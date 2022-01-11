Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE47648B9B6
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245336AbiAKVez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:34:55 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:33144 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245513AbiAKVem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:34:42 -0500
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 16:34:17 EST
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BBWJUj022122;
        Tue, 11 Jan 2022 16:14:30 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awod8VKzLpNjWw6+RzbdJaYnhU3gSnsWPMwhzy+kmgRUHMl9bY1D5RG1/rjDx1AceZ+c2R8EpfORo8Q//Y1HJMALpm9Q+0wZy6dh7kNcF4+uG/2xPmTQAcoTK/ydBhqA1IUnT2UQQ36//9pmj/SSDB7hVRPpcqU4o0a9svfdmwMqnbPezzMYw0ERAHxf7mbFnqkUGlJPHfyWCvFyrYVeIXnB0YoK/IZ5XDpfn1/ygV0cgo8F7BfWUEZtUdPXKmAMXE+OIiCM+b+8IMWypl+12gmdBQH/YTdMAt/+XVQzRIcyc4222ajwP91ZEgyAcKiSGELw+27WmcM7nP8tusTRYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJto+NzWYyoZ35AolrnLB2l386zWUK/Zg2JmThe5ow4=;
 b=H2qH4hAQFUqjnVhOyy8DLw1K+dDrAdmdRSJ8z020WggsEGBL6wJ8c0KtKErCY7ZW6K+SV3KnMpSendhlXRia6OCOy8KXPBAbBgwawydvEc7/2JvJ5lMsKT3FcPbqBLFYLSwUmNU2J/UFdIXQAF+Zsca+gmifMzjZQL9VwHRs6f+dG/YdgG3sxB1tLz7G6OJewo9ZwBXiwosMxBKgvpQOwqr33q4l6ofViy8qctlgWE5PECUqokxvzh1Vi3eS0JFKrN0PbvUfRfVFj/YS2gdCs7+7RHPAuNdWYxFPQr7rXKp9EIdwpvUQEwLunFLtrzVnxLXxymRtxCOoZG82/ekY4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJto+NzWYyoZ35AolrnLB2l386zWUK/Zg2JmThe5ow4=;
 b=aN2NNluHN6q/MteQVAegU/tiVARZfinkJX+rl24ZaJI4qI/IXS2g4vfDJCJ1ffuA6puxfG/eRfSOTKScpUsff2v9X09SwryRl+pL9lfsR8zQvy6BpBvRCGUy5ZrylJK23JOvcgb1/9FzdQah3B3ML2IMhV318MouDFF0VIt0yPc=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:27 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:27 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 1/7] net: axienet: Reset core before accessing MAC and wait for core ready
