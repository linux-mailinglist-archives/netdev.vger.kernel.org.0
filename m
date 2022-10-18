Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421DE60200B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 02:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiJRA63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 20:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiJRA61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 20:58:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E739E2CE07
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 17:58:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id h2so4993961plb.2
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 17:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GS9wuI4stdl/iwGMqY4V89YBp73mErJag0dwmTlE4O0=;
        b=aTBLwfjGHqYKLViUibGINPhfjZpfpSBEKDVpXDqUtcUOO6PaSrsfZ0A6j1G4lss4ym
         clXRE7frAmHrGlVERZo3BVFrjsDpdSUyR6WHGY5Bzxt+v8qVvUI0LFlcOuSMuV34nfX7
         yJSEqPuOGsr9pjxNhCk0s5t/JdyhXZ+ocp4ZQnMYlJTczYVGCoDcoxUwTHZ/7z0kBq8p
         0SCumhH/JZxN2c5JYS+0vQa7fQK2vnetWZGavtH1zz9G1NdlFUX1+TulUU8WVB/2lOY0
         TrhjyOa+5Es1ZVNVdRpqFyES9XusAV1080q0ZSfv8eRrXRrcrc6nfjLsyg7matWPLErw
         HL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GS9wuI4stdl/iwGMqY4V89YBp73mErJag0dwmTlE4O0=;
        b=vq/QYwWK45LrkssRt7iTz/Dmet186wGxVae1Ly6LRMV2Lx9hxhE6f4y51Jmavnm0eH
         Q6VPo1pfMUH26Nk05TkMfAJgJlDQxTJi6mClT9GHoNP6+0lUiqoR3aWkWtY6I49IaRG0
         qi+KNq7S6VAop4MqqSqLLCrGzWsiksIEqiHmBzN2wi9lFFpFsyNv4IDyBkPmiSR+Vdmi
         3I3nKvCuqVtogQYK0iD4IfVqRJFGtOJRFMRWSQ0ueN/LlEr+oDQR8egyIpGRO1hLUDFg
         QDOUzOrb12E+aNxqseV8SZeYC9Uoqu2IjflTg6b3QhGk5nOHI7ms/JG4nhBKq533YYZe
         wImA==
X-Gm-Message-State: ACrzQf3by/7Wh/SsrLHICfnXsMome4SzTQw3o7URYO89y9r2bJ/698J1
        h9S7j+3XVYyabEA00jrH4LTmbRWQBql9Tw==
X-Google-Smtp-Source: AMsMyM6D0EiFHqQ22T3UCBemhgZ3wk5j/A1iqoyyfhQhKwgrcOTDfUZajqvfVou2h7NC9TJmEF1Wmg==
X-Received: by 2002:a17:902:d510:b0:185:4b76:6277 with SMTP id b16-20020a170902d51000b001854b766277mr374543plg.82.1666054701381;
        Mon, 17 Oct 2022 17:58:21 -0700 (PDT)
Received: from localhost ([128.107.241.162])
        by smtp.gmail.com with UTF8SMTPSA id i29-20020a63131d000000b00439f027789asm6785452pgl.59.2022.10.17.17.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 17:58:20 -0700 (PDT)
From:   Govindarajulu Varadarajan <govind.varadar@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     benve@cisco.com,
        Govindarajulu Varadarajan <govind.varadar@gmail.com>
Subject: [PATCH net-next] enic: define constants for legacy interrupts offset
Date:   Mon, 17 Oct 2022 17:58:04 -0700
Message-Id: <20221018005804.188643-1-govind.varadar@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use macro instead of function calls. These values are constant and will
not change.

Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
---
 drivers/net/ethernet/cisco/enic/enic.h      | 23 ++++++---------------
 drivers/net/ethernet/cisco/enic/enic_main.c | 11 +++++-----
 2 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic.h b/drivers/net/ethernet/cisco/enic/enic.h
index a0964b629ffc..300ad05ee05b 100644
--- a/drivers/net/ethernet/cisco/enic/enic.h
+++ b/drivers/net/ethernet/cisco/enic/enic.h
@@ -226,21 +226,6 @@ static inline unsigned int enic_cq_wq(struct enic *enic, unsigned int wq)
 	return enic->rq_count + wq;
 }
 
