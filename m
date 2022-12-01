Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E681163F795
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiLASik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLASij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:38:39 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2A432B87;
        Thu,  1 Dec 2022 10:38:38 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id z4so4232236wrr.3;
        Thu, 01 Dec 2022 10:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UUhZiDVu1l4R7GELwtStsGItVdYVXKe1EeQ/JddBxpU=;
        b=WXr9NDML4HHKsy71hpgfUyvx5HNTe8RAxfqblEBP+xlBPTmdqRLJOILbXhsrO+/HFk
         XWXI4WV9z6JOczXRfDUmZP67xcFFNydEYAvYOGbe1kfITXwCJbCk2e8Q0eDIHy4HfF/E
         Swq6N1Q+6tfWAzE7njzeEn/OGrdiTKwX9MDKMV31bv/X56FcW9WZsog3QENcEHjxPIIw
         0a5N4gW5qFtqfbOuotptHu+IGH6Eg5iLSDvQ3yNeYoQFMEh5m93TiBxKqqF09Pt2swFp
         9cqFgz8B6CAY3jjXAzU0D0Xq8dV9/BkDdKoYRzXJ0LwXN5u1+L0xJzs2BITt+fBIIQ6k
         aq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUhZiDVu1l4R7GELwtStsGItVdYVXKe1EeQ/JddBxpU=;
        b=eaM4iA+ulOZMKxaWwgyx/0oiN5YsiYCCb4d+LG1PlFxiWw96tOSBqj6zlw5OGDC2Ex
         cTzRfLZo09uuC0p5VIEW7kRSomqaS/Ls75VV0vG4I8Tg06by5oDKskbfJdgxKuBpMIGJ
         lttC0O1UHXuv70XV5Fm9+m01O8ob60MOTXhiTFoZpdPAbVL/fJES7WHHh6D9WRnUDQFg
         9qoaJ62bZ/LAkb/Gs5MLCw4FMmoQOtZd8v+beA8imQpi7WO3fxFEzXR/NMHSkdgfujcA
         j8mjqj9YLUatn38gqx9H8Y0JvYuJlFWla3DcmTwI+vzmqPSUGpCvAb+a80TfgUcPwGQT
         WT3A==
X-Gm-Message-State: ANoB5pmdlAtmTF8FbsVl03OlxlaiZo7Sg6R0kDGAfsuzKZWxhP25Kswr
        tGsBGo/W8ZLPR9d1QLYfRQqYJje1+1w=
X-Google-Smtp-Source: AA0mqf5L0O//G3knxROY53909Es1x2VwKOQ9f40XjvkNutn6ulj/WXrM2FYpSFQ7UIgm9kDz+prFQA==
X-Received: by 2002:adf:e6c8:0:b0:242:18c4:694e with SMTP id y8-20020adfe6c8000000b0024218c4694emr12945304wrm.175.1669919916455;
        Thu, 01 Dec 2022 10:38:36 -0800 (PST)
