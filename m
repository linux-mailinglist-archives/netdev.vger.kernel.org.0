Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12F5649B968
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586900AbiAYQ5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:57:21 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:11580 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235103AbiAYQzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:55:06 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PBNFCI021579;
        Tue, 25 Jan 2022 11:54:37 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsvtr0xq1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 11:54:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CtLTQp1gmAUCyVGwPxw3gpW6CRYR9k1pVnTqWQtsHkM+4TSKcWqS9ralQXlieW0W1EjRibmdS4h3aF01D30wGrSxWJc97P89otuq3fcVGdEYDQ2OIMafNg/6YKNtO71u6hKyPYBEPe70m06MGroxKxcP4oC1tzPiYX6+nU0+6+1BTk4GVsT7eIivXtaXjQQU/zyofo6VyKNrw93JipfYvmswtiAOV0Yw1CcEtT5mIVGW4dc4LlR/jPaVpMrrBjcIqHyYyB9hVLQuHA/4eKYKmy1e8uJdHcS4c3nGgZps9KDguX7D6GHOVyGnNpa+tH46LIHw+mMVfntoviS61qKrig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZpCsyTwf3EyAwoM6R+82m4L71YGEiuG7z4Cz/5WX+Q=;
 b=HHwm0i2caQSxzqvJJU3VCN0kfYX0N2PkDlmQofJDTazlQH2veBCOJYlAqCLOhDigHscf3/YNyF3cHljxQ78gH+teH1AK+105ifP1p24/rMOI+S2CMPZPa6/RN+oYwi/hADM1lWwHJ9mhxfjf0VPyf27a3xNQAhBYLB6bSMjKb5sD6Ig5eUxfyN3Cvn2bevG248Sj1rm3g2rtk/rsU075SQMk9tEgk1R61o4YCnilYGXWvbAhsGwpscoyNjWZ5GczQ3241pUKaT0LX0apAvI0vLPwVoAXxZ93cydF+UdSDLa+o/5CIbURzFfnKTw93CoNFrIAj6OlRGhft7njHx2Qew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZpCsyTwf3EyAwoM6R+82m4L71YGEiuG7z4Cz/5WX+Q=;
 b=yZRQDVJyb4/SBHgz3R/zWsUxEJThDHX3fajb/i0Jyhiw8OE/tl+AyOB3N34uvbBbQA0Iyf8tUwnYimzSZ5nGACSQiWH64eWpGgckHquvhl7qtL1z59XVutHxKnqnlUg910OhaNS4M9PsyyvW2idDAOuN/yQm5ir8nEVlviK0/6A=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB6124.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 16:54:36 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 16:54:36 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 1/3] net: phy: at803x: move page selection fix to config_init
