Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4158351F43
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhDATEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbhDATDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:03:25 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D468CC0F26F2
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 10:56:24 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v8so1381917plz.10
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 10:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IhKFr4QryGuJvP1nrQlUiJLdZx7k8fJyCdy8lWdXyik=;
        b=Jt3+CmpobW35WZ0WROatrWxg2RjgXcY5IgvWfJHbNHpRUI78k3/4fBknVqxFr6YeJ4
         /ZjtvPIYXHd/0deYE/oSUoWU4QfRPcOi3PV/8wyXCpBMFrmxAhFOWCjYfjUd1bcJ5/d1
         luGR+2LB4ZsRQ9rk4tcL/asL2bI7vOBJEwq3VaYHyOrrRc41VnUjKbhU4X0DJdSjOM//
         lRXV4032idcNUPEtaBO/j/1a9nIqaCSHz+buy1UHWx/t5lz19LMFgskC9jl0QtkQkw+g
         zdVabOWdd+pClGMyD9/ok8BsZWAxgs2PCcBEzrUe+uq/eo3A6pOKyMkqIPO3Zbv+NalQ
         TCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IhKFr4QryGuJvP1nrQlUiJLdZx7k8fJyCdy8lWdXyik=;
        b=Usi9/ogkufanh8M2UVqSqTxuWFV3Q6QLcrxeeB3Ja6jseS5h3f7JtSyQPEkoMPAk/h
         RP+xXkRBC0YyYZBT1JqgmnZJgUXkPr/6EzSS6t6wsunARYy3In98UO9kn6gSAUYWOYJw
         jz3rG9HkvFdSBpagDE+nvmi10KP8QMJSzitRpVCxEI9Rv5z1EpzRYxZCSnmoqe74waCM
         V56yBbtMr072P1APfobmjyU+dvGnQOr3Qi4SzAibGXApNk5xpwez4pZTF4equeCotlPq
         Hq3rAQMRVU0cR7Zyoyo/t3hxiBKKUB6NF9phCyk9TXhf0OlzlBDIdKHMHNyVb1BSp1cC
         xYjA==
X-Gm-Message-State: AOAM532A5VkDlkod5Pap4Pe+STXnCH9OMxaD6t0FrkuxlYziIKYU2H8B
        1nYq7a9Z3M8mXDTPMKQ/sy/B2FlxWWydqQ==
X-Google-Smtp-Source: ABdhPJwyhkdYcxBAN9m9WpPDh7QCH17LynvITXw0+gE3QldDM6Yseq/6c9vmK9vcYI6haoU37+TiMw==
X-Received: by 2002:a17:902:ec84:b029:e5:bd05:4a98 with SMTP id x4-20020a170902ec84b02900e5bd054a98mr8923732plg.76.1617299783936;
        Thu, 01 Apr 2021 10:56:23 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n5sm6195909pfq.44.2021.04.01.10.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 10:56:23 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH net-next 03/12] ionic: add hw timestamp structs to interface
Date:   Thu,  1 Apr 2021 10:56:01 -0700
Message-Id: <20210401175610.44431-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The interface for hardware timestamping includes a new FW
request, device identity fields, Tx and Rx queue feature bits, a
new Rx filter type, the beginnings of Rx packet classifications,
and hardware timestamp registers.

If the IONIC_ETH_HW_TIMESTAMP bit is shown in the
ionic_lif_config features bit string, then we have support
for the hw clock registers.  If the IONIC_RXQ_F_HWSTAMP and
IONIC_TXQ_F_HWSTAMP features are shown in the ionic_q_identity
features, then the queues can support HW timestamps on packets.

Signed-off-by: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    | 175 +++++++++++++++++-
 2 files changed, 170 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 68e5e7a97801..25c52c042246 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -59,6 +59,7 @@ static_assert(sizeof(struct ionic_dev_getattr_cmd) == 64);
 static_assert(sizeof(struct ionic_dev_getattr_comp) == 16);
 static_assert(sizeof(struct ionic_dev_setattr_cmd) == 64);
 static_assert(sizeof(struct ionic_dev_setattr_comp) == 16);
