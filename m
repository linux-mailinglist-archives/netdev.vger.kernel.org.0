Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6170325359
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhBYQRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:17:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233396AbhBYQP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 11:15:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E19564F1E;
        Thu, 25 Feb 2021 16:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614269684;
        bh=DBu7As++Xj2ngUuK1+BPHEYJ3spEm1jiZ3IV1eWJtd8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qFtp6Tf2JB8d/ukEzEcZsf0tWz1mYfS3aR0VwIyRAt4RZhgFXjTqzJtS5swbKi/xB
         +6UnlZYTg8pRWAb33zl1hobuU73Y1NVHYEEs5xaXgSSlfuK/icvsCBdmcAkEXY0+xd
         kKfthyOsit98bXQM6FG6ohNgkVJIkP18Miuedlh4UJo4Bxw+Ai5Zo0bITZSybECxXY
         BFkr2kZwWEtWhaQLnNMxM7g4Loy2cznVtBkbgcBb+9uAsHZqNtc+t/Yq49LNXmJ9tQ
         96wGodMlVyPIXRUZYlli9Um2itO9MAWYErmVUK+CZ+18DTYlGX7RT8PEKFaegRb5qK
         vlKT54/asbDMg==
Received: by mail-ot1-f50.google.com with SMTP id k13so6147064otn.13;
        Thu, 25 Feb 2021 08:14:44 -0800 (PST)
X-Gm-Message-State: AOAM531v//N+DB0zZnDZQwxer7DPImE7Ol01NE8gpKsDLxHjXLfI8+zm
        ozS3q6KRd0BEozSzUAFOSGoK0Sof7NLX4x1cA6U=
X-Google-Smtp-Source: ABdhPJymtg3uUkipkbuEfUxHC1D4/Jp40XCjodrM1WmdpFLtzVvbkXRbhLb40QGNhXXFA4YNCNPpH6PCKl+1fMHsvUw=
X-Received: by 2002:a9d:6b8b:: with SMTP id b11mr2919095otq.210.1614269683648;
 Thu, 25 Feb 2021 08:14:43 -0800 (PST)
MIME-Version: 1.0
References: <20210225143910.3964364-1-arnd@kernel.org> <20210225143910.3964364-3-arnd@kernel.org>
 <CALW65jZPQm88CDa+bvkk-EJGfyV88hRV=MSOjSt1Q5UxD8xrog@mail.gmail.com>
In-Reply-To: <CALW65jZPQm88CDa+bvkk-EJGfyV88hRV=MSOjSt1Q5UxD8xrog@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 25 Feb 2021 17:14:27 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0ce4xSa_SZKR83X5XV4F2W4+VPieScYnfx6_od+j0EMA@mail.gmail.com>
Message-ID: <CAK8P3a0ce4xSa_SZKR83X5XV4F2W4+VPieScYnfx6_od+j0EMA@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: dsa: mt7530: add GPIOLIB dependency
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Landen Chao <landen.chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 4:52 PM DENG Qingfang <dqfext@gmail.com> wrote:
>
> Hi Arnd,
>
> On Thu, Feb 25, 2021 at 10:40 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The new gpio support may be optional at runtime, but it requires
> > building against gpiolib:
> >
> > ERROR: modpost: "gpiochip_get_data" [drivers/net/dsa/mt7530.ko] undefined!
> > ERROR: modpost: "devm_gpiochip_add_data_with_key" [drivers/net/dsa/mt7530.ko] undefined!
> >
> > Add a Kconfig dependency to enforce this.
>
> I think wrapping the GPIO code block with #ifdef CONFIG_GPIOLIB ...
> #endif may be a better idea.

In practice there is little difference, as most configurations have GPIOLIB
enabled anyway, in particular every configuration in which this driver is
used.

If you want to send an alternative patch to add the #ifdef, please include

Reported-by: Arnd Bergmann <arnd@arndb.de>

      Arnd
