Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F8E11FE8E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfLPGoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43240 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfLPGoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:20 -0500
Received: by mail-pg1-f194.google.com with SMTP id k197so3091119pga.10
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gz2BNQEQle/snIzzzykIMEMiJleVtr/0NhSNW2Xd9+Y=;
        b=hETkzQSljMonMitbuMQNYpR0OQst1o4y7q4LbSFW5CidMpOqDr/lZJS6bfNl34y6F3
         ww2AQT6b6h1aieu5j4kn/FIDugRaEMY9SVsitwauzXFCljmSNiijGtWPf+CEPM2oPWzq
         +0Kd1xRVe+ZDO9ec9tandbxTskTYstU8gfJBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gz2BNQEQle/snIzzzykIMEMiJleVtr/0NhSNW2Xd9+Y=;
        b=IH0O/4aPcfpqQwFlkyk0GLAbmwKDVsWzr9i/L6MgPV9MyVY6QsyITBQUQB4AzCLdM4
         danJBRUw2Rw1Uug55hdohMr4cISRUld2xb3j3v/8gd6YPzIc4PN5qbSZeyIPAWjWd5A5
         g+fQuzK+yqfzqiCHQuOvDbez8VHygQ0lqzhER8oB7g6FQe3ekw7piiZkFmtZsHu1vxoE
         uB01oCYuENAD89SiProkUcEgrIvUKmdCFckL6xFXCHuXHL5FH9QNBYxFEovVrpSm3YHO
         WP6a1NvOwOLQQt9b++KOq5ZyBFfm+ON3b2/Q6/odSfkMRL8Hud+fGYfeaeb5U6+cN4h4
         CdeQ==
X-Gm-Message-State: APjAAAXXuZ2vf7J4v924wRjF6SU07KEL0/941ZKTx9SWJjCi6SMyxFpw
        63xPvfz0Ks7N4tZvpT8S24p+ILp/Jrk=
X-Google-Smtp-Source: APXvYqxsqHzbTof8ekx+rVIOVxmIR/ifdh8NvgQwY3Lv7oqP16LtPafszlOVe22h6DpY7Y6cTZ+3RQ==
X-Received: by 2002:a63:2949:: with SMTP id p70mr16456935pgp.191.1576478659601;
        Sun, 15 Dec 2019 22:44:19 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:19 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 8/8] bridge: Fix tunnelshow json output
Date:   Mon, 16 Dec 2019 15:43:44 +0900
Message-Id: <20191216064344.1470824-9-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

repeats for "vlan tunnelshow" what commit 0f36267485e3 ("bridge: fix vlan
show formatting") did for "vlan show". This fixes problems in json output.

Note that the resulting json output format of "vlan tunnelshow" is not the
same as the original, introduced in commit 8652eeb3ab12 ("bridge: vlan:
support for per vlan tunnel info"). Changes similar to the ones done for
"vlan show" in commit 0f36267485e3 ("bridge: fix vlan show formatting") are
carried over to "vlan tunnelshow".

Fixes: c7c1a1ef51ae ("bridge: colorize output and use JSON print library")
Fixes: 0f36267485e3 ("bridge: fix vlan show formatting")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c                            | 27 +++++++-----------------
 testsuite/tests/bridge/vlan/tunnelshow.t |  2 ++
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 19283bca..205851e4 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -256,12 +256,14 @@ static int filter_vlan_check(__u16 vid, __u16 flags)
 	return 1;
 }
 
-static void open_vlan_port(int ifi_index, const char *fmt)
+static void open_vlan_port(int ifi_index, const char *fmt,
+			   enum vlan_show_subject subject)
 {
 	open_json_object(NULL);
 	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", fmt,
 			   ll_index_to_name(ifi_index));
-	open_json_array(PRINT_JSON, "vlans");
+	open_json_array(PRINT_JSON,
+			subject == VLAN_SHOW_VLAN ? "vlans": "tunnels");
 }
 
 static void close_vlan_port(void)
@@ -289,10 +291,8 @@ static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 	__u16 last_vid_start = 0;
 	__u32 last_tunid_start = 0;
 
-	if (!filter_vlan)
-		open_vlan_port(ifindex, "%s");
+	open_vlan_port(ifindex, "%s", VLAN_SHOW_TUNNELINFO);
 
-	open_json_array(PRINT_JSON, "tunnel");
 	for (i = RTA_DATA(list); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 		struct rtattr *ttb[IFLA_BRIDGE_VLAN_TUNNEL_MAX+1];
 		__u32 tunnel_id = 0;
@@ -331,24 +331,13 @@ static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 		else if (vcheck_ret == 0)
 			continue;
 
-		if (tunnel_flags & BRIDGE_VLAN_INFO_RANGE_BEGIN)
-			continue;
-
-		if (filter_vlan)
-			open_vlan_port(ifindex, "%s");
-
 		open_json_object(NULL);
 		print_range("vlan", last_vid_start, tunnel_vid);
 		print_range("tunid", last_tunid_start, tunnel_id);
 		close_json_object();
-
 		print_string(PRINT_FP, NULL, "%s", _SL_);
-		if (filter_vlan)
-			close_vlan_port();
 	}
-
-	if (!filter_vlan)
-		close_vlan_port();
+	close_vlan_port();
 }
 
 static int print_vlan(struct nlmsghdr *n, void *arg)
@@ -467,7 +456,7 @@ static void print_vlan_stats_attr(struct rtattr *attr, int ifindex)
 
 		/* found vlan stats, first time print the interface name */
 		if (!found_vlan) {
-			open_vlan_port(ifindex, "%-16s");
+			open_vlan_port(ifindex, "%-16s", VLAN_SHOW_VLAN);
 			found_vlan = true;
 		} else {
 			print_string(PRINT_FP, NULL, "%-16s", "");
@@ -600,7 +589,7 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 	int rem = RTA_PAYLOAD(list);
 	__u16 last_vid_start = 0;
 
-	open_vlan_port(ifindex, "%s");
+	open_vlan_port(ifindex, "%s", VLAN_SHOW_VLAN);
 
 	for (i = RTA_DATA(list); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 		struct bridge_vlan_info *vinfo;
diff --git a/testsuite/tests/bridge/vlan/tunnelshow.t b/testsuite/tests/bridge/vlan/tunnelshow.t
index b2141e7c..fd41bfcb 100755
--- a/testsuite/tests/bridge/vlan/tunnelshow.t
+++ b/testsuite/tests/bridge/vlan/tunnelshow.t
@@ -29,3 +29,5 @@ ts_bridge "$0" "Add tunnel with vni > 16k" \
 ts_bridge "$0" "Show tunnel info" vlan tunnelshow dev $VX_DEV
 test_on "1030\s+65556"
 test_lines_count 5
+
+ts_bridge "$0" "Dump tunnel info" -j vlan tunnelshow dev $VX_DEV
-- 
2.24.0

