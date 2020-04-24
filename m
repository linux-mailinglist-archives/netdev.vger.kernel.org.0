Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB6B1B75CC
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgDXMrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:47:07 -0400
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:26784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726848AbgDXMrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:47:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imnb4/HmUNQkBWrGgV8dKtVu0Se4GMfUuFt/qjSVoA6mNOcSJLXkQPau4qoOzrNQS6MXfDN2th/4JeG8ZxQjywHObbjgL6XKIdcZN9dqnqoS1v8a+5sZBS62wF7E3eVm7qxkc8joGO92Y0NIPLrESCGwY9Y3SPN4fG2KLtTdbUBfCuXHqwBFLDAsXorEbWBn80JxLOt9SRb6YpvK+TSsyROREW9gGby+DifNXp0Fu8K0nHQJHIw1pnxFZvgAKQjpl14v7DFVxBC7GjYLNgwDQq3H06NtfQ2vJO+sdVpNI0STjEp3nAOM6STjnWNHo+3AXaE5+T3Yb+e9tI2u1miHXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhEC54kSZvkU7Tt1DoTwvCV1Uimco530U418NlM4X/Y=;
 b=AlG//4HqSoxVAdPA8uDq6lG0/0FPVicmfP4baeHHT4sFnCDeMO0v4LqMAkk2yihxYQCO8CisSQqWnMfpYGtoQE2kodXKFKIXk7vTQewu5MhyaLB6ZSSLeWb5dTogiG3BwSjMmbBX9pRBc3ukGoU3vBWvV9t9QnijOb0IcGpur5umi3Q1uWbRsr2q3WpkgSt+KDnjZeMk4KoocVXPaWjgCYq8l7T9qiT/GXcl9obs5Mqcil+o355oiF4cyIfem2ThQKcg2gmRAJNAPp2NemmQ8xlo7SLMqv2Ynq2Mwnw7WE6GUOxdicaddMt4GKOiHiQh4it+D6Yb59wFM6QnUcfBYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhEC54kSZvkU7Tt1DoTwvCV1Uimco530U418NlM4X/Y=;
 b=VnoDlLr9ltr6fpfsl2ebSfsHeBaIIfHtBQWNV3xJGRldu8YKuGOJ8WvSwj6ZYZOL2swVsDA2IFyNMjqNQKRscqJyw+/gBLP2oUYVvrbChlV3i0jGHv3wdegrQNV7XhIjWqhRP6muTiR7Vl+PfUG7xjNGmR9HqzTk7Ny0wsIdCks=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:48 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:48 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 5/9] net: dpaa2: add kr support for dpaa2 mac
Date:   Fri, 24 Apr 2020 15:46:27 +0300
Message-Id: <1587732391-3374-6-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:47 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3967382-32f0-44fe-f7e3-08d7e84d8dcd
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB59372AD25748BD1CC765A0A1FBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MZvgVMBMgTyK1WuNxJAQT3T300K06J/7GejBVYuGg/eoWCE+/8X3Euyn4cXuMhw1AM2f7d/hwVsffg2W7OPA5Knsrn4JCQDW6GblNUBXOkifmZse6hCbEP8CxHzOEKE2fbLydtsX76C3qOKoeK5nxhU14Ue73KA0iFYnayi8sPKFuDmGWKepQbf3ThWgsbKtsqWjqEIemsYFUBmQWFppetaRNMwuu2mVW8fEUmR042Ac5v+KfhjuzrC3fqU4PFl9LJPOKF1zmBYicBHSAD1hmDUWz6fiAMRfeBGPrVpBklVSuxym4vSSVJomqZQHruNOV1K9Jms1VwaauxRCLYT7J+e+V84s9Fq+4jNfILFqELtwBEO4Wvjj8HlqCMsm3lQfpw1olO1gvSk/9oWDpqzuZ/PNeBFUswOh7S2KdA1Qb55W75aAqfEnKUOCHV+g6c+
X-MS-Exchange-AntiSpam-MessageData: +sCfk7X/UZGWQmXPQWg1EOkd60neVcjGFI6l8buRsI5fzhFADVbwb5RCWOMoUR9skvM+Vtbignfh+/d7bHI2XIwNykvNLKiivRU/DieTBM+CIj4JWQjSxrM3ExlxjLPQrb9ZK7x480Pj3Axr1w5NvQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3967382-32f0-44fe-f7e3-08d7e84d8dcd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:48.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1yx2rvyIInCq7k1eoW0pcPOeN3KCNFZppTNeXJuNO9ucyEQkys/fcQc7HNHt5sTODZ3PxZzm2iMafCPAGtmZQjbhjv6+iFFO7xz1DaF2DU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add kr support in mac driver for dpaa2

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
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

