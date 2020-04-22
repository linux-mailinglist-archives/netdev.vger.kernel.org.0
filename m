Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0581B39D0
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgDVIQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:16:37 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:58679 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgDVIQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587543394; x=1619079394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SdtQ8eUAdIzuZaZgaj1uwq8PlGb5Lle5Moh/ms4CS8s=;
  b=PD5g+Jp8TxqgdG+aB50OXPWeSKeVSAr0fG+hoOsQhDGVh6/cgs3bG2DH
   nydh9m8jSzrh9vhmMd9aWQNCy+haH9JA8v2Qf9SSFaIYGA+SuMxjP+5LA
   j1fZHhvEeMfwyokFMzA5gvaTEmoiCxyHXsz2M67I87qBnJUiXYLQ0/Lze
   U=;
IronPort-SDR: s8uo6S/allcD2KXUM9piuocWRIZk5uAs4KEN+lYyKxD4Xwu6HadoqsyItcDV3g+GovHOXYjtLp
 ODvhcGEhkgCA==
X-IronPort-AV: E=Sophos;i="5.72,412,1580774400"; 
   d="scan'208";a="26804126"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 22 Apr 2020 08:16:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 3E7C1A1D6A;
        Wed, 22 Apr 2020 08:16:32 +0000 (UTC)
Received: from EX13D02UWB001.ant.amazon.com (10.43.161.240) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02UWB001.ant.amazon.com (10.43.161.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 22 Apr 2020 08:16:31 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Wed, 22 Apr 2020 08:16:31 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 7487E81D05; Wed, 22 Apr 2020 08:16:30 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>
Subject: [PATCH V1 net-next 06/13] net: ena: remove code that does nothing
Date:   Wed, 22 Apr 2020 08:16:21 +0000
Message-ID: <20200422081628.8103-7-sameehj@amazon.com>
X-Mailer: git-send-email 2.24.1.AMZN
In-Reply-To: <20200422081628.8103-1-sameehj@amazon.com>
References: <20200422081628.8103-1-sameehj@amazon.com>
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

