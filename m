Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15BC4D105F
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbiCHGlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbiCHGlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:41:14 -0500
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA52A3983B;
        Mon,  7 Mar 2022 22:40:17 -0800 (PST)
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-05 (Coremail) with SMTP id zQCowAD3_0NI+iZi3ouBAg--.44386S2;
        Tue, 08 Mar 2022 14:40:09 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net: ethernet: ti: cpts: Handle error for clk_enable
Date:   Tue,  8 Mar 2022 14:40:07 +0800
Message-Id: <20220308064007.1043691-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowAD3_0NI+iZi3ouBAg--.44386S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr47trWkXFyUJrW7Cw1DGFg_yoWfCwc_WF
        Wj9rsFqa15Gw1vka1Utr4DJas0kasFvF1fZ3WIvay3J3y7Cry0vr4vk3y8Ary8WryjkF9r
        GrZ2yasrZw12kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbz8FF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
        67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU5WlkUUUUU
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the potential failure of the clk_enable(),
it should be better to check it and return error
if fails.

Fixes: 8a2c9a5ab4b9 ("net: ethernet: ti: cpts: rework initialization/deinitialization")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/ti/cpts.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
index dc70a6bfaa6a..92ca739fac01 100644
--- a/drivers/net/ethernet/ti/cpts.c
+++ b/drivers/net/ethernet/ti/cpts.c
@@ -568,7 +568,9 @@ int cpts_register(struct cpts *cpts)
 	for (i = 0; i < CPTS_MAX_EVENTS; i++)
 		list_add(&cpts->pool_data[i].list, &cpts->pool);
 
-	clk_enable(cpts->refclk);
+	err = clk_enable(cpts->refclk);
+	if (err)
+		return err;
 
 	cpts_write32(cpts, CPTS_EN, control);
 	cpts_write32(cpts, TS_PEND_EN, int_enable);
-- 
2.25.1

