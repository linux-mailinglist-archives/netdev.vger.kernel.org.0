Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73BE0445D84
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 02:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhKEBva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 21:51:30 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:43770 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229647AbhKEBv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 21:51:29 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 21:51:29 EDT
Received: from localhost.localdomain (unknown [124.16.141.244])
        by APP-01 (Coremail) with SMTP id qwCowAD3jyD8i4RhvH6SBg--.14727S2;
        Fri, 05 Nov 2021 09:42:20 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     joel@jms.id.au, caihuoqing@baidu.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: litex: Remove unnecessary print function dev_err()
Date:   Fri,  5 Nov 2021 01:42:17 +0000
Message-Id: <20211105014217.38681-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowAD3jyD8i4RhvH6SBg--.14727S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZrWrWF45Kr47Kr1furWfZrb_yoWfXrcEqr
        n29a93Gw48Jr1Fyw10yrW3Zr9Ikrn8X348XaykKayaq34UCry7Z3sFvF1DJw4Uu397CFy7
        try3Jay7C34SqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbc8YjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
        C2z280aVCY1x0267AKxVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
        Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJV
        W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6w4l42xK
        82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
        6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUqRpPUUUUU
X-Originating-IP: [124.16.141.244]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCwcPA1z4kkBX0wACsw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The print function dev_err() is redundant because
platform_get_irq() already prints an error.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/litex/litex_liteeth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index 3d9385a4989b..ab9fa1525053 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -242,10 +242,8 @@ static int liteeth_probe(struct platform_device *pdev)
 	priv->dev = &pdev->dev;
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq < 0) {
-		dev_err(&pdev->dev, "Failed to get IRQ %d\n", irq);
+	if (irq < 0)
 		return irq;
-	}
 	netdev->irq = irq;
 
 	priv->base = devm_platform_ioremap_resource_byname(pdev, "mac");
-- 
2.25.1

