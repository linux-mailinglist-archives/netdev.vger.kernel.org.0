Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843A754FEB8
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356333AbiFQUiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382891AbiFQUhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:37:38 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A2D62A15;
        Fri, 17 Jun 2022 13:34:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qppi5gUR7CNf256MV/TUzalyOyO9eRcAPaBc6rqLGKtnbM4nrnyPHzi0IwaQpZNSvWXsEBGRtUO20sxIBy5U1X39/NeaLzLhLqYBoKZ90IYIJHlRl16pT1453ZeHISSojL5rUOiOcpE7YR7cNQYhCtMSQ1FmcjELh1tVPUo28lNxADDB3cwyvX8Y6OXZ86kp9nOxpTF0hXMnZ148oakrDaVfvrAYfKxTdtKuYwqXjdglKMA/+63M21aNY39i6MCBrnxumI0zIwRrl1eMR+PNuDP7hoI0yTehBltr4nVj4h7MCHaV5J8ciiHjz1nUqjVWBzxAmU9LfwVHrlr1jj0ZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUrZHJaWS8DgoCWjyy3lyN2dOGJdnx8OE+m+BMIwfTM=;
 b=Zs/EbuzDcPpzxMKQS3bGcxQegySF1l3Ihc6S2bizEO9b566voth+pK8W1F/cUdyjYomJ9CZv7IwziHHtMXN+YnJMANkCA5hIJF3Ahd2Uu/QTjJF9fNJ6j2E+jZ3lNECbZnb/oBhnxm09VBbDOX1M6zVwGGCmOAyy8XZJd7ST7O6xpKBC2VEAMhO4H+lYrWjQ73a/n8AsHtYqW6Y4HPRqaHXNyr5IB1cbOadNQewPJwrOGTHvHMu3oQPolOSNZKlZHAV0kAhHdIMIFH+uv7Ap09NfN0cAS8yxl439zfcN298XySPGumaTl8lpRB4NAS8zsZN6Ea+LmkBfjwjg1nSNGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUrZHJaWS8DgoCWjyy3lyN2dOGJdnx8OE+m+BMIwfTM=;
 b=ATe8vV8VEU/S7caP755uTXfNJr6elMxdlAN3ke7K3J9uC62ZtZc+2F4wCJEW2Z2tNmiJvBk86wmgHi04T2vQz9iWZpe+hWK7HjS7Tw8nFmjaPm+Is1f7LjxdOP2EMcc3uyr8KwbekBC6m47/ZChk9zSujkeOwaBt0GVUV3V9NELILL1rclVc+gofFIh52FZ4kWqov88rKiSjUwqRwYvlkHzjSEYyxFzhtLnMNS+zAHB+UhrLZGi3bPE1lVqsmB/G/pynRCgX2x9KCLm7OLosNNwzJF8MVEUs3lxDYSqpXYxsRzhCdLOVcncVBB56vjNS0oujktjDRFppMuxvowf+Zw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:23 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:23 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
Date:   Fri, 17 Jun 2022 16:33:09 -0400
Message-Id: <20220617203312.3799646-26-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7ac8cf9-7a65-485e-ed5c-08da50a0c3a2
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB6838D2A529F6A08300A1A41496AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yb1WmWx1Wcy46dxmqiDmSNG3tc0yQChTlKt7unB580Pjsl2ZWmHf/yPm71Ja2lCt2EVoqMLtONp92mrEt4C+0p14GnXRi5uFbNVuoF51iV7jCWeRrzXXrin4VIGX2zdTf2VaopNpdFR+9w4n+kz0t2BMv8tHDR5bTKNzBZsbPdUZArfUJH3SfiGE8d2tqgOmDI/3UooHNmd1PdaRS1+gm5ErgKPdqbV6ncPi43efF844AWa23eN50eHcg/LPG95Xrk2co3/yJd4xdKUwuV+PY67twxdfsrQJ0MU/SKHwK0MYCcicgq3Q2BIAmM7RBrLtf8FeQ3FKK/N+Z7KRw0D+4n+pWSIQQOMukYcUHD9ekGImCs6MogUzIOPW9u5aDSOvoRVN2TEnxPyEbtvdH2yVQwKpphmsG/xAFjLovi6BtrHT2k5KmAjGte4O5HFNJ0z3PQyJBe3It4ZNtQH/bdDf2LspiSh7fYp5o7FBtAHazYArSyjnbvy2mFJQZqFL6tSHq9CYOFrsOXLVBB0ZYJKpz6ktdzoKqGcK6qa6hf6/VqaUKb7VzJoajMLl7bJhBHllp3+SUf8zlnsiaJ5lqNQ9hoZDG7cJVz+qHgoTRJp55B9FQ7/cdVHKy4UAaYup/b0qOCmNODJ1zPcIJ2JY8+rZbAFcPWYLZvANfeJZ6eJnYyVe0uVvuMaRoDTBgjPIRDSVQcy7imfm1THSLa7LZ9EleHd1FwlqYiyZjbv8/Bdn9Vg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(30864003)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001)(579004)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iFjZklngRfV+i7ZFI33k2hPofquJw5ZtRpNIHGHPGL33aCCvMrBp6OHQyUhv?=
 =?us-ascii?Q?kTzINk20Ei+c04Wb+Pn4d++5KN4YDNvwKLxB+91EudGbMsxUC5Bb0/DmMRSk?=
 =?us-ascii?Q?7rBmpifcd5rohD4WRi6Zoat1Si2uASMtp1VKHnSNsesfUCY6Ywcv2/Ay4C+X?=
 =?us-ascii?Q?u0o4aaLNNi3Uixaa37+LMSjxXUjOVqjW2srMGtb9g5byD3yIq9DQabtzitpT?=
 =?us-ascii?Q?hBMSmdPM4QyzN//enOHymFFvYyELjNAUe28Xuh5kCLDMMRM3eQLPw5j6eD34?=
 =?us-ascii?Q?IJwQTsBLe1l9mIUh1k8Y5T8Q43DxjEU02Sqol+ezGmZ5VS8SrXz7N94LVwnC?=
 =?us-ascii?Q?Poc9MLoQ0s78Oq6X+2wCTdboP5QB4NOpeBD/3u50MwZxkPNK6WxOrJgLZYbB?=
 =?us-ascii?Q?1FrcCu6HFSPlQF0xksez4npFxH3Q74jEEQgQnKoHNXpI0gOiKnn3rNLRwKkd?=
 =?us-ascii?Q?0dZr0wYIj0yXbmAcAY+KiuVAFwQlWWA8T5rrcL5jjKKD+mkGLYgsgkZ4iUim?=
 =?us-ascii?Q?7H1Z5/qGv6ujHwQI0cuxv1R77IGzp8KqDo0m654A5B3rLwsnIlgFgugk1h9n?=
 =?us-ascii?Q?4V8bfY83lDsIWoFWGIE8TGs7QXrw73GuG+jEe2PytBcFkUyl+rEZZsQo4nSm?=
 =?us-ascii?Q?Ii4LXdaOdfc+6w/4kyNkdGnCS2J9sd6Tlz7YGo7JVTob1h+eYZgu5ScbBbmK?=
 =?us-ascii?Q?OPK2KUx2buDbKiDZXHAJtOrk1sGAIeE3yzYDX/q3yJlvBHoh/TVXOeL5QGfO?=
 =?us-ascii?Q?hiVqRntJptCFtIQxxhOqAS18sEo4luuiUs14DEpleW73dfmZJcb8lJ2ydRhx?=
 =?us-ascii?Q?W62fafab3g61bzpuWmLNWsBPJrflO+y73YTU7B5p11m0AoXK6UVyGSz0mVXh?=
 =?us-ascii?Q?rI+OpHpzYfchHfEyMDatjuPz+fzs1u+MeLoHp/FbTN2MVMjsMLtYjYpdwOTA?=
 =?us-ascii?Q?sA/YPVnndapBcoHyTfdL0KwTkFVLMQumjIErhYC7oal5xJ7XmHhS93B9SktR?=
 =?us-ascii?Q?D6WZnwFIcMURKuRL7kIJRM5/g+7FLB+iVp4CyRUGDxeGK1XzXoKt3S9s497n?=
 =?us-ascii?Q?lQuN462TA6g+grOg8ui7W2N4prxdjyadLt1ggGcsm5ly0xdTMV6F0GT8uTfK?=
 =?us-ascii?Q?S7otKeSEtuUM8ozAWyXNsV2MOPxkyBRbPltSgYMPkE+KAFWSS+tC807UO8CB?=
 =?us-ascii?Q?touRmGQNfIVPkdvLjUl4KtYJNodirystLD3kFy4zbAfdyotnyS5lVw2kaH+G?=
 =?us-ascii?Q?7c7CqhqyPNJuyd/lTfJIm8mroDwHkA0ZTjSAxa7+dcE6s3ibh5qcz2Bi71ya?=
 =?us-ascii?Q?s1O2cPYIKuKfoE0U4JqPvyiihgVWX+TTeOziRCX4VDLhPI3RPGXBpxixIATi?=
 =?us-ascii?Q?o3sddDK7NqOH1Cfzm/QrRfYdmVyZdCfu/FSrHRgB3H7y3Gq1307UyzOuQiFX?=
 =?us-ascii?Q?HZHSJno+hB3dKEtQcuW2E6miiDZU771kfXzCj+t5sIyXcI93+hAvE+e+mfQ8?=
 =?us-ascii?Q?Uybq7ftj48ScS4y56IvNl/FXAKq3EwWiBQtqbpp6bfZRX14kdPX50vpk4N0H?=
 =?us-ascii?Q?4QVcp5RFsD1aUv55TBVdEKBxm93fuXgQX5wBoMvCdAVXMfY8VQNfBbTrhNmm?=
 =?us-ascii?Q?feqMYuxGdKrulEhjmOSZqRw9RDFrEB/7FBPMZQDCJkeu02SJIOvQS4eOB6T8?=
 =?us-ascii?Q?qCYOwpnvojq7Y12rMx6s0rZGL/1YSgNM74O0/q6zTR6K8CtXuc/6ffpUw8x7?=
 =?us-ascii?Q?TvIkdmPZGdjTmdGWRGvQG4KP4tCxBww=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ac8cf9-7a65-485e-ed5c-08da50a0c3a2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:23.5758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XZyV8uvzoLPVH+pauTbneExZl9psfKAAjGKDyu8kyXWa7B0BoJ0b3nFaQ3JVb7aII5RCdPPmvKV3mFPpRJ2EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts DPAA to phylink. For the moment, only MEMAC is converted.
