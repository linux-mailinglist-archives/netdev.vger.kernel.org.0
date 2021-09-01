Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9D83FE486
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 23:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243887AbhIAVH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 17:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhIAVHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 17:07:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20770C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 14:06:28 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso666176pjb.3
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 14:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZCsAaqkaMqVNpPiQ+1MN5P21w/b+dAuGzd40sboF9PM=;
        b=zH6Z3M6AGoPThrljQGuj3JIOlk3RnroP0mcRtvFdG6eMFcj9NWgcFnhehZZR9XX3Oa
         5O4Lm3iLaYdlTK8U5d87KVIjjI6mfIpeh8cCukThle83DhFcahTCy+mDdLqgZKg9D+9z
         8GmbuWkdg1mTlwXdqH0q3YMR4LbrB3yML4hhREqS/m0qVNSQAQ7C1rJmEuEJCg9BPR2L
         6T7il3DDmfAwm7UheSfw+Waz8FpjwZBSJ9DjSBpM3kZhBU+PBAtaDBy8rf2+8lsZHNVj
         gNTUIYh/V2AIAL7ADO7vfJsIGUaFF/pn513efNMqkxhoRURi4pbkIYWL0MU3clLsfM2T
         Q1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZCsAaqkaMqVNpPiQ+1MN5P21w/b+dAuGzd40sboF9PM=;
        b=QvArp860WFr61Vcv/ahK+GWkTCGoHF900SZ4VcnBlqBdsyadJsW7rouqGWJ34X/cOI
         tEwV8Qp9+iDa5iPa1NlQdg5qtI2WomJaZoch+ZYkGSvIzX3mXAui8qv0LhnhwDX4rBGP
         ZFoxevO+wzXqsvZ9eenlGF7F364LNjyfPxWQQpO93GSa6JMmVtbiFX6kCSSFY2hUXivS
         3NFrMy/bbHbOJYuHhU/ko2+8bLmxux3yLuhkIKCn75alOjq5FEWjq6v3WlhVZtU/vjsc
         mZ+e3FdDs5Ey6w4YNCDyKFaasZM2TdsYBZel72Ma1kn1+QQZT7rBTc9RtLCe+Dc0vPQ9
         x32Q==
X-Gm-Message-State: AOAM531ntirjn4YpMmSN58E38ib7wHjh6eDeV16Dy39TLOpJh5RNAUCj
        oOfXB0N7R3UsdbIE48PoyfVsvFOYqtCFPQ==
X-Google-Smtp-Source: ABdhPJxnUTufKBvUmlpqlhocbrSUTkhEQGrJyEiQrBotPAXKSnkRz/8yUkWeLT2eT2jS6F2oMPBrKw==
X-Received: by 2002:a17:90a:4549:: with SMTP id r9mr1281832pjm.147.1630530387073;
        Wed, 01 Sep 2021 14:06:27 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id y1sm590191pga.50.2021.09.01.14.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 14:06:26 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] ip: remove leftovers from IPX and DECnet
Date:   Wed,  1 Sep 2021 14:05:55 -0700
Message-Id: <20210901210554.23495-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iproute2 has not supported DECnet or IPX since version 5.0.
There were some leftover support in the ip options flags
and parsing, remove these.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/utils.h | 11 -----------
 ip/ip.c         |  4 +---
 ip/ipneigh.c    |  3 +--
 lib/utils.c     | 22 ++--------------------
 man/man8/ip.8   |  2 --
 5 files changed, 4 insertions(+), 38 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 28eaad8e8303..c984946138b4 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -109,17 +109,6 @@ static inline bool is_addrtype_inet_not_multi(const inet_prefix *p)
 	return (p->flags & ADDRTYPE_INET_MULTI) == ADDRTYPE_INET;
 }
 
-#define DN_MAXADDL 20
-#ifndef AF_DECnet
-#define AF_DECnet 12
-#endif
-
-struct dn_naddr
-{
-        unsigned short          a_len;
-        unsigned char a_addr[DN_MAXADDL];
-};
-
 #ifndef AF_MPLS
 # define AF_MPLS 28
 #endif
diff --git a/ip/ip.c b/ip/ip.c
index e7ffeaff3391..b07a5c7d23d8 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -72,7 +72,7 @@ static void usage(void)
 		"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] |\n"
 		"                    -h[uman-readable] | -iec | -j[son] | -p[retty] |\n"
 		"                    -f[amily] { inet | inet6 | mpls | bridge | link } |\n"
