Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AB255F15E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbiF1WTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiF1WTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:19:11 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00078.outbound.protection.outlook.com [40.107.0.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371523CA50;
        Tue, 28 Jun 2022 15:16:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAuAzX7sy646YUEGffFHEKsvL7xh/6m6K1xEWJ9M0P5eK3cVzbbwngBXTx9FqAc8v4sUGynZq1PCY1n8bMKqzcw/WVN7aKZg2nOhriVpyl+OMqeXCULNV8SDhdqYm5ywYq7OTiixy0EBgxHo6jklsW/EQP5JZF5c7fY7/Eo2m0biVypwSD3nYRTlId9DhIjloJbitOS8RF07UBhwcThgn2A5XZCimkn12Hvx66IahefKX5WUJ+ELv92SYisu7P1A5Sg+lFJS9HfAAPcZ1l7OcTVmavDKlnFC3SiGImODHhrQ0yBJ/DdT/2uvzzy1z5vF1GjumS55JRZaeYXG+zFX4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ovm/e8lx8Wb0gf9WidO8Bq4Iwq5AYX7dvEMSOd6wPXA=;
 b=QqywAc75m0dIexneQNs0fu7oH5Sz61syDP3ZbUv7TmVpFpJYcrTbVU0BHfVCnZ2hGXmVYIBaASgrQMPRIulih1US/TfTiJv9Jb63EN6vRYsv/mmG393kiGGEYGu1L/d+IKcEoCzuMp9gZWplLh9fC4VAbZzgJVTjAk1GKTkcdKihdYFHytYwreTAkruev62e8/ZEjR/jynUPDQadQDOeu1/nnsOwTdlxnYmkV1XgpAUWQyOp79sYNu0Rucf5WzQMy0gnBmMu6/1AJdL1MNruW/9Fs7tfLTh3G3D795p9baMl9/EqT/f2n3e2Wh09gpu/KiYa6/iRGlx2VBhnSHAjng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ovm/e8lx8Wb0gf9WidO8Bq4Iwq5AYX7dvEMSOd6wPXA=;
 b=lDc7KZGaJIm5zxFJUfhF3/+A22vMgd0d5hNNzum39mv7Wu9bjne/EP060RHfc2wajxkqdHE1bdG4E/dyvTI126Oo5cbI8mZjCKmjpPpDccn69n1QbPHwRyz+0GVyg+9J0dyo/mnb6Yu4vNsVbU4ZOU8r8G8HaeZMClHbX1Rr8hxuHenx9nOEQuDLLqrb5gC4PJsFkFvHR0/ykJBFDg9Qw4iM8adWhIrhCaSAQBbaZCPYYdGkyTFp8mpKpJ/gcg1rksMlRibZY0aUnQ+A2l75Se6mhjK369EZbYAZCPKV5im6ujspfEaGKzmXG9cSj9LBICyHNOvQrgbFShqlD4sXmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:15:36 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:15:36 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 31/35] [RFT] net: dpaa: Convert to phylink
Date:   Tue, 28 Jun 2022 18:14:00 -0400
Message-Id: <20220628221404.1444200-32-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 19f4b644-b3fa-4819-220b-08da5953a87b
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jMpoZ12bx+2YubX/ipJIx9LHoDhY7X8VHPSJfH1y/wIwLM/pUuG7BW7Uxb+QmxbCRDJuUznpnW2qNGP8jBVkOHAuMcVxNUpWu+qNatwcohz2IfOynyZIbnrCzZ4p86si0QObQJy2LoyXV/Ffoh24hgr8KCyTE4AiN5sCNTMto9xmzYeadMO1g1upSna5nY3YqryPMuWdMWQT6SssQ90c5oht6swSo8qW7g7PFYiCTI5Kdp9Cn4qCeHzY5LQhplfUZ06lw0KLj07dWkCgC3W0/nvlBa52vqH71Cgj+vuWhX+TtzxZaaZTt2AaKHij2lhlS55/CG46+l5DCJZFSZzhaRtvSL5ix4SrRS1ZqDLBaBtFmT0Qnw9kOpQAJgsS+3H91yt8Fr1iX3O4LOHK6/oY8nwD2rVcaKMp6GdHk/XL3CnXFFtgB8WuVI9RrXjxKAXTPOQF6Y3fqAxLnH1TR0taWKWvE66lfqSU+fUef/8jWMVCGoFXL1p/O3yTWWZKxZ9ff1NsdRUip/4YW0WCuXCb2neKGdvtYTYARmLpxPgygH/B0ZWbxE8N5Zf+RTzOLTdNAh5L8q6NqpTuMb5cfpXrKYC3TjvzSzR0QKL5bMlcno8Wa6oq3mTo2fri8E4AduIBeKqQuTnqLITZoVEn4DUbdsZb9p/i7072y7vC2Mte98245YH334NvwtCoa4FE3xcHwe0/joJbj1r/7Rbv9FjjOQiK+pg1uTCkk2E5xZoGiD73sdaPM7qaZXdCubaCxADx2gwQTjnn60BbQthcy5fXgIFQAgw6bxKx3m9ACZTk3vvCaHKZxDg9uwavzJZAPRzx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(30864003)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001)(579004)(559001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vv/jngjFrl8VqTKMu+AMlgslLSqff+bbMquMQcBNTumdORqx10YW73JhMBvA?=
 =?us-ascii?Q?6oLQ5Md08Tm4uCxzRyrmiNoDWcO0F5rEMmkEae9zpOO4zSws6pv3Vd1VR9zT?=
 =?us-ascii?Q?Mfocc5CfnYjaEIwKWFpSw425Y8lpdZANSFN/Jc/s6VwyUs5uiRnSDBDnmFWL?=
 =?us-ascii?Q?LKWFqwsUvP5JkAvOMvyt1H/nan1VX4zmq2xwHl+p94tn9lnDosZ3aHGCnFcG?=
 =?us-ascii?Q?JH6WKIV8vDMYiFInJn0jU/oKUC92hfKdgDxy4sUvaMEX0ormmtjTHbVfVBBV?=
 =?us-ascii?Q?rlcx6t+eCV9myWOzWteS69KlVtSIduqEbCNn36tLOwoCyLOvc4z30L0uAJjQ?=
 =?us-ascii?Q?TifYNDAG034EQWaFtzLAG75bir9N+XsOeoZU9ao4989gAgVYQ43le4s9d6+D?=
 =?us-ascii?Q?icXjOv6RwRQpHy6WQ033CQzHLbhsupaOPua+kkaT8j21MFyQKZEXZGCqx5bo?=
 =?us-ascii?Q?SYxDGqckpDUf0dnCvzQQ4T81E+psWJrAZYq9WVWoaJnmZ+L62g1AW8x/VAqx?=
 =?us-ascii?Q?sje+GC2BbV9Fq9eejEkrTSCiwzGO8KIKtSIZdTFob6k0Gg92UHvq5+wHPKM1?=
 =?us-ascii?Q?5zE3EZ4uSpce39PuooZ9vb38H5L0DXNEzkR9nQJiRnwnFy5T1nhsfXvU2JjA?=
 =?us-ascii?Q?QIwaRKGWOAKlOLPlETqfin+RMrjJEe0SLyFXNWkCoFFN9xjecKaPCZVk3Jxi?=
 =?us-ascii?Q?vS6ejTgVEc0dYZeLXkHp68LHKX4ZyHOps6l+kC5+GurW0XJZn/xotrx9Vb6X?=
 =?us-ascii?Q?izUghxbboCPQ4p3T1DjfGxqdzf28xA7dLTBzs+RZIxrvEihuza+nTuodC64A?=
 =?us-ascii?Q?lR01KpUuZIHZZNJAGEPSoXi2Yw1khmLL02T1t4MRQiy/i9vGl8SmluXrwlfS?=
 =?us-ascii?Q?ay++ECvWGm5mte3AC4cyZVPSWsLGFvRdvQqyuF0QaD1cZkATIqNZTXO5RVnd?=
 =?us-ascii?Q?Z+FRVcAI1upyLUxHZaXj5doq7FwFmMOzO5ni+szjGAed9uv6yYeQC/GXWOOR?=
 =?us-ascii?Q?DDW7wLa1y/XTIN7rAr6og+Bk4ituWW1pDirhSS7xcocy46MOw3U/5B03edcd?=
 =?us-ascii?Q?rKaRtzP5fAom9Z2um2qr3zfXTkGlch8GIZ/Wb+YdwR0BrcUAVMnsgXLH9mAm?=
 =?us-ascii?Q?vARir6zsKMNqwXJijmk7HS2GXBZoEAZTU++KEBSR1I8Yxlj7OvI3bPVFEyhH?=
 =?us-ascii?Q?LTZY0XWO19ZX2e8hhTAiHuPlBsC2mhr6ccjmDmasAww0hI+3ZNzdlxEpEEhY?=
 =?us-ascii?Q?scPBUYQWEao+sv98ATvhitBiEOAEI1N6acba1Nc2n7/uP8UEEJpXvrqplx10?=
 =?us-ascii?Q?UuAfx9QBkQ46xF53zOgOTgkjR4iO1PTvFEZfHieRMGWV826CG55R5L4lwQSL?=
 =?us-ascii?Q?MIRMXu1kodMDuIgjEYbVxnWn5buMjAT1Qg0pdUoKeRn0VUkdRK2soQ62PdyP?=
 =?us-ascii?Q?Ti5LFm3YRIcHrPnMMnLfVHQbXAjLJ6K6dsdkcPr+4FAlpSUEdcDC5VeSxVPM?=
 =?us-ascii?Q?I0E/MSssUQODzY+dq1huUnMtieHiDOQ99mQmNM0hDkHjAIBTn41Fozhk1BVN?=
 =?us-ascii?Q?nU+dbSBxz9pLGWMxXxhj1lL4NVKGEH6O/zu5Gpa2MK3dA9Sgta5BmCBQHyL9?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f4b644-b3fa-4819-220b-08da5953a87b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:15:07.1864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3FQcXB/buAApy+qLvfOg6kI6AaTMEEXrDvEeWB8jWCB91fFoFHwgbo2y5yPkgtcMI1h6VB9dkAmIg0lrlFkdlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts DPAA to phylink. All macs are converted. This should work
with no device tree modifications (including those made in this series),
except for QSGMII (as noted previously).

The mEMAC configuration is one of the tricker areas. I have tried to capture all
the restrictions across the various models. Most of the time, we assume
that if the serdes supports a mode or the phy-interface-mode specifies it,
then we support it. The only place we can't do this is (RG)MII, since
there's no serdes. In that case, we rely on a (new) devicetree property.
There are also several cases where half-duplex is broken. Unfortunately,
only a single compatible is used for the MAC, so we have to use the board
compatible instead.

The 10GEC conversion is very straightforward, since it only supports
XAUI. There is generally nothing to configure.

The dTSEC conversion is broadly similar to mEMAC, but is simpler because
we don't support configuring the SerDes (though this can be easily
added) and we don't have multiple PCSs. From what I can tell, there's
nothing different in the driver or documentation between SGMII and
1000Base-X except for the advertising. Similarly, I couldn't find
anything about 2500Base-X. In both cases, I treat them like SGMII. These
modes aren't used by any in-tree boards. Similarly, despite being mentioned
in the driver, I couldn't find any documented SoCs which supported QSGMII.
I have left it unimplemented for now.

