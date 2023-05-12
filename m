Return-Path: <netdev+bounces-2114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B2AC7004E6
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:08:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B6CE1C211D3
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4DEDF5A;
	Fri, 12 May 2023 10:07:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF2FD529
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:07:06 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AFA4488;
	Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64ab2a37812so3590333b3a.1;
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886023; x=1686478023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AL9Il3xQ6CcOjY3ofxhaiTscJ0l+n9RW4KfV/woDTZA=;
        b=DMMvY/OlryULJ1BsRWv608YtTpBMnrSEYIq8dTSmOlNMuGp1FaLFrNqLsPDVAlZngQ
         cLHN/7v1d14ia0i0e21UYajgLgiqnpssvLjXYb7sh/yVm38rkBfOnX1jx2IkvXfGIw3L
         bkwrXHw8mm45kPOy7hTGRpyBWETHoSnj+Mc3xNUfvxm0pQQu4gBvBQqx28prqLVMQ5KS
         z41T2YidLtroQll0sqgiDoyQ3ArFlMie+6xTgcYmrz16PAAne2HuAEsumeq9tiCBgNRl
         GOs1hg5elb4aWrY+w8sZoNEWshk0uPWp9mgnSJHhHsncCuP0JT08hNDVPFyrelHbmwtk
         sVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886023; x=1686478023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AL9Il3xQ6CcOjY3ofxhaiTscJ0l+n9RW4KfV/woDTZA=;
        b=em/yAw/HJpzT++28aotkW4yqKKz1shUqNggQS+NkdFqVR/r8zay7B8mdzhNEqDkDcL
         qm9ifaCQ1CBOYk8JE1ZOnpRE9Zw7ai8wFWC4eaULhcqxpPCUQTwGYTy9PZ6Xc20bOLd9
         rU2p2Men3ZIDve7qrSDpzMYUOrvZwH9YTxCavZ+RAhzud5VaZPU/SWTWkTqW7ujTozpW
         iwCU5CHY7cIJKkX8Kg8mq0IbTWb+GtFp+Fk9EeQABJdBcsoGWoWVf3FCupygNvR91BAO
         YWz/ifIu5SgNOMx2mQ9vUVl6pHRjtBraCwqTWDQVhBZAqOQ8H2ipMWfyEnecjE2VQUTo
         ujTg==
X-Gm-Message-State: AC+VfDxqcXwcbq5cD7iWwRCtepianqM+aPE9RA5pu42dfXE9XF2rSWDA
	oKr+u2dh19UlmuL/mghbFNQ=
X-Google-Smtp-Source: ACHHUZ58pt5RKTW1jgFFUUuwPBm8Sk/5pjjh3cUIE7+kVGxXJ3m21l4VtQSwLtJNG70EwPCR8dMLbQ==
X-Received: by 2002:a17:90a:744c:b0:246:9c75:351a with SMTP id o12-20020a17090a744c00b002469c75351amr27695257pjk.12.1683886023117;
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id o65-20020a634144000000b00502fd70b0bdsm6442447pga.52.2023.05.12.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 03:07:02 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 9C638106B31; Fri, 12 May 2023 17:06:55 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux SPDX Licenses <linux-spdx@vger.kernel.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>
Cc: Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	Philippe Ombredanne <pombredanne@nexb.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Jan Kara <jack@suse.com>,
	=?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Ray Lehtiniemi <rayl@mail.com>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Andrey Panin <pazke@donpac.ru>,
	Oleg Drokin <green@crimea.edu>,
	Marc Zyngier <maz@kernel.org>,
	Jonas Jensen <jonas.jensen@gmail.com>,
	Sylver Bruneau <sylver.bruneau@googlemail.com>,
	Andrew Sharp <andy.sharp@lsi.com>,
	Denis Turischev <denis@compulab.co.il>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Alan Cox <alan@linux.intel.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 08/10] drivers: watchdog: Replace GPL license notice with SPDX identifier
Date: Fri, 12 May 2023 17:06:19 +0700
Message-Id: <20230512100620.36807-9-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9335; i=bagasdotme@gmail.com; h=from:subject; bh=FKOXnccXkoNiIUxF9t4WxHzAEPq3ACwfo6jq+ieu+hM=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClx/DOZ2Hvet/74xLl6S+fz3AlXFrG8ttydv7Qiv4drY lxdWNDGjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEwk6xfDf4+WLV7PPBO5mOba v3i4SqpqT4rYvPU7z266XcDe+5pPRJ2R4VNeiWbssQsbNNJkZQVtWH/yH//yX2ldy47WZTbPN21 0YAMA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Many watchdog drivers's source files has already SPDX license
identifier, while some remaining doesn't.

Convert notices on remaining files to SPDX identifier. While at it,
also move SPDX identifier for drivers/watchdog/rtd119x_wdt.c to the
top of file (as in other files).

Cc: Ray Lehtiniemi <rayl@mail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrey Panin <pazke@donpac.ru>
Cc: Oleg Drokin <green@crimea.edu>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
Cc: Andrew Sharp <andy.sharp@lsi.com>
Cc: Denis Turischev <denis@compulab.co.il>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/watchdog/ep93xx_wdt.c     | 5 +----
 drivers/watchdog/ibmasr.c         | 3 +--
 drivers/watchdog/m54xx_wdt.c      | 4 +---
 drivers/watchdog/max63xx_wdt.c    | 5 +----
 drivers/watchdog/moxart_wdt.c     | 4 +---
 drivers/watchdog/octeon-wdt-nmi.S | 5 +----
 drivers/watchdog/orion_wdt.c      | 4 +---
 drivers/watchdog/rtd119x_wdt.c    | 2 +-
 drivers/watchdog/sb_wdog.c        | 5 +----
 drivers/watchdog/sbc_fitpc2_wdt.c | 4 +---
 drivers/watchdog/ts4800_wdt.c     | 4 +---
 drivers/watchdog/ts72xx_wdt.c     | 4 +---
 12 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index 38e26f160b9a57..59dfd7f6bf0ba1 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Watchdog driver for Cirrus Logic EP93xx family of devices.
  *
