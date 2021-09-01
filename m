Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF983FD443
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 09:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242539AbhIAHLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 03:11:46 -0400
Received: from mail-vk1-f170.google.com ([209.85.221.170]:45849 "EHLO
        mail-vk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242480AbhIAHLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 03:11:45 -0400
Received: by mail-vk1-f170.google.com with SMTP id h13so629708vkc.12;
        Wed, 01 Sep 2021 00:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VwS8bS/jaMLnv7P85/rClwUPFipS5eQCb4wP/1pXcmQ=;
        b=E7Ors/70QI/73qTTGFu2HuLsxWtu31pBVPSK9gWgWqUd+oRlOJniXtaA2AfOldtR7j
         FrP4DS0hLWMnE/U0VnOcpt4q1oaDCJLYcsL5DzgX3Q9fMoMKu7ueE8vqUyosKKDVUKSi
         6LAQQd3WgPWtxW/ZQ/wU53qPmsf2RNL3iOqV19UTmb15S+cbRoeOZoSEMxEc6GdiFg7C
         cmA1ZaSunBZ5fvC06IX/uz5wElzf2ouPjUVsQOeEyDSvhnUshyEiENzz3C8Xm1MzuVt+
         sq81aEa6IYoWJpM4fU4CvRsOTy/QuUdDz/M+qB2Jr6qpwQqQ5TWajKkCZDB4w0m4UmFI
         gh3g==
X-Gm-Message-State: AOAM530hg0dNwUBLM0L6zSvKwHuAsD+aSGd8T0WVNE8Ebn+7jzhVyX23
        UKzdSyCt7Cnmf1IbNT4h5+h8hNAuLEXQgdBAowU=
X-Google-Smtp-Source: ABdhPJwamdo6jRb6gCXNB6sxLoVgJxLZXKS/sqoEp9LBmoFfow75VlXPYyPc0Y4XP/Fe1E/vMHdWFX30ydbtAx28nCA=
X-Received: by 2002:a1f:bd0a:: with SMTP id n10mr20322833vkf.5.1630480248316;
 Wed, 01 Sep 2021 00:10:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210803114051.2112986-1-arnd@kernel.org> <20210803114051.2112986-9-arnd@kernel.org>
In-Reply-To: <20210803114051.2112986-9-arnd@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 1 Sep 2021 09:10:37 +0200
Message-ID: <CAMuHMdUippGJmU2GrYpFQG0MYkD4K7g9DpA07t4609uKJzaJtQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/14] [net-next] xsurf100: drop include of lib8390.c
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Tue, Aug 3, 2021 at 1:41 PM Arnd Bergmann <arnd@kernel.org> wrote:
> From: Michael Schmitz <schmitzmic@gmail.com>
>
> Now that ax88796.c exports the ax_NS8390_reinit() symbol, we can
> include 8390.h instead of lib8390.c, avoiding duplication of that
> function and killing a few compile warnings in the bargain.
>
> Fixes: 861928f4e60e826c ("net-next: New ax88796 platform
> driver for Amiga X-Surf 100 Zorro board (m68k)")
>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/8390/xsurf100.c | 9 ++-------
>  init/main.c                          | 6 +++---

Obviously the second change shouldn't have been part of this patch,
and no one noticed.  Patch sent.

>  2 files changed, 5 insertions(+), 10 deletions(-)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
