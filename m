Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D66416B6
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 13:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiLCMgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 07:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLCMgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 07:36:38 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E14D2FC08;
        Sat,  3 Dec 2022 04:36:37 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id g10so1752603qkl.6;
        Sat, 03 Dec 2022 04:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zyo55RdF12Oshfuf3anRJy4vhxaURJFlQu/s5gweHZ0=;
        b=NY02Mmc0Nh8rO1KBj+bnqsrvonxkvcC8zCanAt3zxl28feFnqNLOul/6njS088eTqE
         iFYnRxtL7zGarfWRurTJiH0bLMOahLDg1Vajsu69Vmdwp/oXtsu1D7212P3vBwKg5wuJ
         jR423R8QurvnLSMWBWxFEubfF+TpWQGajN8aoDSnjxUkfC3j4wqe5ZXfAHsy1XIEAUMt
         sXtybIPY93mg0vT5B8fpWhoXCxDJadvNizXVuJcmunWEq5LA5zicEuwvHi5znnzqntiq
         3Ar8EfJTGAL64cKBaIxh8wubYOWcFH7KexuZiGN4wwUBlqA1/5zrhhsG7lRtwd2yqDyi
         Eiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zyo55RdF12Oshfuf3anRJy4vhxaURJFlQu/s5gweHZ0=;
        b=WeE65VDigfyGxNNiN6CPhhym5YoLPmBA+vpcV86tNK6JY5x06kLNa9TrPX+9s5Zie4
         IG9HjPmssWeTZVg0L/FOgVLsL8+nesY5cyXPpyIIboucdVUAAVvYeUASBm34VCIIuI1v
         pzV7MDr8EM4KQiJHbS6xJI8BcUcMDazTuF6PCtGn04XikHcYvU5gVv1784fM/IJ8xv7+
         FxccDuoIliT8IPrmSYRmIJS0U1wAI8/5vrP6GemZEmSZvX5MfZ/26PQD5tkZ1jZONDFL
         xvwYy/I3WQNn0QTxeJMYMdy6MVX/mi3BgeJf9cOsa0BE3notOWw+W9crfgKk4nUVJSUz
         ZM/g==
X-Gm-Message-State: ANoB5pnIXRNjvFxfDrjtsqSmUOmwodIk/RteUfo0yLgzy7WS/fK7/R35
        DUNfnuPXVtva61q4esyhhZFFXTECrz0Ht5iGM5M=
X-Google-Smtp-Source: AA0mqf4CuxmqO0vLrdefK9yfCZYY2Fi7D9QJghNcIlStaWHAAXcABy2XcQ1vTHvl22jwWjsQGQxKd7Ugk/GLElBQT8I=
X-Received: by 2002:a37:f504:0:b0:6cf:5fa1:15f8 with SMTP id
 l4-20020a37f504000000b006cf5fa115f8mr67062663qkk.748.1670070996109; Sat, 03
 Dec 2022 04:36:36 -0800 (PST)
MIME-Version: 1.0
References: <20211015164809.22009-1-asmaa@nvidia.com> <20211015164809.22009-2-asmaa@nvidia.com>
 <CACRpkdbvR0+5gKUH7eE2tZ1H9DR-WiYyh9KSnUTesYiZ=AezNw@mail.gmail.com>
In-Reply-To: <CACRpkdbvR0+5gKUH7eE2tZ1H9DR-WiYyh9KSnUTesYiZ=AezNw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 3 Dec 2022 14:35:59 +0200
Message-ID: <CAHp75VfaoS4yu0UOJj4V2N+4tWdD0JF47TFgfKCGt7SC-Uhfaw@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] gpio: mlxbf2: Introduce IRQ support
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Asmaa Mnebhi <asmaa@nvidia.com>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        bgolaszewski@baylibre.com, davem@davemloft.net, rjw@rjwysocki.net,
        davthompson@nvidia.com
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

On Sat, Dec 3, 2022 at 12:14 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Oct 15, 2021 at 6:48 PM Asmaa Mnebhi <asmaa@nvidia.com> wrote:
>
> > Introduce standard IRQ handling in the gpio-mlxbf2.c
> > driver.
> >
> > Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
>
> Looks good to me!
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

It was more than a year ago :-)

-- 
With Best Regards,
Andy Shevchenko
