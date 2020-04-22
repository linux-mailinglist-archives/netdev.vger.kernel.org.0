Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA881B39AB
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgDVIJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:09:51 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:55159 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgDVIJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587542987; x=1619078987;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SdtQ8eUAdIzuZaZgaj1uwq8PlGb5Lle5Moh/ms4CS8s=;
  b=LntAu3tEqcGXK1cZjtI3JCX7sNTbU+VYKKWen3Kks9xnMA6fi4aXFdON
   FVTj7xKE+4NUEcb5K7cEb+iw/M8cSx+iw7ZdnoQeaa44gzQx62tNNTVAG
   zj4DbVVos7ksHncg5EmxeGu+MmprCPstrgfRBAvhKcIzKNNVLQwb0WvTg
   w=;
IronPort-SDR: GfD9Y4LPPFW8/V2w6IUFwWJpfVW3DGwtI8TYIt8hm6z63kJhcLdhJ8BQgVdJGB1VYh03S4YiVb
 lKwk+TCJCgtg==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="28152277"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 22 Apr 2020 08:09:34 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 405A1A20AC;
        Wed, 22 Apr 2020 08:09:33 +0000 (UTC)
Received: from EX13d09UWC001.ant.amazon.com (10.43.162.60) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC001.ant.amazon.com (10.43.162.60) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:09:32 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:09:32 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 6695B81D04; Wed, 22 Apr 2020 08:09:31 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net 06/13] net: ena: remove code that does nothing
Date:   Wed, 22 Apr 2020 08:09:16 +0000
Message-ID: <20200422080923.6697-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422080923.6697-1-sameehj@amazon.com>
References: <20200422080923.6697-1-sameehj@amazon.com>
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

