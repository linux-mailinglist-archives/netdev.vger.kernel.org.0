Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC946C92A2
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 07:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjCZFbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 01:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCZFbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 01:31:48 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B37B977B;
        Sat, 25 Mar 2023 22:31:47 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-17aeb49429eso6054540fac.6;
        Sat, 25 Mar 2023 22:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679808706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uGppKiinrdkgyLU6jTn9Eaau1zWJ7BP+dnbPug9RFwk=;
        b=kJBXpyzd0CitlplY+cqgB1q8q7L/f3fJHlsnpRjyTPvTd0Vr8Ye++g4uurDRhG86ZH
         Ngw8QqJFkchOAeiPkFZsQmhlJhX5CmZyNsbEtPLicBiPCAnzTsxLT5dZjIHX38p0fu7T
         McnHqwW9s0hcxh5FjIkFoxUXEix0OXH1QfyAohmtNs+BYFEWrtm8hLF8YIEXkhPp5LG9
         OvhmxfiB8YXyLeQCibjykJDoPdMkbgbbDR+klOSrbgEYUNpQzuTnEUO2ZPEh1jtzX/ep
         HV4NDBYGZnofQrZqgXGnAoqUbEYNASCHvVerBjaBY3O6UUgIzq9YMB/Kzki88h27DwPt
         47LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679808706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uGppKiinrdkgyLU6jTn9Eaau1zWJ7BP+dnbPug9RFwk=;
        b=vJdSt/L9nOwtnzgTRLPha4NWJq1slkeTI61Z0j+HE+6SH+ypUl0SCYSVO1XzRCB7nO
         os+WagwuE63Nc2CzFaW/vRxi5BQFj8x8ddRiKNM8yxc8HtlUa0FJeJJDLJS8WGc0BJtE
         1tEqiRxJ0B/vAYkci9tvzwGJV4kxXcx4DjYc+pdP1u0zoOs5MWysOhvXzXbaNWFd1OVq
         H5cOX1jUxsnAYYuocYDQuEYHv2ftdrC5bONs2JqSAep4flwjxs/3p6d3GKBohTV1rFCX
         WyF7xQ9DIYCRL47rladMOsufmKxTqHrrkRMRK88bH+o+/Yi70WDzcazyAMf7IXNy4Mot
         p/3g==
X-Gm-Message-State: AO0yUKWQX9somkpfu64kXqMG6gECUb7oJli6XQYHxfoxRsNgsR6ZvH0V
        UOR2f2eoywCIWHQqhRU+B54lV2Z+mMDJ0g==
X-Google-Smtp-Source: AKy350YwQqckdjVScn9cjqjrEjCac4S7z9eeXlXs19+pM3dtgpR8cKBRmWn9qkRVXFYcar8BLwGvPA==
X-Received: by 2002:a05:6870:c0d3:b0:17a:b61a:4300 with SMTP id e19-20020a056870c0d300b0017ab61a4300mr5338173oad.22.1679808706596;
        Sat, 25 Mar 2023 22:31:46 -0700 (PDT)
Received: from chcpu13.cse.ust.hk (191host119.mobilenet.cse.ust.hk. [143.89.191.119])
        by smtp.gmail.com with ESMTPSA id hv12-20020a056870f98c00b00176209a6d6asm8729329oab.10.2023.03.25.22.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 22:31:46 -0700 (PDT)
From:   Wei Chen <harperchen1110@gmail.com>
To:     pkshih@realtek.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH v2] rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()
Date:   Sun, 26 Mar 2023 05:31:38 +0000
Message-Id: <20230326053138.91338-1-harperchen1110@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a failure during copy_from_user or user-provided data buffer
is invalid, rtl_debugfs_set_write_rfreg should return negative error code
instead of a positive value count.

Fix this bug by returning correct error code. Moreover, the check of buffer
against null is removed since it will be handled by copy_from_user.

Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
Signed-off-by: Wei Chen <harperchen1110@gmail.com>
---
Changes in v2:
 - Add fixes commit tag
 - Correct the subject prefix 

 drivers/net/wireless/realtek/rtlwifi/debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 3e7f9b4f1f19..9eb26dfe4ca9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -375,8 +375,8 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
 
 	tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
@@ -386,7 +386,7 @@ static ssize_t rtl_debugfs_set_write_rfreg(struct file *filp,
 	if (num != 4) {
 		rtl_dbg(rtlpriv, COMP_ERR, DBG_DMESG,
 			"Format is <path> <addr> <mask> <data>\n");
-		return count;
+		return -EINVAL;
 	}
 
 	rtl_set_rfreg(hw, path, addr, bitmask, data);
-- 
2.25.1

