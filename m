Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A72F570477
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiGKNjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiGKNjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:39:07 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A1341D0E
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:39:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYmpfiTprpC/BBMlxAMljsNYmkWiczvY6dZm1enZMkrCwAyRi7TeC2ZsNRO5DV7m0cVs778Ti2Wp98AJCmtWpsJtuzkGp+m0hf1wARDWwQfrCpn+qbJB50Bs03dEXgC2iJuKwiGNtArEH2YYHfo0mVi9C0mwT841Vg96cGHlrZkccOO97O++iTpRp+F3V9/hnwlVeEFwFc4Ur8CZswiUP+i33V8MxMkoyrONK2njD89C0rBNaQNsRpWlOUEaeLhvR71D0gT/QjlrVJtsOCPo5M+JlyYqYJx1PMlpSvAk8DOlBbG5kAkgisCGMF+nLTmHBwXmTvoER70JABQ+Xyl9uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QAo9bWZBSzqjITNS7GhdhcaWnBVNrGGLAbKZaQsdE90=;
 b=ikplK+7Q/MsHsMHS87AQEqgNFUwG7I1H1MiXbtCzLf/RTKuIlpfdp/51TngKBRYgNngaiiJpvFAnrA2HLmjcgjOkGXus+LLHVLDQ8Q/nm/EtN9JNy+fBeGNbUNZEPOCKg0nLxmp90/jw5Ga1SegxTruT9K6cs7OvKXS9ARU5ehwMC+HJJKk57IJdBgmR634xrUWb0utKzJP6AGqmFQHLxoioZa+reVPJ7XRsvMql9Ul0MnJZQMat2zTZaAMW0b3Hr4bg94RR9JgbnuphKZgwzRDWxdu/yAoHqK4CkOgK01TdPE9SPqPPLp0xJfAF5qsqCHDZUf3Iqibvpsz6ImzF5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAo9bWZBSzqjITNS7GhdhcaWnBVNrGGLAbKZaQsdE90=;
 b=AqGg1JE60jIagZuzJOBk07jN7prV0NxPAsxYmPjT/0FisrQRUxxNWDxBWm1Qz5qnnlh8En0t2F7Q6UblctmG0yjqJonkcece440xfcRXwT1h6pYpE2oYUQyHDzN38R8ORRZqnFi00+412mMqG814VhzI2hAjYciIWvoeAVOpg0Qde5RoOifTA77Ome/u+/ABbHTTMnjk2i8xwbpPVePxu29amsBCmkd911+qgVlCkCzulyFoidXwmiXzOW9AqCpOQtADco2GOAUvEJf61wjud4FyLBhsccmX9khxDbj3aGVqWswg/3cXeiQq9hNJGwvsZq40YhB7IAM7rPMFB/jzQw==
