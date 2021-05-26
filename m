Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E171390D9E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 02:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhEZA7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 20:59:22 -0400
Received: from m12-17.163.com ([220.181.12.17]:37001 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhEZA7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 20:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=cPH5Hg7aCKUvPB2wbv
        u+VOANrZ+iZsaBNFD4X/zNBzQ=; b=Oi135XrbTrNT167mRcEyBkQCvGgXEQjjqg
        EvBqCd4J1kEfxX5XS1FaNGM4EwEYLw362SrFvZBYXmcyeKmly8WmC5rZlZKnhl6P
        TiG5rONhMZIfjk50U5hTSHYu9JOsiWHvUBZKSNfp+KlFmkhQsj4+GhDkeUVE33bv
        fCHd5sFBE=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowACXwYXWnK1g5t2d3Q--.46987S2;
        Wed, 26 May 2021 08:56:55 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        dinghao.liu@zju.edu.cn
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] nfc: st95hf: remove unnecessary assignment and label
Date:   Wed, 26 May 2021 08:56:51 +0800
Message-Id: <20210526005651.12652-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EcCowACXwYXWnK1g5t2d3Q--.46987S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW3Wr1xtF1rAF4kJw17trb_yoWkGwbE9r
        yYv347ZFyUGr1UJry2g3ZxX34rKwn7ur4rX3Wag3WYkryjqwsxZanYyrZ5W3sxW3yFyas8
        G3Z5A3yxurnrGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU51c_DUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqxeesVUMZimqwQAAsu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In function st95hf_in_send_cmd, the variable rc is assigned then goto
error label, which just returns rc, so we use return to replace it.
Since error label only used once in the function, so we remove error label.

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


