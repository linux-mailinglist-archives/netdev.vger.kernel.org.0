Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946951BB22C
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgD0XvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbgD0XvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:51:08 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B35C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:08 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x15so9804555pfa.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GqGGw2A5SG7y0JMZ0ograhoz8J8rbzDeLT8aXj+Jwb0=;
        b=eg3i/lf50IICFgVlOTstakcTn+uJg9tWxvJhjlU5LDpLvjoXR+t3QBEEEcogd9tKa0
         q/f2ziS0hvzEnOio5naScqnV8o4ih1/x0WPDToxWA9c5LpdTEHSYsxEvflTkflW7P8+3
         iSA4uNOrJDXHK5G9e45ifANjdDWU4PE6xxbv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GqGGw2A5SG7y0JMZ0ograhoz8J8rbzDeLT8aXj+Jwb0=;
        b=IJCkHNFGlCDM3nnCPo4kV/Vhz9SuqBhgN1mWVYlpDMlKnsvHZ6HDVc3iRCfAH5HrL7
         dj9z+Mmm86LIMRg26ls6CNPhNdLt0q0T4BWnb8Fx2sZ6bUopF8CvKl0zzVHj8g7uIhrb
         OtUshLNrJJWmVErlBrB+XVhxQBnGGaq64lIOdH0w/ZY0lzP54LdUu8H0Yj+XnXKCZpXj
         63eFDg6JILyJY6A6rPk7FENz64owl7B0nQz/QOcHxubpCnS87oG55cDPxvRSVemeAtAK
         Ug1NhwSCW5gF7BA6eZ0CpXLaNu+mwzSF31tmZUGScKxa93FlNSaypFIidSNA1afwr4Tr
         demA==
X-Gm-Message-State: AGi0PuZddUCgcYzU0YltpbdTFACIJ00VzDD/dBsF0qnUUG21BDrvlKpM
        ptw+AlH7EHoOVEC+MSAVEBmspzBojAw=
X-Google-Smtp-Source: APiQypLqueG30lPSk8WsYzkRZjFkYbXTFZsUVhe4tcLk8IZvJYswcXBNQ541wn3hooJbNbFjfhEACA==
X-Received: by 2002:a63:1d4c:: with SMTP id d12mr25875844pgm.247.1588031467151;
        Mon, 27 Apr 2020 16:51:07 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 128sm13058106pfy.5.2020.04.27.16.51.05
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 16:51:06 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2 6/7] bridge: Align output columns
Date:   Tue, 28 Apr 2020 08:50:50 +0900
Message-Id: <20200427235051.250058-7-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use fixed column widths to improve readability.

Before:
root@vsid:/src/iproute2# ./bridge/bridge vlan tunnelshow
port    vlan-id tunnel-id
vx0      1000    1000
         1010-1020       1010-1020
         1030    65556
vx-longname      10      10

After:
root@vsid:/src/iproute2# ./bridge/bridge vlan tunnelshow
port              vlan-id    tunnel-id
vx0               1000       1000
                  1010-1020  1010-1020
                  1030       65556
vx-longname       10         10

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 73 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index 1ca7322a..a50a4fc9 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -22,6 +22,11 @@ enum vlan_show_subject {
 	VLAN_SHOW_TUNNELINFO,
 };
 
