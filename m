Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE4831D2DF
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBPW4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:56:20 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:64321 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231216AbhBPW4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 17:56:09 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GMqtj2028251;
        Tue, 16 Feb 2021 17:55:16 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2056.outbound.protection.outlook.com [104.47.60.56])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9h0yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 17:55:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljh4yGDx8Wz775BfDn/3eZ9ZKoTupTe14u3LwbJ4k38+WxoOnGkYAICpXODWR2m1ZtdwXS5VtrOz9gWnJpS5aYtzKoe3ook6ehiANTnV6+SSjendGze0WuADshK50lAmqKNt1hnwrsgqn4reZhUD5fKqH2O3o9eaIB1wiPbLrddmHPCm/H0HcUKiZE8ILLt+ECSuy+RSf1uA+1Vmkshdm0itoBvrE3PojLLW4h2+NtKUO+NDaFN3ALvjvXpbBddiQts2bEwk8tGuBieFEeLuk68/6eMdT1TlafUkY4KvPkvVZHkKNd1vFIf4a8xbFKAep7f6jjFdNzWYrqgp/VSIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nFOq1csAjfFW/nwE1+C/MkA0Es58sSVAIEU642mTt4=;
 b=K4xG+64ggiouHvGrjF6D0TU5f1rEsy8imh8vMJ5k+neUnC/h4Lszvu6WKDrDL60qAtzZiRuVP4FM8Jp32Mt+Fzp/myFtTk6JktxS9Ry87T+CXRTCuDxyNVF0q1sc/CO7ts4V2JL+c5av/MD6mVvjXvLTPbSo72nKu/P45GA50VU9SBySX9LNogBpSyY6T/+Whtb6PUVZwDSGRQysB7BfXtQzYKNmgvVgJ3C0Az0jAkgiEQ5Z3bXrqL+wNhfLADv+vDiUFpbY6rCRnlx6OjPlw/jUvtTRh+JYY9d4J/B/v/u/PIPioxNIz07JQnZDNDBg05p2if1Kdq8A9q0nbWeEsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nFOq1csAjfFW/nwE1+C/MkA0Es58sSVAIEU642mTt4=;
 b=RNCKVXmiBEmuKNRZnF20Qb4+723XjxsG3Aey71JMH0oNQJre4Wugfb9PVtPSKGGQOkiri1J8zL4Z1B3Bc4KMeyRRftaqFTq4EccGwAu2XtdCCxJe3Bf1yqx5wVYn9C8YAfWf66ViWZ/lHMV8O2qsSBlHIPVmXvnwK9A7nP3yj7s=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38; Tue, 16 Feb
 2021 22:55:15 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 22:55:15 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 3/3] net: phy: broadcom: Do not modify LED configuration for SFP module PHYs
Date:   Tue, 16 Feb 2021 16:54:54 -0600
Message-Id: <20210216225454.2944373-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216225454.2944373-1-robert.hancock@calian.com>
References: <20210216225454.2944373-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47)
 To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0034.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.38 via Frontend Transport; Tue, 16 Feb 2021 22:55:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cead6f9-2e67-48e2-9665-08d8d2cdec5d
