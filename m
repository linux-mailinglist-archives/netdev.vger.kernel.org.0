Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D5E55F148
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiF1WRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiF1WPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:41 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193273A1A7;
        Tue, 28 Jun 2022 15:15:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frb07D53+EBGRfY0GSDBcuib2FZm9OnAPOmZe8iu+yK4tnYd0SWI2Hj7/HL14T7IS8/eN5DXtSeolTGbxfBOLgow9PkRTdPQTvNj3iGABtM7XzE7yRMylvOkFKRCUL0DrSi84cloCNl3MRq/aCUjbRsVauozloSFF2xnjMcGfwzGT5slyLYcxhW2zCWh2WEuSjSau+PyVUSwohl66rkO/xZdQzD9gJuzEYnbUgx2Ju8VFLoE0G4JmgTfBSVp42pSkGJp+HUOzkOK8VkaoT1w7aleCpJf4AHCxNsiJpZKJZ8oaEFyuYXZ7JrqQxC3Ljkd/+KlXWXbTq0AhrMTgdnvPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCoTL6T2wxI5vKbrkQY83fq1NJAYMLDQw8Kz5R3A8s8=;
 b=UqxMpy9KKq3+j78FpxRseRnhlcpvfT8v0cavdmFLYluXpEObaxEKKrFAwDwnDLswi6XB3qNVM4prqpuchnw2q3Hu20hOZn6nYBCK8UV5b1Rb4uywTeAEDW7vGfNOe7IOnELUnaJwhmRi2YN5ljRD6IefG04QoYMB0HSrFqKbqRcqNiIEBsd7yVXRTF2/rwIvMEhT+c1F6Bp8HIh1B4Z46R78+/zVgv5Q12BNq2zUsLX3Cm3xpsH+wTon9ooArVJPG7z6uWJeHSwpNfzg48UW498pfdOInsceQn6FfQK5SuuIvDAYGaGEzeHBjlJ+yUDi1AGhdtpXQ8Ll2qVeA49yRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCoTL6T2wxI5vKbrkQY83fq1NJAYMLDQw8Kz5R3A8s8=;
 b=LxFfS0mRJ39In2EpNfu1gbI/RqWzG82/koAaE3Y/ZVmotEsbzDUyMrzDUNJWVWRV6EFu6q/E6IfFcmeEsQOwFJiTFr3Ydz0eKB5mCOQzyULXwOc1kfoZqfPTwwnBnVXoJJXfGI5tfcGe9+GeNcBFc2c2YK2FMu4TC9p7Qlh7Gz0AqM2wBbQ6v9z9rExT/hh62ZMOBL7wOXtwW4GS++uHe284PmCaoiWCFkjNqmGD2+UQ0VRtb12Lqapjp9KAml2OxCz7KnACte+YS+GzvVSZ790CL23ZL73FjGaVyITdFDg9B7iFiOvcqxa3ftKm3ngkAqEgzKiTjLpjTHPYVSOPPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:56 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:56 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 24/35] net: fman: Change return type of disable to void
