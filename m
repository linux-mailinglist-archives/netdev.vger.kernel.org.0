Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE6361B1A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 10:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbhDPIGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 04:06:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60531 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbhDPIGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 04:06:36 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13G866Sk8023557, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13G866Sk8023557
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Apr 2021 16:06:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 16 Apr 2021 16:06:05 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 16 Apr
 2021 16:06:04 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 3/6] r8152: add help function to change mtu
Date:   Fri, 16 Apr 2021 16:04:34 +0800
Message-ID: <1394712342-15778-353-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-350-Taiwan-albertk@realtek.com>
References: <1394712342-15778-350-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMTYgpFekyCAwNjowMDowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/16/2021 07:42:45
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163158 [Apr 16 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/16/2021 07:45:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMTYgpFekyCAwNjozODowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/16/2021 07:46:47
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163158 [Apr 16 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/16/2021 07:50:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The different chips may have different requests when changing mtu.
Therefore, add a new help function of rtl_ops to change mtu. Besides,
reset the tx/rx after changing mtu.

Additionally, add mtu_to_size() and size_to_mtu() macros to simplify
the code.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 53 ++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 28c9b4dc1a60..3f465242a4f0 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -657,15 +657,13 @@ enum rtl_register_content {
 
 #define INTR_LINK		0x0004
 
-#define RTL8153_MAX_PACKET	9216 /* 9K */
-#define RTL8153_MAX_MTU		(RTL8153_MAX_PACKET - VLAN_ETH_HLEN - \
-				 ETH_FCS_LEN)
 #define RTL8152_RMS		(VLAN_ETH_FRAME_LEN + ETH_FCS_LEN)
 #define RTL8153_RMS		RTL8153_MAX_PACKET
 #define RTL8152_TX_TIMEOUT	(5 * HZ)
 #define RTL8152_NAPI_WEIGHT	64
-#define rx_reserved_size(x)	((x) + VLAN_ETH_HLEN + ETH_FCS_LEN + \
-				 sizeof(struct rx_desc) + RX_ALIGN)
+#define mtu_to_size(m)		((m) + VLAN_ETH_HLEN + ETH_FCS_LEN)
+#define size_to_mtu(s)		((s) - VLAN_ETH_HLEN - ETH_FCS_LEN)
+#define rx_reserved_size(x)	(mtu_to_size(x) + sizeof(struct rx_desc) + RX_ALIGN)
 
 /* rtl8152 flags */
 enum rtl8152_flags {
@@ -795,6 +793,7 @@ struct r8152 {
 		bool (*in_nway)(struct r8152 *tp);
 		void (*hw_phy_cfg)(struct r8152 *tp);
 		void (*autosuspend_en)(struct r8152 *tp, bool enable);
+		void (*change_mtu)(struct r8152 *tp);
 	} rtl_ops;
 
 	struct ups_info {
@@ -1021,8 +1020,7 @@ enum tx_csum_stat {
 static const int multicast_filter_limit = 32;
 static unsigned int agg_buf_sz = 16384;
 
-#define RTL_LIMITED_TSO_SIZE	(agg_buf_sz - sizeof(struct tx_desc) - \
-				 VLAN_ETH_HLEN - ETH_FCS_LEN)
+#define RTL_LIMITED_TSO_SIZE	(size_to_mtu(agg_buf_sz) - sizeof(struct tx_desc))
 
 static
 int get_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
@@ -2632,10 +2630,7 @@ static void rtl8152_nic_reset(struct r8152 *tp)
 
 static void set_tx_qlen(struct r8152 *tp)
 {
-	struct net_device *netdev = tp->netdev;
-
-	tp->tx_qlen = agg_buf_sz / (netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN +
-				    sizeof(struct tx_desc));
+	tp->tx_qlen = agg_buf_sz / (mtu_to_size(tp->netdev->mtu) + sizeof(struct tx_desc));
 }
 
 static inline u8 rtl8152_get_speed(struct r8152 *tp)
@@ -4724,6 +4719,12 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 	set_bit(PHY_RESET, &tp->flags);
 }
 
+static void rtl8153_change_mtu(struct r8152 *tp)
+{
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_JUMBO);
+}
+
 static void r8153_first_init(struct r8152 *tp)
 {
 	u32 ocp_data;
@@ -4756,9 +4757,7 @@ static void r8153_first_init(struct r8152 *tp)
 
 	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
-	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, ocp_data);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_JUMBO);
+	rtl8153_change_mtu(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0);
 	ocp_data |= TCR0_AUTO_FIFO;
@@ -4793,8 +4792,7 @@ static void r8153_enter_oob(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, ocp_data);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
 
 	switch (tp->version) {
 	case RTL_VER_03:
@@ -6494,12 +6492,21 @@ static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
 	dev->mtu = new_mtu;
 
 	if (netif_running(dev)) {
-		u32 rms = new_mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
-
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, rms);
+		if (tp->rtl_ops.change_mtu)
+			tp->rtl_ops.change_mtu(tp);
 
-		if (netif_carrier_ok(dev))
-			r8153_set_rx_early_size(tp);
+		if (netif_carrier_ok(dev)) {
+			netif_stop_queue(dev);
+			napi_disable(&tp->napi);
+			tasklet_disable(&tp->tx_tl);
+			tp->rtl_ops.disable(tp);
+			tp->rtl_ops.enable(tp);
+			rtl_start_rx(tp);
+			tasklet_enable(&tp->tx_tl);
+			napi_enable(&tp->napi);
+			rtl8152_set_rx_mode(dev);
+			netif_wake_queue(dev);
+		}
 	}
 
 	mutex_unlock(&tp->control);
@@ -6588,6 +6595,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
+		ops->change_mtu		= rtl8153_change_mtu;
 		if (tp->udev->speed < USB_SPEED_SUPER)
 			tp->rx_buf_sz	= 16 * 1024;
 		else
@@ -6609,6 +6617,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153b_runtime_enable;
+		ops->change_mtu		= rtl8153_change_mtu;
 		tp->rx_buf_sz		= 32 * 1024;
 		tp->eee_en		= true;
 		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
@@ -6829,7 +6838,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->max_mtu = ETH_DATA_LEN;
 		break;
 	default:
-		netdev->max_mtu = RTL8153_MAX_MTU;
+		netdev->max_mtu = size_to_mtu(9 * 1024);
 		break;
 	}
 
-- 
2.26.3

