Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2BA264C0A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgIJR6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgIJQNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:13:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCB7C0617BA;
        Thu, 10 Sep 2020 09:12:26 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id lo4so9519173ejb.8;
        Thu, 10 Sep 2020 09:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=f9VqUEtIFQY2Ox8OWjG/8do232WTuGvYl5Af6vWbEzQ=;
        b=s8c71q2T9OhpwDpvCo8qGfBLZ8ilNRYbIJ8INbnC8UECS58S8Wowy11WLbFV1nhw2V
         FFv8q+7hwBiEaTvrATBsnzZYRClYEgZll0F4qUTpNfsS8lLdyMktci46t37bGid9fbt4
         lN9o6cgHjbnenc6IuZLv1Mls8lqXdkvvpFAbJs/ucWmVUaSIy0BbfSPWsL0ZDMdeLrIx
         Io2xeNgCZEpeDzJK76kpYTBbGM6u5JaSZKC20dg9E9qyUztQgPz8kSOp4/F1p8PxKQz2
         cYn+fTEQS7T0b8A9YHSeD8I3Y5P3zDSbKGRFcs482oJK+v+8rSz3sO27p41vhqTCg4X9
         KYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=f9VqUEtIFQY2Ox8OWjG/8do232WTuGvYl5Af6vWbEzQ=;
        b=edmOLRq/0Du5Mhvc4BX1PFCkHGRHJytoOPQQKTHJQofDQFEOYh6xurTKrTmM2PsHC6
         JmX6rGhXLHKSg5060o+XZMeP2qfZFXOSrz7Fl2uQuS7fVbbDosTHGYr/GZumGaOooffu
         aFUnBtG1r/qcE8Lm3ZBNAWhK/KPz8z9djZbAB04EC4TQKa0vKzludHFP/yfFVmtmEN4U
         X3mrArfZsq1c0F/90k+eObslVsPmNDC3oTPgQm56DlIUTJ4STNt7Z5MxSiddk0XcZ5Fk
         SSY2HtPxMuRFfxvoKlsJ87cuoARiRG0twgCWdzqWWEkCr0tSQcxTUYxp+0xgCT5x8ISy
         S1TQ==
X-Gm-Message-State: AOAM532nrkb4oucEHvErzOE4JteNrlyuMwGWOeiLuRbQGIt7hTsZqvUq
        MPf63lzwrX5TdtVzdjmpNSYfQmnx9lU=
X-Google-Smtp-Source: ABdhPJzXx+TNQfI8k6Qb2+sAzMIMwcozUx/uaUa0o/YOYG9m8Wz1VCl0WqWU7JQPbJvBSt6iXOU34Q==
X-Received: by 2002:a17:906:a293:: with SMTP id i19mr9908052ejz.428.1599754344331;
        Thu, 10 Sep 2020 09:12:24 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:12:22 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 15/15] habanalabs/gaudi: add NIC init/fini calls from common code
Date:   Thu, 10 Sep 2020 19:11:26 +0300
Message-Id: <20200910161126.30948-16-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Finally, enable the NIC engines. Initialize the NIC ports mask variable
with full mask so all ports will be initialized.

Call the NIC init/fini from the common code.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 drivers/misc/habanalabs/common/device.c       | 18 +++++++++++++++
 drivers/misc/habanalabs/common/habanalabs.h   |  6 +++++
 .../misc/habanalabs/common/habanalabs_drv.c   |  1 +
 drivers/misc/habanalabs/common/pci.c          |  1 +
 drivers/misc/habanalabs/gaudi/gaudi.c         | 23 +++++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           | 12 ++++++++++
 6 files changed, 61 insertions(+)

diff --git a/drivers/misc/habanalabs/common/device.c b/drivers/misc/habanalabs/common/device.c
index 57f5b945fa41..8f8744e4f2c7 100644
--- a/drivers/misc/habanalabs/common/device.c
+++ b/drivers/misc/habanalabs/common/device.c
@@ -1077,6 +1077,12 @@ int hl_device_reset(struct hl_device *hdev, bool hard_reset,
 			goto out_err;
 		}
 
