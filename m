Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B8C516118
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 02:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238961AbiEAAPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 20:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiEAAPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 20:15:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59F1393CD
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 17:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F23zuNcU2ThLT/AuOqeiOztMWZDPuqnoZ1COzem3bQSuWX9XT4TfGvY3B1CpgYnOdC+CxnSfRX62QvI7mgVXtvJoOwvqnfDTRZQJd8OGrqYn32PrWnsPsM/r3C78qiGryXousG3rC3rHDfXa2GIc2uTvyUqkzo53s0FCX2KtDSvNt/C55cSwDoWt+wsTrWH7LOZbY/0qRIMT5eCs2CxOzyieNCOgw3gHnk4vU37PE9V1wQQesJwAnhShhHZ5qvU+BX1W8wvEiy/DgGYK4JylWht8g3Gpeqzdhtdok5lv1Y68xPtvF2shnB8aa6FPzcXykzddOLU23MUOnSe/uSjdtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vayLjKvEX/IdvlXtyxxYdnQPDRkG2h6CUl4mcevhzEg=;
 b=HYeVVXwXg8lDaRSd2hEDNjBUMTt148r2pp9OOlJKEU/5RMDFFEVMAd2mOG1FldX/1su8NE7k7zzkBh+rspaABqHi1B2KdwWAo9rao0t9ldup51AS6+XC84+oRLiDg+g9Q8x5oOaUUaG24pAp2bUegBuQB/jYaEBEd8hsN2u+/yNNfCR6J8rVDSV7lGVONhRcJuSmJ16gKqvSMHk2iEIKZXq/Ol2MWGAmXTkxWAc8c8/ks7mkRVaGViO4s22z6enAEdsLZucTMjZcY4WYH0MuFpAIJHK8o36QjoSb0/Y5VMZDu9yhffORMLQbUmLsE94M9PzJ6J6wOI8DuLGhgb1l2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vayLjKvEX/IdvlXtyxxYdnQPDRkG2h6CUl4mcevhzEg=;
 b=A0QtMhSgCbbu9WG1+vD9fdQGuY73C5KzI8U16QYhJHNQ91EhZ0HsRLL2D/1XVk/tUkk8pGbBfLUTVhU4y5ZLmIv5VFB5TMRk4CRZ7+z3TJnjq2XTfWHuQ7Q/hOs96c7dsNcQiLliWTCzFk5QyQHXxwwrHIM/VvtkTemVNmhldbfEMp8LwRIcswH7ZyX3nHYdjoIDRAd82KWbVbh21d+Wuh0WYL3D5FhKndh02ju9vIlgZqW9jqEESFQo9Y/Z/Q2Fu8mJ5NADTC/PjOFVO345IDhiud0WNmS1rJxlz5pz70Zq48wdJedM2DzC0xuOeNBuLMB975vWsV5WMpJnx9FnYQ==
Received: from MW4PR03CA0174.namprd03.prod.outlook.com (2603:10b6:303:8d::29)
 by CY4PR1201MB0085.namprd12.prod.outlook.com (2603:10b6:910:1c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Sun, 1 May
 2022 00:12:08 +0000
Received: from CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::e2) by MW4PR03CA0174.outlook.office365.com
 (2603:10b6:303:8d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Sun, 1 May 2022 00:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT038.mail.protection.outlook.com (10.13.174.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Sun, 1 May 2022 00:12:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 1 May 2022 00:12:07 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 30 Apr 2022 17:12:06 -0700
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 30 Apr 2022 17:12:06 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next 2/3] ip: iplink_vxlan: add support to set vnifiltering flag on vxlan device
Date:   Sun, 1 May 2022 00:12:04 +0000
Message-ID: <20220501001205.33782-3-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220501001205.33782-1-roopa@nvidia.com>
References: <20220501001205.33782-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d9f4b86-8eda-48e5-6727-08da2b073af3
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0085:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0085B96E33B080AA6FFE47F3CBFE9@CY4PR1201MB0085.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AuWZPv7OwBONpDmX8sqE+qGMBTczzMuR1RHYBrQqpJmMMWWqTwFXSZRZTani+KLpqTdO8PFnWJJN8OxlluLr1Pq2Xhj3hf1+UQwppL27IfYF2sNgQ1afqYE+tovNOOeYhmybBEJMcMeshKXkctT4ZGn7mO28LWzw9x5ihbVUzL4jz8RjYwNRdmCMh2RM0OROKZQnejFzBJ2N7dMpT9ll//W/NgSLnpymQFrVlawIWruS2ZsgIu7zz7okXpryUjEmwZT9Zr6d4MLwugMBhbEixZn74G7kbfNbV0odlAaiCV7tOHrnmNpRursX3ttKTQdRnCI+2/a095yq8gjpAUliVoSs8QFHoUGOM7q5JspvmlSIaAOoAIU68jH4U11FGVBCsP1ARUhe8fcko1NfDXqLUmdiygwcU122OX1zwrzQtSyE43nRhGOjEOlI4xzIGD0pb3YNAG2jq1v83Dwq7HR/Cy+KB73puIyoCueoGQsb9dvGwBNp9sgy0HTkQP/NpuARanxn0lRfkMkSfIzW8LciOU/ijSlLI/JZF+Dpij3ao+Uzw/XZcBo22QWOJ6KpQnfcGQdIfiTGxvcgP1C4h0hU5neS82R0qytlriiUpTr6RX0urTYFWxY93e8AkpuI04HMYIfKIeWAqmRjow8MdyiaENgPW8/wa1A3zqjkFI2ctNwVDYw0WGz/X8S5q2BjbOhCFp0NjerOgvD8N/L+N5j1oQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(4326008)(40460700003)(36860700001)(8676002)(36756003)(8936002)(86362001)(70586007)(70206006)(6916009)(316002)(54906003)(508600001)(2616005)(83380400001)(5660300002)(82310400005)(1076003)(356005)(47076005)(186003)(426003)(2906002)(336012)(81166007)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2022 00:12:07.8735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d9f4b86-8eda-48e5-6727-08da2b073af3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0085
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

