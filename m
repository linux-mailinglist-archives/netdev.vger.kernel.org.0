Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F63134B5F4
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 11:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhC0KHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 06:07:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14169 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhC0KHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 06:07:40 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6vbM5kgQzndhH;
        Sat, 27 Mar 2021 18:05:03 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 18:07:27 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, Kurt Kanzenbach <kurt@linutronix.de>,
        "Andrew Lunn" <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: dsa: hellcreek: Remove redundant dev_err call in hellcreek_probe()
Date:   Sat, 27 Mar 2021 18:07:18 +0800
Message-ID: <1616839638-7111-1-git-send-email-huangguobin4@huawei.com>
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
 drivers/net/dsa/hirschmann/hellcreek.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 918be7eb626f..4d78219da253 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1842,10 +1842,8 @@ static int hellcreek_probe(struct platform_device *pdev)
 	}
 
 	hellcreek->base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(hellcreek->base)) {
-		dev_err(dev, "No memory available!\n");
+	if (IS_ERR(hellcreek->base))
 		return PTR_ERR(hellcreek->base);
-	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ptp");
 	if (!res) {
@@ -1854,10 +1852,8 @@ static int hellcreek_probe(struct platform_device *pdev)
 	}
 
 	hellcreek->ptp_base = devm_ioremap_resource(dev, res);
-	if (IS_ERR(hellcreek->ptp_base)) {
-		dev_err(dev, "No memory available!\n");
+	if (IS_ERR(hellcreek->ptp_base))
 		return PTR_ERR(hellcreek->ptp_base);
-	}
 
 	ret = hellcreek_detect(hellcreek);
 	if (ret) {