Date:   Tue, 28 Jun 2022 18:13:53 -0400
Message-Id: <20220628221404.1444200-25-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 355e24e5-1229-4d0f-ea89-08da5953a231
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3r+xKahC6YhyM30guEmpCHf/tiIlKhZGZ77PSfOwkU4oL29Laj/kE2pHyR4MhtRn8sEs/MlgQaemFCQy+zyafLGGzdrw1tHRDldub+Xa1R3RRPSP0sEDyjTJaZpTcivtYVDF4WtFUm8gO/nPt1zk6jqyj12II308HXJl0Pzz2yEeaSM1LKoSEGfTpK0gmy6OLQy0Jae1JNdHwadNUrePJmKrLFmmWbNCSKYhCINKUOZLorq5mOKH5vfoqw/rFdjli6wphIa+/lCOYIDY1u+GQHIPXPj02VeH1tKd5D6onY/KjKX+sBE/3m0sXq/dElOWy6q1sm4b0L17E9zOAPGbFK1iFvoC65aGovBtLTn/u2eVx9LVpSisraqfl4lZuSb5ITE7Xx5HadZ7G62BvqXliVnYq9Vr204IceY/323kaacgEPhMTKYtUVgMtMkZh19oGDCPr0tWwCUDCj7VIUBL3C6HQ21b5WX2svhiwqrMbqzqEoOou3yA7oxf9Uq8jbMREwKDcLEGM+xjX4OCbRVv+cwMnmhLYrDLCTB4/VK3kwVoZhCbcx3zc2EHKpP1IOtHUV/Jz3fxVKl5Ns2HNORnm+eqlCC19WlRN8rXJzAYD2AxWU5wwIXc1bjsbvwoDZTQrU5C/dIUaK1tNrYsAmprGpX4c0bycdEBONEFyDYbl7tjgoAe2YwyLVmr/82u7mr/MUt+Tue38jZXca35ES2wo2PmP3X0Zgsr8BZ1WdjF6IkmDBxRGyzhDU/DlEkVocKcfGzqn/geMTeAD3p6tvDQFjV20JkPY1SKD+BsK7Op3K0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i/yOAdbZxnXRkUf4SNq4x1bXoJHNu0THAp4WNRfPrdF9XSjfkWSAlLcxa0Ky?=
 =?us-ascii?Q?6lInIjqw1Wsjs6Zm9z9UsmSH0w7PCdt4QD3GJU1FsTBGh3d7cfZsrVrabFKy?=
 =?us-ascii?Q?+phi8AXGYfYWxwWaxLYrg0pgRatieUqaI/a2fIXxHOwTGbjkpS3RdEzMfAp3?=
 =?us-ascii?Q?fCcCdWaDdYz1UMHcDbKmDsUcYf5/wqbNdhcM4F0pV+5S8yz2D3Bic1Enlz37?=
 =?us-ascii?Q?2ySBHcvNnGSVwe/WeDyCAQMJZiYCyyU65o+SxDRBKF5SoXpHESQAnCjRc2Qo?=
 =?us-ascii?Q?xsNiOuw9gxhSRng5j6azATDAUJjCY7VcjbxSsI0ZokJzxTz5N4Fwy8AbIIS6?=
 =?us-ascii?Q?SqIqSEQlFQBhNRn/v1hJLaem9FhTN03JivsX8ugvP0IikVg7TRlcvSDfXDtK?=
 =?us-ascii?Q?aew+jXhXzRudoj9MGpyuceCXJ8WAJk79NAQYykssxElyjHSIXHVd4mCFtpAL?=
 =?us-ascii?Q?ITIqLa/iZ8erOmGbVtNAhkY/vjrp+z/DA5B5SfItQTCik4etyqqc/itDX8yO?=
 =?us-ascii?Q?YRpgKtKEh++BhI73mOdjCWKmmP+xbUj6j3ArybcoZ0ce2t5fb6xfB66pRuxB?=
 =?us-ascii?Q?ai+LTM0JcDF5WGgTAhaxEZWCMatNHdw66mZa1rLr6yyAa9Kq8fi4negoTlNL?=
 =?us-ascii?Q?MPHU/dMStoFLbe2cT87A7mK390e77fdlGBkgpmqOY8ojSRfmezoLKjEc1dcP?=
 =?us-ascii?Q?56o2RWonOJZwzU8wXAZoFDEN1VbTaV6w+eNboX92F04HZ3sraziIxxNFbf0D?=
 =?us-ascii?Q?FMvQbDGZxj6qksk8nYXJ3fPnv2c3Rj0AzY3d4ILymh9OrVjjyOeZ9vpW8VjA?=
 =?us-ascii?Q?3rG2UEd5DVrF1AZL+3TJN+7Wx+jvPeP4WctqPxav/Von86Zi7OeTDLQ0EGgI?=
 =?us-ascii?Q?I6DDnXZ9K7Sbt1oXDuGGaK4Ou5qR1qkDvrsEMbCiTQ9gyq9lANtfgG0L/o9r?=
 =?us-ascii?Q?Ien7KAb0TR7AZX4WTEPs2ttLN5+12w4lINM9UedmS1DOrFU5Uo/OBnLZ+J16?=
 =?us-ascii?Q?cw51A9WI01/pxa8mdBv61C1HC0Kt+KvAQqKeLgQiIxPFfJvtVP2EtmR3FCzB?=
 =?us-ascii?Q?/dOBnYRMszwsD70uxDlGkfw0HA5bQ7Qx2PD0/HRbkHSlTJ85hg0FgD8VDIjA?=
 =?us-ascii?Q?w6OCkLx3mAL3GyFzf+99ieByzn+jOHqeG0iAn/xCKDbodEd5n2vjt2jjHlBS?=
 =?us-ascii?Q?Il1x1eNH4bSe2LEfwKjTPJggKXxxfLiTcTpU8FT4+QjiKEYvx4gL1WgAzmhM?=
 =?us-ascii?Q?u0PWNr7g1LwpikGJjuTLNnc/mQf3LLrRw40co1X/mRTT3ogL3jcQw+aeGvUn?=
 =?us-ascii?Q?zZMXBsWjVHuzE9Typ3YJRw8po3oV3txswbjO0QNiWQTbAdh1y/jvMfCPs7bI?=
 =?us-ascii?Q?wltVbN0IWo8NAmW7IYaUg22JaXRyMuzkOz4UbOe5MP0qphhosbrxytBf6qj1?=
 =?us-ascii?Q?+RuCi1V5Yz7/OqUb2jdWS9tdAX13ljX0v/n7+3wpLQ4b+eW18hCNs7rmPXLB?=
 =?us-ascii?Q?sawRic7p+JMVP3/KGSn2Ig78gUio7gzzZqLHmhTxQAZRaWP/qoMxT21zn/li?=
 =?us-ascii?Q?b6RoczHnUg9/OjEvFQTznaROmGVudA0HRYdz0CId0VL4lUMenrN5NVmrFsXb?=
 =?us-ascii?Q?Zw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 355e24e5-1229-4d0f-ea89-08da5953a231
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:56.5621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BKGATnhskW70ZBKX8D8S7FT5h8On7jJNe98WfE81qA2pzqpb1NrvX4rowqsQZ8PnhLTQnO4KGapSniWWEx45A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling, there is nothing we can do about errors. In fact, the
only error which can occur is misuse of the API. Just warn in the mac
driver instead.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
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

