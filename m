Return-Path: <netdev+bounces-1862-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 671A76FF574
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75D7D1C20F28
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 532A362A;
	Thu, 11 May 2023 15:08:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417FA629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:08:15 +0000 (UTC)
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64A7E72;
	Thu, 11 May 2023 08:08:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1aae46e62e9so63074035ad.2;
        Thu, 11 May 2023 08:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683817690; x=1686409690;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=91+5dXYzQeyUNC81s4FXhCBQF/Ohu+6dIaUfBtGY2zg=;
        b=eUfYz6ggXiEzB0u7XwnKyHjrTJND0HjbcVJLDIx/tZvuVqGafyyNi5bwCOzV0uUoKr
         EkuYS3iFvyhOgcVNoyU48i8FkN4yXD/3g5dPKPyIRpuY579QmW+kcKkMIOzpIypmehjx
         4y4qK8CBju5EnK8OXwGd/BUeBwvI7GrYyUSJKKOr1eJUUq4ZHus17loSONc3fTR/h2um
         ibnhD8PiI8zgQGeXhDW7lk+CpwNSguBuX8fqE5rqvRyvytzz+qxZbejr3besNnGgjpLZ
         RIwngOoYw+QwzUdUb2R8XEUnU5c5PmyEyR1B7z8Sei5hoe4QBh9W9zef0m/08j2xD9/H
         R4Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683817690; x=1686409690;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=91+5dXYzQeyUNC81s4FXhCBQF/Ohu+6dIaUfBtGY2zg=;
        b=KPK3LD/C3ysCc1z0F9L3dfzFvlG1rkjHAJgoP0Ang+6KCfSjqr8W7rcr3yYgIYChY/
         EoJ7D5fYtIb9uGWg9yMZQyvHWggz0zs3KPdlONyhWU1a0QEyOghByT0GERsO2qBzC/8C
         cK2vHbGsJxpSJhqY7LNuhpaZ3muSoq1661+/joUDWIB8BOlUgfww/Ofm2vElCAe1E55H
         UPR8IyatZGq5NX1rNXOpMT3upXDLeee9Bluroy0cyoJd+74i3sIxhPbXJQcPh2RrRC2B
         3P9HbZYfyFB6orEqund2F0R/WOCYQmtyEVdtoWiHm5ZgE5Ug2W7rGgF8E+GtKG3VRnwJ
         IUoA==
X-Gm-Message-State: AC+VfDxlfUS7FJg5oYMXgc4jEFk3IoJoGx7WHF8+TXt5LEH+lB5XmBMu
	nM+6IcvbINdUKJ82PrjOdpA=
X-Google-Smtp-Source: ACHHUZ513s30ssA68dscl1SlkKD2ddH1FINT9xWnrgnXyL/6bHLM08gIebQj0TLX1xYU9JKmPDq3Fw==
X-Received: by 2002:a17:902:d4c6:b0:1ac:8ad0:1707 with SMTP id o6-20020a170902d4c600b001ac8ad01707mr16330835plg.1.1683817689990;
        Thu, 11 May 2023 08:08:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jj18-20020a170903049200b001ac2f98e953sm5985954plb.216.2023.05.11.08.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 08:08:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 11 May 2023 08:08:07 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>, Jan Kara <jack@suse.com>,
	Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>, Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>, Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>,
	Ray Lehtiniemi <rayl@mail.com>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Andrey Panin <pazke@donpac.ru>, Oleg Drokin <green@crimea.edu>,
	Marc Zyngier <maz@kernel.org>,
	Jonas Jensen <jonas.jensen@gmail.com>,
	Sylver Bruneau <sylver.bruneau@googlemail.com>,
	Andrew Sharp <andy.sharp@lsi.com>,
	Denis Turischev <denis@compulab.co.il>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 08/10] drivers: watchdog: Replace GPL license notice with
 SPDX identifier
