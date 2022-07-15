Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730775765DC
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbiGORR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiGORR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:17:26 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227C945980;
        Fri, 15 Jul 2022 10:17:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id j22so10119046ejs.2;
        Fri, 15 Jul 2022 10:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s2m65ed+VKU46wmwzODUfX9pQpnIOrJsSOXJsW+RL10=;
        b=l1dAKUUNH4z2PgburywrqoWlN4/1D2KO9fjGmRU/AzfzM+TZ37w05bSUN3k57gPspR
         O2aQUy0qwEmJiehFBpqQDNf5fDR0RITWMoSNoY9Rzj2uIfqt5243k3bIAYHZ96q/QbT1
         kOiCN/q/4n8dbGCQQlxXdlj9xfP5ba/CFNr03tTeVLAc4qQibW8EXPe+aAYSJ5ZRR6gC
         EcfJ9MnQ3Q7y/up8ohgUId6dheBfbvouEyHIhUzvnzK4r76ns5eLlQ1cKC+ujuYDzyLz
         BfdQKmbRvr1Dt6+s+VAMMdG0uYQc/axGtfxjRoCi/W7qOYhJ2I48PkcgphSnUdNZwwxy
         skxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s2m65ed+VKU46wmwzODUfX9pQpnIOrJsSOXJsW+RL10=;
        b=nFDmZ8jwfm5m2BHscOaoQdPTtrLHZIHdA80FlVeeOtaDOXFHzCA658ocByIKGWXIID
         lUkrieu0M7xVjlig1jRmgn1Wi+nDm5j7geR88vRpLRRAueww3rfK2FxjQbSZQT3Cv3Lr
         9jgNqQ+GpjFJffaN19gEkM6iOfJVKeOD7/4VVZeE6YN8rDdJySc+m1/8Y16hkbd9rPkN
         YcXN5wisopGWEaL9IslUit8tvChTaR7jgAeiBOK+eklOXy1QTqMR9xj8GXONnk+lzY4x
         NMBwdnPdObalejUol74x5Wb2Tv8R2iLbbFBr03fJ/8CRlcW9KmP6vJBMXs6zUwHoCxN+
         DVZA==
X-Gm-Message-State: AJIora/iozb02lKwGfzKfctzyl3a8ilL537vxY7tm1RF5Psff9BT+EI2
        Cvc7Lvrn6WfAgia+UFmjh0c=
X-Google-Smtp-Source: AGRyM1sAWG7bL6CZyLOwnctXoLSDpqKUPYhVVJyLTDZ+mgM4ARRC7PcjVMARHOHBRrF5407oHABQXg==
X-Received: by 2002:a17:907:60c7:b0:72e:d01f:b884 with SMTP id hv7-20020a17090760c700b0072ed01fb884mr11047319ejc.550.1657905443553;
        Fri, 15 Jul 2022 10:17:23 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640210cd00b00435a62d35b5sm3153113edu.45.2022.07.15.10.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 10:17:22 -0700 (PDT)
Date:   Fri, 15 Jul 2022 20:17:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        Marek =?utf-8?B?PT9pc28tODg1OS0xP1E/QmVoPUZBbj89?= 
        <kabel@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220715171719.niqcrklpk4ittfvl@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Fri, Jul 15, 2022 at 05:00:59PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> This is a re-hash of the previous RFC series, this time using the
> suggestion from Vladimir to create a swnode based fixed-link
> specifier.
> 
> Most of the changes are to DSA and phylink code from the previous
> series. I've tested on my Clearfog (which has just one Marvell DSA
> switch) and it works there - also tested without the fixed-link
> specified in DT.

I had some comments I wanted to leave on the previous RFC patch set
(which in turn is essentially identical to this one, hence they still
apply), but I held off because I thought you were waiting for some
feedback from Andrew. Has something changed?

I'm going to leave my comments anyway now.
