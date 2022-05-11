Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9A2522A56
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 05:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiEKDUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 23:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241648AbiEKDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 23:19:46 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F246CF70
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 20:19:36 -0700 (PDT)
X-QQ-mid: bizesmtp75t1652239166tp7qrou5
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 11 May 2022 11:19:26 +0800 (CST)
X-QQ-SSF: 01400000000000F0O000B00A0000000
X-QQ-FEAT: FXvDfBZI5O5BDqhryEigf7NxzgrwBdVsPTINl0hLdN9HfyMkd/v2XwocCNZiM
        QL9Jm46HpIUJpot3Wi0WXJARb6InMgO98G7aIe+Q/b9hWYaRdppk3VbSZ65ActxRngVOgLN
        hVHPuCgfi+cuBYjrZVXfcL1QIxQz8tV434LEBcV7FC0fAAUZeSSiZ3CwAdMZNnq6a2keH0/
        ucPw8Fj7MUo7rtUoqXGXbD5HXY4N8gstkhSUFb1eesSnLc91Fv5+BK2ZnoiUJwSbVMKMh2U
        JQNJolTIcpMj+4vQmVpDLmpguSB1AspENrvjlWf3d8WH8i8sTzh+9mTI/qf70OUMKwjlhci
        dQeJJMTrS6tMPoVNpFiQ3behM9ORsQLRLKkwpuq
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 10/14] net: txgbe: Add ethtool support
Date:   Wed, 11 May 2022 11:26:55 +0800
Message-Id: <20220511032659.641834-11-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add to support the following ethtool commands:

ethtool -i|--driver DEVNAME
ethtool -s|--change DEVNAME
ethtool -a|--show-pause DEVNAME
ethtool -A|--pause DEVNAME
ethtool -c|--show-coalesce DEVNAME
ethtool -C|--coalesce DEVNAME
ethtool -g|--show-ring DEVNAME
ethtool -G|--set-ring DEVNAME
ethtool -k|--show-features DEVNAME
ethtool -K|--features DEVNAME
ethtool -d|--register-dump DEVNAME
ethtool -e|--eeprom-dump DEVNAME
ethtool -E|--change-eeprom DEVNAME
ethtool -r|--negotiate DEVNAME
ethtool -p|--identify DEVNAME
ethtool -t|--test DEVNAME
ethtool -n|-u|--show-nfc|--show-ntuple DEVNAME
ethtool -N|-U|--config-nfc|--config-ntuple DEVNAME
ethtool -T|--show-time-stamping DEVNAME
ethtool -x|--show-rxfh-indir|--show-rxfh DEVNAME
ethtool -X|--set-rxfh-indir|--rxfh DEVNAME
ethtool -f|--flash DEVNAME
ethtool -l|--show-channels DEVNAME
ethtool -L|--set-channels DEVNAME
ethtool -m|--dump-module-eeprom|--module-info DEVNAME

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/Makefile   |    2 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   37 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    | 3188 +++++++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  541 +++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   36 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  169 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |   16 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |   10 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   53 +
 9 files changed, 4051 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c

diff --git a/drivers/net/ethernet/wangxun/txgbe/Makefile b/drivers/net/ethernet/wangxun/txgbe/Makefile
index f233bc45575c..43e5d23109d7 100644
--- a/drivers/net/ethernet/wangxun/txgbe/Makefile
+++ b/drivers/net/ethernet/wangxun/txgbe/Makefile
@@ -6,6 +6,6 @@
 
 obj-$(CONFIG_TXGBE) += txgbe.o
 
