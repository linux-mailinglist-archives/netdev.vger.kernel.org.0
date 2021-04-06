Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D76354AB4
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 04:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243277AbhDFCBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 22:01:09 -0400
Received: from m12-15.163.com ([220.181.12.15]:40077 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239052AbhDFCBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 22:01:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=gSBuEX2ErbkPyQOP3a
        xEn93QZdKdrES4nKAlW9TbMNw=; b=gc/G+26HRkYHUNWPf3AU5sZJWLR25N27t6
        k5cBsDVwQ/uJbzycEjIUBEObWCe8oeDZewV+tyBOI2hTs8d755859uhWMyc+BUwp
        tNQLkg7gFnlbINiy4no55cCiouLLwIz4hIBllR+Or1q3U7jGlOq9/p587FvRrKJZ
        ESgsnl0Ac=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowADX+8ycwGtg77vMAQ--.23S2;
        Tue, 06 Apr 2021 10:00:25 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] nfc: s3fwrn5: remove unnecessary label
Date:   Tue,  6 Apr 2021 09:59:54 +0800
Message-Id: <20210406015954.10988-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: D8CowADX+8ycwGtg77vMAQ--.23S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrtrW3Xw43uF4rAFWrGr48JFb_yoW8Jr4DpF
        Z8Ka4xCFy8KF1rG340yr4jvF9I93y3GFyxG3yjvws7A3y5Zw4vvrnFyFyYkrykCrWUGFy3
        JF42qrn8uFy7tw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jllkxUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqgVssVr7syzLpgAAsh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

In function s3fwrn5_nci_post_setup, the variable ret is assigned then
goto out label, which just return ret, so we use return to replace it.
Other goto sentences are similar, we use return sentences to replace
goto sentences and delete out label.

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

