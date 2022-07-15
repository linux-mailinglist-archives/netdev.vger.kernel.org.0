Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513D1576963
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiGOWDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiGOWBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:01:39 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50080.outbound.protection.outlook.com [40.107.5.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CCD8C740;
        Fri, 15 Jul 2022 15:00:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nywbYUduK3U+L1yn5DIm47v6xcG0BrVGx9bc2/6l4w4fFSfIeUI+Edgi0tmpIQOdQvJlxNcPkJdJS9lB1TSx6x00btUSccMRkvzG7Afj8ShXGGCATI99/Vs5Y4eZ1H5OreDgKzrkfI1SRbvr1amrLcJVtOuCPxvYtSXIVgB5i9+6Qba+NGGTh2jUWADU2PAdJNR7UWbh51eIRdpUAF9oqTZThnX/HkwNVJIm1uljqCuB9sheCT+MJYk1J+Y7aFCq31LYcHAu+jUoSZQaXbJ8mT/u545VixVABirYIINK5EG5IoQh695x85tZfSNI9SzqjwDduzBPyHmUZj6CRKnRhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nva+WLfIPZBM3+YV94s5u3YkscUhHaox6WtOeDvwk7s=;
 b=A3llT5FSplJtEilHmjYSw4Mx0DKc4QJ9gnd/LTaTwyO/3y/NSKdCSX0qHdot5oAVEEX3FandDy93IAhZxvUXYFqEz7zyf0U9ELMCyv23NTpMj1K/DcJyavFKbjcCY7kFCJ6KuUpENAIreKhf2Vl3z4jYaxIz9WwM9I01QtcV+YcLh15w3gT6ETZIlZTnSdXGndzzgDfBTVdVEwV97ExOXSiZ8ps9xpJyLx8ueRmaoAI99QbFKRYXMsOdQV6MK8Hp5GC0mNU/h5DY5RFBewseviaemNxdaOba/aGkbhUCIr6j3DLM3l2VlBW7lO0mPeu9WtUc3dFOuvbSiHCq+dSEgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nva+WLfIPZBM3+YV94s5u3YkscUhHaox6WtOeDvwk7s=;
 b=g+cItMTp9VU3jPCP0W2tLd/Jju1k6udwwQDij2FIe8onYdt04tMxjl56OxEyjdICiNkLJaBnEJob8wE8fFa61gMRkxxsodSP/96w72ivV2ZqQM2LeYIiRBYWL/oCNRO8RJWALP41Y1W09koB6lxJPbpXf46htpvVnn7ksVwMGCjItUptp3ZIJSSJZK37odjyiU3j1GtD59AgRiFJCXisrNEoXUmZDvOYaB6Vqboks10DAKeQP9d/CyavHeuBUgY1PT7nX3bec8mvC8KpCL3d+ECtRHvYt9asiael91jjet9T2DZUxyTE9FeE3jkGwPEeKeG35RroAAS3jUDX8e6mtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by GV2PR03MB8607.eurprd03.prod.outlook.com (2603:10a6:150:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 22:00:53 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:53 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v3 17/47] net: fman: Store en/disable in mac_device instead of mac_priv_s
Date:   Fri, 15 Jul 2022 17:59:24 -0400
Message-Id: <20220715215954.1449214-18-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c89be7c-5d16-42e6-d79e-08da66ad7c76
X-MS-TrafficTypeDiagnostic: GV2PR03MB8607:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJnav6ia8UHVx2hoWeu8eWEVKZN49Zkz2ygZbtCoVzZYxKpnZCaHZERXUHaS24BbkU6aSWDyz47M+Y7TO5SdWrdtnWhjW22zAWEwYAHHNou47VBdcMxB/hvfJYks+uLa5BxCgKanZ5RpEJwQaoInIHA/8/QhOX2vKP1QRT7JWRmllisRRMaSvWkMK4gNbsXFnmgsHqlIsR/jLZAWMqopSoB+332eV+7aVtt7T8AtGz/9JBSNg/D8eo6nGApAp5+WG4tbRN1X+udjsDj6gTHj1BKgbEyY/yrbDzKRWArFWkdilpzOZKch1V0maq14uBLniqGLmf2YLSaQbAUaSptBmhjQm7sBHjJWkcf2S2R1fXBdYMn1x1/Eemft+VT/X62ycHP3mvphUXdYr79+gpakjJ4apNCYHtRUtfYWbRBpTDnsN1kEdYH3CxvHQnVyrXQj3AhcKKiPngJfE4br43VRfS8lGLDW2aab3Y4fob4sj7S8+nmXLgn1/5p/ohraPBb0UEKdH6JtNLCPM9Tp8f7EVf2MA2PMxV0eHXCz9D8Pl1iP+qGp5Q+SFNtYNXs3lNft+/m3h6RORYHa8TyrK7EbPAUwwfePmwhVmaxklvnPdpgHMYVYxljGTNoWJNjbp6HK8Qm2I8iaPxO/57a84fA6u0+RAmPKcccDXmQf1tQ4Z/z9v7sq6iTOMdWc23AQWEBASC8DZGtboH6TmItRfi6Y8UHxmYe2oNclt2rEVKc2YlkZceiPJjywtlaXa5PuVtO5Fuj3AIVcJCePyIrqk7UEiY21VNAA/L9vFrw+oXNZtOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(39850400004)(376002)(346002)(186003)(38350700002)(7416002)(66556008)(83380400001)(38100700002)(66946007)(110136005)(316002)(66476007)(36756003)(8676002)(4326008)(1076003)(2616005)(8936002)(86362001)(44832011)(6486002)(478600001)(6506007)(52116002)(6666004)(41300700001)(5660300002)(54906003)(6512007)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kme2ev7h9mrCKr/m7rrOtQ5iEdIlzjUhGbRqB9obkHMCWMngufAFFssFHeD4?=
 =?us-ascii?Q?QpefsmdhfHSPXeupT/yG3qQ3gzh44+sJLykIPy5I4ooqneNX0kDsYH8gnpK9?=
 =?us-ascii?Q?bNeh8WZaJcCh9tKpTIWHN9rTyQ/aefhUCVuGd9Qf+DpE4QkZnW2I4BjGxLY4?=
 =?us-ascii?Q?hkGMFMiKSAt3nqbT7x16vRsGY8hFC0XmCmYSogNh+X1GBm/UIgRhw3tFdySb?=
 =?us-ascii?Q?Nl0oGh0VZ2Y1AFEl4Gh0ev5gmOfJKCKteRu4GqdtOpPv8xnO93E8Y3vpO2sY?=
 =?us-ascii?Q?s2pZlvqsu8U4uqI5V7+LenMKpm3DtDn2ilVfX9Fd+7ARgdaLHxfn6aXb/T4O?=
 =?us-ascii?Q?2Y6chINBX9U7AAiXtkgkmKfb6rIHb59MxcYnaKOJXPCEqkVJRLKTtcuC3UtL?=
 =?us-ascii?Q?XFBKuYYgcM9UAsE1K0X/knVwnuedIDSnJnZHY+X8uPM8oceqPomCwkEuPCtK?=
 =?us-ascii?Q?MmomoMWzIUAURQ3dYSmDAZ6ZJ3+7A1pnQ016dzMRPWMprLNEDWiU1JoENZ/6?=
 =?us-ascii?Q?6nLlAjBe3NX0wv9efNVndhuhBnmDtcBKXgam8+fWgYCnSO5L48kf3z80acqT?=
 =?us-ascii?Q?+RAc116m4beqvNX5UIKs2C5CnljtrNDca3/lltfUI5EQhikOtH0xSFsezgVK?=
 =?us-ascii?Q?bknncBkvNzd76cOy/b/Sva9+6WaGFGkTsGelIWHM+s5vUwwP7l3gDeKwAs8X?=
 =?us-ascii?Q?X4jeUS0biMP1pGsE1SHWJKIw1au8o1PgkLC+dg5opUduCNOArkh+706xziyp?=
 =?us-ascii?Q?tIH6Zdc0+zTrj5Lb94AYrfG3Ak+uNsxeccIczBz8kLrFIUJz4XUhUIwG+3V8?=
 =?us-ascii?Q?eVLfNBE5aZB/vY1PFtoZDCiGgWrL3AIUicBMStQKkJr3/18V+Rs5MsId6nWr?=
 =?us-ascii?Q?xUrnh+EqICFw2q7n6CGuJW2WCvs2tJnj0dTdhaxkqOBwWfJoL6etefUePAjs?=
 =?us-ascii?Q?Y+8aLPnMXTR5VNGYTnk6FI9ly7Jckp0XBRWcgwpqoYu+SqdiWp0tVBmUKd1U?=
 =?us-ascii?Q?t3e0Ku7dt9tNYvKpwUAdiEofz9hOgCj5vuis4QcTS+iK+Wwc6DxJmo57DAgh?=
 =?us-ascii?Q?U8ek+UxxZfj4HBxKfwVhXaZ9xdPHT1z3jktimBEcQOWZq4C++GeKPNXz4fiR?=
 =?us-ascii?Q?+oNpF2Qve+AX5hgc+X//pr3JIPjCGPMK/rpgMXf0p8/GDqPjeUl9m00JDZOq?=
 =?us-ascii?Q?M6Wd7KCKMvK0bcSlIWzqMcPatZJtA8pyGrHUnv4afVptG3ogdQtHS2f6ld5j?=
 =?us-ascii?Q?yo/Y8RND+WpJ2GL8NToTGOnswEGcAbUaFoOd0X2bSkEcCTgMEsIDMls7naVk?=
 =?us-ascii?Q?00YbKAcXS4WxuTQzKHz3J1jl59tIPhp1fqaIirbxCqaK8m9Wsj9Dac+bN1RR?=
 =?us-ascii?Q?+60hz4gUBXBe5ktX1NoQWP2C2dqZ2wYyW+qEXApAg23+hBwNYRYAaPwU4B17?=
 =?us-ascii?Q?r/LqjmtW0aIdcvYDhBb572myxAOUerSbuCVdCXFFrjehwVkDuwFQ/Zi4N+Zw?=
 =?us-ascii?Q?s+GexHnbYxZy58AkD63FDU8+DxVFw7/08yhn2sg29u3jv7Zxej8MjDIdujKi?=
 =?us-ascii?Q?gx4N7+z1QsZ7nxBwHsZXhWgUNUxUHDF/mVvQya6m1Z2fmAVfc5ntvXx7BWD7?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c89be7c-5d16-42e6-d79e-08da66ad7c76
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:53.0978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkgXjaBWAqmq4dtDYgDxIMCWGQT2Mksm7tlNqUiU5sb1GJp0wRGzdCGAA21FQwqYR2sd2NAsZox4CAeC2Xs8Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8607
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All macs use the same start/stop functions. The actual mac-specific code
lives in enable/disable. Move these functions to an appropriate struct,
and inline the phy enable/disable calls to the caller of start/stop.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 11 +++--
 drivers/net/ethernet/freescale/fman/mac.c     | 44 +++----------------
 drivers/net/ethernet/freescale/fman/mac.h     |  4 +-
 3 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index a770bab4d1ed..e974d90f15e3 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -288,9 +288,11 @@ static int dpaa_stop(struct net_device *net_dev)
 	 */
 	msleep(200);
 
-	err = mac_dev->stop(mac_dev);
+	if (mac_dev->phy_dev)
+		phy_stop(mac_dev->phy_dev);
+	err = mac_dev->disable(mac_dev->fman_mac);
 	if (err < 0)
-		netif_err(priv, ifdown, net_dev, "mac_dev->stop() = %d\n",
+		netif_err(priv, ifdown, net_dev, "mac_dev->disable() = %d\n",
 			  err);
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -2946,11 +2948,12 @@ static int dpaa_open(struct net_device *net_dev)
 			goto mac_start_failed;
 	}
 
-	err = priv->mac_dev->start(mac_dev);
+	err = priv->mac_dev->enable(mac_dev->fman_mac);
 	if (err < 0) {
-		netif_err(priv, ifup, net_dev, "mac_dev->start() = %d\n", err);
+		netif_err(priv, ifup, net_dev, "mac_dev->enable() = %d\n", err);
 		goto mac_start_failed;
 	}
+	phy_start(priv->mac_dev->phy_dev);
 
 	netif_tx_start_all_queues(net_dev);
 
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index a8d521760ffc..6a4eaca83700 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -39,9 +39,6 @@ struct mac_priv_s {
 	struct fixed_phy_status		*fixed_link;
 	u16				speed;
 	u16				max_speed;
-
-	int (*enable)(struct fman_mac *mac_dev);
-	int (*disable)(struct fman_mac *mac_dev);
 };
 
 struct mac_address {
@@ -241,29 +238,6 @@ static int memac_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int start(struct mac_device *mac_dev)
-{
-	int	 err;
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	err = priv->enable(mac_dev->fman_mac);
-	if (!err && phy_dev)
-		phy_start(phy_dev);
-
-	return err;
-}
-
-static int stop(struct mac_device *mac_dev)
-{
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	if (mac_dev->phy_dev)
-		phy_stop(mac_dev->phy_dev);
-
-	return priv->disable(mac_dev->fman_mac);
-}
-
 static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -454,11 +428,9 @@ static void setup_dtsec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->priv->enable		= dtsec_enable;
-	mac_dev->priv->disable		= dtsec_disable;
+	mac_dev->enable			= dtsec_enable;
+	mac_dev->disable		= dtsec_disable;
 }
 
 static void setup_tgec(struct mac_device *mac_dev)
@@ -474,11 +446,9 @@ static void setup_tgec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_void;
-	mac_dev->priv->enable		= tgec_enable;
-	mac_dev->priv->disable		= tgec_disable;
+	mac_dev->enable			= tgec_enable;
+	mac_dev->disable		= tgec_disable;
 }
 
 static void setup_memac(struct mac_device *mac_dev)
@@ -494,11 +464,9 @@ static void setup_memac(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_memac;
-	mac_dev->priv->enable		= memac_enable;
-	mac_dev->priv->disable		= memac_disable;
+	mac_dev->enable			= memac_enable;
+	mac_dev->disable		= memac_disable;
 }
 
 #define DTSEC_SUPPORTED \
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 909faf5fa2fe..95f67b4efb61 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -36,8 +36,8 @@ struct mac_device {
 	bool allmulti;
 
 	int (*init)(struct mac_device *mac_dev);
-	int (*start)(struct mac_device *mac_dev);
-	int (*stop)(struct mac_device *mac_dev);
+	int (*enable)(struct fman_mac *mac_dev);
+	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
 	int (*change_addr)(struct fman_mac *mac_dev, const enet_addr_t *enet_addr);
-- 
2.35.1.1320.gc452695387.dirty

