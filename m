Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0C7580162
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiGYPOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbiGYPNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:13:50 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130075.outbound.protection.outlook.com [40.107.13.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54501CB18;
        Mon, 25 Jul 2022 08:12:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHfS33qVY1IGKdpgK6MR/2zh/sBAm9RxvxRR+vlc+qxwt5A36UpHroX1Rzn/dDJkpQsEoo7FgeNqjb2G5gAeRhLUf32/ThwDV1cTeGAzq9XniLW6SD9wVUinC2fpDt2uWYsIRX5R8W9bZmj8LcIBijfzuDfLUPFWPgy9SY3HdKNbuNpffSibig5ZHHaT0plG/IPqZiK6FLt5DNR7krHjJdNp6JK58oo0VJJ3K2YA89njonLDxCtkLUDg1hVVgyWg4WSdn+zZQKKoqfi0j33iZYG3ibNCW4tkQNws5NHVgZGy+4apwmWfHYPxTVCcLoGo6phrSzqw3lsIju0/C+gaCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TW+mOa9KQRFDSI0Zt1Tw4dlfvjcTJC4gg2BjqexxeaM=;
 b=KJLzpE1EjzKd7O2d4nUeWqjNdefM/1ql/U1BY2PJJRnjw8QfCT4ohZ9ab207LyWpcnPtho4iq9tj8NglV8azhP8WMpstjjIN/Ix1zktXqF5zcn0dI+MZGIGbEMR8sLQYv5Z1TZFLeLYnucYd4pBBS5I2E3qgNPFxgBAzE3oPKil4gFiEqcABT19v3w8l0gWwMvjDZwlqmkFrOhnr4KROM5Z/PA7cTH2zqHZPysD4+GA7SykaRtFUVv6sGG/jii0Vh0YyU0XtOhCFu3tMFflIIxMtcZBzBu03+aRWNEgi6CMNhs0mJB7PEZgVVJltCJkydFJDJa+W/gucl5N11RW//w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TW+mOa9KQRFDSI0Zt1Tw4dlfvjcTJC4gg2BjqexxeaM=;
 b=fbdiUgTtNiCoFMp3J+8rq80iD2n9OEoGGIFaYwYIAMM1bOanlcIi9SYtkVV4mlMSlckAsS3WERe2i+bTvxoS0tNBLSIiTnkDiArHdR7pBdB6RlzGbj4SmwnhiiYv14m+N6/JcnBNJFdhPrWpkzxFtrSl6t5Oqnoh5aK16V4TY5YG/J3f0muBctMVxeJkuuqIwTy3ThjyP5UZ+cvIccSgJMEhJv54yh+82lNdjK4knIXU9QsD4JaTWhs5kTQ4RD29kakIJ6VGe/8v9tnZCw06awsiG7FbCgBUTh/EltxFf6z+WGs3I3S3+1kmlrIZ80CndMyVNkRvrN8IpA3vMfyITg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:36 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:36 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 21/25] net: fman: Change return type of disable to void
