Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083691C2B02
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgECJwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:6409 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgECJw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499549; x=1620035549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Msnd84qBQYm4DKqejTe9PyJUI6reM4yHHZnM3E65/g4=;
  b=jwZeB4xH+wiQi8GcCshbBulQbC06AXbfRl+De8vn5pX+QCHds9AzzvGZ
   FzPY8ct1ZpEdpv7Wv/xIaOucVbnqcAr+XxV5k8tM6OaDXCrdOvc5eKAWS
   oMqPqw8BX00XZ8Lt4GZIxCDAP7Oj+wxY/+lmIeHfcpN1NnNUbwATotKAr
   U=;
IronPort-SDR: HPhQ5gJIAlu+wIMckL9Ztyd3OU6EfsNwiI7QvRF7P3lCb7+JFwvQDYRKpL5oo6iT3/vc2T/hsv
 mScDCGD7FbDw==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="40862722"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 03 May 2020 09:52:26 +0000
Received: from EX13MTAUEB002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id DABAEA2033;
        Sun,  3 May 2020 09:52:24 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:23 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:23 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 7547E81D10; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 04/12] net: ena: change default RSS hash function to Toeplitz
Date:   Sun, 3 May 2020 09:52:13 +0000
Message-ID: <20200503095221.6408-5-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200503095221.6408-1-sameehj@amazon.com>
References: <20200503095221.6408-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Currently in the driver we are setting the hash function to be CRC32.
Starting with this commit we want to change the default behaviour so that
we set the hash function to be Toeplitz instead.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2cc765df8da3..6baafc3aebea 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3991,7 +3991,7 @@ static int ena_rss_init_default(struct ena_adapter *adapter)
 		}
 	}
 
-	rc = ena_com_fill_hash_function(ena_dev, ENA_ADMIN_CRC32, NULL,
+	rc = ena_com_fill_hash_function(ena_dev, ENA_ADMIN_TOEPLITZ, NULL,
 					ENA_HASH_KEY_SIZE, 0xFFFFFFFF);
 	if (unlikely(rc && (rc != -EOPNOTSUPP))) {
 		dev_err(dev, "Cannot fill hash function\n");
-- 
2.24.1.AMZN

