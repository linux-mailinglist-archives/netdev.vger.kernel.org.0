Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E192A6CAA0B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbjC0QMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjC0QMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:12:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E100BF
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 09:12:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHsYqOaXifIYejT56v4RhDyZraXwOQz46mJjiSWCUxISXN8OBGnML8TplJJ4BsUd0Gr1FXyrRPfslyHPOvwpPkYsdxrb1Lq0i6LT3VTdIynObRRgz06Nz6z2kZLcHnuKYcZ9iUOfwgYjGygSnrw3HMvIzfWLJ92LOEZgzyx5+SFw5OOY115ikZr3GCGVsDDC57kGzfJXIf5tDbTVI5H28/M7/ZVTKpPOS/aOwpdI7VGui0AYcdY/byS0S9qCjvun7frYea3ypOG+T3qWx2nhMtzMF+egIbGWi+mlrADAXAC6X/JzeeIgfzC8m7lajbB9sMmkRDej2KaFy9dqjrSB0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7CYDP85W3dAYQ7i9H50aRPFHTh55uCZo3U8Xpnyv+g=;
 b=FvjeyaY+9fU/WdMckMcCGodwgI6Ivizj48rJmIHISLhThqQE0EXc+KhFUgL3zN6zr2fgofAE42Fs5ppiCPRPxhg+Febk5RWrrf6uc7bLqtFR7eCe+gBaCvw7ChGO4XW/rtHmiYjbLsDhB9be2FHXZG3ki6wNZaP7OdAlDmuPtZEeMRGm+RpwCB7qtVGbVngQbCLM71WbxqPR9PXQT/Y0HdpP986sU4EXVhdg1q+g2C76DKm3xGHBzOrx7G0ZA6T9CWtKGQFP4+UlB0O5K1zm1SBp/5i+e5fKoYDZZWW+qjUGAEUZTzc5BPQmnIzOM5IsWjYGAjy8AI4wG51VVGmLGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7CYDP85W3dAYQ7i9H50aRPFHTh55uCZo3U8Xpnyv+g=;
 b=ROOebPJlt+fjDtT7Bm3Ppl1GDoEWCT3dJq5fGbVxS90x5VVzVVE9WW3Fk/k7N95J28cEWm7nLGCYxFMZGkh0P18l5MIHYmuiLxGAvRr36CYUQWHDdbKt+L6TbQKefSm8UnAutxcYI/r+ymY/35c3yVbekssRUVpdm7Az+d3Zwa2VYF3G9p+LN01Vdilovz941hRe8VdRaC7RLyF4hvY/cqu6j2Fm8co5dz65CmaLz5oWPJ+3Ss0ziYHUO5hmmVsgeJx+lp2Rpm6qzTpls5SMVXEmyNhq3PcU63Uxoc7S/iiNFCD85xbpHNCvyALfvP61MWG0WCWlkCTSJY3oNlC17g==
