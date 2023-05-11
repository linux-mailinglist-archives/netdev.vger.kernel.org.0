Return-Path: <netdev+bounces-1801-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2CEC6FF2FC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA7E91C208F2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C2017739;
	Thu, 11 May 2023 13:34:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F681F92C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:30 +0000 (UTC)
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DA110E6C;
	Thu, 11 May 2023 06:34:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-24ded4b33d7so5964086a91.3;
        Thu, 11 May 2023 06:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812055; x=1686404055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZJgd1J/yhpIEPxETlLE5U9uKTj61DHL8mLsf2B7J04=;
        b=Q38OyEzdg7CS9Wc8ZD+5BjNcaWS8Kgar4wv+xF8w2kPAsi+UnKgNrxIPWyFqu+pygN
         fqUCBrp1eBV6DtqXgW0Xrj4jd+zRIeDvYV0EawaP9XMEyATr4wgrGme4cJFUNf64Q6eW
         r1zY7p/scMzGLYZ2wGk50v9xUheiQXvt2GOA0FcVkJvGV4Xk69hSTQk+JGIZrucEcUVb
         nolWl/a1D1x8tFuYyjtotwArb2yPA3B/U1LcPkQWBw7P2YQu2hoCg4zq0nY2XXrC+pmg
         KHcWpE8OkXXhV3Q3TBUCMa0JO71tRnfrjM4Mfvt6GzLGfLQ+BMuD/fWVFfaajnhMgVPf
         W5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812055; x=1686404055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZJgd1J/yhpIEPxETlLE5U9uKTj61DHL8mLsf2B7J04=;
        b=begEJt0zLw7yiqzW/E3mJppMUk+X2zgOhLALjlnN3Z3cWHFUyFkl9AoPCkQAjsImKP
         Ig/owBDx7xrKfvCAUYVwJ0hyPo3qQAUwW9U1olSC6mpz2ZKyr5Z62kUIltVM+irWGocz
         GOCTqlFRxo2bPqhHcAjW4z/ei0xzntnM1m+AmquZarWOvy9owHOcMukKshHON8ViPbdS
         CfKOi4Xs10HvdmzfzDkhPOpG85yFYiMpPC5QOlk9ZUSRMj4F10ULfFKmoBHdoCQCNJM9
         829JiqtIci/ejrwJAJ8jWh4XrIgY7aBGJUwpVEVYSYkTmqx94fOFDoOHGxxmGgwgWzlL
         XEmQ==
X-Gm-Message-State: AC+VfDyQp16vM23TqEtzdORIRr7yCn4HIPFFxv8fiFZ885dsc6tiJjQa
	BSWh1Wdpm8SjqEhRJ49sTq8=
X-Google-Smtp-Source: ACHHUZ5jN/0ts75KhdoLwqc2irXOTUrehxCBlN6tUqbiPb++pl8Az5O3mDzXUIR5ZNe60Nm8ernISA==
X-Received: by 2002:a17:90b:1103:b0:250:6c76:fd9b with SMTP id gi3-20020a17090b110300b002506c76fd9bmr15464060pjb.38.1683812055308;
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id jb4-20020a170903258400b001aaf6353736sm5896810plb.80.2023.05.11.06.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A66971037B5; Thu, 11 May 2023 20:34:10 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>
Cc: Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
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
	Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>,
	Archana <craechal@gmail.com>,
	"David A . Hinds" <dahinds@users.sourceforge.net>,
	Donald Becker <becker@scyld.com>,
	Peter De Schrijver <p2@mind.be>,
	Greg Ungerer <gerg@linux-m68k.org>
Subject: [PATCH 04/10] net: ethernet: 8390: Replace GPL boilerplate with SPDX identifier
Date: Thu, 11 May 2023 20:34:00 +0700
Message-Id: <20230511133406.78155-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12216; i=bagasdotme@gmail.com; h=from:subject; bh=Qt/i4eQgMuIgsiTGQ80teX3SuDZ7RNq5Fn4UY3gpc7Y=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx745vV5y/9MIL7u/LGNt8FT1ffft1Nv5E7vXolzbbB b8K1l3e21HKwiDGxSArpsgyKZGv6fQuI5EL7WsdYeawMoEMYeDiFICJbOBg+MMVwa8SLHJm3tvd V03W3uNbF1Y/YVWLyJWW/ybV7Tv1WDQZGfYdm79lD+/OhTX2rHf7/l8ziJAJNRb7fo3nyox+U72 1s3gA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace GPL boilerplate notice on remaining files with appropriate SPDX
tag. For files mentioning COPYING, use GPL 2.0; otherwise GPL 1.0+.

