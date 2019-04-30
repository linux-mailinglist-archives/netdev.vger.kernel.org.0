Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DD5EE81
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 03:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfD3Bpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 21:45:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729238AbfD3Bpe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 21:45:34 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3A5E35E79536056B8EF8;
        Tue, 30 Apr 2019 09:45:32 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Tue, 30 Apr 2019 09:45:24 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        <julia.lawall@lip6.fr>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH v3 net-next] net: ethernet: ti: cpsw: Fix inconsistent IS_ERR and PTR_ERR in cpsw_probe()
Date:   Tue, 30 Apr 2019 01:55:24 +0000
Message-ID: <20190430015524.50997-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190429143157.79035-1-yuehaibing@huawei.com>
References: <20190429143157.79035-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix inconsistent IS_ERR and PTR_ERR in cpsw_probe,
The proper pointer to use is clk instead of mode.

This issue was detected with the help of Coccinelle.

Fixes: 83a8471ba255 ("net: ethernet: ti: cpsw: refactor probe to group common hw initialization")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
v3: Fix commit log
v2: add Fixes tag
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



