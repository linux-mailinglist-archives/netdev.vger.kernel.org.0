Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED435486C0
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 17:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357373AbiFMNMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359294AbiFMNJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:09:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB871A040
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kc6yeR1C4ccj2X4v0U6h9c7iLzmiD0iQhxF6gS+IaScArfTfqOARKsWWM3GcsP4tBO07GhcW9WjOtDLrLK6mo5RgWjR8eKKlY8u4hELMOx+DS11agBfsICkGeZya69CSnzX+xHHBrUFcODKaizJzP8Luf75E/Z8YqpAhvK2ZMU3iGfNCi3mqpiN5JaYM/krrNMZt1nLZQAxlA8NL7nuPEZY7+RuLPWypw1HAXgSGCabKZW3FLSVqsP9nnUS+22eh7AweFsEEe0WMh0hGedD+tFnbtYc1U6d8hZY0T8U0ERgL44nhH/u3bmQv7sH9LvpD0sFcwZIVr0LTOIx3YfUqCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dtd16y4tJyEVWqbb64SzFctrPrTO3rP20ZkhjwylwT0=;
 b=nvUlz0N0RgFExTtjEmG3Yw73H3Ctryfl0cAYJfcabjxyoefgRHNmusv8B5yOZ+qL2G9j5MA+qxhCS6X6FBM9r6utY/gmpXec3WpVkLPzoOzlkLmhSCYKSQKieuFLyqNHUV5oz7Sl8NqqLBXK1f7hQ62isP0yf/qweOMCCSLIBV/0/SPjyC4PXzbOnqopJWr6Hrdh22TXAyn7lTl1fP8nJsfgwxkANW2nRgDmnKY8JrgIDPBf0Eag7axiShW949PUoU2f4mTo5wt+pdfEALxGpcF0qgtQJqSQ2qemS8psBTYLpbYaJTBeGTBMBZyNzqmprNHNzlLTelcaP7MbzrQ4EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dtd16y4tJyEVWqbb64SzFctrPrTO3rP20ZkhjwylwT0=;
 b=E1BXOpesM/KYQI8qSBO5PMIy9FGl+o9FC220+6QyifDqYgL+qLYfXlvP55MGlsOg9xywIqROadUFFAimWWWdhdlBPO2TnlRgUGg5YNb1RcOfqInBABtfOlL6JJnH9mBC00iMzBp8uSoanssNz5PYTLriM8BHw7C/KnDVliD4+6AYMY+N79bGr0ru5ndWflp1vAYuRKbxEwWrtmt2f5/1OH3SuPDIt8Q/FRX7cmouTmsfR956h97hgsjoED8io5/Kvu+8NBIBQofIMcFk+ltRVHr8eb1Inzc1SjQJtdV9KB8UUjw9hbqvPz+i9v77VsPM55f0CameJm6h0Jjgk5zJMQ==
Received: from DM5PR07CA0036.namprd07.prod.outlook.com (2603:10b6:3:16::22) by
 DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.20; Mon, 13 Jun 2022 11:19:57 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::b1) by DM5PR07CA0036.outlook.office365.com
 (2603:10b6:3:16::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13 via Frontend
 Transport; Mon, 13 Jun 2022 11:19:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:19:57 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:19:56 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:19:55 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:19:53 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v3 3/3] net/macsec: Move some code for sharing with various drivers that implements offload