Date:   Tue, 25 Jan 2022 10:54:08 -0600
Message-Id: <20220125165410.252903-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125165410.252903-1-robert.hancock@calian.com>
References: <20220125165410.252903-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:303:b8::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9c4dcb0-a3a9-4b31-ad82-08d9e0235e58
X-MS-TrafficTypeDiagnostic: YQXPR01MB6124:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB61240E0DE7C61557001D32DCEC5F9@YQXPR01MB6124.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O96fTNpx8DxS408VfDVP1dUbUQBXKj76jdpi1utQwJR540HfEnCuaFNI8n1jPwMQBv1PMbtY2cpqSR/dTQfHmDPa8fVcCOKSOwUw28Ga01Xvup9v3cSWmdYnISXq2FUOrMINk2F/LXhH7OCwje3D98D/g0qdco0gkntzo7wDtvSMdwpApUds+JmWKPU2BLljzgiFsHTq1yvQ1K4G1fYxeP/7ttC1RsLiKt/ItlxBg4Y8PzEc8fFcww2bXG+2VYvtxb93h05SQ2aET17y8jWiyugSIVTBdn/YTyyMfTv9DTpS6RFDhuZuN/LXO2K4EOZRfHNxnZ2QepSzx4/mdX9nPMJSpOgMPxpsOFV2Og4nBksWT2CVqXqvFrEf+QmjVIEf1ZU3CFGK6N82geb3Zn9MKsQVK5Pk7Y3eKjiiVoM5lPL+dJ4pzDMI0ScPIN+1GOVpJgTFOOMpS7ygppmlFkJ1+ZNGMKT4zYc5zP005USAeKQc/C+xrdAHNOFzcy6ogZBIfeJiNs+ZyNms1hhfd3rcGRTpf7hQ7XPBNk7SanLVTm12rUYR0LH0YTaXqsFgzY7lm4aAxm5gfAyOB0OEOm6m1JRMXcD3BM7xjPaDKu7XDyPPQSBV9W79LLyqLpp+kPOk4PObdEwDqZc+uuw6csdo8ZDz2FgmSsZMj24vNLNteCZURyvb1EV7vyG37q5pvk6Foxm99/3hpAaxWTMTVFlO2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(26005)(107886003)(8676002)(86362001)(508600001)(6916009)(5660300002)(44832011)(186003)(4326008)(52116002)(6506007)(2616005)(83380400001)(38350700002)(38100700002)(36756003)(6666004)(66946007)(6486002)(66476007)(1076003)(8936002)(66556008)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HPTZ2JuOM7AfFINeBwvc3swkruw4ht52QvjA6dhmlEG1YyLxqBo5EZApkhhv?=
 =?us-ascii?Q?oHMt8NwmYNAm7eYqI94qo/9tNt6HkV25ZlLXxAvs3zyu+dUzGBJ+C4nA9oVJ?=
 =?us-ascii?Q?DFo1zCr2jf3bO4Hh4CU6DOYzz1QLpNieI0CABe4MehoCts+gkQ8JkhR+l4YW?=
 =?us-ascii?Q?CWdA6f2T0sz21GXpyHhNry9pmjSsRYqy8K6/5FYH1Gucl42h2KJmcIrn9bH3?=
 =?us-ascii?Q?ueVkqYyJ+MMl9C/Z/Okj8TzzW8rayQehwxr8bj1hI+2dZe+KY1/4eT1bFq1j?=
 =?us-ascii?Q?lklBTxpej+GgSCUZt86URUQ2oJJ8Y/pVoOT2js4aLFvcqT+18+qmqa3re9V/?=
 =?us-ascii?Q?aE3uVsstyucOA32gRWncS7pcVXD/wnTTK83TQT/nD3/F+FXWM+q3jpT+fvQY?=
 =?us-ascii?Q?UCsINCxiOi1DxE62YV0CqZFWYZw7P05VbcI/4f2xj/5WwS+VYznCCFdEC2HI?=
 =?us-ascii?Q?XYIzfw9yTxm/UpvlUCZ4ugzH3jrTVxBBhc87jimoeKr6Mm/OrsFAYWmF/W++?=
 =?us-ascii?Q?PAbX5inWgblLhbvTp6rwnJUyZ0yY5YmkCyhKpGTyz0rIfFfQyVByTjIyNYiF?=
 =?us-ascii?Q?nucL1FPAdDMv2b9UV1sDx7is4pGHhd8wvs5hkv0bNss9JfMxM2F07fYonIa/?=
 =?us-ascii?Q?GGPM690DOi/tDioPBTPwTr+HRE8Cr9Xe6hqdBD0pQiwwlFR96wi0VApUOWzT?=
 =?us-ascii?Q?fWTESobVHc3OPJRhU/IlF0QIdMn4Rm/sT3H2gCPhne9bcpfase/mr4JKQEmT?=
 =?us-ascii?Q?FxvQ0nFYKKuR0UpJ6jhcFEZcTNdRmpRXE04IqVFPJYtbF7O6GYOjGFG21ZXv?=
 =?us-ascii?Q?uMhJcfzEZJSZsuepWKn9UjP4L7QM6PMJShDyFNWnijG3WCwJI2umdyM2/oDj?=
 =?us-ascii?Q?aQTp3Uc2agGThfk9ihnzb7/K6mt6plnttIKAs/OQTpHQ0UgDVNyrQHkVfrLU?=
 =?us-ascii?Q?gnGVLePZUcP2Q1Mi9tA4K3T+46Xdz4OjaO/eUg/wE10Cfd7+5QZ8RAr0sZbK?=
 =?us-ascii?Q?hq4ZLgerx43i2TEJbEXSW/cboDNsqvknoW9CjywqoeqGBcxs9AkcKRSNN3Jz?=
 =?us-ascii?Q?2M3gs2YS/d/UkC4bd1oVeIq+PVHxtiWh3YCAkJYcUyZGUa7GoRY/pIQnLWkk?=
 =?us-ascii?Q?xAQx+g4agMr5DB35UPsFwLWFg0qe0NrMCUkhygcv5XYWnMivVIg5Fepujj5C?=
 =?us-ascii?Q?g5X/hb0MdsHK9xIjYlqgaWj9RuoxlSbsm6iYKIktpLrg+IU3LHjDuN09UVhc?=
 =?us-ascii?Q?XL22ra2y8ll1P1smtwaJPLKyY4a15EUqSkJGLdwtwtXnGjYh8OYpLa8XlVj+?=
 =?us-ascii?Q?fQoUT35+WT6rEzGWm28HFj3HCglzyhnQoCsXVtrk+WWQ0Tjky49b9Wsw0KzW?=
 =?us-ascii?Q?Yvm//Hy6Vsm1Z21Y23U5zYPhVk3Uy/WsMhQUkDR370yA5/mIUS2ZBOxfmPv0?=
 =?us-ascii?Q?yfJ4XRs5PrbV3yb9RBSB8XX4N6ByJTPyRXMmFn3oxzmVvVbttb/Lqe0ZhIZT?=
 =?us-ascii?Q?KxaQEMv1PpcLbFWL6K1ODHmqfA20+zoYGWXCx8qI9bh9R7Iutu1NTagRvDhk?=
 =?us-ascii?Q?jhJkZbN9o4mBE+GoC3oQ3/1tCVtDGNL9IvXo342Apo4zQZvlaFfqa48APRTg?=
 =?us-ascii?Q?nqCFtzMWtCbpxAW8uwFCfn8Nr7PwixXcY7JsV5tw95GND+yE7b7dBWPufOGR?=
 =?us-ascii?Q?khWhaYTFItqWdefJtTG4cFXa+D8=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9c4dcb0-a3a9-4b31-ad82-08d9e0235e58
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 16:54:36.2545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6QjpUDwcR6XiD/LeyyuTH6kApxtmx7HsBSgSTKUYPWjDTv/j6iVtmGhpg2PbD5deppTixw4ZAEfxy6dE5dn7SLuGD7QOEPK5u4HcIZrxRMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6124
X-Proofpoint-ORIG-GUID: s9UKxEcI5ytc928KdOk4LxIqD9K9ORjd
X-Proofpoint-GUID: s9UKxEcI5ytc928KdOk4LxIqD9K9ORjd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250106
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
index 5b6c0d120e09..052b2eb9f101 100644
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

