Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE374425464
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 15:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbhJGNko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 09:40:44 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:51918
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241700AbhJGNkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 09:40:18 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id CAF5140004
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633613903;
        bh=i5yc8KqEKBR9h1kRXiKNI/2N/o+Yq4m6PQJBbQ1oeXs=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ZKCdnfjfJXarBeCrT86YsAboUdcpzldopXsDk2aG/rcu7izeL5/wHetBxmm9zkTHK
         zhjTrinyyKwW4uGgKHo35Wp7goPMhtEbczNV9ITVnk2WOZaEIJVkRjXP3/fSm4bP4B
         C6aLRVxULoZ2UIZ6zA/CoDa6KWfDiNOQe1Ax+semL1fPZOXvXO3/FYvnbjzOtUvIyS
         g7x/hUObyqCEEnJkgPkdQg/vnW453cU03xajVQfOEZTroLP39f/F37FkOkbpFKHhZi
         pOulJfln5LFSxabyLV7eeRcThHaU6ZYCJfXS4zSXyHYtO+10i/mbvTJ6j3M3/GHecy
         vKpyXXh9eEJHw==
Received: by mail-ed1-f69.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso5906583edw.10
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 06:38:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5yc8KqEKBR9h1kRXiKNI/2N/o+Yq4m6PQJBbQ1oeXs=;
        b=L4VVQjngJT8OhZ8JaJc2PbhlR81iKIwzJiqDge/QKhYQjMGE6qcqj8eKYlN5knJQqb
         YGWWUSLFMyOxNsSdiQwSdklHcZEFSSiJdnQ/WCUdq7WR4DxtsBjp3aIuVuMPpvzygiNe
         KmpF0ZvaOfFusDU2e2Lb8GSjLDK6glsjcaktuM3XNGtDPPfJv2c2CPOJrEhE+4vGWC2f
         GJlQXuFZzNLLOabTgzzF7j6H2dSTZcvvEDTRT4H2AXEK3Q6E8kc+9vLQ2vJnDH1RHwqE
         itaC26S+WeVPiOGEFXPwoKSj5Gk6ZiY4GLGFqTzpSw/h0LO95KmYTFLksbbRAWTVW69O
         YrcQ==
X-Gm-Message-State: AOAM530C03F+CbUxHf8Mq11RR1tMuFSkb+K06SXr9olknrtiqVWPjqaV
        V5UyATSSNluVxZAg4SaQwT9XezNS5XD2hvp2JA0NA8ZMi8tuDfewbVoMUS0KeAMXVKdxXKzJ5M2
        B8NnlLT5x3K64YHoxqJsOX8re2m+IAGKfJg==
X-Received: by 2002:a17:906:c0d4:: with SMTP id bn20mr5857708ejb.360.1633613903417;
        Thu, 07 Oct 2021 06:38:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGs83pPcxwRjT8XZwuGT/4eMaNDYr0PKnMg7lCK+FLOnIuti4ghrKQPTbVDfP50A00g7hgAg==
X-Received: by 2002:a17:906:c0d4:: with SMTP id bn20mr5857680ejb.360.1633613903222;
        Thu, 07 Oct 2021 06:38:23 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-186-13.adslplus.ch. [188.155.186.13])
        by smtp.gmail.com with ESMTPSA id ay19sm8585613edb.20.2021.10.07.06.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:38:22 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [RESEND PATCH v2 4/7] nfc: st-nci: drop unneeded debug prints
Date:   Thu,  7 Oct 2021 15:30:18 +0200
Message-Id: <20211007133021.32704-5-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ftrace is a preferred and standard way to debug entering and exiting
functions so drop useless debug prints.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/st-nci/i2c.c  | 4 ----
 drivers/nfc/st-nci/ndlc.c | 4 ----
 drivers/nfc/st-nci/se.c   | 6 ------
 drivers/nfc/st-nci/spi.c  | 4 ----
 4 files changed, 18 deletions(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index ccf6152ebb9f..cbd968f013c7 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -157,7 +157,6 @@ static int st_nci_i2c_read(struct st_nci_i2c_phy *phy,
 static irqreturn_t st_nci_irq_thread_fn(int irq, void *phy_id)
 {
 	struct st_nci_i2c_phy *phy = phy_id;
-	struct i2c_client *client;
 	struct sk_buff *skb = NULL;
 	int r;
 
@@ -166,9 +165,6 @@ static irqreturn_t st_nci_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	client = phy->i2c_dev;
-	dev_dbg(&client->dev, "IRQ\n");
-
 	if (phy->ndlc->hard_fault)
 		return IRQ_HANDLED;
 
diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index e9dc313b333e..755460a73c0d 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -239,8 +239,6 @@ static void ndlc_t1_timeout(struct timer_list *t)
 {
 	struct llt_ndlc *ndlc = from_timer(ndlc, t, t1_timer);
 
-	pr_debug("\n");
-
 	schedule_work(&ndlc->sm_work);
 }
 
@@ -248,8 +246,6 @@ static void ndlc_t2_timeout(struct timer_list *t)
 {
 	struct llt_ndlc *ndlc = from_timer(ndlc, t, t2_timer);
 
-	pr_debug("\n");
-
 	schedule_work(&ndlc->sm_work);
 }
 
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 5fd89f72969d..7764b1a4c3cf 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -638,8 +638,6 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
 {
 	struct st_nci_info *info = nci_get_drvdata(ndev);
 
-	pr_debug("\n");
-
 	switch (se_idx) {
 	case ST_NCI_ESE_HOST_ID:
 		info->se_info.cb = cb;
@@ -671,8 +669,6 @@ static void st_nci_se_wt_timeout(struct timer_list *t)
 	u8 param = 0x01;
 	struct st_nci_info *info = from_timer(info, t, se_info.bwi_timer);
 
-	pr_debug("\n");
-
 	info->se_info.bwi_active = false;
 
 	if (!info->se_info.xch_error) {
@@ -692,8 +688,6 @@ static void st_nci_se_activation_timeout(struct timer_list *t)
 	struct st_nci_info *info = from_timer(info, t,
 					      se_info.se_active_timer);
 
-	pr_debug("\n");
-
 	info->se_info.se_active = false;
 
 	complete(&info->se_info.req_completion);
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 0875b773fb41..4e723992e74c 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -169,7 +169,6 @@ static int st_nci_spi_read(struct st_nci_spi_phy *phy,
 static irqreturn_t st_nci_irq_thread_fn(int irq, void *phy_id)
 {
 	struct st_nci_spi_phy *phy = phy_id;
-	struct spi_device *dev;
 	struct sk_buff *skb = NULL;
 	int r;
 
@@ -178,9 +177,6 @@ static irqreturn_t st_nci_irq_thread_fn(int irq, void *phy_id)
 		return IRQ_NONE;
 	}
 
-	dev = phy->spi_dev;
-	dev_dbg(&dev->dev, "IRQ\n");
-
 	if (phy->ndlc->hard_fault)
 		return IRQ_HANDLED;
 
-- 
2.30.2

