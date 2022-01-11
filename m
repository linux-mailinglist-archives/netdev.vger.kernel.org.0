Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2134248B4A7
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344837AbiAKRyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344769AbiAKRyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:54:46 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E32C061748
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:46 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id pj2so192658pjb.2
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8d+DsDwmdySukuhCezTmxH0T4hTAAmO9JWrNTsw04LA=;
        b=X2LamkwZUz4tzqfNj0h3XTKQUd9iEzFTuQKx7I9uzG3NJYUL6pyNP06Veyht2asB92
         9p+CVFCceh0H+sKfrtOKjEGStFh1c+/8c/1RNhuawVZmE8qrLcLUGllog9R8196RUe2+
         1KwM6y1JYliETmeHmgiW2BpsC156XtOzk8UX04m4yqioEOqJToEmidto90aVywaGoobE
         Jz5WmkNCaPrM9tMBS2zyU84aqdgT5dTyy896cqA1dNgMEk20A9MV01YqLJkb6miRVIpy
         YDAHBRj3HViYigIG3HqV9oIEv9nFfK9Kt5JHL7sher6aFuheGKp4AAey77yPXjtqCNmF
         dPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8d+DsDwmdySukuhCezTmxH0T4hTAAmO9JWrNTsw04LA=;
        b=rsR9vAkTxEVzU8eMOufIylWp88pUL6iq5r6RscaMQd7RPTtDSriqMA/C59fvB0Q6e8
         1xKsMUiFWDmaX6K8fCeXeSpSaKNOJx0r+hIyoIr0gaxOXbbWz1SDgQhfF7tlVDG72/iS
         Dpl6MRZvEPkLLt/o4+Q20KaoWyw9DP9XRiVqjknlW5Ws4pWf4qrMuw1P0o5MHwl5iXns
         yrNak1Juh+LJiizIceTpxtuaSc67fB5UMdlNglrJdw74k+PGtaWeJtQcPhE9ruBNYFLQ
         /SJ+J9XO+7j28beNGOA/b5oSC5JVCuleeTbStr4GuCun/X4/1JMwRHDUD+BzykBwUqnp
         7TAw==
X-Gm-Message-State: AOAM530Ld2rhl6VETCE49cL2z7AIeGXcjkFa3hk0GtqEMCB6ZTbvrvEw
        r1XnqAW2DJh3hjKEKYZ9cDEdtiRoPljoeA==
X-Google-Smtp-Source: ABdhPJye4f9Z/gq5CYzJk3QWvf6lEKM3NG/fBnYO6fgaYc9+6jQu9dDipvzf3BcGBUTEhDEx6xHmdA==
X-Received: by 2002:a63:6e4e:: with SMTP id j75mr5081469pgc.293.1641923685590;
        Tue, 11 Jan 2022 09:54:45 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id f8sm23925pga.69.2022.01.11.09.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:54:45 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH v2 iproute2-next 04/11] flower: fix clang warnings
Date:   Tue, 11 Jan 2022 09:54:31 -0800
Message-Id: <20220111175438.21901-5-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220111175438.21901-1-sthemmin@microsoft.com>
References: <20220111175438.21901-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang complains about passing non-format string to print_string.
Handle this by splitting json and non-json parts.

Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 tc/f_flower.c | 38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 6d70b92a2894..1dcce8c4aa95 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1925,10 +1925,9 @@ static int __mask_bits(char *addr, size_t len)
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
@@ -1950,8 +1949,7 @@ static void flower_print_eth_addr(char *name, struct rtattr *addr_attr,
 	}
 
 	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_string_name_value(name, out);
 }
 
 static void flower_print_eth_type(__be16 *p_eth_type,
@@ -2064,7 +2062,6 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 {
 	struct rtattr *addr_attr;
 	struct rtattr *mask_attr;
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 	int family;
@@ -2096,9 +2093,9 @@ static void flower_print_ip_addr(char *name, __be16 eth_type,
 		sprintf(out + done, "/%d", bits);
 
 	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_string_name_value(name, out);
 }
+
 static void flower_print_ip4_addr(char *name, struct rtattr *addr_attr,
 				  struct rtattr *mask_attr)
 {
@@ -2124,22 +2121,19 @@ static void flower_print_port_range(char *name, struct rtattr *min_attr,
 		print_hu(PRINT_JSON, "end", NULL, rta_getattr_be16(max_attr));
 		close_json_object();
 	} else {
-		SPRINT_BUF(namefrm);
 		SPRINT_BUF(out);
 		size_t done;
 
 		done = sprintf(out, "%u", rta_getattr_be16(min_attr));
 		sprintf(out + done, "-%u", rta_getattr_be16(max_attr));
 		print_nl();
-		sprintf(namefrm, "  %s %%s", name);
-		print_string(PRINT_ANY, name, namefrm, out);
+		print_string_name_value(name, out);
 	}
 }
 
 static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 				   struct rtattr *mask_attr)
 {
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 
@@ -2151,8 +2145,7 @@ static void flower_print_tcp_flags(const char *name, struct rtattr *flags_attr,
 		sprintf(out + done, "/%x", rta_getattr_be16(mask_attr));
 
 	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_string_name_value(name, out);
 }
 
 static void flower_print_ct_state(struct rtattr *flags_attr,
@@ -2239,14 +2232,11 @@ static void flower_print_ct_mark(struct rtattr *attr,
 
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
@@ -2342,8 +2332,9 @@ static void flower_print_erspan_opts(const char *name, struct rtattr *attr,
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
@@ -2431,7 +2422,6 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 {
 	const char *value_str = NULL;
 	__u8 value, mask;
-	SPRINT_BUF(namefrm);
 	SPRINT_BUF(out);
 	size_t done;
 
@@ -2452,8 +2442,7 @@ static void flower_print_masked_u8(const char *name, struct rtattr *attr,
 		sprintf(out + done, "/%d", mask);
 
 	print_nl();
-	sprintf(namefrm, "  %s %%s", name);
-	print_string(PRINT_ANY, name, namefrm, out);
+	print_string_name_value(name, out);
 }
 
 static void flower_print_u8(const char *name, struct rtattr *attr)
@@ -2463,14 +2452,11 @@ static void flower_print_u8(const char *name, struct rtattr *attr)
 
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

