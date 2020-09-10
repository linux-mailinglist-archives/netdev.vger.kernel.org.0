Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432BF264E30
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgIJTEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgIJQLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:11:51 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1959FC061796;
        Thu, 10 Sep 2020 09:11:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id q13so9520280ejo.9;
        Thu, 10 Sep 2020 09:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HqUXASV8/J3adrJxXgdebB7pk8ZpozkrNnLZPnpPNz4=;
        b=rMuYKT/nO+bCs0/PjntzsIL3yMzZX12bky9TbQC+p43luWertUNdPLHCmcEs5/s7lp
         aMpTMrWua4TtNULcw07fDXqnBINgH1XrvxHJIWztJiFx9CIAoONLTv76jjyb+KOeLXL4
         3qmjjJrxKDsUmixe4O0e3mLWt4BvDxNO1+n8YOYjPOKMM0yfFlv4kSV1DlHu3Z0QPt7G
         Sxrsc/6AClS5S8cVFamdUGYaYYcHJHUvI6NA0fp98W23kR+wAlUGCJVjXUX2jHRNMIGQ
         TLbSysOhH3k1zkQVt0nz4NR3HuPfLYLXBInwj2Z1XkO9opu57YWwgd5Y6odJPo4mqKpI
         qwhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HqUXASV8/J3adrJxXgdebB7pk8ZpozkrNnLZPnpPNz4=;
        b=S30Y7hc+qClbrgkk1YPhBWzYQo9Q27AYjcpcQMTquqF4s4If7L5Q2Nh0Ew19OV4bXj
         6TyOXdq3jSJuYAOzfzmDt+MzHKvStGJlLUJ2yvGnSHPuh4GBMdO9gem7Y5UQgaA+YmdU
         0wFxGbBNsDODTI8/pMkW2Bu8GwAv6PV3j8tfbq9Md+GGagbAF3zDtKQnhpHVf8nwxYFF
         6IgGFGRXGWjf2JAhMy7D/WNQLAEoIOiwJm8kJHfsRBu3qcpvGiwhThdWej2OQkmCyhFH
         Pxv5XDbQ+35W96+AK5Ijmukb+/7xrOEITMh/O3PWFi78/hcAfSmY9GHrCJcjok6TnaNS
         qRBg==
X-Gm-Message-State: AOAM532ldCcj00tjlj9jZT+ZY+cOb1dK7cgdDjKLo9aDG+fhEX27oO54
        0fTQWKV0VIlXb/bD1VNJ1tSP8XSE/aw=
X-Google-Smtp-Source: ABdhPJwGOMYluoHBIFuyJ+aF+8vL+XdnHF/jHh1znvtHTiq4P26wtwfyKLhzusCwoGLiDFzFFEzN4Q==
X-Received: by 2002:a17:906:8c8:: with SMTP id o8mr9460993eje.91.1599754308990;
        Thu, 10 Sep 2020 09:11:48 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:11:47 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org,
        Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH 02/15] habanalabs/gaudi: add NIC firmware-related definitions
Date:   Thu, 10 Sep 2020 19:11:13 +0300
Message-Id: <20200910161126.30948-3-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161126.30948-1-oded.gabbay@gmail.com>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Add new structures and messages that the driver use to interact with the
firmware to receive information and events (errors) about GAUDI's NIC.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
 .../misc/habanalabs/include/common/cpucp_if.h | 34 ++++++++++++++++---
 .../habanalabs/include/gaudi/gaudi_fw_if.h    | 24 +++++++++++++
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/habanalabs/include/common/cpucp_if.h b/drivers/misc/habanalabs/include/common/cpucp_if.h
index dcde440427b4..ace746bb206e 100644
--- a/drivers/misc/habanalabs/include/common/cpucp_if.h
+++ b/drivers/misc/habanalabs/include/common/cpucp_if.h
@@ -9,6 +9,7 @@
 #define CPUCP_IF_H
 
 #include <linux/types.h>
+#include <linux/if_ether.h>
 
 /*
  * EVENT QUEUE
@@ -199,6 +200,11 @@ enum pq_init_status {
  *       CpuCP to write to the structure, to prevent data corruption in case of
  *       mismatched driver/FW versions.
  *
+ * CPUCP_PACKET_NIC_INFO_GET -
+ *       Fetch information from the device regarding the NIC. the host's driver
+ *       passes the max size it allows the CpuCP to write to the structure, to
+ *       prevent data corruption in case of mismatched driver/FW versions.
+ *
  * CPUCP_PACKET_TEMPERATURE_SET -
  *       Set the value of the offset property of a specified thermal sensor.
  *       The packet's arguments specify the desired sensor and the field to
@@ -238,12 +244,12 @@ enum cpucp_packet_id {
 	CPUCP_PACKET_MAX_POWER_GET,		/* sysfs */
 	CPUCP_PACKET_MAX_POWER_SET,		/* sysfs */
 	CPUCP_PACKET_EEPROM_DATA_GET,		/* sysfs */
