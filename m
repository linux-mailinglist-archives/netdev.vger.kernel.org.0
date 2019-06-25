Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5C95574E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbfFYSjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:39:10 -0400
Received: from pb-smtp2.pobox.com ([64.147.108.71]:65208 "EHLO
        pb-smtp2.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729912AbfFYSjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:39:10 -0400
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id 6BC52164DDB;
        Tue, 25 Jun 2019 14:39:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; s=sasl; bh=omq51xRrnfan
        iedV32HSyjTCy18=; b=EZksBo/Eej8QoKcgshBdiD7LYecHUJ60sex+tuf1Jmy3
        viEd+v+hFFq8U3pT7n+xLbbORIHzrQOCQd1LgidVxcHsSgHvgERxGlUfHf9OJFB+
        WH37f4KpE1WOvFrRSeSlSjyEqzkz3udaphDj/JeEsD5OB0v0iclJmvnGoZYe/Sk=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:to:cc
        :references:from:message-id:date:mime-version:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=sasl; b=QL1BYc
        6HR0WUHE68tEIwsYQk903c0dGGvSSnfkUF+rn14whbLLF7PfANsaLW0K5RjS1wn4
        nIP0Y19Max3J03fCAv16tkOvavO3Q1/3I021Zky+ZrabY/tAQCYgfo1seaQyIO68
        xaUiOU5Szc3zfXVHPnLwUGtxDdQ+bbxgZCBgM=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id 61B27164DDA;
        Tue, 25 Jun 2019 14:39:05 -0400 (EDT)
Received: from [192.168.1.134] (unknown [70.142.57.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id 51C72164DD9;
        Tue, 25 Jun 2019 14:39:04 -0400 (EDT)
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: mt7530: Convert to PHYLINK API
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>
Cc:     sean.wang@mediatek.com, f.fainelli@gmail.com, davem@davemloft.net,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
References: <20190624145251.4849-1-opensource@vdorst.com>
 <20190624145251.4849-2-opensource@vdorst.com>
 <20190624153950.hdsuhrvfd77heyor@shell.armlinux.org.uk>
 <20190625113158.Horde.pCaJOVUsgyhYLd5Diz5EZKI@www.vdorst.com>
 <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
From:   Daniel Santos <daniel.santos@pobox.com>
Message-ID: <1ad9f9a5-8f39-40bd-94bb-6b700f30c4ba@pobox.com>
Date:   Tue, 25 Jun 2019 13:37:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190625121030.m5w7wi3rpezhfgyo@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 8248C57E-9778-11E9-9FC4-72EEE64BB12D-06139138!pb-smtp2.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Although I'm new to the entire Ethernet / *MII subsystem and I haven't
touched DSA yet, I've recently had to add some of this functionality to
the older OpenWRT drivers for swconfig control over the ports.=C2=A0 Ren=C3=
=A9, do
you have an actual datasheet or programming guide for the mt7530?=C2=A0 I
only have one for the mt7620.


On 6/25/19 7:10 AM, Russell King - ARM Linux admin wrote:
> mac_link_*().
>
>>>> +            if (state->pause || phylink_test(state->advertising, Pa=
use))
>>>> +                    mcr |=3D PMCR_TX_FC_EN | PMCR_RX_FC_EN;
>>>> +            if (state->pause & MLO_PAUSE_TX)
>>>> +                    mcr |=3D PMCR_TX_FC_EN;
>>>> +            if (state->pause & MLO_PAUSE_RX)
>>>> +                    mcr |=3D PMCR_RX_FC_EN;
>>> This is clearly wrong - if any bit in state->pause is set, then we
>>> end up with both PMCR_TX_FC_EN | PMCR_RX_FC_EN set.  If we have Pause
>>> Pause set in the advertising mask, then both are set.  This doesn't
>>> seem right - are these bits setting the advertisement, or are they
>>> telling the MAC to use flow control?
>> Last one, tell the MAC to use flow control.
> So the first if() statement is incorrect, and should be removed
> entirely.  You only want to enable the MAC to use flow control as a
> result of the negotiation results.

Ren=C3=A9,
iiuc, this is what's documented in table 28B-3 of the 802.3 spec on page
598.=C2=A0 pdf of section 2 here:
http://www.ismlab.usf.edu/dcom/Ch3_802.3-2005_section2.pdf

>> On the current driver both bits are set in a forced-link situation.
>>
>> If we always forces the MAC mode I think I always set these bits and d=
on't
>> anything with the Pause modes? Is that the right way to do it?
> So what happens if your link partner (e.g. switch) does not support
> flow control?  What if your link partner floods such frames to all
> ports?  You end up transmitting flow control frames, which could be
> sent to all stations on the network... seems not a good idea.
>
> Implementing stuff properly and not taking short-cuts is always a
> good idea for inter-operability.

But will there still be a mechanism to ignore link partner's advertising
and force these parameters?=C2=A0 I've run into what appears to be quirks=
 on
two separate NICs or their drivers, a tp-link tg-3468 (r8169) and an
Aquantia AQC107 802.3bz (atlantic) where these link partners aren't
auto-negotiating correctly after I switch the mt7530 out of
auto-negotiation mode.=C2=A0 Of course, it could be a mistake I've made (=
and
should thus be discussed elsewhere), but iirc, I had to force enable
flow control and then also disable auto-negotiation on the link partner
and force the mode I wanted.

Cheers,
Daniel
