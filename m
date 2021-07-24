Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266453D4A3A
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhGXVIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 17:08:09 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43822
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhGXVHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 17:07:43 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 5F27D3F34F
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 21:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627163294;
        bh=TRvw0HQBwkRWiCVdnew4mISwB8bEYreQOGEzMw+3FDE=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Uwl9yb5XfzSQu3st/zKdkLRMQrM9b2gtitzKKHjz3H37JtbglJxFS29wbwaU1bxMP
         Jxto/eWpc0EELuGAkAQWN1bnVjLKsquNxOz3uE02DjaIbLtSpUWaS/3fWEWLqBfl9p
         ejXYlGILw1js32tzB+g4VlFWHqI102sLRriNEnWpmR69eQmtYoyk9DQmG0laftEvRq
         w6FVDiTACZpK3eficWa3+gxmsa/RGwb8X6sw39WBbDY7WFuSfkp7m84Ecz0IG14K1k
         0E1EhKPRB6O0NpNWYmi4+7CTt47VqjkwI5Pmo7dLP5xMoQRKamFNfyBHgtwGu1F4gm
         xILqELMaS6oPQ==
Received: by mail-ed1-f69.google.com with SMTP id u25-20020aa7d8990000b02903bb6a903d90so3137edq.17
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 14:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TRvw0HQBwkRWiCVdnew4mISwB8bEYreQOGEzMw+3FDE=;
        b=VadzLDZkpBgBgSqlct3UqCvNIHtlr8t9+F4OTOj5A+OYLyFiFk7DPZqfLQe5n0kAbA
         njlOC/b01r72QhGHD1pBs3/I9jE5ShDMT2RCn/kGuQLZ9r+Bo06YweDurGScf9NpOcK7
         T6y55u4Spy0B200Bi0MdgJGc7SDDGVHuBmSmSMWBnurg1p5uMUuZ+DMEA1CjWnNqEFO7
         mR3kZDv3jZ2HMDfTN52WAD5ciC367kMoCOyguAIbfG+APjI6bjdv4CwZUn+4GX48OPT1
         nUfwPmNMrX6Q8McIMM+AZmX39HDQp6KOMzt+cYViVimuerIHAmDJuASvTLzFtf9UrUjt
         sgDw==
X-Gm-Message-State: AOAM533gYxQsECgL1rlvbQJitvMKgxGVZZNcSDqZvU6SmAj2DCnHJUhe
        Z4yY99Z77aic6j9ingHsm8Vm3OXPYNf2CyIyMjGD25uopUs81a8YnsBlFWbUrgXN9/BucNN37bn
        3ZeiwV3tRQXFCYcusSXkenw+LBTn15s1CsA==
X-Received: by 2002:aa7:dcc5:: with SMTP id w5mr13195993edu.355.1627163293903;
        Sat, 24 Jul 2021 14:48:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydqlPQsnsgxgUFeE4aqnx+klbnZbZjTRdJ6m+Vh6/VUS7hHDK60X6grtI4ap93g2wZMDIlsQ==
X-Received: by 2002:aa7:dcc5:: with SMTP id w5mr13195980edu.355.1627163293682;
        Sat, 24 Jul 2021 14:48:13 -0700 (PDT)
