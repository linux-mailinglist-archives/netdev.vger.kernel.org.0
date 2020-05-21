Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB50E1DD6B6
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbgEUTJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:24 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:65535 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730350AbgEUTJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590088164; x=1621624164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=EYcNBlhp2WKm3kVjNd2OFQWayCtJDa26xFC1fokzr24=;
  b=g/xdYHCZxl1UoKS8fYOpWAI5RFNU1smVrTgwfEPyAQTRRcG9KPhJvi7l
   cYtHe/Zw+6BtRWk3QtjmHlF1wcBVyDhC3Gie0XjzbvZWpWnm/kZwQZPon
   juntRb2GAKz7jIgP2Jxj6l8LePgebpbsIg/9UVjVNUiPOXFlWQdU7UUfy
   o=;
IronPort-SDR: pWXLTNkjR7KD4/CZB+yz30saXPMY4X83a+dzN+iMb5jEAfrx/2LPD7AjE8GwQ+G1zJ9rVSG6T4
 DtMO8b2OLlqQ==
X-IronPort-AV: E=Sophos;i="5.73,418,1583193600"; 
   d="scan'208";a="46582257"
Received: from sea32-co-svc-lb4-vlan2.sea.corp.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.47.23.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 21 May 2020 19:09:24 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id 80C5614187A;
        Thu, 21 May 2020 19:09:22 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:01 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 21 May 2020 19:09:01 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.27) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 21 May 2020 19:08:58 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 07/15] net: ena: cosmetic: rename ena_update_tx/rx_rings_intr_moderation()
Date:   Thu, 21 May 2020 22:08:26 +0300
Message-ID: <1590088114-381-8-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590088114-381-1-git-send-email-akiyano@amazon.com>
References: <1590088114-381-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Rename ena_update_tx/rx_rings_intr_moderation() to
ena_update_tx/rx_rings_nonadaptive_intr_moderation()
to distinguish between adaptive and non adaptive interrupt moderaion.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 830d3711d6ee..ca13efa13b63 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -326,7 +326,7 @@ static int ena_get_coalesce(struct net_device *net_dev,
 	return 0;
 }
 
-static void ena_update_tx_rings_intr_moderation(struct ena_adapter *adapter)
+static void ena_update_tx_rings_nonadaptive_intr_moderation(struct ena_adapter *adapter)
 {
 	unsigned int val;
 	int i;
@@ -337,7 +337,7 @@ static void ena_update_tx_rings_intr_moderation(struct ena_adapter *adapter)
 		adapter->tx_ring[i].smoothed_interval = val;
 }
 
-static void ena_update_rx_rings_intr_moderation(struct ena_adapter *adapter)
+static void ena_update_rx_rings_nonadaptive_intr_moderation(struct ena_adapter *adapter)
 {
 	unsigned int val;
 	int i;
@@ -365,14 +365,14 @@ static int ena_set_coalesce(struct net_device *net_dev,
 	if (rc)
 		return rc;
 
-	ena_update_tx_rings_intr_moderation(adapter);
+	ena_update_tx_rings_nonadaptive_intr_moderation(adapter);
 
 	rc = ena_com_update_nonadaptive_moderation_interval_rx(ena_dev,
 							       coalesce->rx_coalesce_usecs);
 	if (rc)
 		return rc;
 
-	ena_update_rx_rings_intr_moderation(adapter);
+	ena_update_rx_rings_nonadaptive_intr_moderation(adapter);
 
 	if (coalesce->use_adaptive_rx_coalesce &&
 	    !ena_com_get_adaptive_moderation_enabled(ena_dev))
-- 
2.23.1