Date:   Mon, 13 Jun 2022 14:19:42 +0300
Message-ID: <20220613111942.12726-4-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220613111942.12726-1-liorna@nvidia.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 233f32b2-6c4e-49b0-19e0-08da4d2ea5ce
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_
X-Microsoft-Antispam-PRVS: <DS0PR12MB6486E8310C82C20341F278CDBFAB9@DS0PR12MB6486.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xh5Pm28aRRTMqLydPPZC3dMrft7tQNeNbHOKaLSgAwPtcVJ3z0W/s6GrCszbK201/31Xc18z5Wx1a3Ubi9vOUjQIUa/i2QopIgXeIgtT1T5SG48MVIDfnvpbaYQ7kMVNzErJ/SPNAz8k2L2BQb+asuAJsROlfN+vrlT6hNqBpzSqDgWSD+HlyS5eMBjblmCHqzA0XLUlhqvXH0cYWt6Nq1HFSQTGks1TXrOJew6ckot5unYV2+h3oj/2yDH555JV7Z5dolFu1r9ZpASSKFCb58JpdUTtQnP88A2alAyXMYCt0RbfLiF5WL5AXNW8axBap/EvfLumHutqX+Wcq5pxiUiIWdTwkVP9eClAt6PUuCTaECpd0iXJE8/KlEZDuIlHrqVKaZMWCtwVJIhW14IMXhV4WbWAnHVk6LcmKd5F8NgCFupiCn8Qfy4vpTb2dGQQE80LXBpwZLJm5uruL/VvcfSkc94ySQyV7n8SMazimxqucs1CbnKF1pmz9t4pgzniS99dpzgyPBZRI79Ekwye5fJGUcypyk1wdImkB1uJB80y+LlijfaoRI7tfIgq9O5+DAKsk9/elko3mgPVbPhe+vRqhc9dAIo+GpjC04lN9jJTqV300rABqpd7pAuCM9oc2IibjjJOEQDjjpr+4xMH8b2DEyVwaSv9zRJqgFFhOAGdU+2aA6Mc5MyUGM2CgUwyOz7naqp+e8s5J2kt4UrtmQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(46966006)(36840700001)(70586007)(5660300002)(8676002)(70206006)(316002)(508600001)(8936002)(86362001)(426003)(6666004)(26005)(4326008)(81166007)(186003)(2616005)(2906002)(110136005)(54906003)(83380400001)(36860700001)(40460700003)(356005)(336012)(82310400005)(36756003)(47076005)(1076003)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:19:57.0834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 233f32b2-6c4e-49b0-19e0-08da4d2ea5ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some MACsec infrastructure like defines and functions,
which may be useful for other drivers who implemented MACsec offload,
aren't accessible since they aren't located in any header file.

Moved those values to MACsec header file will allow those drivers
to use them and avoid code duplication.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
---
v1->v2:
- moved MACSEC_PORT_ES from .c to .h
v2->v3:
- removed Issue and Change-Id from commit message
---
 drivers/net/macsec.c | 33 ++++++---------------------------
 include/net/macsec.h | 21 +++++++++++++++++++++
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 7b7baf3dd596..01ff881f4540 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -24,8 +24,6 @@
 
 #include <uapi/linux/if_macsec.h>
 
-#define MACSEC_SCI_LEN 8
-
 /* SecTAG length = macsec_eth_header without the optional SCI */
 #define MACSEC_TAG_LEN 6
 
@@ -46,20 +44,10 @@ struct macsec_eth_header {
 	u8 secure_channel_id[8]; /* optional */
 } __packed;
 
-#define MACSEC_TCI_VERSION 0x80
-#define MACSEC_TCI_ES      0x40 /* end station */
-#define MACSEC_TCI_SC      0x20 /* SCI present */
-#define MACSEC_TCI_SCB     0x10 /* epon */
-#define MACSEC_TCI_E       0x08 /* encryption */
-#define MACSEC_TCI_C       0x04 /* changed text */
-#define MACSEC_AN_MASK     0x03 /* association number */
-#define MACSEC_TCI_CONFID  (MACSEC_TCI_E | MACSEC_TCI_C)
-
 /* minimum secure data length deemed "not short", see IEEE 802.1AE-2006 9.7 */
 #define MIN_NON_SHORT_LEN 48
 
 #define GCM_AES_IV_LEN 12
-#define DEFAULT_ICV_LEN 16
 
 #define for_each_rxsc(secy, sc)				\
 	for (sc = rcu_dereference_bh(secy->rx_sc);	\
@@ -230,7 +218,6 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 	return (struct macsec_cb *)skb->cb;
 }
 
-#define MACSEC_PORT_ES (htons(0x0001))
 #define MACSEC_PORT_SCB (0x0000)
 #define MACSEC_UNDEF_SCI ((__force sci_t)0xffffffffffffffffULL)
 #define MACSEC_UNDEF_SSCI ((__force ssci_t)0xffffffff)
