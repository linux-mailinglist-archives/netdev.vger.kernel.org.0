Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D52C490FE5
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiAQRu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiAQRuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:25 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1760C061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:25 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i65so10830938pfc.9
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PLrtaU0fxXFhqRXeT0Jx0z02127t5xnDBA04neCpsbE=;
        b=FA8BHYw+OIpAhPIG+zm2oULZ9ihOM/LEyoQ1w1A/2N9Hj4QL02Enk9yGIdcblIN0bc
         GMCQ0nNCW7UOeRpNlT8nN4Vl4Rllfd1TfFhH2NiDUoetjQEIkwaNo9NiQxozSuMeD3sC
         BM8uNetf+AnxHjrmZiXOCNl9/OHuRf1HY62WdOWSpwkRC1nT89c+TFF7eQRsCkZzs2+i
         0eMM1nzyKz4QnXFlTHIQSi1lR7Wd/qIw/pa9HsKJfnSOUyM/TqW8tW5liw+pJJH68vBu
         PFyJsqXbxv5Og8ilmR1xaXgryg+0MLA4nzj2G95aYiCzfsuEywy7hO7YRiKPskynaOoD
         D0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLrtaU0fxXFhqRXeT0Jx0z02127t5xnDBA04neCpsbE=;
        b=h7dz3jsrSfFS0hj17RVaDRen+IYByb75nAHlno0VMCIBSauWvA9lN2uvrqdqMkvEga
         +nWtwmQMaCNvJSEFYkpUuwlnPQaj3m0RtX7YSv80T/moMdjWQ4FM4CMmJxdEtSV/aOJX
         rV0Avx9xfPp+g8fiYPXYeDmLQgWbCs7nQIt0uUrzakMxNVmanG9FssX9wkShSb7A3bzP
         qL6gle97XeT1ZvfFLF3OwUuUerVzdBQ6u5q2ivrPjY2G1uz7Lai3jWqLjPx9LE2UoPic
         4nwBgblJdszrNfhXwJO71kghIBM+jtXanMsVzKbv8ck1tJaF8nnqUgGtUHHqtwM+XIEX
         Ea/A==
X-Gm-Message-State: AOAM532OX2KXNAbdvtWZ8ZV0t9PSsaPg/t3eA7W9mwXa0lJvNDHJ1/9J
        wUw7VL7y8IZTwb/gQfgNqPNHW7uDsnOG4A==
X-Google-Smtp-Source: ABdhPJwpuETKyKNZfke18FN9X4RiRTLGp6HGTKrwziKwvsx4bg1DQASPeG69Cl/QaBB+HpvQzDbqbw==
X-Received: by 2002:a63:7f59:: with SMTP id p25mr19965113pgn.612.1642441824941;
        Mon, 17 Jan 2022 09:50:24 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:24 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 03/11] netem: fix clang warnings
Date:   Mon, 17 Jan 2022 09:50:11 -0800
Message-Id: <20220117175019.13993-4-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
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

