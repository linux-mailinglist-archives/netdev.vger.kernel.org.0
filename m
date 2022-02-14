Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C67B4B4E1D
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351169AbiBNLYw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 14 Feb 2022 06:24:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351226AbiBNLX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:23:59 -0500
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AAC7E0AA;
        Mon, 14 Feb 2022 02:59:32 -0800 (PST)
Received: by mail-qv1-f50.google.com with SMTP id a19so14432712qvm.4;
        Mon, 14 Feb 2022 02:59:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3zUaM8opKL0LG20PPLjLO0sGhx6OMEFs8RjHjfjsiY4=;
        b=tzYW5L5xOK2xjgIhwKD7wo4utCRQktTYnmyF5KtC7nyd4QwxINuVYG0oZDuj2UWxgT
         v/aCYx8fYJ460CRM8cqFGhvZWVTV32Txdva7EilCtR5KuJUaUdqVVS7A7bSNU3h32VJ+
         2pJ2Y3tGDfNi2ZOUy2aWpZT0nVb7NeQpDeHk76U1HFWgRfZgnwSl3z8nfQ4JYELBC7w+
         anK5B90Xh4HPCL5PMFl7xyPXyFTTOvibl637EXBhEt2cmJo4/fZJ0Y71K7/l41QRDnHU
         eA/djqj4anfQA78O8QEI0s/RYo5qs13hiZUR71hMLnibfSqINLjWfOOnZb42aq7YUf4q
         CRrQ==
X-Gm-Message-State: AOAM531hvoqH7tmhpaGYLCsoe+Zw1pr4CRNoNkqjMA02M0yksh9tEj9K
        nnVGq0KJ/mQRARxLUWcaA+SwQIlmvrkhXw==
X-Google-Smtp-Source: ABdhPJwrRq7LQh4v5o0CPVNGHtwumDUPKtYShp4qDGuprC6H2gTwWZ7lqh2fqI8sviBIFGzuhsrVZw==
X-Received: by 2002:a1f:9092:: with SMTP id s140mr849683vkd.38.1644829287597;
        Mon, 14 Feb 2022 01:01:27 -0800 (PST)
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com. [209.85.221.171])
        by smtp.gmail.com with ESMTPSA id o2sm1719696vke.47.2022.02.14.01.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 01:01:27 -0800 (PST)
Received: by mail-vk1-f171.google.com with SMTP id bj24so2718190vkb.8;
        Mon, 14 Feb 2022 01:01:26 -0800 (PST)
X-Received: by 2002:a1f:7307:: with SMTP id o7mr818150vkc.0.1644829286141;
 Mon, 14 Feb 2022 01:01:26 -0800 (PST)
MIME-Version: 1.0
References: <20220212201631.12648-1-s.shtylyov@omp.ru> <20220212201631.12648-2-s.shtylyov@omp.ru>
 <20220214071351.pcvstrzkwqyrg536@pengutronix.de>
In-Reply-To: <20220214071351.pcvstrzkwqyrg536@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 14 Feb 2022 10:01:14 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWi8gno_FBbc=AwsdRtDJik8_bANjQrrRtUOOBRjFN=KA@mail.gmail.com>
Message-ID: <CAMuHMdWi8gno_FBbc=AwsdRtDJik8_bANjQrrRtUOOBRjFN=KA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] platform: make platform_get_irq_optional() optional
To:     =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jiri Slaby <jirislaby@kernel.org>, linux-iio@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Amit Kucheria <amitk@kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-phy@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>, linux-spi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        openipmi-developer@lists.sourceforge.net,
        Peter Korsgaard <peter@korsgaard.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        kvm@vger.kernel.org, Kamal Dasu <kdasu.kdev@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-serial@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        platform-driver-x86@vger.kernel.org, linux-pwm@vger.kernel.org,
        Zha Qipeng <qipeng.zha@intel.com>,
        Corey Minyard <minyard@acm.org>, linux-pm@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Takashi Iwai <tiwai@suse.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Eric Auger <eric.auger@redhat.com>, netdev@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-mmc@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-renesas-soc@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Brian Norris <computersforpeace@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Uwe,

On Mon, Feb 14, 2022 at 8:29 AM Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Sat, Feb 12, 2022 at 11:16:30PM +0300, Sergey Shtylyov wrote:
> > This patch is based on the former Andy Shevchenko's patch:
> >
> > https://lore.kernel.org/lkml/20210331144526.19439-1-andriy.shevchenko@linux.intel.com/
> >
> > Currently platform_get_irq_optional() returns an error code even if IRQ
> > resource simply has not been found.  It prevents the callers from being
> > error code agnostic in their error handling:
> >
> >       ret = platform_get_irq_optional(...);
> >       if (ret < 0 && ret != -ENXIO)
> >               return ret; // respect deferred probe
> >       if (ret > 0)
> >               ...we get an IRQ...
> >
> > All other *_optional() APIs seem to return 0 or NULL in case an optional
> > resource is not available.  Let's follow this good example, so that the
> > callers would look like:
> >
> >       ret = platform_get_irq_optional(...);
> >       if (ret < 0)
> >               return ret;
> >       if (ret > 0)
> >               ...we get an IRQ...
> >
> > Reported-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> > Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
>
> While this patch is better than v1, I still don't like it for the
> reasons discussed for v1. (i.e. 0 isn't usable as a dummy value which I
> consider the real advantage for the other _get_optional() functions.)

IMHO the real advantage is the simplified error handling, which is the
area where most of the current bugs are. So I applaud the core change.

Also IMHO, the dummy value handling is a red herring.  Contrary to
optional clocks and resets, a missing optional interrupt does not
always mean there is nothing to do: in case of polling, something
else must definitely be done.  So even if request_irq() would accept
a dummy interrupt zero and just do nothing, it would give the false
impression that that is all there is to do, while an actual check
for zero with polling code handling may still need to be present,
thus leading to more not less bugs.

> Apart from that, I think the subject is badly chosen. With "Make
> somefunc() optional" I would expect that you introduce a Kconfig symbol
> that results in the function not being available when disabled.

Agreed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
