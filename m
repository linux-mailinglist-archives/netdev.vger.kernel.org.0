Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4454E59F613
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 11:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbiHXJSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 05:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiHXJSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 05:18:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E958E832CD
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 02:18:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQW2HqwWcbh1o3d59uNUEqn2hTc01DGfhpDNhnZ04dRg3ZWR2/eAgjt2ioNli5qVQ4nR6dpzNwKqyKA3lFFvmJ+i1E+1sTyv59R2Z5ApIv3wmltq4rQeRmTWuni06A1AktUa0mnl64CWvJso36jzGFI8cxlKsIfx7/fusz5fjpdIhx6KoBnsNj2IwDXINFM1DRawpnnPBtfwtrj5Zt2BxvHjy6Z00fZD4+fPt23nGLdicWipySYV5ktd0ka1MA8KUIX+8wzZyzhQfTsjym2/9Cc59CnlHPUMEc2o8BQZT6ruOZ20jxR+8ZktGZe2u+Ov2NubOb1kXdOWuugmnBGR3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw9uJ7uW6cf+jg7QumDphTWezUxLcFZDCs4uO+nLW+k=;
 b=VhqcfvsSJ0COfSBdojcqbA5mTXRXny6tea8eVQlsxo1jqx8pijQeOhcwqTqfBDpW4b6icahYVzQphRmuSeao2O9Tq3KmV3sA+0ufR2A1H08/o79f0utW25XlHHD6bfQkEz6Jk155zv/LhYrFkh2q/AXexXg4DF/1d5+8ysZWHKQODddFshY/bTlhslXZ3c557CIR2dPRE88i1J4ziAW7DSPRuSINFA0WUIiw+Lus2w5cPNfmzOKSvTG9RoOeOwTN+WAPZupJJhswwMeREOHBDQxLI3briR0NW0X0zsvx0l2SUwgKCQbTMk4N402I4RozMAh7d+peoigiYwhi4onVLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw9uJ7uW6cf+jg7QumDphTWezUxLcFZDCs4uO+nLW+k=;
 b=CMf4QzyvZVnXIzFbkJgxjwokcrcnvHwZ8JRMZTyv8hYN5DL0EYKo7Fv7uvJ3KNQvJtnmi50vXVPjp554rifuzDGjx2CmMdElC9/LgCIrExc0CRKzxb1//tAcACbSh+Fp51ggjNgxgqxvJccBfPOJT9z0gSfCQYX2kfyq7+r6N8E8KcFjcRfB4EApamunIy/B+AkfzahAfIdfj0EGblQxgpF+N/Y/2/yKB45BEefmP5qP6XB0V6SEeE4HduUW+yhPZvW1wh9rRuxdZ5Mn+/gNbr8blyoAWhb/mBuuhZwTdpiOYA21Mt2xS642r3lJNqgQFWA7rMKT5IMZzjtKid3xpw==
