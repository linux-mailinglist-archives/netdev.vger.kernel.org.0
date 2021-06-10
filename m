Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95BC3A2DA6
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbhFJODz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:03:55 -0400
Received: from m12-11.163.com ([220.181.12.11]:36974 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhFJODy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 10:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2gIa2
        ivO7sVTOiyRe5C/PPsVB2sRGVleTFNA1p6NVz4=; b=SHw+0K3MPyzhrZEzfpRfv
        wl2j8QG0MwDeTNc6W+mxGkHG14Mv6xl98RzmB3uVvfhi1gLtsoOEczTuBGP27doh
        StjqmNl2FTA/caagwxYgNe/RPMATEwldeQcgPDvp9iMT/iSBFaV9wLOaZXeKuO1m
        Z3P13wudPyv8vKlXbF3g3M=
Received: from localhost.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowACHqaFCG8JglYUVhQ--.8453S2;
        Thu, 10 Jun 2021 22:01:39 +0800 (CST)
From:   =?UTF-8?q?=C2=A0Zhongjun=20Tan?= <hbut_tan@163.com>
To:     elder@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tan Zhongjun <tanzhongjun@yulong.com>
Subject: [PATCH] soc: qcom: ipa: Remove superfluous error message around platform_get_irq()
Date:   Thu, 10 Jun 2021 22:01:18 +0800
Message-Id: <20210610140118.1437-1-hbut_tan@163.com>
X-Mailer: git-send-email 2.30.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowACHqaFCG8JglYUVhQ--.8453S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrykKFy7tryDZw1furWDtwb_yoWfuFc_Kr
        9rZF1fWa95ur4Sy3yUZrWfZFy7tw1UZry0gry2v3yS9ry5AF1UJr1DuryfJF4SkrWUCr9r
        CryxGrWIyr9rujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeAsqJUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: xkex3sxwdqqiywtou0bp/1tbiSButxl+Fa+F2AAAAse
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Zhongjun <tanzhongjun@yulong.com>

The platform_get_irq() prints error message telling that interrupt is
missing,hence there is no need to duplicated that message in the
drivers.

Signed-off-by: Tan Zhongjun <tanzhongjun@yulong.com>
---
 drivers/net/ipa/ipa_smp2p.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index 34b68dc43886..93270e50b6b3 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -177,11 +177,8 @@ static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
 	int ret;
 
 	ret = platform_get_irq_byname(smp2p->ipa->pdev, name);
-	if (ret <= 0) {
-		dev_err(dev, "DT error %d getting \"%s\" IRQ property\n",
-			ret, name);
+	if (ret <= 0)
 		return ret ? : -EINVAL;
-	}
 	irq = ret;
 
 	ret = request_threaded_irq(irq, NULL, handler, 0, name, smp2p);
-- 
2.17.1

