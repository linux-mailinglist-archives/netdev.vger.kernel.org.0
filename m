Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF155F103
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiF1WPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiF1WOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:55 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BFC36B7C;
        Tue, 28 Jun 2022 15:14:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIL8DgTSc/oRGOkQbIBSl1xsW+d0gQgFPxw6WIiWcEjwquKUc5lY7ngcgV2lvFPRoeEpGYP31j1j5IKuBDSf1fQjUtdmgHVoQ76DebXnWMgc+pNFxnknMusPm3nWwPSK9bAm0NEX1L/ymiGxVwlo4JkHH26KTEXhKJIoYnH72SMOXXMW/aoLNKLI5L4ejd/8A4hpgOhcjnyvfwp9ExEIMoUA+6hD2iHSsKy7rpeI3C2v+MC1t+OLMegG4mx8zmAQsAet1fwmuHtf9sKvoVxUsfF80+ITd9zDXGix7NPfJjWYg8kUCYyJU2hIZ80QGAhM/FuJLI2lOezGFrl1QWlnvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8om8eH2QedUZdijrrSK77S2858Mj/v8BVIBqUQfR/qc=;
 b=GtGcSKBLpF2pCHGKE7TrRorByOucpfaxn+8kfCccT8kavQLABVMj6et5PtgskoQ4yFBjIa1DKottjdwBX1cW0o8Hns8SUSWGUwx/Mua7lvMjtnzszdj652/TTSI4HXQucNvQ5q/jrwvGIzbG2ZFJ3IzEuuPrBIDq6/aaYGVyilwHRUgQPn7nFNjkql/P6Y99acGgFUomzV20pNSGBS4aNMedNpxAyR0EvUUkZV5RjdB97dow3kYteMgHkbNYQTX/kP/zbpjrJzXzwk7L0lMWrtLtDvwHaYLkU9Mt+vOGUjkiGwZ3KxWSURlDDTo3+QhhJasd88BBGLVJOGHVK6MOyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8om8eH2QedUZdijrrSK77S2858Mj/v8BVIBqUQfR/qc=;
 b=OSzIS4IBvOEIf9Z9vv/vQmudmx7H1ebXjQKahJGAWpT3zwISvlA03yuQo4I5+t0N4nreqzhFh3V+U4hPoepYsGT/tuCm+LEwZLtwutP24IasQW+2kRdfwFpjwoQa7na61q6O4UVOIKs+gPmrTrcq0ALDoWY1Nb9Bh0IXI8CZbvz/BLEsbPVYvXYFHCOuhzeBmsgGuxGS0mpdRCdyUYnLv+5nRVlYcb71ZTZfEPx/T4s19pJvbAGGWhqVEPfFkJz51LtvLwCEKHXEO5moqr3CIIMnQBeRM4k8NdLsLIynwopMYQS41270i6nNRuUqR0q7mKlBdYKymEjzDbxsrCwaJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v2 07/35] net: fman: Store en/disable in mac_device instead of mac_priv_s
