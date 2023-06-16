Return-Path: <netdev+bounces-11465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9BBB7332B2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1693A1C20FE2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE9E19BDF;
	Fri, 16 Jun 2023 13:54:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8626019E40
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:54 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAE330E0;
	Fri, 16 Jun 2023 06:54:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3Pw828RR3Bhq4dNAk4wHNS1RKTXijffXaKq2MbVe6ZF715+QiLE5FkGxq9L4J7koKYJhJ8Dr++hk7d+1lRZzvZ3/WRgwE4e90iX8wLqyXjF4N94PCCumYQcP/aQ9Kv4OIaWmB7oBI4eTRR8nNE2Nzf6kw/hyIqtRDED987t8mDrBuR1LRrUHfZEIpOkL0FLcvqsMjWXUAyhdfXcvXy075XeIbzH6EJZ6//1yds94jvC3ptEZOLtevLmK00E8gXi8LX4Go+Tmi0peBg6VQlBeoDKRvcx0UDIdsg09HGfyu4uR9/keyB7vH8jnFsLBLIIH5Ga9RhT+iVX+9JtwQPrBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkZjJZsGorK0DyRGO1pqdg26usTUhJ5nrc4AjJOOIVE=;
 b=ZClrJoSZxUPJP/TStItpF4jBAhyRE5vDg/kVekbnKwbG8Nqe75g3gMDwNkcK6ujlSIxxOFDsrFqUM8RFkoV9vCAiFtqYvuA5AkskY4nsnsEFP2Vr9dpwUDQ55/vd8uv7Shs1awMY0sHkMmFQ1OUF+Lxo/Qe0Ox/PZMjYGfCV+my7dD9bWTbE6wzb0Y8R5MDfV9DvYFah553MYBiRTgFve3GJACyNNEj6xfv1R94NeMLY1O/SbFMFc1N3QEu/bpnJ+cBjSJGXpbR333ka3pieysNUwm8vOm0iyTJtNVhP9VTqLCoLxrwjpCfb32xpayMft+jfBFOoEI5n07vbt6A7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkZjJZsGorK0DyRGO1pqdg26usTUhJ5nrc4AjJOOIVE=;
 b=K2hTI1oTeKY9DrDBeEMSXUyiJlnSiZ0YGWu11xCN7Px95bbN8n2ArUWS2kx5sPpOscU+dn7Dn+za/Q1dR2bevHOZONFt8oSZuwRVcCWZnUrifMYJotb80B3PuP7MbUkR+PQSpN3uq9bY2YQTIve4noRirfrOQJJUFrp7yEfuQKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:05 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:05 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 12/14] net: phy: nxp-c45-tja11xx: read ext trig ts TJA1120
