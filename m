Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11841BB77B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgD1H16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:58 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:16412 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgD1H1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058874; x=1619594874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xxcn6bDxLptwcRV0JOrmuuxRt/l/J6qUEO+vgADaBzg=;
  b=wEmmYBcozVWDSeDbAXAaKiDL7kuPczylLacaXpSwF9dgbr0ek8L9fmmv
   V1msRAVa/QytuXZxJe+BStUQEncjxP2FrsgSF0iwlXq/ADzD6QsbgwHcj
   KHrAUoXarLUF4XoCeAOMGNhYIYA7exbsJjEWjpIbJXHiS21q4D8Vdt1Lu
   I=;
IronPort-SDR: 2CJg4T7fRIKczWeHNUiLKHiSNwJnW1K5iPKGmfd3M44qHQZKCR3Y6eP022O9jCLILjGng+KXfq
 Qp+RYRp+xaSA==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="39890397"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 28 Apr 2020 07:27:53 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 69098A1812;
        Tue, 28 Apr 2020 07:27:52 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 7331081F81; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 13/13] net: ena: cosmetic: extract code to ena_indirection_table_set()
Date:   Tue, 28 Apr 2020 07:27:26 +0000
Message-ID: <20200428072726.22247-14-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200428072726.22247-1-sameehj@amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Extract code to ena_indirection_table_set() to make
the code cleaner.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 48 ++++++++++++-------
 1 file changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 74725d606964..830d3711d6ee 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -636,6 +636,32 @@ static u32 ena_get_rxfh_key_size(struct net_device *netdev)
 	return ENA_HASH_KEY_SIZE;
 }
 
+static int ena_indirection_table_set(struct ena_adapter *adapter,
+				     const u32 *indir)
+{
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	int i, rc;
+
+	for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++) {
+		rc = ena_com_indirect_table_fill_entry(ena_dev,
+						       i,
+						       ENA_IO_RXQ_IDX(indir[i]));
+		if (unlikely(rc)) {
+			netif_err(adapter, drv, adapter->netdev,
+				  "Cannot fill indirect table (index is too large)\n");
+			return rc;
+		}
+	}
+
+	rc = ena_com_indirect_table_set(ena_dev);
+	if (rc) {
+		netif_err(adapter, drv, adapter->netdev,
+			  "Cannot set indirect table\n");
+		return rc == -EPERM ? -EOPNOTSUPP : rc;
+	}
+	return rc;
+}
+
 static int ena_indirection_table_get(struct ena_adapter *adapter, u32 *indir)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
@@ -710,26 +736,12 @@ static int ena_set_rxfh(struct net_device *netdev, const u32 *indir,
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
 	enum ena_admin_hash_functions func = 0;
-	int rc, i;
+	int rc;
 
 	if (indir) {
-		for (i = 0; i < ENA_RX_RSS_TABLE_SIZE; i++) {
-			rc = ena_com_indirect_table_fill_entry(ena_dev,
-							       i,
-							       ENA_IO_RXQ_IDX(indir[i]));
-			if (unlikely(rc)) {
-				netif_err(adapter, drv, netdev,
-					  "Cannot fill indirect table (index is too large)\n");
-				return rc;
-			}
-		}
-
-		rc = ena_com_indirect_table_set(ena_dev);
-		if (rc) {
-			netif_err(adapter, drv, netdev,
-				  "Cannot set indirect table\n");
-			return rc == -EPERM ? -EOPNOTSUPP : rc;
-		}
+		rc = ena_indirection_table_set(adapter, indir);
+		if (rc)
+			return rc;
 	}
 
 	switch (hfunc) {
-- 
2.24.1.AMZN

