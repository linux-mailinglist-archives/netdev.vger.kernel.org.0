Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C185BAE31
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiIPNc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiIPNcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:32:24 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10043.outbound.protection.outlook.com [40.107.1.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3A6A0632;
        Fri, 16 Sep 2022 06:32:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxTPw98eyVht1bWRfEitQO2Ajjq7WNGVY0ZHOvVVci72oUaVeTXZhK8QKnU7sE/izz1+SpQ0etP5h8idfVBt9efRvJGk472wImfYOSFlYmXK8/dctR/ujSbcnohjoAqJQ9d9JVB/g8iDL8UUz5/S1cC12Prvu89N0/stB5KpHGN2CqDO4w1jAZS36fpxxiR7fHaUFGewPRvgu8gyvHg/ofjAGM3mE+mRkGnTw3L95LaJGEPbliqUKQQfS8RtOPmPIzqzZSR9uQXX2xNojomb8J8rrKAob0f9+Eg//3wFb4GihmNhJCCDviFRqQNzAO4dP90ac9/pSYwHvX2fCn4Yyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrhvioCdapNoscs1YS5O/2kYeW2aAduL1nnZcg5JlJI=;
 b=X3aXKyVT1/aPF0EtVTIvh/DLOniUzfMNhvRdvsU3IMr54+y9u/s/GF6qRGN1gF9W5OAC3O5ln9zvbo1boMHaBdpvQ36pTLrXyyx+RxNqhi50bhdAeLHgZuLHd/Q0bTQ++NKyxe1Uwvhk2OfeGeoxRr47yWvOiate/nSJdcSVgZZGB8ZWsN4Wuq05A49ptczvxcgZrPv73JrGwsm2GS0kgBYkp44FJGtXNOPFe2y12eLYAU0z9fM8TBSd3mHQP+XnFnjxQRYlBsM/H+lq0dwzaGcog3Rs88y05zosvOyUOgihb42VPJLCtbrMCqM0VWirooCObsREYy4xNX5VyZpcCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrhvioCdapNoscs1YS5O/2kYeW2aAduL1nnZcg5JlJI=;
 b=nncI6Fm5ZkBCVlmvO+aRfOu4dqSoXBYUrYZhbxPZwVn2jFcFAW3SDLJn86v1v2L0j/yGjj4IPuk6LqOGWA0POXuTmsKh5Gn3OeqtJj0Px1kLOwrCxT8i/S/OPybTogL5otrCwPwrF2uOmDBaYw/uP/GDYZpZ6g7HuLk75VccWwI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7332.eurprd04.prod.outlook.com (2603:10a6:20b:1db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Fri, 16 Sep
 2022 13:32:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 13:32:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 1/2] net: enetc: move enetc_set_psfp() out of the common enetc_set_features()
Date:   Fri, 16 Sep 2022 16:32:08 +0300
Message-Id: <20220916133209.3351399-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0050.eurprd07.prod.outlook.com
 (2603:10a6:203:2::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3be857-6777-4549-242b-08da97e7e151
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wify5z1R0XZpH5NGFU5ers2+qrkn17sASKmQWRXmRm+BVEzhSdtpuZulvnXaoC8tWb9naiBSdM9Fn4AVWCkWqaTVqCAcMzoyl19RIyVN5Gj4dqJOZ+pqXZfTSdjwgYua9cSqNafUD308YZfoF+26hjxG6JiLB8LdhnFU5Q0revsfgFcyucujHYcw8qtHDFd6VVHK+rISbW/qDd4mKxKe52bDNGDfQUSYa4xSrmPUbN5KX6hsNpwSphuYG4wAO9VYyXCzbKnP5IZ8ByTWeut9BT9p/4Fhg5RXoMz67e3il6m2En5t6Q/gpOooOkr7tGQlq6bmfmXW4t32xu/nBtIh7zY5/yG2WEyRfF1MzZ5zr9aDuRCKOJU5IYcGdwAThj9WFIZJbC4DrCaJQoDAgEKLRowrVOhlJ3C8LgKM3hydq8E8AB0R6aY1QpEQ7OhmQeoYUuOooug6vEEvjfuxMcW95RtNaY/wuBxjcTMsPumi6W3Y5cZtR6Fhlqy9NhPgLQGjp2VzsQL5rPHR2+lhBm6UA3XDaViylpIc6MQ0GiKu7lrMCZWyKfbFHDHbwoIYH/HnL6f27KCyoNvD+NXpjEj+KLNeDbzXG00X9qESEZa5fxDpQf5ua6bhlcId8A11mJ5MvW5/mcyV4gdxTQsD+JdDLPNP+s6fM560zWB0YSOsNaWIj8PC68On3Wt66cM6avapXTQATCsEIFFwWt1jyDH4TwV0AiEfvA5Alpw1KmuTkl/eGIFTuSZd5o+JNcVUAhApLnCtgXPVgCLdr9/TdZzWSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(36756003)(41300700001)(83380400001)(86362001)(316002)(38350700002)(54906003)(6486002)(6916009)(2906002)(38100700002)(8676002)(4326008)(66476007)(66556008)(44832011)(5660300002)(478600001)(6512007)(26005)(66946007)(6506007)(8936002)(2616005)(6666004)(186003)(1076003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PPnePrAoNTYrSQhokiA4L88qXCgd0h0rN8zPPpv+C2P49kx8jDrhBH9me5t0?=
 =?us-ascii?Q?JSSy9H8kLruX+f/i5G9967S9VIxYBqOuRE2g+mcStK5Vv5oAyu56qzfvWYOT?=
 =?us-ascii?Q?DsBmm+3vtpzPNjvmx5Gmj6bWoNkRUJbMHJa3fcshHlMMgUn5E+anMvpf4cjw?=
 =?us-ascii?Q?kIKw2EMG/w5nTaKWweZyEgFSj5ZmpvYaG/+6Dd5Kilpv6ERZWbtSJc9srvWS?=
 =?us-ascii?Q?hEtFr/mHXnQQHeEZfAEQHVzETbPQLMqCjQu+dIrXyLkcAJNju4MC4PXZWgjl?=
 =?us-ascii?Q?qUBFNIVC5Hk6qq+95gDcgRW8iVeogvwKA6btl0Lr0hjadActmMy8uaEidWtf?=
 =?us-ascii?Q?cDDDuMbBIf553r2nAeRjEIqZI5VtnJsdAINnBOaspVh+4QNQ55lrpC0Sug0/?=
 =?us-ascii?Q?B8CzKuZOBqw7z6gch0PYc0796uw4bas50cDcg9iDS5vmq0o1O0k4zongXS9s?=
 =?us-ascii?Q?bDKoVwo126n935qehu9u8MTCW+luTQ4ZeGMALcArmaA6R4gNQFJBThfUrFRt?=
 =?us-ascii?Q?wMdOJupV56a4kexbbnIM6ysKyH+MiNseVY04InSZqlOLmR9mEX1kME9UO2l9?=
 =?us-ascii?Q?1KWq74B3eoakG6rQhRTxftG8MxYAa5+S2xeVPdE+5potsa2CGZNmg+Narb5p?=
 =?us-ascii?Q?xx6Ti1tEykYsKu+OXOwFfq9xNPISbPzL3IryRvDjgujbrNSm3rl384Zcg4cS?=
 =?us-ascii?Q?MsUkschQtbmEkdpI13WHDWvk+GV//iEf+qN0gkLHAHKFqO7IZZ7BAnggJs9e?=
 =?us-ascii?Q?NApt4OC/UKXTxJ3afVvqRHcKbH2W8KIIjtdjis9C/Nl3r/eVq5y2dQVZ5oBD?=
 =?us-ascii?Q?DDeaA1Yyrdd25lJWWbZ1SwZX7GZ0yqsmJVYRkmSOO57BTdJCYxy2f5K0kUKr?=
 =?us-ascii?Q?QEbHVX/8NO3ItrNxI41nr5fTgkH/0e6BweiJ+78HM3uuYitG+mlnDLKqoxgV?=
 =?us-ascii?Q?pN1Mcc3pI0UFxW4AUIq1df8EXReHMWk7ZH59eQS6YAMt9fCb8nDenNpAtM/9?=
 =?us-ascii?Q?O2pTuBzN8Yt7yl9s39SIGX41N3FP7ERevS94yMhXju5Ypz+7nj13FtdckIEa?=
 =?us-ascii?Q?x2yMn5t4BcI4+ihOYI0IDAvF5lX0PepDwnqVg6iBpEYyyEs5nyNHwUgEA3T1?=
 =?us-ascii?Q?nbWPO5P+ItOvy+yShO8GeTemJJTKc5BGwyJlxoN5iLNl5Q6q19nXzZMifG+Z?=
 =?us-ascii?Q?azzie/ryyalMmxKD/bgCYwfrR3gL2aqQ1T/8Dt2mQtNVY2KcPMR9gDm96XNa?=
 =?us-ascii?Q?kTx5Gw2MaE8kZuzGr6sxgdhs9UC21K89TgkiK8GCbVLLXswEwMn8fYtCJyit?=
 =?us-ascii?Q?G+pdmtv0Ie7xNVxv5e1dkA1eaqzbAsOuIU0qw4yPiZhPinYCo79I9PhzoTTZ?=
 =?us-ascii?Q?jO4HxKyAsuqsA4LNmHWQq/Et4iHSPjlcM7doAShjtCb5xONi0H7gEBcjxmwF?=
 =?us-ascii?Q?NKXGjpOVQI+FQRc43D6R9KUMmQPxOzCY5CK7FU3HXBwDIAN6thCIxcG+tLA1?=
 =?us-ascii?Q?q5MGiY3x//ISLeXyR5vlWPE0sfM+rzoBUqIKkJb3VHJ/ltuM8tan/Zvt1isj?=
 =?us-ascii?Q?UmJ/PY54rXSbKr5ykjFn+XVP4AGKqpXGeCjQVdZCxUGr5iLCCe+pF4ZeSyDv?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3be857-6777-4549-242b-08da97e7e151
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 13:32:20.3683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgZoqNXsI22xajDVjJAHvfFhwEMa51zJoQk0zEmhRx3q6LDmN+gapUafzaGMZkvJ4RWD7o8N1KM2WMhN1FUBbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VF netdev driver shouldn't respond to changes in the NETIF_F_HW_TC
flag; only PFs should. Moreover, TSN-specific code should go to
enetc_qos.c, which should not be included in the VF driver.

Fixes: 79e499829f3f ("net: enetc: add hw tc hw offload features for PSPF capability")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new.
Apparently this is also needed before enetc_qos.o could be built out of
enetc-vf.ko.

 drivers/net/ethernet/freescale/enetc/enetc.c  | 32 +------------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  9 ++++--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 11 ++++++-
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 23 +++++++++++++
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  4 ++-
 5 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4470a4a3e4c3..3df099f6cbe0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2600,29 +2600,6 @@ static int enetc_set_rss(struct net_device *ndev, int en)
 	return 0;
 }
 
-static int enetc_set_psfp(struct net_device *ndev, int en)
-{
-	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	int err;
-
-	if (en) {
-		err = enetc_psfp_enable(priv);
-		if (err)
-			return err;
-
-		priv->active_offloads |= ENETC_F_QCI;
-		return 0;
-	}
-
-	err = enetc_psfp_disable(priv);
-	if (err)
-		return err;
-
-	priv->active_offloads &= ~ENETC_F_QCI;
-
-	return 0;
-}
-
 static void enetc_enable_rxvlan(struct net_device *ndev, bool en)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -2641,11 +2618,9 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 		enetc_bdr_enable_txvlan(&priv->si->hw, i, en);
 }
 
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features)
+void enetc_set_features(struct net_device *ndev, netdev_features_t features)
 {
 	netdev_features_t changed = ndev->features ^ features;
-	int err = 0;
 
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
@@ -2657,11 +2632,6 @@ int enetc_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_HW_VLAN_CTAG_TX)
 		enetc_enable_txvlan(ndev,
 				    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
-
-	if (changed & NETIF_F_HW_TC)
-		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
-
-	return err;
 }
 
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 29922c20531f..caa12509d06b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -393,8 +393,7 @@ void enetc_start(struct net_device *ndev);
 void enetc_stop(struct net_device *ndev);
 netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