+		rc = hdev->asic_funcs->nic_init(hdev);
+		if (rc) {
+			dev_err(hdev->dev, "Failed to init NIC driver\n");
+			goto out_err;
+		}
+
 		hl_set_max_power(hdev);
 	} else {
 		rc = hdev->asic_funcs->soft_reset_late_init(hdev);
@@ -1312,6 +1318,13 @@ int hl_device_init(struct hl_device *hdev, struct class *hclass)
 		goto out_disabled;
 	}
 
+	rc = hdev->asic_funcs->nic_init(hdev);
+	if (rc) {
+		dev_err(hdev->dev, "Failed to init NIC driver\n");
+		rc = 0;
+		goto out_disabled;
+	}
+
 	/*
 	 * Expose devices and sysfs nodes to user.
 	 * From here there is no need to add char devices and create sysfs nodes
@@ -1463,6 +1476,11 @@ void hl_device_fini(struct hl_device *hdev)
 
 	hl_cb_pool_fini(hdev);
 
+	/* the NIC uses the kernel context for MMU mappings, therefore must be
+	 * cleaned before it
+	 */
+	hdev->asic_funcs->nic_fini(hdev);
+
 	/* Release kernel context */
 	if ((hdev->kernel_ctx) && (hl_ctx_put(hdev->kernel_ctx) != 1))
 		dev_err(hdev->dev, "kernel ctx is still alive\n");
diff --git a/drivers/misc/habanalabs/common/habanalabs.h b/drivers/misc/habanalabs/common/habanalabs.h
index 1f3735a64d88..1c1850114aa4 100644
--- a/drivers/misc/habanalabs/common/habanalabs.h
+++ b/drivers/misc/habanalabs/common/habanalabs.h
@@ -680,6 +680,10 @@ struct hl_info_mac_addr;
  *                    then the timeout is the default timeout for the specific
  *                    ASIC
  * @get_hw_state: retrieve the H/W state
+ * @nic_init: init the NIC H/W and I/F. This should be called in the final satge
+ *            of the init flow, as we must not have anything that might fail
+ *            during its initialization after the NIC init.
+ * @nic_fini: perform NIC cleanup.
  * @nic_control: Perform NIC related operations.
  * @nic_cq_mmap: map the NIC CQ buffer.
  * @pci_bars_map: Map PCI BARs.
@@ -786,6 +790,8 @@ struct hl_asic_funcs {
 	int (*send_cpu_message)(struct hl_device *hdev, u32 *msg,
 				u16 len, u32 timeout, long *result);
 	enum hl_device_hw_state (*get_hw_state)(struct hl_device *hdev);
+	int (*nic_init)(struct hl_device *hdev);
+	void (*nic_fini)(struct hl_device *hdev);
 	int (*nic_control)(struct hl_device *hdev, u32 op, void *input,
 				void *output);
 	int (*nic_cq_mmap)(struct hl_device *hdev, struct vm_area_struct *vma);
diff --git a/drivers/misc/habanalabs/common/habanalabs_drv.c b/drivers/misc/habanalabs/common/habanalabs_drv.c
index df92afc1b9d5..fcb28975fac5 100644
--- a/drivers/misc/habanalabs/common/habanalabs_drv.c
+++ b/drivers/misc/habanalabs/common/habanalabs_drv.c
@@ -247,6 +247,7 @@ static void set_driver_behavior_per_device(struct hl_device *hdev)
 	hdev->bmc_enable = 1;
 	hdev->hard_reset_on_fw_events = 1;
 	hdev->card_type = cpucp_card_type_pci;
+	hdev->nic_ports_mask = 0x3FF;
 	hdev->nic_ports_ext_mask = 0x3FF;
 	hdev->nic_auto_neg_mask = 0x3FF;
 	hdev->nic_load_fw = 0;
diff --git a/drivers/misc/habanalabs/common/pci.c b/drivers/misc/habanalabs/common/pci.c
index 923b2606e29f..c376ab4695ab 100644
--- a/drivers/misc/habanalabs/common/pci.c
+++ b/drivers/misc/habanalabs/common/pci.c
@@ -230,6 +230,7 @@ int hl_pci_set_inbound_region(struct hl_device *hdev, u8 region,
 			lower_32_bits(pci_region->addr));
 	rc |= hl_pci_iatu_write(hdev, offset + 0x18,
 			upper_32_bits(pci_region->addr));
+	/* Set bar type as memory */
 	rc |= hl_pci_iatu_write(hdev, offset + 0x0, 0);
 
 	/* Enable + bar/address match + match enable + bar number */
diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index eb733a48eb72..758a26b43cf2 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -882,6 +882,27 @@ static void gaudi_late_fini(struct hl_device *hdev)
 	hdev->hl_chip_info->info = NULL;
 }
 
