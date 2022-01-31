Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FA94A3FAE
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 10:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358025AbiAaJ7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 04:59:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:62654 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358013AbiAaJ7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 04:59:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643623165; x=1675159165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88cEJGvmX84FYOdWeWHN1hHz+HrAuwkzL1s0LqJMmsU=;
  b=AkjaUrwe1n33hZK58lNmVk8KuJUlQNAJMQ5sYU0oJp/udE5PYRGyRLfq
   I3rbWji/io6gFnQA77Xn/zox0RnbHm16qdesZizQhW7EDew1JyxWnKJUQ
   Mh0aqIKkAfQDNQMzx/Dkgt/za1tU+MUHLlgMJnj6XVleN3JJQa0GGq0is
   WMgx+F2ST7ymSrP1DWgL+yoquhDfTxAsyC6Scu90bJdvvbbNdWw8Z+LFp
   ai66UMDNsDkm3XNx+gfkeaTSvCunmQV1hAnOgYIGcGsAbWeHCAGJaWD0N
   fvxxPBdB8QJvTHievBopEk8Qkv+dHqniPo08d5o/7NAapwI/YA6gPhKyM
   g==;
IronPort-SDR: mZuYUjfH7o3vBsHbtF1ZiVPxm+hW4+Y6CaOS9BsnnKL0j+F4tFZiAPSgyr+DAIlCFVCyF4Rgdo
 oRRN/ctjvvGXhNAzl+9EpQ1Rqn/f6GpPqhll66E+PjdhQDVy/WLmLR7HAhqayVrqjwg0VfhUh+
 9ODfFdP1aTrvlvKG+VYxtr6z3a6h3FLtP0D5HorK8TRul7fb0KB2xwHUzhsC29mQtIFSmoay0+
 yl+nC4Jz0CzVZOxxMlX3nu2w98YCCgFt+NkIPKX3kCulBdYY3wc1k2wiYHeH4nQUApN8Ja1Ker
 RQwiDs4i3ieeNTIEsPL+HGZf
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="151958784"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2022 02:59:25 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 31 Jan 2022 02:59:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 31 Jan 2022 02:59:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 7/7] net: lan966x: Implement get_ts_info
Date:   Mon, 31 Jan 2022 11:01:22 +0100
Message-ID: <20220131100122.423164-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131100122.423164-1-horatiu.vultur@microchip.com>
References: <20220131100122.423164-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the function get_ts_info in ethtool_ops which is needed to get
the HW capabilities for timestamping.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_ethtool.c       | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index 614f12c2fe6a..e58a27fd8b50 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -545,6 +545,39 @@ static int lan966x_set_pauseparam(struct net_device *dev,
 	return phylink_ethtool_set_pauseparam(port->phylink, pause);
 }
 
+static int lan966x_get_ts_info(struct net_device *dev,
+			       struct ethtool_ts_info *info)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_phc *phc;
+
+	if (!lan966x->ptp)
+		return ethtool_op_get_ts_info(dev, info);
+
+	phc = &lan966x->phc[LAN966X_PHC_PORT];
+
+	info->phc_index = phc->clock ? ptp_clock_index(phc->clock) : -1;
+	if (info->phc_index == -1) {
+		info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+					 SOF_TIMESTAMPING_RX_SOFTWARE |
+					 SOF_TIMESTAMPING_SOFTWARE;
+		return 0;
+	}
+	info->so_timestamping |= SOF_TIMESTAMPING_TX_SOFTWARE |
+				 SOF_TIMESTAMPING_RX_SOFTWARE |
+				 SOF_TIMESTAMPING_SOFTWARE |
+				 SOF_TIMESTAMPING_TX_HARDWARE |
+				 SOF_TIMESTAMPING_RX_HARDWARE |
+				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON) |
+			 BIT(HWTSTAMP_TX_ONESTEP_SYNC);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
 const struct ethtool_ops lan966x_ethtool_ops = {
 	.get_link_ksettings     = lan966x_get_link_ksettings,
 	.set_link_ksettings     = lan966x_set_link_ksettings,
@@ -556,6 +589,7 @@ const struct ethtool_ops lan966x_ethtool_ops = {
 	.get_eth_mac_stats      = lan966x_get_eth_mac_stats,
 	.get_rmon_stats		= lan966x_get_eth_rmon_stats,
 	.get_link		= ethtool_op_get_link,
+	.get_ts_info		= lan966x_get_ts_info,
 };
 
 static void lan966x_check_stats_work(struct work_struct *work)
-- 
2.33.0

