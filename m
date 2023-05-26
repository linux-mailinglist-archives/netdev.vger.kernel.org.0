Return-Path: <netdev+bounces-5791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFF3712BFD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C88F928175B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67204290F7;
	Fri, 26 May 2023 17:42:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F9B290E1
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:42:08 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930BC10D9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5289cf35eeaso1771192a12.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685122905; x=1687714905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiiI/4POXt/8MebZ7mOqMdzoUuu9NWDTgENhi7MVJn0=;
        b=TQSdxgdjyHLBOoV9/Bz6YZOOYUm88FVnw5PxPE8KWnyZM6ONIu3rjLm/6Fcfoshs+Z
         9jihOGdCOMykYgj700BG4xu+h0MtrJP4LFKL9W8sC64MUN+P9Bnem1hqyCNLkEZpbQ+5
         Ue0xMeg9R5QhkQoSrhC1irG8kN0Y2j/UI7fSYtb5Qs0Utm18Cb03AGOvvy57pvLwVduj
         LUuxUC3LIPxjN4xYOfa31TaAdl2+hjGQIH3Un94UHnYjMH+DyL6o36lp/GT9AqfXt/RA
         z3n+iKfe0EBlciLd4+Us4CkH/sHiIgcArirqH7SooOT7Cw6i5idKE+zg/f3FkgXbhBhU
         VM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122905; x=1687714905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiiI/4POXt/8MebZ7mOqMdzoUuu9NWDTgENhi7MVJn0=;
        b=dgPsg9Uo2cjVt56KFvUwTN+SPg/c6/ybJuS7qJSBdLc2OgZRY4iW2bp7ZOcvsm5z/l
         MDJNJP3w2ZQ0Bcb0OekYf42I3vsJQ/uAj28020VImkSUyDhlb7TzJR0cbZ/pZwER6jPl
         ZeJAqVZ8SfBDN/wEJPbC9VQ3G7lXNQdT8liGQoXX/UIoU9NGdMyybiYFqcJK/uopiCOF
         z8gmHauC0/vlw6WWdkQvL+rLCQVNkCMqsOHerokRw0oETe2dRTnelxT1ea+hdVCIUXa5
         FFr4deMUBuzwlxL4HMIP9HXWCXaJSdx4sX1K/UBoGu1vGEv7M0o7iCg3j3Ivo9TZvhga
         7PWg==
X-Gm-Message-State: AC+VfDxvGRvU9qKxL4qHU2k+ERlcFSD5upPdsWmjG4zDG1AU6h5pGL4W
	mulPl+ZPW2gTm1ndgU7kpN8elkIOhPTfnFmeIqTQDA==
X-Google-Smtp-Source: ACHHUZ7pXCANDANU/wEOip9Epof0SEWQLOdqV4mSYLisn/4U7rK25Qhl57F2NOGyaxBZleGt0cewAw==
X-Received: by 2002:a17:902:e54b:b0:1ac:6fc3:6beb with SMTP id n11-20020a170902e54b00b001ac6fc36bebmr3586648plf.9.1685122905601;
        Fri, 26 May 2023 10:41:45 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001ab2b4105ddsm3528754plh.60.2023.05.26.10.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:41:45 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v4 2/2] vxlan: make option printing more consistent
Date: Fri, 26 May 2023 10:41:41 -0700
Message-Id: <20230526174141.5972-3-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230526174141.5972-1-stephen@networkplumber.org>
References: <20230526174141.5972-1-stephen@networkplumber.org>
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

Use a table for the vxlan options. This will change
the order of the printing of options.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/json_print.h |   9 ++++
 ip/iplink_vxlan.c    | 110 +++++++++++++------------------------------
 lib/json_print.c     |  19 ++++++++
 3 files changed, 60 insertions(+), 78 deletions(-)

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
index cb6745c74507..e77c3aa2e3a5 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -19,6 +19,25 @@
 
 #define VXLAN_ATTRSET(attrs, type) (((attrs) & (1L << (type))) != 0)
 
+static const struct vxlan_bool_opt {
+	const char *key;
+	int type;
+	bool default_value;
+} vxlan_opts[] = {
+	{ "metadata",	IFLA_VXLAN_COLLECT_METADATA,	false },
+	{ "vnifilter",	IFLA_VXLAN_VNIFILTER,		false },
+	{ "learning", 	IFLA_VXLAN_LEARNING,		true },
+	{ "proxy",	IFLA_VXLAN_PROXY,		false },
+	{ "rsc",	IFLA_VXLAN_RSC,			false },
+	{ "l2miss",	IFLA_VXLAN_L2MISS,		false },
+	{ "l3miss",	IFLA_VXLAN_L3MISS,		false },
+	{ "udp_csum",	IFLA_VXLAN_UDP_CSUM,		true },
+	{ "udp_zero_csum6_tx", IFLA_VXLAN_UDP_ZERO_CSUM6_TX, false },
+	{ "udp_zero_csum6_rx", IFLA_VXLAN_UDP_ZERO_CSUM6_RX, false },
+	{ "remcsum_tx", IFLA_VXLAN_REMCSUM_TX,		false },
+	{ "remcsum_rx", IFLA_VXLAN_REMCSUM_RX,		false },
+};
+
 static void print_explain(FILE *f)
 {
 	fprintf(f,
@@ -420,6 +439,7 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 
 static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
+	unsigned int i;
 	__u8 ttl = 0;
 	__u8 tos = 0;
 	__u32 maxaddr;
@@ -427,16 +447,6 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (!tb)
 		return;
 
-	if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
-		print_bool(PRINT_ANY, "external", "external ", true);
-	}
-
-	if (tb[IFLA_VXLAN_VNIFILTER] &&
-	    rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER])) {
-		print_bool(PRINT_ANY, "vnifilter", "vnifilter", true);
-	}
-
 	if (tb[IFLA_VXLAN_ID] &&
 	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
 		print_uint(PRINT_ANY, "id", "id %u ", rta_getattr_u32(tb[IFLA_VXLAN_ID]));
@@ -529,26 +539,6 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
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
-
 	if (tb[IFLA_VXLAN_TOS])
 		tos = rta_getattr_u8(tb[IFLA_VXLAN_TOS]);
 	if (tos) {
@@ -601,58 +591,22 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
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
-
 	if (tb[IFLA_VXLAN_GBP])
 		print_null(PRINT_ANY, "gbp", "gbp ", NULL);
 	if (tb[IFLA_VXLAN_GPE])
 		print_null(PRINT_ANY, "gpe", "gpe ", NULL);
+
+	for (i = 0; i < ARRAY_SIZE(vxlan_opts); i++) {
+		const struct vxlan_bool_opt *opt = &vxlan_opts[i];
+		__u8 val;
+
+		if (!tb[opt->type])
+			continue;
+		val = rta_getattr_u8(tb[opt->type]);
+
+		print_bool_opt(PRINT_ANY, opt->key, val,
+			       val != opt->default_value || show_details > 1);
+	}
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


