Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE4621CBE6
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 00:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgGLWgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 18:36:49 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:57603 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgGLWgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 18:36:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594593409; x=1626129409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WMbHJQqI28eTZB5u5ozLb0fcIDt3P203mpjXkckChGk=;
  b=Og8iXRnawLFVZw8flgj0OQxHXiJfoUGFiWicr45JVovHTXxS/wyGn9oC
   /B4tDXfa9OBJk2sl/vZHWAs2gXB6TqO2ZGciMLUx4OOWHkEvDlNsA1VsD
   M3KKgAfAVo+3ddkug0ijwbiBzxzY39qgz0H9YqJ6kmDh105TgyfsGWM89
   o=;
IronPort-SDR: XHS2ZiA4utejnw7UqXmUrCOl/xtqD3VpImuVMESx3VLJAIb/IlkzQF4tvQf7bQjVTlzxSLjiCP
 ledN2K1HUIqw==
X-IronPort-AV: E=Sophos;i="5.75,345,1589241600"; 
   d="scan'208";a="57883305"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Jul 2020 22:36:47 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-c6afef2e.us-west-2.amazon.com (Postfix) with ESMTPS id B52D2A23CA;
        Sun, 12 Jul 2020 22:36:46 +0000 (UTC)
Received: from EX13D21UWA002.ant.amazon.com (10.43.160.246) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:33 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA002.ant.amazon.com (10.43.160.246) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Jul 2020 22:36:33 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.5) by mail-relay.amazon.com
 (10.43.160.118) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 12 Jul 2020 22:36:28 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V2 net-next 3/7] net: ena: cosmetic: satisfy gcc warning
Date:   Mon, 13 Jul 2020 01:36:07 +0300
Message-ID: <1594593371-14045-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
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

