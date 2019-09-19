Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727D5B7B7B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbfISODV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:03:21 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11731 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732143AbfISODU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:03:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1568901799; x=1600437799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=tBsyeok9A7ue/0cVKGGQTADAim8axZ/muS+3/VyPCb8=;
  b=r78l8ndo3sgLj6Yh23BWcfCbp7TDJfukXP6HaQRbx1x0Bl3AN/JsnEic
   uddPZOIG6omrKoNkmbX4seEkbrbrRU7xHYjAcA02bROnkO93NH6pDnK5u
   LUw514hAIhUVsoPUmlxwMWUm57spaLQlCpi36D6V8wod1vPWWeakvWP6j
   8=;
X-IronPort-AV: E=Sophos;i="5.64,523,1559520000"; 
   d="scan'208";a="416106069"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 19 Sep 2019 14:02:58 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 9EBD6241E10;
        Thu, 19 Sep 2019 14:02:58 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:02:43 +0000
Received: from EX13MTAUEE001.ant.amazon.com (10.43.62.200) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 19 Sep 2019 14:02:43 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.62.226) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Thu, 19 Sep 2019 14:02:40 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 4/5] net: ena: remove redundant print of number of queues
Date:   Thu, 19 Sep 2019 17:02:23 +0300
Message-ID: <20190919140224.9137-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190919140224.9137-1-sameehj@amazon.com>
References: <20190919140224.9137-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The number of queues can be derived using ethtool, no need to print
it in ena_probe()

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 062b78483..e964783c4 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3606,9 +3606,9 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		queue_type_str = "Low Latency";
 
 	dev_info(&pdev->dev,
-		 "%s found at mem %lx, mac addr %pM Queues %d, Placement policy: %s\n",
+		 "%s found at mem %lx, mac addr %pM, Placement policy: %s\n",
 		 DEVICE_NAME, (long)pci_resource_start(pdev, 0),
-		 netdev->dev_addr, max_num_io_queues, queue_type_str);
+		 netdev->dev_addr, queue_type_str);
 
 	set_bit(ENA_FLAG_DEVICE_RUNNING, &adapter->flags);
 
-- 
2.17.1