-int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features);
+void enetc_set_features(struct net_device *ndev, netdev_features_t features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		   void *type_data);
@@ -465,6 +464,7 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data);
 int enetc_psfp_init(struct enetc_ndev_priv *priv);
 int enetc_psfp_clean(struct enetc_ndev_priv *priv);
+int enetc_set_psfp(struct net_device *ndev, bool en);
 
 static inline void enetc_get_max_cap(struct enetc_ndev_priv *priv)
 {
@@ -540,4 +540,9 @@ static inline int enetc_psfp_disable(struct enetc_ndev_priv *priv)
 {
 	return 0;
 }
+
+static inline int enetc_set_psfp(struct net_device *ndev, bool en)
+{
+	return 0;
+}
 #endif
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c4a0e836d4f0..201b5f3f634e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -709,6 +709,13 @@ static int enetc_pf_set_features(struct net_device *ndev,
 {
 	netdev_features_t changed = ndev->features ^ features;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err;
+
+	if (changed & NETIF_F_HW_TC) {
+		err = enetc_set_psfp(ndev, !!(features & NETIF_F_HW_TC));
+		if (err)
+			return err;
+	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
@@ -722,7 +729,9 @@ static int enetc_pf_set_features(struct net_device *ndev,
 	if (changed & NETIF_F_LOOPBACK)
 		enetc_set_loopback(ndev, !!(features & NETIF_F_LOOPBACK));
 
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
 }
 
 static const struct net_device_ops enetc_ndev_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 582a663ed0ba..f8a2f02ce22d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1517,6 +1517,29 @@ int enetc_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
+int enetc_set_psfp(struct net_device *ndev, bool en)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	int err;
+
+	if (en) {
+		err = enetc_psfp_enable(priv);
+		if (err)
+			return err;
+
+		priv->active_offloads |= ENETC_F_QCI;
+		return 0;
+	}
+
+	err = enetc_psfp_disable(priv);
+	if (err)
+		return err;
+
+	priv->active_offloads &= ~ENETC_F_QCI;
+
+	return 0;
+}
+
 int enetc_psfp_init(struct enetc_ndev_priv *priv)
 {
 	if (epsfp.psfp_sfi_bitmap)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 17924305afa2..4048101c42be 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -88,7 +88,9 @@ static int enetc_vf_set_mac_addr(struct net_device *ndev, void *addr)
 static int enetc_vf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
-	return enetc_set_features(ndev, features);
+	enetc_set_features(ndev, features);
+
+	return 0;
 }
 
 /* Probing/ Init */
-- 
2.34.1

