Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5923119406D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgCZNwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:05 -0400
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:1666
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgCZNwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8KN6ZsPyweDML1x8BljFnFFxcfgDLkICzujuKCxUFaGAPBbzG4GHg7m1IVl6NTrrLwKi0EQxAmdhRU5NO95Z414sZmPit2my+ceF9xQNt7ivg1EQmR0O+4+kgbhn4sr2blsw2jq4cR+RVpkXwd2aZaokHwH5i8GIhnvqCf4UaU6YtQJJfK847lRjwnNgKDOIy8wM1dOwbMoyuLeQnil9eqg/lPsZTbd+47naGOkJEfpzPLpfHQZateT7UjfkuGLADjI6/7QqHx+3lBbRV4bFhxLf8+wwnVP3X7ATyUHWqGJiZq2bGia4l2Cp1LZD8387ZvpuulXAnTCUP4dHp7Z5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAw6aH0zPo4YrDfsW7Mz35nUyx86Z76nqlXQm8luP0s=;
 b=CXnwBlNB5gdyLcgEGRxHIFQ5pfP8Bzwdmc3y7WfXuOU9ddI56MRD3rHRays47Krh1bkCyPBvaPRojtrsid+rBiCQMxqxrNeZCphmJ0YId6snWHyMerc8yHo21+lDdolAk7KuZTmtkLLDFkrmgnVNn3SC2NQtfYLfF1L4FScwgTZqk5dSEMH+zW/derqvHFgKTMEZluF8RC2gCF3h9X6V18CkguaiUT/25zozvkXwC9EpXHcKJbSRLEEm0p11OoRUxOo1+aEi8Ed09FOzlwmj0Iyumsr37NQ3Wi2wrZ6h+sVqRgajLJAtuqPFpJiRvVKJUJMJTg2ZmnkQnfz5O51BpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAw6aH0zPo4YrDfsW7Mz35nUyx86Z76nqlXQm8luP0s=;
 b=GjY7sALjXDpIWSaunq4e6Yx8AYbzMguOVgOGGCqCxtmV53GULSvsuuHGnnX1JXiYYT4/vQQb3l1PHhAXj1eWv96LRWp7dC0mKlB8wndQt3jgPF7RV/h03w64s+MZ/Ow+emXEuMfNNwegI1ucUWkKkL9wEPHrXV1Jj5SUojzUX30=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:52:00 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:52:00 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 3/9] net: phy: add kr phy connection type
Date:   Thu, 26 Mar 2020 15:51:16 +0200
Message-Id: <1585230682-24417-4-git-send-email-florinel.iordache@nxp.com>
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
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:51:59 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 477eff74-8442-432a-ca68-08d7d18cdb6e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB427276F89FDD1865287C0976FBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nhAao0CsR/ePouUm7vf7krAUr368yxmZLeHNSkA1KHUVsoinNscDG2kSjTABbA5LJKBf+/Tn0w8/vbHh/2nwZ3Tb+NI3hWYvrPyn80WocaKf96ZTXDcM/Z6iL+cVhEIt3Yrb9vEuyUdbGlCLEbIINgUsoZ0sfduUANyDb/1i9PBiFj7ytSkNi9O8DS6yqkUgQMTkGucU49Yrr/uyzjT60GICG2S8btV+HpeCdq2K/uxOiV6DSNiw45VvoOcNS6HxSu0YVTxzFcfpv/2qn4U//gXQa+l1J6Z9qq3Py5bKEnQ+fo0WPo5CDjqf1EHocdsUJmqcVTvh6Jzf8JVTI8jeJ9fTHCKSSDdXAXSbnCFJQ0i4y1krTSC2n64PtF5lD57A18LON9MShs/wxa0JfWc++7Jd7mcqh3gD+4ixYg45MsGNEzI6hdARVBlLDtb6/1HL
X-MS-Exchange-AntiSpam-MessageData: eT7ZPghrRWfCCPfU151RrPixd2yzeh6mOsRxWG6mkVrtxa9OSye3rDRpzduwvwxV17SV5Fu7fKEXdPJjaT86pk4JH9GxAjHTqNNn9qkmnj76quFWPXsRzoPs5x7C0mibNsn52j4n+LXlnCnpKKkr8w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 477eff74-8442-432a-ca68-08d7d18cdb6e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:52:00.4621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJwDWkO2RWuy/dN7W8az16cp526xLUfa8cAFX0MmO5guLWczAHU7bRgxsMXK9pyzSRBh+Ilojx+hILkPcx0dS5zN0k7FqFgDmwug+oXoUfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for backplane kr phy connection types currently available
(10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
the cases for KR modes which are clause 45 compatible to correctly assign
phy_interface and phylink#supported)

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/phy/phylink.c | 15 ++++++++++++---
 include/linux/phy.h       |  6 +++++-
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fed0c59..db1bb87 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -4,6 +4,7 @@
  * technologies such as SFP cages where the PHY is hot-pluggable.
  *
  * Copyright (C) 2015 Russell King
+ * Copyright 2020 NXP
  */
 #include <linux/ethtool.h>
 #include <linux/export.h>
@@ -303,7 +304,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			break;
 
 		case PHY_INTERFACE_MODE_USXGMII:
-		case PHY_INTERFACE_MODE_10GKR:
 		case PHY_INTERFACE_MODE_10GBASER:
 			phylink_set(pl->supported, 10baseT_Half);
 			phylink_set(pl->supported, 10baseT_Full);
@@ -317,7 +317,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 2500baseX_Full);
 			phylink_set(pl->supported, 5000baseT_Full);
 			phylink_set(pl->supported, 10000baseT_Full);
