Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0FD3E43DB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbhHIKXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbhHIKXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:05 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1902C0617BA
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 03:22:42 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m12so20679366wru.12
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 03:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MBbw5q8180eb6a63Vg1eAZyVOGc/Apk3WWE/RPB9XXQ=;
        b=pJRMIjIhU+FRp5Bw3/KX/gz+lPlAkVzdbcloBOt0YG3+R8npAfvNWY7mpne5NKuY1U
         3KNho090a1p/5ZONEdyDx4lVth9e4CoMRQ5pSUbg1qBnm5+Ab8z4HcwwlMQBIug0DJ2a
         Th0vmSgPeYKkk0P0su20WnpVq29YT/zrbcbPtuzGHNxuXhhhvPAerPFWj/w62eTGh3b9
         gue+sYvqZRfVHLrk95lbZWqzFDcC3fDMf/QvUeTOo6HiX4apaF51NQRefGIHmlkPoMxH
         QNFCwkuHasvhG/wOa4LAGjeeftqLdaf2zjb5TgNkiG6+rfCyXwYwONrOp63I3wHpAt+S
         +L/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MBbw5q8180eb6a63Vg1eAZyVOGc/Apk3WWE/RPB9XXQ=;
        b=iPPMP5hH6ggAKvXXoed8eHIHnG5bZPVSXTRpOSDTnlETFTKDp8GbcNP8qMjF0WHPk7
         MOq7GlUEzkTxWqTi93DkZ6U/Qhb5qSSTQxZzC2qNdXzBkuh8Ie+Cu/ZBmAhIFxe1EaFM
         kXxelugUqudju5aTDAOlXVWOWgXX678SWvGU/80f5Z+oPRjbdj1O1rrwg96/oxBqm0F0
         29VYWlCf2S8hojf71mL61czcn+UcDOjS061kR4C7K72SzHBZ2XKJJG6dlgEnZW9A7Tb7
         fk2qzpzc6uiXe/tLXnAdCp60NC7KoJDyy2zDjSWEWA+e7peIEPivbDWzdkGd0mxNxTqI
         SlBA==
X-Gm-Message-State: AOAM530+M6N2lmPs19hzxyRfzvvCeSgwi9r7gaiOCCHuDdItQYjy0Iez
        hgM/rNI+op+biN+28R+Im7mQTALHD3yHXw==
X-Google-Smtp-Source: ABdhPJwTL0hPaIqe2vLItPzRx4UtT3IN3axLzWvYOMzE8vzAc8iaGpXYI7IARpUF4TddBDtpvfykOQ==
X-Received: by 2002:a05:6000:92:: with SMTP id m18mr23750615wrx.277.1628504561291;
        Mon, 09 Aug 2021 03:22:41 -0700 (PDT)
Received: from localhost.localdomain ([217.155.64.254])
        by smtp.gmail.com with ESMTPSA id d4sm1859589wrp.57.2021.08.09.03.22.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 03:22:40 -0700 (PDT)
From:   Ilya Dmitrichenko <errordeveloper@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ilya Dmitrichenko <errordeveloper@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iproute2 v2] ip/tunnel: always print all known attributes
Date:   Mon,  9 Aug 2021 11:22:39 +0100
Message-Id: <20210809102239.9569-1-errordeveloper@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210722151132.4384026a@hermes.local>
References: <20210722151132.4384026a@hermes.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Presently, if a Geneve or VXLAN interface was created with 'external',
it's not possible for a user to determine e.g. the value of 'dstport'
after creation. This change fixes that by avoiding early returns.

