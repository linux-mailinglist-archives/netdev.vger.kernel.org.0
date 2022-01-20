Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C5F4955D2
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377770AbiATVMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbiATVMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:00 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2E2C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:00 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id n11so6286197plf.4
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PLrtaU0fxXFhqRXeT0Jx0z02127t5xnDBA04neCpsbE=;
        b=rIaoHDQdNByK61V7eXYipHjIW9GWUulX+GYwEHkvZRsGLC+mdWq9s+hpfL+dbkQSGL
         eWPj+bXTa/4zK+FWMVoRbaMvoFqdPYFbbaX7ZnIX8ZftZlARKQGbpmGYb3NBvCnfQ+Rz
         vShdFngArogosP1ZUavP6/jmuG2IKFUqkNaxBo6tsySX9fIyhtDk9BAwD1o+MftVc7+b
         z7kfA8DL8AVQXl4HAYTOzoulRKYlN/6GADuD4yFLx/YOVCxeTKRXSGminAwvSNe8byh7
         /+VoJpwQDyN/Q2rQAt5ipUVWXNx/22Hpc5TufD8kPrN+tGUeB55BqBWzf3cDBLllJqKg
         pAdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLrtaU0fxXFhqRXeT0Jx0z02127t5xnDBA04neCpsbE=;
        b=1cTqGgqfGbjXuwFiLIP1A2ouRn/1kYskAaBdZT8S6dT3Upw+2Nf/skJYkUHvM24pQ8
         rXD19GjSJ2X35tEab5tYzPE/8tH7Nb9Uo9coZtdbZCO3nB36ZkqDmLrsNaC0fuDArg4j
         erkpIdgnT/pfeRYeekFnB1/BLKmjDcKFm9OmgyoFX6vtHoQfV4luzfyzIG3c1tIp4FMP
         XA6ixdSMTPQufjKRs8nZVkrBtem4199MqrUsK9QuMkb6mcN+6/Xx8tE1OQKoQFdeaoAo
         OWutV58oNnx9hrnMhqs9jDrHlwIgaZo4vvL7iG+oEkRJUbKvSKW2SV+X/sUG2eByzblQ
         K/Hg==
X-Gm-Message-State: AOAM531YMOa3b2bKbdG/gNHU5D7kS1+Cuw4dvcRIcumrKy/qGh7t4XWb
        YjZbJIaG0cKRdIixryumDEOuSYLGu3RraA==
X-Google-Smtp-Source: ABdhPJwIxAMz7uNO5ocauIyfccgOgQdIwuUiX5HL8ToAl3d5bR+9377i7jnimwWsDKNtX0n0Ns1svg==
X-Received: by 2002:a17:902:aa88:b0:14a:bd99:24ad with SMTP id d8-20020a170902aa8800b0014abd9924admr880116plr.162.1642713119490;
        Thu, 20 Jan 2022 13:11:59 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:11:58 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 03/11] netem: fix clang warnings
Date:   Thu, 20 Jan 2022 13:11:45 -0800
Message-Id: <20220120211153.189476-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