Date: Fri, 16 Jun 2023 16:53:21 +0300
Message-Id: <20230616135323.98215-13-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c256250-ce72-4a70-1ded-08db6e712634
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YSVfGDQNKOXMR6eNlp+NbtPMunL9FBu9pKZT2PhBdLqY5Znk2tNYLe7gioSjD2lOm5OtCA+kXMqwqZnQePMXoyr07wE9u1UK7JbEtT6+VuaqYHz60CpN6C0vw8ibvQS/OiPFOJIwZ9jXYklM+ytXZriYaxledDBvyytVZIm2MSHXJaCUf72Zh4IPQwz5To8l3ajrpBlWcseIxuBauKQJ4Hj8Y+dX3+e5cdKfhR615HJFN5NNAg6c5baaUeKjPK4p33w1FwtxYkUezgQG/vHBEmerTm6xil3qwvGfWEc5iEExohSf+cgpq4dGrNFdyjT4UR3+H38YaZNWZsljmK9+xeBBWRJLlUpM+ThFoQPxc8/OsDRfLLNuakBYD68iiZ3nr4CnQ5v6N9WyGpALCjOUsVDJLlRq60Wh7QQaGyLbl71svsqynDvSP5pEIs96Tz3ILHZ+g2/kst1tsE62aNVH6n7sBhrfL4MD3iHjdGK9Y6tONXk7V2wemb+mn9W5a1PZK7KPu/MGFiErQCvF5pxEIAcapr2otuPHbKjq49mBbIZD44BULMV/d1/avMlxDpVArKdcANYf/8onyQNNLPEAuQh54NCC9bsjQWDrmMZvXpOlVYoj6era851ABhEU+dU8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0KyLpFV2V70rB/V371jIJbnH6wzjQ9e8+LebVHLyww2DYYbdn1x2EJcSFsDr?=
 =?us-ascii?Q?Qln4W1z0jGf2Mu1tfJt0MjlwgDv1X54l8hiRThPzR2Pj3pHjSptFNA9RO4FD?=
 =?us-ascii?Q?3bd7lc+i4Tt2kKCrt+itSGokcbeZiGoDzV66L1E518lE2T/OI2bs4NVc37in?=
 =?us-ascii?Q?Q2/gYVrQglzSGAMjLwSRF7b+SEvSkZ8NGKkZbkkdwnWSPioEZRgWp58/qjT/?=
 =?us-ascii?Q?eCyzqroabbXVeLOOsZHb/yffBNLYltJ95343oz5axIM6LDbVIMEO+N/KTyCd?=
 =?us-ascii?Q?Zur3lZ2ejxncQHQIfGtiuYdwevyZBAkjtN6Ri4AQIwnHBgKM0uj5voErzaFS?=
 =?us-ascii?Q?2uh8o83edq52tlJTqQkc+019W1sb4rkvGuv/rZ/Pp3vKh0LiYK1/UL3aS/tQ?=
 =?us-ascii?Q?arjG6KC2in2Zgvn21BQ3UW871C9ItNXFWhBCs9JWfXR1v3bAbyxYAkR/WZXO?=
 =?us-ascii?Q?0s4Ads6LlJZBqEChiuYwB3VQXrlHActTKUNPYrnYYMGeSzNpypHksiTL9LOf?=
 =?us-ascii?Q?3QPEMxu0F8jGjnPc4oR8K1436J0cvGFE1JR0nPD3dKNc/x8M7KqNMPtMf3gW?=
 =?us-ascii?Q?F/2dB0axn3mhcYfgPsjEZ63wUjRxvmxVsOGRep/MRs5q+0qMUfhUr6Pckctd?=
 =?us-ascii?Q?QyI9hgrmxiH02ZSApg1O8GsDr/WA7LnH+YsEU52WM0H0tCzAkfd/Qz42aW9h?=
 =?us-ascii?Q?5RFVxy6ZumgMx4PSiyPNo4THElS5sKyu7a5X5SQ/zKJEjF+93MQ9R3q845/8?=
 =?us-ascii?Q?SSwgyLeNOnTjFtE440l3TAS3l8zRoNTh2RUw0+H1DE40uh5T9RAQCD2dLQ3p?=
 =?us-ascii?Q?mdvhVT40x2sFdHps7ui5MdswsysYK63A/qUukD1Ku5pneGfV/qkKPFfmBr/4?=
 =?us-ascii?Q?GLIio19nku2tlx+rSdUH2TMu3Ezdzxw78L7CQ2LSTtR/6lCZptR6Bx+1vMCO?=
 =?us-ascii?Q?MSgvNVxGklulvxE/vbBM1BKGaEi3/jl0BDZIzFjpM9lyG8pgmQ2H6dbK0v9u?=
 =?us-ascii?Q?MksWSDg3tIRKgvZop/jY/4I/wZCZYVhAnwyWC8SvdZxTsuZCtZGQCVBRWkBC?=
 =?us-ascii?Q?Lz9gjcv0bid6O9wCbEiqwj5JWB1SR1nOuwbSuHNKjOZfPoharI4tEUZjIMYM?=
 =?us-ascii?Q?P66rjbSoU59+V26p/DRVHRiSH1NNCyIiI8EGgvVUhhT/WclvPXfAw4o+JxTF?=
 =?us-ascii?Q?uBvmN8ltnk9mJv/FUcGt9v0ytcdq8bYXtxac4Z16pTkIRLUJDLnI3YpIkgcK?=
 =?us-ascii?Q?Va3fpwMKL6fszUmHj4w6XIWSeS6EMe0QGqk4/4i6XgDButApfrxI7EcIW/cD?=
 =?us-ascii?Q?iSgTYIB52Mh3J/tSbcnTOI23k4T1PNjtrbrW/6ri83d/pMCd1sbRWADQLynd?=
 =?us-ascii?Q?DDJ2yhNQ4YatMTYj12QguTTnmCUQEBNbtQRjA3W0avXYFNQIes8LJWnF66pW?=
 =?us-ascii?Q?WPd5PwmU60glz7CiKJyCaeJe+svNZu2URB8uEHzVHbNHg4uCK9D+Q5uoKPH6?=
 =?us-ascii?Q?5clbbr8FMAWyRfoVrnSy5zWpA9wcJj0qW3ZjMZ83g+FHpMRZuBAZh43a0pGr?=
 =?us-ascii?Q?3JTBOHlazlZhlbicC8i++WTEu+lDysSYr+aNSdJe/wgbg8ALh6/bMN5hUDbr?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c256250-ce72-4a70-1ded-08db6e712634
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:05.5996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKRuxZgJML+ZpTMDVpjQLiwccmUVOscIHeHTWsEhLrZsM9OmbNwrhEBbqwauduXKBvG8DAeh+Vye1H1obzJct402NtFVWCx1tHKgtZX1C0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On TJA1120, the external trigger timestamp now has a VALID bit. This
changes the logic and we can't use the TJA1103 procedure.

