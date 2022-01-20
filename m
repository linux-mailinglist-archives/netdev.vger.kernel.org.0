Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055614955D4
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377773AbiATVME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377774AbiATVMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:02 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842A4C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:02 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id c5so6337444pgk.12
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1nEsFJLJg2vcd3p5d51yw97QENDl2n12W9wExXuCur0=;
        b=pMk2S0XhMkwE/+d8Br9dd80IYJE1U45epYeLpSqPEkofxtJ2yaRmUzyHWNDinyf114
         xFUVnQZC77ZNL8ZDnWlkl4aZD+/7ftiICDcq+ALlPgTXXaomo1RifGTOlbdg0kcmiYbW
         Uvr2/xvLa43PMFiq4Zq9ik3CNl6cnV1iTYcdZ29fyZ7uNPSOake5plTkWX6tMO4OV0DL
         XWVgUyVhwzw3tK5WQxH9ig/WZaTI2e328TVLwpieu7j8CiJU/qiXtssSbAyEYA3WEEXo
         0/IDELgAWS2pINPhzIG9JOniMXrLEXg5X1ZofsfKPKwbI2/4+FTLFbCx2PnLBR3Lpke/
         KeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1nEsFJLJg2vcd3p5d51yw97QENDl2n12W9wExXuCur0=;
        b=xaooXgG7fVpaHpGd+jbmp1Qsv0gfERyTtH+YdyOYzRv/TyjQ9JV/E1+4Nb0uuMMUvl
         qye3WgdIIfqIeUI/PokXmNmDreVmPkfP3JLtxahNjAQCakJ9bCiPztC/7at1eMJ9p9a9
         whPDlY8kRzmTGG2r6EjMdSzzhG6lEEP6AweTce6DevGMQDZeEM55ShvLxKDktvsZdCl+
         GZYKfdreeHwtSs2icHu81qe9Cl4r3/4/XbuVXOMEG+UlQQgYC/ZXtKToWJiQQOsLSaNx
         27LgXtibiUGp5U/Y4JUcurgpMr+MjiGKQ6XKhSZvcofLExsFjLntMw6kwJWY3KI2u+kc
         k+6w==
X-Gm-Message-State: AOAM532s9otx2dQc9RemBkk+S8v847TWtOp/rSYxCm03biOp0gINDf9v
        WMki5uJGESPLGc/ITVOoGsQw7vsLcm6krA==
X-Google-Smtp-Source: ABdhPJwszL67QEiDzF8RJ/7n/cmP5ieLyAwxFzVeExErJumYR112tEHQgeKsAYZuLIckA9IgkQeBrg==
X-Received: by 2002:a65:6859:: with SMTP id q25mr506618pgt.452.1642713121702;
        Thu, 20 Jan 2022 13:12:01 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:12:01 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>, elibr@mellanox.com
Subject: [PATCH v4 iproute2-next 05/11] tc_util: fix clang warning in print_masked_type
Date:   Thu, 20 Jan 2022 13:11:47 -0800
Message-Id: <20220120211153.189476-6-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing a non-format string but the code here
was doing extra work the JSON case. Using print_uint_name_value here
makes the code much simpler.

Old code was also broken if using oneline mode.

Fixes: 04b215015ba8 ("tc_util: introduce a function to print JSON/non-JSON masked numbers")
Cc: elibr@mellanox.com
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_util.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 6d5eb754831a..78cb9901f7b9 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -783,10 +783,7 @@ static void print_masked_type(__u32 type_max,
 			      const char *name, struct rtattr *attr,
 			      struct rtattr *mask_attr, bool newline)
 {
-	SPRINT_BUF(namefrm);
 	__u32 value, mask;
-	SPRINT_BUF(out);
-	size_t done;
 
 	if (!attr)
 		return;
@@ -794,27 +791,18 @@ static void print_masked_type(__u32 type_max,
 	value = rta_getattr_type(attr);
 	mask = mask_attr ? rta_getattr_type(mask_attr) : type_max;
 
-	if (is_json_context()) {
-		sprintf(namefrm, "\n  %s %%u", name);
-		print_hu(PRINT_ANY, name, namefrm,
-			 rta_getattr_type(attr));
-		if (mask != type_max) {
-			char mask_name[SPRINT_BSIZE-6];
-
-			sprintf(mask_name, "%s_mask", name);
-			if (newline)
-				print_string(PRINT_FP, NULL, "%s ", _SL_);
-			sprintf(namefrm, " %s %%u", mask_name);
-			print_hu(PRINT_ANY, mask_name, namefrm, mask);
-		}
-	} else {
-		done = sprintf(out, "%u", value);
-		if (mask != type_max)
-			sprintf(out + done, "/0x%x", mask);
-		if (newline)
-			print_string(PRINT_FP, NULL, "%s ", _SL_);
-		sprintf(namefrm, " %s %%s", name);
-		print_string(PRINT_ANY, name, namefrm, out);
+	if (newline)
+		print_string(PRINT_FP, NULL, "%s  ", _SL_);
+	else
+		print_string(PRINT_FP, NULL, " ", _SL_);
+
+	print_uint_name_value(name, value);
+
+	if (mask != type_max) {
+		char mask_name[SPRINT_BSIZE-6];
+
+		snprintf(mask_name, sizeof(mask_name), "%s_mask", name);
+		print_hex(PRINT_ANY, mask_name, "/0x%x", mask);
 	}
 }
 
-- 
2.30.2