Received: from DS7PR03CA0160.namprd03.prod.outlook.com (2603:10b6:5:3b2::15)
 by CY4PR1201MB0038.namprd12.prod.outlook.com (2603:10b6:910:19::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Wed, 24 Aug
 2022 09:18:14 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::31) by DS7PR03CA0160.outlook.office365.com
 (2603:10b6:5:3b2::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20 via Frontend
 Transport; Wed, 24 Aug 2022 09:18:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 09:18:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 09:18:13 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 02:18:12 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Wed, 24 Aug
 2022 02:18:10 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <sd@queasysnail.net>
CC:     <tariqt@nvidia.com>, <raeds@nvidia.com>, <netdev@vger.kernel.org>,
        "Emeel Hakim" <ehakim@nvidia.com>
Subject: [PATCH main v2 1/2] macsec: add extended packet number (XPN) support
Date:   Wed, 24 Aug 2022 12:17:52 +0300
Message-ID: <20220824091752.25414-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e04c83b9-2eec-4fc4-40f1-08da85b19269
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0038:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4yK/F065b9M5E6xcnixVbaq8yOncXUp+iN32aXUmtUoqYoYfgt6mDg7h8Z5WoYFf2SaxKb4Fv0XKFIDPKZsB/nxKOqlbHELvmvRG0ljpfV0t/WyIoaM/rYKECXGv9X0uK8SWQto2PqjqYBh8EZKpKjlZnnZohNIVtII8xyA5yursWnoALfKfZA/OWwHL984913lnB9Nh5frtoZEl8+SGya/2GIA+SaTaxC4J4YKsWam8+zQzjkC7NnFokjEaUpkeewA4KbjWflXUCv+7DFkgx+dlVCqPtOTAoarwgmJyKryaUJxNktbv97ddNm/JjMPAdmg8Q8FXlUxYZKy1e9Y5EW3Jktqpp51I8g/yZwRtRaRLpE8HQPz9wRLRDUVba0ShRGXv6Cdq88cQfcn9lcTMVDW3vsRdmPPupeK5EFnUn4EHlSYS4WK7cOht/Ctv0gRDxJnASPPvpkb7DX3Qh5dTf9dzVp8DyIcd0r4PiY+k1CWBKLG1cdjz2ASfBKbJS14seZ1elthUjVY7bvTqEvixel5iejZGUUtww4KSXqPs1rWdnPGhUOoBr+8xwBCBjKRggdkmoZbnb+HULao3RBmquDjngLlep2tdIw/Mrsw/aUXQ0sec99zZ9H/og740DTboabiIZAUcDmIx/Jz9m4e1iJDSZCXOQc9usobOtYqIBjp8Xva2RRklmPOnSIzS2GjBHQ4n4bfKYDPfYyQkqNFJdo0xu6emAgmX06R49/9nZaURfCOE28ZmYV93KTGdiqI9ldzAwPpp2GvJFqlZ8JZC82xjVyZYRhT/1wdajS3/8iWYgvE4+VeVg9nU77L+pl70h98ZU9+lQemuakTFKxBZiBYgLOTzyWbqfr4Q/oCoDmFw/EdGwrO79VXR1MeO7Bdd
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(40470700004)(81166007)(8936002)(30864003)(8676002)(4326008)(70206006)(70586007)(5660300002)(26005)(356005)(6666004)(7696005)(86362001)(316002)(54906003)(40480700001)(2906002)(36756003)(82310400005)(110136005)(83380400001)(40460700003)(82740400003)(2616005)(41300700001)(1076003)(426003)(478600001)(47076005)(336012)(186003)(107886003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 09:18:13.7329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e04c83b9-2eec-4fc4-40f1-08da85b19269
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0038
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for extended packet number (XPN).
XPN can be configured by passing 'xpn on' as part of the ip
link add command using macsec type.
In addition, using 'xpn' keyword instead of the 'pn', passing a 12
bytes salt using the 'salt' keyword and passing short secure channel
id (ssci) using the 'ssci' keyword as part of the ip macsec command
is required (see example).

e.g:

create a MACsec device on link eth0 with enabled xpn
  # ip link add link eth0 macsec0 type macsec port 11
	encrypt on xpn on

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

 include/uapi/linux/if_macsec.h |   2 +
 ip/ipmacsec.c                  | 125 +++++++++++++++++++++++++++------
 2 files changed, 107 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index eee31cec..6edfea0a 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -22,6 +22,8 @@
 
 #define MACSEC_KEYID_LEN 16
 
+#define MACSEC_SALT_LEN 12
+
 /* cipher IDs as per IEEE802.1AE-2018 (Table 14-1) */
 #define MACSEC_CIPHER_ID_GCM_AES_128 0x0080C20001000001ULL
 #define MACSEC_CIPHER_ID_GCM_AES_256 0x0080C20001000002ULL
diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index bf48e8b5..b92e7f51 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -43,11 +43,17 @@ struct sci {
 
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
 };
 
 struct cipher_args {
@@ -98,10 +104,11 @@ static void ipmacsec_usage(void)
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
@@ -174,14 +181,34 @@ static int parse_sa_args(int *argcp, char ***argvp, struct sa_desc *sa)
 
 	while (argc > 0) {
 		if (strcmp(*argv, "pn") == 0) {
-			if (sa->pn != 0)
+			if (sa->pn.pn32 != 0)
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
+			NEXT_ARG();
+			if (!hexstring_a2n(*argv, sa->salt, MACSEC_SALT_LEN,
+					   &len))
+				invarg("expected salt", *argv);
+		} else if (strcmp(*argv, "ssci") == 0) {
+			NEXT_ARG();
+			ret = get_u32(&sa->ssci, *argv, 0);
 		} else if (strcmp(*argv, "key") == 0) {
 			unsigned int len;
 
@@ -392,9 +419,22 @@ static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
 	addattr8(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_AN, sa->an);
 
 	if (c != CMD_DEL) {
-		if (sa->pn)
+		if (sa->xpn) {
+			if (sa->pn.pn64)
+				addattr64(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
+					  sa->pn.pn64);
+			if (sa->salt[0] != '\0')
+				addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SALT,
+					  sa->salt, MACSEC_SALT_LEN);
+			if (sa->ssci != 0)
+				addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_SSCI,
+					  sa->ssci);
+		}
+
+		if (sa->pn.pn32 && !sa->xpn) {
 			addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
-				  sa->pn);
+				  sa->pn.pn32);
+		}
 
 		if (sa->key_len) {
 			addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_KEYID,
@@ -426,10 +466,11 @@ static bool check_sa_args(enum cmd c, struct sa_desc *sa)
 			return -1;
 		}
 
-		if (sa->pn == 0) {
+		if (sa->pn.pn64 == 0) {
 			fprintf(stderr, "must specify a packet number != 0\n");
 			return -1;
 		}
+
 	} else if (c == CMD_UPD) {
 		if (sa->key_len) {
 			fprintf(stderr, "cannot change key on SA\n");
@@ -615,6 +656,9 @@ static void print_key(struct rtattr *key)
 
 #define CIPHER_NAME_GCM_AES_128 "GCM-AES-128"
 #define CIPHER_NAME_GCM_AES_256 "GCM-AES-256"
+#define CIPHER_NAME_GCM_AES_XPN_128 "GCM-AES-XPN-128"
+#define CIPHER_NAME_GCM_AES_XPN_256 "GCM-AES-XPN-256"
+
 #define DEFAULT_CIPHER_NAME CIPHER_NAME_GCM_AES_128
 
 static const char *cs_id_to_name(__u64 cid)
@@ -627,6 +671,10 @@ static const char *cs_id_to_name(__u64 cid)
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
@@ -846,8 +894,8 @@ static void print_txsa_stats(const char *prefix, struct rtattr *attr)
 }
 
 static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
-			struct rtattr *txsc_stats, struct rtattr *secy_stats,
-			struct rtattr *sa)
+			bool is_xpn, struct rtattr *txsc_stats,
+			struct rtattr *secy_stats, struct rtattr *sa)
 {
 	struct rtattr *sa_attr[MACSEC_SA_ATTR_MAX + 1];
 	struct rtattr *a;
@@ -875,8 +923,15 @@ static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
 		print_string(PRINT_FP, NULL, "%s", prefix);
 		print_uint(PRINT_ANY, "an", "%d:",
 			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
-		print_uint(PRINT_ANY, "pn", " PN %u,",
-			   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		if (!is_xpn) {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		} else {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
+			print_uint(PRINT_ANY, "ssci", " SSCI %u,",
+				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI]));
+		}
 
 		print_bool(PRINT_JSON, "active", NULL, state);
 		print_string(PRINT_FP, NULL,
@@ -916,7 +971,8 @@ static void print_rxsc_stats(const char *prefix, struct rtattr *attr)
 }
 
 static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
-			struct rtattr *rxsc_stats, struct rtattr *sa)
+			bool is_xpn, struct rtattr *rxsc_stats,
+			struct rtattr *sa)
 {
 	struct rtattr *sa_attr[MACSEC_SA_ATTR_MAX + 1];
 	struct rtattr *a;
@@ -943,8 +999,15 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
 		print_string(PRINT_FP, NULL, "%s", prefix);
 		print_uint(PRINT_ANY, "an", "%u:",
 			   rta_getattr_u8(sa_attr[MACSEC_SA_ATTR_AN]));
-		print_uint(PRINT_ANY, "pn", " PN %u,",
-			   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		if (!is_xpn) {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_PN]));
+		} else {
+			print_uint(PRINT_ANY, "pn", " PN %u,",
+				   rta_getattr_u64(sa_attr[MACSEC_SA_ATTR_PN]));
+			print_uint(PRINT_ANY, "ssci", " SSCI %u,",
+				   rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI]));
+		}
 
 		print_bool(PRINT_JSON, "active", NULL, state);
 		print_string(PRINT_FP, NULL, " state %s,",
@@ -958,7 +1021,7 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
 	close_json_array(PRINT_JSON, NULL);
 }
 
