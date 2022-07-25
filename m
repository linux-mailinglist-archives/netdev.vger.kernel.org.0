Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42D2580139
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235685AbiGYPL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbiGYPLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:23 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7C012D2B;
        Mon, 25 Jul 2022 08:11:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liCxHX55nAIaGGrN60P8dkTPIBjuw5Lp2hdSnF0/xrUMM/ZVgIcjHWm5IgAdx1ebFPtVoaB9WdDNYeIKcBPnXM6NB60auvTQYLxUnjET7wwW8h9abaNHJRM5AHgQ9UVEWuq86fLiUBCytMcPiTSljao4Ko/tvO9JSwgrHANCHY4A1xhFdVzraETRc9wVFyeWj3KWB3TasidN439csWqVODrEos2R2AsUT0MsOM8/DfFqddEjQrqq98j0y5HwTeWr5+EDE/us7evln9qmeA2Hlx/X/2exx/7zbDHZKID2utQrG7n/fPY1c6SB0xiCrQUzIQtIHxjGknfAHJhnaAjTOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8om8eH2QedUZdijrrSK77S2858Mj/v8BVIBqUQfR/qc=;
 b=al673W+9dbNI2j7cH7u6Rl8YJxawN4q1NMs1e+gJoUz17PxfCkJ1eey+uKIZNifNslg4SrcDG/wj5GkU4PWG3V9tTqAC/mB3r/VyAviMfnVgwi5uz/z1lE8atX1k5FZsHl/SdNcV/tkAn3exA+2hQcKAZWe4x1WkRLRNQXzleHJJINk7NMSi84cWlIc6NVBJGfNG+TLsGJiZ8n2/RO2vFkjje4ml6lymSOolyyLWml4p214IBkFjwJ0HpWGsCGSr3ynoo8sT0yKUe4p9i4zFQIq894if7TJr0SUHJIzK4p+BJXNDG9y5O5hDJNpi1V3wmRi52j6xyXiRYTSL95bdCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8om8eH2QedUZdijrrSK77S2858Mj/v8BVIBqUQfR/qc=;
 b=0finZS6rnY6jRTBRam/u5+ElDob6BucfSzbujmPCoqxuSjCHQbt9VHiFlAYh/5+rB6bFfi0frUMLS9kD4BJEFFPQ+0GqjwRAtzpMr/mRgVSP13zwl/yuUPvnEx5MFioE3fK1XLpVUJIJU4jCiMWXMoPnufivc8N+r+tdChNPETriAATp0+fjtXp9JAOdy/FOzYhDsYfZ8V/cBwpVFSPGVYdYFmYieGIFFzBl3TEkiE/3hd3IwRPJw8xB9+HCFT6hupQ8v6faVhj9soBiSvzQfUiOpfdD4uSXtlSHu2+eyusXY7+zAGPfKKXdCwdTjibawOscpWs2ULA1AIP0Ehb9Ig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:05 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:05 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 04/25] net: fman: Store en/disable in mac_device instead of mac_priv_s
