Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC1D51EBDA
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 06:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiEHE5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 00:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiEHE5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 00:57:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47506E0BE
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 21:53:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aG1eLo4VbjGVsMtZC171vGlSbpK5Mc8/l7FG1QjG6u8NuUl/Ovbga0ot/owxmqq7NpDRFfdnLG52LscXp70FNF2a656oyGHgjLPU7+QOMZ33wtzGYw+3gHhrnp40n6l5rshUd4EzHVOuh54o+ulTKqY7YJGT+mQ7dmxRZGmxW1NLmxwUVuFALDYm+jg98Qk4CFk8xM0KrJ3Kg/UlGuU/f5ZTPTqrC2wWEqQTZNhDWTSV+b0S4BWCTGdFGIFiC5tjxsVbCT7xMktVFunkOJamPrNUaZpCmLD3HFqBsc+zXSpTpVAMBJ1UHVwt3HtP3DJ1IC8dWJcj7bBXZO7SOkmF4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vayLjKvEX/IdvlXtyxxYdnQPDRkG2h6CUl4mcevhzEg=;
 b=TJfrB4KygUPJhz11A5Hj2uREA8btwFHIYx5p2OGQrSiE6E+GrjZ4m0U5Svg9sK1IKH/ljJGWXJqBAZGfw5qtIX/Ufyjr79v8Qmr4VJhU6cZwTV7WspZAPs4Sd9r1RqoUNwyjDIx89lVyqiMjqYxiTOpwWqLzrDgtuPpf1F+VwFskrs060d05eJjKorwq7oCvnYtuRgbZnlM2/J0asTYjn/TfvF2FisnISgLIw8nt4ugRaTFdfXKMkdQz3BjHnNvugGcNqXnBQcHAp4fETQRQnKr/VbJgOlFDg8G0yZgPm9w/0lf9XXLj5ddoh1ElBS8g7+rzqvLXZYicaEN1AtjIYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vayLjKvEX/IdvlXtyxxYdnQPDRkG2h6CUl4mcevhzEg=;
 b=fqRBGfdhEDv74/t8lSdps75/RmAIUB6AtzCSABDCoccti3TdNNk6U3kMRSr4MI6NRLDszW0s6kEkPLL8K2mGhG0gF/AYfmalNQiS0ecfALk+V2WdvRGMHXeehONXoRak/vgAJ9F3r/RzFLCcYHQscHrj4GYM8P1+bVhoin/ePF4GevVMbasB8IYPRepOD9MEmeMqP9vSbVYEWB4NR1e2BEJl5UXpONVl3MT6m/3xPqG9Jaf4YS0H6lCJmWYcnZhPv4ZUY4ATQ1xiqfbxK832WuVuh8hQp+rR/SgZb66cNmgWtrVvRG1IpI1L7W9ModeoPrC4ydJAGA02nsfrS0I6Ig==
Received: from MW4PR03CA0156.namprd03.prod.outlook.com (2603:10b6:303:8d::11)
 by CH0PR12MB5233.namprd12.prod.outlook.com (2603:10b6:610:d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 04:53:40 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::f9) by MW4PR03CA0156.outlook.office365.com
 (2603:10b6:303:8d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Sun, 8 May 2022 04:53:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 04:53:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 8 May 2022 04:53:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 7 May 2022 21:53:39 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 7 May 2022 21:53:39 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next v2 2/3] ip: iplink_vxlan: add support to set vnifiltering flag on vxlan device
