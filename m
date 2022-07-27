Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA4D05827D6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiG0Nic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiG0Nia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:38:30 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E1519029;
        Wed, 27 Jul 2022 06:38:29 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z22so21421362edd.6;
        Wed, 27 Jul 2022 06:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=N+Kho1tTDYMy+feUtLoUrIepxnc5e58P8cS7A/7gF+U=;
        b=qxLOalOnGgYaNSBiFh7kG611YZYBypvahjLD7H1hwxpmxyssGZ1k2CisnikXq7XsLG
         N41BKOmt4wK76lryxMWoSpzMK9BIrvFX6nrrtTzZw2RXKMbsilE6/ilIrKSMVCsl1tAQ
         FULDxEcIGAbvZhrcbK3bBczD45KB0mtMiun56LjdTtQkFdFX1fzK+J3AI9a1NQmpszvm
         3WsI4DSQ+t9EU7CL2uEUHduuk8Bh8uo5GUXNKE6CSKxrbTivW2tZHoJ9FRPYFH3Uv86b
         SIdJY6L+UQegZ4uyqiqNtGPsd7ovg44+S/QfRCqOkLDhmznl/9GZu21QGsaGbTOO33Jm
         OFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=N+Kho1tTDYMy+feUtLoUrIepxnc5e58P8cS7A/7gF+U=;
        b=vQpSgDBrxCPBWn+DJ0KCHze18myczUDDEIJy0VMM/DsDld8BOq81txzaHo+4rnGXXM
         gbadsSMkXapkMzByuHriJtP28p+R6lI7VfbFVEw70zgpkWHXY15ehcSTyOmyO08ZIqGA
         iuku+SYAL6wSF0x5lwH+bcUQHnHgUHRjf31zJZVAzrNTiQgyQ+8Y2dxFnYTRfC8J8BE1
         mGqU5gvpPC/pCVWs/6DdlLCgaH3tuUoELckoolKyfDgMiA6awkBaDsiG5wTsOIkkKQF3
         FamU4th5gZH5356rR8R+If97X91CZcfeW174x8wfMJyW04qq+loPspAqZDiUNbmJjSh7
         eTYQ==
X-Gm-Message-State: AJIora/fi1YCHjH62td51+0XF2tZV3pRV4I0l2GxuuNpDfHQPlg/oSHl
        12//Wpo8a5CFIG5gI3A3Kp0=
X-Google-Smtp-Source: AGRyM1tZdX7DcKsI0OH23LMM8bUt8j1r6SKxeLv0A5Vc723Jp1Ef5b9L3U3LBQ7vPjvnF4yyq0Tmdw==
X-Received: by 2002:a05:6402:3282:b0:43b:e650:4352 with SMTP id f2-20020a056402328200b0043be6504352mr18381276eda.376.1658929108106;
        Wed, 27 Jul 2022 06:38:28 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id g21-20020aa7c855000000b0043bd753174esm7940248edt.27.2022.07.27.06.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 06:38:27 -0700 (PDT)
Date:   Wed, 27 Jul 2022 16:38:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220727133824.ymedhfhrggietmpj@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220727110051.2df82bf6@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220727110051.2df82bf6@dellmb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marek,

On Wed, Jul 27, 2022 at 11:00:51AM +0200, Marek Behún wrote:
> Dear Vladimir,
> 
> am I understanding correctly that your main objection to this series is
> that it may break other drivers?

Yes, but I'm not saying this in a way that tries to make it impossible
to make progress. But rather, I've identified 8 drivers which may lack
complete device tree descriptions:
https://patchwork.kernel.org/project/netdevbpf/patch/20220723164635.1621911-1-vladimir.oltean@nxp.com/

Simply put, I have no indication that the changes presented here are a
step in the right direction for the remaining 7 drivers. Each and every
single one of them needs to be studied and discussed separately; the
discussion has already started for some.

> Do you think it would be okay if I changed it so that only mv88e6xxx
> driver would ask for phylink for CPU/DSA ports?

It would be a good start, yes. What I could do is I could move my
validation logic from the patch linked above into dsa_port_link_register_of().
Running that logic would let DSA know which properties are missing.
Then, for drivers that don't enforce validation, we could add new
dsa_switch_ops that separately ask the driver what phy-mode to use
(if missing) and what speed/duplex to use (if missing). Drivers can use
whatever heuristic is appropriate for their deployments to respond to this.
If the phy-mode and speed/duplex are finally resolved, DSA can create a
software_node and register with phylink that way. Otherwise, DSA will
continue to do what it does today, i.e. skip phylink registration.

How does that sound?
