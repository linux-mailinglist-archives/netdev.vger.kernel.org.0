Return-Path: <netdev+bounces-2117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2D9B7004E9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:09:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBE7E1C211D1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3911078B;
	Fri, 12 May 2023 10:07:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D41078A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:07:09 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE156A67;
	Fri, 12 May 2023 03:07:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-643b7b8f8ceso5229311b3a.1;
        Fri, 12 May 2023 03:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886023; x=1686478023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLwt+CeOi+feKhP3mxJBkHvUBLpCwmKqo12nuDQlmGI=;
        b=qgyxmQu4AqzenRnGSj2QJapIczPViuUs3eDEvRgPLsQq6KcC9RPEEiNYaOWYX6VuSH
         HVb7RublizUABGOViGtjrD5WF0xoTgRug81+djSEWQMzGmP0sm3RJQLL7I6O1fjgdhj6
         ThGA1iaips6fsvC17PSmA+qu1QL8dUIUlVqqTEM+o1LTdJUqUdn+X84+TgL9nf3Mmbc7
         3aWVVTem3u91zRau+28yZyOlUSbdWNFPPny4PchQ03TCU3kIei8wsAqxxYJxw7IbH1PR
         qXU7kg4x655r4cEYsl4hqicvR63aTM4yxeMl6qtXJl99t0h3M3SsAwXzGLawRP2b4X4y
         svFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886023; x=1686478023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hLwt+CeOi+feKhP3mxJBkHvUBLpCwmKqo12nuDQlmGI=;
        b=HJtgZAtp0mi4XNhdZZUnxQmD7mhK4+Z7DDpDyfRBNEZWjcOwZm6ye2u+pp+O6LTIgD
         m8J4/9rqZP025P/0Flkt9HL+XmMunITMTUFEPyp4f0iqH2ca6Sxw4A8l1juV5j0TC8fx
         FUL9i3t6vpHhs6ICyOwQCrrRNQOrw16FNy/mRV5AgHDUo7Gk038p92e7d1bVDScu0Wqs
         NDKT4FWBk3o2+AuYIaH06DDz1QL8GWlc3xh8h1qZuwthS6QgTMf1kN5vnUt0NOzk3T+N
         wLH9jXQxpCt3IqeLun5aj5AH36LrwInwSmcrNg177j7QSpWyJu3sja35sBk7OhvBaDiJ
         8gxw==
X-Gm-Message-State: AC+VfDwNAHWPW5XFcPAjzh7ZNhSyj4ul8RlRDlO46irqQQQHovd2VfoG
	ZAXGfMGbdAZKZ2Mq96GCV7Y=
X-Google-Smtp-Source: ACHHUZ6Sp8tsGaI+fnUKzA6eZvWlfSweSeEvTzWl5Fskx8nhQ74cWrmbE1ra7yOUWC92rkJZwj6nDA==
X-Received: by 2002:a05:6a20:3d16:b0:101:5ef3:1a02 with SMTP id y22-20020a056a203d1600b001015ef31a02mr14868433pzi.7.1683886023329;
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id j20-20020aa78d14000000b0063d375ca0cbsm6685664pfe.151.2023.05.12.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 03:07:02 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id D3A51106B41; Fri, 12 May 2023 17:06:55 +0700 (WIB)
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
	Maxime Bizon <mbizon@freebox.fr>,
	"David A . Hinds" <dahinds@users.sourceforge.net>,
	"John G . Dorsey" <john+@cs.cmu.edu>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 06/10] pcmcia: Add SPDX identifier
Date: Fri, 12 May 2023 17:06:17 +0700
Message-Id: <20230512100620.36807-7-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=28406; i=bagasdotme@gmail.com; h=from:subject; bh=KNBVlfWKS31v1GfrqNdl9eVn/phaf57sc0J+WugtBcg=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClx/DPW7zzzQpvt1f4XAvMLzM0eyl/KZVHdpGxxi8fnv /C99KeOHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZiIZwDDPzOVT8c0d8i9ud+/ eMbGGc3KC35PPnl7XnHRjK6EDxlB2zoYGX4o/Smxjfm8eQv3X3kO+Y2BrlyzVsw6mr1YZNfC+Gs SOswA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add SPDX identifier on remaining files untouched during previous
rounds of SPDX conversion while replacing boilerplate notice if any.