Date:   Sun, 8 May 2022 04:53:39 +0000
Message-ID: <20220508045340.120653-3-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508045340.120653-1-roopa@nvidia.com>
References: <20220508045340.120653-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51fc8c58-1bd6-4e81-bac2-08da30aeb88b
X-MS-TrafficTypeDiagnostic: CH0PR12MB5233:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5233A4509291FD402DC5760FCBC79@CH0PR12MB5233.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzptpC9OJnUjeeft4vKPNTv+1I37ye42PHPE2wc5LHroV/scYCmgt0JQAjV6y1KsbmIANb8qR91eoAgUY01qrlV8c2mFwRyhq5rmht3kf76ZFl9iwfXBo0F0UsD+2esdzc+SASdTozoSTuISLsKRFnoDY5l6U5U90sh3a6VKnDFmCY58pJxUCxs5JjgCJtsHkjbT7BYehG73J0BvH6pk9/3F8L7gOUUXF5YFt4NChQ1Gf8X5Q+SiE35opL++j3uMetZ5bTLFJYjMEmYzaKylPN8m5gfTecgsztwQRmg+88MeG/b3Q7cqT68uhq6n/bkT7AFXHyzlmAlqGhPkuUlSvT9k6D8QnJXJfVOMdvcVvyIqosDqftaL1cFNZr7W+R/TlmDkBRNBIpTaa3ZU0NOeyW8q2OBeJ0vJtjZWORSADRCZbPeYZSesQXN3aok8GZ0i5sdwOYphPXlacEUM8i1fCekBhi+VqFNSlpDtyh0GGMJ2gy/yoLrRkwPI5pVMfpg9w5wa71QX+SuO2JBExoyYswhotbYinHBypOjW4zmOLeSf4RAOjosqTxyJYTvxS5pWnyP+2E1cVLq70B5KdtKwrySntHWNmk/TwpWZHzap5tWc41/Q+Oa+paR5tBTnfYiloQm5ulBPjOgqZrQFZlc3Xhga2JU49xRS0okZvO0WMyTPU/0XG4RBc4dOfhqXQT3930YIzFyGp9rKI7XJbF56ehFuo0KFbjgode7DC+KIkJVx7VR1PPOLaju1yyFxQwMrLXfETwchCa+87Ps0dVuGsg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(81166007)(36756003)(356005)(316002)(5660300002)(508600001)(83380400001)(8936002)(2906002)(426003)(26005)(336012)(82310400005)(86362001)(1076003)(47076005)(2616005)(186003)(54906003)(6916009)(36860700001)(8676002)(70206006)(4326008)(40460700003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 04:53:40.4016
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51fc8c58-1bd6-4e81-bac2-08da30aeb88b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5233
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds option to set vnifilter flag on a vxlan device. vnifilter is
only supported on a collect metadata device.

example: set vnifilter flag
$ ip link add vxlan0 type vxlan external vnifilter local 172.16.0.1

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 ip/iplink_vxlan.c     | 23 ++++++++++++++++++++++-
 man/man8/ip-link.8.in |  9 +++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index 9afa3cca..3dde2150 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -48,6 +48,7 @@ static void print_explain(FILE *f)
 		"		[ [no]udp6zerocsumrx ]\n"
 		"		[ [no]remcsumtx ] [ [no]remcsumrx ]\n"
 		"		[ [no]external ] [ gbp ] [ gpe ]\n"
+		"		[ [no]vnifilter ]\n"
 		"\n"
 		"Where:	VNI	:= 0-16777215\n"
 		"	ADDR	:= { IP_ADDRESS | any }\n"
@@ -81,6 +82,7 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u8 learning = 1;
 	__u16 dstport = 0;
 	__u8 metadata = 0;
+	__u8 vnifilter = 0;
 	__u64 attrs = 0;
 	bool set_op = (n->nlmsg_type == RTM_NEWLINK &&
 		       !(n->nlmsg_flags & NLM_F_CREATE));
@@ -330,6 +332,15 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (!matches(*argv, "gpe")) {
 			check_duparg(&attrs, IFLA_VXLAN_GPE, *argv, *argv);
 			addattr_l(n, 1024, IFLA_VXLAN_GPE, NULL, 0);
+		} else if (!matches(*argv, "vnifilter")) {
+			check_duparg(&attrs, IFLA_VXLAN_VNIFILTER,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_VNIFILTER, 1);
+			vnifilter = 1;
+		} else if (!matches(*argv, "novnifilter")) {
+			check_duparg(&attrs, IFLA_VXLAN_VNIFILTER,
+				     *argv, *argv);
+			addattr8(n, 1024, IFLA_VXLAN_VNIFILTER, 0);
 		} else if (matches(*argv, "help") == 0) {
 			explain();
 			return -1;
@@ -341,12 +352,17 @@ static int vxlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		argc--, argv++;
 	}
 
+	if (!metadata && vnifilter) {
+		fprintf(stderr, "vxlan: vnifilter is valid only when 'external' is set\n");
+		return -1;
+	}
+
 	if (metadata && VXLAN_ATTRSET(attrs, IFLA_VXLAN_ID)) {
 		fprintf(stderr, "vxlan: both 'external' and vni cannot be specified\n");
 		return -1;
 	}
 
-	if (!metadata && !VXLAN_ATTRSET(attrs, IFLA_VXLAN_ID) && !set_op) {
+	if (!metadata && !vnifilter && !VXLAN_ATTRSET(attrs, IFLA_VXLAN_ID) && !set_op) {
 		fprintf(stderr, "vxlan: missing virtual network identifier\n");
 		return -1;
 	}
@@ -420,6 +436,11 @@ static void vxlan_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_bool(PRINT_ANY, "external", "external ", true);
 	}
 
+	if (tb[IFLA_VXLAN_VNIFILTER] &&
+	    rta_getattr_u8(tb[IFLA_VXLAN_VNIFILTER])) {
+		print_bool(PRINT_ANY, "vnifilter", "vnifilter", true);
+	}
+
 	if (tb[IFLA_VXLAN_ID] &&
 	    RTA_PAYLOAD(tb[IFLA_VXLAN_ID]) >= sizeof(__u32)) {
 		print_uint(PRINT_ANY, "id", "id %u ", rta_getattr_u32(tb[IFLA_VXLAN_ID]));
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index fc214a10..6f332645 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -601,6 +601,8 @@ the following additional arguments are supported:
 .B gbp
 ] [
 .B gpe
+] [
+.RB [ no ] vnifilter
 ]
 
 .in +8
@@ -712,6 +714,13 @@ are entered into the VXLAN device forwarding database.
 .RB "(e.g. " "ip route encap" )
 or the internal FDB should be used.
 
+.sp
+.RB [ no ] vnifilter
+- specifies whether the vxlan device is capable of vni filtering. Only works with a vxlan
+device with external flag set. once enabled, bridge vni command is used to manage the
+vni filtering table on the device. The device can only receive packets with vni's configured
+in the vni filtering table.
+
 .sp
 .B gbp
 - enables the Group Policy extension (VXLAN-GBP).
-- 
2.25.1

