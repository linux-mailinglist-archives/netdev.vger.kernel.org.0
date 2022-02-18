Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E5E4BC11C
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 21:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbiBRUWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 15:22:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbiBRUWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 15:22:45 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14A74AE18
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 12:22:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0gg+80pyT2Zs8ZbI1TFTLJF2x/JM5vM/XLUmTOriTlYRi/0OoBYp2lAXuO6VSg9YvmaGlkaWoxm5gxO2cJZEGrVJvjc4/Fk/9koiND1hFAxvj8b8E2WzbgnR8CmY9waB/XN0mkt/s3dZpV1e3YzTyMHBMeFt1fCdfpmRtY7xFFwKu29/w65itN5vwfM+8rhtI0E00FStadMGjlEAbQu9HWA9tjzUhYr8YfDq6Z885a67d5rabJqRhDvcCi7E+LPsx/jqVIUJjso+XbsvkEcJJSiMlDCu/KS6OoxWo4yW2gm8yVbm+nJTxeJK5rEmvETJoY3kJ9OZTO0Z9iWi4kILw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vCouO/T3wVhnRJUbiUhb74btS5bn2Ibtg56f8dOlm4=;
 b=cS+p2uagjEaTbqOUoccjt6W1Qxk62R0fehAdSgHjldWHH+Ho27ZmpWR07dBglKhfQ/aI7J3eaDFxrHCpZexqFcOmkwMp7wAWlITYvqRf3o/i+/4XrgnJ8X5YsmVqzuGVmP9WlRqFNqiBoBRT9PllS/LUEDxVW44HEQDD+nX99r+PhSghuLhsdTU9fZfbK0LTzUNWiqY6YJiwDbziKJqlltyuB4q68q4sMLg3euJJjAE5qpFYZxmjO+WyBq4Pi/gIj8Gp2Gecv5U2enMcRpMb6Os6asCBJHFCg+p11+HN1NpCAeAVKS0NFINQKn/cUH7rSwaIaXKU5kE1fHTWfBuuag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vCouO/T3wVhnRJUbiUhb74btS5bn2Ibtg56f8dOlm4=;
 b=VQsBofeYtTELcVuf7jQ2npwlAH1jzUMw2rB2ZnkPrY1tVavdWcXnNeuoLBrytPl8wrujW+/mq81eHktb3Ent0HkkAd2kfHDDrI71PQ0O3IJEIAOszJKkEJaB7y9iv8K/ej1yUAH5Y5RdGjqdfiqB64PfKpxpb4X52EQ7V/wSmJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by DB7PR04MB4378.eurprd04.prod.outlook.com (2603:10a6:5:30::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 18 Feb
 2022 20:22:22 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 20:22:22 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        richardcochran@gmail.com, Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next v3 2/2] dpaa2-eth: Update SINGLE_STEP register access