This should work with no device tree modifications (including those made in
this series), except for QSGMII (as noted previously).

One area where I wasn't sure how to do things was regarding when to call
phy_init and phy_power_on. Should that happen when selecting the PCS?
Similarly, I wasn't sure where to reconfigure the thresholds in
dpaa_eth_cgr_init. Should happen in link_up? If so, I think we will need
some kind of callback.

The configuration is one of the tricker areas. I have tried to capture all
the restrictions across the various models. Most of the time, we assume
that if the serdes supports a mode or the phy-interface-mode specifies it,
then we support it. The only place we can't do this is (RG)MII, since
there's no serdes. In that case, we rely on a (new) devicetree property.
There are also several cases where half-duplex is broken. Unfortunately,
only a single compatible is used for the MAC, so we have to use the board
compatible instead.

This has been tested on an LS1046ARDB. Without the serdes enabled,
everything works. With the serdes enabled, everything works but eth3 (aka
MAC6). On that interface, SGMII never completes AN for whatever reason. I
haven't tested the counterfactual (serdes enabled but no phylink). With
managed=phy (e.g. unspecified), I was unable to get the interfaces to come
up at all.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/dpaa/Kconfig   |   2 -
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  94 +---
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |  82 +--
 drivers/net/ethernet/freescale/fman/Makefile  |   3 +-
 .../net/ethernet/freescale/fman/fman_mac.h    |  10 -
 .../net/ethernet/freescale/fman/fman_memac.c  | 521 +++++++++---------
 drivers/net/ethernet/freescale/fman/mac.c     | 169 +-----
 drivers/net/ethernet/freescale/fman/mac.h     |  24 +-
 8 files changed, 327 insertions(+), 578 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig b/drivers/net/ethernet/freescale/dpaa/Kconfig
index 0ddcb1355daf..2b560661c82a 100644
--- a/drivers/net/ethernet/freescale/dpaa/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
@@ -2,8 +2,6 @@
 menuconfig FSL_DPAA_ETH
 	tristate "DPAA Ethernet"
 	depends on FSL_DPAA && FSL_FMAN
-	select PHYLIB
-	select FIXED_PHY
 	select PHYLINK
 	select PCS_LYNX
 	help
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 9d31fd1d8ad0..2caf353dd64d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -262,12 +262,26 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->needed_headroom = priv->tx_headroom;
 	net_dev->watchdog_timeo = msecs_to_jiffies(tx_timeout);
 
+	/* The rest of the config is filled in by the mac device already */
+	mac_dev->phylink_config.dev = &net_dev->dev;
+	mac_dev->phylink_config.type = PHYLINK_NETDEV;
+	mac_dev->phylink = phylink_create(&mac_dev->phylink_config,
+					  dev_fwnode(mac_dev->dev),
+					  mac_dev->phy_if,
+					  mac_dev->phylink_ops);
+	if (IS_ERR(mac_dev->phylink)) {
+		err = PTR_ERR(mac_dev->phylink);
+		dev_err_probe(dev, err, "Could not create phylink\n");
+		return err;
+	}
+
 	/* start without the RUNNING flag, phylib controls it later */
 	netif_carrier_off(net_dev);
 
 	err = register_netdev(net_dev);
 	if (err < 0) {
 		dev_err(dev, "register_netdev() = %d\n", err);
+		phylink_destroy(mac_dev->phylink);
 		return err;
 	}
 
@@ -289,21 +303,14 @@ static int dpaa_stop(struct net_device *net_dev)
 	 */
 	msleep(200);
 
-	if (mac_dev->phy_dev)
-		phy_stop(mac_dev->phy_dev);
-	err = mac_dev->disable(mac_dev->fman_mac);
-	if (err < 0)
-		netif_err(priv, ifdown, net_dev, "mac_dev->disable() = %d\n",
-			  err);
-
+	phylink_stop(mac_dev->phylink);
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
 		error = fman_port_disable(mac_dev->port[i]);
 		if (error)
 			err = error;
 	}
 
-	if (net_dev->phydev)
-		phy_disconnect(net_dev->phydev);
+	phylink_disconnect_phy(mac_dev->phylink);
 	net_dev->phydev = NULL;
 
 	msleep(200);
@@ -834,7 +841,9 @@ static int dpaa_eth_cgr_init(struct dpaa_priv *priv)
 	 * lower than its max, e.g. if a dTSEC later negotiates a 100Mbps link.
 	 * In such cases, we ought to reconfigure the threshold, too.
 	 */
-	if (priv->mac_dev->if_support & SUPPORTED_10000baseT_Full)
+	// FIXME
+	if (true)
+	//if (priv->mac_dev->if_support & SUPPORTED_10000baseT_Full)
 		cs_th = DPAA_CS_THRESHOLD_10G;
 	else
 		cs_th = DPAA_CS_THRESHOLD_1G;
@@ -2877,54 +2886,6 @@ static void dpaa_eth_napi_disable(struct dpaa_priv *priv)
 	}
 }
 
