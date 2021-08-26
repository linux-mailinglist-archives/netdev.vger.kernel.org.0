Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0113F8857
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242400AbhHZNKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241790AbhHZNKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:07 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677E5C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id s25so4661638edw.0
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j+2VolArdcPmMu0Oy9cOK4261/tdEnIPHSKXG49BBLM=;
        b=ILUzRAYfCp/jL7iMIZkjG63M1/ZnRU9V/cUMI8irf9U+EydWuYaOsgiIWZYhPkGbVz
         bowj93GTY28eqzdaLkl5QZyZ3/aQqwgA141XYy56GnFYMB/TNnrQEepSkGKkiOJ5cwp+
         7qsDPrZgiHJwpUs9Br4f2nGgcwgirQdqIHvMMOW9lvMfP/qHqbcedsoLrq12y1xZy6Sc
         zl+eoY06nH1txa6mW16SWtCboqo/Be3OtLDb53ECzz0/kylcQnEC3QXYdhCBSt5f1jzM
         qfDn0L/2J1n61X3wePke4oWfonlupZvlj7QQkZggDRRnzmGYZ/JnpW3LNHZ6FyuKmwt0
         +nbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j+2VolArdcPmMu0Oy9cOK4261/tdEnIPHSKXG49BBLM=;
        b=rDXz4Af/CSddnpuKmr7Byr82x49dWI8AMeYCh/Us+WgWuqv9iIisQStPXn7yA6Xmam
         hBdYfuDXUnMU+pOXtMUgXn0ExyGDLulhQmKeMHbJTlD+tznqmCboXC65mMRAATMl6OCp
         Ax9/J2ZV72HuoeHIeDwN09vvSWakcc92nasaq4mE+gOs7c7PkkYG2fStC/DngZIu7ktS
         MK4e6zgzWdwNmz7F1ScuSviPndAfNkRsyXeOIwAR/oX8pk/ZJMnURUS3VzWpeCVBw0T5
         LqjaFph4+0bQGS5QO5qq9GatsRfGJuKoCcEt4SnmK68000Hwg/zmpnvQOMG9CkRMSAfk
         R6bQ==
X-Gm-Message-State: AOAM533xFk1Qj3xyMVVRyz1r0WwVKb3F/nd4jCvPOOWT3iTKR5DVpZRd
        +BpSZ37Rv65k4FyCRTKiqb/9fpXHylvzjhzO
X-Google-Smtp-Source: ABdhPJz8EkQWdB75LAtjCxVN6LWiIikLDMr5OnEOT+Od8WEUMhmzCGuONiRPDniFY/lwJPK9gkUjVw==
X-Received: by 2002:a50:8e51:: with SMTP id 17mr4273960edx.308.1629983357598;
        Thu, 26 Aug 2021 06:09:17 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:17 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 02/17] bridge: vlan: add support to show global vlan options
Date:   Thu, 26 Aug 2021 16:05:18 +0300
Message-Id: <20210826130533.149111-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210826130533.149111-1-razor@blackwall.org>
References: <20210826130533.149111-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for new bridge vlan command grouping called global which
operates on global options. The first command it supports is "show".
Man page and help are also updated with the new command.

Syntax is: $ bridge vlan global show [ vid VID ] [ dev DEV ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 bridge/br_common.h |   3 +-
 bridge/monitor.c   |   2 +-
 bridge/vlan.c      | 229 ++++++++++++++++++++++++++++++++++-----------
 man/man8/bridge.8  |  21 +++++
 4 files changed, 200 insertions(+), 55 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index b9adafd98dea..09f42c814918 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -12,7 +12,8 @@ int print_mdb_mon(struct nlmsghdr *n, void *arg);
 int print_fdb(struct nlmsghdr *n, void *arg);
 void print_stp_state(__u8 state);
 int parse_stp_state(const char *arg);
-int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor);
+int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor,
+		   bool global_only);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/monitor.c b/bridge/monitor.c
index 88f52f52f084..845e221abb49 100644
--- a/bridge/monitor.c
+++ b/bridge/monitor.c
@@ -71,7 +71,7 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 	case RTM_DELVLAN:
 		if (prefix_banner)
 			fprintf(fp, "[VLAN]");
