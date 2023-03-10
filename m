Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4566B522D
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjCJUt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjCJUtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:49:22 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0B4E4D88;
        Fri, 10 Mar 2023 12:48:50 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 2A4B2B8B;
        Fri, 10 Mar 2023 21:48:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678481329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAjAj+e/P9Pob2x2vyWB69iAlmQKDC9RdLBVUbu+2Fg=;
        b=kCI1ZMQbkG6GyyMmiyjWndnxEn+vH4/2mmOiyvSz6eHPSPA64ss0Kp22rv5Eds6VSQcuHC
        mqkTF/4Xoc690ER1px4+wzZoxkcbhzLhJsIA7GsBSqymYa5G6NUCk+ffxX2AlK0vcPJUuM
        8MHafHRXP5GdClPS3VsNVeMEOYBDLzPy0mikkRJIaSjRhu00FsUvbkplxp+mEzgkt5X6eJ
        I7LqlZmxC0q/u8aVK2HO0iJS9lpNVZQyKdEOitxpYjquvQ+MALsTN79mdqEEpDZTAc8v8l
        hxgNsjybHRjSLM5XV8YflTL6ipDSlCFld4E+1WZB9tpOoqC91qB0lilVLvvM+A==
MIME-Version: 1.0
Date:   Fri, 10 Mar 2023 21:48:48 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?Q?K=C3=B6ry_Ma?= =?UTF-8?Q?incent?= 
        <kory.maincent@bootlin.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
In-Reply-To: <20230310160648.vwzbyood3rectlr7@skbuf>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-1-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <0d2304a9bc276a0d321629108cf8febd@walle.cc>
 <20230310160648.vwzbyood3rectlr7@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <4e0f6651b9206ff8ef6d25d729d45d24@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-03-10 17:06, schrieb Vladimir Oltean:
> On Fri, Mar 10, 2023 at 02:34:07PM +0100, Michael Walle wrote:
>> Yeah, but my problem right now is, that if this discussion won't find
>> any good solution, the lan8814 phy timestamping will find it's way
>> into an official kernel and then it is really hard to undo things.
>> 
>> So, I'd really prefer to *first* have a discussion how to proceed
>> with the PHY timestamping and then add the lan8814 support, so
>> existing boards don't show a regressions.
> 
> You don't mean LAN8814 but LAN8841, no?

Ohh, I'm stupid. No, I mean the LAN8814 (Quad PHY).

> For the former, PTP support was added in commit ece19502834d ("net: 
> phy:
> micrel: 1588 support for LAN8814 phy") - first present in v5.18.

Yeah and I remember.. there was some kind of issue with the PHY
latencies. Ok, looks like I'm screwed then. I wonder how Microchip
is doing it, because our board is almost an identical copy of the
reference system.

> For the latter, it was commit cafc3662ee3f ("net: micrel: Add PHC
> support for lan8841"), and this one indeed is in the v6.3 release
> candidates.
> 
> Assuming you can prove a regression, how about adding the PHY driver
> whitelist *without* the lan8841 as a patch to net.git? (blaming commit
> cafc3662ee3f ("net: micrel: Add PHC support for lan8841")).
> 
> Doing this will effectively deactivate lan8841 PHY timestamping without
> reverting the code. Then, this PHY timestamping support could be
> activated back in net-next, based on some sort of explicit UAPI call.

Sorry for the noise and any inconvenience,
-michael
