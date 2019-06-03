Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 523283327C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbfFCOoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:44:05 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:40857 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbfFCOoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 10:44:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1559573044; x=1591109044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=oS1tlqD8U5b2w3uY2otlmxvijWzibgcOJ+C42vA2Yyg=;
  b=vcO/Dyp24tG1JaZt0f/2QZUWy+f+N7LxTS95I3zoqVhNlBsthFcRhOgR
   3qKovn6NdiSYf3LyVePbos4RmuMIQILJNXVd33s+m+b0EfmC4XwB+sVPY
   tEy+o2dEP5t6bK4u8pyVRmmkPtT+AyBXSBPlMEo+HYVapitu/WserZm2v
   M=;
X-IronPort-AV: E=Sophos;i="5.60,547,1549929600"; 
   d="scan'208";a="735848823"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-57e1d233.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Jun 2019 14:44:03 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-57e1d233.us-east-1.amazon.com (Postfix) with ESMTPS id B11A6141AC3;
        Mon,  3 Jun 2019 14:44:03 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:48 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 3 Jun 2019 14:43:48 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 14:43:45 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net 04/11] net: ena: arrange ena_probe() function variables in reverse christmas tree
Date:   Mon, 3 Jun 2019 17:43:22 +0300
Message-ID: <20190603144329.16366-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190603144329.16366-1-sameehj@amazon.com>
References: <20190603144329.16366-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

Reverse christmas tree arrangement is when strings are written from longer
to shorter with each line. Most of our functions are abiding this
arrangement but this function does not.

In this commit we arrange the variables of ena_probe() in reverse christmas
tree.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index b80b5eddc..399bd5453 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3281,17 +3281,17 @@ static int ena_calc_queue_size(struct pci_dev *pdev,
 static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ena_com_dev_get_features_ctx get_feat_ctx;
-	static int version_printed;
-	struct net_device *netdev;
-	struct ena_adapter *adapter;
 	struct ena_llq_configurations llq_config;
 	struct ena_com_dev *ena_dev = NULL;
-	char *queue_type_str;
-	static int adapters_found;
+	struct ena_adapter *adapter;
+	static int version_printed;
 	int io_queue_num, bars, rc;
-	int queue_size;
+	struct net_device *netdev;
+	static int adapters_found;
+	char *queue_type_str;
 	u16 tx_sgl_size = 0;
 	u16 rx_sgl_size = 0;
+	int queue_size;
 	bool wd_state;
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
-- 
2.17.1

