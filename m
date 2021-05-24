Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD7F38DEC6
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 03:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhEXBJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 21:09:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3917 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbhEXBJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 21:09:14 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FpJsM4r9RzBts8;
        Mon, 24 May 2021 09:04:55 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 09:07:46 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 24
 May 2021 09:07:45 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <leoyang.li@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <christophe.leroy@csgroup.eu>
CC:     <netdev@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] ethernet: ucc_geth: Use kmemdup() rather than kmalloc+memcpy
Date:   Mon, 24 May 2021 09:07:01 +0800
Message-ID: <20210524010701.24596-1-yuehaibing@huawei.com>
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

Issue identified with Coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: keep kmemdup oneline

 drivers/net/ethernet/freescale/ucc_geth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index e0936510fa34..0acfafb73db1 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3590,10 +3590,9 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	if ((ucc_num < 0) || (ucc_num > 7))
 		return -ENODEV;
 
-	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
+	ug_info = kmemdup(&ugeth_primary_info, sizeof(*ug_info), GFP_KERNEL);
 	if (ug_info == NULL)
 		return -ENOMEM;
-	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
 
 	ug_info->uf_info.ucc_num = ucc_num;
 
-- 
2.17.1