Date:   Tue, 11 Jan 2022 15:13:52 -0600
Message-Id: <20220111211358.2699350-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111211358.2699350-1-robert.hancock@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:610:5b::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7702423-cb14-49d8-7bbc-08d9d54759e1
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB921815E352ABED692E3EF438EC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4I3rKDDc1reH/F6rgYF46q93Kkzz3zHM3p771wo+881ZBKPs/Yu/bXHllzSFP4m47TPxl3v/GW8//KhhyoVuphgLddnrItQf3zep45/6A+ra64c4SMeT94vquNFueoRgYTMu4WC0NnrVbocL/OzHfP5aVs/lZLTDzvyoD5JfHJ5NpVLGXuhaa+CEvTaHH76vVvFFM32bPB5b2+4eKes3VVucpb1vMVtMAd9l7nay+ffsWZhKl8BUgZ2ykaaQRxboAm06L2uxAsAxvJK3YQs7fwhMbMCC+ABEZiQ8LydsEckjB7SU584Hzhm4Npg6esLlnLspuaigS+gOr6LJlWHMxJ9eVZFgbT9Dc6S1HDncOvkfXGKJFir4op1eDOttJKFgDR4b7fAChBBKhcE11zgK3DtMjpzIUHjpyRJ6VudJ6nqJzGNVvWHJGNhY6oL7gHIddKq6mOWJLiyBxDm7i5Cv2R2BrkZFuQSwa18qJn/AKHDrdmbT5R5J0ojo6FKr+njMjfYabk4xznsYGMDXuBvuDDBcPIup/TXmnnpDJ6jFDPTv1SFiW+V0N2btxMFqKJH539SOlK5bbXs/1Gt3o8SVQCJDxrP66pJqeX1ZI+GxVg+ItZzVJblvHoyAS9Z4vWsEH1YdiLOheP27/Y/NtJoU5byr/cQg/8FzJiO1yYxy6FPGH606s4NtPi+Lvbf9QjDo85fiXc9nK+RES/MqKc7Lqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4F8VZOYIqzhpl6nqnbI6ZCkG7HewVGjEYO37tKqgsd1+alhsNQ38BGRWkxjn?=
 =?us-ascii?Q?JjSq8kbZWgupdwvYeEdakyqvi5SBXCsOsI0hzBO8eSUPzhii9EqH4Pv1MP2e?=
 =?us-ascii?Q?LkxVSWTC8+MPa/YVWcQwhzyJ0eznT/CUxFlscQftGzY67X7wJklyZ51TcWP7?=
 =?us-ascii?Q?AsvCiOhRgfzoXBpc+O8vDOJuG4X0Dit2RJzx5g+S2JroLUoG8o4bGtT37q9I?=
 =?us-ascii?Q?UVxr+i0C9WzEYaGriLMmYpWJDob1eLk6AtzlAs0MMkWHSgYns3IUs8eKISrf?=
 =?us-ascii?Q?LmYvQ018lha3u86huE5RK0kV9BDRHQz7vUVRVEm3dKpVUvyPSji1bNSVbbf1?=
 =?us-ascii?Q?LHQytPKa6Zhgoy4UztRmOyeHyyyzh70N7XGj7rbULFFc/rCYEEAVj9qSbrjU?=
 =?us-ascii?Q?wuTKrY4s7ZR6YO7uV5PpNhRO27PG9tcOaYzI3U6/ohxXP7i72Nkmm3Hb4XC+?=
 =?us-ascii?Q?adjkHgbg6PM/uLvVI98uVXHDoqEgugJr8bBJTSplIQn5hl7rrPxWW+6rE0E4?=
 =?us-ascii?Q?NCabsaTCSgdNtGAkixQYY2KBTBYUNiWBoRqNF3TD30eOl2sILy4/EW8CTVQ+?=
 =?us-ascii?Q?76HOt14VY6pchI8RsJ2tXvo7vgUqEI4BJfvPAXLK9zfyVgV1o4TCny8hI1fD?=
 =?us-ascii?Q?eGw/LCObHRAkLyqzubQT35fbK6jlq6hrk0VGU6jpdrTmVermakDuLnwtFEGe?=
 =?us-ascii?Q?JL30iH5aZhBQYmoHQIqL1ZhHYv1L+Sz7KS9q0cl4Er5FNU1vidRnicXj+Cx+?=
 =?us-ascii?Q?7t8tu1C2AgOU9OUh9Wo1i/JsIbSUUoLJ+cHkXcF6qiDEh1xCTN+Q4lwuSZYp?=
 =?us-ascii?Q?aocGwVNPo81CP+5d7T2oqOxS/BefJo9BoQzSy/HJRvuS0LDPU3nxzU0pBwAj?=
 =?us-ascii?Q?BDP4cJieaCPe/WYeSV6/a6VEfsM/E/oRlt96vywO/z8OQGRoFfbJwGTnD2Yw?=
 =?us-ascii?Q?GgJ4EvFYh01BZ6CJUBudVx/xJg+8w/X14MvXuPS/U5qvFM0LrIcytxrCW/fl?=
 =?us-ascii?Q?iKhR/vA+sl9Kl1UigLP5+jIaibxPk41BmdUGuEnhFEv8v/A/fRpE21Tahp0a?=
 =?us-ascii?Q?Fiw1rMyddWVtn8oEoBjbKdZCi1+worjB3TajPKGrDOhTZPTiLVzOgLRPPivL?=
 =?us-ascii?Q?afFVlScYPzSq3RrVHAMPmxMcwF6v6xCtHcv8vnL70ONm5FAP3Mw23lrbqJiK?=
 =?us-ascii?Q?TAy56dqlNozRop8x3LrM6/eyqVjBmNAHySA0xzxNN+l54nqhkyJ6PMbJvrOx?=
 =?us-ascii?Q?SgzP8jpq9M8n1adbSNCGEWUnJKVeCmSG36HO7UX4MXCxHyMzwqvKIpEJ+jaW?=
 =?us-ascii?Q?h5GcPxMSd+INlbLZdWncOHtAaYAia7QMzksnH64SGx3ekluTYqkD7II+iCwn?=
 =?us-ascii?Q?aswEFfKT1irQmScJ6ldZhyI0JDv2Nf/1z8MDkXQwMLK0P73npRP64Lwz1JMA?=
 =?us-ascii?Q?B36UTddPYOKcoxvk/wNpwSuX/2aIbGpPWBy3GhLev/XP/BRGCaILEzzlTAns?=
 =?us-ascii?Q?pwXlEizN1FXPt4nkEpN2gzMO7qNtdemqAqiV7H/Mzd0/RxRf48VaPTG3uFRL?=
 =?us-ascii?Q?DmjcakriVBW+d9uFG3UPW7Jue4EkHXLh2JWu7yg6VOD6Kf7xvedqTWZ8Bak/?=
 =?us-ascii?Q?bQfVkD8Owc7uDbmZJgnRhJ1BhSrqWVCL8X7QtlR1TZNBl0R+/lcH/+IL9C8P?=
 =?us-ascii?Q?ut4LQQZs3Bfa5s7AHnFsrlrOQes=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7702423-cb14-49d8-7bbc-08d9d54759e1
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:27.8541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yppwRfdaj+9RvWw6abXienSW8CgSn66orp8/Rtqi1CFX+z86UIBpiqRcnHvKJGuusnzikPdvEB7710TsGmEKmtkdcPhOSehoE9ZGgI99NGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: 3Z1JTWY0q3MHF3R9W_T-S1Du7yksMmCd
X-Proofpoint-GUID: 3Z1JTWY0q3MHF3R9W_T-S1Du7yksMmCd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases where the Xilinx Ethernet core was used in 1000Base-X or
SGMII modes, which use the internal PCS/PMA PHY, and the MGT
transceiver clock source for the PCS was not running at the time the
FPGA logic was loaded, the core would come up in a state where the
PCS could not be found on the MDIO bus. To fix this, the Ethernet core
(including the PCS) should be reset after enabling the clocks, prior to
attempting to access the PCS using of_mdio_find_device.

