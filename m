Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2011B39AA
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgDVIJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:09:50 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:19304 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgDVIJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587542987; x=1619078987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7w4lbsOoRJxc4Nt6EEAwHzDDzzUzmz8HrWkZfO0QTW4=;
  b=j25QGoTBvUi3tLg8kdMMnuB9nG5spF5lWlxBPuH+2rujROClKZBQ2lTz
   WOx4zMqDlQ72ewPCf8QsgmNOQuZdgXZ5BU/uUPCvz47H0SR4azaBqrncZ
   7gpBKDT7vY2Vp694kym0vUTf+sb1LTN4TE+lez8bLmNqMTIGj4DdSSfsj
   8=;
IronPort-SDR: 9dOvbtNL/uDV125Z3RPbxBejqLP5Pc79Wje4Bwo8yS6pNvTxLuM+lFN+u6uGonGKebusDv30PS
 XlUQPQXUPjhw==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="26715947"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 22 Apr 2020 08:09:34 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id 25446A1D9A;
        Wed, 22 Apr 2020 08:09:33 +0000 (UTC)
Received: from EX13D02UWB001.ant.amazon.com (10.43.161.240) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB001.ant.amazon.com (10.43.161.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 69B6081D05; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 07/13] net: ena: add unmask interrupts statistics to ethtool
Date:   Wed, 22 Apr 2020 08:09:17 +0000
Message-ID: <20200422080923.6697-8-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422080923.6697-1-sameehj@amazon.com>
References: <20200422080923.6697-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Add unmask interrupts statistics to ethtool.

Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 1 +
 drivers/net/ethernet/amazon/ena/ena_netdev.c  | 3 +++
 drivers/net/ethernet/amazon/ena/ena_netdev.h  | 1 +
 3 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index c7df25f92dbd..74725d606964 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -83,6 +83,7 @@ static const struct ena_stats ena_stats_tx_strings[] = {
 	ENA_STAT_TX_ENTRY(bad_req_id),
 	ENA_STAT_TX_ENTRY(llq_buffer_copy),
 	ENA_STAT_TX_ENTRY(missed_tx),
+	ENA_STAT_TX_ENTRY(unmask_interrupt),
 };
 
 static const struct ena_stats ena_stats_rx_strings[] = {
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 6baafc3aebea..3cea4c9090c2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1762,6 +1762,9 @@ static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 				tx_ring->smoothed_interval,
 				true);
 
+	u64_stats_update_begin(&tx_ring->syncp);
+	tx_ring->tx_stats.unmask_interrupt++;
+	u64_stats_update_end(&tx_ring->syncp);
 	/* It is a shared MSI-X.
 	 * Tx and Rx CQ have pointer to it.
 	 * So we use one of them to reach the intr reg
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 97dfd0c67e84..ebeb911c0efb 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -248,6 +248,7 @@ struct ena_stats_tx {
 	u64 bad_req_id;
 	u64 llq_buffer_copy;
 	u64 missed_tx;
+	u64 unmask_interrupt;
 };
 
 struct ena_stats_rx {
-- 
2.24.1.AMZN

