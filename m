Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE7831D1FE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhBPVTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:19:44 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:35297 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhBPVTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:19:34 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GL6cwQ010488;
        Tue, 16 Feb 2021 16:18:39 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2051.outbound.protection.outlook.com [104.47.61.51])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9gyqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 16:18:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PS1IZzkVtI4s+0jy60gQrKKMWnFkInQeuJkRa8BfJQrj3zoLJgHzWkILecSx+RjG8IRvBzN5dBtEG7wa4QAQqPn13z91Gh84SEfaGHUWHnhSVXICF0osjwA1TpQXShUYslms+7NkyswdcZPIfEwCymD82c1t5CCpz7PdtDSbjpvfDzeG1+Kb/ZFlVJRNjf0S3CVQd6UIr0ZfZnKhfo6J2M0X5w+7CA7Z0KxBkpp2CTR7hJyGwvyh6s7WmOxpQuZjCKMqr1tlxKyVAXsKkTS4I+QfKa/5cnEC7kLuLNPg4lhEGkPpMydTureDMC3oDN/em+1/csrWEWudZGKVXfk7nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nFOq1csAjfFW/nwE1+C/MkA0Es58sSVAIEU642mTt4=;
 b=LoHOzyfWmmgfret0Y/Ff26I1Dni4g2pg365dQFRaRXgFyrosgvnpBbo+z9rPVP4X4pX9T2WuSG8PJuqd7XA7TCpDaZib0TOYVhtjRPz7AScxBPVlhyFut54lO2/Y/v6TS47eDqb/VgSORs1JtGx658AHPLjdht4uqhCzd9kaYPLYzyxTqm5cZM/uKXP5qbvbCbmyrNnkUf+AJABc3WiZIQTJeJRbomy+27c8ejs3otFp1T2dKYoqZPVjbB1aQZNnPr9b7AaCw+ePHBezJq31n77UOS4NraMOu8/fFGzJhG4cHYPiKWvMMk5CknnvuGnwdXZ1qKzzIvKQckLutK0rGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nFOq1csAjfFW/nwE1+C/MkA0Es58sSVAIEU642mTt4=;
 b=XV/5d2wuCYJqiOGM5O67xtj6gabG8NlCgvJ6mU/nKMa110MRl3f7EGUECoboAsqr3VxwSiT8IGwZE78LWX5ZM3HYIN21xvdc1LFeC2fML5cL3MNlU10OP0CwcD7DnYbaeXbuZPoGXrP0FNpmGprVAGokSPniKnU9PJPDaPdlo8Y=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.39; Tue, 16 Feb
 2021 21:18:18 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 21:18:18 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 3/3] net: phy: broadcom: Do not modify LED configuration for SFP module PHYs
