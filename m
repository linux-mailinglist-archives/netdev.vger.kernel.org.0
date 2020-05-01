Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C621C0FF4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 10:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgEAIrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 04:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgEAIrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 04:47:40 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9FEC035494
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 01:47:40 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s20so3453666plp.6
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 01:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PfeGynxjgUk/0XjkOT5+UbZbm1lwWZSKchAv88ryudA=;
        b=It23HrjdJvtllo+bBYUycBuYIzbWe/B1f97XVqaJ1UT0+vclzXYfZapp8UZKeUB/yk
         mAP/c1ePQ7NPqp+71JeQJ3g7SeGEQytrka7bGA92BakfKWn/sa+lGTfrMJjJ+Gp4zrR7
         8rqM463o/1DI8oUm1JtheuzmyEicnYRgfD0oI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PfeGynxjgUk/0XjkOT5+UbZbm1lwWZSKchAv88ryudA=;
        b=mwlOyEYZ6lHKpnNV7c2x4xR1tfkPXQ7PxDfAzhMKUUvrcAW2ecaEAcfYfuOKqSwvKO
         OYK7wlJQEsaUAezcrviriW2CJ2d20/SmM0IChZ9qIxNXRCY8c3Ka1Tv1k2ER3J5+lvgl
         jgMHIAKLd1+rHFuIz8Ld3Ak6R98ai9rZeHOC0V1L0+iG3bOf3RJImY7vNM8yLAcejXgD
         dz9CYNPAJfOLPCRV2Ax8O0tCNTTC4p7pyfVGKDZQdbRlkI+OfJiWUhreNMejY9NWWrOD
         e7d1bNSt4vH4CjOGgJyMovU40Bgo0J9uBvwNwSmjZNH0gI8wd+7ql9fQ5sxbxVce02r6
         uzKg==
X-Gm-Message-State: AGi0PuZDNsU53mHtta8pHmlPi6qvj9nfjZe2zddszbfKfpQB0Fn/LDsT
        wqOxpKH9y0eASwSgr4PZgChPix/1pt0=
X-Google-Smtp-Source: APiQypJjouJGOTeSr9mEjLOe/c3SFt+ufjyYds/cfLyLJfp2stbleJxr5bJvsY5Qe0giyAAzHhqmyA==
X-Received: by 2002:a17:90a:d192:: with SMTP id fu18mr3342174pjb.98.1588322859757;
        Fri, 01 May 2020 01:47:39 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id mj4sm1578460pjb.0.2020.05.01.01.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 01:47:39 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH iproute2 v2 5/6] bridge: Align output columns
Date:   Fri,  1 May 2020 17:47:19 +0900
Message-Id: <20200501084720.138421-6-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
References: <20200501084720.138421-1-bpoirier@cumulusnetworks.com>
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
vx0      2       2
         1010-1020       1010-1020
         1030    65556
vx-longname      2       2

After:
root@vsid:/src/iproute2# ./bridge/bridge vlan tunnelshow
port              vlan-id    tunnel-id
vx0               2          2
                  1010-1020  1010-1020
                  1030       65556
vx-longname       2          2

Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c | 73 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/bridge/vlan.c b/bridge/vlan.c
index b126fae2..8753d4c3 100644
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

