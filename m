Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44D4352A80
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhDBMQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:16:38 -0400
Received: from m12-17.163.com ([220.181.12.17]:35310 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229932AbhDBMQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 08:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=IWxKbG8Cj43FYem+vi
        40htkvh411QjWWlh67x/zPVmw=; b=Tr9LDxn7SOW6Qxbk0PlypryMV45g1kf2lp
        ZzS/9yutOpOtsOmbOpvChmDXkMzb/97uSb+25DGCxUJtVPymfcl3buL1Dm36wZ8w
        S9qm2sLhGeBtu8aUEFQbp0ddDaMwcRio3P+a/W101ywn84u69IrPRMF8f3/D4VJk
        SPOOSwqlw=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowACXwob2Cmdgsxc2tQ--.61767S2;
        Fri, 02 Apr 2021 20:15:52 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: s3fwrn5: remove unnecessary label
Date:   Fri,  2 Apr 2021 20:15:48 +0800
Message-Id: <20210402121548.3260-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EcCowACXwob2Cmdgsxc2tQ--.61767S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrtrW3Xw43uF4rCr15AF1UKFg_yoW8JryrpF
        Z8Ka4xCFyFkF4rG34vyr4q9F9a93y3GFyxG3yjqws7A3yrZw4vvFnFyFyYkrykCrWUGFy3
        JF42qrs8uFy7Kw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jWApnUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbirA1osVr7s48WXgAAst
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In function s3fwrn5_nci_post_setup, The variable ret is assigned to 0,
then goto out label, but just return ret in out label, so we use
return 0 to replace it. and other goto sentences are similar, we use
return sentences to replace it and delete out label.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/s3fwrn5/core.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index c00b7a0..865d3e3 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -124,13 +124,12 @@ static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
 
 	if (s3fwrn5_firmware_init(info)) {
 		//skip bootloader mode
-		ret = 0;
-		goto out;
+		return 0;
 	}
 
 	ret = s3fwrn5_firmware_update(info);
 	if (ret < 0)
-		goto out;
+		return ret;
 
 	/* NCI core reset */
 
@@ -139,12 +138,9 @@ static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
 
 	ret = nci_core_reset(info->ndev);
 	if (ret < 0)
-		goto out;
-
-	ret = nci_core_init(info->ndev);
+		return ret;
 
-out:
-	return ret;
+	return nci_core_init(info->ndev);
 }
 
 static struct nci_ops s3fwrn5_nci_ops = {
-- 
1.9.1


