Return-Path: <netdev+bounces-4767-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A23270E289
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 141FD1C20DED
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDB20206B3;
	Tue, 23 May 2023 16:59:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4E9206A2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:59:38 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65536E0
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:59:37 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d2f99c8c3so4785b3a.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684861176; x=1687453176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TxF2SonzBsRNzH20Te/NQ2fwwB3EwWGUMmP1nMhMls4=;
        b=xG4tHz59Rq1QuPeJzftDKGeMHf1y1U5JgFBB/ee0BFp7padGijog4e3F2ho2wN3iKa
         W+qAZLitAOgmSwKGs0TjVn6R2J1l4vAyak2yjHGm/4sKahMOt6m+MHpFk6ZO2f/jD8cX
         yYcPT6A0589OI1hdDg6PqkP8VutqEKMn4CGz8enZIDPwesqfP0o51//7u+gR9GdZREc6
         4btDLk0DitxC9BzEZiP7+C/JzjUPQ1HEb0YTxtRQSie9fDs5qlGhqHnHEkWx4iWt2Ji+
         O3mQcI2xLAJv82U+SgvNoQQQf54Vh3RKoHyWvMUA6fhaCtuA30qSQMemVVbhnbFnk0oR
         9tTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684861176; x=1687453176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TxF2SonzBsRNzH20Te/NQ2fwwB3EwWGUMmP1nMhMls4=;
        b=bPmIUG1twK733iMFIB4VxkhJrW4QXsGj7cnD2GE3i92+1gNqwGirDGf3uTrw6QnALb
         nfkYVS3BI2ZkxNJKDleDfmma8P1OTQQljBs0HZz2u29tLSemLAWnV3uTmUtUS0dCDgFN
         k9DXh6B4SqGZtA+9pGZzF9FWWyomJ1I1UdG+CBU2WTp5TqIfBWZWoN9GlPyro540UmCn
         okRBMs1RhwUYZ2UV1uRPbgXrw12BrrKGHjugtbDeJ7n/xM6FXsdGii0AnPGc8Ea1pfTa
         huIX3ktX7YcQQRRiwcVH4c4gjioIhHtMgyvYwJ3oqBEXcm2bK+rgO25+ej0uUZ6+PYZp
         kLNw==
X-Gm-Message-State: AC+VfDwtA5l+k57agID8jSp3ucqsGC2QSDSCV7a4Gsf+OIprbv+2khzi
	nanvw0t2qhbHnGEaHElBxXEiDdWFjMeIXejNJXznCg==
X-Google-Smtp-Source: ACHHUZ7ZM606/KrPCdjIJ6oB2pzDWLs7QRMW5bYsdQgWfZqo0/T1fQfSwFB0L/9uaT1aW0soq/wmTw==
X-Received: by 2002:a05:6a20:3d0e:b0:10b:96be:ca35 with SMTP id y14-20020a056a203d0e00b0010b96beca35mr7837064pzi.28.1684861176567;
        Tue, 23 May 2023 09:59:36 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id a14-20020a62e20e000000b00643889e30c2sm3836891pfi.180.2023.05.23.09.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 09:59:36 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [RFC 2/2] vxlan: make option printing more consistent
Date: Tue, 23 May 2023 09:59:32 -0700
Message-Id: <20230523165932.8376-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230523165932.8376-1-stephen@networkplumber.org>
References: <20230523165932.8376-1-stephen@networkplumber.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add new helper function print_bool_opt() which prints
with no prefix and use it for vxlan options.

Based on discussion around how to handle new localbypass option.
Initial version of this was from Ido Schimmel.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/json_print.h |  9 +++++
 ip/iplink_vxlan.c    | 80 ++++++++++++++++----------------------------
 lib/json_print.c     | 18 ++++++++++
 3 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 91b34571ceb0..4d165a91c23a 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -101,6 +101,15 @@ static inline int print_rate(bool use_iec, enum output_type t,
 	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
 }
 
+int print_color_bool_opt(enum output_type type, enum color_attr color,
+			 const char *key, bool value);
+
+static inline int print_bool_opt(enum output_type type,
+				 const char *key, bool value)
+{
+	return print_color_bool_opt(type, COLOR_NONE, key, value);
+}
+
 /* A backdoor to the size formatter. Please use print_size() instead. */
 char *sprint_size(__u32 sz, char *buf);
 
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index cb6745c74507..292e19cdb940 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -427,15 +427,13 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (!tb)
 		return;
 
-	if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
-		print_bool(PRINT_ANY, "external", "external ", true);
-	}
+	if (tb[IFLA_VXLAN_COLLECT_METADATA])
+		print_bool_opt(PRINT_ANY, "external",
+			       rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA]));
 
