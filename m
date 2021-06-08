Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E7239FAC7
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhFHPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhFHPfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:35:25 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9725C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 08:33:22 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id x14so13227419ljp.7
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 08:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6MwjdJLeEpSC0apKdrMCy6GpFHPBUueYy/xEq2Hv4io=;
        b=fjmvSBle2rfmnqCOj9mYP9XZeXEC2K2bL6Ac2BJbfq+wMPy15Btaslyu1Fj0CL/M+b
         QEP8WiEaLBJQfjgEuLC+qOGTpTzYUpXCJpNh0O/hP0TN0caZvD9TkYnFKUt4xmuFmhBK
         f3/sdoTjyEUUD/0TWMajxgGAHNFKXiIq7tPgixgT01RxcTu+jrEKK+oDPsZ+1idZ4AE2
         MIsnVrebooWXNh5jx9uog4VHWJYg7KB/QnGZWDvjDdb72B8hWOWCV+fTfnUo7D1PjeKT
         VwM44NkjmMchrkQGVuhWFUlcm9Y/0gkhveu1wcnTkHGHfbOIk8Q55AXjV6UvB3idhdwk
         1cPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6MwjdJLeEpSC0apKdrMCy6GpFHPBUueYy/xEq2Hv4io=;
        b=djS/FxguyJPo1+jKke2RhDnuegMpR89amZ+09+UWL70G2I8L1o+kAh55mBZhzIL2KP
         RlYbGMITBHVcrD6wp8y3DYpgGGDheE9pdScN3ChQd7OQwb+3vN/CK8aRdqwHM4aoB/8n
         gW0AuVT2UYlMkMtH4z58wts/Vx9SAFprLVaTvBvsFRg2zK7pZXLLb/1Ligi8nsIdKmKu
         itLyzJorIUq6QZRT84lxCwaYCtRaexQeyPPPGDiqp5hvWy5+Jhfobcttmoes6F3a1Tyj
         dfxTmmQUYuC8fTZ0HrSOJbaLTKqes+8TiWFcQuNofYsgSVg6HdHyS621vACpoWyayB+J
         W4Jg==
X-Gm-Message-State: AOAM530pWypeXdDf4kPlqfBW4HXyGQx1hIoDSErp8V+74dHJmdvTXPGY
        jtSl1l4K8t5VPBzxQnusvWMLipqm1QV6fixR
X-Google-Smtp-Source: ABdhPJzM/08uzCGHyIYYMAmJjEX71m9k5C6l6ILgI4iH8eKn1CRyiGkFQaxmFYAnZISpNzeipd9LHA==
X-Received: by 2002:a05:651c:157:: with SMTP id c23mr18218313ljd.393.1623166401124;
        Tue, 08 Jun 2021 08:33:21 -0700 (PDT)
Received: from dau-work-pc.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id h4sm10483ljk.4.2021.06.08.08.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:33:20 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [RFC 1/3] [RFC iproute2-next] tc: f_u32: Rename commands and functions ip6 to ipv6 to unify naming
Date:   Tue,  8 Jun 2021 18:33:07 +0300
Message-Id: <20210608153309.4019-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before patch:
~$ tc filter add dev dummy0 parent 1: protocol ipv6 prio 10 \
    u32 match ip6 src aa:bb:cc:dd::/128 flowid 1:1

After patch:
~$ tc filter add dev dummy0 parent 1: protocol ipv6 prio 10 \
    u32 match ipv6 src aa:bb:cc:dd::/128 flowid 1:1

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 tc/f_u32.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index 2ed5254a..3fd3eb17 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -35,7 +35,7 @@ static void explain(void)
 		"or         u32 divisor DIVISOR\n"
 		"\n"
 		"Where: SELECTOR := SAMPLE SAMPLE ...\n"
-		"       SAMPLE := { ip | ip6 | udp | tcp | icmp | u{32|16|8} | mark }\n"
+		"       SAMPLE := { ip | ipv6 | udp | tcp | icmp | u{32|16|8} | mark }\n"
 		"                 SAMPLE_ARGS [ divisor DIVISOR ]\n"
 		"       FILTERID := X:Y:Z\n"
 		"\nNOTE: CLASSID is parsed at hexadecimal input.\n");
@@ -356,7 +356,7 @@ static int parse_ip_addr(int *argc_p, char ***argv_p, struct tc_u32_sel *sel,
 	return res;
 }
 
-static int parse_ip6_addr(int *argc_p, char ***argv_p,
+static int parse_ipv6_addr(int *argc_p, char ***argv_p,
 			  struct tc_u32_sel *sel, int off)
 {
 	int res = -1;
@@ -403,7 +403,7 @@ static int parse_ip6_addr(int *argc_p, char ***argv_p,
 	return res;
 }
 
-static int parse_ip6_class(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
+static int parse_ipv6_class(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 {
 	int res = -1;
 	int argc = *argc_p;
@@ -538,7 +538,7 @@ static int parse_ip(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 	return res;
 }
 
-static int parse_ip6(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
+static int parse_ipv6(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 {
 	int res = -1;
 	int argc = *argc_p;
@@ -549,13 +549,13 @@ static int parse_ip6(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 
 	if (strcmp(*argv, "src") == 0) {
 		NEXT_ARG();
-		res = parse_ip6_addr(&argc, &argv, sel, 8);
+		res = parse_ipv6_addr(&argc, &argv, sel, 8);
 	} else if (strcmp(*argv, "dst") == 0) {
 		NEXT_ARG();
-		res = parse_ip6_addr(&argc, &argv, sel, 24);
-	} else if (strcmp(*argv, "priority") == 0) {
+		res = parse_ipv6_addr(&argc, &argv, sel, 24);
+	} else if (strcmp(*argv, "priority") == 0 || strcmp(*argv, "class") == 0) {
 		NEXT_ARG();
-		res = parse_ip6_class(&argc, &argv, sel);
+		res = parse_ipv6_class(&argc, &argv, sel);
 	} else if (strcmp(*argv, "protocol") == 0) {
 		NEXT_ARG();
 		res = parse_u8(&argc, &argv, sel, 6, 0);
@@ -712,9 +712,9 @@ static int parse_selector(int *argc_p, char ***argv_p,
 	} else if (matches(*argv, "ip") == 0) {
 		NEXT_ARG();
 		res = parse_ip(&argc, &argv, sel);
-	} else	if (matches(*argv, "ip6") == 0) {
+	} else	if (matches(*argv, "ip6") == 0 || matches(*argv, "ipv6") == 0) {
 		NEXT_ARG();
-		res = parse_ip6(&argc, &argv, sel);
+		res = parse_ipv6(&argc, &argv, sel);
 	} else if (matches(*argv, "udp") == 0) {
 		NEXT_ARG();
 		res = parse_udp(&argc, &argv, sel);
-- 
2.20.1

