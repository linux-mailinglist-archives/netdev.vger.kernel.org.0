Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800482EC549
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 21:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbhAFUmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 15:42:18 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:39292 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbhAFUmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 15:42:17 -0500
Received: by mail-ot1-f47.google.com with SMTP id d8so4281674otq.6;
        Wed, 06 Jan 2021 12:42:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+nn1mS9duynrGzRRIiFhGe9v+GbfGVRWJu+NZK2hPWU=;
        b=UDuCsxFJodQ7UtSUWcHcnQKi4acOn3zHTLZODVkQGgcICl8piK2c+ydqsyeyPV4AaM
         mxCXQxvApj4NHYjswZkKusri1CS+/6E+Ee3Lh7L4gw2lBVVxbRujJWVRSUb//RlKtJig
         Dh6N7d+x3vclv5zXDmtzv64XLPv7807aoIRs5OjdxJmMjy4bFjklAvBaiXh1DDyj7KoG
         ibNKXV0CilBaHhan0UQrraOWIQBoxejggaLBlONa8Qp26xD6I69G4UYZkASsCJAG/ZA5
         p7T769/o0BqRLQi/+SMlQ7q8NZCRkhHcAYANTI/pKdGJ2GDZgARWuftLq2QQ7xS/4hAh
         y1Mw==
X-Gm-Message-State: AOAM531MvxeRBdRjaSvpWTDMq2b3idI2cZs6V5V8CIb8K1pipGZtfKZI
        cxEe/FQlojeigUdOWKj5lulfExQf8dh/JF3rWzs=
X-Google-Smtp-Source: ABdhPJzU2VNqomItTpW9N5EsZUcSxwbWydRvzmZvuW0h6PN+1EDrO5WVGcImI85plCOq8i6uJPLffPJf+e8BxB/lkhA=
X-Received: by 2002:a05:6830:1f5a:: with SMTP id u26mr4549619oth.250.1609965695506;
 Wed, 06 Jan 2021 12:41:35 -0800 (PST)
MIME-Version: 1.0
References: <20210105140305.141401-1-tsbogend@alpha.franken.de>
 <CAMuHMdX=trGqj8RzV7r1iTneqDjWOc4e1T-X+R_B34rxxhJpbg@mail.gmail.com> <20210106184839.GA7773@alpha.franken.de>
In-Reply-To: <20210106184839.GA7773@alpha.franken.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 6 Jan 2021 21:41:24 +0100
Message-ID: <CAMuHMdV86BES7dmWr-7j1jbtoSy0bH1J0e5W41p8evagi0Nqcw@mail.gmail.com>
Subject: Re: [PATCH 00/10] Remove support for TX49xx
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>, linux-ide@vger.kernel.org,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-rtc@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Wed, Jan 6, 2021 at 7:49 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
> On Wed, Jan 06, 2021 at 09:37:11AM +0100, Geert Uytterhoeven wrote:
> > On Tue, Jan 5, 2021 at 3:03 PM Thomas Bogendoerfer
> > <tsbogend@alpha.franken.de> wrote:
> > > I couldn't find any buyable product other than reference boards using
> > > TX49xx CPUs. And since nobody showed interest in keeping support for
> > > it, it's time to remove it.
> >
> > I have an RBTX4927 development board in my board farm, boot-test every
> > bi-weekly renesas-drivers release on it, and fix kernel issues when they
> > appear.
> >
> > Is that sufficient to keep it?
>
> for me it is. But now we probaly need some reverts then...

Indeed. Fortunately not all of it, as some removals were TX4938-only.

> I wonder whether you have seen my mail about the removal
>
> https://lore.kernel.org/linux-mips/20201207105627.GA15866@alpha.franken.de
>
> and my call for people owning MIPS machines
>
> https://lore.kernel.org/linux-mips/20200227144910.GA25011@alpha.franken.de/

Sorry, I'm not following the linux-mips list that closely, so I hadn't
seen them.  It's always a good idea to CC linux-kernel, and perhaps the
few people who last touched the affected files.

> Still "unclaimed" machines are
>
> IMG Pistachio SoC based boards (MACH_PISTACHIO(
> Toshiba TX39 series based machines (MACH_TX39XX)
> NEC VR4100 series based machines (MACH_VR41XX)
> Netlogic XLR/XLS based systems (NLM_XLR_BOARD)
> Netlogic XLP based systems (NLM_XLP_BOARD)
> Sibyte BCM91120C-CRhine (SIBYTE_CRHINE)
> Sibyte BCM91120x-Carmel (SIBYTE_CARMEL)
> Sibyte BCM91125C-CRhone (SIBYTE_CRHONE)
> Sibyte BCM91125E-Rhone (SIBYTE_RHONE)
> Sibyte BCM91250C2-LittleSur (SIBYTE_LITTLESUR)
> Sibyte BCM91250E-Sentosa (SIBYTE_SENTOSA)
>
> Is there something on this list you also regulary use ?

No, I don't have anything from the list above.
The RBTX4927 is basically my last MIPS-based system I do boot
current kernels on.

In active use, not for development:
  - Ubiquiti EdgeRouter-X (Ralink-based).

Stored in my attic:
  - NetGear WNDR4300 (AtherOS-based),
  - MikroTik Routerboard 150 (ADMtek-based, no (longer?) supported upstream),
  - NEC DDB VRC-5476 (upstream support removed 15 years ago ;-)

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
