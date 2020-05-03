Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABA81C2B07
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 11:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgECJwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 05:52:42 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:27734 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgECJwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 05:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588499560; x=1620035560;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SdtQ8eUAdIzuZaZgaj1uwq8PlGb5Lle5Moh/ms4CS8s=;
  b=PAoQOd8SaJm0aQc9PkIp5PXv458MInj0L84L7ioQfOpdWhdRk8zD/nmV
   y6E7gWV3yMZQ/1DPQxMaiI460NDC8rARCQ+K+KBFjlDuRwPx58DiGoPWd
   SV7meRKanl3w1DH6RsWEX+jYGWCFpcHTNgk6g1lVQSxQAoSg3d8LEqvGK
   E=;
IronPort-SDR: JKoywPdlcKHWyDiFtvlByc39jwxGc81FHr5TgF8IEIIqQz8HylftXgTuCppg7ZbAB9lYhe4k/I
 EBWK/crr3jVw==
X-IronPort-AV: E=Sophos;i="5.73,347,1583193600"; 
   d="scan'208";a="42280425"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 03 May 2020 09:52:40 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 1A9A9A07CE;
        Sun,  3 May 2020 09:52:39 +0000 (UTC)
Received: from EX13D08UEE003.ant.amazon.com (10.43.62.118) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D08UEE003.ant.amazon.com (10.43.62.118) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 3 May 2020 09:52:24 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sun, 3 May 2020 09:52:24 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 7AE1281D18; Sun,  3 May 2020 09:52:23 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V3 net-next 06/12] net: ena: remove code that does nothing
Date:   Sun, 3 May 2020 09:52:15 +0000
Message-ID: <20200503095221.6408-7-sameehj@amazon.com>
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

From: Sameeh Jubran <sameehj@amazon.com>

Both key and func parameters are pointers on the stack.
Setting them to NULL does nothing.
The original intent was to leave the key and func unset in this case,
but for this to happen nothing needs to be done as the calling
function ethtool_get_rxfh() already clears key and func.

This commit removes the above described useless code.

Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 0c3a2f14387e..c7df25f92dbd 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -674,11 +674,8 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	 */
 	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func);
 	if (rc) {
-		if (rc == -EOPNOTSUPP) {
-			key = NULL;
-			hfunc = NULL;
+		if (rc == -EOPNOTSUPP)
 			rc = 0;
-		}
 
 		return rc;
 	}
-- 
2.24.1.AMZN

