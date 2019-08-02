Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E74B07F5DF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 13:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392319AbfHBLUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 07:20:13 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33004 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729311AbfHBLUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 07:20:13 -0400
Received: by mail-qt1-f194.google.com with SMTP id r6so69212912qtt.0;
        Fri, 02 Aug 2019 04:20:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6svSKUB8W/2vAHAY5YVCqR8+83bHvMbbXUyJ8GuWHhs=;
        b=Vl32TDMoJGrn//dSjae8BtiiQXbK1GVk/KIbMF3jNGRWYACaHiYHpsZfap3j31W4oW
         1BA2ejxnYg2JRRwI0gLIoyFsHc67h+13SAY00sQX8udn4tjIu/HINcaKSY81kZga1S8t
         Z96q1ZqfPotvz1gM8G2zfUCt8ExscRW1F+h0PNErKwUa17Di67EyRfK3i11QcIwrMbg9
         UF4CXKQ8dj4VEjWIcB3WleofB9bgdF13cUL1B7ycOfdu2iwYzk1KZqn4GgwyAXd3pEqp
         ZyJk+a63FwkjXR3xmi2n7mIjzg1WtgsxYAO6/htVZuth3A95S1NsrU6cwDkhpCwGjOfc
         17OQ==
X-Gm-Message-State: APjAAAUdUndDAUq0W8zUuGURS4swB4p+GxBZ8r9A6fPJkOw5lclCpg3H
        rr+b//tj0sGqReIzV6FkE2Lpr4My2TzBF+YvrTk=
X-Google-Smtp-Source: APXvYqzzEMPL706zJeruFWjyPx3W7qLTYqQ+nPflILZAKmqIvcLEpD7XRJHi8zMXFo3sUO3koJwU4XNqk+rw0f5qJV4=
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr95077214qtf.204.1564744811845;
 Fri, 02 Aug 2019 04:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-6-arnd@arndb.de>
 <CAMpxmJWFfT_vrDas2fzW5tnxskk9kmgHQpGnGQ-_C20UaS_jhA@mail.gmail.com>
In-Reply-To: <CAMpxmJWFfT_vrDas2fzW5tnxskk9kmgHQpGnGQ-_C20UaS_jhA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 2 Aug 2019 13:19:55 +0200
Message-ID: <CAK8P3a3KpKvRKXY72toE_5eAp4ER_Mre0GX3guwGeQgsY2HX+g@mail.gmail.com>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 9:10 AM Bartosz Golaszewski
<bgolaszewski@baylibre.com> wrote:
> > -#include <mach/hardware.h>
> > -#include <mach/platform.h>
> > +#define _GPREG(x)                              (x)
>
> What purpose does this macro serve?
>
> >
> >  #define LPC32XX_GPIO_P3_INP_STATE              _GPREG(0x000)
> >  #define LPC32XX_GPIO_P3_OUTP_SET               _GPREG(0x004)

In the existing code base, this macro converts a register offset to
an __iomem pointer for a gpio register. I changed the definition of the
macro here to keep the number of changes down, but I it's just
as easy to remove it if you prefer.

> > @@ -167,14 +166,26 @@ struct lpc32xx_gpio_chip {
> >         struct gpio_regs        *gpio_grp;
> >  };
> >
> > +void __iomem *gpio_reg_base;
>
> Any reason why this can't be made part of struct lpc32xx_gpio_chip?

It could be, but it's the same for each instance, and not known until
probe() time, so the same pointer would need to be copied into each
instance that is otherwise read-only.

Let me know if you'd prefer me to rework these two things or leave
them as they are.

> > +static inline u32 gpreg_read(unsigned long offset)
>
> Here and elsewhere: could you please keep the lpc32xx_gpio prefix for
> all symbols?

Sure.

      Arnd
