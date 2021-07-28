Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530B23D85A4
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 03:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhG1BtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 21:49:08 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:19882 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhG1BtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 21:49:06 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.5]) by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee96100b76fcf6-9f7c1; Wed, 28 Jul 2021 09:48:31 +0800 (CST)
X-RM-TRANSID: 2ee96100b76fcf6-9f7c1
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee36100b76beda-518dd;
        Wed, 28 Jul 2021 09:48:31 +0800 (CST)
X-RM-TRANSID: 2ee36100b76beda-518dd
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     k.opasiak@samsung.com, davem@davemloft.net, nathan@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH v2] nfc: s3fwrn5: fix undefined parameter values in dev_err()
Date:   Wed, 28 Jul 2021 09:49:25 +0800
Message-Id: <20210728014925.1680-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function s3fwrn5_fw_download(), the 'ret' is not assigned,
so the correct value should be given in dev_err function.

Fixes: a0302ff5906a ("nfc: s3fwrn5: remove unnecessary label")
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
---
Changes from v1
 - Modify the code in another form
---
 drivers/nfc/s3fwrn5/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
index 1421ffd46d9a..1af7a1e632cf 100644
--- a/drivers/nfc/s3fwrn5/firmware.c
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -422,7 +422,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
 	tfm = crypto_alloc_shash("sha1", 0, 0);
 	if (IS_ERR(tfm)) {
 		dev_err(&fw_info->ndev->nfc_dev->dev,
-			"Cannot allocate shash (code=%d)\n", ret);
+			"Cannot allocate shash (code=%pe)\n", tfm);
 		return PTR_ERR(tfm);
 	}
 
-- 
2.18.2



