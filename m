Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C21CD1E9
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 14:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfJFMeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 08:34:03 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:11033 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfJFMeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 08:34:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570365241; x=1601901241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Q1MHdvpJypILKa5zvQzlXrF08cTZ3opfzakfucfNPKU=;
  b=Y5Kx1894eIi7eLn7VnMAQ4Cms/JlTcf5OQIJJQfJksQ1KmP8iDdZmvS0
   EAiTFjVZYCtNrQjFU85E4q9LrTSNy3yqKRv2+UX4Ufe5g1L3799xcJKb3
   WrkZoe1rOIXyvWGXYQp+6c6ich/MIKSjVPEF6h/CBRtslg7Cy79TBRoGt
   o=;
X-IronPort-AV: E=Sophos;i="5.67,263,1566864000"; 
   d="scan'208";a="755848660"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-c300ac87.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 06 Oct 2019 12:34:01 +0000
Received: from EX13MTAUEB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-c300ac87.us-west-2.amazon.com (Postfix) with ESMTPS id 39BD2A26FB;
        Sun,  6 Oct 2019 12:34:01 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB001.ant.amazon.com (10.43.60.96) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 6 Oct 2019 12:33:48 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 6 Oct 2019 12:33:48 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.52.96) by
 mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Sun, 6 Oct 2019 12:33:45 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V3 net-next 5/6] net: ena: remove redundant print of number of queues
Date:   Sun, 6 Oct 2019 15:33:27 +0300
Message-ID: <20191006123328.24210-6-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191006123328.24210-1-sameehj@amazon.com>
References: <20191006123328.24210-1-sameehj@amazon.com>
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
index e71568159..6386554b1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3605,9 +3605,9 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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

