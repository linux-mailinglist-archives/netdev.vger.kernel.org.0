Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30A39E3ED
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfD2NrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:47:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48282 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbfD2NrB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 09:47:01 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A366693F2C37064144E6;
        Mon, 29 Apr 2019 21:46:57 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Mon, 29 Apr 2019 21:46:47 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: ethernet: ti: cpsw: Fix inconsistent IS_ERR and PTR_ERR in cpsw_probe()
Date:   Mon, 29 Apr 2019 13:56:50 +0000
Message-ID: <20190429135650.72794-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the call to PTR_ERR to access the value just tested by IS_ERR.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/ti/cpsw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index c3cba46fac9d..e37680654a13 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -2381,7 +2381,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	clk = devm_clk_get(dev, "fck");
 	if (IS_ERR(clk)) {
-		ret = PTR_ERR(mode);
+		ret = PTR_ERR(clk);
 		dev_err(dev, "fck is not found %d\n", ret);
 		return ret;
 	}