Date:   Fri, 18 Feb 2022 22:22:01 +0200
Message-Id: <20220218202201.11111-3-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220218202201.11111-1-radu-andrei.bulie@nxp.com>
References: <20220218202201.11111-1-radu-andrei.bulie@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cb54cbc-78c5-47bb-b099-08d9f31c5e82
X-MS-TrafficTypeDiagnostic: DB7PR04MB4378:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4378E223DFA85BC1B6AC700EB0379@DB7PR04MB4378.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRuuFmle7zlG5CbRiz3pH3c9l0HTVh6t2fRqg21tfyFarpluM65VCVhDPvzFLM/5xkWN0SYVniLl+oEZIqoqGZdi5TkgsR1P5kQ3dmLBJizVoF0woVwz8TuPCH3ccvD0WAsIB+CKbMbHZ/QA6DaySzQGGdO4i2JZC4Jv9RxblURj7WKm3i1MMOU8GKjaYPJR5noP/b3G/1SRye3mTKePrulu4eZZX8Qt1e8bO7JiK/kqxSLmv9xyq/cobIzF1CnNO3gC+4/NPqCeHROtlIiGlIWdutawSFgLTdR++/AWpUdNNaeBkELwGMIsf03JZKSLKhyx1KluAmjyBDceYjGEcjbMXBYONBkGcd/7qC3epQNH36SNArINlWdcwQ6MAt4HsP6gG+tBZe0M/h7pR5LseswwMhJF2Njze8p2kUMHqPfrK0MtbRoMtMOYsymzuJkAp/OmK4FH+PTOiJoIHop4JNsVq+EnLhKaMOvjQB69btoTsVAlYirTtFI3bGnk73TZWNGNJazPBmRHJUJFMfy0jWi5mGe17PmXwjz2R+p2VYXkI0b8Lt7Kw0xxj13V0RAJg2hKlHAILyOs32cGX/cc1+VBJ/miLSuTilnR7GRX3HAzpCSdYyd5mzTuf826ZC2XJ+HKfFpy/yAWnfjcpvru0ecd0PvClt/IyudLqu2zG8WyWcnGUEGRAEKx2tfcPC0Fr0mDIGHnwX0ekSNONtBJLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(8676002)(508600001)(66946007)(186003)(6506007)(66476007)(5660300002)(4326008)(2906002)(86362001)(66556008)(36756003)(1076003)(316002)(2616005)(26005)(83380400001)(6486002)(38100700002)(15650500001)(52116002)(6666004)(8936002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sf4hHLitOt982tI27ftdcvFJ6ztbi9ZPGSrfnZCNA1+lCiB0GsNc2fFvdn0Z?=
 =?us-ascii?Q?OAehGKAXEJbT6U/i1NaioqreAL0gO3ZE2Wt9QC4+lZCRzBjxq4QqRKy+EEN2?=
 =?us-ascii?Q?9jb7LOgnf4xZICQOP7wRpVkYV1gZXPDvwv5b2TBLe63symDce+BZKpNvie/n?=
 =?us-ascii?Q?gJfygZBptsOx7Gmdq7PLJpkSLM8Ipce5cl5VSb9ZXdxs5CbxhRm2ipi5ffN7?=
 =?us-ascii?Q?Juf6VRgA//DRbofgUGrLGS3UqmKTBtXzPwnbOH9BZ9HKlMh0vkqs/K4wAIta?=
 =?us-ascii?Q?ipYG/pfmgn3RhBYKJel+CDLKvoQYFcFcbViS9qNk3VVMK+Y2TEnvaFqMEszU?=
 =?us-ascii?Q?jbrSezTnkoL4MLqxBMRwVBOPuE0L7NeunAgDczI4WXppQiGw5AbCJHvSTzWS?=
 =?us-ascii?Q?2yYO6PorceZ0kLVXDex/r9qNMWARoOSlZpa/17k9vkxNxVzSmQ3aRR0lrOJB?=
 =?us-ascii?Q?O1JysJArrCMU3u1yST7hcbpBFkUvBEhv6SwWGCUvEAFQLKnheI8qUkL546si?=
 =?us-ascii?Q?gV/hYuoBoTag7vHTnIZ2VqzbSZa1ZjRsj6wfzV44v+818yejS7HD1x7cHPhu?=
 =?us-ascii?Q?YWaigBcIQ1TUrEeunHkuDzSKcvXaNLrNt2+xccqwS5erpSeKzpkkqg2TjO1r?=
 =?us-ascii?Q?QffXR/6wNqusKxYHC4JX3XSqWLE9QozwNWL2MfWsJHWdiRMTv1HMRA5stm08?=
 =?us-ascii?Q?qxXGXhdNkOGLCDhoZkGhLG5Y4Nb58RHSxyvueQQ87/gi54BDNH2hRzmM76XX?=
 =?us-ascii?Q?xGKYx/4QGm80C4bTN16wlpQk/PTqC0vRWRLHfFXUGvteKBXgoIkb/HVyNjRI?=
 =?us-ascii?Q?2WWSqFW//O9ROR5bPv9pIp0lfPDmF2iS+73l4sgARAFfgLX+rEbh4kpTJDmu?=
 =?us-ascii?Q?FO3VuQ4rPxhKTe+Yobouq6TQRa0Gyc1zLQDw3IRa5g9EUMm06lMwA2A7a78J?=
 =?us-ascii?Q?Q5y4bSh40Q97WOrMbepE1mGHabkY8zZKROgRC2spWi1GbrdAa1dA1lItG9Zm?=
 =?us-ascii?Q?03Lja9qIvE1Za3J1gL6JHpB5u29gf9CjYoBiMYFjgIIOATDTru9Y5BjnF1/l?=
 =?us-ascii?Q?Jbo8ri082aP00+R8TS9vLMyIT3i6zkZAikyWMmAE+fYndNG8AeeMQkZd1yB8?=
 =?us-ascii?Q?pBP32mWjxSZRabycc0B+XS2q6wof2t5I8IVCfXF7QuOyx1u8v9wZjrpJ6pPY?=
 =?us-ascii?Q?3cIXhUkLltUZZLW8EjmtzJ+So0b5Zw6BE9WHxbFPCRIiPt8GqhVdvI1eOlXR?=
 =?us-ascii?Q?xdfyeGOTUavmZtRPFCWfRTaGvim3jUapprUgCGfUgZZNulKd8Gs+XnSkj5lJ?=
 =?us-ascii?Q?uyB9pgTYIS66nCIU/q5EOEWpuK/AAaju2wnamVhn5hvDR/HPgyEn1vOB7leW?=
 =?us-ascii?Q?mT2torKlYmpJs8feBhT5Z2mw5tOdPUchqdADwJ06c3qC2pAPXndKFee0w5zW?=
 =?us-ascii?Q?mGUt1nSZ80enW3AVtWanWbcp/vr6S6rhBpbNCXT1iOxn++Fn8L602DBRMz4j?=
 =?us-ascii?Q?fSyIsdwr0Ys4JPlUoOyTv3Ag6t5+KZIz0+1Ry2AwJuu8KmmXK8w0WA8kaHjD?=
 =?us-ascii?Q?hCFMFkB1pOyB8scQ4n1h8EHU28nNPUSL8roCDIAczMJLlSo1VjrZ2puCqmUf?=
 =?us-ascii?Q?/d6L+wQVkNbspaq8ccPUJD2hQhsyRY+IuykaTfuUGrJPtCSBalm5EffaRL1Q?=
 =?us-ascii?Q?TKFPQg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb54cbc-78c5-47bb-b099-08d9f31c5e82
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:22:22.1455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0b28op/d60Zto1EGLkNv/cwFRfNo7IHspFilUL0kANQhzD9u3IH/xuKsBRRBPTPYBJdvFzHfmyg3DroFSg3O1aauLo/6G5rIPvFMqAxElvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4378
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
Changes in v2:
 - move global function pointer into the driver's private structure in 2/2
 - move repetitive code outside the body of the callback functions  in 2/2
 - update function dpaa2_ptp_onestep_reg_update_method  and remove goto
   statement from non error path in 2/2
Changes in v3:
 - remove static storage class specifier from within the structure in 2/2

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 89 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 14 ++-
 2 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index c4a48e6f1758..aab11d5da062 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -35,6 +35,75 @@ MODULE_DESCRIPTION("Freescale DPAA2 Ethernet Driver");
 struct ptp_qoriq *dpaa2_ptp;
 EXPORT_SYMBOL(dpaa2_ptp);
 
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
+	cfg.en = 1;
+	cfg.ch_update = udp;
+	cfg.offset = offset;
+	cfg.peer_delay = 0;
+
+	if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token, &cfg))
+		WARN_ONCE(1, "Failed to set single step register");
+}
+
+static void dpaa2_update_ptp_onestep_direct(struct dpaa2_eth_priv *priv,
+					    u32 offset, u8 udp)
+{
+	u32 val = 0;
+
+	val = DPAA2_PTP_SINGLE_STEP_ENABLE |
+	       DPAA2_PTP_SINGLE_CORRECTION_OFF(offset);
+
+	if (udp)
+		val |= DPAA2_PTP_SINGLE_STEP_CH;
+
+	if (priv->onestep_reg_base)
+		writel(val, priv->onestep_reg_base);
+}
+
+static void dpaa2_ptp_onestep_reg_update_method(struct dpaa2_eth_priv *priv)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpni_single_step_cfg ptp_cfg;
+
+	priv->dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_indirect;
+
+	if (!(priv->features & DPAA2_ETH_FEATURE_ONESTEP_CFG_DIRECT))
+		return;
+
+	if (dpni_get_single_step_cfg(priv->mc_io, 0,
+				     priv->mc_token, &ptp_cfg)) {
+		dev_err(dev, "dpni_get_single_step_cfg cannot retrieve onestep reg, falling back to indirect update\n");
+		return;
+	}
+
+	if (!ptp_cfg.ptp_onestep_reg_base) {
+		dev_err(dev, "1588 onestep reg not available, falling back to indirect update\n");
+		return;
+	}
+
+	priv->onestep_reg_base = ioremap(ptp_cfg.ptp_onestep_reg_base,
+					 sizeof(u32));
+	if (!priv->onestep_reg_base) {
+		dev_err(dev, "1588 onestep reg cannot be mapped, falling back to indirect update\n");
+		return;
+	}
+
+	priv->dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_direct;
+}
+
 static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
 				dma_addr_t iova_addr)
 {
@@ -696,7 +765,6 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 				       struct sk_buff *skb)
 {
 	struct ptp_tstamp origin_timestamp;
-	struct dpni_single_step_cfg cfg;
 	u8 msgtype, twostep, udp;
 	struct dpaa2_faead *faead;
 	struct dpaa2_fas *fas;
@@ -750,14 +818,12 @@ static void dpaa2_eth_enable_tx_tstamp(struct dpaa2_eth_priv *priv,
 			htonl(origin_timestamp.sec_lsb);
 		*(__be32 *)(data + offset2 + 6) = htonl(origin_timestamp.nsec);
 
-		cfg.en = 1;
-		cfg.ch_update = udp;
-		cfg.offset = offset1;
-		cfg.peer_delay = 0;
+		if (priv->ptp_correction_off == offset1)
+			return;
+
+		priv->dpaa2_set_onestep_params_cb(priv, offset1, udp);
+		priv->ptp_correction_off = offset1;
 
-		if (dpni_set_single_step_cfg(priv->mc_io, 0, priv->mc_token,
-					     &cfg))
-			WARN_ONCE(1, "Failed to set single step register");
 	}
 }
 