+#define VLAN_ID_LEN 9
+
+#define __stringify_1(x...) #x
+#define __stringify(x...) __stringify_1(x)
+
 static void usage(void)
 {
 	fprintf(stderr,
@@ -256,11 +261,11 @@ static int filter_vlan_check(__u16 vid, __u16 flags)
 	return 1;
 }
 
-static void open_vlan_port(int ifi_index, const char *fmt,
-			   enum vlan_show_subject subject)
+static void open_vlan_port(int ifi_index, enum vlan_show_subject subject)
 {
 	open_json_object(NULL);
-	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname", fmt,
+	print_color_string(PRINT_ANY, COLOR_IFNAME, "ifname",
+			   "%-" __stringify(IFNAMSIZ) "s  ",
 			   ll_index_to_name(ifi_index));
 	open_json_array(PRINT_JSON,
 			subject == VLAN_SHOW_VLAN ? "vlans": "tunnels");
@@ -272,16 +277,18 @@ static void close_vlan_port(void)
 	close_json_object();
 }
 
-static void print_range(const char *name, __u32 start, __u32 id)
+static unsigned int print_range(const char *name, __u32 start, __u32 id)
 {
 	char end[64];
+	int width;
 
 	snprintf(end, sizeof(end), "%sEnd", name);
 
-	print_uint(PRINT_ANY, name, "\t %u", start);
+	width = print_uint(PRINT_ANY, name, "%u", start);
 	if (start != id)
-		print_uint(PRINT_ANY, end, "-%u", id);
+		width += print_uint(PRINT_ANY, end, "-%u", id);
 
+	return width;
 }
 
 static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
@@ -297,6 +304,7 @@ static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 		__u32 tunnel_id = 0;
 		__u16 tunnel_vid = 0;
 		__u16 tunnel_flags = 0;
+		unsigned int width;
 		int vcheck_ret;
 
 		if (i->rta_type != IFLA_BRIDGE_VLAN_TUNNEL_INFO)
@@ -331,12 +339,25 @@ static void print_vlan_tunnel_info(struct rtattr *tb, int ifindex)
 			continue;
 
 		if (!opened) {
-			open_vlan_port(ifindex, "%s", VLAN_SHOW_TUNNELINFO);
+			open_vlan_port(ifindex, VLAN_SHOW_TUNNELINFO);
 			opened = true;
+		} else {
+			print_string(PRINT_FP, NULL,
+				     "%-" __stringify(IFNAMSIZ) "s  ", "");
 		}
 
 		open_json_object(NULL);
-		print_range("vlan", last_vid_start, tunnel_vid);
+		width = print_range("vlan", last_vid_start, tunnel_vid);
+		if (width <= VLAN_ID_LEN) {
+			char buf[VLAN_ID_LEN + 1];
+
+			snprintf(buf, sizeof(buf), "%-*s",
+				 VLAN_ID_LEN - width, "");
+			print_string(PRINT_FP, NULL, "%s  ", buf);
+		} else {
+			fprintf(stderr, "BUG: vlan range too wide, %u\n",
+				width);
+		}
 		print_range("tunid", last_tunid_start, tunnel_id);
 		close_json_object();
 		print_string(PRINT_FP, NULL, "%s", _SL_);
@@ -404,20 +425,23 @@ static void print_vlan_flags(__u16 flags)
 static void print_one_vlan_stats(const struct bridge_vlan_xstats *vstats)
 {
 	open_json_object(NULL);
-	print_hu(PRINT_ANY, "vid", " %hu", vstats->vid);
 
+	print_hu(PRINT_ANY, "vid", "%hu", vstats->vid);
 	print_vlan_flags(vstats->flags);
+	print_nl();
 
-	print_lluint(PRINT_ANY, "rx_bytes",
-		     "\n                   RX: %llu bytes",
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+	print_lluint(PRINT_ANY, "rx_bytes", "RX: %llu bytes",
 		     vstats->rx_bytes);
 	print_lluint(PRINT_ANY, "rx_packets", " %llu packets\n",
-		vstats->rx_packets);
-	print_lluint(PRINT_ANY, "tx_bytes",
-		     "                   TX: %llu bytes",
+		     vstats->rx_packets);
+
+	print_string(PRINT_FP, NULL, "%-" __stringify(IFNAMSIZ) "s    ", "");
+	print_lluint(PRINT_ANY, "tx_bytes", "TX: %llu bytes",
 		     vstats->tx_bytes);
 	print_lluint(PRINT_ANY, "tx_packets", " %llu packets\n",
-		vstats->tx_packets);
+		     vstats->tx_packets);
+
 	close_json_object();
 }
 
@@ -452,10 +476,11 @@ static void print_vlan_stats_attr(struct rtattr *attr, int ifindex)
 
 		/* found vlan stats, first time print the interface name */
 		if (!found_vlan) {
-			open_vlan_port(ifindex, "%-16s", VLAN_SHOW_VLAN);
+			open_vlan_port(ifindex, VLAN_SHOW_VLAN);
 			found_vlan = true;
 		} else {
-			print_string(PRINT_FP, NULL, "%-16s", "");
+			print_string(PRINT_FP, NULL,
+				     "%-" __stringify(IFNAMSIZ) "s  ", "");
 		}
 		print_one_vlan_stats(vstats);
 	}
@@ -534,9 +559,11 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 
 		if (!is_json_context()) {
-			printf("port\tvlan-id");
+			printf("%-" __stringify(IFNAMSIZ) "s  %-"
+			       __stringify(VLAN_ID_LEN) "s", "port",
+			       "vlan-id");
 			if (subject == VLAN_SHOW_TUNNELINFO)
-				printf("\ttunnel-id");
+				printf("  tunnel-id");
 			printf("\n");
 		}
 
@@ -555,7 +582,8 @@ static int vlan_show(int argc, char **argv, int subject)
 		}
 
 		if (!is_json_context())
-			printf("%-16s vlan-id\n", "port");
+			printf("%-" __stringify(IFNAMSIZ) "s  vlan-id\n",
+			       "port");
 
 		if (rtnl_dump_filter(&rth, print_vlan_stats, stdout) < 0) {
 			fprintf(stderr, "Dump terminated\n");
@@ -604,8 +632,11 @@ void print_vlan_info(struct rtattr *tb, int ifindex)
 			continue;
 
 		if (!opened) {
-			open_vlan_port(ifindex, "%s", VLAN_SHOW_VLAN);
+			open_vlan_port(ifindex, VLAN_SHOW_VLAN);
 			opened = true;
+		} else {
+			print_string(PRINT_FP, NULL, "%-"
+				     __stringify(IFNAMSIZ) "s  ", "");
 		}
 
 		open_json_object(NULL);
-- 
2.26.0