-static void dpaa_adjust_link(struct net_device *net_dev)
-{
-	struct mac_device *mac_dev;
-	struct dpaa_priv *priv;
-
-	priv = netdev_priv(net_dev);
-	mac_dev = priv->mac_dev;
-	mac_dev->adjust_link(mac_dev);
-}
-
-/* The Aquantia PHYs are capable of performing rate adaptation */
-#define PHY_VEND_AQUANTIA	0x03a1b400
-
-static int dpaa_phy_init(struct net_device *net_dev)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	struct mac_device *mac_dev;
-	struct phy_device *phy_dev;
-	struct dpaa_priv *priv;
-
-	priv = netdev_priv(net_dev);
-	mac_dev = priv->mac_dev;
-
-	phy_dev = of_phy_connect(net_dev, mac_dev->phy_node,
-				 &dpaa_adjust_link, 0,
-				 mac_dev->phy_if);
-	if (!phy_dev) {
-		netif_err(priv, ifup, net_dev, "init_phy() failed\n");
-		return -ENODEV;
-	}
-
-	/* Unless the PHY is capable of rate adaptation */
-	if (mac_dev->phy_if != PHY_INTERFACE_MODE_XGMII ||
-	    ((phy_dev->drv->phy_id & GENMASK(31, 10)) != PHY_VEND_AQUANTIA)) {
-		/* remove any features not supported by the controller */
-		ethtool_convert_legacy_u32_to_link_mode(mask,
-							mac_dev->if_support);
-		linkmode_and(phy_dev->supported, phy_dev->supported, mask);
-	}
-
-	phy_support_asym_pause(phy_dev);
-
-	mac_dev->phy_dev = phy_dev;
-	net_dev->phydev = phy_dev;
-
-	return 0;
-}
-
 static int dpaa_open(struct net_device *net_dev)
 {
 	struct mac_device *mac_dev;
@@ -2935,7 +2896,8 @@ static int dpaa_open(struct net_device *net_dev)
 	mac_dev = priv->mac_dev;
 	dpaa_eth_napi_enable(priv);
 
-	err = dpaa_phy_init(net_dev);
+	err = phylink_of_phy_connect(mac_dev->phylink,
+				     mac_dev->dev->of_node, 0);
 	if (err)
 		goto phy_init_failed;
 
@@ -2945,13 +2907,7 @@ static int dpaa_open(struct net_device *net_dev)
 			goto mac_start_failed;
 	}
 
-	err = priv->mac_dev->enable(mac_dev->fman_mac);
-	if (err < 0) {
-		netif_err(priv, ifup, net_dev, "mac_dev->enable() = %d\n", err);
-		goto mac_start_failed;
-	}
-	phy_start(priv->mac_dev->phy_dev);
-
+	phylink_start(mac_dev->phylink);
 	netif_tx_start_all_queues(net_dev);
 
 	return 0;
@@ -2959,6 +2915,7 @@ static int dpaa_open(struct net_device *net_dev)
 mac_start_failed:
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++)
 		fman_port_disable(mac_dev->port[i]);
+	phylink_disconnect_phy(mac_dev->phylink);
 
 phy_init_failed:
 	dpaa_eth_napi_disable(priv);
