Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC4D548E91
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351343AbiFMMkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 08:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357306AbiFMMjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 08:39:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2044.outbound.protection.outlook.com [40.107.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95C9340F7
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 04:10:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oe2/dsYtgMBW12B38kfSuQYa94Sw8F/7wlIoCH50IOMUF5Yw7jsREOrszLOCuQ041B/iP0UMS0Lb3A+juD6h26WVWTOZkfPRrv4krQM98qmsqZ3h84RTWSnkOarmpIXYcaU1LCiJYPzAJqv1JMrR/zNsLfWhhZ7hlNBt4GyM8yQGVs5NCRp/HDAVRkR9HrX+V7GTebQV/LJyAS2XUimhXZFsOgzSyL0co7kkWlCMSCa17NRFrNwF2FePKfOwC0dPkj5661WjXX/9PIvSpCNCVUVH+heXdZK/0B6r6g/UU96GJTvTogsga/WYjMfxV7dmE1QmZU+Ox0BCVNeZSeYB8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93IEZkwbVkbS/P1un+Yn1+yyD0WT3V0oMU8Uw/UjDf0=;
 b=TK0SKZ/vmB8rUHBPfPOlRq/+0u5pc9wbrcjHfXnEGR/TDVCc++rfPqILlfXjQ1C/9EwMur5s/WAVYEWcO/HehN4Cc2Mpk22B5j1YJm8tly3Mgv09TvnIDaJmmBNOEYIB1oXdjQczox8XsAOeE5aLWGIBFwmx0YiHIDWGE5oZlh/tAnLtFnuV+FXCeMUx66YaWEes1szGmv5jWHAVN0gJWuOkPNi891ZKxugr2XZUPOFPCc9GySHgdyaqRCewume4+q/oDBNUFW5gwcCj9NKJER/Ze1bfYsDeavzy8aXbGp7vySNuG+aiJWhnkFA6jCy0fLo5ZMDUbaLZ4+YYmOECTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93IEZkwbVkbS/P1un+Yn1+yyD0WT3V0oMU8Uw/UjDf0=;
 b=SJnmEd0LAof9FU5xekkQnflhkmXBQnDRaQXpBEnqgJU6v+m2fNfjuYnG+ySq0/U4iXQGU2L0xEIk0JQTdECIRd1Y3GxlgtX4sLQHrkKaNa9MtPNg+sU/QB/RP4HD7p/YS7y6DzSQfg8KFPq4mJO2xPpgiXEcQ/KDlTaOgNJW7f+g/wTxqKeE259XKaNGAdX6zbm8xAg4KxjA+5mt+bOtE/XC6E8qWrJWMPSHFSY0RA+cBpgB4PC5VurhL4Br0LcWtwZ4XuibN6dBJkPp8FN7fWI19XttU1uWQmufLFLwkBQDrFdPWJU2nMfVVisCvx3cpn8zsj/+SQ/rEGAVD9+cHQ==
Received: from BN8PR16CA0020.namprd16.prod.outlook.com (2603:10b6:408:4c::33)
 by MWHPR1201MB0015.namprd12.prod.outlook.com (2603:10b6:300:df::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 11:10:01 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::aa) by BN8PR16CA0020.outlook.office365.com
 (2603:10b6:408:4c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20 via Frontend
 Transport; Mon, 13 Jun 2022 11:10:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Mon, 13 Jun 2022 11:10:00 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 13 Jun
 2022 11:09:59 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 13 Jun
 2022 04:09:59 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 13 Jun 2022 04:09:57 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v2 3/3] net/macsec: Move some code for sharing with various drivers that implements offload
Date:   Mon, 13 Jun 2022 14:09:45 +0300
Message-ID: <20220613110945.7598-4-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220613110945.7598-1-liorna@nvidia.com>
References: <20220613110945.7598-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6ec6fa8-20dc-4151-e6ad-08da4d2d4258
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0015:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00153EE2383783730863D7DFBFAB9@MWHPR1201MB0015.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xcYax8orHn4itlSh3JWNxHql7jKQCYbsOQEkd+yN7mPw5wog6jsBp0vK2OTTyLnxOPQXZc0p3jz7RuV+GivN+AXIzv0ekX84MK1OAQoEjr65mNJh5qNLWgv0OP/L7/ZkfnC1MyOc7723NXeVWGS8+X3IJPO5DcqrA7SqMMiPrZgvY+KrmGGztBMlJhP+fL0BkhNd5j31hu7Vr2hvySnXrsPKr/Dt0GnFDsPfPvzfHGYDYJWnicQZHEJ8QFc3W4Dwhm4/3EApuYj5S2OKaRwYK9nh9PJoTclc3NhAOQV2GVgXVbn9qdbyidANAzlVOoXxdb1WoXb8+adDPShAvyjV1ar8Y7FbdBAKCWLVPcrBp6SkHyxYv4Zr9xbzRq13PufsiHJu8/bNPpbt8abf5x/RQH4uXqy00kJVZjx+i6YXgeJw2E+FV0MATnjs6q8w8UDmiyvm28J9L5ad4oI5yu/rTjN6X4BfXkHtbAKHROiuMaDcctZ8JcsYPdxmMhy70pbzZPZBD0EaUP3oWKX/zVei0eqs7G+uPOoKospl/uaye13NxhsuNU0t3RH5TSeEj/1TRgIHg8aSkL7GT874adX7fEhBpkIUwG/lxEFScC2tz83nnkhbIoB2kRfqRZy+652EBzn1m2yeX0B6EgAp+ic2yMkSEbaVYLMeCN6jvL+CXr8Ptb+5sXVGXvHQ80rStMQMIDWKUI9/c2L1E2rTDcS4jA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(46966006)(40470700004)(83380400001)(2616005)(1076003)(426003)(47076005)(107886003)(186003)(336012)(81166007)(36756003)(8936002)(5660300002)(356005)(36860700001)(82310400005)(2906002)(508600001)(70586007)(26005)(70206006)(54906003)(110136005)(4326008)(6666004)(8676002)(40460700003)(316002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2022 11:10:00.6617
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ec6fa8-20dc-4151-e6ad-08da4d2d4258
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0015
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

Issue: 2980522
Change-Id: I2363a380b9d968fc7298cd7b59acdf1abb81fe50
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
---
v1->v2:
- moved MACSEC_PORT_ES from .c to .h
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

