Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644DE39FA2C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhFHPUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhFHPUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:20:00 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDA8C061574
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 08:17:56 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id r16so8322850ljk.9
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 08:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKlzMs2lD1tYCQcR5b54DlEhQgqSRloMljB35g+LwsU=;
        b=h/AceNhMfplleyi/DryeEaDTCMwM1BUnIF7vV/772/TxHitshHY8vP2Sx5BaxYcXgv
         iCcnIQFo7RVwiZZD24Qv1YOznJj1rf6MpMPdtJc7HuyD68dYAGDTd7RELNiHRKI1iAs1
         k9yb0xNm0cxvkH/8SLAojMIM5UmU6gDCQY2Rl2ob4lkMdEKUi49wzs8IY2+CPw/Oe9s+
         cR/HY+R/Fwjsc2kycYIUslFSsnVsvY/TD7gEqlX0jifOQbUfxrt2OafDfOg2ph4nQVZ2
         XXNYPm5xEhcJGEO1NSeXNsyH/6pwueIGtFRBNIXT+VcCnnTrh5zw4UwdqGOGXTQsPx2K
         yPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kKlzMs2lD1tYCQcR5b54DlEhQgqSRloMljB35g+LwsU=;
        b=bkxiaKd1WRwxXfHNZ6+XfzhatPmEjC4kJHEVhhATEJrFD+wdRPp7iIbYLX9GMLRczQ
         1bQ6wbDbHASpHhM8K6+PSdXv9f60aKvzVNFV6Nz5GLWccnSb1RVy5pqM2pbBX1WZmBMr
         tulSQ0jVvuPqHNxHXC249QissOM9A9CaX67WPeOsmaus+IqTAKQ9sGScGRG9/6vnS1iV
         RwAbWO7nTKw743hCyyrWb2ndOe8w00rdm9hXmjCa3pXxtNFPc0dSy8Tzp7n4T4j3Mo/Y
         DIHpx/PqLt4AV7McvQwaCnBJmN6Pn08WoirODb6GhQU7xu2kDzysVj8Vkv2Mcfa+Oq1M
         ijrQ==
X-Gm-Message-State: AOAM532PUDC49HtiDBvqiURM3Yuaff7Z7ghRS1R6BoyWR9vhHZdKK8qB
        +fBIUtDBwdOwt5iIcAKtKaU=
X-Google-Smtp-Source: ABdhPJxd8RxswzB7scm+jTQeLS5UwfCIKgzXPXvjwpn8MMfFr+NAXdWHVNKIy6uN42KnJ++NQhARmQ==
X-Received: by 2002:a2e:b890:: with SMTP id r16mr18574636ljp.300.1623165474866;
        Tue, 08 Jun 2021 08:17:54 -0700 (PDT)
Received: from dau-work-pc.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id x10sm2367ljj.126.2021.06.08.08.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 08:17:54 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH] [RFC iproute2-next] tc: f_u32: Fix the ipv6 pretty printing.
Date:   Tue,  8 Jun 2021 18:17:37 +0300
Message-Id: <20210608151739.3220-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unexpectedly the print_ipv6 function is the copy-paste version of the print_ipv4 function. Fixed.

Before patch:

$ sudo tc -p -s f ls dev dummy0
filter parent 1: protocol ipv6 pref 30 u32 chain 0
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800: ht divisor 1
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )
  match IP src 64.0.0.0/32 (success 0 )
  match IP dst 0.0.0.0/32 (success 0 )
  match sport 0, match dport 0 (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::801 order 2049 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )  (success 0 )  (success 0 )  (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::802 order 2050 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )
  match IP src 0.204.0.221/32 (success 0 )
  match IP dst 0.0.0.0/1 (success 0 )  (success 0 )  (success 0 )  (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::803 order 2051 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::804 order 2052 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::805 order 2053 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
  match IP ihl 1 (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::806 order 2054 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::807 order 2055 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0) (success 0 )

After patch:

$ sudo tc -p -s f ls dev dummy0
filter parent 1: protocol ipv6 pref 30 u32 chain 0
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800: ht divisor 1
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::800 order 2048 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 src 2a02:26e0:4000::/128
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::801 order 2049 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 dst 2a02:26e0:4000::/128
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::802 order 2050 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 src aa:bb:cc:dd::/65
 match ipv6 dst aa:bb:cc:dd::/66
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::803 order 2051 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 class 0xff 0xff (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::804 order 2052 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 class 0x10 0xff (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::805 order 2053 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 class 0x10 0xf0 (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::806 order 2054 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 flowlabel 0xbcde 0xffff (success 0 )
filter parent 1: protocol ipv6 pref 30 u32 chain 0 fh 800::807 order 2055 key ht 800 bkt 0 flowid 1:1 not_in_hw  (rule hit 0 success 0)
 match ipv6 class 0x12 0xff
 match ipv6 flowlabel 0xbcde 0xffff (success 0 )

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 tc/f_u32.c | 152 +++++++++++++++++++++++++++++------------------------
 1 file changed, 82 insertions(+), 70 deletions(-)

diff --git a/tc/f_u32.c b/tc/f_u32.c
index 3fd3eb17..d7beb586 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -820,28 +820,28 @@ static int parse_hashkey(int *argc_p, char ***argv_p, struct tc_u32_sel *sel)
 	return 0;
 }
 
-static void print_ipv4(FILE *f, const struct tc_u32_key *key)
+static int print_ipv4(FILE *f, const struct tc_u32_key *key)
 {
 	char abuf[256];
 
+	if (key == NULL)
+		return 0;
+
 	switch (key->off) {
 	case 0:
 		switch (ntohl(key->mask)) {
 		case 0x0f000000:
-			fprintf(f, "\n  match IP ihl %u",
+			return fprintf(f, "\n  match IP ihl %u",
 				ntohl(key->val) >> 24);
-			return;
 		case 0x00ff0000:
-			fprintf(f, "\n  match IP dsfield %#x",
+			return fprintf(f, "\n  match IP dsfield %#x",
 				ntohl(key->val) >> 16);
-			return;
 		}
 		break;
 	case 8:
 		if (ntohl(key->mask) == 0x00ff0000) {
-			fprintf(f, "\n  match IP protocol %d",
+			return fprintf(f, "\n  match IP protocol %d",
 				ntohl(key->val) >> 16);
-			return;
 		}
 		break;
 	case 12:
@@ -849,12 +849,11 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 			int bits = mask2bits(key->mask);
 
 			if (bits >= 0) {
-				fprintf(f, "\n  %s %s/%d",
+				return fprintf(f, "\n  %s %s/%d",
 					key->off == 12 ? "match IP src" : "match IP dst",
 					inet_ntop(AF_INET, &key->val,
 						  abuf, sizeof(abuf)),
 					bits);
-				return;
 			}
 		}
 		break;
@@ -862,87 +861,100 @@ static void print_ipv4(FILE *f, const struct tc_u32_key *key)
 	case 20:
 		switch (ntohl(key->mask)) {
 		case 0x0000ffff:
-			fprintf(f, "\n  match dport %u",
+			return fprintf(f, "\n  match dport %u",
 				ntohl(key->val) & 0xffff);
-			return;
 		case 0xffff0000:
-			fprintf(f, "\n  match sport %u",
+			return fprintf(f, "\n  match sport %u",
 				ntohl(key->val) >> 16);
-			return;
 		case 0xffffffff:
-			fprintf(f, "\n  match dport %u, match sport %u",
+			return fprintf(f, "\n  match dport %u, match sport %u",
 				ntohl(key->val) & 0xffff,
 				ntohl(key->val) >> 16);
 
-			return;
 		}
 		/* XXX: Default print_raw */
 	}
+
+	return 0;
 }
 
-static void print_ipv6(FILE *f, const struct tc_u32_key *key)
+static int print_ipv6(FILE *f, const struct tc_u32_key *key)
 {
 	char abuf[256];
 
+	static __u32 ipv6_src_addr[4];
+	static int ipv6_src_plen;
+	static __u32 ipv6_dst_addr[4];
+	static int ipv6_dst_plen;
+
+	int ret = 0;
+
+	if ((key == NULL || key->off >= 24) && ipv6_src_plen > 0) {
+		ret = fprintf(f, "\n match ipv6 src %s/%d",
+			inet_ntop(AF_INET6, ipv6_src_addr, abuf, sizeof(abuf)), ipv6_src_plen);
+		memset(ipv6_src_addr, 0, 16);
+		ipv6_src_plen = 0;
+	}
+
+	if (key == NULL && ipv6_dst_plen > 0) {
+		ret += fprintf(f, "\n match ipv6 dst %s/%d",
+			inet_ntop(AF_INET6, ipv6_dst_addr, abuf, sizeof(abuf)), ipv6_dst_plen);
+		memset(ipv6_dst_addr, 0, 16);
+		ipv6_dst_plen = 0;
+	}
+
+	if (key == NULL)
+		return ret;
+
 	switch (key->off) {
 	case 0:
-		switch (ntohl(key->mask)) {
-		case 0x0f000000:
-			fprintf(f, "\n  match IP ihl %u",
-				ntohl(key->val) >> 24);
-			return;
-		case 0x00ff0000:
-			fprintf(f, "\n  match IP dsfield %#x",
-				ntohl(key->val) >> 16);
-			return;
+		if (ntohl(key->mask) & 0x0ff00000) {
+			ret = fprintf(f, "\n match ipv6 class %#x %#x",
+				(ntohl(key->val) & 0x0ff00000) >> 20,
+				(ntohl(key->mask) & 0x0ff00000) >> 20);
+		}
+		if (ntohl(key->mask) & 0x000fffff) {
+			ret += fprintf(f, "\n match ipv6 flowlabel %#x %#x",
+				ntohl(key->val) & 0x000fffff,
+				ntohl(key->mask) & 0x000fffff);
 		}
+		return ret;
 		break;
-	case 8:
-		if (ntohl(key->mask) == 0x00ff0000) {
-			fprintf(f, "\n  match IP protocol %d",
-				ntohl(key->val) >> 16);
-			return;
+	case 4:
+		if (ntohl(key->mask) == 0x0000ff00) {
+			return fprintf(f, "\n  match ipv6 protocol %d",
+				ntohl(key->val) >> 8);
 		}
 		break;
+	case 8:
 	case 12:
-	case 16: {
-			int bits = mask2bits(key->mask);
-
-			if (bits >= 0) {
-				fprintf(f, "\n  %s %s/%d",
-					key->off == 12 ? "match IP src" : "match IP dst",
-					inet_ntop(AF_INET, &key->val,
-						  abuf, sizeof(abuf)),
-					bits);
-				return;
-			}
+	case 16:
+	case 20: {
+			ipv6_src_plen += mask2bits(key->mask);
+			ipv6_src_addr[(key->off - 8) / 4] = key->val;
 		}
 		break;
-
-	case 20:
-		switch (ntohl(key->mask)) {
-		case 0x0000ffff:
-			fprintf(f, "\n  match sport %u",
-				ntohl(key->val) & 0xffff);
-			return;
-		case 0xffff0000:
-			fprintf(f, "\n  match dport %u",
-				ntohl(key->val) >> 16);
-			return;
-		case 0xffffffff:
-			fprintf(f, "\n  match sport %u, match dport %u",
-				ntohl(key->val) & 0xffff,
-				ntohl(key->val) >> 16);
-
-			return;
+	case 24:
+	case 28:
+	case 32:
+	case 36: {
+			ipv6_dst_plen += mask2bits(key->mask);
+			ipv6_dst_addr[(key->off - 24) / 4] = key->val;
 		}
+		break;
+
 		/* XXX: Default print_raw */
 	}
+
+	return 0;
 }
 
-static void print_raw(FILE *f, const struct tc_u32_key *key)
+static int print_raw(FILE *f, const struct tc_u32_key *key)
 {
-	fprintf(f, "\n  match %08x/%08x at %s%d",
+	if (key == NULL)
+		return 0;
+
+	return fprintf(f, "\n  match %08x/%08x at %s%d",
 		(unsigned int)ntohl(key->val),
 		(unsigned int)ntohl(key->mask),
 		key->offmask ? "nexthdr+" : "",
@@ -952,14 +964,14 @@ static void print_raw(FILE *f, const struct tc_u32_key *key)
 static const struct {
 	__u16 proto;
 	__u16 pad;
-	void (*pprinter)(FILE *f, const struct tc_u32_key *key);
+	int (*pprinter)(FILE *f, const struct tc_u32_key *key);
 } u32_pprinters[] = {
 	{0,	   0, print_raw},
 	{ETH_P_IP, 0, print_ipv4},
 	{ETH_P_IPV6, 0, print_ipv6},
 };
 
-static void show_keys(FILE *f, const struct tc_u32_key *key)
+static int show_keys(FILE *f, const struct tc_u32_key *key)
 {
 	int i = 0;
 
@@ -969,8 +981,7 @@ static void show_keys(FILE *f, const struct tc_u32_key *key)
 	for (i = 0; i < ARRAY_SIZE(u32_pprinters); i++) {
 		if (u32_pprinters[i].proto == ntohs(f_proto)) {
 show_k:
-			u32_pprinters[i].pprinter(f, key);
-			return;
+			return u32_pprinters[i].pprinter(f, key);
 		}
 	}
 
@@ -1289,12 +1300,13 @@ static int u32_print_opt(struct filter_util *qu, FILE *f, struct rtattr *opt,
 	if (sel) {
 		if (sel->nkeys) {
 			int i;
-
-			for (i = 0; i < sel->nkeys; i++) {
-				show_keys(f, sel->keys + i);
-				if (show_stats && NULL != pf)
-					fprintf(f, " (success %llu ) ",
-						(unsigned long long) pf->kcnts[i]);
+			// The ipv6 pretty printing requires an additional call at the end.
+			// Call the show_keys with the NULL value after call with last key.
+			for (i = 0; i <= sel->nkeys; i++) {
+				if (show_keys(f, i < sel->nkeys ? sel->keys + i : NULL))
+					if (i < sel->nkeys && show_stats && NULL != pf)
+						fprintf(f, " (success %llu ) ",
+							(unsigned long long) pf->kcnts[i]);
 			}
 		}
 
-- 
2.20.1