Message-ID: <46c263f6-dd9c-408c-b3e0-bfb2676c6505@roeck-us.net>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-9-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511133406.78155-9-bagasdotme@gmail.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:34:04PM +0700, Bagas Sanjaya wrote:
> Many watchdog drivers's source files has already SPDX license
> identifier, while some remaining doesn't.
> 
> Convert notices on remaining files to SPDX identifier.
> 
> Cc: Ray Lehtiniemi <rayl@mail.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Andrey Panin <pazke@donpac.ru>
> Cc: Oleg Drokin <green@crimea.edu>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Jonas Jensen <jonas.jensen@gmail.com>
> Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
> Cc: Andrew Sharp <andy.sharp@lsi.com>
> Cc: Denis Turischev <denis@compulab.co.il>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  drivers/watchdog/ep93xx_wdt.c     | 5 +----
>  drivers/watchdog/ibmasr.c         | 3 +--
>  drivers/watchdog/m54xx_wdt.c      | 4 +---
>  drivers/watchdog/max63xx_wdt.c    | 5 +----
>  drivers/watchdog/moxart_wdt.c     | 4 +---
>  drivers/watchdog/octeon-wdt-nmi.S | 5 +----
>  drivers/watchdog/orion_wdt.c      | 4 +---
>  drivers/watchdog/rtd119x_wdt.c    | 2 +-
>  drivers/watchdog/sb_wdog.c        | 5 +----
>  drivers/watchdog/sbc_fitpc2_wdt.c | 4 +---
>  drivers/watchdog/ts4800_wdt.c     | 4 +---
>  drivers/watchdog/ts72xx_wdt.c     | 4 +---
>  12 files changed, 12 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
> index 38e26f160b9a57..f5d70842617fe9 100644
> --- a/drivers/watchdog/ep93xx_wdt.c
> +++ b/drivers/watchdog/ep93xx_wdt.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */

This was supposed to be a C++ style comment for C source files.
Has the rule changed ?

>  /*
>   * Watchdog driver for Cirrus Logic EP93xx family of devices.
>   *
> @@ -11,10 +12,6 @@
>   * Copyright (c) 2012 H Hartley Sweeten <hsweeten@visionengravers.com>
>   *	Convert to a platform device and use the watchdog framework API
>   *
> - * This file is licensed under the terms of the GNU General Public
> - * License version 2. This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
> - *
>   * This watchdog fires after 250msec, which is a too short interval
>   * for us to rely on the user space daemon alone. So we ping the
>   * wdt each ~200msec and eventually stop doing it if the user space
> diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
> index 4a22fe15208630..df03f3b2659a3e 100644
> --- a/drivers/watchdog/ibmasr.c
> +++ b/drivers/watchdog/ibmasr.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-1.0-or-later */
>  /*
>   * IBM Automatic Server Restart driver.
>   *
> @@ -6,8 +7,6 @@
>   * Based on driver written by Pete Reynolds.
>   * Copyright (c) IBM Corporation, 1998-2004.
>   *
> - * This software may be used and distributed according to the terms
> - * of the GNU Public License, incorporated herein by reference.
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> diff --git a/drivers/watchdog/m54xx_wdt.c b/drivers/watchdog/m54xx_wdt.c
> index f388a769dbd33d..9ca80b6c1790b6 100644
> --- a/drivers/watchdog/m54xx_wdt.c
> +++ b/drivers/watchdog/m54xx_wdt.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * drivers/watchdog/m54xx_wdt.c
>   *
> @@ -11,9 +12,6 @@
>   *  Copyright 2004 (c) MontaVista, Software, Inc.
>   *  Based on sa1100 driver, Copyright (C) 2000 Oleg Drokin <green@crimea.edu>
>   *
> - * This file is licensed under  the terms of the GNU General Public
> - * License version 2. This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
> index 9e1541cfae0d89..811f6dabad2c08 100644
> --- a/drivers/watchdog/max63xx_wdt.c
> +++ b/drivers/watchdog/max63xx_wdt.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * drivers/char/watchdog/max63xx_wdt.c
>   *
> @@ -5,10 +6,6 @@
>   *
>   * Copyright (C) 2009 Marc Zyngier <maz@misterjones.org>
>   *
> - * This file is licensed under the terms of the GNU General Public
> - * License version 2. This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
> - *
>   * This driver assumes the watchdog pins are memory mapped (as it is
>   * the case for the Arcom Zeus). Should it be connected over GPIOs or
>   * another interface, some abstraction will have to be introduced.
> diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
> index 6340a1f5f471b2..c87873c7d13f86 100644
> --- a/drivers/watchdog/moxart_wdt.c
> +++ b/drivers/watchdog/moxart_wdt.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * MOXA ART SoCs watchdog driver.
>   *
> @@ -5,9 +6,6 @@
>   *
>   * Jonas Jensen <jonas.jensen@gmail.com>
>   *
> - * This file is licensed under the terms of the GNU General Public
> - * License version 2.  This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
>   */
>  
>  #include <linux/clk.h>
> diff --git a/drivers/watchdog/octeon-wdt-nmi.S b/drivers/watchdog/octeon-wdt-nmi.S
> index 97f6eb7b5a8e04..e308cc74392018 100644
> --- a/drivers/watchdog/octeon-wdt-nmi.S
> +++ b/drivers/watchdog/octeon-wdt-nmi.S
> @@ -1,8 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */

The text below suggests that this should be GPL1+.

>  /*
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License.  See the file "COPYING" in the main directory of this archive
> - * for more details.
> - *
>   * Copyright (C) 2007-2017 Cavium, Inc.
>   */
>  #include <asm/asm.h>
> diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
> index 5ec2dd8fd5fa3d..938b357a12b911 100644
> --- a/drivers/watchdog/orion_wdt.c
> +++ b/drivers/watchdog/orion_wdt.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * drivers/watchdog/orion_wdt.c
>   *
> @@ -5,9 +6,6 @@
>   *
>   * Author: Sylver Bruneau <sylver.bruneau@googlemail.com>
>   *
> - * This file is licensed under  the terms of the GNU General Public
> - * License version 2. This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> diff --git a/drivers/watchdog/rtd119x_wdt.c b/drivers/watchdog/rtd119x_wdt.c
> index 95c8d7abce42e6..1c3c36e9779739 100644
> --- a/drivers/watchdog/rtd119x_wdt.c
> +++ b/drivers/watchdog/rtd119x_wdt.c
> @@ -1,9 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
>  /*
>   * Realtek RTD129x watchdog
>   *
>   * Copyright (c) 2017 Andreas Färber
>   *
> - * SPDX-License-Identifier: GPL-2.0+
>   */
>  
>  #include <linux/bitops.h>
> diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
> index 504be461f992a9..00b35eddf9395f 100644
> --- a/drivers/watchdog/sb_wdog.c
> +++ b/drivers/watchdog/sb_wdog.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-1.0 OR GPL-2.0 */
>  /*
>   * Watchdog driver for SiByte SB1 SoCs
>   *
> @@ -38,10 +39,6 @@
>   *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
>   *						All Rights Reserved.
>   *
> - *	This program is free software; you can redistribute it and/or
> - *	modify it under the terms of the GNU General Public License
> - *	version 1 or 2 as published by the Free Software Foundation.
> - *
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
> index 13db71e165836e..141fcbd11c4c82 100644
> --- a/drivers/watchdog/sbc_fitpc2_wdt.c
> +++ b/drivers/watchdog/sbc_fitpc2_wdt.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * Watchdog driver for SBC-FITPC2 board
>   *
> @@ -5,9 +6,6 @@
>   *
>   * Adapted from the IXP2000 watchdog driver by Deepak Saxena.
>   *
> - * This file is licensed under  the terms of the GNU General Public
> - * License version 2. This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt
> diff --git a/drivers/watchdog/ts4800_wdt.c b/drivers/watchdog/ts4800_wdt.c
> index 0ea554c7cda579..9d7d7ad876a788 100644
> --- a/drivers/watchdog/ts4800_wdt.c
> +++ b/drivers/watchdog/ts4800_wdt.c
> @@ -1,11 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * Watchdog driver for TS-4800 based boards
>   *
>   * Copyright (c) 2015 - Savoir-faire Linux
>   *
> - * This file is licensed under the terms of the GNU General Public
> - * License version 2. This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
>   */
>  
>  #include <linux/kernel.h>
> diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
> index bf918f5fa13175..bb53dc481006c9 100644
> --- a/drivers/watchdog/ts72xx_wdt.c
> +++ b/drivers/watchdog/ts72xx_wdt.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * Watchdog driver for Technologic Systems TS-72xx based SBCs
>   * (TS-7200, TS-7250 and TS-7260). These boards have external
> @@ -8,9 +9,6 @@
>   *
>   * This driver is based on ep93xx_wdt and wm831x_wdt drivers.
>   *
> - * This file is licensed under the terms of the GNU General Public
> - * License version 2. This program is licensed "as is" without any
> - * warranty of any kind, whether express or implied.
>   */
>  
>  #include <linux/platform_device.h>
> -- 
> An old man doll... just what I always wanted! - Clara
> 