Cc: Maxime Bizon <mbizon@freebox.fr>
Cc: David A. Hinds <dahinds@users.sourceforge.net>
Cc: John G. Dorsey <john+@cs.cmu.edu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/pcmcia/bcm63xx_pcmcia.c |  5 +----
 drivers/pcmcia/cirrus.h         | 21 +--------------------
 drivers/pcmcia/i82365.c         | 22 +---------------------
 drivers/pcmcia/i82365.h         | 21 +--------------------
 drivers/pcmcia/o2micro.h        | 21 +--------------------
 drivers/pcmcia/pd6729.c         |  3 +--
 drivers/pcmcia/pxa2xx_base.h    |  1 +
 drivers/pcmcia/ricoh.h          | 21 +--------------------
 drivers/pcmcia/sa1100_generic.c | 22 +---------------------
 drivers/pcmcia/sa11xx_base.c    | 22 +---------------------
 drivers/pcmcia/sa11xx_base.h    | 22 +---------------------
 drivers/pcmcia/soc_common.c     | 22 +---------------------
 drivers/pcmcia/tcic.c           | 22 +---------------------
 drivers/pcmcia/tcic.h           | 21 +--------------------
 drivers/pcmcia/ti113x.h         | 21 +--------------------
 drivers/pcmcia/topic.h          | 23 +----------------------
 drivers/pcmcia/vg468.h          | 21 +--------------------
 17 files changed, 17 insertions(+), 294 deletions(-)

diff --git a/drivers/pcmcia/bcm63xx_pcmcia.c b/drivers/pcmcia/bcm63xx_pcmcia.c
index dd3c2609904877..0564bcabf85dc9 100644
--- a/drivers/pcmcia/bcm63xx_pcmcia.c
+++ b/drivers/pcmcia/bcm63xx_pcmcia.c
@@ -1,8 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
  * Copyright (C) 2008 Maxime Bizon <mbizon@freebox.fr>
  */
 
diff --git a/drivers/pcmcia/cirrus.h b/drivers/pcmcia/cirrus.h
index 446a4576e73e6c..8d3a256c97a087 100644
--- a/drivers/pcmcia/cirrus.h
+++ b/drivers/pcmcia/cirrus.h
@@ -1,30 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * cirrus.h 1.4 1999/10/25 20:03:34
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
  */
 
 #ifndef _LINUX_CIRRUS_H
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 891ccea2cccb0a..a7b50c7201215f 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -1,34 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1
 /*======================================================================
 
     Device driver for Intel 82365 and compatible PC Card controllers.
 
     i82365.c 1.265 1999/11/10 18:36:21
 
-    The contents of this file are subject to the Mozilla Public
-    License Version 1.1 (the "License"); you may not use this file
-    except in compliance with the License. You may obtain a copy of
-    the License at http://www.mozilla.org/MPL/
-
-    Software distributed under the License is distributed on an "AS
-    IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-    implied. See the License for the specific language governing
-    rights and limitations under the License.
-
     The initial developer of the original code is David A. Hinds
     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
     are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
 
-    Alternatively, the contents of this file may be used under the
-    terms of the GNU General Public License version 2 (the "GPL"), in which
-    case the provisions of the GPL are applicable instead of the
-    above.  If you wish to allow the use of your version of this file
-    only under the terms of the GPL and not to allow others to use
-    your version of this file under the MPL, indicate your decision
-    by deleting the provisions above and replace them with the notice
-    and other provisions required by the GPL.  If you do not delete
-    the provisions above, a recipient may use your version of this
-    file under either the MPL or the GPL.
-    
 ======================================================================*/
 
 #include <linux/module.h>
