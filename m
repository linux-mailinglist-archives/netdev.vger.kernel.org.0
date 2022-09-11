Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8620A5B4CFD
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 11:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiIKJ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 05:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIKJ1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 05:27:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8D4248C9
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 02:27:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msX6JcRh6AOp28NxBHoUHnu3KQfJUR+zjPGm4a39Y6hieTnH1wXwuhEa9XEeZxFY9map4ltKZQSZmNDHTDP1Dre1PVJ39zLFu27BE+7QwXhGa9Vpn3NCcsuZ5/hpjjPTAuAmXUnwO+i2rASJU0ugE/aKya/qJh+YQJRdCA2RDOdupQ5ftxzF0O28Qmoxqf2B0gcbcwnNS1ZH5eBticOU5eyrmo3gNDGr6igENRjmb8yTsfdJ4NAVdTulRImhPppOrRbRH3GPxwH51/td0Xyoh5WDvNw7+jpNVsFTa9TUFGAGPlxoynQvXFb8Z5mEJ0ZrzVIepW+sWr941brUyNGMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYz/GcoRWdsLWWi8qWWl2RZlisBq7rwlLkRfq9j341s=;
 b=A5b0Az323/pPDDLbwhgn6684Q4jGmUPVLmIZKKWAWH53XTnpAgi/9AXGr4gi4TSRETyg6KuoFtToIwvk14Bf3mmQ0O7jMrHlvyxmx1dOB6qfo9BiprEXeaj9mR2Qv6og1tCujCLQoPq0DPJun9LO+h3EmWy4+UJOBbdRH7Kfm9+p6ul+HCmapA140Nvv3dEPynHuLORZzsZAEUxzFEp8vC0M5wQme7eGSCjXzzgGq2M0OwxwpS+xEsdAAb7JnB4aHtgSr4w8+r0wK3iaDyGEvxSsJUkHb5zgQIZ7MLIOIsvHS4yGy3AvNXyvRfSWiQWY5vxX5ChPs/L6Vb3RpWZVdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYz/GcoRWdsLWWi8qWWl2RZlisBq7rwlLkRfq9j341s=;
 b=nPHFclz7scNtnirsSkgB2GUhP8uWo5CNRs3GJYypTACq2iGIizZp8XylyADWkhz9SV/6wINWGfqph2ObsqMbkx0K4n77/jKoBvE5wztvOHj0V5iEe6Qq7lQC1C79rsP3AyGHAKMDIGssBA0JoQVGmBXauFCkoojNRNCYwoONM69ZutAXzk8NMQYvYnTMMoFMaZNlxdwEPmLkiqbHzejJBAkMqevKAifNiTAhDuDyWakaPzafUh6glZ1RCHMNa+xvGUVJebOHNIXdStelHMXa+WGZbh2fJW7bKcYa0uKCB/I6eCTAh2T3ygvFr4SkS9eS+C96U9fH7vxDCYi0+0f1hQ==
