Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710F9B30B2
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 17:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387760AbfIOP15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 11:27:57 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:12973 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731547AbfIOP14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 11:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568561275; x=1600097275;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=XVTX1m4EHwPcCh/AHCs7dGe+yJomY3Cqrq76l/dHGvA=;
  b=QcHdAaLfrC9DVqa8hGGJW6F586opCCL4VfS2QNARdenv6Tt/nUHt5ltg
   qTgVQSPSrKI6n1pLxudsLcpZbLkslRIaPcESovzDYSli4Qz8dCBOzVxC/
   5yoF6NM7ogrJLD0owh9VqTc41rk8vlMSt+IpDNN4rg4TYJ36CsbyEPMPq
   c=;
X-IronPort-AV: E=Sophos;i="5.64,509,1559520000"; 
   d="scan'208";a="784987487"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 15 Sep 2019 15:27:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id ED08DC5ACF;
        Sun, 15 Sep 2019 15:27:53 +0000 (UTC)
Received: from EX13D02UWC003.ant.amazon.com (10.43.162.199) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 15:27:46 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13D02UWC003.ant.amazon.com (10.43.162.199) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 15 Sep 2019 15:27:46 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 15 Sep 2019 15:27:42 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net-next 4/5] net: ena:remove redundant print of number of queues and placement policy
Date:   Sun, 15 Sep 2019 18:27:21 +0300
Message-ID: <20190915152722.8240-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915152722.8240-1-sameehj@amazon.com>
References: <20190915152722.8240-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The number of queues and the placement policy are printed in the process
of queue creation in ena_up(). No need to print them in ena_probe()

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a98422667..9d3abb184 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3441,7 +3441,6 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct net_device *netdev;
 	static int adapters_found;
 	u32 max_num_io_queues;
-	char *queue_type_str;
 	bool wd_state;
 	int bars, rc;
 
@@ -3607,15 +3606,10 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	timer_setup(&adapter->timer_service, ena_timer_service, 0);
 	mod_timer(&adapter->timer_service, round_jiffies(jiffies + HZ));
 
-	if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_HOST)
-		queue_type_str = "Regular";
-	else
-		queue_type_str = "Low Latency";
-
 	dev_info(&pdev->dev,
-		 "%s found at mem %lx, mac addr %pM Queues %d, Placement policy: %s\n",
+		 "%s found at mem %lx, mac addr %pM\n",
 		 DEVICE_NAME, (long)pci_resource_start(pdev, 0),
-		 netdev->dev_addr, max_num_io_queues, queue_type_str);
+		 netdev->dev_addr);
 
 	set_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
 
-- 
2.17.1

