Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4AD987C7B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 16:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407087AbfHIOTC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 9 Aug 2019 10:19:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41937 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfHIOTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 10:19:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id g17so1058726qkk.8;
        Fri, 09 Aug 2019 07:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TEfOzDxFX7gDpnqMzrlBGrH3Syt9gXqMdj4yqEybIZo=;
        b=QXHfe+5F2OOhd2CElNQM4DMdlNJ4IJl8fINRHiW3jKlocffCMbvetrzZAqZj73zlmj
         KWvFoVIYkOHvDj1DaYKbfsuCvroIUYFb3KL+M9mkFDlElbx/WQrXDrEmoD9TEU4aBY4V
         KOYSTDW4jBYl1Q1ouhbunaHKhuxt1uFwhly4aynTDR3/pFoatrZAGcllqAX3imwjf7rg
         Zvptpq+bditHfN3KQpZl7biqacUzCNzWVHXcWNc47zgDNuTW5Ddvc7FolbuGOSKoYWHe
         U95f/JthiUb4jQ8Awib8m4ByohBD8ZbF9S/ymEA2OIxhbWwKX69SfaGeAtETxlf7AIPX
         4bTg==
X-Gm-Message-State: APjAAAULwbc9OKX1TGlOPd/2K493GXivn5Vz3PzAouoEWlMHdClUpahm
        1/NNzHwi7xx3joyV/qXpaBZpTVA/KRvGrriqZOs=
X-Google-Smtp-Source: APXvYqwdOIIhs7aYJbryOrEuz/1xQSAZBUfsTj7jxd0qGAmaTDwXDUSNUG1kGVNfZ5fjxOBFSW0skDDZmykp0YbSLSg=
X-Received: by 2002:a37:984:: with SMTP id 126mr12380366qkj.3.1565360340175;
 Fri, 09 Aug 2019 07:19:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-6-arnd@arndb.de>
 <CAMpxmJWFfT_vrDas2fzW5tnxskk9kmgHQpGnGQ-_C20UaS_jhA@mail.gmail.com>
 <CAK8P3a3KpKvRKXY72toE_5eAp4ER_Mre0GX3guwGeQgsY2HX+g@mail.gmail.com> <CAMpxmJUdSnp0QNwWB0rJ1opFrYs9R2KSVS64Tz8X5GDYAJYLpg@mail.gmail.com>
In-Reply-To: <CAMpxmJUdSnp0QNwWB0rJ1opFrYs9R2KSVS64Tz8X5GDYAJYLpg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 9 Aug 2019 16:18:43 +0200
Message-ID: <CAK8P3a1NT_yoP39y52oJTMsFCb96-bRyuMm=+5HPPsxyq0fJDA@mail.gmail.com>
Subject: Re: [PATCH 05/14] gpio: lpc32xx: allow building on non-lpc32xx targets
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     soc@kernel.org, arm-soc <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-serial@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 10:28 AM Bartosz Golaszewski
<bgolaszewski@baylibre.com> wrote:
>
> pt., 2 sie 2019 o 13:20 Arnd Bergmann <arnd@arndb.de> napisał(a):
> >
> > On Fri, Aug 2, 2019 at 9:10 AM Bartosz Golaszewski
> > <bgolaszewski@baylibre.com> wrote:
> > > > -#include <mach/hardware.h>
> > > > -#include <mach/platform.h>
> > > > +#define _GPREG(x)                              (x)
> > >
> > > What purpose does this macro serve?
> > >
> > > >
> > > >  #define LPC32XX_GPIO_P3_INP_STATE              _GPREG(0x000)
> > > >  #define LPC32XX_GPIO_P3_OUTP_SET               _GPREG(0x004)
> >
> > In the existing code base, this macro converts a register offset to
> > an __iomem pointer for a gpio register. I changed the definition of the
> > macro here to keep the number of changes down, but I it's just
> > as easy to remove it if you prefer.
>
> Could you just add a comment so that it's clear at first glance?

I ended up removing the macro. With the change to keep the reg_base as
a struct member, this ends up being a relatively small change, and it's
more straightforward that way.

> > > > @@ -167,14 +166,26 @@ struct lpc32xx_gpio_chip {
> > > >         struct gpio_regs        *gpio_grp;
> > > >  };
> > > >
> > > > +void __iomem *gpio_reg_base;
> > >
> > > Any reason why this can't be made part of struct lpc32xx_gpio_chip?
> >
> > It could be, but it's the same for each instance, and not known until
> > probe() time, so the same pointer would need to be copied into each
> > instance that is otherwise read-only.
> >
> > Let me know if you'd prefer me to rework these two things or leave
> > them as they are.
>
> I would prefer not to have global state in the driver, let's just
> store the pointer in the data passed to gpiochip_add_data().

Ok, done.

       Arnd
