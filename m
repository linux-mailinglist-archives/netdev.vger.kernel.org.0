Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF88B31A8CB
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBMA3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:29:50 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:25511 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229679AbhBMA3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:29:46 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0Qi7D028671;
        Fri, 12 Feb 2021 19:28:57 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hq424ane-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:28:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5AQDTXGCG4jJLMZPAiIPCaIZVVLS3wae1Wu3FDJcFeAX8e0izovJtJdcKrMw3sm1mHbMDnJcR804P8NprQIXhatFOYusw/gvjeIFQifRF1FsnTf7EQ7+GlL4oYDAf8RV6WReSsGKwaPk9dRgjERPFjhqVHDOv1iXrL1MyqTJ7DAvV2c+Mzg95FvB21V5BljTmorYwUUPHzyTQeUU7Pa7Zze4hljCyCDFSnpv/DX70Op73cYD7DArr2YmwgrvFGfJkb3zOOY0VFX+RBo6Je7mLsux2KsqxQKlNh380ikuH9O0ZNXyoxGpKKAOTmBJ4aRSAMqAG67pg0x3SX0icmVmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uqO2ZRtzFyTHRxfJQnddDdJ7hnA+j28UlVZv0QYWRk=;
 b=fqesnxO1MUD5p9KZU3aFJbYcy9rPvOy1lM/5zgk4xsIRCh4NJ1e9EINMEQwhykboSIA5c0xUIl8amyv56bDsDiW0k/sLYPstenfYTqfOo3q2hzjA1I4TUPHrpq3zx0fSx2oUe15eFb1nfzjKMpiQnAHtrz4SY/IBu4PVAjctMlUAwyub94EPT06O6k7VD2VyPKX4ZkSIPlbYJngU5EQ3H9wGLKJlCq3zmsmcoLIVflvcRe9s2WQSKXLTLZzC3ucAthQm635n3+tZVEWpLU5n1xgXOnskLG8JrpmtBXDjYnxxwdt+G1TvheE2Dvv+gH0bjXl+daS6NQCLgFLUjKfVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uqO2ZRtzFyTHRxfJQnddDdJ7hnA+j28UlVZv0QYWRk=;
 b=i2keec/LAgOVSFg3jeaC56NyaXcGWaPtjjjvfa7kVmWsrEcbmGsH1bW0WOqprPPppn2hbA8jvSZe+1iPabWwbyCmVbJF0MZoZ0iHTIEdXEXwdL1xybTQWFyXOMbiKb/y2LFJNgr2gRPyOdq8lVM/bCMQeUO/23gCTJbK3brHSS8=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YTBPR01MB3264.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:28:55 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:28:55 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/2] net: phy: broadcom: Do not modify LED configuration for SFP module PHYs
