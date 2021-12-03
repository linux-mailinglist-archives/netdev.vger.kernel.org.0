Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8C94670BE
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348371AbhLCDfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:35:00 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:33652 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344703AbhLCDe6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 22:34:58 -0500
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-05 (Coremail) with SMTP id zQCowADHpxR7j6lhInAGAQ--.34308S2;
        Fri, 03 Dec 2021 11:31:08 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fw@strlen.de,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH v3] net: bcm4908: Handle dma_set_coherent_mask error codes
Date:   Fri,  3 Dec 2021 11:31:06 +0800
Message-Id: <20211203033106.1512770-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowADHpxR7j6lhInAGAQ--.34308S2
X-Coremail-Antispam: 1UD129KBjvdXoWrur43Jw15Cr45Cw4xCFyrCrg_yoWDuFg_KF
        yUZ3sag3y8CryY9wsakw47Zry0kw4qvr18uFy0grZaqr98Cr1Ut3ykAF1rtw1UWrWUJFy3
        JrnxtFZxA340gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_
        Gr4l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUnQ6pDU
        UUU
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
 
v2 -> v3
 
* Change 1. Modify the subject.
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

