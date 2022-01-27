Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD3449D6B5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiA0A14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:27:56 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:29458 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbiA0A1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:27:55 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QK9ps7002638;
        Wed, 26 Jan 2022 19:27:47 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dud3cr3qe-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 19:27:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLLxqDaaHrl4fjV3Bt4OokDZPnpQpRbZxRkkZkASerX3+YAmV2J8xExszTvXcGcA79JI6o3O9Ltu2RHU6rWXsbqVg5wFZxmuYolzHiZIvBNkd6E5BHSDZ2JL3CAey7lUh8oYBwvqg2LW52OOSIKrzi97xGXh63aZySZ/tKn+RiLOn+btNhTc4R8f3coaDrkfSGK547R8TqhbYB4y/pET4TeMbjI26BnZyAjNJsuylXiYqNkq3tHMDHxCNwOFcYcahaz16Ex8gVLsI0cYWKsKaOjKg3O/4fRFP+jpmIbMpW/Njxpr8cwO9RSfumB9zzItwuYBXq6DV+WhXW8WBnPG4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+4Z3aJHtEQ0ydiC7Ig296tnVUiEzF9TLEzQnhCeSl0=;
 b=ZgMfmX1bTtuOJit3henr/lzy+7ePLNJm/JJ7GAnorhEOxmVYWosOgNO//0MySHR+G2RlCk595ZZT5EcthKGbllpVyp0tHFgms7Mgyx35PzASvnSe60e6aA1lcNe1UZVz4GqFGIbvtxYIDKuD3HTjXpozmUMhDyOoc9S7tVWs/iOZtxBiJjREUSxCXSRfLoPwHIbTBtKO+8gw7JeopGWdzZoC0i2l+GhOBDlDNwnVdEdt3BqjzV5RaHmeTkSyAZnEs6fZh5Sc4A2wyteU5WRW7FaAFWTEhAMTfYqcyl+iGpcq0nbl+by4XbcqNZVam3dNXvvrFLNSIGpUTFZEJ0uW3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+4Z3aJHtEQ0ydiC7Ig296tnVUiEzF9TLEzQnhCeSl0=;
 b=Bkk7cDnvMq1cjUIM7FyZi3Egk489h2oLzRCW9MYGncWrn0eof/S4MJjUVzN+bXxIxaeZlLDIrDgy+NeQkoU61zLdoxLYNPiEB2Xi+TwBW+BVWbWhhfDcSWdsDEggXLbIZWYkI4nPwEql/s+93U3ZZ1YOSAW4V/rFViJUu3TU5Tc=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Thu, 27 Jan
 2022 00:27:46 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 00:27:45 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 2/3] net: macb: Added ZynqMP-specific initialization
