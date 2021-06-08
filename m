Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444C739FBAA
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 18:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhFHQGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 12:06:06 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:10832 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbhFHQGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 12:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1623168252; x=1654704252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iOEZS4LTGwWhDDLJO/4/al+2HOSYj/KYxWRqJK70eb8=;
  b=e01yHl98Qa1j67RoxbBoKdJmw+dFAZxj6wcG4Z467EfZcXj3Bv2hT5ly
   hJwK/Cido3ddwb0lcgDXRy69uuBm/NnW3xp7XaJ3jK/tUmq1lj3fp5KtI
   HnlpPVYIyiBygpC2DS8FUtEf1QFmtelKiZuiG4el2PYWnjKQTGWjVey0g
   c=;
X-IronPort-AV: E=Sophos;i="5.83,258,1616457600"; 
   d="scan'208";a="114485245"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-53356bf6.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 08 Jun 2021 16:04:04 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-53356bf6.us-west-2.amazon.com (Postfix) with ESMTPS id 623C9A1CDF;
        Tue,  8 Jun 2021 16:04:03 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com (10.43.162.93) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Tue, 8 Jun 2021 16:03:55 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: [Patch v1 net-next 10/10] net: ena: re-organize code to improve readability
Date:   Tue, 8 Jun 2021 19:01:18 +0300
Message-ID: <20210608160118.3767932-11-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608160118.3767932-1-shayagr@amazon.com>
References: <20210608160118.3767932-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.93]
X-ClientProxiedBy: EX13D43UWC003.ant.amazon.com (10.43.162.16) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restructure some ethtool to a switch-case blocks to make it more uniform
with other similar functions.
Also restructure variable declaration to create reversed x-mas tree.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c     |  3 ++-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 18 +++++++++++-------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 764852ead1d6..ab413fc1f68e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1979,7 +1979,8 @@ int ena_com_get_dev_attr_feat(struct ena_com_dev *ena_dev,
 		if (rc)
 			return rc;
 
-		if (get_resp.u.max_queue_ext.version != ENA_FEATURE_MAX_QUEUE_EXT_VER)
+		if (get_resp.u.max_queue_ext.version !=
+		    ENA_FEATURE_MAX_QUEUE_EXT_VER)
 			return -EINVAL;
 
 		memcpy(&get_feat_ctx->max_queue_ext, &get_resp.u.max_queue_ext,
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 2fe7ccee55b2..27dae632efcb 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -233,10 +233,13 @@ int ena_get_sset_count(struct net_device *netdev, int sset)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	if (sset != ETH_SS_STATS)
-		return -EOPNOTSUPP;
+	switch (sset) {
+	case ETH_SS_STATS:
+		return ena_get_sw_stats_count(adapter) +
+		       ena_get_hw_stats_count(adapter);
+	}
 
-	return ena_get_sw_stats_count(adapter) + ena_get_hw_stats_count(adapter);
+	return -EOPNOTSUPP;
 }
 
 static void ena_queue_strings(struct ena_adapter *adapter, u8 **data)
@@ -314,10 +317,11 @@ static void ena_get_ethtool_strings(struct net_device *netdev,
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 
-	if (sset != ETH_SS_STATS)
-		return;
-
-	ena_get_strings(adapter, data, adapter->eni_stats_supported);
+	switch (sset) {
+	case ETH_SS_STATS:
+		ena_get_strings(adapter, data, adapter->eni_stats_supported);
+		break;
+	}
 }
 
 static int ena_get_link_ksettings(struct net_device *netdev,
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 261680aba33c..cd6ea59c543c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1426,9 +1426,9 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 				  u32 descs,
 				  u16 *next_to_clean)
 {
-	struct sk_buff *skb;
 	struct ena_rx_buffer *rx_info;
 	u16 len, req_id, buf = 0;
+	struct sk_buff *skb;
 	void *page_addr;
 	u32 page_offset;
 	void *data_addr;
-- 
2.25.1

