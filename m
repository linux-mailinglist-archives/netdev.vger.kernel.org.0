Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1E341C86B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345175AbhI2Pbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 11:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345318AbhI2Pbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:31:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCE8C061765
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:56 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x7so9944435edd.6
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 08:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RNiD2ML6uyrZMgJvYNcGyQqKMQ9MGZdfaIwLCMa/gzQ=;
        b=cE2a3fzrvqb4gx+6K7mI3I8njCp0PjtOgYsQoC/o3QRWafMQSCqGc0mOYfTB9eAtW0
         nWIqk80WkXoSDeU+BIbXZbhBxPYIY+NME5lmva4NvhzklRiDkpwbKuH3+0tQi7J+Kofv
         mFmdZ5xmHNa+QIRs9sSMF8BPV758cJep556XFH8Y3H7nLdsRSUWM+/fZTZWesJ8m9X7N
         X6F2rh39tenewUW1+LVMB4C0dkKWoFVuR6WAUHyRkOKlYhM4reqe9NsV4xNKAExX5lgh
         AEnvTDOgUvS9hAtpUrvX1HJL06FNAiJEZL1DHKkqj+zbiuu1O085rSO6ai5RT86TN37l
         ciug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RNiD2ML6uyrZMgJvYNcGyQqKMQ9MGZdfaIwLCMa/gzQ=;
        b=TZa9bBUSszKI6uwLdHYCX9KVZINbJZTTwUqssuMixym7jxevgWf7TThKmdUok7zdra
         VsKt9SFAqlkPELuPbP3fYJ8+XKNbTlpcMyeIVz0APpPTcY26l4lmGYUEjL+AeIf1rkBM
         fYahob1uCyCc4yd/1p2zqFTYeZk3ps0HDsgw0GS6JkDx1Nlsi5et97EwZcBF8fRvlRJI
         myCzjR54JuDi/JjhTVb4MOpKCMLy6awSiYsVyS49T7Afrn+tMNm9xE07b645TQx9xP9D
         N7ZgBvL/XS4CJmuULO1yOeRJTagJzgFUm8XFPXLIQINWVSHrqMZGUvIrl2NSYNda5RGp
         gC3w==
X-Gm-Message-State: AOAM533EJBPaQ9W0cFy9wKitzgmaoHD7uduJWJ7XdQ8OtxPe8g2ZfTDr
        cuWxsOElGHUQdZ3uCydqlsRTpApyu/GiZo+0
X-Google-Smtp-Source: ABdhPJynVHlNTaPT5wru6r5TuAI9uEEGfIxM4j/jmNHXIV9hhtDnSMzsjgZIg0SI639YYeA+MMcoTg==
X-Received: by 2002:a17:907:374:: with SMTP id rs20mr372413ejb.460.1632929337859;
        Wed, 29 Sep 2021 08:28:57 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q12sm108434ejs.58.2021.09.29.08.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 08:28:57 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC iproute2-next 05/11] ip: nexthop: always parse attributes for printing
Date:   Wed, 29 Sep 2021 18:28:42 +0300
Message-Id: <20210929152848.1710552-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929152848.1710552-1-razor@blackwall.org>
References: <20210929152848.1710552-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Always parse nexthop group attributes into structure for printing. Nexthop
print helpers take structures and print them accordingly.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 ip/ipnexthop.c | 117 +++++++++++++++++++++----------------------------
 1 file changed, 49 insertions(+), 68 deletions(-)

diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
index 9340d8941277..e334b852aa55 100644
--- a/ip/ipnexthop.c
+++ b/ip/ipnexthop.c
@@ -220,28 +220,22 @@ static bool __valid_nh_group_attr(const struct rtattr *g_attr)
 	return num && num * sizeof(struct nexthop_grp) == RTA_PAYLOAD(g_attr);
 }
 
