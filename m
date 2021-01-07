Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0472ECB6B
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 09:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbhAGIFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 03:05:36 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:37857 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbhAGIFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 03:05:35 -0500
Received: by mail-ot1-f41.google.com with SMTP id o11so5559124ote.4;
        Thu, 07 Jan 2021 00:05:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0TPseVwGCXsOzziJOFXy0csIKxTAA1WaNx2ZI4idEKY=;
        b=qYDm+V2g02amIBsejIlly/kxYZMeLMqAAWMKA2EUK5gv1L7jnv2NLfzICoHEdxUnP1
         r2WOSvBfObTNpVann5meU4MrT14hGOru7v7n8piZWymfFYs22t2ibczE5g+JFwGnUdbP
         5DdqseVimErO1P9Uv1Sh/EiDxVEMc0sewoLephTM465UtNZK+l5JTgsyK8TK8PZxVsNB
         dBYpjLA2CRfJzvCEeswplZPcO7EwuZMbOi6jfHaMkpVLi/mJ1owEz0vly0C6vaL1uKzQ
         29lgEfZPlIA1++r5fyuMfztUKA/BLpAYKkje993mcrMUTl0WD+jRImySMYxaJAz31Rb2
         gMrw==
X-Gm-Message-State: AOAM5333ii966ffPw5pRYuEBflSltJ4dtnAZIgRo9B4CoiQelLxc+dpi
        J5T4y9B0rc8VrA02km+5hxviglCYU0gLa9flWQZ3K5io
X-Google-Smtp-Source: ABdhPJzVAPf8/NQQQzT3zzrkoDzUv+P+SG+XgCFUWTKsU/u1ByX8ezoz8GuB2nVGz7LNk3BFgEKDp8LcWHb42uaO/Sc=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr5905584oth.250.1610006693990;
 Thu, 07 Jan 2021 00:04:53 -0800 (PST)
MIME-Version: 1.0
References: <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com>
 <20210106184839.GA7773@alpha.franken.de> <CAMuHMdV86BES7dmWr-7j1jbtoSy0bH1J0e5W41p8evagi0Nqcw@mail.gmail.com>
 <20210107.101729.1936921832901251107.anemo@mba.ocn.ne.jp>
In-Reply-To: <20210107.101729.1936921832901251107.anemo@mba.ocn.ne.jp>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 7 Jan 2021 09:04:43 +0100
Message-ID: <CAMuHMdX6ptaO3r=b55zqwrrK8ADfSRWdunwHA5DYD08PMCAPaA@mail.gmail.com>
Subject: Re: [PATCH 00/10] Remove support for TX49xx
To:     Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "R, Vignesh" <vigneshr@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.com>, linux-ide@vger.kernel.org,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-spi <linux-spi@vger.kernel.org>, linux-rtc@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Richard Weinberger <richard@nod.at>,
        Jakub Kicinski <kuba@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        netdev <netdev@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vinod <vkoul@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nemoto-san,

On Thu, Jan 7, 2021 at 2:18 AM Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> On Wed, 6 Jan 2021 21:41:24 +0100, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >> > Is that sufficient to keep it?
> >>
> >> for me it is. But now we probaly need some reverts then...
> >
> > Indeed. Fortunately not all of it, as some removals were TX4938-only.
>
> These patches should not break RBTX4927:
>
>   net: tc35815: Drop support for TX49XX boards
>   spi: txx9: Remove driver
>   mtd: Remove drivers used by TX49xx
>   char: hw_random: Remove tx4939 driver
>   rtc: tx4939: Remove driver
>   ide: tx4938ide: Remove driver

Indeed.

> And these patches just break audio-support only.
>
>   dma: tx49 removal
>   ASoC: txx9: Remove driver
>
> I think dma and ASoC drivers are hard to maintain now, and can be
> dropped for basic support for RBTX4927.
> (TX39 boards does not have audio-support, so dma txx9 driver can be
> dropped too)

Agreed, I don't test audio anyway, but I know it used to work (I had
intended to use the board as an MPD media server, but never got beyond
the prototyping phase).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
