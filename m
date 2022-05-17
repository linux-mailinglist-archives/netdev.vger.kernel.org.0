Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92650529A5D
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbiEQHFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiEQHFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:05:07 -0400
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA0A1EC7B;
        Tue, 17 May 2022 00:05:05 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id o130so15353888ybc.8;
        Tue, 17 May 2022 00:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uGL6v7eQK1/0CRwWroEeXxkpUt+slToqlAa+poondV0=;
        b=WJFzwfiTvp8Qoe/BXM3DE9JsAYNW9+ZVu9JikHZjOuUy3AbzUrBFvevljtQcwzxjLd
         czUSSmun4yZsGEqD5Zve82sWCGI6c4bQa0xKG2DhlTRmU8UXIPFcsGcEDHr/oQ1dwtuE
         zyBKxE6BxHYAOhsrVkHJfeDKmdD6yxfReAgRIFMr4rXRmN1JF0moOoHGvBs5sUi8jj7m
         ObKeyW4W4y1ny4HmLUpZl/oc1e31Pl0l1pXRuZqhmw9oZc1OkK4eZ7kk4kDa7zKT0ww+
         qNGOoBKawuq4Xv68j4JlYbHKwrJp2Sph1BKoLZp8kj7hdkNILDRLPlXlqrDsEqN0O9NC
         Cing==
X-Gm-Message-State: AOAM530ZaTGcsx1v6Ku4ZLqfFx7wVo8nfljnnfBzn8MeVvVx+4rv3v8f
        tMsUmyfSVmP6+xy07wgTRT9CDQTkaNGFrC46orgWfEMw/F2pnw==
X-Google-Smtp-Source: ABdhPJy683BW3WCcSZi2Cj9GijVHOZZd+oqshOvpXiUDGrBiMFaUyh8rHdidrsvX/lcd0qtI32pp9NMN2Z/62yAFKIY=
X-Received: by 2002:a5b:ac4:0:b0:64b:48de:269b with SMTP id
 a4-20020a5b0ac4000000b0064b48de269bmr22306374ybr.423.1652771104753; Tue, 17
 May 2022 00:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220514141650.1109542-1-mailhol.vincent@wanadoo.fr> <20220514141650.1109542-4-mailhol.vincent@wanadoo.fr>
 <7b1644ad-c117-881e-a64f-35b8d8b40ef7@hartkopp.net> <CAMZ6RqKZMHXB7rQ70GrXcVE7x7kytAAGfE+MOpSgWgWgp0gD2g@mail.gmail.com>
 <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
In-Reply-To: <20220517060821.akuqbqxro34tj7x6@pengutronix.de>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 17 May 2022 16:04:53 +0900
Message-ID: <CAMZ6RqJ3sXYUOpw7hEfDzj14H-vXK_i+eYojBk2Lq=h=7cm7Jg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 17 May 2022 at 15:08, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 17.05.2022 10:50:16, Vincent MAILHOL wrote:
> > > would it probably make sense to
> > > introduce a new can-skb module that could be used by all CAN
> > > virtual/software interfaces?
> > >
> > > Or some other split-up ... any idea?
> >
> > My concern is: what would be the merrit? If we do not split, the users
> > of slcan and v(x)can would have to load the can-dev module which will
> > be slightly bloated for their use, but is this really an issue?
>
> If you use modprobe all required modules are loaded automatically.

Yes, this, now I know. In the past, when I started developing
etas_es58x as an out of tree module (which I inserted using insmod),
it took me a little time to figure out the dependencies tree and which
module I actually had to modprobe separately.

> > I do
> > not see how this can become a performance bottleneck, so what is the
> > problem?
> > I could also argue that most of the devices do not depend on
> > rx-offload.o. So should we also split this one out of can-dev on the
> > same basis and add another module dependency?
>
> We can add a non user visible Kconfig symbol for rx-offload and let the
> drivers that need it do a "select" on it. If selected the rx-offload
> would be compiled into to can-dev module.

Yes, and this remark also applies to can-skb I think.

So slcan, v(x)can and can-dev will select can-skb, and some of the
hardware drivers (still have to figure out the list) will select
can-rx-offload (other dependencies will stay as it is today).

I think that splitting the current can-dev into can-skb + can-dev +
can-rx-offload is enough. Please let me know if you see a need for
more.

> > The benefit (not having to load a bloated module for three drivers)
> > does not outweigh the added complexity: all hardware modules will have
> > one additional modprobe dependency on the tiny can-skb module.
> >
> > But as said above, I am not fully opposed to the split, I am just
> > strongly divided. If we go for the split, creating a can-skb module is
> > the natural and only option I see.
> > If the above argument does not convince you, I will send a v3 with that split.

If both you and Oliver prefer the split, then split it would be!

Because this topic is related to Kbuild, there is actually one thing
which bothered me but which I never asked: why are all the CAN devices
under "Networking support" and not "Device Drivers" in menuconfig like
everything else? Would it make sense to move our devices under the
"Device Drivers" section? I can do it while working on the v3.
