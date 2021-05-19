Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16A53884A9
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 04:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhESCMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 22:12:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3589 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbhESCM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 22:12:29 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FlGVv5GfhzsSR5;
        Wed, 19 May 2021 10:08:23 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 10:11:09 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 19
 May 2021 10:11:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <yuehaibing@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] ethtool: stats: Fix a copy-paste error
Date:   Wed, 19 May 2021 10:10:38 +0800
Message-ID: <20210519021038.25928-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

data->ctrl_stats should be memset with correct size.

Fixes: bfad2b979ddc ("ethtool: add interface to read standard MAC Ctrl stats")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ethtool/stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index b7642dc96d50..ec07f5765e03 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -119,7 +119,7 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	 */
 	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
 	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
-	memset(&data->ctrl_stats, 0xff, sizeof(data->mac_stats));
+	memset(&data->ctrl_stats, 0xff, sizeof(data->ctrl_stats));
 	memset(&data->rmon_stats, 0xff, sizeof(data->rmon_stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
-- 
2.17.1

