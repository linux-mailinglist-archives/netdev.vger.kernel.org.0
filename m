Return-Path: <netdev+bounces-5386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BFC710FF9
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9FC828154E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB311C764;
	Thu, 25 May 2023 15:50:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FD41C752
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:50:42 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B062B6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:50:40 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ae79528d4dso14778625ad.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685029839; x=1687621839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVNMAQ6kkP576xY8p9hQ4i2wpyfRPBfJvLfon/5xZVI=;
        b=VAoL+zR+fSuf0fmcGffFY9EbJxHyQP1AX8FoTt3/g8fIDwO/OQuAJdJoYbrlNdAwuq
         Wb9701hHMrrGCE9Ekex9hdY6JSNnmpmygKg5L5ynr9lP/q1yjxGAzouqXNW+aUFKtTkH
         wcQp4p7eYs9cCzRCnV+fURZrfYOUAghjxffo4sYiGJu/KMJo/hFTgyUAmd1ujCl2XPaR
         qKVcjyte2D76/6NY76Dee/kmMwb14jqBRRmmmQyD/UpVl6QxQYZZQe38PhzcfOWgp+8D
         4oqJNZ+kef07IGKWOW6eUHhU3J3UA/TfQdC7/6tTvI7mzUz5t/Uwobm493esnuvi2wFr
         sXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685029839; x=1687621839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVNMAQ6kkP576xY8p9hQ4i2wpyfRPBfJvLfon/5xZVI=;
        b=ergRDr7n+BxDzAINOx8mwKnDQWEW6V7KQjfYDZp7rgYIXw2LSXTpkeHdIoq7gQ0xMo
         FDYfDTynpoaUhU4K/oB3+5QgyATOvFMSQIOZ9GUWq7+3HveL9sdQ6muy0vni3xw2Nbcx
         nx2xn90u3TULRMKu5jzRk8JwyFk7cbmQ4qGd5In8jCg3MQ4bLxhkBJigt3mBQSCfkiD2
         FbkPcMNOVFvrDHlbj2L0WfA9oF1Niom7Q1jZiMMOchrtB+FvJHMOxe/x0llmuxUbQETP
         rnsi2hkLrB+6RQ+0m7s88IKIpMB060De8JztvllDfeqHkIgUQYv3QnqoLGixmGQJ8DVs
         fGig==
X-Gm-Message-State: AC+VfDxW/ClFipi18hTND55D1gZDN42N37250je96ps9D+9bAuVP9004
	8Ki3QRu2SdJYtjv+CrgR1hA+qSYOT/MiL8zHuPAm3A==
X-Google-Smtp-Source: ACHHUZ5VFd2K584cSWqmh/so0M5/fmm6DuzWV2SIzFYDskjE5p3sMxCEdBB6KaYI3XHuB33bxd8XJg==
X-Received: by 2002:a17:903:18b:b0:1af:b682:7a78 with SMTP id z11-20020a170903018b00b001afb6827a78mr2002643plg.52.1685029839271;
        Thu, 25 May 2023 08:50:39 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902e84100b001a9a8983a15sm1586547plg.231.2023.05.25.08.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 08:50:38 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v2 2/2] vxlan: make option printing more consistent
Date: Thu, 25 May 2023 08:50:35 -0700
Message-Id: <20230525155035.7471-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525155035.7471-1-stephen@networkplumber.org>
References: <20230525155035.7471-1-stephen@networkplumber.org>
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

If the option matches the expected default value,
it is not printed if in non JSON mode.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/json_print.h |  9 +++++
 ip/iplink_vxlan.c    | 80 ++++++++++++++++----------------------------
 lib/json_print.c     | 19 +++++++++++
 3 files changed, 56 insertions(+), 52 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 91b34571ceb0..be1a99775fde 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -101,6 +101,15 @@ static inline int print_rate(bool use_iec, enum output_type t,
 	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
 }
 
+int print_color_bool_opt(enum output_type type, enum color_attr color,
+			 const char *key, bool value, bool expected);
+
+static inline int print_bool_opt(enum output_type type,
+				 const char *key, bool value, bool expected)
+{
+	return print_color_bool_opt(type, COLOR_NONE, key, value, expected);
+}
+
 /* A backdoor to the size formatter. Please use print_size() instead. */
 char *sprint_size(__u32 sz, char *buf);
 
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index cb6745c74507..fb37d426372d 100644
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
+			       rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA]), false);
 
