Return-Path: <netdev+bounces-5399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F0171117F
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 19:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E82B1C20F17
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D681D2C3;
	Thu, 25 May 2023 16:59:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CBF1D2C0
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:59:29 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EC3189
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:59:27 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64a9335a8e7so918152b3a.0
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685033967; x=1687625967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wof52/YKL35hK6QvZIAtDZ2DrWAp9pXzuSFhNkcDxck=;
        b=iz8aMflFP5X9AbwT7XrNfwWVvCsfLqScfPf0B4uLByr/ivMlyvyK15Jg+3CLRWsYxN
         H+8O6SNafhVwm23Y6kyUFd3F7JcA6lprxNyKKLyS6D7wFAvZAH4B+py1nk4UYJwvtD5U
         wQ64hE8f6MgK7YSTGgAZ1g+rGAxvrUhTT78I8BOiqNia8baez5KVv9ZWUJo8LzEo5mQk
         70z3/IoKkouCGh3aS3I+ybIzqHIcwVPvQA7pegIoMktAbGB2bL/kRc1xQvc7ABzvyF5E
         CHVy0QzECPMVMasbVN1b1gPDuP6dTcFBuZR30KNHxFeJKNiZa24xReqbS5k7Y6ywp44i
         wpWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685033967; x=1687625967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wof52/YKL35hK6QvZIAtDZ2DrWAp9pXzuSFhNkcDxck=;
        b=IYI+xm/Gk6pDPkajlVfpxSVIt/+hE3ZJYEio8N+4fkAVNXWqKFgVxK5BZrImRBPrQm
         GnbTqk2SOgWyzKorhPczHZCxgADlkg+SUjUQLJVKNCn/29BSeJ+MOOHnUNjfZvEawK9O
         otOdTBhUkIcIqF/4MZYLowp23wso8uf+zZqHV7SElahqUq9IB1RoH9VjoryFYha6GpX3
         ptU0cS2dlFxncMZVTPHg5xljlVSdsjTC/HQJvIASF/ft4r/qEMNy6dDyq3IFLBkhEUUV
         xWlafeMx7hntcj25KXo1VUBssBA1Zp+Kj1/FbaSlJGnPGbpIeGylWmEwanUGbb6U9DIU
         CGiw==
X-Gm-Message-State: AC+VfDx+Glt0qsWPWMuDuJlnfv57GOFoDHngvY7UyqPLJWo2Au7aA+j5
	MzmDvMIX+5qwRBC60Jmze9LInQi2E1f6D1kRLAxdvw==
X-Google-Smtp-Source: ACHHUZ77loWcCZkypvSQHZ/bypC/0qeJsZUke4Dzv7I9vwtBEJEwHI6ynok7m8f1/vGMsXgW7BZJ3w==
X-Received: by 2002:a17:902:e5ce:b0:1a9:4cd5:e7e0 with SMTP id u14-20020a170902e5ce00b001a94cd5e7e0mr3037609plf.17.1685033967008;
        Thu, 25 May 2023 09:59:27 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902e88300b00194d14d8e54sm1662111plg.96.2023.05.25.09.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 09:59:26 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v3 2/2] vxlan: make option printing more consistent
Date: Thu, 25 May 2023 09:59:22 -0700
Message-Id: <20230525165922.9711-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525165922.9711-1-stephen@networkplumber.org>
References: <20230525165922.9711-1-stephen@networkplumber.org>
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
it is not printed if in non JSON mode unless the details
setting is repeated.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/json_print.h |  9 +++++
 ip/iplink_vxlan.c    | 91 +++++++++-----------------------------------
 lib/json_print.c     | 19 +++++++++
 3 files changed, 46 insertions(+), 73 deletions(-)

diff --git a/include/json_print.h b/include/json_print.h
index 91b34571ceb0..49d3cc14789c 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -101,6 +101,15 @@ static inline int print_rate(bool use_iec, enum output_type t,
 	return print_color_rate(use_iec, t, COLOR_NONE, key, fmt, rate);
 }
 
+int print_color_bool_opt(enum output_type type, enum color_attr color,
+			 const char *key, bool value, bool show);
+
+static inline int print_bool_opt(enum output_type type,
+				 const char *key, bool value, bool show)
+{
+	return print_color_bool_opt(type, COLOR_NONE, key, value, show);
+}
+
 /* A backdoor to the size formatter. Please use print_size() instead. */
 char *sprint_size(__u32 sz, char *buf);
 
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index cb6745c74507..3a7f8375b5c5 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -427,15 +427,15 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (!tb)
 		return;
 
-	if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
-		print_bool(PRINT_ANY, "external", "external ", true);
+#define PRINT_VXLAN_OPTION(attr, opt, expect)				\
+	if (tb[attr]) {							\
+		__u8 opt = rta_getattr_u8(tb[attr]);			\
+		print_bool_opt(PRINT_ANY, #opt, opt,			\
+			       opt != expect || show_details > 1);	\
 	}
 