Date:   Mon, 25 Jul 2022 11:10:35 -0400
Message-Id: <20220725151039.2581576-22-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4412de39-12fe-417c-acf3-08da6e4ff7da
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1DOrHlrQorLLuk2gPClhAFt7H+yv3uqE+5lBd9nfwYHZilCmoeehaAA1DFHqTiUKpfyuaz3bdJ5KiCZAl8BPMCDajnMNzKu5iSIrUdmVehBpZuXzd8w4hz9JuCdOmXFyncwgWs5f5TwHied8H3HudMBVurGuTN9vbL+6p13dcMGHyUKFeL8rct+ftgjpYchOwhqmc7VxRh6BdDBlMWen10L1Md2alVdsLp+AprtKVxwOHvJnkBU25RgE5dmvZV4oXYGkCAyDepL3b78cWE/JQO7VEl8Un2aERbPYAplrhmZVvugELoYuk1PrppXGudHOxj52BJ1U1qMxkjOg4yJ+vBjIpUPMQuUy1KBhL5XKro8QDgM9JTCU2dMl6WXfVCss5Hy7JrjIl3pOnzDKQJ5e6DUIwlwxbFwQWeveApNgkg3lLKGhqXRcw89N7Kqf+7a+APX2Dy3rLml0jmy2lI7cyFe+wr4KE6EirWGuDhs7bXhvXTGksYbnHsZQUD1bFgJjx2SQeMAYmY5bIuKDjeYFyK6WNX3lREB5I8TqaYUEOKvQkc69u4op5QYUY8kDT3FbmpFy/rLna8GZK3NdPOx5dlD6Ks2m4nTSS/gYFv5ZNYkP0nHYutbrjMKdkVJdUJYv9x0WInZt031rkevmLA01UCNQBzYItiKhSJ4dsG71KzSZxly09P+H47uxQMUJK0a65LgfLG2nSA30thZ4LqWcMF4lLk57AFMZZm/6ywqNhNwmXjzayVZtsFJPQEwKOufh0GzKIijHVmbfF2WApb3G+C+QOEBeSBtXMwKBybCUHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c/3l8I6G2af1kHCa2d95LEczKHi76M0gyyrSKadM4EHyfRz5zIFowZaQjA4X?=
 =?us-ascii?Q?3S6oLLFdC39LE2mFj8cJrC1dovTI6miW+691rhBPkLuxESeOGX8/0JkPzuf8?=
 =?us-ascii?Q?++/O+TvPmX613lIujzWXOxKJpyeZPyYemiPZezyLjvLQRSzohkdCtDhb52FU?=
 =?us-ascii?Q?a8qq/t4Uc67ctjJQYvqdIcZV4slKh2ah4k2L2rL4K/tQP8vSXa0HlfwVpijj?=
 =?us-ascii?Q?UdXlq1TXg7kGSK9tnx9uLo3ekVidWozJypBuK4l5mG/owaIqLxzf4faWZ8qS?=
 =?us-ascii?Q?sM52n+y35hfgSnoWOkVz8hJAE9Dd+HdJ0mUKxZIJ9VRpPl9575NMNAJU0vIh?=
 =?us-ascii?Q?H0cbcWnEe/le2ZhK+H9p11G16Kpw2ZU168SlZSK/eXgeLjKGYZh+3KMIrOk3?=
 =?us-ascii?Q?vAZLbqh17ur6ZKD+IsoBen9EEkPv1wFasivbpdxYvlNRiIOWDHIcxpANriI+?=
 =?us-ascii?Q?vd4IieIsR6UaeerP5HQXrrw+UcnfTeOrNficbY84eUYUgVche7OsA8PGp6Qz?=
 =?us-ascii?Q?WBYYrzwaQBgHevjT4j5zFyXyzKi7a4C3upzeE3vAuDb8N0ncGKpdycn8aVno?=
 =?us-ascii?Q?GUU2FVmwoCNec3cF9bbKnL/yVt4of/EKMo3WmYXq/IDDMRvvNAaDgw8LWgUe?=
 =?us-ascii?Q?MCLO0a3LW/oc1thP1R114kd/SbDw2cIjPJUwthkFJvD5uxRdMWaQkpAwRlXt?=
 =?us-ascii?Q?vWNQB+4ZwCS7847/PHqVG27YaQ4gG6USMmrwN3xvtxjebGDIccmFubb+1hTp?=
 =?us-ascii?Q?K/AtmABifwjZTUoSgJ1okOiSoWlN2tsaemr7jO8uj3Ou4+9wSKgUgOSLoFtR?=
 =?us-ascii?Q?Kn8xgkwXP5sJEEZGr4JsHGnHnjnv8R0xLwKU74XMODztc4fjurIYONCCIQWi?=
 =?us-ascii?Q?NvQa9cu2VuaCH1Lpw7m7wsDQHpOeDpuxXfglL0POm8oDxVFoEfCKyhGZg86F?=
 =?us-ascii?Q?PoCXpVDi+TTP8GwJXeg8CTLQVzU99V3fovuw97iE/1PG/v5vBDN2XfUGlOny?=
 =?us-ascii?Q?JS1vHrVtthVOUKZf0ZzBruOdk5NNa+lGK4iCBwOPXZDN5/9t/Yy8dpf1lWGg?=
 =?us-ascii?Q?gM57W2nfa4km8JzVxFWSP84JHIqQixveLyAvZ9RhsBSsL4q9HQCgaAKVvt/5?=
 =?us-ascii?Q?XKWNk+cyALCdrwONnEVFMUxAIHluEV+nC7aQeyAqeTKCtLs3uKQdO0Hi7Eub?=
 =?us-ascii?Q?0lsawD4MQJeCF/dHtq8zcIMjOmqRDOtJksFtYHXL5yUGwzgZ0Ojs27IJDtD8?=
 =?us-ascii?Q?srdk4aBx0u+n58Fx2CMOylBqhScO/USuufLW0vCth/nZFLCCl1RmJp1EsLuf?=
 =?us-ascii?Q?F7TrMmAPOsdWwAV0UGzr+fGNOQg9YhOvSY4I8Jp8B3b7UNQkLqYJUPLdzi/d?=
 =?us-ascii?Q?LWM4IlvbaRJm0E6exv+b132wigPwI0A5jGRt2vj3qH9yhfqGtNviI25JmVW8?=
 =?us-ascii?Q?fqYY3tomR8LkLVSNoHwglVP9lunyoWIj2cm6bdLtJ+IDQ5u8CCU+8pbtnWUR?=
 =?us-ascii?Q?JftJ5isuiEvON4eNQTW4E9Y1T1fatsKqWOawWaSNU7sB/SwE0oA5RrPQ9Cyr?=
 =?us-ascii?Q?/9MLMu5k2YGIg5OLn6+/N47kzSaWGg+ouwMZ/m1nM6ka5oy8Y65ri/sSJj72?=
 =?us-ascii?Q?3Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4412de39-12fe-417c-acf3-08da6e4ff7da
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:36.7371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6/ApFkPfrJvjEU5JEzGUmzlUR4uqLIaDsjUK9XetJNWm8DYmBxRicwTFXWcoNIyphsERQxx2RI+fU9l/c1yoiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling, there is nothing we can do about errors. In fact, the
only error which can occur is misuse of the API. Just warn in the mac
driver instead.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c   | 5 +----
 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 7 ++-----
 drivers/net/ethernet/freescale/fman/fman_memac.c | 8 +++-----
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 7 ++-----
 drivers/net/ethernet/freescale/fman/mac.h        | 2 +-
 5 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index d443d53c4504..0ea29f83d0e4 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -290,10 +290,7 @@ static int dpaa_stop(struct net_device *net_dev)
 
 	if (mac_dev->phy_dev)
 		phy_stop(mac_dev->phy_dev);
