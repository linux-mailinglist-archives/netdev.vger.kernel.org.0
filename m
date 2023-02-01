Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2BC686B6D
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjBAQVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBAQVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:21:02 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D645366EEF;
        Wed,  1 Feb 2023 08:21:01 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b5so11697087plz.5;
        Wed, 01 Feb 2023 08:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xitRr7qYfg49Eo7qtPnqsKz32hh3WjwjlzkJ7eR8EdE=;
        b=nli1FljFh5HcIzgfOZMOyuTxM6+oIX/gK3sT6bvl2zmLu1P/3pr9hE9OdD4eCYhY/R
         QvbmFKeFFcHqcELDl4ZjvOsDqU3Zx6pUSSo4JSpMFAymplPp5EgbWuOM3bR9aFzI1mZi
         IrPbLQfAj3qYDTno0zcaFA1fbKY0segW0wSv0Rh1Mc12dlAepEwkbg7PYQhu1SsZVpKX
         r3HMKTm4jGTafghUIQRrAk1evwYulISpQez8ubolfE/xlm9Psmwsn6Febb0KzrpzG5Lm
         OIjFn1MKtuHu7DEpdFTRt75jKeVAVJSajk6VZgvOnMYjbsnbSljk7GwFmHvjludmAgdb
         4GJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xitRr7qYfg49Eo7qtPnqsKz32hh3WjwjlzkJ7eR8EdE=;
        b=igDueeXjpWqtcmrvc84uAXs7ylT/Ar2id8MNhVFYDkfbChFhYscMwFYVlHOZKzxDR3
         LZE6SjLUYjtD2nmkE83K9q/N3FaN6XVQveFTgCQAT277tUOMkMs3U2xE9RhK/bTuAFVd
         cJCMcgD2W9d7bdR9bH0YnmpxZTNW0Cy7tNFakjLtEXx9QOD2P9Nq42mJB025ld9Di/kN
         x9fInKUvCDb124UFBBXxTDfY2JjcTQOc4E4fmRYUAULlUR2v/AHTwwZHxZbbqbPBkKNu
         OINNiTFc02A8Up2h1jhAIYqCYxyfABb9ckUGCmmDTDWJri7L7ZbDro8T2qgDTsq00tsy
         imEw==
X-Gm-Message-State: AO0yUKU7lgXONZhQOZaKZDecSHs2KcP4RJfnwM17nszpNvdm7QUvvQiK
        4wovoiama8k1h2HOniR3On0=
X-Google-Smtp-Source: AK7set8wiR+lxnF8ajSsL40l5E1LX3ja+p32ADnomI7TpfuEPwaTWQT7e+b5M9Hm6ZidWCgssJEK+A==
X-Received: by 2002:a17:902:c209:b0:198:adc4:229b with SMTP id 9-20020a170902c20900b00198adc4229bmr1721438pll.22.1675268461135;
        Wed, 01 Feb 2023 08:21:01 -0800 (PST)
Received: from google.com ([2620:15c:9d:2:ce3a:44de:62b3:7a4b])
        by smtp.gmail.com with ESMTPSA id v71-20020a63894a000000b00478eb777d18sm10928122pgd.72.2023.02.01.08.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 08:21:00 -0800 (PST)
Date:   Wed, 1 Feb 2023 08:20:57 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] [v2] at86rf230: convert to gpio descriptors
Message-ID: <Y9qRae1d7xXGCJez@google.com>
References: <20230126162323.2986682-1-arnd@kernel.org>
 <CAKdAkRQT_Jk5yBeMZqh=M1JscVLFieZTQjLGOGxy8nHh8SnD3A@mail.gmail.com>
 <CAKdAkRSuDJgdsSQqy9Cc_eUYuOfFsLmBJ8Rd93uQhY6HV8nN4w@mail.gmail.com>
 <20230201093332.15b0ff9a@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201093332.15b0ff9a@xps-13>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miquel,

On Wed, Feb 01, 2023 at 09:33:32AM +0100, Miquel Raynal wrote:
> Hi Dmitry,
> 
> dmitry.torokhov@gmail.com wrote on Tue, 31 Jan 2023 16:50:07 -0800:
> 
> > On Tue, Jan 31, 2023 at 3:52 PM Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> > >
> > > Hi Arnd,
> > >
> > > On Thu, Jan 26, 2023 at 8:32 AM Arnd Bergmann <arnd@kernel.org> wrote:  
> > > >
> > > >         /* Reset */
> > > > -       if (gpio_is_valid(rstn)) {
> > > > +       if (rstn) {
> > > >                 udelay(1);
> > > > -               gpio_set_value_cansleep(rstn, 0);
> > > > +               gpiod_set_value_cansleep(rstn, 0);
> > > >                 udelay(1);
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
> 
> You mean the semantics of gpio_set_value() gpiod_set_value() are
> different? Looking at your patch it looks like gpio_set_value() asserts
> a physical line state (high or low) while gpiod_set_value() would
> actually try to assert a logical state (enabled or disabled) with the
> meaning of those being possibly inverted thanks to the DT polarities.
> Am I getting this right?

Right. If one wants to do physical levels, they need to use gpiod "raw"
APIs.

Thanks.

-- 
Dmitry