-		"                    -4 | -6 | -I | -D | -M | -B | -0 |\n"
+		"                    -4 | -6 | -M | -B | -0 |\n"
 		"                    -l[oops] { maximum-addr-flush-attempts } | -br[ief] |\n"
 		"                    -o[neline] | -t[imestamp] | -ts[hort] | -b[atch] [filename] |\n"
 		"                    -rc[vbuf] [size] | -n[etns] name | -N[umeric] | -a[ll] |\n"
@@ -224,8 +224,6 @@ int main(int argc, char **argv)
 			preferred_family = AF_INET6;
 		} else if (strcmp(opt, "-0") == 0) {
 			preferred_family = AF_PACKET;
-		} else if (strcmp(opt, "-D") == 0) {
-			preferred_family = AF_DECnet;
 		} else if (strcmp(opt, "-M") == 0) {
 			preferred_family = AF_MPLS;
 		} else if (strcmp(opt, "-B") == 0) {
diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 95bde520fbfc..b778de00b242 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -328,8 +328,7 @@ int print_neigh(struct nlmsghdr *n, void *arg)
 	if (!(filter.state&r->ndm_state) &&
 	    !(r->ndm_flags & NTF_PROXY) &&
 	    !(r->ndm_flags & NTF_EXT_LEARNED) &&
-	    (r->ndm_state || !(filter.state&0x100)) &&
-	    (r->ndm_family != AF_DECnet))
+	    (r->ndm_state || !(filter.state&0x100)))
 		return 0;
 
 	if (filter.master && !(n->nlmsg_flags & NLM_F_DUMP_FILTERED)) {
diff --git a/lib/utils.c b/lib/utils.c
index 0559923beced..53d310060284 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -540,7 +540,7 @@ static int __get_addr_1(inet_prefix *addr, const char *name, int family)
 	memset(addr, 0, sizeof(*addr));
 
 	if (strcmp(name, "default") == 0) {
-		if ((family == AF_DECnet) || (family == AF_MPLS))
+		if (family == AF_MPLS)
 			return -1;
 		addr->family = family;
 		addr->bytelen = af_byte_len(addr->family);
@@ -551,7 +551,7 @@ static int __get_addr_1(inet_prefix *addr, const char *name, int family)
 
 	if (strcmp(name, "all") == 0 ||
 	    strcmp(name, "any") == 0) {
-		if ((family == AF_DECnet) || (family == AF_MPLS))
+		if (family == AF_MPLS)
 			return -1;
 		addr->family = family;
 		addr->bytelen = 0;
@@ -636,10 +636,6 @@ int af_bit_len(int af)
 		return 128;
 	case AF_INET:
 		return 32;
-	case AF_DECnet:
-		return 16;
-	case AF_IPX:
-		return 80;
 	case AF_MPLS:
 		return 20;
 	}
@@ -729,16 +725,6 @@ int get_addr_rta(inet_prefix *dst, const struct rtattr *rta, int family)
 		dst->bytelen = 16;
 		memcpy(dst->data, data, 16);
 		break;
-	case 2:
-		dst->family = AF_DECnet;
-		dst->bytelen = 2;
-		memcpy(dst->data, data, 2);
-		break;
-	case 10:
-		dst->family = AF_IPX;
-		dst->bytelen = 10;
-		memcpy(dst->data, data, 10);
-		break;
 	default:
 		return -1;
 	}
@@ -1029,8 +1015,6 @@ int read_family(const char *name)
 		family = AF_INET6;
 	else if (strcmp(name, "link") == 0)
 		family = AF_PACKET;
-	else if (strcmp(name, "ipx") == 0)
-		family = AF_IPX;
 	else if (strcmp(name, "mpls") == 0)
 		family = AF_MPLS;
 	else if (strcmp(name, "bridge") == 0)
@@ -1046,8 +1030,6 @@ const char *family_name(int family)
 		return "inet6";
 	if (family == AF_PACKET)
 		return "link";
-	if (family == AF_IPX)
-		return "ipx";
 	if (family == AF_MPLS)
 		return "mpls";
 	if (family == AF_BRIDGE)
diff --git a/man/man8/ip.8 b/man/man8/ip.8
index c3598a022fa2..2a4848b785f0 100644
--- a/man/man8/ip.8
+++ b/man/man8/ip.8
@@ -37,8 +37,6 @@ ip \- show / manipulate routing, network devices, interfaces and tunnels
 .BR inet " | " inet6 " | " link " } | "
 \fB-4\fR |
 \fB-6\fR |
-\fB-I\fR |
-\fB-D\fR |
 \fB-B\fR |
 \fB-0\fR |
 \fB-l\fR[\fIoops\fR] { \fBmaximum-addr-flush-attempts\fR } |
-- 
2.30.2

