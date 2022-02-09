Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3504D4AF1BA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbiBIMdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiBIMdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:33:22 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501F3C05CB9B;
        Wed,  9 Feb 2022 04:33:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdtyLsipFzO8XWF0tUamDEa8MTLfaMugsnoAZ+ZfV9iJK4BB6dul6C3HB0SR0V4tfdjxRXz8QnY4Zck7FF6OlA9/bfrIkZikA3RDBZrCMAGVNsfN89J9+0xYvQ4IVgwJnpGPWaUzi4P2EfRkDzEyWxMjs0Nw2PVoSGvW9retVYKou5naeWaaXjh3BhpWrXwJ8gb8xpSANycgn3cXelm2lwM/+6uTXiGctt//Mqpuw3ZRTg1jDZ5sM0BXLmP9a6ow+dRTJVDNfgYTBRVcSiRU6pfprkE3skrtXzopZn1Sy3lcYMR1Jt7BVa+yxmua6aZOfi+UYXtNdsFa02rNMiH2HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2+g7iGSrNChcyXmw1tgIoXrfaaiK6QnTD771x/iSRk=;
 b=FOvoquzZKVGAAyCA+xUCH5nUYsJYsK5neXBTIok9PL5xN66r/ywtArAHIs6Qe8LgkfWcNd8bZa2OqrbIWWZ9SsSHpJV13D1fyrmzubx5i78T6uCgIpyi7SPo6Ivr+x9JFh+onyyao3MzyemG+NdA8CPNBfa2K00FHUNrd48ZIC3kDGvP6tVTm01GWbx6uXkbdLGj1mkMzBgzC+FnoyNWyPzJSpPAun3V96eo5rJ5yErVjC66bY5AQDUl3Mdn5QiUZFBtxqXcVFrnzaNNFmOtcBnS2lx7yBLoM4QapkFXVXBFqZF1w9S1UL9q5xA2bcTEQLhgBw3GbqNRG2c6uWX6Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2+g7iGSrNChcyXmw1tgIoXrfaaiK6QnTD771x/iSRk=;
 b=ViMc6axEmqu6x+NpVsDRG+xE+D8ylHCcKgcY2Gs4a9FwdA9CzoTf/G80QjV1T5r7V3EXkBsv/vdWv4o0ea5t/iTGV7O1I2Kut+y4znS/2o98MjxMgb+tiuS2FzKuSHA/AGhtpDcJWzvqIcgBSNkiomdQC6bwza2kYLOITXRsWj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com (2603:10a6:10:1f2::23)
 by DBAPR04MB7398.eurprd04.prod.outlook.com (2603:10a6:10:1a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 12:33:22 +0000
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a]) by DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a%3]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 12:33:22 +0000
From:   Po Liu <po.liu@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, tim.gardner@canonical.com, kuba@kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Cc:     xiaoliang.yang_1@nxp.com, Po Liu <po.liu@nxp.com>
Subject: [v2,net-next 3/3] net:enetc: enetc qos using the CBDR dma alloc function
Date:   Wed,  9 Feb 2022 20:33:03 +0800
Message-Id: <20220209123303.22799-3-po.liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220209123303.22799-1-po.liu@nxp.com>
References: <20220209054929.10266-3-po.liu@nxp.com>
 <20220209123303.22799-1-po.liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0241.apcprd06.prod.outlook.com
 (2603:1096:4:ac::25) To DBBPR04MB7818.eurprd04.prod.outlook.com
 (2603:10a6:10:1f2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a30153d-0848-4ced-a0ce-08d9ebc85c16
X-MS-TrafficTypeDiagnostic: DBAPR04MB7398:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB739807F20B445ADB5C6A7B54922E9@DBAPR04MB7398.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d17wv8tuUM3o/XkzhNXT4pgzfRfR87TCQ7Y/+NdsCOhOjrcInn791n1+Z2WlPlHyZU0KGdToIBbuClx04qIWVyKKNaiAEFocCJyrk3ieLCCrYjP+onQDfDkizAJwIXEJ+3LsC4rrUSwuy+DQArBTdwuxuzZ73h1xZsAngbIV4hWaWZhISLoHUa8nSxO+DLU3yU8uqKThlKJuL/FuOGXfTscGYR99aEkKH4X8i0R4XPFQoqu71pXeHvBEJjt6GBQBWERlnaJafTqbwaves43MuRyeXT74GW0bDWsmmEM4e5zlHyYOYt96e63r0XbFlQIeReeep6QRoDrek4sP/IrTxXEyexvqdHQkpNTfcf0hr1YcHlwrOp1DgYlAYk2lunKaThf6qHZDeRJETG+wcJ8TKs6ukixItDsCq9izAEpYpm+bR3wLYwpRilIt2NBWhM8ykHuFTQBD/ONMcucMHuoBww4hl/ry+cRQq8RdzdYT8c9fegPy+N9/8mt3tAnQP8L2shunPqPV356juyBVr+jGed1+41QBMgK0/nCLZhrnwIBtMGWfKwh+OUz4u7UMbhn2DN2ZsJumCRnPlG6i4Gkp5MRmIduyFtzoxGlRQCAauOQ7590G5EdW/vGlKFf6j2KzswhTgUXQ79N9drO0IsyxsQntEMXjKo/2jssGJ3u+1QHLWLRykh2SjKHugl7+Bbuk5rm1sdcXm+EKbToFMZJGJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7818.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(66946007)(6506007)(36756003)(186003)(52116002)(6636002)(1076003)(316002)(2616005)(38350700002)(6666004)(38100700002)(66556008)(86362001)(6512007)(2906002)(4326008)(44832011)(5660300002)(66476007)(6486002)(508600001)(8676002)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qj2Q7EWWrTGfXkVXW/1CPN+E+32qzKZxhd/bXbhxHcgeONBuJEaeq3Hgv6fI?=
 =?us-ascii?Q?M3PKZoHa6iCzxwO2NK8f41PLjdZl6MTn2YgkcA69pTzu6mkx4aWJYZQtVViJ?=
 =?us-ascii?Q?wcTKWVRhUofJmkzIZjBvk7KEA0pjc1zAr7vckJWR5yAyvg/v8H4MbLscO5FL?=
 =?us-ascii?Q?34KPZr/id/CnfMQpEWj/8oY+N0v4IESOLbAZ2/dPCOhSobm53iVi8z/xvPdP?=
 =?us-ascii?Q?1dL0J7Y+e2NO5VuE+DsJtnsqqZQCxymkGHI1UVrMKBDQfNYsoUpTQ/aZ+u33?=
 =?us-ascii?Q?8u5LiT4GHuzKfW17sbdtNFhBQuPCe5f7dQnjzoLf5TguJVIzYrQxsvgVLuHv?=
 =?us-ascii?Q?1kk5bbcTO5A0dADgCMA/88XLRmNyJ36pNtjcs7ZY5mbx3kTr1JO9MsbNucNR?=
 =?us-ascii?Q?AZyJuPNHk2gPHgK9Xm/h9TPY0XMzwMq8U95QbxBoqyTet3ChMOGR+/O0kfXU?=
 =?us-ascii?Q?zy6IeE3tJXjlTu6uAh2kYlWzTvPXV31s0XzvBe2523QAC8IuvtLQyUuH/jxb?=
 =?us-ascii?Q?xH6PbLqJGqrk7fJ6PBCUoFqpHhT0rWPJy+9QqioGx048YkCaJuMcX5vV9Llf?=
 =?us-ascii?Q?mN1xUhd0nsMg59ZgpYWkJSM+eTeAeDMZPEahlwej1CAQP7TQl63MQBvnUsiB?=
 =?us-ascii?Q?AX7vmIA+hS1ADfOsMmUcqpGChrtrisVwV6r+FLG4VdbPwNrcr6huEmpjy2sB?=
 =?us-ascii?Q?gWTjiy+SlRi0C5jmrKmFmuxlbRZUepiVU6ZzzbCV9rFudVKutLE+HuGJSplG?=
 =?us-ascii?Q?RVq0zpUWXJ3BK455lXQn5/oaDcMalT6uBL8Qhj3RJOieADh/R+ec8Gkx3qwm?=
 =?us-ascii?Q?fusW08mdwXBbyULKzqy2KRLPix23l9z1+3dMkqplQ9HslDZKOXVg/R9E8B7x?=
 =?us-ascii?Q?6LSge/QHb59R2r3wxd0tI9WgrsOemlNGlHsXZvYsyXfzmRIawBpxu4SChNPk?=
 =?us-ascii?Q?SJRXYnFQXx9ThIwVwpwRLtZb+xmElEte/JDJ8eqIYKlmR2qmgbu2Vj2waB+N?=
 =?us-ascii?Q?N7U6Lxjtk4t6qtKymwlEw31zILhBsAbfO0W1CWjSwjUs3wj+t/HFsREWTf09?=
 =?us-ascii?Q?BKbNXYKaOxy7AfY8MjeSSDNJ5kUbyH6NfJtvPlea8I0DKu4ehlK62RkMJTIy?=
 =?us-ascii?Q?BF2UprCRDUzo93iM1v7rFgckCqH5s+Nk9FBLD0tijjQcuwVOmOJUqJbl3BSL?=
 =?us-ascii?Q?jThQcSNgGSK9W1LS63TG9S6HQkRJUHWeaq3RB/leEgd30eQ+jbLAzymAMrB5?=
 =?us-ascii?Q?gW2NmPoxc34ajo/lcpr3Kts5oEnDXBXWXfIzHIf2Qt72K1t2VfTIJ1k2bJSG?=
 =?us-ascii?Q?g7q0kmuzWvvoDMGK/HDHz5s1gDYjd2S1PGOI429fRcqFwGaCtLEtlhKlo4py?=
 =?us-ascii?Q?h4BTIqme5siSR/3h7QTvnwbc2S9j7w5nFtbFYunlXj8L7rEIu6UOJ7dqy+yn?=
 =?us-ascii?Q?v/BmpxFQm2l/YWexZKjKALojBqBWYnEkQHifeUl1tY4NaoRyZ1e9WV7CD3jG?=
 =?us-ascii?Q?Fi/ikSSO/Mm2MdCxFUJG3+EVRIPR0DPkrFaYW/IjUm8HSUpGqWLfF5jOv97m?=
 =?us-ascii?Q?brLB7tAhVL9KKHmSKFg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a30153d-0848-4ced-a0ce-08d9ebc85c16
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7818.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 12:33:22.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0dNegRKaPQPxpv3oc0i8ozcskuK/7FCGf04olASAW3BhxM/mgqcseWJ77pohGBg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7398
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
v2: fix the enetc_streamid_hw_set() cbd cleared again lead HW setting error 

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 97 +++++--------------
 1 file changed, 22 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index d3d7172e0fcc..5a3eea1a718b 100644
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
@@ -451,6 +440,7 @@ static struct actions_fwd enetc_act_fwd[] = {
 };
 
 static struct enetc_psfp epsfp = {
+	.dev_bitmap = 0,
 	.psfp_sfi_bitmap = NULL,
 };
 
@@ -464,7 +454,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct streamid_data *si_data;
 	struct streamid_conf *si_conf;
-	dma_addr_t dma, dma_align;
+	dma_addr_t dma;
 	u16 data_size;
 	void *tmp;
 	int port;
@@ -487,20 +477,11 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
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
@@ -521,11 +502,6 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 		goto out;
 
 	/* Enable the entry overwrite again incase space flushed by hardware */
-	memset(&cbd, 0, sizeof(cbd));
-
-	cbd.index = cpu_to_le16((u16)sid->index);
-	cbd.cmd = 0;
-	cbd.cls = BDCR_CMD_STREAM_IDENTIFY;
 	cbd.status_flags = 0;
 
 	si_conf->en = 0x80;
@@ -538,11 +514,6 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	memset(si_data, 0, data_size);
 
-	cbd.length = cpu_to_le16(data_size);
-
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
-
 	/* VIDM default to be 1.
 	 * VID Match. If set (b1) then the VID must match, otherwise
 	 * any VID is considered a match. VIDM setting is only used
@@ -562,8 +533,7 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	err = enetc_send_cmd(priv->si, &cbd);
 out:
-	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
-			  tmp, dma);
+	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
 	return err;
 }
@@ -632,7 +602,7 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 {
 	struct enetc_cbd cbd = { .cmd = 2 };
 	struct sfi_counter_data *data_buf;
-	dma_addr_t dma, dma_align;
+	dma_addr_t dma;
 	u16 data_size;
 	void *tmp;
 	int err;
@@ -643,21 +613,11 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
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
-
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
-	cbd.length = cpu_to_le16(data_size);
+	tmp = enetc_cbd_alloc_data_mem(priv->si, &cbd, data_size,
+				       &dma, (void *)&data_buf);
+	if (!tmp)
+		return -ENOMEM;
 
 	err = enetc_send_cmd(priv->si, &cbd);
 	if (err)
@@ -684,8 +644,7 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 				data_buf->flow_meter_dropl;
 
 exit:
-	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
-			  tmp, dma);
+	enetc_cbd_free_data_mem(priv->si, data_size, tmp, &dma);
 
 	return err;
 }
@@ -725,7 +684,7 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	struct sgcl_conf *sgcl_config;
 	struct sgcl_data *sgcl_data;
 	struct sgce *sgce;
-	dma_addr_t dma, dma_align;
+	dma_addr_t dma;
 	u16 data_size;
 	int err, i;
 	void *tmp;
@@ -775,20 +734,10 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
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
 
@@ -843,9 +792,7 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
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

