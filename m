Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0239685C6F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjBAAuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjBAAuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:50:23 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03659125A3;
        Tue, 31 Jan 2023 16:50:22 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id bk15so46764787ejb.9;
        Tue, 31 Jan 2023 16:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=14Rz9IsCEo6lrI4LScZe0yDYpkBPJjzhIJ93HjF95ds=;
        b=SU9a656eCx8kjuXWl96KuMwptfpNjgImHGqWLpPbShy0obUH7AvXYddMYGhYJMTigA
         q/kaVok0qgP5QeSm6UPJKr+PwZb8L4DyKKcUU2fkacw9bPcb9JuwlpdNtQW0T0185zCT
         VhH0KPBg1B8y8656SffYsYm6D8y+/kmH9DVZKroN1Ty/BqFSD35DrvZtF9qHHogzrKbk
         reFnZnh/wbYXXP9febcx7Y+cSFH9q7loj2VhBHLqnnZqGihQJNNUb/SB7CfqxaRx282v
         6JiIRUJ7oU3u2H8cqkb/aYnh1t8KF62uADD9qZ2eqvxPCttS7gdl18LO5RwOdtEHhmw3
         EFaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14Rz9IsCEo6lrI4LScZe0yDYpkBPJjzhIJ93HjF95ds=;
        b=bH1ZOuZAZ5Heglf8Fo8Xn/OxQDLD6pYG9FOziT9nrxW37ccFGxiLoyVnmAn6L4zNrx
         QQpp/dwC2kLpa/BGBwylOVrA19GLNhnOAchJe/kxCuvSeI5shR/FzfqC2q32597z48lx
         iYrEc8yXxl4LrxMafXBrZORumU5y4O6aygLKK1y8aSX5iQklXXq7NIGEzWyi9Pix6+bq
         aTelK/DlleZpNh5OWsa7bKtQmPdBNJ15XjxIXEQBo/Gc/fgHde6iI7DCLFwDbxAji22F
         g+PWZMhp4qetllpQWAh793FPHpSOh/YZxNU8ZOilkHMMDoJuqNWO7Q831T/z8DLQWJDT
         574A==
X-Gm-Message-State: AO0yUKX/6mSsoR7NYPId0A8yH8V/IkBLDmw1BVedDr6sdMEAbGcw7k7s
        rJSykLIPgRoEwFU4cD/XtQfDHB6u/18JegVd1r8=
X-Google-Smtp-Source: AK7set+iUvTF3Kdsy7EXm5jI2HjyrWe3w7eLfqf2U1oyWlSnAV6M6aU77qS+7+am4ZW5UHYryom+uxtgJ8A6wCx2PpU=
X-Received: by 2002:a17:906:139b:b0:88c:1d3d:6fab with SMTP id
 f27-20020a170906139b00b0088c1d3d6fabmr91900ejc.299.1675212620101; Tue, 31 Jan
 2023 16:50:20 -0800 (PST)
MIME-Version: 1.0
References: <20230126162323.2986682-1-arnd@kernel.org> <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
In-Reply-To: <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Tue, 31 Jan 2023 16:50:07 -0800
Message-ID: <CAKdAkRSuDJgdsSQqy9Cc_eUYuOfFsLmBJ8Rd93uQhY6HV8nN4w@mail.gmail.com>
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 3:52 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> Hi Arnd,
>
> On Thu, Jan 26, 2023 at 8:32 AM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> >         /* Reset */
> > -       if (gpio_is_valid(rstn)) {
> > +       if (rstn) {
> >                 udelay(1);
> > -               gpio_set_value_cansleep(rstn, 0);
> > +               gpiod_set_value_cansleep(rstn, 0);
> >                 udelay(1);
> > -               gpio_set_value_cansleep(rstn, 1);
> > +               gpiod_set_value_cansleep(rstn, 1);
>
> For gpiod conversions, if we are not willing to chase whether existing
> DTSes specify polarities
> properly and create workarounds in case they are wrong, we should use
> gpiod_set_raw_value*()
> (my preference would be to do the work and not use "raw" variants).
>
> In this particular case, arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> defines reset line as active low,
> so you are leaving the device in reset state.
>
> Please review your other conversion patches.

We also can not change the names of requested GPIOs from "reset-gpio"
to "rstn-gpios" and expect
this to work.

Stefan, please consider reverting this and applying a couple of
patches I will send out shortly.

Thanks.

-- 
Dmitry
