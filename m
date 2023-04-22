Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD256EB876
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjDVKMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjDVKMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:12:12 -0400
Received: from out203-205-221-249.mail.qq.com (out203-205-221-249.mail.qq.com [203.205.221.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19AA271C;
        Sat, 22 Apr 2023 03:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158308;
        bh=AiHaweSI9v1B2EKsrPZKFyxUxyDMJ+lDNtxzoXG3z3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Q8sl5ZZPJOS+KLV3bMXaR0lxI1BGXiSd6vwlYmevTTHOOwNxer6PH5lPDSOoKaVcL
         u+xQ+hsHj5L92Srh96a+OzHBUyqL0fpiOcN91rcs4UxGhv8EONjJK7SnxAHOK4dv8G
         k3DfmpYWEFSrix2nQDqeH054dk8UFcKoXH4VBmUE=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157926th7ubsyc9
Message-ID: <tencent_0560341E420A95A81E12CC3712B5305B0508@qq.com>
X-QQ-XMAILINFO: OUycJhUUya+/p9YnDt4faZAK2QKOb4v+LDStxlHMcQvroFSprUYeyZVfVKi/bd
         C9bgOAwgE3UGY1RYgsa9yHqX6S82AN6q9JSVnJJuoMdCGLkFUnNpEB+Q1wrdZruvy+s+aphs+QZ0
         Np/x8sPaW9yo5DX4TMa3Hm/yAIYhsyQUx34C04PqUIHrp9MckNkeUhWGLT0rtGWnRei559pefsdM
         6ULaQkcoaB46kHR+ClBMO9ol6T6zJu1W9/go9JfASKkyKfVHkAHcuRcvDtQrkrQ837EOOYaQwUI9
         ZzEterk4XGbSeiuHm5c+Eb3gmoqClDZxocN6C81E7o4PyuPkLm2BL4SzKBXQ96z9fFAtTZL9BlUI
         dvPHC3NW0yGnfbxokZEeV+I+FEvHpLBmtXLsjFzkXQjURoTFTjTzi//A6WqXQVg49xV7MM04MH69
         q2VetfKaScahmX73YcpSD1LQFBu7yrdlvPsrcq0fdEKxzPgrWMioddzaIWHEDu7ZgL6THVl7zgG7
         HQORpAZoX5hipnCnRw9mGJ03Ry94fHGEbEAH7ULvIMU1wZ5b9AXKS/VzOrpDWjvoGiFCdymZU9Ry
         kg3MIIUTAHZho5HaiYxVFTbYZaMwHTypH0kY8sHrkDPf+9Ltsf3U7mQxmWyrVYfgiIXCKPNWfmAS
         HwsGZfuulSc1bbZSrUo7AkYbEEkuYmeihEcpPmyC7hpxYsXGTCtNfJUiScLM/Y/1U+jmFsZkPJQx
         fork2jgxmTIqNAFHdFPKb7foUJwrxFd9r9V+DTynsRIJ0ipjzG5mJfcikQqu6uS32JhmctQQlCuA
         c9Ju8ndXDhwGbl9XV5qIuAUNSqeX2XgmAxj3bAKhVxSCkE9uGi4JJr13gHE/rD9Q25ugUXnEXtGv
         pHpt9+uCBMY0w4b07jlOZdwMu5A8Ea+uWsMwTmedIxOJ3V0hmIN5C52pbDF73DIw89qCYSTgxnjT
         FJf4q5PkjTRNTom/5s5R+d5Fr0e+merkgS+Frj5VacKPBQVBudwreBIPPRdog+6t/h5RLwICDXmV
         SEUDmm2dipcuRLWGiOTFex4HUAJaHBYOE1L+JCzo8yhFIZHaVf
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 05/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_h2c
Date:   Sat, 22 Apr 2023 18:04:49 +0800
X-OQ-MSGID: <71d87586fb8e306ea9ed5ccde7e5a98be52e4c0c.1682156784.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682156784.git.zhang_shurong@foxmail.com>
References: <cover.1682156784.git.zhang_shurong@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user, rtw_debugfs_set_h2c
should return negative error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index f721205185cf..911f0514c497 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -393,8 +393,11 @@ static ssize_t rtw_debugfs_set_h2c(struct file *filp,
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
-- 
2.40.0