-	if (tb[IFLA_VXLAN_VNIFILTER] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER])) {
-		print_bool(PRINT_ANY, "vnifilter", "vnifilter", true);
-	}
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_COLLECT_METADATA, external, false);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_VNIFILTER, vnifilter, false);
 
 	if (tb[IFLA_VXLAN_ID] &&
 	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
@@ -529,25 +529,11 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   "dstport %u ",
 			   rta_getattr_be16(tb[IFLA_VXLAN_PORT]));
 
-	if (tb[IFLA_VXLAN_LEARNING]) {
-		__u8 learning = rta_getattr_u8(tb[IFLA_VXLAN_LEARNING]);
-
-		print_bool(PRINT_JSON, "learning", NULL, learning);
-		if (!learning)
-			print_bool(PRINT_FP, NULL, "nolearning ", true);
-	}
-
-	if (tb[IFLA_VXLAN_PROXY] && rta_getattr_u8(tb[IFLA_VXLAN_PROXY]))
-		print_bool(PRINT_ANY, "proxy", "proxy ", true);
-
-	if (tb[IFLA_VXLAN_RSC] && rta_getattr_u8(tb[IFLA_VXLAN_RSC]))
-		print_bool(PRINT_ANY, "rsc", "rsc ", true);
-
-	if (tb[IFLA_VXLAN_L2MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L2MISS]))
-		print_bool(PRINT_ANY, "l2miss", "l2miss ", true);
-
-	if (tb[IFLA_VXLAN_L3MISS] && rta_getattr_u8(tb[IFLA_VXLAN_L3MISS]))
-		print_bool(PRINT_ANY, "l3miss", "l3miss ", true);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_LEARNING, learning, true);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_PROXY, proxy, false);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_RSC, rsc, false);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_L2MISS, l2miss, false);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_L3MISS, l3miss, false);
 
 	if (tb[IFLA_VXLAN_TOS])
 		tos = rta_getattr_u8(tb[IFLA_VXLAN_TOS]);
@@ -601,58 +587,17 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	    ((maxaddr = rta_getattr_u32(tb[IFLA_VXLAN_LIMIT])) != 0))
 		print_uint(PRINT_ANY, "limit", "maxaddr %u ", maxaddr);
 
-	if (tb[IFLA_VXLAN_UDP_CSUM]) {
-		__u8 udp_csum = rta_getattr_u8(tb[IFLA_VXLAN_UDP_CSUM]);
-
-		if (is_json_context()) {
-			print_bool(PRINT_ANY, "udp_csum", NULL, udp_csum);
-		} else {
-			if (!udp_csum)
-				fputs("no", f);
-			fputs("udpcsum ", f);
-		}
-	}
-
-	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
-		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]);
-
-		if (is_json_context()) {
-			print_bool(PRINT_ANY,
-				   "udp_zero_csum6_tx", NULL, csum6);
-		} else {
-			if (!csum6)
-				fputs("no", f);
-			fputs("udp6zerocsumtx ", f);
-		}
-	}
-
-	if (tb[IFLA_VXLAN_UDP_ZERO_CSUM6_RX]) {
-		__u8 csum6 = rta_getattr_u8(tb[IFLA_VXLAN_UDP_ZERO_CSUM6_RX]);
-
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
-	}
-
-	if (tb[IFLA_VXLAN_REMCSUM_TX] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_TX]))
-		print_bool(PRINT_ANY, "remcsum_tx", "remcsumtx ", true);
-
-	if (tb[IFLA_VXLAN_REMCSUM_RX] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_REMCSUM_RX]))
-		print_bool(PRINT_ANY, "remcsum_rx", "remcsumrx ", true);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_UDP_CSUM, udp_csum, true);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_UDP_ZERO_CSUM6_TX, udp_zero_csum6_tx, false);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_UDP_ZERO_CSUM6_RX, udp_zero_csum6_rx, false);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_REMCSUM_TX, remcsum_tx, false);
+	PRINT_VXLAN_OPTION(IFLA_VXLAN_REMCSUM_RX, remcsum_rx, false);
 
 	if (tb[IFLA_VXLAN_GBP])
 		print_null(PRINT_ANY, "gbp", "gbp ", NULL);
 	if (tb[IFLA_VXLAN_GPE])
 		print_null(PRINT_ANY, "gpe", "gpe ", NULL);
+#undef PRINT_VXLAN_OPTION
 }
 
 static void vxlan_print_help(struct link_util *lu, int argc, char **argv,
diff --git a/lib/json_print.c b/lib/json_print.c
index d7ee76b10de8..602de027ca27 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -215,6 +215,25 @@ int print_color_bool(enum output_type type,
 				  value ? "true" : "false");
 }
 
+/* In JSON mode, acts like print_color_bool.
+ * Otherwise, will print key with prefix of "no" if false.
+ * The show flag is used to suppres printing in non-JSON mode
+ */
+int print_color_bool_opt(enum output_type type,
+			 enum color_attr color,
+			 const char *key,
+			 bool value, bool show)
+{
+	int ret = 0;
+
+	if (_IS_JSON_CONTEXT(type))
+		jsonw_bool_field(_jw, key, value);
+	else if (_IS_FP_CONTEXT(type) && show)
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


