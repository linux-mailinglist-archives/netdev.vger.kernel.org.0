Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B692B63F76E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbiLAS0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiLAS0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:26:22 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46003AB014
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:26:21 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d18so2441104pls.4
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ph7MPGrfzunQQt/4eI+BDAhPTHgqrwSTx7Qab2zu/54=;
        b=uW3WAUUtEquVeyqwSyCNiPA4ZE6LRad2EIeI/NOmUXA/ssB8kofL4AF/dCq9d0mj6s
         VwKpCbh88+eLrVZ7DI6sP3Lbr9sVe31XAOF+v3oKZudyPonlFsJpVJgmXIrMdJRF91zI
         1leGCa6ps+dg/sE3nYrkNZ5XE7bZ2gyvrxZCs8sCX3mvFSW/1ObW+chwR2Zpz774GSNK
         s8X1mPJq6ACoJkNamddfcaBdVQdePtKTFiaUVujbOH1qzprOLEKzMcE6l0eJ6ELKaOF0
         8zdwWbXUcrZs2TGb9KDv8ljxBztTwYX/WITZX7ANHya6M9o/xTAc86kTsEqWqX8g5rms
         fnwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ph7MPGrfzunQQt/4eI+BDAhPTHgqrwSTx7Qab2zu/54=;
        b=BIV53WPI0Fp+vWc+UN0kPaSAKa4LDQbpxPfGILq3Iwbkna0ZGDAOkRqndDrYeHUBM/
         zfu2/PFJd1cOONrS0IBI/A0iFk1Z37LCZ1p/Mjluy+vLvWYkX19TKp+/D/T1EVGHpJY2
         V5MsgahKt/+yh4kGGnAvmJaWuH1nFheksGzMgO+nNGzoO+lH7Pd46IVhBcEazlLOvGM6
         Mkbujli0sm5bx2lYbT4sd1KSuaQvWJxKqx6QLuAA1v8Zg/1TpWULptM5gCU3gxtwoN3A
         5KGPJputzshfsb/cGyLEVnxoWBSBCG0UgzwSxOrX7my9X0vYjc1bueVHte11IXVg9Yfm
         KOTQ==
X-Gm-Message-State: ANoB5plucA+Pmoetl7FuYoSsnpt/3Cu2N5u0zhBAtL5oQyJyu56EBYGP
        MIG9cAlqzsoF8pFsDxqHJBILqDJGYy876z3sQiQsDA==
X-Google-Smtp-Source: AA0mqf5QozFyW7q9c6BF/o9L3OqnCFhDdUgc2yrLlh0pxLxeMZMlxoQhiHjjGBMnLoCa9wtFqyvWym0IyyRI4m6r/mc=
X-Received: by 2002:a17:90b:1095:b0:219:237c:7986 with SMTP id
 gj21-20020a17090b109500b00219237c7986mr26530907pjb.220.1669919180735; Thu, 01
 Dec 2022 10:26:20 -0800 (PST)
MIME-Version: 1.0
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <Y3bRX1N0Rp7EDJkS@lunn.ch> <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
 <Y3eEiyUn6DDeUZmg@lunn.ch> <CAJ+vNU2pAQh6KKiX5x7hFuVpN68NZjhnzwFLRAzS9YZ8bWm1KA@mail.gmail.com>
 <Y3q5t+1M5A0+FQ0M@lunn.ch>
In-Reply-To: <Y3q5t+1M5A0+FQ0M@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 1 Dec 2022 10:26:09 -0800
Message-ID: <CAJ+vNU0yjsJjQLWbtZmswQOyQ6At-Qib8WCcVcSgtDmcFQ3hGQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
To:     Ansuel Smith <ansuelsmth@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 20, 2022 at 3:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Nov 18, 2022 at 11:57:00AM -0800, Tim Harvey wrote:
> > On Fri, Nov 18, 2022 at 5:11 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Andrew,
> > > >
> > > > I completely agree with you but I haven't seen how that can be done
> > > > yet. What support exists for a PHY driver to expose their LED
> > > > configuration to be used that way? Can you point me to an example?
> > >
> > > Nobody has actually worked on this long enough to get code merged. e.g.
> > > https://lore.kernel.org/netdev/20201004095852.GB1104@bug/T/
> > > https://lists.archive.carbon60.com/linux/kernel/3396223
> > >
> > > This is probably the last attempt, which was not too far away from getting merged:
> > > https://patches.linaro.org/project/linux-leds/cover/20220503151633.18760-1-ansuelsmth@gmail.com/
> > >
> > > I seem to NACK a patch like yours every couple of months. If all that
> > > wasted time was actually spent on a common framework, this would of
> > > been solved years ago.
> > >
> > > How important is it to you to control these LEDs? Enough to finish
> > > this code and get it merged?
> > >
> >
> > Andrew,
> >
> > Thanks for the links - the most recent attempt does look promising.
> > For whatever reason I don't have that series in my mail history so
> > it's not clear how I can respond to it.
>
> apt-get install b4
>
> > Ansuel, are you planning on posting a v7 of 'Adds support for PHY LEDs
> > with offload triggers' [1]?
> >
> > I'm not all that familiar with netdev led triggers. Is there a way to
> > configure the default offload blink mode via dt with your series? I
> > didn't quite follow how the offload function/blink-mode gets set.
>
> The idea is that the PHY LEDs are just LEDs in the Linux LED
> framework. So read Documentation/devicetree/bindings/leds/common.yaml.
> The PHY should make use of these standard DT properties, including
> linux,default-trigger.
>
>         Andrew

Ansuel,

Are you planning on posting a v7 of 'Adds support for PHY LEDs with
offload triggers' [1]?

Best Regards,

Tim
[1] https://patches.linaro.org/project/linux-leds/list/?series=174704