-	if (tb[IFLA_VXLAN_VNIFILTER] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER])) {
-		print_bool(PRINT_ANY, "vnifilter", "vnifilter", true);
-	}
+	if (tb[IFLA_VXLAN_VNIFILTER])
+		print_bool_opt(PRINT_ANY, "vnifilter",
+			       rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER]));
 
 	if (tb[IFLA_VXLAN_ID] &&
 	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
@@ -532,22 +530,24 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (tb[IFLA_VXLAN_LEARNING]) {
 		__u8 learning = rta_getattr_u8(tb[IFLA_VXLAN_LEARNING]);
 
-		print_bool(PRINT_JSON, "learning", NULL, learning);
-		if (!learning)
-			print_bool(PRINT_FP, NULL, "nolearning ", true);
+		print_bool_opt(PRINT_ANY, "learning", learning);
 	}
 
-	if (tb[IFLA_VXLAN_PROXY] && rta_getattr_u8(tb[IFLA_VXLAN_PROXY]))
-		print_bool(PRINT_ANY, "proxy", "proxy ", true);
+	if (tb[IFLA_VXLAN_PROXY])
+		print_bool_opt(PRINT_ANY, "proxy",
+			       rta_getattr_u8(tb[IFLA_VXLAN_PROXY]));
 
-	if (tb[IFLA_VXLAN_RSC] && rta_getattr_u8(tb[IFLA_VXLAN_RSC]))
-		print_bool(PRINT_ANY, "rsc", "rsc ", true);
+	if (tb[IFLA_VXLAN_RSC])
+		print_bool_opt(PRINT_ANY, "rsc",
+			       rta_getattr_u8(tb[IFLA_VXLAN_RSC]));
 
-	if (tb[IFLA_VXLAN_L2MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L2MISS]))
-		print_bool(PRINT_ANY, "l2miss", "l2miss ", true);
+	if (tb[IFLA_VXLAN_L2MISS])
+		print_bool_opt(PRINT_ANY, "l2miss",
+			       rta_getattr_u8(tb[IFLA_VXLAN_L2MISS]));
 
-	if (tb[IFLA_VXLAN_L3MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L3MISS]))
-		print_bool(PRINT_ANY, "l3miss", "l3miss ", true);
+	if (tb[IFLA_VXLAN_L3MISS])
+		print_bool_opt(PRINT_ANY, "l3miss",
+			       rta_getattr_u8(tb[IFLA_VXLAN_L3MISS]));
 
 	if (tb[IFLA_VXLAN_TOS])
 		tos = rta_getattr_u8(tb[IFLA_VXLAN_TOS]);
@@ -604,51 +604,27 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (tb[IFLA_VXLAN_UDP_CSUM]) {
 		__u8 udp_csum = rta_getattr_u8(tb[IFLA_VXLAN_UDP_CSUM]);
 
-		if (is_json_context()) {
-			print_bool(PRINT_ANY, "udp_csum", NULL, udp_csum);
-		} else {
-			if (!udp_csum)
-				fputs("no", f);
-			fputs("udpcsum ", f);
-		}
+		print_bool_opt(PRINT_ANY, "udp_csum", udp_csum);
 	}
 
 	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
 
-		if (is_json_context()) {
-			print_bool(PRINT_ANY,
-				   "udp_zero_csum6_tx", NULL, csum6);
-		} else {
-			if (!csum6)
-				fputs("no", f);
-			fputs("udp6zerocsumtx ", f);
-		}
+		print_bool_opt(PRINT_ANY, "udp_zero_csum6_tx",  csum6);
 	}
 
 	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_RX]) {
 		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_RX]);
 
-		if (is_json_context()) {
-			print_bool(PRINT_ANY,
-				   "udp_zero_csum6_rx",
-				   NULL,
-				   csum6);
-		} else {
-			if (!csum6)
-				fputs("no", f);
-			fputs("udp6zerocsumrx ", f);
-		}
+		print_bool_opt(PRINT_ANY, "udp_zero_csum6_rx",  csum6);
 	}
 
-	if (tb[IFLA_VXLAN_REMCSUM_TX] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_TX]))
-		print_bool(PRINT_ANY, "remcsum_tx", "remcsumtx ", true);
-
-	if (tb[IFLA_VXLAN_REMCSUM_RX] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_RX]))
-		print_bool(PRINT_ANY, "remcsum_rx", "remcsumrx ", true);
-
+	if (tb[IFLA_VXLAN_REMCSUM_TX])
+		print_bool_opt(PRINT_ANY, "remcsum_tx",
+			       rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_TX]));
+	if (tb[IFLA_VXLAN_REMCSUM_RX])
+		print_bool_opt(PRINT_ANY, "remcsum_rx",
+			       rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_RX]));
 	if (tb[IFLA_VXLAN_GBP])
 		print_null(PRINT_ANY, "gbp", "gbp ", NULL);
 	if (tb[IFLA_VXLAN_GPE])
diff --git a/lib/json_print.c b/lib/json_print.c
index d7ee76b10de8..29959e7335c3 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -215,6 +215,24 @@ int print_color_bool(enum output_type type,
 				  value ? "true" : "false");
 }
 
+/* In JSON mode, acts like print_color_bool
+ * otherwise, prints key with no prefix if false
+ */
+int print_color_bool_opt(enum output_type type,
+			 enum color_attr color,
+			 const char *key,
+			 bool value)
+{
+	int ret = 0;
+
+	if (_IS_JSON_CONTEXT(type))
+		jsonw_bool_field(_jw, key, value);
+	else if (_IS_FP_CONTEXT(type))
+		ret = color_fprintf(stdout, color, "%s%s ",
+				    value ? "" : "no", key);
+	return ret;
+}
+
 int print_color_on_off(enum output_type type,
 		       enum color_attr color,
 		       const char *key,
-- 
2.39.2


