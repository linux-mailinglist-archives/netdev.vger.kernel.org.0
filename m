Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108CB267B1C
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgILO56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgILOlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:41:20 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93246C061573;
        Sat, 12 Sep 2020 07:41:19 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t16so13351478edw.7;
        Sat, 12 Sep 2020 07:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=95AmpbnHs6EBKsNRujy6IyyFyDbmIcgHwJWElIu3//8=;
        b=pf/nBkYLsuQQfeQKOUR4S1qc8v7siyW3KGvz273t1sm2wtdm7qjwB80HyC9nj3BrVP
         elxx2cT9jA+4uZU4rzE+Dn/ovl/VOt7S5+qDyslvSPAbZGdCv94CJrtCCMapD99/5w00
         JsKqpvp8gavAkEGb7UXh+1IPdfrmIlxRV2G7tWECkXGrtH7t4xfp0deAB07WOwfoYocn
         s7eunbSJ9KCHnSazJYfgHGteWX53b/GEz14jqYIOpUjpR/jQI1r10Uls4cV2ZChUf2fI
         hWIq88lR6O2bhDOHzMKkc/Qm4Gvo1m8+UEv3eymtKH5jZg4jrxHABXHyr7/dX1TmeqlD
         bbtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=95AmpbnHs6EBKsNRujy6IyyFyDbmIcgHwJWElIu3//8=;
        b=Q74zKQKOIf05hlIysu66QhSpyhgC9wrfM/zlRGDnmofX+7fT31fIdzZPUH+hHI/YQ+
         eIU9DvcgkmKjFb9Q2ZwjPS4FKsKElNDKF3KGmnYFAEQXjHOVOZl8rDKhW7ZThxzMWWiY
         cQqKcIJuIJFctsQRkz0NVSXgTdYzuJzIJpEOm0vnyRmRwdZ/ssTxS7W5pE4GdPcYDBpt
         VOX+SW4d3Z0gTtyhQj6QIEzUBbsAFZ0C5Xym6qfEGDRrXy4ePjjFhEi0yglQP+Tw5Q+w
         MEXeUmLvtegEPwFsDGe0ZtSF5CbMmrETJy7gY6ikuWTBqvOTZP6XAqJuMGJB1OX/eHL0
         85aQ==
X-Gm-Message-State: AOAM532ca78C+T3lB+hKZ/00Wxj/kfevfZ4vbnKI+26h0hun1CLnVzzB
        cgyG0nzo2K6wWXaOs2E5Q2U3iT2avJg=
X-Google-Smtp-Source: ABdhPJxRFHFjy41tAy0Znw/qCTyohb7C8KVCrPFjsF0oWs/4uBb9u6YJQNmAGzqCdf7c293Gcbj9eA==
X-Received: by 2002:a05:6402:2c7:: with SMTP id b7mr8875997edx.125.1599921677573;
        Sat, 12 Sep 2020 07:41:17 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:16 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v2 02/14] habanalabs/gaudi: add NIC firmware-related definitions
Date:   Sat, 12 Sep 2020 17:40:54 +0300
Message-Id: <20200912144106.11799-3-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912144106.11799-1-oded.gabbay@gmail.com>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
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
index 2a5c9cb3d505..782b8b8636be 100644
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
@@ -244,12 +250,12 @@ enum cpucp_packet_id {
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
 	CPUCP_PACKET_PLL_REG_GET,		/* internal */
 };
@@ -300,7 +306,7 @@ struct cpucp_packet {
 		/* For led set */
 		__le32 led_index;
 
-		/* For get CpuCP info/EEPROM data */
+		/* For get CpuCP info/EEPROM data/NIC info */
 		__le32 data_max_size;
 	};
 
@@ -392,6 +398,12 @@ struct eq_generic_event {
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
@@ -440,4 +452,18 @@ struct cpucp_info {
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

