Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA83C6EB88E
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjDVKTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDVKTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:19:21 -0400
Received: from out203-205-221-249.mail.qq.com (out203-205-221-249.mail.qq.com [203.205.221.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FEA1FC0;
        Sat, 22 Apr 2023 03:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158739;
        bh=z8S0DFiFjCmjZMlMnT7AsuASmakTQv+zP2mNvAbhkDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DQDIlvGj+k291zGMDr/BTa6A+qH4C6wKfS4EkpINPNVquKfvHMdMuMg5t18SWdnpN
         HWb/J87/+ObFVhO9dGlfNK7W1kYswTHn6iQtnlgzMzBICGNfGCpXWOqLbFlPqG+EoI
         sY+cRI3PLhH39ELnm6X22MxSgSmyntEjE3G8oQAc=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157928tfv627lfy
Message-ID: <tencent_588107D54A02EA06A1D67C6B118CC3A35805@qq.com>
X-QQ-XMAILINFO: MpSLeT6aCErC+jUWDBvMxzccUdI/jjD4NwtJ4TEOo9iC1GERxc1SIoBgPLOzb1
         eYZVK8tjnJcAtnFGp+jh71Ub6LDEAue2FU69fnC1yHEnSiPkV3diI4bgrnAW00snShYC3ahuBegP
         Jgd8avl24nIYPPpMNYy5c/Tys0+qNAUdnNKZXRD69IBfbH8DQnUeHu43m3gH5/mPNwoZkXB75b/H
         bL1d0gL4lbXbKvqiGBF+lZNL77hsk35BAJsNHdMbcwK7E5T7XHt+W4vuLQaMEZaWQjZ1S/22iGpe
         ocX5Qvyfi3sf9EA3KbljpcgTxn3MOLx4trU+urrlivq+8tyzQO5j+hNKpFp4m9vdEckHLIoGtUH6
         679lUgq7gs1c43NVoI7jE+34yvtiDZLK0zNO7mWXC/GVTjV9czGM8sQWutr9M5YAzYCxCjcoB+ze
         78zIrhj7mzNsgTx2OXOuFDOJLX8V1KC6nUu/mVsAu2B+HglqwpXTr38NNbAxgyRYS+L1yprfb/IR
         3NzkP4JWOgVkbuxLjebKItwbRMuerQz3WtIUJYMrtpGRNYSiAwnail9afXkss4H+UC7amCod4Y0C
         60waM7134L98FOzSL6TH5t8QiqcbDUzhac6xo0ApMNCpref6AF/4K/9Q2AnGty7n//hszOpCDFfY
         ma1Gg9hp9WPMV0KwdAcXXi61qc3QOldIdDk9+LtzvdYdnTdgDReDQHG3Dgu1DkSp5SKN64VYQsOv
         KJJrbodvI8O9Jf7s+sy7NeXv4LdTiypYuLDaPUXpspknbuB3i4eIiyyvci2pgHBQbxMXm3K+2Aa0
         eRIiDhz/K+FFN3zj3zJ3bUwmIuSjX44SK1BMDZjaWgcwqwJTaj7A/UnwL2a9SFkyt/99HwRFdLua
         SKzMLzwlgdBnWpRcLq7EjqGPwF5ovi2fR74fnXsTflEpKPekaK9ZveoMxYX5NvsWrMlZup6lVtjQ
         uBoyLBCA0gL+dQl6lL3gN+Vmt64E1mnX/J7lVZzjMSZuD+LymUR8AsW9ECDyYguoT6FU1hUUYTj5
         9q6a5Gylu/qxrlh76haqSaEfyt1jGiCNJRWJBI2w==
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 06/10] wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_rf_write
Date:   Sat, 22 Apr 2023 18:04:50 +0800
X-OQ-MSGID: <f2fc025197b5643beee3f7e5fc04ddaa07edcc97.1682156784.git.zhang_shurong@foxmail.com>
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

If there is a failure during copy_from_user or user-provided data
buffer is invalid, rtw_debugfs_set_rf_write should return negative
error code instead of a positive value count.

Fix this bug by returning correct error code.

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
---
 drivers/net/wireless/realtek/rtw88/debug.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
index 911f0514c497..259e6c15bc78 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.c
+++ b/drivers/net/wireless/realtek/rtw88/debug.c
@@ -423,14 +423,17 @@ static ssize_t rtw_debugfs_set_rf_write(struct file *filp,
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
-- 
2.40.0

