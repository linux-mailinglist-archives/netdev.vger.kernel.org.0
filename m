Return-Path: <netdev+bounces-1802-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14C576FF2FE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32A641C20F3A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665C119E70;
	Thu, 11 May 2023 13:34:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E3D19E6F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:34:32 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F61C10E7A;
	Thu, 11 May 2023 06:34:16 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64115e652eeso58011478b3a.0;
        Thu, 11 May 2023 06:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683812056; x=1686404056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XPQCkH64CNFAQt/WeXCfUvrIoglaGTPj4GtDmz/dzcQ=;
        b=afwzm1NJKhY/AGMm4Ukn8Imuqv9CCQxXBvXEUTCs/qMHxCAIFSog6kU+C4CeaJtk1d
         FkLcNbqx2GplOXyzHHJaY+ER1f/PJOy6Fg4EHIHb5OPxQTfL2HV08JF8B2wpaCu03/SE
         8jF6K0FVmX9SDxcY7WmQaqOo/BwIYVijsAheX7ZBNYfAM43CnSh6pyFBbhRsYRJNmNhY
         oSg1PXZ3TgpG4sorx/zMULZ9WhUr3Zd0Specs8gaJyWoi4MWQlbldF6ljQudY4c/VxSF
         yBi6cjqRmp53+v0keU1WhJ1snXq1qJmW3cPOBixJYCcl44ZdHxz0fS0+s840C4O/weyb
         qDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812056; x=1686404056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XPQCkH64CNFAQt/WeXCfUvrIoglaGTPj4GtDmz/dzcQ=;
        b=brlVYt0/SDt+0/39QTZ2bsuRZJs+ccS9KiyNkP9/O015zaAfBvfl7Hkj13neu1vTpU
         duaF5npNJ4RC9Fstboj7WZl2NnEjEzx2qm+euufzVIe7KjwfPZqDwMz68gOeJ5M4ecb8
         MqOctW1AFp1Qfgerdp1POrD+KSgGxRQQNaOEo2fWMztIneonvLR72NHpCxOCa9IlOuTA
         IVhJBl9zmfiI6JiMwQO5kwrq/fWOB3rbRf5fzpHKlm8N545bWIcXOfQoBK3M6m1gvFXQ
         lZqKc1sPyWTAJu56IViQgPF8MRiVqmoe5cxfHiQxBomNi4mNRpD0DWtLOrb81BOWsC+3
         atiA==
X-Gm-Message-State: AC+VfDxRCzk6jVgatbV8l0JLzmNEI02ra+cXIC5zKS4Y5mykAFgHUEQ0
	b9kqWG7/KmLSCCD9oixA3Ew=
X-Google-Smtp-Source: ACHHUZ4O1Jat5CJArv133r+VpyuY8MQSaAtCOvha77FamvBMtlmldVdj4KXYHlWxeZOFjIPmFy4Zqw==
X-Received: by 2002:a05:6a20:3ca9:b0:f3:3ea5:5185 with SMTP id b41-20020a056a203ca900b000f33ea55185mr25359361pzj.10.1683812055664;
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id x25-20020a62fb19000000b00640e01dfba0sm5468631pfm.175.2023.05.11.06.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:34:15 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E58141067A9; Thu, 11 May 2023 20:34:09 +0700 (WIB)
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
	Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 02/10] mISDN: Replace GPL notice boilerplate with SPDX identifier
