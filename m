Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3226EE5A9
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 18:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbjDYQYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 12:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbjDYQYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 12:24:31 -0400
Received: from out203-205-221-242.mail.qq.com (out203-205-221-242.mail.qq.com [203.205.221.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6545D161A4;
        Tue, 25 Apr 2023 09:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682439864;
        bh=IDTmH6R2OwB+nQcAtD+Ty/w+VtwcXIHQkO3n55itJrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NX+HKXCq2Sbsb3WL9o1Fo8A+NRjhUAJXVD9M77qucsTwjr2BuhBVbOWG40ANI0wSx
         PbVRoVEVRe6ZYOy7beJSZKH76rTuA7RryW3qqbcg4a9wf161Tj1laNRaD7gVm+czxc
         FKDp6SAB/GMCPBpkBzaghXh9KMr7o+QrzefvS31o=
Received: from localhost.localdomain ([116.132.239.134])
        by newxmesmtplogicsvrsza12-0.qq.com (NewEsmtp) with SMTP
        id 60F0C276; Wed, 26 Apr 2023 00:24:15 +0800
X-QQ-mid: xmsmtpt1682439861tim77xyyv
Message-ID: <tencent_E2DD5600188F8798C22CAA9BC4D08D4FAD06@qq.com>
X-QQ-XMAILINFO: NkHKfw09D6j8SaLeVQ/sV0Dvr/JRRZGPIwo8MAdjXGZaZxNEgBUwD6ayKk/efP
         Y0vH3jVAAoOfZsBm1pYBEQcmc2m75348H6pQCpaPsi0hNr5eOabZ1VJzaF84gCY7BZ5V9F9bog82
         0IZf8SpcW+n1gFBGz9UDb+335g5hlJszsCNmidzSYOSAuRguoP9PBe8nqtmkmlS9L+tjy43itWDL
         IrlZ/0adhbueTurgtsCRricF7vKUTQjkvW77N5Dmn6l8RHkyPWV+gdlRsTjFBbRtNeCqFq/SSehX
         ptrvhB/5eHjMXyxIWDXlL7L/KncUPc2myn6OKJXumJrT8dJsziU2TDpXoM/GPZ2SQbIOHcJIgUMx
         8GBBhemdux6KCYQHpGHHA+UA8GAcmnfp/Pp/jWSGm9STFPVi45+wxphb8oYJlGKQzcKIvlZqHqmI
         96F2Kfd0e6WU9TBaBLe/82857QSj55Q4JSRk0syX3cTafhQAnACLJaKw9HZowvKyn07nl89jS8ia
         LCCmCF7VmiJmXiwyfJqrpNqTvxJ3TIo9IAJBzKL6yYkxf6obWUkg/8UAjUG0nkTI6pFCH0f7WlTF
         LwJbMUrWMpRL+oggkhDvDlHdZM4g65+/lAKmrxZVnCktc+g/6UntFZKaua6mxgSP/KZp13EZi1bD
         5DG4VtptY8aj/W5TXHqOR92ok2CfuBQUI0Yd8VJuzTawuLpiLG7RZctGL3U+JZ65oKk156u4DQut
         rYhdm2J/agd3yuXXbQmcmjeyCGlQJwa/W1tpSXVzZg6HMcHppZNxO2QD93/+gYrzE1k7eao0jMR3
         CYs2sQz5LJ6+sKlSlGemheg64LLUx/c5J8945PWTzIT0yPl7VEzjprObffCm12+ztGmIFLByoXj1
         5a3SQtiBesDBwteqjlhLDzIZod/fSJyMPR90D5L07ov/sdn9Zu4utwdTBlFCtzm6TuP2BHpUP8Cb
         4NJRCl8aZH8RjvW1nDBGKy1uWOmKXLrtCO8cfaKnPQjTGkuh9kwMjvcaWekHCOaXYv188Kc7L29T
         4dW/PIBA==
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH v2 2/2] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*
Date:   Wed, 26 Apr 2023 00:24:12 +0800
X-OQ-MSGID: <b2f299c0f969991f41955a7f9d77ebc37efcaec9.1682438257.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682438257.git.zhang_shurong@foxmail.com>
References: <cover.1682438257.git.zhang_shurong@foxmail.com>
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
index 3da477e1ebd3..786669a092f1 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -201,13 +201,16 @@ static ssize_t rtw_debugfs_set_read_reg(struct file *filp,
 	char tmp[32 + 1];
 	u32 addr, len;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 2);
+	if (ret < 0)
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
+	if (ret < 0)
+		return ret;
 
 	num = sscanf(tmp, "%d %d", &offset, &page_num);
 
@@ -314,8 +320,11 @@ static ssize_t rtw_debugfs_set_single_input(struct file *filp,
 	char tmp[32 + 1];
 	u32 input;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret < 0)
+		return ret;
 
 	num = kstrtoint(tmp, 0, &input);
 
@@ -338,14 +347,17 @@ static ssize_t rtw_debugfs_set_write_reg(struct file *filp,
 	char tmp[32 + 1];
 	u32 addr, val, len;
 	int num;
+	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 3);
+	if (ret < 0)
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
+	if (ret < 0)
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
+	if (ret < 0)
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
+	if (ret < 0)
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
+	if (ret < 0)
+		return ret;
 
 	ret = kstrtou8(tmp, 0, &fix_rate);
 	if (ret) {
@@ -860,7 +883,9 @@ static ssize_t rtw_debugfs_set_coex_enable(struct file *filp,
 	bool enable;
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret < 0)
+		return ret;
 
 	ret = kstrtobool(tmp, &enable);
 	if (ret) {
@@ -930,7 +955,9 @@ static ssize_t rtw_debugfs_set_fw_crash(struct file *filp,
 	bool input;
 	int ret;
 
-	rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	ret = rtw_debugfs_copy_from_user(tmp, sizeof(tmp), buffer, count, 1);
+	if (ret < 0)
+		return ret;
 
 	ret = kstrtobool(tmp, &input);
 	if (ret)
-- 
2.40.0

