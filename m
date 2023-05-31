Return-Path: <netdev+bounces-6720-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA1D07179B5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:13:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C9392813C8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDE3BE4B;
	Wed, 31 May 2023 08:13:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D6CBA2B
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:13:44 +0000 (UTC)
X-Greylist: delayed 732 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 01:13:42 PDT
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3373293;
	Wed, 31 May 2023 01:13:41 -0700 (PDT)
Received: from localhost.localdomain (unknown [124.16.138.125])
	by APP-03 (Coremail) with SMTP id rQCowAC3vzNK_XZkbgFTCA--.54869S2;
	Wed, 31 May 2023 15:54:51 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	davthompson@nvidia.com,
	asmaa@nvidia.com,
	mkl@pengutronix.de
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Date: Wed, 31 May 2023 15:54:51 +0800
Message-Id: <20230531075451.47524-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAC3vzNK_XZkbgFTCA--.54869S2
X-Coremail-Antispam: 1UD129KBjvJXoWrZF4UGr1xJr43AF1ruF1ftFb_yoW8Jry7pr
	y8JryvqrZ5J3Wjg3Z7J395Zr1fuw4qvF1a9FWfKa1furn8Za1qkr98tFWxuFn7Gr9xG3y3
	Ary3ZFs5ZFn8A3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkIecxEwVAFwVW8CwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbhiSPUUUUU==
X-Originating-IP: [124.16.138.125]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the check for the return value of the platform_get_irq and
return error if it fails.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 694de9513b9f..a38e1c68874f 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -427,6 +427,10 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	priv->error_irq = platform_get_irq(pdev, MLXBF_GIGE_ERROR_INTR_IDX);
 	priv->rx_irq = platform_get_irq(pdev, MLXBF_GIGE_RECEIVE_PKT_INTR_IDX);
 	priv->llu_plu_irq = platform_get_irq(pdev, MLXBF_GIGE_LLU_PLU_INTR_IDX);
+	if (priv->error_irq < 0 || priv->rx_irq < 0 || priv->llu_plu_irq < 0) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	phy_irq = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(&pdev->dev), "phy-gpios", 0);
 	if (phy_irq < 0) {
-- 
2.25.1


