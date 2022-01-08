Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80104885F6
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiAHUrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbiAHUq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B60C061401
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:59 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so16979973pjf.3
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2C+2eEriNgfUMFK2tfl8QCL4ko+C8d9Iz4dkqd/S39I=;
        b=y/gCiyW8ZHIXMsIbefnUkbUIRfIIXRiu9UkcVQmEZq/fPhTK2xMwzotHViEBbapWg7
         IrXKy3THpyZ96XgnfQ9AJMVqrQVqHGeI6LQgZmIKGeOW8v0DQ94EvcN4JmLEia8ymMxo
         2qTDTzwDT5zzrMqfcWolaupiJ5nqqothZ6Y4W5KEWPcQAP3N9hJ0/OYkctC67DL8RKdY
         ROhl2iHi9eakEK1zbejh1+SUIvIqJF+OdAFpnxWbSxTo05qgOI4CrRTVaOHeQlE2g7av
         NSG6uNKlh5/5W7wbWfYg+8vuqM7yqQ1WiSkrC/nGXJmWhsS46f2WS0K9r+6MDS8eCcEK
         JZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2C+2eEriNgfUMFK2tfl8QCL4ko+C8d9Iz4dkqd/S39I=;
        b=Mtamb0lP6Bb2HZh2Ftkam0Dmh8CwXrfA6eMfzVRMEFI0X7Zb72AdvkJDjqVPjabS6m
         Esvxf0cWnwkJdLnTv5Ou4ef4kgw9HHW1ELRxJsAnmEr3HzqOEtYfa4SVCOiV2rScgGYC
         alDdGNBZutVK8i33MWWd76qhTwD/YYr0lBbRkxW3L0ljlM1TpPEpkhqV5dju6yapQ7i0
         2I3ryJ69bjtwDuVkIbSPTmx0vQFxALKjDdyNl2mrLhLRbHDnAtzsLXbN/uCEH0SRnzMJ
         WRoswiZgFGqlGPHShd7sbeO1Ux9UKxh7Ebo4dz3k/cmx27QQMrLFbmiEox/ENoaCyr2k
         tQMQ==
X-Gm-Message-State: AOAM533Ey3fyCPkg1RX06Bzw+LSCZoYIYvKG+lX26Ao1yplCIIm5ja8W
        lX9ME06Zxr9rD5cHLkrBPwDawPD0Wm0x/g==
X-Google-Smtp-Source: ABdhPJwWEIXXPyzahWT7lThJ27KVK8mTTSOmxNdB0ByAJdPkcG+FiLfFwQATqUYyHjQ/2CDYiGX29g==
X-Received: by 2002:a05:6a00:2313:b0:4bb:8b68:3677 with SMTP id h19-20020a056a00231300b004bb8b683677mr69098381pfh.2.1641674818254;
        Sat, 08 Jan 2022 12:46:58 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:57 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>, elibr@mellanox.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 07/11] tc_util: fix clang warning in print_masked_type
Date:   Sat,  8 Jan 2022 12:46:46 -0800
Message-Id: <20220108204650.36185-8-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing a non-format string but the code here
was doing extra work the JSON case.  It was also broken if using oneline mode.

Fixes: 04b215015ba8 ("tc_util: introduce a function to print JSON/non-JSON masked numbers")
Cc: elibr@mellanox.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 6d5eb754831a..c95b6fd6e49d 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -783,7 +783,6 @@ static void print_masked_type(__u32 type_max,
 			      const char *name, struct rtattr *attr,
 			      struct rtattr *mask_attr, bool newline)
 {
-	SPRINT_BUF(namefrm);
 	__u32 value, mask;
 	SPRINT_BUF(out);
 	size_t done;
@@ -795,26 +794,21 @@ static void print_masked_type(__u32 type_max,
 	mask = mask_attr ? rta_getattr_type(mask_attr) : type_max;
 
 	if (is_json_context()) {
-		sprintf(namefrm, "\n  %s %%u", name);
-		print_hu(PRINT_ANY, name, namefrm,
-			 rta_getattr_type(attr));
+		print_hu(PRINT_JSON, name, NULL, value);
 		if (mask != type_max) {
 			char mask_name[SPRINT_BSIZE-6];
 
 			sprintf(mask_name, "%s_mask", name);
-			if (newline)
-				print_string(PRINT_FP, NULL, "%s ", _SL_);
-			sprintf(namefrm, " %s %%u", mask_name);
-			print_hu(PRINT_ANY, mask_name, namefrm, mask);
+			print_hu(PRINT_JSON, mask_name, NULL, mask);
 		}
 	} else {
 		done = sprintf(out, "%u", value);
 		if (mask != type_max)
 			sprintf(out + done, "/0x%x", mask);
-		if (newline)
-			print_string(PRINT_FP, NULL, "%s ", _SL_);
-		sprintf(namefrm, " %s %%s", name);
-		print_string(PRINT_ANY, name, namefrm, out);
+
+		print_nl();
+		print_string(PRINT_FP, NULL, " %s", name);
+		print_string(PRINT_FP, NULL, " %s", out);
 	}
 }
 
-- 
2.30.2

