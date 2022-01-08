Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDD24885BC
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 20:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiAHT70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 14:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiAHT70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 14:59:26 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DE5C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 11:59:26 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id k21so28948077lfu.0
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 11:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmQQjCZvXJaBDJ7E/zeJKuRlqhgtFaus2U/9SW2d+aY=;
        b=I6rgdKgWV00ylEKR3abh9nnc/98CfuSmKKo02kNSSBjsB2N5Apa3BBV/mFv5aCupp2
         WHdX5xWLXi7+vxXwF70CdkaRpoCenRgnHo38Kuu4QyZA0djeY0lnkwFm/ayebHng9PkL
         o6ObGayRf2hejZ12B6xLCTHFjmc2hiY5/jwBO9yXCTcPjPRWdkhlEZ6YDtOvTCe/AxfM
         7Rt0UZ63OoF59+P4VH8aAeaPPbiyi78eTrgMWhI0Zn1JHihLvS+OzcrQz8zJ31tPmKXu
         /BSaeeAJu1+IgUF1h8LCwB7tXy8Gqz37Sh3MXlZG54NsG9fxaxPSBZjb/tkUY4lgaESD
         AnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmQQjCZvXJaBDJ7E/zeJKuRlqhgtFaus2U/9SW2d+aY=;
        b=SLUu2UMvbkodz1xL8v/Ne+ZznnC+t6ezghHzAv3DGS9Wxo8V/V3nnd1opytw4h+NXX
         dZCh319mnOmswfSQI6oDd8CrFOuQnWTqejd1DT1u24p32bq3F0FSqWbw2kyB2n8HCE5N
         VHyPfQ7bqoB7aAqzKxVGMkIH1cC05vbAq9sTbtYqsEL2G3Tt/FVE842Z9xYLnLOySHa3
         j6a9sqVgVIX2Q3JQeecs81xjcoIYIdOpdQySuDtkbnjU6pY8DE6DINrfpagHgBRadlNW
         SQmdAJiG66Gqr/LM8AwFtwB0Rw2VXX/gW72HD8CXvbo6cKrMUr6rw6X7xIyatDa35/58
         tXhA==
X-Gm-Message-State: AOAM532U9JIKhIvKUDPv2Cn2BU3PqPQbG9Cm+AW2Iky3yJO1UAdBEp2I
        eORjzrC2XBp8OI9T7qSvNfryoWiqIcI=
X-Google-Smtp-Source: ABdhPJxvtnkcO418wsi/lH56z59Q9XCdAP90CIszaPwOaoswkZvnIilhkifcdK3p3tPISXsb8SXLuA==
X-Received: by 2002:a19:674b:: with SMTP id e11mr29154210lfj.83.1641671964187;
        Sat, 08 Jan 2022 11:59:24 -0800 (PST)
Received: from dau-work-pc.corp.zonatelecom.ru ([185.17.67.197])
        by smtp.googlemail.com with ESMTPSA id b21sm344740lfv.47.2022.01.08.11.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 11:59:23 -0800 (PST)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     littlesmilingcloud@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2 v2] ip: Extend filter links/addresses
Date:   Sat,  8 Jan 2022 22:58:25 +0300
Message-Id: <20220108195824.23840-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves the filtering of links/addresses with the next
features:
1. Additional types: ether, loopback, ppp
2. Exclude of specific interface type with 'exclude_type' option

Examples:
ip link show type ether
ip address show exclude_type ppp

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 ip/ip_common.h           |  1 +
 ip/ipaddress.c           | 52 ++++++++++++++++++++++++++++++++++++----
 ip/iplink.c              |  2 +-
 man/man8/ip-address.8.in | 16 ++++++++++++-
 man/man8/ip-link.8.in    | 13 +++++++---
 5 files changed, 75 insertions(+), 9 deletions(-)

diff --git a/ip/ip_common.h b/ip/ip_common.h
index ea04c8ff..38377be4 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -26,6 +26,7 @@ struct link_filter {
 	int master;
 	char *kind;
 	char *slave_kind;
+	char *exclude_kind;
 	int target_nsid;
 };
 
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 4109d8bd..c1f0ccde 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -60,7 +60,7 @@ static void usage(void)
 		"       ip address {save|flush} [ dev IFNAME ] [ scope SCOPE-ID ]\n"
 		"                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
 		"       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
-		"                         [ nomaster ]\n"
+		"                         [ nomaster ] [ exclude_type TYPE ]\n"
 		"                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
 		"                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
 		"       ip address {showdump|restore}\n"
@@ -227,6 +227,28 @@ static int match_link_kind(struct rtattr **tb, const char *kind, bool slave)
 	return strcmp(parse_link_kind(tb[IFLA_LINKINFO], slave), kind);
 }
 
+static int match_if_type_name(unsigned short if_type, const char *type_name)
+{
+
+	char *expected_type_name;
+
+	switch (if_type) {
+	case ARPHRD_ETHER:
+		expected_type_name = "ether";
+		break;
+	case ARPHRD_LOOPBACK:
+		expected_type_name = "loopback";
+		break;
+	case ARPHRD_PPP:
+		expected_type_name = "ppp";
+		break;
+	default:
+		expected_type_name = "";
+	}
+
+	return !strcmp(type_name, expected_type_name);
+}
+
 static void print_linktype(FILE *fp, struct rtattr *tb)
 {
 	struct rtattr *linkinfo[IFLA_INFO_MAX+1];
@@ -1023,8 +1045,18 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	} else if (filter.master > 0)
 		return -1;
 
