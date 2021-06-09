Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFCE3A15F7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbhFINtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:49:32 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8117 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbhFINtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:49:31 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0Syd51bPzYrdZ;
        Wed,  9 Jun 2021 21:44:41 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 21:47:31 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 9 Jun 2021
 21:47:31 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>
Subject: [PATCH net-next] net: ethernet: ti: cpsw-phy-sel: Use devm_platform_ioremap_resource_byname()
Date:   Wed, 9 Jun 2021 21:51:38 +0800
Message-ID: <20210609135138.3192652-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the devm_platform_ioremap_resource_byname() helper instead of
calling platform_get_resource_byname() and devm_ioremap_resource()
separately.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/ti/cpsw-phy-sel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw-phy-sel.c b/drivers/net/ethernet/ti/cpsw-phy-sel.c
index 6e72ecbe5cf7..e8f38e3f7706 100644
--- a/drivers/net/ethernet/ti/cpsw-phy-sel.c
+++ b/drivers/net/ethernet/ti/cpsw-phy-sel.c
@@ -206,7 +206,6 @@ static const struct of_device_id cpsw_phy_sel_id_table[] = {
 
 static int cpsw_phy_sel_probe(struct platform_device *pdev)
 {
-	struct resource	*res;
 	const struct of_device_id *of_id;
 	struct cpsw_phy_sel_priv *priv;
 
@@ -223,8 +222,7 @@ static int cpsw_phy_sel_probe(struct platform_device *pdev)
 	priv->dev = &pdev->dev;
 	priv->cpsw_phy_sel = of_id->data;
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gmii-sel");
-	priv->gmii_sel = devm_ioremap_resource(&pdev->dev, res);
+	priv->gmii_sel = devm_platform_ioremap_resource_byname(pdev, "gmii-sel");
 	if (IS_ERR(priv->gmii_sel))
 		return PTR_ERR(priv->gmii_sel);
 
-- 
2.25.1

