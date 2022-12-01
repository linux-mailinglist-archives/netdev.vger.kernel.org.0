Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5115B63F790
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiLASgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:36:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiLASf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:35:59 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CD0AA8E9
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:35:58 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id r7so2671851pfl.11
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=i63ILiYKNdFdyIi+lkwKMcE7oZYw8auZyDHNIq81dXA=;
        b=dREByz5gq5l+QODuRzOM/db1b5cUlqK+44d9FNtc4uNKR7VTcWUcPAFzTNBX4ZZ2Sl
         3+9kMTz+85EPk9258asao9s2h5yOKFOc8Ym2CCBwvQqxMWcmBt3bJC18w3mVOQUqNuML
         p258ChiwJAdIxYyXp4ikct9qEYtTboETexXQ/Ijynq7HyVB07gi9LxZXNSPOqFS7C5iv
         QFWbgvE081x9HjgKryHgRSCKoJLBLuIY1ylCrDNglH7Lr1Bl7F/Klt6zAtzZBhn8a6Fv
         AdK93/L/LgyQveNPXK5iIsQQmEh+33LCq/V2gGQ+MwP0T4900PS7cZVrky82ZDhL8lYs
         MBrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i63ILiYKNdFdyIi+lkwKMcE7oZYw8auZyDHNIq81dXA=;
        b=tvDi6ui5PRJ7FPPIlbVs4it8a4UMjm1bJ0Cb5WF4kUmAOEWMpq426wk0GJj8aWzNd9
         Fg/mCxeLy8T8y8SQQRn7v5WNQCQiTVGlYlM26tmRgJLbCy5DZgps4kjGEQ0MRqmeBQF0
         Gf+YKOQ/LnRV2GvoAbN4IkDSe2NhEoL6QyJpWgTVESKMM963/RCsoKMgJDdG+bFLSHJS
         WFxfOR3udVClvtpyNWx2oHiQ2koWGDUASm4IXXtcsBiSCSvVLdLlSbOyqkUr2aCvkiK3
         wQ/WHwyJaX1hcwGi4rvBTBeJFFjArIPJ8MoB8Psnz8MpnGgc+uZYJfJkwIuRwfetGO0I
         d1cg==
X-Gm-Message-State: ANoB5pn1qb9NcFQJ9VnS9aRElGl4WOOCu0wUjdZTmszEMgx6kZIGQu9v
        3BXGSNZAKKY6F7VKbMRqS5Mdstw7HxHMUFdwxnueCw==
X-Google-Smtp-Source: AA0mqf5GIFlXT3xsGJUCUnEPzewxsVJpjp51A/USaa0Ecw1GwaJ5otmluZOA5ixL4tBVNcAeXszaC48ueHfbMIKQrNo=
X-Received: by 2002:a63:f214:0:b0:477:f449:3644 with SMTP id
 v20-20020a63f214000000b00477f4493644mr25277863pgh.484.1669919757574; Thu, 01
 Dec 2022 10:35:57 -0800 (PST)
MIME-Version: 1.0
References: <20221118001548.635752-1-tharvey@gateworks.com>
 <Y3bRX1N0Rp7EDJkS@lunn.ch> <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
 <Y3eEiyUn6DDeUZmg@lunn.ch> <CAJ+vNU2pAQh6KKiX5x7hFuVpN68NZjhnzwFLRAzS9YZ8bWm1KA@mail.gmail.com>
 <Y3q5t+1M5A0+FQ0M@lunn.ch> <CAJ+vNU0yjsJjQLWbtZmswQOyQ6At-Qib8WCcVcSgtDmcFQ3hGQ@mail.gmail.com>
 <6388f310.050a0220.532be.7cd5@mx.google.com>
In-Reply-To: <6388f310.050a0220.532be.7cd5@mx.google.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 1 Dec 2022 10:35:46 -0800
Message-ID: <CAJ+vNU2AbaDAMhQ0-mDh6ROC7rdkbmXoiSijRTN2ryEgT=QHiQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
To:     Christian Marangi <ansuelsmth@gmail.com>
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
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 1, 2022 at 10:31 AM Christian Marangi <ansuelsmth@gmail.com> wrote:
>
> On Thu, Dec 01, 2022 at 10:26:09AM -0800, Tim Harvey wrote:
> > On Sun, Nov 20, 2022 at 3:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Fri, Nov 18, 2022 at 11:57:00AM -0800, Tim Harvey wrote:
> > > > On Fri, Nov 18, 2022 at 5:11 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > > > >
> > > > > > Andrew,
> > > > > >
> > > > > > I completely agree with you but I haven't seen how that can be done
> > > > > > yet. What support exists for a PHY driver to expose their LED
> > > > > > configuration to be used that way? Can you point me to an example?
> > > > >
> > > > > Nobody has actually worked on this long enough to get code merged. e.g.
> > > > > https://lore.kernel.org/netdev/20201004095852.GB1104@bug/T/
> > > > > https://lists.archive.carbon60.com/linux/kernel/3396223
> > > > >
> > > > > This is probably the last attempt, which was not too far away from getting merged:
> > > > > https://patches.linaro.org/project/linux-leds/cover/20220503151633.18760-1-ansuelsmth@gmail.com/
> > > > >
> > > > > I seem to NACK a patch like yours every couple of months. If all that
> > > > > wasted time was actually spent on a common framework, this would of
> > > > > been solved years ago.
> > > > >
> > > > > How important is it to you to control these LEDs? Enough to finish
> > > > > this code and get it merged?
> > > > >
> > > >
> > > > Andrew,
> > > >
> > > > Thanks for the links - the most recent attempt does look promising.
> > > > For whatever reason I don't have that series in my mail history so
> > > > it's not clear how I can respond to it.
> > >
> > > apt-get install b4
> > >
> > > > Ansuel, are you planning on posting a v7 of 'Adds support for PHY LEDs
> > > > with offload triggers' [1]?
> > > >
> > > > I'm not all that familiar with netdev led triggers. Is there a way to
> > > > configure the default offload blink mode via dt with your series? I
> > > > didn't quite follow how the offload function/blink-mode gets set.
> > >
> > > The idea is that the PHY LEDs are just LEDs in the Linux LED
> > > framework. So read Documentation/devicetree/bindings/leds/common.yaml.
> > > The PHY should make use of these standard DT properties, including
> > > linux,default-trigger.
> > >
> > >         Andrew
> >
> > Ansuel,
> >
> > Are you planning on posting a v7 of 'Adds support for PHY LEDs with
> > offload triggers' [1]?
> >
> > Best Regards,
> >
> > Tim
> > [1] https://patches.linaro.org/project/linux-leds/list/?series=174704
>
> I can consider that only if there is a real interest for it and would
> love some help by the netdev team to actually have a review from the
> leds team...
>
> I tried multiple time to propose it but I never got a review... only a
> review from an external guy that wanted to follow his idea in every way
> possible with the only intention of applying his code (sorry to be rude
> about that but i'm more than happy to recover the work and search for a
> common solution)
>
> So yes this is still in my TODO list but it would help if others can
> tell me that they want to actually review it. That would put that
> project on priority and I would recover and push a v7.
>
> --
>         Ansuel

Ansuel,

Considering Andrew is nak'ing any phy code to configure LED's until a
solution using via /sys/class/leds is provided I would say there is
real interest.

It seems to me that you got very positive feedback for this last
series. I would think if you submitted without RFC it would catch more
eyes as well.

Best Regards,

Tim