Cc: David A. Hinds <dahinds@users.sourceforge.net>
Cc: Donald Becker <becker@scyld.com>
Cc: Peter De Schrijver <p2@mind.be>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/net/ethernet/8390/8390.h      | 2 ++
 drivers/net/ethernet/8390/apne.c      | 7 +------
 drivers/net/ethernet/8390/axnet_cs.c  | 6 +++---
 drivers/net/ethernet/8390/hydra.c     | 6 ++----
 drivers/net/ethernet/8390/lib8390.c   | 5 ++---
 drivers/net/ethernet/8390/mac8390.c   | 6 ++----
 drivers/net/ethernet/8390/mcf8390.c   | 4 +---
 drivers/net/ethernet/8390/ne.c        | 4 +---
 drivers/net/ethernet/8390/ne2k-pci.c  | 8 +-------
 drivers/net/ethernet/8390/pcnet_cs.c  | 5 ++---
 drivers/net/ethernet/8390/smc-ultra.c | 4 +---
 drivers/net/ethernet/8390/stnic.c     | 5 +----
 drivers/net/ethernet/8390/wd.c        | 4 +---
 drivers/net/ethernet/8390/zorro8390.c | 7 +------
 14 files changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/8390.h
index e5226446599884..b0e3df9779ddbb 100644
--- a/drivers/net/ethernet/8390/8390.h
+++ b/drivers/net/ethernet/8390/8390.h
@@ -1,3 +1,5 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
+
 /* Generic NS8390 register definitions. */
 
 /* This file is part of Donald Becker's 8390 drivers, and is distributed
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index 991ad953aa7906..ef1f40e8801ccc 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * Amiga Linux/68k 8390 based PCMCIA Ethernet Driver for the Amiga 1200
  *
@@ -19,12 +20,6 @@
  *
  * ----------------------------------------------------------------------------
  *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file COPYING in the main directory of the Linux
- * distribution for more details.
- *
- * ----------------------------------------------------------------------------
- *
  */
 
 
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index 78f985885547ea..937485fa87825a 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -1,3 +1,5 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
+
 /*======================================================================
 
     A PCMCIA ethernet driver for Asix AX88190-based cards
@@ -17,9 +19,7 @@
 
     Written 1992,1993 by Donald Becker.
     Copyright 1993 United States Government as represented by the
-    Director, National Security Agency.  This software may be used and
-    distributed according to the terms of the GNU General Public License,
-    incorporated herein by reference.
+    Director, National Security Agency.
     Donald Becker may be reached at becker@scyld.com
 
 ======================================================================*/
diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/8390/hydra.c
index 1df7601af86a40..9fae05dd12a3e3 100644
--- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -1,10 +1,8 @@
+/* SPDX-License-Identifier: GPL-1.0-only */
+
 /* New Hydra driver using generic 8390 core */
 /* Based on old hydra driver by Topi Kanerva (topi@susanna.oulu.fi) */
 
-/* This file is subject to the terms and conditions of the GNU General      */
-/* Public License.  See the file COPYING in the main directory of the       */
-/* Linux distribution for more details.                                     */
-
 /* Peter De Schrijver (p2@mind.be) */
 /* Oldenburg 2000 */
 
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
index e84021282edf30..14ab1e4d9a5c36 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -1,3 +1,5 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
+
 /* 8390.c: A general NS8390 ethernet driver core for linux. */
 /*
 	Written 1992-94 by Donald Becker.
@@ -5,9 +7,6 @@
 	Copyright 1993 United States Government as represented by the
 	Director, National Security Agency.
 
-	This software may be used and distributed according to the terms
-	of the GNU General Public License, incorporated herein by reference.
-
 	The author may be reached as becker@scyld.com, or C/O
 	Scyld Computing Corporation
 	410 Severn Ave., Suite 210
diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index 7fb819b9b89a5b..e09f0f20516593 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /* mac8390.c: New driver for 8390-based Nubus (or Nubus-alike)
    Ethernet cards on Linux */
 /* Based on the former daynaport.c driver, by Alan Cox.  Some code
    taken from or inspired by skeleton.c by Donald Becker, acenic.c by
-   Jes Sorensen, and ne2k-pci.c by Donald Becker and Paul Gortmaker.
-
-   This software may be used and distributed according to the terms of
-   the GNU Public License, incorporated herein by reference.  */
+   Jes Sorensen, and ne2k-pci.c by Donald Becker and Paul Gortmaker. */
 
 /* 2000-02-28: support added for Dayna and Kinetics cards by
    A.G.deWijn@phys.uu.nl */
