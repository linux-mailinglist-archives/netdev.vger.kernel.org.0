Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DDF3A225A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhFJCsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 22:48:20 -0400
Received: from m12-18.163.com ([220.181.12.18]:58568 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhFJCsS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 22:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=qQF+Mfd/W4sXUIec0/
        FlJ4NKUAQca2lB2YNmUFlOk5o=; b=CQK4R+oq/f+CLZV6c6Xay7Os2VYlaIT9lL
        g5Eb77AIXKTx6qojodfLftWBFHR+yt2IaAcnzlp/0pCWrkjxO01VoKlmG5b38Juu
        W+7bhL4SKvyDGfHbOzVJryR7l1EXdtWK/gRfqwJHbq6IkxqH094QIbz9iPrAOC0w
        fFpYau4BY=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp14 (Coremail) with SMTP id EsCowACnr9fvfMFgYRxEog--.31055S2;
        Thu, 10 Jun 2021 10:46:10 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, unixbhaskar@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: fdp: remove unnecessary labels
Date:   Thu, 10 Jun 2021 10:46:16 +0800
Message-Id: <20210610024616.1804-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EsCowACnr9fvfMFgYRxEog--.31055S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18Cw43CF47XFy3Ar18Xwb_yoW8Gr1UpF
        45XFWqyr4rJ3WrX3Z8Ar4DZFyYga1xAryDGrWxt3s7AF45trn7JFZ5tFW8ZrWxurZ5Gw12
        vF4qqwn3ua1jqw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jpWlkUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiqwSjsVUMZnxVgAABsq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Some labels are meaningless, so we delete them and use the
return statement instead of the goto statement.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/fdp/fdp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index 7863b25..5287458 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -266,7 +266,7 @@ static int fdp_nci_request_firmware(struct nci_dev *ndev)
 	r = request_firmware(&info->ram_patch, FDP_RAM_PATCH_NAME, dev);
 	if (r < 0) {
 		nfc_err(dev, "RAM patch request error\n");
-		goto error;
+		return r;
 	}
 
 	data = (u8 *) info->ram_patch->data;
@@ -283,7 +283,7 @@ static int fdp_nci_request_firmware(struct nci_dev *ndev)
 	r = request_firmware(&info->otp_patch, FDP_OTP_PATCH_NAME, dev);
 	if (r < 0) {
 		nfc_err(dev, "OTP patch request error\n");
-		goto out;
+		return 0;
 	}
 
 	data = (u8 *) info->otp_patch->data;
@@ -295,10 +295,7 @@ static int fdp_nci_request_firmware(struct nci_dev *ndev)
 
 	dev_dbg(dev, "OTP patch version: %d, size: %d\n",
 		 info->otp_patch_version, (int) info->otp_patch->size);
-out:
 	return 0;
-error:
-	return r;
 }
 
 static void fdp_nci_release_firmware(struct nci_dev *ndev)
-- 
1.9.1