-txgbe-objs := txgbe_main.o \
+txgbe-objs := txgbe_main.o txgbe_ethtool.o \
               txgbe_hw.o txgbe_phy.o \
               txgbe_lib.o txgbe_ptp.o
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
index 3b429cca494e..709805f7743c 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
@@ -453,6 +453,10 @@ struct txgbe_adapter {
 	struct txgbe_ring_feature ring_feature[RING_F_ARRAY_SIZE];
 	struct msix_entry *msix_entries;
 
+	u64 test_icr;
+	struct txgbe_ring test_tx_ring;
+	struct txgbe_ring test_rx_ring;
+
 	/* structs defined in txgbe_hw.h */
 	struct txgbe_hw hw;
 	u16 msg_enable;
@@ -478,10 +482,13 @@ struct txgbe_adapter {
 	spinlock_t fdir_perfect_lock;
 
 	u8 __iomem *io_addr;    /* Mainly for iounmap use */
+	u32 wol;
 
 	char eeprom_id[32];
+	u16 eeprom_cap;
 	bool netdev_registered;
 	u32 interrupt_event;
+	u32 led_reg;
 
 	struct ptp_clock *ptp_clock;
 	struct ptp_clock_info ptp_caps;
@@ -559,12 +566,18 @@ struct txgbe_cb {
 
 #define TXGBE_CB(skb) ((struct txgbe_cb *)(skb)->cb)
 
+/* needed by txgbe_ethtool.c */
+extern char txgbe_driver_name[];
+
 void txgbe_irq_disable(struct txgbe_adapter *adapter);
 void txgbe_irq_enable(struct txgbe_adapter *adapter, bool queues, bool flush);
 int txgbe_open(struct net_device *netdev);
 int txgbe_close(struct net_device *netdev);
 void txgbe_up(struct txgbe_adapter *adapter);
 void txgbe_down(struct txgbe_adapter *adapter);
+void txgbe_reinit_locked(struct txgbe_adapter *adapter);
+void txgbe_reset(struct txgbe_adapter *adapter);
+void txgbe_set_ethtool_ops(struct net_device *netdev);
 int txgbe_setup_rx_resources(struct txgbe_ring *rx_ring);
 int txgbe_setup_tx_resources(struct txgbe_ring *tx_ring);
 void txgbe_free_rx_resources(struct txgbe_ring *rx_ring);
@@ -573,6 +586,7 @@ void txgbe_configure_rx_ring(struct txgbe_adapter *adapter,
 			     struct txgbe_ring *ring);
 void txgbe_configure_tx_ring(struct txgbe_adapter *adapter,
 			     struct txgbe_ring *ring);
+void txgbe_update_stats(struct txgbe_adapter *adapter);
 int txgbe_init_interrupt_scheme(struct txgbe_adapter *adapter);
 void txgbe_reset_interrupt_capability(struct txgbe_adapter *adapter);
 void txgbe_set_interrupt_capability(struct txgbe_adapter *adapter);
@@ -584,16 +598,22 @@ void txgbe_unmap_and_free_tx_resource(struct txgbe_ring *ring,
 				      struct txgbe_tx_buffer *tx_buffer);
 void txgbe_alloc_rx_buffers(struct txgbe_ring *rx_ring, u16 cleaned_count);
 void txgbe_set_rx_mode(struct net_device *netdev);
+int txgbe_setup_tc(struct net_device *dev, u8 tc);
 void txgbe_tx_ctxtdesc(struct txgbe_ring *tx_ring, u32 vlan_macip_lens,
 		       u32 fcoe_sof_eof, u32 type_tucmd, u32 mss_l4len_idx);
+void txgbe_do_reset(struct net_device *netdev);
 void txgbe_write_eitr(struct txgbe_q_vector *q_vector);
 int txgbe_poll(struct napi_struct *napi, int budget);
+void txgbe_disable_rx_queue(struct txgbe_adapter *adapter,
+			    struct txgbe_ring *ring);
 
 static inline struct netdev_queue *txring_txq(const struct txgbe_ring *ring)
 {
 	return netdev_get_tx_queue(ring->netdev, ring->queue_index);
 }
 
+int txgbe_wol_supported(struct txgbe_adapter *adapter);
+
 void txgbe_ptp_init(struct txgbe_adapter *adapter);
 void txgbe_ptp_stop(struct txgbe_adapter *adapter);
 void txgbe_ptp_suspend(struct txgbe_adapter *adapter);
@@ -606,6 +626,8 @@ void txgbe_ptp_start_cyclecounter(struct txgbe_adapter *adapter);
 void txgbe_ptp_reset(struct txgbe_adapter *adapter);
 void txgbe_ptp_check_pps_event(struct txgbe_adapter *adapter);
 
+void txgbe_store_reta(struct txgbe_adapter *adapter);
+
 /**
  * interrupt masking operations. each bit in PX_ICn correspond to a interrupt.
  * disable a interrupt by writing to PX_IMS with the corresponding bit=1
@@ -644,6 +666,18 @@ static inline void txgbe_intr_disable(struct txgbe_hw *hw, u64 qmask)
 	/* skip the flush */
 }
 
+static inline void txgbe_intr_trigger(struct txgbe_hw *hw, u64 qmask)
+{
+	u32 mask;
+
+	mask = (qmask & 0xFFFFFFFF);
+	if (mask)
+		wr32(hw, TXGBE_PX_ICS(0), mask);
+	mask = (qmask >> 32);
+	if (mask)
+		wr32(hw, TXGBE_PX_ICS(1), mask);
+}
+
 #define TXGBE_RING_SIZE(R) ((R)->count < TXGBE_MAX_TXD ? (R)->count / 128 : 0)
 
 #define TXGBE_CPU_TO_BE16(_x) cpu_to_be16(_x)
@@ -713,8 +747,11 @@ static inline struct device *pci_dev_to_dev(struct pci_dev *pdev)
 #define TXGBE_FAILED_READ_CFG_WORD  0xffffU
 #define TXGBE_FAILED_READ_CFG_BYTE  0xffU
 
+extern u32 txgbe_read_reg(struct txgbe_hw *hw, u32 reg, bool quiet);
 extern u16 txgbe_read_pci_cfg_word(struct txgbe_hw *hw, u32 reg);
 
+#define TXGBE_R32_Q(h, r) txgbe_read_reg(h, r, true)
+
 #define TXGBE_HTONL(_i) htonl(_i)
 #define TXGBE_NTOHL(_i) ntohl(_i)
 #define TXGBE_NTOHS(_i) ntohs(_i)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
new file mode 100644
index 000000000000..fcb894cf223a
--- /dev/null
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
@@ -0,0 +1,3188 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2015 - 2017 Beijing WangXun Technology Co., Ltd. */
+
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/netdevice.h>
+#include <linux/ethtool.h>
+#include <linux/vmalloc.h>
+#include <linux/highmem.h>
+#include <linux/firmware.h>
+#include <linux/net_tstamp.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+
+#include "txgbe.h"
+#include "txgbe_hw.h"
+#include "txgbe_phy.h"
+
+#define TXGBE_ALL_RAR_ENTRIES 16
+#define TXGBE_RSS_INDIR_TBL_MAX 64
+
+enum {NETDEV_STATS, TXGBE_STATS};
+
+struct txgbe_stats {
+	char stat_string[ETH_GSTRING_LEN];
+	int type;
+	int sizeof_stat;
+	int stat_offset;
+};
+
+#define TXGBE_STAT(m)		TXGBE_STATS, \
+				sizeof(((struct txgbe_adapter *)0)->m), \
+				offsetof(struct txgbe_adapter, m)
+#define TXGBE_NETDEV_STAT(m)	NETDEV_STATS, \
+				sizeof(((struct rtnl_link_stats64 *)0)->m), \
+				offsetof(struct rtnl_link_stats64, m)
+
+static const struct txgbe_stats txgbe_gstrings_stats[] = {
+	{"rx_packets", TXGBE_NETDEV_STAT(rx_packets)},
+	{"tx_packets", TXGBE_NETDEV_STAT(tx_packets)},
+	{"rx_bytes", TXGBE_NETDEV_STAT(rx_bytes)},
+	{"tx_bytes", TXGBE_NETDEV_STAT(tx_bytes)},
+	{"rx_pkts_nic", TXGBE_STAT(stats.gprc)},
+	{"tx_pkts_nic", TXGBE_STAT(stats.gptc)},
+	{"rx_bytes_nic", TXGBE_STAT(stats.gorc)},
+	{"tx_bytes_nic", TXGBE_STAT(stats.gotc)},
+	{"lsc_int", TXGBE_STAT(lsc_int)},
+	{"tx_busy", TXGBE_STAT(tx_busy)},
+	{"non_eop_descs", TXGBE_STAT(non_eop_descs)},
+	{"rx_errors", TXGBE_NETDEV_STAT(rx_errors)},
+	{"tx_errors", TXGBE_NETDEV_STAT(tx_errors)},
+	{"rx_dropped", TXGBE_NETDEV_STAT(rx_dropped)},
+	{"tx_dropped", TXGBE_NETDEV_STAT(tx_dropped)},
+	{"multicast", TXGBE_NETDEV_STAT(multicast)},
+	{"broadcast", TXGBE_STAT(stats.bprc)},
+	{"rx_no_buffer_count", TXGBE_STAT(stats.rnbc[0]) },
+	{"collisions", TXGBE_NETDEV_STAT(collisions)},
+	{"rx_over_errors", TXGBE_NETDEV_STAT(rx_over_errors)},
+	{"rx_crc_errors", TXGBE_NETDEV_STAT(rx_crc_errors)},
+	{"rx_frame_errors", TXGBE_NETDEV_STAT(rx_frame_errors)},
+	{"hw_rsc_aggregated", TXGBE_STAT(rsc_total_count)},
+	{"hw_rsc_flushed", TXGBE_STAT(rsc_total_flush)},
+	{"fdir_match", TXGBE_STAT(stats.fdirmatch)},
+	{"fdir_miss", TXGBE_STAT(stats.fdirmiss)},
+	{"fdir_overflow", TXGBE_STAT(fdir_overflow)},
+	{"rx_fifo_errors", TXGBE_NETDEV_STAT(rx_fifo_errors)},
+	{"rx_missed_errors", TXGBE_NETDEV_STAT(rx_missed_errors)},
+	{"tx_aborted_errors", TXGBE_NETDEV_STAT(tx_aborted_errors)},
+	{"tx_carrier_errors", TXGBE_NETDEV_STAT(tx_carrier_errors)},
+	{"tx_fifo_errors", TXGBE_NETDEV_STAT(tx_fifo_errors)},
+	{"tx_heartbeat_errors", TXGBE_NETDEV_STAT(tx_heartbeat_errors)},
+	{"tx_timeout_count", TXGBE_STAT(tx_timeout_count)},
+	{"tx_restart_queue", TXGBE_STAT(restart_queue)},
+	{"rx_long_length_count", TXGBE_STAT(stats.roc)},
+	{"rx_short_length_count", TXGBE_STAT(stats.ruc)},
+	{"tx_flow_control_xon", TXGBE_STAT(stats.lxontxc)},
+	{"rx_flow_control_xon", TXGBE_STAT(stats.lxonrxc)},
+	{"tx_flow_control_xoff", TXGBE_STAT(stats.lxofftxc)},
+	{"rx_flow_control_xoff", TXGBE_STAT(stats.lxoffrxc)},
+	{"rx_csum_offload_good_count", TXGBE_STAT(hw_csum_rx_good)},
+	{"rx_csum_offload_errors", TXGBE_STAT(hw_csum_rx_error)},
+	{"alloc_rx_page_failed", TXGBE_STAT(alloc_rx_page_failed)},
+	{"alloc_rx_buff_failed", TXGBE_STAT(alloc_rx_buff_failed)},
+	{"rx_no_dma_resources", TXGBE_STAT(hw_rx_no_dma_resources)},
+	{"os2bmc_rx_by_bmc", TXGBE_STAT(stats.o2bgptc)},
+	{"os2bmc_tx_by_bmc", TXGBE_STAT(stats.b2ospc)},
+	{"os2bmc_tx_by_host", TXGBE_STAT(stats.o2bspc)},
+	{"os2bmc_rx_by_host", TXGBE_STAT(stats.b2ogprc)},
+	{"tx_hwtstamp_timeouts", TXGBE_STAT(tx_hwtstamp_timeouts)},
+	{"rx_hwtstamp_cleared", TXGBE_STAT(rx_hwtstamp_cleared)},
+};
+
+/* txgbe allocates num_tx_queues and num_rx_queues symmetrically so
+ * we set the num_rx_queues to evaluate to num_tx_queues. This is
+ * used because we do not have a good way to get the max number of
+ * rx queues with CONFIG_RPS disabled.
+ */
+#define TXGBE_NUM_RX_QUEUES netdev->num_tx_queues
+#define TXGBE_NUM_TX_QUEUES netdev->num_tx_queues
+
+#define TXGBE_QUEUE_STATS_LEN ( \
+		(TXGBE_NUM_TX_QUEUES + TXGBE_NUM_RX_QUEUES) * \
+		(sizeof(struct txgbe_queue_stats) / sizeof(u64)))
+#define TXGBE_GLOBAL_STATS_LEN  ARRAY_SIZE(txgbe_gstrings_stats)
+#define TXGBE_PB_STATS_LEN ( \
+		(sizeof(((struct txgbe_adapter *)0)->stats.pxonrxc) + \
+		 sizeof(((struct txgbe_adapter *)0)->stats.pxontxc) + \
+		 sizeof(((struct txgbe_adapter *)0)->stats.pxoffrxc) + \
+		 sizeof(((struct txgbe_adapter *)0)->stats.pxofftxc)) \
+		/ sizeof(u64))
+#define TXGBE_STATS_LEN (TXGBE_GLOBAL_STATS_LEN + \
+			 TXGBE_PB_STATS_LEN + \
+			 TXGBE_QUEUE_STATS_LEN)
+
+static const char txgbe_gstrings_test[][ETH_GSTRING_LEN] = {
+	"Register test  (offline)", "Eeprom test    (offline)",
+	"Interrupt test (offline)", "Loopback test  (offline)",
+	"Link test   (on/offline)"
+};
+
+#define TXGBE_TEST_LEN  (sizeof(txgbe_gstrings_test) / ETH_GSTRING_LEN)
+
+/* currently supported speeds for 10G */
+#define ADVERTISED_MASK_10G (SUPPORTED_10000baseT_Full | \
+			     SUPPORTED_10000baseKX4_Full | \
+			     SUPPORTED_10000baseKR_Full)
+
+#define txgbe_isbackplane(type)  \
+			((type == txgbe_media_type_backplane) ? true : false)
+
+static __u32 txgbe_backplane_type(struct txgbe_hw *hw)
+{
+	__u32 mode = 0x00;
+
+	switch (hw->phy.link_mode) {
+	case TXGBE_PHYSICAL_LAYER_10GBASE_KX4:
+		mode = SUPPORTED_10000baseKX4_Full;
+		break;
+	case TXGBE_PHYSICAL_LAYER_10GBASE_KR:
+		mode = SUPPORTED_10000baseKR_Full;
+		break;
+	case TXGBE_PHYSICAL_LAYER_1000BASE_KX:
+		mode = SUPPORTED_1000baseKX_Full;
+		break;
+	default:
+		mode = (SUPPORTED_10000baseKX4_Full |
+			SUPPORTED_10000baseKR_Full |
+			SUPPORTED_1000baseKX_Full);
+		break;
+	}
+	return mode;
+}
+
+int txgbe_get_link_ksettings(struct net_device *netdev,
+			     struct ethtool_link_ksettings *cmd)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 supported_link;
+	u32 link_speed = 0;
+	bool autoneg = false;
+	u32 supported, advertising;
+	bool link_up;
+
+	ethtool_convert_link_mode_to_legacy_u32(&supported,
+						cmd->link_modes.supported);
+
+	TCALL(hw, mac.ops.get_link_capabilities, &supported_link, &autoneg);
+
+	if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_KR_KX_KX4)
+		autoneg = adapter->backplane_an ? 1 : 0;
+	else if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_MAC_SGMII)
+		autoneg = adapter->an37 ? 1 : 0;
+
+	/* set the supported link speeds */
+	if (supported_link & TXGBE_LINK_SPEED_10GB_FULL)
+		supported |= (txgbe_isbackplane(hw->phy.media_type)) ?
+			txgbe_backplane_type(hw) : SUPPORTED_10000baseT_Full;
+	if (supported_link & TXGBE_LINK_SPEED_1GB_FULL)
+		supported |= (txgbe_isbackplane(hw->phy.media_type)) ?
+			SUPPORTED_1000baseKX_Full : SUPPORTED_1000baseT_Full;
+	if (supported_link & TXGBE_LINK_SPEED_100_FULL)
+		supported |= SUPPORTED_100baseT_Full;
+	if (supported_link & TXGBE_LINK_SPEED_10_FULL)
+		supported |= SUPPORTED_10baseT_Full;
+
+	/* default advertised speed if phy.autoneg_advertised isn't set */
+	advertising = supported;
+
+	/* set the advertised speeds */
+	if (hw->phy.autoneg_advertised) {
+		advertising = 0;
+		if (hw->phy.autoneg_advertised & TXGBE_LINK_SPEED_100_FULL)
+			advertising |= ADVERTISED_100baseT_Full;
+		if (hw->phy.autoneg_advertised & TXGBE_LINK_SPEED_10GB_FULL)
+			advertising |= (supported & ADVERTISED_MASK_10G);
+		if (hw->phy.autoneg_advertised & TXGBE_LINK_SPEED_1GB_FULL) {
+			if (supported & SUPPORTED_1000baseKX_Full)
+				advertising |= ADVERTISED_1000baseKX_Full;
+			else
+				advertising |= ADVERTISED_1000baseT_Full;
+		}
+		if (hw->phy.autoneg_advertised & TXGBE_LINK_SPEED_10_FULL)
+			advertising |= ADVERTISED_10baseT_Full;
+	} else {
+		/* default modes in case phy.autoneg_advertised isn't set */
+		if (supported_link & TXGBE_LINK_SPEED_10GB_FULL)
+			advertising |= ADVERTISED_10000baseT_Full;
+		if (supported_link & TXGBE_LINK_SPEED_1GB_FULL)
+			advertising |= ADVERTISED_1000baseT_Full;
+		if (supported_link & TXGBE_LINK_SPEED_100_FULL)
+			advertising |= ADVERTISED_100baseT_Full;
+		if (hw->phy.multispeed_fiber && !autoneg) {
+			if (supported_link & TXGBE_LINK_SPEED_10GB_FULL)
+				advertising = ADVERTISED_10000baseT_Full;
+		}
+		if (supported_link & TXGBE_LINK_SPEED_10_FULL)
+			advertising |= ADVERTISED_10baseT_Full;
+	}
+
+	if (autoneg) {
+		supported |= SUPPORTED_Autoneg;
+		advertising |= ADVERTISED_Autoneg;
+		cmd->base.autoneg = AUTONEG_ENABLE;
+	} else {
+		cmd->base.autoneg = AUTONEG_DISABLE;
+	}
+
+	/* Determine the remaining settings based on the PHY type. */
+	switch (adapter->hw.phy.type) {
+	case txgbe_phy_tn:
+	case txgbe_phy_aq:
+	case txgbe_phy_cu_unknown:
+		supported |= SUPPORTED_TP;
+		advertising |= ADVERTISED_TP;
+		cmd->base.port = PORT_TP;
+		break;
+	case txgbe_phy_qt:
+		supported |= SUPPORTED_FIBRE;
+		advertising |= ADVERTISED_FIBRE;
+		cmd->base.port = PORT_FIBRE;
+		break;
+	case txgbe_phy_nl:
+	case txgbe_phy_sfp_passive_tyco:
+	case txgbe_phy_sfp_passive_unknown:
+	case txgbe_phy_sfp_ftl:
+	case txgbe_phy_sfp_avago:
+	case txgbe_phy_sfp_intel:
+	case txgbe_phy_sfp_unknown:
+		switch (adapter->hw.phy.sfp_type) {
+			/* SFP+ devices, further checking needed */
+		case txgbe_sfp_type_da_cu:
+		case txgbe_sfp_type_da_cu_core0:
+		case txgbe_sfp_type_da_cu_core1:
+			supported |= SUPPORTED_FIBRE;
+			advertising |= ADVERTISED_FIBRE;
+			cmd->base.port = PORT_DA;
+			break;
+		case txgbe_sfp_type_sr:
+		case txgbe_sfp_type_lr:
+		case txgbe_sfp_type_srlr_core0:
+		case txgbe_sfp_type_srlr_core1:
+		case txgbe_sfp_type_1g_sx_core0:
+		case txgbe_sfp_type_1g_sx_core1:
+		case txgbe_sfp_type_1g_lx_core0:
+		case txgbe_sfp_type_1g_lx_core1:
+			supported |= SUPPORTED_FIBRE;
+			advertising |= ADVERTISED_FIBRE;
+			cmd->base.port = PORT_FIBRE;
+			break;
+		case txgbe_sfp_type_not_present:
+			supported |= SUPPORTED_FIBRE;
+			advertising |= ADVERTISED_FIBRE;
+			cmd->base.port = PORT_NONE;
+			break;
+		case txgbe_sfp_type_1g_cu_core0:
+		case txgbe_sfp_type_1g_cu_core1:
+			supported |= SUPPORTED_TP;
+			advertising |= ADVERTISED_TP;
+			cmd->base.port = PORT_TP;
+			break;
+		case txgbe_sfp_type_unknown:
+		default:
+			supported |= SUPPORTED_FIBRE;
+			advertising |= ADVERTISED_FIBRE;
+			cmd->base.port = PORT_OTHER;
+			break;
+		}
+		break;
+	case txgbe_phy_xaui:
+		supported |= SUPPORTED_TP;
+		advertising |= ADVERTISED_TP;
+		cmd->base.port = PORT_TP;
+		break;
+	case txgbe_phy_unknown:
+	case txgbe_phy_generic:
+	case txgbe_phy_sfp_unsupported:
+	default:
+		supported |= SUPPORTED_FIBRE;
+		advertising |= ADVERTISED_FIBRE;
+		cmd->base.port = PORT_OTHER;
+		break;
+	}
+
+	if (!in_interrupt()) {
+		TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
+	} else {
+		/* this case is a special workaround for RHEL5 bonding
+		 * that calls this routine from interrupt context
+		 */
+		link_speed = adapter->link_speed;
+		link_up = adapter->link_up;
+	}
+
+	supported |= SUPPORTED_Pause;
+
+	switch (hw->fc.requested_mode) {
+	case txgbe_fc_full:
+		advertising |= ADVERTISED_Pause;
+		break;
+	case txgbe_fc_rx_pause:
+		advertising |= ADVERTISED_Pause |
+				ADVERTISED_Asym_Pause;
+		break;
+	case txgbe_fc_tx_pause:
+		advertising |= ADVERTISED_Asym_Pause;
+		break;
+	default:
+		advertising &= ~(ADVERTISED_Pause |
+				 ADVERTISED_Asym_Pause);
+	}
+
+	if (link_up) {
+		switch (link_speed) {
+		case TXGBE_LINK_SPEED_10GB_FULL:
+			cmd->base.speed = SPEED_10000;
+			break;
+		case TXGBE_LINK_SPEED_1GB_FULL:
+			cmd->base.speed = SPEED_1000;
+			break;
+		case TXGBE_LINK_SPEED_100_FULL:
+			cmd->base.speed = SPEED_100;
+			break;
+		case TXGBE_LINK_SPEED_10_FULL:
+			cmd->base.speed = SPEED_10;
+			break;
+		default:
+			break;
+		}
+		cmd->base.duplex = DUPLEX_FULL;
+	} else {
+		cmd->base.speed = -1;
+		cmd->base.duplex = -1;
+	}
+
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
+						supported);
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
+						advertising);
+	return 0;
+}
+
+static int txgbe_set_link_ksettings(struct net_device *netdev,
+				    const struct ethtool_link_ksettings *cmd)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 advertised, old;
+	s32 err = 0;
+	u32 supported, advertising;
+
+	ethtool_convert_link_mode_to_legacy_u32(&supported,
+						cmd->link_modes.supported);
+	ethtool_convert_link_mode_to_legacy_u32(&advertising,
+						cmd->link_modes.advertising);
+
+	if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_KR_KX_KX4)
+		adapter->backplane_an = cmd->base.autoneg ? 1 : 0;
+	else if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_MAC_SGMII)
+		adapter->an37 = cmd->base.autoneg ? 1 : 0;
+
+	if (hw->phy.multispeed_fiber) {
+		/* this function does not support duplex forcing, but can
+		 * limit the advertising of the adapter to the specified speed
+		 */
+		if (advertising & ~supported)
+			return -EINVAL;
+
+		/* only allow one speed at a time if no autoneg */
+		if (!cmd->base.autoneg && hw->phy.multispeed_fiber) {
+			if (advertising == (ADVERTISED_10000baseT_Full |
+			    ADVERTISED_1000baseT_Full))
+				return -EINVAL;
+		}
+		old = hw->phy.autoneg_advertised;
+		advertised = 0;
+		if (advertising & ADVERTISED_10000baseT_Full)
+			advertised |= TXGBE_LINK_SPEED_10GB_FULL;
+
+		if (advertising & ADVERTISED_1000baseT_Full)
+			advertised |= TXGBE_LINK_SPEED_1GB_FULL;
+
+		if (advertising & ADVERTISED_100baseT_Full)
+			advertised |= TXGBE_LINK_SPEED_100_FULL;
+
+		if (advertising & ADVERTISED_10baseT_Full)
+			advertised |= TXGBE_LINK_SPEED_10_FULL;
+
+		if (old == advertised)
+			return err;
+		/* this sets the link speed and restarts auto-neg */
+		while (test_and_set_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+			usleep_range(1000, 2000);
+
+		hw->mac.autotry_restart = true;
+		err = TCALL(hw, mac.ops.setup_link, advertised, true);
+		if (err) {
+			txgbe_info(probe, "setup link failed with code %d\n", err);
+			TCALL(hw, mac.ops.setup_link, old, true);
+		}
+		if ((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP)
+			TCALL(hw, mac.ops.flap_tx_laser);
+		clear_bit(__TXGBE_IN_SFP_INIT, &adapter->state);
+	} else if ((hw->subsystem_device_id & 0xF0) == TXGBE_ID_KR_KX_KX4 ||
+		   (hw->subsystem_device_id & 0xF0) == TXGBE_ID_MAC_SGMII) {
+		if (!cmd->base.autoneg) {
+			if (advertising == (ADVERTISED_10000baseKR_Full |
+					    ADVERTISED_1000baseKX_Full |
+					    ADVERTISED_10000baseKX4_Full))
+				return -EINVAL;
+		} else {
+			err = txgbe_set_link_to_kr(hw, 1);
+			return err;
+		}
+		advertised = 0;
+		if (advertising & ADVERTISED_10000baseKR_Full) {
+			err = txgbe_set_link_to_kr(hw, 1);
+			advertised |= TXGBE_LINK_SPEED_10GB_FULL;
+		} else if (advertising & ADVERTISED_10000baseKX4_Full) {
+			err = txgbe_set_link_to_kx4(hw, 1);
+			advertised |= TXGBE_LINK_SPEED_10GB_FULL;
+		} else if (advertising & ADVERTISED_1000baseKX_Full) {
+			advertised |= TXGBE_LINK_SPEED_1GB_FULL;
+			err = txgbe_set_link_to_kx(hw, TXGBE_LINK_SPEED_1GB_FULL, 0);
+		}
+	} else {
+		/* in this case we currently only support 10Gb/FULL */
+		u32 speed = cmd->base.speed;
+
+		if (cmd->base.autoneg == AUTONEG_ENABLE ||
+		    advertising != ADVERTISED_10000baseT_Full ||
+		    (speed + cmd->base.duplex != SPEED_10000 + DUPLEX_FULL))
+			return -EINVAL;
+	}
+
+	return err;
+}
+
+static void txgbe_get_pauseparam(struct net_device *netdev,
+				 struct ethtool_pauseparam *pause)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	if (txgbe_device_supports_autoneg_fc(hw) &&
+	    !hw->fc.disable_fc_autoneg)
+		pause->autoneg = 1;
+	else
+		pause->autoneg = 0;
+
+	if (hw->fc.current_mode == txgbe_fc_rx_pause) {
+		pause->rx_pause = 1;
+	} else if (hw->fc.current_mode == txgbe_fc_tx_pause) {
+		pause->tx_pause = 1;
+	} else if (hw->fc.current_mode == txgbe_fc_full) {
+		pause->rx_pause = 1;
+		pause->tx_pause = 1;
+	}
+}
+
+static int txgbe_set_pauseparam(struct net_device *netdev,
+				struct ethtool_pauseparam *pause)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_fc_info fc = hw->fc;
+
+	/* some devices do not support autoneg of flow control */
+	if (pause->autoneg == AUTONEG_ENABLE &&
+	    !txgbe_device_supports_autoneg_fc(hw))
+		return -EINVAL;
+
+	fc.disable_fc_autoneg = (pause->autoneg != AUTONEG_ENABLE);
+
+	if ((pause->rx_pause && pause->tx_pause) || pause->autoneg)
+		fc.requested_mode = txgbe_fc_full;
+	else if (pause->rx_pause)
+		fc.requested_mode = txgbe_fc_rx_pause;
+	else if (pause->tx_pause)
+		fc.requested_mode = txgbe_fc_tx_pause;
+	else
+		fc.requested_mode = txgbe_fc_none;
+
+	/* if the thing changed then we'll update and use new autoneg */
+	if (memcmp(&fc, &hw->fc, sizeof(struct txgbe_fc_info))) {
+		hw->fc = fc;
+		if (netif_running(netdev))
+			txgbe_reinit_locked(adapter);
+		else
+			txgbe_reset(adapter);
+	}
+
+	return 0;
+}
+
+static u32 txgbe_get_msglevel(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	return adapter->msg_enable;
+}
+
+static void txgbe_set_msglevel(struct net_device *netdev, u32 data)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	adapter->msg_enable = data;
+}
+
+#define TXGBE_REGS_LEN  4096
+static int txgbe_get_regs_len(struct net_device __always_unused *netdev)
+{
+	return TXGBE_REGS_LEN * sizeof(u32);
+}
+
+#define TXGBE_GET_STAT(_A_, _R_)        (_A_->stats._R_)
+
+static void txgbe_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
+			   void *p)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 *regs_buff = p;
+	u32 i;
+	u32 id = 0;
+
+	memset(p, 0, TXGBE_REGS_LEN * sizeof(u32));
+	regs_buff[TXGBE_REGS_LEN - 1] = 0x55555555;
+
+	regs->version = hw->revision_id << 16 |
+			hw->device_id;
+
+	/* Global Registers */
+	/* chip control */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_MIS_PWR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_MIS_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_MIS_PF_SM);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_MIS_RST);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_MIS_ST);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_MIS_SWSM);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_MIS_RST_ST);
+	/* pvt sensor */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TS_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TS_EN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TS_ST);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TS_ALARM_THRE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TS_DALARM_THRE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TS_INT_EN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TS_ALARM_ST);
+	/* Fmgr Register */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_CMD);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_DATA);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_STATUS);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_USR_CMD);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_CMDCFG0);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_CMDCFG1);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_ILDR_STATUS);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_SPI_ILDR_SWPTR);
+
+	/* Port Registers */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_PORT_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_PORT_ST);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_EX_VTYPE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_VXLAN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_VXLAN_GPE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_GENEVE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_TEREDO);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_TCP_TIME);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_LED_CTL);
+	/* GPIO */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_GPIO_DR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_GPIO_DDR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_GPIO_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_GPIO_INTEN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_GPIO_INTMASK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_GPIO_INTSTATUS);
+	/* I2C */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CON);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_TAR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_DATA_CMD);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_SS_SCL_HCNT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_SS_SCL_LCNT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_FS_SCL_HCNT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_FS_SCL_LCNT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_HS_SCL_HCNT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_INTR_STAT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_INTR_MASK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_RAW_INTR_STAT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_RX_TL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_TX_TL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_INTR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_RX_UNDER);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_RX_OVER);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_TX_OVER);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_RD_REQ);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_TX_ABRT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_RX_DONE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_ACTIVITY);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_STOP_DET);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_START_DET);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_GEN_CALL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_ENABLE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_STATUS);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_TXFLR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_RXFLR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_SDA_HOLD);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_TX_ABRT_SOURCE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_SDA_SETUP);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_ENABLE_STATUS);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_FS_SPKLEN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_HS_SPKLEN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_SCL_STUCK_TIMEOUT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_SDA_STUCK_TIMEOUT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_CLR_SCL_STUCK_DET);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_DEVICE_ID);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_COMP_PARAM_1);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_COMP_VERSION);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_I2C_COMP_TYPE);
+	/* TX TPH */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_TPH_TDESC);
+	/* RX TPH */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_TPH_RDESC);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_TPH_RHDR);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_CFG_TPH_RPL);
+
+	/* TDMA */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_VF_TE(0));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_VF_TE(1));
+	for (i = 0; i < 8; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_PB_THRE(i));
+	for (i = 0; i < 4; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_LLQ(i));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_ETYPE_LB_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_ETYPE_LB_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_ETYPE_AS_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_ETYPE_AS_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_MAC_AS_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_MAC_AS_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_VLAN_AS_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_VLAN_AS_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_TCP_FLG_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_TCP_FLG_H);
+	for (i = 0; i < 64; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_VLAN_INS(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_ETAG_INS(i));
+	}
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_PBWARB_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_MMW);
+	for (i = 0; i < 8; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_PBWARB_CFG(i));
+	for (i = 0; i < 128; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_VM_CREDIT(i));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_FC_EOF);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDM_FC_SOF);
+
+	/* RDMA */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDM_ARB_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDM_VF_RE(0));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDM_VF_RE(1));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDM_RSC_CTL);
+	for (i = 0; i < 8; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDM_ARB_CFG(i));
+	for (i = 0; i < 4; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDM_PF_QDE(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDM_PF_HIDE(i));
+	}
+
+	/* RDB */
+	/*flow control */
+	for (i = 0; i < 4; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RFCV(i));
+	for (i = 0; i < 8; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RFCL(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RFCH(i));
+	}
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RFCRT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RFCC);
+	/* receive packet buffer */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_PB_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_PB_WRAP);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_UP2TC);
+	for (i = 0; i < 8; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_PB_SZ(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_MPCNT(i));
+	}
+	/* lli interrupt */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_LLI_THRE);
+	/* ring assignment */
+	for (i = 0; i < 64; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_PL_CFG(i));
+	for (i = 0; i < 32; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RSSTBL(i));
+	for (i = 0; i < 10; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RSSRK(i));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RSS_TC);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_RA_CTL);
+	for (i = 0; i < 128; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_5T_SA(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_5T_DA(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_5T_SDP(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_5T_CTL0(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_5T_CTL1(i));
+	}
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_SYN_CLS);
+	for (i = 0; i < 8; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_ETYPE_CLS(i));
+	/* fcoe redirection table */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FCRE_CTL);
+	for (i = 0; i < 8; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FCRE_TBL(i));
+	/*flow director */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_HKEY);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_SKEY);
+	for (i = 0; i < 16; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_FLEX_CFG(i));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_FREE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_LEN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_USE_ST);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_FAIL_ST);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_MATCH);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_MISS);
+	for (i = 0; i < 3; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_IP6(i));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_SA);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_DA);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_PORT);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_FLEX);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_HASH);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_CMD);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_DA4_MSK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_SA4_MSK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_TCP_MSK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_UDP_MSK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_SCTP_MSK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_IP6_MSK);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RDB_FDIR_OTHER_MSK);
+
+	/* PSR */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VLAN_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VM_CTL);
+	for (i = 0; i < 64; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VM_L2CTL(i));
+	for (i = 0; i < 8; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_ETYPE_SWC(i));
+	for (i = 0; i < 128; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MC_TBL(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_UC_TBL(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VLAN_TBL(i));
+	}
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MAC_SWC_AD_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MAC_SWC_AD_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MAC_SWC_VM_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MAC_SWC_VM_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MAC_SWC_IDX);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VLAN_SWC);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VLAN_SWC_VM_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VLAN_SWC_VM_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_VLAN_SWC_IDX);
+	for (i = 0; i < 4; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MR_CTL(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MR_VLAN_L(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MR_VLAN_H(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MR_VM_L(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_MR_VM_H(i));
+	}
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_1588_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_1588_STMPL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_1588_STMPH);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_1588_ATTRL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_1588_ATTRH);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_1588_MSGTYPE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_WKUP_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_WKUP_IPV);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_LAN_FLEX_CTL);
+	for (i = 0; i < 4; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_WKUP_IP4TBL(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_WKUP_IP6TBL(i));
+	}
+	for (i = 0; i < 16; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_LAN_FLEX_DW_L(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_LAN_FLEX_DW_H(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_LAN_FLEX_MSK(i));
+	}
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PSR_LAN_FLEX_CTL);
+
+	/* TDB */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDB_RFCS);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDB_PB_SZ(0));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDB_UP2TC);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDB_PBRARB_CTL);
+	for (i = 0; i < 8; i++)
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDB_PBRARB_CFG(i));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TDB_MNG_TC);
+
+	/* tsec */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_ST);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_BUF_AF);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_BUF_AE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_MIN_IFG);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_STMPL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_STMPH);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_SYSTIML);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_SYSTIMH);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_INC);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_ADJL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_TSC_1588_ADJH);
+
+	/* RSEC */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RSC_CTL);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_RSC_ST);
+
+	/* BAR register */
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_MISC_IC);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_MISC_ICS);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_MISC_IEN);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_GPIE);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_IC(0));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_IC(1));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_ICS(0));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_ICS(1));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_IMS(0));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_IMS(1));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_IMC(0));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_IMC(1));
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_ISB_ADDR_L);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_ISB_ADDR_H);
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_ITRSEL);
+	for (i = 0; i < 64; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_ITR(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_IVAR(i));
+	}
+	regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_MISC_IVAR);
+	for (i = 0; i < 128; i++) {
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_RR_BAL(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_RR_BAH(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_RR_WP(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_RR_RP(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_RR_CFG(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_TR_BAL(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_TR_BAH(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_TR_WP(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_TR_RP(i));
+		regs_buff[id++] = TXGBE_R32_Q(hw, TXGBE_PX_TR_CFG(i));
+	}
+}
+
+static int txgbe_get_eeprom_len(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	return adapter->hw.eeprom.word_size * 2;
+}
+
+static int txgbe_get_eeprom(struct net_device *netdev,
+			    struct ethtool_eeprom *eeprom, u8 *bytes)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 *eeprom_buff;
+	int first_word, last_word, eeprom_len;
+	int ret_val = 0;
+	u16 i;
+
+	if (eeprom->len == 0)
+		return -EINVAL;
+
+	eeprom->magic = hw->vendor_id | (hw->device_id << 16);
+
+	first_word = eeprom->offset >> 1;
+	last_word = (eeprom->offset + eeprom->len - 1) >> 1;
+	eeprom_len = last_word - first_word + 1;
+
+	eeprom_buff = kmalloc_array(eeprom_len, sizeof(u16), GFP_KERNEL);
+	if (!eeprom_buff)
+		return -ENOMEM;
+
+	ret_val = TCALL(hw, eeprom.ops.read_buffer, first_word, eeprom_len,
+			eeprom_buff);
+
+	/* Device's eeprom is always little-endian, word addressable */
+	for (i = 0; i < eeprom_len; i++)
+		le16_to_cpus(&eeprom_buff[i]);
+
+	memcpy(bytes, (u8 *)eeprom_buff + (eeprom->offset & 1), eeprom->len);
+	kfree(eeprom_buff);
+
+	return ret_val;
+}
+
+static int txgbe_set_eeprom(struct net_device *netdev,
+			    struct ethtool_eeprom *eeprom, u8 *bytes)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 *eeprom_buff;
+	void *ptr;
+	int max_len, first_word, last_word, ret_val = 0;
+	u16 i;
+
+	if (eeprom->len == 0)
+		return -EINVAL;
+
+	if (eeprom->magic != (hw->vendor_id | (hw->device_id << 16)))
+		return -EINVAL;
+
+	max_len = hw->eeprom.word_size * 2;
+
+	first_word = eeprom->offset >> 1;
+	last_word = (eeprom->offset + eeprom->len - 1) >> 1;
+	eeprom_buff = kmalloc(max_len, GFP_KERNEL);
+	if (!eeprom_buff)
+		return -ENOMEM;
+
+	ptr = eeprom_buff;
+
+	if (eeprom->offset & 1) {
+		/* need read/modify/write of first changed EEPROM word
+		 * only the second byte of the word is being modified
+		 */
+		ret_val = TCALL(hw, eeprom.ops.read, first_word,
+				&eeprom_buff[0]);
+		if (ret_val)
+			goto err;
+
+		ptr++;
+	}
+	if (((eeprom->offset + eeprom->len) & 1) && ret_val == 0) {
+		/* need read/modify/write of last changed EEPROM word
+		 * only the first byte of the word is being modified
+		 */
+		ret_val = TCALL(hw, eeprom.ops.read, last_word,
+				&eeprom_buff[last_word - first_word]);
+		if (ret_val)
+			goto err;
+	}
+
+	/* Device's eeprom is always little-endian, word addressable */
+	for (i = 0; i < last_word - first_word + 1; i++)
+		le16_to_cpus(&eeprom_buff[i]);
+
+	memcpy(ptr, bytes, eeprom->len);
+
+	for (i = 0; i < last_word - first_word + 1; i++)
+		cpu_to_le16s(&eeprom_buff[i]);
+
+	ret_val = TCALL(hw, eeprom.ops.write_buffer, first_word,
+			last_word - first_word + 1,
+			eeprom_buff);
+
+	/* Update the checksum */
+	if (ret_val == 0)
+		TCALL(hw, eeprom.ops.update_checksum);
+
+err:
+	kfree(eeprom_buff);
+	return ret_val;
+}
+
+static void txgbe_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *drvinfo)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	strncpy(drvinfo->driver, txgbe_driver_name,
+		sizeof(drvinfo->driver) - 1);
+	strncpy(drvinfo->fw_version, adapter->eeprom_id,
+		sizeof(drvinfo->fw_version));
+	strncpy(drvinfo->bus_info, pci_name(adapter->pdev),
+		sizeof(drvinfo->bus_info) - 1);
+	if (adapter->num_tx_queues <= TXGBE_NUM_RX_QUEUES) {
+		drvinfo->n_stats = TXGBE_STATS_LEN -
+				   (TXGBE_NUM_RX_QUEUES - adapter->num_tx_queues) *
+				   (sizeof(struct txgbe_queue_stats) / sizeof(u64)) * 2;
+	} else {
+		drvinfo->n_stats = TXGBE_STATS_LEN;
+	}
+	drvinfo->testinfo_len = TXGBE_TEST_LEN;
+	drvinfo->regdump_len = txgbe_get_regs_len(netdev);
+}
+
+static void txgbe_get_ringparam(struct net_device *netdev,
+				struct ethtool_ringparam *ring,
+				struct kernel_ethtool_ringparam *kernel_ring,
+				struct netlink_ext_ack *extack)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	ring->rx_max_pending = TXGBE_MAX_RXD;
+	ring->tx_max_pending = TXGBE_MAX_TXD;
+	ring->rx_mini_max_pending = 0;
+	ring->rx_jumbo_max_pending = 0;
+	ring->rx_pending = adapter->rx_ring_count;
+	ring->tx_pending = adapter->tx_ring_count;
+	ring->rx_mini_pending = 0;
+	ring->rx_jumbo_pending = 0;
+}
+
+static int txgbe_set_ringparam(struct net_device *netdev,
+			       struct ethtool_ringparam *ring,
+			       struct kernel_ethtool_ringparam *kernel_ring,
+			       struct netlink_ext_ack *extack)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_ring *temp_ring;
+	int i, err = 0;
+	u32 new_rx_count, new_tx_count;
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
+		return -EINVAL;
+
+	new_tx_count = clamp_t(u32, ring->tx_pending,
+			       TXGBE_MIN_TXD, TXGBE_MAX_TXD);
+	new_tx_count = ALIGN(new_tx_count, TXGBE_REQ_TX_DESCRIPTOR_MULTIPLE);
+
+	new_rx_count = clamp_t(u32, ring->rx_pending,
+			       TXGBE_MIN_RXD, TXGBE_MAX_RXD);
+	new_rx_count = ALIGN(new_rx_count, TXGBE_REQ_RX_DESCRIPTOR_MULTIPLE);
+
+	if (new_tx_count == adapter->tx_ring_count &&
+	    new_rx_count == adapter->rx_ring_count) {
+		/* nothing to do */
+		return 0;
+	}
+
+	while (test_and_set_bit(__TXGBE_RESETTING, &adapter->state))
+		usleep_range(1000, 2000);
+
+	if (!netif_running(adapter->netdev)) {
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			adapter->tx_ring[i]->count = new_tx_count;
+		for (i = 0; i < adapter->num_rx_queues; i++)
+			adapter->rx_ring[i]->count = new_rx_count;
+		adapter->tx_ring_count = new_tx_count;
+		adapter->rx_ring_count = new_rx_count;
+		goto clear_reset;
+	}
+
+	/* allocate temporary buffer to store rings in */
+	i = max_t(int, adapter->num_tx_queues, adapter->num_rx_queues);
+	temp_ring = vmalloc(i * sizeof(struct txgbe_ring));
+
+	if (!temp_ring) {
+		err = -ENOMEM;
+		goto clear_reset;
+	}
+
+	txgbe_down(adapter);
+
+	/* Setup new Tx resources and free the old Tx resources in that order.
+	 * We can then assign the new resources to the rings via a memcpy.
+	 * The advantage to this approach is that we are guaranteed to still
+	 * have resources even in the case of an allocation failure.
+	 */
+	if (new_tx_count != adapter->tx_ring_count) {
+		for (i = 0; i < adapter->num_tx_queues; i++) {
+			memcpy(&temp_ring[i], adapter->tx_ring[i],
+			       sizeof(struct txgbe_ring));
+
+			temp_ring[i].count = new_tx_count;
+			err = txgbe_setup_tx_resources(&temp_ring[i]);
+			if (err) {
+				while (i) {
+					i--;
+					txgbe_free_tx_resources(&temp_ring[i]);
+				}
+				goto err_setup;
+			}
+		}
+
+		for (i = 0; i < adapter->num_tx_queues; i++) {
+			txgbe_free_tx_resources(adapter->tx_ring[i]);
+
+			memcpy(adapter->tx_ring[i], &temp_ring[i],
+			       sizeof(struct txgbe_ring));
+		}
+
+		adapter->tx_ring_count = new_tx_count;
+	}
+
+	/* Repeat the process for the Rx rings if needed */
+	if (new_rx_count != adapter->rx_ring_count) {
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			memcpy(&temp_ring[i], adapter->rx_ring[i],
+			       sizeof(struct txgbe_ring));
+
+			temp_ring[i].count = new_rx_count;
+			err = txgbe_setup_rx_resources(&temp_ring[i]);
+			if (err) {
+				while (i) {
+					i--;
+					txgbe_free_rx_resources(&temp_ring[i]);
+				}
+				goto err_setup;
+			}
+		}
+
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			txgbe_free_rx_resources(adapter->rx_ring[i]);
+			memcpy(adapter->rx_ring[i], &temp_ring[i],
+			       sizeof(struct txgbe_ring));
+		}
+
+		adapter->rx_ring_count = new_rx_count;
+	}
+
+err_setup:
+	txgbe_up(adapter);
+	vfree(temp_ring);
+clear_reset:
+	clear_bit(__TXGBE_RESETTING, &adapter->state);
+	return err;
+}
+
+static int txgbe_get_sset_count(struct net_device *netdev, int sset)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	switch (sset) {
+	case ETH_SS_TEST:
+		return TXGBE_TEST_LEN;
+	case ETH_SS_STATS:
+		if (adapter->num_tx_queues <= TXGBE_NUM_RX_QUEUES) {
+			return TXGBE_STATS_LEN -
+			       (TXGBE_NUM_RX_QUEUES - adapter->num_tx_queues) *
+			       (sizeof(struct txgbe_queue_stats) / sizeof(u64)) * 2;
+		} else {
+			return TXGBE_STATS_LEN;
+		}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void txgbe_get_ethtool_stats(struct net_device *netdev,
+				    struct ethtool_stats *stats, u64 *data)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct rtnl_link_stats64 temp;
+	const struct rtnl_link_stats64 *net_stats;
+
+	unsigned int start;
+	struct txgbe_ring *ring;
+	int i, j;
+	char *p;
+
+	txgbe_update_stats(adapter);
+	net_stats = dev_get_stats(netdev, &temp);
+
+	for (i = 0; i < TXGBE_GLOBAL_STATS_LEN; i++) {
+		switch (txgbe_gstrings_stats[i].type) {
+		case NETDEV_STATS:
+			p = (char *)net_stats +
+				txgbe_gstrings_stats[i].stat_offset;
+			break;
+		case TXGBE_STATS:
+			p = (char *)adapter +
+				txgbe_gstrings_stats[i].stat_offset;
+			break;
+		default:
+			data[i] = 0;
+			continue;
+		}
+
+		data[i] = (txgbe_gstrings_stats[i].sizeof_stat ==
+			   sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
+	}
+
+	for (j = 0; j < adapter->num_tx_queues; j++) {
+		ring = adapter->tx_ring[j];
+		if (!ring) {
+			data[i++] = 0;
+			data[i++] = 0;
+			continue;
+		}
+
+		do {
+			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			data[i] = ring->stats.packets;
+			data[i + 1] = ring->stats.bytes;
+		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		i += 2;
+	}
+	for (j = 0; j < adapter->num_rx_queues; j++) {
+		ring = adapter->rx_ring[j];
+		if (!ring) {
+			data[i++] = 0;
+			data[i++] = 0;
+			continue;
+		}
+
+		do {
+			start = u64_stats_fetch_begin_irq(&ring->syncp);
+			data[i] = ring->stats.packets;
+			data[i + 1] = ring->stats.bytes;
+		} while (u64_stats_fetch_retry_irq(&ring->syncp, start));
+		i += 2;
+	}
+	for (j = 0; j < TXGBE_MAX_PACKET_BUFFERS; j++) {
+		data[i++] = adapter->stats.pxontxc[j];
+		data[i++] = adapter->stats.pxofftxc[j];
+	}
+	for (j = 0; j < TXGBE_MAX_PACKET_BUFFERS; j++) {
+		data[i++] = adapter->stats.pxonrxc[j];
+		data[i++] = adapter->stats.pxoffrxc[j];
+	}
+}
+
+static void txgbe_get_strings(struct net_device *netdev, u32 stringset,
+			      u8 *data)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	char *p = (char *)data;
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_TEST:
+		memcpy(data, *txgbe_gstrings_test,
+		       TXGBE_TEST_LEN * ETH_GSTRING_LEN);
+		break;
+	case ETH_SS_STATS:
+		for (i = 0; i < TXGBE_GLOBAL_STATS_LEN; i++) {
+			memcpy(p, txgbe_gstrings_stats[i].stat_string,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < adapter->num_tx_queues; i++) {
+			sprintf(p, "tx_queue_%u_packets", i);
+			p += ETH_GSTRING_LEN;
+			sprintf(p, "tx_queue_%u_bytes", i);
+			p += ETH_GSTRING_LEN;
+		}
+		for (i = 0; i < adapter->num_rx_queues; i++) {
+			sprintf(p, "rx_queue_%u_packets", i);
+			p += ETH_GSTRING_LEN;
+			sprintf(p, "rx_queue_%u_bytes", i);
+			p += ETH_GSTRING_LEN;
+		}
+		for (i = 0; i < TXGBE_MAX_PACKET_BUFFERS; i++) {
+			sprintf(p, "tx_pb_%u_pxon", i);
+			p += ETH_GSTRING_LEN;
+			sprintf(p, "tx_pb_%u_pxoff", i);
+			p += ETH_GSTRING_LEN;
+		}
+		for (i = 0; i < TXGBE_MAX_PACKET_BUFFERS; i++) {
+			sprintf(p, "rx_pb_%u_pxon", i);
+			p += ETH_GSTRING_LEN;
+			sprintf(p, "rx_pb_%u_pxoff", i);
+			p += ETH_GSTRING_LEN;
+		}
+		break;
+	}
+}
+
+static int txgbe_link_test(struct txgbe_adapter *adapter, u64 *data)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	bool link_up;
+	u32 link_speed = 0;
+
+	if (TXGBE_REMOVED(hw->hw_addr)) {
+		*data = 1;
+		return 1;
+	}
+	*data = 0;
+	TCALL(hw, mac.ops.check_link, &link_speed, &link_up, true);
+	if (!link_up)
+		*data = 1;
+	return *data;
+}
+
+/* ethtool register test data */
+struct txgbe_reg_test {
+	u32 reg;
+	u8  array_len;
+	u8  test_type;
+	u32 mask;
+	u32 write;
+};
+
+/* In the hardware, registers are laid out either singly, in arrays
+ * spaced 0x40 bytes apart, or in contiguous tables.  We assume
+ * most tests take place on arrays or single registers (handled
+ * as a single-element array) and special-case the tables.
+ * Table tests are always pattern tests.
+ *
+ * We also make provision for some required setup steps by specifying
+ * registers to be written without any read-back testing.
+ */
+
+#define PATTERN_TEST    1
+#define SET_READ_TEST   2
+#define WRITE_NO_TEST   3
+#define TABLE32_TEST    4
+#define TABLE64_TEST_LO 5
+#define TABLE64_TEST_HI 6
+
+/* default sapphire register test */
+static struct txgbe_reg_test reg_test_sapphire[] = {
+	{ TXGBE_RDB_RFCL(0), 1, PATTERN_TEST, 0x8007FFF0, 0x8007FFF0 },
+	{ TXGBE_RDB_RFCH(0), 1, PATTERN_TEST, 0x8007FFF0, 0x8007FFF0 },
+	{ TXGBE_PSR_VLAN_CTL, 1, PATTERN_TEST, 0x00000000, 0x00000000 },
+	{ TXGBE_PX_RR_BAL(0), 4, PATTERN_TEST, 0xFFFFFF80, 0xFFFFFF80 },
+	{ TXGBE_PX_RR_BAH(0), 4, PATTERN_TEST, 0xFFFFFFFF, 0xFFFFFFFF },
+	{ TXGBE_PX_RR_CFG(0), 4, WRITE_NO_TEST, 0, TXGBE_PX_RR_CFG_RR_EN },
+	{ TXGBE_RDB_RFCH(0), 1, PATTERN_TEST, 0x8007FFF0, 0x8007FFF0 },
+	{ TXGBE_RDB_RFCV(0), 1, PATTERN_TEST, 0xFFFFFFFF, 0xFFFFFFFF },
+	{ TXGBE_PX_TR_BAL(0), 4, PATTERN_TEST, 0xFFFFFFFF, 0xFFFFFFFF },
+	{ TXGBE_PX_TR_BAH(0), 4, PATTERN_TEST, 0xFFFFFFFF, 0xFFFFFFFF },
+	{ TXGBE_RDB_PB_CTL, 1, SET_READ_TEST, 0x00000001, 0x00000001 },
+	{ TXGBE_PSR_MC_TBL(0), 128, TABLE32_TEST, 0xFFFFFFFF, 0xFFFFFFFF },
+	{ .reg = 0 }
+};
+
+static bool reg_pattern_test(struct txgbe_adapter *adapter, u64 *data, int reg,
+			     u32 mask, u32 write)
+{
+	u32 pat, val, before;
+	static const u32 test_pattern[] = {
+		0x5A5A5A5A, 0xA5A5A5A5, 0x00000000, 0xFFFFFFFF
+	};
+
+	if (TXGBE_REMOVED(adapter->hw.hw_addr)) {
+		*data = 1;
+		return true;
+	}
+	for (pat = 0; pat < ARRAY_SIZE(test_pattern); pat++) {
+		before = rd32(&adapter->hw, reg);
+		wr32(&adapter->hw, reg, test_pattern[pat] & write);
+		val = rd32(&adapter->hw, reg);
+		if (val != (test_pattern[pat] & write & mask)) {
+			txgbe_err(drv,
+				  "pattern test reg %04X failed: got 0x%08X expected 0x%08X\n",
+				  reg, val, test_pattern[pat] & write & mask);
+			*data = reg;
+			wr32(&adapter->hw, reg, before);
+			return true;
+		}
+		wr32(&adapter->hw, reg, before);
+	}
+	return false;
+}
+
+static bool reg_set_and_check(struct txgbe_adapter *adapter, u64 *data, int reg,
+			      u32 mask, u32 write)
+{
+	u32 val, before;
+
+	if (TXGBE_REMOVED(adapter->hw.hw_addr)) {
+		*data = 1;
+		return true;
+	}
+	before = rd32(&adapter->hw, reg);
+	wr32(&adapter->hw, reg, write & mask);
+	val = rd32(&adapter->hw, reg);
+	if ((write & mask) != (val & mask)) {
+		txgbe_err(drv,
+			  "set/check reg %04X test failed: got 0x%08X expected 0x%08X\n",
+			  reg, (val & mask), (write & mask));
+		*data = reg;
+		wr32(&adapter->hw, reg, before);
+		return true;
+	}
+	wr32(&adapter->hw, reg, before);
+	return false;
+}
+
+static bool txgbe_reg_test(struct txgbe_adapter *adapter, u64 *data)
+{
+	struct txgbe_reg_test *test;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 i;
+
+	if (TXGBE_REMOVED(hw->hw_addr)) {
+		txgbe_err(drv, "Adapter removed - register test blocked\n");
+		*data = 1;
+		return true;
+	}
+
+	test = reg_test_sapphire;
+
+	/* Perform the remainder of the register test, looping through
+	 * the test table until we either fail or reach the null entry.
+	 */
+	while (test->reg) {
+		for (i = 0; i < test->array_len; i++) {
+			bool b = false;
+
+			switch (test->test_type) {
+			case PATTERN_TEST:
+				b = reg_pattern_test(adapter, data,
+						     test->reg + (i * 0x40),
+						     test->mask,
+						     test->write);
+				break;
+			case SET_READ_TEST:
+				b = reg_set_and_check(adapter, data,
+						      test->reg + (i * 0x40),
+						      test->mask,
+						      test->write);
+				break;
+			case WRITE_NO_TEST:
+				wr32(hw, test->reg + (i * 0x40),
+				     test->write);
+				break;
+			case TABLE32_TEST:
+				b = reg_pattern_test(adapter, data,
+						     test->reg + (i * 4),
+						     test->mask,
+						     test->write);
+				break;
+			case TABLE64_TEST_LO:
+				b = reg_pattern_test(adapter, data,
+						     test->reg + (i * 8),
+						     test->mask,
+						     test->write);
+				break;
+			case TABLE64_TEST_HI:
+				b = reg_pattern_test(adapter, data,
+						     (test->reg + 4) + (i * 8),
+						     test->mask,
+						     test->write);
+				break;
+			}
+			if (b)
+				return true;
+		}
+		test++;
+	}
+
+	*data = 0;
+	return false;
+}
+
+static bool txgbe_eeprom_test(struct txgbe_adapter *adapter, u64 *data)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	bool status = true;
+
+	if (TCALL(hw, eeprom.ops.validate_checksum, NULL)) {
+		*data = 1;
+	} else {
+		*data = 0;
+		status = false;
+	}
+	return status;
+}
+
+static irqreturn_t txgbe_test_intr(int __always_unused irq, void *data)
+{
+	struct net_device *netdev = (struct net_device *)data;
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	u64 icr;
+
+	/* get misc interrupt, as cannot get ring interrupt status */
+	icr = txgbe_misc_isb(adapter, TXGBE_ISB_VEC1);
+	icr <<= 32;
+	icr |= txgbe_misc_isb(adapter, TXGBE_ISB_VEC0);
+
+	adapter->test_icr = icr;
+
+	return IRQ_HANDLED;
+}
+
+static int txgbe_intr_test(struct txgbe_adapter *adapter, u64 *data)
+{
+	struct net_device *netdev = adapter->netdev;
+	u64 mask;
+	u32 i = 0, shared_int = true;
+	u32 irq = adapter->pdev->irq;
+
+	if (TXGBE_REMOVED(adapter->hw.hw_addr)) {
+		*data = 1;
+		return -1;
+	}
+	*data = 0;
+
+	/* Hook up test interrupt handler just for this test */
+	if (adapter->msix_entries) {
+		/* NOTE: we don't test MSI-X interrupts here, yet */
+		return 0;
+	} else if (adapter->flags & TXGBE_FLAG_MSI_ENABLED) {
+		shared_int = false;
+		if (request_irq(irq, &txgbe_test_intr, 0, netdev->name,
+				netdev)) {
+			*data = 1;
+			return -1;
+		}
+	} else if (!request_irq(irq, &txgbe_test_intr, IRQF_PROBE_SHARED,
+				netdev->name, netdev)) {
+		shared_int = false;
+	} else if (request_irq(irq, &txgbe_test_intr, IRQF_SHARED,
+			       netdev->name, netdev)) {
+		*data = 1;
+		return -1;
+	}
+	txgbe_info(hw, "testing %s interrupt\n",
+		   (shared_int ? "shared" : "unshared"));
+
+	/* Disable all the interrupts */
+	txgbe_irq_disable(adapter);
+	TXGBE_WRITE_FLUSH(&adapter->hw);
+	usleep_range(10000, 20000);
+
+	/* Test each interrupt */
+	for (; i < 1; i++) {
+		/* Interrupt to test */
+		mask = 1ULL << i;
+
+		if (!shared_int) {
+			/* Disable the interrupts to be reported in
+			 * the cause register and then force the same
+			 * interrupt and see if one gets posted.  If
+			 * an interrupt was posted to the bus, the
+			 * test failed.
+			 */
+			adapter->test_icr = 0;
+			txgbe_intr_disable(&adapter->hw, ~mask);
+			txgbe_intr_trigger(&adapter->hw, mask);
+			TXGBE_WRITE_FLUSH(&adapter->hw);
+			usleep_range(10000, 20000);
+
+			if (adapter->test_icr & mask) {
+				*data = 3;
+				break;
+			}
+		}
+
+		/* Enable the interrupt to be reported in the cause
+		 * register and then force the same interrupt and see
+		 * if one gets posted.  If an interrupt was not posted
+		 * to the bus, the test failed.
+		 */
+		adapter->test_icr = 0;
+		txgbe_intr_disable(&adapter->hw, TXGBE_INTR_ALL);
+		txgbe_intr_trigger(&adapter->hw, mask);
+		TXGBE_WRITE_FLUSH(&adapter->hw);
+		usleep_range(10000, 20000);
+
+		if (!(adapter->test_icr & mask)) {
+			*data = 4;
+			break;
+		}
+	}
+
+	/* Disable all the interrupts */
+	txgbe_intr_disable(&adapter->hw, TXGBE_INTR_ALL);
+	TXGBE_WRITE_FLUSH(&adapter->hw);
+	usleep_range(10000, 20000);
+
+	/* Unhook test interrupt handler */
+	free_irq(irq, netdev);
+
+	return *data;
+}
+
+static void txgbe_free_desc_rings(struct txgbe_adapter *adapter)
+{
+	struct txgbe_ring *tx_ring = &adapter->test_tx_ring;
+	struct txgbe_ring *rx_ring = &adapter->test_rx_ring;
+	struct txgbe_hw *hw = &adapter->hw;
+
+	/* shut down the DMA engines now so they can be reinitialized later */
+
+	/* first Rx */
+	TCALL(hw, mac.ops.disable_rx);
+	txgbe_disable_rx_queue(adapter, rx_ring);
+
+	/* now Tx */
+	wr32(hw, TXGBE_PX_TR_CFG(tx_ring->reg_idx), 0);
+
+	wr32m(hw, TXGBE_TDM_CTL, TXGBE_TDM_CTL_TE, 0);
+
+	txgbe_reset(adapter);
+
+	txgbe_free_tx_resources(&adapter->test_tx_ring);
+	txgbe_free_rx_resources(&adapter->test_rx_ring);
+}
+
+static int txgbe_setup_desc_rings(struct txgbe_adapter *adapter)
+{
+	struct txgbe_ring *tx_ring = &adapter->test_tx_ring;
+	struct txgbe_ring *rx_ring = &adapter->test_rx_ring;
+	struct txgbe_hw *hw = &adapter->hw;
+	int ret_val;
+	int err;
+
+	TCALL(hw, mac.ops.setup_rxpba, 0, 0, PBA_STRATEGY_EQUAL);
+
+	/* Setup Tx descriptor ring and Tx buffers */
+	tx_ring->count = TXGBE_DEFAULT_TXD;
+	tx_ring->queue_index = 0;
+	tx_ring->dev = pci_dev_to_dev(adapter->pdev);
+	tx_ring->netdev = adapter->netdev;
+	tx_ring->reg_idx = adapter->tx_ring[0]->reg_idx;
+
+	err = txgbe_setup_tx_resources(tx_ring);
+	if (err)
+		return 1;
+
+	wr32m(&adapter->hw, TXGBE_TDM_CTL,
+	      TXGBE_TDM_CTL_TE, TXGBE_TDM_CTL_TE);
+
+	txgbe_configure_tx_ring(adapter, tx_ring);
+
+	/* enable mac transmitter */
+	wr32m(hw, TXGBE_MAC_TX_CFG,
+	      TXGBE_MAC_TX_CFG_TE | TXGBE_MAC_TX_CFG_SPEED_MASK,
+	      TXGBE_MAC_TX_CFG_TE | TXGBE_MAC_TX_CFG_SPEED_10G);
+
+	/* Setup Rx Descriptor ring and Rx buffers */
+	rx_ring->count = TXGBE_DEFAULT_RXD;
+	rx_ring->queue_index = 0;
+	rx_ring->dev = pci_dev_to_dev(adapter->pdev);
+	rx_ring->netdev = adapter->netdev;
+	rx_ring->reg_idx = adapter->rx_ring[0]->reg_idx;
+
+	err = txgbe_setup_rx_resources(rx_ring);
+	if (err) {
+		ret_val = 4;
+		goto err_nomem;
+	}
+
+	TCALL(hw, mac.ops.disable_rx);
+
+	txgbe_configure_rx_ring(adapter, rx_ring);
+
+	TCALL(hw, mac.ops.enable_rx);
+
+	return 0;
+
+err_nomem:
+	txgbe_free_desc_rings(adapter);
+	return ret_val;
+}
+
+static int txgbe_setup_config(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 reg_data;
+
+	/* Setup traffic loopback */
+	reg_data = rd32(hw, TXGBE_PSR_CTL);
+	reg_data |= TXGBE_PSR_CTL_BAM | TXGBE_PSR_CTL_UPE |
+		TXGBE_PSR_CTL_MPE | TXGBE_PSR_CTL_TPE;
+	wr32(hw, TXGBE_PSR_CTL, reg_data);
+
+	wr32(hw, TXGBE_RSC_CTL,
+	     (rd32(hw, TXGBE_RSC_CTL) |
+	      TXGBE_RSC_CTL_SAVE_MAC_ERR) &
+	     ~TXGBE_RSC_CTL_SECRX_DIS);
+
+	wr32(hw, TXGBE_RSC_LSEC_CTL, 0x4);
+
+	wr32(hw, TXGBE_PSR_VLAN_CTL,
+	     rd32(hw, TXGBE_PSR_VLAN_CTL) &
+	     ~TXGBE_PSR_VLAN_CTL_VFE);
+
+	wr32m(&adapter->hw, TXGBE_MAC_RX_CFG,
+	      TXGBE_MAC_RX_CFG_LM, ~TXGBE_MAC_RX_CFG_LM);
+	wr32m(&adapter->hw, TXGBE_CFG_PORT_CTL,
+	      TXGBE_CFG_PORT_CTL_FORCE_LKUP,
+	      ~TXGBE_CFG_PORT_CTL_FORCE_LKUP);
+
+	TXGBE_WRITE_FLUSH(hw);
+	usleep_range(10000, 20000);
+
+	return 0;
+}
+
+static int txgbe_setup_phy_loopback_test(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 value;
+	/* setup phy loopback */
+	value = txgbe_rd32_epcs(hw, TXGBE_PHY_MISC_CTL0);
+	value |= TXGBE_PHY_MISC_CTL0_TX2RX_LB_EN_0 |
+		TXGBE_PHY_MISC_CTL0_TX2RX_LB_EN_3_1;
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, value);
+
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1);
+	txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1,
+			value | TXGBE_SR_PMA_MMD_CTL1_LB_EN);
+	return 0;
+}
+
+static void txgbe_phy_loopback_cleanup(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 value;
+
+	value = txgbe_rd32_epcs(hw, TXGBE_PHY_MISC_CTL0);
+	value &= ~(TXGBE_PHY_MISC_CTL0_TX2RX_LB_EN_0 |
+		   TXGBE_PHY_MISC_CTL0_TX2RX_LB_EN_3_1);
+
+	txgbe_wr32_epcs(hw, TXGBE_PHY_MISC_CTL0, value);
+	value = txgbe_rd32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1);
+	txgbe_wr32_epcs(hw, TXGBE_SR_PMA_MMD_CTL1,
+			value & ~TXGBE_SR_PMA_MMD_CTL1_LB_EN);
+}
+
+static void txgbe_create_lbtest_frame(struct sk_buff *skb,
+				      unsigned int frame_size)
+{
+	memset(skb->data, 0xFF, frame_size);
+	frame_size >>= 1;
+	memset(&skb->data[frame_size], 0xAA, frame_size / 2 - 1);
+	skb->data[frame_size + 10] = 0xBE;
+	skb->data[frame_size + 12] = 0xAF;
+}
+
+static bool txgbe_check_lbtest_frame(struct txgbe_rx_buffer *rx_buffer,
+				     unsigned int frame_size)
+{
+	unsigned char *data;
+	bool match = true;
+
+	frame_size >>= 1;
+	data = kmap(rx_buffer->page) + rx_buffer->page_offset;
+
+	if (data[3] != 0xFF ||
+	    data[frame_size + 10] != 0xBE ||
+	    data[frame_size + 12] != 0xAF)
+		match = false;
+
+	kunmap(rx_buffer->page);
+	return match;
+}
+
+static u16 txgbe_clean_test_rings(struct txgbe_ring *rx_ring,
+				  struct txgbe_ring *tx_ring,
+				  unsigned int size)
+{
+	union txgbe_rx_desc *rx_desc;
+	struct txgbe_rx_buffer *rx_buffer;
+	struct txgbe_tx_buffer *tx_buffer;
+	const int bufsz = txgbe_rx_bufsz(rx_ring);
+	u16 rx_ntc, tx_ntc, count = 0;
+
+	/* initialize next to clean and descriptor values */
+	rx_ntc = rx_ring->next_to_clean;
+	tx_ntc = tx_ring->next_to_clean;
+	rx_desc = TXGBE_RX_DESC(rx_ring, rx_ntc);
+
+	while (txgbe_test_staterr(rx_desc, TXGBE_RXD_STAT_DD)) {
+		/* unmap buffer on Tx side */
+		tx_buffer = &tx_ring->tx_buffer_info[tx_ntc];
+		txgbe_unmap_and_free_tx_resource(tx_ring, tx_buffer);
+
+		/* check Rx buffer */
+		rx_buffer = &rx_ring->rx_buffer_info[rx_ntc];
+
+		/* sync Rx buffer for CPU read */
+		dma_sync_single_for_cpu(rx_ring->dev,
+					rx_buffer->page_dma,
+					bufsz,
+					DMA_FROM_DEVICE);
+
+		/* verify contents of skb */
+		if (txgbe_check_lbtest_frame(rx_buffer, size))
+			count++;
+
+		/* sync Rx buffer for device write */
+		dma_sync_single_for_device(rx_ring->dev,
+					   rx_buffer->page_dma,
+					   bufsz,
+					   DMA_FROM_DEVICE);
+
+		/* increment Rx/Tx next to clean counters */
+		rx_ntc++;
+		if (rx_ntc == rx_ring->count)
+			rx_ntc = 0;
+		tx_ntc++;
+		if (tx_ntc == tx_ring->count)
+			tx_ntc = 0;
+
+		/* fetch next descriptor */
+		rx_desc = TXGBE_RX_DESC(rx_ring, rx_ntc);
+	}
+
+	/* re-map buffers to ring, store next to clean values */
+	txgbe_alloc_rx_buffers(rx_ring, count);
+	rx_ring->next_to_clean = rx_ntc;
+	tx_ring->next_to_clean = tx_ntc;
+
+	return count;
+}
+
+static int txgbe_run_loopback_test(struct txgbe_adapter *adapter)
+{
+	struct txgbe_ring *tx_ring = &adapter->test_tx_ring;
+	struct txgbe_ring *rx_ring = &adapter->test_rx_ring;
+	int i, j, lc, good_cnt, ret_val = 0;
+	unsigned int size = 1024;
+	netdev_tx_t tx_ret_val;
+	struct sk_buff *skb;
+	u32 flags_orig = adapter->flags;
+
+	/* allocate test skb */
+	skb = alloc_skb(size, GFP_KERNEL);
+	if (!skb)
+		return 11;
+
+	/* place data into test skb */
+	txgbe_create_lbtest_frame(skb, size);
+	skb_put(skb, size);
+
+	/* Calculate the loop count based on the largest descriptor ring
+	 * The idea is to wrap the largest ring a number of times using 64
+	 * send/receive pairs during each loop
+	 */
+
+	if (rx_ring->count <= tx_ring->count)
+		lc = ((tx_ring->count / 64) * 2) + 1;
+	else
+		lc = ((rx_ring->count / 64) * 2) + 1;
+
+	for (j = 0; j <= lc; j++) {
+		/* reset count of good packets */
+		good_cnt = 0;
+
+		/* place 64 packets on the transmit queue*/
+		for (i = 0; i < 64; i++) {
+			skb_get(skb);
+			tx_ret_val = txgbe_xmit_frame_ring(skb,
+							   adapter,
+							   tx_ring);
+			if (tx_ret_val == NETDEV_TX_OK)
+				good_cnt++;
+		}
+
+		if (good_cnt != 64) {
+			ret_val = 12;
+			break;
+		}
+
+		/* allow 200 milliseconds for packets to go from Tx to Rx */
+		msleep(200);
+
+		good_cnt = txgbe_clean_test_rings(rx_ring, tx_ring, size);
+		if (j == 0) {
+			continue;
+		} else if (good_cnt != 64) {
+			ret_val = 13;
+			break;
+		}
+	}
+
+	/* free the original skb */
+	kfree_skb(skb);
+	adapter->flags = flags_orig;
+
+	return ret_val;
+}
+
+static int txgbe_loopback_test(struct txgbe_adapter *adapter, u64 *data)
+{
+	*data = txgbe_setup_desc_rings(adapter);
+	if (*data)
+		goto out;
+
+	*data = txgbe_setup_config(adapter);
+	if (*data)
+		goto err_loopback;
+
+	*data = txgbe_setup_phy_loopback_test(adapter);
+	if (*data)
+		goto err_loopback;
+	*data = txgbe_run_loopback_test(adapter);
+	if (*data)
+		txgbe_info(hw, "phy loopback testing failed\n");
+	txgbe_phy_loopback_cleanup(adapter);
+
+err_loopback:
+	txgbe_free_desc_rings(adapter);
+out:
+	return *data;
+}
+
+static void txgbe_diag_test(struct net_device *netdev,
+			    struct ethtool_test *eth_test, u64 *data)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	bool if_running = netif_running(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	if (TXGBE_REMOVED(hw->hw_addr)) {
+		txgbe_err(hw, "Adapter removed - test blocked\n");
+		data[0] = 1;
+		data[1] = 1;
+		data[2] = 1;
+		data[3] = 1;
+		data[4] = 1;
+		eth_test->flags |= ETH_TEST_FL_FAILED;
+		return;
+	}
+
+	set_bit(__TXGBE_TESTING, &adapter->state);
+	if (eth_test->flags == ETH_TEST_FL_OFFLINE) {
+		/* Offline tests */
+		txgbe_info(hw, "offline testing starting\n");
+
+		/* Link test performed before hardware reset so autoneg doesn't
+		 * interfere with test result
+		 */
+		if (txgbe_link_test(adapter, &data[4]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		if (if_running)
+			/* indicate we're in test mode */
+			txgbe_close(netdev);
+		else
+			txgbe_reset(adapter);
+
+		txgbe_info(hw, "register testing starting\n");
+		if (txgbe_reg_test(adapter, &data[0]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		txgbe_reset(adapter);
+		txgbe_info(hw, "eeprom testing starting\n");
+		if (txgbe_eeprom_test(adapter, &data[1]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		txgbe_reset(adapter);
+		txgbe_info(hw, "interrupt testing starting\n");
+		if (txgbe_intr_test(adapter, &data[2]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		if (!(((hw->subsystem_device_id & TXGBE_NCSI_MASK) == TXGBE_NCSI_SUP) ||
+		      ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP))) {
+			txgbe_reset(adapter);
+			txgbe_info(hw, "loopback testing starting\n");
+			if (txgbe_loopback_test(adapter, &data[3]))
+				eth_test->flags |= ETH_TEST_FL_FAILED;
+		}
+
+		data[3] = 0;
+
+		txgbe_reset(adapter);
+
+		/* clear testing bit and return adapter to previous state */
+		clear_bit(__TXGBE_TESTING, &adapter->state);
+		if (if_running)
+			txgbe_open(netdev);
+		else
+			TCALL(hw, mac.ops.disable_tx_laser);
+	} else {
+		txgbe_info(hw, "online testing starting\n");
+
+		/* Online tests */
+		if (txgbe_link_test(adapter, &data[4]))
+			eth_test->flags |= ETH_TEST_FL_FAILED;
+
+		/* Offline tests aren't run; pass by default */
+		data[0] = 0;
+		data[1] = 0;
+		data[2] = 0;
+		data[3] = 0;
+
+		clear_bit(__TXGBE_TESTING, &adapter->state);
+	}
+
+	msleep_interruptible(4 * 1000);
+}
+
+static int txgbe_wol_exclusion(struct txgbe_adapter *adapter,
+			       struct ethtool_wolinfo *wol)
+{
+	int retval = 0;
+
+	/* WOL not supported for all devices */
+	if (!txgbe_wol_supported(adapter)) {
+		retval = 1;
+		wol->supported = 0;
+	}
+
+	return retval;
+}
+
+static void txgbe_get_wol(struct net_device *netdev,
+			  struct ethtool_wolinfo *wol)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	wol->supported = WAKE_UCAST | WAKE_MCAST |
+			 WAKE_BCAST | WAKE_MAGIC;
+	wol->wolopts = 0;
+
+	if (txgbe_wol_exclusion(adapter, wol) ||
+	    !device_can_wakeup(pci_dev_to_dev(adapter->pdev)))
+		return;
+	if ((hw->subsystem_device_id & TXGBE_WOL_MASK) != TXGBE_WOL_SUP)
+		return;
+
+	if (adapter->wol & TXGBE_PSR_WKUP_CTL_EX)
+		wol->wolopts |= WAKE_UCAST;
+	if (adapter->wol & TXGBE_PSR_WKUP_CTL_MC)
+		wol->wolopts |= WAKE_MCAST;
+	if (adapter->wol & TXGBE_PSR_WKUP_CTL_BC)
+		wol->wolopts |= WAKE_BCAST;
+	if (adapter->wol & TXGBE_PSR_WKUP_CTL_MAG)
+		wol->wolopts |= WAKE_MAGIC;
+}
+
+static int txgbe_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	if (wol->wolopts & (WAKE_PHY | WAKE_ARP | WAKE_MAGICSECURE))
+		return -EOPNOTSUPP;
+
+	if (txgbe_wol_exclusion(adapter, wol))
+		return wol->wolopts ? -EOPNOTSUPP : 0;
+	if ((hw->subsystem_device_id & TXGBE_WOL_MASK) != TXGBE_WOL_SUP)
+		return -EOPNOTSUPP;
+
+	adapter->wol = 0;
+
+	if (wol->wolopts & WAKE_UCAST)
+		adapter->wol |= TXGBE_PSR_WKUP_CTL_EX;
+	if (wol->wolopts & WAKE_MCAST)
+		adapter->wol |= TXGBE_PSR_WKUP_CTL_MC;
+	if (wol->wolopts & WAKE_BCAST)
+		adapter->wol |= TXGBE_PSR_WKUP_CTL_BC;
+	if (wol->wolopts & WAKE_MAGIC)
+		adapter->wol |= TXGBE_PSR_WKUP_CTL_MAG;
+
+	hw->wol_enabled = !!(adapter->wol);
+	wr32(hw, TXGBE_PSR_WKUP_CTL, adapter->wol);
+
+	device_set_wakeup_enable(pci_dev_to_dev(adapter->pdev), adapter->wol);
+
+	return 0;
+}
+
+static int txgbe_nway_reset(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	if (netif_running(netdev))
+		txgbe_reinit_locked(adapter);
+
+	return 0;
+}
+
+static int txgbe_set_phys_id(struct net_device *netdev,
+			     enum ethtool_phys_id_state state)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_hw *hw = &adapter->hw;
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		adapter->led_reg = rd32(hw, TXGBE_CFG_LED_CTL);
+		return 2;
+
+	case ETHTOOL_ID_ON:
+		TCALL(hw, mac.ops.led_on, TXGBE_LED_LINK_UP);
+		break;
+
+	case ETHTOOL_ID_OFF:
+		TCALL(hw, mac.ops.led_off, TXGBE_LED_LINK_UP);
+		break;
+
+	case ETHTOOL_ID_INACTIVE:
+		/* Restore LED settings */
+		wr32(&adapter->hw, TXGBE_CFG_LED_CTL, adapter->led_reg);
+		break;
+	}
+
+	return 0;
+}
+
+static int txgbe_get_coalesce(struct net_device *netdev,
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	ec->tx_max_coalesced_frames_irq = adapter->tx_work_limit;
+	/* only valid if in constant ITR mode */
+	if (adapter->rx_itr_setting <= 1)
+		ec->rx_coalesce_usecs = adapter->rx_itr_setting;
+	else
+		ec->rx_coalesce_usecs = adapter->rx_itr_setting >> 2;
+
+	/* if in mixed tx/rx queues per vector mode, report only rx settings */
+	if (adapter->q_vector[0]->tx.count && adapter->q_vector[0]->rx.count)
+		return 0;
+
+	/* only valid if in constant ITR mode */
+	if (adapter->tx_itr_setting <= 1)
+		ec->tx_coalesce_usecs = adapter->tx_itr_setting;
+	else
+		ec->tx_coalesce_usecs = adapter->tx_itr_setting >> 2;
+
+	return 0;
+}
+
+/* this function must be called before setting the new value of
+ * rx_itr_setting
+ */
+static bool txgbe_update_rsc(struct txgbe_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	/* nothing to do if LRO or RSC are not enabled */
+	if (!(adapter->flags2 & TXGBE_FLAG2_RSC_CAPABLE) ||
+	    !(netdev->features & NETIF_F_LRO))
+		return false;
+
+	/* check the feature flag value and enable RSC if necessary */
+	if (adapter->rx_itr_setting == 1 ||
+	    adapter->rx_itr_setting > TXGBE_MIN_RSC_ITR) {
+		if (!(adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED)) {
+			adapter->flags2 |= TXGBE_FLAG2_RSC_ENABLED;
+			txgbe_info(probe,
+				   "rx-usecs value high enough to re-enable RSC\n");
+			return true;
+		}
+	/* if interrupt rate is too high then disable RSC */
+	} else if (adapter->flags2 & TXGBE_FLAG2_RSC_ENABLED) {
+		adapter->flags2 &= ~TXGBE_FLAG2_RSC_ENABLED;
+		txgbe_info(probe, "rx-usecs set too low, disabling RSC\n");
+		return true;
+	}
+	return false;
+}
+
+static int txgbe_set_coalesce(struct net_device *netdev,
+			      struct ethtool_coalesce *ec,
+			      struct kernel_ethtool_coalesce *kernel_coal,
+			      struct netlink_ext_ack *extack)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	struct txgbe_q_vector *q_vector;
+	int i;
+	u16 tx_itr_param, rx_itr_param;
+	u16  tx_itr_prev;
+	bool need_reset = false;
+
+	if (adapter->q_vector[0]->tx.count && adapter->q_vector[0]->rx.count) {
+		/* reject Tx specific changes in case of mixed RxTx vectors */
+		if (ec->tx_coalesce_usecs)
+			return -EINVAL;
+		tx_itr_prev = adapter->rx_itr_setting;
+	} else {
+		tx_itr_prev = adapter->tx_itr_setting;
+	}
+
+	if (ec->tx_max_coalesced_frames_irq)
+		adapter->tx_work_limit = ec->tx_max_coalesced_frames_irq;
+
+	if ((ec->rx_coalesce_usecs > (TXGBE_MAX_EITR >> 2)) ||
+	    (ec->tx_coalesce_usecs > (TXGBE_MAX_EITR >> 2)))
+		return -EINVAL;
+
+	if (ec->rx_coalesce_usecs > 1)
+		adapter->rx_itr_setting = ec->rx_coalesce_usecs << 2;
+	else
+		adapter->rx_itr_setting = ec->rx_coalesce_usecs;
+
+	if (adapter->rx_itr_setting == 1)
+		rx_itr_param = TXGBE_20K_ITR;
+	else
+		rx_itr_param = adapter->rx_itr_setting;
+
+	if (ec->tx_coalesce_usecs > 1)
+		adapter->tx_itr_setting = ec->tx_coalesce_usecs << 2;
+	else
+		adapter->tx_itr_setting = ec->tx_coalesce_usecs;
+
+	if (adapter->tx_itr_setting == 1)
+		tx_itr_param = TXGBE_12K_ITR;
+	else
+		tx_itr_param = adapter->tx_itr_setting;
+
+	/* mixed Rx/Tx */
+	if (adapter->q_vector[0]->tx.count && adapter->q_vector[0]->rx.count)
+		adapter->tx_itr_setting = adapter->rx_itr_setting;
+
+	/* detect ITR changes that require update of TXDCTL.WTHRESH */
+	if (adapter->tx_itr_setting != 1 &&
+	    adapter->tx_itr_setting < TXGBE_100K_ITR) {
+		if (tx_itr_prev == 1 ||
+		    tx_itr_prev >= TXGBE_100K_ITR)
+			need_reset = true;
+	} else {
+		if (tx_itr_prev != 1 &&
+		    tx_itr_prev < TXGBE_100K_ITR)
+			need_reset = true;
+	}
+
+	/* check the old value and enable RSC if necessary */
+	need_reset |= txgbe_update_rsc(adapter);
+
+	for (i = 0; i < adapter->num_q_vectors; i++) {
+		q_vector = adapter->q_vector[i];
+		q_vector->tx.work_limit = adapter->tx_work_limit;
+		q_vector->rx.work_limit = adapter->rx_work_limit;
+		if (q_vector->tx.count && !q_vector->rx.count)
+			/* tx only */
+			q_vector->itr = tx_itr_param;
+		else
+			/* rx only or mixed */
+			q_vector->itr = rx_itr_param;
+		txgbe_write_eitr(q_vector);
+	}
+
+	/* do reset here at the end to make sure EITR==0 case is handled
+	 * correctly w.r.t stopping tx, and changing TXDCTL.WTHRESH settings
+	 * also locks in RSC enable/disable which requires reset
+	 */
+	if (need_reset)
+		txgbe_do_reset(netdev);
+
+	return 0;
+}
+
+static int txgbe_get_ethtool_fdir_entry(struct txgbe_adapter *adapter,
+					struct ethtool_rxnfc *cmd)
+{
+	union txgbe_atr_input *mask = &adapter->fdir_mask;
+	struct ethtool_rx_flow_spec *fsp =
+		(struct ethtool_rx_flow_spec *)&cmd->fs;
+	struct hlist_node *node;
+	struct txgbe_fdir_filter *rule = NULL;
+
+	/* report total rule count */
+	cmd->data = (1024 << adapter->fdir_pballoc) - 2;
+
+	hlist_for_each_entry_safe(rule, node,
+				  &adapter->fdir_filter_list, fdir_node) {
+		if (fsp->location <= rule->sw_idx)
+			break;
+	}
+
+	if (!rule || fsp->location != rule->sw_idx)
+		return -EINVAL;
+
+	/* fill out the flow spec entry */
+
+	/* set flow type field */
+	switch (rule->filter.formatted.flow_type) {
+	case TXGBE_ATR_FLOW_TYPE_TCPV4:
+		fsp->flow_type = TCP_V4_FLOW;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_UDPV4:
+		fsp->flow_type = UDP_V4_FLOW;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_SCTPV4:
+		fsp->flow_type = SCTP_V4_FLOW;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_IPV4:
+		fsp->flow_type = IP_USER_FLOW;
+		fsp->h_u.usr_ip4_spec.ip_ver = ETH_RX_NFC_IP4;
+		fsp->h_u.usr_ip4_spec.proto = 0;
+		fsp->m_u.usr_ip4_spec.proto = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	fsp->h_u.tcp_ip4_spec.psrc = rule->filter.formatted.src_port;
+	fsp->m_u.tcp_ip4_spec.psrc = mask->formatted.src_port;
+	fsp->h_u.tcp_ip4_spec.pdst = rule->filter.formatted.dst_port;
+	fsp->m_u.tcp_ip4_spec.pdst = mask->formatted.dst_port;
+	fsp->h_u.tcp_ip4_spec.ip4src = rule->filter.formatted.src_ip[0];
+	fsp->m_u.tcp_ip4_spec.ip4src = mask->formatted.src_ip[0];
+	fsp->h_u.tcp_ip4_spec.ip4dst = rule->filter.formatted.dst_ip[0];
+	fsp->m_u.tcp_ip4_spec.ip4dst = mask->formatted.dst_ip[0];
+	fsp->h_ext.vlan_etype = rule->filter.formatted.flex_bytes;
+	fsp->m_ext.vlan_etype = mask->formatted.flex_bytes;
+	fsp->h_ext.data[1] = htonl(rule->filter.formatted.vm_pool);
+	fsp->m_ext.data[1] = htonl(mask->formatted.vm_pool);
+	fsp->flow_type |= FLOW_EXT;
+
+	/* record action */
+	if (rule->action == TXGBE_RDB_FDIR_DROP_QUEUE)
+		fsp->ring_cookie = RX_CLS_FLOW_DISC;
+	else
+		fsp->ring_cookie = rule->action;
+
+	return 0;
+}
+
+static int txgbe_get_ethtool_fdir_all(struct txgbe_adapter *adapter,
+				      struct ethtool_rxnfc *cmd,
+				      u32 *rule_locs)
+{
+	struct hlist_node *node;
+	struct txgbe_fdir_filter *rule;
+	int cnt = 0;
+
+	/* report total rule count */
+	cmd->data = (1024 << adapter->fdir_pballoc) - 2;
+
+	hlist_for_each_entry_safe(rule, node,
+				  &adapter->fdir_filter_list, fdir_node) {
+		if (cnt == cmd->rule_cnt)
+			return -EMSGSIZE;
+		rule_locs[cnt] = rule->sw_idx;
+		cnt++;
+	}
+
+	cmd->rule_cnt = cnt;
+
+	return 0;
+}
+
+static int txgbe_get_rss_hash_opts(struct txgbe_adapter *adapter,
+				   struct ethtool_rxnfc *cmd)
+{
+	cmd->data = 0;
+
+	/* Report default options for RSS on txgbe */
+	switch (cmd->flow_type) {
+	case TCP_V4_FLOW:
+		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		fallthrough;
+	case UDP_V4_FLOW:
+		if (adapter->flags2 & TXGBE_FLAG2_RSS_FIELD_IPV4_UDP)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		fallthrough;
+	case SCTP_V4_FLOW:
+	case AH_ESP_V4_FLOW:
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+	case IPV4_FLOW:
+		cmd->data |= RXH_IP_SRC | RXH_IP_DST;
+		break;
+	case TCP_V6_FLOW:
+		cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		fallthrough;
+	case UDP_V6_FLOW:
+		if (adapter->flags2 & TXGBE_FLAG2_RSS_FIELD_IPV6_UDP)
+			cmd->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		fallthrough;
+	case SCTP_V6_FLOW:
+	case AH_ESP_V6_FLOW:
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
+	case IPV6_FLOW:
+		cmd->data |= RXH_IP_SRC | RXH_IP_DST;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int txgbe_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
+			   u32 *rule_locs)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	int ret = -EOPNOTSUPP;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = adapter->num_rx_queues;
+		ret = 0;
+		break;
+	case ETHTOOL_GRXCLSRLCNT:
+		cmd->rule_cnt = adapter->fdir_filter_count;
+		ret = 0;
+		break;
+	case ETHTOOL_GRXCLSRULE:
+		ret = txgbe_get_ethtool_fdir_entry(adapter, cmd);
+		break;
+	case ETHTOOL_GRXCLSRLALL:
+		ret = txgbe_get_ethtool_fdir_all(adapter, cmd,
+						 (u32 *)rule_locs);
+		break;
+	case ETHTOOL_GRXFH:
+		ret = txgbe_get_rss_hash_opts(adapter, cmd);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int txgbe_update_ethtool_fdir_entry(struct txgbe_adapter *adapter,
+					   struct txgbe_fdir_filter *input,
+					   u16 sw_idx)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	struct hlist_node *node, *parent;
+	struct txgbe_fdir_filter *rule;
+	bool deleted = false;
+	s32 err;
+
+	parent = NULL;
+	rule = NULL;
+
+	hlist_for_each_entry_safe(rule, node,
+				  &adapter->fdir_filter_list, fdir_node) {
+		/* hash found, or no matching entry */
+		if (rule->sw_idx >= sw_idx)
+			break;
+		parent = node;
+	}
+
+	/* if there is an old rule occupying our place remove it */
+	if (rule && rule->sw_idx == sw_idx) {
+		/* hardware filters are only configured when interface is up,
+		 * and we should not issue filter commands while the interface
+		 * is down
+		 */
+		if (netif_running(adapter->netdev) &&
+		    (!input || rule->filter.formatted.bkt_hash !=
+		     input->filter.formatted.bkt_hash)) {
+			err = txgbe_fdir_erase_perfect_filter(hw,
+							      &rule->filter,
+							      sw_idx);
+			if (err)
+				return -EINVAL;
+		}
+
+		hlist_del(&rule->fdir_node);
+		kfree(rule);
+		adapter->fdir_filter_count--;
+		deleted = true;
+	}
+
+	/* If we weren't given an input, then this was a request to delete a
+	 * filter. We should return -EINVAL if the filter wasn't found, but
+	 * return 0 if the rule was successfully deleted.
+	 */
+	if (!input)
+		return deleted ? 0 : -EINVAL;
+
+	/* initialize node and set software index */
+	INIT_HLIST_NODE(&input->fdir_node);
+
+	/* add filter to the list */
+	if (parent)
+		hlist_add_behind(&input->fdir_node, parent);
+	else
+		hlist_add_head(&input->fdir_node,
+			       &adapter->fdir_filter_list);
+
+	/* update counts */
+	adapter->fdir_filter_count++;
+
+	return 0;
+}
+
+static int txgbe_flowspec_to_flow_type(struct ethtool_rx_flow_spec *fsp,
+				       u8 *flow_type)
+{
+	switch (fsp->flow_type & ~FLOW_EXT) {
+	case TCP_V4_FLOW:
+		*flow_type = TXGBE_ATR_FLOW_TYPE_TCPV4;
+		break;
+	case UDP_V4_FLOW:
+		*flow_type = TXGBE_ATR_FLOW_TYPE_UDPV4;
+		break;
+	case SCTP_V4_FLOW:
+		*flow_type = TXGBE_ATR_FLOW_TYPE_SCTPV4;
+		break;
+	case IP_USER_FLOW:
+		switch (fsp->h_u.usr_ip4_spec.proto) {
+		case IPPROTO_TCP:
+			*flow_type = TXGBE_ATR_FLOW_TYPE_TCPV4;
+			break;
+		case IPPROTO_UDP:
+			*flow_type = TXGBE_ATR_FLOW_TYPE_UDPV4;
+			break;
+		case IPPROTO_SCTP:
+			*flow_type = TXGBE_ATR_FLOW_TYPE_SCTPV4;
+			break;
+		case 0:
+			if (!fsp->m_u.usr_ip4_spec.proto) {
+				*flow_type = TXGBE_ATR_FLOW_TYPE_IPV4;
+				break;
+			}
+			fallthrough;
+		default:
+			return 0;
+		}
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static bool txgbe_match_ethtool_fdir_entry(struct txgbe_adapter *adapter,
+					   struct txgbe_fdir_filter *input)
+{
+	struct hlist_node *node2;
+	struct txgbe_fdir_filter *rule = NULL;
+
+	hlist_for_each_entry_safe(rule, node2,
+				  &adapter->fdir_filter_list, fdir_node) {
+		if (rule->filter.formatted.bkt_hash ==
+		    input->filter.formatted.bkt_hash &&
+		    rule->action == input->action) {
+			txgbe_info(drv, "FDIR entry already exist\n");
+			return true;
+		}
+	}
+	return false;
+}
+
+static int txgbe_add_ethtool_fdir_entry(struct txgbe_adapter *adapter,
+					struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp =
+		(struct ethtool_rx_flow_spec *)&cmd->fs;
+	struct txgbe_hw *hw = &adapter->hw;
+	struct txgbe_fdir_filter *input;
+	union txgbe_atr_input mask;
+	u8 queue;
+	int err;
+	u16 ptype = 0;
+
+	if (!(adapter->flags & TXGBE_FLAG_FDIR_PERFECT_CAPABLE))
+		return -EOPNOTSUPP;
+
+	/* ring_cookie is a masked into a set of queues and txgbe pools or
+	 * we use drop index
+	 */
+	if (fsp->ring_cookie == RX_CLS_FLOW_DISC) {
+		queue = TXGBE_RDB_FDIR_DROP_QUEUE;
+	} else {
+		u32 ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);
+
+		if (ring >= adapter->num_rx_queues)
+			return -EINVAL;
+
+		/* Map the ring onto the absolute queue index */
+		queue = adapter->rx_ring[ring]->reg_idx;
+	}
+
+	/* Don't allow indexes to exist outside of available space */
+	if (fsp->location >= ((1024 << adapter->fdir_pballoc) - 2)) {
+		txgbe_err(drv, "Location out of range\n");
+		return -EINVAL;
+	}
+
+	input = kzalloc(sizeof(*input), GFP_ATOMIC);
+	if (!input)
+		return -ENOMEM;
+
+	memset(&mask, 0, sizeof(union txgbe_atr_input));
+
+	/* set SW index */
+	input->sw_idx = fsp->location;
+
+	/* record flow type */
+	if (!txgbe_flowspec_to_flow_type(fsp,
+					 &input->filter.formatted.flow_type)) {
+		txgbe_err(drv, "Unrecognized flow type\n");
+		goto err_out;
+	}
+
+	mask.formatted.flow_type = TXGBE_ATR_L4TYPE_IPV6_MASK |
+				   TXGBE_ATR_L4TYPE_MASK;
+
+	if (input->filter.formatted.flow_type == TXGBE_ATR_FLOW_TYPE_IPV4)
+		mask.formatted.flow_type &= TXGBE_ATR_L4TYPE_IPV6_MASK;
+
+	/* Copy input into formatted structures */
+	input->filter.formatted.src_ip[0] = fsp->h_u.tcp_ip4_spec.ip4src;
+	mask.formatted.src_ip[0] = fsp->m_u.tcp_ip4_spec.ip4src;
+	input->filter.formatted.dst_ip[0] = fsp->h_u.tcp_ip4_spec.ip4dst;
+	mask.formatted.dst_ip[0] = fsp->m_u.tcp_ip4_spec.ip4dst;
+	input->filter.formatted.src_port = fsp->h_u.tcp_ip4_spec.psrc;
+	mask.formatted.src_port = fsp->m_u.tcp_ip4_spec.psrc;
+	input->filter.formatted.dst_port = fsp->h_u.tcp_ip4_spec.pdst;
+	mask.formatted.dst_port = fsp->m_u.tcp_ip4_spec.pdst;
+
+	if (fsp->flow_type & FLOW_EXT) {
+		input->filter.formatted.vm_pool =
+				(unsigned char)ntohl(fsp->h_ext.data[1]);
+		mask.formatted.vm_pool =
+				(unsigned char)ntohl(fsp->m_ext.data[1]);
+		input->filter.formatted.flex_bytes =
+						fsp->h_ext.vlan_etype;
+		mask.formatted.flex_bytes = fsp->m_ext.vlan_etype;
+	}
+
+	switch (input->filter.formatted.flow_type) {
+	case TXGBE_ATR_FLOW_TYPE_TCPV4:
+		ptype = TXGBE_PTYPE_L2_IPV4_TCP;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_UDPV4:
+		ptype = TXGBE_PTYPE_L2_IPV4_UDP;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_SCTPV4:
+		ptype = TXGBE_PTYPE_L2_IPV4_SCTP;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_IPV4:
+		ptype = TXGBE_PTYPE_L2_IPV4;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_TCPV6:
+		ptype = TXGBE_PTYPE_L2_IPV6_TCP;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_UDPV6:
+		ptype = TXGBE_PTYPE_L2_IPV6_UDP;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_SCTPV6:
+		ptype = TXGBE_PTYPE_L2_IPV6_SCTP;
+		break;
+	case TXGBE_ATR_FLOW_TYPE_IPV6:
+		ptype = TXGBE_PTYPE_L2_IPV6;
+		break;
+	default:
+		break;
+	}
+
+	input->filter.formatted.vlan_id = htons(ptype);
+	if (mask.formatted.flow_type & TXGBE_ATR_L4TYPE_MASK)
+		mask.formatted.vlan_id = 0xFFFF;
+	else
+		mask.formatted.vlan_id = htons(0xFFF8);
+
+	/* determine if we need to drop or route the packet */
+	if (fsp->ring_cookie == RX_CLS_FLOW_DISC)
+		input->action = TXGBE_RDB_FDIR_DROP_QUEUE;
+	else
+		input->action = fsp->ring_cookie;
+
+	spin_lock(&adapter->fdir_perfect_lock);
+
+	if (hlist_empty(&adapter->fdir_filter_list)) {
+		/* save mask and program input mask into HW */
+		memcpy(&adapter->fdir_mask, &mask, sizeof(mask));
+		err = txgbe_fdir_set_input_mask(hw, &mask,
+						adapter->cloud_mode);
+		if (err) {
+			txgbe_err(drv, "Error writing mask\n");
+			goto err_out_w_lock;
+		}
+	} else if (memcmp(&adapter->fdir_mask, &mask, sizeof(mask))) {
+		txgbe_err(drv,
+			  "Hardware only supports one mask per port. To change the mask you must first delete all the rules.\n");
+		goto err_out_w_lock;
+	}
+
+	/* apply mask and compute/store hash */
+	txgbe_atr_compute_perfect_hash(&input->filter, &mask);
+
+	/* check if new entry does not exist on filter list */
+	if (txgbe_match_ethtool_fdir_entry(adapter, input))
+		goto err_out_w_lock;
+
+	/* only program filters to hardware if the net device is running, as
+	 * we store the filters in the Rx buffer which is not allocated when
+	 * the device is down
+	 */
+	if (netif_running(adapter->netdev)) {
+		err = txgbe_fdir_write_perfect_filter(hw,
+						      &input->filter, input->sw_idx, queue,
+						      adapter->cloud_mode);
+		if (err)
+			goto err_out_w_lock;
+	}
+
+	txgbe_update_ethtool_fdir_entry(adapter, input, input->sw_idx);
+
+	spin_unlock(&adapter->fdir_perfect_lock);
+
+	return err;
+err_out_w_lock:
+	spin_unlock(&adapter->fdir_perfect_lock);
+err_out:
+	kfree(input);
+	return -EINVAL;
+}
+
+static int txgbe_del_ethtool_fdir_entry(struct txgbe_adapter *adapter,
+					struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp =
+		(struct ethtool_rx_flow_spec *)&cmd->fs;
+	int err;
+
+	spin_lock(&adapter->fdir_perfect_lock);
+	err = txgbe_update_ethtool_fdir_entry(adapter, NULL, fsp->location);
+	spin_unlock(&adapter->fdir_perfect_lock);
+
+	return err;
+}
+
+#define UDP_RSS_FLAGS (TXGBE_FLAG2_RSS_FIELD_IPV4_UDP | \
+		       TXGBE_FLAG2_RSS_FIELD_IPV6_UDP)
+static int txgbe_set_rss_hash_opt(struct txgbe_adapter *adapter,
+				  struct ethtool_rxnfc *nfc)
+{
+	u32 flags2 = adapter->flags2;
+
+	/* RSS does not support anything other than hashing
+	 * to queues on src and dst IPs and ports
+	 */
+	if (nfc->data & ~(RXH_IP_SRC | RXH_IP_DST |
+			  RXH_L4_B_0_1 | RXH_L4_B_2_3))
+		return -EINVAL;
+
+	switch (nfc->flow_type) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST) ||
+		    !(nfc->data & RXH_L4_B_0_1) ||
+		    !(nfc->data & RXH_L4_B_2_3))
+			return -EINVAL;
+		break;
+	case UDP_V4_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST))
+			return -EINVAL;
+		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+		case 0:
+			flags2 &= ~TXGBE_FLAG2_RSS_FIELD_IPV4_UDP;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			flags2 |= TXGBE_FLAG2_RSS_FIELD_IPV4_UDP;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case UDP_V6_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST))
+			return -EINVAL;
+		switch (nfc->data & (RXH_L4_B_0_1 | RXH_L4_B_2_3)) {
+		case 0:
+			flags2 &= ~TXGBE_FLAG2_RSS_FIELD_IPV6_UDP;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			flags2 |= TXGBE_FLAG2_RSS_FIELD_IPV6_UDP;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case AH_ESP_V4_FLOW:
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+	case SCTP_V4_FLOW:
+	case AH_ESP_V6_FLOW:
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
+	case SCTP_V6_FLOW:
+		if (!(nfc->data & RXH_IP_SRC) ||
+		    !(nfc->data & RXH_IP_DST) ||
+		    (nfc->data & RXH_L4_B_0_1) ||
+		    (nfc->data & RXH_L4_B_2_3))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* if we changed something we need to update flags */
+	if (flags2 != adapter->flags2) {
+		struct txgbe_hw *hw = &adapter->hw;
+		u32 mrqc;
+
+		mrqc = rd32(hw, TXGBE_RDB_RA_CTL);
+
+		if ((flags2 & UDP_RSS_FLAGS) &&
+		    !(adapter->flags2 & UDP_RSS_FLAGS))
+			txgbe_warn(drv,
+				   "enabling UDP RSS: fragmented packets may arrive out of order to the stack above\n");
+
+		adapter->flags2 = flags2;
+
+		/* Perform hash on these packet types */
+		mrqc |= TXGBE_RDB_RA_CTL_RSS_IPV4
+		      | TXGBE_RDB_RA_CTL_RSS_IPV4_TCP
+		      | TXGBE_RDB_RA_CTL_RSS_IPV6
+		      | TXGBE_RDB_RA_CTL_RSS_IPV6_TCP;
+
+		mrqc &= ~(TXGBE_RDB_RA_CTL_RSS_IPV4_UDP |
+			  TXGBE_RDB_RA_CTL_RSS_IPV6_UDP);
+
+		if (flags2 & TXGBE_FLAG2_RSS_FIELD_IPV4_UDP)
+			mrqc |= TXGBE_RDB_RA_CTL_RSS_IPV4_UDP;
+
+		if (flags2 & TXGBE_FLAG2_RSS_FIELD_IPV6_UDP)
+			mrqc |= TXGBE_RDB_RA_CTL_RSS_IPV6_UDP;
+
+		wr32(hw, TXGBE_RDB_RA_CTL, mrqc);
+	}
+
+	return 0;
+}
+
+static int txgbe_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	int ret = -EOPNOTSUPP;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		ret = txgbe_add_ethtool_fdir_entry(adapter, cmd);
+		break;
+	case ETHTOOL_SRXCLSRLDEL:
+		ret = txgbe_del_ethtool_fdir_entry(adapter, cmd);
+		break;
+	case ETHTOOL_SRXFH:
+		ret = txgbe_set_rss_hash_opt(adapter, cmd);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static u32 txgbe_get_rxfh_key_size(struct net_device *netdev)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	return sizeof(adapter->rss_key);
+}
+
+static u32 txgbe_rss_indir_size(struct net_device *netdev)
+{
+	return 128;
+}
+
+static void txgbe_get_reta(struct txgbe_adapter *adapter, u32 *indir)
+{
+	int i, reta_size = 128;
+
+	for (i = 0; i < reta_size; i++)
+		indir[i] = adapter->rss_indir_tbl[i];
+}
+
+static int txgbe_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
+			  u8 *hfunc)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	if (indir)
+		txgbe_get_reta(adapter, indir);
+
+	if (key)
+		memcpy(key, adapter->rss_key, txgbe_get_rxfh_key_size(netdev));
+
+	return 0;
+}
+
+static int txgbe_set_rxfh(struct net_device *netdev, const u32 *indir,
+			  const u8 *key, const u8 hfunc)
+{
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+	int i;
+	u32 reta_entries = 128;
+
+	if (hfunc)
+		return -EINVAL;
+
+	/* Fill out the redirection table */
+	if (indir) {
+		int max_queues = min_t(int, adapter->num_rx_queues,
+				       TXGBE_RSS_INDIR_TBL_MAX);
+
+		/* Verify user input. */
+		for (i = 0; i < reta_entries; i++)
+			if (indir[i] >= max_queues)
+				return -EINVAL;
+
+		for (i = 0; i < reta_entries; i++)
+			adapter->rss_indir_tbl[i] = indir[i];
+	}
+
+	/* Fill out the rss hash key */
+	if (key)
+		memcpy(adapter->rss_key, key, txgbe_get_rxfh_key_size(netdev));
+
+	txgbe_store_reta(adapter);
+
+	return 0;
+}
+
+static int txgbe_get_ts_info(struct net_device *dev,
+			     struct ethtool_ts_info *info)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+
+	/* we always support timestamping disabled */
+	info->rx_filters = 1 << HWTSTAMP_FILTER_NONE;
+
+	info->so_timestamping =
+		SOF_TIMESTAMPING_TX_SOFTWARE |
+		SOF_TIMESTAMPING_RX_SOFTWARE |
+		SOF_TIMESTAMPING_SOFTWARE |
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	if (adapter->ptp_clock)
+		info->phc_index = ptp_clock_index(adapter->ptp_clock);
+	else
+		info->phc_index = -1;
+
+	info->tx_types =
+		(1 << HWTSTAMP_TX_OFF) |
+		(1 << HWTSTAMP_TX_ON);
+
+	info->rx_filters |=
+		(1 << HWTSTAMP_FILTER_PTP_V1_L4_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_SYNC) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ) |
+		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
+
+	return 0;
+}
+
+static unsigned int txgbe_max_channels(struct txgbe_adapter *adapter)
+{
+	unsigned int max_combined;
+
+	if (!(adapter->flags & TXGBE_FLAG_MSIX_ENABLED)) {
+		/* We only support one q_vector without MSI-X */
+		max_combined = 1;
+	} else if (adapter->atr_sample_rate) {
+		/* support up to 64 queues with ATR */
+		max_combined = TXGBE_MAX_FDIR_INDICES;
+	} else {
+		/* support up to max allowed queues with RSS */
+		max_combined = TXGBE_MAX_RSS_INDICES;
+	}
+
+	return max_combined;
+}
+
+static void txgbe_get_channels(struct net_device *dev,
+			       struct ethtool_channels *ch)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+
+	/* report maximum channels */
+	ch->max_combined = txgbe_max_channels(adapter);
+
+	/* report info for other vector */
+	if (adapter->flags & TXGBE_FLAG_MSIX_ENABLED) {
+		ch->max_other = NON_Q_VECTORS;
+		ch->other_count = NON_Q_VECTORS;
+	}
+
+	/* record RSS queues */
+	ch->combined_count = adapter->ring_feature[RING_F_RSS].indices;
+
+	/* nothing else to report if RSS is disabled */
+	if (ch->combined_count == 1)
+		return;
+
+	/* if ATR is disabled we can exit */
+	if (!adapter->atr_sample_rate)
+		return;
+
+	/* report flow director queues as maximum channels */
+	ch->combined_count = adapter->ring_feature[RING_F_FDIR].indices;
+}
+
+static int txgbe_set_channels(struct net_device *dev,
+			      struct ethtool_channels *ch)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	unsigned int count = ch->combined_count;
+	u8 max_rss_indices = TXGBE_MAX_RSS_INDICES;
+
+	/* verify they are not requesting separate vectors */
+	if (!count || ch->rx_count || ch->tx_count)
+		return -EINVAL;
+
+	/* verify other_count has not changed */
+	if (ch->other_count != NON_Q_VECTORS)
+		return -EINVAL;
+
+	/* verify the number of channels does not exceed hardware limits */
+	if (count > txgbe_max_channels(adapter))
+		return -EINVAL;
+
+	/* update feature limits from largest to smallest supported values */
+	adapter->ring_feature[RING_F_FDIR].limit = count;
+
+	/* cap RSS limit */
+	if (count > max_rss_indices)
+		count = max_rss_indices;
+	adapter->ring_feature[RING_F_RSS].limit = count;
+
+	/* use setup TC to update any traffic class queue mapping */
+	return txgbe_setup_tc(dev, netdev_get_num_tc(dev));
+}
+
+static int txgbe_get_module_info(struct net_device *dev,
+				 struct ethtool_modinfo *modinfo)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 status;
+	u8 sff8472_rev, addr_mode;
+	bool page_swap = false;
+
+	/* Check whether we support SFF-8472 or not */
+	status = TCALL(hw, phy.ops.read_i2c_eeprom,
+		       TXGBE_SFF_SFF_8472_COMP,
+		       &sff8472_rev);
+	if (status != 0)
+		return -EIO;
+
+	/* addressing mode is not supported */
+	status = TCALL(hw, phy.ops.read_i2c_eeprom,
+		       TXGBE_SFF_SFF_8472_SWAP,
+		       &addr_mode);
+	if (status != 0)
+		return -EIO;
+
+	if (addr_mode & TXGBE_SFF_ADDRESSING_MODE) {
+		txgbe_err(drv,
+			  "Address change required to access page 0xA2, but not supported. Please report the module type to the driver maintainers.\n");
+		page_swap = true;
+	}
+
+	if (sff8472_rev == TXGBE_SFF_SFF_8472_UNSUP || page_swap) {
+		/* We have a SFP, but it does not support SFF-8472 */
+		modinfo->type = ETH_MODULE_SFF_8079;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
+	} else {
+		/* We have a SFP which supports a revision of SFF-8472. */
+		modinfo->type = ETH_MODULE_SFF_8472;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+	}
+
+	return 0;
+}
+
+static int txgbe_get_module_eeprom(struct net_device *dev,
+				   struct ethtool_eeprom *ee,
+				   u8 *data)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 status = TXGBE_ERR_PHY_ADDR_INVALID;
+	u8 databyte = 0xFF;
+	int i = 0;
+
+	if (ee->len == 0)
+		return -EINVAL;
+
+	for (i = ee->offset; i < ee->offset + ee->len; i++) {
+		/* I2C reads can take long time */
+		if (test_bit(__TXGBE_IN_SFP_INIT, &adapter->state))
+			return -EBUSY;
+
+		if (i < ETH_MODULE_SFF_8079_LEN)
+			status = TCALL(hw, phy.ops.read_i2c_eeprom, i,
+				       &databyte);
+		else
+			status = TCALL(hw, phy.ops.read_i2c_sff8472, i,
+				       &databyte);
+
+		if (status != 0)
+			return -EIO;
+
+		data[i - ee->offset] = databyte;
+	}
+
+	return 0;
+}
+
+static int txgbe_set_flash(struct net_device *netdev, struct ethtool_flash *ef)
+{
+	int ret;
+	const struct firmware *fw;
+	struct txgbe_adapter *adapter = netdev_priv(netdev);
+
+	ret = request_firmware(&fw, ef->data, &netdev->dev);
+	if (ret < 0)
+		return ret;
+
+	if (ef->region == 0) {
+		ret = txgbe_upgrade_flash(&adapter->hw, ef->region,
+					  fw->data, fw->size);
+	} else {
+		if (txgbe_mng_present(&adapter->hw))
+			ret = txgbe_upgrade_flash_hostif(&adapter->hw,
+							 ef->region,
+							 fw->data, fw->size);
+		else
+			ret = -EOPNOTSUPP;
+	}
+
+	release_firmware(fw);
+	if (!ret)
+		dev_info(&netdev->dev,
+			 "loaded firmware %s, reboot to make firmware work\n",
+			 ef->data);
+	return ret;
+}
+
+static const struct ethtool_ops txgbe_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
+	.get_link_ksettings     = txgbe_get_link_ksettings,
+	.set_link_ksettings     = txgbe_set_link_ksettings,
+	.get_drvinfo            = txgbe_get_drvinfo,
+	.get_regs_len           = txgbe_get_regs_len,
+	.get_regs               = txgbe_get_regs,
+	.get_wol                = txgbe_get_wol,
+	.set_wol                = txgbe_set_wol,
+	.nway_reset             = txgbe_nway_reset,
+	.get_link               = ethtool_op_get_link,
+	.get_eeprom_len         = txgbe_get_eeprom_len,
+	.get_eeprom             = txgbe_get_eeprom,
+	.set_eeprom             = txgbe_set_eeprom,
+	.get_ringparam          = txgbe_get_ringparam,
+	.set_ringparam          = txgbe_set_ringparam,
+	.get_pauseparam         = txgbe_get_pauseparam,
+	.set_pauseparam         = txgbe_set_pauseparam,
+	.get_msglevel           = txgbe_get_msglevel,
+	.set_msglevel           = txgbe_set_msglevel,
+	.self_test              = txgbe_diag_test,
+	.get_strings            = txgbe_get_strings,
+	.set_phys_id            = txgbe_set_phys_id,
+	.get_sset_count         = txgbe_get_sset_count,
+	.get_ethtool_stats      = txgbe_get_ethtool_stats,
+	.get_coalesce           = txgbe_get_coalesce,
+	.set_coalesce           = txgbe_set_coalesce,
+	.get_rxnfc              = txgbe_get_rxnfc,
+	.set_rxnfc              = txgbe_set_rxnfc,
+	.get_channels           = txgbe_get_channels,
+	.set_channels           = txgbe_set_channels,
+	.get_module_info        = txgbe_get_module_info,
+	.get_module_eeprom      = txgbe_get_module_eeprom,
+	.get_ts_info            = txgbe_get_ts_info,
+	.get_rxfh_indir_size    = txgbe_rss_indir_size,
+	.get_rxfh_key_size      = txgbe_get_rxfh_key_size,
+	.get_rxfh               = txgbe_get_rxfh,
+	.set_rxfh               = txgbe_set_rxfh,
+	.flash_device           = txgbe_set_flash,
+};
+
+void txgbe_set_ethtool_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &txgbe_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 040ddb0e46fd..35279209c51d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -158,6 +158,46 @@ s32 txgbe_clear_hw_cntrs(struct txgbe_hw *hw)
 	return 0;
 }
 
