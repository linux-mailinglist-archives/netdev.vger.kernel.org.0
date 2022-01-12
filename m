Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E004148CA10
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355912AbiALRpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:45:17 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:35439 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355884AbiALRpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:45:08 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6j93020242;
        Wed, 12 Jan 2022 12:44:43 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg598-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:44:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMc2Nzg1yurs3SU9DERKIHdlVKQoDHKaQhQ9zdfH56IXnrXxfWVCkjUVLXZlqTmRsUjgYPl6gol+do1zlqtT8pcwh6y957N7tJeEj79DUk4jZmZ8i6BKG9ECyOUBoBAh6gZ+3XRw9Vy0VCJsNbSLaMebvS+vJWF5ROua8zyj/IkquYbs4jDgdOFrBQe/I1Li5GGprvfWze5zGYFRbEIr5AOAP/jEAhO45JkiRzATkaFrw1/FzyElu7q5Mj5OQ8D0mmdwsN3rB+d+HaPpY6+MeXxFublFbta5Srzq1asj5reC4K6dq14xXyqYwUE8eMD5JsUSJd7MXtW///tZ77ME0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=seG5I/bcQo/fgxkf7Kl/CAe9gc2d0pwCufN/U9tferM=;
 b=MJRCPy9c/5zfT5aO7pkGVs/kHDxTvRz1hTM1gUN9QFPdPas3KEuktMfWwmvXF5FNfbM4uAScUy9TLLTyq0Yo3+XpuNdCaTsOoL5k4V8NeS2iEdNiKdltZE0p36Mav4NJQq9y/ygIh8rM0BX8HN3ECGYz4R7i9GZWooMRCuAB/j0SMF77NDOq1/xQRCznkjYWz+8jK69X17p9V0UiACvGjK13JuD62uMBNDw1cm0RsWw5lE/Fz9uYzoSTYhHLkoXahMv9Gs9zIdg0lbP5dsGf1u/dOnX0OoGCwKVEaf4PCJJIxs8DYFiLsWOEpYiGCLaWVPSx+oxBe+XFV25ApWxxng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seG5I/bcQo/fgxkf7Kl/CAe9gc2d0pwCufN/U9tferM=;
 b=NLCI0wTNAQetJsJBPNQ2uKA/9MZWXSF8Ku+TYAiSL4ctJftAe5AjDHbW81MAyx3uztUZj6Wm0RqdcZR50SWUDaPx6UspZNtUoYWRymeJT0ByUuJpK3Kx6qDCS/lbQSORtfDgA2OJ0RLXW8N4DXoV/ALLpZSzcvvR4nnxkgyZJN8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Wed, 12 Jan
 2022 17:44:42 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:44:42 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 1/3] net: phy: at803x: move page selection fix to config_init
