Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7777E76ED4
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 18:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfGZQUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 12:20:53 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33219 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728611AbfGZQUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 12:20:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so55130627wru.0;
        Fri, 26 Jul 2019 09:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/qDVf+3dooEMAhruNasjaP2IHvuiWtEmkuvHmBG+jE=;
        b=u74QyaIaeokVKcRlclbi8ZChTroTb+hxErNprFXFz63Rra5MoMHUzsrbWObUJ9n0Ux
         7ANAXkMymd83qMr5GScNwcw2aYi3uILh36LndhKYmSk6ed00GJi2B4x8HZ08xB4gQjWX
         aqlfKimYkJ02s5kxVwcBDzn5ouy8Mb5tK5a7LpJ7Gje454GjWKDTCaYpqL35f/JYeEXa
         Xr2fLn4cqHSs8Q9sov/srOvuG70bhp7UfBx4vA58SfNFZLxQ1y5tufGPhazUruajAR0x
         8tpSWrFw+RlYbtQ+LLXAPXew0fL9tOO+6ShaAfoaTduq/lBtsW20YbNWycu3Q6Re0sb2
         x/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T/qDVf+3dooEMAhruNasjaP2IHvuiWtEmkuvHmBG+jE=;
        b=JT/l2/28218hdsfYg+y6C7smE5Uc1JA5YXC2HgV8uNS3S/leHYD4rv6tcZj86iaZTh
         yLr/Y72eUMULv6K6E5iDl75zL5iCvwAQFIKF5UzONLFhpX/Bl7n87m6MkVBHH5kPAsbF
         ZEN2qj0kKanwTheX210UPtQOYliawxpzrTqiaU31fg02efPeQTUp6X02Kq1eRasQvJb/
         bjLNTa2LqQCDAsmo2QcNcLHNPxXmRDRqcczRAsBDT6uE6DMBNooAmtlMHOjE70bgA2mj
         nK4WdqrSPwEB7uV2R1xnTYbywCDmUU9gUoMEBRkVtMJ/qtEvzcuhkjhHFWpKn9WwO5jF
         trQw==
X-Gm-Message-State: APjAAAX9NOE5r9pJ7hULJImChL74CT3b4h9JGTS7P9313iywapOUucPV
        vQcxSMrjGZRu2+EHGcYKar0=
X-Google-Smtp-Source: APXvYqwChD/6H+v/k2i0GRnWa8BPb9pYfF23pSNRnjD9xEwPX6Kks+G03fmvtv+XXTU2gzoC5WPMnw==
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr323995wrw.185.1564158051059;
        Fri, 26 Jul 2019 09:20:51 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id u2sm45819941wmc.3.2019.07.26.09.20.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 09:20:49 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kelsey Skunberg <skunberg.kelsey@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] drivers: net: xgene: Move status variable declaration into CONFIG_ACPI block
Date:   Fri, 26 Jul 2019 09:20:37 -0700
Message-Id: <20190726162037.37308-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_ACPI is unset (arm allyesconfig), status is unused.

drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c:383:14: warning:
unused variable 'status' [-Wunused-variable]
        acpi_status status;
                    ^
drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c:440:14: warning:
unused variable 'status' [-Wunused-variable]
        acpi_status status;
                    ^
drivers/net/ethernet/apm/xgene/xgene_enet_hw.c:697:14: warning: unused
variable 'status' [-Wunused-variable]
        acpi_status status;
                    ^

Move the declaration into the CONFIG_ACPI block so that there are no
compiler warnings.

Fixes: 570d785ba46b ("drivers: net: xgene: Remove acpi_has_method() calls")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c    | 3 ++-
 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c | 3 ++-
 drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c | 3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
index 79924efd4ab7..5f657879134e 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
@@ -694,7 +694,6 @@ bool xgene_ring_mgr_init(struct xgene_enet_pdata *p)
 static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 {
 	struct device *dev = &pdata->pdev->dev;
-	acpi_status status;
 
 	if (!xgene_ring_mgr_init(pdata))
 		return -ENODEV;
@@ -713,6 +712,8 @@ static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 		udelay(5);
 	} else {
 #ifdef CONFIG_ACPI
+		acpi_status status;
+
 		status = acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
 					      "_RST", NULL, NULL);
 		if (ACPI_FAILURE(status)) {
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
index 3b3dc5b25b29..f482ced2cadd 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
@@ -437,7 +437,6 @@ static void xgene_sgmac_tx_disable(struct xgene_enet_pdata *p)
 static int xgene_enet_reset(struct xgene_enet_pdata *p)
 {
 	struct device *dev = &p->pdev->dev;
-	acpi_status status;
 
 	if (!xgene_ring_mgr_init(p))
 		return -ENODEV;
@@ -461,6 +460,8 @@ static int xgene_enet_reset(struct xgene_enet_pdata *p)
 		}
 	} else {
 #ifdef CONFIG_ACPI
+		acpi_status status;
+
 		status = acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
 					      "_RST", NULL, NULL);
 		if (ACPI_FAILURE(status)) {
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
index 78584089d76d..304b5d43f236 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
@@ -380,7 +380,6 @@ static void xgene_xgmac_tx_disable(struct xgene_enet_pdata *pdata)
 static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 {
 	struct device *dev = &pdata->pdev->dev;
-	acpi_status status;
 
 	if (!xgene_ring_mgr_init(pdata))
 		return -ENODEV;
@@ -394,6 +393,8 @@ static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 		udelay(5);
 	} else {
 #ifdef CONFIG_ACPI
+		acpi_status status;
+
 		status = acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
 					      "_RST", NULL, NULL);
 		if (ACPI_FAILURE(status)) {
-- 
2.22.0

