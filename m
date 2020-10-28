Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC9D29E154
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgJ2CAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:00:17 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:33483 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728214AbgJ1Vvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:51:49 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2020 17:51:49 EDT
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 57550FE5;
        Tue, 27 Oct 2020 22:46:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 27 Oct 2020 22:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=9
        kAvLz/bxHGG/V595tWQ2rZ+1UuS5eb7cM1uxdeI31U=; b=nGX+Z5ieR4ZfXzii5
        nUG4GRmGqByBamJCWnFh3FDMq98d0MXPEhmZvhjZU8TPrPZDpZu7OmMV99vEILiX
        BP9GaVs0DOpbTRs4YsSmH+l+47ChCtkxIPufWg3bFrBOR6+WUn3XQA6HdyHaRTiY
        DR6PnfRJOW389vKPuYnWDIVlzA0tkrfOewawsptbQkERMjhy6bdG5VL1+KFOkxBT
        q3n2Zyo2H5yYI0eA9irzS6LrlBCtFJnfiK+nz3qXFXLGtQ8pS6D0yPAvDHijDfHj
        CiJbHWO4O7w9OjPisPnEUYDbU0LL1eqhklH2UsvxPmdtoHA7Sthl5cbf/335Poi/
        +IrQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=9kAvLz/bxHGG/V595tWQ2rZ+1UuS5eb7cM1uxdeI3
        1U=; b=PeW8/sc6fMqRLRgUsQIcXg430dokhLWsq7mjExjWy+6bIehTCGL41p9y4
        tFwSnhA0Ws5VM5B+//fYweLJkTgCt3CfDb/GSUMBa9rIrJ/EQnIeAwqxfaGVffzA
        kK6E8EqGAGAX2/el8a3jBnUVPIAiB5j9ifiIDtGWhn9YS8iDZbQwom0CKTXiT6Uy
        oTKPzoodBxLHIFuBTUHs3rCYGkxrvNq9KFdFR45xk2PaxT2mOqP3ngphPgp3V5KD
        8+HPJ4eTZtG5keSwMjc5DhQJg9ZoMT/jJ15dfMW+KgztICHvEKIeD2vVvbWZNS88
        vcnz3b2QzGJAEaqgZ91V4VN3sRWHg==
X-ME-Sender: <xms:btuYX8XW83qC46a6RIYoHz18NhcrRWtNz4-IdaNn3gFooGXIAPcpBw>
    <xme:btuYXwmMWYhZSLYVxuE8djZ49abKVxkSx48PpLbKHwENhyFjgTEPq7-x8Ydah7GZI
    X2L9PKX3ZrMnBWxHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrledtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefurghmuhgv
    lhcujfholhhlrghnugcuoehsrghmuhgvlhesshhhohhllhgrnhgurdhorhhgqeenucggtf
    frrghtthgvrhhnpefgveffteelheffjeeukedvkedviedtheevgeefkeehueeiieeuteeu
    gfettdeggeenucfkphepjedtrddufeehrddugeekrdduhedunecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepshgrmhhuvghlsehshhholhhlrghn
    ugdrohhrgh
X-ME-Proxy: <xmx:btuYXwYOnV8bH050x_9BLK8kdgMUtz21twVv9YmTiCZE1i7Ski2jxA>
    <xmx:btuYX7XI4zYYY8lSM_geqhOmPqwYBOZlcizhogEcDQsFnQ1UjeI9Qg>
    <xmx:btuYX2nXbj6tFXFrb4CZJ81WrrfJW86N1xNUWm4gls3TuW7bX8VYNQ>
    <xmx:b9uYX7iAgKbpdH_LPd23xCE4XFE6Cjk77p9w_E7T0DoBr39vijSeNlHh77Y>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id 883293280063;
        Tue, 27 Oct 2020 22:46:05 -0400 (EDT)
Subject: Re: [linux-sunxi] Re: [PATCH] net: phy: realtek: omit setting
 PHY-side delay when "rgmii" specified
To:     Icenowy Zheng <icenowy@aosc.io>
Cc:     andrew@lunn.ch, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sunxi@googlegroups.com
References: <20201025085556.2861021-1-icenowy@aosc.io>
 <20201025141825.GB792004@lunn.ch>
 <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io>
 <20201025143608.GD792004@lunn.ch>
 <F5D81295-B4CD-4B80-846A-39503B70E765@aosc.io>
 <20201025172848.GI792004@lunn.ch>
 <C3279C11-EE7F-49FA-9BB3-ACA797B7B690@aosc.io>
 <20201026121257.GB836546@lunn.ch>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <6f75be3f-90d7-982e-0f43-e742f04bb26e@sholland.org>
Date:   Tue, 27 Oct 2020 21:46:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201026121257.GB836546@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Icenowy,

On 10/26/20 7:12 AM, Andrew Lunn wrote:
>> By referring to linux/phy.h, NA means not applicable. This surely
>> do not apply when RGMII is really in use.
> 
> It means the PHY driver should not touch the mode, something else has
> set it up. That could be strapping, the bootloader, ACPI firmware,
> whatever.
> 
>> I think no document declares RGMII must have all internal delays
>> of the PHY explicitly disabled. It just says RGMII.
> 
> Please take a look at all the other PHY drivers. They should all
> disable delays when passed PHY_INTERFACE_MODE_RGMII.

Documentation/networking/phy.rst also makes this clear:

PHY_INTERFACE_MODE_RGMII: the PHY is not responsible for inserting any internal
delay by itself, it assumes that either the Ethernet MAC (if capable or the PCB
traces) insert the correct 1.5-2ns delay

Regards,
Samuel
