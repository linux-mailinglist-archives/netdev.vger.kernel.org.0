Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09BF3F8866
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242672AbhHZNKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242551AbhHZNKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:25 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08435C0612A3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:37 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i6so4618803edu.1
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8N2re8clnk6JqvcltxkYZ1Njjnm96fT4O114rkbfUCI=;
        b=x2wwmhvDkCOm3UFyFK9vA5skA6QteKFYcUrOxixAS/adBP2tg4QXWpSRjnzn9ac5dc
         olArXFRinmalyP4EUzz6rEfAf7e75ddae1ejKGIxTxkBZlBNStW907wa59YVsUxlB6Om
         G81+s6pMv3kzvdjekyzIykUW4tE0oVaLsuf0z20zDMuZvHFrmZ4EWcYiv3ECjxvb6kRS
         gtJajiwljSLXKlWzu2FnTR0EBXiE9HWj11S3GPefnJ423VT9qcMcXwsaBzCGHPIruv+T
         1jLI+ESzWVDvPf5h4pkEV50aununLG2f+CA7eH8MWM6bz26QyWiiKppEz8ll2y61GKa7
         znkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8N2re8clnk6JqvcltxkYZ1Njjnm96fT4O114rkbfUCI=;
        b=ZuW5CG2/fTjyNiUdobDsrFQ5U8+HLqJ6tePVFYp6TS3iXZjzIgieC/T9zccAF7WOqk
         /RRIr8VXr+pKQkumKwkVqJ2eOF71nzeQhj7tj9N+BNtfwwOxyOVQOqBqHUkFHdsO7AFk
         S7VNiVUnBeuQMfpnBMzY5il3yJLGdwjRXndw0T+wU3rUbhJKwcmRqZ5UKrdSNX3nDVqT
         RTuEEtzynqSY5lD3cxq7cVo2NuObPo0+j3X7NIxVnTcisCZuA7bAmtASrYZl8tROZSA2
         /hkNDMNPmUF6mGlGK4ZlMY8N1cN03Z8ESYVDXcvzmq0dAX5voXVbSZbU9/aEpq/HGSsy
         lw6Q==
X-Gm-Message-State: AOAM531Ge6ctuhSSX16sL+40sAOquxe3XASGYKVigvFc+wxT0KKkkHKJ
        2FFBFfUK140hrE8aIDXmoKbYlWCj1UxRhqu8
X-Google-Smtp-Source: ABdhPJzHmvvg6tV3ANp0q8erZoeZ3ibb96Qx675vJ1qYOcsUmuWyzT+CjleIlcTwHVhO092oiJBlyA==
X-Received: by 2002:a05:6402:5212:: with SMTP id s18mr4176778edd.160.1629983375357;
        Thu, 26 Aug 2021 06:09:35 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:34 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 17/17] bridge: vlan: add support for dumping router ports
Date:   Thu, 26 Aug 2021 16:05:33 +0300
Message-Id: <20210826130533.149111-18-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add dump support for vlan multicast router ports and their details if
requested. If details are requested we print 1 entry per line, otherwise
we print all router ports on a single line similar to how mdb prints
them.

Looks like:
$ bridge vlan global show vid 100
 port              vlan-id
 bridge            100
                     mcast_snooping 1 mcast_querier 0 mcast_igmp_version 2 mcast_mld_version 1 mcast_last_member_count 2 mcast_last_member_interval 100 mcast_startup_query_count 2 mcast_startup_query_interval 3125 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000
                     router ports: ens20 ens16

Looks like (with -s):
 $ bridge -s vlan global show vid 100
 port              vlan-id
 bridge            100
                     mcast_snooping 1 mcast_querier 0 mcast_igmp_version 2 mcast_mld_version 1 mcast_last_member_count 2 mcast_last_member_interval 100 mcast_startup_query_count 2 mcast_startup_query_interval 3125 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000
                     router ports: ens20   187.57 temp
                                   ens16   118.27 temp

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/br_common.h |  1 +
 bridge/mdb.c       |  6 +++---
 bridge/vlan.c      | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index 09f42c814918..610e83f65603 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -14,6 +14,7 @@ void print_stp_state(__u8 state);
 int parse_stp_state(const char *arg);
 int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor,
 		   bool global_only);
+void br_print_router_port_stats(struct rtattr *pattr);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/mdb.c b/bridge/mdb.c
index b427d878677f..7b5863d31c46 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -59,7 +59,7 @@ static const char *format_timer(__u32 ticks, int align)
 	return tbuf;
 }
 
-static void __print_router_port_stats(FILE *f, struct rtattr *pattr)
+void br_print_router_port_stats(struct rtattr *pattr)
 {
 	struct rtattr *tb[MDBA_ROUTER_PATTR_MAX + 1];
 
@@ -101,13 +101,13 @@ static void br_print_router_ports(FILE *f, struct rtattr *attr,
 			print_string(PRINT_JSON, "port", NULL, port_ifname);
 
 			if (show_stats)
-				__print_router_port_stats(f, i);
+				br_print_router_port_stats(i);
 			close_json_object();
 		} else if (show_stats) {
 			fprintf(f, "router ports on %s: %s",
 				brifname, port_ifname);
 
-			__print_router_port_stats(f, i);
+			br_print_router_port_stats(i);
 			fprintf(f, "\n");
 		} else {
 			fprintf(f, "%s ", port_ifname);
diff --git a/bridge/vlan.c b/bridge/vlan.c
index acc6a2e4b885..40e2c4f7b50c 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -802,6 +802,36 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
+static void print_vlan_router_ports(struct rtattr *rattr)
+{
+	int rem = RTA_PAYLOAD(rattr);
+	struct rtattr *i;
+
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+	open_json_array(PRINT_ANY, is_json_context() ? "router_ports" :
+						       "router ports: ");
+	for (i = RTA_DATA(rattr); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
+		uint32_t *port_ifindex = RTA_DATA(i);
+		const char *port_ifname = ll_index_to_name(*port_ifindex);
+
+		open_json_object(NULL);
+		if (show_stats && i != RTA_DATA(rattr)) {
+			print_nl();
+			/* start: IFNAMSIZ + 4 + strlen("router ports: ") */
+			print_string(PRINT_FP, NULL,
+				     "%-" __stringify(IFNAMSIZ) "s    "
+				     "              ",
+				     "");
+		}
+		print_string(PRINT_ANY, "port", "%s ", port_ifname);
+		if (show_stats)
+			br_print_router_port_stats(i);
+		close_json_object();
+	}
+	close_json_array(PRINT_JSON, NULL);
+	print_nl();
+}
+
 static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 {
 	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1], *vattr;
@@ -901,6 +931,10 @@ static void print_vlan_global_opts(struct rtattr *a, int ifindex)
 			     rta_getattr_u64(vattr));
 	}
 	print_nl();
+	if (vtb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS]) {
+		vattr = RTA_DATA(vtb[BRIDGE_VLANDB_GOPTS_MCAST_ROUTER_PORTS]);
+		print_vlan_router_ports(vattr);
+	}
 	close_json_object();
 }
 
-- 
2.31.1

