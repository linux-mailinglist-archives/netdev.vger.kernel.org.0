Return-Path: <netdev+bounces-2502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3158E70242A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37A9B1C209FF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB734C9C;
	Mon, 15 May 2023 06:08:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9598481
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:08:34 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0AB35BD;
	Sun, 14 May 2023 23:08:18 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so18143090b3a.0;
        Sun, 14 May 2023 23:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684130897; x=1686722897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7vAdArybvvD8TNivN89YmoKrMty9jDST5N2dzspJoI=;
        b=IvF215fUpwVnQQf61TUrPURIR7iCsWM48yKE4vMR7kvC7D4VJf4ukDmERVDZrnESuJ
         f+1gnkkZvc+Bf2L9lZKcbJ958k8PJfOxnt7PQrD8GY+4Y7qr7de/ZvPpxU2Bv3sS4NlD
         W0Df5Kw03kGPs9IwrFfBVPx0hSmzMEwGrx0T3r44aq28eN9KRbfv5w1TZQ8uI5232DKJ
         ccM9rfghw1rZpAAvIxPQ9MvwTN+ZnvkS/jM+NLHlz2gktCHy3A2B7Jy4ybdtjUPHZXM2
         PxA02XNucU9hJRS0hz3Sz79i4z5Gx+E9FQvCNsd8yszQJ07szk0zsORMsWMXwbz1H9kM
         jdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684130897; x=1686722897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7vAdArybvvD8TNivN89YmoKrMty9jDST5N2dzspJoI=;
        b=hv2IrscgizFja4aslsGkYb8Tf0TYEJjzXiI7BE5+z5nBsx161jsnxu44M+rqVZxgUa
         RmqW3jhVkZi1jAcPU/SEuMLJzgbhxIOXkcacjCADSsm/eHVIXmu9SiqB5ax7iLhVD1oo
         B0oEYVpiLWTNwgUGpnlYFRiUQOL5zyGIb8JsM02/Dy/1yKAu1ZFHOowmdEn2u/qkx/RA
         WISFeFrV/O2PYxlhe4ukWXMDpsBkpnDlY1t7zslmpE2kqZ6TWLOpUtyPiMV4IhTK9Klp
         sLDEdo7IO7v18TKQz3RauC7USL+RqF+rKV6NE5gFa213zsGQ1pJlzE7kYbykCuW2jGZ+
         el8g==
X-Gm-Message-State: AC+VfDx8fvIpO345QNXsOllJyPHqldIV7PLPEvu2/r9HFUWfSSymlu0T
	nCi0WRPu7cqiQuAmp5fq6EY=
X-Google-Smtp-Source: ACHHUZ5DV09YUir+k2c9SgrFh6FrYuNbNfuo0niVdotMC1NfcbGUZRkDCE7VOJ3raY3s9jNOvAI3Ig==
X-Received: by 2002:a05:6a00:14ca:b0:635:7fb2:2ab4 with SMTP id w10-20020a056a0014ca00b006357fb22ab4mr37774879pfu.6.1684130897488;
        Sun, 14 May 2023 23:08:17 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-77.three.co.id. [180.214.232.77])
        by smtp.gmail.com with ESMTPSA id f23-20020aa782d7000000b0063d2cd02d69sm10968313pfn.54.2023.05.14.23.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 23:08:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 8364D106980; Mon, 15 May 2023 13:08:06 +0700 (WIB)
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
	Richard Hirst <richard@sleepie.demon.co.uk>
Subject: [PATCH net 4/5] net: ethernet: i825xx: Replace unversioned GPL (GPL 1.0) notice with SPDX identifier
Date: Mon, 15 May 2023 13:07:14 +0700
Message-Id: <20230515060714.621952-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515060714.621952-1-bagasdotme@gmail.com>
References: <20230515060714.621952-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3296; i=bagasdotme@gmail.com; h=from:subject; bh=9EFkLdmAtZloacPPkfZIu+19jGDm5As1gK/OT9eIQEA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDCmJZwR1qzjmfbfoOcByaJHNvdf7PR8yJ//592XdohMOd 5oNFjFEdJSyMIhxMciKKbJMSuRrOr3LSORC+1pHmDmsTCBDGLg4BWAiDZUM/9OOS/u48CzYn69h 7+AckLn17M6LChO9nh8XZxS9qrr4lCAjw9OjupxeK5ouKdyUnGf5tfnSy/f8RvFcqiLfNnK9Pf1 WhwEA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace unversioned GPL boilerplate notice with corresponding SPDX
license identifier, which is GPL 1.0+.

Cc: Donald Becker <becker@scyld.com>
Cc: Richard Hirst <richard@sleepie.demon.co.uk>
Cc: Sam Creasey <sammy@sammy.net>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/net/ethernet/i825xx/82596.c      | 5 ++---
 drivers/net/ethernet/i825xx/lasi_82596.c | 5 ++---
 drivers/net/ethernet/i825xx/lib82596.c   | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index 3ee89ae496d0ca..773d7aa29ef5fc 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
 /* 82596.c: A generic 82596 ethernet driver for linux. */
 /*
    Based on Apricot.c
@@ -31,9 +32,7 @@
    Driver skeleton
    Written 1993 by Donald Becker.
    Copyright 1993 United States Government as represented by the Director,
-   National Security Agency. This software may only be used and distributed
-   according to the terms of the GNU General Public License as modified by SRC,
-   incorporated herein by reference.
+   National Security Agency.
 
    The author may be reached as becker@scyld.com, or C/O
    Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD 21403
diff --git a/drivers/net/ethernet/i825xx/lasi_82596.c b/drivers/net/ethernet/i825xx/lasi_82596.c
index 0af70094aba341..3e53e0c243ba04 100644
--- a/drivers/net/ethernet/i825xx/lasi_82596.c
+++ b/drivers/net/ethernet/i825xx/lasi_82596.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
 /* lasi_82596.c -- driver for the intel 82596 ethernet controller, as
    munged into HPPA boxen .
 
@@ -59,9 +60,7 @@
    Driver skeleton
    Written 1993 by Donald Becker.
    Copyright 1993 United States Government as represented by the Director,
-   National Security Agency. This software may only be used and distributed
-   according to the terms of the GNU General Public License as modified by SRC,
-   incorporated herein by reference.
+   National Security Agency.
 
    The author may be reached as becker@scyld.com, or C/O
    Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD 21403
diff --git a/drivers/net/ethernet/i825xx/lib82596.c b/drivers/net/ethernet/i825xx/lib82596.c
index ca2fb303fcc6f6..67d248a7a6f49e 100644
--- a/drivers/net/ethernet/i825xx/lib82596.c
+++ b/drivers/net/ethernet/i825xx/lib82596.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-1.0+
 /* lasi_82596.c -- driver for the intel 82596 ethernet controller, as
    munged into HPPA boxen .
 
@@ -59,9 +60,7 @@
    Driver skeleton
    Written 1993 by Donald Becker.
    Copyright 1993 United States Government as represented by the Director,
-   National Security Agency. This software may only be used and distributed
-   according to the terms of the GNU General Public License as modified by SRC,
-   incorporated herein by reference.
+   National Security Agency.
 
    The author may be reached as becker@scyld.com, or C/O
    Scyld Computing Corporation, 410 Severn Ave., Suite 210, Annapolis MD 21403
-- 
An old man doll... just what I always wanted! - Clara