-		return print_vlan_rtm(n, arg, true);
+		return print_vlan_rtm(n, arg, true, false);
 
 	default:
 		return 0;
diff --git a/bridge/vlan.c b/bridge/vlan.c
index 9b6511f189ff..9e33995f8f33 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -36,7 +36,8 @@ static void usage(void)
 		"                                                     [ self ] [ master ]\n"
 		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
-		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n");
+		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
+		"       bridge vlan global { show } [ dev DEV ] [ vid VLAN_ID ]\n");
 	exit(-1);
 }
 
@@ -621,11 +622,89 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
-int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
+static void print_vlan_global_opts(struct rtattr *a)
+{
+	struct rtattr *vtb[BRIDGE_VLANDB_GOPTS_MAX + 1];
+	__u16 vid, vrange = 0;
+
+	if ((a->rta_type & NLA_TYPE_MASK) != BRIDGE_VLANDB_GLOBAL_OPTIONS)
+		return;
+
+	parse_rtattr_flags(vtb, BRIDGE_VLANDB_GOPTS_MAX, RTA_DATA(a),
+			   RTA_PAYLOAD(a), NLA_F_NESTED);
+	vid = rta_getattr_u16(vtb[BRIDGE_VLANDB_GOPTS_ID]);
+	if (vtb[BRIDGE_VLANDB_GOPTS_RANGE])
+		vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_GOPTS_RANGE]);
+	else
+		vrange = vid;
+	print_range("vlan", vid, vrange);
+	print_nl();
+}
+
+static void print_vlan_opts(struct rtattr *a)
+{
+	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1];
+	struct bridge_vlan_xstats vstats;
+	struct bridge_vlan_info *vinfo;
+	__u16 vrange = 0;
+	__u8 state = 0;
+
+	if ((a->rta_type & NLA_TYPE_MASK) != BRIDGE_VLANDB_ENTRY)
+		return;
+
+	parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
+			   RTA_PAYLOAD(a), NLA_F_NESTED);
+	vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
+
+	memset(&vstats, 0, sizeof(vstats));
+	if (vtb[BRIDGE_VLANDB_ENTRY_RANGE])
+		vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_ENTRY_RANGE]);
+	else
+		vrange = vinfo->vid;
+
+	if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
+		state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
+
+	if (vtb[BRIDGE_VLANDB_ENTRY_STATS]) {
+		struct rtattr *stb[BRIDGE_VLANDB_STATS_MAX+1];
+		struct rtattr *attr;
+
+		attr = vtb[BRIDGE_VLANDB_ENTRY_STATS];
+		parse_rtattr(stb, BRIDGE_VLANDB_STATS_MAX, RTA_DATA(attr),
+			     RTA_PAYLOAD(attr));
+
+		if (stb[BRIDGE_VLANDB_STATS_RX_BYTES]) {
+			attr = stb[BRIDGE_VLANDB_STATS_RX_BYTES];
+			vstats.rx_bytes = rta_getattr_u64(attr);
+		}
+		if (stb[BRIDGE_VLANDB_STATS_RX_PACKETS]) {
+			attr = stb[BRIDGE_VLANDB_STATS_RX_PACKETS];
+			vstats.rx_packets = rta_getattr_u64(attr);
+		}
+		if (stb[BRIDGE_VLANDB_STATS_TX_PACKETS]) {
+			attr = stb[BRIDGE_VLANDB_STATS_TX_PACKETS];
+			vstats.tx_packets = rta_getattr_u64(attr);
+		}
+		if (stb[BRIDGE_VLANDB_STATS_TX_BYTES]) {
+			attr = stb[BRIDGE_VLANDB_STATS_TX_BYTES];
+			vstats.tx_bytes = rta_getattr_u64(attr);
+		}
+	}
+	print_range("vlan", vinfo->vid, vrange);
+	print_vlan_flags(vinfo->flags);
+	print_nl();
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+	print_stp_state(state);
+	print_nl();
+	if (show_stats)
+		__print_one_vlan_stats(&vstats);
+}
+
+int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only)
 {
-	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1], *a;
 	struct br_vlan_msg *bvm = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
