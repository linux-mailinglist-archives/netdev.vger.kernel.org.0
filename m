Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9B758AC8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfF0TK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:10:59 -0400
Received: from pb-smtp1.pobox.com ([64.147.108.70]:64379 "EHLO
        pb-smtp1.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0TK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:10:59 -0400
Received: from pb-smtp1.pobox.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id A2AED157CAE;
        Thu, 27 Jun 2019 15:10:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=wb9ITU4KH88C
        r4Wml648++v4DXU=; b=Rot878kMWE5XjbhBSU7QDKCIAgG6d5RBTIH120Iog9Qw
        W3R3fzUiv4n3/zZ109X4lpqnVdfsaMS/GrtVF0iReaVTkMGAK9o3SRJIadNVJL9S
        5oylDOK6A19ikEt42myiaeTth2AaddFoTrHy6Hcm3f+SGMyqne4grOqqQ6Mnzsk=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=MiZNDA
        sR3PuH0LmolzMmwuXjTO7B9N7vuwsFLVSrnQphaPw01ZlzDxOzBqeDXps+Q21ULx
        n5vMeeRFDHmTPapRI5niUMMdrV/n64vEE0FLpEJg07tyqMsA/bUisWUBxMadVd92
        VE3cd3TV+GkBoWS/9o4SxmIEQoWnVtARdm4Xo=
Received: from pb-smtp1.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id 98848157CAD;
        Thu, 27 Jun 2019 15:10:55 -0400 (EDT)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp1.pobox.com (Postfix) with ESMTPSA id 6957B157CAC;
        Thu, 27 Jun 2019 15:10:53 -0400 (EDT)
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
 <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
 <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
 <20190625190246.GA27733@lunn.ch>
 <4fc51dc4-0eec-30d7-86d1-3404819cf6fe@pobox.com>
 <20190625204148.GB27733@lunn.ch>
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <e469daa1-3e28-db9c-e29a-7f68cc676fda@pobox.com>
Date:   Thu, 27 Jun 2019 14:09:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190625204148.GB27733@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 49051B76-990F-11E9-8B0D-46F8B7964D18-06139138!pb-smtp1.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/19 3:41 PM, Andrew Lunn wrote:
> On Tue, Jun 25, 2019 at 02:27:55PM -0500, Daniel Santos wrote:
>> On 6/25/19 2:02 PM, Andrew Lunn wrote:
>>>> But will there still be a mechanism to ignore link partner's adverti=
sing
>>>> and force these parameters?
>>> >From man 1 ethtool:
>>>
>>>        -a --show-pause
>>>               Queries the specified Ethernet device for pause paramet=
er information.
>>>
>>>        -A --pause
>>>               Changes the pause parameters of the specified Ethernet =
device.
>>>
>>>            autoneg on|off
>>>                   Specifies whether pause autonegotiation should be e=
nabled.
>>>
>>>            rx on|off
>>>                   Specifies whether RX pause should be enabled.
>>>
>>>            tx on|off
>>>                   Specifies whether TX pause should be enabled.
>>>
>>> You need to check the driver to see if it actually implements this
>>> ethtool call, but that is how it should be configured.
>>>
>>> 	Andrew
>>>
>> Thank you Andrew,
>>
>> So in this context, my question is the difference between "enabling" a=
nd
>> "forcing".=C2=A0 Here's that register for the mt7620 (which has an mt7=
530 on
>> its die): https://imgur.com/a/pTk0668=C2=A0 I believe this is also wha=
t Ren=C3=A9
>> is seeking clarity on?
> Lets start with normal operation. If the MAC supports pause or asym
> pause, it calls phy_support_sym_pause() or phy_support_asym_pause().
> phylib will then configure the PHY to advertise pause as appropriate.
> Once auto-neg has completed, the results of the negotiation are set in
> phydev. So phdev->pause and phydev->asym_pause. The MAC callback is
> then used to tell the MAC about the autoneg results. The MAC should be
> programmed using the values in phdev->pause and phydev->asym_pause.
>
> For ethtool, the MAC driver needs to implement .get_pauseparam and
> .set_pauseparam. The set_pauseparam needs to validate the settings,
> using phy_validate_pause(). If valid, phy_set_asym_pause() is used to
> tell the PHY about the new configuration. This will trigger a new
> auto-neg if auto-neg is enabled, and the results will be passed back
> in the usual way. If auto-neg is disabled, or pause auto-neg is
> disabled, the MAC should configure pause directly based on the
> settings passed.
>
> Looking at the data sheet page, you want FORCE_MODE_Pn set. You never
> want the MAC directly talking to the PHY. Bad things will happen.

So what exactly do you mean by the MAC directly talking to the PHY?=C2=A0=
 Do
you mean setting speed, duplex, etc. via the MAC registers instead of
via MDIO to the MII registers of the PHY?

> Then use FORCE_RX_FC_Pn and FORCE_TX_Pn to reflect phydev->pause and
> phydev->asym_pause.
>
> The same idea applies when using phylink.
>
>     Andrew

You're help is greatly appreciated here.=C2=A0 Admittedly, I'm also tryin=
g to
get this working in the now deprecated swconfig for a 3.18 kernel that's
in production.=C2=A0 In my code, I had just set the appropriate bits in b=
oth
the MAC and mii registers -- did I just shoot myself in the foot or only
toe or two? :)=C2=A0 I should probably start a separate thread for this.=C2=
=A0
(And probably attempt to wrestle an mt7530 programmer's guide out of
MediaTek!)

Thanks,
Daniel

PS: I found a rather humorous quote from the mt7621 datasheet regarding
the MAC registers (at 0x3000 for port 0, 0x3100 for port 1, etc.):

    2.4 Link Status

    You can find MAC control register put at 0x3500 for MAC 5, and
    0x3600 for MAC 6. You can change
    MAC ability at this register. We would suggest don=E2=80=99t use the
    register 0x3000 to 0x3400. It may not
    work.

I'm not sure if this only applies to something in between the mt7621 and
it's internal mt7530 or not.