+static_assert(sizeof(struct ionic_lif_setphc_cmd) == 64);
 
 /* Port commands */
 static_assert(sizeof(struct ionic_port_identify_cmd) == 64);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 1299630fcde8..0478b48d9895 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -34,6 +34,7 @@ enum ionic_cmd_opcode {
 	IONIC_CMD_LIF_RESET			= 22,
 	IONIC_CMD_LIF_GETATTR			= 23,
 	IONIC_CMD_LIF_SETATTR			= 24,
+	IONIC_CMD_LIF_SETPHC			= 25,
 
 	IONIC_CMD_RX_MODE_SET			= 30,
 	IONIC_CMD_RX_FILTER_ADD			= 31,
@@ -269,6 +270,9 @@ union ionic_drv_identity {
  *                    value in usecs to device units using:
  *                    device units = usecs * mult / div
  * @eq_count:         Number of shared event queues
+ * @hwstamp_mask:     Bitmask for subtraction of hardware tick values.
+ * @hwstamp_mult:     Hardware tick to nanosecond multiplier.
+ * @hwstamp_shift:    Hardware tick to nanosecond divisor (power of two).
  */
 union ionic_dev_identity {
 	struct {
@@ -283,6 +287,9 @@ union ionic_dev_identity {
 		__le32 intr_coal_mult;
 		__le32 intr_coal_div;
 		__le32 eq_count;
+		__le64 hwstamp_mask;
+		__le32 hwstamp_mult;
+		__le32 hwstamp_shift;
 	};
 	__le32 words[478];
 };
@@ -374,6 +381,39 @@ enum ionic_q_feature {
 	IONIC_Q_F_4X_SG_DESC		= BIT_ULL(9),
 };
 
+/**
+ * enum ionic_rxq_feature - RXQ-specific Features
+ *
+ * Per-queue-type features use bits 16 and higher.
+ *
+ * @IONIC_RXQ_F_HWSTAMP:   Queue supports Hardware Timestamping
+ */
+enum ionic_rxq_feature {
+	IONIC_RXQ_F_HWSTAMP		= BIT_ULL(16),
+};
+
+/**
+ * enum ionic_txq_feature - TXQ-specific Features
+ *
+ * Per-queue-type features use bits 16 and higher.
+ *
+ * @IONIC_TXQ_F_HWSTAMP:   Queue supports Hardware Timestamping
+ */
+enum ionic_txq_feature {
+	IONIC_TXQ_F_HWSTAMP		= BIT(16),
+};
+
+/**
+ * struct ionic_hwstamp_bits - Hardware timestamp decoding bits
+ * @IONIC_HWSTAMP_INVALID:          Invalid hardware timestamp value
+ * @IONIC_HWSTAMP_CQ_NEGOFFSET:     Timestamp field negative offset
+ *                                  from the base cq descriptor.
+ */
+enum ionic_hwstamp_bits {
+	IONIC_HWSTAMP_INVALID	    = ~0ull,
+	IONIC_HWSTAMP_CQ_NEGOFFSET  = 8,
+};
+
 /**
  * struct ionic_lif_logical_qtype - Descriptor of logical to HW queue type
  * @qtype:          Hardware Queue Type
@@ -434,6 +474,8 @@ union ionic_lif_config {
  *     @max_mcast_filters:  Number of perfect multicast addresses supported
  *     @min_frame_size:     Minimum size of frames to be sent
  *     @max_frame_size:     Maximum size of frames to be sent
+ *     @hwstamp_tx_modes:   Bitmask of BIT_ULL(enum ionic_txstamp_mode)
+ *     @hwstamp_rx_filters: Bitmask of enum ionic_pkt_class
  *     @config:             LIF config struct with features, mtu, mac, q counts
  *
  * @rdma:                RDMA identify structure
@@ -467,7 +509,10 @@ union ionic_lif_identity {
 			__le16 rss_ind_tbl_sz;
 			__le32 min_frame_size;
 			__le32 max_frame_size;
-			u8 rsvd2[106];
+			u8 rsvd2[2];
+			__le64 hwstamp_tx_modes;
+			__le64 hwstamp_rx_filters;
+			u8 rsvd3[88];
 			union ionic_lif_config config;
 		} __packed eth;
 
@@ -1046,7 +1091,64 @@ enum ionic_eth_hw_features {
 	IONIC_ETH_HW_TSO_UDP_CSUM	= BIT(16),
 	IONIC_ETH_HW_RX_CSUM_GENEVE	= BIT(17),
 	IONIC_ETH_HW_TX_CSUM_GENEVE	= BIT(18),
-	IONIC_ETH_HW_TSO_GENEVE		= BIT(19)
+	IONIC_ETH_HW_TSO_GENEVE		= BIT(19),
+	IONIC_ETH_HW_TIMESTAMP		= BIT(20),
+};
+
+/**
+ * enum ionic_pkt_class - Packet classification mask.
+ *
+ * Used with rx steering filter, packets indicated by the mask can be steered
+ * toward a specific receive queue.
+ *
+ * @IONIC_PKT_CLS_NTP_ALL:          All NTP packets.
+ * @IONIC_PKT_CLS_PTP1_SYNC:        PTPv1 sync
+ * @IONIC_PKT_CLS_PTP1_DREQ:        PTPv1 delay-request
+ * @IONIC_PKT_CLS_PTP1_ALL:         PTPv1 all packets
+ * @IONIC_PKT_CLS_PTP2_L4_SYNC:     PTPv2-UDP sync
+ * @IONIC_PKT_CLS_PTP2_L4_DREQ:     PTPv2-UDP delay-request
+ * @IONIC_PKT_CLS_PTP2_L4_ALL:      PTPv2-UDP all packets
+ * @IONIC_PKT_CLS_PTP2_L2_SYNC:     PTPv2-ETH sync
+ * @IONIC_PKT_CLS_PTP2_L2_DREQ:     PTPv2-ETH delay-request
+ * @IONIC_PKT_CLS_PTP2_L2_ALL:      PTPv2-ETH all packets
+ * @IONIC_PKT_CLS_PTP2_SYNC:        PTPv2 sync
+ * @IONIC_PKT_CLS_PTP2_DREQ:        PTPv2 delay-request
+ * @IONIC_PKT_CLS_PTP2_ALL:         PTPv2 all packets
+ * @IONIC_PKT_CLS_PTP_SYNC:         PTP sync
+ * @IONIC_PKT_CLS_PTP_DREQ:         PTP delay-request
+ * @IONIC_PKT_CLS_PTP_ALL:          PTP all packets
+ */
+enum ionic_pkt_class {
+	IONIC_PKT_CLS_NTP_ALL		= BIT(0),
+
+	IONIC_PKT_CLS_PTP1_SYNC		= BIT(1),
+	IONIC_PKT_CLS_PTP1_DREQ		= BIT(2),
+	IONIC_PKT_CLS_PTP1_ALL		= BIT(3) |
+		IONIC_PKT_CLS_PTP1_SYNC | IONIC_PKT_CLS_PTP1_DREQ,
+
+	IONIC_PKT_CLS_PTP2_L4_SYNC	= BIT(4),
+	IONIC_PKT_CLS_PTP2_L4_DREQ	= BIT(5),
+	IONIC_PKT_CLS_PTP2_L4_ALL	= BIT(6) |
+		IONIC_PKT_CLS_PTP2_L4_SYNC | IONIC_PKT_CLS_PTP2_L4_DREQ,
+
+	IONIC_PKT_CLS_PTP2_L2_SYNC	= BIT(7),
+	IONIC_PKT_CLS_PTP2_L2_DREQ	= BIT(8),
+	IONIC_PKT_CLS_PTP2_L2_ALL	= BIT(9) |
+		IONIC_PKT_CLS_PTP2_L2_SYNC | IONIC_PKT_CLS_PTP2_L2_DREQ,
+
+	IONIC_PKT_CLS_PTP2_SYNC		=
+		IONIC_PKT_CLS_PTP2_L4_SYNC | IONIC_PKT_CLS_PTP2_L2_SYNC,
+	IONIC_PKT_CLS_PTP2_DREQ		=
+		IONIC_PKT_CLS_PTP2_L4_DREQ | IONIC_PKT_CLS_PTP2_L2_DREQ,
+	IONIC_PKT_CLS_PTP2_ALL		=
+		IONIC_PKT_CLS_PTP2_L4_ALL | IONIC_PKT_CLS_PTP2_L2_ALL,
+
+	IONIC_PKT_CLS_PTP_SYNC		=
+		IONIC_PKT_CLS_PTP1_SYNC | IONIC_PKT_CLS_PTP2_SYNC,
+	IONIC_PKT_CLS_PTP_DREQ		=
+		IONIC_PKT_CLS_PTP1_DREQ | IONIC_PKT_CLS_PTP2_DREQ,
+	IONIC_PKT_CLS_PTP_ALL		=
+		IONIC_PKT_CLS_PTP1_ALL | IONIC_PKT_CLS_PTP2_ALL,
 };
 
 /**
@@ -1355,6 +1457,20 @@ enum ionic_stats_ctl_cmd {
 	IONIC_STATS_CTL_RESET		= 0,
 };
 
+/**
+ * enum ionic_txstamp_mode - List of TX Timestamping Modes
+ * @IONIC_TXSTAMP_OFF:           Disable TX hardware timetamping.
+ * @IONIC_TXSTAMP_ON:            Enable local TX hardware timetamping.
+ * @IONIC_TXSTAMP_ONESTEP_SYNC:  Modify TX PTP Sync packets.
+ * @IONIC_TXSTAMP_ONESTEP_P2P:   Modify TX PTP Sync and PDelayResp.
+ */
+enum ionic_txstamp_mode {
+	IONIC_TXSTAMP_OFF		= 0,
+	IONIC_TXSTAMP_ON		= 1,
+	IONIC_TXSTAMP_ONESTEP_SYNC	= 2,
+	IONIC_TXSTAMP_ONESTEP_P2P	= 3,
+};
+
 /**
  * enum ionic_port_attr - List of device attributes
  * @IONIC_PORT_ATTR_STATE:      Port state attribute
@@ -1597,6 +1713,7 @@ enum ionic_rss_hash_types {
  * @IONIC_LIF_ATTR_FEATURES:    LIF features attribute
  * @IONIC_LIF_ATTR_RSS:         LIF RSS attribute
  * @IONIC_LIF_ATTR_STATS_CTRL:  LIF statistics control attribute
+ * @IONIC_LIF_ATTR_TXSTAMP:     LIF TX timestamping mode
  */
 enum ionic_lif_attr {
 	IONIC_LIF_ATTR_STATE        = 0,
@@ -1606,6 +1723,7 @@ enum ionic_lif_attr {
 	IONIC_LIF_ATTR_FEATURES     = 4,
 	IONIC_LIF_ATTR_RSS          = 5,
 	IONIC_LIF_ATTR_STATS_CTRL   = 6,
+	IONIC_LIF_ATTR_TXSTAMP      = 7,
 };
 
 /**
@@ -1623,6 +1741,7 @@ enum ionic_lif_attr {
  *              @key:       The hash secret key
  *              @addr:      Address for the indirection table shared memory
  * @stats_ctl:  stats control commands (enum ionic_stats_ctl_cmd)
+ * @txstamp:    TX Timestamping Mode (enum ionic_txstamp_mode)
  */
 struct ionic_lif_setattr_cmd {
 	u8     opcode;
@@ -1641,6 +1760,7 @@ struct ionic_lif_setattr_cmd {
 			__le64 addr;
 		} rss;
 		u8      stats_ctl;
+		__le16 txstamp_mode;
 		u8      rsvd[60];
 	} __packed;
 };
@@ -1685,6 +1805,7 @@ struct ionic_lif_getattr_cmd {
  * @mtu:        Mtu
  * @mac:        Station mac
  * @features:   Features (enum ionic_eth_hw_features)
+ * @txstamp:    TX Timestamping Mode (enum ionic_txstamp_mode)
  * @color:      Color bit
  */
 struct ionic_lif_getattr_comp {
@@ -1696,11 +1817,35 @@ struct ionic_lif_getattr_comp {
 		__le32  mtu;
 		u8      mac[6];
 		__le64  features;
+		__le16  txstamp_mode;
 		u8      rsvd2[11];
 	} __packed;
 	u8     color;
 };
 
+/**
+ * struct ionic_lif_setphc_cmd - Set LIF PTP Hardware Clock
+ * @opcode:     Opcode
+ * @lif_index:  LIF index
+ * @tick:       Hardware stamp tick of an instant in time.
+ * @nsec:       Nanosecond stamp of the same instant.
+ * @frac:       Fractional nanoseconds at the same instant.
+ * @mult:       Cycle to nanosecond multiplier.
+ * @shift:      Cycle to nanosecond divisor (power of two).
+ */
+struct ionic_lif_setphc_cmd {
+	u8	opcode;
+	u8	rsvd1;
+	__le16  lif_index;
+	u8      rsvd2[4];
+	__le64	tick;
+	__le64	nsec;
+	__le64	frac;
+	__le32	mult;
+	__le32	shift;
+	u8     rsvd3[24];
+};
+
 enum ionic_rx_mode {
 	IONIC_RX_MODE_F_UNICAST		= BIT(0),
 	IONIC_RX_MODE_F_MULTICAST	= BIT(1),
@@ -1733,9 +1878,10 @@ struct ionic_rx_mode_set_cmd {
 typedef struct ionic_admin_comp ionic_rx_mode_set_comp;
 
 enum ionic_rx_filter_match_type {
-	IONIC_RX_FILTER_MATCH_VLAN = 0,
-	IONIC_RX_FILTER_MATCH_MAC,
-	IONIC_RX_FILTER_MATCH_MAC_VLAN,
+	IONIC_RX_FILTER_MATCH_VLAN	= 0x0,
+	IONIC_RX_FILTER_MATCH_MAC	= 0x1,
+	IONIC_RX_FILTER_MATCH_MAC_VLAN	= 0x2,
+	IONIC_RX_FILTER_STEER_PKTCLASS	= 0x10,
 };
 
 /**
@@ -1752,6 +1898,7 @@ enum ionic_rx_filter_match_type {
  * @mac_vlan:   MACVLAN filter
  *              @vlan:  VLAN ID
  *              @addr:  MAC address (network-byte order)
+ * @pkt_class:  Packet classification filter
  */
 struct ionic_rx_filter_add_cmd {
 	u8     opcode;
@@ -1770,8 +1917,9 @@ struct ionic_rx_filter_add_cmd {
 			__le16 vlan;
 			u8     addr[6];
 		} mac_vlan;
+		__le64 pkt_class;
 		u8 rsvd[54];
-	};
+	} __packed;
 };
 
 /**
@@ -2771,6 +2919,16 @@ union ionic_dev_cmd_comp {
 	struct ionic_fw_control_comp fw_control;
 };
 
+/**
+ * struct ionic_hwstamp_regs - Hardware current timestamp registers
+ * @tick_low:        Low 32 bits of hardware timestamp
+ * @tick_high:       High 32 bits of hardware timestamp
+ */
+struct ionic_hwstamp_regs {
+	u32    tick_low;
+	u32    tick_high;
+};
+
 /**
  * union ionic_dev_info_regs - Device info register format (read-only)
  * @signature:       Signature value of 0x44455649 ('DEVI')
@@ -2781,6 +2939,7 @@ union ionic_dev_cmd_comp {
  * @fw_heartbeat:    Firmware heartbeat counter
  * @serial_num:      Serial number
  * @fw_version:      Firmware version
+ * @hwstamp_regs:    Hardware current timestamp registers
  */
 union ionic_dev_info_regs {
 #define IONIC_DEVINFO_FWVERS_BUFLEN 32
@@ -2795,6 +2954,8 @@ union ionic_dev_info_regs {
 		u32    fw_heartbeat;
 		char   fw_version[IONIC_DEVINFO_FWVERS_BUFLEN];
 		char   serial_num[IONIC_DEVINFO_SERIAL_BUFLEN];
+		u8     rsvd_pad1024[948];
+		struct ionic_hwstamp_regs hwstamp;
 	};
 	u32 words[512];
 };
@@ -2842,6 +3003,7 @@ union ionic_adminq_cmd {
 	struct ionic_q_control_cmd q_control;
 	struct ionic_lif_setattr_cmd lif_setattr;
 	struct ionic_lif_getattr_cmd lif_getattr;
+	struct ionic_lif_setphc_cmd lif_setphc;
 	struct ionic_rx_mode_set_cmd rx_mode_set;
 	struct ionic_rx_filter_add_cmd rx_filter_add;
 	struct ionic_rx_filter_del_cmd rx_filter_del;
@@ -2858,6 +3020,7 @@ union ionic_adminq_comp {
 	struct ionic_q_init_comp q_init;
 	struct ionic_lif_setattr_comp lif_setattr;
 	struct ionic_lif_getattr_comp lif_getattr;
+	struct ionic_admin_comp lif_setphc;
 	struct ionic_rx_filter_add_comp rx_filter_add;
 	struct ionic_fw_control_comp fw_control;
 };
-- 
2.17.1