Date: Thu, 11 May 2023 20:33:58 +0700
Message-Id: <20230511133406.78155-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511133406.78155-1-bagasdotme@gmail.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4139; i=bagasdotme@gmail.com; h=from:subject; bh=cJS8ef+qojTtJfUCqsZFkSaB82TgDOnvwkt3EGdvflA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCkx747Fz56X8GZ15aRzh97mM8+U03ALmneF+dT5Zxb3L by5b3+S6ShlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEWDwY/nCc93sU6xFW5SS2 dSGr18XStuYJxZMfz1gS9iRGYZrrczuGfzrtmVY9x9cIby/a/8Sdf0rADrNJqZ+mJkuee7Kw6rn BZX4A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace unversioned GPL notice boilerplate on dsp_* with SPDX identifier
for GPL 1.0+. These files missed previous SPDX conversion batches
due to not specifying GPL version.

Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/isdn/mISDN/dsp_audio.c    | 4 +---
 drivers/isdn/mISDN/dsp_blowfish.c | 4 +---
 drivers/isdn/mISDN/dsp_cmx.c      | 4 +---
 drivers/isdn/mISDN/dsp_core.c     | 3 +--
 drivers/isdn/mISDN/dsp_dtmf.c     | 4 +---
 drivers/isdn/mISDN/dsp_tones.c    | 4 +---
 6 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_audio.c b/drivers/isdn/mISDN/dsp_audio.c
index bbef98e7a16efb..869c3a7d92a981 100644
--- a/drivers/isdn/mISDN/dsp_audio.c
+++ b/drivers/isdn/mISDN/dsp_audio.c
@@ -1,12 +1,10 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * Audio support data for mISDN_dsp.
  *
  * Copyright 2002/2003 by Andreas Eversberg (jolly@eversberg.eu)
  * Rewritten by Peter
  *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
  */
 
 #include <linux/delay.h>
diff --git a/drivers/isdn/mISDN/dsp_blowfish.c b/drivers/isdn/mISDN/dsp_blowfish.c
index 0aa572f3858da7..bd83aacf9ffd96 100644
--- a/drivers/isdn/mISDN/dsp_blowfish.c
+++ b/drivers/isdn/mISDN/dsp_blowfish.c
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * Blowfish encryption/decryption for mISDN_dsp.
  *
  * Copyright Andreas Eversberg (jolly@eversberg.eu)
  *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
  */
 
 #include <linux/mISDNif.h>
diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index 357b87592eb48c..b9b3fbb5791121 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * Audio crossconnecting/conferrencing (hardware level).
  *
  * Copyright 2002 by Andreas Eversberg (jolly@eversberg.eu)
  *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
  */
 
 /*
diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 386084530c2f85..800ad56d21285e 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -1,10 +1,9 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * Author       Andreas Eversberg (jolly@eversberg.eu)
  * Based on source code structure by
  *		Karsten Keil (keil@isdn4linux.de)
  *
- *		This file is (c) under GNU PUBLIC LICENSE
- *
  * Thanks to    Karsten Keil (great drivers)
  *              Cologne Chip (great chips)
  *
diff --git a/drivers/isdn/mISDN/dsp_dtmf.c b/drivers/isdn/mISDN/dsp_dtmf.c
index 642f30be5ce249..baf69d585afe00 100644
--- a/drivers/isdn/mISDN/dsp_dtmf.c
+++ b/drivers/isdn/mISDN/dsp_dtmf.c
@@ -1,12 +1,10 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * DTMF decoder.
  *
  * Copyright            by Andreas Eversberg (jolly@eversberg.eu)
  *			based on different decoders such as ISDN4Linux
  *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
  */
 
 #include <linux/mISDNif.h>
diff --git a/drivers/isdn/mISDN/dsp_tones.c b/drivers/isdn/mISDN/dsp_tones.c
index 8389e2105cdcf6..becfb1dd60d631 100644
--- a/drivers/isdn/mISDN/dsp_tones.c
+++ b/drivers/isdn/mISDN/dsp_tones.c
@@ -1,11 +1,9 @@
+/* SPDX-License-Identifier: GPL-1.0-or-later */
 /*
  * Audio support data for ISDN4Linux.
  *
  * Copyright Andreas Eversberg (jolly@eversberg.eu)
  *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- *
  */
 
 #include <linux/gfp.h>
-- 
An old man doll... just what I always wanted! - Clara


