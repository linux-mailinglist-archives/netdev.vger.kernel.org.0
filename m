Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD3557C3
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfFYT3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:29:31 -0400
Received: from pb-smtp2.pobox.com ([64.147.108.71]:51598 "EHLO
        pb-smtp2.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfFYT3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:29:31 -0400
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id E9D101651F3;
        Tue, 25 Jun 2019 15:29:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=+my+WhMrqgL7
        VR0icxCDR+v6790=; b=Okhw9DsdsSF+A7KnE0gT4xNPJpB+Ef7ciXACW0AqCr78
        VFAcZ5z82fVq22G1zAYN8L+FX7NKriz9zXaaUQhVnV7nNuOVmwqvL2pm6Lf9vl/7
        wR4DS/aymvYjyMSRGlG3g9Q2VoOVBiB2r/AjUfIZEyF2XEElYnTcyWZs3Lmewek=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=UE5HAG
        /vO0Us3y4KwokGWFFNo4p5bvlyiSJqddSzuVMn30vMsoXEJxjDcMWOsE27kwWN2S
        cn2dl49gFtiFez+FnjyAUImA3SQe/SewgqE1wYj357FsVp1j93XZyXII2mwM1ptu
        zB77Emw2nAz/57G8A3MmRv4FXvGiwkvJl3M48=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id DEA841651F2;
        Tue, 25 Jun 2019 15:29:28 -0400 (EDT)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id EC6761651F1;
        Tue, 25 Jun 2019 15:29:27 -0400 (EDT)
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
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <4fc51dc4-0eec-30d7-86d1-3404819cf6fe@pobox.com>
Date:   Tue, 25 Jun 2019 14:27:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190625190246.GA27733@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 8C7CBB52-977F-11E9-BFB1-72EEE64BB12D-06139138!pb-smtp2.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 2:02 PM, Andrew Lunn wrote:
>> But will there still be a mechanism to ignore link partner's advertisi=
ng
>> and force these parameters?
> >From man 1 ethtool:
>
>        -a --show-pause
>               Queries the specified Ethernet device for pause parameter=
 information.
>
>        -A --pause
>               Changes the pause parameters of the specified Ethernet de=
vice.
>
>            autoneg on|off
>                   Specifies whether pause autonegotiation should be ena=
bled.
>
>            rx on|off
>                   Specifies whether RX pause should be enabled.
>
>            tx on|off
>                   Specifies whether TX pause should be enabled.
>
> You need to check the driver to see if it actually implements this
> ethtool call, but that is how it should be configured.
>
> 	Andrew
>
Thank you Andrew,

So in this context, my question is the difference between "enabling" and
"forcing".=C2=A0 Here's that register for the mt7620 (which has an mt7530=
 on
its die): https://imgur.com/a/pTk0668=C2=A0 I believe this is also what R=
en=C3=A9
is seeking clarity on?

Thanks,
Daniel
