Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5215988A1
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344727AbiHRQT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbiHRQRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:55 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10088.outbound.protection.outlook.com [40.107.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B81EBD17A;
        Thu, 18 Aug 2022 09:17:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRXYjwP9QDypHQ0UrO8fNAvgttmlzcISxINxy2yavFKnxY9Vwp4pG1Rpr2Lr3vEupVnP63V7Ig6VKumLvX+Vwd5bSd1dldQ9Q0/EudxwjEYeQEb/TxXNRRXOzJ0kmrHWz1cL9rU4Hjq4tN5rKdWCUyaO08TCpQVxK7mZcryvpzEkBNE1Lcof6CARZZl9tBYD8lIIpgp1HCaUtrvElL1pdilug5Kr3UXnceYYVRikmQw5E5gHmtUjz8ybqw+Nf54KrGEEi9ahTZcDOjwl1ZwGwqiXOsbX7rDt7/Q/bjGKk8GWtE6wgZEapP1JnNkAyMQqfVKL0VSTNlAK8PQLW+Atuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrjFhE6GcDc3NyqacZut6e2mzgJ8sem49dgtwHT5lEE=;
 b=UwmhJU3AalahgcAju88U47Lu7j+6xuRX/6nudY/fL55dK6iyxYuVA02uPEivZ3F7pa/ssGbyOxakDBFj8l8oaUAvG68cUonDPdNgwDYGepyTD0e3GTAY4fA9mffLOvuW3VctS9LJDmmaPMUZStJMuXmgFn2akPKMirgvDgeGy1wQZMCdWMDocIPJvUKxzlfEEBZ42b2f3mH/g3/VN/ToGGwk1Tx8ZuvL9xIzyoCvdXmZ4DmDpBD5D6ujVUOtzJUBlAgh+v3PulPUyYXz+txTcjPZx+mpwT1igX9qt0ia6Vr3dsNjX6I0O2RgTJtCijLY8wlTcr7n9BZLDb/roFrgTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrjFhE6GcDc3NyqacZut6e2mzgJ8sem49dgtwHT5lEE=;
 b=lnrteL1a6cn+tImAqEf57ckzahSfEqmgLJndLQQVcuvrTTyjg1UB19RpyAJkVHJoKm/W+afAysbfY37MmKr4kY42tGkgIcMUqA1gQXFA4UTSJ4NJ8cqyQAp2cr/jwfjIN1/rFdd7pfkAnbCg7tSX//VffxZCUawU/kPmNQmzZWl1C4JqpJZ/yoXiLxd8RtqlUYpSdNDW++fstCblW/qGVqpV1XTlmxlIYbD058oaCvZK7/DacK38Dk0UUUp/fRDehizipzEzMRQ9X3H9itfXwM4HqGWdTFE61H6BqfJ3uueXJ9Dc++Kc9PLZRHqKiEMOv/DdyAkUY5E0NJf++d345Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:33 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:33 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 17/25] net: fman: Pass params directly to mac init
Date:   Thu, 18 Aug 2022 12:16:41 -0400
Message-Id: <20220818161649.2058728-18-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a757671-713d-427e-cc59-08da813527d3
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pwHYYQc9MJf6SIpex1GPwXREoRil4o41zUYZRmhczjYzAnPAvlGNhGbsF5C6iQHbwi3qca+moGzkrx77fsXa4rFgAhEf9mFO4YnRq/4rX5DfB7ns6IxXHb/K+dcrKs4PTEfYm3dygcS/2Wf4JRk/7EDQUv4Ph8gtI59W9qTY1QmgfJrsmQ/rgRBIX3vcBUOw/8w2xM46Xha5AK3tPADTdvGaE3sumwlgfvEDaiCjZCY5RpL9ce4hG1OPpxznPYjOqg0UU9L9SsDHL09A5fl+jCqs1ZzOPeB6UFU/ZoDSKwXDht3N9sZquADg25uIsz+DcUQx0XoWxP6f9G+gPb4gp60zFOXLe3Wz2g682BV/Qf3k5eftr/lxBaJ7qcGGYPzbfhtjfADHDgYs+tCu/2CNvpwQBv3loXOcGBWkYLSNFg/U27e9OpbCHQImOYFLzuU4NZ3VZ7dkgRHj5uTdAKIoUUvvSWnkpFQpXKwu6u7IGk3qpNAPrpKPHXgdwrylenrEXcHkb3fgJsZTeULEnVrL+hKL6ojsE4XA4w09MiIIHUp+ads16NSJ5tMEKX4gldzB5Gdets2gOexg126Pcn38YW6l975g0ZogFPo5K5GSksbKsTPrf2jP0kCyM7hH6QmHMBHM0QFy0EoiSPaFDYJVJWwHx6nONhroJSzviULKGJ4+9u31Zo6NrDIH40TWk7QorxQuO6n5oZs37OMdpnfjKIgP04Umfg/J70/hi0ehGxlKeTP27ibRu5IW4tgYoTl1Is8herd0VuvuHh6ASUyzBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(107886003)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g4s0yCvv8rtTybgT3tZS7Eh8OsTq22nQ80l1q+3d628zqHJPerglydkl/Lcx?=
 =?us-ascii?Q?fZsOWi7uiOqIpucdgR2REJJkMbox+RtGuJ9/zwTKBitn61DAJZoUHQjtbBNX?=
 =?us-ascii?Q?E/u8MpCp7EVisUQzE6B0CedPu9KMVltdxABX74Qv1yB/n0/64uUZjtC6szRy?=
 =?us-ascii?Q?gHxvTpFiKipR2pi9IbVsgszH2iamPqzpi3/+OJ+y41Q3uO60uCirURDGCUFf?=
 =?us-ascii?Q?iMzHi3WDl9jtnW9s0z57Ld/BxoI5yYylQAeSmgmnkvZRs9wlMNyBaOEBYUW2?=
 =?us-ascii?Q?/gzyv6PWFJFB/jmOFvNn1Iw0CifQZdHrmbhcD2tbW0NzDzmfqU/Z75s7nFdP?=
 =?us-ascii?Q?MMKDLbhgMgZKOV9++V+6bLLAQY3H0ZrXSmSeVPux8MznUbboGy2OyYugP/xC?=
 =?us-ascii?Q?y9HlSONRE880GWWcjO3TnOwoxtYkAoPG4/QQQA6OVF8dAFnDVk7hlL9z98Cd?=
 =?us-ascii?Q?NCvjUav/yA8ySoPyjfdbn+X+s8Y3siycTTuHEBgSZDTpx+FWCSr53k4EMJj/?=
 =?us-ascii?Q?AgyqpSz5AoM7WLiwBNagC+fB5Arc1mBmj/LjyDaHQ0Y+kE9uF1/bIX5iQbiO?=
 =?us-ascii?Q?yyO1zTBTTvbofQM9lrg9zOUYUDaFXvUiVG1ktwY/OX/sKcMtnutsvzDSuc+7?=
 =?us-ascii?Q?uG2BInCe0OY/rrUq7jDQiKZKBknd8y41NcfdnK95aiwIdXBVH1FaThTdt5Of?=
 =?us-ascii?Q?OTJ73YW5InfIaI+3cya+d5UjqqaSN/dHCISLTTM2jQ72UcPxsp9ONPYxh1vg?=
 =?us-ascii?Q?FXoWvQoLD0keNRH49DhckSH3d4eATIz8FEgCweWwkxRjPcG28zyqPHk9wrKb?=
 =?us-ascii?Q?k/OXwhtrNwOcMqw5VKFrIEMoPwkMpYgRSz2vXMBM+oKEiTdCPfkzpeVWojpQ?=
 =?us-ascii?Q?fgjtJjn58xb53wD+rN+E526NYM9mMYOnH0K8wccKDvRk1e2aYUNk98wFohHN?=
 =?us-ascii?Q?dmQ8DOUdUb+xfsUovV0fg26nsZOPCwukn9hp/JMi/xssEAjYnFk/kHJeP/3M?=
 =?us-ascii?Q?YOtbj9Zc+wWaxgj8rzlLUBjCZPntnArI2mTDofH4oq90lQydsngjyZPJJu3K?=
 =?us-ascii?Q?mEdJBiAlKKcTga3F6Dri1ApE+lVz+WdAtMoNfVDMxpc8+8Igk6o4oDuZylVO?=
 =?us-ascii?Q?rEVJJ/5acjFl8GxjiV2ppGDrJT3j83Bw8zxLvFj7NICfldeYVrMTHV8sPoNa?=
 =?us-ascii?Q?pw3x7HNRzXNU+xDPFvPrddbrFWG1yG6+4HukHueAtCGQxxf9leJ31RXwWR41?=
 =?us-ascii?Q?UQWPdFIwKu/hNzKAxOuST8t3GQV6MA6Qf2eMd6z+ak7byyx3F9PYePB3g/M7?=
 =?us-ascii?Q?pzHkg3BOEeZQYLgAd+xl0JyB7GAetvMp3fxyNrP/8O8J5TvCMHVtI5Idpth9?=
 =?us-ascii?Q?Z+V1XCiP5XOitcHDfdKV92ZTZwwQUNLzWbaX5d1ER/gTMU2IFKIz9yS0gFJ1?=
 =?us-ascii?Q?TZs3SCL6xWNuwKxPyLp6041AlWT12vE9mTX/h0B6KYKeaF1n5xVWkTKAoXpy?=
 =?us-ascii?Q?YWojt9vJGA+qufOlU9r0XmllGZvE2DiyMjoDELIrYLzyjJ3ttaeJe2HqeYqG?=
 =?us-ascii?Q?dU7v+d2FcDkTRdwhkSReyemQ2Pzeisb26T+KAxD+s1xzOsfdM0kd4+Z2v+23?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a757671-713d-427e-cc59-08da813527d3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:33.0287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3/K7UAl3n5QiPMD7rKNz0lhA2tA4w3PduK9gK/hTAR3bkhDJ15VjK9QzIoCiRw285BqpJcBfamUzyjaWaZ5eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of having the mac init functions call back into the fman core to
get their params, just pass them directly to the init functions.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 10 ++----
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  3 +-
 .../net/ethernet/freescale/fman/fman_memac.c  | 14 +++-----
 .../net/ethernet/freescale/fman/fman_memac.h  |  3 +-
 .../net/ethernet/freescale/fman/fman_tgec.c   | 10 ++----
 .../net/ethernet/freescale/fman/fman_tgec.h   |  3 +-
 drivers/net/ethernet/freescale/fman/mac.c     | 36 ++++++++-----------
 drivers/net/ethernet/freescale/fman/mac.h     |  2 --
 8 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index c2c4677451a9..9fabb2dfc972 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1474,10 +1474,10 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 }
 
 int dtsec_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			err;