@@ -2407,6 +2473,9 @@ static int dpaa2_eth_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
 	}
 
+	if (priv->tx_tstamp_type == HWTSTAMP_TX_ONESTEP_SYNC)
+		dpaa2_ptp_onestep_reg_update_method(priv);
+
 	return copy_to_user(rq->ifr_data, &config, sizeof(config)) ?
 			-EFAULT : 0;
 }
@@ -4300,6 +4369,8 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 		return err;
 	}
 
+	dpaa2_eth_detect_features(priv);
+
 	/* Capabilities listing */
 	supported |= IFF_LIVE_ADDR_CHANGE;
 
@@ -4758,6 +4829,8 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	dpaa2_eth_free_dpbp(priv);
 	dpaa2_eth_free_dpio(priv);
 	dpaa2_eth_free_dpni(priv);
+	if (priv->onestep_reg_base)
+		iounmap(priv->onestep_reg_base);
 
 	fsl_mc_portal_free(priv->mc_io);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index b79831cd1a94..447718483ef4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -526,12 +526,15 @@ struct dpaa2_eth_priv {
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
+	void (*dpaa2_set_onestep_params_cb)(struct dpaa2_eth_priv *priv,
+					    u32 offset, u8 udp);
 	struct fsl_mc_device *dpbp_dev;
 	u16 rx_buf_size;
 	u16 bpid;
@@ -673,6 +676,13 @@ enum dpaa2_eth_rx_dist {
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