+	struct rtattr *a;
 	int rem;
 
 	if (n->nlmsg_type != RTM_NEWVLAN && n->nlmsg_type != RTM_DELVLAN &&
@@ -660,49 +739,13 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 
 	rem = len;
 	for (a = BRVLAN_RTA(bvm); RTA_OK(a, rem); a = RTA_NEXT(a, rem)) {
-		struct bridge_vlan_xstats vstats;
-		struct bridge_vlan_info *vinfo;
-		__u32 vrange = 0;
-		__u8 state = 0;
-
-		parse_rtattr_flags(vtb, BRIDGE_VLANDB_ENTRY_MAX, RTA_DATA(a),
-				   RTA_PAYLOAD(a), NLA_F_NESTED);
-		vinfo = RTA_DATA(vtb[BRIDGE_VLANDB_ENTRY_INFO]);
-
-		memset(&vstats, 0, sizeof(vstats));
-		if (vtb[BRIDGE_VLANDB_ENTRY_RANGE])
-			vrange = rta_getattr_u16(vtb[BRIDGE_VLANDB_ENTRY_RANGE]);
-		else
-			vrange = vinfo->vid;
-
-		if (vtb[BRIDGE_VLANDB_ENTRY_STATE])
-			state = rta_getattr_u8(vtb[BRIDGE_VLANDB_ENTRY_STATE]);
+		unsigned short rta_type = a->rta_type & NLA_TYPE_MASK;
 
-		if (vtb[BRIDGE_VLANDB_ENTRY_STATS]) {
-			struct rtattr *stb[BRIDGE_VLANDB_STATS_MAX+1];
-			struct rtattr *attr;
-
-			attr = vtb[BRIDGE_VLANDB_ENTRY_STATS];
-			parse_rtattr(stb, BRIDGE_VLANDB_STATS_MAX, RTA_DATA(attr),
-				     RTA_PAYLOAD(attr));
+		/* skip unknown attributes */
+		if (rta_type > BRIDGE_VLANDB_MAX ||
+		    (global_only && rta_type != BRIDGE_VLANDB_GLOBAL_OPTIONS))
+			continue;
 
-			if (stb[BRIDGE_VLANDB_STATS_RX_BYTES]) {
-				attr = stb[BRIDGE_VLANDB_STATS_RX_BYTES];
-				vstats.rx_bytes = rta_getattr_u64(attr);
-			}
-			if (stb[BRIDGE_VLANDB_STATS_RX_PACKETS]) {
-				attr = stb[BRIDGE_VLANDB_STATS_RX_PACKETS];
-				vstats.rx_packets = rta_getattr_u64(attr);
-			}
-			if (stb[BRIDGE_VLANDB_STATS_TX_PACKETS]) {
-				attr = stb[BRIDGE_VLANDB_STATS_TX_PACKETS];
-				vstats.tx_packets = rta_getattr_u64(attr);
-			}
-			if (stb[BRIDGE_VLANDB_STATS_TX_BYTES]) {
-				attr = stb[BRIDGE_VLANDB_STATS_TX_BYTES];
-				vstats.tx_bytes = rta_getattr_u64(attr);
-			}
-		}
 		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
 			open_vlan_port(bvm->ifindex, VLAN_SHOW_VLAN);
 			open_json_object(NULL);
@@ -711,14 +754,16 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 			open_json_object(NULL);
 			print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s  ", "");
 		}
-		print_range("vlan", vinfo->vid, vrange);
-		print_vlan_flags(vinfo->flags);
-		print_nl();
-		print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
-		print_stp_state(state);
-		print_nl();
-		if (show_stats)
-			__print_one_vlan_stats(&vstats);
+
+		switch (rta_type) {
+		case BRIDGE_VLANDB_ENTRY:
+			print_vlan_opts(a);
+			break;
+		case BRIDGE_VLANDB_GLOBAL_OPTIONS:
+			print_vlan_global_opts(a);
+			break;
+		}
+
 		close_json_object();
 	}
 
