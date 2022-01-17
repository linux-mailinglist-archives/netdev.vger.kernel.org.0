Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5B490FE6
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiAQRua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbiAQRu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:27 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A64C06173F
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:27 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id x83so11534572pgx.4
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iEgjwO21tklJU+rA01ZKNx+SZWk9A5aVEz+AGzdHYvI=;
        b=fK7Um/ANqMdjWCUCOlSlg3CFo9/bV6ObC+d5vK/HGT+QXlwlCgAoeF/jgmO1op9GVJ
         0hh78YQZuWeET7bIFlEMdHW7N84We+Pmh9QcL//M7OvDtgcEoe9RzY2xEPpXwlMVi2y9
         JlQtMFUQ7KzFv4XhsgAEu4pSMynSZZigWUbdA44Mtj7LNEFfUDaBfVPWwFCh8BsZzPEL
         LtFj/zNB7uebd5+ohCCOu+Yowppb4tr18v/43dZeemn9VH30wZu15QFJyfVQMyHUb1ub
         UTPo7AVtBcT9MBfsgpEM5iUf5eOU0/3vejtmUlkXZPwZ3clKEFcznC2F19ffhd71gr8W
         EtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iEgjwO21tklJU+rA01ZKNx+SZWk9A5aVEz+AGzdHYvI=;
        b=VvuvYIbHLaHaUAj6XxHRE52V1ePnySaPFRthXQVE2eR1hTKHvjC+9PJVUYISWE/OhX
         5+Z7msvFXvV7n0I9gXxE1UV/3beENxq2lmWGD669zqKBlp/Hw/EvH7CQ9Mxo+UuGpBvR
         GHbiz2qjurVk05CTayhVQ/X5VGNffds22+dnEvsm0yO7i+SMOxGs4Y9MIzvO4j5q2yur
         e8V74ziedNYsVTIWEqSR5WwQ1oAA3yh0qwDnKD+hn/0UQR0DOeG+dEvyPe4NwmkQHrYk
         qoOJVCqLKgme9No3vOutytuB1ei+t23TnCW05OnZSq5kV6jZbCZekjrS9SB7kQLWLvSN
         9vtQ==
X-Gm-Message-State: AOAM531M3qnAMuS/FE10zY5aJ1qJsn+m8l1/ok1ISNXfaCvBVza2SZ8S
        Amr+kts6XqXwbX9K4jzJ6wXED4xuDF7P3A==
X-Google-Smtp-Source: ABdhPJxkdd3edydZhJm/0p/7OPC/GPDNgVUrfKcmuyYpKhwsZc0ifhOrhjrBKG38cQJCLQeN0+HIRQ==
X-Received: by 2002:a63:b24b:: with SMTP id t11mr19827037pgo.444.1642441826766;
        Mon, 17 Jan 2022 09:50:26 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:26 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>, elibr@mellanox.com
Subject: [PATCH v3 iproute2-next 05/11] tc_util: fix clang warning in print_masked_type
Date:   Mon, 17 Jan 2022 09:50:13 -0800
Message-Id: <20220117175019.13993-6-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
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
 tc/tc_util.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 6d5eb754831a..cdc3451cdc09 100644
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
@@ -794,27 +791,14 @@ static void print_masked_type(__u32 type_max,
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
+	print_string(PRINT_FP, NULL, "%s  ", _SL_);
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

