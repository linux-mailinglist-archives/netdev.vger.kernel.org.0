Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26034AE997
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbiBIFyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:54:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbiBIFwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:52:12 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60056.outbound.protection.outlook.com [40.107.6.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B626C0DE7DA;
        Tue,  8 Feb 2022 21:52:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbTgMHfFGvSIbYcPEt2neJac69elVRYNXt4yn70GPlG7c5Oy4LJTX5EHXnl+7urEaOfbgEFoFtGJvdlU2upCNI4tEKnorSTPZlVhiU6cNjhYiFSb/BunK9ODVKYTgCRr7b6y7WjzJyCUlC+Upj3TbC/l+ww1XfDnvXObWjwX7zaxZrykIzY7LXPtq10y+wRpd4U+WLvNFhZ4q8C0xm8Rrj2QVklQY+GAkhtCJApuZ6uEsbQWX68lgFQNn/lZ/ahPNwDEqMayh+YJ1aaW8Oy1ElY8XRUn9JchUfZnCVqlpTMmPUQPEE/2F57ucrgMuS+i+xXmq/DNCoEgj+NpEEjSMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88F9u7kzdYGAVeqXRt4Y3yUCU9dzJ8EmNJtpZpJ2uDI=;
 b=A1SirIQ8J6DRtEOUb9n3yJqlaucta+D1d6agN1mdHcpYJNc8jTWwA4RTuS+DceNHgeViOGEKSceQ2kZSa2pSGHXlyTaFjp2LdpZ3uqT/Od2ZK8Hnz6xiPnCYPab421iEpLJPO0dye+Sxeb+ybHTbKIM/OVGFxQZVi6R2Ex4fjqKUT9rCPdgoNBlKT8St7vAe0bQfZPJUVzJ7TaI7rJ1ix/nwmTb4X1vVHOkuSuQXs5CUywK8OQOaZSoVZ8VLknxvVRLPmfKaAxs7y7yt2D6BxaXmr1ZbJ+30CXtpaw3zp9ndVMAksM2v3rhDJjx+tjXpUXV5JEmBu8k1vO3Ru8FxvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88F9u7kzdYGAVeqXRt4Y3yUCU9dzJ8EmNJtpZpJ2uDI=;
 b=lbFmRV7xgqH1aeM/Li3shC+agpFq3hLr3TC0iPLu+jY+jPzD7rU3TC5ITyu5oVU5iqyV1VSNgLCi+mEsBduW/G359kwFyduteJGEvP+ty91OH7KWbkg2BzHvJl2sMLd6q9z5zxZo6x5j3DRMn/r41b8CM+jZx6gNls0P7XhC1vM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PA4PR04MB7823.eurprd04.prod.outlook.com (2603:10a6:102:c1::14)
 by DB7PR04MB5002.eurprd04.prod.outlook.com (2603:10a6:10:19::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 05:50:32 +0000
Received: from PA4PR04MB7823.eurprd04.prod.outlook.com
 ([fe80::653b:a7f3:f5c9:b7a5]) by PA4PR04MB7823.eurprd04.prod.outlook.com
 ([fe80::653b:a7f3:f5c9:b7a5%5]) with mapi id 15.20.4951.018; Wed, 9 Feb 2022
 05:50:32 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tim.gardner@canonical.com, kuba@kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, Po Liu <po.liu@nxp.com>
Subject: [v1,net-next 3/3] net:enetc: enetc qos using the CBDR dma alloc function
Date:   Wed,  9 Feb 2022 13:49:29 +0800
Message-Id: <20220209054929.10266-3-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220209054929.10266-1-po.liu@nxp.com>
References: <20220209054929.10266-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To PA4PR04MB7823.eurprd04.prod.outlook.com (2603:10a6:102:c1::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4fdcca1-942c-40d2-450e-08d9eb9015dd
X-MS-TrafficTypeDiagnostic: DB7PR04MB5002:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5002E59EFD05C6F82C816027922E9@DB7PR04MB5002.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wzCYO7Eo9XiJpl9hZGBDU0gch1J6QowJz/Xd/d0C2Mv/ZVKyeKu/SwaLIBzIkPb3C5U1zBh9JqO1Z6raIsfFjxJZsBVHUB98ATQrw76dxPty/h2Kdp23uM5wP62ElZbgzRfXBiVHnRCPRD3Yz9gaxudpLescQYQJ1RHqgHtE3iPsZt3/hRo7+s79rTlpFf9kY6ixF4pU0ntiDsIqQbCGlgTPgeEPjCqmHFE/LzUi8ciBRuWxyvZcWbHXzB6JzxFqrQBVM9koKr0nh5ixAozU85IDLI+f2H5J/cTYxCqb6KxKBzPH9Rvu/rITo1JVQcZVPNrCMtSZRdJmThx1CWWmJwV9I36wDexM2VfVcu6h+5LfU3NNKD5uAPt0+jLhCd0NRelWp4paNRUkSDW9bno+es2RR3g+wZ+8nfXrPGR1G0bZFViMisPjWOz98uHKpt/5D21N0nijptWXyRvY9h4fnbMhLQLPLuUTH+5QQi//zGZTQmMlTfHNQ6wplKWr3+P2tXm/estHEePO1s1nvV6ZTmj3Od4TV+5AM1naAlqCVXbTotTFhvMqims9FdKNu2w5Dxt2FPZRLeom+3qcBwAcGhdIGDuW8Qrl1X7qnaENUw3o7Byrxe/SSZnmME672HewahAwiJw7+usOx2gtEjCpHVhqTy9zwu8AUf9lTXJnnjVbkmAczITM4UjrYU13416neXkfiMMso17nxSh8Ea8bgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7823.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(4326008)(44832011)(316002)(6636002)(5660300002)(6512007)(26005)(6486002)(6666004)(86362001)(6506007)(2906002)(2616005)(186003)(1076003)(66476007)(8936002)(66556008)(508600001)(66946007)(38100700002)(38350700002)(8676002)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NMGOjCkCHieJ2nLah1e/0s2dl/Kb6dvdkP6vn9yKT3gCgG1/tZTlBuFFElkQ?=
 =?us-ascii?Q?NOLwFhzcEz/w/wHIFFBbjK83TC7B9lOwGq4uxQR9pP6FiAjRh/JlJvt0IMy7?=
 =?us-ascii?Q?maYGmePzOfjsRK7eO+Fs5hAD7TXKiI5AhzXIi9SRzUi2Bl0XOLMs5126V3I6?=
 =?us-ascii?Q?E/NX6LIhkn5dbAGZntv2+5fZQSLrZN0T2fJbpqaYD3WG0uEn0CMTjt8rVPuP?=
 =?us-ascii?Q?OuXNwysR/AoWt3uiAtKIyzwcj4P/8IP3wFPNjZi6aSY/9gjbeI09+lUbblI7?=
 =?us-ascii?Q?ruzeufCNiRUGfx+ZehcY9qb7IAu2wCeEOW6+BEzVgR0FMGgRU96LY1ASrw1+?=
 =?us-ascii?Q?JmcptiYnslQyAB+N1JqeLc5G8xBMWjE4ZDJhRT2QhHVfQvt+MJ9CjGMnvPPV?=
 =?us-ascii?Q?GmzVuUZzBBB7yehyQDHXQW6WHqUoqe3bkX/e6gEO4DiRQTW1dsFGk8l0rT8v?=
 =?us-ascii?Q?DhxeN2GWe8pelq5Dq4hemr+p1bZYhLA3JO64dISyH4AOnkAn++wIRO7kXuSl?=
 =?us-ascii?Q?/vhQxrEb1GdN1V7LoxCCzb3hv/HRP1S/pQ2YTyEVAO1iX0wd9vYmEaPLUJ9O?=
 =?us-ascii?Q?TevnKswDKn+waMOhveev9SwbB60g9x8Ck0a7eOyoVnOK4UzTWHJ2DYnRFqNl?=
 =?us-ascii?Q?r++tekvbGVWbcD3d2FY45HmxwBQf8EjRHXX3QyNFx0Tut+8k6DRAOyCB9b9p?=
 =?us-ascii?Q?53uOd9h5KqQyiYl+ybkdhoZ62PROeuuHRJF6hoyCe8g4h9AJSJLya8B/Aom/?=
 =?us-ascii?Q?YZv2iAc7K+6iAUXirDPUBzHItHpR2mPfT73hTc6palKY7ilzYTOM9cK8aztv?=
 =?us-ascii?Q?w7aMjOebFlfqp0FQPGb8zzMFaGj6g0N1thJeMMnJ/QgDgNJydE+jiOJu4GyG?=
 =?us-ascii?Q?PCAFHt1TcginMHLFHAa1C8xw6+BUeZT/VSTjqXxxS1IU9ibn5nJnTaZgrBKx?=
 =?us-ascii?Q?hYIHpCq8zyJZkh1prZ/Ft+mgAIcjY3C14NJPyMnjFI4k7lTD0Zt6Hrw/J/jF?=
 =?us-ascii?Q?jNwuQgHF54E4nMcke3BFE69xJpnUTHbzQYd71IQmVqGIu/btvkB+qB3Ip6ae?=
 =?us-ascii?Q?gNB3c6B3H0d5pp6CAg62LFDCye0aP/O7MP0SJUqYR6uTuxWihp2f9PXfQ6yw?=
 =?us-ascii?Q?uKi5dQQ/D+GayjOnadAErXErU7iVqnif49iWbCvQeD2yw8IcCzsDtCBcAK3d?=
 =?us-ascii?Q?Mo0ezHAkfqWZF2V70X2R06zwIA8dEg1JjGq3+1bsh9CD9czNVe4sZf6MWTBw?=
 =?us-ascii?Q?GqPtATBnFIIdRtqiSyhb5RCaey3oY/FKnc9I2IkIja69A3N14rN2sydJeRai?=
 =?us-ascii?Q?ph7w95Ccdckvf+LHPZooKM3XKoLDyFapoNlpstvdMhuM3W5nNW9vLnrpPchI?=
 =?us-ascii?Q?v5pq8SqWrg6dQ4ohmS3v+f8Q6I4l/67r5tcu6dyWKDP95rQz5QRMgdymuLpn?=
 =?us-ascii?Q?fgNfIuELsc0Cie9FTbvGz8Y4r2/9y0G5eyQYIVsTQ4ysdg7edYgUHlCKQlR3?=
 =?us-ascii?Q?catORwE7VcrY3yv1jrtd3w4ns1uySZAwZoWkWjwXCMAdg0rCJ9behCzlGJ12?=
 =?us-ascii?Q?pC2D3FSJvrtxAsUgX2I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fdcca1-942c-40d2-450e-08d9eb9015dd
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7823.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 05:50:32.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGHPI5WdpkJSOIPfWW37Xjtw6fuv1I7DhnKtbDKrHTb4K0t1848NoaeBIVW0RS9I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5002
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we can use the enetc_cbd_alloc_data_mem() to replace complicated DMA
data alloc method and CBDR memory basic seting.

Signed-off-by: Po Liu <po.liu@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 91 +++++--------------
 1 file changed, 21 insertions(+), 70 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index d3d7172e0fcc..147c2457292f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -45,7 +45,6 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 		      | pspeed);
 }
 
-#define ENETC_QOS_ALIGN	64
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
@@ -53,7 +52,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct tgs_gcl_conf *gcl_config;
 	struct tgs_gcl_data *gcl_data;
-	dma_addr_t dma, dma_align;
+	dma_addr_t dma;
 	struct gce *gce;
 	u16 data_size;
 	u16 gcl_len;
@@ -84,16 +83,10 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_config = &cbd.gcl_conf;
 
 	data_size = struct_size(gcl_data, entry, gcl_len);
-	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
-				 data_size + ENETC_QOS_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(&priv->si->pdev->dev,
-			"DMA mapping of taprio gate list failed!\n");
+	tmp = enetc_cbd_alloc_data_mem(priv->si, &cbd, data_size,
+				       &dma, (void *)&gcl_data);
+	if (!tmp)
 		return -ENOMEM;
-	}
-	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
-	gcl_data = (struct tgs_gcl_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
 	gce = (struct gce *)(gcl_data + 1);
 
@@ -116,11 +109,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		temp_gce->period = cpu_to_le32(temp_entry->interval);
 	}
 
