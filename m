Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51D71BA369
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgD0MOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:14:00 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48368 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726260AbgD0MN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 08:13:59 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 49D2FD425B27427F5F35;
        Mon, 27 Apr 2020 20:13:57 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Mon, 27 Apr 2020 20:13:48 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "stigge @ antcom . de" <stigge@antcom.de>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: lpc-enet: fix error return code in lpc_mii_init()
Date:   Mon, 27 Apr 2020 12:15:07 +0000
Message-ID: <20200427121507.23249-1-weiyongjun1@huawei.com>
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

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b7370112f519 ("lpc32xx: Added ethernet driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index d20cf03a3ea0..311454d9b0bc 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -823,7 +823,8 @@ static int lpc_mii_init(struct netdata_local *pldat)
 	if (err)
 		goto err_out_unregister_bus;
 
-	if (lpc_mii_probe(pldat->ndev) != 0)
+	err = lpc_mii_probe(pldat->ndev);
+	if (err)
 		goto err_out_unregister_bus;
 
 	return 0;