Date:   Wed, 26 Jan 2022 18:27:10 -0600
Message-Id: <20220127002711.3632101-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127002711.3632101-1-robert.hancock@calian.com>
References: <20220127002711.3632101-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8971d1e7-2d67-4cdf-2a2b-08d9e12bd71a
X-MS-TrafficTypeDiagnostic: YQXPR01MB5578:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB557870BE38DC7B7AEB124F0DEC219@YQXPR01MB5578.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aL3JWOsVb6R0mNyv5T2gM1wK5P8zv/svq4ZD1/+PxK7TMxty3Ydp4wJ8wIlK+PYLNzHvNsGo9r/EMDmwQ5oSCx/h9SHLxz5Cklh4eJiInLFHafPaoIBwzV/VGijuPqIc0RcRh6YbSSyiVjnUjuSs58hLhevOj+kTNk68IpP4pD/11AGOJge1mCEpPUKuqjNE3Stwm9KqAx/f80fH+hX+bTRshkjHsb/WcDuRbAOZT6aLPN3GunXQ+kNHy/xhxCvekFkw2rpxj1fISBKdzojT464x+prcPXTWRgZArtm9R8WNvl1cG5xGya/ECqD88V7cxlX0ZOd+Y1PiN8LZQ/48OBLXPaJXSGmimrI8JQQ9KILe0XwP3iSGe/VBtcfFXhAPTzoLa+megHA+4UXdWo/1E32ZqtXtkd6VAoM4VuMmLUKn5H1zSjH/xqw2PkQ1xHSwUFIETKHaEc5JR2vJ0ZePnFrerSD30pVHNZlWsKz6wUlPnjPUePFotVtyJKTpJUbFY0q1BnCOSomwcfiXsrTgM/zw/KCpyX39Iv44k+Nm2zIoUgqptdzCgnTOPf88PUkYaCFmkxyx9AwKuyA1M2KSjAifmpPBKOsUhr+wj8Yiqu45XqlJPzcHrd9lUOoNyh8g4LIYuhOYArtf6YG4T2vwCPY7fXDJwbrNiPwNFp244L3vyOSlNzyj/iSEyjQm7L1SXo7KvXry/wCp+gNcwjdAeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38350700002)(107886003)(66556008)(8676002)(66476007)(38100700002)(66946007)(4326008)(508600001)(6506007)(44832011)(83380400001)(2616005)(52116002)(26005)(186003)(86362001)(2906002)(8936002)(6512007)(36756003)(1076003)(6486002)(6916009)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jw6L7BB0pylEGnSnQ3lq1xbjYkAAtH+7uAMNbmzpum/kkRZRLzHS5mX6Dqfb?=
 =?us-ascii?Q?Qe6WmJC8dwbl8oEQx5drtNs20YVUXltyT4l4gGvWCMevxQLRS8D9EMvy2YH0?=
 =?us-ascii?Q?ZgA1wSgFIIlFxoEUADC5acnY5Rwk1WbmqVop1KelEfmEFhKwtxeF/k/mpZMg?=
 =?us-ascii?Q?hJnBGjrAufU2UEUI7OUUarSBjWTMPlhHtr7s56OAMx7MUfNdarfZ+Ci5uY/+?=
 =?us-ascii?Q?t2qDMiP7+MTLzyLgor7qNjRWvx5FQjbMPMbjPLTheOeYWj2PsJMz633P+sq/?=
 =?us-ascii?Q?YDXF1HhS/Fq9FEeps4oK2F/GTqWWhzelyJW6BIJjto1MihzJ9JSjCWppBdU2?=
 =?us-ascii?Q?95J/elAGBVRQYAqgfuGs34vxlzXa7UzxaWQIgpks2m1sv5DkkIYLLmMIZ5kA?=
 =?us-ascii?Q?eQx4k84ZTZplUsm1amLD5E1HqKVEvaLVKEiMk75/agxT4qON7PSVya4frnFA?=
 =?us-ascii?Q?uiAbVdTv+XQy+hsTsGFYOL0bAag2jbwJNsSmQbmsKXftGxTmvl6hrZ0qx+I9?=
 =?us-ascii?Q?jBoKXcAFOem22lfeHRl2+EBfAJAeTaN6lRT9i0lD37KNUoq5WfEwjHOyAgjV?=
 =?us-ascii?Q?UuI0ePU6qX6V1VrW6UbmfcNUpe82dwuHSk9NBY9u7jrnckOB5HYmwPPTX4iQ?=
 =?us-ascii?Q?UfHxsXtB3px6bRo+K0n9WxfA4xi/OyVLXWCKFHMRsTQKxTeGpHgfMckXuV9k?=
 =?us-ascii?Q?KPkfAkuM002UNWv5iGuy61dPEBqzymJ9oDJn+TZ2tKZNMoGMi1p4Jc53INal?=
 =?us-ascii?Q?GQNYO/kndmEEaJn7p6a07B/pIbrGbQSlTGr9ysunqeS4WMGVu0GfJkPkGXbo?=
 =?us-ascii?Q?k4p0cv0Hwb2x61Zo7ZBXtPGYGqP0hHrUhEaX/K6m9xuJorqxQyjQO3HFvsx/?=
 =?us-ascii?Q?auDpt8cujnXE6mtqKTeVWvmT9cd2G4Vpej5czlDO8bl/I1Lov/mEsudME9gr?=
 =?us-ascii?Q?I7VbknFE93ytWD3cW4CRqfS9MknhEbSjQgmfREX0qnQDtpd4RZ/uOadUVvk0?=
 =?us-ascii?Q?lhvOLiPaIvdrtAeimp5Rju8sU0gVSEGhnkM6qFU2PGAf3MKkWZ44NBmlbfIT?=
 =?us-ascii?Q?rchvJr2rfh2OpcsWmiFQALwYTHUVW0K8GUF8Dax8w0JEG+utUULvArw6XeNs?=
 =?us-ascii?Q?trrqg5jGJlsM+QQmIFVQNIPOMhSWNiMza0PZ3Fhg0dMUyZe/s7ayTReYdqdl?=
 =?us-ascii?Q?vM/bRRq61eiygjesit/vUHevW4dq2NfiDzabm6A5SUX3adedXgb1RKY/bzQW?=
 =?us-ascii?Q?Xnubh30F4eVIpmbn8yQlcgrCjzZqfmUyBZZ2Ao/6134l9FEXpaNLWzxz3osA?=
 =?us-ascii?Q?HuehKLDcxSb3bcZFyungqZXWNUg6T5GBHIuZzQWDaSvzH9g2ILLdeCJU79mp?=
 =?us-ascii?Q?k/uLlfn+UdTxNJD9JjZhJTu6ewuYHfpzEtzGSslC7+C2ec0eGLJwjHEpkLfC?=
 =?us-ascii?Q?Ptanu9aJcsRtcP0Ru4n7l4t3r8Qg0qpgaVot1nXuWKgT/dMCxxvO/ADsNjLk?=
 =?us-ascii?Q?7aceG3oXYr3smWAuND9ptcRlPP7T0tqmA0Rr2OVa4uQaa7aoDVxQA6UWP4sU?=
 =?us-ascii?Q?b2260rczq2V6koxrGpni2+DV8By0N4gLaIVzwaLrzfo2RFsdRChoVvXB98rx?=
 =?us-ascii?Q?u37Ff1gi9ToshNYik0GO7Y2WXftset+8xGoqv6FJFY5zHVlMO6gXm+24nEkV?=
 =?us-ascii?Q?TAvfTO2t6IfJnzjD5drz2QA91Ck=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8971d1e7-2d67-4cdf-2a2b-08d9e12bd71a
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:27:45.9545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUmHSuV2CKX0Q8SfHSeb5PPruXvTGL5U9CXTv6NgtOw1pfgoaNQyJYvn5wDxsKLUdELzQ6p1PHFZDuie09TKc5fHk1rxiYZmEON/q9thAX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB5578
X-Proofpoint-ORIG-GUID: cwVAmVGew3I03ZkqftbP8z4tfMQXvKKg
X-Proofpoint-GUID: cwVAmVGew3I03ZkqftbP8z4tfMQXvKKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=926 spamscore=0 lowpriorityscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GEM controllers on ZynqMP were missing some initialization steps which
are required in some cases when using SGMII mode, which uses the PS-GTR
transceivers managed by the phy-zynqmp driver.

