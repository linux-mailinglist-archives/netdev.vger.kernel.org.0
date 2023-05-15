Return-Path: <netdev+bounces-2500-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE77702425
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:09:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 080F1280F0F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629074C9B;
	Mon, 15 May 2023 06:08:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CEC79D8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:08:32 +0000 (UTC)
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB7A4216;
	Sun, 14 May 2023 23:08:15 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-51f6461af24so8524972a12.2;
        Sun, 14 May 2023 23:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684130895; x=1686722895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mBiqBBIYLEkHibtBdW/1btIfiL3qtmo7cBbm0jM9yY8=;
        b=Zd9l0vJOaVerMEtQTyk8v2s5Fazl7J7mIhKC/rwplP10gkYcBTw9hxgYzCujnSS2Y4
         tmgzqvya/fn+NhwwkYluDXlaTytrqzBLpi58NsU8zvE+mjt/catXOEqGPwr8cSRPlYvL
         VTN6+kQyuX0gXxvih1cZ7kfF0bs1NU5myR12m85okk0wyqvlfXt4Q5nJuYVXO3rc+fLx
         aI0p53Dq/ztY9ZqW366frEQcJtoPYU6KKwxKrRp5b41EPSq9sSHwiQr4bodWpuPZ/5Ky
         NJ/EeACOkmoumzR0V2VIGa37NBul1wQvlb7a6kG9IxNgWcDCxsEi240q/iYI/ZFiVPPu
         WRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684130895; x=1686722895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mBiqBBIYLEkHibtBdW/1btIfiL3qtmo7cBbm0jM9yY8=;
        b=WzT5iJgoGR13zpTK9fFM5if8m3mKf3uFYaBJal/CdqfM4sfI85eRF0AjblcEjjNj5S
         O9AlkanYYO6yIZZ+g1WyVbYtZrLjaptD7qN4up6tFVIyeA7kBaL+KTKz3NB7AvqoYlFv
         dCa26y+TymBuN+w2lMuUiIjn512fKU0Liy3dQLqq2k3xJRSXHijMY2QQ8NeIE2bbtmlV
         FKbtZqdAnk8CBg2sslMZuFq+ovCTBldprVIfCVEresPnWJ8se187QhnDyDZCRLJ3PoLC
         reCAKzyNuqNqxK9OKUrQSxNi00/nEF/vAScQj370qYt88gFFxAklYc9n+Fh3D2AWcYNb
         8Lyw==
X-Gm-Message-State: AC+VfDzQ9gHXqWaAZhCDcTdqUkEGpOU3Reb6XhBjV5bu9RLvUaJn0+Zu
	Fg14vseGanEC+/8afupVMu4=
X-Google-Smtp-Source: ACHHUZ6UYDydbDzFmOjNs6twK6LvN2+rzCltPp5vkxK9/FKtqLhbxMEfafIMFxrm5+IBkfRm8U6Evw==
X-Received: by 2002:a17:903:44b:b0:1ab:f74:a111 with SMTP id iw11-20020a170903044b00b001ab0f74a111mr33176554plb.63.1684130895138;
        Sun, 14 May 2023 23:08:15 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id l4-20020a170902f68400b001a525705aa8sm12474028plg.136.2023.05.14.23.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 23:08:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 57D3E10697E; Mon, 15 May 2023 13:08:06 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Networking <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Greg Ungerer <gerg@linux-m68k.org>,
	Simon Horman <simon.horman@corigine.com>,
	Tom Rix <trix@redhat.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Donald Becker <becker@scyld.com>,
	Peter De Schrijver <p2@mind.be>,
	Topi Kanerva <topi@susanna.oulu.fi>,
	Alain Malek <Alain.Malek@cryogen.com>,
	Bruce Abbott <bhabbott@inhb.co.nz>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Fontana <rfontana@redhat.com>
Subject: [PATCH net 3/5] net: ethernet: 8390: Replace GPL 2.0 boilerplate with SPDX identifier
Date: Mon, 15 May 2023 13:07:13 +0700
Message-Id: <20230515060714.621952-4-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515060714.621952-1-bagasdotme@gmail.com>
References: <20230515060714.621952-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4485; i=bagasdotme@gmail.com; h=from:subject; bh=JOFAII8UyXAJ429qaAk/G7gCF3pJmNAwC5W8F65Ndew=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCmJZwQ7jnD5zw9WfeBSMvV7bZs/v7NP27Nrkctc3i6b+ EBmcmZ3RykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACbSN4vhf17NgXr/a8t7tWM2 iPJ4M+Uvf37F5Clv2VrmtCXGvwMOnWL47/lwZbTuX+MT/7Kybz/kWT+P58mONB6zk4uOFK86d+X jQg4A
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The boilerplate refers to COPYING in the top-level directory of kernel
tree. Replace it with corresponding SPDX license identifier.

Cc: Donald Becker <becker@scyld.com>
Cc: Peter De Schrijver <p2@mind.be>
Cc: Topi Kanerva <topi@susanna.oulu.fi>
Cc: Alain Malek <Alain.Malek@cryogen.com>
Cc: Bruce Abbott <bhabbott@inhb.co.nz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Fontana <rfontana@redhat.com>
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/net/ethernet/8390/apne.c      | 7 +------
 drivers/net/ethernet/8390/hydra.c     | 6 ++----
 drivers/net/ethernet/8390/mcf8390.c   | 4 +---
 drivers/net/ethernet/8390/stnic.c     | 5 +----
 drivers/net/ethernet/8390/zorro8390.c | 7 +------
 5 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index 991ad953aa7906..a09f383dd249f1 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
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
 
 
diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/8390/hydra.c
index 1df7601af86a40..24f49a8ff903ff 100644
--- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -1,10 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
 /* New Hydra driver using generic 8390 core */
 /* Based on old hydra driver by Topi Kanerva (topi@susanna.oulu.fi) */
 
-/* This file is subject to the terms and conditions of the GNU General      */
-/* Public License.  See the file COPYING in the main directory of the       */
-/* Linux distribution for more details.                                     */
-
 /* Peter De Schrijver (p2@mind.be) */
 /* Oldenburg 2000 */
 
diff --git a/drivers/net/ethernet/8390/mcf8390.c b/drivers/net/ethernet/8390/mcf8390.c
index 8a7918d3341965..217838b2822025 100644
--- a/drivers/net/ethernet/8390/mcf8390.c
+++ b/drivers/net/ethernet/8390/mcf8390.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
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
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
index bd89ca8a92dfbc..265976e3b64ab2 100644
--- a/drivers/net/ethernet/8390/stnic.c
+++ b/drivers/net/ethernet/8390/stnic.c
@@ -1,8 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /* stnic.c : A SH7750 specific part of driver for NS DP83902A ST-NIC.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
  *
  * Copyright (C) 1999 kaz Kojima
  */
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/8390/zorro8390.c
index e8b4fe813a0828..d70390e9d03d9b 100644
--- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-only
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


