Return-Path: <netdev+bounces-11467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2167332B6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0744D2813CE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1DC1ACA5;
	Fri, 16 Jun 2023 13:55:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3AD15484
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:55:24 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E3C3C06;
	Fri, 16 Jun 2023 06:54:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHOHSGgEiFzVYAuLx2Yl4D49M3ViWtzP7J9dZr+FVZw9iClM8tXkNGoinmENwKXuWMdyMXxCk6FRf7MPVr5mLdiEr3KT2KGhbpzXa6+zTgVlElLZ3MxBWqF5Ounw3czP9UihUMugH5as4ROJqWaG68sZuksZGkew7XGLhHA9iz5CYppf13ZYtYwMNo7K+TwpqFe0M2jVpB2cJGpvt5FV7zsJ8HSuMF9SojI99ZhnDuPCH2jt44YMExi8jjY97zfOpqom9B87zUbHa9z7gtYIwr7rVo8RTWS6etXYHzu/jThcPkAqW8aFz1QUR+oF9wHky5UCFytK9jwCpNeAfSb1Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dWptkUDrne1LC9NMWLBTCBsdbu4JEDTyP8oIm1moysE=;
 b=G9MCm2wreIaSHVRIa3gHUdIPNvULVNB6gNq3tilv83yb9YbmsjVwVEKTCqqmdCqPq+1/hK/QmCNDuaJ7G/nOraRTVmG1AWI1Mf12gGTU+SGmpJQzou+6Dm2D6jfTg7zSp2FXhEZzbnRxBimrzyNzTB5+JOu+57k0WYZdTUTeWeZ1rDKrioK5daXV8ic3iySVu1+g+538+du9rmplaM5xq7MUjPDhR99afnN0OON4ZRIQF0GQjmfE5QFM1jZ+Rk6i0VR/ooeTiTXKJ6a8pTg92KAe3qsDB5mVg2DaWC78jqVTtwFn+mEQZz40fm3XOBsk4zuRufev+8kBjblxuAygTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dWptkUDrne1LC9NMWLBTCBsdbu4JEDTyP8oIm1moysE=;
 b=lC7hSTlvQpHzcLXo6GQJcYck2I6QaEBVSjiHNs/WMAFvvONhpv3N8LxVc4ip8Npwc3S2ZRBeryMT9jtH+/mZveXRMfAgI58tGY1TN1A7dQ7UDeJqVUZaAU2wP/l7bCy49e8jsKuN2sG4PsvVshc/C4ujbDYxfZf6sMNhZeco+es=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:07 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:07 +0000
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
Subject: [PATCH net-next v1 14/14] net: phy: nxp-c45-tja11xx: timestamp reading workaround for TJA1120
Date: Fri, 16 Jun 2023 16:53:23 +0300
Message-Id: <20230616135323.98215-15-radu-nicolae.pirea@oss.nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: f545938a-567e-47e2-df6a-08db6e712743
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f863TDCPBPYYcP+JzqXShrqE/YWYqHD3VE1VobNwE7ykFw7h1McSc75xKAFZ6zqLvj22bQD2eMye+9Iwq+/T02KxpQa4ZEKiySu0dvO3uhDDQyOLHiwWHs9IgyY34fyMvbZQXKHJB216WMTNJq0HENoEtO+f350rdGnItjWqP72TD+LtvqHpV6Fxml1EtTcQ5JqrDu/av8AH7d0qmNH9c8jCRBUJbvEgzLelEr+pElOjYySXkIR1m4oO6taK7SpqCQxr9JpoD9szIy2IdxNjlR6dGxOLBKfKxRP/ca6IXGj+SQ7YXt0q5dFy9WLw2RHm/N2WrYejNvHFFCym7bCm5eECptc4U2GtAEMTAcDXWDi4y3IyAws1Gev3MxkWkZcUtFwM3tE2NfpmrR7XOt90DytPWkmysralE0MXU+O+eRwgSEemIF+TOe1Iq9OtBTjuFbLe545oh3N+m9mJqaMcRA/bF9cVBhfWeQj+Ryf8FrYUh+92AuKpA/pY4Xg5lqlsN6KgssdPyml7vQIoL904X8EYB3KjLjmcFRp2hlWmlyjzvYNDxpKAEeRbK7O2kFmhT9nQLpO+aNTOWCFm1ID/6QIwr9lixFkZBMTb/La4/Ek=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(83380400001)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ab53qSFngt7v/Ps13www38+RjTz4vtyKkcAibnlCh/j459x4jEP+XepVOeeb?=
 =?us-ascii?Q?iDnZiFwbVv+jRUtvfWJSWuVyMCWJpJk97CHZRi1qt2KiYTN7I3n3FV6lNLN6?=
 =?us-ascii?Q?9/7D2kQ+sTcLxd9wzCO6bYFHrPp1Zxt/7LDjGtWcRDqvUI7FDwMr8tFA7A/B?=
 =?us-ascii?Q?CDsz/yJ8nXMJgLId+3zQ8exn2xvdFpwSnJrhxy0lN7skDMOIwLydU/8J1CLD?=
 =?us-ascii?Q?sHAlwm4bGuZdTOZO7VMpzXCxPYTv0dUnjdIQfjbrWHZHzFhY6wZIiZlW3bRX?=
 =?us-ascii?Q?jSv2vcj1dAKtPRmypFQxTJJdgBNZrVpLcFP7FrSh3kUJ8fpwWCkNYrmFifqW?=
 =?us-ascii?Q?IvFIDjHu9K5xP/i8NYtqWv30onOL/CUqn9yyKJ/Oi5fKTcJlqmLUjba7vqXp?=
 =?us-ascii?Q?WpqbkpCgPtT0W0Q66cWKNQbdIShxDYiD5dbrjBP1/uVGfRAc1Zm4qW7jUDcR?=
 =?us-ascii?Q?5Nc9DK4HvW0WkqF6FTkxhT9oIBYcJRe4DJ9BEjAE7vTPTgbzJ0Cy4lrn+4fT?=
 =?us-ascii?Q?fkl0mJXdUGFbklyDLufsrgxlh5KiW4n8eVqnO5jCkuleFy+fFYyqOHRiJPqt?=
 =?us-ascii?Q?dIpfo3eydcKhDTl1YaSCjktkOs9poZWcAY154Oz1af6y3MM/KWahX6CdDCAE?=
 =?us-ascii?Q?DgHuWw+XRtTOfYwr+lnljRvVWEP7gH1a9k0hbDkbKAbtd9MQX11DmaDobuSu?=
 =?us-ascii?Q?eOxXBKIIyh30bPHjGaZJ7GQhRRuqX8w+XVDGYTpdmA2fUgn4f+FnCBTEDVD9?=
 =?us-ascii?Q?PuO3t9oUZWqJ8DIePR4vaiZioypkNseWwkFs7+wcJ2U4Tyiqnl1pvg9oJ2vf?=
 =?us-ascii?Q?9EF1Hm8h9qlK31w0kgHnTT7y4+ogY9iO5QPcvp9nAoPHq4yVhAXNuFwS5L4+?=
 =?us-ascii?Q?kIOeg7UTOYxfca3gtJ1K1axm0orMTuI2KayIjAyoEPL+pXQwSCV1tp8ijj3b?=
 =?us-ascii?Q?VrYfH2k5y5l9sJtrBNxbClwSKXSEysFqSsNAd1MpNp6Km7cQxXUPeuuTENzU?=
 =?us-ascii?Q?1vulE7vCed0/pbFd5R/FSUN+BuRYmF0IZUTSzJBSjs0eleciAxsgYglh4oUQ?=
 =?us-ascii?Q?qyX1N6lEzqFH3ddsy9f/Q5DvufCsQrvjlIFPWQrvW1gecmsk69Ru8eG2mipd?=
 =?us-ascii?Q?HvmnLaqgIMFyZYPMpuncSckJdeqgD6+77XsPuktA+CHzNxXvibg3dN/KVxvS?=
 =?us-ascii?Q?ttCdVX4r0y4evE92DiR69ONu3OgJJrvZ0AtQUVPNhAYWr0SH+Lg5pVu0xd5r?=
 =?us-ascii?Q?MHuxpJzd/Km3Q9TBHDXTF79ndR9u2Kl2yNac0A6dDak9B02WyPMrqPAiEpht?=
 =?us-ascii?Q?DKcmy5HdNFGGDH8OnFA07ZKISyeFIyasMwILpIfi3RRF7lzx1FBiZZGP0gD8?=
 =?us-ascii?Q?7wq9HerumFOnqFXKUjXZidyuX5QbO+CqnEUoR6yyLj3w86z1mAROSL362a+e?=
 =?us-ascii?Q?pdUBD8FBeU6RqDk7M6u+WZa1LKP8G/7acnYttdsnjWG1h9I0istcG1TZAQn7?=
 =?us-ascii?Q?1lPV8WnQc0YtnZeax41RZEXYkGGnkiIlWPgUwhGb/sduV3d1GsgpmYdY1r6Z?=
 =?us-ascii?Q?J+PlUSuDfle6yyMJU/0hIkSyE2dg3QV6qVEBJO0Mn6RLtflG8x36TKDACFMa?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f545938a-567e-47e2-df6a-08db6e712743
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:07.3572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwGT0z5l8Y0Z7iXJapvOt+p8eH6RssiQ4AYfgRgqrKUCTAFQdyKLsGDcm3HwBNUlOEwjeefWHCb2RNYNC2gTeGWk4fEOF/gBZZwmRquWTGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On TJA1120 engineering samples, the new timestamp is stuck in the FIFO.
If the MORE_TS bit is set and the VALID bit is not set, we know that we
have a timestamp in the FIFO but not in the buffer.