-	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
 	struct device_node	*phy_node;
 
@@ -1495,11 +1495,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = dtsec_config(&params);
+	mac_dev->fman_mac = dtsec_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.h b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
index cf3e683c089c..8c72d280c51a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.h
@@ -11,6 +11,7 @@
 struct mac_device;
 
 int dtsec_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node);
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params);
 
 #endif /* __DTSEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 5c0b837ebcbc..7121be0f958b 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1154,11 +1154,11 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 }
 
 int memac_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node)
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params)
 {
 	int			 err;
 	struct device_node	*phy_node;
-	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
 
@@ -1176,14 +1176,10 @@ int memac_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
+	if (params->max_speed == SPEED_10000)
+		params->phy_if = PHY_INTERFACE_MODE_XGMII;
 
-	if (params.max_speed == SPEED_10000)
-		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-
-	mac_dev->fman_mac = memac_config(&params);
+	mac_dev->fman_mac = memac_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.h b/drivers/net/ethernet/freescale/fman/fman_memac.h
index a58215a3b1d9..5a3a14f9684f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.h
@@ -14,6 +14,7 @@
 struct mac_device;
 
 int memac_initialization(struct mac_device *mac_dev,
-			 struct device_node *mac_node);
+			 struct device_node *mac_node,
+			 struct fman_mac_params *params);
 
 #endif /* __MEMAC_H */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 32ee1674ff2f..f34f89e46a6f 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -783,10 +783,10 @@ static struct fman_mac *tgec_config(struct fman_mac_params *params)
 }
 
 int tgec_initialization(struct mac_device *mac_dev,
-			struct device_node *mac_node)
+			struct device_node *mac_node,
+			struct fman_mac_params *params)
 {
 	int err;
-	struct fman_mac_params	params;
 	struct fman_mac		*tgec;
 
 	mac_dev->set_promisc		= tgec_set_promiscuous;
@@ -803,11 +803,7 @@ int tgec_initialization(struct mac_device *mac_dev,
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = tgec_config(&params);
+	mac_dev->fman_mac = tgec_config(params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
 		goto _return;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.h b/drivers/net/ethernet/freescale/fman/fman_tgec.h
index 2e45b9fea352..768b8d165e05 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.h
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.h
@@ -11,6 +11,7 @@
 struct mac_device;
 
 int tgec_initialization(struct mac_device *mac_dev,
-			struct device_node *mac_node);
+			struct device_node *mac_node,
+			struct fman_mac_params *params);
 
 #endif /* __TGEC_H */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 62af81c0c942..fb04c1f9cd3e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -57,25 +57,6 @@ static void mac_exception(void *handle, enum fman_mac_exceptions ex)
 		__func__, ex);
 }
 
