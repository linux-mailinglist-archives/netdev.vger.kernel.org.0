Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AF0576996
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiGOWER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiGOWD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:26 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70080.outbound.protection.outlook.com [40.107.7.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABCD8BAA6;
        Fri, 15 Jul 2022 15:01:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WILG1q3JjRwHMNo86w2BqDWtP7iZMErFI/80lBKOYUCSEkTLeS2GCLqSN0H1fuWUk9G6v476FmaIgY2JycobCt3ksZwrP4FnJYXsvdeCxOgbl0GHgHbcyuicdvg/D2sbHxV6E7Xf/oowdq0SyciDfJaNqXfS4ApKVqxPrfFEj8w3fs4Bbf/jmv0HBSN7ndZUKZCa6UnSKxo268cOsTH2qPh9ffw0rVyBw+KbwUNhMMq76XoyjsKtCYQsxc21FWgJn9c3GyAnhWeSZOhS+2HlGZPqm8LecJGic2c83mPGaE9HRbmQVMBtp6l5sjD8/lDd5norF0tvatA9STuLT5ShGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z92nDiFPrY/SLAPUikzBA56YSrw9Hgp2mCAPGnpbtek=;
 b=UPyTB8apeZcCbqhHrwNnUcL9lLjYURAKrr6CJUmMDWH1VtHQdD+972iyfcFYAO9TJHsTVLSNiyujIH6JHq5x9uDwrTBDR8h3vHjWjQ8Q6s+ysZ2faNPdc0YrFVqFU1HFN72y1WHLVJJc1/pXNSfOZs7eJ0EvT7ThX34MGr/BgjfEGAkMRkajXw2JerPCXdZb1ymX70JmsQFTwqf0fiu8PEy+UKZW2s4LkXSIguIwAR9L0r0i8apDKT47+dCZ1G4Xv4RqNJO4x/9tE3eRnMs2LbIdeArAp7tZTLa4fE/c90QVHkUn8s23QMWvRqgowMZWzI+MLlLn8eDsU7Ed2yWsDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z92nDiFPrY/SLAPUikzBA56YSrw9Hgp2mCAPGnpbtek=;
 b=g8+AfIlmDjwdgjeiviiSQtV6HFMYveCdUtX3jxY1BCIcqSzImTjmQmuqOLcIWtkfwUDuVo5Nnetea+sq5Jrt29eKbCvz9jiERsIv6BtkfKPxQWDNMLJboBf2MgcSUBwbyypiJjC8+uow+yfA+1ktnsxiJA0j3m+QMaDa8WTgfMwpZRzqPuhY958LMnZalCP5EbSwIussbjoYxx5qWQl/kV6JZD/B0ati0ydFmyvQZ6EubPffOs/AXgQrB9KpRHP/ivkeHXN6lnCFBY1ce9H3bngeXqvB6XbnAYd7AUVes3CQCci+fxhN+Qg10TQCsNy9C27Ji18aBbmHiWhVji0vQA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by PR2PR03MB5243.eurprd03.prod.outlook.com (2603:10a6:101:1e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:01:23 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:23 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 31/47] net: fman: Use mac_dev for some params
Date:   Fri, 15 Jul 2022 17:59:38 -0400
Message-Id: <20220715215954.1449214-32-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8951a34c-65ec-46f9-2014-08da66ad8e70
X-MS-TrafficTypeDiagnostic: PR2PR03MB5243:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qWACkbcgOuuoDjOuFzdq0+1EopSt3at1gSv0J0VP6he3eLPKLOhM36So+MUYiz89Mdl/ZmkgTHR31IgKKcPuNq2QSmpcCDsVqFBbZ29rzi6IcM5pixBRaKF8wCEYbWpJDonxsCDSqfTu5TxyZ+6plNVn/Z/S6d0JvRoBP/hvo0cQZ5X52zCUNQu4TdAMKIOAKVF2PhByO7YWavN7w1Se5nDTZUHeYup5NY/FoTZYa/FRj0x4JJRkOHUoyfBd82WAImrfpBh6JWosYA7+hGESrOQIkIyPSAXrqwJmoHVSrqOeegMyMqcu9aWgMyTXKfnschK6pnO95RlqyoablC/qDqRk36pee66oKQJucnKO3qvPYjcHTf/jWh58u7ppvzAjDeXF3iO6M0nlWjfJscwGoWAz2Gg8tVSvB5zexAu7tYZifE06K4VJ8PnT/nnnrR5NuMISvSzrIH2pgGrkig1C3J2J6tPQp0ZUVhKmTeVxgZ4DeRZlPtaFypd7ECxnMwSn0ewFZYphqJONyLzSUMNxWN1VSqUwfQPjnm9LsifdAdNyO6I5OUzj+9oO+bRaoE3M89flEFU10FXmRZCfxHnPebm6NpvxDAq9+VG1Ek69M6lQGXU9CcI1zdAN9ppux3Yef6UQ7negCWHNePbAFOMEEFsDcHboe69SrjQrvRDVssssZNeZgMSY0I6spiqlgfx0aA29EuKpT01GwABG3dPOJOsn1W8wumMHU8GCErHVfE19am0QJc905PzLZojX3cbrk+Z2NNO5S6tR9gENpRsixTMJb2vnLIj8n1YhryCIvoQO7rPbNZdedH1IdHvRTHk1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39850400004)(366004)(376002)(396003)(136003)(6666004)(83380400001)(1076003)(36756003)(107886003)(2616005)(186003)(26005)(41300700001)(44832011)(2906002)(6486002)(5660300002)(54906003)(110136005)(316002)(86362001)(6512007)(66476007)(66946007)(66556008)(8936002)(6506007)(38350700002)(4326008)(38100700002)(52116002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VlYtziPPqyVZMcCSAU8DgpjRJCKCQxd4zuj+GkKqu1tRfIofaBv+S4m+wO+l?=
 =?us-ascii?Q?4OT4hRCtUY1c5booz4kR6QErNNf/ddCVN/QQXxc0jWrnB4hLMgCNB1OQwI01?=
 =?us-ascii?Q?SmMCkrYzgv0KkP6NKhFmARCg2aQGf68nLZNpNF69dWEnjYFmoTi48dcVYwUr?=
 =?us-ascii?Q?9sAo4tOv7/kZH97Zlh7+0bi17hLpvpvZz8qtV0EB68bTMHFmFUSHsApIbPTj?=
 =?us-ascii?Q?4EV+/MlHuv4SXkcQFntwLc7ySfuLKk+ltOg6hfDtLyOnnqUYTTEJtICAQCfg?=
 =?us-ascii?Q?+B+oo/9xSJY5UuK5dMgq74YOxw/h3YML3NxRX4PEeJlurNdExe2rpBAj3BIL?=
 =?us-ascii?Q?2F+1G3q+u1Bj9XJdZWJu1LL5yaMEQnt+OfTi6F7MSAqklUmvo8Td5Leh9jmM?=
 =?us-ascii?Q?a5oQmuQiwksK2MO803eOvC+7/lN+TMConCunN7Xqj92VGDrNwThRlraXwJI3?=
 =?us-ascii?Q?0o1dRFgDyYmZF0xQmSL+yCbSF4F0z6eVsD2myi5K/AjLxBmoCVg8lRIGx+x/?=
 =?us-ascii?Q?L1M1rJdvo1r+nsOv+XmT981WpBezdw2dzfrjIXS6Eg5zOghbc9xlKHrEXiFS?=
 =?us-ascii?Q?4E9/fDWeY3sb5Ebm6Z4vvdTkb1VStEQ1WaC92H4vxjCSfG8Gfj/EeRR9iHAw?=
 =?us-ascii?Q?IQdiwUp1n/g60vpXBsR3nrQ9ZvYfYh6sOMB7gUZ52FDORSHrzf3GwV3DU9Xr?=
 =?us-ascii?Q?tApr6GEeLUQCyAJicbLNsXZ81tuLm97s0P5Cm1km7wcnn/yF0V+Ua4wiFe2P?=
 =?us-ascii?Q?j8IFXvntmQg6KTLuUHLukSJtnr4S9BmNn6+kcRzkMxZWhzTrz7//neJe04Oi?=
 =?us-ascii?Q?OkjqvUkC/d0cgTx157R03ldQj+xXufnuskmiLLo3XBkaWc5Y1VTkyFm1NMvL?=
 =?us-ascii?Q?9iEJWTubcgb9KVgkIjvSbHi+3BuPNx0nlgo+xqsgwFnx3r89bPTKCog0iFIx?=
 =?us-ascii?Q?93AA1r780a6iaEc9EgPU5SfsXcbFBwMVbgflDfhNutDT+LFkYl8xxsFLvz7w?=
 =?us-ascii?Q?ZQFiu+FHUpkCnbOVomxbYwuPmBDgx1Dqr3c3S1n3j7B1kVL4ukrSfUgzFoKI?=
 =?us-ascii?Q?+CGfLBJ7is31icvcdXMsXPXtD3L9Tqk27ftCYM4xtM8czLx7xAXGNfhrNiri?=
 =?us-ascii?Q?XURxiHCt/w5oY591LaLZTkuIzSSLWUERuw2k2m6qe5n0ZoWHUNojAhKzFWnj?=
 =?us-ascii?Q?b8hxAMgQu3pvR7LvPxOI8tXVyoCWlpo2yKANbmgZUIochVcx4ADhVy2DGjzE?=
 =?us-ascii?Q?TB49Vcu3n3L+BDyUPKtx2NJ606oxqEnheUNI3VJRt+Qhrzc3KxELOkpOLQjV?=
 =?us-ascii?Q?DGNmCVxhWINi/8K97AKxtRtR90vtturXQvMmqowsztk3UPUYWsdKnocBeY0P?=
 =?us-ascii?Q?bHiF+jB+SCtWnsByvrhV2UmZ0uYdbKDY1+zJ49lM8J/OKL6vxS/Ge2mTiREh?=
 =?us-ascii?Q?l/312CC1MRo0jqp2HeN6VnwmokBu87YS+sdiK2LLMBh0RToU9lthKTwUD4Yq?=
 =?us-ascii?Q?AU4Qx+pUMEmVh2a6kbP47HdjewTo9DQCs+vGU51O367NvG2T3sPi9/D6QOC3?=
 =?us-ascii?Q?sPQbMyXn5PMKoFSHAcA3/L+B9aAX0jeqbwAo3t7Uk2avnadcEEaLOanP3fI+?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8951a34c-65ec-46f9-2014-08da66ad8e70
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:23.3465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWHGAU7rh7Jb+YNlgra9CB6p+xWy/ShU+BXCeoQkfIVEIDXhYJXr3kSnYErZwIo2pJPy2DhgLfS8egpFDyhF2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2PR03MB5243
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some params are already present in mac_dev. Use them directly instead of
passing them through params.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c    | 16 +++++++---------
 drivers/net/ethernet/freescale/fman/fman_mac.h  |  7 -------
 .../net/ethernet/freescale/fman/fman_memac.c    | 17 ++++++++---------
 drivers/net/ethernet/freescale/fman/fman_tgec.c | 12 +++++-------
 drivers/net/ethernet/freescale/fman/mac.c       | 10 ++--------
 5 files changed, 22 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 9fabb2dfc972..09ad1117005a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1413,13 +1413,11 @@ static int dtsec_free(struct fman_mac *dtsec)
 	return 0;
 }
 