diff --git a/drivers/pcmcia/i82365.h b/drivers/pcmcia/i82365.h
index 3f84d7a2dc84fa..5501001c7dd8ab 100644
--- a/drivers/pcmcia/i82365.h
+++ b/drivers/pcmcia/i82365.h
@@ -1,30 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * i82365.h 1.15 1999/10/25 20:03:34
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
  */
 
 #ifndef _LINUX_I82365_H
diff --git a/drivers/pcmcia/o2micro.h b/drivers/pcmcia/o2micro.h
index 5096e92c7a4cfb..8b828c0932950c 100644
--- a/drivers/pcmcia/o2micro.h
+++ b/drivers/pcmcia/o2micro.h
@@ -1,30 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * o2micro.h 1.13 1999/10/25 20:03:34
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
  */
 
 #ifndef _LINUX_O2MICRO_H
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index a0a2e7f18356c5..d6a28fa6da840b 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: GPL-1.0+
 /*
  * Driver for the Cirrus PD6729 PCI-PCMCIA bridge.
  *
  * Based on the i82092.c driver.
  *
- * This software may be used and distributed according to the terms of
- * the GNU General Public License, incorporated herein by reference.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/pcmcia/pxa2xx_base.h b/drivers/pcmcia/pxa2xx_base.h
index e58c7a41541880..9583d08983f5cd 100644
--- a/drivers/pcmcia/pxa2xx_base.h
+++ b/drivers/pcmcia/pxa2xx_base.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 int pxa2xx_drv_pcmcia_add_one(struct soc_pcmcia_socket *skt);
 void pxa2xx_drv_pcmcia_ops(struct pcmcia_low_level *ops);
 void pxa2xx_configure_sockets(struct device *dev, struct pcmcia_low_level *ops);
diff --git a/drivers/pcmcia/ricoh.h b/drivers/pcmcia/ricoh.h
index 8ac7b138c09486..f037169f6108f7 100644
--- a/drivers/pcmcia/ricoh.h
+++ b/drivers/pcmcia/ricoh.h
@@ -1,30 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * ricoh.h 1.9 1999/10/25 20:03:34
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
  */
 
 #ifndef _LINUX_RICOH_H
diff --git a/drivers/pcmcia/sa1100_generic.c b/drivers/pcmcia/sa1100_generic.c
index 89d4ba58c89135..9ec190ab29a89e 100644
--- a/drivers/pcmcia/sa1100_generic.c
+++ b/drivers/pcmcia/sa1100_generic.c
@@ -1,33 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1
 /*======================================================================
 
     Device driver for the PCMCIA control functionality of StrongARM
     SA-1100 microprocessors.
 
-    The contents of this file are subject to the Mozilla Public
-    License Version 1.1 (the "License"); you may not use this file
-    except in compliance with the License. You may obtain a copy of
-    the License at http://www.mozilla.org/MPL/
-
-    Software distributed under the License is distributed on an "AS
-    IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-    implied. See the License for the specific language governing
-    rights and limitations under the License.
-
     The initial developer of the original code is John G. Dorsey
     <john+@cs.cmu.edu>.  Portions created by John G. Dorsey are
     Copyright (C) 1999 John G. Dorsey.  All Rights Reserved.
 
-    Alternatively, the contents of this file may be used under the
-    terms of the GNU Public License version 2 (the "GPL"), in which
-    case the provisions of the GPL are applicable instead of the
-    above.  If you wish to allow the use of your version of this file
-    only under the terms of the GPL and not to allow others to use
-    your version of this file under the MPL, indicate your decision
-    by deleting the provisions above and replace them with the notice
-    and other provisions required by the GPL.  If you do not delete
-    the provisions above, a recipient may use your version of this
-    file under either the MPL or the GPL.
-    
 ======================================================================*/
 
 #include <linux/module.h>
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index 48140ac73ed632..3e9b3b0c9b0817 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -1,33 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1
 /*======================================================================
 
     Device driver for the PCMCIA control functionality of StrongARM
     SA-1100 microprocessors.
 
-    The contents of this file are subject to the Mozilla Public
-    License Version 1.1 (the "License"); you may not use this file
-    except in compliance with the License. You may obtain a copy of
-    the License at http://www.mozilla.org/MPL/
-
-    Software distributed under the License is distributed on an "AS
-    IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-    implied. See the License for the specific language governing
-    rights and limitations under the License.
-
     The initial developer of the original code is John G. Dorsey
     <john+@cs.cmu.edu>.  Portions created by John G. Dorsey are
     Copyright (C) 1999 John G. Dorsey.  All Rights Reserved.
 
-    Alternatively, the contents of this file may be used under the
-    terms of the GNU Public License version 2 (the "GPL"), in which
-    case the provisions of the GPL are applicable instead of the
-    above.  If you wish to allow the use of your version of this file
-    only under the terms of the GPL and not to allow others to use
-    your version of this file under the MPL, indicate your decision
-    by deleting the provisions above and replace them with the notice
-    and other provisions required by the GPL.  If you do not delete
-    the provisions above, a recipient may use your version of this
-    file under either the MPL or the GPL.
-
 ======================================================================*/
 
 #include <linux/module.h>