Received: from DM6PR02CA0153.namprd02.prod.outlook.com (2603:10b6:5:332::20)
 by CH3PR12MB8331.namprd12.prod.outlook.com (2603:10b6:610:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 16:12:31 +0000
Received: from DS1PEPF0000E650.namprd02.prod.outlook.com
 (2603:10b6:5:332:cafe::49) by DM6PR02CA0153.outlook.office365.com
 (2603:10b6:5:332::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 16:12:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E650.mail.protection.outlook.com (10.167.18.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Mon, 27 Mar 2023 16:12:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 27 Mar 2023
 09:12:22 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 27 Mar 2023 09:12:20 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 1/2] ip: Support IP address protocol
Date:   Mon, 27 Mar 2023 18:12:05 +0200
Message-ID: <9bf7ce65b6883fd9dc745bac3e5977d8120445f3.1679933269.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679933269.git.petrm@nvidia.com>
References: <cover.1679933269.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E650:EE_|CH3PR12MB8331:EE_
X-MS-Office365-Filtering-Correlation-Id: 84089a3a-bebb-4242-3ffe-08db2ede1181
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrpfehm2AqHdQjG/gk1QqIE+wqBzl6hVwNsasQ5yCMiY5EVUDaJD01DutXvHdg4l2FvEMi53Vdoi7+JJLvmEwbMXDNbabT9Lx6/xBgLiMiDdKAiU9YfwlD5txIs5ac/VOWc3QWwK1cL6mXsc/zVU2iYv7Ppyeh07A9YF0R3UTWeRnMM9ZIO6QTcNBxbEv24c//acwvNfTS/YBX2YFgYrhcM/7Ofrar++XvuEICbucf4B4ebEA8Vz/zAMj5w6Q4kx7jHKs0jfC1WF5x59E9CY7IulOuORYjw8yYu8zXGGWi14Wg/tWYNPhrNFBZxglwXPFe4o0bYbBMzORhyLezheq2/EK2ieRuhZ/ptQQYpo4HccBqcSEUeZFdo1/MVZBLgYMt0WKBhKVQSrazK5+8lpju/npKoA7bP0XOkaqTay+JOUOSE1/eENEtgQ0/CP/JkNmZI+D1b/y0QR0vKkW71pckasgtHQng7SSMwMgY+/QSCAwnn3kJdraa9TDKuumziI7IKauYak8G/5hTK0jwPvbbkYF6PJdd45Drqbavn/GL6O0gm1/MVsSx6azsMeRd2G7LO7jK0tPNOSERHN966tBIBQcsRzzxT0F3i3iS5nOhOMnK29VzsQ8TbqyMD8sEc5Y5Dj9uJeWOhuUjne0eHajGNUN0CEFSg7D4buU1cRFJEA5Q+5GNwril/+LzcF3wFZX6rNqu2LIdzZHsd5MDPCqH1Y5Yv2RKBa1qhrXhXssvk+XfZecAhAqdh9g/wxzinH
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(396003)(346002)(451199021)(40470700004)(46966006)(36840700001)(7696005)(41300700001)(16526019)(186003)(6666004)(107886003)(5660300002)(8936002)(478600001)(26005)(4326008)(2616005)(336012)(8676002)(47076005)(70206006)(70586007)(426003)(83380400001)(316002)(110136005)(82740400003)(36860700001)(7636003)(82310400005)(2906002)(356005)(36756003)(40480700001)(40460700003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 16:12:31.2795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84089a3a-bebb-4242-3ffe-08db2ede1181
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E650.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8331
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv4 and IPv6 addresses can be assigned a protocol value that indicates the
provenance of the IP address. The attribute is modeled after ip route
protocols, and essentially allows the administrator or userspace stack to
tag addresses in some way that makes sense to the actor in question.
Support for this feature was merged with commit 47f0bd503210 ("net: Add new
protocol attribute to IP addresses"), for kernel 5.18.

In this patch, add support for setting the protocol attribute at IP address
addition, replacement, and listing requests.

An example session with the feature in action:

	# ip address add dev d 192.0.2.1/28 proto 0xab
	# ip address show dev d
	26: d: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet 192.0.2.1/28 scope global proto 0xab d
	       valid_lft forever preferred_lft forever

	# ip address replace dev d 192.0.2.1/28 proto 0x11
	# ip address show dev d
	26: d: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
	    inet 192.0.2.1/28 scope global proto 0x11 d
	       valid_lft forever preferred_lft forever

A JSON dump. The protocol value is always provided as a string, even in
numeric mode, to provide a consistent interface.

	# ip -j address show dev d | jq
	[
	  {
	    "ifindex": 26,
	    "ifname": "d",
	    "flags": [
	      "BROADCAST",
	      "NOARP"
	    ],
	    "mtu": 1500,
	    "qdisc": "noop",
	    "operstate": "DOWN",
	    "group": "default",
	    "txqlen": 1000,
	    "link_type": "ether",
	    "address": "06:29:74:fd:1f:eb",
	    "broadcast": "ff:ff:ff:ff:ff:ff",
	    "addr_info": [
	      {
	        "family": "inet",
	        "local": "192.0.2.1",
	        "prefixlen": 28,
	        "scope": "global",
	        "protocol": "0x11",
	        "label": "d",
	        "valid_life_time": 4294967295,
	        "preferred_life_time": 4294967295
	      }
	    ]
	  }
	]

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/rt_names.h |  2 ++
 ip/ip_common.h     |  2 ++
 ip/ipaddress.c     | 34 +++++++++++++++++++++++--
 lib/rt_names.c     | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/include/rt_names.h b/include/rt_names.h
index 6358650db404..e96d80f30554 100644
--- a/include/rt_names.h
+++ b/include/rt_names.h
@@ -5,6 +5,7 @@
 #include <asm/types.h>
 
 const char *rtnl_rtprot_n2a(int id, char *buf, int len);
+const char *rtnl_addrprot_n2a(int id, char *buf, int len);
 const char *rtnl_rtscope_n2a(int id, char *buf, int len);
 const char *rtnl_rttable_n2a(__u32 id, char *buf, int len);
 const char *rtnl_rtrealm_n2a(int id, char *buf, int len);
@@ -13,6 +14,7 @@ const char *rtnl_dsfield_get_name(int id);
 const char *rtnl_group_n2a(int id, char *buf, int len);
 
 int rtnl_rtprot_a2n(__u32 *id, const char *arg);
+int rtnl_addrprot_a2n(__u32 *id, const char *arg);
 int rtnl_rtscope_a2n(__u32 *id, const char *arg);
 int rtnl_rttable_a2n(__u32 *id, const char *arg);
 int rtnl_rtrealm_a2n(__u32 *id, const char *arg);
diff --git a/ip/ip_common.h b/ip/ip_common.h
index c4cb1bcb1e3a..4a20ec3cba62 100644
--- a/ip/ip_common.h
+++ b/ip/ip_common.h
@@ -28,6 +28,8 @@ struct link_filter {
 	char *kind;
 	char *slave_kind;
 	int target_nsid;
+	bool have_proto;
+	int proto;
 };
 
 const char *get_ip_lib_dir(void);
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 9ba814380342..41055c43ec13 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -57,11 +57,13 @@ static void usage(void)
 		"       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
 		"                         [ nomaster ]\n"
 		"                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
-		"                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
+		"                         [ label LABEL ] [up] [ vrf NAME ]\n"
+		"                         [ proto ADDRPROTO ] ]\n"
 		"       ip address {showdump|restore}\n"
 		"IFADDR := PREFIX | ADDR peer PREFIX\n"
 		"          [ broadcast ADDR ] [ anycast ADDR ]\n"
 		"          [ label IFNAME ] [ scope SCOPE-ID ] [ metric METRIC ]\n"
+		"          [ proto ADDRPROTO ]\n"
 		"SCOPE-ID := [ host | link | global | NUMBER ]\n"
 		"FLAG-LIST := [ FLAG-LIST ] FLAG\n"
 		"FLAG  := [ permanent | dynamic | secondary | primary |\n"
@@ -70,7 +72,9 @@ static void usage(void)
 		"CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG\n"
 		"CONFFLAG  := [ home | nodad | mngtmpaddr | noprefixroute | autojoin ]\n"
 		"LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]\n"
-		"LFT := forever | SECONDS\n");
+		"LFT := forever | SECONDS\n"
+		"ADDRPROTO := [ NAME | NUMBER ]\n"
+		);
 	iplink_types_usage();
 
 	exit(-1);
@@ -1568,6 +1572,9 @@ int print_addrinfo(struct nlmsghdr *n, void *arg)
 
 	if (filter.family && filter.family != ifa->ifa_family)
 		return 0;
+	if (filter.have_proto && rta_tb[IFA_PROTO] &&
+	    filter.proto != rta_getattr_u8(rta_tb[IFA_PROTO]))
+		return 0;
 
 	if (ifa_label_match_rta(ifa->ifa_index, rta_tb[IFA_LABEL]))
 		return 0;
@@ -1675,6 +1682,14 @@ int print_addrinfo(struct nlmsghdr *n, void *arg)
 
 	print_ifa_flags(fp, ifa, ifa_flags);
 
+	if (rta_tb[IFA_PROTO]) {
+		__u8 proto = rta_getattr_u8(rta_tb[IFA_PROTO]);
+
+		if (proto || is_json_context())
+			print_string(PRINT_ANY, "protocol", "proto %s ",
+				     rtnl_addrprot_n2a(proto, b1, sizeof(b1)));
+	}
+
 	if (rta_tb[IFA_LABEL])
 		print_string(PRINT_ANY,
 			     "label",
@@ -2196,6 +2211,14 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			} else {
 				filter.kind = *argv;
 			}
+		} else if (strcmp(*argv, "proto") == 0) {
+			__u8 proto;
+
+			NEXT_ARG();
+			if (get_u8(&proto, *argv, 0))
+				invarg("\"proto\" value is invalid\n", *argv);
+			filter.have_proto = true;
+			filter.proto = proto;
 		} else {
 			if (strcmp(*argv, "dev") == 0)
 				NEXT_ARG();
@@ -2520,6 +2543,13 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
 			} else {
 				ifa_flags |= flag_data->mask;
 			}
+		} else if (strcmp(*argv, "proto") == 0) {
+			__u8 proto;
+
+			NEXT_ARG();
+			if (get_u8(&proto, *argv, 0))
+				invarg("\"proto\" value is invalid\n", *argv);
+			addattr8(&req.n, sizeof(req), IFA_PROTO, proto);
 		} else {
 			if (strcmp(*argv, "local") == 0)
 				NEXT_ARG();
diff --git a/lib/rt_names.c b/lib/rt_names.c
index 2432224acc0a..51d11fd056b1 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -226,6 +226,68 @@ int rtnl_rtprot_a2n(__u32 *id, const char *arg)
 }
 
 
