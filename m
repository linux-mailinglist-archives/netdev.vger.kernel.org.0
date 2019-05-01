Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA9510870
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfEANsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:48:08 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:44388 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfEANsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1556718487; x=1588254487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=B9rK1YRACLV7GfhK7IeQsxgbcVADkJtf6c7s9ETnSk8=;
  b=ZQpmTDI1c4EHShLSlnSJ2sE+AVIsZwJsqwjxcnHyVg00YDL1GtdYMxDF
   rS4yvNXWwxfnQD7ISDcJiUuWffA+c2InWOswO55yCZDqhsK0p278aXqnU
   GWJRdteb599mZcZGTvkXV8vho9zzJmUMwyMOjuhJK4Z1EQtQEDK8rdwRC
   0=;
X-IronPort-AV: E=Sophos;i="5.60,417,1549929600"; 
   d="scan'208";a="797293795"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 May 2019 13:48:06 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (8.14.7/8.14.7) with ESMTP id x41Dm1L9124046
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 May 2019 13:48:06 GMT
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:47 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 1 May 2019 13:47:47 +0000
Received: from HFA16-8226Y22.hfa16.amazon.com (10.218.60.55) by
 mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 1 May 2019 13:47:43 +0000
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>
Subject: [PATCH V1 net 7/8] net: ena: fix ena_com_fill_hash_function() implementation
Date:   Wed, 1 May 2019 16:47:09 +0300
Message-ID: <20190501134710.8938-8-sameehj@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190501134710.8938-1-sameehj@amazon.com>
References: <20190501134710.8938-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

ena_com_fill_hash_function() didn't configure the rss->hash_func.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")

Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 677d31abf214..4cdd8459c37e 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2280,6 +2280,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return -EINVAL;
 	}
 
+	rss->hash_func = func;
 	rc = ena_com_set_hash_function(ena_dev);
 
 	/* Restore the old function */
-- 
2.17.1