@@ -727,7 +772,12 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 
 static int print_vlan_rtm_filter(struct nlmsghdr *n, void *arg)
 {
-	return print_vlan_rtm(n, arg, false);
+	return print_vlan_rtm(n, arg, false, false);
+}
+
+static int print_vlan_rtm_global_filter(struct nlmsghdr *n, void *arg)
+{
+	return print_vlan_rtm(n, arg, false, true);
 }
 
 static int vlan_show(int argc, char **argv, int subject)
@@ -845,6 +895,61 @@ out:
 	return 0;
 }
 
+static int vlan_global_show(int argc, char **argv)
+{
+	__u32 dump_flags = BRIDGE_VLANDB_DUMPF_GLOBAL;
+	int ret = 0, subject = VLAN_SHOW_VLAN;
+	char *filter_dev = NULL;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			if (filter_dev)
+				duparg("dev", *argv);
+			filter_dev = *argv;
+		} else if (strcmp(*argv, "vid") == 0) {
+			NEXT_ARG();
+			if (filter_vlan)
+				duparg("vid", *argv);
+			filter_vlan = atoi(*argv);
+		}
+		argc--; argv++;
+	}
+
+	if (filter_dev) {
+		filter_index = ll_name_to_index(filter_dev);
+		if (!filter_index)
+			return nodev(filter_dev);
+	}
+
+	new_json_obj(json);
+
+	if (rtnl_brvlandump_req(&rth, PF_BRIDGE, dump_flags) < 0) {
+		perror("Cannot send dump request");
+		exit(1);
+	}
+
+	if (!is_json_context()) {
+		printf("%-" __stringify(IFNAMSIZ) "s  %-"
+		       __stringify(VLAN_ID_LEN) "s", "port",
+		       "vlan-id");
+		printf("\n");
+	}
+
+	ret = rtnl_dump_filter(&rth, print_vlan_rtm_global_filter, &subject);
+	if (ret < 0) {
+		fprintf(stderr, "Dump terminated\n");
+		exit(1);
+	}
+
+	if (vlan_rtm_cur_ifidx != -1)
+		close_vlan_port();
+
+	delete_json_obj();
+	fflush(stdout);
+	return 0;
+}
+
 void print_vlan_info(struct rtattr *tb, int ifindex)
 {
 	struct rtattr *i, *list = tb;
@@ -889,6 +994,22 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 		close_vlan_port();
 }
 
+static int vlan_global(int argc, char **argv)
+{
+	if (argc > 0) {
+		if (matches(*argv, "show") == 0 ||
+		    matches(*argv, "lst") == 0 ||
+		    matches(*argv, "list") == 0)
+			return vlan_global_show(argc-1, argv+1);
+		else
+			usage();
+	} else {
+		return vlan_global_show(0, NULL);
+	}
+
+	return 0;
+}
+
 int do_vlan(int argc, char **argv)
 {
 	ll_init_map(&rth);
@@ -907,6 +1028,8 @@ int do_vlan(int argc, char **argv)
 		}
 		if (matches(*argv, "set") == 0)
 			return vlan_option_set(argc-1, argv+1);
+		if (matches(*argv, "global") == 0)
+			return vlan_global(argc-1, argv+1);
 		if (matches(*argv, "help") == 0)
 			usage();
 	} else {
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index eec7df4383bc..9ec4cb1dec67 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -152,6 +152,13 @@ bridge \- show / manipulate bridge addresses and devices
 .B dev
 .IR DEV " ]"
 
+.ti -8
+.BR "bridge vlan global" " [ " show " ] [ "
+.B dev
+.IR DEV " ] [ "
+.B vid
+.IR VID " ]"
+
 .ti -8
 .BR "bridge monitor" " [ " all " | " neigh " | " link " | " mdb " | " vlan " ]"
 
@@ -895,6 +902,20 @@ option, the command displays per-vlan traffic statistics.
 
 This command displays the current vlan tunnel info mapping.
 
+.SS bridge vlan global show - list global vlan options.
+
+This command displays the global VLAN options for each VLAN entry.
+
+.TP
+.BI dev " DEV"
+the interface only whose VLAN global options should be listed. Default is to list
+all bridge interfaces.
+
+.TP
+.BI vid " VID"
+the VLAN ID only whose global options should be listed. Default is to list
+all vlans.
+
 .SH bridge monitor - state monitoring
 
 The
-- 
2.31.1