To move the new timestamp in the buffer registers, the current
timestamp(which is invalid) is unlocked by writing any of the buffer
registers.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 0d22eb7534dc..3543c8fe099c 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -532,15 +532,30 @@ static bool nxp_c45_get_extts(struct nxp_c45_phy *priv,
 static bool tja1120_get_extts(struct nxp_c45_phy *priv,
 			      struct timespec64 *extts)
 {
+	const struct nxp_c45_regmap *regmap = nxp_c45_get_regmap(priv->phydev);
+	bool more_ts;
 	bool valid;
 	u16 reg;
 
+	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
+			   regmap->vend1_ext_trg_ctrl);
+	more_ts = !!(reg & TJA1120_MORE_TS);
+
 	reg = phy_read_mmd(priv->phydev, MDIO_MMD_VEND1,
 			   TJA1120_VEND1_PTP_TRIG_DATA_S);
 	valid = !!(reg & TJA1120_TS_VALID);
 	if (valid)
 		return nxp_c45_get_extts(priv, extts);
 
+	/* Bug workaround for TJA1120 enegineering samples: move the new
+	 * timestamp from the FIFO to the buffer.
+	 */
+	if (more_ts) {
+		phy_write_mmd(priv->phydev, MDIO_MMD_VEND1,
+			      regmap->vend1_ext_trg_ctrl, RING_DONE);
+		return nxp_c45_get_extts(priv, extts);
+	}
+
 	return valid;
 }
 
@@ -588,15 +603,25 @@ static bool tja1120_get_hwtxts(struct nxp_c45_phy *priv,
 			       struct nxp_c45_hwts *hwts)
 {
 	struct phy_device *phydev = priv->phydev;
+	bool more_ts;
 	bool valid;
 	u16 reg;
 
 	mutex_lock(&priv->ptp_lock);
+	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_END);
+	more_ts = !!(reg & TJA1120_MORE_TS);
 	reg = phy_read_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_DATA_S);
 	valid = !!(reg & TJA1120_TS_VALID);
-	if (!valid)
-		goto tja1120_get_hwtxts_out;
-
+	if (!valid) {
+		if (!more_ts)
+			goto tja1120_get_hwtxts_out;
+		/* Bug workaround for TJA1120 enegineering samples: move the
+		 * new timestamp from the FIFO to the buffer.
+		 */
+		phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+				   TJA1120_EGRESS_TS_END, TJA1120_TS_VALID);
+		valid = true;
+	}
 	nxp_c45_read_egress_ts(priv, hwts);
 	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, TJA1120_EGRESS_TS_DATA_S,
 			   TJA1120_TS_VALID);
-- 
2.34.1


