Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A58522811B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgGUNjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:39:11 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:9766 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbgGUNjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:39:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595338750; x=1626874750;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=wSgddJdybN4D8HMVNQxbWr+lX1oi575vjbIWY3WFS24=;
  b=inwORdQOV/MH/6moEWLGpYklYpZonU5gsKAI1SVbzZPQULL/eHEDBBHg
   hBssbmnrOSuQUH8NY+Qyd9oxoCIynkoDhAl0ngv99hQW+jPpkD0J1UDx2
   BT4PxjDRJ12T1M3rt8CnuxF5Uu6c3MHtKN5/CqYttuWANgDFcjpVMUYBD
   4=;
IronPort-SDR: /Zt4XHt0BMqfhA+CGz49GiRLjh06FGioQOWFjTpHJtNqQRL+cD2WKuDm7iaUVTOKyBHJNQyQQM
 frpxhqeFQi2g==
X-IronPort-AV: E=Sophos;i="5.75,379,1589241600"; 
   d="scan'208";a="43199624"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Jul 2020 13:39:08 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 1429BA17C9;
        Tue, 21 Jul 2020 13:39:06 +0000 (UTC)
Received: from EX13D10UWA003.ant.amazon.com (10.43.160.248) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:44 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D10UWA003.ant.amazon.com (10.43.160.248) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Jul 2020 13:38:44 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.6) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jul 2020 13:38:39 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 3/8] net: ena: cosmetic: satisfy gcc warning
Date:   Tue, 21 Jul 2020 16:38:06 +0300
Message-ID: <1595338691-3130-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
References: <1595338691-3130-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

gcc 4.8 reports a warning when initializing with = {0}.
Dropping the "0" from the braces fixes the issue.
This fix is not ANSI compatible but is allowed by gcc.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index e453542c9e94..d3d2e3934237 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -307,7 +307,7 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 			     struct ena_rx_buffer *rx_info)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
-	struct ena_com_tx_ctx ena_tx_ctx = {0};
+	struct ena_com_tx_ctx ena_tx_ctx = {};
 	struct ena_tx_buffer *tx_info;
 	struct ena_ring *xdp_ring;
 	u16 next_to_use, req_id;
-- 
2.23.3

