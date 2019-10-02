Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7B4C4965
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfJBIWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:22:25 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:30476 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfJBIWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570004544; x=1601540544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=tBsyeok9A7ue/0cVKGGQTADAim8axZ/muS+3/VyPCb8=;
  b=Y/D7+p72UFWcK0CBLHqmiITCm44fcGnk9KXNRvU4WNWVqECwTijsHQ/U
   AT38L9rsO/DT55iafiuivww0/L7a3kcPqmddFccsK0ifMj+h51XDMFdWT
   /mg5GKrwOrFKMBNq1QlJnFAsUuSsTGg6IbprGjeCuMhwvOqzTqXWrFvNy
   I=;
X-IronPort-AV: E=Sophos;i="5.64,573,1559520000"; 
   d="scan'208";a="838639022"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 02 Oct 2019 08:21:38 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id C2299A1E8D;
        Wed,  2 Oct 2019 08:21:22 +0000 (UTC)
Received: from EX13D08UEB003.ant.amazon.com (10.43.60.11) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.129) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:12 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB003.ant.amazon.com (10.43.60.11) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 2 Oct 2019 08:21:12 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.90) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 2 Oct 2019 08:21:09 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V2 net-next 4/5] net: ena: remove redundant print of number of queues
Date:   Wed, 2 Oct 2019 11:20:51 +0300
Message-ID: <20191002082052.14051-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191002082052.14051-1-sameehj@amazon.com>
References: <20191002082052.14051-1-sameehj@amazon.com>
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