Date:   Fri, 12 Feb 2021 18:28:25 -0600
Message-Id: <20210213002825.2557444-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210213002825.2557444-1-robert.hancock@calian.com>
References: <20210213002825.2557444-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:3:115::20) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR11CA0010.namprd11.prod.outlook.com (2603:10b6:3:115::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sat, 13 Feb 2021 00:28:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cc4a3a2-5172-46f7-71db-08d8cfb658f6
X-MS-TrafficTypeDiagnostic: YTBPR01MB3264:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB32648DA98A04C088AC7A0D44EC8A9@YTBPR01MB3264.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +14VNqwFVsqs30H/y/wCHKa819ivW9h+ZE1nHYhwZTfpAerkDj2CKNEjv1Ce0l7GpT52iUf+L9WMQdCU8Tn6VKH9TwOW67GxA57e7gsvoe2eO//vAiSI1hLTC39vl0HkSGc/PqVOpTiuR72gIK1ZGoMojAwLLdj8JND88Dhwm28xR17lMHJJlZ91jCOA8A0JWVrNVrueVkIxH2XlF4ow0C19O77+svty9mFtQuluLNgIjA3tFiKblo05I6E+Rwh0Ld3JDh69OTxZPKGkMXX7ApLWMeWC0at5BOdv3azTbijMMk/3OxYrWo/Bm3Xcyz+F/KID50UvZXXTAAkqPKilKYaqrR0fk6HrB+sAgRfly0/tDB5VD0PyEpJX3VEuroC5waMeUm67mfU71CKnK/NKjUZ8ejnBqJSzs4g96IuMPDjL4HU7ZdqqUqI0z4dYsOARTzNi9PQZP+ZJE4fXjwtISzP+NFCzSEj5HUUXeNXPwBe8pObUkNICuQM8AtO05+bu88UaGqHpTrBxj6/D5cCfe+3ssf1tMbmQDkgUTmz2RtWS/klbIkmEyZULgi58H/yxkkyEfzI0Mlrna1E8k2BKow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(376002)(346002)(396003)(366004)(107886003)(6666004)(16526019)(478600001)(66476007)(66556008)(8936002)(36756003)(186003)(26005)(316002)(69590400012)(86362001)(52116002)(6506007)(8676002)(6512007)(44832011)(5660300002)(956004)(66946007)(83380400001)(1076003)(2906002)(6486002)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?btTnqtAo5VpUAdWXA55+T+F8Q3dME8VbR06x5QFsQXH7bsJbHL0lmGacyu2m?=
 =?us-ascii?Q?Lh2VLLp3AgCPmpdxcwyOFja8mPYKQfEcdK/TY4rZcPPydxjIHWuWGgMs3oqs?=
 =?us-ascii?Q?XtEUPaBcgfaHW6u6w3So4WDqE5O2D/F3e/eWxTy7xrJr0qh7i4lgiaJgNgp7?=
 =?us-ascii?Q?VEIKvPGRu4rOLYeg2AyVUHBMaCnoU3hgj35k1ZdOjNl5j1tRUTcYYhJHQnDO?=
 =?us-ascii?Q?WZSrOYJCUkr/6yC8zdtTv5NSVteyX/XVbc+kF/Ub3Hmdo+GbVf4kM6e0e+iy?=
 =?us-ascii?Q?C5L6ZW+4vcPwCbQ6OWfMeea8UKfz4/JrX/8IZUC1OACwGy3gsq0dQnL46mTU?=
 =?us-ascii?Q?SyX/cpzbOf+BfZAjcDzXz5ssEKOwjYd02wnlW8nPkWrt/BiCx8hYG76gydTa?=
 =?us-ascii?Q?Lc4nTG8WUnwDFzipOalnOiHorqei+VGDHHCT/wP64Op0XmJa3Q5vzUcUfHaL?=
 =?us-ascii?Q?s1RZ/xjmoBER25WjCE5mSO5Stf8cykfvJGUl+ekxAVcNkiUSxe2sE12nLNjv?=
 =?us-ascii?Q?I4VFbDraWaeHypBiqq0ogfXrOM7qF78idKRsmN2djUkNxnv/2BxEDhYS2J66?=
 =?us-ascii?Q?KwhaKS5syig3zyCDhROBpkLVvoYenbvTc+VeMYSSqmlP0qS4VYEKaRgvoFZ3?=
 =?us-ascii?Q?T6dtvjgFBIRSA34ogpAxxl3dNvPzzmIzaSmTbY8nWPiX2Vpnvhj3fZnQTM04?=
 =?us-ascii?Q?sFOyjll5Q8S7GTW/lVCQ5RBTB2lQfO3TAtDPMldgBfww3jcTA42/81fmXkUd?=
 =?us-ascii?Q?Zs+A7uI4ozJ3DwtL+mjO1g2m3NSEvg30hp6ho1pPbisJx8eZZKc/7booB6Ub?=
 =?us-ascii?Q?xAnEFNQV13QNzjpRVsy1l9HPimSvpQNTD/Qpf4Md7sHHJ8th/mapmasYpdtr?=
 =?us-ascii?Q?ToQQvoFHGLD0ccvC/RctTtenDCM6cq+YwPKmN+dCqyo0sQt5ThdyYh37YWvu?=
 =?us-ascii?Q?/CSna4BN1jLSm1OMvFOeN3xJvPusKkePtMNMvq4tCkWJLwSh1aMcE1HKmFJ4?=
 =?us-ascii?Q?IxxNB+OVTBzAhCe3hPuNodUO4b9u6aIlES87IQPVtr2tZBESUZqhe1FmM/m4?=
 =?us-ascii?Q?6uCliLN7QBaRodtcplcBTbKdQo4h3nLwVpy4POMbq7UZQ68oYB1FdNVWF/I9?=
 =?us-ascii?Q?wyAdR0ItLSS3ZC3dNDgTWCdROJZmBnX/iXKXGti1e1YS0ODejs3Y9C/9ItW5?=
 =?us-ascii?Q?Q3UEfbuWUs4Dvbqn1if2kkRTgr6bCp7y10G6DgneQ7jQv4dRdMVekJU0Ib47?=
 =?us-ascii?Q?xiYJgof7/PFGp8+kfp1AbDXeuN1lhvxrYI3u4MPT3hOxzvEVy/Amhd2be2zK?=
 =?us-ascii?Q?RckZsljwHblrIbaR0XSZoOzx?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc4a3a2-5172-46f7-71db-08d8cfb658f6
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:28:55.7827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0IXNc+0HZHWrMjUDoXVNb6ACkVVvzq2Tzw4Jfp+4TWhXWCI+wIuER0c/QYEeguulUZU/qjBvZY8+Fl1lArjK//S1tRsgJ03g5SBxw0DZsOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3264
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 impostorscore=0 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102130002
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
 drivers/net/phy/broadcom.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 78542580f2b2..81a5721f732a 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -12,6 +12,7 @@
 
 #include "bcm-phy-lib.h"
 #include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/brcmphy.h>
 #include <linux/of.h>
@@ -365,18 +366,25 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 
 	bcm54xx_phydsp_config(phydev);
 
-	/* Encode link speed into LED1 and LED3 pair (green/amber).
+	/* For non-SFP setups, encode link speed into LED1 and LED3 pair
+	 * (green/amber).
 	 * Also flash these two LEDs on activity. This means configuring
 	 * them for MULTICOLOR and encoding link/activity into them.
+	 * Don't do this for devices that may be on an SFP module, since
+	 * some of these use the LED outputs to control the SFP LOS signal,
+	 * and changing these settings will cause LOS to malfunction.
 	 */
-	val = BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_MULTICOLOR1) |
-		BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_MULTICOLOR1);
-	bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1, val);
-
-	val = BCM_LED_MULTICOLOR_IN_PHASE |
-		BCM5482_SHD_LEDS1_LED1(BCM_LED_MULTICOLOR_LINK_ACT) |
-		BCM5482_SHD_LEDS1_LED3(BCM_LED_MULTICOLOR_LINK_ACT);
-	bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);
+	if (!phydev->sfp_bus &&
+	    (!phydev->attached_dev || !phydev->attached_dev->sfp_bus)) {
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

