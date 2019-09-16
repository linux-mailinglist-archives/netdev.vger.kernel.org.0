Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2558FB395C
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 13:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbfIPLcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 07:32:31 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:61847 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbfIPLcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 07:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568633549; x=1600169549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=gA2fJpS4far4RiIviJ0O+AsVF2SEnjeG1Stk2E87Oc0=;
  b=FlzMNUcUmafg0U7hOFTK6mjbu+EqLqA80pQ8wInGOGUVoQIFq+sEh/y8
   PkkIMDqeGU2ocGHTWpZvEgvahJT+WolC6qn7DNcgLy4P5M2Nh3FxY6qyc
   /2dOjEqohEXx/5ERymDwaoxyMD06TjGDeLpTHHWLxQSRCXEnGStdYpB3v
   c=;
X-IronPort-AV: E=Sophos;i="5.64,512,1559520000"; 
   d="scan'208";a="750940092"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Sep 2019 11:32:29 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 626D6141ADF;
        Mon, 16 Sep 2019 11:32:29 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:05 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Sep 2019 11:32:04 +0000
Received: from HFA15-G63729NC.hfa16.amazon.com (10.218.52.89) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Sep 2019 11:32:01 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 07/11] net: ena: remove ena_restore_ethtool_params() and relevant fields
Date:   Mon, 16 Sep 2019 14:31:32 +0300
Message-ID: <1568633496-4143-8-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
References: <1568633496-4143-1-git-send-email-akiyano@amazon.com>
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

