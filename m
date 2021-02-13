Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD8431A921
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhBMA5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:57:42 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:2720 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231894AbhBMAzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:55:19 -0500
X-Greylist: delayed 1805 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2021 19:55:15 EST
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0Mc2k009216;
        Fri, 12 Feb 2021 19:24:23 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92s68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:24:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvuCcin8trTn/oBLuB3pOCjiHzz48zCswVQ278ScaCLnk/8EW5fe2weHgJlKkd/gTsFXwkkESW9A895hMBvxSAvajZ9q/APXPvVJgKMAHwahjW3fvPWX0slqnfKeyalrxcOQZaxfyRDRYeWXf24sek+AWDRBjLUlFWJVIt/yl0Np3UObDboHKYWm34vgn9MpL4hFHkbXapm1V9piNjsyLiWEkVUbWV7vdzLAtwiL9ZSbBT+MJjsJyAON+XBu19IqYIHJ4CRj3bGznLITQJt5JZg9bwN/OsiUq4pVMlnvp8/x5QTN0+8jdSpitVKmug+Foi1xmssPq6LSc5736BntPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTyqnKGnhCiJXicYZzUTgQE0CXI9Fu+ymOqhl6LfbtU=;
 b=K8dUuwMU6Z5SxJ2Rs7AEhFFPMGmbCIvOmxDD3jOL6NzIBGdZkQKayFcxl5f8dR2HC/meWM1ra9qLU+Sh4h2kkQnrA4YZtW3xDBTPle8UVejLpQJD2RgQn3fbb2ndQaQ9L/x3X5bHgv6pa6i+h6+gVw8u3Z7QXYQr60mZO0GZ/4ZcR4UmhnAL720/z+5n1N5gTfZ72PsWgWMmAXxVe/kTEIgfF7+k3E1O+CDqmrO2s7XeVxltz+2jghfF9zHi6FjVTaFhPp2anJKidoZx1cu7SqmhxNmBP86lsIxC/U4Z+ryWnAIN+iJERaFKOTSBc8m+mVhFupTJMR0eM9b8vEVDxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTyqnKGnhCiJXicYZzUTgQE0CXI9Fu+ymOqhl6LfbtU=;
 b=iEr2qLlcB6Czep5481H0SF0wI73uBcysnSfgJ/zidFJg7xU7EuSFayYkNZXO0OVgjkZqWmNRrIF83h1G1owDJQ+zV+Emh/bFbnExV7m0JI3U/57HjaHqEQAPY+2FgvlOY7W6gXD39c4cdR51bYuhJ+deVqRoKbUtOmAbmJ3jBTs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:24:22 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:24:22 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 3/3] net: axienet: Support dynamic switching between 1000BaseX and SGMII
