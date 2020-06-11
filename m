Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1551F6028
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 04:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgFKCyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 22:54:51 -0400
Received: from smtp21.cstnet.cn ([159.226.251.21]:35400 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbgFKCyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 22:54:50 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2020 22:52:47 EDT
Received: from localhost.localdomain (unknown [159.226.5.100])
        by APP-01 (Coremail) with SMTP id qwCowAB3KszDmuFe33kpAg--.46380S2;
        Thu, 11 Jun 2020 10:45:24 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     ioana.ciornei@nxp.com, ruxandra.radulescu@nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: dpaa2: Use devm_kcalloc() in setup_dpni()
Date:   Thu, 11 Jun 2020 02:45:20 +0000
Message-Id: <20200611024520.630-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: qwCowAB3KszDmuFe33kpAg--.46380S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtrW7tw1kZr1xXFW5CF45KFg_yoWkJFgEkr
        47Zr17Ar4qkFySya1rKr4YvFyvkF4xZr48AFsaqFW3G3srArW8Ww4DXw13Ars3ur4xCry3
        Jr1IyF13ZwnrKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbwxYjsxI4VWkKwAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
        C2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwIxGrwCF
        x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
        v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
        67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2
        IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
        xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUgg_TUUUUU
X-Originating-IP: [159.226.5.100]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAQEA102YMkl4wAAsP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "devm_kcalloc".

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8fb48de5d18c..f150cd454fa4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2907,8 +2907,9 @@ static int setup_dpni(struct fsl_mc_device *ls_dev)
 	if (err && err != -EOPNOTSUPP)
 		goto close;
 
-	priv->cls_rules = devm_kzalloc(dev, sizeof(struct dpaa2_eth_cls_rule) *
-				       dpaa2_eth_fs_count(priv), GFP_KERNEL);
+	priv->cls_rules = devm_kcalloc(dev, dpaa2_eth_fs_count(priv),
+				       sizeof(struct dpaa2_eth_cls_rule),
+				       GFP_KERNEL);
 	if (!priv->cls_rules) {
 		err = -ENOMEM;
 		goto close;
-- 
2.17.1