-static struct fman_mac *dtsec_config(struct fman_mac_params *params)
+static struct fman_mac *dtsec_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *dtsec;
 	struct dtsec_cfg *dtsec_drv_param;
-	void __iomem *base_addr;
-
-	base_addr = params->base_addr;
 
 	/* allocate memory for the UCC GETH data structure. */
 	dtsec = kzalloc(sizeof(*dtsec), GFP_KERNEL);
@@ -1436,10 +1434,10 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 
 	set_dflts(dtsec_drv_param);
 
-	dtsec->regs = base_addr;
-	dtsec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	dtsec->regs = mac_dev->vaddr;
+	dtsec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	dtsec->max_speed = params->max_speed;
-	dtsec->phy_if = params->phy_if;
+	dtsec->phy_if = mac_dev->phy_if;
 	dtsec->mac_id = params->mac_id;
 	dtsec->exceptions = (DTSEC_IMASK_BREN	|
 			     DTSEC_IMASK_RXCEN	|
@@ -1456,7 +1454,7 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 			     DTSEC_IMASK_RDPEEN);
 	dtsec->exception_cb = params->exception_cb;
 	dtsec->event_cb = params->event_cb;
-	dtsec->dev_id = params->dev_id;
+	dtsec->dev_id = mac_dev;
 	dtsec->ptp_tsu_enabled = dtsec->dtsec_drv_param->ptp_tsu_en;
 	dtsec->en_tsu_err_exception = dtsec->dtsec_drv_param->ptp_exception_en;
 
