Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA02D40C
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 05:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfE2DAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 23:00:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34842 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfE2DAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 23:00:41 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BEBA775CA4A0DB04526B;
        Wed, 29 May 2019 11:00:33 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 29 May 2019
 11:00:26 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <antoine.tenart@bootlin.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] net: mvpp2: cls: Remove unnessesary check in mvpp2_ethtool_cls_rule_ins
Date:   Wed, 29 May 2019 10:59:06 +0800
Message-ID: <20190529025906.17452-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190527134646.21804-1-yuehaibing@huawei.com>
References: <20190527134646.21804-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix smatch warning:

drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c:1236
 mvpp2_ethtool_cls_rule_ins() warn: unsigned 'info->fs.location' is never less than zero.

'info->fs.location' is u32 type, never less than zero.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: rework patch based net-next
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index bd19a910dc90..e1c90adb2982 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1300,8 +1300,7 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 	struct mvpp2_ethtool_fs *efs, *old_efs;
 	int ret = 0;
 
-	if (info->fs.location >= MVPP2_N_RFS_ENTRIES_PER_FLOW ||
-	    info->fs.location < 0)
+	if (info->fs.location >= MVPP2_N_RFS_ENTRIES_PER_FLOW)
 		return -EINVAL;
 
 	efs = kzalloc(sizeof(*efs), GFP_KERNEL);
-- 
2.20.1


