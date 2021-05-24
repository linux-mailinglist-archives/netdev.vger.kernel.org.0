Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E675538DF1B
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 04:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhEXCOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 22:14:07 -0400
Received: from m12-12.163.com ([220.181.12.12]:54451 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231765AbhEXCOF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 22:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=33HhlmsO4TUy4vpKzC
        VRugwD5ZbCqQaS+7CjzK1u9p8=; b=cHnh6mpAfoe/S0Pw+bhhi8M7NfBpHgwhcO
        D/xKxLR2RXgKX/12O0gob48/l+22d8PiGhDyXvMGhRwL7NfxaMAf/xNOZnhhlKjB
        WjovmT91H6XUi+ztqJskl4P2I1ZUvmuUvXmkjKbjYRKcregEHiQL9hj2H9/62o17
        rMX0YA11A=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowAAXJVJOC6tgXIx2Fw--.11368S2;
        Mon, 24 May 2021 10:11:28 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        alex.dewar90@gmail.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: st-nci: remove unnecessary assignment and label
Date:   Mon, 24 May 2021 10:11:23 +0800
Message-Id: <20210524021123.8860-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DMCowAAXJVJOC6tgXIx2Fw--.11368S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW3Xw4xZFWfArW8KFy7GFg_yoWktrbE9r
        WSvr9xCr48JwnYyr1UKrsxZr929rs8ur18uFn8tr9xKF9rJ39Ikwn7urn3X3s8W34rAF9r
        ur1vkryFyw1DZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeK2NtUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In function st_nci_hci_network_init, the variable r is assigned then
goto exit label, which just return r, so we use return to replace it.
and exit label only used once at here, so we remove exit label.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/st-nci/se.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 1cba8f6..8657e02 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -534,10 +534,8 @@ static int st_nci_hci_network_init(struct nci_dev *ndev)
 	dest_params =
 		kzalloc(sizeof(struct core_conn_create_dest_spec_params) +
 			sizeof(struct dest_spec_params), GFP_KERNEL);
-	if (dest_params == NULL) {
-		r = -ENOMEM;
-		goto exit;
-	}
+	if (dest_params == NULL)
+		return -ENOMEM;
 
 	dest_params->type = NCI_DESTINATION_SPECIFIC_PARAM_NFCEE_TYPE;
 	dest_params->length = sizeof(struct dest_spec_params);
@@ -594,8 +592,6 @@ static int st_nci_hci_network_init(struct nci_dev *ndev)
 
 free_dest_params:
 	kfree(dest_params);
-
-exit:
 	return r;
 }
 
-- 
1.9.1


