Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1376EF8E4
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbjDZRCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjDZRCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:02:39 -0400
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1572119;
        Wed, 26 Apr 2023 10:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682528554;
        bh=0ro1Q2CF1xQNb/gy1AZ9jBw1NdDwfeHCr8UBHwGTDEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=sGYNlJvfZL1S4c5L9514lxhRSW6uhRS0Dhu1OeDJawyUUxLJlqZMf21UgbaHYGTV6
         88n2BL21MoXz5c7uMMiNWKxcIwP22GIoDwAV6sMnjlzw9Tz2lRLgml2eALm6wJfhIg
         b7EivUrz+PSFXdSYOpyqNJr6rVlL/wswyD7dWOZo=
Received: from localhost.localdomain ([220.243.191.11])
        by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
        id 9828290; Thu, 27 Apr 2023 01:02:24 +0800
X-QQ-mid: xmsmtpt1682528550tplh0530s
Message-ID: <tencent_53140CC2A3468101955F02EB66AA96780B05@qq.com>
X-QQ-XMAILINFO: NQR8mRxMnur9AFHCJt/ESyJGljtOI6Xc4QiXqADCvD/cQLntNbWeQ+s+l0qEak
         /Hp1mn4qGFLI2z0KMPEIOs/UhP7AEmnH00KqH4Cws1XmLtJoe5O9xWs2acXlP4fcIddaet7mzWGV
         cvRzp6wOUCV6Vnk2H17WLl/ORqpb8VrOi3gEc1ZJhmcKP0lgOHFE5AO33DAlvzkI9Ji5l0yZaWgp
         f5OTge2pH4ae4mYBj7FR7MGyZiyR3tew6KCwWLXDQ0YrnS9m4RHtqOsbFURDnCop5shwqhok1iOx
         t/yHtqgrCA0u97+qV2tXs8dsy+ytNB1TaRtqhSmuJcHJArrowfxvSEYXhmKanO42m3xXZKoDCUBQ
         YGijkZ//GJU4Yk+e/2Rp7rdwY2ZHg+E8Bf0l14hF4wwPQ6twaU8bymGt6nOewM+qrW0DUH5Ay5zV
         7s2ZsLKnHbxMiYzfVYDSYcn5nOFbnhKZQ3Thbz5eDkpSxGFFSC5JjrUkauwrTwTJebYGb13yAgXR
         lhssJVD42BKIY+LtWsF9MHBW93YSnSxLxgiZklGIwTyDwCuazFhvVZiSTSyTxKg1E50FcDD3sVPB
         2TVJ+UEkNyO9aZpsTWIWiXBzn/+h3BVZ7OamvjRnkzqmjEsZ2400nfm4uA3Nb37wiKiSGAsaQRb6
         y+tKee0Jq8clqFntC6fMaU5WVISmPLPkUMdeZeN+Uf8RofwzLqvoPDRimdX/E31xOeRvJzLSMJEa
         xdxP2apxaTKbtcgzy/ELZuf257SHprejURxvgr5NYmW1N32KA07maLdhprdtczzGZZLxK5LIi76A
         iijeWtof3CtcMFZq8LXCt3a4tewjb69eSdak0FYZc1XeHNjR5ZS6w+7rPwFLgKuWFPtDcXbmz3AD
         qQQrEqBDCDiZZ+zQ7BbhO9HIAycmr5pJ/W9TXFJHlxB44O5iLdTkH5SHLYuG7WkBeqoBE8ykqu/D
         96RKDCHvETeIbzHynul9loo7SSnKlIF2060SmUN+4n5TAkWZdrAwd2OpC8IIuc4q3MbxLcCYq8vU
         smc0ej8woreK1ghDa4
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     pkshih@realtek.com
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH v3 2/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*
Date:   Thu, 27 Apr 2023 01:02:21 +0800
X-OQ-MSGID: <476f196ff13885460e81bc5c7511d9fc4a0c66a1.1682526135.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682526135.git.zhang_shurong@foxmail.com>
References: <cover.1682526135.git.zhang_shurong@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user or user-provided data
buffer is invalid, rtw_debugfs_set_* should return negative
error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 55 ++++++++++++++++------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 3da477e1ebd3..f8ba133baff0 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -201,13 +201,16 @@ static ssize_t rtw_debugfs_set_read_reg(struct file *filp,
 	char tmp[32 + 1];
 	u32 addr, len;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	if (ret)
+		return ret;
 
 	num = sscanf(tmp, "%x %x", &addr, &len);
 
 	if (num !=  2)
-		return count;
+		return -EINVAL;
 
 	if (len != 1 && len != 2 && len != 4) {
 		rtw_warn(rtwdev, "read reg setting wrong len\n");
@@ -288,8 +291,11 @@ static ssize_t rtw_debugfs_set_rsvd_page(struct file *filp,
 	char tmp[32 + 1];
 	u32 offset, page_num;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	if (ret)
+		return ret;
 
 	num = sscanf(tmp, "%d %d", &offset, &page_num);
 
@@ -314,8 +320,11 @@ static ssize_t rtw_debugfs_set_single_input(struct file *filp,
 	char tmp[32 + 1];
 	u32 input;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret)
+		return ret;
 
 	num = kstrtoint(tmp, 0, &input);
 
@@ -338,14 +347,17 @@ static ssize_t rtw_debugfs_set_write_reg(struct file *filp,
 	char tmp[32 + 1];
 	u32 addr, val, len;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	if (ret)
+		return ret;
 
 	/* write BB/MAC register */
 	num = sscanf(tmp, "%x %x %x", &addr, &val, &len);
 
 	if (num !=  3)
-		return count;
+		return -EINVAL;
 
 	switch (len) {
 	case 1:
@@ -381,8 +393,11 @@ static ssize_t rtw_debugfs_set_h2c(struct file *filp,
 	char tmp[32 + 1];
 	u8 param[8];
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	if (ret)
+		return ret;
 
 	num = sscanf(tmp, "%hhx,%hhx,%hhx,%hhx,%hhx,%hhx,%hhx,%hhx",
 		     &param[0], &param[1], &param[2], &param[3],
@@ -408,14 +423,17 @@ static ssize_t rtw_debugfs_set_rf_write(struct file *filp,
 	char tmp[32 + 1];
 	u32 path, addr, mask, val;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 4);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 4);
+	if (ret)
+		return ret;
 
 	num = sscanf(tmp, "%x %x %x %x", &path, &addr, &mask, &val);
 
 	if (num !=  4) {
 		rtw_warn(rtwdev, "invalid args, [path] [addr] [mask] [val]\n");
-		return count;
+		return -EINVAL;
 	}
 
 	mutex_lock(&rtwdev->mutex);
@@ -438,14 +456,17 @@ static ssize_t rtw_debugfs_set_rf_read(struct file *filp,
 	char tmp[32 + 1];
 	u32 path, addr, mask;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	if (ret)
+		return ret;
 
 	num = sscanf(tmp, "%x %x %x", &path, &addr, &mask);
 
 	if (num !=  3) {
 		rtw_warn(rtwdev, "invalid args, [path] [addr] [mask] [val]\n");
-		return count;
+		return -EINVAL;
 	}
 
 	debugfs_priv->rf_path = path;
@@ -467,7 +488,9 @@ static ssize_t rtw_debugfs_set_fix_rate(struct file *filp,
 	char tmp[32 + 1];
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret)
+		return ret;
 
 	ret = kstrtou8(tmp, 0, &fix_rate);
 	if (ret) {
@@ -860,7 +883,9 @@ static ssize_t rtw_debugfs_set_coex_enable(struct file *filp,
 	bool enable;
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret)
+		return ret;
 
 	ret = kstrtobool(tmp, &enable);
 	if (ret) {
@@ -930,7 +955,9 @@ static ssize_t rtw_debugfs_set_fw_crash(struct file *filp,
 	bool input;
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret)
+		return ret;
 
 	ret = kstrtobool(tmp, &input);
 	if (ret)
-- 
2.40.0

