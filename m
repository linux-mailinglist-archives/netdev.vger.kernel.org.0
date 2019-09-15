Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4CBFB2FAE
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 13:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfIOLN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 07:13:59 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34981 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfIOLN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 07:13:59 -0400
Received: by mail-pg1-f194.google.com with SMTP id n4so17692257pgv.2;
        Sun, 15 Sep 2019 04:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vGC++bKSuV0/ZHeXvOktEZ3piBgJqAASmtSW9gcDz7s=;
        b=VREF9dGMdMMX6ZJx1pB+O8KiiatL6uIa/VZT40Bvej1Uxn4+9l5TwCceBM8VumPNGw
         IYwvIX+bR4Kefn3tJkagGe5Umh601Mu2164hRNHeN2YwKkyYufAxkp7Lz0KsDNGux6/h
         r7sNB9qQDXBK7oqyDiCNOepZf/yeiJHtigS8zLm9B25gsGfwXXZi/TZNLr0CmzjROL+T
         URTzACd1uGV6/oiT7rRFgiHPEXo/DUAHaZG4+3udlmPyRq+UROkVQ5epJwPxoAJyXSsS
         pUBFW1TFCjwgpiB0PqGxkCV8Nb3E7neZWclmC6hocMLDz78ALvORvv2iiD4AEeFFb+Vs
         76kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vGC++bKSuV0/ZHeXvOktEZ3piBgJqAASmtSW9gcDz7s=;
        b=si0GabHP4nNlE5ulh+8fCaKQmoG4MPOIyUXvWPD9j52scCMFFMa3j6OlSWcJas99u4
         gcIoIOGoZZqux2UrGdBtcSBzwWqiaAEoXHNZ4LZAhb5Z+YV3gQutX4UCJ/BTXko/ZPmM
         QEp+LJL1Kq1YbAa3nd2U0Zv0aRQMS/wchZc/rfn3g7L+Lt+DR7qovjxHTl4EWtC3Yh3M
         JkMuhchka1geqS8G3HYSao4CNoveMHTegASrFfR0q0FXIQrR+wK1iQGtAFZ3EOfX/ze5
         VrZrU5idGCFMsFvwhDC4trTCcYzjI8qVONUrWdhvhnHgNk/ZTgBz15XaYVueRgpbcS2U
         4Yeg==
X-Gm-Message-State: APjAAAU/XHABoxpBryBHA9XW9KZJ4nICtb04I5f85I4COEUEu53cmeHs
        Zzh4Q3SHzbIG2pqjM6xWwTV5Dc93qfaDLgrlJds=
X-Google-Smtp-Source: APXvYqyIbP6ZNHGDxbrWlrznhA5vytzdFd4rqRsyaDgTksk3zIWCSt7TuedGEAfBJqPyP8aPmFZbFgaUHJQTX8Qigps=
X-Received: by 2002:a17:90b:151:: with SMTP id em17mr8116611pjb.132.1568546038301;
 Sun, 15 Sep 2019 04:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190913225547.GA106494@dtor-ws> <20190914170933.GV2680@smile.fi.intel.com>
 <20190915060524.GC237523@dtor-ws>
In-Reply-To: <20190915060524.GC237523@dtor-ws>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sun, 15 Sep 2019 14:13:46 +0300
Message-ID: <CAHp75VdtnpO6GU8w_cTdc9dM4ob_hDt56aPU9a8iOgVw06uKQg@mail.gmail.com>
Subject: Re: [PATCH v2] net: mdio: switch to using gpiod_get_optional()
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 15, 2019 at 9:26 AM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Sat, Sep 14, 2019 at 08:09:33PM +0300, Andy Shevchenko wrote:
> > On Fri, Sep 13, 2019 at 03:55:47PM -0700, Dmitry Torokhov wrote:

> > > +   mdiodev->reset_gpio = gpiod_get_optional(&mdiodev->dev,
> > > +                                            "reset", GPIOD_OUT_LOW);
> > > +   error = PTR_ERR_OR_ZERO(mdiodev->reset_gpio);
> > > +   if (error)
> > > +           return error;

> > > +   if (mdiodev->reset_gpio)
> >
> > This is redundant check.
>
> I see that gpiod_* API handle NULL desc and usually return immediately,
> but frankly I am not that comfortable with it. I'm OK with functions
> that free/destroy objects that recognize NULL resources,

> but it is
> unusual for other types of APIs.

CLK, reset, ... frameworks do check for NULL pointer since they
provide an *_optional() getters. So, it's not unusual.
--
With Best Regards,
Andy Shevchenko
