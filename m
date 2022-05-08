Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E779951EC53
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 11:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiEHJOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 05:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiEHJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 05:14:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35145DF1C
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 02:10:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CH4em1b58h266e4zVqqQXjucQSL4HxC7SEp5G6uUMen7ryljcs34B3TMoKcxK7xRBPSv4Lnvmg6/xoezg7kPwJpWLOj749ZnGVALlFJr8OYFwwIOzp9enCWyQhsvDXM7bBRUpNLxC1JX2SfQams5SP3Iaa1btYSWn52qYwZxdYzkylRcqRZPGnBssuHjKxZhyx8k6Z8LjQNEWstY7s6dk0qCdyh0+vOYu0eHtntqzAkD+TcjboKurmXwKXBkgatEzgLh9WFc6F7M0OjKKbTSNmMUm82gCycfdb/k89zzWlN2lI+8MA+UX8R0Snf2yo+gfsiGD1/RgFKyfbaGZe0o8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TT2JhROWLw0+kt8mFawW7Nr55GR1Y6Z4cMem9Prtksw=;
 b=TzJsUWbStkElkqeRtKw7UKz6FyS/aLt7KtymB/09bEw/VMOf0FAmARpDcXeeYsrmDiTJyh5hZQl5h/p9mDHrAv0SjJiFr4mOsbsBS0v01nKQC/yCCaEOkijWsJEeEVzBg93S01r3k7jQPcEz0YSpw0gGVzoqgK30qASiS8gb4x8qswSrQYiPQqJOp8Wv2jVrK/LLF0kPm8ZkftIIqW8TsG9FDOcIVnHHHLt99aIR01Eur5IpdzXt95YVp40HFCSKy27DayO7a3VOXz09FwJL4VsV1lamMKfVeNEBRA6s1SjRSS/Jq8BzZzKbbxnqLNzoVVaSB91bd8M9dGmWW8A9hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TT2JhROWLw0+kt8mFawW7Nr55GR1Y6Z4cMem9Prtksw=;
 b=rejNNCIsbrsmhnAUbGeu5JZT9nIwVrYXsUcvnhkV9Ja+E4CWg1uj8L50q60PYGho81sapzJxFB8DIMTC5EnCZTbyaS5tHz1ns2dRg76wIm0yUA/aFhohi8rB9US9X53NyCbEL45p99hgtwJk3Uy01fGUnYKrs7pl+iCDJbfwA2lNT4vlkbmFEMWzZz/jbF1Os8uDsIDsFANwLhHnMGGHJY+UcS5oCkMjJrD9/P04H1C2v5CL2OsCCE7vyp+pRG1ua2s7iGOARBhCwjeNbxu8nGtTwP9ZUWWrd70XzsArUVwujAn7MUMAM78xu5QA4Xbgixw+0ZreHHHS4stryI/+HA==