10GEC and dTSEC have not been tested at all. I would greatly appreciate
if someone could try them out.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This has been tested on an LS1046ARDB. With the serdes driver disabled
(e.g. with eveything up to this patch applied), everything works. With
the serdes driver enabled, fewer things work. When SRDS_PRTCL_S1 is
1133, everything works but eth3 (aka MAC6). If I configure all lanes for
SGMII then MAC6 works (but of course the 10G MACs break). When
SRDS_PRTCL_S is 0000 only ETH5 worked. I looked at the serdes registers,
but I only saw differences in undocumented registers/fields. I'm still
looking into this...

With managed=phy , I was unable to get the interfaces to come up at all,
hence the default to in-band.

Changes in v2:
- Configure the SerDes in enable/disable
- Convert 10GEC and dTSEC as well
- Properly implement all ethtool ops and ioctls. These were mostly
  stubbed out just enough to compile last time.
- Remove unused variable slow_10g_if
- Restrict valid link modes based on the phy interface. This is easier
  to set up, and mostly captures what I intended to do the first time.
  We now have a custom validate which restricts half-duplex for some SoCs
  for RGMII, but generally just uses the default phylink validate.

 drivers/net/ethernet/freescale/dpaa/Kconfig   |   4 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  85 +--
 .../ethernet/freescale/dpaa/dpaa_ethtool.c    |  90 +--
 drivers/net/ethernet/freescale/fman/Kconfig   |   1 -
 .../net/ethernet/freescale/fman/fman_dtsec.c  | 453 +++++++-------
 .../net/ethernet/freescale/fman/fman_mac.h    |  10 -
 .../net/ethernet/freescale/fman/fman_memac.c  | 579 ++++++++++--------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 131 ++--
 drivers/net/ethernet/freescale/fman/mac.c     | 168 +----
 drivers/net/ethernet/freescale/fman/mac.h     |  23 +-
 10 files changed, 637 insertions(+), 907 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/Kconfig b/drivers/net/ethernet/freescale/dpaa/Kconfig
index 0e1439fd00bd..2b560661c82a 100644
--- a/drivers/net/ethernet/freescale/dpaa/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa/Kconfig
@@ -2,8 +2,8 @@
 menuconfig FSL_DPAA_ETH
 	tristate "DPAA Ethernet"
 	depends on FSL_DPAA && FSL_FMAN
-	select PHYLIB
-	select FIXED_PHY
+	select PHYLINK
+	select PCS_LYNX
 	help
 	  Data Path Acceleration Architecture Ethernet driver,
 	  supporting the Freescale QorIQ chips.
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index fd81ebc7be44..125e7db3dba8 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -264,8 +264,19 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->needed_headroom = priv->tx_headroom;
 	net_dev->watchdog_timeo = msecs_to_jiffies(tx_timeout);
 
-	mac_dev->net_dev = net_dev;
+	/* The rest of the config is filled in by the mac device already */
+	mac_dev->phylink_config.dev = &net_dev->dev;
+	mac_dev->phylink_config.type = PHYLINK_NETDEV;
 	mac_dev->update_speed = dpaa_eth_cgr_set_speed;
+	mac_dev->phylink = phylink_create(&mac_dev->phylink_config,
+					  dev_fwnode(mac_dev->dev),
+					  mac_dev->phy_if,
+					  mac_dev->phylink_ops);
+	if (IS_ERR(mac_dev->phylink)) {
+		err = PTR_ERR(mac_dev->phylink);
+		dev_err_probe(dev, err, "Could not create phylink\n");
+		return err;
+	}
 
 	/* start without the RUNNING flag, phylib controls it later */
 	netif_carrier_off(net_dev);
@@ -273,6 +284,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	err = register_netdev(net_dev);
 	if (err < 0) {
 		dev_err(dev, "register_netdev() = %d\n", err);
+		phylink_destroy(mac_dev->phylink);
 		return err;
 	}
 
@@ -294,8 +306,7 @@ static int dpaa_stop(struct net_device *net_dev)
 	 */
 	msleep(200);
 
-	if (mac_dev->phy_dev)
-		phy_stop(mac_dev->phy_dev);
+	phylink_stop(mac_dev->phylink);
 	mac_dev->disable(mac_dev->fman_mac);
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -304,8 +315,7 @@ static int dpaa_stop(struct net_device *net_dev)
 			err = error;
 	}
 
-	if (net_dev->phydev)
-		phy_disconnect(net_dev->phydev);
+	phylink_disconnect_phy(mac_dev->phylink);
 	net_dev->phydev = NULL;
 
 	msleep(200);
@@ -833,10 +843,10 @@ static int dpaa_eth_cgr_init(struct dpaa_priv *priv)
 
 	/* Set different thresholds based on the configured MAC speed.
 	 * This may turn suboptimal if the MAC is reconfigured at another
-	 * speed, so MACs must call dpaa_eth_cgr_set_speed in their adjust_link
+	 * speed, so MACs must call dpaa_eth_cgr_set_speed in their link_up
 	 * callback.
 	 */
-	if (priv->mac_dev->if_support & SUPPORTED_10000baseT_Full)
+	if (priv->mac_dev->phylink_config.mac_capabilities & MAC_10000FD)
 		cs_th = DPAA_CS_THRESHOLD_10G;
 	else
 		cs_th = DPAA_CS_THRESHOLD_1G;
@@ -865,7 +875,7 @@ static int dpaa_eth_cgr_init(struct dpaa_priv *priv)
 
 static void dpaa_eth_cgr_set_speed(struct mac_device *mac_dev, int speed)
 {
-	struct net_device *net_dev = mac_dev->net_dev;
+	struct net_device *net_dev = to_net_dev(mac_dev->phylink_config.dev);
 	struct dpaa_priv *priv = netdev_priv(net_dev);
 	struct qm_mcc_initcgr opts = { };
 	u32 cs_th;
@@ -2904,54 +2914,6 @@ static void dpaa_eth_napi_disable(struct dpaa_priv *priv)
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
@@ -2962,7 +2924,8 @@ static int dpaa_open(struct net_device *net_dev)
 	mac_dev = priv->mac_dev;
 	dpaa_eth_napi_enable(priv);
 
-	err = dpaa_phy_init(net_dev);
+	err = phylink_of_phy_connect(mac_dev->phylink,
+				     mac_dev->dev->of_node, 0);
 	if (err)
 		goto phy_init_failed;
 
@@ -2977,7 +2940,7 @@ static int dpaa_open(struct net_device *net_dev)
 		netif_err(priv, ifup, net_dev, "mac_dev->enable() = %d\n", err);
 		goto mac_start_failed;
 	}
-	phy_start(priv->mac_dev->phy_dev);
+	phylink_start(mac_dev->phylink);
 
 	netif_tx_start_all_queues(net_dev);
 
@@ -2986,6 +2949,7 @@ static int dpaa_open(struct net_device *net_dev)
 mac_start_failed:
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++)
 		fman_port_disable(mac_dev->port[i]);
+	phylink_disconnect_phy(mac_dev->phylink);
 
 phy_init_failed:
 	dpaa_eth_napi_disable(priv);
@@ -3141,10 +3105,12 @@ static int dpaa_ts_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
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
@@ -3548,6 +3514,7 @@ static int dpaa_remove(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, NULL);
 	unregister_netdev(net_dev);
