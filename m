Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B134955D3
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377775AbiATVMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:12:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377771AbiATVMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:12:01 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B60AC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso3895745pjv.1
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 13:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqvz2LGyE7knId3mboqOpZqiWxGHqUhxacItbVAXPoM=;
        b=pa06sAuIA3ZlMeH510153FlurSUQW0i8GFOrKtZEJKp/h9f3DQKz7x6cqKXEgOcOdp
         Uk1HDxaYu2BR3FHttIOJimS648lVNBc9jYrvRDjPGRfO1+X5XrFsTteiqRAyczdmALVU
         B4bUy5e6jSz3HpNd8qVnpZH2k+t8npuktK/kAIrtboUOJwqll5+xBBToehHxNnmguImL
         fSwMFj29cHcIQoX3htpYv8WndgdtyxVu/hPXks+ap17jEscn3EDn+ToXMsoyogZTPBwP
         JqOicj1hTTqh9eQjWJficxQXOj6RPoGNMv9EK0yGACTLT0CQKS9R6sp2q8cEw4necsKz
         v8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqvz2LGyE7knId3mboqOpZqiWxGHqUhxacItbVAXPoM=;
        b=jiFa7RrL71Hgkuzp8T0fY74iRwZkBh8kO/Pq71WtZFliZCrPwDTkDgwjpzLsEaPDzi
         blduySYaSg6ptHSc+HRkAktrLH3zHTamwOGYFMpD8Xgud96Ji7bTDADxvOF/yZnrRglF
         QQFp04cRZZNG0diitcSPO6hj1hX7TUr3YhWtfFHPMlIeZPZvYLypKni92cGh3xc5oVIN
         k9o326aJ8rWO4felQIjbcYiG8jwTE+F24On5nlKGa54ns2Es2EiMz6UFIiHne0+oOiTj
         FB3f2i7+20QmuVPDXZl2agbgz8j69ifzQrP/5tbYV9geYhr/vcGDas8nvluoAvU/sXAW
         z0QQ==
X-Gm-Message-State: AOAM532AY03zJ5TseQoXID83agCC7AvPPebK8fy8c5YM1+fYcutzmQ2w
        hXWkcHGCeAudYLeYdQrT/YDftr4GZm3UCw==
X-Google-Smtp-Source: ABdhPJxv+MVvcxT9EX2Dp7Bh7pkM5096K1/4eR9yHP458UjGeSk7OLsPX8+AMDstY2aWxq2SRtsxuA==
X-Received: by 2002:a17:90b:4b41:: with SMTP id mi1mr13130898pjb.1.1642713120622;
        Thu, 20 Jan 2022 13:12:00 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id rj9sm3357187pjb.49.2022.01.20.13.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 13:11:59 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v4 iproute2-next 04/11] flower: fix clang warnings
Date:   Thu, 20 Jan 2022 13:11:46 -0800
Message-Id: <20220120211153.189476-5-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220120211153.189476-1-stephen@networkplumber.org>
References: <20220120211153.189476-1-stephen@networkplumber.org>
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