Date:   Mon, 25 Jul 2022 11:10:18 -0400
Message-Id: <20220725151039.2581576-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2297e743-e747-4b5c-640d-08da6e4fe501
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJpWWazYWUs6apCkX8aXkJTfldpf33CnHqolFmZikH+GQzDXCd6WNV1WnO1P0WrQ7NEFFO54ZVYXVPsDLB46zuHVePPnsA2zTBBIKUby6UWylChNeMoJ+UZN85HnDgwyig+512xdKEQpy5SJcS8tiIyAtRS1Yf3/GT/j5YwLD+R0Pr2pUdFliMvJiYjjtZN9TD6i4Ki/YSX3bPLrORVFt8FybXV8EqrXfTxmYJ9kWJUojTkk2J23hTVl3vXGHUZIJ4VM3CcnNQb1HHZ8LT9cOhFgw9mEDgtWEkmWRd0RcHosVpHjAmgSExxEDVq+jTwVA0kO5U9iungtTH1JtYCZvfOCmk7g7ZcQmVstlWfDUJyZoVpTu6lbCMMgbn1AxO58fbCVleSmB6/jFBSGuudS38ZKAmsmK2WERI1sh7kHfmph/0TM2ZUaJSRSJOjhi4rid+fLAYDfM/UAsVqEdt9sNlUqKxthuvf7PlGhCahRB2IVeUath/Omnk/9dWIersfqG48zFlsNd2MudIw4ME3BYOO0j7d1KzRGxAWyq2nwSTB8ozb5RxzFCzuMeLo+E58rg9925WtXR+6zABdbLgH6LJd0m/HE+v0crAKL/dbbd7vGUtQgyrcvFskWI3QnTOPEK5PhAMhqTWRnIAtCOcd6XiSbw88WdkfH0OOyJ2nVfJybhWFNmRdE34NUZhqNsSbd76VNXD3G82s+OpmuydRK+o4sKClTvHgtdlv0Ij0rvNE/WVSubvIdz8QaMcAvbjIBAvs58Et6sIbsODlomTqt0pg7I7qUnqPMcI7ALSbHi+I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ufJYZSn8A3q+zQ/LR2BwNRfjX2pvfex5q9uSoM4gCwOgtLoMkNtv26KSU7uz?=
 =?us-ascii?Q?LmCWHpwOAuiG+GVhCY6wKKM9feKVxjeeFNtkoYCfSMSzrSXZLzBObFhBHwj3?=
 =?us-ascii?Q?FJPRdFM8dEc9bPCvy0yBmNxarPZkE2GRx1i1UKB5+jdIbUpJcFIESW8kTVeG?=
 =?us-ascii?Q?jDVvClE2ODyEZ0WwG4MOfNJH1HorCwpUR1jPMRSP+nzai2kUvRE+aZ5tW0xb?=
 =?us-ascii?Q?dZPk2QhtdwuoBYXYZC6exDcl0W1dmbpRQE/gbCBnRSOvvcrY0ZOQl57WQNcJ?=
 =?us-ascii?Q?j6pOJP11NxxQODpi7WrUx3GCBwojAPugiXgmUdKQyrMkHmF1gHRRzeJdj6dC?=
 =?us-ascii?Q?1o+MUiYakubtYuXleGWhP6mD4akfHv4IAaEVYZayAxhYxrAxCHWqS2xt6H1Q?=
 =?us-ascii?Q?seWdvwogHvPtHeWDs+phT4p4t0YHDVtRLftJAyXR13GqDkhx2rhm1cVFXgx7?=
 =?us-ascii?Q?1H93I/bzzphdRJASAYY4wAImjg6dCcVNPJCTWOxxaAxlDtGqkekr4SD/F2B6?=
 =?us-ascii?Q?qNmOrf6RPdNcp3bExKAL9T2i8JRZaJmmNh5gHzERNsx6QlMYrV/VM8gX5Ern?=
 =?us-ascii?Q?VIeNRH1Q+5BCsRQVdYJu3TyFFQSgP6MYYmFOPeZWOMYs6j7l60AnIsuP3bXV?=
 =?us-ascii?Q?OBW1dDYGdfLkZpYI1aOqxcbjzjqDqD2Pb7VjVzlt9AhfEoe9q1QJBp+oSbMF?=
 =?us-ascii?Q?PNIE0MXoEDpuaRG7aHwJbdqXrxOjRUEgwPnVxm3Yc4qLHL1YCnFek+kgWUfe?=
 =?us-ascii?Q?JwiT2Gx4jjUsMlrDX6FCP7clUlPF/f23dPmbWa4M1F07lYqhklu73YXgOdwA?=
 =?us-ascii?Q?uWCQUzO2Io15xum8HbxM/0OBMa1dZo7HbsQBAxTAshHABMM71gycT7hszIV+?=
 =?us-ascii?Q?0TTHP8ACDUqJRNqgW29eCtfiGViSkBgRelidACj47M7KNWi/ltc3ADYBHwiG?=
 =?us-ascii?Q?qdSaHLkEzRS15Rr3J+JEcFz41d8g5q4C89ZHfMWbO4Ndq1/0ZqLplDUKsZIx?=
 =?us-ascii?Q?QqTgXy1bRaHXcth0ESPImh6jsPxX0+3EHjh75yq400PBVpsrj9WTGFgYhtiu?=
 =?us-ascii?Q?RZJ2yjd7uZdw6yJ+107D5TRryCy8JpUjFs/t9EgJGv8rsXDwSxMOfREnQzbh?=
 =?us-ascii?Q?ZcCrcw8csVVFjYn852WQ5+OyC5+TRQECOfnotvjkJeZgnK/ePCQY9bXzIQQn?=
 =?us-ascii?Q?YKapzhtqNA9/ueGzLjxtn6vLxOZG50EBAdmy3FyKxkNC0eDEqDiggwYZcZKk?=
 =?us-ascii?Q?H421LE90Q/iD5Id9FvRmQ9Olnu9Nz+upED7b3RWZ9otT3Mk9PntFm2V00oTX?=
 =?us-ascii?Q?Iuvn2/lEmqtzsCngVzoLHhjiduZiByT2+40ZB70jyBoi7AzqlT6WZTB/1GOT?=
 =?us-ascii?Q?sOFGFyGgJNAmAkHT6Mrb44QdFITZBOuulYjD4atJzsrgWRExI0CKHYHTnmYY?=
 =?us-ascii?Q?QOmOE9ySIs7avrBjTu1WNNd7D0jEC5Nx/2NwmUIEyg2NAG2X6hoLgU/9PA92?=
 =?us-ascii?Q?fVnlcqEgXQQHmvdk+wRVL7hQ5OyAxtIT3QBIjuVdeZ6jzrAw9x1q+cQoryAj?=
 =?us-ascii?Q?MLDKKPkfZQbG6rhOOtRI0JcVrHM60k+V7LgtgNkgxy0jdry3ihK3xQr2BnYY?=
 =?us-ascii?Q?FQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2297e743-e747-4b5c-640d-08da6e4fe501
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:05.1141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4MSC5+ECTUXW9xfyRVDymXS+6NpIkN94g4n3HMAFwHnM4lhCmjzLENn43RablVvdRTAs4/H1pEDVUNBYlftZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
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
index 45634579adb6..a548598b2e2d 100644
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
@@ -2942,11 +2944,12 @@ static int dpaa_open(struct net_device *net_dev)
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