+static char *rtnl_addrprot_tab[256] = {
+	[IFAPROT_UNSPEC]    = "unspec",
+	[IFAPROT_KERNEL_LO] = "kernel_lo",
+	[IFAPROT_KERNEL_RA] = "kernel_ra",
+	[IFAPROT_KERNEL_LL] = "kernel_ll",
+};
+static bool rtnl_addrprot_tab_initialized;
+
+static void rtnl_addrprot_initialize(void)
+{
+	rtnl_tab_initialize(CONFDIR "/rt_addrprotos",
+			    rtnl_addrprot_tab,
+			    ARRAY_SIZE(rtnl_addrprot_tab));
+	rtnl_addrprot_tab_initialized = true;
+}
+
+const char *rtnl_addrprot_n2a(int id, char *buf, int len)
+{
+	if (id < 0 || id >= 256 || numeric)
+		goto numeric;
+	if (!rtnl_addrprot_tab_initialized)
+		rtnl_addrprot_initialize();
+	if (rtnl_addrprot_tab[id])
+		return rtnl_addrprot_tab[id];
+numeric:
+	snprintf(buf, len, "%#x", id);
+	return buf;
+}
+
+int rtnl_addrprot_a2n(__u32 *id, const char *arg)
+{
+	static char *cache;
+	static unsigned long res;
+	char *end;
+	int i;
+
+	if (cache && strcmp(cache, arg) == 0) {
+		*id = res;
+		return 0;
+	}
+
+	if (!rtnl_addrprot_tab_initialized)
+		rtnl_addrprot_initialize();
+
+	for (i = 0; i < 256; i++) {
+		if (rtnl_addrprot_tab[i] &&
+		    strcmp(rtnl_addrprot_tab[i], arg) == 0) {
+			cache = rtnl_addrprot_tab[i];
+			res = i;
+			*id = res;
+			return 0;
+		}
+	}
+
+	res = strtoul(arg, &end, 0);
+	if (!end || end == arg || *end || res > 255)
+		return -1;
+	*id = res;
+	return 0;
+}
+
+
 static char *rtnl_rtscope_tab[256] = {
 	[RT_SCOPE_UNIVERSE]	= "global",
 	[RT_SCOPE_NOWHERE]	= "nowhere",
-- 
2.39.0

