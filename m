Return-Path: <netdev+bounces-2499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CC2702424
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90CBA280F3A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6FDD5226;
	Mon, 15 May 2023 06:08:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F6F4C9C
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:08:31 +0000 (UTC)
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004C9420B;
	Sun, 14 May 2023 23:08:14 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1addac3de73so25957925ad.1;
        Sun, 14 May 2023 23:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684130894; x=1686722894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZr/i7Xd/HcCv+Wun5jcdIOlwoy5iDy/18eFfmYezAY=;
        b=MNeedPrp1/7KMVzLlWKlkkEdqHmE0C3eaJejhgzHcdq7pUgxRbCkT5pgFoFhh/y1Os
         U003ntF2XR30Rrwuq3YA5KeZjg6cV6i7PrqcLDetaue/dn/IQdirLGvZFVbmdn9nmoaz
         gOX63U7opCimZC7Ip/SmLKprEQ/Qu/BKelIpD9ZzR+JwmJ66rlvaDac6o1KUnDEWN2tP
         q94MKgSEN33gQLkyvvGy9uW2XDr9Kw/NwHIPELkeM59AyHPjklWZ4OWctbpWhyKD9NQY
         awO0NzXOVX6wj6ZNZESsyUv8ADIktULbl1a6Zd0SgSI5g30vQMfy20CkCGEQTZYgh/oJ
         q4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684130894; x=1686722894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZr/i7Xd/HcCv+Wun5jcdIOlwoy5iDy/18eFfmYezAY=;
        b=cZ0d6CUXpbB24EMCdxhweCQnWP2ZwyYwO8569sI7cRppnYidekmf/1cQG37zL3EWlN
         w7otgbl25lOuY9GNjefXRXmHG/vWwihY1hPitMYacze54m7nIkLKdbb01/ROvrVL7LiS
         EkHx1vkmUWbgFsPrjhMzHM8Nux/jvS7uPL4XD7C1vnAsGcgc4p+j5fWOfCuDwqjTA1Xw
         UwYZNihxQ2m2JVQ311sUzoGP/0+Ptfm9OVsjataS80ymqjk2KfFMWxryLCtSeqdVgGy5
         0ccPYAO4Gd9/wQMaA4kp2nHn95IicZ6W7leS9Li0QVtPz1oQyVMaXGT/kKzEWQ/reVaG
         PxJw==
X-Gm-Message-State: AC+VfDy98eSUU2jvDYqU1UQuV7G9qYLw2A+ck1SNG66aurqkyqu6EekJ
	W8g3jetm8CinbJkG7P7xaVM=
X-Google-Smtp-Source: ACHHUZ4vcnouQ/RnI6buH1rugymU1Z9C73m/oU/KC/sw1aruxCjPdo2KYFk/KY+7REdrMQ0nVwHbfA==
X-Received: by 2002:a17:902:cec9:b0:1a6:dba5:2e60 with SMTP id d9-20020a170902cec900b001a6dba52e60mr43209175plg.25.1684130894339;
        Sun, 14 May 2023 23:08:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id c8-20020a170902b68800b001aaecc15d66sm6878409pls.289.2023.05.14.23.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 23:08:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 39D80106978; Mon, 15 May 2023 13:08:06 +0700 (WIB)
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
	"David A . Hinds" <dahinds@users.sourceforge.net>,
	Donald Becker <becker@scyld.com>,
	Alan Cox <alan@linux.intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Fontana <rfontana@redhat.com>
Subject: [PATCH net 2/5] net: ethernet: 8390: Convert unversioned GPL notice to SPDX license identifier
Date: Mon, 15 May 2023 13:07:12 +0700
Message-Id: <20230515060714.621952-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515060714.621952-1-bagasdotme@gmail.com>
References: <20230515060714.621952-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7624; i=bagasdotme@gmail.com; h=from:subject; bh=nwJjij+Cp6htrcVApSQd0hjb4BLZQHOQ98oK/6yDY5E=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCmJZwRnhR9jvWFreHvLZ18btedfrv5qc7gYoL5v4rxPH 5Zxf/xd01HKwiDGxSArpsgyKZGv6fQuI5EL7WsdYeawMoEMYeDiFICJdM1kZGhak+b57mpxRhMv c6bKRpF5ya8emAZdW82T6uq+kIflegPDP/v3X4wNKtf58idNdHySNU9uyrQo10eMDrlZOpd3CJ3 zYQUA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace boilerplate notice for unversioned GPL to SPDX tag for GPL 1.0+.
For ne2k-pci.c, only add SPDX tag and keep the boilerplate instead,
since the boilerplate notes that it must be preserved.

Cc: David A. Hinds <dahinds@users.sourceforge.net>
Cc: Donald Becker <becker@scyld.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Richard Fontana <rfontana@redhat.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/net/ethernet/8390/8390.h      | 2 ++
 drivers/net/ethernet/8390/axnet_cs.c  | 6 +++---
 drivers/net/ethernet/8390/lib8390.c   | 5 ++---
 drivers/net/ethernet/8390/mac8390.c   | 6 ++----
 drivers/net/ethernet/8390/ne.c        | 4 +---
 drivers/net/ethernet/8390/ne2k-pci.c  | 1 +
 drivers/net/ethernet/8390/pcnet_cs.c  | 5 ++---
 drivers/net/ethernet/8390/smc-ultra.c | 4 +---
 drivers/net/ethernet/8390/wd.c        | 4 +---
 9 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/8390.h
index e5226446599884..f784a6e2ab0ed3 100644
--- a/drivers/net/ethernet/8390/8390.h
+++ b/drivers/net/ethernet/8390/8390.h
@@ -1,3 +1,5 @@
+/* SPDX-License-Identifier: GPL-1.0+ */
+
 /* Generic NS8390 register definitions. */
 
 /* This file is part of Donald Becker's 8390 drivers, and is distributed
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index 78f985885547ea..fea489af72fb0b 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-1.0+
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
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
index e84021282edf30..84aeb8054304f9 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 7fb819b9b89a5b..4a0a095a1a8a0a 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -1,11 +1,9 @@
+// SPDX-License-Identifier: GPL-1.0+
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
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index 0a9118b8be0c64..cb04a3071f92d4 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 6a0a2039600a0a..2c6bd36d2f313b 100644
--- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
 /* A Linux device driver for PCI NE2000 clones.
  *
  * Authors and other copyright holders:
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index 0f07fe03da98c8..9bd5e991f1e52b 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
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
index 6e62c37c940056..ae10b7de41e8f1 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
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
diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index 5b00c452bede64..9a36667d00b65c 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
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
-- 
An old man doll... just what I always wanted! - Clara


