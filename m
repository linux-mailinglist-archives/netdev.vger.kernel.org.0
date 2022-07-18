Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC48057854A
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 16:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiGROZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 10:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiGROZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 10:25:16 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45852CE13;
        Mon, 18 Jul 2022 07:25:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id b11so21506004eju.10;
        Mon, 18 Jul 2022 07:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7DdDsGhXcK90ynwzFc8Ey8lHFszMXZo5aRKhgEZd4uk=;
        b=OSVrgaaNfVM1U1imz3NejJXJRKz2xnHXN89Q1+rhR4nVNvKS6NKENr+a8Db+Q2mXH2
         J+FoL4gCap1b57EoOBvhTiIkeeq7ZsujMYcqI/4/DRyNBnNzKWPWnA9CDqU2qnW4EsV6
         nlDTskI7uy8IzD+jMRyUVWzkMH6kwmcfZQYW1t0v86bfCXCGgXn/GbHifkMcxAHXTwz1
         K4AVARbCPWWWv1f+b1j3maj3KcGBHgMajQPOtsgGOCmhvQtN/0vFLdmoj9OlJCEgP/oO
         315WJu8lb+uJleeExJzqKdNiGovqS7hN4Zj+etVfb+4v0yzMUKh3D08mAZLlx0wTQ1Cy
         zgMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7DdDsGhXcK90ynwzFc8Ey8lHFszMXZo5aRKhgEZd4uk=;
        b=EgENnTlflzXLjLnvMWQoSKHoEvWuoHCbNbzvXwvJLPee/lHmq2Jm/sfJN+dA+wyBxh
         hKeAXbKbzvwMdrEEkoZVfeYW87NaL5FO+xRPIEnIhwLZfP3v/Sx3nCqZgG2512B9RhUG
         gnbjaLvSCwqK3SxEEBjnraLRWTXQq9yFcAxC2d1ZvD9AksrR++jrvRGegwkVO+MLy1IV
         0x9mXovFBrIQ/Ym06G5PO+MIZhJP/a/Pc14bxgD9Gg/H2GT6XezbUUXC74a47K7wJ9R/
         Q39LZq9/5OqkIs4lCK0LWV0eBe6sX7vlZ/qIaFXArHy8p9kh3D+Ey45MWFi6vPPhf9H/
         mb2g==
X-Gm-Message-State: AJIora+s9JszCw9P31H8NSgPAYGhgFvPe2ZLz6jT4wZ+NVz7qUGgBMgT
        e4BdRhzqM6v7y9uOGMtTPmw=
X-Google-Smtp-Source: AGRyM1sEheIFNl3MBseKFin6lSWB6ACjtHJGFOFj4+AFpV+dz3UFgxQDHhyuosVn1sXr8b6XrmMijw==
X-Received: by 2002:a17:906:ef8b:b0:72b:58da:b115 with SMTP id ze11-20020a170906ef8b00b0072b58dab115mr24890310ejb.417.1658154309632;
        Mon, 18 Jul 2022 07:25:09 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id u7-20020a056402110700b0043a6c9e50f4sm8606780edv.29.2022.07.18.07.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 07:25:08 -0700 (PDT)
Date:   Mon, 18 Jul 2022 17:25:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 0/6] net: dsa: always use phylink
Message-ID: <20220718142505.3shv2rwe4fakgsp2@skbuf>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <20220715171719.niqcrklpk4ittfvl@skbuf>
 <YtHVLGR0RQ6dWuBS@shell.armlinux.org.uk>
 <20220715160359.2e9dabfe@kernel.org>
 <20220716111551.64rjruz4q4g5uzee@skbuf>
 <YtKkRLD74tqoeBuR@shell.armlinux.org.uk>
 <20220716131345.b2jas3rucsifli7g@skbuf>
 <YtUfg+WYIYYi5J+q@shell.armlinux.org.uk>
 <20220718124512.o3qxiwop7nzfjbfx@skbuf>
 <YtVZ6VI1yvbgSYDg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtVZ6VI1yvbgSYDg@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:02:33PM +0100, Russell King (Oracle) wrote:
> In the second RFC, I stated:
> 
> "Some of the questions from the original RFC remain though, so I've
> included that text below. I'm guessing as they remain unanswered that
> no one has any opinions on them?"
> 
> Clearly, I was soliciting answers from _everyone_ who received this,
> not just the two people in the To: header.
(...)
> This is _not_ the issue I'm raising. I am complaining about the
> "default_interface" issue that you've only piped up about, despite
> (a) an explicit question having been asked about that approach, (b) it
> appearing in not just one, not two, not three but four RFC series sent,
> and only finally being raised when a non-RFC series was sent.
> 
> This whole debarcle could have been avoided with providing feedback at
> an earlier stage, when I explicitly requested it _several_ times.

Please stop shoving quotes of your questions in my face, I'm still glad
I deleted my draft responses to them when they were originally asked,
because *when* (not *if*) things will have went sideways, I would have
blamed myself for people wanting to test/respond but not having whom to
talk to, because you rage quit.

You need to understand that a voluntary reviewer doesn't have a duty to
respond to you on any certain date, and that I'm not obliged to shut up
about where to place "default_interface" because I haven't said anything
about it in the first N series. I was on the fence whether it was even
worth saying anything about it at all, and the only reason I decided to
do it was because the patch to change every DSA driver's phylink_get_caps()
prototype now conflicts with concurrent changes done to drivers, and
doesn't apply to net-next anyway:
https://patchwork.kernel.org/project/netdevbpf/patch/E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk/
So I really can't be reasonably accused of wanting to stall this series.

You have no reason whatsoever to pick a fight with me, so please stop it.
