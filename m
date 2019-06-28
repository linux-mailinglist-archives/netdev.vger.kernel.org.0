Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8EB6594AE
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfF1HS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:18:28 -0400
Received: from pb-smtp1.pobox.com ([64.147.108.70]:56758 "EHLO
        pb-smtp1.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfF1HS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:18:27 -0400
Received: from pb-smtp1.pobox.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id 9716B15B271;
        Fri, 28 Jun 2019 03:18:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=RqYXy6/tiJNJ
        E8T+ohPnz7lg4ls=; b=FN8QofOuy53TgWJm08+iIvLzrseBMj+ub7b4uBinaYxn
        y6hTo8Tdk8JWo7ZRDjArSz3rBTrV6vZaYxtUDTjg4xIFCSwpuV07H6pcFpsrDxzY
        tbsgfbG15aaQoF2P1GBkkrz1I7+K2gwO7wNr1nzusb/TONfWD3W6XD8WIIqZgKA=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=HugLNt
        NjRsijoTY98SpqiN0xRNaJASV+0xeZmmyZqL9gvspfcd6GzA9BAGyHMNYTqGPkb9
        si4b/gcFeUe5eUaYdMI97zKkrYSs6e66Gz9zvi7ba362Hc9kpTW50TfaEfGtXEzD
        bHwsS1bnNXpEQatGfI3aSRubJy2ZFRISNptm8=
Received: from pb-smtp1.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp1.pobox.com (Postfix) with ESMTP id 7B56F15B270;
        Fri, 28 Jun 2019 03:18:22 -0400 (EDT)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp1.pobox.com (Postfix) with ESMTPSA id 6345615B26F;
        Fri, 28 Jun 2019 03:18:21 -0400 (EDT)
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
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
 <e469daa1-3e28-db9c-e29a-7f68cc676fda@pobox.com>
 <20190627192806.GQ27733@lunn.ch>
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <56d8024e-1e02-7ff7-abf2-261ec9cbabf7@pobox.com>
Date:   Fri, 28 Jun 2019 02:16:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190627192806.GQ27733@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: E93712BA-9974-11E9-9809-46F8B7964D18-06139138!pb-smtp1.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On 6/27/19 2:28 PM, Andrew Lunn wrote:
>>> Looking at the data sheet page, you want FORCE_MODE_Pn set. You never
>>> want the MAC directly talking to the PHY. Bad things will happen.
>> So what exactly do you mean by the MAC directly talking to the PHY?=C2=
=A0 Do
>> you mean setting speed, duplex, etc. via the MAC registers instead of
>> via MDIO to the MII registers of the PHY?
> The data sheet implies the MAC hardware performs reads on the PHY to
> get the status, and then uses that to configure the MAC. This is often
> called PHY polling. The MAC hardware however has no idea what the PHY
> driver is doing. The MAC does not take the PHY mutex. So the PHY
> driver might be doing something at the same time the MAC hardware
> polls the PHY, and it gets odd results. Some PHYs have multiple pages,
> and for example reading the temperature sensor means swapping
> pages. If the MAC hardware was to poll while the sensor is being read,
> it would not get the link status, it would read some random
> temperature register.
>
> So you want the PHY driver to read the results of auto-neg and it then
> tell the MAC the results, so the MAC can be configured correctly.

Thank you, this is very helpful!=C2=A0 I finally understand why these
settings are in two different places. :)=C2=A0 Unfortunately this driver =
(in
OpenWRT) does a lot of "magic" during init to registers that I don't
have documentation for, but I see where auto-polling can be disabled now.

>>> Then use FORCE_RX_FC_Pn and FORCE_TX_Pn to reflect phydev->pause and
>>> phydev->asym_pause.
>>>
>>> The same idea applies when using phylink.
>>>
>>>     Andrew
>> You're help is greatly appreciated here.=C2=A0 Admittedly, I'm also tr=
ying to
>> get this working in the now deprecated swconfig for a 3.18 kernel that=
's
>> in production.
> I'm not very familiar with swconfig. Is there software driving the
> PHY? If not, it is then safe for the MAC hardware to poll the PHY.
>
>      Andrew

swconfig is an netlink-based interface the OpenWRT team developed for
configuring switches before DSA was converted into a vendor-neutral
interface.=C2=A0 Now that DSA does what swconfig was designed for it has =
been
deprecated, although (to my knowledge) we don't yet have DSA for all
devices that OpenWRT supports.

Daniel