@@ -11,10 +12,6 @@
  * Copyright (c) 2012 H Hartley Sweeten <hsweeten@visionengravers.com>
  *	Convert to a platform device and use the watchdog framework API
  *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- *
  * This watchdog fires after 250msec, which is a too short interval
  * for us to rely on the user space daemon alone. So we ping the
  * wdt each ~200msec and eventually stop doing it if the user space
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 4a22fe15208630..6955c693b5fd00 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
 /*
  * IBM Automatic Server Restart driver.
  *
@@ -6,8 +7,6 @@
  * Based on driver written by Pete Reynolds.
  * Copyright (c) IBM Corporation, 1998-2004.
  *
- * This software may be used and distributed according to the terms
- * of the GNU Public License, incorporated herein by reference.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/watchdog/m54xx_wdt.c b/drivers/watchdog/m54xx_wdt.c
index f388a769dbd33d..062ea3e6497e52 100644
--- a/drivers/watchdog/m54xx_wdt.c
+++ b/drivers/watchdog/m54xx_wdt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * drivers/watchdog/m54xx_wdt.c
  *
@@ -11,9 +12,6 @@
  *  Copyright 2004 (c) MontaVista, Software, Inc.
  *  Based on sa1100 driver, Copyright (C) 2000 Oleg Drokin <green@crimea.edu>
  *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index 9e1541cfae0d89..21935f9620e463 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * drivers/char/watchdog/max63xx_wdt.c
  *
@@ -5,10 +6,6 @@
  *
  * Copyright (C) 2009 Marc Zyngier <maz@misterjones.org>
  *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
- *
  * This driver assumes the watchdog pins are memory mapped (as it is
  * the case for the Arcom Zeus). Should it be connected over GPIOs or
  * another interface, some abstraction will have to be introduced.
diff --git a/drivers/watchdog/moxart_wdt.c b/drivers/watchdog/moxart_wdt.c
index 6340a1f5f471b2..b7b1da3c932ded 100644
--- a/drivers/watchdog/moxart_wdt.c
+++ b/drivers/watchdog/moxart_wdt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * MOXA ART SoCs watchdog driver.
  *
@@ -5,9 +6,6 @@
  *
  * Jonas Jensen <jonas.jensen@gmail.com>
  *
- * This file is licensed under the terms of the GNU General Public
- * License version 2.  This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <linux/clk.h>
diff --git a/drivers/watchdog/octeon-wdt-nmi.S b/drivers/watchdog/octeon-wdt-nmi.S
index 97f6eb7b5a8e04..57bb0845de477d 100644
--- a/drivers/watchdog/octeon-wdt-nmi.S
+++ b/drivers/watchdog/octeon-wdt-nmi.S
@@ -1,8 +1,5 @@
+/* SPDX-License-Identifier: GPL-1.0+ */
 /*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
  * Copyright (C) 2007-2017 Cavium, Inc.
  */
 #include <asm/asm.h>
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 5ec2dd8fd5fa3d..1fe583e8a95b2e 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * drivers/watchdog/orion_wdt.c
  *
@@ -5,9 +6,6 @@
  *
  * Author: Sylver Bruneau <sylver.bruneau@googlemail.com>
  *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/watchdog/rtd119x_wdt.c b/drivers/watchdog/rtd119x_wdt.c
index 95c8d7abce42e6..984905695dde51 100644
--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -1,9 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * Realtek RTD129x watchdog
  *
  * Copyright (c) 2017 Andreas Färber
  *
- * SPDX-License-Identifier: GPL-2.0+
  */
 
 #include <linux/bitops.h>
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 504be461f992a9..822bf8905bf3ce 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
 /*
  * Watchdog driver for SiByte SB1 SoCs
  *
@@ -38,10 +39,6 @@
  *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *						All Rights Reserved.
  *
- *	This program is free software; you can redistribute it and/or
- *	modify it under the terms of the GNU General Public License
- *	version 1 or 2 as published by the Free Software Foundation.
- *
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index 13db71e165836e..b8eb8d5ca1af0c 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Watchdog driver for SBC-FITPC2 board
  *
@@ -5,9 +6,6 @@
  *
  * Adapted from the IXP2000 watchdog driver by Deepak Saxena.
  *
- * This file is licensed under  the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME " WATCHDOG: " fmt
diff --git a/drivers/watchdog/ts4800_wdt.c b/drivers/watchdog/ts4800_wdt.c
index 0ea554c7cda579..0099403f49922f 100644
--- a/drivers/watchdog/ts4800_wdt.c
+++ b/drivers/watchdog/ts4800_wdt.c
@@ -1,11 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Watchdog driver for TS-4800 based boards
  *
  * Copyright (c) 2015 - Savoir-faire Linux
  *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index bf918f5fa13175..3d57670befe1ce 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * Watchdog driver for Technologic Systems TS-72xx based SBCs
  * (TS-7200, TS-7250 and TS-7260). These boards have external
@@ -8,9 +9,6 @@
  *
  * This driver is based on ep93xx_wdt and wm831x_wdt drivers.
  *
- * This file is licensed under the terms of the GNU General Public
- * License version 2. This program is licensed "as is" without any
- * warranty of any kind, whether express or implied.
  */
 
 #include <linux/platform_device.h>
-- 
An old man doll... just what I always wanted! - Clara