-	CPUCP_RESERVED,
+	CPUCP_PACKET_NIC_INFO_GET,		/* internal */
 	CPUCP_PACKET_TEMPERATURE_SET,		/* sysfs */
 	CPUCP_PACKET_VOLTAGE_SET,		/* sysfs */
 	CPUCP_PACKET_CURRENT_SET,		/* sysfs */
-	CPUCP_PACKET_PCIE_THROUGHPUT_GET,		/* internal */
-	CPUCP_PACKET_PCIE_REPLAY_CNT_GET,		/* internal */
+	CPUCP_PACKET_PCIE_THROUGHPUT_GET,	/* internal */
+	CPUCP_PACKET_PCIE_REPLAY_CNT_GET,	/* internal */
 	CPUCP_PACKET_TOTAL_ENERGY_GET,		/* internal */
 };
 
@@ -288,7 +294,7 @@ struct cpucp_packet {
 		/* For led set */
 		__le32 led_index;
 
-		/* For get CpuCP info/EEPROM data */
+		/* For get CpuCP info/EEPROM data/NIC info */
 		__le32 data_max_size;
 	};
 
@@ -367,6 +373,12 @@ struct eq_generic_event {
 #define CARD_NAME_MAX_LEN		16
 #define VERSION_MAX_LEN			128
 #define CPUCP_MAX_SENSORS		128
+#define CPUCP_MAX_NICS			128
+#define CPUCP_LANES_PER_NIC		4
+#define CPUCP_NIC_QSFP_EEPROM_MAX_LEN	1024
+#define CPUCP_MAX_NIC_LANES		(CPUCP_MAX_NICS * CPUCP_LANES_PER_NIC)
+#define CPUCP_NIC_MASK_ARR_LEN		((CPUCP_MAX_NICS + 63) / 64)
+#define CPUCP_NIC_POLARITY_ARR_LEN	((CPUCP_MAX_NIC_LANES + 63) / 64)
 
 struct cpucp_sensor {
 	__le32 type;
@@ -415,4 +427,18 @@ struct cpucp_info {
 	char card_name[CARD_NAME_MAX_LEN];
 };
 
+struct cpucp_mac_addr {
+	__u8 mac_addr[ETH_ALEN];
+};
+
+struct cpucp_nic_info {
+	struct cpucp_mac_addr mac_addrs[CPUCP_MAX_NICS];
+	__le64 link_mask[CPUCP_NIC_MASK_ARR_LEN];
+	__le64 pol_tx_mask[CPUCP_NIC_POLARITY_ARR_LEN];
+	__le64 pol_rx_mask[CPUCP_NIC_POLARITY_ARR_LEN];
+	__le64 link_ext_mask[CPUCP_NIC_MASK_ARR_LEN];
+	__u8 qsfp_eeprom[CPUCP_NIC_QSFP_EEPROM_MAX_LEN];
+	__le64 auto_neg_mask[CPUCP_NIC_MASK_ARR_LEN];
+};
+
 #endif /* CPUCP_IF_H */
diff --git a/drivers/misc/habanalabs/include/gaudi/gaudi_fw_if.h b/drivers/misc/habanalabs/include/gaudi/gaudi_fw_if.h
index 8aadc6357da1..d61a4c87b765 100644
--- a/drivers/misc/habanalabs/include/gaudi/gaudi_fw_if.h
+++ b/drivers/misc/habanalabs/include/gaudi/gaudi_fw_if.h
@@ -8,6 +8,8 @@
 #ifndef GAUDI_FW_IF_H
 #define GAUDI_FW_IF_H
 
+#include <linux/types.h>
+
 #define GAUDI_EVENT_QUEUE_MSI_IDX	8
 #define GAUDI_NIC_PORT1_MSI_IDX		10
 #define GAUDI_NIC_PORT3_MSI_IDX		12
@@ -31,6 +33,28 @@ enum gaudi_pll_index {
 	IF_PLL
 };
 
+enum gaudi_nic_axi_error {
+	RXB,
+	RXE,
+	TXS,
+	TXE,
+	QPC_RESP,
+	NON_AXI_ERR,
+};
+
+/*
+ * struct eq_nic_sei_event - describes an AXI error cause.
+ * @axi_error_cause: one of the events defined in enum gaudi_nic_axi_error.
+ * @id: can be either 0 or 1, to further describe unit with interrupt cause
+ *      (i.e. TXE0 or TXE1).
+ * @pad[6]: padding structure to 64bit.
+ */
+struct eq_nic_sei_event {
+	__u8 axi_error_cause;
+	__u8 id;
+	__u8 pad[6];
+};
+
 #define GAUDI_PLL_FREQ_LOW		200000000 /* 200 MHz */
 
 #endif /* GAUDI_FW_IF_H */
-- 
2.17.1