-	err = mac_dev->disable(mac_dev->fman_mac);
-	if (err < 0)
-		netif_err(priv, ifdown, net_dev, "mac_dev->disable() = %d\n",
-			  err);
+	mac_dev->disable(mac_dev->fman_mac);
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
 		error = fman_port_disable(mac_dev->port[i]);
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 7acd57424034..f2dd07b714ea 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -871,13 +871,12 @@ static int dtsec_enable(struct fman_mac *dtsec)
 	return 0;
 }
 
-static int dtsec_disable(struct fman_mac *dtsec)
+static void dtsec_disable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
+	WARN_ON_ONCE(!is_init_done(dtsec->dtsec_drv_param));
 
 	/* Graceful stop - Assert the graceful Rx/Tx stop bit */
 	graceful_stop(dtsec);
@@ -885,8 +884,6 @@ static int dtsec_disable(struct fman_mac *dtsec)
 	tmp = ioread32be(&regs->maccfg1);
 	tmp &= ~(MACCFG1_RX_EN | MACCFG1_TX_EN);
 	iowrite32be(tmp, &regs->maccfg1);
-
-	return 0;
 }
 
 static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 19619af99f9c..8ad93a4c0c21 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -701,19 +701,17 @@ static int memac_enable(struct fman_mac *memac)
 	return 0;
 }
 
-static int memac_disable(struct fman_mac *memac)
+static void memac_disable(struct fman_mac *memac)
+
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
+	WARN_ON_ONCE(!is_init_done(memac->memac_drv_param));
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
 	iowrite32be(tmp, &regs->command_config);
-
-	return 0;
 }
 
 static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 010c0e0b57d7..f4cdf0cf7c32 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -408,19 +408,16 @@ static int tgec_enable(struct fman_mac *tgec)
 	return 0;
 }
 
-static int tgec_disable(struct fman_mac *tgec)
+static void tgec_disable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
+	WARN_ON_ONCE(!is_init_done(tgec->cfg));
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
 	iowrite32be(tmp, &regs->command_config);
-
-	return 0;
 }
 
 static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index c5fb4d46210f..a55efcb7998c 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -38,7 +38,7 @@ struct mac_device {
 	bool allmulti;
 
 	int (*enable)(struct fman_mac *mac_dev);
-	int (*disable)(struct fman_mac *mac_dev);
+	void (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
 	int (*change_addr)(struct fman_mac *mac_dev, const enet_addr_t *enet_addr);
-- 
2.35.1.1320.gc452695387.dirty

