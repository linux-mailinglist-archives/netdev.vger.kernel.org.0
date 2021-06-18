Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAE13AC52C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhFRHr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:47:56 -0400
Received: from m12-18.163.com ([220.181.12.18]:35826 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhFRHry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 03:47:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=r5odC9gStQoxBN83uL
        x0DQ5sdHPVQIH/QKmAdbuq7A4=; b=kW+iyCyGJwNW5+gWrvevRmsOB/HQoV/a7x
        izB62TGoe+UM1glVgQ9KzDArapB8fwYMtKJVPsrnepAGGveydknUm+c5c8X6TcdQ
        J9d6TTCOM8Z38qVOWe63nr+X4b3zG7Db4AO4a3mWiLK3IobxzoFTfGpF1G2B6yWa
        nfPFhql3Q=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowAAXHtbwTsxgFIXYqA--.3668S2;
        Fri, 18 Jun 2021 15:44:51 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     charles.gorand@effinnov.com, krzysztof.kozlowski@canonical.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] NFC: nxp-nci: remove unnecessary label
Date:   Fri, 18 Jun 2021 15:44:56 +0800
Message-Id: <20210618074456.17544-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EsCowAAXHtbwTsxgFIXYqA--.3668S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWxJw48tF1ruw47CFy5CFg_yoWDArb_ur
        yrZ3s2qrWUCr4rZw17K3ZxuryDtw10ga4kX3Za9ay3AFyqgwn8Ww4Ivrn3Gw1UWFWxCFyD
        Cr18Ar1Iyr4qyjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUeWq2tUUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqxO1sVUMZ3fBvgAAsK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Label chunk_exit is unnecessary, so we delete it and
directly return -ENOMEM.

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


