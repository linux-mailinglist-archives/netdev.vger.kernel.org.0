Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC76F71FBD
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391631AbfGWS7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:59:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41188 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfGWS7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:59:04 -0400
Received: by mail-io1-f68.google.com with SMTP id j5so79969355ioj.8;
        Tue, 23 Jul 2019 11:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HYm7XH62ntJYWSyfWpsGscwHo2G/L6bw9DNE5penN0s=;
        b=ftT7qx7TkK+td7mZlBzVadEHjECIKNd75Mlox2nmY/ezjb9Wm14b1upOVdmaN97z3H
         zSovOBNtmpO3r05+Omiic1GBSzC+Jwj0eVuTIeP7xVU9XxZFkKfsLxYX3SBDffRx5xf0
         vnNp0crGrR0U+vjFr1dQIlCJ9Q4MEuyizf4MKsmdtpwrnZKG1s8hJ/b+x0uvJiSa+BeZ
         Z4rG+wMB1ntBpt75kqqXkMr3l0pYAqqM7wEuG+opPWV8Et2XZYj1k1Ispv8bx2Ewjb8m
         zKLg6v7p/W+AzC6VlQ1p2m/TY8DgPoVu+a7rds38S2ldAGTpa/VxyxH/khigW791N+7k
         yYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HYm7XH62ntJYWSyfWpsGscwHo2G/L6bw9DNE5penN0s=;
        b=oEutH7IuMrPaDJEcEBibCNsphD/HCJ6z8Ms/wCTKBLbCBI3sUbq/fp+l2uUz88OXz7
         1Bg9jcGMSAnwfnmVnVN5phe/8eKMLf+FsecyNiNp17kODUyAewSelEhLvTPd1L4Q+qpp
         aIawsTI9XvCzw8QdpdXA9tNYJ3RdwEd4ODbbAA36nQxKpWkRB0KQQpezlgZHmA5eDDsM
         6EB8pfTKM/WRw3pL2RonWdIZGDbwOZ/UiP9LgW8UtrvVzQlxn5rLJU0zSUgfDirud3jW
         82Kdtmvw2ysERxNmd3l5UM2k4vr8J3XqcyyRCKKA1pHUNQmlp2JJn34706E0JnSKoQdz
         UdEg==
X-Gm-Message-State: APjAAAXuL+ZiJFBHsM5lNk3047+vfF3J36sVGkrtZhyU2Jq9Uv5oGkAv
        8w70j4ijiBEEMal49Q4sxP8=
X-Google-Smtp-Source: APXvYqzs0EJ0e/stODDMjXwtN84leWJEvBvtgryU/N+jHEcY2jiKOr2+MShA8IMncnwe5r1ZIPEHPQ==
X-Received: by 2002:a6b:b497:: with SMTP id d145mr49070420iof.17.1563908342941;
        Tue, 23 Jul 2019 11:59:02 -0700 (PDT)
Received: from localhost.localdomain (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id i3sm40636351ion.9.2019.07.23.11.59.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 11:59:01 -0700 (PDT)
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn@helgaas.com
Cc:     skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skunberg.kelsey@gmail.com
Subject: [PATCH v2] drivers: net: xgene: Remove acpi_has_method() calls
Date:   Tue, 23 Jul 2019 12:58:11 -0600
Message-Id: <20190723185811.8548-1-skunberg.kelsey@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
References: <20190722030401.69563-1-skunberg.kelsey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

acpi_evaluate_object will already return an error if the needed method
does not exist. Remove unnecessary acpi_has_method() calls and check the
returned acpi_status for failure instead.

Signed-off-by: Kelsey Skunberg <skunberg.kelsey@gmail.com>
---
Changes in v2:
	- Fixed white space warnings and errors

 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c    |  9 ++++-----
 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c | 10 +++++-----
 drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c |  9 ++++-----
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
index 61a465097cb8..79924efd4ab7 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_hw.c
@@ -694,6 +694,7 @@ bool xgene_ring_mgr_init(struct xgene_enet_pdata *p)
 static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 {
 	struct device *dev = &pdata->pdev->dev;
+	acpi_status status;
 
 	if (!xgene_ring_mgr_init(pdata))
 		return -ENODEV;
@@ -712,11 +713,9 @@ static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 		udelay(5);
 	} else {
 #ifdef CONFIG_ACPI
-		if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev), "_RST")) {
-			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
-					     "_RST", NULL, NULL);
-		} else if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev),
-					 "_INI")) {
+		status = acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
+					      "_RST", NULL, NULL);
+		if (ACPI_FAILURE(status)) {
 			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
 					     "_INI", NULL, NULL);
 		}
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
index 6453fc2ebb1f..5d637b46b2bf 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
@@ -437,6 +437,7 @@ static void xgene_sgmac_tx_disable(struct xgene_enet_pdata *p)
 static int xgene_enet_reset(struct xgene_enet_pdata *p)
 {
 	struct device *dev = &p->pdev->dev;
+	acpi_status status;
 
 	if (!xgene_ring_mgr_init(p))
 		return -ENODEV;
@@ -460,14 +461,13 @@ static int xgene_enet_reset(struct xgene_enet_pdata *p)
 		}
 	} else {
 #ifdef CONFIG_ACPI
-		if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_RST"))
-			acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
-					     "_RST", NULL, NULL);
-		else if (acpi_has_method(ACPI_HANDLE(&p->pdev->dev), "_INI"))
+		status = acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
+					      "_RST", NULL, NULL);
+		if (ACPI_FAILURE(status)) {
 			acpi_evaluate_object(ACPI_HANDLE(&p->pdev->dev),
 					     "_INI", NULL, NULL);
+		}
 #endif
-	}
 
 	if (!p->port_id) {
 		xgene_enet_ecc_init(p);
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
index 133eb91c542e..78584089d76d 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c
@@ -380,6 +380,7 @@ static void xgene_xgmac_tx_disable(struct xgene_enet_pdata *pdata)
 static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 {
 	struct device *dev = &pdata->pdev->dev;
+	acpi_status status;
 
 	if (!xgene_ring_mgr_init(pdata))
 		return -ENODEV;
@@ -393,11 +394,9 @@ static int xgene_enet_reset(struct xgene_enet_pdata *pdata)
 		udelay(5);
 	} else {
 #ifdef CONFIG_ACPI
-		if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev), "_RST")) {
-			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
-					     "_RST", NULL, NULL);
-		} else if (acpi_has_method(ACPI_HANDLE(&pdata->pdev->dev),
-					   "_INI")) {
+		status = acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
+					      "_RST", NULL, NULL);
+		if (ACPI_FAILURE(status)) {
 			acpi_evaluate_object(ACPI_HANDLE(&pdata->pdev->dev),
 					     "_INI", NULL, NULL);
 		}
-- 
2.20.1