diff --git a/drivers/net/ethernet/8390/mcf8390.c b/drivers/net/ethernet/8390/mcf8390.c
index 8a7918d3341965..e2dbc4b858c658 100644
--- a/drivers/net/ethernet/8390/mcf8390.c
+++ b/drivers/net/ethernet/8390/mcf8390.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Support for ColdFire CPU based boards using a NS8390 Ethernet device.
  *
@@ -5,9 +6,6 @@
  *
  *  (C) Copyright 2012,  Greg Ungerer <gerg@uclinux.org>
  *
- *  This file is subject to the terms and conditions of the GNU General Public
- *  License.  See the file COPYING in the main directory of the Linux
- *  distribution for more details.
  */
 
 #include <linux/module.h>
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index 0a9118b8be0c64..053c7cf201b27f 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /* ne.c: A general non-shared-memory NS8390 ethernet driver for linux. */
 /*
     Written 1992-94 by Donald Becker.
@@ -5,9 +6,6 @@
     Copyright 1993 United States Government as represented by the
     Director, National Security Agency.
 
-    This software may be used and distributed according to the terms
-    of the GNU General Public License, incorporated herein by reference.
-
     The author may be reached as becker@scyld.com, or C/O
     Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD 21403
 
diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8390/ne2k-pci.c
index 6a0a2039600a0a..01348d6ff47820 100644
--- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /* A Linux device driver for PCI NE2000 clones.
  *
  * Authors and other copyright holders:
@@ -6,13 +7,6 @@
  * Copyright 1993 assigned to the United States Government as represented
  * by the Director, National Security Agency.
  *
- * This software may be used and distributed according to the terms of
- * the GNU General Public License (GPL), incorporated herein by reference.
- * Drivers based on or derived from this code fall under the GPL and must
- * retain the authorship, copyright and license notice.  This file is not
- * a complete program and may only be used when the entire operating
- * system is licensed under the GPL.
- *
  * The author may be reached as becker@scyld.com, or C/O
  * Scyld Computing Corporation
  * 410 Severn Ave., Suite 210
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index 0f07fe03da98c8..0512472cf7800c 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*======================================================================
 
     A PCMCIA ethernet driver for NS8390-based cards
@@ -17,9 +18,7 @@
 
     Written 1992,1993 by Donald Becker.
     Copyright 1993 United States Government as represented by the
-    Director, National Security Agency.  This software may be used and
-    distributed according to the terms of the GNU General Public License,
-    incorporated herein by reference.
+    Director, National Security Agency.
     Donald Becker may be reached at becker@scyld.com
 
     Based also on Keith Moore's changes to Don Becker's code, for IBM
diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 6e62c37c940056..deb869995eabf6 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /* smc-ultra.c: A SMC Ultra ethernet driver for linux. */
 /*
 	This is a driver for the SMC Ultra and SMC EtherEZ ISA ethercards.
@@ -7,9 +8,6 @@
 	Copyright 1993 United States Government as represented by the
 	Director, National Security Agency.
 
-	This software may be used and distributed according to the terms
-	of the GNU General Public License, incorporated herein by reference.
-
 	The author may be reached as becker@scyld.com, or C/O
 	Scyld Computing Corporation
 	410 Severn Ave., Suite 210
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
index bd89ca8a92dfbc..31945bae451989 100644
--- a/drivers/net/ethernet/8390/stnic.c
+++ b/drivers/net/ethernet/8390/stnic.c
@@ -1,8 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /* stnic.c : A SH7750 specific part of driver for NS DP83902A ST-NIC.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
  *
  * Copyright (C) 1999 kaz Kojima
  */
diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index 5b00c452bede64..6ecd63b8f8976e 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /* wd.c: A WD80x3 ethernet driver for linux. */
 /*
 	Written 1993-94 by Donald Becker.
@@ -5,9 +6,6 @@
 	Copyright 1993 United States Government as represented by the
 	Director, National Security Agency.
 
-	This software may be used and distributed according to the terms
-	of the GNU General Public License, incorporated herein by reference.
-
 	The author may be reached as becker@scyld.com, or C/O
 	Scyld Computing Corporation
 	410 Severn Ave., Suite 210
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/8390/zorro8390.c
index e8b4fe813a0828..e6abb22c82b514 100644
--- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  *  Amiga Linux/m68k and Linux/PPC Zorro NS8390 Ethernet Driver
  *
@@ -9,12 +10,6 @@
  *
  *  ---------------------------------------------------------------------------
  *
- *  This file is subject to the terms and conditions of the GNU General Public
- *  License.  See the file COPYING in the main directory of the Linux
- *  distribution for more details.
- *
- *  ---------------------------------------------------------------------------
- *
  *  The Ariadne II and X-Surf are Zorro-II boards containing Realtek RTL8019AS
  *  Ethernet Controllers.
  */
-- 
An old man doll... just what I always wanted! - Clara