+	phylink_destroy(priv->mac_dev->phylink);
 
 	err = dpaa_fq_free(dev, &priv->dpaa_fq_list);
 
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 73f07881ce2d..7463ec7f0105 100644
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
@@ -99,80 +91,28 @@ static void dpaa_set_msglevel(struct net_device *net_dev,
 
 static int dpaa_nway_reset(struct net_device *net_dev)
 {
-	int err;
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct mac_device *mac_dev = priv->mac_dev;
 
-	if (!net_dev->phydev)
-		return -ENODEV;
-
-	err = 0;
-	if (net_dev->phydev->autoneg) {
-		err = phy_start_aneg(net_dev->phydev);
-		if (err < 0)
-			netdev_err(net_dev, "phy_start_aneg() = %d\n",
-				   err);
-	}
-
-	return err;
+	return phylink_ethtool_nway_reset(mac_dev->phylink);
 }
 
 static void dpaa_get_pauseparam(struct net_device *net_dev,
 				struct ethtool_pauseparam *epause)
 {
-	struct mac_device *mac_dev;
-	struct dpaa_priv *priv;
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct mac_device *mac_dev = priv->mac_dev;
 
-	priv = netdev_priv(net_dev);
-	mac_dev = priv->mac_dev;
-
-	if (!net_dev->phydev)
-		return;
-
-	epause->autoneg = mac_dev->autoneg_pause;
-	epause->rx_pause = mac_dev->rx_pause_active;
-	epause->tx_pause = mac_dev->tx_pause_active;
+	phylink_ethtool_get_pauseparam(mac_dev->phylink, epause);
 }
 
 static int dpaa_set_pauseparam(struct net_device *net_dev,
 			       struct ethtool_pauseparam *epause)
 {
-	struct mac_device *mac_dev;
-	struct phy_device *phydev;
-	bool rx_pause, tx_pause;
-	struct dpaa_priv *priv;
-	int err;
+	struct dpaa_priv *priv = netdev_priv(net_dev);
+	struct mac_device *mac_dev = priv->mac_dev;
 
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
+	return phylink_ethtool_set_pauseparam(mac_dev->phylink, epause);
 }
 
 static int dpaa_get_sset_count(struct net_device *net_dev, int type)
diff --git a/drivers/net/ethernet/freescale/fman/Kconfig b/drivers/net/ethernet/freescale/fman/Kconfig
index f5ef42bd2011..a55542c1ad65 100644
--- a/drivers/net/ethernet/freescale/fman/Kconfig
+++ b/drivers/net/ethernet/freescale/fman/Kconfig
@@ -3,7 +3,6 @@ config FSL_FMAN
 	tristate "FMan support"
 	depends on FSL_SOC || ARCH_LAYERSCAPE || COMPILE_TEST
 	select GENERIC_ALLOCATOR
-	select PHYLIB
 	select PHYLINK
 	select PCS_LYNX
 	select CRC32
diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 6617932fd3fd..4ece454e9480 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -17,6 +17,7 @@
 #include <linux/crc32.h>
 #include <linux/of_mdio.h>
 #include <linux/mii.h>
+#include <linux/netdevice.h>
 
 /* TBI register addresses */
 #define MII_TBICON		0x11
@@ -29,9 +30,6 @@
 #define TBICON_CLK_SELECT	0x0020	/* Clock select */
 #define TBICON_MI_MODE		0x0010	/* GMII mode (TBI if not set) */
 
-#define TBIANA_SGMII		0x4001
-#define TBIANA_1000X		0x01a0
-
 /* Interrupt Mask Register (IMASK) */
 #define DTSEC_IMASK_BREN	0x80000000
 #define DTSEC_IMASK_RXCEN	0x40000000
@@ -92,9 +90,10 @@
 
 #define DTSEC_ECNTRL_GMIIM		0x00000040
 #define DTSEC_ECNTRL_TBIM		0x00000020
-#define DTSEC_ECNTRL_SGMIIM		0x00000002
 #define DTSEC_ECNTRL_RPM		0x00000010
 #define DTSEC_ECNTRL_R100M		0x00000008
+#define DTSEC_ECNTRL_RMM		0x00000004
+#define DTSEC_ECNTRL_SGMIIM		0x00000002
 #define DTSEC_ECNTRL_QSGMIIM		0x00000001
 
 #define TCTRL_TTSE			0x00000040
@@ -318,7 +317,8 @@ struct fman_mac {
 	void *fm;
 	struct fman_rev_info fm_rev_info;
 	bool basex_if;
-	struct phy_device *tbiphy;
+	struct mdio_device *tbidev;
+	struct phylink_pcs pcs;
 };
 
 static void set_dflts(struct dtsec_cfg *cfg)
@@ -356,7 +356,6 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
 		phy_interface_t iface, u16 iface_speed, u64 addr,
 		u32 exception_mask, u8 tbi_addr)
 {
-	bool is_rgmii, is_sgmii, is_qsgmii;
 	enet_addr_t eth_addr;
 	u32 tmp;
 	int i;
@@ -365,47 +364,6 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
 	iowrite32be(MACCFG1_SOFT_RESET, &regs->maccfg1);
 	iowrite32be(0, &regs->maccfg1);
 
-	/* dtsec_id2 */
-	tmp = ioread32be(&regs->tsec_id2);
-
-	/* check RGMII support */
-	if (iface == PHY_INTERFACE_MODE_RGMII ||
-	    iface == PHY_INTERFACE_MODE_RGMII_ID ||
-	    iface == PHY_INTERFACE_MODE_RGMII_RXID ||
-	    iface == PHY_INTERFACE_MODE_RGMII_TXID ||
-	    iface == PHY_INTERFACE_MODE_RMII)
-		if (tmp & DTSEC_ID2_INT_REDUCED_OFF)
-			return -EINVAL;
-
-	if (iface == PHY_INTERFACE_MODE_SGMII ||
-	    iface == PHY_INTERFACE_MODE_MII)
-		if (tmp & DTSEC_ID2_INT_REDUCED_OFF)
-			return -EINVAL;
-
-	is_rgmii = iface == PHY_INTERFACE_MODE_RGMII ||
-		   iface == PHY_INTERFACE_MODE_RGMII_ID ||
-		   iface == PHY_INTERFACE_MODE_RGMII_RXID ||
-		   iface == PHY_INTERFACE_MODE_RGMII_TXID;
-	is_sgmii = iface == PHY_INTERFACE_MODE_SGMII;
-	is_qsgmii = iface == PHY_INTERFACE_MODE_QSGMII;
-
-	tmp = 0;
-	if (is_rgmii || iface == PHY_INTERFACE_MODE_GMII)
-		tmp |= DTSEC_ECNTRL_GMIIM;
-	if (is_sgmii)
-		tmp |= (DTSEC_ECNTRL_SGMIIM | DTSEC_ECNTRL_TBIM);
-	if (is_qsgmii)
-		tmp |= (DTSEC_ECNTRL_SGMIIM | DTSEC_ECNTRL_TBIM |
-			DTSEC_ECNTRL_QSGMIIM);
-	if (is_rgmii)
-		tmp |= DTSEC_ECNTRL_RPM;
-	if (iface_speed == SPEED_100)
-		tmp |= DTSEC_ECNTRL_R100M;
-
-	iowrite32be(tmp, &regs->ecntrl);
-
-	tmp = 0;
-
 	if (cfg->tx_pause_time)
 		tmp |= cfg->tx_pause_time;
 	if (cfg->tx_pause_time_extd)
@@ -446,17 +404,10 @@ static int init(struct dtsec_regs __iomem *regs, struct dtsec_cfg *cfg,
 
 	tmp = 0;
 
-	if (iface_speed < SPEED_1000)
-		tmp |= MACCFG2_NIBBLE_MODE;
-	else if (iface_speed == SPEED_1000)
-		tmp |= MACCFG2_BYTE_MODE;
-
 	tmp |= (cfg->preamble_len << MACCFG2_PREAMBLE_LENGTH_SHIFT) &
 		MACCFG2_PREAMBLE_LENGTH_MASK;
 	if (cfg->tx_pad_crc)
 		tmp |= MACCFG2_PAD_CRC_EN;
-	/* Full Duplex */
-	tmp |= MACCFG2_FULL_DUPLEX;
 	iowrite32be(tmp, &regs->maccfg2);
 
 	tmp = (((cfg->non_back_to_back_ipg1 <<
@@ -525,10 +476,6 @@ static void set_bucket(struct dtsec_regs __iomem *regs, int bucket,
 
 static int check_init_parameters(struct fman_mac *dtsec)
 {
-	if (dtsec->max_speed >= SPEED_10000) {
-		pr_err("1G MAC driver supports 1G or lower speeds\n");
-		return -EINVAL;
-	}
 	if ((dtsec->dtsec_drv_param)->rx_prepend >
 	    MAX_PACKET_ALIGNMENT) {
 		pr_err("packetAlignmentPadding can't be > than %d\n",
@@ -630,22 +577,10 @@ static int get_exception_flag(enum fman_mac_exceptions exception)
 	return bit_mask;
 }
 
-static bool is_init_done(struct dtsec_cfg *dtsec_drv_params)
-{
-	/* Checks if dTSEC driver parameters were initialized */
-	if (!dtsec_drv_params)
-		return true;
-
-	return false;
-}
-
 static u16 dtsec_get_max_frame_length(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return 0;
-
 	return (u16)ioread32be(&regs->maxfrm);
 }
 
@@ -682,6 +617,7 @@ static void dtsec_isr(void *handle)
 		dtsec->exception_cb(dtsec->dev_id, FM_MAC_EX_1G_COL_RET_LMT);
 	if (event & DTSEC_IMASK_XFUNEN) {
 		/* FM_TX_LOCKUP_ERRATA_DTSEC6 Errata workaround */
+		/* FIXME: This races with the rest of the driver! */
 		if (dtsec->fm_rev_info.major == 2) {
 			u32 tpkt1, tmp_reg1, tpkt2, tmp_reg2, i;
 			/* a. Write 0x00E0_0C00 to DTSEC_ID
@@ -814,6 +750,43 @@ static void free_init_resources(struct fman_mac *dtsec)
 	dtsec->unicast_addr_hash = NULL;
 }
 
+static struct fman_mac *pcs_to_dtsec(struct phylink_pcs *pcs)
+{
+	return container_of(pcs, struct fman_mac, pcs);
+}
+
+static void dtsec_pcs_get_state(struct phylink_pcs *pcs,
+				struct phylink_link_state *state)
+{
+	struct fman_mac *dtsec = pcs_to_dtsec(pcs);
+
+	phylink_mii_c22_pcs_get_state(dtsec->tbidev, state);
+}
+
+static int dtsec_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			    phy_interface_t interface,
+			    const unsigned long *advertising,
+			    bool permit_pause_to_mac)
+{
+	struct fman_mac *dtsec = pcs_to_dtsec(pcs);
+
+	return phylink_mii_c22_pcs_config(dtsec->tbidev, mode, interface,
+					  advertising);
+}
+
+static void dtsec_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct fman_mac *dtsec = pcs_to_dtsec(pcs);
+
+	phylink_mii_c22_pcs_an_restart(dtsec->tbidev);
+}
+
+static const struct phylink_pcs_ops dtsec_pcs_ops = {
+	.pcs_get_state = dtsec_pcs_get_state,
+	.pcs_config = dtsec_pcs_config,
+	.pcs_an_restart = dtsec_pcs_an_restart,
+};
+
 static void graceful_start(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -854,36 +827,11 @@ static void graceful_stop(struct fman_mac *dtsec)
 
 static int dtsec_enable(struct fman_mac *dtsec)
 {
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-	u32 tmp;
-
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	/* Enable */
-	tmp = ioread32be(&regs->maccfg1);
-	tmp |= MACCFG1_RX_EN | MACCFG1_TX_EN;
-	iowrite32be(tmp, &regs->maccfg1);
-
-	/* Graceful start - clear the graceful Rx/Tx stop bit */
-	graceful_start(dtsec);
-
 	return 0;
 }
 
 static void dtsec_disable(struct fman_mac *dtsec)
 {
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-	u32 tmp;
-
-	WARN_ON_ONCE(!is_init_done(dtsec->dtsec_drv_param));
-
-	/* Graceful stop - Assert the graceful Rx/Tx stop bit */
-	graceful_stop(dtsec);
-
-	tmp = ioread32be(&regs->maccfg1);
-	tmp &= ~(MACCFG1_RX_EN | MACCFG1_TX_EN);
-	iowrite32be(tmp, &regs->maccfg1);
 }
 
 static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
@@ -894,11 +842,6 @@ static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 ptv = 0;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	graceful_stop(dtsec);
-
 	if (pause_time) {
 		/* FM_BAD_TX_TS_IN_B_2_B_ERRATA_DTSEC_A003 Errata workaround */
 		if (dtsec->fm_rev_info.major == 2 && pause_time <= 320) {
@@ -919,8 +862,6 @@ static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 		iowrite32be(ioread32be(&regs->maccfg1) & ~MACCFG1_TX_FLOW,
 			    &regs->maccfg1);
 
-	graceful_start(dtsec);
-
 	return 0;
 }
 
@@ -929,11 +870,6 @@ static int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	graceful_stop(dtsec);
-
 	tmp = ioread32be(&regs->maccfg1);
 	if (en)
 		tmp |= MACCFG1_RX_FLOW;
@@ -941,17 +877,120 @@ static int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 		tmp &= ~MACCFG1_RX_FLOW;
 	iowrite32be(tmp, &regs->maccfg1);
 
-	graceful_start(dtsec);
-
 	return 0;
 }
 
+static struct phylink_pcs *dtsec_select_pcs(struct phylink_config *config,
+					    phy_interface_t iface)
+{
+	struct fman_mac *dtsec = fman_config_to_mac(config)->fman_mac;
+
+	switch (iface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return &dtsec->pcs;
+	default:
+		return NULL;
+	}
+}
+
+static void dtsec_mac_config(struct phylink_config *config, unsigned int mode,
+			     const struct phylink_link_state *state)
+{
+	struct mac_device *mac_dev = fman_config_to_mac(config);
+	struct dtsec_regs __iomem *regs = mac_dev->fman_mac->regs;
+	u32 tmp;
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_RMII:
+		tmp = DTSEC_ECNTRL_RMM;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		tmp = DTSEC_ECNTRL_GMIIM | DTSEC_ECNTRL_RPM;
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		tmp = DTSEC_ECNTRL_TBIM | DTSEC_ECNTRL_SGMIIM;
+		break;
+	default:
+		dev_warn(mac_dev->dev, "cannot configure dTSEC for %s\n",
+			 phy_modes(state->interface));
+	}
+
+	if (state->speed == SPEED_100)
+		tmp |= DTSEC_ECNTRL_R100M;
+
+	iowrite32be(tmp, &regs->ecntrl);
+}
+
+static void dtsec_link_up(struct phylink_config *config, struct phy_device *phy,
+			  unsigned int mode, phy_interface_t interface,
+			  int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct mac_device *mac_dev = fman_config_to_mac(config);
+	struct fman_mac *dtsec = mac_dev->fman_mac;
+	struct dtsec_regs __iomem *regs = dtsec->regs;
+	u16 pause_time = tx_pause ? FSL_FM_PAUSE_TIME_ENABLE :
+			 FSL_FM_PAUSE_TIME_DISABLE;
+	u32 tmp;
+
+	dtsec_set_tx_pause_frames(dtsec, 0, pause_time, 0);
+	dtsec_accept_rx_pause_frames(dtsec, rx_pause);
+
+	tmp = ioread32be(&regs->maccfg2);
+	tmp &= ~(MACCFG2_NIBBLE_MODE | MACCFG2_BYTE_MODE | MACCFG2_FULL_DUPLEX);
+	if (speed >= SPEED_1000)
+		tmp |= MACCFG2_BYTE_MODE;
+	else
+		tmp |= MACCFG2_NIBBLE_MODE;
+
+	if (duplex == DUPLEX_FULL)
+		tmp |= MACCFG2_FULL_DUPLEX;
+
+	iowrite32be(tmp, &regs->maccfg2);
+
+	mac_dev->update_speed(mac_dev, speed);
+
+	/* Enable */
+	tmp = ioread32be(&regs->maccfg1);
+	tmp |= MACCFG1_RX_EN | MACCFG1_TX_EN;
+	iowrite32be(tmp, &regs->maccfg1);
+
+	/* Graceful start - clear the graceful Rx/Tx stop bit */
+	graceful_start(dtsec);
+}
+
+static void dtsec_link_down(struct phylink_config *config, unsigned int mode,
+			    phy_interface_t interface)
+{
+	struct fman_mac *dtsec = fman_config_to_mac(config)->fman_mac;
+	struct dtsec_regs __iomem *regs = dtsec->regs;
+	u32 tmp;
+
+	/* Graceful stop - Assert the graceful Rx/Tx stop bit */
+	graceful_stop(dtsec);
+
+	tmp = ioread32be(&regs->maccfg1);
+	tmp &= ~(MACCFG1_RX_EN | MACCFG1_TX_EN);
+	iowrite32be(tmp, &regs->maccfg1);
+}
+
+static const struct phylink_mac_ops dtsec_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_select_pcs = dtsec_select_pcs,
+	.mac_config = dtsec_mac_config,
+	.mac_link_up = dtsec_link_up,
+	.mac_link_down = dtsec_link_down,
+};
+
 static int dtsec_modify_mac_address(struct fman_mac *dtsec,
 				    const enet_addr_t *enet_addr)
 {
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	graceful_stop(dtsec);
 
 	/* Initialize MAC Station Address registers (1 & 2)
@@ -975,9 +1014,6 @@ static int dtsec_add_hash_mac_address(struct fman_mac *dtsec,
 	u32 crc = 0xFFFFFFFF;
 	bool mcast, ghtx;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	addr = ENET_ADDR_TO_UINT64(*eth_addr);
 
 	ghtx = (bool)((ioread32be(&regs->rctrl) & RCTRL_GHTX) ? true : false);
@@ -1037,9 +1073,6 @@ static int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
 	u32 tmp;
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->rctrl);
 	if (enable)
 		tmp |= RCTRL_MPROM;
@@ -1056,9 +1089,6 @@ static int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 rctrl, tctrl;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	rctrl = ioread32be(&regs->rctrl);
 	tctrl = ioread32be(&regs->tctrl);
 
@@ -1087,9 +1117,6 @@ static int dtsec_del_hash_mac_address(struct fman_mac *dtsec,
 	u32 crc = 0xFFFFFFFF;
 	bool mcast, ghtx;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	addr = ENET_ADDR_TO_UINT64(*eth_addr);
 
 	ghtx = (bool)((ioread32be(&regs->rctrl) & RCTRL_GHTX) ? true : false);
@@ -1153,9 +1180,6 @@ static int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	/* Set unicast promiscuous */
 	tmp = ioread32be(&regs->rctrl);
 	if (new_val)
@@ -1177,90 +1201,12 @@ static int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 	return 0;
 }
 
-static int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
-{
-	struct dtsec_regs __iomem *regs = dtsec->regs;
-	u32 tmp;
-
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	graceful_stop(dtsec);
-
-	tmp = ioread32be(&regs->maccfg2);
-
-	/* Full Duplex */
-	tmp |= MACCFG2_FULL_DUPLEX;
-
-	tmp &= ~(MACCFG2_NIBBLE_MODE | MACCFG2_BYTE_MODE);
-	if (speed < SPEED_1000)
-		tmp |= MACCFG2_NIBBLE_MODE;
-	else if (speed == SPEED_1000)
-		tmp |= MACCFG2_BYTE_MODE;
-	iowrite32be(tmp, &regs->maccfg2);
-
-	tmp = ioread32be(&regs->ecntrl);
-	if (speed == SPEED_100)
-		tmp |= DTSEC_ECNTRL_R100M;
-	else
-		tmp &= ~DTSEC_ECNTRL_R100M;
-	iowrite32be(tmp, &regs->ecntrl);
-
-	graceful_start(dtsec);
-
-	return 0;
-}
-
-static int dtsec_restart_autoneg(struct fman_mac *dtsec)
-{
-	u16 tmp_reg16;
-
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
-	tmp_reg16 = phy_read(dtsec->tbiphy, MII_BMCR);
-
-	tmp_reg16 &= ~(BMCR_SPEED100 | BMCR_SPEED1000);
-	tmp_reg16 |= (BMCR_ANENABLE | BMCR_ANRESTART |
-		      BMCR_FULLDPLX | BMCR_SPEED1000);
-
-	phy_write(dtsec->tbiphy, MII_BMCR, tmp_reg16);
-
-	return 0;
-}
-
-static void adjust_link_dtsec(struct mac_device *mac_dev)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct fman_mac *fman_mac;
-	bool rx_pause, tx_pause;
-	int err;
-
-	fman_mac = mac_dev->fman_mac;
-	if (!phy_dev->link) {
-		dtsec_restart_autoneg(fman_mac);
-
-		return;
-	}
-
-	dtsec_adjust_link(fman_mac, phy_dev->speed);
-	mac_dev->update_speed(mac_dev, phy_dev->speed);
-	fman_get_pause_cfg(mac_dev, &rx_pause, &tx_pause);
-	err = fman_set_mac_active_pause(mac_dev, rx_pause, tx_pause);
-	if (err < 0)
-		dev_err(mac_dev->dev, "fman_set_mac_active_pause() = %d\n",
-			err);
-}
-
 static int dtsec_set_exception(struct fman_mac *dtsec,
 			       enum fman_mac_exceptions exception, bool enable)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 bit_mask = 0;
 
-	if (!is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	if (exception != FM_MAC_EX_1G_1588_TS_RX_ERR) {
 		bit_mask = get_exception_flag(exception);
 		if (bit_mask) {
@@ -1310,12 +1256,9 @@ static int dtsec_init(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct dtsec_cfg *dtsec_drv_param;
-	u16 max_frm_ln;
+	u16 max_frm_ln, tbicon;
 	int err;
 
-	if (is_init_done(dtsec->dtsec_drv_param))
-		return -EINVAL;
-
 	if (DEFAULT_RESET_ON_INIT &&
 	    (fman_reset_mac(dtsec->fm, dtsec->mac_id) != 0)) {
 		pr_err("Can't reset MAC!\n");
@@ -1330,38 +1273,19 @@ static int dtsec_init(struct fman_mac *dtsec)
 
 	err = init(dtsec->regs, dtsec_drv_param, dtsec->phy_if,
 		   dtsec->max_speed, dtsec->addr, dtsec->exceptions,
-		   dtsec->tbiphy->mdio.addr);
+		   dtsec->tbidev->addr);
 	if (err) {
 		free_init_resources(dtsec);
 		pr_err("DTSEC version doesn't support this i/f mode\n");
 		return err;
 	}
 
-	if (dtsec->phy_if == PHY_INTERFACE_MODE_SGMII) {
-		u16 tmp_reg16;
+	/* Configure the TBI PHY Control Register */
+	tbicon = TBICON_CLK_SELECT | TBICON_SOFT_RESET;
+	mdiodev_write(dtsec->tbidev, MII_TBICON, tbicon);
 
-		/* Configure the TBI PHY Control Register */
-		tmp_reg16 = TBICON_CLK_SELECT | TBICON_SOFT_RESET;
-		phy_write(dtsec->tbiphy, MII_TBICON, tmp_reg16);
-
-		tmp_reg16 = TBICON_CLK_SELECT;
-		phy_write(dtsec->tbiphy, MII_TBICON, tmp_reg16);
-
-		tmp_reg16 = (BMCR_RESET | BMCR_ANENABLE |
-			     BMCR_FULLDPLX | BMCR_SPEED1000);
-		phy_write(dtsec->tbiphy, MII_BMCR, tmp_reg16);
-
-		if (dtsec->basex_if)
-			tmp_reg16 = TBIANA_1000X;
-		else
-			tmp_reg16 = TBIANA_SGMII;
-		phy_write(dtsec->tbiphy, MII_ADVERTISE, tmp_reg16);
-
-		tmp_reg16 = (BMCR_ANENABLE | BMCR_ANRESTART |
-			     BMCR_FULLDPLX | BMCR_SPEED1000);
-
-		phy_write(dtsec->tbiphy, MII_BMCR, tmp_reg16);
-	}
+	tbicon = TBICON_CLK_SELECT;
+	mdiodev_write(dtsec->tbidev, MII_TBICON, tbicon);
 
 	/* Max Frame Length */
 	max_frm_ln = (u16)ioread32be(&regs->maxfrm);
@@ -1406,6 +1330,8 @@ static int dtsec_free(struct fman_mac *dtsec)
 
 	kfree(dtsec->dtsec_drv_param);
 	dtsec->dtsec_drv_param = NULL;
+	if (!IS_ERR_OR_NULL(dtsec->tbidev))
+		put_device(&dtsec->tbidev->dev);
 	kfree(dtsec);
 
 	return 0;
@@ -1434,7 +1360,6 @@ static struct fman_mac *dtsec_config(struct mac_device *mac_dev,
 
 	dtsec->regs = mac_dev->vaddr;
 	dtsec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
-	dtsec->max_speed = params->max_speed;
 	dtsec->phy_if = mac_dev->phy_if;
 	dtsec->mac_id = params->mac_id;
 	dtsec->exceptions = (DTSEC_IMASK_BREN	|
@@ -1457,7 +1382,6 @@ static struct fman_mac *dtsec_config(struct mac_device *mac_dev,
 	dtsec->en_tsu_err_exception = dtsec->dtsec_drv_param->ptp_exception_en;
 
 	dtsec->fm = params->fm;
-	dtsec->basex_if = params->basex_if;
 
 	/* Save FMan revision */
 	fman_get_revision(dtsec->fm, &dtsec->fm_rev_info);
@@ -1476,18 +1400,18 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	int			err;
 	struct fman_mac		*dtsec;
 	struct device_node	*phy_node;
+	unsigned long		 capabilities;
+	unsigned long		*supported;
 
+	mac_dev->phylink_ops		= &dtsec_mac_ops;
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
 	mac_dev->change_addr		= dtsec_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
 	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
 	mac_dev->set_exception		= dtsec_set_exception;
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
 	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = adjust_link_dtsec;
 	mac_dev->enable			= dtsec_enable;
 	mac_dev->disable		= dtsec_disable;
 
@@ -1502,19 +1426,56 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	dtsec->dtsec_drv_param->tx_pad_crc = true;
 
 	phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
-	if (!phy_node) {
-		pr_err("TBI PHY node is not available\n");
+	if (!phy_node || of_device_is_available(phy_node)) {
+		of_node_put(phy_node);
 		err = -EINVAL;
+		dev_err_probe(mac_dev->dev, err,
+			      "TBI PCS node is not available\n");
 		goto _return_fm_mac_free;
 	}
 
-	dtsec->tbiphy = of_phy_find_device(phy_node);
-	if (!dtsec->tbiphy) {
-		pr_err("of_phy_find_device (TBI PHY) failed\n");
-		err = -EINVAL;
+	dtsec->tbidev = of_mdio_find_device(phy_node);
+	of_node_put(phy_node);
+	if (!dtsec->tbidev) {
+		err = -EPROBE_DEFER;
+		dev_err_probe(mac_dev->dev, err,
+			      "could not find mdiodev for PCS\n");
 		goto _return_fm_mac_free;
 	}
-	put_device(&dtsec->tbiphy->mdio.dev);
+	dtsec->pcs.ops = &dtsec_pcs_ops;
+	dtsec->pcs.poll = true;
+
+	supported = mac_dev->phylink_config.supported_interfaces;
+
+	/* FIXME: Can we use DTSEC_ID2_INT_FULL_OFF to determine if these are
+	 * supported? If not, we can determine support via the phy if SerDes
+	 * support is added.
+	 */
+	if (mac_dev->phy_if == PHY_INTERFACE_MODE_SGMII ||
+	    mac_dev->phy_if == PHY_INTERFACE_MODE_1000BASEX) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+	} else if (mac_dev->phy_if == PHY_INTERFACE_MODE_2500BASEX) {
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+	}
+
+	if (!(ioread32be(&dtsec->regs->tsec_id2) & DTSEC_ID2_INT_REDUCED_OFF)) {
+		phy_interface_set_rgmii(supported);
+
+		/* DTSEC_ID2_INT_REDUCED_OFF indicates that the dTSEC supports
+		 * RMII and RGMII. However, the only SoCs which support RMII
+		 * are the P1017 and P1023. Avoid advertising this mode on
+		 * other SoCs. This is a bit of a moot point, since there's no
+		 * in-tree support for ethernet on these platforms...
+		 */
+		if (of_machine_is_compatible("fsl,P1023") ||
+		    of_machine_is_compatible("fsl,P1023RDB"))
+			__set_bit(PHY_INTERFACE_MODE_RMII, supported);
+	}
+
+	capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+	capabilities |= MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD;
+	mac_dev->phylink_config.mac_capabilities = capabilities;
 
 	err = dtsec_init(dtsec);
 	if (err < 0)
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 65887a3160d7..e5d6cddea731 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -170,20 +170,10 @@ struct fman_mac_params {
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
index 2b274d50fafb..0abb1b037635 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -278,9 +278,6 @@ struct fman_mac {
 	struct memac_regs __iomem *regs;
 	/* MAC address of device */
 	u64 addr;
-	/* Ethernet physical interface */
-	phy_interface_t phy_if;
-	u16 max_speed;
 	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
@@ -293,12 +290,12 @@ struct fman_mac {
 	struct memac_cfg *memac_drv_param;
 	void *fm;
 	struct fman_rev_info fm_rev_info;
-	bool basex_if;
 	struct phy *serdes;
 	struct phylink_pcs *sgmii_pcs;
 	struct phylink_pcs *qsgmii_pcs;
 	struct phylink_pcs *xfi_pcs;
 	bool allmulti_enabled;
+	bool rgmii_no_half_duplex;
 };
 
 static void add_addr_in_paddr(struct memac_regs __iomem *regs, const u8 *adr,
@@ -356,7 +353,6 @@ static void set_exception(struct memac_regs __iomem *regs, u32 val,
 }
 
 static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
-		phy_interface_t phy_if, u16 speed, bool slow_10g_if,
 		u32 exceptions)
 {
 	u32 tmp;
@@ -384,41 +380,6 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
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
@@ -458,24 +419,6 @@ static u32 get_mac_addr_hash_code(u64 eth_addr)
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
@@ -581,41 +524,31 @@ static void free_init_resources(struct fman_mac *memac)
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
 static int memac_enable(struct fman_mac *memac)
 {
-	struct memac_regs __iomem *regs = memac->regs;
-	u32 tmp;
+	int ret;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
+	ret = phy_init(memac->serdes);
+	if (ret) {
+		dev_err(memac->dev_id->dev,
+			"could not initialize serdes: %pe\n", ERR_PTR(ret));
+		return ret;
+	}
 
-	tmp = ioread32be(&regs->command_config);
-	tmp |= CMD_CFG_RX_EN | CMD_CFG_TX_EN;
-	iowrite32be(tmp, &regs->command_config);
+	ret = phy_power_on(memac->serdes);
+	if (ret) {
+		dev_err(memac->dev_id->dev,
+			"could not power on serdes: %pe\n", ERR_PTR(ret));
+		phy_exit(memac->serdes);
+	}
 
-	return 0;
+	return ret;
 }
 
 static void memac_disable(struct fman_mac *memac)
-
 {
-	struct memac_regs __iomem *regs = memac->regs;
-	u32 tmp;
-
-	WARN_ON_ONCE(!is_init_done(memac->memac_drv_param));
-
-	tmp = ioread32be(&regs->command_config);
-	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
-	iowrite32be(tmp, &regs->command_config);
+	phy_power_off(memac->serdes);
+	phy_exit(memac->serdes);
 }
 
 static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
@@ -623,9 +556,6 @@ static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->command_config);
 	if (new_val)
 		tmp |= CMD_CFG_PROMIS_EN;
@@ -637,73 +567,12 @@ static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
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
-	mac_dev->update_speed(mac_dev, phy_dev->speed);
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
@@ -738,9 +607,6 @@ static int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->command_config);
 	if (en)
 		tmp &= ~CMD_CFG_PAUSE_IGNORE;
@@ -752,12 +618,179 @@ static int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	return 0;
 }
 
+static void memac_validate(struct phylink_config *config,
+			   unsigned long *supported,
+			   struct phylink_link_state *state)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	struct fman_mac *memac = fman_config_to_mac(config)->fman_mac;
+
+	phylink_generic_validate(config, supported, state);
+
+	if (phy_interface_mode_is_rgmii(state->interface) &&
+	    memac->rgmii_no_half_duplex) {
+		phylink_get_linkmodes(mask, state->interface,
+				      MAC_10HD | MAC_100HD);
+		linkmode_andnot(supported, supported, mask);
+		linkmode_andnot(state->advertising, state->advertising, mask);
+	}
+}
+
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
+	/* TODO: EEE? */
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
+	mac_dev->update_speed(mac_dev, speed);
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
+static const struct phylink_mac_ops memac_mac_ops = {
+	.validate = memac_validate,
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
@@ -771,9 +804,6 @@ static int memac_add_hash_mac_address(struct fman_mac *memac,
 	u32 hash;
 	u64 addr;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	addr = ENET_ADDR_TO_UINT64(*eth_addr);
 
 	if (!(addr & GROUP_ADDRESS)) {
@@ -802,9 +832,6 @@ static int memac_set_allmulti(struct fman_mac *memac, bool enable)
 	u32 entry;
 	struct memac_regs __iomem *regs = memac->regs;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	if (enable) {
 		for (entry = 0; entry < HASH_TABLE_SIZE; entry++)
 			iowrite32be(entry | HASH_CTRL_MCAST_EN,
@@ -834,9 +861,6 @@ static int memac_del_hash_mac_address(struct fman_mac *memac,
 	u32 hash;
 	u64 addr;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	addr = ENET_ADDR_TO_UINT64(*eth_addr);
 
 	hash = get_mac_addr_hash_code(addr) & HASH_CTRL_ADDR_MASK;
@@ -864,9 +888,6 @@ static int memac_set_exception(struct fman_mac *memac,
 {
 	u32 bit_mask = 0;
 
-	if (!is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	bit_mask = get_exception_flag(exception);
 	if (bit_mask) {
 		if (enable)
@@ -886,23 +907,15 @@ static int memac_init(struct fman_mac *memac)
 {
 	struct memac_cfg *memac_drv_param;
 	enet_addr_t eth_addr;
-	bool slow_10g_if = false;
-	struct fixed_phy_status *fixed_link;
 	int err;
 	u32 reg32 = 0;
 
-	if (is_init_done(memac->memac_drv_param))
-		return -EINVAL;
-
 	err = check_init_parameters(memac);
 	if (err)
 		return err;
 
 	memac_drv_param = memac->memac_drv_param;
 
-	if (memac->fm_rev_info.major == 6 && memac->fm_rev_info.minor == 4)
-		slow_10g_if = true;
-
 	/* First, reset the MAC if desired. */
 	if (memac_drv_param->reset_on_init) {
 		err = reset(memac->regs);
@@ -918,10 +931,7 @@ static int memac_init(struct fman_mac *memac)
 		add_addr_in_paddr(memac->regs, (const u8 *)eth_addr, 0);
 	}
 
-	fixed_link = memac_drv_param->fixed_link;
-
-	init(memac->regs, memac->memac_drv_param, memac->phy_if,
-	     memac->max_speed, slow_10g_if, memac->exceptions);
+	init(memac->regs, memac->memac_drv_param, memac->exceptions);
 
 	/* FM_RX_FIFO_CORRUPT_ERRATA_10GMAC_A006320 errata workaround
 	 * Exists only in FMan 6.0 and 6.3.
@@ -937,11 +947,6 @@ static int memac_init(struct fman_mac *memac)
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
@@ -970,23 +975,24 @@ static int memac_init(struct fman_mac *memac)
 	fman_register_intr(memac->fm, FMAN_MOD_MAC, memac->mac_id,
 			   FMAN_INTR_TYPE_NORMAL, memac_exception, memac);
 
-	kfree(memac_drv_param);
-	memac->memac_drv_param = NULL;
-
 	return 0;
 }
 
+static void pcs_free(struct phylink_pcs *pcs)
+{
+	if (!IS_ERR_OR_NULL(pcs)) {
+		put_device(&lynx_get_mdio_device(pcs)->dev);
+		lynx_pcs_destroy(pcs);
+	}
+}
+
 static int memac_free(struct fman_mac *memac)
 {
 	free_init_resources(memac);
 
-	if (memac->sgmii_pcs)
-		lynx_pcs_destroy(memac->sgmii_pcs);
-	if (memac->qsgmii_pcs)
-		lynx_pcs_destroy(memac->qsgmii_pcs);
-	if (memac->xfi_pcs)
-		lynx_pcs_destroy(memac->xfi_pcs);
-
+	pcs_free(memac->sgmii_pcs);
+	pcs_free(memac->qsgmii_pcs);
+	pcs_free(memac->xfi_pcs);
 	kfree(memac->memac_drv_param);
 	kfree(memac);
 
@@ -1019,8 +1025,6 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
 	memac->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
 
 	memac->regs = mac_dev->vaddr;
-	memac->max_speed = params->max_speed;
-	memac->phy_if = mac_dev->phy_if;
 	memac->mac_id = params->mac_id;
 	memac->exceptions = (MEMAC_IMASK_TSECC_ER | MEMAC_IMASK_TECC_ER |
 			     MEMAC_IMASK_RECC_ER | MEMAC_IMASK_MGI);
@@ -1028,7 +1032,6 @@ static struct fman_mac *memac_config(struct mac_device *mac_dev,
 	memac->event_cb = params->event_cb;
 	memac->dev_id = mac_dev;
 	memac->fm = params->fm;
-	memac->basex_if = params->basex_if;
 
 	/* Save FMan revision */
 	fman_get_revision(memac->fm, &memac->fm_rev_info);
@@ -1053,32 +1056,41 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
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
+	struct device_node      *fixed;
 	struct phylink_pcs	*pcs;
-	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
+	unsigned long		 capabilities;
+	unsigned long		*supported;
 
+	mac_dev->phylink_ops		= &memac_mac_ops;
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
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
 
-	if (params->max_speed == SPEED_10000)
-		mac_dev->phy_if = PHY_INTERFACE_MODE_XGMII;
-
 	mac_dev->fman_mac = memac_config(mac_dev, params);
 	if (!mac_dev->fman_mac) {
 		err = -EINVAL;
@@ -1124,9 +1136,9 @@ int memac_initialization(struct mac_device *mac_dev,
 	else
 		pcs = memac_pcs_create(mac_node, err);
 
-	if (!pcs) {
-		dev_err(mac_dev->dev, "missing pcs\n");
-		err = -ENOENT;
+	if (IS_ERR(pcs)) {
+		err = PTR_ERR(pcs);
+		dev_err_probe(mac_dev->dev, err, "missing pcs\n");
 		goto _return_fm_mac_free;
 	}
 
@@ -1146,82 +1158,115 @@ int memac_initialization(struct mac_device *mac_dev,
 		err = PTR_ERR(memac->serdes);
 		dev_err_probe(mac_dev->dev, err, "could not get serdes\n");
 		goto _return_fm_mac_free;
+	}
+
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
+
+	/* Note that half duplex is only supported on 10/100M interfaces. */
+
+	if (memac->sgmii_pcs &&
+	    (memac_supports(mac_dev, PHY_INTERFACE_MODE_SGMII) ||
+	     memac_supports(mac_dev, PHY_INTERFACE_MODE_1000BASEX))) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+	}
+
+	if (memac->sgmii_pcs &&
+	    memac_supports(mac_dev, PHY_INTERFACE_MODE_2500BASEX))
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+
+	if (memac->qsgmii_pcs &&
+	    memac_supports(mac_dev, PHY_INTERFACE_MODE_QSGMII))
+		__set_bit(PHY_INTERFACE_MODE_QSGMII, supported);
+	else if (mac_dev->phy_if == PHY_INTERFACE_MODE_QSGMII)
+		dev_warn(mac_dev->dev, "no QSGMII pcs specified\n");
+
+	if (memac->xfi_pcs &&
+	    memac_supports(mac_dev, PHY_INTERFACE_MODE_10GBASER)) {
+		__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
 	} else {
-		err = phy_init(memac->serdes);
-		if (err) {
-			dev_err_probe(mac_dev->dev, err,
-				      "could not initialize serdes\n");
+		/* From what I can tell, only 1G macs support RGMII. */
+		/* For compatibility, default to enabled if the rgmii property
+		 * is absent
+		 */
+		unsigned int rgmii = 1;
+
+		err = of_property_read_u32(mac_node, "rgmii", &rgmii);
+		if (err == -EINVAL)
+			dev_warn(mac_dev->dev,
+				 "missing 'rgmii' property; assuming supported\n");
+		else if (err)
 			goto _return_fm_mac_free;
-		}
 
-		err = phy_power_on(memac->serdes);
-		if (err) {
-			dev_err_probe(mac_dev->dev, err,
-				      "could not power on serdes\n");
-			goto _return_phy_exit;
-		}
+		if (rgmii) {
+			phy_interface_set_rgmii(supported);
 
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
+			if (of_property_read_bool(mac_node, "mii"))
+				__set_bit(PHY_INTERFACE_MODE_MII, supported);
 		}
 	}
 
-	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
-		struct phy_device *phy;
-
-		err = of_phy_register_fixed_link(mac_node);
-		if (err)
-			goto _return_phy_power_off;
-
-		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
-		if (!fixed_link) {
-			err = -ENOMEM;
-			goto _return_phy_power_off;
-		}
-
-		mac_dev->phy_node = of_node_get(mac_node);
-		phy = of_phy_find_device(mac_dev->phy_node);
-		if (!phy) {
-			err = -EINVAL;
-			of_node_put(mac_dev->phy_node);
-			goto _return_fixed_link_free;
-		}
-
-		fixed_link->link = phy->link;
-		fixed_link->speed = phy->speed;
-		fixed_link->duplex = phy->duplex;
-		fixed_link->pause = phy->pause;
-		fixed_link->asym_pause = phy->asym_pause;
-
-		put_device(&phy->mdio.dev);
-		memac->memac_drv_param->fixed_link = fixed_link;
-	}
+	capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
+	capabilities |= MAC_10 | MAC_100 | MAC_1000FD | MAC_2500FD | MAC_10000FD;
+
+	/* These SoCs don't support half duplex at all; there's no different
+	 * FMan version or compatible, so we just have to check the machine
+	 * compatible instead
+	 */
+	if (of_machine_is_compatible("fsl,ls1043a") ||
+	    of_machine_is_compatible("fsl,ls1046a") ||
+	    of_machine_is_compatible("fsl,B4QDS"))
+		capabilities &= ~(MAC_10HD | MAC_100HD);
+
+	mac_dev->phylink_config.mac_capabilities = capabilities;
+
+	/* The T2080 and T4240 don't support half duplex RGMII. There is no
+	 * other way to identify these SoCs, so just use the machine
+	 * compatible.
+	 */
+	if (of_machine_is_compatible("fsl,T2080QDS") ||
+	    of_machine_is_compatible("fsl,T2080RDB") ||
+	    of_machine_is_compatible("fsl,T2081QDS") ||
+	    of_machine_is_compatible("fsl,T4240QDS") ||
+	    of_machine_is_compatible("fsl,T4240RDB"))
+		memac->rgmii_no_half_duplex = true;
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
 
 	goto _return;
 
-_return_phy_power_off:
-	phy_power_off(memac->serdes);
-_return_phy_exit:
-	phy_exit(memac->serdes);
-_return_fixed_link_free:
-	kfree(fixed_link);
 _return_fm_mac_free:
 	memac_free(mac_dev->fman_mac);
 _return:
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 33f3b1cc2cfe..00a8c65cdd56 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -13,6 +13,7 @@
 #include <linux/bitrev.h>
 #include <linux/io.h>
 #include <linux/crc32.h>
+#include <linux/netdevice.h>
 
 /* Transmit Inter-Packet Gap Length Register (TX_IPG_LENGTH) */
 #define TGEC_TX_IPG_LENGTH_MASK	0x000003ff
@@ -243,10 +244,6 @@ static int init(struct tgec_regs __iomem *regs, struct tgec_cfg *cfg,
 
 static int check_init_parameters(struct fman_mac *tgec)
 {
-	if (tgec->max_speed < SPEED_10000) {
-		pr_err("10G MAC driver only support 10G speed\n");
-		return -EINVAL;
-	}
 	if (!tgec->exception_cb) {
 		pr_err("uninitialized exception_cb\n");
 		return -EINVAL;
@@ -384,40 +381,13 @@ static void free_init_resources(struct fman_mac *tgec)
 	tgec->unicast_addr_hash = NULL;
 }
 
-static bool is_init_done(struct tgec_cfg *cfg)
-{
-	/* Checks if tGEC driver parameters were initialized */
-	if (!cfg)
-		return true;
-
-	return false;
-}
-
 static int tgec_enable(struct fman_mac *tgec)
 {
-	struct tgec_regs __iomem *regs = tgec->regs;
-	u32 tmp;
-
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
-	tmp = ioread32be(&regs->command_config);
-	tmp |= CMD_CFG_RX_EN | CMD_CFG_TX_EN;
-	iowrite32be(tmp, &regs->command_config);
-
 	return 0;
 }
 
 static void tgec_disable(struct fman_mac *tgec)
 {
-	struct tgec_regs __iomem *regs = tgec->regs;
-	u32 tmp;
-
-	WARN_ON_ONCE(!is_init_done(tgec->cfg));
-
-	tmp = ioread32be(&regs->command_config);
-	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
-	iowrite32be(tmp, &regs->command_config);
 }
 
 static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
@@ -425,9 +395,6 @@ static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->command_config);
 	if (new_val)
 		tmp |= CMD_CFG_PROMIS_EN;
@@ -444,9 +411,6 @@ static int tgec_set_tx_pause_frames(struct fman_mac *tgec,
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	iowrite32be((u32)pause_time, &regs->pause_quant);
 
 	return 0;
@@ -457,9 +421,6 @@ static int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->command_config);
 	if (!en)
 		tmp |= CMD_CFG_PAUSE_IGNORE;
@@ -470,12 +431,53 @@ static int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 	return 0;
 }
 
+static void tgec_mac_config(struct phylink_config *config, unsigned int mode,
+			    const struct phylink_link_state *state)
+{
+}
+
+static void tgec_link_up(struct phylink_config *config, struct phy_device *phy,
+			 unsigned int mode, phy_interface_t interface,
+			 int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	struct mac_device *mac_dev = fman_config_to_mac(config);
+	struct fman_mac *tgec = mac_dev->fman_mac;
+	struct tgec_regs __iomem *regs = tgec->regs;
+	u16 pause_time = tx_pause ? FSL_FM_PAUSE_TIME_ENABLE :
+			 FSL_FM_PAUSE_TIME_DISABLE;
+	u32 tmp;
+
+	tgec_set_tx_pause_frames(tgec, 0, pause_time, 0);
+	tgec_accept_rx_pause_frames(tgec, rx_pause);
+	mac_dev->update_speed(mac_dev, speed);
+
+	tmp = ioread32be(&regs->command_config);
+	tmp |= CMD_CFG_RX_EN | CMD_CFG_TX_EN;
+	iowrite32be(tmp, &regs->command_config);
+}
+
+static void tgec_link_down(struct phylink_config *config, unsigned int mode,
+			   phy_interface_t interface)
+{
+	struct fman_mac *tgec = fman_config_to_mac(config)->fman_mac;
+	struct tgec_regs __iomem *regs = tgec->regs;
+	u32 tmp;
+
+	tmp = ioread32be(&regs->command_config);
+	tmp &= ~(CMD_CFG_RX_EN | CMD_CFG_TX_EN);
+	iowrite32be(tmp, &regs->command_config);
+}
+
+static const struct phylink_mac_ops tgec_mac_ops = {
+	.validate = phylink_generic_validate,
+	.mac_config = tgec_mac_config,
+	.mac_link_up = tgec_link_up,
+	.mac_link_down = tgec_link_down,
+};
+
 static int tgec_modify_mac_address(struct fman_mac *tgec,
 				   const enet_addr_t *p_enet_addr)
 {
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	tgec->addr = ENET_ADDR_TO_UINT64(*p_enet_addr);
 	set_mac_address(tgec->regs, (const u8 *)(*p_enet_addr));
 
@@ -490,9 +492,6 @@ static int tgec_add_hash_mac_address(struct fman_mac *tgec,
 	u32 crc = 0xFFFFFFFF, hash;
 	u64 addr;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	addr = ENET_ADDR_TO_UINT64(*eth_addr);
 
 	if (!(addr & GROUP_ADDRESS)) {
@@ -525,9 +524,6 @@ static int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
 	u32 entry;
 	struct tgec_regs __iomem *regs = tgec->regs;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	if (enable) {
 		for (entry = 0; entry < TGEC_HASH_TABLE_SIZE; entry++)
 			iowrite32be(entry | TGEC_HASH_MCAST_EN,
@@ -548,9 +544,6 @@ static int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	tmp = ioread32be(&regs->command_config);
 
 	if (enable)
@@ -572,9 +565,6 @@ static int tgec_del_hash_mac_address(struct fman_mac *tgec,
 	u32 crc = 0xFFFFFFFF, hash;
 	u64 addr;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	addr = ((*(u64 *)eth_addr) >> 16);
 
 	/* CRC calculation */
@@ -601,22 +591,12 @@ static int tgec_del_hash_mac_address(struct fman_mac *tgec,
 	return 0;
 }
 
-static void tgec_adjust_link(struct mac_device *mac_dev)
-{
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-
-	mac_dev->update_speed(mac_dev, phy_dev->speed);
-}
-
 static int tgec_set_exception(struct fman_mac *tgec,
 			      enum fman_mac_exceptions exception, bool enable)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 bit_mask = 0;
 
-	if (!is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	bit_mask = get_exception_flag(exception);
 	if (bit_mask) {
 		if (enable)
@@ -641,9 +621,6 @@ static int tgec_init(struct fman_mac *tgec)
 	enet_addr_t eth_addr;
 	int err;
 
-	if (is_init_done(tgec->cfg))
-		return -EINVAL;
-
 	if (DEFAULT_RESET_ON_INIT &&
 	    (fman_reset_mac(tgec->fm, tgec->mac_id) != 0)) {
 		pr_err("Can't reset MAC!\n");
@@ -752,7 +729,6 @@ static struct fman_mac *tgec_config(struct mac_device *mac_dev, struct fman_mac_
 
 	tgec->regs = mac_dev->vaddr;
 	tgec->addr = ENET_ADDR_TO_UINT64(mac_dev->addr);
-	tgec->max_speed = params->max_speed;
 	tgec->mac_id = params->mac_id;
 	tgec->exceptions = (TGEC_IMASK_MDIO_SCAN_EVENT	|
 			    TGEC_IMASK_REM_FAULT	|
@@ -787,17 +763,15 @@ int tgec_initialization(struct mac_device *mac_dev,
 	int err;
 	struct fman_mac		*tgec;
 
+	mac_dev->phylink_ops		= &tgec_mac_ops;
 	mac_dev->set_promisc		= tgec_set_promiscuous;
 	mac_dev->change_addr		= tgec_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
 	mac_dev->remove_hash_mac_addr	= tgec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= tgec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= tgec_accept_rx_pause_frames;
 	mac_dev->set_exception		= tgec_set_exception;
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
 	mac_dev->set_multi		= fman_set_multi;
-	mac_dev->adjust_link            = tgec_adjust_link;
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
 
@@ -807,6 +781,19 @@ int tgec_initialization(struct mac_device *mac_dev,
 		goto _return;
 	}
 
+	/* The internal connection to the serdes is XGMII, but this isn't
+	 * really correct for the phy mode (which is the external connection).
+	 * However, this is how all older device trees say that they want
+	 * XAUI, so just convert it for them.
+	 */
+	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XGMII)
+		mac_dev->phy_if = PHY_INTERFACE_MODE_XAUI;
+
+	__set_bit(PHY_INTERFACE_MODE_XAUI,
+		  mac_dev->phylink_config.supported_interfaces);
+	mac_dev->phylink_config.mac_capabilities =
+		MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10000FD;
+
 	tgec = mac_dev->fman_mac;
 	tgec->cfg->max_frame_length = fman_get_max_frm();
 	err = tgec_init(tgec);
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 7b7526fd7da3..2b0a30f69147 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -15,6 +15,7 @@
 #include <linux/phy.h>
 #include <linux/netdevice.h>
 #include <linux/phy_fixed.h>
+#include <linux/phylink.h>
 #include <linux/etherdevice.h>
 #include <linux/libfdt_env.h>
 
@@ -93,130 +94,8 @@ int fman_set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
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
@@ -263,8 +142,8 @@ static struct platform_device *dpaa_eth_add_device(int fman_id,
 }
 
 static const struct of_device_id mac_match[] = {
-	{ .compatible	= "fsl,fman-dtsec", .data = dtsec_initialization },
-	{ .compatible	= "fsl,fman-xgec", .data = tgec_initialization },
+	{ .compatible   = "fsl,fman-dtsec", .data = dtsec_initialization },
+	{ .compatible   = "fsl,fman-xgec", .data = tgec_initialization },
 	{ .compatible	= "fsl,fman-memac", .data = memac_initialization },
 	{}
 };
@@ -296,6 +175,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	platform_set_drvdata(_of_dev, mac_dev);
 
 	/* Save private information */
 	mac_dev->priv = priv;
@@ -424,57 +304,21 @@ static int mac_probe(struct platform_device *_of_dev)
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
index b95d384271bd..5bf03e1e279a 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -9,6 +9,7 @@
 #include <linux/device.h>
 #include <linux/if_ether.h>
 #include <linux/phy.h>
+#include <linux/phylink.h>
 #include <linux/list.h>
 
 #include "fman_port.h"
@@ -24,32 +25,22 @@ struct mac_device {
 	struct device		*dev;
 	u8			 addr[ETH_ALEN];
 	struct fman_port	*port[2];
-	u32			 if_support;
-	struct phy_device	*phy_dev;
+	struct phylink		*phylink;
+	struct phylink_config	phylink_config;
 	phy_interface_t		phy_if;
-	struct device_node	*phy_node;
-	struct net_device	*net_dev;
 
-	bool autoneg_pause;
-	bool rx_pause_req;
-	bool tx_pause_req;
-	bool rx_pause_active;
-	bool tx_pause_active;
 	bool promisc;
 	bool allmulti;
 
+	const struct phylink_mac_ops *phylink_ops;
 	int (*enable)(struct fman_mac *mac_dev);
 	void (*disable)(struct fman_mac *mac_dev);
-	void (*adjust_link)(struct mac_device *mac_dev);
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
@@ -63,6 +54,12 @@ struct mac_device {
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

