Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A461C4885F2
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiAHUq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiAHUq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:56 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F6FC06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:55 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x15so8677454plg.1
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VxcROO/YL7z1OeGPOjZVYFxIeHXhPKmelOrqJjV/+sw=;
        b=tRABf8EeIm9+Q/rBzJCHrAOkSrCfiIGyD4wmbPFWj0wII5O4qmLWG8I//HYJ1RGA3C
         R2ZvG05pFNv/C1/h7xodEGbr3sIghA59h9qO3Z174pvNEQHNVppW5B9VyNluX4O/jhQv
         WxS++g0PEegHxMkL4rRSQp3HCE56YLwU9/ZQjR7+9sXxSigRcCyXPDJ6AP6Ge9SI+Cyk
         051/UYuEuxBOwML9wCnifv1RMsFLIoUD7mH+jhkzShhDSmwQhmki8J4+i/5fnn6p0q6s
         RetWtNPVGnBN8LKzUEsIeE7Hx2aDP93DtHUjHXCnxYyN1GJkjY47YofVYa6Q0DVvZJA9
         tmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VxcROO/YL7z1OeGPOjZVYFxIeHXhPKmelOrqJjV/+sw=;
        b=OT/ebtXrvHvGXBwyjv73qAC2f6s/8N2vx0OeR0kCpOjzZ3bWEVN1bCtVr0kg4H7Vn5
         tIgiQgKnCEYuVA/G22ova3ZlNTAIRT/KXcrL61LnhLtw6N8LsFQZHa+FcmJacE1eyvT+
         G8XRpgatzs3egrxp/KRxVDAKk29XEKa8r8VteLNsEz5LtlsAe4NB8dGwSszDIom2GpVn
         OJTEYrr6OJarvMETSPTPvsNSS88RJxMEyH/XDD/XJQ++6Uq9qwJiYiXB1BhBLUucXAVI
         SEHzvj9f56m0qV11KMOEaPGqarxXRMsQqQsmjIRBE76b+hzL1tnyT4WKjbsq0bTSD/WQ
         oPww==
X-Gm-Message-State: AOAM530VMCx+QX8DUgCPAB50981lYoY44BpkioXuS44O5JjDY9NDLAxI
        1WLIEWuyDmHD97W4Pq5svc5wTW4oOIBg+g==
X-Google-Smtp-Source: ABdhPJwhuWzlXkLP6wGYhUP87Qjkw0D9JnIk9lSe4IOZ2I52QWrnS4zqTT8QI7gPZNsPgpV5GP+BXg==
X-Received: by 2002:a17:90b:4b8d:: with SMTP id lr13mr22538335pjb.0.1641674815023;
        Sat, 08 Jan 2022 12:46:55 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:54 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 03/11] netem: fix clang warnings
Date:   Sat,  8 Jan 2022 12:46:42 -0800
Message-Id: <20220108204650.36185-4-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>

Netem is using empty format string to not print values.
Clang complains about this hack so don't do it.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/q_netem.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/tc/q_netem.c b/tc/q_netem.c
index 2e5a46ab7b25..c483386894ea 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -59,10 +59,12 @@ static void explain1(const char *arg)
 #define MAX_DIST	(16*1024)
 
 /* Print values only if they are non-zero */
-static void __print_int_opt(const char *label_json, const char *label_fp,
-			    int val)
+static void __attribute__((format(printf, 2, 0)))
+__print_int_opt(const char *label_json, const char *label_fp, int val)
 {
-	print_int(PRINT_ANY, label_json, val ? label_fp : "", val);
+	print_int(PRINT_JSON, label_json, NULL, val);
+	if (val != 0)
+		print_int(PRINT_FP, NULL, label_fp, val);
 }
 #define PRINT_INT_OPT(label, val)			\
 	__print_int_opt(label, " " label " %d", (val))
@@ -70,8 +72,8 @@ static void __print_int_opt(const char *label_json, const char *label_fp,
 /* Time print prints normally with varying units, but for JSON prints
  * in seconds (1ms vs 0.001).
  */
-static void __print_time64(const char *label_json, const char *label_fp,
-			   __u64 val)
+static void __attribute__((format(printf, 2, 0)))
+__print_time64(const char *label_json, const char *label_fp, __u64 val)
 {
 	SPRINT_BUF(b1);
 
@@ -85,8 +87,8 @@ static void __print_time64(const char *label_json, const char *label_fp,
 /* Percent print prints normally in percentage points, but for JSON prints
  * an absolute value (1% vs 0.01).
  */
-static void __print_percent(const char *label_json, const char *label_fp,
-			    __u32 per)
+static void __attribute__((format(printf, 2, 0)))
+__print_percent(const char *label_json, const char *label_fp, __u32 per)
 {
 	print_float(PRINT_FP, NULL, label_fp, (100. * per) / UINT32_MAX);
 	print_float(PRINT_JSON, label_json, NULL, (1. * per) / UINT32_MAX);
@@ -802,9 +804,10 @@ static int netem_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		rate64 = rate64 ? : rate->rate;
 		tc_print_rate(PRINT_ANY, "rate", " rate %s", rate64);
 		PRINT_INT_OPT("packetoverhead", rate->packet_overhead);
-		print_uint(PRINT_ANY, "cellsize",
-			   rate->cell_size ? " cellsize %u" : "",
-			   rate->cell_size);
+
+		print_uint(PRINT_JSON, "cellsize", NULL, rate->cell_size);
+		if (rate->cell_size)
+			print_uint(PRINT_FP, NULL, " cellsize %u", rate->cell_size);
 		PRINT_INT_OPT("celloverhead", rate->cell_overhead);
 		close_json_object();
 	}
@@ -824,9 +827,13 @@ static int netem_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		close_json_object();
 	}
 
-	print_bool(PRINT_ANY, "ecn", ecn ? " ecn " : "", ecn);
-	print_luint(PRINT_ANY, "gap", qopt.gap ? " gap %lu" : "",
-		    (unsigned long)qopt.gap);
+	print_bool(PRINT_JSON, "ecn", NULL, ecn);
+	if (ecn)
+		print_bool(PRINT_FP, NULL, " ecn ", ecn);
+
+	print_luint(PRINT_JSON, "gap", NULL, qopt.gap);
+	if (qopt.gap)
+		print_luint(PRINT_FP, NULL, " gap %lu", qopt.gap);
 
 	return 0;
 }
-- 
2.30.2