+static int gaudi_nic_init(struct hl_device *hdev)
+{
+	/*
+	 * In init flow we initialize the NIC ports from scratch. In hard reset
+	 * flow, we get here after the NIC ports were halted, hence we only
+	 * need to reopen them.
+	 */
+	if (atomic_read(&hdev->in_reset)) {
+		gaudi_nic_ports_reopen(hdev);
+		return 0;
+	}
+
+	return gaudi_nic_ports_init(hdev);
+}
+
+static void gaudi_nic_fini(struct hl_device *hdev)
+{
+	/* must be called after MSI was disabled */
+	gaudi_nic_ports_fini(hdev);
+}
+
 static void gaudi_nic_handle_rx(struct gaudi_nic_device *gaudi_nic)
 {
 	/* at this point, interrupts were disabled by the H/W */
@@ -7482,6 +7503,8 @@ static const struct hl_asic_funcs gaudi_funcs = {
 	.get_eeprom_data = gaudi_get_eeprom_data,
 	.send_cpu_message = gaudi_send_cpu_message,
 	.get_hw_state = gaudi_get_hw_state,
+	.nic_init = gaudi_nic_init,
+	.nic_fini = gaudi_nic_fini,
 	.nic_control = gaudi_nic_control,
 	.nic_cq_mmap = gaudi_nic_cq_mmap,
 	.pci_bars_map = gaudi_pci_bars_map,
diff --git a/drivers/misc/habanalabs/goya/goya.c b/drivers/misc/habanalabs/goya/goya.c
index 6e98c830f6a2..e753b3a0079f 100644
--- a/drivers/misc/habanalabs/goya/goya.c
+++ b/drivers/misc/habanalabs/goya/goya.c
@@ -5265,6 +5265,16 @@ static enum hl_device_hw_state goya_get_hw_state(struct hl_device *hdev)
 	return RREG32(mmHW_STATE);
 }
 
+static int goya_nic_init(struct hl_device *hdev)
+{
+	return 0;
+}
+
+static void goya_nic_fini(struct hl_device *hdev)
+{
+
+}
+
 static int goya_nic_control(struct hl_device *hdev, u32 op, void *input,
 			void *output)
 {
@@ -5405,6 +5415,8 @@ static const struct hl_asic_funcs goya_funcs = {
 	.get_eeprom_data = goya_get_eeprom_data,
 	.send_cpu_message = goya_send_cpu_message,
 	.get_hw_state = goya_get_hw_state,
+	.nic_init = goya_nic_init,
+	.nic_fini = goya_nic_fini,
 	.nic_control = goya_nic_control,
 	.nic_cq_mmap = goya_nic_mmap,
 	.pci_bars_map = goya_pci_bars_map,
-- 
2.17.1

