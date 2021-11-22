Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3119745944A
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 18:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbhKVRxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 12:53:40 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37405 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhKVRxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 12:53:37 -0500
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id CBED060006;
        Mon, 22 Nov 2021 17:50:19 +0000 (UTC)
Date:   Mon, 22 Nov 2021 18:50:19 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
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
Subject: Re: [PATCH 00/17] Non-const bitfield helper conversions
Message-ID: <YZvYW1ElW7ZYZNTC@piout.net>
References: <cover.1637592133.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1637592133.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2021 16:53:53+0100, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> <linux/bitfield.h> contains various helpers for accessing bitfields, as
> typically used in hardware registers for memory-mapped I/O blocks. These
> helpers ensure type safety, and deduce automatically shift values from
> mask values, avoiding mistakes due to inconsistent shifts and masks, and
> leading to a reduction in source code size.
> 
> I have already submitted a few conversions to the FIELD_{GET,PREP}()
> helpers that were fixes for real bugs:
>   - [PATCH] mips: cm: Convert to bitfield API to fix out-of-bounds
>     access
>     https://lore.kernel.org/r/0471c545117c5fa05bd9c73005cda9b74608a61e.1635501373.git.geert+renesas@glider.be
>   - [PATCH] drm/armada: Fix off-by-one error in
>     armada_overlay_get_property()
>     https://lore.kernel.org/r/5818c8b04834e6a9525441bc181580a230354b69.1635501237.git.geert+renesas@glider.be
> 
> Plus several patches for normal conversions:
>   - [PATCH] ARM: ptrace: Use bitfield helpers
>     https://lore.kernel.org/r/a1445d3abb45cfc95cb1b03180fd53caf122035b.1637593297.git.geert+renesas@glider.be
>   - [PATCH] MIPS: CPC: Use bitfield helpers
>     https://lore.kernel.org/r/35f0f17e3d987afaa9cd09cdcb8131d42a53c3e1.1637593297.git.geert+renesas@glider.be
>   - [PATCH] MIPS: CPS: Use bitfield helpers
>     https://lore.kernel.org/r/8bd8b1b9a3787e594285addcf2057754540d0a5f.1637593297.git.geert+renesas@glider.be
>   - [PATCH] crypto: sa2ul - Use bitfield helpers
>     https://lore.kernel.org/r/ca89d204ef2e40193479db2742eadf0d9cf3c0ff.1637593297.git.geert+renesas@glider.be
>   - [PATCH] dmaengine: stm32-mdma: Use bitfield helpers
>     https://lore.kernel.org/r/36ceab242a594233dc7dc6f1dddb4ac32d1e846f.1637593297.git.geert+renesas@glider.be
>   - [PATCH] intel_th: Use bitfield helpers
>     https://lore.kernel.org/r/b1e4f027aa88acfbdfaa771b0920bd1d977828ba.1637593297.git.geert+renesas@glider.be
>   - [PATCH] Input: palmas-pwrbutton - use bitfield helpers
>     https://lore.kernel.org/r/f8831b88346b36fc6e01e0910d0db6c94287d2b4.1637593297.git.geert+renesas@glider.be
>   - [PATCH] irqchip/mips-gic: Use bitfield helpers
>     https://lore.kernel.org/r/74f9d126961a90d3e311b92a54870eaac5b3ae57.1637593297.git.geert+renesas@glider.be
>   - [PATCH] mfd: mc13xxx: Use bitfield helpers
>     https://lore.kernel.org/r/afa46868cf8c1666e9cbbbec42767ca2294b024d.1637593297.git.geert+renesas@glider.be
>   - [PATCH] regulator: lp873x: Use bitfield helpers
>     https://lore.kernel.org/r/44d60384b640c8586b4ca7edbc9287a34ce21c5b.1637593297.git.geert+renesas@glider.be
>   - [PATCH] regulator: lp87565: Use bitfield helpers
>     https://lore.kernel.org/r/941c2dfd5b5b124b8950bcce42db4c343dfe9821.1637593297.git.geert+renesas@glider.be
> 
> The existing FIELD_{GET,PREP}() macros are limited to compile-time
> constants.  However, it is very common to prepare or extract bitfield
> elements where the bitfield mask is not a compile-time constant.
> To avoid this limitation, the AT91 clock driver already has its own
> field_{prep,get}() macros.
> 

My understanding was that this (being compile time only) was actually
done on purpose. Did I misunderstand?