@@ -1495,7 +1493,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
-	mac_dev->fman_mac = dtsec_config(params);
+	mac_dev->fman_mac = dtsec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 7774af6463e5..730aae7fed13 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -163,25 +163,18 @@ typedef void (fman_mac_exception_cb)(void *dev_id,
 
 /* FMan MAC config input */
 struct fman_mac_params {
-	/* Base of memory mapped FM MAC registers */
-	void __iomem *base_addr;
-	/* MAC address of device; First octet is sent first */
-	enet_addr_t addr;
 	/* MAC ID; numbering of dTSEC and 1G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_1G_MACS;
 	 * numbering of 10G-MAC (TGEC) and 10G-mEMAC:
 	 * 0 - FM_MAX_NUM_OF_10G_MACS
 	 */
 	u8 mac_id;
-	/* PHY interface */
-	phy_interface_t	 phy_if;
 	/* Note that the speed should indicate the maximum rate that
 	 * this MAC should support rather than the actual speed;
 	 */
 	u16 max_speed;
 	/* A handle to the FM object this port related to */
 	void *fm;
-	void *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *event_cb;    /* MDIO Events Callback Routine */
 	fman_mac_exception_cb *exception_cb;/* Exception Callback Routine */
 	/* SGMII/QSGII interface with 1000BaseX auto-negotiation between MAC
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 7121be0f958b..2f3050df5ab9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1109,13 +1109,12 @@ static int memac_free(struct fman_mac *memac)
 	return 0;
 }
 
-static struct fman_mac *memac_config(struct fman_mac_params *params)
+static struct fman_mac *memac_config(struct mac_device *mac_dev,
+				     struct fman_mac_params *params)
 {
 	struct fman_mac *memac;
 	struct memac_cfg *memac_drv_param;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the m_emac data structure */
 	memac = kzalloc(sizeof(*memac), GFP_KERNEL);
 	if (!memac)
@@ -1133,17 +1132,17 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 
 	set_dflts(memac_drv_param);
 
-	memac->addr = ENET_ADDR_TO_UINT64(params->addr);
+	memac->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 
-	memac->regs = base_addr;
+	memac->regs = mac_dev->vaddr;
 	memac->max_speed = params->max_speed;
-	memac->phy_if = params->phy_if;
+	memac->phy_if = mac_dev->phy_if;
 	memac->mac_id = params->mac_id;
 	memac->exceptions = (MEMAC_IMASK_TSECC_ER | MEMAC_IMASK_TECC_ER |
 			     MEMAC_IMASK_RECC_ER | MEMAC_IMASK_MGI);
 	memac->exception_cb = params->exception_cb;
 	memac->event_cb = params->event_cb;
-	memac->dev_id = params->dev_id;
+	memac->dev_id = mac_dev;
 	memac->fm = params->fm;
 	memac->basex_if = params->basex_if;
 
@@ -1177,9 +1176,9 @@ int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->disable		= memac_disable;
 
 	if (params->max_speed == SPEED_10000)
-		params->phy_if = PHY_INTERFACE_MODE_XGMII;
+		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
 
-	mac_dev->fman_mac = memac_config(params);
+	mac_dev->fman_mac = memac_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index f34f89e46a6f..2642a4c27292 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -728,13 +728,11 @@ static int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-static struct fman_mac *tgec_config(struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct mac_device *mac_dev, struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
-	void __iomem *base_addr;
 
-	base_addr = params->base_addr;
 	/* allocate memory for the UCC GETH data structure. */
 	tgec = kzalloc(sizeof(*tgec), GFP_KERNEL);
 	if (!tgec)
@@ -752,8 +750,8 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 
 	set_dflts(cfg);
 
-	tgec->regs = base_addr;
-	tgec->addr = ENET_ADDR_TO_UINT64(params->addr);
+	tgec->regs = mac_dev->vaddr;
+	tgec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 	tgec->max_speed = params->max_speed;
 	tgec->mac_id = params->mac_id;
 	tgec->exceptions = (TGEC_IMASK_MDIO_SCAN_EVENT	|
@@ -773,7 +771,7 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 			    TGEC_IMASK_RX_ALIGN_ER);
 	tgec->exception_cb = params->exception_cb;
 	tgec->event_cb = params->event_cb;
-	tgec->dev_id = params->dev_id;
+	tgec->dev_id = mac_dev;
 	tgec->fm = params->fm;
 
 	/* Save FMan revision */
@@ -803,7 +801,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
-	mac_dev->fman_mac = tgec_config(params);
+	mac_dev->fman_mac = tgec_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index fb04c1f9cd3e..0f9e3e9e60c6 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -34,7 +34,6 @@ struct mac_priv_s {
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
 	u16				speed;
-	u16				max_speed;
 };
 
 struct mac_address {
@@ -439,7 +438,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->phy_if = phy_if;
 
 	priv->speed		= phy2speed[mac_dev->phy_if];
-	priv->max_speed		= priv->speed;
+	params.max_speed	= priv->speed;
 	mac_dev->if_support	= DTSEC_SUPPORTED;
 	/* We don't support half-duplex in SGMII mode */
 	if (mac_dev->phy_if == PHY_INTERFACE_MODE_SGMII)
@@ -447,7 +446,7 @@ static int mac_probe(struct platform_device *_of_dev)
 					SUPPORTED_100baseT_Half);
 
 	/* Gigabit support (no half-duplex) */
-	if (priv->max_speed == 1000)
+	if (params.max_speed == 1000)
 		mac_dev->if_support |= SUPPORTED_1000baseT_Full;
 
 	/* The 10G interface only supports one mode */
@@ -457,16 +456,11 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
 
-	params.base_addr = mac_dev->vaddr;
-	memcpy(&params.addr, mac_dev->addr, sizeof(mac_dev->addr));
-	params.max_speed	= priv->max_speed;
-	params.phy_if		= mac_dev->phy_if;
 	params.basex_if		= false;
 	params.mac_id		= priv->cell_index;
 	params.fm		= (void *)priv->fman;
 	params.exception_cb	= mac_exception;
 	params.event_cb		= mac_exception;
-	params.dev_id		= mac_dev;
 
 	err = init(mac_dev, mac_node, &params);
 	if (err < 0) {
-- 
2.35.1.1320.gc452695387.dirty

