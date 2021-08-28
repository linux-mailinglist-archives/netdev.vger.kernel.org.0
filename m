Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7973FA543
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhH1LJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbhH1LJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:09:12 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE733C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:20 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bt14so19702252ejb.3
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 04:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DD7LcPhr/pr5PsIEFmZ+1SXoj1kQBxj9xbFMpbeFkjI=;
        b=JH8bS1C3+Z9aP/wBRH9TwSlGJtnw5zJihP29xXzdSa492HV04LPqAxzoXoGXkjHsnR
         qjtG8QVnuIDLjTqBmNhE/Jbc8lbbgTF3USOkH7oF08dgc4stBYO/Kg71kF1X22n8fSmu
         fpO7IzxvaV1tycOFuLgprTZxHAe2duSVIDLldqGKP3mrXLj/tKFfH1pOrod/xY+3xKeH
         Y2604b9e5kj54gnKePTEtUVom7inZXMTDxeqfo9xRosqWwGQfjc/8Ydf8EudSpW2FsZT
         8tYPBT7YOcnMBpCE2OAdwKzIV+myMJRpbbPHpE3pwcgprFCxIfxMn2pVz/jr0DY28HLs
         1m9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DD7LcPhr/pr5PsIEFmZ+1SXoj1kQBxj9xbFMpbeFkjI=;
        b=pbhGu9iVH4AhTqgH95ucknI7csfJpyfoX1js2MGYgdUbvmLjMQ4BjIYYTJHYXTyHWh
         WgpgXdfY4ytA+w/v1wxzOKe9tB0KIREO/3faQj1310bH5qEGonpRut4F+XKXOnav9+yf
         3ZNWogPVhLeVP/TEJJOlHWmKOcd5NGE+NKKizeeK3gIx6IF/UD6ftN42TT8QBCJeN0qR
         yGXNXsWhd7T1alvI3gmoX7FbS0QV0L8oDANxt44Dx4voVZhXOEngJ8ZLS3UO3KlhOCF3
         2nBpNu650O0TXM7v73tvLrtUDoUliVYyq9gIWIZaqdq3qpUX3K1rAelh9ZoHPVqaZCYd
         6PTw==
X-Gm-Message-State: AOAM530l6loMczTqG2u7n5Xjqb05eUhsyfyBfxmdyDUFqnVuGWaVbc0f
        Z8io7LEgFUsfaRGbgHBB4LNkv6WhBNcJZbDm
X-Google-Smtp-Source: ABdhPJw7/+v2nWyjyA0WlICSsfOazmA3+9k7Yaiim+idBho2XDrNgiPIekpITzI+SrXuZGR/r3zPDg==
X-Received: by 2002:a17:906:3548:: with SMTP id s8mr15326407eja.185.1630148899065;
        Sat, 28 Aug 2021 04:08:19 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i19sm4710429edx.54.2021.08.28.04.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 04:08:18 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, dsahern@gmail.com, stephen@networkplumber.org,
        Joachim Wiberg <troglobit@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next v2 04/19] bridge: vlan: add support to show global vlan options
Date:   Sat, 28 Aug 2021 14:07:50 +0300
Message-Id: <20210828110805.463429-5-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828110805.463429-1-razor@blackwall.org>
References: <20210828110805.463429-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add support for new bridge vlan command grouping called global which
operates on global options. The first command it supports is "show".
To do that we update print_vlan_rtm to recognize the global vlan options
attribute and parse it properly.
Man page and help are also updated with the new command.

Syntax is: $ bridge vlan global show [ vid VID ] [ dev DEV ]

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
v2: previously this was patch 02 which is now split in 02-04
    use strcmp instead of matches

 bridge/br_common.h |   3 +-
 bridge/monitor.c   |   2 +-
 bridge/vlan.c      | 110 +++++++++++++++++++++++++++++++++++++++++++--
 man/man8/bridge.8  |  21 +++++++++
 4 files changed, 130 insertions(+), 6 deletions(-)

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
index 7e4254283373..8a2cc306cb07 100644
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
 
@@ -621,6 +622,25 @@ static int print_vlan_stats(struct nlmsghdr *n, void *arg)
 	return 0;
 }
 
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
 static void print_vlan_opts(struct rtattr *a)
 {
 	struct rtattr *vtb[BRIDGE_VLANDB_ENTRY_MAX + 1];
@@ -680,7 +700,7 @@ static void print_vlan_opts(struct rtattr *a)
 		__print_one_vlan_stats(&vstats);
 }
 
-int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
+int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only)
 {
 	struct br_vlan_msg *bvm = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
@@ -722,7 +742,8 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 		unsigned short rta_type = a->rta_type & NLA_TYPE_MASK;
 
 		/* skip unknown attributes */
-		if (rta_type > BRIDGE_VLANDB_MAX)
+		if (rta_type > BRIDGE_VLANDB_MAX ||
+		    (global_only && rta_type != BRIDGE_VLANDB_GLOBAL_OPTIONS))
 			continue;
 
 		if (vlan_rtm_cur_ifidx != bvm->ifindex) {
@@ -737,6 +758,9 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 		case BRIDGE_VLANDB_ENTRY:
 			print_vlan_opts(a);
 			break;
+		case BRIDGE_VLANDB_GLOBAL_OPTIONS:
+			print_vlan_global_opts(a);
+			break;
 		}
 		close_json_object();
 	}
@@ -746,7 +770,12 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 
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
@@ -864,6 +893,61 @@ out:
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
@@ -908,6 +992,22 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 		close_vlan_port();
 }
 
+static int vlan_global(int argc, char **argv)
+{
+	if (argc > 0) {
+		if (strcmp(*argv, "show") == 0 ||
+		    strcmp(*argv, "lst") == 0 ||
+		    strcmp(*argv, "list") == 0)
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
@@ -926,6 +1026,8 @@ int do_vlan(int argc, char **argv)
 		}
 		if (matches(*argv, "set") == 0)
 			return vlan_option_set(argc-1, argv+1);
+		if (strcmp(*argv, "global") == 0)
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

