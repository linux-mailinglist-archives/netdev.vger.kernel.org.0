Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D30B46706E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378323AbhLCDGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:06:47 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:51826 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239667AbhLCDGr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 22:06:47 -0500
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-05 (Coremail) with SMTP id zQCowAAnCRbdiKlhM80FAQ--.32888S2;
        Fri, 03 Dec 2021 11:02:53 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fw@strlen.de,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v2] net: broadcom: Catch the Exception
Date:   Fri,  3 Dec 2021 11:02:50 +0800
Message-Id: <20211203030250.1512671-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowAAnCRbdiKlhM80FAQ--.32888S2
X-Coremail-Antispam: 1UD129KBjvdXoWrur43JFWxuryUCr4rGr43GFg_yoWDKwbEgF
        yUZ3sag3y8CryYkwsakw43Zry0k3yqvw18uFyvgrZaqr98ur1Dt3yktF1rtw1UWrWDJFyS
        yrnxtFZxA340gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU-miiUUU
        UU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of dma_set_coherent_mask() is not always 0.
To catch the exception in case that dma is not support the mask.

Fixes: 9d61d138ab30 ("net: broadcom: rename BCM4908 driver & update DT binding")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
Changelog

v1 -> v2

* Change 1. Correct the Fixes tags.
* Change 2. CC Florian.
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 02a569500234..376f81796a29 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -708,7 +708,9 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 
 	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
 
-	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	err = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
 
 	err = bcm4908_enet_dma_alloc(enet);
 	if (err)
-- 
2.25.1

