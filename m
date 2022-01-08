Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA4C4885F5
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 21:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbiAHUrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 15:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiAHUq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 15:46:57 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B50C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 12:46:57 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so11402216pjp.0
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 12:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oo58f/CDxEDICbVKNpq8KMWLTQGVgfPS6SqpLesaoss=;
        b=eHqaZkE2bzVQ2XCHQOl7+5DNGmk+se2kvJYmmMHohcZLOHTaK1oymRISWVY6G60+uf
         InWDgZh3zTw7TLbHdMzVOv6zpbcDj+KtZO90/3k+mhUbUX8glfEJ2bRAw5isR1KxhnLJ
         Wdha32dGeRsS56RXcAF5Q1NQvuy6n60fidxe+k0M3m6zlPFHqZ1sf04xMe91KT/QN7WR
         s8urnRXVeJKir6r0SiCHsaew6oB3dgl7bZiRr1tH7lugOCxVLyicHFcUBpd5j6WQx3vL
         AX7ZMMxmIaqiiqGN+oLEbLUKqto8Qx0nSxG557NKKFZBIlsicobo8KPIaT8d7jccFRUm
         Bb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oo58f/CDxEDICbVKNpq8KMWLTQGVgfPS6SqpLesaoss=;
        b=30r9yg7k/ivt4UoiOnaOOURHxIHREne9s4l4iYC8bFrAFUDTkEDZJbv0eDCYQ/RgsS
         MLwTr3BGzV6XGiEm3haWH0rVIGKfkyZ79pisA4IlIoBh6af6lnVvMAuPYMaad38DxTMP
         rYejxn+XKqeQMTuUSdGJnUBkEzM08PkaSbEofUjuAnmkkjvPeWqiv23Adhr03Q1af2NV
         gmMi/oRoN9WhQ4e0xqPGzZyDl10rz2hgMrkq1kc7GtrtaizLjrVf8wxZrTedIoIMfwtL
         MavIOB1cM08PkiKpVGgRKW7/ERGJC6L0nbwsdcp2PzFSrJwO2jh3JLNC1qZ9dkjOrzRl
         1TSA==
X-Gm-Message-State: AOAM532XzYWSE4E6l4Dygv8NYmwNsLLkncrVkzSc/ZJK4iV8XOcY5SpE
        9nDTPiDq+f2r8dRqYB/Cyn+pjPyqIhLRoA==
X-Google-Smtp-Source: ABdhPJwJ8pqqmbU8mfZh1IKpgxqsZc5SzFlZSFF61l/hODQeZSiA7I5wxW3pNy3B8nLmydDlq/GXAw==
X-Received: by 2002:a17:90b:1c8c:: with SMTP id oo12mr21988369pjb.148.1641674816553;
        Sat, 08 Jan 2022 12:46:56 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id u71sm2129393pgd.68.2022.01.08.12.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 12:46:56 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH iproute2-next 05/11] flower: fix clang warnings
Date:   Sat,  8 Jan 2022 12:46:44 -0800
Message-Id: <20220108204650.36185-6-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220108204650.36185-1-sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing non-format string to print_string.
Handle this by splitting json and non-json parts.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 tc/f_flower.c | 62 ++++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 33 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 7f78195fd303..d6ff94ddbefb 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1925,10 +1925,17 @@ static int __mask_bits(char *addr, size_t len)
 	return bits;
 }
 
-static void flower_print_eth_addr(char *name, struct rtattr *addr_attr,
+static void flower_print_string(const char *name, const char *value)
+{
+	print_nl();
+	print_string(PRINT_JSON, name, NULL, value);
+	print_string(PRINT_FP, NULL, "  %s", name);
+	print_string(PRINT_FP, NULL, " %s", value);
+}
+
+static void flower_print_eth_addr(const char *name, struct rtattr *addr_attr,
 				  struct rtattr *mask_attr)
 {
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	SPRINT_BUF(b1);
 	size_t done;
@@ -1949,9 +1956,7 @@ static void flower_print_eth_addr(char *name, struct rtattr *addr_attr,
 			sprintf(out + done, "/%d", bits);
 	}
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	flower_print_string(name, out);
 }
 
 static void flower_print_eth_type(__be16 *p_eth_type,
@@ -2064,7 +2069,6 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 {
 	struct rtattr *addr_attr;
 	struct rtattr *mask_attr;
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 	int family;
@@ -2095,10 +2099,9 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 	else if (bits < len * 8)
 		sprintf(out + done, "/%d", bits);
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	flower_print_string(name, out);
 }
+
 static void flower_print_ip4_addr(char *name, struct rtattr *addr_attr,
 				  struct rtattr *mask_attr)
 {
@@ -2124,22 +2127,19 @@ static void flower_print_port_range(char *name, struct rtattr *min_attr,
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
+
+		flower_print_string(name, out);
 	}
 }
 
 static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 				   struct rtattr *mask_attr)
 {
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 
@@ -2150,9 +2150,7 @@ static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 	if (mask_attr)
 		sprintf(out + done, "/%x", rta_getattr_be16(mask_attr));
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	flower_print_string(name, out);
 }
 
 static void flower_print_ct_state(struct rtattr *flags_attr,
@@ -2237,16 +2235,20 @@ static void flower_print_ct_mark(struct rtattr *attr,
 	print_masked_u32("ct_mark", attr, mask_attr, true);
 }
 
-static void flower_print_key_id(const char *name, struct rtattr *attr)
+static void flower_print_uint(const char *name, unsigned int val)
 {
-	SPRINT_BUF(namefrm);
+	print_nl();
+	print_uint(PRINT_JSON, name, NULL, val);
+	print_string(PRINT_FP, NULL, "  %s", name);
+	print_uint(PRINT_FP, NULL, " %%u", val);
+}
 
+static void flower_print_key_id(const char *name, struct rtattr *attr)
+{
 	if (!attr)
 		return;
 
-	print_nl();
-	sprintf(namefrm, "  %s %%u", name);
-	print_uint(PRINT_ANY, name, namefrm, rta_getattr_be32(attr));
+	flower_print_uint(name, rta_getattr_be32(attr));
 }
 
 static void flower_print_geneve_opts(const char *name, struct rtattr *attr,
@@ -2342,8 +2344,9 @@ static void flower_print_erspan_opts(const char *name, struct rtattr *attr,
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
@@ -2431,7 +2434,6 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 {
 	const char *value_str = NULL;
 	__u8 value, mask;
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 
@@ -2451,9 +2453,7 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 	if (mask != UINT8_MAX)
 		sprintf(out + done, "/%d", mask);
 
-	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	flower_print_string(name, out);
 }
 
 static void flower_print_u8(const char *name, struct rtattr *attr)
@@ -2463,14 +2463,10 @@ static void flower_print_u8(const char *name, struct rtattr *attr)
 
 static void flower_print_u32(const char *name, struct rtattr *attr)
 {
-	SPRINT_BUF(namefrm);
-
 	if (!attr)
 		return;
 
-	print_nl();
-	sprintf(namefrm, "  %s %%u", name);
-	print_uint(PRINT_ANY, name, namefrm, rta_getattr_u32(attr));
+	flower_print_uint(name, rta_getattr_u32(attr));
 }
 
 static void flower_print_mpls_opt_lse(struct rtattr *lse)
-- 
2.30.2

