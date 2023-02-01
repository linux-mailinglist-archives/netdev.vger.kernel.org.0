Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155AB686B68
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjBAQTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbjBAQTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:19:32 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6BD6F20D;
        Wed,  1 Feb 2023 08:19:28 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id c10-20020a17090a1d0a00b0022e63a94799so2739098pjd.2;
        Wed, 01 Feb 2023 08:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L51QcybdvZxC0Y33sJNQYA8JyEbOgptDcqBfhpm3m8c=;
        b=QyMFtOrOtBs6vi0ArDT0UrCKsg0l4+hDJVlT0HlTEH+lt9E833uCPsVHcAAzu40dL3
         O5JlJrazRZmgPzZWftIE1BWjgfosw2dVNWn0KXvA3d337ne1lCz1UkyycqpFunkgfUEJ
         DDA3iNLJfqr9fU/+phvsHr2WGgLj8nDk/kjwBehBwJbneJqeEN8SdWu02F/cmDE6smuA
         Y/ghYckg2l3lPyg09bTlhUvSlxfFUs17BXYP6t17B91oBUHszaLWj1nQzRIs4sSes5O6
         ouM4cX4lWour33n9svAo6MoHGNQ6LPhe5gldtFqpGmWssqv2nyIGu2mugMHja3kUZK6d
         RO4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L51QcybdvZxC0Y33sJNQYA8JyEbOgptDcqBfhpm3m8c=;
        b=BSerUxBfQ9PKiSGYOnbv2FsG/og6Bggwk4GmBt86uJJBpX92q43X5kb6ue9SLaZ9Iv
         OBPl/ll4dImEUY0cVDg/g/sEZA1Rx9rPr3QlXIEXTuB2wxKeVJLgSqNIv4w5gtif0Jqj
         o8SDEbcV8ESYCiLK6zKh6l6pRhCoc0NvzDD3ryh1kgbsOsgxf+7FEa9hOe8aEpCJTUgx
         APSqYJGfr1YrjPOwh2wJ5ZKXt4mb4n0Na9vS9eUB62vnWhLw/06IkuocdjzPvjUXFsHI
         GDkmC++B614lzoKyFtlea7PBmUbGDO/ZG8onYuJDG6v0M982T57PYtCvpZSNXjh6oRCv
         SEyg==
X-Gm-Message-State: AO0yUKUETkm5/N8d6yDlVQc425+4qqo2wSpxidk+VVnP0gdyH4EwJmrk
        /Z8ThhK0vLQUCSQlwFlRM5c=
X-Google-Smtp-Source: AK7set8EhnXKVPNM6SIPjuW7MGwCBpWV1VRZhfvColDvuSqyc1gDnLJD5mzQJ0AX9vc6nV6c0bsP5g==
X-Received: by 2002:a17:903:20c4:b0:189:894c:6b48 with SMTP id i4-20020a17090320c400b00189894c6b48mr2505773plb.59.1675268367526;
        Wed, 01 Feb 2023 08:19:27 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id p4-20020a1709026b8400b0019141c79b1dsm11792457plk.254.2023.02.01.08.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 08:19:26 -0800 (PST)
Date:   Wed, 1 Feb 2023 08:19:23 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
Message-ID: <Y9qRC2qz7ZbKslnb@google.com>
References: <20230126162323.2986682-1-arnd@kernel.org>
 <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
 <CAKdAkRSuDJgdsSQqy9Cc_eUYuOfFsLmBJ8Rd93uQhY6HV8nN4w@mail.gmail.com>
 <77b78287-a352-85ae-0c3d-c3837be9bf1d@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77b78287-a352-85ae-0c3d-c3837be9bf1d@datenfreihafen.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 01:42:37PM +0100, Stefan Schmidt wrote:
> Hello Dmitry.
> 
> On 01.02.23 01:50, Dmitry Torokhov wrote:
> > On Tue, Jan 31, 2023 at 3:52 PM Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > > 
> > > Hi Arnd,
> > > 
> > > On Thu, Jan 26, 2023 at 8:32 AM Arnd Bergmann <arnd@kernel.org> wrote:
> > > > 
> > > >          /* Reset */
> > > > -       if (gpio_is_valid(rstn)) {
> > > > +       if (rstn) {
> > > >                  udelay(1);
> > > > -               gpio_set_value_cansleep(rstn, 0);
> > > > +               gpiod_set_value_cansleep(rstn, 0);
> > > >                  udelay(1);
> > > > -               gpio_set_value_cansleep(rstn, 1);
> > > > +               gpiod_set_value_cansleep(rstn, 1);
> > > 
> > > For gpiod conversions, if we are not willing to chase whether existing
> > > DTSes specify polarities
> > > properly and create workarounds in case they are wrong, we should use
> > > gpiod_set_raw_value*()
> > > (my preference would be to do the work and not use "raw" variants).
> > > 
> > > In this particular case, arch/arm/boot/dts/vf610-zii-dev-rev-c.dts
> > > defines reset line as active low,
> > > so you are leaving the device in reset state.
> > > 
> > > Please review your other conversion patches.
> > 
> > We also can not change the names of requested GPIOs from "reset-gpio"
> > to "rstn-gpios" and expect
> > this to work.
> > 
> > Stefan, please consider reverting this and applying a couple of
> > patches I will send out shortly.
> 
> Thanks for having another look at these patches. Do you have the same
> concern for the convesion patch to cc2520 that has been posted and applied
> as well?

There are no DT users of cc2520 in the tree, so while ideally reset line
should not be left in "logical active" state at the end of the probe, we
can deal with this in a follow up patch, I doubt it will lead to
regressions as it is.

If I were really nitpicky I would adjust error messages when we fail to
get GPIOs, but again, can be done as a followup.

> 
> Arnd, if you have any concerns about the revert please speak up soon as I am
> going to revert your patch and get these patches into my tree later today.
> 

Thanks.

-- 
Dmitry
