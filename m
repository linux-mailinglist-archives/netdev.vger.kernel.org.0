Return-Path: <netdev+bounces-2119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59D627004EC
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:10:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 991E8281B85
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40F0A107A6;
	Fri, 12 May 2023 10:07:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0491078A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:07:12 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5087210FA;
	Fri, 12 May 2023 03:07:05 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6436dfa15b3so6547618b3a.1;
        Fri, 12 May 2023 03:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886024; x=1686478024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWGvLME6XjQ0tFUnKq6AacvhzEjlFbbbcItiQ0VGRMw=;
        b=pSxVabFvaiUGD88WdZCsWFaOcILF5JsArnlHqwUBenr6uxtudR9tJiRsm+CsYYtfdL
         NgvBlxZJSFuTNQOgFEauPuLnZ1MfkQkEk+GEihFQJBZUb9NKIycUSlSOvSvLAqhlCxtv
         CLlhMKmGCpAGWLdUpJ1YRC/drbtDo7365ypu3FCXOvMlQ6GPeWTam1a/QRs2ysZjDzZQ
         vk2y9df7X5lQ5a7AG8BhnkFHGsFBZL98nkbT6eMl1wN9H/wJmE7L7drjnv55+zsxMkaU
         X9WlyijKVkPuOBwjeA9idH73Y7SIwH7W2qxASYiim+Kr+W9mZyHkrhqj9a4WuZooPbtF
         oPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886024; x=1686478024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aWGvLME6XjQ0tFUnKq6AacvhzEjlFbbbcItiQ0VGRMw=;
        b=gZ2El0n6yHUmzP3sUWip1ZpcJByDN0QczFiryP21jVL/rCjjQhhpqKTCTT931O6qyK
         P1/Of2VruV2Ncsfb+vS4XDP9Xhw76+1iu21/1CQj6bawVchruwuNjJpDHSuGiO3wdV/A
         X9s90uTlpk5QaqU3UAtoKtfOK12drBpQbOI9zLQKao3987gntS8eCz/SOcg9WkzkHZCw
         Cef2o43NUcZ8IDVGr8mGxshszzMAww6O1poohpfrPE3klsmb0Y9Id92eYVeDxnwvO7NH
         x6Q9sgOyZyy8URFfVj+lV+tyL60KqQonbbydxABtSj8osv88DjRqkjeAKrOFLmc4+Juv
         NwUA==
X-Gm-Message-State: AC+VfDzaXCGDYE07E6DX0Ri+cqm7tBudUSJCVv0WUjd0oNiv2DaObIF8
	L5fzDXOnHV3pRJGEblAFo9M=
X-Google-Smtp-Source: ACHHUZ6fI2R1suLeneCPDSRC8Ucyzwjgc6XLWW/4N2uL81YoU1srsDYieN+uI7B6U5uhuI+pymaOPg==
X-Received: by 2002:a05:6a20:12c2:b0:103:883b:10c1 with SMTP id v2-20020a056a2012c200b00103883b10c1mr10309267pzg.41.1683886024408;
        Fri, 12 May 2023 03:07:04 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id 9-20020aa79249000000b0063db25e140bsm6768678pfp.32.2023.05.12.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 03:07:03 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 2BBBC106B3E; Fri, 12 May 2023 17:06:55 +0700 (WIB)
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
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 09/10] udf: Replace license notice with SPDX identifier
Date: Fri, 12 May 2023 17:06:20 +0700
Message-Id: <20230512100620.36807-10-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=15320; i=bagasdotme@gmail.com; h=from:subject; bh=ABK9ZOO5oiAHmddCrfdOSIFbrgTPUXz2uxE/RZnAb3g=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClx/DOLpbmN1y2z/SYzaU7DH5crWxfJLkpQt1o2d1uY4 mu3qZxnOkpZGMS4GGTFFFkmJfI1nd5lJHKhfa0jzBxWJpAhDFycAjCR8mcM/zM2frGtzNMXvhTU 5LJLMaLz2YnWj6veLOvcdOi7nkoYaxsjw6uwg4eysuZ+5y15x3J7Du/MLcrpWUuWvJvGcEX9v9i MVVwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Except Kconfig and Makefile, all source files for UDF filesystem doesn't
bear SPDX license identifier. Add appropriate license identifier while
replacing boilerplates.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Pali Rohár <pali@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
tglx, in your patch attempt [1] you said that you'd figured out original
author names in UDF source files [2], but you had not already try to
contact them, right? I thought that they are pseudonyms if they couldn't
be contacted.

