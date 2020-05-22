Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7FE1DE2AC
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgEVJMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:12:13 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:46766 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgEVJMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:12:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1590138732; x=1621674732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=EYcNBlhp2WKm3kVjNd2OFQWayCtJDa26xFC1fokzr24=;
  b=Jcn/J3eCQKHtps5fBbsGYVLzYwH4eIq9/AVfSRb5U4lJHlW9hX7H2NFH
   1E2kQKn8Xxq9KU/vp3j3Kn6hJpuSGj64F9FdI03ILDvqGtqu3g0CIjD22
   mAHi/DuB5SeiOgL1a+D1Q1+MExqEVx4ChbWAs1YnZdaJzqtw4BJ3Iw257
   g=;
IronPort-SDR: XoemVlMYqRJRXo9qMQlRZQEP04CLtc5HG1L1xTWlKBdgPgAPJLGP8LKMlqEhciJtIcV8CC7e0E
 afVmWQejJXHw==
X-IronPort-AV: E=Sophos;i="5.73,421,1583193600"; 
   d="scan'208";a="33055129"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 May 2020 09:11:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 81EF5A210C;
        Fri, 22 May 2020 09:11:58 +0000 (UTC)
Received: from EX13D10UWB002.ant.amazon.com (10.43.161.130) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:40 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB002.ant.amazon.com (10.43.161.130) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 22 May 2020 09:11:40 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.161.249) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 May 2020 09:11:36 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 06/14] net: ena: cosmetic: rename ena_update_tx/rx_rings_intr_moderation()
Date:   Fri, 22 May 2020 12:08:57 +0300
Message-ID: <1590138545-501-7-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590138545-501-1-git-send-email-akiyano@amazon.com>
References: <1590138545-501-1-git-send-email-akiyano@amazon.com>
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

