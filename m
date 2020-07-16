Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64FA222AAB
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 20:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgGPSLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 14:11:11 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:46694 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgGPSLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 14:11:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594923070; x=1626459070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=U5Kd9OcJaHwKe4qYczPX82NmcTj0a0nZJOcMmatMXxE=;
  b=I86nfpFmB0Id4yQ9o55x58KaW3BwC8EFiO6K2T4DI6LV9XSPljks9TLP
   s//sk6Pb8ITXXZrqz2KBrp9O6XWUVGlP4TPO82q/vM6R7q/gKGPZDRueL
   ANkvBxzNNzVyVRqdr1pjMiCIu7CfsIBrquyXkHOY8hEW8tS5MYt4UlnZs
   A=;
IronPort-SDR: xAKp4WfzOTdM9qd7+w5bNl1w6ky73BI+uCtwd07XEvV2nWzmUo/Mv2+c+psTs2Mn5i7z1uOPT8
 zbHmzEx5IAJw==
X-IronPort-AV: E=Sophos;i="5.75,360,1589241600"; 
   d="scan'208";a="60403189"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 16 Jul 2020 18:11:07 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 8E1DCA1CF5;
        Thu, 16 Jul 2020 18:11:06 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:11:00 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 16 Jul 2020 18:11:00 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.212.20) by
 mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 16 Jul 2020 18:10:56 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V3 net-next 3/8] net: ena: cosmetic: satisfy gcc warning
Date:   Thu, 16 Jul 2020 21:10:05 +0300
Message-ID: <1594923010-6234-4-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
References: <1594923010-6234-1-git-send-email-akiyano@amazon.com>
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
2.23.3

