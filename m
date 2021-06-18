Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D343AD0A0
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbhFRQoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:44:22 -0400
Received: from m12-12.163.com ([220.181.12.12]:36861 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233058AbhFRQoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=f9Ui/oYSk48oHVAu8A
        I9c5OPGqStY9Q1e3ITf86NGJc=; b=qcMbnVgXG6N1rv76bbLuwbvg5zISzIZ+Ro
        yD9idEwYaJqayWgG7MelvM4EmO8bVzmQ6+yBPB+UUkVdFnkdCj9ZYUyT0nho+ko/
        PDdBj4KKrptl1KZsXeJuYBbCu2YCHhS9ytbrO4QAqGlIy97v1Eu9NfPAzouZ4RDE
        Gz4JS5oSg=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowACHpyvBXsxgrcJOKg--.33804S2;
        Fri, 18 Jun 2021 16:52:19 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     charles.gorand@effinnov.com, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] NFC: nxp-nci: remove unnecessary label
Date:   Fri, 18 Jun 2021 16:52:26 +0800
Message-Id: <20210618085226.18440-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DMCowACHpyvBXsxgrcJOKg--.33804S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7ur4UCw13GrWDKr4Uurg_yoWDXFb_ur
        yrZ34fXrWUCrWFvw1xKasxuFyDtw10gaykX3Za9ay3AFyqgw15Ww4Ivrn3Gw1UWFW8CFyD
        Cw18Aw42yr4qyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5Ub15UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBHAO1sV3l-enGnAAAst
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Remove unnecessary label chunk_exit and return directly.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/nxp-nci/firmware.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmware.c
index dae0c80..119bf30 100644
--- a/drivers/nfc/nxp-nci/firmware.c
+++ b/drivers/nfc/nxp-nci/firmware.c
@@ -95,10 +95,8 @@ static int nxp_nci_fw_send_chunk(struct nxp_nci_info *info)
 	int r;
 
 	skb = nci_skb_alloc(info->ndev, info->max_payload, GFP_KERNEL);
-	if (!skb) {
-		r = -ENOMEM;
-		goto chunk_exit;
-	}
+	if (!skb)
+		return -ENOMEM;
 
 	chunk_len = info->max_payload - NXP_NCI_FW_HDR_LEN - NXP_NCI_FW_CRC_LEN;
 	remaining_len = fw_info->frame_size - fw_info->written;
@@ -124,7 +122,6 @@ static int nxp_nci_fw_send_chunk(struct nxp_nci_info *info)
 
 	kfree_skb(skb);
 
-chunk_exit:
 	return r;
 }
 
-- 
1.9.1


