Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1CD4885B9
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 20:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiAHT4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 14:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiAHT4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 14:56:03 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFB6C06173F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 11:56:03 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id d3so2466306lfv.13
        for <netdev@vger.kernel.org>; Sat, 08 Jan 2022 11:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcHd0JeANSgfzrVCyHKH4t4A6RfnBK6w68s14ddhXG0=;
        b=P3vDz4FGJB80MHcaKKkVUcxNiExfcs1QiaPF+YsDPQySJ+1nFcs+eRVKWZeexj73NC
         lJfyDRvnDAEcJ1JTgrt/nQ9Tos/SSpS1igbWBvzAGw7zXLqKB604sR64eM1AVXgmOvbe
         4C3nWbzSe776iIzr6ei861Bpw9M7P6S7qwHAXG5LzhtoCootLVZc43KahYZCiBSUNMfU
         WtcAXrvwhkHlmu+Ji3ppveVAehSZHKt5B9OAb9LEIadBP+ITicBTRwocI8jmvI+duQhh
         dyZ6fYQ4YPpovMZqaEdtB3JyOabbykOGsYbkN7ff0DBIQgjZ3P/HfqBGYguGgDJj7AvY
         gyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcHd0JeANSgfzrVCyHKH4t4A6RfnBK6w68s14ddhXG0=;
        b=G3pZkCDEac9xYKjLQu2HLJjKzZK/WgSO5LGLQBzPHl0PLZdBLmsBAv1rW8WzgHMN8S
         lgrt2IDd2psi7LFEM+44OkjA7fdrRuNE1XM1xg2W5DFwLeh6hLyIMHq5z+S1q63G5GEy
         DNeUsto3YDKMgHR0oqiJeyPPXMKTlZDvDvW0CJ0jEkQD5bZ5pAhbvz/tD91ezUAOjsMV
         GtTp+bv/8CABBWMc3gbR5G5cVIE7ZhAhJkqSuf7b9CyerJCz7Yom1VwiZJAarA/C79wM
         Tb9hdlvmg6y62itiEYY/jSu5kDw0/A/XVzgrVDiB3VsyT7RxWTnJczPSzCF6PiKWaNvB
         qPrQ==
X-Gm-Message-State: AOAM531oYks+MV/7lAWqBCUAUg8Yq05PAyTzzkOUhwpr8daokGkc/VrT
        LH2YrI+gvwE+j9pdb/jeTNY=
X-Google-Smtp-Source: ABdhPJwRaZsX0WX6QSjnQ4XRaB8fnZs6F+cEzeBJM/R77vrpW61xZmctlYYAM+6lsRWM3iYUCewcng==
X-Received: by 2002:a2e:a7ce:: with SMTP id x14mr45033707ljp.421.1641671761271;
        Sat, 08 Jan 2022 11:56:01 -0800 (PST)
Received: from dau-work-pc.corp.zonatelecom.ru ([185.17.67.197])
        by smtp.googlemail.com with ESMTPSA id q24sm342447lfr.223.2022.01.08.11.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 11:56:00 -0800 (PST)
From:   "=?UTF-8?q?=D0=90=D0=BD=D1=82=D0=BE=D0=BD=20=D0=94=D0=B0=D0=BD=D0=B8=D0=BB=D0=BE=D0=B2?=" 
        <littlesmilingcloud@gmail.com>
X-Google-Original-From: =?UTF-8?q?=D0=90=D0=BD=D1=82=D0=BE=D0=BD=20=D0=94=D0=B0=D0=BD=D0=B8=D0=BB=D0=BE=D0=B2?= <a.danilov@zonatelecom.ru>
To:     Stephen Hamminger <stephen@networkplumber.org>
Cc:     Anton Danilov <littlesmilingcloud@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH iproute2 v2] ip: Extend filter links/addresses
Date:   Sat,  8 Jan 2022 22:47:05 +0300
Message-Id: <20220108194703.23466-1-a.danilov@zonatelecom.ru>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anton Danilov <littlesmilingcloud@gmail.com>

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