+/**
+ * txgbe_device_supports_autoneg_fc - Check if device supports autonegotiation
+ * of flow control
+ * @hw: pointer to hardware structure
+ *
+ * This function returns true if the device supports flow control
+ * autonegotiation, and false if it does not.
+ *
+ **/
+bool txgbe_device_supports_autoneg_fc(struct txgbe_hw *hw)
+{
+	bool supported = false;
+	u32 speed;
+	bool link_up;
+	u8 device_type = hw->subsystem_id & 0xF0;
+
+	switch (hw->phy.media_type) {
+	case txgbe_media_type_fiber:
+		TCALL(hw, mac.ops.check_link, &speed, &link_up, false);
+		/* if link is down, assume supported */
+		if (link_up)
+			supported = speed == TXGBE_LINK_SPEED_1GB_FULL ?
+				true : false;
+		else
+			supported = true;
+		break;
+	case txgbe_media_type_backplane:
+		supported = (device_type != TXGBE_ID_MAC_XAUI &&
+			     device_type != TXGBE_ID_MAC_SGMII);
+		break;
+	default:
+		break;
+	}
+
+	ERROR_REPORT2(TXGBE_ERROR_UNSUPPORTED,
+		      "Device %x does not support flow control autoneg",
+		      hw->device_id);
+	return supported;
+}
+
 /**
  *  txgbe_setup_fc - Set up flow control
  *  @hw: pointer to hardware structure
@@ -1903,6 +1943,337 @@ s32 txgbe_reset_hostif(struct txgbe_hw *hw)
 	return status;
 }
 
+u16 txgbe_crc16_ccitt(const u8 *buf, int size)
+{
+	u16 crc = 0;
+	int i;
+
+	while (--size >= 0) {
+		crc ^= (u16)*buf++ << 8;
+		for (i = 0; i < 8; i++) {
+			if (crc & 0x8000)
+				crc = crc << 1 ^ 0x1021;
+			else
+				crc <<= 1;
+		}
+	}
+	return crc;
+}
+
+s32 txgbe_upgrade_flash_hostif(struct txgbe_hw *hw, u32 region,
+			       const u8 *data, u32 size)
+{
+	struct txgbe_hic_upg_start start_cmd;
+	struct txgbe_hic_upg_write write_cmd;
+	struct txgbe_hic_upg_verify verify_cmd;
+	u32 offset;
+	s32 status = 0;
+
+	start_cmd.hdr.cmd = FW_FLASH_UPGRADE_START_CMD;
+	start_cmd.hdr.buf_len = FW_FLASH_UPGRADE_START_LEN;
+	start_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
+	start_cmd.module_id = (u8)region;
+	start_cmd.hdr.checksum = 0;
+	start_cmd.hdr.checksum = txgbe_calculate_checksum((u8 *)&start_cmd,
+				(FW_CEM_HDR_LEN + start_cmd.hdr.buf_len));
+	start_cmd.pad2 = 0;
+	start_cmd.pad3 = 0;
+
+	status = txgbe_host_interface_command(hw, (u32 *)&start_cmd,
+					      sizeof(start_cmd),
+					      TXGBE_HI_FLASH_ERASE_TIMEOUT,
+					      true);
+
+	if (start_cmd.hdr.cmd_or_resp.ret_status == FW_CEM_RESP_STATUS_SUCCESS) {
+		status = 0;
+	} else {
+		status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
+		return status;
+	}
+
+	for (offset = 0; offset < size;) {
+		write_cmd.hdr.cmd = FW_FLASH_UPGRADE_WRITE_CMD;
+		if (size - offset > 248) {
+			write_cmd.data_len = 248 / 4;
+			write_cmd.eof_flag = 0;
+		} else {
+			write_cmd.data_len = (u8)((size - offset) / 4);
+			write_cmd.eof_flag = 1;
+		}
+		memcpy((u8 *)write_cmd.data, &data[offset], write_cmd.data_len * 4);
+		write_cmd.hdr.buf_len = (write_cmd.data_len + 1) * 4;
+		write_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
+		write_cmd.check_sum = txgbe_crc16_ccitt((u8 *)write_cmd.data,
+							write_cmd.data_len * 4);
+
+		status = txgbe_host_interface_command(hw, (u32 *)&write_cmd,
+						      sizeof(write_cmd),
+						      TXGBE_HI_FLASH_UPDATE_TIMEOUT,
+						      true);
+		if (start_cmd.hdr.cmd_or_resp.ret_status ==
+						FW_CEM_RESP_STATUS_SUCCESS) {
+			status = 0;
+		} else {
+			status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
+			return status;
+		}
+		offset += write_cmd.data_len * 4;
+	}
+
+	verify_cmd.hdr.cmd = FW_FLASH_UPGRADE_VERIFY_CMD;
+	verify_cmd.hdr.buf_len = FW_FLASH_UPGRADE_VERIFY_LEN;
+	verify_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
+	switch (region) {
+	case TXGBE_MODULE_EEPROM:
+		verify_cmd.action_flag = TXGBE_RELOAD_EEPROM;
+		break;
+	case TXGBE_MODULE_FIRMWARE:
+		verify_cmd.action_flag = TXGBE_RESET_FIRMWARE;
+		break;
+	case TXGBE_MODULE_HARDWARE:
+		verify_cmd.action_flag = TXGBE_RESET_LAN;
+		break;
+	default:
+		return status;
+	}
+
+	verify_cmd.hdr.checksum = txgbe_calculate_checksum((u8 *)&verify_cmd,
+				(FW_CEM_HDR_LEN + verify_cmd.hdr.buf_len));
+
+	status = txgbe_host_interface_command(hw, (u32 *)&verify_cmd,
+					      sizeof(verify_cmd),
+					      TXGBE_HI_FLASH_VERIFY_TIMEOUT,
+					      true);
+
+	if (verify_cmd.hdr.cmd_or_resp.ret_status == FW_CEM_RESP_STATUS_SUCCESS)
+		status = 0;
+	else
+		status = TXGBE_ERR_HOST_INTERFACE_COMMAND;
+
+	return status;
+}
+
+/**
+ * cmd_addr is used for some special command:
+ *	 1. to be sector address, when implemented erase sector command
+ *	 2. to be flash address when implemented read, write flash address
+ **/
+u8 fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr)
+{
+	u32 cmd_val = 0;
+	u32 time_out = 0;
+
+	cmd_val = (cmd << SPI_CLK_CMD_OFFSET) |
+		  (SPI_CLK_DIV << SPI_CLK_DIV_OFFSET) | cmd_addr;
+	wr32(hw, SPI_H_CMD_REG_ADDR, cmd_val);
+	while (1) {
+		if (rd32(hw, SPI_H_STA_REG_ADDR) & 0x1)
+			break;
+
+		if (time_out == SPI_TIME_OUT_VALUE)
+			return 1;
+
+		time_out = time_out + 1;
+		usleep_range(10, 20);
+	}
+
+	return 0;
+}
+
+u8 fmgr_usr_cmd_op(struct txgbe_hw *hw, u32 usr_cmd)
+{
+	u8 status = 0;
+
+	wr32(hw, SPI_H_USR_CMD_REG_ADDR, usr_cmd);
+	status = fmgr_cmd_op(hw, SPI_CMD_USER_CMD, 0);
+
+	return status;
+}
+
+u8 flash_erase_chip(struct txgbe_hw *hw)
+{
+	u8 status = fmgr_cmd_op(hw, SPI_CMD_ERASE_CHIP, 0);
+	return status;
+}
+
+u8 flash_erase_sector(struct txgbe_hw *hw, u32 sec_addr)
+{
+	u8 status = fmgr_cmd_op(hw, SPI_CMD_ERASE_SECTOR, sec_addr);
+	return status;
+}
+
+u32 flash_read_dword(struct txgbe_hw *hw, u32 addr)
+{
+	u8 status = fmgr_cmd_op(hw, SPI_CMD_READ_DWORD, addr);
+
+	if (status)
+		return (u32)status;
+
+	return rd32(hw, SPI_H_DAT_REG_ADDR);
+}
+
+u8 flash_write_dword(struct txgbe_hw *hw, u32 addr, u32 dword)
+{
+	u8 status = 0;
+
+	wr32(hw, SPI_H_DAT_REG_ADDR, dword);
+	status = fmgr_cmd_op(hw, SPI_CMD_WRITE_DWORD, addr);
+	if (status)
+		return status;
+
+	if (dword != flash_read_dword(hw, addr))
+		return 1;
+
+	return 0;
+}
+
+int txgbe_upgrade_flash(struct txgbe_hw *hw, u32 region,
+			const u8 *data, u32 size)
+{
+	u32 sector_num = 0;
+	u32 read_data = 0;
+	u8 status = 0;
+	u8 skip = 0;
+	u32 i = 0;
+	u8 flash_vendor = 0;
+	u32 mac_addr0_dword0_t;
+	u32 mac_addr0_dword1_t;
+	u32 mac_addr1_dword0_t;
+	u32 mac_addr1_dword1_t;
+	u32 serial_num_dword0_t;
+	u32 serial_num_dword1_t;
+	u32 serial_num_dword2_t;
+
+	/* check sub_id */;
+	DEBUGOUT("Checking sub_id .......\n");
+	DEBUGOUT1("The card's sub_id : %04x\n", hw->subsystem_id);
+	DEBUGOUT1("The image's sub_id : %04x\n",
+		  data[0xfffdc] << 8 | data[0xfffdd]);
+	if ((hw->subsystem_id & 0xfff) == ((data[0xfffdc] << 8 |
+					    data[0xfffdd]) & 0xfff)) {
+		DEBUGOUT("It is a right image\n");
+	} else if (hw->subsystem_id == 0xffff) {
+		DEBUGOUT("update anyway\n");
+	} else {
+		DEBUGOUT("====The Gigabit image is not match the Gigabit card====\n");
+		DEBUGOUT("====Please check your image====\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* check dev_id */
+	DEBUGOUT("Checking dev_id .......\n");
+	DEBUGOUT1("The image's dev_id : %04x\n",
+		  data[0xfffde] << 8 | data[0xfffdf]);
+	DEBUGOUT1("The card's dev_id : %04x\n", hw->device_id);
+	if (!((hw->device_id & 0xfff0) == ((data[0xfffde] << 8 | data[0xfffdf]) & 0xfff0)) &&
+	    !(hw->device_id == 0xffff)) {
+		DEBUGOUT("====The Gigabit image is not match the Gigabit card====\n");
+		DEBUGOUT("====Please check your image====\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* unlock flash write protect */
+	wr32(hw, TXGBE_SPI_CMDCFG0, 0x9f050206);
+	wr32(hw, 0x10194, 0x9f050206);
+
+	msleep(1000);
+
+	mac_addr0_dword0_t = flash_read_dword(hw, MAC_ADDR0_WORD0_OFFSET_1G);
+	mac_addr0_dword1_t = flash_read_dword(hw, MAC_ADDR0_WORD1_OFFSET_1G) &
+				0xffff;
+	mac_addr1_dword0_t = flash_read_dword(hw, MAC_ADDR1_WORD0_OFFSET_1G);
+	mac_addr1_dword1_t = flash_read_dword(hw, MAC_ADDR1_WORD1_OFFSET_1G) &
+				0xffff;
+
+	serial_num_dword0_t = flash_read_dword(hw,
+					       PRODUCT_SERIAL_NUM_OFFSET_1G);
+	serial_num_dword1_t = flash_read_dword(hw,
+					       PRODUCT_SERIAL_NUM_OFFSET_1G + 4);
+	serial_num_dword2_t = flash_read_dword(hw,
+					       PRODUCT_SERIAL_NUM_OFFSET_1G + 8);
+	DEBUGOUT2("Old: MAC Address0 is: 0x%04x%08x\n",
+		  mac_addr0_dword1_t, mac_addr0_dword0_t);
+	DEBUGOUT2("     MAC Address1 is: 0x%04x%08x\n",
+		  mac_addr1_dword1_t, mac_addr1_dword0_t);
+
+	status = fmgr_usr_cmd_op(hw, 0x6);  /* write enable */
+	status = fmgr_usr_cmd_op(hw, 0x98); /* global protection un-lock */
+	msleep(1000);
+
+	/* Note: for Spanish FLASH, first 8 sectors (4KB) in sector0 (64KB)
+	 * need to use a special erase command (4K sector erase)
+	 */
+	if (flash_vendor == 1) {
+		for (i = 0; i < 8; i++) {
+			flash_erase_sector(hw, i * 128);
+			msleep(20); /* 20 ms */
+		}
+		wr32(hw, SPI_CMD_CFG1_ADDR, 0x0103c7d8);
+	}
+
+	sector_num = size / SPI_SECTOR_SIZE;
+
+	/* Winbond Flash, erase chip command is okay,
+	 * but erase sector doestn't work.
+	 */
+	if (flash_vendor == 2) {
+		status = flash_erase_chip(hw);
+		DEBUGOUT1("Erase chip command, return status = %0d\n", status);
+		msleep(1000);
+	} else {
+		wr32(hw, SPI_CMD_CFG1_ADDR, 0x0103c720);
+		for (i = 0; i < sector_num; i++) {
+			status = flash_erase_sector(hw, i * SPI_SECTOR_SIZE);
+			DEBUGOUT2("Erase sector[%2d] command, return status = %0d\n",
+				  i, status);
+			msleep(50);
+		}
+		wr32(hw, SPI_CMD_CFG1_ADDR, 0x0103c7d8);
+	}
+
+	/* Program Image file in dword */
+	for (i = 0; i < size / 4; i++) {
+		read_data = data[4 * i + 3] << 24 | data[4 * i + 2] << 16 |
+				data[4 * i + 1] << 8 | data[4 * i];
+		read_data = __le32_to_cpu(read_data);
+		skip = ((i * 4 == MAC_ADDR0_WORD0_OFFSET_1G) ||
+			(i * 4 == MAC_ADDR0_WORD1_OFFSET_1G) ||
+			(i * 4 == MAC_ADDR1_WORD0_OFFSET_1G) ||
+			(i * 4 == MAC_ADDR1_WORD1_OFFSET_1G) ||
+			(i * 4 >= PRODUCT_SERIAL_NUM_OFFSET_1G &&
+			 i * 4 <= PRODUCT_SERIAL_NUM_OFFSET_1G + 8));
+		if (read_data != 0xffffffff && !skip) {
+			status = flash_write_dword(hw, i * 4, read_data);
+			if (status) {
+				DEBUGOUT2("ERROR: Program 0x%08x @addr: 0x%08x is failed !!\n",
+					  read_data, i * 4);
+				read_data = flash_read_dword(hw, i * 4);
+				DEBUGOUT1("Read data from Flash is: 0x%08x\n",
+					  read_data);
+				return 1;
+			}
+		}
+		if (i % 1024 == 0)
+			DEBUGOUT1("\b\b\b\b%3d%%", (int)(i * 4 * 100 / size));
+	}
+	flash_write_dword(hw, MAC_ADDR0_WORD0_OFFSET_1G,
+			  mac_addr0_dword0_t);
+	flash_write_dword(hw, MAC_ADDR0_WORD1_OFFSET_1G,
+			  mac_addr0_dword1_t | 0x80000000); /* lan0 */
+	flash_write_dword(hw, MAC_ADDR1_WORD0_OFFSET_1G,
+			  mac_addr1_dword0_t);
+	flash_write_dword(hw, MAC_ADDR1_WORD1_OFFSET_1G,
+			  mac_addr1_dword1_t | 0x80000000); /* lan1 */
+	flash_write_dword(hw, PRODUCT_SERIAL_NUM_OFFSET_1G,
+			  serial_num_dword0_t);
+	flash_write_dword(hw, PRODUCT_SERIAL_NUM_OFFSET_1G + 4,
+			  serial_num_dword1_t);
+	flash_write_dword(hw, PRODUCT_SERIAL_NUM_OFFSET_1G + 8,
+			  serial_num_dword2_t);
+
+	return 0;
+}
+
 /**
  * txgbe_set_rxpba - Initialize Rx packet buffer
  * @hw: pointer to hardware structure
@@ -2633,6 +3004,7 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 
 	/* PHY */
 	phy->ops.read_i2c_byte = txgbe_read_i2c_byte;
+	phy->ops.read_i2c_sff8472 = txgbe_read_i2c_sff8472;
 	phy->ops.read_i2c_eeprom = txgbe_read_i2c_eeprom;
 	phy->ops.identify_sfp = txgbe_identify_module;
 	phy->ops.check_overtemp = txgbe_check_overtemp;
@@ -2694,6 +3066,9 @@ s32 txgbe_init_ops(struct txgbe_hw *hw)
 	eeprom->ops.calc_checksum = txgbe_calc_eeprom_checksum;
 	eeprom->ops.read = txgbe_read_ee_hostif;
 	eeprom->ops.read_buffer = txgbe_read_ee_hostif_buffer;
+	eeprom->ops.write = txgbe_write_ee_hostif;
+	eeprom->ops.write_buffer = txgbe_write_ee_hostif_buffer;
+	eeprom->ops.update_checksum = txgbe_update_eeprom_checksum;
 	eeprom->ops.validate_checksum = txgbe_validate_eeprom_checksum;
 
 	/* Manageability interface */
@@ -4674,6 +5049,43 @@ s32 txgbe_fdir_write_perfect_filter(struct txgbe_hw *hw,
 	return 0;
 }
 
+s32 txgbe_fdir_erase_perfect_filter(struct txgbe_hw *hw,
+				    union txgbe_atr_input *input,
+				    u16 soft_id)
+{
+	u32 fdirhash;
+	u32 fdircmd;
+	s32 err;
+
+	/* configure FDIRHASH register */
+	fdirhash = input->formatted.bkt_hash;
+	fdirhash |= soft_id << TXGBE_RDB_FDIR_HASH_SIG_SW_INDEX_SHIFT;
+	wr32(hw, TXGBE_RDB_FDIR_HASH, fdirhash);
+
+	/* flush hash to HW */
+	TXGBE_WRITE_FLUSH(hw);
+
+	/* Query if filter is present */
+	wr32(hw, TXGBE_RDB_FDIR_CMD,
+	     TXGBE_RDB_FDIR_CMD_CMD_QUERY_REM_FILT);
+
+	err = txgbe_fdir_check_cmd_complete(hw, &fdircmd);
+	if (err) {
+		DEBUGOUT("Flow Director command did not complete!\n");
+		return err;
+	}
+
+	/* if filter exists in hardware then remove it */
+	if (fdircmd & TXGBE_RDB_FDIR_CMD_FILTER_VALID) {
+		wr32(hw, TXGBE_RDB_FDIR_HASH, fdirhash);
+		TXGBE_WRITE_FLUSH(hw);
+		wr32(hw, TXGBE_RDB_FDIR_CMD,
+		     TXGBE_RDB_FDIR_CMD_CMD_REMOVE_FLOW);
+	}
+
+	return 0;
+}
+
 /**
  *  txgbe_start_hw - Prepare hardware for Tx/Rx
  *  @hw: pointer to hardware structure
@@ -4959,6 +5371,102 @@ s32 txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
 	return status;
 }
 
+/**
+ *  txgbe_write_ee_hostif - Write EEPROM word using hostif
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to write
+ *  @data: word write to the EEPROM
+ *
+ *  Write a 16 bit word to the EEPROM using the hostif.
+ **/
+s32 txgbe_write_ee_hostif_data(struct txgbe_hw *hw, u16 offset,
+			       u16 data)
+{
+	s32 status;
+	struct txgbe_hic_write_shadow_ram buffer;
+
+	buffer.hdr.req.cmd = FW_WRITE_SHADOW_RAM_CMD;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = FW_WRITE_SHADOW_RAM_LEN;
+	buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+	/* one word */
+	buffer.length = TXGBE_CPU_TO_BE16(sizeof(u16));
+	buffer.data = data;
+	buffer.address = TXGBE_CPU_TO_BE32(offset * 2);
+
+	status = txgbe_host_interface_command(hw, (u32 *)&buffer,
+					      sizeof(buffer),
+					      TXGBE_HI_COMMAND_TIMEOUT, false);
+
+	return status;
+}
+
+/**
+ *  txgbe_write_ee_hostif - Write EEPROM word using hostif
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to write
+ *  @data: word write to the EEPROM
+ *
+ *  Write a 16 bit word to the EEPROM using the hostif.
+ **/
+s32 txgbe_write_ee_hostif(struct txgbe_hw *hw, u16 offset,
+			  u16 data)
+{
+	s32 status = 0;
+
+	if (TCALL(hw, mac.ops.acquire_swfw_sync,
+		  TXGBE_MNG_SWFW_SYNC_SW_FLASH) == 0) {
+		status = txgbe_write_ee_hostif_data(hw, offset, data);
+		TCALL(hw, mac.ops.release_swfw_sync,
+		      TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	} else {
+		DEBUGOUT("write ee hostif failed to get semaphore");
+		status = TXGBE_ERR_SWFW_SYNC;
+	}
+
+	return status;
+}
+
+/**
+ *  txgbe_write_ee_hostif_buffer - Write EEPROM word(s) using hostif
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to write
+ *  @words: number of words
+ *  @data: word(s) write to the EEPROM
+ *
+ *  Write a 16 bit word(s) to the EEPROM using the hostif.
+ **/
+s32 txgbe_write_ee_hostif_buffer(struct txgbe_hw *hw,
+				 u16 offset, u16 words, u16 *data)
+{
+	s32 status = 0;
+	u16 i = 0;
+
+	/* Take semaphore for the entire operation. */
+	status = TCALL(hw, mac.ops.acquire_swfw_sync,
+		       TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+	if (status != 0) {
+		DEBUGOUT("EEPROM write buffer - semaphore failed\n");
+		goto out;
+	}
+
+	for (i = 0; i < words; i++) {
+		status = txgbe_write_ee_hostif_data(hw, offset + i,
+						    data[i]);
+
+		if (status != 0) {
+			DEBUGOUT("EEPROM buffered write failed\n");
+			break;
+		}
+	}
+
+	TCALL(hw, mac.ops.release_swfw_sync, TXGBE_MNG_SWFW_SYNC_SW_FLASH);
+out:
+
+	return status;
+}
+
 s32 txgbe_close_notify(struct txgbe_hw *hw)
 {
 	int tmp;
@@ -5078,6 +5586,39 @@ s32 txgbe_calc_eeprom_checksum(struct txgbe_hw *hw)
 	return (s32)checksum;
 }
 
+/**
+ * txgbe_update_eeprom_checksum - Updates the EEPROM checksum and flash
+ * @hw: pointer to hardware structure
+ **/
+s32 txgbe_update_eeprom_checksum(struct txgbe_hw *hw)
+{
+	s32 status;
+	u16 checksum = 0;
+
+	/* Read the first word from the EEPROM. If this times out or fails, do
+	 * not continue or we could be in for a very long wait while every
+	 * EEPROM read fails
+	 */
+	status = txgbe_read_ee_hostif(hw, 0, &checksum);
+	if (status) {
+		DEBUGOUT("EEPROM read failed\n");
+		return status;
+	}
+
+	status = txgbe_calc_eeprom_checksum(hw);
+	if (status < 0)
+		return status;
+
+	checksum = (u16)(status & 0xffff);
+
+	status = txgbe_write_ee_hostif(hw, TXGBE_EEPROM_CHECKSUM,
+				       checksum);
+	if (status)
+		return status;
+
+	return status;
+}
+
 /**
  *  txgbe_validate_eeprom_checksum - Validate EEPROM checksum
  *  @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
index e6b78292c60b..eb1e189fbaa5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
@@ -4,6 +4,31 @@
 #ifndef _TXGBE_HW_H_
 #define _TXGBE_HW_H_
 
+#define SPI_CLK_DIV                        2
+
+#define SPI_CMD_ERASE_CHIP                 4  // SPI erase chip command
+#define SPI_CMD_ERASE_SECTOR               3  // SPI erase sector command
+#define SPI_CMD_WRITE_DWORD                0  // SPI write a dword command
+#define SPI_CMD_READ_DWORD                 1  // SPI read a dword command
+#define SPI_CMD_USER_CMD                   5  // SPI user command
+
+#define SPI_CLK_CMD_OFFSET                28  // SPI command field offset in Command register
+#define SPI_CLK_DIV_OFFSET                25  // SPI clock divide field offset in Command register
+
+#define SPI_TIME_OUT_VALUE           10000
+#define SPI_SECTOR_SIZE           (4 * 1024)  // FLASH sector size is 64KB
+#define SPI_H_CMD_REG_ADDR           0x10104  // SPI Command register address
+#define SPI_H_DAT_REG_ADDR           0x10108  // SPI Data register address
+#define SPI_H_STA_REG_ADDR           0x1010c  // SPI Status register address
+#define SPI_H_USR_CMD_REG_ADDR       0x10110  // SPI User Command register address
+#define SPI_CMD_CFG1_ADDR            0x10118  // Flash command configuration register 1
+
+#define MAC_ADDR0_WORD0_OFFSET_1G    0x006000c  // MAC Address for LAN0, stored in external FLASH
+#define MAC_ADDR0_WORD1_OFFSET_1G    0x0060014
+#define MAC_ADDR1_WORD0_OFFSET_1G    0x007000c  // MAC Address for LAN1, stored in external FLASH
+#define MAC_ADDR1_WORD1_OFFSET_1G    0x0070014
+#define PRODUCT_SERIAL_NUM_OFFSET_1G    0x00f0000
+
 /**
  * Packet Type decoding
  **/
@@ -91,6 +116,7 @@ s32 txgbe_disable_sec_rx_path(struct txgbe_hw *hw);
 s32 txgbe_enable_sec_rx_path(struct txgbe_hw *hw);
 
 s32 txgbe_fc_enable(struct txgbe_hw *hw);
+bool txgbe_device_supports_autoneg_fc(struct txgbe_hw *hw);
 void txgbe_fc_autoneg(struct txgbe_hw *hw);
 s32 txgbe_setup_fc(struct txgbe_hw *hw);
 
@@ -143,6 +169,9 @@ s32 txgbe_fdir_set_input_mask(struct txgbe_hw *hw,
 s32 txgbe_fdir_write_perfect_filter(struct txgbe_hw *hw,
 				    union txgbe_atr_input *input,
 				    u16 soft_id, u8 queue, bool cloud_mode);
+s32 txgbe_fdir_erase_perfect_filter(struct txgbe_hw *hw,
+				    union txgbe_atr_input *input,
+				    u16 soft_id);
 s32 txgbe_fdir_add_perfect_filter(struct txgbe_hw *hw,
 				  union txgbe_atr_input *input,
 				  union txgbe_atr_input *mask,
@@ -174,9 +203,16 @@ s32 txgbe_enable_rx_dma(struct txgbe_hw *hw, u32 regval);
 s32 txgbe_init_ops(struct txgbe_hw *hw);
 
 s32 txgbe_init_eeprom_params(struct txgbe_hw *hw);
+s32 txgbe_update_eeprom_checksum(struct txgbe_hw *hw);
 s32 txgbe_calc_eeprom_checksum(struct txgbe_hw *hw);
 s32 txgbe_validate_eeprom_checksum(struct txgbe_hw *hw,
 				   u16 *checksum_val);
+int txgbe_upgrade_flash(struct txgbe_hw *hw, u32 region,
+			const u8 *data, u32 size);
+s32 txgbe_write_ee_hostif_buffer(struct txgbe_hw *hw,
+				 u16 offset, u16 words, u16 *data);
+s32 txgbe_write_ee_hostif(struct txgbe_hw *hw, u16 offset,
+			  u16 data);
 s32 txgbe_read_ee_hostif_buffer(struct txgbe_hw *hw,
 				u16 offset, u16 words, u16 *data);
 s32 txgbe_read_ee_hostif_data(struct txgbe_hw *hw, u16 offset, u16 *data);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index b225417c27d5..0e5400dbdd9a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -155,6 +155,79 @@ static void txgbe_remove_adapter(struct txgbe_hw *hw)
 		txgbe_service_event_schedule(adapter);
 }
 
+static void txgbe_check_remove(struct txgbe_hw *hw, u32 reg)
+{
+	u32 value;
+
+	/* The following check not only optimizes a bit by not
+	 * performing a read on the status register when the
+	 * register just read was a status register read that
+	 * returned TXGBE_FAILED_READ_REG. It also blocks any
+	 * potential recursion.
+	 */
+	if (reg == TXGBE_CFG_PORT_ST) {
+		txgbe_remove_adapter(hw);
+		return;
+	}
+	value = rd32(hw, TXGBE_CFG_PORT_ST);
+	if (value == TXGBE_FAILED_READ_REG)
+		txgbe_remove_adapter(hw);
+}
+
+static u32 txgbe_validate_register_read(struct txgbe_hw *hw, u32 reg, bool quiet)
+{
+	int i;
+	u32 value;
+	u8 __iomem *reg_addr;
+	struct txgbe_adapter *adapter = hw->back;
+
+	reg_addr = READ_ONCE(hw->hw_addr);
+	if (TXGBE_REMOVED(reg_addr))
+		return TXGBE_FAILED_READ_REG;
+	for (i = 0; i < TXGBE_DEAD_READ_RETRIES; ++i) {
+		value = txgbe_rd32(reg_addr + reg);
+		if (value != TXGBE_DEAD_READ_REG)
+			break;
+	}
+	if (quiet)
+		return value;
+	if (value == TXGBE_DEAD_READ_REG)
+		txgbe_err(drv, "%s: register %x read unchanged\n", __func__, reg);
+	else
+		txgbe_warn(hw, "%s: register %x read recovered after %d retries\n",
+			   __func__, reg, i + 1);
+	return value;
+}
+
+/**
+ * txgbe_read_reg - Read from device register
+ * @hw: hw specific details
+ * @reg: offset of register to read
+ *
+ * Returns : value read or TXGBE_FAILED_READ_REG if removed
+ *
+ * This function is used to read device registers. It checks for device
+ * removal by confirming any read that returns all ones by checking the
+ * status register value for all ones. This function avoids reading from
+ * the hardware if a removal was previously detected in which case it
+ * returns TXGBE_FAILED_READ_REG (all ones).
+ */
+u32 txgbe_read_reg(struct txgbe_hw *hw, u32 reg, bool quiet)
+{
+	u32 value;
+	u8 __iomem *reg_addr;
+
+	reg_addr = READ_ONCE(hw->hw_addr);
+	if (TXGBE_REMOVED(reg_addr))
+		return TXGBE_FAILED_READ_REG;
+	value = txgbe_rd32(reg_addr + reg);
+	if (unlikely(value == TXGBE_FAILED_READ_REG))
+		txgbe_check_remove(hw, reg);
+	if (unlikely(value == TXGBE_DEAD_READ_REG))
+		value = txgbe_validate_register_read(hw, reg, quiet);
+	return value;
+}
+
 static void txgbe_release_hw_control(struct txgbe_adapter *adapter)
 {
 	/* Let firmware take over control of hw */
@@ -3854,6 +3927,10 @@ int txgbe_open(struct net_device *netdev)
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
 	int err;
 
+	/* disallow open during test */
+	if (test_bit(__TXGBE_TESTING, &adapter->state))
+		return -EBUSY;
+
 	netif_carrier_off(netdev);
 
 	/* allocate transmit descriptors */
@@ -3970,6 +4047,8 @@ static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct txgbe_adapter *adapter = pci_get_drvdata(pdev);
 	struct net_device *netdev = adapter->netdev;
+	struct txgbe_hw *hw = &adapter->hw;
+	u32 wufc = adapter->wol;
 
 	netif_device_detach(netdev);
 
@@ -3980,6 +4059,27 @@ static int __txgbe_shutdown(struct pci_dev *pdev, bool *enable_wake)
 
 	txgbe_clear_interrupt_scheme(adapter);
 
+	if (wufc) {
+		txgbe_set_rx_mode(netdev);
+		txgbe_configure_rx(adapter);
+		/* enable the optics for SFP+ fiber as we can WoL */
+		TCALL(hw, mac.ops.enable_tx_laser);
+
+		/* turn on all-multi mode if wake on multicast is enabled */
+		if (wufc & TXGBE_PSR_WKUP_CTL_MC) {
+			wr32m(hw, TXGBE_PSR_CTL,
+			      TXGBE_PSR_CTL_MPE, TXGBE_PSR_CTL_MPE);
+		}
+
+		pci_clear_master(adapter->pdev);
+		wr32(hw, TXGBE_PSR_WKUP_CTL, wufc);
+	} else {
+		wr32(hw, TXGBE_PSR_WKUP_CTL, 0);
+	}
+
+	pci_wake_from_d3(pdev, !!wufc);
+
+	*enable_wake = !!wufc;
 	txgbe_release_hw_control(adapter);
 
 	if (!test_and_set_bit(__TXGBE_DISABLED, &adapter->state))
@@ -5720,6 +5820,37 @@ static int txgbe_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 	}
 }
 
+/**
+ * txgbe_setup_tc - routine to configure net_device for multiple traffic
+ * classes.
+ *
+ * @netdev: net device to configure
+ * @tc: number of traffic classes to enable
+ */
+int txgbe_setup_tc(struct net_device *dev, u8 tc)
+{
+	struct txgbe_adapter *adapter = netdev_priv(dev);
+
+	/* Hardware has to reinitialize queues and interrupts to
+	 * match packet buffer alignment. Unfortunately, the
+	 * hardware is not flexible enough to do this dynamically.
+	 */
+	if (netif_running(dev))
+		txgbe_close(dev);
+	else
+		txgbe_reset(adapter);
+
+	txgbe_clear_interrupt_scheme(adapter);
+
+	netdev_reset_tc(dev);
+
+	txgbe_init_interrupt_scheme(adapter);
+	if (netif_running(dev))
+		txgbe_open(dev);
+
+	return 0;
+}
+
 void txgbe_do_reset(struct net_device *netdev)
 {
 	struct txgbe_adapter *adapter = netdev_priv(netdev);
@@ -5904,6 +6035,29 @@ static const struct net_device_ops txgbe_netdev_ops = {
 void txgbe_assign_netdev_ops(struct net_device *dev)
 {
 	dev->netdev_ops = &txgbe_netdev_ops;
+	txgbe_set_ethtool_ops(dev);
+}
+
+/**
+ * txgbe_wol_supported - Check whether device supports WoL
+ * @adapter: the adapter private structure
+ *
+ * This function is used by probe and ethtool to determine
+ * which devices have WoL support
+ *
+ **/
+int txgbe_wol_supported(struct txgbe_adapter *adapter)
+{
+	struct txgbe_hw *hw = &adapter->hw;
+	u16 wol_cap = adapter->eeprom_cap & TXGBE_DEVICE_CAPS_WOL_MASK;
+
+	/* check eeprom to see if WOL is enabled */
+	if (wol_cap == TXGBE_DEVICE_CAPS_WOL_PORT0_1 ||
+	    (wol_cap == TXGBE_DEVICE_CAPS_WOL_PORT0 &&
+	     hw->bus.func == 0))
+		return true;
+	else
+		return false;
 }
 
 /**
@@ -6117,6 +6271,21 @@ static int txgbe_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_sw_init;
 
+	/* WOL not supported for all devices */
+	adapter->wol = 0;
+	TCALL(hw, eeprom.ops.read,
+	      hw->eeprom.sw_region_offset + TXGBE_DEVICE_CAPS,
+	      &adapter->eeprom_cap);
+
+	if ((hw->subsystem_device_id & TXGBE_WOL_MASK) == TXGBE_WOL_SUP &&
+	    hw->bus.lan_id == 0) {
+		adapter->wol = TXGBE_PSR_WKUP_CTL_MAG;
+		wr32(hw, TXGBE_PSR_WKUP_CTL, adapter->wol);
+	}
+	hw->wol_enabled = !!(adapter->wol);
+
+	device_set_wakeup_enable(pci_dev_to_dev(adapter->pdev), adapter->wol);
+
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
 	 */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 1e3137506812..c2fd45c8cfa5 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -319,6 +319,22 @@ s32 txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
 		     eeprom_data);
 }
 
+/**
+ *  txgbe_read_i2c_sff8472 - Reads 8 bit word over I2C interface
+ *  @hw: pointer to hardware structure
+ *  @byte_offset: byte offset at address 0xA2
+ *  @eeprom_data: value read
+ *
+ *  Performs byte read operation to SFP module's SFF-8472 data over I2C
+ **/
+s32 txgbe_read_i2c_sff8472(struct txgbe_hw *hw, u8 byte_offset,
+			   u8 *sff8472_data)
+{
+	return TCALL(hw, phy.ops.read_i2c_byte, byte_offset,
+		     TXGBE_I2C_EEPROM_DEV_ADDR2,
+		     sff8472_data);
+}
+
 /**
  *  txgbe_read_i2c_byte_int - Reads 8 bit word over I2C
  *  @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
index 3efb4abef03a..a8a4adfaf9fb 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h
@@ -7,6 +7,7 @@
 #include "txgbe.h"
 
 #define TXGBE_I2C_EEPROM_DEV_ADDR       0xA0
+#define TXGBE_I2C_EEPROM_DEV_ADDR2      0xA2
 
 /* EEPROM byte offsets */
 #define TXGBE_SFF_IDENTIFIER            0x0
@@ -18,6 +19,8 @@
 #define TXGBE_SFF_10GBE_COMP_CODES      0x3
 #define TXGBE_SFF_CABLE_TECHNOLOGY      0x8
 #define TXGBE_SFF_CABLE_SPEC_COMP       0x3C
+#define TXGBE_SFF_SFF_8472_SWAP         0x5C
+#define TXGBE_SFF_SFF_8472_COMP         0x5E
 
 /* Bitmasks */
 #define TXGBE_SFF_DA_PASSIVE_CABLE      0x4
@@ -28,6 +31,8 @@
 #define TXGBE_SFF_1GBASET_CAPABLE       0x8
 #define TXGBE_SFF_10GBASESR_CAPABLE     0x10
 #define TXGBE_SFF_10GBASELR_CAPABLE     0x20
+#define TXGBE_SFF_ADDRESSING_MODE       0x4
+
 /* Bit-shift macros */
 #define TXGBE_SFF_VENDOR_OUI_BYTE0_SHIFT        24
 #define TXGBE_SFF_VENDOR_OUI_BYTE1_SHIFT        16
@@ -39,6 +44,9 @@
 #define TXGBE_SFF_VENDOR_OUI_AVAGO      0x00176A00
 #define TXGBE_SFF_VENDOR_OUI_INTEL      0x001B2100
 
+/* SFP+ SFF-8472 Compliance */
+#define TXGBE_SFF_SFF_8472_UNSUP        0x00
+
 s32 txgbe_check_reset_blocked(struct txgbe_hw *hw);
 
 s32 txgbe_identify_module(struct txgbe_hw *hw);
@@ -51,5 +59,7 @@ s32 txgbe_read_i2c_byte(struct txgbe_hw *hw, u8 byte_offset,
 
 s32 txgbe_read_i2c_eeprom(struct txgbe_hw *hw, u8 byte_offset,
 			  u8 *eeprom_data);
+s32 txgbe_read_i2c_sff8472(struct txgbe_hw *hw, u8 byte_offset,
+			   u8 *sff8472_data);
 
 #endif /* _TXGBE_PHY_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 9416f80d07f0..97abd60eabb1 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -1906,6 +1906,10 @@ enum txgbe_l2_ptypes {
 #define TXGBE_TXD_TUNNEL_UDP            (0x0ULL << TXGBE_TXD_TUNNEL_TYPE_SHIFT)
 #define TXGBE_TXD_TUNNEL_GRE            (0x1ULL << TXGBE_TXD_TUNNEL_TYPE_SHIFT)
 
+/* Number of Transmit and Receive Descriptors must be a multiple of 8 */
+#define TXGBE_REQ_TX_DESCRIPTOR_MULTIPLE        8
+#define TXGBE_REQ_RX_DESCRIPTOR_MULTIPLE        8
+
 /* Transmit Descriptor */
 union txgbe_tx_desc {
 	struct {
@@ -2042,6 +2046,9 @@ union txgbe_atr_hash_dword {
 #define TXGBE_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
 #define TXGBE_HI_MAX_BLOCK_DWORD_LENGTH 64 /* Num of dwords in range */
 #define TXGBE_HI_COMMAND_TIMEOUT        5000 /* Process HI command limit */
+#define TXGBE_HI_FLASH_ERASE_TIMEOUT    5000 /* Process Erase command limit */
+#define TXGBE_HI_FLASH_UPDATE_TIMEOUT   5000 /* Process Update command limit */
+#define TXGBE_HI_FLASH_VERIFY_TIMEOUT   60000 /* Process Apply command limit */
 
 /* CEM Support */
 #define FW_CEM_HDR_LEN                  0x4
@@ -2059,6 +2066,11 @@ union txgbe_atr_hash_dword {
 #define FW_MAX_READ_BUFFER_SIZE         244
 #define FW_RESET_CMD                    0xDF
 #define FW_RESET_LEN                    0x2
+#define FW_FLASH_UPGRADE_START_CMD      0xE3
+#define FW_FLASH_UPGRADE_START_LEN      0x1
+#define FW_FLASH_UPGRADE_WRITE_CMD      0xE4
+#define FW_FLASH_UPGRADE_VERIFY_CMD     0xE5
+#define FW_FLASH_UPGRADE_VERIFY_LEN     0x4
 #define FW_DW_OPEN_NOTIFY               0xE9
 #define FW_DW_CLOSE_NOTIFY              0xEA
 
@@ -2131,6 +2143,40 @@ struct txgbe_hic_reset {
 	u16 reset_type;
 };
 
+enum txgbe_module_id {
+	TXGBE_MODULE_EEPROM = 0,
+	TXGBE_MODULE_FIRMWARE,
+	TXGBE_MODULE_HARDWARE,
+	TXGBE_MODULE_PCIE
+};
+
+struct txgbe_hic_upg_start {
+	struct txgbe_hic_hdr hdr;
+	u8 module_id;
+	u8  pad2;
+	u16 pad3;
+};
+
+struct txgbe_hic_upg_write {
+	struct txgbe_hic_hdr hdr;
+	u8 data_len;
+	u8 eof_flag;
+	u16 check_sum;
+	u32 data[62];
+};
+
+enum txgbe_upg_flag {
+	TXGBE_RESET_NONE = 0,
+	TXGBE_RESET_FIRMWARE,
+	TXGBE_RELOAD_EEPROM,
+	TXGBE_RESET_LAN
+};
+
+struct txgbe_hic_upg_verify {
+	struct txgbe_hic_hdr hdr;
+	u32 action_flag;
+};
+
 /* Number of 100 microseconds we wait for PCI Express master disable */
 #define TXGBE_PCI_MASTER_DISABLE_TIMEOUT        800
 
@@ -2434,7 +2480,11 @@ struct txgbe_eeprom_operations {
 	s32 (*read)(struct txgbe_hw *hw, u16 offset, u16 *data);
 	s32 (*read_buffer)(struct txgbe_hw *hw,
 			   u16 offset, u16 words, u16 *data);
+	s32 (*write)(struct txgbe_hw *hw, u16 offset, u16 data);
+	s32 (*write_buffer)(struct txgbe_hw *hw,
+			    u16 offset, u16 words, u16 *data);
 	s32 (*validate_checksum)(struct txgbe_hw *hw, u16 *checksum_val);
+	s32 (*update_checksum)(struct txgbe_hw *hw);
 	s32 (*calc_checksum)(struct txgbe_hw *hw);
 };
 
@@ -2513,6 +2563,8 @@ struct txgbe_phy_operations {
 	s32 (*init)(struct txgbe_hw *hw);
 	s32 (*read_i2c_byte)(struct txgbe_hw *hw, u8 byte_offset,
 			     u8 dev_addr, u8 *data);
+	s32 (*read_i2c_sff8472)(struct txgbe_hw *hw, u8 byte_offset,
+				u8 *sff8472_data);
 	s32 (*read_i2c_eeprom)(struct txgbe_hw *hw, u8 byte_offset,
 			       u8 *eeprom_data);
 	s32 (*check_overtemp)(struct txgbe_hw *hw);
@@ -2599,6 +2651,7 @@ struct txgbe_hw {
 	bool adapter_stopped;
 	enum txgbe_reset_type reset_type;
 	bool force_full_reset;
+	bool wol_enabled;
 	enum txgbe_link_status link_status;
 	u16 subsystem_id;
 	u16 tpid[8];
-- 
2.27.0