-static void print_rxsc_list(struct rtattr *sc)
+static void print_rxsc_list(struct rtattr *sc, bool is_xpn)
 {
 	int rem = RTA_PAYLOAD(sc);
 	struct rtattr *c;
@@ -973,6 +1036,7 @@ static void print_rxsc_list(struct rtattr *sc)
 		print_rx_sc("    ",
 			    rta_getattr_u64(sc_attr[MACSEC_RXSC_ATTR_SCI]),
 			    rta_getattr_u32(sc_attr[MACSEC_RXSC_ATTR_ACTIVE]),
+			    is_xpn,
 			    sc_attr[MACSEC_RXSC_ATTR_STATS],
 			    sc_attr[MACSEC_RXSC_ATTR_SA_LIST]);
 		close_json_object();
@@ -989,6 +1053,8 @@ static int process(struct nlmsghdr *n, void *arg)
 	int ifindex;
 	__u64 sci;
 	__u8 encoding_sa;
+	__u64 cid;
+	bool is_xpn = false;
 
 	if (n->nlmsg_type != genl_family)
 		return -1;
@@ -1032,13 +1098,16 @@ static int process(struct nlmsghdr *n, void *arg)
 
 	print_attrs(attrs_secy);
 
-	print_tx_sc("    ", sci, encoding_sa,
+	cid = rta_getattr_u64(attrs_secy[MACSEC_SECY_ATTR_CIPHER_SUITE]);
+	if (cid == MACSEC_CIPHER_ID_GCM_AES_XPN_128 || cid == MACSEC_CIPHER_ID_GCM_AES_XPN_256)
+		is_xpn = true;
+	print_tx_sc("    ", sci, encoding_sa, is_xpn,
 		    attrs[MACSEC_ATTR_TXSC_STATS],
 		    attrs[MACSEC_ATTR_SECY_STATS],
 		    attrs[MACSEC_ATTR_TXSA_LIST]);
 
 	if (attrs[MACSEC_ATTR_RXSC_LIST])
-		print_rxsc_list(attrs[MACSEC_ATTR_RXSC_LIST]);
+		print_rxsc_list(attrs[MACSEC_ATTR_RXSC_LIST], is_xpn);
 
 	if (attrs[MACSEC_ATTR_OFFLOAD]) {
 		struct rtattr *attrs_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
@@ -1251,6 +1320,7 @@ static void usage(FILE *f)
 		"                  [ send_sci { on | off } ]\n"
 		"                  [ end_station { on | off } ]\n"
 		"                  [ scb { on | off } ]\n"
+		"                  [ xpn { on | off } ]\n"
 		"                  [ protect { on | off } ]\n"
 		"                  [ replay { on | off} window { 0..2^32-1 } ]\n"
 		"                  [ validate { strict | check | disabled } ]\n"
@@ -1268,7 +1338,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 	enum macsec_offload offload;
 	struct cipher_args cipher = {0};
 	enum macsec_validation_type validate;
-	bool es = false, scb = false, send_sci = false;
+	bool es = false, scb = false, send_sci = false, xpn = false;
 	int replay_protect = -1;
 	struct sci sci = { 0 };
 
@@ -1388,6 +1458,14 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 				return ret;
 			addattr8(n, MACSEC_BUFLEN,
 				 IFLA_MACSEC_OFFLOAD, offload);
+		} else if (strcmp(*argv, "xpn") == 0) {
+			NEXT_ARG();
+			int i;
+
+			i = parse_on_off("xpn", *argv, &ret);
+			if (ret != 0)
+				return ret;
+			xpn = i;
 		} else {
 			fprintf(stderr, "macsec: unknown command \"%s\"?\n",
 				*argv);
@@ -1415,6 +1493,13 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 		return -1;
 	}
 
+	if (xpn) {
+		if (cipher.id == MACSEC_CIPHER_ID_GCM_AES_256)
+			cipher.id = MACSEC_CIPHER_ID_GCM_AES_XPN_256;
+		else
+			cipher.id = MACSEC_CIPHER_ID_GCM_AES_XPN_128;
+	}
+
 	if (cipher.id)
 		addattr_l(n, MACSEC_BUFLEN, IFLA_MACSEC_CIPHER_SUITE,
 			  &cipher.id, sizeof(cipher.id));
-- 
2.21.3

