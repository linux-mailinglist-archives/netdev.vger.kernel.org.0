Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCFB463F77D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiLASbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiLASbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:31:47 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E58A430E;
        Thu,  1 Dec 2022 10:31:46 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id w15so4157334wrl.9;
        Thu, 01 Dec 2022 10:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hObqbw9hHcLQ8nyKJ+uZcCd4sfmbwCwcvHP4La3EFGU=;
        b=eSTYTGx7/LQserb2caN1EUOHlw9gvDC/AXZJE/iui7upbn7AlY6+YkOcpThjquf+jF
         SIX5RzfWiDWgxo1Kk3UCv3myuJjehbADlGddNrclKnD8BauQW4aA6YJ0+V8mDamDbgmE
         tqabs0Vy4q/bnhcmO4ucdmQIPeorl/H8/Paq5ruWL4HPFkKpo48VNSDYV6NqQ6TFpPJw
         FyTfCGYSR7AibFJJK2VClFUSXJFE9jDPrDQhtrMGqtA4eF1mOC4jGL72lf2FrrxvmkRz
         +Sj/V4MSgtdccOjz6fF6t/LWVJK2exD800NBATYigQbSxORYwZsUwyFHIN1HpwBxJb8P
         9Uzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hObqbw9hHcLQ8nyKJ+uZcCd4sfmbwCwcvHP4La3EFGU=;
        b=bqWqOmvgz8Q38ewPG4NmzbPWa3vWpuh80l9nz8y8m5GsI7d457GiFnNzOUEqMRq+fU
         IDTkhDjsQmvyxOuranA183OdmohBYtOUROtQ4rrtuJutzOwlukKyvGk6CV00+DDdVfZ8
         l+t50sHQ51XaEOc9OXEvNdjjk+PyjJEQ+/taDWusiEIwzGqdtX4qeDROkT5O4y3fa8lm
         GiSrheDBaAVlsUTjdeSv0Lfc2HLtKGVr/VzKwiYydxhVCMJLmZNFj92Y5HGSpB8v2nXf
         UxkRlCM/S/FDGY2DGRPAHpvgcW4dxv/g+jFjR9gbj03hiZ8h8BdTueLXZL7D4a8DPbOE
         1zAA==
X-Gm-Message-State: ANoB5pkKxkwbH15rvSwpNaTdxN8NvNQzr0xnq9mFy+9k2bbCxPaChZB/
        4XCkUN0wExT4Bj0CoyHgpbouwQ2SR+s=
X-Google-Smtp-Source: AA0mqf4TfiUTBr+8oy0zyryOajQGCmMfgzN29Zq2q3OBJinn+jx7GDmEc0ToaPWD6fXcLfqrL2DsKw==
X-Received: by 2002:a05:6000:886:b0:241:b933:34a1 with SMTP id ca6-20020a056000088600b00241b93334a1mr32160178wrb.550.1669919504471;
        Thu, 01 Dec 2022 10:31:44 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.gmail.com with ESMTPSA id bg28-20020a05600c3c9c00b003cfa3a12660sm9914617wmb.1.2022.12.01.10.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 10:31:44 -0800 (PST)
Message-ID: <6388f310.050a0220.532be.7cd5@mx.google.com>
X-Google-Original-Message-ID: <Y4jzEDL2iTgTaxNT@Ansuel-xps.>
Date:   Thu, 1 Dec 2022 19:31:44 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <Y3bRX1N0Rp7EDJkS@lunn.ch>
 <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
 <Y3eEiyUn6DDeUZmg@lunn.ch>
 <CAJ+vNU2pAQh6KKiX5x7hFuVpN68NZjhnzwFLRAzS9YZ8bWm1KA@mail.gmail.com>
 <Y3q5t+1M5A0+FQ0M@lunn.ch>
 <CAJ+vNU0yjsJjQLWbtZmswQOyQ6At-Qib8WCcVcSgtDmcFQ3hGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU0yjsJjQLWbtZmswQOyQ6At-Qib8WCcVcSgtDmcFQ3hGQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 10:26:09AM -0800, Tim Harvey wrote:
> On Sun, Nov 20, 2022 at 3:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Fri, Nov 18, 2022 at 11:57:00AM -0800, Tim Harvey wrote:
> > > On Fri, Nov 18, 2022 at 5:11 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > > Andrew,
> > > > >
> > > > > I completely agree with you but I haven't seen how that can be done
> > > > > yet. What support exists for a PHY driver to expose their LED
> > > > > configuration to be used that way? Can you point me to an example?
> > > >
> > > > Nobody has actually worked on this long enough to get code merged. e.g.
> > > > https://lore.kernel.org/netdev/20201004095852.GB1104@bug/T/
> > > > https://lists.archive.carbon60.com/linux/kernel/3396223
> > > >
> > > > This is probably the last attempt, which was not too far away from getting merged:
> > > > https://patches.linaro.org/project/linux-leds/cover/20220503151633.18760-1-ansuelsmth@gmail.com/
> > > >
> > > > I seem to NACK a patch like yours every couple of months. If all that
> > > > wasted time was actually spent on a common framework, this would of
> > > > been solved years ago.
> > > >
> > > > How important is it to you to control these LEDs? Enough to finish
> > > > this code and get it merged?
> > > >
> > >
> > > Andrew,
> > >
> > > Thanks for the links - the most recent attempt does look promising.
> > > For whatever reason I don't have that series in my mail history so
> > > it's not clear how I can respond to it.
> >
> > apt-get install b4
> >
> > > Ansuel, are you planning on posting a v7 of 'Adds support for PHY LEDs
> > > with offload triggers' [1]?
> > >
> > > I'm not all that familiar with netdev led triggers. Is there a way to
> > > configure the default offload blink mode via dt with your series? I
> > > didn't quite follow how the offload function/blink-mode gets set.
> >
> > The idea is that the PHY LEDs are just LEDs in the Linux LED
> > framework. So read Documentation/devicetree/bindings/leds/common.yaml.
> > The PHY should make use of these standard DT properties, including
> > linux,default-trigger.
> >
> >         Andrew
> 
> Ansuel,
> 
> Are you planning on posting a v7 of 'Adds support for PHY LEDs with
> offload triggers' [1]?
> 
> Best Regards,
> 
> Tim
> [1] https://patches.linaro.org/project/linux-leds/list/?series=174704

I can consider that only if there is a real interest for it and would
love some help by the netdev team to actually have a review from the
leds team...

I tried multiple time to propose it but I never got a review... only a
review from an external guy that wanted to follow his idea in every way
possible with the only intention of applying his code (sorry to be rude
about that but i'm more than happy to recover the work and search for a
common solution)

So yes this is still in my TODO list but it would help if others can
tell me that they want to actually review it. That would put that
project on priority and I would recover and push a v7.

-- 
	Ansuel
