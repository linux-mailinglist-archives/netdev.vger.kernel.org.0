Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8806B629449
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiKOJ3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKOJ3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:29:32 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14737BC26;
        Tue, 15 Nov 2022 01:29:30 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BA77A1BF205;
        Tue, 15 Nov 2022 09:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668504569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZzaCUVqgu6mLezJNdaf9hoUrWcdXw3DoAzvtlQBAKeQ=;
        b=aaPtb1oqHYVfOd92rUhN0mfRqGQ1qVa3CRwZUYCUC6Le+grUEPUTvdV6f/PLBnE4YN7C+F
        WiOYm+yhAXMLd7CDfzecO1Mhttx52JlQC+K/vsEXOIgVdD8s45yI49KuBAyYV/NTGypt1D
        js+hVHFIHXh8cx3HHgw2cQrD6dQ0uOaoilX1dBaMmXhKpbTfe+Z093sr8CqT/EiOkLfW3G
        j/T1S0NOogy0YF9yZQYzXWts2jKRqea6lCO7qIGH4iR7FD4/XyQmXovLrUYMcRBqRAa9eo
        MDlUJf7Ir4cQekCdhYA0IA9P4D+O9EFAzerbE980Hq9GsVXqxH96mGlJR4SQnA==
Date:   Tue, 15 Nov 2022 10:29:24 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20221115102924.1329b49f@pc-7.home>
In-Reply-To: <6b38ec27-65a3-c973-c5e1-a25bbe4f6104@nbd.name>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
        <20221104174151.439008-4-maxime.chevallier@bootlin.com>
        <20221104200530.3bbe18c6@kernel.org>
        <20221107093950.74de3fa1@pc-8.home>
        <6b38ec27-65a3-c973-c5e1-a25bbe4f6104@nbd.name>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

Felix, thanks for the feedback !

On Tue, 8 Nov 2022 13:22:17 +0100
Felix Fietkau <nbd@nbd.name> wrote:

[...]

> FYI, I'm currently working on hardware DSA untagging on the mediatek
> mtk_eth_soc driver. On this hardware, I definitely need to keep the
> custom DSA tag driver, as hardware untagging is not always available.
> For the receive side, I came up with this patch (still untested) for
> using METADATA_HW_PORT_MUX.
> It has the advantage of being able to skip the tag protocol rcv ops
> call for offload-enabled packets.
> 
> Maybe for the transmit side we could have some kind of netdev feature
> or capability that indicates offload support and allows skipping the
> tag xmit function as well.
> In that case, ipqess could simply use a no-op tag driver.

If I'm not mistaken, Florian also proposed a while ago an offload
mechanism for taggin/untagging :

https://lore.kernel.org/lkml/1438322920.20182.144.camel@edumazet-glaptop2.roam.corp.google.com/T/

It uses some of the points you're mentionning, such as the netdev
feature :)

All in all, I'm still a bit confused about the next steps. If I can
summarize a bit, we have a lot of approaches, all with advantages and
inconvenients, I'll try to summarize the state :

 - We could simply use the skb extensions as-is, rename the tagger
   something like "DSA_TAG_IPQDMA" and consider this a way to perform
   tagging on this specific class of hardware, without trying too hard
   to make it generic.

 - We could try to move forward with this mechanism of offloading
   tagging and untagging from the MAC driver, this would address
   Florian's first try at this, Felix's use-case and would fit well the
   IPQESS case

 - There's the option discussed by Vlad and Jakub to add several
   frontends, one being a switchev driver, here I'm a bit lost TBH, if
   we go this way I could definitely use a few pointers from Vlad :)

When looking at it from this point of view, option 2 looks pretty
promising, but I would like to make sure we're on the same page at that
point. On my side, I've tried several approaches for this tagging and
so far none are acceptable, for good reasons. I would like to make sure
then that I grasp the full picture and I didn't miss other possible
ways of addressing this.

Thanks everyone for your help !

Maxime
