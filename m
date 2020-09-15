Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC3326AD4B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgIOTPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 15:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbgIORLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:11:42 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597C1C06121C;
        Tue, 15 Sep 2020 10:10:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g4so4155453wrs.5;
        Tue, 15 Sep 2020 10:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=95AmpbnHs6EBKsNRujy6IyyFyDbmIcgHwJWElIu3//8=;
        b=bhyWGZQRKB9CFF2kmnkU8Atk6keUlwS30KlGYIiprvuLbydmJJIc4ZhuvUryI09og5
         nyyesPmZixYJbOm83xmqdsDCC71S/V5WrRzOEb1Rnoc42eax+LbclDseDT5g5j/ds6Cv
         1I7k4B9zzUJP1abqs9NL1FdksqU3NxCp4qDLqv5blQ23DQhr2/M30IYcCEWREbAlm6Ow
         pLIly09KMYjyN5FRAH5VnrZKFaQdlmt/R8oEuRP+NVazGJ3Whay6ilatzApL34wHJsvs
         4Kg7pQVu0lVHnludR37I9dzW6VGf0LPkYFFmdTox3Y+IpBM/wj9lQe9/S9i457g1HZod
         52oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=95AmpbnHs6EBKsNRujy6IyyFyDbmIcgHwJWElIu3//8=;
        b=B5k+Yi2nRYkwpLpTRpHQKpJLSu1ww66Tbr6HmVAnLNdJfOirMNf1fI1SeqLbfYt8Vn
         +RNnnpbXFF/rAe6m7oRXEkhcbwdRAF+NPo3Zk942nj4rcE9jJEA2g6mbUvpIEZsXKEFO
         Jwv5vZK5ndld6/HuYB8vDAy1j9NtNgQ4n71ywp/J/A9RnnBWewVDiamoj3PF/p04QnE6
         JX/oTgmVGN5Lb358I2HlaRsC0GFMBm00FBSSiHBQ9MIJke2eNGVP2RPN1esjG2x5hWzZ
         pJyglWsBkPCZMkWx6Ae1H0bDX9DNeYC6InY5R+2X979r04FObgjQkuUluIwrX/J3kIYP
         cfqw==
X-Gm-Message-State: AOAM533MtZlnCfTYSRlrvEnJbwRR/Ht7SsA2A7UmTlc6wXvsDNvfdbkl
        DVyxwk8i0yqh/a42W+slEjdh8SCVnKTVug==
X-Google-Smtp-Source: ABdhPJxHB8nDq+dGdHqqKigFmn7Hmw5QZv0+YycUSEX0fUjI5iiQ5rxKbTKOgF9CDvI7EqZPq7fSxA==
X-Received: by 2002:adf:ff83:: with SMTP id j3mr23198999wrr.135.1600189833279;
        Tue, 15 Sep 2020 10:10:33 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id b194sm356558wmd.42.2020.09.15.10.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 10:10:31 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v3 02/14] habanalabs/gaudi: add NIC firmware-related definitions
Date:   Tue, 15 Sep 2020 20:10:10 +0300
Message-Id: <20200915171022.10561-3-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200915171022.10561-1-oded.gabbay@gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
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

