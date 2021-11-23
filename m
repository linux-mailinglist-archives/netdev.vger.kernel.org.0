Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570BE459DC3
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbhKWIYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:24:01 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:37656 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhKWIXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:23:54 -0500
Received: by mail-ot1-f43.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so32710152otg.4;
        Tue, 23 Nov 2021 00:20:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EqDPz0+moIASV8/u18qtwgFpVhcXgwVMGWtajI5MBd0=;
        b=1+BrM5ab/nAOx38mqOY5EiIsoIHJshvpzrms3mNltCT/grGe1DZiRFqVnUrv+a9REA
         2qPEOov7jWklahWSboLBlrmFkoUaUHOaWx1uE0R9vh4iB59KD9l89nlcXVUCOkECXKgd
         cEBS96wc07XGbbnq9bZP9lWJvngwo6AWkkysfpKr+B9I+5lmSSHTHpWHFVtNSMKsIBKw
         ukPkFG0Akro9oKI2kp9YBVa0rqiQ+Wo3MLzZK+DZPRY9/lTC1ir7G+Haq0yfwB2tme4C
         Okundo4drrFPwChrNvQ1V+wRsETxqQmoPKZvM7UURzHeV9FkH2J46OiH0MpiabeOHARU
         LKbw==
X-Gm-Message-State: AOAM531zV7a2Bi5IYbemDickJkqZB8l7tHzJQdvOQsCm6uVtO+D+qfUH
        k0YwZlGAKBLKiVy2syvjFeMl6/qhwvqQ+A==
X-Google-Smtp-Source: ABdhPJwe9sx059Wb7JhFyeXY/CngRgc5BHN/QDbA5X094r9QBlKhv/BTVKvqe6nOczniqpfZc40LFQ==
X-Received: by 2002:a9d:19e3:: with SMTP id k90mr2701498otk.99.1637655646043;
        Tue, 23 Nov 2021 00:20:46 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id w19sm2408417oih.44.2021.11.23.00.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:20:45 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id a23-20020a9d4717000000b0056c15d6d0caso32654069otf.12;
        Tue, 23 Nov 2021 00:20:45 -0800 (PST)
X-Received: by 2002:a9f:248b:: with SMTP id 11mr5954157uar.14.1637655634916;
 Tue, 23 Nov 2021 00:20:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637592133.git.geert+renesas@glider.be> <YZvYW1ElW7ZYZNTC@piout.net>
In-Reply-To: <YZvYW1ElW7ZYZNTC@piout.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 23 Nov 2021 09:20:23 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWKHoBWm2XQmKwB0q8Ya8KzpCgA29D0igXJrGY8=3e8_A@mail.gmail.com>
Message-ID: <CAMuHMdWKHoBWm2XQmKwB0q8Ya8KzpCgA29D0igXJrGY8=3e8_A@mail.gmail.com>
Subject: Re: [PATCH 00/17] Non-const bitfield helper conversions
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
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

Hi Alexandre,

On Mon, Nov 22, 2021 at 6:50 PM Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
> On 22/11/2021 16:53:53+0100, Geert Uytterhoeven wrote:
> > The existing FIELD_{GET,PREP}() macros are limited to compile-time
> > constants.  However, it is very common to prepare or extract bitfield
> > elements where the bitfield mask is not a compile-time constant.
> > To avoid this limitation, the AT91 clock driver already has its own
> > field_{prep,get}() macros.
>
> My understanding was that this (being compile time only) was actually
> done on purpose. Did I misunderstand?

Yes, it was done on purpose, to maximize type safety.

However, this imposes a severe limitation: we cannot use them in case
the mask is non-const (i.e. stored in some data structure).  This
is a quite common use-case, given the examples I found and converted,
and given you added field_{get,prep}() to the AT91 clock driver.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
