Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEFC34B647
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 11:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhC0KiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 06:38:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14501 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhC0KiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 06:38:18 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F6wHL3tqkzrbyb;
        Sat, 27 Mar 2021 18:36:14 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 18:38:06 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yunjian Wang <wangyunjian@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: moxa: remove redundant dev_err call in moxart_mac_probe()
Date:   Sat, 27 Mar 2021 18:37:54 +0800
Message-ID: <1616841474-9299-1-git-send-email-huangguobin4@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guobin Huang <huangguobin4@huawei.com>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Guobin Huang <huangguobin4@huawei.com>
---
 drivers/net/ethernet/moxa/moxart_ether.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index 49fd843c4c8a..b85733942053 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -485,7 +485,6 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	ndev->base_addr = res->start;
 	priv->base = devm_ioremap_resource(p_dev, res);
 	if (IS_ERR(priv->base)) {
-		dev_err(p_dev, "devm_ioremap_resource failed\n");
 		ret = PTR_ERR(priv->base);
 		goto init_fail;
 	}

