Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB614B558A
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 17:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356089AbiBNQEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 11:04:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356093AbiBNQEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 11:04:37 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C4C60AA9
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 08:04:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bf3wRZTk5YmsoAOFiEmEAFpjECEfXTH8qn/hCzfS+sVNNd+9WbaRWz1z3q7XhhEVO7dHnMW00b/tRqqJAczcw3H3ieu+vhbxvv4vfCg8RDbxB/jyh1hI6qY6l+E2JoUzVEqZeLj5FCc2Lbvo+kFAMtT65OSqBIiQrT7zaWSW5TmCyQuJKXPtJCIKsuZdQpee0um9Mygp+TQKAJiq4PNqwPLnjDg7CHoAPLAOAiUDdoWNlPy1QMvQ1j5zAN5bukXgau5zDb5ubEmm+VP14LwcVx5S81750PnsxkNsm3+/D4f4OdSFFoC92LvtMivoICHR5ggbzsXXChT5a2IyZf6kgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXblt3ZgXq9gfDhWBb86S5XcqcN8SrVKtEQBmmxl4R0=;
 b=jS70Y2Z0fslngSu14hgDa3k/51ZzZBTLS2UobWALtYGItApNTF970UDa6WEjGI+bt0F/tc0kGt/1IatS0FPA5QN+3bbNurWBYGzoDvxm1VBsb5pJeeDhfOqX5T0KbcwKvQLh4I7UTt+SPISW9UY4rYKx+aFPSF4JdnKpKwnKCA469fceM708wpezEsmGS5+brP/Z4SScQ8ZWy6RzECljRxJwQEUgHr3XlYa4+St2qWai/aWnRQBmvmXVUhL/rxQfJN2v7dA5FGYuUJj1nhJyKmHrOfV5X0UFVXhnwSFLjmYJHBjQPjXHrqEyJi52n+wrqvlHihO+FNwrYRF34hzXoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXblt3ZgXq9gfDhWBb86S5XcqcN8SrVKtEQBmmxl4R0=;
 b=sJ5SAhMcipaSRIwtyeDg/RAPdCGb+8OsdvOFJlCG0me3kXCiRkBn1RmGgIyJ5EXkqFshNah+XcxRRHC5j4DSAPL+fpioRYddfcS///NYM0VHFwa+czG3rjn9B2OcYaoNb4bD5cddWw3ZB1ekjzFGKLbwIc9+EUUKQlzO8SdIEVA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by AM7PR04MB6981.eurprd04.prod.outlook.com (2603:10a6:20b:103::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 16:04:20 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366%5]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 16:04:20 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next 2/2] dpaa2-eth: Update SINGLE_STEP register access
