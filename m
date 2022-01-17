Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9566C490FE3
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiAQRu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiAQRu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:50:26 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92332C06173E
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:26 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo478853pjb.2
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 09:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqvz2LGyE7knId3mboqOpZqiWxGHqUhxacItbVAXPoM=;
        b=BL5jOI0uw4ovRmkPOXSMn6yCBlZJbPwTeybuqgkwlzzYL+fLh7UJwYKPUTL1C6CUBm
         gCleIB70Cd9ueSQT1Jx/h+J0ToDK/wHK/1gLVqH9BYrlenA/xf/McNnHxr1mUE/NL6YM
         NeO/4QBa1Y4RENC55vklwqHZ/MjRiIh9KGjPDD8SVL8sFEyEYPCvth84ZaNaW2ieB2CQ
         vXKNP3rNtL02gZbhbs01Wgtua1jADOAyyB0R/cP4phLuKkv1V8Qci0mITVwBlNdKf4fT
         9cWA57BMB114S8OiCTpIoeHmygPJN3qCthpD+QCTKSfQR/OE8CIKbqsxneQhHPyzVpGK
         Iu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqvz2LGyE7knId3mboqOpZqiWxGHqUhxacItbVAXPoM=;
        b=zJnuvrugUEcy3imhFjVa45AOlt+6mztOjwDkfudV9SphHQHjee5IIO3EbhcMVXQCRv
         C+pnaolEAWnRkgja5n3pGl+FdRNmZzmT+4ocvsQ+sxxdcdGz1h4+AtkNQupGOM9TOHOo
         fOudg/F0J2Cw1TpeO3t7yU0Gw/9dvBPA3jBupzJxB4N6CSE7+7xVjKQ1ELD+ZkBP49NU
         MQJL/uAo223zAny0PQFI2UooQCeGYvu7melYwpDyVgEnwpC79Z4jGpI4Tmt0OVNpdhbD
         uAO2VY6hoxVZ7nYzvimSx99x3YjB8nubEHfd7CEp+7B84nZshJ7oWPNUTpbmEKp6z5Qu
         Nu5Q==
X-Gm-Message-State: AOAM532BJzTNbje8Qa886yWBIMhMFLJfAfirlxSwDDDVSuYff8VMqltO
        82ujxlr4SlYTuXLuaoVr/vieFzx++BSmqQ==
X-Google-Smtp-Source: ABdhPJwOtH8AK9cftf8bbjGegjqJj741fdCsmwoWL7M2WW9khyxEPBobzSlxnmI/L6y5r34UgZbsKg==
X-Received: by 2002:a17:902:cacb:b0:14a:c2ac:5216 with SMTP id y11-20020a170902cacb00b0014ac2ac5216mr4028683pld.163.1642441825812;
        Mon, 17 Jan 2022 09:50:25 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id q19sm15819117pfk.131.2022.01.17.09.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 09:50:25 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v3 iproute2-next 04/11] flower: fix clang warnings
Date:   Mon, 17 Jan 2022 09:50:12 -0800
Message-Id: <20220117175019.13993-5-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220117175019.13993-1-stephen@networkplumber.org>
References: <20220117175019.13993-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing non-format string to print_string.
Handle this by splitting json and non-json parts.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/f_flower.c | 49 ++++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 6d70b92a2894..f4dd2ce194c4 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -102,6 +102,12 @@ static void explain(void)
 		"	to specify different mask, he has to use different prio.\n");
 }
 
+static void print_indent_name_value(const char *name, const char *value)
+{
+	print_string(PRINT_FP, NULL, "%s  ", _SL_);
+	print_string_name_value(name, value);
+}
+
 static int flower_parse_eth_addr(char *str, int addr_type, int mask_type,
 				 struct nlmsghdr *n)
 {
@@ -1925,10 +1931,9 @@ static int __mask_bits(char *addr, size_t len)
 	return bits;
 }
 