Received: from DS7PR07CA0004.namprd07.prod.outlook.com (2603:10b6:5:3af::13)
 by LV2PR12MB5920.namprd12.prod.outlook.com (2603:10b6:408:172::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Sun, 8 May
 2022 09:10:11 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::59) by DS7PR07CA0004.outlook.office365.com
 (2603:10b6:5:3af::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20 via Frontend
 Transport; Sun, 8 May 2022 09:10:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 09:10:10 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 8 May
 2022 09:10:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 8 May 2022
 02:10:09 -0700
Received: from nps-server-31.mtl.labs.mlnx (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sun, 8 May 2022 02:10:06 -0700
From:   Lior Nahmanson <liorna@nvidia.com>
To:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Subject: [PATCH net-next v1 03/03] net/macsec: Move some code for sharing with various drivers that implements offload
Date:   Sun, 8 May 2022 12:09:54 +0300
Message-ID: <20220508090954.10864-4-liorna@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220508090954.10864-1-liorna@nvidia.com>
References: <20220508090954.10864-1-liorna@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4e6fa3f-fffd-423f-3a5e-08da30d28df6
X-MS-TrafficTypeDiagnostic: LV2PR12MB5920:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB5920E45AE2729CCE0EF4A1CBBFC79@LV2PR12MB5920.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFbLyE0Q3D23nuWf9MTLhyiGLILO0F3pXhD+Nl8i0h2JcPkDLF00rmLnxXx+fliX6Fe7D73Ovgk0HFay/1/+64ZB7xaIM/rvO0EghT9h12kmh8sLgHHsgL8tawIrJRB1CWDvvRHOhccRtE71z9yI5jqfbqytKQ40c/uxkU8V8LlixJYZgdhgSpYLqy6fUgcsX/ZzVEqXIxCHtbihjK4ng1wQyYi97D87rWOY0NL/xoFAQoTVaba8BNCF1rqhcYn9MZI06DqJWOsTVn4pWqh8D8eO7kzf6X5CP18200XEyBzQPtoV6MO4gmJ1kIOqYO2s6X0CCBBcGtt+e3SU8zvpwws67mbBKlIilhJBT6ie9y12Q4apIAauycmiARdVLvjh64LNArth2z5478O20yTvpvKCznTFYhK+kVYVZTZmp+haR25DzUF5+y/7KjCZvkq0hFhXf8K9b3lr9ilnTaMHSR7uiyspyTPjBmHjo5Nb6/PQ2e3Lz3iroLFaClZo/ImFDdNhz2irt2anBbKA5xaxWk7pOWu7SUEk5TUyZKOlMXaSHrgTZXwj/VVcOpLzt2qXUQsrUjITfp84q4aWtZCqEHfyTFiyCj8VHlFumBmdg8VyyKqsjt5aOkRoR1UqMkDDdT2opV9rZWesfuW9P/2H+j3Koo72zWrcusN9f77DHyaqtEpl5lOZ3/18/oAc4K7zPJkHKoerpcO4lTwPXoNjIg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(107886003)(83380400001)(336012)(47076005)(426003)(82310400005)(36860700001)(40460700003)(2616005)(186003)(508600001)(36756003)(1076003)(26005)(2906002)(5660300002)(316002)(54906003)(110136005)(70586007)(8676002)(70206006)(81166007)(8936002)(6666004)(356005)(86362001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 09:10:10.8086
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e6fa3f-fffd-423f-3a5e-08da30d28df6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5920
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/macsec.c | 32 ++++++--------------------------
 include/net/macsec.h | 20 ++++++++++++++++++++
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index ee83d6a6e818..b214abc0fb94 100644
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
@@ -242,14 +230,6 @@ static struct macsec_cb *macsec_skb_cb(struct sk_buff *skb)
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
@@ -314,7 +294,7 @@ static void macsec_fill_sectag(struct macsec_eth_header *h,
 	/* with GCM, C/E clear for !encrypt, both set for encrypt */
 	if (tx_sc->encrypt)
 		h->tci_an |= MACSEC_TCI_CONFID;
-	else if (secy->icv_len != DEFAULT_ICV_LEN)
+	else if (secy->icv_len != MACSEC_DEFAULT_ICV_LEN)
 		h->tci_an |= MACSEC_TCI_C;
 
 	h->tci_an |= tx_sc->encoding_sa;
@@ -632,7 +612,7 @@ static struct sk_buff *macsec_encrypt(struct sk_buff *skb,
 
 	unprotected_len = skb->len;
 	eth = eth_hdr(skb);
-	sci_present = send_sci(secy);
+	sci_present = macsec_send_sci(secy);
 	hh = skb_push(skb, macsec_extra_len(sci_present));
 	memmove(hh, eth, 2 * ETH_ALEN);
 
@@ -1266,7 +1246,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	/* 10.6.1 if the SC is not found */
 	cbit = !!(hdr->tci_an & MACSEC_TCI_C);
 	if (!cbit)
-		macsec_finalize_skb(skb, DEFAULT_ICV_LEN,
+		macsec_finalize_skb(skb, MACSEC_DEFAULT_ICV_LEN,
 				    macsec_extra_len(macsec_skb_cb(skb)->has_sci));
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
@@ -4001,7 +3981,7 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	rx_handler_func_t *rx_handler;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	struct net_device *real_dev;
 	int err, mtu;
 	sci_t sci;
@@ -4125,7 +4105,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 				struct netlink_ext_ack *extack)
 {
 	u64 csid = MACSEC_DEFAULT_CIPHER_ID;
-	u8 icv_len = DEFAULT_ICV_LEN;
+	u8 icv_len = MACSEC_DEFAULT_ICV_LEN;
 	int flag;
 	bool es, scb, sci;
 
@@ -4137,7 +4117,7 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 
 	if (data[IFLA_MACSEC_ICV_LEN]) {
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-		if (icv_len != DEFAULT_ICV_LEN) {
+		if (icv_len != MACSEC_DEFAULT_ICV_LEN) {
 			char dummy_key[DEFAULT_SAK_LEN] = { 0 };
 			struct crypto_aead *dummy_tfm;
 
diff --git a/include/net/macsec.h b/include/net/macsec.h
index fcbca963c04d..c5a18e7b386a 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -17,6 +17,19 @@
 #define MACSEC_SALT_LEN 12
 #define MACSEC_NUM_AN 4 /* 2 bits for the association number */
 
+#define MACSEC_SCI_LEN 8
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
 
@@ -295,5 +308,12 @@ struct macsec_ops {
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

