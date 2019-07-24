Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7825B727F6
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 08:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfGXGIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 02:08:20 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44693 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXGIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 02:08:19 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so86973792iob.11;
        Tue, 23 Jul 2019 23:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YDk5LUlpe3ysfAT5OqSj5FwvlMLI+GX+8vcuIiOGrxI=;
        b=D/1DcqJnqZhoAAisXhEa4TclRHbrKwelJKoQ/+ULJ8XvaRhtBy7OLVIpIW8rneITml
         RzJOrhhksEKAtGgXLjDxC+aW/lsajC2Jo5hTObIcEAqaCJBWAJ1XhG0fHKvh9vFphDWf
         zEFY2QAWTfUBADk6kPsI7CPZFfM3FjrZev+y4/DwwKLzeUgMOYJQJB4uXerKlSX2U854
         2ForQ6vtgqXpCnXRqOx+eDVnQnplf9oA89ZYiuVX5T7w6E31x+t7RcTLKQrjrZBbIw8u
         GY3gFTTe7zfmx/Sno4B8rdpDvcfZ0pkOCvvGKowPvDtITBv8doG8SvBCbXoommQlCU7d
         GYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YDk5LUlpe3ysfAT5OqSj5FwvlMLI+GX+8vcuIiOGrxI=;
        b=hH0tGeJAjiZrTxoPz0F7VSvxVCw97YaQPUd04Aj1ygSr+6zuv2IaRMSaegOb4AwA4h
         8M5DRtgnfis5Cnn25HisiTl+x+9uRvPd2PDg8HdmGRIzcGPxEIiAIMs61e4FRPpzGfn4
         2aIgsKfxHox/H7S1xodAxmT/p4Q1jGdj+oKblEo3FMGsebB/SHeHjEkbKF3mxy7M8Anr
         5mtLv45ioN9lGkhplRnfaYaYlBtXDFxKebTTdcFQ6fcbNm1NYJfZ8iR2Er3BahPpfS6F
         qRZ4tKvd+f9HkpOUTvyiPx1id//HHoE8FS6ySVaMFpbM1VKXlcGnKJXl6M89nF7DrA1e
         2a6Q==
X-Gm-Message-State: APjAAAWRb8oU0PwzvzGva4N5q1AySCf9cAJNvR02/CC4NcJTTWptGlAE
        wHTSgMiGekbSVrBYFxnT8fU=
X-Google-Smtp-Source: APXvYqyY2mboFz8cpwu4jM7KIEHCvEDvrl0oB8lS4KEtd1/it9Zo0Pc46OEwq3HAauajG1VvS72Xpw==
X-Received: by 2002:a02:aa0d:: with SMTP id r13mr83123955jam.129.1563948498756;
        Tue, 23 Jul 2019 23:08:18 -0700 (PDT)
Received: from localhost.localdomain (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id z26sm45034296ioi.85.2019.07.23.23.08.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 23:08:18 -0700 (PDT)
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     skunberg.kelsey@gmail.com, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v3] drivers: net: xgene: Remove acpi_has_method() calls
Date:   Wed, 24 Jul 2019 00:06:59 -0600
Message-Id: <20190724060659.105292-1-skunberg.kelsey@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190723185811.8548-1-skunberg.kelsey@gmail.com>
References: <20190723185811.8548-1-skunberg.kelsey@gmail.com>
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

Changes in v3:
	- Resolved build errors caused by missing bracket

 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c    | 9 ++++-----
 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c | 9 +++++----
 drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c | 9 ++++-----
 3 files changed, 13 insertions(+), 14 deletions(-)

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
index 6453fc2ebb1f..3b3dc5b25b29 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c
@@ -437,6 +437,7 @@ static void xgene_sgmac_tx_disable(struct xgene_enet_pdata *p)
 static int xgene_enet_reset(struct xgene_enet_pdata *p)
 {
 	struct device *dev = &p->pdev->dev;
+	acpi_status status;
 
 	if (!xgene_ring_mgr_init(p))
 		return -ENODEV;
@@ -460,12 +461,12 @@ static int xgene_enet_reset(struct xgene_enet_pdata *p)
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
 	}
 
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

