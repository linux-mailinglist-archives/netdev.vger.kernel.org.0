Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D237E5AC34D
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 09:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbiIDHsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 03:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiIDHr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 03:47:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248FB44560
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 00:47:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezllAtAXVEwdsw7Vzi8X1tj39Rh72brk6uQ8Am5KG2xKmD6pibIJZGHn+S06E4tIRFRcMZ43GMItcgeqh/KjG6KMS/9YM5AWF7RSKNdfTdkj+qoT1DTVgzjTBKWGcmE9CU1ZY1QE30GWG7/GFq2FDXPF7Cw9KY0enfVZ4/ytAHM3jRAC7KDBwY2kME6p1UsyfU9Qun3hj6gu6lHqbl4UgItr3wp2PCMTl0azW+ZxhQOjV9i6VP9s7+r6FZZlF6g+hU/Pw3xb3RPEI4J4IqW8IDFm6lcl5CLrt/w2rUbZsaKsx/8E8gpDskx89l7VxqpEDSnKhs0DcrcQ1huxMmCZiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9njO9acSF+LCMn3wX1mW7Z5EcW0Bz5xpAwAOy/9mg48=;
 b=Pq1aR/hWb1Jtv5TKDLKHW6pm6Wj+oHkxJsqaJyyYDLvTC8yvHMgRY5JDZ3ospOm2OekekEusNCrsCOCGW5QorZ0BZw33e0WTW3W8tWw2zIg2WN/kvsS5Uik6b+Ehitf7UuHXrKh6NxQ9CABC6P76Wh3+QNwqa2UGr0gEqnj+NkwoH0POkILyn8eFzpJU35tOzkKjlkp3217m8tiHHJljvsdo8FLBMNf7DOEvP3d/l3Ow/dB7X93qg8YyyI+JjhoaAXxCVL46t1CzrnjrAjNQuQSoPMPgCU3w9hPGqU2MaSvdBzS5A6xUjANdIiWXtkbGsAxPAzGB+oKaUjIxuq/Udg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9njO9acSF+LCMn3wX1mW7Z5EcW0Bz5xpAwAOy/9mg48=;
 b=naczQUuurrMYknB21TfT8f34DvoyCsHSRTLAIQebP7gasFs1gJ26DNe+V5k7KS7lM7Xx5rNWz2X28cfYXDCk7dvizLThOkNN3i4vhRN2ur7iCKDjnMXujVVTeiERdEQsUvJPeLGAhcakSmcGpiS3I42KiV/wQkT3A4k3tIoTWvMKfnAn1aX2s7iL5SVIsrEp3afElT9OokTJOoTf2rY80LYZcYffWEpxrIjrlrbri206tA3zs0/+IzTNzf/hyLZ3K29s8O0IcOw/s4+DCEucIx5TX+Bd8IzTkl4UwPUM0UjyK11P0npYNcFr83Ib48frt6zWaY6WIif16WGV14vB8A==
