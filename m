Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF5434C145
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbhC2Bua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:50:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15079 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhC2Bt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 21:49:58 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F7wSm74M8z19JQK;
        Mon, 29 Mar 2021 09:47:52 +0800 (CST)
Received: from mdc.localdomain (10.175.104.57) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 09:49:45 +0800
From:   Huang Guobin <huangguobin4@huawei.com>
To:     <huangguobin4@huawei.com>, Vinod Koul <vkoul@kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2] net: stmmac: remove redundant dev_err call in qcom_ethqos_probe()
Date:   Mon, 29 Mar 2021 09:49:32 +0800
Message-ID: <1616982572-14473-1-git-send-email-huangguobin4@huawei.com>
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
 .../net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c  | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index bfc4a92f1d92..a674b7d6b49a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -477,7 +477,6 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rgmii");
 	ethqos->rgmii_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ethqos->rgmii_base)) {
-		dev_err(&pdev->dev, "Can't get rgmii base\n");
 		ret = PTR_ERR(ethqos->rgmii_base);
 		goto err_mem;
 	}

