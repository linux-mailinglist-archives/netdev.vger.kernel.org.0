Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9045E796
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 06:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344432AbhKZF4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 00:56:11 -0500
Received: from m12-13.163.com ([220.181.12.13]:40226 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358583AbhKZFyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 00:54:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=0oY/MG+Yhmc81YNGi4
        zbRgDI258IH1wg0UuqAzQsMzk=; b=SgkO8x4SeneLZu99sSDrZrJb84MegQlg5A
        KC6ZvB38NX2Ov0cw3ZGNswphWrlo0XAo/3+lAo/T6FwcBWa1qLmtlJP6yXxeuPyc
        UuEsd0SjBdOms6OEBx1GfqEyF3n41uiwXnMVnKIAwsKvPX+y7zxxfmkU5+vAlUI/
        xJeWR/BUg=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp9 (Coremail) with SMTP id DcCowAC3bMl1OaBhnUCuPw--.68S2;
        Fri, 26 Nov 2021 09:33:52 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: fdp: Merge the same judgment
Date:   Fri, 26 Nov 2021 09:31:30 +0800
Message-Id: <20211126013130.27112-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DcCowAC3bMl1OaBhnUCuPw--.68S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7CFWfZF1fAw17Aw15CFg_yoW3JFg_CF
        s3XrW7ZrWFgr1YyryfCr9IvFyFqF17Ww1fGay5KayYyrykCF47C34UCr93A3WfWa10vF9r
        WFnxC34SyrWDujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYyGQDUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBHAZXsV3mCNEsxAAAs2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Combine two judgments that return the same value

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/fdp/i2c.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
index f78670bf41e0..28a9e1eb9bcf 100644
--- a/drivers/nfc/fdp/i2c.c
+++ b/drivers/nfc/fdp/i2c.c
@@ -205,9 +205,7 @@ static irqreturn_t fdp_nci_i2c_irq_thread_fn(int irq, void *phy_id)
 
 	r = fdp_nci_i2c_read(phy, &skb);
 
-	if (r == -EREMOTEIO)
-		return IRQ_HANDLED;
-	else if (r == -ENOMEM || r == -EBADMSG)
+	if (r == -EREMOTEIO || r == -ENOMEM || r == -EBADMSG)
 		return IRQ_HANDLED;
 
 	if (skb != NULL)
-- 
2.29.0


