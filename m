Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA751DE502
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbgEVLD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:03:28 -0400
Received: from mail.loongson.cn ([114.242.206.163]:44048 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728371AbgEVLD1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 07:03:27 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH995scdeQtI3AA--.86S2;
        Fri, 22 May 2020 19:03:23 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     "'David S. Miller'" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: [PATCH] net: Fix return value about devm_platform_ioremap_resource()
Date:   Fri, 22 May 2020 19:03:21 +0800
Message-Id: <1590145401-27763-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxH995scdeQtI3AA--.86S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr4rtF1Utry5CF1Uuw1fXrb_yoW8Kw4Upa
        1vyFWxur1jgF45t34kta1kZFy5A3W2q3y7Kr95Z3Z3u34DJr4DCryrCFyjyrn5trW0kFyY
        qr4ayrWUZFZ0q3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
        6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4k
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXTm3UUUU
        U==
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When call function devm_platform_ioremap_resource(), we should use IS_ERR()
to check the return value and return PTR_ERR() if failed.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 drivers/net/can/ifi_canfd/ifi_canfd.c     | 5 ++++-
 drivers/net/can/sun4i_can.c               | 2 +-
 drivers/net/dsa/b53/b53_srab.c            | 2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
index 04d59be..74503ca 100644
--- a/drivers/net/can/ifi_canfd/ifi_canfd.c
+++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
@@ -947,8 +947,11 @@ static int ifi_canfd_plat_probe(struct platform_device *pdev)
 	u32 id, rev;
 
 	addr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
+
 	irq = platform_get_irq(pdev, 0);
-	if (IS_ERR(addr) || irq < 0)
+	if (irq < 0)
 		return -EINVAL;
 
 	id = readl(addr + IFI_CANFD_IP_ID);
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e3ba8ab..e2c6cf4 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -792,7 +792,7 @@ static int sun4ican_probe(struct platform_device *pdev)
 
 	addr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(addr)) {
-		err = -EBUSY;
+		err = PTR_ERR(addr);
 		goto exit;
 	}
 
diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
index 1207c30..aaa12d7 100644
--- a/drivers/net/dsa/b53/b53_srab.c
+++ b/drivers/net/dsa/b53/b53_srab.c
@@ -609,7 +609,7 @@ static int b53_srab_probe(struct platform_device *pdev)
 
 	priv->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->regs))
-		return -ENOMEM;
+		return PTR_ERR(priv->regs);
 
 	dev = b53_switch_alloc(&pdev->dev, &b53_srab_ops, priv);
 	if (!dev)
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 7a0d785..17243bb 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1418,7 +1418,7 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	pep->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pep->base)) {
-		err = -ENOMEM;
+		err = PTR_ERR(pep->base);
 		goto err_netdev;
 	}
 
-- 
2.1.0

