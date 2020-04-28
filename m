Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5939D1BB76F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgD1H1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:37 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:16353 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgD1H1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058855; x=1619594855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7w4lbsOoRJxc4Nt6EEAwHzDDzzUzmz8HrWkZfO0QTW4=;
  b=kPLMjZUzeiaQjmb9YQUwtrY/hNvCLjuTs5c56U7Y1slbas7jT5GP6Xk3
   bb7f8rEQDP1h4fKG30ZNonWr+Pc/jW4dDbpgeKeaY7YF6Y+m0J6qedS/u
   9yfZmZTHkPFFGk+lD4ie4M0SBEEP12KQZ21dT41bryoPc/J6iIcIjhj7M
   0=;
IronPort-SDR: yGpLSU1w3d2+YmYK3qc6IKblae++blTuhS4Bx1OvWxJTCqBPxEQ/GlNWvbwkhDFl9PXHHjQOHc
 Jn6AP+XFiq/w==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="39890324"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-81e76b79.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 28 Apr 2020 07:27:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-81e76b79.us-west-2.amazon.com (Postfix) with ESMTPS id 2EA4DA238F;
        Tue, 28 Apr 2020 07:27:32 +0000 (UTC)
Received: from EX13D10UWA004.ant.amazon.com (10.43.160.64) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA004.ant.amazon.com (10.43.160.64) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 5EC2381DCE; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 07/13] net: ena: add unmask interrupts statistics to ethtool
Date:   Tue, 28 Apr 2020 07:27:20 +0000
Message-ID: <20200428072726.22247-8-sameehj@amazon.com>
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