Date:   Wed, 12 Jan 2022 11:44:16 -0600
Message-Id: <20220112174418.873691-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112174418.873691-1-robert.hancock@calian.com>
References: <20220112174418.873691-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:610:4f::39) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59fbaafd-3fea-42c5-3394-08d9d5f3369f
X-MS-TrafficTypeDiagnostic: YTXPR0101MB1215:EE_
X-Microsoft-Antispam-PRVS: <YTXPR0101MB12159C5354C9A7AFC8A698B4EC529@YTXPR0101MB1215.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qkHnNRkpswtbJH9yuALnlYeffKc2ALksSEe6bRIE0OfCQ00/RUrvsF7fGa3md4zxP01Gn5v6X0oLeK81NcaC/IInxToi70Zhizmx3OPLACjLH8anf4LRHkQ+wq1oVPPw6KUWUnysek3anX3O3mHgEW9LKYn/5qKjVq6zHnskJQi8IxGQEMwEblD0LZO0GHtm3kO8QAqrFJ4plJ8WipOAEr543J1woENoN4IcsQQX4CFP/Cln9+bk3mq1uBRSf4U8EKv+lyCdtMh4WQhaxwtyBxNid3D4iWL0auz9NuB/jEO4Q8BgnFL4yYnafcTHsIao/UHMZMjSFZ4lG/bmiyfZ5CMrifr+nyt0RF9OkCHf7cfuYwuk2NJrTCztI7FgNLIJMIhadsvHVNSlm/BuX3jIqEPDzE9io4AR0ZiSaYVmODkvTEHfgFH+B4ayBdPPx4St/u+5KXwDHvVAc6rDnzNlbmrVA48cAbO/cj+PdSBklZWMgErRco6dfVAIpbsbd8EdtQqLbuUnI6L9SU9L99ItDDIDSoKPViwuklrq8nhBEDYIIb7CZnz4TDGy5oxXYmgk5WbkSriGKS4iKjvEZ9T4G5pgFTBkcJKkgqfO1b4TZqVF94zHn2WbV3cKRRyTCcEmeYcMSld4LWSLGSQWafz05MGOYbLP/c8N5rNCrh5W5YdW66AaS5vVisSaamGqVi47x7u5Xv5IYVKTT/sw2crK2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(107886003)(66476007)(6486002)(26005)(5660300002)(8936002)(2906002)(83380400001)(6666004)(508600001)(66556008)(186003)(1076003)(66946007)(6916009)(2616005)(316002)(38350700002)(6512007)(38100700002)(4326008)(52116002)(44832011)(6506007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RgfZC9UT1OKoZjEQQeghMEFJ4QvquYVxt59Qd6JCtA850bV2Z9D9PZ5Ta3vZ?=
 =?us-ascii?Q?jXLneHR2uB/KAAlzZ0ZrQhzAKCEC7eSHck6l5Q/2SDaPpvvXi3exK6mM5P6K?=
 =?us-ascii?Q?GZ5Hi7B1Hb8kug9Kq3OsSpeocVqrhTkJR84Bd3cvPmy8thtRwelzmDG5EiRF?=
 =?us-ascii?Q?6thdy6nmVjq4c7163IyUUrteilIDhW3cwO3jqPjvS2hIXlN/lMiw0xQXONQF?=
 =?us-ascii?Q?J/w69mZ6F2JSpC7NZKORWuU2oBUnID8YWAPKz0luiniIT72i1NgeLv1tMxaB?=
 =?us-ascii?Q?ocpKHWgzYxOLoveQpySjPH+RQ5jojIqFpdMRDEKW3YyUE9KbStZqt4p9UXkC?=
 =?us-ascii?Q?UD/jIt4XAAwnxJRhBqs4rmbDzTGwGaNVeIIv7rx8dhVmquu0TyoJg2s8M2Jf?=
 =?us-ascii?Q?apCdLEWOllfQabLAHvzqRCq7cmsd+sZ4bGDoR7TaVMF4yNFXj1eRhCK9m7s0?=
 =?us-ascii?Q?obgl+ykRSasUjOoeF4fA2qEtuXvOqqE31jAvZJKQIDQV2cRkjNP3dLce3BCO?=
 =?us-ascii?Q?HTgz9DdwP/hcx2qYmW1Q9lQnpSqTrg6Q0S2zd21wvvK8hNgCjip1YuWokTpD?=
 =?us-ascii?Q?x+b0qaZ7BOoZg0qWpYskQ9+xOQEfvRSBmtSXHA7MdehVszuCtkuRwvQOMKw4?=
 =?us-ascii?Q?dB4DqP6XPWT6G5QSZQ5XfmIL++T4U7gfms8hBcv4M3U/dEvzpym/q0ATHvQ3?=
 =?us-ascii?Q?a+zZJUNrULnqQMESqYw3W/5dhnVBnvBmjbsuHFEOBatMPpGjMws/zBho5Iqx?=
 =?us-ascii?Q?86UDyBS2+5W9JjKYPKt5KyaMHcHIVsKnZWff7AO0RR1LJoiD/tqZ0JqBfLl4?=
 =?us-ascii?Q?Fxndz2sWFaUs3KQvRcQsuxiEMgYMASzJ4bHMvzN3sn6cUrSC0HlKfQYnjDb+?=
 =?us-ascii?Q?uO2Q1iFzsg/nDCEbNjpuKyFuOfT50wWP/H1eWPlUlC2GZ56fi+5Q6Xhufg/k?=
 =?us-ascii?Q?HiWwHB/QxsWHmq318jOxl0A1oL53WaB4JkcaQQmgNAFztvqOUVHsDqSBvCVv?=
 =?us-ascii?Q?zWIF6H9m3NHStBbeHztvajALLFE9ERd+41vZlTdk/kiZSaat3ZTrFi/GrRUw?=
 =?us-ascii?Q?94EgJlOpL5ZyWB9wE3wdFHxGU/ntqEBDiDDOVvZclonhvRA8tEqPQE/PyUOG?=
 =?us-ascii?Q?vXczbiCjDkrHfw/4Klwxq6ZlpcbfV3+xtrz/wwcA3Bb3mek82zoN5a/6WJGv?=
 =?us-ascii?Q?LijOcfGjqNkzfTRojYCCr8Plm/9uP++Xo4t15PyZGTULKF4T311t9qKFK1gZ?=
 =?us-ascii?Q?Md2dSkX2574F9d92XEbjj5ARke9um4YF/OBqPF2SFn8PzUGup7fX8uAdjYF7?=
 =?us-ascii?Q?TwSHGyQFwcZwpmz1hSejYM//dHwXe6ZjyKcd4C42DY9QbbHrchnGKhHSL/To?=
 =?us-ascii?Q?YCgEkachtbCTv3Er0B5HOrACyy4Lr/CgGkyX8BCN7bEHA+Hu49YP3kShq+QL?=
 =?us-ascii?Q?0Fbnvi9H+iCM6T8NsVuoJO5Ud/fk0DDnJq52odjBBglbbl0xolxtrpxgKvkL?=
 =?us-ascii?Q?EMyc4vuI4qcIpkvMwdkTeNFlbZHxxhPnL8bDzpVxIfdIA1OkFblt8YTiWmsM?=
 =?us-ascii?Q?t21B57/+RliNG6vJl5HWunC1AMXkSqbyuPAlL8itsRyv9ibgIKVCJ0/QFCKr?=
 =?us-ascii?Q?3fdfD1mp3auTxZJ9B/IFauDSDKbh8c7GhDia3ez4axx4dG8OOe4h8L2nZJDE?=
 =?us-ascii?Q?na8d6uE0CgRMsD/7NCuvw3cVniU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59fbaafd-3fea-42c5-3394-08d9d5f3369f
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:44:42.0915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TB9m6vUwbNonkrGfsS5R+SHhervNkSzZP/gIc+q/rrDntZ3qjZi6NXuPoY8ecjcLn5kvmLUWRNbk4kjtDsGNSeQPTEWq3PdNNGlkA8xqnHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1215
X-Proofpoint-GUID: XKHxiMml7lTLOLxh9FLO9lH5gElinf9s
X-Proofpoint-ORIG-GUID: XKHxiMml7lTLOLxh9FLO9lH5gElinf9s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fix to select the copper page on AR8031 was being done in the probe
function rather than config_init, so it would not be redone after resume
from suspend. Move this to config_init so it is always redone when
needed.

Fixes: c329e5afb42f ("net: phy: at803x: select correct page on config init")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index dae95d9a07e8..3d7eeb572be8 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -784,25 +784,7 @@ static int at803x_probe(struct phy_device *phydev)
 			return ret;
 	}
 
