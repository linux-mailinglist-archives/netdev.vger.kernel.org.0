Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E0C31A9A3
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 03:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhBMCUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 21:20:08 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:57343 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229918AbhBMCT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 21:19:59 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D2IBXW001727;
        Fri, 12 Feb 2021 21:19:09 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92swb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 21:19:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkzupuZwQHXqH+QX1qdmM+4sDR76rSlu7x630dB4VzVwaPHQtBAEa3+nJRhxNfd0xUctvBfXm8k1QRhOmntdhWNGW2kIywkivXFyKOAIyNEveNMUH0iWDwiGhGsNR7F5Ui6GqEWEsLnOiRVN8Hg4OWkUyOo1e8OqCIGnvBRTCwq7mU60c7Km1uxuLBb2rLA7oDBxf0M66hAYtF9wgfOpEJr4rFuIw5GrHYc08joxxdPkhF2t299Q0XNlorWbYUZhOXzdL38nAz57j2pj7m+tx805t9tlflS77AiUSdtzi9/GOUj9uSnaH4KC5JpSfD0oDTij4HpW0BDYrL5FmQP4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eANcMZHMEe0VU4Hsmj5w2hDa0gCxI0xhfBM9misHVYI=;
 b=ogSY+C+IxVkAGRo19xro1ZNhJ5fXwtpHwZOUIO/hVzG+Sy4XV529XdqNZNrVuWskRtX3RbjF562zsYLp2rwq2K4mCPZxY3iE4S0rDFVE32NgKB6elrqwaO9o8nHAOsReJrTOVSysWHJQYJmmE/XzO98F8lO9qywIRII3wLmulw7OvxWkp0vsfLcLzSlOTiQZg8g7o7RjIpSnMKAuGT92BXOsMq7NoV03fhK78epHKRSKhXQ5jh/RYaiixL03LjP9HKAUP1eaB3szGOjZ/SUSJHC1/9Kh2PHSadbC2hoiR6f1DZsrb7hVxuWMTKcdDdflBrK74YXS+UHJvSsEgx6Jbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eANcMZHMEe0VU4Hsmj5w2hDa0gCxI0xhfBM9misHVYI=;
 b=UC0Hef7sq/tfw6iDxRu8hRADm/5VScL7srV3UgUQJlK244+CYEvOt5CB7FX1PoaIbQFcFq6gDH9EISNAhe9soS3oUZ3Dug2yLt7K2mkCdIs5i/FAmzOE4u+x7eRoe0uuAPHgdGn5kCy7SroxhEH17o4JlZ+7EPahzWkwTrYtHpM=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTBPR01MB2606.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Sat, 13 Feb
 2021 02:19:08 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.037; Sat, 13 Feb 2021
 02:19:08 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 2/2] net: phy: broadcom: Do not modify LED configuration for SFP module PHYs