Received: from Ansuel-xps. (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.gmail.com with ESMTPSA id z16-20020a5d4d10000000b00241c712916fsm6300234wrt.0.2022.12.01.10.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 10:38:35 -0800 (PST)
Message-ID: <6388f4ab.5d0a0220.a137.068e@mx.google.com>
X-Google-Original-Message-ID: <Y4j0rEEA1fC8yRFy@Ansuel-xps.>
Date:   Thu, 1 Dec 2022 19:38:36 +0100
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
 <6388f310.050a0220.532be.7cd5@mx.google.com>
 <CAJ+vNU2AbaDAMhQ0-mDh6ROC7rdkbmXoiSijRTN2ryEgT=QHiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU2AbaDAMhQ0-mDh6ROC7rdkbmXoiSijRTN2ryEgT=QHiQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 10:35:46AM -0800, Tim Harvey wrote:
> On Thu, Dec 1, 2022 at 10:31 AM Christian Marangi <ansuelsmth@gmail.com> wrote:
> >
> > On Thu, Dec 01, 2022 at 10:26:09AM -0800, Tim Harvey wrote:
> > > On Sun, Nov 20, 2022 at 3:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > On Fri, Nov 18, 2022 at 11:57:00AM -0800, Tim Harvey wrote:
> > > > > On Fri, Nov 18, 2022 at 5:11 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > > >
> > > > > > > Andrew,
> > > > > > >
> > > > > > > I completely agree with you but I haven't seen how that can be done
> > > > > > > yet. What support exists for a PHY driver to expose their LED
> > > > > > > configuration to be used that way? Can you point me to an example?
> > > > > >
> > > > > > Nobody has actually worked on this long enough to get code merged. e.g.
> > > > > > https://lore.kernel.org/netdev/20201004095852.GB1104@bug/T/
> > > > > > https://lists.archive.carbon60.com/linux/kernel/3396223
> > > > > >
> > > > > > This is probably the last attempt, which was not too far away from getting merged:
> > > > > > https://patches.linaro.org/project/linux-leds/cover/20220503151633.18760-1-ansuelsmth@gmail.com/
> > > > > >
> > > > > > I seem to NACK a patch like yours every couple of months. If all that
> > > > > > wasted time was actually spent on a common framework, this would of
> > > > > > been solved years ago.
> > > > > >
> > > > > > How important is it to you to control these LEDs? Enough to finish
> > > > > > this code and get it merged?
> > > > > >
> > > > >
> > > > > Andrew,
> > > > >
> > > > > Thanks for the links - the most recent attempt does look promising.
> > > > > For whatever reason I don't have that series in my mail history so
> > > > > it's not clear how I can respond to it.
> > > >
> > > > apt-get install b4
> > > >
> > > > > Ansuel, are you planning on posting a v7 of 'Adds support for PHY LEDs
> > > > > with offload triggers' [1]?
> > > > >
> > > > > I'm not all that familiar with netdev led triggers. Is there a way to
> > > > > configure the default offload blink mode via dt with your series? I
> > > > > didn't quite follow how the offload function/blink-mode gets set.
> > > >
> > > > The idea is that the PHY LEDs are just LEDs in the Linux LED
> > > > framework. So read Documentation/devicetree/bindings/leds/common.yaml.
> > > > The PHY should make use of these standard DT properties, including
> > > > linux,default-trigger.
> > > >
> > > >         Andrew
> > >
> > > Ansuel,
> > >
> > > Are you planning on posting a v7 of 'Adds support for PHY LEDs with
> > > offload triggers' [1]?
> > >
> > > Best Regards,
> > >
> > > Tim
> > > [1] https://patches.linaro.org/project/linux-leds/list/?series=174704
> >
> > I can consider that only if there is a real interest for it and would
> > love some help by the netdev team to actually have a review from the
> > leds team...
> >
> > I tried multiple time to propose it but I never got a review... only a
> > review from an external guy that wanted to follow his idea in every way
> > possible with the only intention of applying his code (sorry to be rude
> > about that but i'm more than happy to recover the work and search for a
> > common solution)
> >
> > So yes this is still in my TODO list but it would help if others can
> > tell me that they want to actually review it. That would put that
> > project on priority and I would recover and push a v7.
> >
> > --
> >         Ansuel
> 
> Ansuel,
> 
> Considering Andrew is nak'ing any phy code to configure LED's until a
> solution using via /sys/class/leds is provided I would say there is
> real interest.
> 
> It seems to me that you got very positive feedback for this last
> series. I would think if you submitted without RFC it would catch more
> eyes as well.
> 

Well yes that's the fun part. netdev really liked the concept and how it
was implemented (and actually also liked the use of a dedicated trigger
instead of bloating the netdev trigger)

But I never got a review from LED team and that result in having the
patch stalled and never merged... But ok I will recover the work and
recheck/retest everything from the start hoping to get more traction
now...

-- 
	Ansuel