-			phylink_set(pl->supported, 10000baseKR_Full);
 			phylink_set(pl->supported, 10000baseKX4_Full);
 			phylink_set(pl->supported, 10000baseCR_Full);
 			phylink_set(pl->supported, 10000baseSR_Full);
@@ -326,6 +325,14 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 10000baseER_Full);
 			break;
 
+		case PHY_INTERFACE_MODE_10GKR:
+			phylink_set(pl->supported, 10000baseKR_Full);
+			break;
+
+		case PHY_INTERFACE_MODE_40GKR4:
+			phylink_set(pl->supported, 40000baseKR4_Full);
+			break;
+
 		case PHY_INTERFACE_MODE_XLGMII:
 			phylink_set(pl->supported, 25000baseCR_Full);
 			phylink_set(pl->supported, 25000baseKR_Full);
@@ -823,7 +830,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy->is_c45 &&
 	    interface != PHY_INTERFACE_MODE_RXAUI &&
 	    interface != PHY_INTERFACE_MODE_XAUI &&
-	    interface != PHY_INTERFACE_MODE_USXGMII)
+	    interface != PHY_INTERFACE_MODE_USXGMII &&
+	    interface != PHY_INTERFACE_MODE_10GKR &&
+	    interface != PHY_INTERFACE_MODE_40GKR4)
 		config.interface = PHY_INTERFACE_MODE_NA;
 	else
 		config.interface = interface;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 2432ca4..d7cca4b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -6,6 +6,7 @@
  * Author: Andy Fleming
  *
  * Copyright (c) 2004 Freescale Semiconductor, Inc.
+ * Copyright 2020 NXP
  */
 
 #ifndef __PHY_H
@@ -107,8 +108,9 @@
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
 	PHY_INTERFACE_MODE_10GBASER,
 	PHY_INTERFACE_MODE_USXGMII,
-	/* 10GBASE-KR - with Clause 73 AN */
+	/* Backplane KR */
 	PHY_INTERFACE_MODE_10GKR,
+	PHY_INTERFACE_MODE_40GKR4,
 	PHY_INTERFACE_MODE_MAX,
 } phy_interface_t;
 
@@ -190,6 +192,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "usxgmii";
 	case PHY_INTERFACE_MODE_10GKR:
 		return "10gbase-kr";
+	case PHY_INTERFACE_MODE_40GKR4:
+		return "40gbase-kr4";
 	default:
 		return "unknown";
 	}
-- 
1.9.1