Received: from DS7PR03CA0251.namprd03.prod.outlook.com (2603:10b6:5:3b3::16)
 by SA1PR12MB7149.namprd12.prod.outlook.com (2603:10b6:806:29c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Sun, 11 Sep
 2022 09:27:07 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b3:cafe::c1) by DS7PR03CA0251.outlook.office365.com
 (2603:10b6:5:3b3::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12 via Frontend
 Transport; Sun, 11 Sep 2022 09:27:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Sun, 11 Sep 2022 09:27:07 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 11 Sep
 2022 09:27:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 11 Sep
 2022 02:27:05 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Sun, 11 Sep
 2022 02:27:03 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <raeds@nvidia.com>, <tariqt@nvidia.com>,
        "Emeel Hakim" <ehakim@nvidia.com>
Subject: [PATCH main v5 1/2] macsec: add Extended Packet Number support
Date:   Sun, 11 Sep 2022 12:26:55 +0300
Message-ID: <20220911092656.13986-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|SA1PR12MB7149:EE_
X-MS-Office365-Filtering-Correlation-Id: 830331de-6913-4658-5856-08da93d7cbc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6JkAlAq/zUTFxkI1Qfe5sXG6QEQW4SCIh5hWcbRlZSa9W3/BWQB23RSSd0Zox9Wa3PgmQHs7zEjfSnN2gz1B0EVN3v1C6biieV17Ea9nHU9Xk5WFXMP61d73Y7rid7bOj0+gtocMgKoEj2SizsEJR8ZjyAJAwKd/6rh6MmSS7HToJ1H3G265KertlmFrlQ68BwNVzO37SpQxOw66R64x8J95IujtKzAfnCjUws2zaVwSRtv9NquHu6WWM/V1KD9azrnZ3R+iM9ockSzdtXXuLZXJ+Ow5eDHr0HdF5d+fGOXnn7w6MEJpXBR/P0uX3ZWaa1Iw3h6nTpRsQMRcfDfMMsjdMA/65f/YodU1BKnI6Su6X6vOnrVExdPD0Dr7i12Wl5CKUHeRgJuG76Sa8wTX7cVt7FYE3XFKRLUuMRbiGioCE01dHB4UuU5+ZT5+eVMueN3gkKheXZ4KDRZkJYPjIfAKk9t5wfeLJ83IBACFnbqfhFIDbN8E/zqvS5EKmxokNKiff8Ntla9Rnwbg5NbCpumdCPL+VKJ8IeyBjKhdwnZFV+a7u0+ecMShrA+xNtJNEXM7RsyaLZ99WsyF8UGVEz4+ufFpQxAItYLpNBUGLDDABUFkMUlI35mGOFIVNua4114E8hGtlKIixQ8Q25QWgUyhSDqk9zo5jjfYN2vdKjZCSuakU981lTN9PA/c6k8Ekt+cSBYVqI3rhFnKu2yxKAHiPni/hEggwaw+qBU6TqW8y0Dd5P2+EMwZEiK+n+yvG6pXbFBYH8xzKDNVD4ratFP8mqota94o76slrruZRtPoKFH7+DsIVEFUQtj+xBRuWzrUEiKOyuSl+4IPP5sW1fprfWP9t0K2jFuQNd+PlDEERnDXcEOpPHeQOhZpTKs
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(46966006)(40470700004)(36840700001)(36756003)(478600001)(316002)(356005)(40480700001)(41300700001)(54906003)(81166007)(40460700003)(110136005)(82740400003)(47076005)(7696005)(26005)(86362001)(2616005)(1076003)(426003)(336012)(36860700001)(107886003)(83380400001)(82310400005)(2906002)(6666004)(186003)(8676002)(4326008)(70586007)(5660300002)(70206006)(8936002)(30864003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 09:27:07.0456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 830331de-6913-4658-5856-08da93d7cbc3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7149
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for extended packet number (XPN).
XPN can be configured by passing 'cipher gcm-aes-xpn-128' as part of
the ip link add command using macsec type.
In addition, using 'xpn' keyword instead of the 'pn', passing a 12
bytes salt using the 'salt' keyword and passing short secure channel
id (ssci) using the 'ssci' keyword as part of the ip macsec command
is required (see example).

e.g:

create a MACsec device on link eth0 with enabled xpn
  # ip link add link eth0 macsec0 type macsec port 11
	encrypt on cipher gcm-aes-xpn-128

configure a secure association on the device
  # ip macsec add macsec0 tx sa 0 xpn 1024 on ssci 5
	salt 838383838383838383838383
	key 01 81818181818181818181818181818181

configure a secure association on the device with ssci = 5
  # ip macsec add macsec0 tx sa 0 xpn 1024 on ssci 5
	salt 838383838383838383838383
	key 01 82828282828282828282828282828282

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1->V2:
- Updated commit message.
- Related uapi change got accepted upstream.
  "https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=5d8175783585"
- Allowed ssci to be empty to leave it up to the kernel to reject invalid
  requests.
- Removed the flag option and exchanged it by a property for xpn.
- Added the 64b xpn, ssci as part of the dump.

V2->V3:
- Add dedicated function to read ssci correctly.
- Check for duplicate xpn and pn where command line has an xpn argument
  with upper 32bits set followed by a pn argument.
- Don't use int to hold a boolean result. 

V3->V4:
- Extend cipher suites to include 2 more options (GCM-AES-XPN-128, GCM-AES-XPN-256).
- Add duparg check for both salt and ssci.
- Add dedicated function to check if we are in xpn mode.

V4->V5:
- Updated commit message.
- Updated usage print.
- Use salt_set and ssci_set params in the is salt and ssci provided checks.

 ip/ipmacsec.c | 140 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 117 insertions(+), 23 deletions(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index bf48e8b5..6dd73827 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -43,11 +43,19 @@ struct sci {
 
 struct sa_desc {
 	__u8 an;
-	__u32 pn;
+	union {
+		__u32 pn32;
+		__u64 pn64;
+	} pn;
 	__u8 key_id[MACSEC_KEYID_LEN];
 	__u32 key_len;
 	__u8 key[MACSEC_MAX_KEY_LEN];
 	__u8 active;
+	__u8 salt[MACSEC_SALT_LEN];
+	__u32 ssci;
+	bool xpn;
+	bool salt_set;
+	bool ssci_set;
 };
 
 struct cipher_args {
@@ -98,14 +106,20 @@ static void ipmacsec_usage(void)
 		"       ip macsec show\n"
 		"       ip macsec show DEV\n"
 		"       ip macsec offload DEV [ off | phy | mac ]\n"
-		"where  OPTS := [ pn <u32> ] [ on | off ]\n"
+		"where  OPTS := [ pn <u32> | xpn <u64> ] [ salt SALT ] [ ssci <u32> ] [ on | off ]\n"
 		"       ID   := 128-bit hex string\n"
 		"       KEY  := 128-bit or 256-bit hex string\n"
-		"       SCI  := { sci <u64> | port { 1..2^16-1 } address <lladdr> }\n");
+		"       SCI  := { sci <u64> | port { 1..2^16-1 } address <lladdr> }\n"
+		"       SALT := 96-bit hex string\n");
 
 	exit(-1);
 }
 
+static bool ciphersuite_is_xpn(__u64 cid)
+{
+	return (cid == MACSEC_CIPHER_ID_GCM_AES_XPN_128 || cid == MACSEC_CIPHER_ID_GCM_AES_XPN_256);
+}
+
 static int get_an(__u8 *val, const char *arg)
 {
 	int ret = get_u8(val, arg, 0);
@@ -124,6 +138,11 @@ static int get_sci(__u64 *sci, const char *arg)
 	return get_be64(sci, arg, 16);
 }
 
+static int get_ssci(__u32 *ssci, const char *arg)
+{
+	return get_be32(ssci, arg, 16);
+}
+
 static int get_port(__be16 *port, const char *arg)
 {
 	return get_be16(port, arg, 0);
@@ -174,14 +193,42 @@ static int parse_sa_args(int *argcp, char ***argvp, struct sa_desc *sa)
 
 	while (argc > 0) {
 		if (strcmp(*argv, "pn") == 0) {
-			if (sa->pn != 0)
+			if (sa->pn.pn64 != 0)
 				duparg2("pn", "pn");
 			NEXT_ARG();
-			ret = get_u32(&sa->pn, *argv, 0);
+			ret = get_u32(&sa->pn.pn32, *argv, 0);
 			if (ret)
 				invarg("expected pn", *argv);
-			if (sa->pn == 0)
+			if (sa->pn.pn32 == 0)
 				invarg("expected pn != 0", *argv);
+		} else if (strcmp(*argv, "xpn") == 0) {
+			if (sa->pn.pn64 != 0)
+				duparg2("xpn", "xpn");
+			NEXT_ARG();
+			ret = get_u64(&sa->pn.pn64, *argv, 0);
+			if (ret)
+				invarg("expected pn", *argv);
+			if (sa->pn.pn64 == 0)
+				invarg("expected pn != 0", *argv);
+			sa->xpn = true;
+		} else if (strcmp(*argv, "salt") == 0) {
+			unsigned int len;
+
+			if (sa->salt_set)
+				duparg2("salt", "salt");
+			NEXT_ARG();
+			if (!hexstring_a2n(*argv, sa->salt, MACSEC_SALT_LEN,
+					   &len))
+				invarg("expected salt", *argv);
+			sa->salt_set = true;
+		} else if (strcmp(*argv, "ssci") == 0) {
+			if (sa->ssci_set)
+				duparg2("ssci", "ssci");
+			NEXT_ARG();
+			ret = get_ssci(&sa->ssci, *argv);
+			if (ret)
+				invarg("expected ssci", *argv);
+			sa->ssci_set = true;
 		} else if (strcmp(*argv, "key") == 0) {
 			unsigned int len;
 
@@ -392,9 +439,21 @@ static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
 	addattr8(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_AN, sa->an);
 
 	if (c != CMD_DEL) {
-		if (sa->pn)
-			addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
-				  sa->pn);
+		if (sa->xpn) {
+			if (sa->pn.pn64)
+				addattr64(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
+					  sa->pn.pn64);
+			if (sa->salt_set)
+				addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SALT,
+					  sa->salt, MACSEC_SALT_LEN);
+			if (sa->ssci_set)
+				addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SSCI,
+					  sa->ssci);
+		} else {
+			if (sa->pn.pn32)
+				addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
+					  sa->pn.pn32);
+		}
 
 		if (sa->key_len) {
 			addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_KEYID,
@@ -426,7 +485,7 @@ static bool check_sa_args(enum cmd c, struct sa_desc *sa)
 			return -1;
 		}
 
-		if (sa->pn == 0) {
+		if (sa->pn.pn64 == 0) {
 			fprintf(stderr, "must specify a packet number != 0\n");
 			return -1;
 		}
@@ -615,6 +674,9 @@ static void print_key(struct rtattr *key)
 
 #define CIPHER_NAME_GCM_AES_128 "GCM-AES-128"
 #define CIPHER_NAME_GCM_AES_256 "GCM-AES-256"
+#define CIPHER_NAME_GCM_AES_XPN_128 "GCM-AES-XPN-128"
+#define CIPHER_NAME_GCM_AES_XPN_256 "GCM-AES-XPN-256"
+
 #define DEFAULT_CIPHER_NAME CIPHER_NAME_GCM_AES_128
 
 static const char *cs_id_to_name(__u64 cid)
@@ -627,6 +689,10 @@ static const char *cs_id_to_name(__u64 cid)
 		return CIPHER_NAME_GCM_AES_128;
 	case MACSEC_CIPHER_ID_GCM_AES_256:
 		return CIPHER_NAME_GCM_AES_256;
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
+		return CIPHER_NAME_GCM_AES_XPN_128;
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
+		return CIPHER_NAME_GCM_AES_XPN_256;
 	default:
 		return "(unknown)";
 	}
@@ -846,8 +912,8 @@ static void print_txsa_stats(const char *prefix, struct rtattr *attr)
 }
 
 static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
-			struct rtattr *txsc_stats, struct rtattr *secy_stats,
-			struct rtattr *sa)
+			bool is_xpn, struct rtattr *txsc_stats,
+			struct rtattr *secy_stats, struct rtattr *sa)
 {
 	struct rtattr *sa_attr[MACSEC_SA_ATTR_MAX + 1];
 	struct rtattr *a;
@@ -875,8 +941,16 @@ static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
 		print_string(PRINT_FP, NULL, "%s", prefix);
 		print_uint(PRINT_ANY, "an", "%d:",
 			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
-		print_uint(PRINT_ANY, "pn", " PN %u,",
-			   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		if (is_xpn) {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
+			print_0xhex(PRINT_ANY, "ssci",
+				    "SSCI %08x",
+				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
+		} else {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		}
 
 		print_bool(PRINT_JSON, "active", NULL, state);
 		print_string(PRINT_FP, NULL,
@@ -916,7 +990,8 @@ static void print_rxsc_stats(const char *prefix, struct rtattr *attr)
 }
 
 static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
-			struct rtattr *rxsc_stats, struct rtattr *sa)
+			bool is_xpn, struct rtattr *rxsc_stats,
+			struct rtattr *sa)
 {
 	struct rtattr *sa_attr[MACSEC_SA_ATTR_MAX + 1];
 	struct rtattr *a;
@@ -943,8 +1018,16 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
 		print_string(PRINT_FP, NULL, "%s", prefix);
 		print_uint(PRINT_ANY, "an", "%u:",
 			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
-		print_uint(PRINT_ANY, "pn", " PN %u,",
-			   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		if (is_xpn) {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
+			print_0xhex(PRINT_ANY, "ssci",
+				    "SSCI %08x",
+				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
+		} else {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		}
 
 		print_bool(PRINT_JSON, "active", NULL, state);
 		print_string(PRINT_FP, NULL, " state %s,",
@@ -958,7 +1041,7 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
 	close_json_array(PRINT_JSON, NULL);
 }
 
-static void print_rxsc_list(struct rtattr *sc)
+static void print_rxsc_list(struct rtattr *sc, bool is_xpn)
 {
 	int rem = RTA_PAYLOAD(sc);
 	struct rtattr *c;
@@ -973,6 +1056,7 @@ static void print_rxsc_list(struct rtattr *sc)
 		print_rx_sc("    ",
 			    rta_getattr_u64(sc_attr[MACSEC_RXSC_ATTR_SCI]),
 			    rta_getattr_u32(sc_attr[MACSEC_RXSC_ATTR_ACTIVE]),
+			    is_xpn,
 			    sc_attr[MACSEC_RXSC_ATTR_STATS],
 			    sc_attr[MACSEC_RXSC_ATTR_SA_LIST]);
 		close_json_object();
@@ -989,6 +1073,8 @@ static int process(struct nlmsghdr *n, void *arg)
 	int ifindex;
 	__u64 sci;
 	__u8 encoding_sa;
+	__u64 cid;
+	bool is_xpn = false;
 
 	if (n->nlmsg_type != genl_family)
 		return -1;
@@ -1032,13 +1118,15 @@ static int process(struct nlmsghdr *n, void *arg)
 
 	print_attrs(attrs_secy);
 
-	print_tx_sc("    ", sci, encoding_sa,
+	cid = rta_getattr_u64(attrs_secy[MACSEC_SECY_ATTR_CIPHER_SUITE]);
+	is_xpn = ciphersuite_is_xpn(cid);
+	print_tx_sc("    ", sci, encoding_sa, is_xpn,
 		    attrs[MACSEC_ATTR_TXSC_STATS],
 		    attrs[MACSEC_ATTR_SECY_STATS],
 		    attrs[MACSEC_ATTR_TXSA_LIST]);
 
 	if (attrs[MACSEC_ATTR_RXSC_LIST])
-		print_rxsc_list(attrs[MACSEC_ATTR_RXSC_LIST]);
+		print_rxsc_list(attrs[MACSEC_ATTR_RXSC_LIST], is_xpn);
 
 	if (attrs[MACSEC_ATTR_OFFLOAD]) {
 		struct rtattr *attrs_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
@@ -1245,7 +1333,7 @@ static void usage(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... macsec [ [ address <lladdr> ] port { 1..2^16-1 } | sci <u64> ]\n"
-		"                  [ cipher { default | gcm-aes-128 | gcm-aes-256 } ]\n"
+		"                  [ cipher { default | gcm-aes-128 | gcm-aes-256 | gcm-aes-xpn-128 | gcm-aes-xpn-256 } ]\n"
 		"                  [ icvlen { 8..16 } ]\n"
 		"                  [ encrypt { on | off } ]\n"
 		"                  [ send_sci { on | off } ]\n"
@@ -1300,9 +1388,15 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			else if (strcmp(*argv, "gcm-aes-256") == 0 ||
 			         strcmp(*argv, "GCM-AES-256") == 0)
 				cipher.id = MACSEC_CIPHER_ID_GCM_AES_256;
+			else if (strcmp(*argv, "gcm-aes-xpn-128") == 0 ||
+				 strcmp(*argv, "GCM-AES-XPN-128") == 0)
+				cipher.id = MACSEC_CIPHER_ID_GCM_AES_XPN_128;
+			else if (strcmp(*argv, "gcm-aes-xpn-256") == 0 ||
+				 strcmp(*argv, "GCM-AES-XPN-256") == 0)
+				cipher.id = MACSEC_CIPHER_ID_GCM_AES_XPN_256;
 			else
-				invarg("expected: default, gcm-aes-128 or"
-				       " gcm-aes-256", *argv);
+				invarg("expected: default, gcm-aes-128, gcm-aes-256,"
+				       " gcm-aes-xpn-128 or gcm-aes-xpn-256", *argv);
 		} else if (strcmp(*argv, "icvlen") == 0) {
 			NEXT_ARG();
 			if (cipher.icv_len)
-- 
2.21.3