Received: from MW4P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::33)
 by DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Sun, 4 Sep
 2022 07:47:55 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::80) by MW4P220CA0028.outlook.office365.com
 (2603:10b6:303:115::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.13 via Frontend
 Transport; Sun, 4 Sep 2022 07:47:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Sun, 4 Sep 2022 07:47:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 4 Sep
 2022 07:47:53 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 4 Sep 2022
 00:47:52 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Sun, 4 Sep
 2022 00:47:51 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <raeds@nvidia.com>, <tariqt@nvidia.com>,
        "Emeel Hakim" <ehakim@nvidia.com>
Subject: [PATCH main v3 1/2] macsec: add Extended Packet Number support
Date:   Sun, 4 Sep 2022 10:47:28 +0300
Message-ID: <20220904074729.4804-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94344437-9d76-46ce-61d8-08da8e49c71f
X-MS-TrafficTypeDiagnostic: DS7PR12MB6045:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0R1EfW42le4YwSf+m96/+jOcvYgqe4eKpPQx894ABzYWgkzwZ6yHLGrk1jAKnuZZDeWzvyLwOcfD78ex3GNmU0/ueSj9P6kU9Ysw+cQ6Ur/QHLo3+cd01funXtHDwiqDiWveOerhPKbkaoRJ37ROKQY1uFduzNd71Fj+cLd/Oud9H02D31DCs6gWz6xWOtTaj2GRcwAVF9wpl0jnNTsoaIcQ+sw4921vX6GUV+FTLHWaZuxDaPVTOW4oJ5a9/dxHAHTLNMSNkqa8IA0gy6M4+BWLDhOygbzMoO8XxcVFstCPTMArQTzGO5w/a3KFbPOjU2Ugtb0bFdY2Ueb3RlY+uJ8fNldc18Yk8KcB0V1g6v26xWwZLyAA4T2DFrizkVnGwHSQCt0UyvKcC6yOgbtPpfcEebn8nvh8cQUh1reI+0KlNIvo3ZSLe2w5VHlVFrDbqSmXd50BGOg0g3f65+EIPO4EQhoXHvLqE/emBr0mxvKRqZH/BzIRE76/lLjemw4eRxtgJo/xtZ3YMGqYPHpbbmD30MGVUHRoJ49efv3TaQHnmUP6l4J4zN3cjwmNE+jXEytsAuNwMMs5kSYSz2xf5udrYbmJWu9NSIGticpXk6KWJr7yUkkIBNZ8SmFcj6QF+rC81C0/9tiIWMCdLN2xr0mHO/1aRHE25aUfSVeGsEHwUBXuggcGeD+orrK4RJlnA/2zaQXlbZYRaDET1Uiuv8E+oFT0Vz6h2z17bM9rEdMH/+jnQh2W77vBLVSWx30VB1Zaj59XusQl52KADP9pjFUE55ICDXHSg98762KLreZAdWjVlrz1pLeN8LydMrkHc0jzLW70PwvAzm/H0IABUyXd6NLVPsFnthmxPl/FU2TSKL9satFRgFenqTV0EZFB
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(376002)(36840700001)(46966006)(40470700004)(81166007)(86362001)(8936002)(40480700001)(82310400005)(70586007)(70206006)(4326008)(356005)(110136005)(54906003)(316002)(8676002)(478600001)(41300700001)(36860700001)(82740400003)(40460700003)(83380400001)(2906002)(5660300002)(30864003)(6666004)(7696005)(26005)(107886003)(47076005)(36756003)(186003)(336012)(1076003)(2616005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2022 07:47:54.9888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94344437-9d76-46ce-61d8-08da8e49c71f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

V2->V3:
- Add dedicated function to read ssci correctly.
- Check for duplicate xpn and pn where command line has an xpn argument
  with upper 32bits set followed by a pn argument.
- Don't use int to hold a boolean result. 

 ip/ipmacsec.c | 131 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 111 insertions(+), 20 deletions(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index bf48e8b5..3bff765d 100644
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
@@ -124,6 +131,11 @@ static int get_sci(__u64 *sci, const char *arg)
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
@@ -174,14 +186,36 @@ static int parse_sa_args(int *argcp, char ***argvp, struct sa_desc *sa)
 
 	while (argc > 0) {
 		if (strcmp(*argv, "pn") == 0) {
-			if (sa->pn != 0)
+			if (sa->pn.pn64 != 0)
 				duparg2("pn", "pn");
 			NEXT_ARG();
-			ret = get_u32(&sa->pn, *argv, 0);
+			ret = get_u32(&sa->pn.pn32, *argv, 0);
+			if (ret)
+				invarg("expected pn", *argv);
+			if (sa->pn.pn32 == 0)
+				invarg("expected pn != 0", *argv);
+		} else if (strcmp(*argv, "xpn") == 0) {
+			if (sa->pn.pn64 != 0)
+				duparg2("xpn", "xpn");
+			NEXT_ARG();
+			ret = get_u64(&sa->pn.pn64, *argv, 0);
 			if (ret)
 				invarg("expected pn", *argv);
-			if (sa->pn == 0)
+			if (sa->pn.pn64 == 0)
 				invarg("expected pn != 0", *argv);
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
+			ret = get_ssci(&sa->ssci, *argv);
+			if (ret)
+				invarg("expected ssci", *argv);
 		} else if (strcmp(*argv, "key") == 0) {
 			unsigned int len;
 
@@ -392,9 +426,22 @@ static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
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
@@ -426,10 +473,11 @@ static bool check_sa_args(enum cmd c, struct sa_desc *sa)
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
@@ -615,6 +663,9 @@ static void print_key(struct rtattr *key)
 
 #define CIPHER_NAME_GCM_AES_128 "GCM-AES-128"
 #define CIPHER_NAME_GCM_AES_256 "GCM-AES-256"
+#define CIPHER_NAME_GCM_AES_XPN_128 "GCM-AES-XPN-128"
+#define CIPHER_NAME_GCM_AES_XPN_256 "GCM-AES-XPN-256"
+
 #define DEFAULT_CIPHER_NAME CIPHER_NAME_GCM_AES_128
 
 static const char *cs_id_to_name(__u64 cid)
@@ -627,6 +678,10 @@ static const char *cs_id_to_name(__u64 cid)
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
@@ -846,8 +901,8 @@ static void print_txsa_stats(const char *prefix, struct rtattr *attr)
 }
 
 static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
-			struct rtattr *txsc_stats, struct rtattr *secy_stats,
-			struct rtattr *sa)
+			bool is_xpn, struct rtattr *txsc_stats,
+			struct rtattr *secy_stats, struct rtattr *sa)
 {
 	struct rtattr *sa_attr[MACSEC_SA_ATTR_MAX + 1];
 	struct rtattr *a;
@@ -875,8 +930,16 @@ static void print_tx_sc(const char *prefix, __u64 sci, __u8 encoding_sa,
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
+			print_0xhex(PRINT_ANY, "ssci",
+				    "SSCI %08x",
+				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
+		}
 
 		print_bool(PRINT_JSON, "active", NULL, state);
 		print_string(PRINT_FP, NULL,
@@ -916,7 +979,8 @@ static void print_rxsc_stats(const char *prefix, struct rtattr *attr)
 }
 
 static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
-			struct rtattr *rxsc_stats, struct rtattr *sa)
+			bool is_xpn, struct rtattr *rxsc_stats,
+			struct rtattr *sa)
 {
 	struct rtattr *sa_attr[MACSEC_SA_ATTR_MAX + 1];
 	struct rtattr *a;
@@ -943,8 +1007,16 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
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
+			print_0xhex(PRINT_ANY, "ssci",
+				    "SSCI %08x",
+				    ntohl(rta_getattr_u32(sa_attr[MACSEC_SA_ATTR_SSCI])));
+		}
 
 		print_bool(PRINT_JSON, "active", NULL, state);
 		print_string(PRINT_FP, NULL, " state %s,",
@@ -958,7 +1030,7 @@ static void print_rx_sc(const char *prefix, __be64 sci, __u8 active,
 	close_json_array(PRINT_JSON, NULL);
 }
 
-static void print_rxsc_list(struct rtattr *sc)
+static void print_rxsc_list(struct rtattr *sc, bool is_xpn)
 {
 	int rem = RTA_PAYLOAD(sc);
 	struct rtattr *c;
@@ -973,6 +1045,7 @@ static void print_rxsc_list(struct rtattr *sc)
 		print_rx_sc("    ",
 			    rta_getattr_u64(sc_attr[MACSEC_RXSC_ATTR_SCI]),
 			    rta_getattr_u32(sc_attr[MACSEC_RXSC_ATTR_ACTIVE]),
+			    is_xpn,
 			    sc_attr[MACSEC_RXSC_ATTR_STATS],
 			    sc_attr[MACSEC_RXSC_ATTR_SA_LIST]);
 		close_json_object();
@@ -989,6 +1062,8 @@ static int process(struct nlmsghdr *n, void *arg)
 	int ifindex;
 	__u64 sci;
 	__u8 encoding_sa;
+	__u64 cid;
+	bool is_xpn = false;
 
 	if (n->nlmsg_type != genl_family)
 		return -1;
@@ -1032,13 +1107,16 @@ static int process(struct nlmsghdr *n, void *arg)
 
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
@@ -1251,6 +1329,7 @@ static void usage(FILE *f)
 		"                  [ send_sci { on | off } ]\n"
 		"                  [ end_station { on | off } ]\n"
 		"                  [ scb { on | off } ]\n"
+		"                  [ xpn { on | off } ]\n"
 		"                  [ protect { on | off } ]\n"
 		"                  [ replay { on | off} window { 0..2^32-1 } ]\n"
 		"                  [ validate { strict | check | disabled } ]\n"
@@ -1268,7 +1347,7 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 	enum macsec_offload offload;
 	struct cipher_args cipher = {0};
 	enum macsec_validation_type validate;
-	bool es = false, scb = false, send_sci = false;
+	bool es = false, scb = false, send_sci = false, xpn = false;
 	int replay_protect = -1;
 	struct sci sci = { 0 };
 
@@ -1388,6 +1467,11 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 				return ret;
 			addattr8(n, MACSEC_BUFLEN,
 				 IFLA_MACSEC_OFFLOAD, offload);
+		} else if (strcmp(*argv, "xpn") == 0) {
+			NEXT_ARG();
+			xpn = parse_on_off("xpn", *argv, &ret);
+			if (ret != 0)
+				return ret;
 		} else {
 			fprintf(stderr, "macsec: unknown command \"%s\"?\n",
 				*argv);
@@ -1415,6 +1499,13 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
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