[1]: https://lore.kernel.org/all/20190604081206.123876666@linutronix.de/
[2]: https://lore.kernel.org/all/alpine.DEB.2.21.1906111604130.1662@nanos.tec.linutronix.de/
 
 fs/udf/balloc.c    |  6 +-----
 fs/udf/dir.c       |  6 +-----
 fs/udf/directory.c |  6 +-----
 fs/udf/ecma_167.h  | 24 +-----------------------
 fs/udf/file.c      |  6 +-----
 fs/udf/ialloc.c    |  6 +-----
 fs/udf/inode.c     |  6 +-----
 fs/udf/lowlevel.c  |  6 +-----
 fs/udf/misc.c      |  6 +-----
 fs/udf/namei.c     |  6 +-----
 fs/udf/osta_udf.h  | 24 +-----------------------
 fs/udf/partition.c |  6 +-----
 fs/udf/super.c     |  6 +-----
 fs/udf/symlink.c   |  6 +-----
 fs/udf/truncate.c  |  6 +-----
 fs/udf/udftime.c   | 19 +------------------
 fs/udf/unicode.c   |  6 +-----
 17 files changed, 17 insertions(+), 134 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 14b9db4c80f03f..ab3ffc355949dc 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * balloc.c
  *
@@ -5,11 +6,6 @@
  *	Block allocation handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
- *
  *  (C) 1999-2001 Ben Fennema
  *  (C) 1999 Stelias Computing Inc
  *
diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 212393b12c2266..f6533f93851b95 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * dir.c
  *
@@ -5,11 +6,6 @@
  *  Directory handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
- *
  *  (C) 1998-2004 Ben Fennema
  *
  * HISTORY
diff --git a/fs/udf/directory.c b/fs/udf/directory.c
index 654536d2b60976..1c775e072b2fef 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -1,14 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * directory.c
  *
  * PURPOSE
  *	Directory related functions
  *
- * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
  */
 
 #include "udfdecl.h"
diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
index de17a97e866742..b2b5bca45758df 100644
--- a/fs/udf/ecma_167.h
+++ b/fs/udf/ecma_167.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0+ */
 /*
  * ecma_167.h
  *
@@ -8,29 +9,6 @@
  * Copyright (c) 2017-2019  Pali Rohár <pali@kernel.org>
  * All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, this software may be distributed under the terms of the
- * GNU Public License ("GPL").
- *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
  */
 
 /**
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 8238f742377bab..b871b85457e5bb 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * file.c
  *
@@ -5,11 +6,6 @@
  *  File handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *  This file is distributed under the terms of the GNU General Public
- *  License (GPL). Copies of the GPL can be obtained from:
- *    ftp://prep.ai.mit.edu/pub/gnu/GPL
- *  Each contributing author retains all rights to their own work.
- *
  *  (C) 1998-1999 Dave Boynton
  *  (C) 1998-2004 Ben Fennema
  *  (C) 1999-2000 Stelias Computing Inc
diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
index 8d50121778a57d..5f7ac8c8479873 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ialloc.c
  *
@@ -5,11 +6,6 @@
  *	Inode allocation handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
- *
  *  (C) 1998-2001 Ben Fennema
  *
  * HISTORY
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 1e71e04ae8f6b9..28cdfc57d946e3 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * inode.c
  *
@@ -5,11 +6,6 @@
  *  Inode handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *  This file is distributed under the terms of the GNU General Public
- *  License (GPL). Copies of the GPL can be obtained from:
- *    ftp://prep.ai.mit.edu/pub/gnu/GPL
- *  Each contributing author retains all rights to their own work.
- *
  *  (C) 1998 Dave Boynton
  *  (C) 1998-2004 Ben Fennema
  *  (C) 1999-2000 Stelias Computing Inc
diff --git a/fs/udf/lowlevel.c b/fs/udf/lowlevel.c
index c87ed942d07653..9d847a7a0905dd 100644
--- a/fs/udf/lowlevel.c
+++ b/fs/udf/lowlevel.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * lowlevel.c
  *
@@ -5,11 +6,6 @@
  *  Low Level Device Routines for the UDF filesystem
  *
  * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
- *
  *  (C) 1999-2001 Ben Fennema
  *
  * HISTORY
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 3777468d06ce58..0788593b6a1d8b 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * misc.c
  *
@@ -5,11 +6,6 @@
  *	Miscellaneous routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
- *
  *  (C) 1998 Dave Boynton
  *  (C) 1998-2004 Ben Fennema
  *  (C) 1999-2000 Stelias Computing Inc
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index fd20423d3ed24c..49e1e0fe3feeb2 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * namei.c
  *
@@ -5,11 +6,6 @@
  *      Inode name handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *      This file is distributed under the terms of the GNU General Public
- *      License (GPL). Copies of the GPL can be obtained from:
- *              ftp://prep.ai.mit.edu/pub/gnu/GPL
- *      Each contributing author retains all rights to their own work.
- *
  *  (C) 1998-2004 Ben Fennema
  *  (C) 1999-2000 Stelias Computing Inc
  *
diff --git a/fs/udf/osta_udf.h b/fs/udf/osta_udf.h
index 157de0ec0cd530..6c09a4cb46f4a7 100644
--- a/fs/udf/osta_udf.h
+++ b/fs/udf/osta_udf.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0+ */
 /*
  * osta_udf.h
  *
@@ -8,29 +9,6 @@
  * Copyright (c) 2017-2019  Pali Rohár <pali@kernel.org>
  * All rights reserved.
  *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * Alternatively, this software may be distributed under the terms of the
- * GNU Public License ("GPL").
- *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
  */
 
 /**
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index 5bcfe78d5cabe9..af877991edc13a 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * partition.c
  *
@@ -5,11 +6,6 @@
  *      Partition handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *      This file is distributed under the terms of the GNU General Public
- *      License (GPL). Copies of the GPL can be obtained from:
- *              ftp://prep.ai.mit.edu/pub/gnu/GPL
- *      Each contributing author retains all rights to their own work.
- *
  *  (C) 1998-2001 Ben Fennema
  *
  * HISTORY
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 6304e3c5c3d969..928a04d9d9e0ad 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * super.c
  *
@@ -15,11 +16,6 @@
  *    https://www.iso.org/
  *
  * COPYRIGHT
- *  This file is distributed under the terms of the GNU General Public
- *  License (GPL). Copies of the GPL can be obtained from:
- *    ftp://prep.ai.mit.edu/pub/gnu/GPL
- *  Each contributing author retains all rights to their own work.
- *
  *  (C) 1998 Dave Boynton
  *  (C) 1998-2004 Ben Fennema
  *  (C) 2000 Stelias Computing Inc
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index a34c8c4e6d2109..779b5c2c75f61e 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * symlink.c
  *
@@ -5,11 +6,6 @@
  *	Symlink handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
- *
  *  (C) 1998-2001 Ben Fennema
  *  (C) 1999 Stelias Computing Inc
  *
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 2e7ba234bab8b8..a686c10fd709d1 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * truncate.c
  *
@@ -5,11 +6,6 @@
  *	Truncate handling routines for the OSTA-UDF(tm) filesystem.
  *
  * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
- *
  *  (C) 1999-2004 Ben Fennema
  *  (C) 1999 Stelias Computing Inc
  *
diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
index fce4ad976c8c29..d0fce5348fd3f3 100644
--- a/fs/udf/udftime.c
+++ b/fs/udf/udftime.c
@@ -1,21 +1,4 @@
-/* Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, Inc.
-   This file is part of the GNU C Library.
-   Contributed by Paul Eggert (eggert@twinsun.com).
-
-   The GNU C Library is free software; you can redistribute it and/or
-   modify it under the terms of the GNU Library General Public License as
-   published by the Free Software Foundation; either version 2 of the
-   License, or (at your option) any later version.
-
-   The GNU C Library is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-   Library General Public License for more details.
-
-   You should have received a copy of the GNU Library General Public
-   License along with the GNU C Library; see the file COPYING.LIB.  If not,
-   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
-   Boston, MA 02111-1307, USA.  */
+// SPDX-License-Identifier: GPL-2.0-only
 
 /*
  * dgb 10/02/98: ripped this from glibc source to help convert timestamps
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 622569007b530b..ae6e809fa3aac7 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * unicode.c
  *
@@ -11,11 +12,6 @@
  *	UTF-8 is explained in the IETF RFC XXXX.
  *		ftp://ftp.internic.net/rfc/rfcxxxx.txt
  *
- * COPYRIGHT
- *	This file is distributed under the terms of the GNU General Public
- *	License (GPL). Copies of the GPL can be obtained from:
- *		ftp://prep.ai.mit.edu/pub/gnu/GPL
- *	Each contributing author retains all rights to their own work.
  */
 
 #include "udfdecl.h"
-- 
An old man doll... just what I always wanted! - Clara