@@ -3114,10 +3071,12 @@ static int dpaa_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 static int dpaa_ioctl(struct net_device *net_dev, struct ifreq *rq, int cmd)
 {
 	int ret = -EINVAL;
+	struct dpaa_priv *priv = netdev_priv(net_dev);
 
 	if (cmd == SIOCGMIIREG) {
 		if (net_dev->phydev)
-			return phy_mii_ioctl(net_dev->phydev, rq, cmd);
+			return phylink_mii_ioctl(priv->mac_dev->phylink, rq,
+						 cmd);
 	}
 
 	if (cmd == SIOCSHWTSTAMP)
@@ -3521,6 +3480,7 @@ static int dpaa_remove(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, NULL);
 	unregister_netdev(net_dev);
+	phylink_destroy(priv->mac_dev->phylink);
 
 	err = dpaa_fq_free(dev, &priv->dpaa_fq_list);
 
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 73f07881ce2d..bf0690d21e3d 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -54,27 +54,19 @@ static char dpaa_stats_global[][ETH_GSTRING_LEN] = {
 static int dpaa_get_link_ksettings(struct net_device *net_dev,
 				   struct ethtool_link_ksettings *cmd)
 {
-	if (!net_dev->phydev)
-		return 0;
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct mac_device *mac_dev = priv->mac_dev;
 
-	phy_ethtool_ksettings_get(net_dev->phydev, cmd);
-
-	return 0;
+	return phylink_ethtool_ksettings_get(mac_dev->phylink, cmd);
 }
 
 static int dpaa_set_link_ksettings(struct net_device *net_dev,
 				   const struct ethtool_link_ksettings *cmd)
 {
-	int err;
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct mac_device *mac_dev = priv->mac_dev;
 
-	if (!net_dev->phydev)
-		return -ENODEV;
-
-	err = phy_ethtool_ksettings_set(net_dev->phydev, cmd);
-	if (err < 0)
-		netdev_err(net_dev, "phy_ethtool_ksettings_set() = %d\n", err);
-
-	return err;
+	return phylink_ethtool_ksettings_set(mac_dev->phylink, cmd);
 }
 
 static void dpaa_get_drvinfo(struct net_device *net_dev,
@@ -115,66 +107,6 @@ static int dpaa_nway_reset(struct net_device *net_dev)
 	return err;
 }
 
-static void dpaa_get_pauseparam(struct net_device *net_dev,
-				struct ethtool_pauseparam *epause)
-{
-	struct mac_device *mac_dev;
-	struct dpaa_priv *priv;
-
-	priv = netdev_priv(net_dev);
-	mac_dev = priv->mac_dev;
-
-	if (!net_dev->phydev)
-		return;
-
-	epause->autoneg = mac_dev->autoneg_pause;
-	epause->rx_pause = mac_dev->rx_pause_active;
-	epause->tx_pause = mac_dev->tx_pause_active;
-}
-
-static int dpaa_set_pauseparam(struct net_device *net_dev,
-			       struct ethtool_pauseparam *epause)
-{
-	struct mac_device *mac_dev;
-	struct phy_device *phydev;
-	bool rx_pause, tx_pause;
-	struct dpaa_priv *priv;
-	int err;
-
-	priv = netdev_priv(net_dev);
-	mac_dev = priv->mac_dev;
-
-	phydev = net_dev->phydev;
-	if (!phydev) {
-		netdev_err(net_dev, "phy device not initialized\n");
-		return -ENODEV;
-	}
-
-	if (!phy_validate_pause(phydev, epause))
-		return -EINVAL;
-
-	/* The MAC should know how to handle PAUSE frame autonegotiation before
-	 * adjust_link is triggered by a forced renegotiation of sym/asym PAUSE
-	 * settings.
-	 */
-	mac_dev->autoneg_pause = !!epause->autoneg;
-	mac_dev->rx_pause_req = !!epause->rx_pause;
-	mac_dev->tx_pause_req = !!epause->tx_pause;
-
-	/* Determine the sym/asym advertised PAUSE capabilities from the desired
-	 * rx/tx pause settings.
-	 */
-
-	phy_set_asym_pause(phydev, epause->rx_pause, epause->tx_pause);
-
-	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
-	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
-	if (err < 0)
-		netdev_err(net_dev, "set_mac_active_pause() = %d\n", err);
-
-	return err;
-}
-
 static int dpaa_get_sset_count(struct net_device *net_dev, int type)
 {
 	unsigned int total_stats, num_stats;
@@ -566,8 +498,6 @@ const struct ethtool_ops dpaa_ethtool_ops = {
 	.get_msglevel = dpaa_get_msglevel,
 	.set_msglevel = dpaa_set_msglevel,
 	.nway_reset = dpaa_nway_reset,
-	.get_pauseparam = dpaa_get_pauseparam,
-	.set_pauseparam = dpaa_set_pauseparam,
 	.get_link = ethtool_op_get_link,
 	.get_sset_count = dpaa_get_sset_count,
 	.get_ethtool_stats = dpaa_get_ethtool_stats,
diff --git a/drivers/net/ethernet/freescale/fman/Makefile b/drivers/net/ethernet/freescale/fman/Makefile
index b618091db091..ee0b9178187c 100644
--- a/drivers/net/ethernet/freescale/fman/Makefile
+++ b/drivers/net/ethernet/freescale/fman/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_FSL_FMAN) += fsl_dpaa_mac.o
 
 fsl_dpaa_fman-objs	:= fman_muram.o fman.o fman_sp.o fman_keygen.o
 fsl_dpaa_fman_port-objs := fman_port.o
-fsl_dpaa_mac-objs:= mac.o fman_dtsec.o fman_memac.o fman_tgec.o
+#fsl_dpaa_mac-objs:= mac.o fman_dtsec.o fman_memac.o fman_tgec.o
+fsl_dpaa_mac-objs := mac.o fman_memac.o
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 730aae7fed13..837ecf1c97c8 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -169,20 +169,10 @@ struct fman_mac_params {
 	 * 0 - FM_MAX_NUM_OF_10G_MACS
 	 */
 	u8 mac_id;
-	/* Note that the speed should indicate the maximum rate that
-	 * this MAC should support rather than the actual speed;
-	 */
-	u16 max_speed;
 	/* A handle to the FM object this port related to */
 	void *fm;
 	fman_mac_exception_cb *event_cb;    /* MDIO Events Callback Routine */
 	fman_mac_exception_cb *exception_cb;/* Exception Callback Routine */
-	/* SGMII/QSGII interface with 1000BaseX auto-negotiation between MAC
-	 * and phy or backplane; Note: 1000BaseX auto-negotiation relates only
-	 * to interface between MAC and phy/backplane, SGMII phy can still
-	 * synchronize with far-end phy at 10Mbps, 100Mbps or 1000Mbps
-	*/
-	bool basex_if;
 };
 
 struct eth_hash_t {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 3eea6710013a..d12dbb7f173a 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -66,6 +66,12 @@ do {									\
 #define IF_MODE_RGMII_FD	0x00001000 /* Full duplex RGMII */
 #define IF_MODE_HD		0x00000040 /* Half duplex operation */
 
+#define IF_STATUS_RGLINK	BIT(15)
+#define IF_STATUS_RGSP		GENMASK(14, 13)
+#define IF_STATUS_RGSP_10	0
+#define IF_STATUS_RGSP_100	1
+#define IF_STATUS_RGSP_1000	2
+
 /* Hash table Control Register (HASHTABLE_CTRL) */
 #define HASH_CTRL_MCAST_EN	0x00000100
 /* 26-31 Hash table address code */
@@ -273,14 +279,16 @@ struct memac_cfg {
 	u32 tx_ipg_length;
 };
 
+struct memac_pcs {
+	struct phylink_pcs pcs;
+	struct phy_device *phy;
+};
+
 struct fman_mac {
 	/* Pointer to MAC memory mapped registers */
 	struct memac_regs __iomem *regs;
 	/* MAC address of device */
 	u64 addr;
-	/* Ethernet physical interface */
-	phy_interface_t phy_if;
-	u16 max_speed;
 	void *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
@@ -293,7 +301,6 @@ struct fman_mac {
 	struct memac_cfg *memac_drv_param;
 	void *fm;
 	struct fman_rev_info fm_rev_info;
-	bool basex_if;
 	struct phy *serdes;
 	struct phylink_pcs *sgmii_pcs;
 	struct phylink_pcs *qsgmii_pcs;
@@ -356,7 +363,6 @@ static void set_exception(struct memac_regs __iomem *regs, u32 val,
 }
 
 static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
-		phy_interface_t phy_if, u16 speed, bool slow_10g_if,
 		u32 exceptions)
 {
 	u32 tmp;
@@ -384,41 +390,6 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
 	iowrite32be((u32)cfg->pause_quanta, &regs->pause_quanta[0]);
 	iowrite32be((u32)0, &regs->pause_thresh[0]);
 
-	/* IF_MODE */
-	tmp = 0;
-	switch (phy_if) {
-	case PHY_INTERFACE_MODE_XGMII:
-		tmp |= IF_MODE_10G;
-		break;
-	case PHY_INTERFACE_MODE_MII:
-		tmp |= IF_MODE_MII;
-		break;
-	default:
-		tmp |= IF_MODE_GMII;
-		if (phy_if == PHY_INTERFACE_MODE_RGMII ||
-		    phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
-		    phy_if == PHY_INTERFACE_MODE_RGMII_RXID ||
-		    phy_if == PHY_INTERFACE_MODE_RGMII_TXID)
-			tmp |= IF_MODE_RGMII | IF_MODE_RGMII_AUTO;
-	}
-	iowrite32be(tmp, &regs->if_mode);
-
-	/* TX_FIFO_SECTIONS */
-	tmp = 0;
-	if (phy_if == PHY_INTERFACE_MODE_XGMII) {
-		if (slow_10g_if) {
-			tmp |= (TX_FIFO_SECTIONS_TX_AVAIL_SLOW_10G |
-				TX_FIFO_SECTIONS_TX_EMPTY_DEFAULT_10G);
-		} else {
-			tmp |= (TX_FIFO_SECTIONS_TX_AVAIL_10G |
-				TX_FIFO_SECTIONS_TX_EMPTY_DEFAULT_10G);
-		}
-	} else {
-		tmp |= (TX_FIFO_SECTIONS_TX_AVAIL_1G |
-			TX_FIFO_SECTIONS_TX_EMPTY_DEFAULT_1G);
-	}
-	iowrite32be(tmp, &regs->tx_fifo_sections);
-
 	/* clear all pending events and set-up interrupts */
 	iowrite32be(0xffffffff, &regs->ievent);
 	set_exception(regs, exceptions, true);
@@ -458,24 +429,6 @@ static u32 get_mac_addr_hash_code(u64 eth_addr)
 	return xor_val;
 }
 
-static void setup_sgmii_internal(struct fman_mac *memac,
-				 struct phylink_pcs *pcs,
-				 struct fixed_phy_status *fixed_link)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
-	phy_interface_t iface = memac->basex_if ? PHY_INTERFACE_MODE_1000BASEX :
-				PHY_INTERFACE_MODE_SGMII;
-	unsigned int mode = fixed_link ? MLO_AN_FIXED : MLO_AN_INBAND;
-
-	linkmode_set_pause(advertising, true, true);
-	pcs->ops->pcs_config(pcs, mode, iface, advertising, true);
-	if (fixed_link)
-		pcs->ops->pcs_link_up(pcs, mode, iface, fixed_link->speed,
-				      fixed_link->duplex);
-	else
-		pcs->ops->pcs_an_restart(pcs);
-}
-
 static int check_init_parameters(struct fman_mac *memac)
 {
 	if (!memac->exception_cb) {
@@ -581,53 +534,11 @@ static void free_init_resources(struct fman_mac *memac)
 	memac->unicast_addr_hash = NULL;
 }
 
-static bool is_init_done(struct memac_cfg *memac_drv_params)
-{
-	/* Checks if mEMAC driver parameters were initialized */
-	if (!memac_drv_params)
-		return true;
-
-	return false;
-}
-
-static int memac_enable(struct fman_mac *memac)
-{
-	struct memac_regs __iomem *regs = memac->regs;
-	u32 tmp;
-
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	tmp = ioread32be(&regs->command_config);
-	tmp |= CMD_CFG_RX_EN | CMD_CFG_TX_EN;
-	iowrite32be(tmp, &regs->command_config);
-
-	return 0;
-}
-
-static int memac_disable(struct fman_mac *memac)
-{
-	struct memac_regs __iomem *regs = memac->regs;
-	u32 tmp;
-
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	tmp = ioread32be(&regs->command_config);
-	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
-	iowrite32be(tmp, &regs->command_config);
-
-	return 0;
-}
-
 static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->command_config);
 	if (new_val)
 		tmp |= CMD_CFG_PROMIS_EN;
@@ -639,72 +550,12 @@ static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 	return 0;
 }
 
-static int memac_adjust_link(struct fman_mac *memac, u16 speed)
-{
-	struct memac_regs __iomem *regs = memac->regs;
-	u32 tmp;
-
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
-	tmp = ioread32be(&regs->if_mode);
-
-	/* Set full duplex */
-	tmp &= ~IF_MODE_HD;
-
-	if (phy_interface_mode_is_rgmii(memac->phy_if)) {
-		/* Configure RGMII in manual mode */
-		tmp &= ~IF_MODE_RGMII_AUTO;
-		tmp &= ~IF_MODE_RGMII_SP_MASK;
-		/* Full duplex */
-		tmp |= IF_MODE_RGMII_FD;
-
-		switch (speed) {
-		case SPEED_1000:
-			tmp |= IF_MODE_RGMII_1000;
-			break;
-		case SPEED_100:
-			tmp |= IF_MODE_RGMII_100;
-			break;
-		case SPEED_10:
-			tmp |= IF_MODE_RGMII_10;
-			break;
-		default:
-			break;
-		}
-	}
-
-	iowrite32be(tmp, &regs->if_mode);
-
-	return 0;
-}
-
-static void adjust_link_memac(struct mac_device *mac_dev)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct fman_mac *fman_mac;
-	bool rx_pause, tx_pause;
-	int err;
-
-	fman_mac = mac_dev->fman_mac;
-	memac_adjust_link(fman_mac, phy_dev->speed);
-
-	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
-	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
-	if (err < 0)
-		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
-			err);
-}
-
 static int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 				     u16 pause_time, u16 thresh_time)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->tx_fifo_sections);
 
 	GET_TX_EMPTY_DEFAULT_VALUE(tmp);