-	if (filter.kind && match_link_kind(tb, filter.kind, 0))
-		return -1;
+	if (filter.exclude_kind) {
+		if (match_link_kind(tb, filter.exclude_kind, 0) == 0 ||
+		    (!tb[IFLA_LINKINFO] && match_if_type_name(ifi->ifi_type, filter.exclude_kind)))
+			return -1;
+	}
+
+	if (filter.kind) {
+		if (!tb[IFLA_LINKINFO] && match_if_type_name(ifi->ifi_type, filter.kind))
+			;
+		else if (match_link_kind(tb, filter.kind, 0) != 0)
+			return -1;
+	}
 
 	if (filter.slave_kind && match_link_kind(tb, filter.slave_kind, 1))
 		return -1;
@@ -1971,7 +2003,9 @@ static int iplink_filter_req(struct nlmsghdr *nlh, int reqlen)
 			return err;
 	}
 
-	if (filter.kind) {
+	if (filter.kind && !strcmp(filter.kind, "ether") &&
+	    !strcmp(filter.kind, "loopback") && !strcmp(filter.kind, "ppp")) {
+
 		struct rtattr *linkinfo;
 
 		linkinfo = addattr_nest(nlh, reqlen, IFLA_LINKINFO);
@@ -2137,6 +2171,16 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			} else {
 				filter.kind = *argv;
 			}
+		} else if (strcmp(*argv, "exclude_type") == 0) {
+			int soff;
+
+			NEXT_ARG();
+			soff = strlen(*argv) - strlen("_slave");
+			if (!strcmp(*argv + soff, "_slave")) {
+				invarg("Not a valid type for exclude\n", *argv);
+			} else {
+				filter.exclude_kind = *argv;
+			}
 		} else {
 			if (strcmp(*argv, "dev") == 0)
 				NEXT_ARG();
diff --git a/ip/iplink.c b/ip/iplink.c
index a3ea775d..e0d49cab 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -120,7 +120,7 @@ void iplink_usage(void)
 		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
 		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
-		"		[nomaster]\n"
+		"		[exclude_type TYPE] [nomaster]\n"
 		"\n"
 		"	ip link xstats type TYPE [ ARGS ]\n"
 		"\n"
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index 65f67e06..21de3d77 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -45,6 +45,8 @@ ip-address \- protocol address management
 .IR PATTERN " ] [ "
 .B  master
 .IR DEVICE " ] [ "
+.B  exclude_type
+.IR TYPE " ] [ "
 .B  type
 .IR TYPE " ] [ "
 .B vrf
@@ -138,7 +140,10 @@ ip-address \- protocol address management
 .BR ipvlan " |"
 .BR lowpan " |"
 .BR geneve " |"
-.BR macsec " ]"
+.BR macsec " |"
+.BR ether " |"
+.BR loopback " |"
+.BR ppp " ]"
 
 .SH "DESCRIPTION"
 The
@@ -337,6 +342,10 @@ interface list by comparing it with the relevant attribute in case the kernel
 didn't filter already. Therefore any string is accepted, but may lead to empty
 output.
 
+.TP
+.BI exclude_type " TYPE"
+don't list linterfaces of the given type.
+
 .TP
 .B up
 only list running interfaces.
@@ -441,6 +450,11 @@ Same as above except that only addresses assigned to active network interfaces
 are shown.
 .RE
 .PP
+ip address show type ether
+.RS 4
+Shows IPv4 and IPv6 addresses assigned to all physical ethernetl interfaces
+.RE
+.PP
 ip address show dev eth0
 .RS 4
 Shows IPv4 and IPv6 addresses assigned to network interface eth0.
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 19a0c9ca..60cbb5c7 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -176,10 +176,12 @@ ip-link \- network device configuration
 .BR up " ] ["
 .B master
 .IR DEVICE " ] ["
-.B type
-.IR ETYPE " ] ["
 .B vrf
 .IR NAME " ] ["
+.B type
+.IR ETYPE " ] ["
+.B exclude_type
+.IR ETYPE " ] ["
 .BR nomaster " ]"
 
 .ti -8
@@ -237,7 +239,7 @@ ip-link \- network device configuration
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
-.BR bridge_slave " | " bond_slave " ]"
+.BR ether " | " loopback " | " ppp " | " bridge_slave " | " bond_slave " ]"
 
 .ti -8
 .IR VFVLAN-LIST " := [ "  VFVLAN-LIST " ] " VFVLAN
@@ -2630,6 +2632,11 @@ ip link show type vlan
 Shows the vlan devices.
 .RE
 .PP
+ip link show exclude_type ppp
+.RS 4
+List the network interfaces except PPP devices.
+.RE
+.PP
 ip link show master br0
 .RS 4
 Shows devices enslaved by br0
-- 
2.20.1