-	cbd.length = cpu_to_le16(data_size);
 	cbd.status_flags = 0;
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
@@ -133,8 +123,7 @@ static int enetc_setup_taprio(struct net_device *ndev,
 			 ENETC_QBV_PTGCR_OFFSET,
 			 tge & (~ENETC_QBV_TGE));
 
-	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
-			  tmp, dma);
+	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
 	return err;
 }
@@ -464,7 +453,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct streamid_data *si_data;
 	struct streamid_conf *si_conf;
-	dma_addr_t dma, dma_align;
+	dma_addr_t dma;
 	u16 data_size;
 	void *tmp;
 	int port;
@@ -487,20 +476,11 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	cbd.status_flags = 0;
 
 	data_size = sizeof(struct streamid_data);
-	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
-				 data_size + ENETC_QOS_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(&priv->si->pdev->dev,
-			"DMA mapping of stream identify failed!\n");
+	tmp = enetc_cbd_alloc_data_mem(priv->si, &cbd, data_size,
+				       &dma, (void *)&si_data);
+	if (!tmp)
 		return -ENOMEM;
-	}
-	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
-	si_data = (struct streamid_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
-	cbd.length = cpu_to_le16(data_size);
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 	eth_broadcast_addr(si_data->dmac);
 	si_data->vid_vidm_tg = (ENETC_CBDR_SID_VID_MASK
 			       + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
@@ -538,11 +518,6 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	memset(si_data, 0, data_size);
 
-	cbd.length = cpu_to_le16(data_size);
-
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
-
 	/* VIDM default to be 1.
 	 * VID Match. If set (b1) then the VID must match, otherwise
 	 * any VID is considered a match. VIDM setting is only used
@@ -562,8 +537,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	err = enetc_send_cmd(priv->si, &cbd);
 out:
-	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
-			  tmp, dma);
+	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
 	return err;
 }
@@ -632,7 +606,7 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 {
 	struct enetc_cbd cbd = { .cmd = 2 };
 	struct sfi_counter_data *data_buf;
-	dma_addr_t dma, dma_align;
+	dma_addr_t dma;
 	u16 data_size;
 	void *tmp;
 	int err;
@@ -643,21 +617,11 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 	cbd.status_flags = 0;
 
 	data_size = sizeof(struct sfi_counter_data);
-	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
-				 data_size + ENETC_QOS_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(&priv->si->pdev->dev,
-			"DMA mapping of stream counter failed!\n");
-		return -ENOMEM;
-	}
-	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
-	data_buf = (struct sfi_counter_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
-
-	cbd.length = cpu_to_le16(data_size);
+	tmp = enetc_cbd_alloc_data_mem(priv->si, &cbd, data_size,
+				       &dma, (void *)&data_buf);
+	if (!tmp)
+		return -ENOMEM;
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
@@ -684,8 +648,7 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 				data_buf->flow_meter_dropl;
 
 exit:
-	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
-			  tmp, dma);
+	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
 	return err;
 }
@@ -725,7 +688,7 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	struct sgcl_conf *sgcl_config;
 	struct sgcl_data *sgcl_data;
 	struct sgce *sgce;
-	dma_addr_t dma, dma_align;
+	dma_addr_t dma;
 	u16 data_size;
 	int err, i;
 	void *tmp;
@@ -775,20 +738,10 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	sgcl_config->acl_len = (sgi->num_entries - 1) & 0x3;
 
 	data_size = struct_size(sgcl_data, sgcl, sgi->num_entries);
-	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
-				 data_size + ENETC_QOS_ALIGN,
-				 &dma, GFP_KERNEL);
-	if (!tmp) {
-		dev_err(&priv->si->pdev->dev,
-			"DMA mapping of stream counter failed!\n");
+	tmp = enetc_cbd_alloc_data_mem(priv->si, &cbd, data_size,
+				       &dma, (void *)&sgcl_data);
+	if (!tmp)
 		return -ENOMEM;
-	}
-	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
-	sgcl_data = (struct sgcl_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
-
-	cbd.length = cpu_to_le16(data_size);
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	sgce = &sgcl_data->sgcl[0];
 
@@ -843,9 +796,7 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	err = enetc_send_cmd(priv->si, &cbd);
 
 exit:
-	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
-			  tmp, dma);
-
+	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 	return err;
 }
 
-- 
2.17.1