X-MS-TrafficTypeDiagnostic: YTBPR01MB3119:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB31190EE10DC9E54F4717FB33EC879@YTBPR01MB3119.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ip2FEVDCqFx+p6IXwD5ZggXUxjJEDqKqViiZSGqsc3zxHCpG4W6rgRZj88JWmOadDcHQI9w98IfEwhEloalC7fO4cUdAaDfSxtAcUdWhQOwFlytwgak0MIV8Z94ZOxmuYAJH5c+eltEpRCRrFaawuNUEoAdqwhm4SLk1dIZqOiCB/8qWxZWxbr/JfmiELrJ+jR3pFzdRMZlIfXbYr6mgGeHTwgW5Ra60S51LoD0jsu+IVu1I2iS7yZm0haIeXnBAo0o/rJbE03kbbZ535ea6RbqAIzz/DVE2Ia6z0t0gO1z5iZ0/evWfsBNIswPuzNachdFu65ohcJHE1naCEQ8vP0iwn/simgcANWxym+b1Vvaq6Ak+WD9Pd9+WyDQXNMpZ9R5TtfaAB7dH6ujJkOvBZvtFHzacS/C4MlLFKCXy53j5fk4GdT2jAUjeNxQGJ3mdez5FQGj4q3Il04TjLB4RYzaxIZNEJDDAUMf+DSCzC9YRGuz5HJh0WYFqpftAqiwnJ/KEOV3gS6teGnvBcVVbS/kInI+WIqq1xHcdL6xZFQHAV4q7skRORDKKptLh7Gmgmx045GiOTenzyDMrebrPWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(376002)(136003)(346002)(396003)(4326008)(8936002)(5660300002)(36756003)(66556008)(1076003)(66946007)(16526019)(2616005)(956004)(69590400012)(66476007)(6486002)(478600001)(107886003)(26005)(6506007)(86362001)(44832011)(6512007)(2906002)(52116002)(316002)(83380400001)(6666004)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D8wp3JoJrfmhGivyXSJT7sPZy1q8y3eV5bdxSedwDeHFqgLBGOWW4129sjP7?=
 =?us-ascii?Q?dqmwvMW3PBHo0ek7aa0GjP3WeT6m5j1DT2qVOLPYee30d3tmeTOnaJFnSq02?=
 =?us-ascii?Q?6tqWAk2kqtMJfg1eUuuMn/E8QY/JZrBSucYY38he8oiwtXG4Q0uaqjqZYgmF?=
 =?us-ascii?Q?HI67fM9FeAc5WwwFC9OgiANoCaaHuTqtU3jAWOSdwP+9r1Sc96+/W/WR0DzF?=
 =?us-ascii?Q?/m22/H07+cZcy1L36B5SZlxOdZ4IMkRmeEIht7lQJ9s4+fD1KCNaHgPGHIxB?=
 =?us-ascii?Q?87Vw+SznKiRFqn/nPf2r0FnzF+NRjFNBiMbQZBBcO20l4zSutH60bcIvS0Bo?=
 =?us-ascii?Q?QSYosn9SdGbipv7CpThLHliehooyFrMh4vzLtR1sQg734RwI1NzZrbqBOYiZ?=
 =?us-ascii?Q?sJm9i+c2fa1rnzj4fA6KK8D/6LSIQv2r1IfS9/7bOV5fttap7jBzp/TStiAm?=
 =?us-ascii?Q?qgfst29blO+l0yppSmR0/o3KVXMjbezDhRPdk6HXdb3dmYZiQTyllO7XrWPo?=
 =?us-ascii?Q?0+XaS3U//26TQt8l2RP9S9bawdePM1TPYuTqimJwrsOAwgq/s/tyj2JT5GYX?=
 =?us-ascii?Q?GhEox9brmSwk5uL7mbSVUDJAsVV6NXgYrVfAvcbg0aU6iD5izVr/rGgDxE4A?=
 =?us-ascii?Q?AWwU8QD3pFpS8xn0bUlPR61G7f6Nw3aWboIJbKLAvrDYCtDbmyb6nmpdXclf?=
 =?us-ascii?Q?rwRxU3Db0WQoX5mlAI13qcjwJssDNZkw5/fX1TbCMmcwT90UnE4cX4zyga7E?=
 =?us-ascii?Q?haE4W3tGQpWz5Wrt6kyutpY5q90WfxqPErJ6zoX4RHAfClYhlXzKtiwYn70P?=
 =?us-ascii?Q?BhwglbSluhplc/hCsiumac/GImvU4wO9BhVPeU1EgDIbQAh2OqcuoekCfkLp?=
 =?us-ascii?Q?H36ZhPkfAqiiniBeRZuSgvc4FhIlDmGMD8rvBkWyW9Jqx4pJ0bSlP4lifAzo?=
 =?us-ascii?Q?dz2sC7VS7V41yTslyDR0yc9JbLLnb52DHEUzLj0faPD3CybED8SAr/zx3YXP?=
 =?us-ascii?Q?e7UMZXOZzLIAQTK188cdRGMhW0kNooTzanKckPt43+mwEDEWAwyed4KMErpW?=
 =?us-ascii?Q?/HolRAE+3l1IgfcJe8D9IT3B2DCubdwsxYNuBRGiSsjmxrvZYBmhR3kaTM9O?=
 =?us-ascii?Q?ruwrUeq0b/4Mc2dM6ZyB0Z+GtKHdU9xl6Dd16q12UwSID8JNR0MuuQgFumMW?=
 =?us-ascii?Q?0jmKw3AB+riby8eHcyVbTSF2f5PU38EzX2asFkKExlFgLJryI+IDREQGA7jb?=
 =?us-ascii?Q?Y835MXoJBV80k10i8KJRX1nz3FlOz4XDE/6MAA0COFmkO8z584QeRMxy2k33?=
 =?us-ascii?Q?CrQmGRcTFBlDemdj9l6L2a4K?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cead6f9-2e67-48e2-9665-08d8d2cdec5d
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 22:55:15.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtG+6HeYfGXhyGimcXy9iZu2/brrbcIhDK6d7LqvOoSfvKKN3HcEM63BjW+s1eyOiDEymHuU1unrsxC92q5liuParbg87C/6DK9DUnlqX8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3119
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_14:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bcm54xx_config_init was modifying the PHY LED configuration to enable link
and activity indications. However, some SFP modules (such as Bel-Fuse
SFP-1GBT-06) have no LEDs but use the LED outputs to control the SFP LOS
signal, and modifying the LED settings will cause the LOS output to
malfunction. Skip this configuration for PHYs which are bound to an SFP
bus.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/broadcom.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 8e7fc3368380..fa0be591ae79 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -366,18 +366,24 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 
 	bcm54xx_phydsp_config(phydev);
 
-	/* Encode link speed into LED1 and LED3 pair (green/amber).
+	/* For non-SFP setups, encode link speed into LED1 and LED3 pair
+	 * (green/amber).
 	 * Also flash these two LEDs on activity. This means configuring
 	 * them for MULTICOLOR and encoding link/activity into them.
+	 * Don't do this for devices on an SFP module, since some of these
+	 * use the LED outputs to control the SFP LOS signal, and changing
+	 * these settings will cause LOS to malfunction.
 	 */
-	val = BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_MULTICOLOR1) |
-		BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_MULTICOLOR1);
-	bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1, val);
-
-	val = BCM_LED_MULTICOLOR_IN_PHASE |
-		BCM5482_SHD_LEDS1_LED1(BCM_LED_MULTICOLOR_LINK_ACT) |
-		BCM5482_SHD_LEDS1_LED3(BCM_LED_MULTICOLOR_LINK_ACT);
-	bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);
+	if (!phy_on_sfp(phydev)) {
+		val = BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_MULTICOLOR1) |
+			BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_MULTICOLOR1);
+		bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1, val);
+
+		val = BCM_LED_MULTICOLOR_IN_PHASE |
+			BCM5482_SHD_LEDS1_LED1(BCM_LED_MULTICOLOR_LINK_ACT) |
+			BCM5482_SHD_LEDS1_LED3(BCM_LED_MULTICOLOR_LINK_ACT);
+		bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);
+	}
 
 	return 0;
 }
-- 
2.27.0

