Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5DE49E7B8
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbiA0QjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:39:10 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:47368 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234708AbiA0QjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:39:09 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20RCHCF1005960;
        Thu, 27 Jan 2022 11:38:44 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3duu8kr6pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 11:38:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQdx+v8epzkl1fjS0U4G2aFgea7njgZ3PAW6/8EueJHKrliNbBdXHSOXMSYvI9GmPlRlfQC+fl+fTTrK+oUXihpHrC3JUVO83JOqS2U50ysAssvYu0gDwpENnX1H4P0270VUXtBhMlmM6Rs1oPJYQhlQlqHkt6x1Av/s/IVEtS721Tvktk5QZ+gpPzJqGPTJXFLdwOdyazIa/eep9uL8hDX0bf/+cFydozYl0j7x0VmJzGRzgqCkkI2zSmWkOv/acdKZKmHkwJ5c38ui3Ur2Sy0g20KoT1228JJel3IeKP2ZA9vPeBeRA4XP8Bxga/ycIWpz54JT93UZfRwgQWBHcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9T6jFQFhSz0GMOP/aUa3YakhTJOgHhScPKdM1yWrGtU=;
 b=OMkZqSay1aeEJbuMqLKEE3KD5FuHK3XieTz2s7DbCybKpUZkCI+glsmy7Qajsuie7uUkZeIkZYl4/gszLVdfD858EvoC5QvPLBHnKbKRGbZR/JvxJ2NGJo9ZzOSMPLZBPlzRcei0q2zaftz+w0GeXSoORx/ZG44fcZqf0t6YUBqEPa93rjC2S3LwL3d0RdTYqnNZe06AAmmDa71UkO1XaZkdKvk1SUfYmLMg+O7GUC+IEm9pdAuhuCW1XCXdJwDVMq6F22etbiqAOp1fTW5on9Fexm2h92GDLwwnnjwpzUDz7LoveC1PoBO6a7ov5GaLgMp0aEfDqUfUp1LQX1ZWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T6jFQFhSz0GMOP/aUa3YakhTJOgHhScPKdM1yWrGtU=;
 b=fDCBFq6n0BrIorofIZ3G1h3bDxKkpdEL3eNK6+uP+q46mf4bv15RdGo1ZHOnbHkyK1767bIMvLvxwqMLah1QHu8omrAUB/lx0rFoP7/V494hOkk+uIjV+XUhuLmvzjB4jnGZhPMGdq+F8SQOo34H66enZkRN23wcruCJR3Tn6B8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:2f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 16:38:42 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 16:38:42 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, laurent.pinchart@ideasonboard.com,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 2/3] net: macb: Added ZynqMP-specific initialization