Date:   Mon, 14 Feb 2022 18:03:48 +0200
Message-Id: <20220214160348.25124-3-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
References: <20220214160348.25124-1-radu-andrei.bulie@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93fcb154-4fac-4715-ae4f-08d9efd3a8f8
X-MS-TrafficTypeDiagnostic: AM7PR04MB6981:EE_
X-Microsoft-Antispam-PRVS: <AM7PR04MB6981E5B5BF09D8D63BAFB878B0339@AM7PR04MB6981.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DU+F0423IvUtnnTH9+kwYmEquHFKpOaUnnR+vXhz5L8DawKBA0zswxVcsDAAYL/YxhVSJBRzGb16UpHE2SyiZ3Csc/Qqs79dssV75zXhJ64nvYLzqIbLriab+liIWYaVK01RhUzozg3darXlKYCKwXcAsqQl2f/Yv23bBd6pG855TdsKJj97bgNisAFazPks3Wde8Izld6Dhi/PvsbA49noPLcnaua6VDtzAvPtmuW5gzCPYkgvR1Bb2uCFOOT/4EO9DJ2qJJAwwXegShCPD8R4tflQ+hx+JYPiLx9J997s57VygLuhZ2rhAkk6iT8JVvv3/2qWoi2vc/Yi+4IjWuTZ2sOJTWh6UXY+HV3dfwDlTn/9wsHrHEmCFm2QXRESq8WkW/NurE47MCQ0ccoyWYuFtThx/STd9Vx4sU4Y4gQRNa47BMQNmMzn2qFhRzvZ01dafYIb/Skuak6XeQWYOXaJzBy+S0/7XoGB1r/oD8PuuK3gKjN+EUG3lihFMVp9H+DIKJ4+IXXJs237z1Nfv7oCgOwp1kGYNQqxrv6wPzV7LefVRAQnR2kEB8co7/zR1uJfhIBVPWq54TT2KZoqirYkRusagELLR2tbF3ctV5u5KCX2tIl69JNjgSioJuBLzFDDnoJRl28vOjxXTUrXa/9TDJa2YLkyJBTYIh0cbAV2RvKnQKwKMYwiYeqRQNynLrx48j9Dbhl8hfXUR3/UpnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(66476007)(38100700002)(6512007)(6666004)(5660300002)(8676002)(8936002)(6506007)(52116002)(15650500001)(4326008)(83380400001)(38350700002)(2616005)(186003)(26005)(508600001)(86362001)(36756003)(2906002)(1076003)(316002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RSrm6p79y/UNDUhB474Fyfw4FFtOvrQt55YKwsXX9bThX538N8qGDah9Ni0O?=
 =?us-ascii?Q?PsbLZxUmod9+a6n7TSEX9pGuY0WTzl2NvMpTaijJrVWS2lKT0Ic4+vyWM2HK?=
 =?us-ascii?Q?n5AqaWs2wLxaEVtAQVRRQcGrh3pfSPojsmWHKAXC63rQGk9826nC8HnDOzZ0?=
 =?us-ascii?Q?BMorkmlLMjb0fBEI8NbgYNZF+lUKSWho26yeYqqHqzpYmIZQN0wfF87IgtSx?=
 =?us-ascii?Q?jEDOIWoqMphVbUKQI824b73NPI5+wax6CG8aivNREVUM5jQIFLKzYv2+MS8p?=
 =?us-ascii?Q?1VM1IltCsMYEv5bxKcnwSJOQaLdjQA0Mb6FcR6bBJE1tpci3s+1eMjImzDt9?=
 =?us-ascii?Q?II45qX9z8NBJgg8952i/Rv320R2cJ8wHsIh+GJuJDKZu9rcpQJcNSNM+Ispl?=
 =?us-ascii?Q?SkMBcp4t2UhPSHLZ6RuS40INJBufYXSEGQzUHNUMr/GwRtbcHvChpySPe1zW?=
 =?us-ascii?Q?FC174mO1qdUKD3ixu7YBDxv3yI4upvDtnhsOX1IIi8lQBcD8kUFwpdN70DNs?=
 =?us-ascii?Q?I0tj9AeF0DMxnnE77zhu1L0DWnCIGhJ0VmuzttKOVZhFFEyHcMvecj71VaYX?=
 =?us-ascii?Q?80Gfgcpt2LKoRcSW9W31X4vvezUuch6KVanqBkdiOWNxCp7G2P/PKDeOq9Ek?=
 =?us-ascii?Q?g96E8oKfXtjTIqLS0RQtE63zelxdmHjtdF6a56vszLFKJ1yjqW7+9KwmENJU?=
 =?us-ascii?Q?8rajllQiZq/hOPB9ad45rP4imJA+wB2m4maZ2TLNG5ttTC3tOv+FtN8aS9ts?=
 =?us-ascii?Q?XKk9MprqVsg8ZYMywvUV2cK1l/uHnXfnudzStcbKxVi7EB2ei+lHVlyXwBgj?=
 =?us-ascii?Q?2LiusjspU/oLvSIYgZMnTjhqQtBclujLjXtgeAj1Ix+silak0UKUTXgnVG6/?=
 =?us-ascii?Q?BwCjCgmWdrtrX/CBatICEJXepfhfqnKAzZMCccRhrAQPmz6JslO0hQWYo4xt?=
 =?us-ascii?Q?sCXGA1nWp0Gnvlym9tyL2oHCTgi+iyUMIKKEaxfki65Ty/DHDgnZTcXoKTXK?=
 =?us-ascii?Q?I6uC6oaZZCb5QbERhMadyWb2O0LHeBBJ99JW+zuHsBk3BP+rbpAN/6z0wnBU?=
 =?us-ascii?Q?ghTk/n635XXcD0+7+VqXIc4fvH6mn50SnYY36HNRcCAlP0pFZH3waw1+E5h7?=
 =?us-ascii?Q?BU5LdB5R6l/wkfwVsyhpmBHR4Rg2pWQ8kOmy5pE1Y7B1IjYwcDtRRWUwBIsg?=
 =?us-ascii?Q?CuKr9xd7UDftIBRlAhDDldG0LiDziwcyxkK0yqCablLtc9ID/n6QqaEumQDN?=
 =?us-ascii?Q?1BayFGKBDDeEpPLPXChBMFJBwdmQyUQaYXzMkj7i+2p+Z8oHmskKv8Qqhhn4?=
 =?us-ascii?Q?edQ/5uVIwIJ1ew3E7gcBi4zBRV6jPKOkQfRTZt8tXujlQm3lpmUScPH2OW5m?=
 =?us-ascii?Q?jLtjdkQb4lZbZm01buoJuInNU3nqBM+UZuEpyJDxbQUWElGALyqA1HOY2UPl?=
 =?us-ascii?Q?GDdEBxYMgpwEkRvmn9rYIqLLuEbuCEv1BenEe5ENYfpqc0Og57rSs7o2YIgf?=
 =?us-ascii?Q?OSIeJzre3UFGrKYPO4oUoJMRzbSe5TAO1DHteJoTkREo1UGt4WTgdtc6danv?=
 =?us-ascii?Q?6Ib2tZ2H5CvZ3EdzIz1HYTBBFiuVKfFopxSm7Piod7HYGgXWcEvaND2oY9tD?=
 =?us-ascii?Q?M/VqyjiQwSJaaf7v2i5Ihsd16c5mrsdKQl/Af7GIGqEF8JTUp3uFl9zTJNU6?=
 =?us-ascii?Q?VQ64oA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93fcb154-4fac-4715-ae4f-08d9efd3a8f8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 16:04:20.3205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtZbF3KFp0RaTBU6MiKl/gscmAko+/qMB4JXPthp10JnZsauU22i665ITz0sAOkHlZpGvU9jx0e5HI9qWJhzdFSAznDOCpzarlIYjeeaeww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6981
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DPAA2 MAC supports 1588 one step timestamping.
If this option is enabled then for each transmitted PTP event packet,
the 1588 SINGLE_STEP register is accessed to modify the following fields:

-offset of the correction field inside the PTP packet
-UDP checksum update bit,  in case the PTP event packet has
 UDP encapsulation

These values can change any time, because there may be multiple
PTP clients connected, that receive various 1588 frame types:
- L2 only frame
- UDP / Ipv4
- UDP / Ipv6
- other

The current implementation uses dpni_set_single_step_cfg to update the
SINLGE_STEP register.
Using an MC command  on the Tx datapath for each transmitted 1588 message
introduces high delays, leading to low throughput and consequently to a
small number of supported PTP clients. Besides these, the nanosecond
correction field from the PTP packet will contain the high delay from the
driver which together with the originTimestamp will render timestamp
values that are unacceptable in a GM clock implementation.

This patch updates the Tx datapath for 1588 messages when single step
timestamp is enabled and provides direct access to SINGLE_STEP register,
eliminating the  overhead caused by the dpni_set_single_step_cfg
MC command. MC version >= 10.32 implements this functionality.
If the MC version does not have support for returning the
single step register base address, the driver will use
dpni_set_single_step_cfg command for updates operations.

All the delay introduced by dpni_set_single_step_cfg
function will be eliminated (if MC version has support for returning the
base address of the single step register), improving the egress driver
performance for PTP packets when single step timestamping is enabled.

Before these changes the maximum throughput for 1588 messages with
single step hardware timestamp enabled was around 2000pps.
After the updates the throughput increased up to 32.82 Mbps / 46631.02 pps.

Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 96 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 12 ++-
 2 files changed, 97 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c4a48e6f1758..7221c7299cb4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -35,6 +35,85 @@ MODULE_DESCRIPTION("Freescale DPAA2 Ethernet Driver");
 struct ptp_qoriq *dpaa2_ptp;
 EXPORT_SYMBOL(dpaa2_ptp);
 
+static void (*dpaa2_set_onestep_params_cb)(struct dpaa2_eth_priv *priv,
+					   u32 offset, u8 udp);
+
+static void dpaa2_eth_detect_features(struct dpaa2_eth_priv *priv)
+{
+	priv->features = 0;
+
+	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_PTP_ONESTEP_VER_MAJOR,
+				   DPNI_PTP_ONESTEP_VER_MINOR) >= 0)
+		priv->features |= DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT;
+}
+
+static void dpaa2_update_ptp_onestep_indirect(struct dpaa2_eth_priv *priv,
+					      u32 offset, u8 udp)
+{
+	struct dpni_single_step_cfg cfg;
+
+	if (priv->ptp_correction_off == offset)
+		return;
+
+	cfg.en = 1;
+	cfg.ch_update = udp;
+	cfg.offset = offset;
+	cfg.peer_delay = 0;
+
+	if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token, &cfg))
+		WARN_ONCE(1, "Failed to set single step register");
+
+	priv->ptp_correction_off = offset;
+}
+
+static void dpaa2_update_ptp_onestep_direct(struct dpaa2_eth_priv *priv,
+					    u32 offset, u8 udp)
+{
+	u32 val = 0;
+
+	if (priv->ptp_correction_off == offset)
+		return;
+
+	val =  DPAA2_PTP_SINGLE_STEP_ENABLE |
+	       DPAA2_PTP_SINGLE_CORRECTION_OFF(offset);
+
+	if (udp)
+		val |= DPAA2_PTP_SINGLE_STEP_CH;
+
+	if (priv->onestep_reg_base)
+		writel(val, priv->onestep_reg_base);
+
+	priv->ptp_correction_off = offset;
+}
+
+static void dpaa2_ptp_onestep_reg_update_method(struct dpaa2_eth_priv *priv)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpni_single_step_cfg ptp_cfg = {0};
+
+	dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_indirect;
+
+	if (!(priv->features & DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT))
+		return;
+
+	if (dpni_get_single_step_cfg(priv->mc_io, 0, priv->mc_token, &ptp_cfg))
+		goto fallback;
+
+	if (!ptp_cfg.ptp_onestep_reg_base)
+		goto fallback;
+
+	priv->onestep_reg_base = ioremap(ptp_cfg.ptp_onestep_reg_base, sizeof(u32));
+	if (!priv->onestep_reg_base)
+		goto fallback;
+
+	dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_direct;
+
+	return;
+
+fallback:
+	dev_err(dev, "1588 onestep reg not available, falling back to indirect update\n");
+}
+
 static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 				dma_addr_t iova_addr)
 {
@@ -696,7 +775,6 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 				       struct sk_buff *skb)
 {
 	struct ptp_tstamp origin_timestamp;
-	struct dpni_single_step_cfg cfg;
 	u8 msgtype, twostep, udp;
 	struct dpaa2_faead *faead;
 	struct dpaa2_fas *fas;
@@ -750,14 +828,7 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 			htonl(origin_timestamp.sec_lsb);
 		*(__be32 *)(data + offset2 + 6) = htonl(origin_timestamp.nsec);
 
-		cfg.en = 1;
-		cfg.ch_update = udp;
-		cfg.offset = offset1;
-		cfg.peer_delay = 0;
-
-		if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token,
-					     &cfg))
-			WARN_ONCE(1, "Failed to set single step register");
+		dpaa2_set_onestep_params_cb(priv, offset1, udp);
 	}
 }
 