diff --git a/drivers/pcmcia/sa11xx_base.h b/drivers/pcmcia/sa11xx_base.h
index 3d76d720f463de..c2dbdc5495f78e 100644
--- a/drivers/pcmcia/sa11xx_base.h
+++ b/drivers/pcmcia/sa11xx_base.h
@@ -1,33 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*======================================================================
 
     Device driver for the PCMCIA control functionality of StrongARM
     SA-1100 microprocessors.
 
-    The contents of this file are subject to the Mozilla Public
-    License Version 1.1 (the "License"); you may not use this file
-    except in compliance with the License. You may obtain a copy of
-    the License at http://www.mozilla.org/MPL/
-
-    Software distributed under the License is distributed on an "AS
-    IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-    implied. See the License for the specific language governing
-    rights and limitations under the License.
-
     The initial developer of the original code is John G. Dorsey
     <john+@cs.cmu.edu>.  Portions created by John G. Dorsey are
     Copyright (C) 1999 John G. Dorsey.  All Rights Reserved.
 
-    Alternatively, the contents of this file may be used under the
-    terms of the GNU Public License version 2 (the "GPL"), in which
-    case the provisions of the GPL are applicable instead of the
-    above.  If you wish to allow the use of your version of this file
-    only under the terms of the GPL and not to allow others to use
-    your version of this file under the MPL, indicate your decision
-    by deleting the provisions above and replace them with the notice
-    and other provisions required by the GPL.  If you do not delete
-    the provisions above, a recipient may use your version of this
-    file under either the MPL or the GPL.
-
 ======================================================================*/
 
 #if !defined(_PCMCIA_SA1100_H)
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index 61b0c8952bb5e0..8b035367fd4268 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -1,33 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1
 /*======================================================================
 
     Common support code for the PCMCIA control functionality of
     integrated SOCs like the SA-11x0 and PXA2xx microprocessors.
 
-    The contents of this file are subject to the Mozilla Public
-    License Version 1.1 (the "License"); you may not use this file
-    except in compliance with the License. You may obtain a copy of
-    the License at http://www.mozilla.org/MPL/
-
-    Software distributed under the License is distributed on an "AS
-    IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-    implied. See the License for the specific language governing
-    rights and limitations under the License.
-
     The initial developer of the original code is John G. Dorsey
     <john+@cs.cmu.edu>.  Portions created by John G. Dorsey are
     Copyright (C) 1999 John G. Dorsey.  All Rights Reserved.
 
-    Alternatively, the contents of this file may be used under the
-    terms of the GNU Public License version 2 (the "GPL"), in which
-    case the provisions of the GPL are applicable instead of the
-    above.  If you wish to allow the use of your version of this file
-    only under the terms of the GPL and not to allow others to use
-    your version of this file under the MPL, indicate your decision
-    by deleting the provisions above and replace them with the notice
-    and other provisions required by the GPL.  If you do not delete
-    the provisions above, a recipient may use your version of this
-    file under either the MPL or the GPL.
-
 ======================================================================*/
 
 
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index 1a0e3f0987599d..a5fca2d14c1257 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -1,34 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1
 /*======================================================================
 
     Device driver for Databook TCIC-2 PCMCIA controller
 
     tcic.c 1.111 2000/02/15 04:13:12
 
-    The contents of this file are subject to the Mozilla Public
-    License Version 1.1 (the "License"); you may not use this file
-    except in compliance with the License. You may obtain a copy of
-    the License at http://www.mozilla.org/MPL/
-
-    Software distributed under the License is distributed on an "AS
-    IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-    implied. See the License for the specific language governing
-    rights and limitations under the License.
-
     The initial developer of the original code is David A. Hinds
     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
     are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
 
-    Alternatively, the contents of this file may be used under the
-    terms of the GNU General Public License version 2 (the "GPL"), in which
-    case the provisions of the GPL are applicable instead of the
-    above.  If you wish to allow the use of your version of this file
-    only under the terms of the GPL and not to allow others to use
-    your version of this file under the MPL, indicate your decision
-    by deleting the provisions above and replace them with the notice
-    and other provisions required by the GPL.  If you do not delete
-    the provisions above, a recipient may use your version of this
-    file under either the MPL or the GPL.
-    
 ======================================================================*/
 
 #include <linux/module.h>