The GEM core appears to need a hardware-level reset in order to work
properly in SGMII mode in cases where the GT reference clock was not
present at initial power-on. This can be done using a reset mapped to
the zynqmp-reset driver in the device tree.

Also, when in SGMII mode, the GEM driver needs to ensure the PHY is
initialized and powered on.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb.h      |  5 +++
 drivers/net/ethernet/cadence/macb_main.c | 53 +++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9ddbee7de72b..584336b7cdaf 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -12,6 +12,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/net_tstamp.h>
 #include <linux/interrupt.h>
+#include <linux/phy/phy.h>
 
 #if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) || defined(CONFIG_MACB_USE_HWSTAMP)
 #define MACB_EXT_DESC
@@ -1291,6 +1292,9 @@ struct macb {
 	u32			wol;
 
 	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
+
+	struct phy		*sgmii_phy;     /* for ZynqMP SGMII mode */
+
 #ifdef MACB_EXT_DESC
 	uint8_t hw_dma_cap;
 #endif
@@ -1315,6 +1319,7 @@ struct macb {
 
 	struct macb_pm_data pm_data;
 	const struct macb_usrio_config *usrio;
+
 };
 
 #ifdef CONFIG_MACB_USE_HWSTAMP
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a363da928e8b..4787196e0980 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -34,7 +34,9 @@
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
+#include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
+#include <linux/reset.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -2739,6 +2741,10 @@ static int macb_open(struct net_device *dev)
 
 	macb_init_hw(bp);
 
+	err = phy_power_on(bp->sgmii_phy);
+	if (err)
+		goto reset_hw;
+
 	err = macb_phylink_connect(bp);
 	if (err)
 		goto reset_hw;
@@ -2775,6 +2781,8 @@ static int macb_close(struct net_device *dev)
 	phylink_stop(bp->phylink);
 	phylink_disconnect_phy(bp->phylink);
 
+	phy_power_off(bp->sgmii_phy);
+
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
 	netif_carrier_off(dev);
@@ -4544,13 +4552,50 @@ static const struct macb_config np4_config = {
 	.usrio = &macb_default_usrio,
 };
 
+static int zynqmp_init(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct macb *bp = netdev_priv(dev);
+	int ret;
+
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
+		bp->sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
+
+		if (IS_ERR(bp->sgmii_phy)) {
+			ret = PTR_ERR(bp->sgmii_phy);
+			dev_err_probe(&pdev->dev, ret,
+				      "failed to get PS-GTR PHY\n");
+			return ret;
+		}
+
+		ret = phy_init(bp->sgmii_phy);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to init PS-GTR PHY: %d\n",
+				ret);
+			return ret;
+		}
+	}
+
+	/* Fully reset GEM controller at hardware level using zynqmp-reset driver,
+	 * if mapped in device tree.
+	 */
+	ret = device_reset_optional(&pdev->dev);
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret, "failed to reset controller");
+		return ret;
+	}
+
+	return macb_init(pdev);
+}
+
 static const struct macb_config zynqmp_config = {
 	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE |
 			MACB_CAPS_JUMBO |
 			MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
-	.init = macb_init,
+	.init = zynqmp_init,
 	.jumbo_max_len = 10240,
 	.usrio = &macb_default_usrio,
 };
@@ -4767,7 +4812,7 @@ static int macb_probe(struct platform_device *pdev)
 
 	err = macb_mii_init(bp);
 	if (err)
-		goto err_out_free_netdev;
+		goto err_out_phy_exit;
 
 	netif_carrier_off(dev);
 
@@ -4792,6 +4837,9 @@ static int macb_probe(struct platform_device *pdev)
 	mdiobus_unregister(bp->mii_bus);
 	mdiobus_free(bp->mii_bus);
 
+err_out_phy_exit:
+	phy_exit(bp->sgmii_phy);
+
 err_out_free_netdev:
 	free_netdev(dev);
 
@@ -4813,6 +4861,7 @@ static int macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		phy_exit(bp->sgmii_phy);
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
-- 
2.31.1