-static void flower_print_eth_addr(char *name, struct rtattr *addr_attr,
+static void flower_print_eth_addr(const char *name, struct rtattr *addr_attr,
 				  struct rtattr *mask_attr)
 {
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	SPRINT_BUF(b1);
 	size_t done;
@@ -1949,9 +1954,7 @@ static void flower_print_eth_addr(char *name, struct rtattr *addr_attr,
 			sprintf(out + done, "/%d", bits);
 	}
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_indent_name_value(name, out);
 }
 
 static void flower_print_eth_type(__be16 *p_eth_type,
@@ -2064,7 +2067,6 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 {
 	struct rtattr *addr_attr;
 	struct rtattr *mask_attr;
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 	int family;
@@ -2095,10 +2097,9 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 	else if (bits < len * 8)
 		sprintf(out + done, "/%d", bits);
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_indent_name_value(name, out);
 }
+
 static void flower_print_ip4_addr(char *name, struct rtattr *addr_attr,
 				  struct rtattr *mask_attr)
 {
@@ -2124,22 +2125,18 @@ static void flower_print_port_range(char *name, struct rtattr *min_attr,
 		print_hu(PRINT_JSON, "end", NULL, rta_getattr_be16(max_attr));
 		close_json_object();
 	} else {
-		SPRINT_BUF(namefrm);
 		SPRINT_BUF(out);
 		size_t done;
 
 		done = sprintf(out, "%u", rta_getattr_be16(min_attr));
 		sprintf(out + done, "-%u", rta_getattr_be16(max_attr));
-		print_nl();
-		sprintf(namefrm, "  %s %%s", name);
-		print_string(PRINT_ANY, name, namefrm, out);
+		print_indent_name_value(name, out);
 	}
 }
 
 static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 				   struct rtattr *mask_attr)
 {
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 
@@ -2150,9 +2147,7 @@ static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 	if (mask_attr)
 		sprintf(out + done, "/%x", rta_getattr_be16(mask_attr));
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_indent_name_value(name, out);
 }
 
 static void flower_print_ct_state(struct rtattr *flags_attr,
@@ -2239,14 +2234,11 @@ static void flower_print_ct_mark(struct rtattr *attr,
 
 static void flower_print_key_id(const char *name, struct rtattr *attr)
 {
-	SPRINT_BUF(namefrm);
-
 	if (!attr)
 		return;
 
 	print_nl();
-	sprintf(namefrm, "  %s %%u", name);
-	print_uint(PRINT_ANY, name, namefrm, rta_getattr_be32(attr));
+	print_uint_name_value(name, rta_getattr_be32(attr));
 }
 
 static void flower_print_geneve_opts(const char *name, struct rtattr *attr,
@@ -2342,8 +2334,9 @@ static void flower_print_erspan_opts(const char *name, struct rtattr *attr,
 	sprintf(strbuf, "%u:%u:%u:%u", ver, idx, dir, hwid);
 }
 
-static void flower_print_enc_parts(const char *name, const char *namefrm,
-				   struct rtattr *attr, char *key, char *mask)
+static void __attribute__((format(printf, 2, 0)))
+flower_print_enc_parts(const char *name, const char *namefrm,
+		       struct rtattr *attr, char *key, char *mask)
 {
 	char *key_token, *mask_token, *out;
 	int len;
@@ -2431,7 +2424,6 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 {
 	const char *value_str = NULL;
 	__u8 value, mask;
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 
@@ -2451,9 +2443,7 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 	if (mask != UINT8_MAX)
 		sprintf(out + done, "/%d", mask);
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_indent_name_value(name, out);
 }
 
 static void flower_print_u8(const char *name, struct rtattr *attr)
@@ -2463,14 +2453,11 @@ static void flower_print_u8(const char *name, struct rtattr *attr)
 
 static void flower_print_u32(const char *name, struct rtattr *attr)
 {
-	SPRINT_BUF(namefrm);
-
 	if (!attr)
 		return;
 
 	print_nl();
-	sprintf(namefrm, "  %s %%u", name);
-	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
+	print_uint_name_value(name, rta_getattr_u32(attr));
 }
 
 static void flower_print_mpls_opt_lse(struct rtattr *lse)
-- 
2.30.2

