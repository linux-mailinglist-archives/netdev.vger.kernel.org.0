Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A2438D9C6
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 10:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhEWICX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 04:02:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3915 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbhEWICS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 04:02:18 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Fnt48321tzCvy3;
        Sun, 23 May 2021 15:57:44 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sun, 23 May 2021 16:00:34 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 23
 May 2021 16:00:33 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <leoyang.li@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rasmus.villemoes@prevas.dk>
CC:     <netdev@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] ethernet: ucc_geth: Use kmemdup() rather than kmalloc+memcpy
Date:   Sun, 23 May 2021 15:56:16 +0800
Message-ID: <20210523075616.14792-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue identified with Coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index e0936510fa34..51206272cc25 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3590,10 +3590,10 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
 
-	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
+	ug_info = kmemdup(&ugeth_primary_info, sizeof(*ug_info),
+			  GFP_KERNEL);
 	if (ug_info == NULL)
 		return -ENOMEM;
-	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
 
 	ug_info->uf_info.ucc_num = ucc_num;
 
-- 
2.17.1

