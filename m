Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09069463121
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhK3KjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:39:03 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28131 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbhK3KjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 05:39:03 -0500
Received: from dggeml709-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4J3JTB21yqz1DJlQ;
        Tue, 30 Nov 2021 18:33:02 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 dggeml709-chm.china.huawei.com (10.3.17.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 30 Nov 2021 18:35:42 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
Date:   Tue, 30 Nov 2021 10:48:40 +0000
Message-ID: <20211130104840.1767981-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeml709-chm.china.huawei.com (10.3.17.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not necessary to free memory allocated with devm_kzalloc
and using kfree leads to a double free.

Fixes: 35aefaad326b ("net: ixp4xx_hss: Convert to use DT probing")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/wan/ixp4xx_hss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index d02d8a2eb99d..0b7d9f2f2b8b 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -1508,7 +1508,6 @@ static int ixp4xx_hss_remove(struct platform_device *pdev)
 	unregister_hdlc_device(port->netdev);
 	free_netdev(port->netdev);
 	npe_release(port->npe);
-	kfree(port);
 	return 0;
 }
 