Also, when resetting the device, wait for the PhyRstCmplt bit to be set
in the interrupt status register before continuing initialization, to
ensure that the core is actually ready. The MgtRdy bit could also be
waited for, but unfortunately when using 7-series devices, the bit does
not appear to work as documented (it seems to behave as some sort of
link state indication and not just an indication the transceiver is
ready) so it can't really be relied on.

Fixes: 3e08fd4a8298 (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 90144ac7aee8..f4ae035bed35 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -496,7 +496,8 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 
 static int __axienet_device_reset(struct axienet_local *lp)
 {
-	u32 timeout;
+	u32 value;
+	int ret;
 
 	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
 	 * process of Axi DMA takes a while to complete as all pending
@@ -506,15 +507,23 @@ static int __axienet_device_reset(struct axienet_local *lp)
 	 * they both reset the entire DMA core, so only one needs to be used.
 	 */
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, XAXIDMA_CR_RESET_MASK);
-	timeout = DELAY_OF_ONE_MILLISEC;
-	while (axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET) &
-				XAXIDMA_CR_RESET_MASK) {
-		udelay(1);
-		if (--timeout == 0) {
-			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
-				   __func__);
-			return -ETIMEDOUT;
-		}
+	ret = read_poll_timeout(axienet_dma_in32, value,
+				!(value & XAXIDMA_CR_RESET_MASK),
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAXIDMA_TX_CR_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: DMA reset timeout!\n", __func__);
+		return ret;
+	}
+
+	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
+	ret = read_poll_timeout(axienet_ior, value,
+				value & XAE_INT_PHYRSTCMPLT_MASK,
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAE_IS_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
+		return ret;
 	}
 
 	return 0;
@@ -2046,6 +2055,11 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
 
+	/* Reset core now that clocks are enabled, prior to accessing MDIO */
+	ret = __axienet_device_reset(lp);
+	if (ret)
+		goto cleanup_clk;
+
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
 		ret = axienet_mdio_setup(lp);
-- 
2.31.1