@@ -739,9 +590,6 @@ static int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->command_config);
 	if (en)
 		tmp &= ~CMD_CFG_PAUSE_IGNORE;
@@ -753,12 +601,160 @@ static int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	return 0;
 }
 
+/**
+ * memac_if_mode() - Convert an interface mode into an IF_MODE config
+ * @interface: A phy interface mode
+ *
+ * Return: A configuration word, suitable for programming into the lower bits
+ *         of %IF_MODE.
+ */
+static u32 memac_if_mode(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_MII:
+		return IF_MODE_MII;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		return IF_MODE_GMII | IF_MODE_RGMII;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_QSGMII:
+		return IF_MODE_GMII;
+	case PHY_INTERFACE_MODE_10GBASER:
+		return IF_MODE_10G;
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+static struct phylink_pcs *memac_select_pcs(struct phylink_config *config,
+					    phy_interface_t iface)
+{
+	struct fman_mac *memac = fman_config_to_mac(config)->fman_mac;
+
+	switch (iface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		return memac->sgmii_pcs;
+	case PHY_INTERFACE_MODE_QSGMII:
+		return memac->qsgmii_pcs;
+	case PHY_INTERFACE_MODE_10GBASER:
+		return memac->xfi_pcs;
+	default:
+		return NULL;
+	}
+}
+
+static int memac_prepare(struct phylink_config *config, unsigned int mode,
+			 phy_interface_t iface)
+{
+	struct fman_mac *memac = fman_config_to_mac(config)->fman_mac;
+
+	switch (iface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_10GBASER:
+		return phy_set_mode_ext(memac->serdes, PHY_MODE_ETHERNET,
+					iface);
+	default:
+		return 0;
+	}
+}
+
+static void memac_mac_config(struct phylink_config *config, unsigned int mode,
+			     const struct phylink_link_state *state)
+{
+	struct mac_device *mac_dev = fman_config_to_mac(config);
+	struct memac_regs __iomem *regs = mac_dev->fman_mac->regs;
+	u32 tmp = ioread32be(&regs->if_mode);
+
+	tmp &= ~(IF_MODE_MASK | IF_MODE_RGMII);
+	tmp |= memac_if_mode(state->interface);
+	if (phylink_autoneg_inband(mode))
+		tmp |= IF_MODE_RGMII_AUTO;
+	iowrite32be(tmp, &regs->if_mode);
+}
+
+static void memac_link_up(struct phylink_config *config, struct phy_device *phy,
+			  unsigned int mode, phy_interface_t interface,
+			  int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct mac_device *mac_dev = fman_config_to_mac(config);
+	struct fman_mac *memac = mac_dev->fman_mac;
+	struct memac_regs __iomem *regs = memac->regs;
+	u32 tmp = memac_if_mode(interface);
+	u16 pause_time = tx_pause ? FSL_FM_PAUSE_TIME_ENABLE :
+			 FSL_FM_PAUSE_TIME_DISABLE;
+
+	memac_set_tx_pause_frames(memac, 0, pause_time, 0);
+	memac_accept_rx_pause_frames(memac, rx_pause);
+
+	if (duplex == DUPLEX_HALF)
+		tmp |= IF_MODE_HD;
+
+	switch (speed) {
+	case SPEED_1000:
+		tmp |= IF_MODE_RGMII_1000;
+		break;
+	case SPEED_100:
+		tmp |= IF_MODE_RGMII_100;
+		break;
+	case SPEED_10:
+		tmp |= IF_MODE_RGMII_10;
+		break;
+	}
+	iowrite32be(tmp, &regs->if_mode);
+
+	if (phy)
+		phy_init_eee(phy, 0);
+
+	if (speed == SPEED_10000) {
+		if (memac->fm_rev_info.major == 6 &&
+		    memac->fm_rev_info.minor == 4)
+			tmp = TX_FIFO_SECTIONS_TX_AVAIL_SLOW_10G;
+		else
+			tmp = TX_FIFO_SECTIONS_TX_AVAIL_10G;
+		tmp |= TX_FIFO_SECTIONS_TX_EMPTY_DEFAULT_10G;
+	} else {
+		tmp = TX_FIFO_SECTIONS_TX_AVAIL_1G |
+		      TX_FIFO_SECTIONS_TX_EMPTY_DEFAULT_1G;
+	}
+	iowrite32be(tmp, &regs->tx_fifo_sections);
+
+	tmp = ioread32be(&regs->command_config);
+	tmp |= CMD_CFG_RX_EN | CMD_CFG_TX_EN;
+	iowrite32be(tmp, &regs->command_config);
+}
+
+static void memac_link_down(struct phylink_config *config, unsigned int mode,
+			    phy_interface_t interface)
+{
+	struct fman_mac *memac = fman_config_to_mac(config)->fman_mac;
+	struct memac_regs __iomem *regs = memac->regs;
+	u32 tmp;
+
+	/* TODO: graceful */
+	tmp = ioread32be(&regs->command_config);
+	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
+	iowrite32be(tmp, &regs->command_config);
+}
+
+static const struct phylink_mac_ops memac_phylink_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_select_pcs = memac_select_pcs,
+	.mac_prepare = memac_prepare,
+	.mac_config = memac_mac_config,
+	.mac_link_up = memac_link_up,
+	.mac_link_down = memac_link_down,
+};
+
 static int memac_modify_mac_address(struct fman_mac *memac,
 				    const enet_addr_t *enet_addr)
 {
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	add_addr_in_paddr(memac->regs, (const u8 *)(*enet_addr), 0);
 
 	return 0;
@@ -772,9 +768,6 @@ static int memac_add_hash_mac_address(struct fman_mac *memac,
 	u32 hash;
 	u64 addr;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	addr = ENET_ADDR_TO_UINT64(*eth_addr);
 
 	if (!(addr & GROUP_ADDRESS)) {
@@ -803,9 +796,6 @@ static int memac_set_allmulti(struct fman_mac *memac, bool enable)
 	u32 entry;
 	struct memac_regs __iomem *regs = memac->regs;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	if (enable) {
 		for (entry = 0; entry < HASH_TABLE_SIZE; entry++)
 			iowrite32be(entry | HASH_CTRL_MCAST_EN,
@@ -835,9 +825,6 @@ static int memac_del_hash_mac_address(struct fman_mac *memac,
 	u32 hash;
 	u64 addr;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	addr = ENET_ADDR_TO_UINT64(*eth_addr);
 
 	hash = get_mac_addr_hash_code(addr) & HASH_CTRL_ADDR_MASK;
@@ -865,9 +852,6 @@ static int memac_set_exception(struct fman_mac *memac,
 {
 	u32 bit_mask = 0;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	bit_mask = get_exception_flag(exception);
 	if (bit_mask) {
 		if (enable)
@@ -888,13 +872,9 @@ static int memac_init(struct fman_mac *memac)
 	struct memac_cfg *memac_drv_param;
 	enet_addr_t eth_addr;
 	bool slow_10g_if = false;
-	struct fixed_phy_status *fixed_link;
 	int err;
 	u32 reg32 = 0;
 
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	err = check_init_parameters(memac);
 	if (err)
 		return err;
@@ -919,10 +899,7 @@ static int memac_init(struct fman_mac *memac)
 		add_addr_in_paddr(memac->regs, (const u8 *)eth_addr, 0);
 	}
 
-	fixed_link = memac_drv_param->fixed_link;
-
-	init(memac->regs, memac->memac_drv_param, memac->phy_if,
-	     memac->max_speed, slow_10g_if, memac->exceptions);
+	init(memac->regs, memac->memac_drv_param, memac->exceptions);
 
 	/* FM_RX_FIFO_CORRUPT_ERRATA_10GMAC_A006320 errata workaround
 	 * Exists only in FMan 6.0 and 6.3.
@@ -938,11 +915,6 @@ static int memac_init(struct fman_mac *memac)
 		iowrite32be(reg32, &memac->regs->command_config);
 	}
 
-	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII)
-		setup_sgmii_internal(memac, memac->sgmii_pcs, fixed_link);
-	else if (memac->phy_if == PHY_INTERFACE_MODE_QSGMII)
-		setup_sgmii_internal(memac, memac->qsgmii_pcs, fixed_link);
-
 	/* Max Frame Length */
 	err = fman_set_mac_max_frame(memac->fm, memac->mac_id,
 				     memac_drv_param->max_frame_length);
@@ -971,9 +943,6 @@ static int memac_init(struct fman_mac *memac)
 	fman_register_intr(memac->fm, FMAN_MOD_MAC, memac->mac_id,
 			   FMAN_INTR_TYPE_NORMAL, memac_exception, memac);
 
-	kfree(memac_drv_param);
-	memac->memac_drv_param = NULL;
-
 	return 0;
 }
 
@@ -1020,8 +989,6 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
 	memac->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 
 	memac->regs = mac_dev->vaddr;
-	memac->max_speed = params->max_speed;
-	memac->phy_if = mac_dev->phy_if;
 	memac->mac_id = params->mac_id;
 	memac->exceptions = (MEMAC_IMASK_TSECC_ER | MEMAC_IMASK_TECC_ER |
 			     MEMAC_IMASK_RECC_ER | MEMAC_IMASK_MGI);
@@ -1029,7 +996,6 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
 	memac->event_cb = params->event_cb;
 	memac->dev_id = mac_dev;
 	memac->fm = params->fm;
-	memac->basex_if = params->basex_if;
 
 	/* Save FMan revision */
 	fman_get_revision(memac->fm, &memac->fm_rev_info);
@@ -1054,33 +1020,40 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
 	return lynx_pcs_create(mdiodev) ?: ERR_PTR(-ENOMEM);
 }
 
+static bool memac_supports(struct mac_device *mac_dev, phy_interface_t iface)
+{
+	/* If there's no serdes device, assume that it's been configured for
+	 * whatever the default interface mode is.
+	 */
+	if (!mac_dev->fman_mac->serdes)
+		return mac_dev->phy_if == iface;
+	/* Otherwise, ask the serdes */
+	return !phy_validate(mac_dev->fman_mac->serdes, PHY_MODE_ETHERNET,
+			     iface, NULL);
+}
+
 int memac_initialization(struct mac_device *mac_dev,
 			 struct device_node *mac_node,
 			 struct fman_mac_params *params)
 {
 	int			 err;
+	struct device_node	*fixed;
 	struct mac_priv_s	*priv;
 	struct phylink_pcs	*pcs;
-	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
+	unsigned long		capabilities;
+	unsigned long		*supported;
 
 	priv = mac_dev->priv;
+	mac_dev->phylink_ops		= &memac_phylink_mac_ops;
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
 	mac_dev->remove_hash_mac_addr	= memac_del_hash_mac_address;
-	mac_dev->set_tx_pause		= memac_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= memac_accept_rx_pause_frames;
 	mac_dev->set_exception		= memac_set_exception;
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
 	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_memac;
-	mac_dev->enable			= memac_enable;
-	mac_dev->disable		= memac_disable;
-
-	if (params->max_speed == SPEED_10000)
-		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
 
 	mac_dev->fman_mac = memac_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
@@ -1150,6 +1123,7 @@ int memac_initialization(struct mac_device *mac_dev,
 		dev_err_probe(mac_dev->dev, err, "could not get serdes\n");
 		goto _return_fm_mac_free;
 	} else {
+		/* FIXME: init/power on at an appropriate time... */
 		err = phy_init(memac->serdes);
 		if (err) {
 			dev_err_probe(mac_dev->dev, err,
@@ -1163,57 +1137,114 @@ int memac_initialization(struct mac_device *mac_dev,
 				      "could not power on serdes\n");
 			goto _return_phy_exit;
 		}
+	}
 
-		if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
-		    memac->phy_if == PHY_INTERFACE_MODE_1000BASEX ||
-		    memac->phy_if == PHY_INTERFACE_MODE_2500BASEX ||
-		    memac->phy_if == PHY_INTERFACE_MODE_QSGMII ||
-		    memac->phy_if == PHY_INTERFACE_MODE_XGMII) {
-			err = phy_set_mode_ext(memac->serdes, PHY_MODE_ETHERNET,
-					       memac->phy_if);
-			if (err) {
-				dev_err_probe(mac_dev->dev, err,
-					      "could not set serdes mode to %s\n",
-					      phy_modes(memac->phy_if));
-				goto _return_phy_power_off;
-			}
-		}
+	/* The internal connection to the serdes is XGMII, but this isn't
+	 * really correct for the phy mode (which is the external connection).
+	 * However, this is how all older device trees say that they want
+	 * 10GBase-R (aka XFI), so just convert it for them.
+	 */
+	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
+		mac_dev->phy_if = PHY_INTERFACE_MODE_10GBASER;
+
+	/* TODO: The following interface modes are supported by (some) hardware
+	 * but not by this driver:
+	 * - 1000Base-KX
+	 * - 10GBase-KR
+	 * - XAUI/HiGig
+	 */
+	supported = mac_dev->phylink_config.supported_interfaces;
+	capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+
+	/* Note that half duplex is only supported on 10/100M interfaces. */
+
+	if (memac->sgmii_pcs &&
+	    (memac_supports(mac_dev, PHY_INTERFACE_MODE_SGMII) ||
+	     memac_supports(mac_dev, PHY_INTERFACE_MODE_1000BASEX))) {
+		capabilities |= MAC_10 | MAC_100 | MAC_1000FD;
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
 	}
 
-	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
-		struct phy_device *phy;
+	if (memac->sgmii_pcs &&
+	    memac_supports(mac_dev, PHY_INTERFACE_MODE_2500BASEX)) {
+		capabilities |= MAC_2500FD;
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+	}
 
-		err = of_phy_register_fixed_link(mac_node);
-		if (err)
-			goto _return_phy_power_off;
+	if (memac->qsgmii_pcs &&
+	    memac_supports(mac_dev, PHY_INTERFACE_MODE_QSGMII)) {
+		capabilities |= MAC_10 | MAC_100 | MAC_1000FD;
+		__set_bit(PHY_INTERFACE_MODE_QSGMII, supported);
+	} else if (mac_dev->phy_if == PHY_INTERFACE_MODE_QSGMII) {
+		dev_warn(mac_dev->dev, "no QSGMII pcs specified\n");
+	}
+
+	if (memac->xfi_pcs &&
+	    memac_supports(mac_dev, PHY_INTERFACE_MODE_10GBASER)) {
+		capabilities |= MAC_10000FD;
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+	} else {
+		/* From what I can tell, only 1G macs support RGMII. */
+		/* For compatibility, default to enabled if the rgmii property
+		 * is absent
+		 */
+		unsigned int rgmii = 1;
 
-		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
-		if (!fixed_link) {
-			err = -ENOMEM;
+		err = of_property_read_u32(mac_node, "rgmii", &rgmii);
+		if (err == -EINVAL)
+			dev_warn(mac_dev->dev,
+				 "missing 'rgmii' property; assuming supported\n");
+		else if (err)
 			goto _return_phy_power_off;
-		}
 
-		mac_dev->phy_node = of_node_get(mac_node);
-		phy = of_phy_find_device(mac_dev->phy_node);
-		if (!phy) {
-			err = -EINVAL;
-			of_node_put(mac_dev->phy_node);
-			goto _return_fixed_link_free;
+		if (rgmii) {
+			capabilities |= MAC_10FD | MAC_100FD | MAC_1000FD;
+			/* The T2080 and T4240 don't support half duplex RGMII.
+			 * There is no other way to identify these SoCs, so
+			 * just use the machine compatible.
+			 */
+			if (!of_machine_is_compatible("fsl,T2080QDS") &&
+			    !of_machine_is_compatible("fsl,T2080RDB") &&
+			    !of_machine_is_compatible("fsl,T2081QDS") &&
+			    !of_machine_is_compatible("fsl,T4240QDS") &&
+			    !of_machine_is_compatible("fsl,T4240RDB"))
+				capabilities |= MAC_10HD | MAC_100HD;
+			phy_interface_set_rgmii(supported);
+
+			if (of_property_read_bool(mac_node, "mii"))
+				__set_bit(PHY_INTERFACE_MODE_MII, supported);
 		}
+	}
 
-		fixed_link->link = phy->link;
-		fixed_link->speed = phy->speed;
-		fixed_link->duplex = phy->duplex;
-		fixed_link->pause = phy->pause;
-		fixed_link->asym_pause = phy->asym_pause;
+	/* These SoCs don't support half duplex at all; there's no different
+	 * FMan version or compatible, so we just have to check the machine
+	 * compatible instead
+	 */
+	if (of_machine_is_compatible("fsl,ls1043a") ||
+	    of_machine_is_compatible("fsl,ls1046a") ||
+	    of_machine_is_compatible("fsl,B4QDS"))
+		capabilities &= ~(MAC_10HD | MAC_100HD);
 
-		put_device(&phy->mdio.dev);
-		memac->memac_drv_param->fixed_link = fixed_link;
-	}
+	mac_dev->phylink_config.mac_capabilities = capabilities;
+
+	/* Most boards should use MLO_AN_INBAND, but existing boards don't have
+	 * a managed property. Default to MLO_AN_INBAND if nothing else is
+	 * specified. We need to be careful and not enable this if we have a
+	 * fixed link or if we are using MII or RGMII, since those
+	 * configurations modes don't use in-band autonegotiation.
+	 */
+	fixed = of_get_child_by_name(mac_node, "fixed-link");
+	if (!fixed && !of_property_read_bool(mac_node, "fixed-link") &&
+	    !of_property_read_bool(mac_node, "managed") &&
+	    mac_dev->phy_if != PHY_INTERFACE_MODE_MII &&
+	    !phy_interface_mode_is_rgmii(mac_dev->phy_if))
+		mac_dev->phylink_config.ovr_an_inband = true;
+	of_node_put(fixed);
 
 	err = memac_init(mac_dev->fman_mac);
 	if (err < 0)
-		goto _return_fixed_link_free;
+		goto _return_fm_mac_free;
 
 	dev_info(mac_dev->dev, "FMan MEMAC\n");
 
@@ -1223,8 +1254,6 @@ int memac_initialization(struct mac_device *mac_dev,
 	phy_power_off(memac->serdes);
 _return_phy_exit:
 	phy_exit(memac->serdes);
-_return_fixed_link_free:
-	kfree(fixed_link);
 _return_fm_mac_free:
 	memac_free(mac_dev->fman_mac);
 _return:
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index c02f38ab335e..f59e71c23569 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -15,6 +15,7 @@
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/phy_fixed.h>
+#include <linux/phylink.h>
 #include <linux/etherdevice.h>
 #include <linux/libfdt_env.h>
 
@@ -98,130 +99,8 @@ int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 	return 0;
 }
 
-/**
- * fman_set_mac_active_pause
- * @mac_dev:	A pointer to the MAC device
- * @rx:		Pause frame setting for RX
- * @tx:		Pause frame setting for TX
- *
- * Set the MAC RX/TX PAUSE frames settings
- *
- * Avoid redundant calls to FMD, if the MAC driver already contains the desired
- * active PAUSE settings. Otherwise, the new active settings should be reflected
- * in FMan.
- *
- * Return: 0 on success; Error code otherwise.
- */
-int fman_set_mac_active_pause(struct mac_device *mac_dev, bool rx, bool tx)
-{
-	struct fman_mac *fman_mac = mac_dev->fman_mac;
-	int err = 0;
-
-	if (rx != mac_dev->rx_pause_active) {
-		err = mac_dev->set_rx_pause(fman_mac, rx);
-		if (likely(err == 0))
-			mac_dev->rx_pause_active = rx;
-	}
-
-	if (tx != mac_dev->tx_pause_active) {
-		u16 pause_time = (tx ? FSL_FM_PAUSE_TIME_ENABLE :
-					 FSL_FM_PAUSE_TIME_DISABLE);
-
-		err = mac_dev->set_tx_pause(fman_mac, 0, pause_time, 0);
-
-		if (likely(err == 0))
-			mac_dev->tx_pause_active = tx;
-	}
-
-	return err;
-}
-EXPORT_SYMBOL(fman_set_mac_active_pause);
-
-/**
- * fman_get_pause_cfg
- * @mac_dev:	A pointer to the MAC device
- * @rx_pause:	Return value for RX setting
- * @tx_pause:	Return value for TX setting
- *
- * Determine the MAC RX/TX PAUSE frames settings based on PHY
- * autonegotiation or values set by eththool.
- *
- * Return: Pointer to FMan device.
- */
-void fman_get_pause_cfg(struct mac_device *mac_dev, bool *rx_pause,
-			bool *tx_pause)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	u16 lcl_adv, rmt_adv;
-	u8 flowctrl;
-
-	*rx_pause = *tx_pause = false;
-
-	if (!phy_dev->duplex)
-		return;
-
-	/* If PAUSE autonegotiation is disabled, the TX/RX PAUSE settings
-	 * are those set by ethtool.
-	 */
-	if (!mac_dev->autoneg_pause) {
-		*rx_pause = mac_dev->rx_pause_req;
-		*tx_pause = mac_dev->tx_pause_req;
-		return;
-	}
-
-	/* Else if PAUSE autonegotiation is enabled, the TX/RX PAUSE
-	 * settings depend on the result of the link negotiation.
-	 */
-
-	/* get local capabilities */
-	lcl_adv = linkmode_adv_to_lcl_adv_t(phy_dev->advertising);
-
-	/* get link partner capabilities */
-	rmt_adv = 0;
-	if (phy_dev->pause)
-		rmt_adv |= LPA_PAUSE_CAP;
-	if (phy_dev->asym_pause)
-		rmt_adv |= LPA_PAUSE_ASYM;
-
-	/* Calculate TX/RX settings based on local and peer advertised
-	 * symmetric/asymmetric PAUSE capabilities.
-	 */
-	flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
-	if (flowctrl & FLOW_CTRL_RX)
-		*rx_pause = true;
-	if (flowctrl & FLOW_CTRL_TX)
-		*tx_pause = true;
-}
-EXPORT_SYMBOL(fman_get_pause_cfg);
-
-#define DTSEC_SUPPORTED \
-	(SUPPORTED_10baseT_Half \
-	| SUPPORTED_10baseT_Full \
-	| SUPPORTED_100baseT_Half \
-	| SUPPORTED_100baseT_Full \
-	| SUPPORTED_Autoneg \
-	| SUPPORTED_Pause \
-	| SUPPORTED_Asym_Pause \
-	| SUPPORTED_FIBRE \
-	| SUPPORTED_MII)
-
 static DEFINE_MUTEX(eth_lock);
 
-static const u16 phy2speed[] = {
-	[PHY_INTERFACE_MODE_MII]		= SPEED_100,
-	[PHY_INTERFACE_MODE_GMII]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_SGMII]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_TBI]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_RMII]		= SPEED_100,
-	[PHY_INTERFACE_MODE_RGMII]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_RGMII_ID]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_RGMII_RXID]	= SPEED_1000,
-	[PHY_INTERFACE_MODE_RGMII_TXID]	= SPEED_1000,
-	[PHY_INTERFACE_MODE_RTBI]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_QSGMII]		= SPEED_1000,
-	[PHY_INTERFACE_MODE_XGMII]		= SPEED_10000
-};
-
 static struct platform_device *dpaa_eth_add_device(int fman_id,
 						   struct mac_device *mac_dev)
 {
@@ -268,8 +147,9 @@ static struct platform_device *dpaa_eth_add_device(int fman_id,
 }
 
 static const struct of_device_id mac_match[] = {
-	{ .compatible	= "fsl,fman-dtsec", .data = dtsec_initialization },
-	{ .compatible	= "fsl,fman-xgec", .data = tgec_initialization },
+	// TODO
+	//{ .compatible   = "fsl,fman-dtsec", .data = dtsec_initialization },
+	//{ .compatible   = "fsl,fman-xgec", .data = tgec_initialization },
 	{ .compatible	= "fsl,fman-memac", .data = memac_initialization },
 	{}
 };
@@ -301,6 +181,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	platform_set_drvdata(_of_dev, mac_dev);
 
 	/* Save private information */
 	mac_dev->priv = priv;
@@ -429,57 +310,21 @@ static int mac_probe(struct platform_device *_of_dev)
 	}
 	mac_dev->phy_if = phy_if;
 