@@ -2407,6 +2478,9 @@ static int dpaa2_eth_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 	}
 
+	if (priv->tx_tstamp_type == HWTSTAMP_TX_ONESTEP_SYNC)
+		dpaa2_ptp_onestep_reg_update_method(priv);
+
 	return copy_to_user(rq->ifr_data, &config, sizeof(config)) ?
 			-EFAULT : 0;
 }
@@ -4300,6 +4374,8 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 		return err;
 	}
 
+	dpaa2_eth_detect_features(priv);
+
 	/* Capabilities listing */
 	supported |= IFF_LIVE_ADDR_CHANGE;
 
@@ -4758,6 +4834,8 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	dpaa2_eth_free_dpbp(priv);
 	dpaa2_eth_free_dpio(priv);
 	dpaa2_eth_free_dpni(priv);
+	if (priv->onestep_reg_base)
+		iounmap(priv->onestep_reg_base);
 
 	fsl_mc_portal_free(priv->mc_io);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index b79831cd1a94..ed3d441e81bc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -526,12 +526,13 @@ struct dpaa2_eth_priv {
 	u8 num_channels;
 	struct dpaa2_eth_channel *channel[DPAA2_ETH_MAX_DPCONS];
 	struct dpaa2_eth_sgt_cache __percpu *sgt_cache;
-
+	unsigned long features;
 	struct dpni_attr dpni_attrs;
 	u16 dpni_ver_major;
 	u16 dpni_ver_minor;
 	u16 tx_data_offset;
-
+	void __iomem *onestep_reg_base;
+	u8 ptp_correction_off;
 	struct fsl_mc_device *dpbp_dev;
 	u16 rx_buf_size;
 	u16 bpid;
@@ -673,6 +674,13 @@ enum dpaa2_eth_rx_dist {
 #define DPAA2_ETH_DIST_L4DST		BIT(8)
 #define DPAA2_ETH_DIST_ALL		(~0ULL)
 
+#define DPNI_PTP_ONESTEP_VER_MAJOR 8
+#define DPNI_PTP_ONESTEP_VER_MINOR 2
+#define DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT BIT(0)
+#define DPAA2_PTP_SINGLE_STEP_ENABLE	BIT(31)
+#define DPAA2_PTP_SINGLE_STEP_CH	BIT(7)
+#define DPAA2_PTP_SINGLE_CORRECTION_OFF(v) ((v) << 8)
+
 #define DPNI_PAUSE_VER_MAJOR		7
 #define DPNI_PAUSE_VER_MINOR		13
 #define dpaa2_eth_has_pause_support(priv)			\
-- 
2.17.1