diff --git a/drivers/pcmcia/tcic.h b/drivers/pcmcia/tcic.h
index 2c0b8f65ad6c6f..aff1e65fc69032 100644
--- a/drivers/pcmcia/tcic.h
+++ b/drivers/pcmcia/tcic.h
@@ -1,30 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * tcic.h 1.13 1999/10/25 20:03:34
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
  */
 
 #ifndef _LINUX_TCIC_H
diff --git a/drivers/pcmcia/ti113x.h b/drivers/pcmcia/ti113x.h
index 5cb670e037a0c6..a65ab56551ee93 100644
--- a/drivers/pcmcia/ti113x.h
+++ b/drivers/pcmcia/ti113x.h
@@ -1,30 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * ti113x.h 1.16 1999/10/25 20:03:34
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
  */
 
 #ifndef _LINUX_TI113X_H
diff --git a/drivers/pcmcia/topic.h b/drivers/pcmcia/topic.h
index 582688fe750540..d1ad01abab13f4 100644
--- a/drivers/pcmcia/topic.h
+++ b/drivers/pcmcia/topic.h
@@ -1,31 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * topic.h 1.8 1999/08/28 04:01:47
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
- * topic.h $Release$ 1999/08/28 04:01:47
  */
 
 #ifndef _LINUX_TOPIC_H
diff --git a/drivers/pcmcia/vg468.h b/drivers/pcmcia/vg468.h
index 88c2b487f675fc..c582fc8086c26d 100644
--- a/drivers/pcmcia/vg468.h
+++ b/drivers/pcmcia/vg468.h
@@ -1,30 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR MPL-1.1 */
 /*
  * vg468.h 1.11 1999/10/25 20:03:34
  *
- * The contents of this file are subject to the Mozilla Public License
- * Version 1.1 (the "License"); you may not use this file except in
- * compliance with the License. You may obtain a copy of the License
- * at http://www.mozilla.org/MPL/
- *
- * Software distributed under the License is distributed on an "AS IS"
- * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
- * the License for the specific language governing rights and
- * limitations under the License. 
- *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
- * Alternatively, the contents of this file may be used under the
- * terms of the GNU General Public License version 2 (the "GPL"), in which
- * case the provisions of the GPL are applicable instead of the
- * above.  If you wish to allow the use of your version of this file
- * only under the terms of the GPL and not to allow others to use
- * your version of this file under the MPL, indicate your decision by
- * deleting the provisions above and replace them with the notice and
- * other provisions required by the GPL.  If you do not delete the
- * provisions above, a recipient may use your version of this file
- * under either the MPL or the GPL.
  */
 
 #ifndef _LINUX_VG468_H
-- 
An old man doll... just what I always wanted! - Clara