-static void print_nh_group(FILE *fp, const struct rtattr *grps_attr)
+static void print_nh_group(const struct nh_entry *nhe)
 {
-	struct nexthop_grp *nhg = RTA_DATA(grps_attr);
-	int num = RTA_PAYLOAD(grps_attr) / sizeof(*nhg);
 	int i;
 
-	if (!__valid_nh_group_attr(grps_attr)) {
-		fprintf(fp, "<invalid nexthop group>");
-		return;
-	}
-
 	open_json_array(PRINT_JSON, "group");
 	print_string(PRINT_FP, NULL, "%s", "group ");
-	for (i = 0; i < num; ++i) {
+	for (i = 0; i < nhe->nh_groups_cnt; ++i) {
 		open_json_object(NULL);
 
 		if (i)
 			print_string(PRINT_FP, NULL, "%s", "/");
 
-		print_uint(PRINT_ANY, "id", "%u", nhg[i].id);
-		if (nhg[i].weight)
-			print_uint(PRINT_ANY, "weight", ",%u", nhg[i].weight + 1);
+		print_uint(PRINT_ANY, "id", "%u", nhe->nh_groups[i].id);
+		if (nhe->nh_groups[i].weight)
+			print_uint(PRINT_ANY, "weight", ",%u",
+				   nhe->nh_groups[i].weight + 1);
 
 		close_json_object();
 	}
@@ -261,15 +255,14 @@ static const char *nh_group_type_name(__u16 type)
 	}
 }
 
-static void print_nh_group_type(FILE *fp, const struct rtattr *grp_type_attr)
+static void print_nh_group_type(__u16 nh_grp_type)
 {
-	__u16 type = rta_getattr_u16(grp_type_attr);
-
-	if (type == NEXTHOP_GRP_TYPE_MPATH)
+	if (nh_grp_type == NEXTHOP_GRP_TYPE_MPATH)
 		/* Do not print type in order not to break existing output. */
 		return;
 
-	print_string(PRINT_ANY, "type", "type %s ", nh_group_type_name(type));
+	print_string(PRINT_ANY, "type", "type %s ",
+		     nh_group_type_name(nh_grp_type));
 }
 
 static void parse_nh_res_group_rta(const struct rtattr *res_grp_attr,
@@ -299,39 +292,22 @@ static void parse_nh_res_group_rta(const struct rtattr *res_grp_attr,
 	}
 }
 
-static void print_nh_res_group(FILE *fp, const struct rtattr *res_grp_attr)
+static void print_nh_res_group(const struct nha_res_grp *res_grp)
 {
-	struct rtattr *tb[NHA_RES_GROUP_MAX + 1];
-	struct rtattr *rta;
 	struct timeval tv;
 
-	parse_rtattr_nested(tb, NHA_RES_GROUP_MAX, res_grp_attr);
-
 	open_json_object("resilient_args");
 
-	if (tb[NHA_RES_GROUP_BUCKETS])
-		print_uint(PRINT_ANY, "buckets", "buckets %u ",
-			   rta_getattr_u16(tb[NHA_RES_GROUP_BUCKETS]));
+	print_uint(PRINT_ANY, "buckets", "buckets %u ", res_grp->buckets);
 
-	if (tb[NHA_RES_GROUP_IDLE_TIMER]) {
-		rta = tb[NHA_RES_GROUP_IDLE_TIMER];
-		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
-		print_tv(PRINT_ANY, "idle_timer", "idle_timer %g ", &tv);
-	}
+	__jiffies_to_tv(&tv, res_grp->idle_timer);
+	print_tv(PRINT_ANY, "idle_timer", "idle_timer %g ", &tv);
 
-	if (tb[NHA_RES_GROUP_UNBALANCED_TIMER]) {
-		rta = tb[NHA_RES_GROUP_UNBALANCED_TIMER];
-		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
-		print_tv(PRINT_ANY, "unbalanced_timer", "unbalanced_timer %g ",
-			 &tv);
-	}
+	__jiffies_to_tv(&tv, res_grp->unbalanced_timer);
+	print_tv(PRINT_ANY, "unbalanced_timer", "unbalanced_timer %g ", &tv);
 
-	if (tb[NHA_RES_GROUP_UNBALANCED_TIME]) {
-		rta = tb[NHA_RES_GROUP_UNBALANCED_TIME];
-		__jiffies_to_tv(&tv, rta_getattr_u32(rta));
-		print_tv(PRINT_ANY, "unbalanced_time", "unbalanced_time %g ",
-			 &tv);
-	}
+	__jiffies_to_tv(&tv, res_grp->unbalanced_time);
+	print_tv(PRINT_ANY, "unbalanced_time", "unbalanced_time %g ", &tv);
 
 	close_json_object();
 }
