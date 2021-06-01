Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80793974D5
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhFAODu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:03:50 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2933 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbhFAODs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:03:48 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FvYfw44LXz67w9;
        Tue,  1 Jun 2021 21:59:04 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 22:02:01 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 1 Jun
 2021 22:02:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <rajur@chelsio.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] cxgb4: Fix -Wunused-const-variable warning
Date:   Tue, 1 Jun 2021 22:01:48 +0800
Message-ID: <20210601140148.27968-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_PCI_IOV is n, make W=1 warns:

drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c:3909:33:
 warning: ‘cxgb4_mgmt_ethtool_ops’ defined but not used [-Wunused-const-variable=]
 static const struct ethtool_ops cxgb4_mgmt_ethtool_ops = {
                                 ^~~~~~~~~~~~~~~~~~~~~~

Move it into #ifdef block to fix this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 421bd9b88028..b730aa1cb141 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3894,7 +3894,6 @@ static const struct net_device_ops cxgb4_mgmt_netdev_ops = {
 	.ndo_set_vf_vlan        = cxgb4_mgmt_set_vf_vlan,
 	.ndo_set_vf_link_state	= cxgb4_mgmt_set_vf_link_state,
 };
-#endif
 
 static void cxgb4_mgmt_get_drvinfo(struct net_device *dev,
 				   struct ethtool_drvinfo *info)
@@ -3909,6 +3908,7 @@ static void cxgb4_mgmt_get_drvinfo(struct net_device *dev,
 static const struct ethtool_ops cxgb4_mgmt_ethtool_ops = {
 	.get_drvinfo       = cxgb4_mgmt_get_drvinfo,
 };
+#endif
 
 static void notify_fatal_err(struct work_struct *work)
 {
-- 
2.17.1