-	priv->speed		= phy2speed[mac_dev->phy_if];
-	params.max_speed	= priv->speed;
-	mac_dev->if_support	= DTSEC_SUPPORTED;
-	/* We don't support half-duplex in SGMII mode */
-	if (mac_dev->phy_if == PHY_INTERFACE_MODE_SGMII)
-		mac_dev->if_support &= ~(SUPPORTED_10baseT_Half |
-					SUPPORTED_100baseT_Half);
-
-	/* Gigabit support (no half-duplex) */
-	if (params.max_speed == 1000)
-		mac_dev->if_support |= SUPPORTED_1000baseT_Full;
-
-	/* The 10G interface only supports one mode */
-	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
-		mac_dev->if_support = SUPPORTED_10000baseT_Full;
-
-	/* Get the rest of the PHY information */
-	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
-
-	params.basex_if		= false;
 	params.mac_id		= priv->cell_index;
 	params.fm		= (void *)priv->fman;
 	params.exception_cb	= mac_exception;
 	params.event_cb		= mac_exception;
 
 	err = init(mac_dev, mac_node, &params);
-	if (err < 0) {
-		dev_err(dev, "mac_dev->init() = %d\n", err);
-		of_node_put(mac_dev->phy_node);
-		return err;
-	}
-
-	/* pause frame autonegotiation enabled */
-	mac_dev->autoneg_pause = true;
-
-	/* By intializing the values to false, force FMD to enable PAUSE frames
-	 * on RX and TX
-	 */
-	mac_dev->rx_pause_req = true;
-	mac_dev->tx_pause_req = true;
-	mac_dev->rx_pause_active = false;
-	mac_dev->tx_pause_active = false;
-	err = fman_set_mac_active_pause(mac_dev, true, true);
 	if (err < 0)