@@ -244,14 +231,6 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
 #define DEFAULT_ENCRYPT false
 #define DEFAULT_ENCODING_SA 0
 
-static bool send_sci(const struct macsec_secy *secy)
-{
-	const struct macsec_tx_sc *tx_sc = &secy->tx_sc;
-
-	return tx_sc->send_sci ||
-		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
-}
-
 static sci_t make_sci(const u8 *addr, __be16 port)
 {
 	sci_t sci;
@@ -316,7 +295,7 @@ static void macsec_fill_sectag(struct macsec_eth_header *h,
 	/* with GCM, C/E clear for !encrypt, both set for encrypt */
 	if (tx_sc->encrypt)
 		h->tci_an |= MACSEC_TCI_CONFID;
-	else if (secy->icv_len != DEFAULT_ICV_LEN)
+	else if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN)
 		h->tci_an |= MACSEC_TCI_C;
 
 	h->tci_an |= tx_sc->encoding_sa;
@@ -634,7 +613,7 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 
 	unprotected_len = skb->len;
 	eth = eth_hdr(skb);
-	sci_present = send_sci(secy);
+	sci_present = macsec_send_sci(secy);
 	hh = skb_push(skb, macsec_extra_len(sci_present));
 	memmove(hh, eth, 2 * ETH_ALEN);
 
@@ -1268,7 +1247,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	/* 10.6.1 if the SC is not found */
 	cbit = !!(hdr->tci_an & MACSEC_TCI_C);
 	if (!cbit)
-		macsec_finalize_skb(skb, DEFAULT_ICV_LEN,
+		macsec_finalize_skb(skb, MACSEC_DEFAULT_ICV_LEN,
 				    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
@@ -4007,7 +3986,7 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	rx_handler_func_t *rx_handler;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	struct net_device *real_dev;
 	int err, mtu;
 	sci_t sci;
@@ -4131,7 +4110,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 				struct netlink_ext_ack *extack)
 {
 	u64 csid = MACSEC_DEFAULT_CIPHER_ID;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	int flag;
 	bool es, scb, sci;
 
@@ -4143,7 +4122,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_MACSEC_ICV_LEN]) {
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-		if (icv_len != DEFAULT_ICV_LEN) {
+		if (icv_len != MACSEC_DEFAULT_ICV_LEN) {
 			char dummy_key[DEFAULT_SAK_LEN] = { 0 };
 			struct crypto_aead *dummy_tfm;
 
diff --git a/include/net/macsec.h b/include/net/macsec.h
index fcbca963c04d..e727924c5e52 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -17,6 +17,20 @@
 #define MACSEC_SALT_LEN 12
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
+#define MACSEC_SCI_LEN 8
+#define MACSEC_PORT_ES (htons(0x0001))
+
+#define MACSEC_TCI_VERSION 0x80
+#define MACSEC_TCI_ES      0x40 /* end station */
+#define MACSEC_TCI_SC      0x20 /* SCI present */
+#define MACSEC_TCI_SCB     0x10 /* epon */
+#define MACSEC_TCI_E       0x08 /* encryption */
+#define MACSEC_TCI_C       0x04 /* changed text */
+#define MACSEC_AN_MASK     0x03 /* association number */
+#define MACSEC_TCI_CONFID  (MACSEC_TCI_E | MACSEC_TCI_C)
+
+#define MACSEC_DEFAULT_ICV_LEN 16
+
 typedef u64 __bitwise sci_t;
 typedef u32 __bitwise ssci_t;
 
@@ -295,5 +309,12 @@ struct macsec_ops {
 };
 
 void macsec_pn_wrapped(struct macsec_secy *secy, struct macsec_tx_sa *tx_sa);
+static inline bool macsec_send_sci(const struct macsec_secy *secy)
+{
+	const struct macsec_tx_sc *tx_sc = &secy->tx_sc;
+
+	return tx_sc->send_sci ||
+		(secy->n_rx_sc > 1 && !tx_sc->end_station && !tx_sc->scb);
+}
 
 #endif /* _NET_MACSEC_H_ */
-- 
2.25.4