-	/* Some bootloaders leave the fiber page selected.
-	 * Switch to the copper page, as otherwise we read
-	 * the PHY capabilities from the fiber side.
-	 */
-	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
-		phy_lock_mdio_bus(phydev);
-		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
-		phy_unlock_mdio_bus(phydev);
-		if (ret)
-			goto err;
-	}
-
 	return 0;
-
-err:
-	if (priv->vddio)
-		regulator_disable(priv->vddio);
-
-	return ret;
 }
 
 static void at803x_remove(struct phy_device *phydev)
@@ -912,6 +894,22 @@ static int at803x_config_init(struct phy_device *phydev)
 {
 	int ret;
 
+	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
+		/* Some bootloaders leave the fiber page selected.
+		 * Switch to the copper page, as otherwise we read
+		 * the PHY capabilities from the fiber side.
+		 */
+		phy_lock_mdio_bus(phydev);
+		ret = at803x_write_page(phydev, AT803X_PAGE_COPPER);
+		phy_unlock_mdio_bus(phydev);
+		if (ret)
+			return ret;
+
+		ret = at8031_pll_config(phydev);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* The RX and TX delay default is:
 	 *   after HW reset: RX delay enabled and TX delay disabled
 	 *   after SW reset: RX delay enabled, while TX delay retains the
@@ -941,12 +939,6 @@ static int at803x_config_init(struct phy_device *phydev)
 	if (ret < 0)
 		return ret;
 
-	if (phydev->drv->phy_id == ATH8031_PHY_ID) {
-		ret = at8031_pll_config(phydev);
-		if (ret < 0)
-			return ret;
-	}
-
 	/* Ar803x extended next page bit is enabled by default. Cisco
 	 * multigig switches read this bit and attempt to negotiate 10Gbps
 	 * rates even if the next page bit is disabled. This is incorrect
-- 
2.31.1

