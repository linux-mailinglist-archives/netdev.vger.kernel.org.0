Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340E034C17F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhC2Byu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:54:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15080 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhC2By1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:54:27 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F7wYy6M8rz19JS5;
        Mon, 29 Mar 2021 09:52:22 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:54:17 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: mscc: ocelot: remove redundant dev_err call in vsc9959_mdio_bus_alloc()
Date:   Mon, 29 Mar 2021 09:54:05 +0800
Message-ID: <1616982845-14819-1-git-send-email-huangguobin4@huawei.com>
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
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5ff623ee76a6..789fe08cae50 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1057,10 +1057,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	res.end += felix->imdio_base;
 
 	imdio_regs = devm_ioremap_resource(dev, &res);
-	if (IS_ERR(imdio_regs)) {
-		dev_err(dev, "failed to map internal MDIO registers\n");
+	if (IS_ERR(imdio_regs))
 		return PTR_ERR(imdio_regs);
-	}
 
 	hw = enetc_hw_alloc(dev, imdio_regs);
 	if (IS_ERR(hw)) {