> This patch series makes them available for general use, and converts
> several drivers to the existing FIELD_{GET,PREP}() and the new
> field_{get,prep}() helpers.
> 
> I can take the first two patches through the reneas-clk tree for v5.17,
> but probably it is best for the remaining patches to be postponed to
> v5.18.
> 
> Thanks for your comments!
> 
> Geert Uytterhoeven (17):
>   bitfield: Add non-constant field_{prep,get}() helpers
>   clk: renesas: Use bitfield helpers
>   [RFC] soc: renesas: Use bitfield helpers
>   [RFC] ARM: OMAP2+: Use bitfield helpers
>   [RFC] bus: omap_l3_noc: Use bitfield helpers
>   [RFC] clk: ti: Use bitfield helpers
>   [RFC] iio: st_sensors: Use bitfield helpers
>   [RFC] iio: humidity: hts221: Use bitfield helpers
>   [RFC] iio: imu: st_lsm6dsx: Use bitfield helpers
>   [RFC] media: ti-vpe: cal: Use bitfield helpers
>   [RFC] mmc: sdhci-of-aspeed: Use bitfield helpers
>   [RFC] pinctrl: aspeed: Use bitfield helpers
>   [RFC] pinctl: ti: iodelay: Use bitfield helpers
>   [RFC] regulator: ti-abb: Use bitfield helpers
>   [RFC] thermal/ti-soc-thermal: Use bitfield helpers
>   [RFC] ALSA: ice1724: Use bitfield helpers
>   [RFC] rtw89: Use bitfield helpers
> 
>  arch/arm/mach-omap2/clkt2xxx_dpllcore.c       |  5 +-
>  arch/arm/mach-omap2/cm2xxx.c                  | 11 ++-
>  arch/arm/mach-omap2/cm2xxx_3xxx.h             |  9 +--
>  arch/arm/mach-omap2/cm33xx.c                  |  9 +--
>  arch/arm/mach-omap2/cm3xxx.c                  |  7 +-
>  arch/arm/mach-omap2/cminst44xx.c              |  9 +--
>  arch/arm/mach-omap2/powerdomains3xxx_data.c   |  3 +-
>  arch/arm/mach-omap2/prm.h                     |  2 -
>  arch/arm/mach-omap2/prm2xxx.c                 |  4 +-
>  arch/arm/mach-omap2/prm2xxx_3xxx.c            |  7 +-
>  arch/arm/mach-omap2/prm2xxx_3xxx.h            |  9 +--
>  arch/arm/mach-omap2/prm33xx.c                 | 53 +++++-------
>  arch/arm/mach-omap2/prm3xxx.c                 |  3 +-
>  arch/arm/mach-omap2/prm44xx.c                 | 53 ++++--------
>  arch/arm/mach-omap2/vc.c                      | 12 +--
>  arch/arm/mach-omap2/vp.c                      | 11 +--
>  drivers/bus/omap_l3_noc.c                     |  4 +-
>  drivers/clk/at91/clk-peripheral.c             |  1 +
>  drivers/clk/at91/pmc.h                        |  3 -
>  drivers/clk/renesas/clk-div6.c                |  6 +-
>  drivers/clk/renesas/r8a779a0-cpg-mssr.c       |  9 +--
>  drivers/clk/renesas/rcar-gen3-cpg.c           | 15 ++--
>  drivers/clk/ti/apll.c                         | 25 +++---
>  drivers/clk/ti/dpll3xxx.c                     | 81 ++++++++-----------
>  .../iio/common/st_sensors/st_sensors_core.c   |  5 +-
>  drivers/iio/humidity/hts221_core.c            |  8 +-
>  drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h       |  1 -
>  .../iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c    |  7 +-
>  drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c  | 45 +++++------
>  drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c  | 11 +--
>  drivers/media/platform/ti-vpe/cal.h           |  4 +-
>  drivers/mmc/host/sdhci-of-aspeed.c            |  5 +-
>  drivers/net/wireless/realtek/rtw89/core.h     | 38 ++-------
>  drivers/pinctrl/aspeed/pinctrl-aspeed-g4.c    |  3 +-
>  drivers/pinctrl/aspeed/pinctrl-aspeed-g5.c    |  3 +-
>  drivers/pinctrl/aspeed/pinctrl-aspeed-g6.c    |  3 +-
>  drivers/pinctrl/aspeed/pinctrl-aspeed.c       |  5 +-
>  drivers/pinctrl/aspeed/pinmux-aspeed.c        |  6 +-
>  drivers/pinctrl/ti/pinctrl-ti-iodelay.c       | 35 +++-----
>  drivers/regulator/ti-abb-regulator.c          |  7 +-
>  drivers/soc/renesas/renesas-soc.c             |  4 +-
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c   | 11 ++-
>  include/linux/bitfield.h                      | 30 +++++++
>  sound/pci/ice1712/wm8766.c                    | 14 ++--
>  sound/pci/ice1712/wm8776.c                    | 14 ++--
>  45 files changed, 263 insertions(+), 347 deletions(-)
> 
> -- 
> 2.25.1
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
