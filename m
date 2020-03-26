Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 090CA194073
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgCZNwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:14 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:55298
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727733AbgCZNwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzNN7gAVENZQf1wcNDlOoaVWKQ3QR2JDMRn0Mcz2zmjI6deTEcNqSTAJODhO+ZA0kdwwn/j/XEfhTeYAxzRX+o21Za8ilFrbzoxKEoLM3Kw3RXzqtqSP5SgzChVmCZz/2TYn0kEToPYDT3Zxmt/R7UefzhXsyLJ+cP5IcrzidZzhWbdpFEv5Td4mTbZTjc2L1qCF576DHb0aFcViOTBfjlNSwkc9W9in+RONmXArXHRpvnDHr5mH2G3X/q/Pe2+qJU+lyEiJSHvze8Znp4XLOZxVL5oo4oYcFqKTEc+JoItz9uer9xv7J4kDNcdjdSNaRA17+IOadjcgRHHW3wcWXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JjBwpsa1ZjaIS4MP7/u+CF5st/pQ3hnCG20ywtO62s=;
 b=n9KpJMYbyy1u+hTo8yb7zWxmxID/ve1Wcsp3kBB51q73QYhF535zKoFGpD2kuPypsrGS95qMI4YJwiRJE4qZ9wcW7mahC1dkYmejCcm83m43M0XJjbM7SNlAtELLFaUIua/bBTwS+bP+pV+NByQp8RGk3VWlt6vB7l4bJhknnae43PzDcXHCxWEULcRZB5mjNI5s057pzne5GcYyj9TkAS0svHrlsIyzBTNLL5CVHZDXblDNe0GJmfTirRr9o4Qivp1mBScRZbvvpBoPQekRQlDhu0ouddNRMYw+VYkefhLF7S/L9PtSGzAr0XxHTtPAaAUzGeGLQEr69RXnheZmIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JjBwpsa1ZjaIS4MP7/u+CF5st/pQ3hnCG20ywtO62s=;
 b=R1XF3c44nHVvscpIHnZ8BquoTk/CUn18ptp6rsYTCOiaNFM7kccBycw/j2RUqgyjZcbUWJHHN5e4GPYWPW12zEXspt5ZnfJSmhwqYzJi6qg7iPcPe5Yw9AlL2CRU3siOgOavcX+jVocJK6SCEMFqaf9iN82uTIseWCLEOiJSMn4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:52:09 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:52:09 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 5/9] net: dpaa2: add kr support for dpaa2 mac
Date:   Thu, 26 Mar 2020 15:51:18 +0200
Message-Id: <1585230682-24417-6-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:52:08 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e1747a1-cf3f-45ec-d9c5-08d7d18ce0ca
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4272AD2E3A05907B1EA29F3FFBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jlt8+pA4B2hDjap5nyYuS+auEbUnUbdEcexkYEe6ffRZNVi6vQyJHDgr3wkkhSL8beRi94TIrXfFvfKCLfdFghyfvFXT1+xBAyB1FPFWbgHpURhQ1YclWTVCHeAH80KBsfBqkGLdkKydV3o0RzcfQmntGaggwkujYOiKE9lGuCRF5MiunY94a4WjlBy8EwiUjqVk1QxJ/SF0tKbXkmhptZ21rSYGsPbSIXTf2J7YLYUIZA4X2yh2IEDGFu2jX5HmpxCNBiynNZEmjnoLs8Qlhfuv0mXD6Siz36ZuJK4jgLuqsMdx5WoIk8he7qvnHqMEnaYcxuUX+19rGyp5amttkUE+ugjr+L7Z5n0cGcM1Xi42Rqvd+DYsThRmizIr5ScTZ/a2P+gyZkRQvSdRjT4XeS1BhfComKaTlX/W7gv9NX79kz882o/V4G4MDustlFN3
X-MS-Exchange-AntiSpam-MessageData: 4+fFlkOIJaV0tYpduKgN8isLGrlAxyYbaTw7cl9+8P8Q2sZfBOlQRkWK0N6UGZ5RBMFm9CkUJffW9fb2s1an8w1iCJcgujQs3UBhlx3gFjhP6PPLixLImP7ra3ppFA5cv3kF6CmcPR8jmfRZAm7zkg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1747a1-cf3f-45ec-d9c5-08d7d18ce0ca
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:52:09.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZvh4YiyQ4SKzFZtEOeiIyZvS9hji5xWrnwYNBP/jiWSCEJ0luYSVvMMpqy8AvRun4L/BfVEh6Qk/Gb90RwsJoTVxcPHi2rJ0YSiB1WPT+s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kr support in mac driver for dpaa2

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ee236c..f3c384c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2019 NXP */
+/* Copyright 2019, 2020 NXP */
 
 #include "dpaa2-eth.h"
 #include "dpaa2-mac.h"
@@ -71,6 +71,8 @@ static bool dpaa2_mac_phy_mode_mismatch(struct dpaa2_mac *mac,
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
+	case PHY_INTERFACE_MODE_10GKR:
+	case PHY_INTERFACE_MODE_40GKR4:
 		return (interface != mac->if_mode);
 	default:
 		return true;
@@ -103,6 +105,12 @@ static void dpaa2_mac_validate(struct phylink_config *config,
 		phylink_set(mask, 100baseT_Full);
 		phylink_set(mask, 1000baseT_Full);
 		break;
+	case PHY_INTERFACE_MODE_10GKR:
+		phylink_set(mask, 10000baseKR_Full);
+		break;
+	case PHY_INTERFACE_MODE_40GKR4:
+		phylink_set(mask, 40000baseKR4_Full);
+		break;
 	default:
 		goto empty_set;
 	}
-- 
1.9.1

