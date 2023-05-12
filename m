Return-Path: <netdev+bounces-2110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34FDF7004C7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9542281AD1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF672D311;
	Fri, 12 May 2023 10:07:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABEBD30A
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 10:07:02 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC712171E;
	Fri, 12 May 2023 03:07:00 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-644d9bf05b7so5095600b3a.3;
        Fri, 12 May 2023 03:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683886020; x=1686478020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bem8jDoswsIx3LqKUeWVXu4IOKeZhVI23DjbNiD86cQ=;
        b=Lhcg+tsBS0zcH6bPFXMc7vXKGo0Adx4cYbOJbHWuzEJzwS15HeLps1wI3OrhTUWaJx
         SmKHaWIaizGmM5lwXznkTZb4DMX+AFgJHJ02THSMfRCh+CYxfwncT5qXEpkn/dd7SYkm
         NfaHwSDSjQ9ECQnUZJyqswLI6xNVyydOjlALuX7Mm8O8AL8fQN56FqYIbGf/bN4AIBBX
         CMU245xlISEzD6Z3ksQ8Zn++WTcGC7NL2EFKjSs+JRtCMh96AjKt+31yxKc4RPjl/we9
         YQlqcssAXeZS+YVuLzvzeZca+npyUHkZyjTU8EuUngo+otTY7Y0zx5aJA6eCLRJaP7oP
         BhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683886020; x=1686478020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bem8jDoswsIx3LqKUeWVXu4IOKeZhVI23DjbNiD86cQ=;
        b=EVouEi3y95+9YbxzUaJ4JeG+eEGauJIRH09ePPsTo8PqI2XgzuO8DuEJi0tyg4aopT
         HmqPtNBaEFbQLlIZEc1/s3M1xYUxQJjd883JHlVMhD1gT0SxJbpCKpbeyapD7C7x4Uul
         +tgaeTJ1tPGV5geYXAMHuTeAUtuCrr27Th99aZnriX2E6d9tz3BwV41L/TPJM7JsdWZH
         S7scP/0UAGhVxhJhn0YlRO5ZvPlOLHDS8mJ6zTFupG/VNEqdelB5QQSVx2MpQWS/1y9H
         N/yxW8iSB9dJ6AUXlqVeQsewTVj9zmPjS3nflW/tAXuyNQwtaDWH1ecM+v/jpfeTAypM
         wVTQ==
X-Gm-Message-State: AC+VfDxWHwAjZ6oqhATy/rlEzT4kK88gtjEzbs0DG8wkfN19Xek2cEcG
	shShan7Z3z9IEWsTlsTwgEE=
X-Google-Smtp-Source: ACHHUZ6WGSKAIfGxAnEVHEzQApp2UgiCiA76V06pwKR3ytoEGn1X1r2QTpMagYcS63H7lNElT9sucw==
X-Received: by 2002:a05:6a20:7f83:b0:100:5ddc:c6a1 with SMTP id d3-20020a056a207f8300b001005ddcc6a1mr21528686pzj.15.1683886020037;
        Fri, 12 May 2023 03:07:00 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-58.three.co.id. [116.206.12.58])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b0050f93a3586fsm6141727pgf.37.2023.05.12.03.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 03:06:59 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id D9764101B84; Fri, 12 May 2023 17:06:54 +0700 (WIB)
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
	Stephen Hemminger <stephen@networkplumber.org>,
	Andreas Eversberg <jolly@eversberg.eu>,
	Karsten Keil <keil@isdn4linux.de>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v2 02/10] mISDN: Replace GPL notice boilerplate with SPDX identifier
Date: Fri, 12 May 2023 17:06:13 +0700
Message-Id: <20230512100620.36807-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230512100620.36807-1-bagasdotme@gmail.com>
References: <20230512100620.36807-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4211; i=bagasdotme@gmail.com; h=from:subject; bh=gDeWnuEEVweZ2+OADiOaGpHECUxDBZJJ7rTKBKg4aRc=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDClx/NO7GIO2pwcIC1w4HXP6zJekhh8+eQ9ZNy61FHr4m efuNjmrjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAExkbQcjwwqBz+uOHGlcvIf3 7uwffQ2H2zMfP5ZTUljb/XQ9z7MfUToM/xTvuqkbtJs+lxT6qKPze4aK35n5ypZCRm0toXd8Xh+ +zAAA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace unversioned GPL notice boilerplate on dsp_* with SPDX identifier
for GPL 1.0+. These files missed previous SPDX conversion batches
due to not specifying GPL version.

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: Andreas Eversberg <jolly@eversberg.eu>
Cc: Karsten Keil <keil@isdn4linux.de>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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
index bbef98e7a16efb..df86c0ce9cd8d1 100644
--- a/drivers/isdn/mISDN/dsp_audio.c
+++ b/drivers/isdn/mISDN/dsp_audio.c
@@ -1,12 +1,10 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 0aa572f3858da7..e161c092012653 100644
--- a/drivers/isdn/mISDN/dsp_blowfish.c
+++ b/drivers/isdn/mISDN/dsp_blowfish.c
@@ -1,11 +1,9 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 357b87592eb48c..c2b24fdf234523 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1,11 +1,9 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 386084530c2f85..b9ec8489e690a0 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -1,10 +1,9 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 642f30be5ce249..746c210a6d2495 100644
--- a/drivers/isdn/mISDN/dsp_dtmf.c
+++ b/drivers/isdn/mISDN/dsp_dtmf.c
@@ -1,12 +1,10 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 8389e2105cdcf6..16a47cc910c585 100644
--- a/drivers/isdn/mISDN/dsp_tones.c
+++ b/drivers/isdn/mISDN/dsp_tones.c
@@ -1,11 +1,9 @@
+// SPDX-License-Identifier: GPL-1.0+
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


