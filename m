Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF253ECD72
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 06:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhHPEHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 00:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbhHPEHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 00:07:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E89C061764;
        Sun, 15 Aug 2021 21:06:23 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so14738665pjb.2;
        Sun, 15 Aug 2021 21:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4HKnHAiUNAzYRRDKiTL1R3sjGoApYCxJD2ihqVsIpwc=;
        b=cnlbiCfSwSvYVDsM9gSWFd5Edae4dqWRb8Mkww+8FQfkpSZUp7n7liD0gI+NkyJ98K
         pZ74Lr74ZEPN0EHeabD36RHeCRlpZuKW0U8Ynif6Hm/yjK8EHFGtFoKYK5r5D2VsVN3b
         hvyx6KUS6wWmlj86aWdOIPrkdxhAiL80ZpNKAWmejTqFyJw9etzstHgq+40LeYxaxN3G
         iCDARxuQK//QNj/rG2Hyi0YbyGeUuAY7dwCcsRCcgsuPeMEUxk1EBuY3otwzrdg5Tjvo
         QH9eMppjklUqL0b1Ngv3PuNGpUY6EGwFCza6muuDeVeqfx/V7tQ5ZVcxQ7quh3rO/nI4
         zamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4HKnHAiUNAzYRRDKiTL1R3sjGoApYCxJD2ihqVsIpwc=;
        b=HKJcTMKWVFZ2AWpUraQqm0CD7b0pH7NP5jwP7LkGDvZfhPkqBmWShAqXIuypgVAyGy
         s+IllwQPB2odCUkdhpZZvulUOScxX6tnUvmTSKEMIbrIpRrvllSj0ojC22N2gZBlBQBA
         b4co9tHAJSTgN/Rkn5TWkADt+3WAgMVzIhZdcQHwne4cFxERLaok9OTJLaEP6KsEC3aC
         Kljd4cqkYrJqZKfisWWRWdeKfqwuYuITBoToRfMeTWw3wMy98eoWTAjLWpjdhV9L2y5z
         uBK8SyZJQVpbe6waBFBqMsNEW+N6JZz1PYCouTp11LG2NjwIn6M+k+Sed2VyIxMhf/t3
         SYJg==
X-Gm-Message-State: AOAM530fA/ulWjx9d7bGRxR2OfJT4v72GZVvV8yLR37Tl8MFjfAnHsvK
        MRp3fQENqK6xB35HcLtQ5rU=
X-Google-Smtp-Source: ABdhPJyz+/bpAfb/VTMTroBn7Rd8D8yVzz6W3NSNjnzqfouTMsyozc5eAcvRG+0S+VT6OWpxcNlAGw==
X-Received: by 2002:a65:620a:: with SMTP id d10mr13996935pgv.120.1629086783287;
        Sun, 15 Aug 2021 21:06:23 -0700 (PDT)
Received: from ubuntu.localdomain ([182.226.226.37])
        by smtp.gmail.com with ESMTPSA id i6sm9436998pfa.44.2021.08.15.21.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 21:06:22 -0700 (PDT)
From:   bongsu.jeon2@gmail.com
To:     shuah@kernel.org, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-nfc@lists.01.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next 2/3] selftests: Remove the polling code to read a NCI frame
Date:   Sun, 15 Aug 2021 21:05:59 -0700
Message-Id: <20210816040600.175813-3-bongsu.jeon2@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
References: <20210816040600.175813-1-bongsu.jeon2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

Because the virtual NCI device uses Wait Queue, the virtual device
application doesn't need to poll the NCI frame.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 tools/testing/selftests/nci/nci_dev.c | 33 +++++++++------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 57b505cb1561..34e76c7fa1fe 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -270,8 +270,7 @@ static void *virtual_dev_open(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -280,8 +279,7 @@ static void *virtual_dev_open(void *data)
 		goto error;
 	write(dev_fd, nci_reset_rsp, sizeof(nci_reset_rsp));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_init_cmd))
@@ -290,8 +288,7 @@ static void *virtual_dev_open(void *data)
 		goto error;
 	write(dev_fd, nci_init_rsp, sizeof(nci_init_rsp));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_disc_map_cmd))
@@ -313,8 +310,7 @@ static void *virtual_dev_open_v2(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -324,8 +320,7 @@ static void *virtual_dev_open_v2(void *data)
 	write(dev_fd, nci_reset_rsp_v2, sizeof(nci_reset_rsp_v2));
 	write(dev_fd, nci_reset_ntf, sizeof(nci_reset_ntf));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_init_cmd_v2))
@@ -334,8 +329,7 @@ static void *virtual_dev_open_v2(void *data)
 		goto error;
 	write(dev_fd, nci_init_rsp_v2, sizeof(nci_init_rsp_v2));
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_disc_map_cmd))
@@ -402,8 +396,7 @@ static void *virtual_deinit(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -425,8 +418,7 @@ static void *virtual_deinit_v2(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_reset_cmd))
@@ -489,16 +481,14 @@ static void *virtual_poll_start(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_discovery_cmd))
 		goto error;
 	if (memcmp(nci_rf_discovery_cmd, buf, len))
 		goto error;
-	write(dev_fd, nci_rf_disc_rsp, sizeof(nci_rf_disc_rsp))
-		;
+	write(dev_fd, nci_rf_disc_rsp, sizeof(nci_rf_disc_rsp));
 
 	return (void *)0;
 error:
@@ -513,8 +503,7 @@ static void *virtual_poll_stop(void *data)
 
 	dev_fd = *(int *)data;
 
-	while ((len = read(dev_fd, buf, 258)) == 0)
-		;
+	len = read(dev_fd, buf, 258);
 	if (len <= 0)
 		goto error;
 	if (len != sizeof(nci_rf_deact_cmd))
-- 
2.32.0