-		dev_err(dev, "fman_set_mac_active_pause() = %d\n", err);
+		return err;
 
 	if (!is_zero_ether_addr(mac_dev->addr))
 		dev_info(dev, "FMan MAC address: %pM\n", mac_dev->addr);
 
 	priv->eth_dev = dpaa_eth_add_device(fman_id, mac_dev);
 	if (IS_ERR(priv->eth_dev)) {
+		err = PTR_ERR(priv->eth_dev);
 		dev_err(dev, "failed to add Ethernet platform device for MAC %d\n",
 			priv->cell_index);
 		priv->eth_dev = NULL;
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index c5fb4d46210f..199ea046580a 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/if_ether.h>
 #include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/list.h>
 
 #include "fman_port.h"
@@ -24,31 +25,20 @@ struct mac_device {
 	struct device		*dev;
 	u8			 addr[ETH_ALEN];
 	struct fman_port	*port[2];
-	u32			 if_support;
-	struct phy_device	*phy_dev;
+	struct phylink		*phylink;
+	struct phylink_config	phylink_config;
 	phy_interface_t		phy_if;
-	struct device_node	*phy_node;
 
-	bool autoneg_pause;
-	bool rx_pause_req;
-	bool tx_pause_req;
-	bool rx_pause_active;
-	bool tx_pause_active;
 	bool promisc;
 	bool allmulti;
 
-	int (*enable)(struct fman_mac *mac_dev);
-	int (*disable)(struct fman_mac *mac_dev);
-	void (*adjust_link)(struct mac_device *mac_dev);
+	const struct phylink_mac_ops *phylink_ops;
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
 	int (*change_addr)(struct fman_mac *mac_dev, const enet_addr_t *enet_addr);
 	int (*set_allmulti)(struct fman_mac *mac_dev, bool enable);
 	int (*set_tstamp)(struct fman_mac *mac_dev, bool enable);
 	int (*set_multi)(struct net_device *net_dev,
 			 struct mac_device *mac_dev);
-	int (*set_rx_pause)(struct fman_mac *mac_dev, bool en);
-	int (*set_tx_pause)(struct fman_mac *mac_dev, u8 priority,
-			    u16 pause_time, u16 thresh_time);
 	int (*set_exception)(struct fman_mac *mac_dev,
 			     enum fman_mac_exceptions exception, bool enable);
 	int (*add_hash_mac_addr)(struct fman_mac *mac_dev,
@@ -60,6 +50,12 @@ struct mac_device {
 	struct mac_priv_s	*priv;
 };
 
+static inline struct mac_device
+*fman_config_to_mac(struct phylink_config *config)
+{
+	return container_of(config, struct mac_device, phylink_config);
+}
+
 struct dpaa_eth_data {
 	struct mac_device *mac_dev;
 	int mac_hw_id;
-- 
2.35.1.1320.gc452695387.dirty

