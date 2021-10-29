Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A91C4404B9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 23:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhJ2VSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 17:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbhJ2VSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 17:18:02 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4D8C061767;
        Fri, 29 Oct 2021 14:15:32 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w1so23809747edd.0;
        Fri, 29 Oct 2021 14:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zB9iTOd6l5xRY5CMg7grYjmtDvYZDiD8fNnJgsxmRRU=;
        b=ZUVK0iOjP01bBbFRtJazELaaIxANhNBitZ8fQCtTHWI49EV1xOygLc7+WtV7eq+U2K
         9zgEBG7ELWsWRc4Vkfs8EEmw40GOYfJx0H34sAcDWg+nB4eneRq0a60aWcl/ohVul5j9
         dxuukyER2DQgzNHfiZ7sQ4595xY7rgWQPF0vlPEBaDlJxw23X4oKGkflSYfza+fbFGuj
         XnkZrWPhtlOwt7tert1R7g+wxVmBVDkwZcx+P25uy6SucfFMGSvsfAyGv43R9BgpI4d8
         RMViIoNXYUrcPkOMqR67hj48aOx5SFd4xUH2CPnGTzGKpqYWxJ3IFqDDPrfAE1GUI9c+
         O7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zB9iTOd6l5xRY5CMg7grYjmtDvYZDiD8fNnJgsxmRRU=;
        b=4IcCn3S2bNYqSHQJmF22k4V4PRsTIRUFsSciDLANPwBc5STRxKFydOpRn8bLBANJ69
         1alq9ST9QmTP3+j5PIPiOGL7SS/Z6Is2wXS7XPIhyBwc5V1Nl7RK/YjNXOBp9iuCWyve
         U75Se2bk+x9FjKl7HGHh1pFlCYOeLb2lmGYhctHULlUfwRsG7zFL2Tm8QRPAwI2CB0KE
         AG9VayxZxNfq/+wug0mzg9S9zA+JKOojGBy8+pG9GvsOFAiladLl/xZZRGzr6hkAcBZQ
         Ye3jqynAI2YJ2RBwXzQoh+IN9cUXO8NXGBaa/nLtNozDwnbX4iG6QgGH4g567cTH9r3J
         Vw7A==
X-Gm-Message-State: AOAM533s4/G1HW/yhMskljCsuIQD4k0Jzt0piw0IRrCl0rdNrWmtevOE
        hTq5b2XCAk56WaVn4rJWaI+3UY/+m8l0J8RlhkjFnUU4c3u0JA==
X-Google-Smtp-Source: ABdhPJx6hAQf0cMI8/q0l37HlNiY5i1PNjSiBeveMPEQBRbZHbggKWBMIxewQ+CETE/rfTiLZgJbs4e4Ml5qiLNJIYk=
X-Received: by 2002:a05:6402:205a:: with SMTP id bc26mr6340821edb.119.1635542131112;
 Fri, 29 Oct 2021 14:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211015164809.22009-1-asmaa@nvidia.com> <CAMRc=McSPG61nnq9sibBunwso1dsO6Juo2M8MtQuEEGZbWqDNw@mail.gmail.com>
 <CH2PR12MB3895A1C9868F8F0C9CA3FC45D7879@CH2PR12MB3895.namprd12.prod.outlook.com>
In-Reply-To: <CH2PR12MB3895A1C9868F8F0C9CA3FC45D7879@CH2PR12MB3895.namprd12.prod.outlook.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sat, 30 Oct 2021 00:14:54 +0300
Message-ID: <CAHp75VcRaumXM5hDEra=UCzAoOAzEP9DGDxVFo3UGvGu8KLqnw@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] gpio: mlxbf2: Introduce proper interrupt handling
To:     Asmaa Mnebhi <asmaa@nvidia.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        David Thompson <davthompson@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 7:46 PM Asmaa Mnebhi <asmaa@nvidia.com> wrote:

> > This is a follow up on a discussion regarding proper handling of GPIO
> > interrupts within the gpio-mlxbf2.c driver.
> >
> > Link to discussion:
> > https://lore.kernel.org/netdev/20210816115953.72533-7-andriy.shevchenk
> > o@linux.intel.com/T/
> >
> > Patch 1 adds support to a GPIO IRQ handler in gpio-mlxbf2.c.
> > Patch 2 is a follow up removal of custom GPIO IRQ handling from the
> > mlxbf_gige driver and replacing it with a simple IRQ request. The ACPI
> > table for the mlxbf_gige driver is responsible for instantiating the
> > PHY GPIO interrupt via GpioInt.
> >
> > Andy Shevchenko, could you please review this patch series.
> > David Miller, could you please ack the changes in the mlxbf_gige
> > driver.

It looks nice! Thank you for fixing this code and making it right!

-- 
With Best Regards,
Andy Shevchenko
