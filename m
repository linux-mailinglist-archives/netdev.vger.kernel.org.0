Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF477186B34
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 13:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbgCPMjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 08:39:24 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8928 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731055AbgCPMjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 08:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1584362363; x=1615898363;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=/2khqVNRPOGPjyuIDjrs3MmZoMil42ginaBwNCwYBxA=;
  b=MN+snxcxWPk5tHNNGCombre2QMcnz8SxC3QsvH5S0bqvyFRokOFe3ZFn
   wRyLgpGMW3jD7cRPbcoVWjDh0HUH5TcqTDhoz2jDbe7PKKklGhiKz98Vt
   IpXld6kP3LycpMQzqR8/rNu02+9mGMASVOlNkOvfHYXTZguN9BnjyBJ6q
   E=;
IronPort-SDR: gvngpW+4JYKsN4mkLqo7HjflLOGRmfWVNsnHxJ/vzXXNxghXev5HZJH5qDGKRoEwGZitSLwrL+
 JkM65HuqORrA==
X-IronPort-AV: E=Sophos;i="5.70,560,1574121600"; 
   d="scan'208";a="21214133"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 16 Mar 2020 12:39:11 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 9AF9CA2B42;
        Mon, 16 Mar 2020 12:39:09 +0000 (UTC)
Received: from EX13D21UWA001.ant.amazon.com (10.43.160.154) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 16 Mar 2020 12:38:53 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D21UWA001.ant.amazon.com (10.43.160.154) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 16 Mar 2020 12:38:52 +0000
Received: from HFA15-G63729NC.amazon.com (10.1.213.27) by
 mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 16 Mar 2020 12:38:48 +0000
From:   <akiyano@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>, <shayagr@amazon.com>,
        <sameehj@amazon.com>
Subject: [PATCH V1 net 4/7] net: ena: remove code that does nothing
Date:   Mon, 16 Mar 2020 14:38:21 +0200
Message-ID: <1584362304-274-5-git-send-email-akiyano@amazon.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584362304-274-1-git-send-email-akiyano@amazon.com>
References: <1584362304-274-1-git-send-email-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

Both key and func parameters are pointers on the stack.
Setting them to NULL does nothing.
The original intent was to leave the key and func unset in this case,
but for this to happen nothing needs to be done as the calling
function ethtool_get_rxfh() already clears key and func.

This commit removes the above described useless code.

Fixes: 0c8923c0a64f ("net: ena: rss: fix failure to get indirection table")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index d1a320b1774d..0b5adcb40425 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -675,11 +675,8 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
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
2.17.1