Date:   Thu, 27 Jan 2022 10:37:35 -0600
Message-Id: <20220127163736.3677478-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127163736.3677478-1-robert.hancock@calian.com>
References: <20220127163736.3677478-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:610:4e::15) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acc89adb-9806-4fc9-1046-08d9e1b37a9c
X-MS-TrafficTypeDiagnostic: QB1PR01MB2531:EE_
X-Microsoft-Antispam-PRVS: <QB1PR01MB253166944DA455335AC3CE98EC219@QB1PR01MB2531.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ab4K7eNKU0P9cDBqkcM181tBFThYPzlfO3lfohwWm9u1A8LaUd1XDQ9+VNx4YJTzKypE0yYLB5tk8lxYrtcQmssgN3POmZ+zD430wWejg9WcW/vqwCT7QcFN5p6k9DfVb5lCYAM3+EjlW4XXkGHroOeSizqQG3TBiQK19gV+jMcAF5ZtRFoTMzyHsm0MYKasbCiZjZgEVFygMeTnJ0CjxdIelvc+KSCL/p4ErEkAU5FnkbT8VG5aidYvQ6Z9zPaT3HdM/6e4agc9c7Y1UQqKpAyEyDVl1EqqGFeje9ayuJJKmwNTFVMVfJOSGIfmlWH5YiaNGSunosoWtibhs3UqblUSs1U3cTwn/bAEFlH2S6yYPO/xDrdoTxsLztwL0EJbvNXysNSbCC+G01/0yw2mO+AI/cxG0mA1D09CLkpbkgh/rRjnGDj+I0LNw8k0EAHoplQv6gnknnDFsXftH8aUImksMbqMGLPwX6kOjpBM8AbXRcd9xCkkvMEjRIsANXXX7ouSEsbJJQdKno7FwAZ2kptd4f5c3ggoGgb0tRgXm29b1yp0FQOs8lhgR8yt91uKViKJvhKVHYpnH3FYJkSjVW+HSnnXuTQuncLrtTO3TjIh8pEgU1cp8FfPT+tGSnwMW6qSq35tcaME0Sji/07OCNX5EBm5zKYB4o/g1dLaNUmZpXTLWC5/Wu956+4DYbq1q3+yMKwva4cRbvkTHRmL5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(1076003)(186003)(36756003)(38350700002)(26005)(107886003)(52116002)(6506007)(44832011)(6666004)(2906002)(2616005)(316002)(8676002)(8936002)(4326008)(66556008)(66946007)(508600001)(66476007)(6486002)(6916009)(7416002)(5660300002)(6512007)(86362001)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ARuOkCNMqCKMrQR4snxCmBlYwtXN/U0/2RwPcrT0aGtQJTwgKxSC7Hw803Am?=
 =?us-ascii?Q?SOlp4yY4weEmln64xQShB2YRxSsVwRpVlO5tu4Wu+dPVC3+2mR7qLV1ASaNG?=
 =?us-ascii?Q?ergSExcrGvc/zzFt0GZlsFrwxCQ19R6LdojA2YE/CKz0BUMzlfo6dunnGP+a?=
 =?us-ascii?Q?nmOQ/beWz4d5mzx/yG2yKZXkDAv15/1nAU6mSFZ/6LeG9XHyaEcLYCDNOTFU?=
 =?us-ascii?Q?eH1xdtWb9xE5UnNlyAld6lfkTkMZKLJH/PS2n4h0Klya4F2oRRRAIcwA/jTj?=
 =?us-ascii?Q?IpnHAddK1ZJpWM+2Uz+A1BDtNcg2ZyiWMRkIoBEeubxs77XwVFWk8CSilvbV?=
 =?us-ascii?Q?zmg86RHkKWOAYA64SqVzzF6ZaKRkNAQuQ/jLJWgCLEB+t0i82++n8MVMOjUw?=
 =?us-ascii?Q?1Y8JjQPpgjESfzsTU8V+RkJ5x14G7Q9JqBLCJzDucpRYkgIJFXk1gaMNu/eS?=
 =?us-ascii?Q?UFSBw9u/fDFghvdZatVv6d4zIgMRrdsQ3zUtMolCMZqJQDx7ophETV45ydW/?=
 =?us-ascii?Q?WnygXFXRrKRgJTOD4rMQYyOcmYs7gD/w0Ubc23XEC1hSKdsvn3S6DlUsCfT3?=
 =?us-ascii?Q?JYQbV4bjyQRuUc8Nf9RJakTZPrVdQ1tdBFLiAy0WLpLbDkvmF4cHz8NxQ68d?=
 =?us-ascii?Q?CtfpmdP7LdcconeMaH66RHilEbURphEIagD1eKkVW2PqJuG3c/360BZSOH1b?=
 =?us-ascii?Q?J4/iXNu5jCXtFWs2eW7Mb+Z3dQP80ux7DQZL6028kfotJlZT1RosEqIx9ixe?=
 =?us-ascii?Q?Dm/ZB5KMYJO68iAZY7Ik3CMZqYjdI3l53VmYqaBNssgi5hTWXI+Xwc2D7Le1?=
 =?us-ascii?Q?Zrln2w38Myv1Hh3IY96ysKx0IT1j5D37peQqxlQpEnEvm/Nb6Z4ve28r7f/n?=
 =?us-ascii?Q?b1u3Q70mN1MY3SHdOlTywbxgg3OzS3vZ0bYvgIbdi1Lb2VB/4T84G0wd2h6P?=
 =?us-ascii?Q?KFW4W4y070ZjGprLmz7F9S6wNDYV8mNwsnRJf+HsVUItTiwhnhnClwC4viFS?=
 =?us-ascii?Q?oqCprQICzcOLTLk5prpQHZ4cvhidFo2J0P3tb7T9pV0rZoOgtmvHfma0+u+k?=
 =?us-ascii?Q?BUSbg3McQ9IMhXFgWEC9NUEc8CCSdxQseDsySOzk4L22AeVXUTeR8PrbRjsM?=
 =?us-ascii?Q?2Z7JDe5IBD3+SKisge92PIvoy5BM8EU6nCe8GYycVaHboo/Vb3f2EDOQaucc?=
 =?us-ascii?Q?X9hDXY9Csvk0Q9lnHsEjkJhCoXU4G7cGbmSg169i2MgPwD8rM6PJiQILpRQx?=
 =?us-ascii?Q?Q4B0CLWQ2HqJ4kTEGRGixX6a7/wu+goy+DnfptQRkExyW124yBViAksLaWGs?=
 =?us-ascii?Q?ijGLPVNoj00x9LU4otXSpDXAhDgYBxYCxVqmWZ0wkUWVv+vJeuZeuMsBtB7f?=
 =?us-ascii?Q?SmR+d4AcqY/8ts/DunIcHOLiF6/a6jAG+Wjt+VH9jKfdwIsUT2VL03XlsomP?=
 =?us-ascii?Q?Np5Bz0+O0Qq/1lxLS7q73F9JkH/OINDuqK+L13/t6L9aGgs9taLXGzwnc/q6?=
 =?us-ascii?Q?XQPAWuGw1T1Z4cozi/NAVcujM2F9rSf4hRCB2gQUpNVUxFcBdriufl5zUXvq?=
 =?us-ascii?Q?vJL8bYa9M9R4TKRl3PU1QGD6SsWjiRTBSPAJ0v6X8Pu7EBpCj9/DQSQNxePd?=
 =?us-ascii?Q?mh8qTrL62vB0BDlBSEmO7xDIpoH5JIaW8wrAkF0nCBm7AsxNT5RTxtuJjXeC?=
 =?us-ascii?Q?plIIF8IKh7o+KVjD0u+Rx8yOKc4=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc89adb-9806-4fc9-1046-08d9e1b37a9c
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 16:38:42.3173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kq3bSCqeUE4mmgCbcpsJ58+0Jxc6GTRbY+EihBkaRD0WRW517Z13Yofri/D81odEubMfwEvvRsKmoDsOTQKY2y2Rjqw59NK/6vNfcdSY3Oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: QB1PR01MB2531
X-Proofpoint-GUID: l5gSoCq5WDD1doBOrlsrYsDIft9lkC8R
X-Proofpoint-ORIG-GUID: l5gSoCq5WDD1doBOrlsrYsDIft9lkC8R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=972 malwarescore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270100
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
 drivers/net/ethernet/cadence/macb.h      |  4 ++
 drivers/net/ethernet/cadence/macb_main.c | 63 ++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9ddbee7de72b..f0a7d8396a4a 100644
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
+	struct phy		*sgmii_phy;	/* for ZynqMP SGMII mode */
+
 #ifdef MACB_EXT_DESC
 	uint8_t hw_dma_cap;
 #endif
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a363da928e8b..1ce20bf52f72 100644
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
@@ -2739,10 +2741,14 @@ static int macb_open(struct net_device *dev)
 
 	macb_init_hw(bp);
 
