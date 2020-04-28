Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04CA1BB776
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgD1H1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:27:50 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:11727 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgD1H1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588058868; x=1619594868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SdtQ8eUAdIzuZaZgaj1uwq8PlGb5Lle5Moh/ms4CS8s=;
  b=IIV96VSyWs6v6hfuVEIdY8tIOEzaOP1o3NE3FaZJvCmlEhhmKvwKa0WJ
   2nTeLH5UFkYOZypmQRyOD8Rroc9LPKjcIQ6FoEvkA+iXfTItyG3VuVOVU
   k4yTnJ/I721QWfzzid/oygkyIEbkA49eYhRDS+plcF4KlZ0/w8sWrpM3J
   M=;
IronPort-SDR: OYOIpCfAsWhJ0yA0rCmHxkXDu2iXTvwjGeXGKFKPdBRCfSgou1XcKDDlVCCrM4ANyyqufw6Y4S
 YJt1Q68tfXAw==
X-IronPort-AV: E=Sophos;i="5.73,327,1583193600"; 
   d="scan'208";a="31563128"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 28 Apr 2020 07:27:48 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id B0541A1C24;
        Tue, 28 Apr 2020 07:27:47 +0000 (UTC)
Received: from EX13D08UEE002.ant.amazon.com (10.43.62.92) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D08UEE002.ant.amazon.com (10.43.62.92) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 28 Apr 2020 07:27:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Tue, 28 Apr 2020 07:27:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 5BC9281CBA; Tue, 28 Apr 2020 07:27:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V2 net-next 06/13] net: ena: remove code that does nothing
Date:   Tue, 28 Apr 2020 07:27:19 +0000
Message-ID: <20200428072726.22247-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200428072726.22247-1-sameehj@amazon.com>
References: <20200428072726.22247-1-sameehj@amazon.com>
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