-	if (tb[IFLA_VXLAN_VNIFILTER] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER])) {
-		print_bool(PRINT_ANY, "vnifilter", "vnifilter", true);
-	}
+	if (tb[IFLA_VXLAN_VNIFILTER])
+		print_bool_opt(PRINT_ANY, "vnifilter",
+			       rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER]), false);
 
 	if (tb[IFLA_VXLAN_ID] &&
 	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
@@ -532,22 +530,24 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (tb[IFLA_VXLAN_LEARNING]) {
 		__u8 learning = rta_getattr_u8(tb[IFLA_VXLAN_LEARNING]);
 
-		print_bool(PRINT_JSON, "learning", NULL, learning);
-		if (!learning)
-			print_bool(PRINT_FP, NULL, "nolearning ", true);
+		print_bool_opt(PRINT_ANY, "learning", learning, true);
 	}
 
-	if (tb[IFLA_VXLAN_PROXY] && rta_getattr_u8(tb[IFLA_VXLAN_PROXY]))
-		print_bool(PRINT_ANY, "proxy", "proxy ", true);
+	if (tb[IFLA_VXLAN_PROXY])
+		print_bool_opt(PRINT_ANY, "proxy",
+			       rta_getattr_u8(tb[IFLA_VXLAN_PROXY]), false);
 
-	if (tb[IFLA_VXLAN_RSC] && rta_getattr_u8(tb[IFLA_VXLAN_RSC]))
-		print_bool(PRINT_ANY, "rsc", "rsc ", true);
+	if (tb[IFLA_VXLAN_RSC])
+		print_bool_opt(PRINT_ANY, "rsc",
+			       rta_getattr_u8(tb[IFLA_VXLAN_RSC]), false);
 
-	if (tb[IFLA_VXLAN_L2MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L2MISS]))
-		print_bool(PRINT_ANY, "l2miss", "l2miss ", true);
+	if (tb[IFLA_VXLAN_L2MISS])
+		print_bool_opt(PRINT_ANY, "l2miss",
+			       rta_getattr_u8(tb[IFLA_VXLAN_L2MISS]), false);
 
-	if (tb[IFLA_VXLAN_L3MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L3MISS]))
-		print_bool(PRINT_ANY, "l3miss", "l3miss ", true);
+	if (tb[IFLA_VXLAN_L3MISS])
+		print_bool_opt(PRINT_ANY, "l3miss",
+			       rta_getattr_u8(tb[IFLA_VXLAN_L3MISS]), false);
 
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
+		print_bool_opt(PRINT_ANY, "udp_csum", udp_csum, true);
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
+		print_bool_opt(PRINT_ANY, "udp_zero_csum6_tx", csum6, false);
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
+		print_bool_opt(PRINT_ANY, "udp_zero_csum6_rx", csum6, false);
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
+			       rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_TX]), false);
+	if (tb[IFLA_VXLAN_REMCSUM_RX])
+		print_bool_opt(PRINT_ANY, "remcsum_rx",
+			       rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_RX]), false);
 	if (tb[IFLA_VXLAN_GBP])
 		print_null(PRINT_ANY, "gbp", "gbp ", NULL);
 	if (tb[IFLA_VXLAN_GPE])
diff --git a/lib/json_print.c b/lib/json_print.c
index d7ee76b10de8..2dfddf713eb8 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -215,6 +215,25 @@ int print_color_bool(enum output_type type,
 				  value ? "true" : "false");
 }
 
+/* In JSON mode, acts like print_color_bool
+ * otherwise, if the value does not match expected value
+ *   then print key if true and key with prefix of "no" if false.
+ */
+int print_color_bool_opt(enum output_type type,
+			 enum color_attr color,
+			 const char *key,
+			 bool value, bool expected)
+{
+	int ret = 0;
+
+	if (_IS_JSON_CONTEXT(type))
+		jsonw_bool_field(_jw, key, value);
+	else if (_IS_FP_CONTEXT(type) && value != expected)
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