For TJA1103, we can always read a valid timestamp from the registers,
compare the new timestamp with the old timestamp and, if they are not the
same, an event occurred. This logic cannot be applied for TJA1120 because
the timestamp is 0 if the VALID bit is not set.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 36 +++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 4b40be45c955..0ed96d696bad 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -34,6 +34,8 @@
 #define TJA1120_GLOBAL_INFRA_IRQ_STATUS	0x2C0C
 #define TJA1120_DEV_BOOT_DONE		BIT(1)
 
+#define TJA1120_VEND1_PTP_TRIG_DATA_S	0x1070
+
 #define TJA1120_EGRESS_TS_DATA_S	0x9060
 #define TJA1120_EGRESS_TS_END		0x9067
 #define TJA1120_TS_VALID		BIT(0)
@@ -268,6 +270,7 @@ struct nxp_c45_phy_data {
 	void (*counters_enable)(struct phy_device *phydev);
 	bool (*get_egressts)(struct nxp_c45_phy *priv,
 			     struct nxp_c45_hwts *hwts);
+	bool (*get_extts)(struct nxp_c45_phy *priv, struct timespec64 *extts);
 	void (*ptp_init)(struct phy_device *phydev);
 	void (*ptp_enable)(struct phy_device *phydev, bool enable);
 	void (*nmi_handler)(struct phy_device *phydev,
@@ -504,7 +507,7 @@ static bool nxp_c45_match_ts(struct ptp_header *header,
 	       header->domain_number  == hwts->domain_number;
 }
 
-static void nxp_c45_get_extts(struct nxp_c45_phy *priv,
+static bool nxp_c45_get_extts(struct nxp_c45_phy *priv,
 			      struct timespec64 *extts)
 {
 	const struct nxp_c45_regmap *regmap = nxp_c45_get_regmap(priv->phydev);
@@ -519,6 +522,23 @@ static void nxp_c45_get_extts(struct nxp_c45_phy *priv,
 				      regmap->vend1_ext_trg_data_3) << 16;
 	phy_write_mmd(priv->phydev, MDIO_MMD_VEND1,
 		      regmap->vend1_ext_trg_ctrl, RING_DONE);
+
+	return true;
+}
+
+static bool tja1120_get_extts(struct nxp_c45_phy *priv,
+			      struct timespec64 *extts)
+{
+	bool valid;
+	u16 reg;
+
+	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+			   TJA1120_VEND1_PTP_TRIG_DATA_S);
+	valid = !!(reg & TJA1120_TS_VALID);
+	if (valid)
+		return nxp_c45_get_extts(priv, extts);
+
+	return valid;
 }
 
 static void nxp_c45_read_egress_ts(struct nxp_c45_phy *priv,
@@ -628,12 +648,12 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 	bool reschedule = false;
 	struct timespec64 ts;
 	struct sk_buff *skb;
-	bool txts_valid;
+	bool ts_valid;
 	u32 ts_raw;
 
 	while (!skb_queue_empty_lockless(&priv->tx_queue) && poll_txts) {
-		txts_valid = data->get_egressts(priv, &hwts);
-		if (unlikely(!txts_valid)) {
+		ts_valid = data->get_egressts(priv, &hwts);
+		if (unlikely(!ts_valid)) {
 			/* Still more skbs in the queue */
 			reschedule = true;
 			break;
@@ -654,9 +674,9 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
 		netif_rx(skb);
 	}
 
-	if (priv->extts) {
-		nxp_c45_get_extts(priv, &ts);
-		if (timespec64_compare(&ts, &priv->extts_ts) != 0) {
+	if (priv->extts && data->get_extts) {
+		ts_valid = data->get_extts(priv, &ts);
+		if (ts_valid && timespec64_compare(&ts, &priv->extts_ts) != 0) {
 			priv->extts_ts = ts;
 			event.index = priv->extts_index;
 			event.type = PTP_CLOCK_EXTTS;
@@ -1702,6 +1722,7 @@ static const struct nxp_c45_phy_data tja1103_phy_data = {
 	.ack_ptp_irq = false,
 	.counters_enable = tja1103_counters_enable,
 	.get_egressts = nxp_c45_get_hwtxts,
+	.get_extts = nxp_c45_get_extts,
 	.ptp_init = tja1103_ptp_init,
 	.ptp_enable = tja1103_ptp_enable,
 	.nmi_handler = tja1103_nmi_handler,
@@ -1816,6 +1837,7 @@ static const struct nxp_c45_phy_data tja1120_phy_data = {
 	.ack_ptp_irq = true,
 	.counters_enable = tja1120_counters_enable,
 	.get_egressts = tja1120_get_hwtxts,
+	.get_extts = tja1120_get_extts,
 	.ptp_init = tja1120_ptp_init,
 	.ptp_enable = tja1120_ptp_enable,
 	.nmi_handler = tja1120_nmi_handler,
-- 
2.34.1


