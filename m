Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1DD487DAC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 21:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiAGUYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 15:24:23 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:34546 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbiAGUYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 15:24:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641587063; x=1673123063;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N8rDUzt2sNXTsmXLEmbZ7ailyg9d5J6zy7XUGedrljI=;
  b=o4KYLqkpemPqTQ1VdJtpdkjscF1bHXtW+XrjyyGvzaleMehUPnLPWkm8
   b20Hj89jNLMQG3dTSyaZg88R2OnNm5imWnYG2VLpa06XPJWwEE6Z4P6Uu
   BTi27Mj6tgUrRuUSOvr8XLFaKuQ294UteEGZ2nA9SbXjZ2UBKhnKP9CMG
   M=;
X-IronPort-AV: E=Sophos;i="5.88,270,1635206400"; 
   d="scan'208";a="185624941"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 07 Jan 2022 20:24:22 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com (Postfix) with ESMTPS id 138E4810C8;
        Fri,  7 Jan 2022 20:24:20 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:06 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Fri, 7 Jan 2022 20:24:05 +0000
Received: from dev-dsk-akiyano-1c-2138b29d.eu-west-1.amazon.com (172.19.83.6)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.26 via Frontend Transport; Fri, 7 Jan 2022 20:24:04 +0000
From:   Arthur Kiyanovski <akiyano@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>
Subject: [PATCH V2 net-next 05/10] net: ena: Remove redundant return code check
Date:   Fri, 7 Jan 2022 20:23:41 +0000
Message-ID: <20220107202346.3522-6-akiyano@amazon.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220107202346.3522-1-akiyano@amazon.com>
References: <20220107202346.3522-1-akiyano@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ena_com_indirect_table_fill_entry() function only returns -EINVAL
or 0, no need to check for -EOPNOTSUPP.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index f0fbecb8019f..2dfb1ee378e5 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4110,7 +4110,7 @@ static int ena_rss_init_default(struct ena_adapter *adapter)
 		val = ethtool_rxfh_indir_default(i, adapter->num_io_queues);
 		rc = ena_com_indirect_table_fill_entry(ena_dev, i,
 						       ENA_IO_RXQ_IDX(val));
-		if (unlikely(rc && (rc != -EOPNOTSUPP))) {
+		if (unlikely(rc)) {
 			dev_err(dev, "Cannot fill indirect table\n");
 			goto err_fill_indir;
 		}
-- 
2.32.0