Date:   Tue, 16 Feb 2021 15:17:21 -0600
Message-Id: <20210216211721.2884984-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216211721.2884984-1-robert.hancock@calian.com>
References: <20210216211721.2884984-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM3PR14CA0128.namprd14.prod.outlook.com
 (2603:10b6:0:53::12) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM3PR14CA0128.namprd14.prod.outlook.com (2603:10b6:0:53::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Tue, 16 Feb 2021 21:18:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81e5c8e1-93a4-47b9-2faa-08d8d2c05bd1
X-MS-TrafficTypeDiagnostic: YTXPR0101MB0879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTXPR0101MB087976EAC830DCAAACF345A7EC879@YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YjhoJQ/BYpabF8GGWN8Ic8SCZs/gcgMwDpxvp6haMVeVTqZO++yX0xNEZj+3tK2QP/BsANXELpX4dOw0mE7znVj5bI7d6BWbAw1GqdLB7u5KwcNfskiN1OiYzh4yMQ3nZW0EAJbG73USQhe/umN14gNxUgumREcg34lsmz+YSWFSfBocZuRw9SNAOjr9W+j57jo5MKYkle30s7915eo3V0Z7MMTn1B/WSsVguThG4L8exi9cr8hQ+f6Jmlf9+j0Bmw7+cYoKobxqr8D3WhgwEzEOURR57DMqqOHZV03OYgWN9RuT6lPTgb/84SRoinvP3VQxOBiAIcMRSsvcaauAadqy3TnQwK8gakrFedHhkCfyoNwtJV0pO52txZak6q3YrT1jTf1cuZWkOuKLeciNCzXeTyufLkzVsllqhIBlLkzIUN7UR99u3G9hML5eJGAUQe05wLvRr5YXDcIaIWPaDrNSoUPy/6CbtyJOe+0/J+9eYUHAoQpLaupa4ORmTrEAQYR4rPZDjDVKXfwlQS73/ed38L4xwx3T0gsZYcb4niPHS8b82Jy6tduqOnTdF0950bYynu191AigC8PtfZjEXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39850400004)(366004)(346002)(8936002)(8676002)(956004)(6486002)(66476007)(1076003)(66946007)(316002)(186003)(4326008)(6666004)(2616005)(6506007)(16526019)(36756003)(478600001)(5660300002)(69590400012)(52116002)(107886003)(83380400001)(66556008)(26005)(2906002)(44832011)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9eMHvxbbbfJl4Zbo//YEX1IPcMXXOfexMlUa9m5RJa84oGw97mi+dGF5GbwQ?=
 =?us-ascii?Q?hLIGaBW4d8DjShQFYfxgKJNKazzX6twTApaAAbChA6M82mOCcq1jD7aO0d3d?=
 =?us-ascii?Q?kKZEjDbCprmVmyAJbL3g3d8YVXAWWAO2846E5cgkWhl/sOL3XsGm2XnbAjTI?=
 =?us-ascii?Q?hsh/mLIYh7r93L0fLnsIEhZ89uSifVtB2jqqhJWsu5B+BeDb6TGU5rBDgPJr?=
 =?us-ascii?Q?Cyu20qQ2b00vWUEygXYJfXpG/+kWpjEy2aIEZmh3FPl7KNm4lZPHkQmb/OAc?=
 =?us-ascii?Q?CoBxFWBTrIb7wMCJ3HIzQ7Sv0jDZzFu5SJ7H4bi/TFqH1At3yZSgNgCMxsTp?=
 =?us-ascii?Q?TewViVbO9a+2ZGV6ddEpg1yFEbZoCvOezS3EqD3Oi0XGD/SfjF6zNO/i8gtf?=
 =?us-ascii?Q?9XlJzUwyVuPzGWQmfTPWfBxmVhOpmszA+jJlUf+3W8+Z3+aLKW7uiotLRqrq?=
 =?us-ascii?Q?KXPKfCthNj28t8bh9tbLPwuVq2ai1mnqWfpFzbiC25s8H5eaRGZHv1JfVoRF?=
 =?us-ascii?Q?bwk6noQcrU0oD42GcmA008UAQEFhomUwCS4Eb8IweWVU1be5BZ5bX0qRQ8Fr?=
 =?us-ascii?Q?FntukZ4OoZBlwCgd+B6G7EijJ4P9W4YICNQ4XXZZilrAQXabDTGQV9FjhTfP?=
 =?us-ascii?Q?d25vhuInkPC2rt/SbRklXNysl8En7wbPuGXrqgcwL4XPv/vRLbBjEVTqpcqb?=
 =?us-ascii?Q?3K8Hi2WnTmtVSdKz9C0sh2mqcPGGfBh2q/BjShYi4Ew8gMdg++odwsi22PLj?=
 =?us-ascii?Q?/QVO1+peGHwkzr6sfx5ekODd5xX+gleco0AL6gSP5NT5zykO08ntEYgfaUER?=
 =?us-ascii?Q?LMcLThbD9904dCPpvzq87OSvgNwGwH4Qad7igi+qNFXH23X1IkobJhD4A++a?=
 =?us-ascii?Q?a4vVgQKng+G4ol+GXFJlkwfUnJKEVIAjh91loykV2/DBCFWB3SdY8/rwELBJ?=
 =?us-ascii?Q?EUFTLpVlXK700jq2bdc9B7ruIZEQDhvH05DmbfaS0SMC0nXSAqesVyPQwkDS?=
 =?us-ascii?Q?z8qtCqCjawku1EwI7XhXpFONRJVdVDbF0YK9keja/EXDK9Y1t0Rn3kig8xBh?=
 =?us-ascii?Q?A/FJ/AcrKTZAoh9oqYYAwjHy+ewlzZdp8559akYA4jZ+WQiB7K0lOWG3Mfr0?=
 =?us-ascii?Q?Ly4tqK1VCfesEeQhSU33MCCi2UefrIJ73YKmygNPZHjcaxknDhcevBJbRymP?=
 =?us-ascii?Q?2iLTqvdhJpyu8+eq9dXQcMeCn9u+vpmz6UoDJlwPV5QGvsWPjImHoR/0gigE?=
 =?us-ascii?Q?JkQ7SkU2AxP5d7bPdNhwCeqD3Kh55+HjnRbRe6nqihQeptt/QoMYN1d+W5c7?=
 =?us-ascii?Q?9d1wihgKmOdjn+KPAHdJhGTP?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e5c8e1-93a4-47b9-2faa-08d8d2c05bd1
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 21:18:09.0423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJtnjDskHcMCCk1tE4qqWC6AK8ZljAWhvtYO27kw601uLw0AE40Kyx0n4jKQ4iWiT2ItiflmVWQr1JmKB1VDIjXffBbhyZMmQPeEE2QLtA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0879
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_12:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160172
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