This change partly reverts commit 00ff4b8e31af ("ip/tunnel: Be consistent
when printing tunnel collect metadata").

Signed-off-by: Ilya Dmitrichenko <errordeveloper@gmail.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
---
 ip/iplink_geneve.c | 12 ++++--------
 ip/iplink_vxlan.c  | 12 ++++--------
 ip/link_gre.c      |  1 -
 ip/link_gre6.c     |  1 -
 ip/link_ip6tnl.c   |  1 -
 ip/link_iptnl.c    |  1 -
 6 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/ip/iplink_geneve.c b/ip/iplink_geneve.c
index 9299236c..78fc818e 100644
--- a/ip/iplink_geneve.c
+++ b/ip/iplink_geneve.c
@@ -243,7 +243,6 @@ static int geneve_parse_opt(struct link_util *lu, int argc, char **argv,
 
 static void geneve_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
-	__u32 vni;
 	__u8 ttl = 0;
 	__u8 tos = 0;
 
@@ -252,15 +251,12 @@ static void geneve_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_GENEVE_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
-	if (!tb[IFLA_GENEVE_ID] ||
-	    RTA_PAYLOAD(tb[IFLA_GENEVE_ID]) < sizeof(__u32))
-		return;
-
-	vni = rta_getattr_u32(tb[IFLA_GENEVE_ID]);
-	print_uint(PRINT_ANY, "id", "id %u ", vni);
+	if (tb[IFLA_GENEVE_ID] &&
+	    RTA_PAYLOAD(tb[IFLA_GENEVE_ID]) >= sizeof(__u32)) {
+		print_uint(PRINT_ANY, "id", "id %u ", rta_getattr_u32(tb[IFLA_GENEVE_ID]));
+	}
 
 	if (tb[IFLA_GENEVE_REMOTE]) {
 		__be32 addr = rta_getattr_u32(tb[IFLA_GENEVE_REMOTE]);
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index bae9d994..9afa3cca 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -408,7 +408,6 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 
 static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
-	__u32 vni;
 	__u8 ttl = 0;
 	__u8 tos = 0;
 	__u32 maxaddr;
@@ -419,15 +418,12 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 	if (tb[IFLA_VXLAN_COLLECT_METADATA] &&
 	    rta_getattr_u8(tb[IFLA_VXLAN_COLLECT_METADATA])) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
-	if (!tb[IFLA_VXLAN_ID] ||
-	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) < sizeof(__u32))
-		return;
-
-	vni = rta_getattr_u32(tb[IFLA_VXLAN_ID]);
-	print_uint(PRINT_ANY, "id", "id %u ", vni);
+	if (tb[IFLA_VXLAN_ID] &&
+	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
+		print_uint(PRINT_ANY, "id", "id %u ", rta_getattr_u32(tb[IFLA_VXLAN_ID]));
+	}
 
 	if (tb[IFLA_VXLAN_GROUP]) {
 		__be32 addr = rta_getattr_u32(tb[IFLA_VXLAN_GROUP]);
diff --git a/ip/link_gre.c b/ip/link_gre.c
index 6d4a8be8..f462a227 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -442,7 +442,6 @@ static void gre_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_GRE_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	tnl_print_endpoint("remote", tb[IFLA_GRE_REMOTE], AF_INET);
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index f33598af..232d9bde 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -461,7 +461,6 @@ static void gre_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 	if (tb[IFLA_GRE_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	if (tb[IFLA_GRE_FLAGS])
diff --git a/ip/link_ip6tnl.c b/ip/link_ip6tnl.c
index c7b49b02..2fcc13ef 100644
--- a/ip/link_ip6tnl.c
+++ b/ip/link_ip6tnl.c
@@ -344,7 +344,6 @@ static void ip6tunnel_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb
 
 	if (tb[IFLA_IPTUN_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	if (tb[IFLA_IPTUN_FLAGS])
diff --git a/ip/link_iptnl.c b/ip/link_iptnl.c
index 636cdb2c..b25855ba 100644
--- a/ip/link_iptnl.c
+++ b/ip/link_iptnl.c
@@ -368,7 +368,6 @@ static void iptunnel_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[
 
 	if (tb[IFLA_IPTUN_COLLECT_METADATA]) {
 		print_bool(PRINT_ANY, "external", "external ", true);
-		return;
 	}
 
 	if (tb[IFLA_IPTUN_PROTO]) {
-- 
2.29.2