-	err = macb_phylink_connect(bp);
+	err = phy_power_on(bp->sgmii_phy);
 	if (err)
 		goto reset_hw;
 
+	err = macb_phylink_connect(bp);
+	if (err)
+		goto phy_off;
+
 	netif_tx_start_all_queues(dev);
 
 	if (bp->ptp_info)
@@ -2750,6 +2756,9 @@ static int macb_open(struct net_device *dev)
 
 	return 0;
 
+phy_off:
+	phy_power_off(bp->sgmii_phy);
+
 reset_hw:
 	macb_reset_hw(bp);
 	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
@@ -2775,6 +2784,8 @@ static int macb_close(struct net_device *dev)
 	phylink_stop(bp->phylink);
 	phylink_disconnect_phy(bp->phylink);
 
+	phy_power_off(bp->sgmii_phy);
+
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
 	netif_carrier_off(dev);
@@ -4544,13 +4555,55 @@ static const struct macb_config np4_config = {
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
+		phy_exit(bp->sgmii_phy);
+		return ret;
+	}
+
+	ret = macb_init(pdev);
+	if (ret)
+		phy_exit(bp->sgmii_phy);
+
+	return ret;
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
@@ -4767,7 +4820,7 @@ static int macb_probe(struct platform_device *pdev)
 
 	err = macb_mii_init(bp);
 	if (err)
-		goto err_out_free_netdev;
+		goto err_out_phy_exit;
 
 	netif_carrier_off(dev);
 
@@ -4792,6 +4845,9 @@ static int macb_probe(struct platform_device *pdev)
 	mdiobus_unregister(bp->mii_bus);
 	mdiobus_free(bp->mii_bus);
 
+err_out_phy_exit:
+	phy_exit(bp->sgmii_phy);
+
 err_out_free_netdev:
 	free_netdev(dev);
 
@@ -4813,6 +4869,7 @@ static int macb_remove(struct platform_device *pdev)
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		phy_exit(bp->sgmii_phy);
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
-- 
2.31.1

