Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF1061DDE4
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 20:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiKETty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 15:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKETtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 15:49:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5688C10572;
        Sat,  5 Nov 2022 12:49:50 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id f27so21141990eje.1;
        Sat, 05 Nov 2022 12:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5Uw4achefntbuDEmtPAMe547HVX41/nVL2BQsQgEJM=;
        b=FhCNcouAY5y5+AGNSTDP5XFLuOrKlAGBqJFYOo0biY635FJLas5iDZCn2pWESDoR/d
         vFWXuvDJDgNzMmPnn2U/5DlggQlCEgBfo/qraD3qc8ANARFWx5zOo8LfzBY7kzeiqOAS
         42y7vDYO8N/CoxJPHASA3OA5d0ptjuMmCvU50fD8yXTbS6F+ZCzyrWN85Wv5J+ntoW8r
         vsf5Mx1HsJ/1+la1ab33HIx4FjC80ZSBza60CF/nic6OXXGNffOK1c5OHlcWgCzaCH5A
         Y3by5pi2w6i8gWRxFJQmUuEWsbJW+m5GPQ7r89TSAAIyDUnYTGfW2pXJcKvRyvoVC8EA
         XfkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J5Uw4achefntbuDEmtPAMe547HVX41/nVL2BQsQgEJM=;
        b=2Pbwjse6I+8fnWSSSUAYj9vXoH8NOLYjfH4CwHSDqOQNTJQKclQPzvtLDYtowR7lqf
         LsUkbZvxBRXBaeQPaAg4ff21eqZ9YRnVtR7Gyvkkn9gUEbgfb2l/q5e0tygQxom/IrwS
         V5cMrhBI4mQ/jGyH/os6up8+dqr3P3bX2ick9UD65raRYTW149txO2oT+NgyqJgIdagS
         efCJd99VXQk4OVW1m7qpOFo2i3YZcQY1KIV5bS+hjUyFGD81S1mDclX9LI0Gd8bL2x1a
         G8lQaadN0c4xokwVvubzsGYUT9W2POk2ZjY/WLUx1aUi5ArSIA8pgBtlaUioAWkznXnW
         EWyA==
X-Gm-Message-State: ACrzQf2GAt2+6qsbaOm8eJ1NtFWHEw7HgTRyFYDuIy8KwGVdAxMsS67V
        31rXNS4vQEd0eQAzFRkPVNHjt3yzGq/2fQ==
X-Google-Smtp-Source: AMsMyM70hd6yCcN13TFAX1z7xRADsiD537lD/kbznKBVMkYevbQFVIitQC1j2CNHnGuT48zwFXV4Vw==
X-Received: by 2002:a17:907:8688:b0:791:91a0:fdb3 with SMTP id qa8-20020a170907868800b0079191a0fdb3mr38971607ejc.499.1667677788695;
        Sat, 05 Nov 2022 12:49:48 -0700 (PDT)
Received: from fedora.. (dh207-96-23.xnet.hr. [88.207.96.23])
        by smtp.googlemail.com with ESMTPSA id et19-20020a170907295300b0079b9f7509a0sm1289409ejc.52.2022.11.05.12.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 12:49:48 -0700 (PDT)
From:   Robert Marko <robimarko@gmail.com>
To:     mani@kernel.org, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, elder@linaro.org,
        hemantk@codeaurora.org, quic_jhugo@quicinc.com,
        quic_qianyu@quicinc.com, bbhatt@codeaurora.org,
        mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ansuelsmth@gmail.com, Robert Marko <robimarko@gmail.com>
Subject: [PATCH 2/2] wifi: ath11k: use unique QRTR instance ID
Date:   Sat,  5 Nov 2022 20:49:43 +0100
Message-Id: <20221105194943.826847-2-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105194943.826847-1-robimarko@gmail.com>
References: <20221105194943.826847-1-robimarko@gmail.com>
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

Currently, trying to use AHB + PCI/MHI cards or multiple PCI/MHI cards
will cause a clash in the QRTR instance node ID and prevent the driver
from talking via QMI to the card and thus initializing it with:
[    9.836329] ath11k c000000.wifi: host capability request failed: 1 90
[    9.842047] ath11k c000000.wifi: failed to send qmi host cap: -22

So, in order to allow for this combination of cards, especially AHB + PCI
cards like IPQ8074 + QCN9074 (Used by me and tested on) set the desired
QRTR instance ID offset by calculating a unique one based on PCI domain
and bus ID-s and writing it to bits 7-0 of BHI_ERRDBG2 MHI register by
using the SBL state callback that is added as part of the series.
We also have to make sure that new QRTR offset is added on top of the
default QRTR instance ID-s that are currently used in the driver.

This finally allows using AHB + PCI or multiple PCI cards on the same
system.

Before:
root@OpenWrt:/# qrtr-lookup
  Service Version Instance Node  Port
     1054       1        0    7     1 <unknown>
       69       1        2    7     3 ATH10k WLAN firmware service