Received: from localhost.localdomain ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id j5sm8383005edv.10.2021.07.24.14.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:48:13 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 05/12] nfc: constify nfc_phy_ops
Date:   Sat, 24 Jul 2021 23:47:36 +0200
Message-Id: <20210724214743.121884-6-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
References: <20210724214743.121884-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither the core nor the drivers modify the passed pointer to struct
nfc_phy_ops (consisting of function pointers), so make it a pointer
to const for correctness and safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/fdp/fdp.c             | 4 ++--
 drivers/nfc/fdp/fdp.h             | 2 +-
 drivers/nfc/fdp/i2c.c             | 2 +-
 drivers/nfc/mei_phy.c             | 2 +-
 drivers/nfc/mei_phy.h             | 2 +-
 drivers/nfc/microread/i2c.c       | 2 +-
 drivers/nfc/microread/microread.c | 8 ++++----
 drivers/nfc/microread/microread.h | 6 +++---
 drivers/nfc/pn544/i2c.c           | 2 +-
 drivers/nfc/pn544/pn544.c         | 9 +++++----
 drivers/nfc/pn544/pn544.h         | 7 ++++---
 drivers/nfc/st-nci/i2c.c          | 2 +-
 drivers/nfc/st-nci/ndlc.c         | 6 +++---
 drivers/nfc/st-nci/ndlc.h         | 8 ++++----
 drivers/nfc/st-nci/spi.c          | 2 +-
 drivers/nfc/st21nfca/core.c       | 2 +-
 drivers/nfc/st21nfca/i2c.c        | 2 +-
 drivers/nfc/st21nfca/st21nfca.h   | 4 ++--
 18 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 4d88a617d0e8..3e542b7389cb 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -38,7 +38,7 @@
 #define NCI_OP_PROP_SET_PDATA_OID		0x23
 
 struct fdp_nci_info {
-	struct nfc_phy_ops *phy_ops;
+	const struct nfc_phy_ops *phy_ops;
 	struct fdp_i2c_phy *phy;
 	struct nci_dev *ndev;
 
@@ -687,7 +687,7 @@ static const struct nci_ops nci_ops = {
 	.n_core_ops = ARRAY_SIZE(fdp_core_ops),
 };
 
-int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
+int fdp_nci_probe(struct fdp_i2c_phy *phy, const struct nfc_phy_ops *phy_ops,
 			struct nci_dev **ndevp, int tx_headroom,
 			int tx_tailroom, u8 clock_type, u32 clock_freq,
 			u8 *fw_vsc_cfg)
diff --git a/drivers/nfc/fdp/fdp.h b/drivers/nfc/fdp/fdp.h
index ead3b21ccae6..dc048d4b977e 100644
--- a/drivers/nfc/fdp/fdp.h
+++ b/drivers/nfc/fdp/fdp.h
@@ -21,7 +21,7 @@ struct fdp_i2c_phy {
 	uint16_t next_read_size;
 };
 
-int fdp_nci_probe(struct fdp_i2c_phy *phy, struct nfc_phy_ops *phy_ops,
+int fdp_nci_probe(struct fdp_i2c_phy *phy, const struct nfc_phy_ops *phy_ops,
 		  struct nci_dev **ndev, int tx_headroom, int tx_tailroom,
 		  u8 clock_type, u32 clock_freq, u8 *fw_vsc_cfg);
 void fdp_nci_remove(struct nci_dev *ndev);
diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index c5596e514648..98e1876c9468 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -120,7 +120,7 @@ static int fdp_nci_i2c_write(void *phy_id, struct sk_buff *skb)
 	return r;
 }
 
-static struct nfc_phy_ops i2c_phy_ops = {
+static const struct nfc_phy_ops i2c_phy_ops = {
 	.write = fdp_nci_i2c_write,
 	.enable = fdp_nci_i2c_enable,
 	.disable = fdp_nci_i2c_disable,
diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index e56cea716cd2..41146bb99474 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -362,7 +362,7 @@ static void nfc_mei_phy_disable(void *phy_id)
 	phy->powered = 0;
 }
 
-struct nfc_phy_ops mei_phy_ops = {
+const struct nfc_phy_ops mei_phy_ops = {
 	.write = nfc_mei_phy_write,
 	.enable = nfc_mei_phy_enable,
 	.disable = nfc_mei_phy_disable,
diff --git a/drivers/nfc/mei_phy.h b/drivers/nfc/mei_phy.h
index 51bd44f5f3b8..2b1edb3eba15 100644
--- a/drivers/nfc/mei_phy.h
+++ b/drivers/nfc/mei_phy.h
@@ -45,7 +45,7 @@ struct nfc_mei_phy {
 	int hard_fault;
 };
 
-extern struct nfc_phy_ops mei_phy_ops;
+extern const struct nfc_phy_ops mei_phy_ops;
 
 struct nfc_mei_phy *nfc_mei_phy_alloc(struct mei_cl_device *device);
 void nfc_mei_phy_free(struct nfc_mei_phy *phy);
diff --git a/drivers/nfc/microread/i2c.c b/drivers/nfc/microread/i2c.c
index dd78d987e6c9..f91760c78455 100644
--- a/drivers/nfc/microread/i2c.c
+++ b/drivers/nfc/microread/i2c.c
@@ -225,7 +225,7 @@ static irqreturn_t microread_i2c_irq_thread_fn(int irq, void *phy_id)
 	return IRQ_HANDLED;
 }
 
-static struct nfc_phy_ops i2c_phy_ops = {
+static const struct nfc_phy_ops i2c_phy_ops = {
 	.write = microread_i2c_write,
 	.enable = microread_i2c_enable,
 	.disable = microread_i2c_disable,
diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
index b1d3975e8a81..a5d5c3ec65f9 100644
--- a/drivers/nfc/microread/microread.c
+++ b/drivers/nfc/microread/microread.c
@@ -152,7 +152,7 @@ static struct nfc_hci_gate microread_gates[] = {
 #define MICROREAD_CMD_TAILROOM	2
 
 struct microread_info {
-	struct nfc_phy_ops *phy_ops;
+	const struct nfc_phy_ops *phy_ops;
 	void *phy_id;
 
 	struct nfc_hci_dev *hdev;
@@ -641,9 +641,9 @@ static struct nfc_hci_ops microread_hci_ops = {
 	.event_received = microread_event_received,
 };
 
-int microread_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
-		    int phy_headroom, int phy_tailroom, int phy_payload,
-		    struct nfc_hci_dev **hdev)
+int microread_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
+		    char *llc_name, int phy_headroom, int phy_tailroom,
+		    int phy_payload, struct nfc_hci_dev **hdev)
 {
 	struct microread_info *info;
 	unsigned long quirks = 0;
diff --git a/drivers/nfc/microread/microread.h b/drivers/nfc/microread/microread.h
index 044f5e456375..76152d7aa53c 100644
--- a/drivers/nfc/microread/microread.h
+++ b/drivers/nfc/microread/microread.h
@@ -10,9 +10,9 @@
 
 #define DRIVER_DESC "NFC driver for microread"
 
-int microread_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
-		    int phy_headroom, int phy_tailroom, int phy_payload,
-		    struct nfc_hci_dev **hdev);
+int microread_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
+		    char *llc_name, int phy_headroom, int phy_tailroom,
+		    int phy_payload, struct nfc_hci_dev **hdev);
 
 void microread_remove(struct nfc_hci_dev *hdev);
 
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index de59e439c369..37d26f01986b 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -515,7 +515,7 @@ static irqreturn_t pn544_hci_i2c_irq_thread_fn(int irq, void *phy_id)
 	return IRQ_HANDLED;
 }
 
-static struct nfc_phy_ops i2c_phy_ops = {
+static const struct nfc_phy_ops i2c_phy_ops = {
 	.write = pn544_hci_i2c_write,
 	.enable = pn544_hci_i2c_enable,
 	.disable = pn544_hci_i2c_disable,
diff --git a/drivers/nfc/pn544/pn544.c b/drivers/nfc/pn544/pn544.c
index b788870473e8..23faa46bb486 100644
--- a/drivers/nfc/pn544/pn544.c
+++ b/drivers/nfc/pn544/pn544.c
@@ -108,7 +108,7 @@ static struct nfc_hci_gate pn544_gates[] = {
 #define PN544_CMDS_HEADROOM	2
 
 struct pn544_hci_info {
-	struct nfc_phy_ops *phy_ops;
+	const struct nfc_phy_ops *phy_ops;
 	void *phy_id;
 
 	struct nfc_hci_dev *hdev;
@@ -901,9 +901,10 @@ static struct nfc_hci_ops pn544_hci_ops = {
 	.disable_se = pn544_hci_disable_se,
 };
 
-int pn544_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
-		    int phy_headroom, int phy_tailroom, int phy_payload,
-		    fw_download_t fw_download, struct nfc_hci_dev **hdev)
+int pn544_hci_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
+		    char *llc_name, int phy_headroom, int phy_tailroom,
+		    int phy_payload, fw_download_t fw_download,
+		    struct nfc_hci_dev **hdev)
 {
 	struct pn544_hci_info *info;
 	u32 protocols;
diff --git a/drivers/nfc/pn544/pn544.h b/drivers/nfc/pn544/pn544.h
index 5634ba215ead..c6fe3e11e0c8 100644
--- a/drivers/nfc/pn544/pn544.h
+++ b/drivers/nfc/pn544/pn544.h
@@ -16,9 +16,10 @@
 typedef int (*fw_download_t)(void *context, const char *firmware_name,
 				u8 hw_variant);
 
-int pn544_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops, char *llc_name,
-		    int phy_headroom, int phy_tailroom, int phy_payload,
-		    fw_download_t fw_download, struct nfc_hci_dev **hdev);
+int pn544_hci_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
+		    char *llc_name, int phy_headroom, int phy_tailroom,
+		    int phy_payload, fw_download_t fw_download,
+		    struct nfc_hci_dev **hdev);
 void pn544_hci_remove(struct nfc_hci_dev *hdev);
 
 #endif /* __LOCAL_PN544_H_ */
diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 46981405e8b1..ccf6152ebb9f 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -186,7 +186,7 @@ static irqreturn_t st_nci_irq_thread_fn(int irq, void *phy_id)
 	return IRQ_HANDLED;
 }
 
-static struct nfc_phy_ops i2c_phy_ops = {
+static const struct nfc_phy_ops i2c_phy_ops = {
 	.write = st_nci_i2c_write,
 	.enable = st_nci_i2c_enable,
 	.disable = st_nci_i2c_disable,
diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index 5d74c674368a..e9dc313b333e 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -253,9 +253,9 @@ static void ndlc_t2_timeout(struct timer_list *t)
 	schedule_work(&ndlc->sm_work);
 }
 
-int ndlc_probe(void *phy_id, struct nfc_phy_ops *phy_ops, struct device *dev,
-	       int phy_headroom, int phy_tailroom, struct llt_ndlc **ndlc_id,
-	       struct st_nci_se_status *se_status)
+int ndlc_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
+	       struct device *dev, int phy_headroom, int phy_tailroom,
+	       struct llt_ndlc **ndlc_id, struct st_nci_se_status *se_status)
 {
 	struct llt_ndlc *ndlc;
 
diff --git a/drivers/nfc/st-nci/ndlc.h b/drivers/nfc/st-nci/ndlc.h
index 066e2fd75238..c24ce9b0df52 100644
--- a/drivers/nfc/st-nci/ndlc.h
+++ b/drivers/nfc/st-nci/ndlc.h
@@ -16,7 +16,7 @@ struct st_nci_se_status;
 /* Low Level Transport description */
 struct llt_ndlc {
 	struct nci_dev *ndev;
-	struct nfc_phy_ops *ops;
+	const struct nfc_phy_ops *ops;
 	void *phy_id;
 
 	struct timer_list t1_timer;
@@ -45,8 +45,8 @@ int ndlc_open(struct llt_ndlc *ndlc);
 void ndlc_close(struct llt_ndlc *ndlc);
 int ndlc_send(struct llt_ndlc *ndlc, struct sk_buff *skb);
 void ndlc_recv(struct llt_ndlc *ndlc, struct sk_buff *skb);
-int ndlc_probe(void *phy_id, struct nfc_phy_ops *phy_ops, struct device *dev,
-	       int phy_headroom, int phy_tailroom, struct llt_ndlc **ndlc_id,
-	       struct st_nci_se_status *se_status);
+int ndlc_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
+	       struct device *dev, int phy_headroom, int phy_tailroom,
+	       struct llt_ndlc **ndlc_id, struct st_nci_se_status *se_status);
 void ndlc_remove(struct llt_ndlc *ndlc);
 #endif /* __LOCAL_NDLC_H__ */
diff --git a/drivers/nfc/st-nci/spi.c b/drivers/nfc/st-nci/spi.c
index 250d56f204c3..a620c34790e6 100644
--- a/drivers/nfc/st-nci/spi.c
+++ b/drivers/nfc/st-nci/spi.c
@@ -198,7 +198,7 @@ static irqreturn_t st_nci_irq_thread_fn(int irq, void *phy_id)
 	return IRQ_HANDLED;
 }
 
-static struct nfc_phy_ops spi_phy_ops = {
+static const struct nfc_phy_ops spi_phy_ops = {
 	.write = st_nci_spi_write,
 	.enable = st_nci_spi_enable,
 	.disable = st_nci_spi_disable,
diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index 6ca0d2f56b18..583c36d4ff67 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -935,7 +935,7 @@ static struct nfc_hci_ops st21nfca_hci_ops = {
 	.se_io = st21nfca_hci_se_io,
 };
 
-int st21nfca_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops,
+int st21nfca_hci_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
 		       char *llc_name, int phy_headroom, int phy_tailroom,
 		       int phy_payload, struct nfc_hci_dev **hdev,
 			   struct st21nfca_se_status *se_status)
diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 7a9f4d71707e..9dc9693a7356 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -482,7 +482,7 @@ static irqreturn_t st21nfca_hci_irq_thread_fn(int irq, void *phy_id)
 	return IRQ_HANDLED;
 }
 
-static struct nfc_phy_ops i2c_phy_ops = {
+static const struct nfc_phy_ops i2c_phy_ops = {
 	.write = st21nfca_hci_i2c_write,
 	.enable = st21nfca_hci_i2c_enable,
 	.disable = st21nfca_hci_i2c_disable,
diff --git a/drivers/nfc/st21nfca/st21nfca.h b/drivers/nfc/st21nfca/st21nfca.h
index 5e0de0fef1d4..cb6ad916be91 100644
--- a/drivers/nfc/st21nfca/st21nfca.h
+++ b/drivers/nfc/st21nfca/st21nfca.h
@@ -144,7 +144,7 @@ struct st21nfca_se_info {
 };
 
 struct st21nfca_hci_info {
-	struct nfc_phy_ops *phy_ops;
+	const struct nfc_phy_ops *phy_ops;
 	void *phy_id;
 
 	struct nfc_hci_dev *hdev;
@@ -163,7 +163,7 @@ struct st21nfca_hci_info {
 	struct st21nfca_vendor_info vendor_info;
 };
 
-int st21nfca_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops,
+int st21nfca_hci_probe(void *phy_id, const struct nfc_phy_ops *phy_ops,
 		       char *llc_name, int phy_headroom, int phy_tailroom,
 		       int phy_payload, struct nfc_hci_dev **hdev,
 		       struct st21nfca_se_status *se_status);
-- 
2.27.0