Date:   Tue, 28 Jun 2022 18:13:36 -0400
Message-Id: <20220628221404.1444200-8-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57e8d96f-9620-4d32-7be6-08da5953932c
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nRLyBsPrAwP6PSr+LMslXX/4gxzoMbGrotjLq6NRFrUbWGdUOsprP3WKZFxUvpfu0ZSRwXWBGeGKhGk2SjbyIykuRNPWWTOeN95rZZycZI6m9za1aJFS5atwAXVNy7qAeUZ35GHub1uvB02atDxQdAKaHcbpE4mvYjGojYCABPUUIFiud/L8qKzAlQklZ3NTgLhLa/Ltdipr4/jIL4btrREnq/+WY69nTbvTqs49GUwjHxYGQxzPzPPiDCeqWzPK2hTANRRVMXs69UvFKqbeLqdsf2RdsEkqxEaKZhj5drYA4vnGAKvY3EVwzo1fnBvAMjbh7Ukn+4Rgv0k3rGtmIkGMB6phIFClgAWslDj2HZ4gDeLDh6/mA5uJnIzYoRREgiB0fkbzkN/e76LfU2JWLdHBpxSKmyGV+1vGnie2X9VZatrmBunJjNuw8qs0kymZvjTfy9zRrcqazE8Ma/ED7DPopUqFQRsdzgaHNNOErMQ9ri+rxIQ/OxceUq1T/fALoxTRUPEdvr/7vBFKqVq4qM4gUaNfE21dSEF4r2i1dPF33779PwX3/1NOzRqeMG8R/SB61d7MztoKo1EoekzFJetuuRSWHoRiuFVc+LHBstw38vigamcfd+7MM3okGhIeSiSGVtAUH9J23pgGcWfQqb5e2giTicZKUPoz6CCCyiwl+9lhxxbDe1sZ3ueALzdsUrwiP2ivmUn4kgtp/PaJOT6WZhoo5cllvlBIXlGu6s+FChK118lFMC4AujHbal7kml6lKHkH9mu4q1x9IjalLWOWjI3ZLv7kxAihcwnm1QI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(7416002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N1L4Wj8ozuWsEk/ZN0frpmKJ7bVcS0O1Mzblf3aiBqxx0nA3SH2zRlr4dmIv?=
 =?us-ascii?Q?pfWIF4VWooP1xBQNqbAI90MGfAsWdJ4N717+jq+X7Q3m/XwTs7ug/fOpcjxc?=
 =?us-ascii?Q?2W1INovZVH59PodWWK99pZvFA4JPIR/RHPGxelIxEarEEHzzAa3i25S65DnS?=
 =?us-ascii?Q?w+7eqdB/UU9nrg6fBfUKUcmvrERkfFcLyJzkO5wniJoIFLUBWa/NM26L19CS?=
 =?us-ascii?Q?cgKaeCak9Q5e+prRTLOJ3ueH9o1CQRasrh0AkVfQ96rrMfcCntV+1O0sPS6N?=
 =?us-ascii?Q?nVGMi1x0ZBIpiJ0KGGRbeP31VDJPqnuRtPmqpw0qzk0UEYJo4zS4scbS/vZd?=
 =?us-ascii?Q?sEd6ztU68hULGcO2AccZE44UAAhowQKmiUciCUWRxh8lUP4Ve5q31nsBPt8e?=
 =?us-ascii?Q?w2ZArzdE3pwMay5kuKk4nSkFjbQJsNSduJ56F3Ik1U2+T7AzC2+Yx0PrBB5g?=
 =?us-ascii?Q?/6lNeBFVNHhzl7f2egCDDC1wIT/gWUoFXTWYs6sLpjNFXYOhVmnRJIoB308l?=
 =?us-ascii?Q?8uAoNXjKIuBDH4SgDSWpwrwVjEiEdf2ZhEl1AtFs2/aCZtmL8a0/QKzTnUbQ?=
 =?us-ascii?Q?H62ZfpMRIaFZLjLk+3XJ9XciNl8gHTsmonloWpFqAVpBzps4X32fYpKi3Yr/?=
 =?us-ascii?Q?aFLIgCVYd56ken1k/HPOyf+IxFfcpHW8Lud3AFfVywGIhcDj/D9fuOwhx6Vn?=
 =?us-ascii?Q?48vvNNicGGFoHZYUUBLrBonuHM/Y33o8XSnLI0PBRMn0cEJxnjt47iKSfpqM?=
 =?us-ascii?Q?OjFRctZEMV8xhGzKm6zJw5u4q22/KW/7xRB07xnhu0Jc5TuVGadsZg5L23jj?=
 =?us-ascii?Q?SMFJFDqEo31o5e8Rejnj82tFhaOhkmDvShWbWpVV1BW7x+HBJOL0Bqd4qiV9?=
 =?us-ascii?Q?dWc7guiUuomSbHEMyYtpE9ku9Phy3Wrxt+/985VZlEBkdzDMRS4NyRDQQW9M?=
 =?us-ascii?Q?QjKw2M+m/ZcGAowGVdKMknIz2rPqzGb0xZ6RjK5ZCQbv0zEFmb/TH6JAZoV/?=
 =?us-ascii?Q?Fj+vPbWmkZNY3NmX7EmOZxAWNnBhkKZn1w0oOW4kqZXIAQaRvxHj8RpeOzIj?=
 =?us-ascii?Q?xI1dWVM0/11Ajpek64kTxLTHlWj5Io4CKmWMEFWjU4ELGnl7tklLWbcyAq/Y?=
 =?us-ascii?Q?zOTj35EbmQi6nhfL8c+fx0P1/jS8ZSgO2bJdK0hTJI3+yAGUff7lrvFyUK+u?=
 =?us-ascii?Q?oM/vI3+VGxm8lBqkX5j6M1MCRqYrUUkDR280FymELstH4pYpviwSzYNryYzm?=
 =?us-ascii?Q?Jl5bZkiD8ORIGTy5xJKmWZsqjtTMz/IdhbRyWbiMiCRqlD+DpyZyOgYDaxln?=
 =?us-ascii?Q?N5RHmiE/YVtpXIu/XBlbmH2fgmqjDGbeJYpL8yyd0RFfZrLCl06BHLanapr3?=
 =?us-ascii?Q?L2wcdFEktUVs4d1ylyrajvpcWqsRk4OCRhPpYAD+4nu3sPRU9oZNUNU9iF5v?=
 =?us-ascii?Q?vsVCz8WtooLbW3fbceYC9zBDS68Ml90p6Esg5F0WZTL+RkDDUQm3+WLQ1sur?=
 =?us-ascii?Q?MF5VRgZkYE3xDtXTNUj88k6/KIlgn5xmnM5KVvpEJGzK/FnbHuHZbgC8pvRZ?=
 =?us-ascii?Q?jPCVeC50WF+0NAj485DPDP2GpD8pUxtFL9purDBxbg0JmFAL55TPcgFsC4z0?=
 =?us-ascii?Q?CA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e8d96f-9620-4d32-7be6-08da5953932c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:31.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7k4obUcGZCGvIwRKyIWTnYhIRxdzW+cv5wnQrb/kfGBAgIg4X675Eh2uq4TaeMbL59/X6D3S4qnmIdYF1yldXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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