@@ -458,9 +434,9 @@ out_err:
 int print_nexthop(struct nlmsghdr *n, void *arg)
 {
 	struct nhmsg *nhm = NLMSG_DATA(n);
-	struct rtattr *tb[NHA_MAX+1];
 	FILE *fp = (FILE *)arg;
-	int len;
+	struct nh_entry nhe;
+	int len, err;
 
 	SPRINT_BUF(b1);
 
@@ -481,56 +457,61 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
 	if (filter.proto && filter.proto != nhm->nh_protocol)
 		return 0;
 
-	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
-
+	err = parse_nexthop_rta(fp, nhm, len, &nhe);
+	if (err) {
+		close_json_object();
+		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(err));
+		return -1;
+	}
 	open_json_object(NULL);
 
 	if (n->nlmsg_type == RTM_DELNEXTHOP)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
 
-	if (tb[NHA_ID])
-		print_uint(PRINT_ANY, "id", "id %u ",
-			   rta_getattr_u32(tb[NHA_ID]));
+	print_uint(PRINT_ANY, "id", "id %u ", nhe.nh_id);
 
-	if (tb[NHA_GROUP])
-		print_nh_group(fp, tb[NHA_GROUP]);
+	if (nhe.nh_groups)
+		print_nh_group(&nhe);
 
-	if (tb[NHA_GROUP_TYPE])
-		print_nh_group_type(fp, tb[NHA_GROUP_TYPE]);
+	print_nh_group_type(nhe.nh_grp_type);
 
-	if (tb[NHA_RES_GROUP])
-		print_nh_res_group(fp, tb[NHA_RES_GROUP]);
+	if (nhe.nh_has_res_grp)
+		print_nh_res_group(&nhe.nh_res_grp);
 
-	if (tb[NHA_ENCAP])
-		lwt_print_encap(fp, tb[NHA_ENCAP_TYPE], tb[NHA_ENCAP]);
+	if (nhe.nh_encap)
+		lwt_print_encap(fp, &nhe.nh_encap_type.rta, nhe.nh_encap);
 
-	if (tb[NHA_GATEWAY])
-		print_rta_gateway(fp, nhm->nh_family, tb[NHA_GATEWAY]);
+	if (nhe.nh_gateway_len)
+		__print_rta_gateway(fp, nhe.nh_family,
+				    format_host(nhe.nh_family,
+						nhe.nh_gateway_len,
+						&nhe.nh_gateway));
 
-	if (tb[NHA_OIF])
-		print_rta_ifidx(fp, rta_getattr_u32(tb[NHA_OIF]), "dev");
+	if (nhe.nh_oif)
+		print_rta_ifidx(fp, nhe.nh_oif, "dev");
 
-	if (nhm->nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
+	if (nhe.nh_scope != RT_SCOPE_UNIVERSE || show_details > 0) {
 		print_string(PRINT_ANY, "scope", "scope %s ",
-			     rtnl_rtscope_n2a(nhm->nh_scope, b1, sizeof(b1)));
+			     rtnl_rtscope_n2a(nhe.nh_scope, b1, sizeof(b1)));
 	}
 
-	if (tb[NHA_BLACKHOLE])
+	if (nhe.nh_blackhole)
 		print_null(PRINT_ANY, "blackhole", "blackhole ", NULL);
 
-	if (nhm->nh_protocol != RTPROT_UNSPEC || show_details > 0) {
+	if (nhe.nh_protocol != RTPROT_UNSPEC || show_details > 0) {
 		print_string(PRINT_ANY, "protocol", "proto %s ",
-			     rtnl_rtprot_n2a(nhm->nh_protocol, b1, sizeof(b1)));
+			     rtnl_rtprot_n2a(nhe.nh_protocol, b1, sizeof(b1)));
 	}
 
-	print_rt_flags(fp, nhm->nh_flags);
+	print_rt_flags(fp, nhe.nh_flags);
 
-	if (tb[NHA_FDB])
+	if (nhe.nh_fdb)
 		print_null(PRINT_ANY, "fdb", "fdb", NULL);
 
 	print_string(PRINT_FP, NULL, "%s", "\n");
 	close_json_object();
 	fflush(fp);
+	destroy_nexthop_entry(&nhe);
 
 	return 0;
 }
-- 
2.31.1

