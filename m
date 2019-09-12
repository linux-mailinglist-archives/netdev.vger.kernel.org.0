Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE0B1B1625
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 00:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbfILWKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 18:10:48 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:60146 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfILWKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 18:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568326247; x=1599862247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=gA2fJpS4far4RiIviJ0O+AsVF2SEnjeG1Stk2E87Oc0=;
  b=qcQw+vDClPGTNPdoGWmbpKzr+lhUMuEmNSWK5pdGHxyB++7rQHwGltWY
   zJLNoVvlqXXrYij0gGHPyqELzw7H85nLhzgPmyBVvcXjrmoWbQ/FpIVtj
   I2r0rTlW+uQv7iKz8qd+W3vS6SwcsxSoOVMJJgwol28MZTOZIjVnez4n+
   c=;
X-IronPort-AV: E=Sophos;i="5.64,498,1559520000"; 
   d="scan'208";a="702221922"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 12 Sep 2019 22:10:36 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id 732AC282050;
        Thu, 12 Sep 2019 22:10:31 +0000 (UTC)
Received: from EX13d09UWA001.ant.amazon.com (10.43.160.247) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:05 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13d09UWA001.ant.amazon.com (10.43.160.247) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 12 Sep 2019 22:10:04 +0000
Received: from HFA15-G63729NC.amazon.com (10.95.77.90) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 12 Sep 2019 22:09:58 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 07/11] net: ena: remove ena_restore_ethtool_params() and relevant fields
Date:   Fri, 13 Sep 2019 01:08:44 +0300
Message-ID: <1568326128-4057-8-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
References: <1568326128-4057-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Deleted unused 4 fields from struct ena_adapter and their only user
ena_restore_ethtool_params().

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 ----------
 drivers/net/ethernet/amazon/ena/ena_netdev.h |  3 ---
 2 files changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 1d8855ab8624..8b9f8b90e525 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1563,14 +1563,6 @@ static void ena_napi_enable_all(struct ena_adapter *adapter)
 		napi_enable(&adapter->ena_napi[i].napi);
 }
 
-static void ena_restore_ethtool_params(struct ena_adapter *adapter)
-{
-	adapter->tx_usecs = 0;
-	adapter->rx_usecs = 0;
-	adapter->tx_frames = 1;
-	adapter->rx_frames = 1;
-}
-
 /* Configure the Rx forwarding */
 static int ena_rss_configure(struct ena_adapter *adapter)
 {
@@ -1620,8 +1612,6 @@ static int ena_up_complete(struct ena_adapter *adapter)
 	/* enable transmits */
 	netif_tx_start_all_queues(adapter->netdev);
 
-	ena_restore_ethtool_params(adapter);
-
 	ena_napi_enable_all(adapter);
 
 	return 0;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index e9450991ab74..72ee51a82ec7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -330,9 +330,6 @@ struct ena_adapter {
 
 	u32 missing_tx_completion_threshold;
 
-	u32 tx_usecs, rx_usecs; /* interrupt moderation */
-	u32 tx_frames, rx_frames; /* interrupt moderation */
-
 	u32 requested_tx_ring_size;
 	u32 requested_rx_ring_size;
 
-- 
2.17.2