Received: from DM6PR03CA0096.namprd03.prod.outlook.com (2603:10b6:5:333::29)
 by DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Mon, 11 Jul
 2022 13:39:04 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::24) by DM6PR03CA0096.outlook.office365.com
 (2603:10b6:5:333::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16 via Frontend
 Transport; Mon, 11 Jul 2022 13:39:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Mon, 11 Jul 2022 13:39:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 11 Jul 2022 13:39:03 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Mon, 11 Jul 2022 06:39:03 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 11 Jul
 2022 06:39:01 -0700
From:   <ehakim@nvidia.com>
To:     <dsahern@kernel.org>, <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH v1 2/3] macsec: add Extended Packet Number support
Date:   Mon, 11 Jul 2022 16:38:52 +0300
Message-ID: <20220711133853.19418-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220711133853.19418-1-ehakim@nvidia.com>
References: <20220711133853.19418-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b969e72-cc9d-4b18-f076-08da6342b8ac
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gjCj6MAAcbsmwOuMQsXQtEHiHUmWW2V7SB8LwKVXFyQlR1YKqtwJ9zHgSCHVNNkgUukFjMy03atMePipzM+hCcMU+hFKHN61a4X2Bl5CEGRmoXZpnUYITytm64EDzOoaMSBO97z1+4CM9QOJqA9jyjdACh2c5HXpFXfrADj5WdT45eFS2+uU9doaCSegsVw0XmQlI57WzoX7x2t6pWnXV+ULN2bQc3Ccp1DV4qNZwE/U5VlnT9ZY0Drx+AWxqQGnxLbUPM3p0joswHeYrJveL0BUFxnSkpSNjPSHy0s0kz7T+KMWAGDK34zo2zD+QlwYlhSouK9iAT/b6d1s1kko2OCNqum4QkFx1t9xHRTjd+MrWKwJFefvRtElnrmFCSSAHIVP69ouscmqiErrcU32nUvX5Fp8O4pL/lHkl2r1K0nwC8CCRsyDxRZoaoowgP6t2ZGlyWqSi/Ggfq7duI5cfNPuN+Zn1bcDUVkWsIBNpGWxImueBYZ8XKsFdpR8BD1B0xD65N8Nj5OVwvp26Bw97w73wemes78B8QurzZrB1jGpY4aZ2eP6dEx2lWRsF1IBz8cgPAzMgYwQUCJw2qIT/TcssX/wJD8MLY7NuCthf8vhaT9HVdIZ9v03aNlFo+kA84yVzbCEcoHs4iQc3gD8nErchqOd9U5mX1SU0vmg8O00xZCvDCnIWLn7hcjV2nFtZr6OQzq4R84c9xBm2OIRhwC6Q4clEIw2sMhbel7C9EGT9rvYM5WDHH47Vnbaax0EE4257+ShE6LXRc3L/qYJjPqNHRWm35JOOAMux2j4ceDrZ4+ak627dO1lzBLfiCyGThMUTxnGgl12clnK4ovjZVOsXbeBxlKV6Ph1xqHP2Lc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(346002)(46966006)(40470700004)(36840700001)(110136005)(478600001)(36860700001)(86362001)(70586007)(81166007)(7696005)(47076005)(336012)(107886003)(36756003)(426003)(82740400003)(316002)(54906003)(70206006)(4326008)(1076003)(8676002)(186003)(2616005)(26005)(2906002)(40460700003)(41300700001)(6666004)(5660300002)(8936002)(2876002)(356005)(83380400001)(82310400005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 13:39:04.2585
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b969e72-cc9d-4b18-f076-08da6342b8ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

This patch adds support for extended packet number (XPN).
XPN can be configured by passing 'xpn' as flag in the ip
link add command using macsec type, in addition using
'xpn' keyword instead of the 'pn' and passing a 12 bytes salt
using the 'salt' keyword as part of the ip macsec command is
also required (see example).
XPN uses a 32 bit short secure channel id (ssci) instead of
the 64 bit secure channel id (sci) for the initialization vector
(IV) calculation, this patch also allows the user to optionally
pass his own ssci using the 'ssci' keyword in the ip macsec
command, in case of non provided ssci, the value 1 will be passed
as the default ssci value.

e.g:

create a MACsec device on link eth0 with enabled xpn
  # ip link add link eth0 macsec0 type macsec port 11
	encrypt on flag xpn

configure a secure association on the device (here ssci is default)
  # ip macsec add macsec0 tx sa 0 xpn 1024
	salt 838383838383838383838383 on
	key 01 81818181818181818181818181818181

configure a secure association on the device with ssci = 5
  # ip macsec add macsec0 tx sa 0 xpn 1024 ssci 5
	salt 838383838383838383838383 on
	key 01 81818181818181818181818181818181

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 include/uapi/linux/if_macsec.h |   2 +
 ip/ipmacsec.c                  | 117 +++++++++++++++++++++++++++++----
 2 files changed, 108 insertions(+), 11 deletions(-)

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
index 9aeaafcc..54ab5f39 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -41,13 +41,33 @@ struct sci {
 	char abuf[6];
 };
 
+union __pn {
+	struct {
+#  if __BYTE_ORDER == __LITTLE_ENDIAN
+		__u32 lower;
+		__u32 upper;
+#endif
+# if __BYTE_ORDER == __BIG_ENDIAN
+		__u32 upper;
+		__u32 lower;
+#endif
+# if __BYTE_ORDER != __BIG_ENDIAN && __BYTE_ORDER != __LITTLE_ENDIAN
+#error  "Please fix byteorder defines"
+#endif
+	};
+	__u64 full64;
+};
+
 struct sa_desc {
 	__u8 an;
-	__u32 pn;
+	union __pn pn;
 	__u8 key_id[MACSEC_KEYID_LEN];
 	__u32 key_len;
 	__u8 key[MACSEC_MAX_KEY_LEN];
 	__u8 active;
+	__u8 salt[MACSEC_SALT_LEN];
+	__u32 ssci;
+	bool xpn;
 };
 
 struct cipher_args {
@@ -71,8 +91,14 @@ struct rxsc_desc {
 	__u8 active;
 };
 
+/* masks to set a bit in flags, hence to set bit i in flags,
+ * we need to use and bitwise with the value 2^(i-1)
+ */
+#define MACSEC_FLAGS_XPN 1
+
 #define MACSEC_BUFLEN 1024
 
+#define DEFAULT_SSCI 1
 
 /* netlink socket */
 static struct rtnl_handle genl_rth;
@@ -98,7 +124,7 @@ static void ipmacsec_usage(void)
 		"       ip macsec show\n"
 		"       ip macsec show DEV\n"
 		"       ip macsec offload DEV [ off | phy | mac ]\n"
-		"where  OPTS := [ pn <u32> ] [ on | off ]\n"
+		"where  OPTS := [ pn <u32> ] [ xpn <u64> ] [ salt <u96> ] [ ssci <u32> ] [ on | off ]\n"
 		"       ID   := 128-bit hex string\n"
 		"       KEY  := 128-bit or 256-bit hex string\n"
 		"       SCI  := { sci <u64> | port { 1..2^16-1 } address <lladdr> }\n");
@@ -174,14 +200,34 @@ static int parse_sa_args(int *argcp, char ***argvp, struct sa_desc *sa)
 
 	while (argc > 0) {
 		if (strcmp(*argv, "pn") == 0) {
-			if (sa->pn != 0)
+			if (sa->pn.lower != 0)
 				duparg2("pn", "pn");
 			NEXT_ARG();
-			ret = get_u32(&sa->pn, *argv, 0);
+			ret = get_u32(&sa->pn.lower, *argv, 0);
+			if (ret)
+				invarg("expected pn", *argv);
+			if (sa->pn.lower == 0)
+				invarg("expected pn != 0", *argv);
+		} else if (strcmp(*argv, "xpn") == 0) {
+			if (sa->pn.full64 != 0)
+				duparg2("xpn", "xpn");
+			NEXT_ARG();
+			ret = get_u64(&sa->pn.full64, *argv, 0);
 			if (ret)
 				invarg("expected pn", *argv);
-			if (sa->pn == 0)
+			if (sa->pn.full64 == 0)
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
+			ret = get_u32(&sa->ssci, *argv, 0);
 		} else if (strcmp(*argv, "key") == 0) {
 			unsigned int len;
 
@@ -392,9 +438,29 @@ static int do_modify_nl(enum cmd c, enum macsec_nl_commands cmd, int ifindex,
 	addattr8(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_AN, sa->an);
 
 	if (c != CMD_DEL) {
-		if (sa->pn)
+		if (sa->xpn) {
+			if (sa->pn.full64)
+				addattr64(&req.n, MACSEC_BUFLEN,
+					  MACSEC_SA_ATTR_PN, sa->pn.full64);
+			if (c == CMD_ADD) {
+				addattr_l(&req.n, MACSEC_BUFLEN,
+					  MACSEC_SA_ATTR_SALT,
+					  sa->salt, MACSEC_SALT_LEN);
+				if (sa->ssci != 0)
+					addattr32(&req.n, MACSEC_BUFLEN,
+						  MACSEC_SA_ATTR_SSCI,
+						  sa->ssci);
+				else
+					addattr32(&req.n, MACSEC_BUFLEN,
+						  MACSEC_SA_ATTR_SSCI,
+						  DEFAULT_SSCI);
+			}
+		}
+
+		if (sa->pn.lower && !sa->xpn) {
 			addattr32(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_PN,
-				  sa->pn);
+				  sa->pn.lower);
+		}
 
 		if (sa->key_len) {
 			addattr_l(&req.n, MACSEC_BUFLEN, MACSEC_SA_ATTR_KEYID,
@@ -426,10 +492,17 @@ static bool check_sa_args(enum cmd c, struct sa_desc *sa)
 			return -1;
 		}
 
-		if (sa->pn == 0) {
+		if (sa->pn.full64 == 0) {
 			fprintf(stderr, "must specify a packet number != 0\n");
 			return -1;
 		}
+
+		if (sa->xpn && sa->salt[0] == '\0') {
+			fprintf(stderr,
+				"xpn set, but no salt set.\n");
+			return -1;
+		}
+
 	} else if (c == CMD_UPD) {
 		if (sa->key_len) {
 			fprintf(stderr, "cannot change key on SA\n");
@@ -615,6 +688,9 @@ static void print_key(struct rtattr *key)
 
 #define CIPHER_NAME_GCM_AES_128 "GCM-AES-128"
 #define CIPHER_NAME_GCM_AES_256 "GCM-AES-256"
+#define CIPHER_NAME_GCM_AES_XPN_128 "GCM-AES-XPN-128"
+#define CIPHER_NAME_GCM_AES_XPN_256 "GCM-AES-XPN-256"
+
 #define DEFAULT_CIPHER_NAME CIPHER_NAME_GCM_AES_128
 
 static const char *cs_id_to_name(__u64 cid)
@@ -627,6 +703,10 @@ static const char *cs_id_to_name(__u64 cid)
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
@@ -1258,7 +1338,7 @@ static void usage(FILE *f)
 		"                  [ offload { mac | phy | off } ]\n"
 		"                  [ flag FLAG-LIST ]\n"
 		"FLAG-LIST :=      [ FLAG-LIST ] FLAG\n"
-		"FLAG :=\n"
+		"FLAG :=           xpn\n"
 		);
 }
 
@@ -1268,8 +1348,16 @@ static int macsec_flag_parse(__u8 *flags, int *argcp, char ***argvp)
 	char **argv = *argvp;
 
 	while (1) {
-		/* parse flag list */
-		break;
+		if (strcmp(*argv, "xpn") == 0) {
+			*flags |= MACSEC_FLAGS_XPN;
+		} else {
+			PREV_ARG(); /* back track */
+			break;
+		}
+
+		if (!NEXT_ARG_OK())
+			break;
+		NEXT_ARG();
 	}
 
 	*argcp = argc;
@@ -1438,6 +1526,13 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 		return -1;
 	}
 
+	if (flags & MACSEC_FLAGS_XPN) {
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
2.26.3

