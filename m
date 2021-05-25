Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E6E38FB08
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 08:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhEYGjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 02:39:55 -0400
Received: from m12-15.163.com ([220.181.12.15]:35431 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230465AbhEYGjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 02:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=35LorTIeip7UD/JOGo
        p8yGU8p5m2rRWiwxvD4jcGH1w=; b=aiGArh3RwVVJyEsVM6Ar+IBoO9VBEJKIy+
        lkZA4dp+lOEdNWo+bok40PDhdZx33gBlAwIz1SCGYs5QSmUCEs5KzHk/HPYxE8iO
        uDkUlABhhWxlseuCMVwF0vHpLnCjq4llqakKCBYn9oLd66PUZZKATRn/tZfmeIXC
        aCaTRz2OU=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowACnrpJLm6xgPWjLCA--.32S2;
        Tue, 25 May 2021 14:38:10 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        dinghao.liu@zju.edu.cn
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] NFC: st95hf: remove unnecessary assignment and label
Date:   Tue, 25 May 2021 14:38:01 +0800
Message-Id: <20210525063801.11840-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: D8CowACnrpJLm6xgPWjLCA--.32S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW3Wr1xtF1rAF4Duw1ftFb_yoWkGFcE9r
        yjv347ZFWUGr1UJry2g3ZxX34rKwnY9r4rX3Wag3WYkryjqwsxZanYyrZ5W3sxWryFyas8
        G3Z5A3yxursrGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5opBDUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBLAqdsV++L6CNhgAAsv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In function st95hf_in_send_cmd, the variable rc is assigned then goto
error label, which just return rc, so we use return to replace it. and
error label only used once in the function, so we remove error label.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/st95hf/core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 4578547..88924be 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -926,10 +926,8 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 	int len_data_to_tag = 0;
 
 	skb_resp = nfc_alloc_recv_skb(MAX_RESPONSE_BUFFER_SIZE, GFP_KERNEL);
-	if (!skb_resp) {
-		rc = -ENOMEM;
-		goto error;
-	}
+	if (!skb_resp)
+		return -ENOMEM;
 
 	switch (stcontext->current_rf_tech) {
 	case NFC_DIGITAL_RF_TECH_106A:
@@ -986,7 +984,6 @@ static int st95hf_in_send_cmd(struct nfc_digital_dev *ddev,
 
 free_skb_resp:
 	kfree_skb(skb_resp);
-error:
 	return rc;
 }
 
-- 
1.9.1