-static inline unsigned int enic_legacy_io_intr(void)
-{
-	return 0;
-}
-
-static inline unsigned int enic_legacy_err_intr(void)
-{
-	return 1;
-}
-
-static inline unsigned int enic_legacy_notify_intr(void)
-{
-	return 2;
-}
-
 static inline unsigned int enic_msix_rq_intr(struct enic *enic,
 	unsigned int rq)
 {
@@ -258,6 +243,10 @@ static inline unsigned int enic_msix_err_intr(struct enic *enic)
 	return enic->rq_count + enic->wq_count;
 }
 
+#define ENIC_LEGACY_IO_INTR	0
+#define ENIC_LEGACY_ERR_INTR	1
+#define ENIC_LEGACY_NOTIFY_INTR	2
+
 static inline unsigned int enic_msix_notify_intr(struct enic *enic)
 {
 	return enic->rq_count + enic->wq_count + 1;
@@ -267,7 +256,7 @@ static inline bool enic_is_err_intr(struct enic *enic, int intr)
 {
 	switch (vnic_dev_get_intr_mode(enic->vdev)) {
 	case VNIC_DEV_INTR_MODE_INTX:
-		return intr == enic_legacy_err_intr();
+		return intr == ENIC_LEGACY_ERR_INTR;
 	case VNIC_DEV_INTR_MODE_MSIX:
 		return intr == enic_msix_err_intr(enic);
 	case VNIC_DEV_INTR_MODE_MSI:
@@ -280,7 +269,7 @@ static inline bool enic_is_notify_intr(struct enic *enic, int intr)
 {
 	switch (vnic_dev_get_intr_mode(enic->vdev)) {
 	case VNIC_DEV_INTR_MODE_INTX:
-		return intr == enic_legacy_notify_intr();
+		return intr == ENIC_LEGACY_NOTIFY_INTR;
 	case VNIC_DEV_INTR_MODE_MSIX:
 		return intr == enic_msix_notify_intr(enic);
 	case VNIC_DEV_INTR_MODE_MSI:
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 29500d32e362..37bd38d772e8 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -448,9 +448,9 @@ static irqreturn_t enic_isr_legacy(int irq, void *data)
 {
 	struct net_device *netdev = data;
 	struct enic *enic = netdev_priv(netdev);
-	unsigned int io_intr = enic_legacy_io_intr();
-	unsigned int err_intr = enic_legacy_err_intr();
-	unsigned int notify_intr = enic_legacy_notify_intr();
+	unsigned int io_intr = ENIC_LEGACY_IO_INTR;
+	unsigned int err_intr = ENIC_LEGACY_ERR_INTR;
+	unsigned int notify_intr = ENIC_LEGACY_NOTIFY_INTR;
 	u32 pba;
 
 	vnic_intr_mask(&enic->intr[io_intr]);
@@ -1507,7 +1507,7 @@ static int enic_poll(struct napi_struct *napi, int budget)
 	struct enic *enic = netdev_priv(netdev);
 	unsigned int cq_rq = enic_cq_rq(enic, 0);
 	unsigned int cq_wq = enic_cq_wq(enic, 0);
-	unsigned int intr = enic_legacy_io_intr();
+	unsigned int intr = ENIC_LEGACY_IO_INTR;
 	unsigned int rq_work_to_do = budget;
 	unsigned int wq_work_to_do = ENIC_WQ_NAPI_BUDGET;
 	unsigned int  work_done, rq_work_done = 0, wq_work_done;
@@ -1856,8 +1856,7 @@ static int enic_dev_notify_set(struct enic *enic)
 	spin_lock_bh(&enic->devcmd_lock);
 	switch (vnic_dev_get_intr_mode(enic->vdev)) {
 	case VNIC_DEV_INTR_MODE_INTX:
-		err = vnic_dev_notify_set(enic->vdev,
-			enic_legacy_notify_intr());
+		err = vnic_dev_notify_set(enic->vdev, ENIC_LEGACY_NOTIFY_INTR);
 		break;
 	case VNIC_DEV_INTR_MODE_MSIX:
 		err = vnic_dev_notify_set(enic->vdev,
-- 
2.37.3

