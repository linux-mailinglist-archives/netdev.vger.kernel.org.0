Return-Path: <netdev+bounces-1810-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1FB96FF323
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E24AF1C21005
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:37:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C64C19E63;
	Thu, 11 May 2023 13:34:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076521D2A4
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:41 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A94DDB3;
	Thu, 11 May 2023 06:34:21 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6436e004954so8898888b3a.0;
        Thu, 11 May 2023 06:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812061; x=1686404061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsvhjdJ96ntIxsMiGpISSADki1JCUqV8akNIjg6qYNQ=;
        b=RLm1Z4+I9ZqxDMfqOxEbRktK7MHUZ6BislKFd4vk5MQP+hxHsvNxlRQ8huH7AWczGC
         Pt4wVDz7ub/1CgQq/Aa5t/bMPvFUIEMBnkr6valeDJpX2IeFWOsxOmjV8Wna3MGkHui4
         wdbswQLL4Gr0mOBaIDqesz6VbdR7l9fsFoVhUsAkN5lxQm38Fhhu9GhQOjFYujPXWprb
         wH4pivA+QYm9wLlOwQ4hTSLstz2xFFDn2SBWWnsIPrInKhcUHww1zgY22V/vk8tPLi4C
         x0BLH0qa7nMWUmcgKaoFVIIP6uaFF+2BNMqTnbq25qkcCNwPzPEJqqR2MxUXHolmDunM
         0UuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812061; x=1686404061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RsvhjdJ96ntIxsMiGpISSADki1JCUqV8akNIjg6qYNQ=;
        b=aPk7D3Z/N9wspuuN7lj/ZJ+sztEnvN06p/16Q5rHU0nZp4cE5FrTuVCxzvhvIdsaRj
         RRZ/6BbRpS7HNwXbZt5NQMK6UaqesMzrvUeLfro57eHNqJENygHIeJOavjwwA7OdvWbR
         QKyMYbuhcQsxMAZYQPBrXuteI3728fgni5zeyTszwRmSy7rg41jthn8fco5kJ6Vf4jbX
         wMcriBj7kIjp7D0TTsfhB/ITki5+aVp1im39vXKCCQjn3UuuqE1gQl3TZNio2oeZtyFr
         j5JCqC6e+/Hl7DMSpiFb4DcVJD/eWxqc+KfOxg7mq1rASImezmR/0JtDqh9S/Ej0AxYX
         qnkA==
X-Gm-Message-State: AC+VfDy6lFPVXUgMXFSQhTvTfCZNd2zmw9phLKwNyMSUVDsDRY0ojmvq
	hJzYVX/xRBwvpYyCudqLsSA=
X-Google-Smtp-Source: ACHHUZ6zECQCJE3075jyqS4CM91H1WwzMQ84EOryKcwcxEnrXxgMjgj2hgcfxD9eruWg6E8IW/VTgA==
X-Received: by 2002:a05:6a20:918b:b0:101:4348:3e44 with SMTP id v11-20020a056a20918b00b0010143483e44mr12787576pzd.12.1683812060884;
        Thu, 11 May 2023 06:34:20 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id e35-20020a635463000000b0051b70c8d446sm4968249pgm.73.2023.05.11.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0C9BD106979; Thu, 11 May 2023 20:34:11 +0700 (WIB)
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
	Archana <craechal@gmail.com>
Subject: [PATCH 09/10] udf: Replace license notice with SPDX identifier
Date: Thu, 11 May 2023 20:34:05 +0700
Message-Id: <20230511133406.78155-10-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14877; i=bagasdotme@gmail.com; h=from:subject; bh=tey5LajupxhReMk4nez7njbiOBtLjbLleZ6OYhO4cd8=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx7074Bv5MzL4mdvT4uTkNi1r4w956vDarXWsQ+Kpvj 0tyvtLxjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEyEwZqR4WnbjTsTFl7b2ewf wtlm4yVpkjePZ4GwR56A9rtXf+dqJDD8r2+fKLXuK2tyBUusyTe3D48/pJW5Pp3X+TTXcZVBxtJ TnAA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Except Kconfig and Makefile, all source files for UDF filesystem doesn't
bear SPDX license identifier. Add appropriate license identifier while
replacing boilerplates.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
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
index 14b9db4c80f03f..a56eb6975d19c8 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 212393b12c2266..015e17382f975e 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 654536d2b60976..3b65d5dc70b008 100644
--- a/fs/udf/directory.c
+++ b/fs/udf/directory.c
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index de17a97e866742..961e7bf5cb5c00 100644
--- a/fs/udf/ecma_167.h
+++ b/fs/udf/ecma_167.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0-only */
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
index 8238f742377bab..a13622121a63c5 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 8d50121778a57d..67a869cbf5987b 100644
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 1e71e04ae8f6b9..7c1e083223211c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index c87ed942d07653..28fc91f12da911 100644
--- a/fs/udf/lowlevel.c
+++ b/fs/udf/lowlevel.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 3777468d06ce58..c0eaad4d0d86ff 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index fd20423d3ed24c..6d6cd24c7c2536 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 157de0ec0cd530..85a5924873aeb5 100644
--- a/fs/udf/osta_udf.h
+++ b/fs/udf/osta_udf.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0-only */
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
index 5bcfe78d5cabe9..7d78be28929906 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 6304e3c5c3d969..80bee18ec6e1f4 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index a34c8c4e6d2109..0b91b2c92bddb8 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index 2e7ba234bab8b8..3fb6c2abb4dc34 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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
index fce4ad976c8c29..d525ea68725f1c 100644
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
+/* SPDX-License-Identifier: GPL-2.0-only */
 
 /*
  * dgb 10/02/98: ripped this from glibc source to help convert timestamps
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index 622569007b530b..5d6b66e15fcded 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
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


