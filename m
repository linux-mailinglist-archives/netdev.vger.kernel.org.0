Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17E221A77B
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgGITFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:05:54 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:50484 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGITFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594321554; x=1625857554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WMbHJQqI28eTZB5u5ozLb0fcIDt3P203mpjXkckChGk=;
  b=Zqh6T1AJ03gB6cduTbNuChYm2X1DOKBuF6V1L3QmRgkeax5VFi+g1flF
   /PkbkgIuVX92af3mrGZk+ZH0i6QdCjGzuExN7CEhxBEn9Xyt8qYeTarLr
   cOTr6o4uxHvgN7XM5q7Ljib2MvzNc9rVSqLmpOpAIljFxd4JnRays3C1r
   A=;
IronPort-SDR: dF+tx2qMgjyEJDnkeaPRFsuWj5JWjiwMJVU6KyhBrVCaqAjaTl6ug7wAxzrh4w2nUwPSVD0Jg6
 tlDKOnN22MBQ==
X-IronPort-AV: E=Sophos;i="5.75,332,1589241600"; 
   d="scan'208";a="41136642"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 09 Jul 2020 19:05:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 02000A230D;
        Thu,  9 Jul 2020 19:05:52 +0000 (UTC)
Received: from EX13d09UWC004.ant.amazon.com (10.43.162.114) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:28 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC004.ant.amazon.com (10.43.162.114) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 9 Jul 2020 19:05:27 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.15) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 9 Jul 2020 19:05:21 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net-next 3/8] net: ena: cosmetic: satisfy gcc warning
Date:   Thu, 9 Jul 2020 22:04:58 +0300
Message-ID: <1594321503-12256-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
References: <1594321503-12256-1-git-send-email-akiyano@amazon.com>
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
index 90c0fe15cd23..18a30a81a475 100644
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
2.23.1

