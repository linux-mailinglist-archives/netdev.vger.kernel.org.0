Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F715459E10
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhKWIds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:33:48 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:33687 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhKWIdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:33:45 -0500
Received: by mail-pl1-f171.google.com with SMTP id y7so16488285plp.0;
        Tue, 23 Nov 2021 00:30:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tcMJT0SWmBGQBJ3SmOjoPLUb8FZNAvYeGhtoSVPIc5Y=;
        b=VCwEKliL7vGRQmqGa4OMEbd1m3tRXMH4G3hTaAeVkGf6vCk+BkEwKON0qO4ojpIBu7
         5S/RdfdBKMbTAP3mGoN+251WSN4Pwm8xoHQLwgCvGzqml9ewO+dTyZWiQV2YnuXx/Yhg
         N7TZfP4FV0JTMOz0dfTOUmW8cZWl14TaywEiAwKhZfpsoXIpBKK3RGeNQbuwteft0deb
         uGrSX4Ndb2OLiDQP3tKchxdSy4MxELRQmZz1QMt5WNHZY7m17ACOogdFlHjlR+G4H4aS
         Sv0kDBU1DYI45fA1iO5iwjKbsy1aOvJLcVmgYavbHAFXvm6yuw/fsnK7EsoY6DqmYJdy
         mo/Q==
X-Gm-Message-State: AOAM533kPT0CAVTEBMKnvnV3a52WBPvXZ8G2ah3BroubBL9caLh/IMTz
        Upra7T4xA08w3LqQso2MzT5FLDVYgcZlCg==
X-Google-Smtp-Source: ABdhPJxqlamro1/ExJyGPSHWiNDEHJ4qDus6lyQwI/LLtsri6heukspgET3j/WYt8l2kuwABiNAxXw==
X-Received: by 2002:a17:90b:4c4d:: with SMTP id np13mr724754pjb.233.1637656236892;
        Tue, 23 Nov 2021 00:30:36 -0800 (PST)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com. [209.85.215.171])
        by smtp.gmail.com with ESMTPSA id ne7sm401026pjb.36.2021.11.23.00.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:30:36 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id q12so17660815pgh.5;
        Tue, 23 Nov 2021 00:30:36 -0800 (PST)
X-Received: by 2002:a67:af0a:: with SMTP id v10mr5521182vsl.35.1637656225413;
 Tue, 23 Nov 2021 00:30:25 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637592133.git.geert+renesas@glider.be> <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
 <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
In-Reply-To: <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 23 Nov 2021 09:30:14 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUnBgFpqhgjf5AA0LH9MZOFALeC=YinZ4Tv_V+Y9hkRSg@mail.gmail.com>
Message-ID: <CAMuHMdUnBgFpqhgjf5AA0LH9MZOFALeC=YinZ4Tv_V+Y9hkRSg@mail.gmail.com>
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}() helpers
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On Mon, Nov 22, 2021 at 5:33 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2021-11-22 at 16:53 +0100, Geert Uytterhoeven wrote:
> > The existing FIELD_{GET,PREP}() macros are limited to compile-time
> > constants.  However, it is very common to prepare or extract bitfield
> > elements where the bitfield mask is not a compile-time constant.
> >
>
> I'm not sure it's really a good idea to add a third API here?
>
> We have the upper-case (constant) versions, and already
> {u32,...}_get_bits()/etc.

These don't work for non-const masks.

> Also, you're using __ffs(), which doesn't work for 64-bit on 32-bit
> architectures (afaict), so that seems a bit awkward.

That's a valid comment. Can be fixed by using a wrapper macro
that checks if typeof(mask) == u64, and uses an __ffs64() version when
needed.

> Maybe we can make {u32,...}_get_bits() be doing compile-time only checks
> if it is indeed a constant? The __field_overflow() usage is already only
> done if __builtin_constant_p(v), so I guess we can do the same with
> __bad_mask()?

Are all compilers smart enough to replace the division by
field_multiplier(field) by a shift?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