Date:   Fri, 12 Feb 2021 20:18:40 -0600
Message-Id: <20210213021840.2646187-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210213021840.2646187-1-robert.hancock@calian.com>
References: <20210213021840.2646187-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: YT1PR01CA0096.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::35) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by YT1PR01CA0096.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Sat, 13 Feb 2021 02:19:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e32be36-7017-4adc-a0eb-08d8cfc5bdb9
X-MS-TrafficTypeDiagnostic: YTBPR01MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTBPR01MB26069E12624FDEFB4300D1FAEC8A9@YTBPR01MB2606.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOO5/0AVCPzSQvjqSuCC2z//zFUVoNlbfm8pea3YcYcYmbYqJoE+p6yBjIP2BxlmDlQyegGKLM8S17eneHswEd4cdYfL4TSp6J+AuNtUlzzUKs9DvfInM9cVij7jwAu75IyDOnrGPhtSil/XGi0Kl/VSl/nsMyA8HpyEcCIlCNLMZecjVYuoCFLdtTCoEFHlYSVLEekRe1KjiHOe4LHlNyaiQ7UAH4/3enKXhLWVYGKOAy0eX8EfJW7TeFntELnsPZU/InK1q63Bo2jLHvhYKZ/XfvK2CrJMD1cClZ7KkINI8ukwL1HeqM8sqJdjg3BBQ/diKvFyAOqJh9SHDvH2oas/dj01L7dV4oesz1NOaMf5BRlNfHFrHtyyDbc/9sGcIqpiV2jSCGhvNvyMduJmRJJ4KvSbOMU7SaTWg4J+sh7CuGJATa8aJQ4qnDWsadaPdP7STRGjKW8vuh3r7/8x+aPEV/1cp3xG11GqWcq178Z3Ia18W3y0Fla1GLPpl+P9QVgHDB175l5MwFoqJpg6xnrsManRMhQqkz1KvKjeovnYbmxyjFCLp01XWKCwkBuvVlXM3MTpfWx1hLCvweZQGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(346002)(366004)(376002)(6512007)(107886003)(6486002)(4326008)(36756003)(5660300002)(52116002)(956004)(2906002)(478600001)(69590400012)(2616005)(44832011)(16526019)(186003)(26005)(1076003)(8676002)(316002)(6506007)(8936002)(86362001)(66476007)(66556008)(66946007)(6666004)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?N4gqmoGiCKon1E41xpHNh9fvnyPHqv1N/Jytc0R4EvkgHrS5b3pBvipGEL4A?=
 =?us-ascii?Q?uYm4WJeFznjo1qI7IErznIBQ4PtPtEQi/MPumaf4rqNjV7SsQglyad1vnliw?=
 =?us-ascii?Q?vGSohmSHLY32x5atX+8B+XTmaSf9zR9PCOKQ79ecFRreEPSpzsIsgLlrqaI1?=
 =?us-ascii?Q?FvqX0yyYFrR37Fk3jibfl772cKM74WR4P0uoI6HDSW4HNTBzAD1Os2Yl6wZ/?=
 =?us-ascii?Q?oXtKTvwAkeimYUfEXXsNEGjQY2IhIOKFS+junX2p+EnERQF/v/h8aMMOuuuX?=
 =?us-ascii?Q?Z7uovH/H5YAEDvnUf1B3v5lJQGh/Iu/zW7c7hFzTDInO8ppUQyuCcf8ijm9y?=
 =?us-ascii?Q?Dx4TjKLis/9CZm147wjGuQw7puqXssm+K9aSKLEAzB6XG2Ur9ll7Ud3J86Vo?=
 =?us-ascii?Q?TKm10XJqYuVtLcoHxdIt/1XXMlTHnK3NTpU5LNZHxkwFfampQRgrXFMXQujr?=
 =?us-ascii?Q?ADKkwv8prx3fO1j4gcRzvLes1Cz0il/dnkxW3JHg/v+6DXavohQ6ubfwisDp?=
 =?us-ascii?Q?FHEAUxhb9KLRlu0rDc9I5XN2dTYxKFQdi7kEKkALhlbQMlgefCnqE48ZSDvw?=
 =?us-ascii?Q?V45fxszPy8uLebK10Z3qsxFK0fBVhfai7O2YR0b9UAv+f+nzKGAkK1aglcWn?=
 =?us-ascii?Q?APpYJU1W7hChiYdIevJOTL7I8pIjykKRADyIzW7SiWNbqJMmFhlq0irxSoHI?=
 =?us-ascii?Q?7lFdWVDzs1UgFIRpIGH+W7TFFDidvyYyVpy58yiF6/9naExLe3UOjvarjJMH?=
 =?us-ascii?Q?YAR6m9TOAXZuHfV9DnGZrgGjmZvNH/1jj9OjYVnyVaAaQHZegTYZuoCZRox4?=
 =?us-ascii?Q?6EWy/CUjSkSQXqSuk407KFiw7dGr3on9G2r8byz9/4IecGNyu5SP0LMNHKgz?=
 =?us-ascii?Q?3q/PSZImlALOAemJRBCTasSnxULGD+8E6YxznZfcgSwK+kTftwr+3zuej3ki?=
 =?us-ascii?Q?K3Ykm+V8yTI8ftwmlTKF0yhTmW/9GyuxcajO3PMYEWVinQ8JJEej+8E5M3qQ?=
 =?us-ascii?Q?iZ5W8OWzLZvNJmvQybGdBfYTD7i9r8AtMTzMPb3587jldZDdGVj7IeeK07qX?=
 =?us-ascii?Q?95ZDkGGQ7iVAKoorpWTSJryg2g/yfWL/RnrTZWvTF5e7cNC3N5OYXL2GSFrA?=
 =?us-ascii?Q?CPaDty7BXEWIFreT+ERpFFERd33WePtbLT25RYWR13DN5i12tJfQDc7uQh/C?=
 =?us-ascii?Q?QXkCiAIPuFbHhTJJj/OVmkwL++x1jr3y/3GMUD/qmCpWoBhdqvz4/ghBx71d?=
 =?us-ascii?Q?6pAK92f9UfQHU8PROuV0SUt9A2whxTDvKLBaEcGdg76ZTalaxwRInuDUPock?=
 =?us-ascii?Q?nsuO64k72KEs9ek/T0xSNU3k?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e32be36-7017-4adc-a0eb-08d8cfc5bdb9
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 02:19:07.9446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGZyVi54++iS6cWV9/RJ8wbBFYeTjAZ3oG1LBOxxSYZCjCSq+PdC/y00yFF+Sq4Kzm5hUm3oIoySHRrwOeaSkyPAeomvk1lyISZuOpCssIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB2606
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130019
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
index 484791ac236b..9d73bfe0a1c2 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -12,6 +12,7 @@
 
 #include "bcm-phy-lib.h"
 #include <linux/module.h>
+#include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/brcmphy.h>
 #include <linux/of.h>
@@ -366,18 +367,25 @@ static int bcm54xx_config_init(struct phy_device *phydev)
 
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