-int set_fman_mac_params(struct mac_device *mac_dev,
-			struct fman_mac_params *params)
-{
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	params->base_addr = mac_dev->vaddr;
-	memcpy(&params->addr, mac_dev->addr, sizeof(mac_dev->addr));
-	params->max_speed	= priv->max_speed;
-	params->phy_if		= mac_dev->phy_if;
-	params->basex_if	= false;
-	params->mac_id		= priv->cell_index;
-	params->fm		= (void *)priv->fman;
-	params->exception_cb	= mac_exception;
-	params->event_cb	= mac_exception;
-	params->dev_id		= mac_dev;
-
-	return 0;
-}
-
 int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -294,13 +275,15 @@ MODULE_DEVICE_TABLE(of, mac_match);
 static int mac_probe(struct platform_device *_of_dev)
 {
 	int			 err, i, nph;
-	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node,
+		    struct fman_mac_params *params);
 	struct device		*dev;
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
 	struct platform_device	*of_dev;
 	struct resource		*res;
 	struct mac_priv_s	*priv;
+	struct fman_mac_params	 params;
 	u32			 val;
 	u8			fman_id;
 	phy_interface_t          phy_if;
@@ -474,7 +457,18 @@ static int mac_probe(struct platform_device *_of_dev)
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
 
-	err = init(mac_dev, mac_node);
+	params.base_addr = mac_dev->vaddr;
+	memcpy(&params.addr, mac_dev->addr, sizeof(mac_dev->addr));
+	params.max_speed	= priv->max_speed;
+	params.phy_if		= mac_dev->phy_if;
+	params.basex_if		= false;
+	params.mac_id		= priv->cell_index;
+	params.fm		= (void *)priv->fman;
+	params.exception_cb	= mac_exception;
+	params.event_cb		= mac_exception;
+	params.dev_id		= mac_dev;
+
+	err = init(mac_dev, mac_node, &params);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 7aa71b05bd3e..c5fb4d46210f 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -72,8 +72,6 @@ int fman_set_mac_active_pause(struct mac_device *mac_dev, bool rx, bool tx);
 
 void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
 			bool *tx_pause);
-int set_fman_mac_params(struct mac_device *mac_dev,
-			struct fman_mac_params *params);
 int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev);
 
 #endif	/* __MAC_H */
-- 
2.35.1.1320.gc452695387.dirty

