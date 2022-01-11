Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB22A48B4A6
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344898AbiAKRys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344832AbiAKRyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:45 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796F7C061751
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:45 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id h1so18368291pls.11
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VxcROO/YL7z1OeGPOjZVYFxIeHXhPKmelOrqJjV/+sw=;
        b=ugTKXt3bvC+7cdTkk2x+y9er57F2R2ECwGsgWQJzKgCsY1ZqiP5xcejAv69F1HQxlJ
         SzkyWwYZwWdwQOX3n7D3Q/zcw078l0MJOMZz89eAMw/VEH6Xngcky7GxItw2GNmDgQBR
         8yigA51BJlgZAwwUhIZQcxvM7Aps+Wzce6636a9T9w8SPRf9w17MFhd/6t03MNzMlzER
         n24ftvpcpBSvv81gvwrxvgJJB2fmj9lEzbykShEDBlsJR+FuJOk2RTo++38yB+Eke5Q6
         tGdUf93uURcaMMWmaERqmFyL0cnkLhFm6RGx1Dr64P8s4Wy5nUG4AwKQei1Qcim9Z6Vh
         b2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VxcROO/YL7z1OeGPOjZVYFxIeHXhPKmelOrqJjV/+sw=;
        b=4yCap35wBtyw1H4RSoHDW9hvx7O5cly/6dCU4YGGyJh/3hYaERSXI0tFLTHXEhMTgB
         gTblGqJeF7eieFsP+cTsxPVi7/999IrK0juITotyglT9fV2c2Ki5hQiuzOOGelIgRtS4
         Jd5kMJdHRFJsmllZ0w8YMvDhL23aedJP/k7/K8h1LspfBa3GbLzuY1WTz0exKc10BTIo
         B2mSfLS3wR2xlCT/DAuu4HLYPVFg606fDid4+0KHRfk1bynyCYagy16x/zBjQpX46ooM
         Vy9En1OHVopOwdDXaPVDl6ifadKsFYj4nyAkFl6QAIQCc3tK7LkANEPgD8qjpjjInVeH
         iM3g==
X-Gm-Message-State: AOAM532B7ycc9SVFKJU42qaspbnSr/uTptzzXZay8iQ3xGQWUCJvr9mQ
        Xzp3X7nzDcUj7oEWElqCjtcIoZc0xwZYSw==
X-Google-Smtp-Source: ABdhPJx12iWn3Ssr9r7AUyGmM+bu25Jx6ehpiWFcoOt0xNi2u3VsipLD5xHPiyN2ySWwvbNYkLABTA==
X-Received: by 2002:a63:370f:: with SMTP id e15mr4863682pga.230.1641923684628;
        Tue, 11 Jan 2022 09:54:44 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:44 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 03/11] netem: fix clang warnings
Date:   Tue, 11 Jan 2022 09:54:30 -0800
Message-Id: <20220111175438.21901-4-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
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