After:
root@OpenWrt:/# qrtr-lookup
  Service Version Instance Node  Port
     1054       1        0    7     1 <unknown>
       69       1        2    7     3 ATH10k WLAN firmware service
       15       1        0    8     1 Test service
       69       1        8    8     2 ATH10k WLAN firmware service

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 47 ++++++++++++++++++---------
 drivers/net/wireless/ath/ath11k/mhi.h |  3 ++
 drivers/net/wireless/ath/ath11k/pci.c |  5 ++-
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 86995e8dc913..23e85ea902f5 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -294,6 +294,32 @@ static void ath11k_mhi_op_runtime_put(struct mhi_controller *mhi_cntrl)
 {
 }
 
+static int ath11k_mhi_op_read_reg(struct mhi_controller *mhi_cntrl,
+				  void __iomem *addr,
+				  u32 *out)
+{
+	*out = readl(addr);
+
+	return 0;
+}
+
+static void ath11k_mhi_op_write_reg(struct mhi_controller *mhi_cntrl,
+				    void __iomem *addr,
+				    u32 val)
+{
+	writel(val, addr);
+}
+
+static void ath11k_mhi_qrtr_instance_set(struct mhi_controller *mhi_cntrl)
+{
+	struct ath11k_base *ab = dev_get_drvdata(mhi_cntrl->cntrl_dev);
+
+	ath11k_mhi_op_write_reg(mhi_cntrl,
+				mhi_cntrl->bhi + BHI_ERRDBG2,
+				FIELD_PREP(QRTR_INSTANCE_MASK,
+				ab->qmi.service_ins_id - ab->hw_params.qmi_service_ins_id));
+}
+
 static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
 {
 	switch (reason) {
@@ -315,6 +341,8 @@ static char *ath11k_mhi_op_callback_to_str(enum mhi_callback reason)
 		return "MHI_CB_FATAL_ERROR";
 	case MHI_CB_BW_REQ:
 		return "MHI_CB_BW_REQ";
+	case MHI_CB_EE_SBL_MODE:
+		return "MHI_CB_EE_SBL_MODE";
 	default:
 		return "UNKNOWN";
 	}
@@ -336,27 +364,14 @@ static void ath11k_mhi_op_status_cb(struct mhi_controller *mhi_cntrl,
 		if (!(test_bit(ATH11K_FLAG_UNREGISTERING, &ab->dev_flags)))
 			queue_work(ab->workqueue_aux, &ab->reset_work);
 		break;
+	case MHI_CB_EE_SBL_MODE:
+		ath11k_mhi_qrtr_instance_set(mhi_cntrl);
+		break;
 	default:
 		break;
 	}
 }
 
-static int ath11k_mhi_op_read_reg(struct mhi_controller *mhi_cntrl,
-				  void __iomem *addr,
-				  u32 *out)
-{
-	*out = readl(addr);
-
-	return 0;
-}
-
-static void ath11k_mhi_op_write_reg(struct mhi_controller *mhi_cntrl,
-				    void __iomem *addr,
-				    u32 val)
-{
-	writel(val, addr);
-}
-
 static int ath11k_mhi_read_addr_from_dt(struct mhi_controller *mhi_ctrl)
 {
 	struct device_node *np;
diff --git a/drivers/net/wireless/ath/ath11k/mhi.h b/drivers/net/wireless/ath/ath11k/mhi.h
index 8d9f852da695..0db308bc3047 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.h
+++ b/drivers/net/wireless/ath/ath11k/mhi.h
@@ -16,6 +16,9 @@
 #define MHICTRL					0x38
 #define MHICTRL_RESET_MASK			0x2
 
+#define BHI_ERRDBG2				0x38
+#define QRTR_INSTANCE_MASK			GENMASK(7, 0)
+
 int ath11k_mhi_start(struct ath11k_pci *ar_pci);
 void ath11k_mhi_stop(struct ath11k_pci *ar_pci);
 int ath11k_mhi_register(struct ath11k_pci *ar_pci);
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 99cf3357c66e..cd26c1567415 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -370,13 +370,16 @@ static void ath11k_pci_sw_reset(struct ath11k_base *ab, bool power_on)
 static void ath11k_pci_init_qmi_ce_config(struct ath11k_base *ab)
 {
 	struct ath11k_qmi_ce_cfg *cfg = &ab->qmi.ce_cfg;
+	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
+	struct pci_bus *bus = ab_pci->pdev->bus;
 
 	cfg->tgt_ce = ab->hw_params.target_ce_config;
 	cfg->tgt_ce_len = ab->hw_params.target_ce_count;
 
 	cfg->svc_to_ce_map = ab->hw_params.svc_to_ce_map;
 	cfg->svc_to_ce_map_len = ab->hw_params.svc_to_ce_map_len;
-	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
+	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id +
+	(((pci_domain_nr(bus) & 0xF) << 4) | (bus->number & 0xF));
 
 	ath11k_ce_get_shadow_config(ab, &cfg->shadow_reg_v2,
 				    &cfg->shadow_reg_v2_len);
-- 
2.38.1