Date:   Fri, 12 Feb 2021 18:23:56 -0600
Message-Id: <20210213002356.2557207-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210213002356.2557207-1-robert.hancock@calian.com>
References: <20210213002356.2557207-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM6PR07CA0080.namprd07.prod.outlook.com
 (2603:10b6:5:337::13) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM6PR07CA0080.namprd07.prod.outlook.com (2603:10b6:5:337::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sat, 13 Feb 2021 00:24:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d3b604d-547e-4c20-5b01-08d8cfb5b5d4
X-MS-TrafficTypeDiagnostic: YT1PR01MB3564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB35640A223DA7BD34CD5E6765EC8A9@YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkVgzYvf25/xWXBfTqJUyxYgP+++5fuj9cRNvyzpg5vfD+/x/6lcAvOAQ3Qa4opH8XWZJsl6cODLPH1iALa2qbruRiliI3csQ/li/5uLI7dAh+hVS0fNhW0qvc7t8Zjl7dAgkUTBWNshdHCVEUH0pxqLAG9LlcEGKmjiWKN8UB/5rN9NduGlTsWY8qSHBySdcO0SzmHmeJTJwYqJkylxaiS5C/negh62s1rivHXUvFGFgcRijcrlm/pDT/9Kf+WLFUlwub+EJ+FrAmYiNiLcKeY5+T74aVxiYR72U1wuHJbvls/Mclqs4Zh2OQtA4Stp5cuDeSTSd/7i4K1FqwG+aVoa3Tm1U+RvDaledZN+HGj3+9zmscmsDDOqviU6Y4z3CklE81M2DvYLiQ2B5/ZTZ786I53MsbxJig26svPemYUzp3eXSj658BGvWnqr6r38QSXW+luSVhnXtu2Uab76vn8HG5RMJsfrslF02UKAbSJnraCMpmQgTVTNWeRLb9N7E1rkfbK2jJaV52zP2Obih2E0DED8SdFcQSvSDSh9ZPJ2gYJw5fa4+93wsPng2us9I9SDJ6RzWetDMinRX+iPBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(1076003)(6512007)(52116002)(4326008)(478600001)(66556008)(66476007)(66946007)(2906002)(8676002)(44832011)(2616005)(107886003)(6486002)(5660300002)(69590400012)(316002)(956004)(83380400001)(16526019)(8936002)(6666004)(6506007)(26005)(36756003)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/rT0Ug4IdDCX4mBHBvKBJMRPb0s5vdJ3KMU2/UYh2ykJqx6ax1xT5irsRy6S?=
 =?us-ascii?Q?Ab38E0NUKTn92u1+IYl6hsL4vcxhQ6trBon6KS7ASMhPr7OJBCgI0tRacHyR?=
 =?us-ascii?Q?1JrZznPO8i/OsKcc4KiVKM+7K7tBqY90VAodJIt1AW2FlAfn6eZmQri7CgCw?=
 =?us-ascii?Q?KPJw2jX3LNE7absHo0JDowVR7569ct7+0A6OYp1vv4y01zOuV94BKQGNxKKV?=
 =?us-ascii?Q?CtuB42DY//7JNTE5w6lMPKcaRyF1Hn8CINe4LcVx5afuAkMXAOqL3N3ix9ZT?=
 =?us-ascii?Q?P2iMBWwxB44jDzUI6n8MFw5ZEKxgACvia0uMs518lthjsBWSs7SNpLfgrJjI?=
 =?us-ascii?Q?JcbMwI9lDHeH4R9EHZhS506k9KkjHOh3Tw8TQo7F1923KB9XWk1H/8+J5Unz?=
 =?us-ascii?Q?JbQD59Xan323b7CIkVGbjiDffDgifdaMB75PDe1I8QSLUsOHbYyDFag2Hzcb?=
 =?us-ascii?Q?yYOR1ivaSmOgg2EYTrrSbjbwz7g8AG1KiqSe8hS3bc5u/93ukMytJZVAdZ57?=
 =?us-ascii?Q?PT2HmXY0GR3lsn2vGEwpeaIUIxfGOkanHMDA9DwnUfh0Tstw9s34w1V/G3ff?=
 =?us-ascii?Q?uh0r3CymKZ1P8+b/T8JPIKe1zknoXH0e91cRx85rewPWPauDxtwgvLdlt+KZ?=
 =?us-ascii?Q?28F7KidwQRTOQZQ2dvPKK5/K1FT+oJp6UFnYIIeVTLzk7wTIIAfLbTFN2ImA?=
 =?us-ascii?Q?PSWK3WIjzVRdtWlWpo5fnGc+z0JnpaYjxeBWMZA4ZRF4SsdrA+MwLuYBgSdg?=
 =?us-ascii?Q?4Xbh5rqyGhlcqHNkYRFFdJul8K8dyZ9wr4zupQB7y84f2uQv7NvpF8gmDP4L?=
 =?us-ascii?Q?NZvjFwovt+kYJtDWZNSYm9ljpGOfBFEGjmuA1x1KcbmxAq7T63uVYlmjgrFS?=
 =?us-ascii?Q?HokL9J3cd4kD5Q8leb/XWPwCkZCFz2KAxyWsheDsmo8QvcGPgI3p7rNHsNpQ?=
 =?us-ascii?Q?jS9LuzCS6UZiqQGjpJqDBIeAG59wxsE2L6Qe2K+7BFesf2gT73DqxdVFwLeV?=
 =?us-ascii?Q?FPb81jytvjZwNswLTB85FDO8lgwPdDbIqWb14jGqjtqD78pVgNwj9fr6RVcj?=
 =?us-ascii?Q?VgEvKGfuQ1i9+v5x0twv657oWEexZfGziK3Rx+mRcCmz1jGkhH88hUATqc/a?=
 =?us-ascii?Q?unkzyyzTY69nnoGzGwOewmWd+EJ0tFCkBkFGIRdb+tKXJf4qrwxxFoO5tT5q?=
 =?us-ascii?Q?EqCxq1FMAS+Jxte7nmrWOA4R1ElyLwrqbOdOuhc7g9m8DXgnFU+wfqajk2D3?=
 =?us-ascii?Q?hVmWhNxovyicREmxZ+vFuB0tsa6Mk1MUiw6pr1hRDS4nvE7ADUxPQML9d8ZQ?=
 =?us-ascii?Q?jVX/WFmTnmYFwY3Pix0PyY1f?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3b604d-547e-4c20-5b01-08d8cfb5b5d4
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:24:22.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A5AuZhP6mWsqKbKG+6qTrh1dgZU1+UzasGR8NujAvFRvVPDhUbgJ0Wc7DLTomNgUfv2h55Du/FeJi7N0nYhM8jKtZcumBy6De6qHiX5+elE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer versions of the Xilinx AXI Ethernet core (specifically version 7.2 or
later) allow the core to be configured with a PHY interface mode of "Both",
allowing either 1000BaseX or SGMII modes to be selected at runtime. Add
support for this in the driver to allow better support for applications
which can use both fiber and copper SFP modules.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  | 29 +++++----
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 60 ++++++++++++++++---
 2 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index a03c3ca1b28d..1e966a39967e 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -339,6 +339,10 @@
 
 #define DELAY_OF_ONE_MILLISEC		1000
 
+/* Xilinx PCS/PMA PHY register for switching 1000BaseX or SGMII */
+#define XLNX_MII_STD_SELECT_REG		0x11
+#define XLNX_MII_STD_SELECT_SGMII	BIT(0)
+
 /**
  * struct axidma_bd - Axi Dma buffer descriptor layout
  * @next:         MM2S/S2MM Next Descriptor Pointer
@@ -377,22 +381,29 @@ struct axidma_bd {
  * @ndev:	Pointer for net_device to which it will be attached.
  * @dev:	Pointer to device structure
  * @phy_node:	Pointer to device node structure
+ * @phylink:	Pointer to phylink instance
+ * @phylink_config: phylink configuration settings
+ * @pcs_phy:	Reference to PCS/PMA PHY if used
+ * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
+ * @clk:	Clock for AXI bus
  * @mii_bus:	Pointer to MII bus structure
  * @mii_clk_div: MII bus clock divider value
  * @regs_start: Resource start for axienet device addresses
  * @regs:	Base address for the axienet_local device address space
  * @dma_regs:	Base address for the axidma device address space
- * @dma_err_tasklet: Tasklet structure to process Axi DMA errors
+ * @dma_err_task: Work structure to process Axi DMA errors
  * @tx_irq:	Axidma TX IRQ number
  * @rx_irq:	Axidma RX IRQ number
+ * @eth_irq:	Ethernet core IRQ number
  * @phy_mode:	Phy type to identify between MII/GMII/RGMII/SGMII/1000 Base-X
  * @options:	AxiEthernet option word
- * @last_link:	Phy link state in which the PHY was negotiated earlier
  * @features:	Stores the extended features supported by the axienet hw
  * @tx_bd_v:	Virtual address of the TX buffer descriptor ring
  * @tx_bd_p:	Physical address(start address) of the TX buffer descr. ring
+ * @tx_bd_num:	Size of TX buffer descriptor ring
  * @rx_bd_v:	Virtual address of the RX buffer descriptor ring
  * @rx_bd_p:	Physical address(start address) of the RX buffer descr. ring
+ * @rx_bd_num:	Size of RX buffer descriptor ring
  * @tx_bd_ci:	Stores the index of the Tx buffer descriptor in the ring being
  *		accessed currently. Used while alloc. BDs before a TX starts
  * @tx_bd_tail:	Stores the index of the Tx buffer descriptor in the ring being
@@ -414,23 +425,20 @@ struct axienet_local {
 	struct net_device *ndev;
 	struct device *dev;
 
-	/* Connection to PHY device */
 	struct device_node *phy_node;
 
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
-	/* Reference to PCS/PMA PHY if used */
 	struct mdio_device *pcs_phy;
 
-	/* Clock for AXI bus */
+	bool switch_x_sgmii;
+
 	struct clk *clk;
 
-	/* MDIO bus data */
-	struct mii_bus *mii_bus;	/* MII bus reference */
-	u8 mii_clk_div; /* MII bus clock divider value */
+	struct mii_bus *mii_bus;
+	u8 mii_clk_div;
 
-	/* IO registers, dma functions and IRQs */
 	resource_size_t regs_start;
 	void __iomem *regs;
 	void __iomem *dma_regs;
@@ -442,10 +450,9 @@ struct axienet_local {
 	int eth_irq;
 	phy_interface_t phy_mode;
 
-	u32 options;			/* Current options word */
+	u32 options;
 	u32 features;
 
-	/* Buffer descriptors */
 	struct axidma_bd *tx_bd_v;
 	dma_addr_t tx_bd_p;
 	u32 tx_bd_num;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 3ef31bae71fb..3a8775e0ca55 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1502,13 +1502,22 @@ static void axienet_validate(struct phylink_config *config,
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	/* Only support the mode we are configured for */
-	if (state->interface != PHY_INTERFACE_MODE_NA &&
-	    state->interface != lp->phy_mode) {
-		netdev_warn(ndev, "Cannot use PHY mode %s, supported: %s\n",
-			    phy_modes(state->interface),
-			    phy_modes(lp->phy_mode));
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		return;
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_NA:
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_SGMII:
+		if (lp->switch_x_sgmii)
+			break;
+		fallthrough;
+	default:
+		if (state->interface != lp->phy_mode) {
+			netdev_warn(ndev, "Cannot use PHY mode %s, supported: %s\n",
+				    phy_modes(state->interface),
+				    phy_modes(lp->phy_mode));
+			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+			return;
+		}
 	}
 
 	phylink_set(mask, Autoneg);
@@ -1568,6 +1577,33 @@ static void axienet_mac_an_restart(struct phylink_config *config)
 	phylink_mii_c22_pcs_an_restart(lp->pcs_phy);
 }
 
+static int axienet_mac_prepare(struct phylink_config *config, unsigned int mode,
+			       phy_interface_t iface)
+{
+	struct net_device *ndev = to_net_dev(config->dev);
+	struct axienet_local *lp = netdev_priv(ndev);
+	int ret;
+
+	switch (iface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		if (!lp->switch_x_sgmii)
+			return 0;
+
+		ret = mdiobus_write(lp->pcs_phy->bus,
+				    lp->pcs_phy->addr,
+				    XLNX_MII_STD_SELECT_REG,
+				    iface == PHY_INTERFACE_MODE_SGMII ?
+					XLNX_MII_STD_SELECT_SGMII : 0);
+		if (ret < 0)
+			netdev_warn(ndev, "Failed to switch PHY interface: %d\n",
+				    ret);
+		return ret;
+	default:
+		return 0;
+	}
+}
+
 static void axienet_mac_config(struct phylink_config *config, unsigned int mode,
 			       const struct phylink_link_state *state)
 {
@@ -1645,6 +1681,7 @@ static const struct phylink_mac_ops axienet_phylink_ops = {
 	.validate = axienet_validate,
 	.mac_pcs_get_state = axienet_mac_pcs_get_state,
 	.mac_an_restart = axienet_mac_an_restart,
+	.mac_prepare = axienet_mac_prepare,
 	.mac_config = axienet_mac_config,
 	.mac_link_down = axienet_mac_link_down,
 	.mac_link_up = axienet_mac_link_up,
@@ -1896,6 +1933,9 @@ static int axienet_probe(struct platform_device *pdev)
 	 */
 	of_property_read_u32(pdev->dev.of_node, "xlnx,rxmem", &lp->rxmem);
 
+	lp->switch_x_sgmii = of_property_read_bool(pdev->dev.of_node,
+						   "xlnx,switch-x-sgmii");
+
 	/* Start with the proprietary, and broken phy_type */
 	ret = of_property_read_u32(pdev->dev.of_node, "xlnx,phy-type", &value);
 	if (!ret) {
@@ -1925,6 +1965,12 @@ static int axienet_probe(struct platform_device *pdev)
 		if (ret)
 			goto free_netdev;
 	}
+	if (lp->switch_x_sgmii && lp->phy_mode != PHY_INTERFACE_MODE_SGMII &&
+	    lp->phy_mode != PHY_INTERFACE_MODE_1000BASEX) {
+		dev_err(&pdev->dev, "xlnx,switch-x-sgmii only supported with SGMII or 1000BaseX\n");
+		ret = -EINVAL;
+		goto free_netdev;
+	}
 
 	/* Find the DMA node, map the DMA registers, and decode the DMA IRQs */
 	np = of_parse_phandle(pdev->dev.of_node, "axistream-connected", 0);
-- 
2.27.0

