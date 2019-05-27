Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09AC42B717
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 15:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfE0N4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 09:56:35 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbfE0N4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 09:56:34 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7DBC2F6231E3F38B7F47;
        Mon, 27 May 2019 21:56:32 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Mon, 27 May 2019
 21:56:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <antoine.tenart@bootlin.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: mvpp2: cls: Remove unnessesary check in mvpp2_ethtool_cls_rule_ins
Date:   Mon, 27 May 2019 21:46:46 +0800
Message-ID: <20190527134646.21804-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
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
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index a57d17ab91f0..914b93f27469 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1232,8 +1232,7 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 	struct mvpp2_ethtool_fs *efs, *old_efs;
 	int ret = 0;
 
-	if (info->fs.location >= 4 ||
-	    info->fs.location < 0)
+	if (info->fs.location >= 4)
 		return -EINVAL;
 
 	efs = kzalloc(sizeof(*efs), GFP_KERNEL);
-- 
2.17.1


