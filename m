Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3A731E5A2
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhBRFcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:32:04 -0500
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:55526
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230380AbhBRFaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:30:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYHyXlDwxI/pylN1ZGW7zvEwmHyLGybX5Mti5bksPbybuCIjOuedQEifn/4GZv7WuTfZY5wUksI23gpJ7DB6+tZthqKp950LB7oHWZqm9FIZE3ZUs+XG6PQqADLZggZz1PM6LtrXbcKjHwLOweQWj1763cTAOnsi/9PNLmmAaPOAvq6gGoAhI2Syr//LpycmVxDUoVp/Vc4U3XETHaAtMkr5wYsVM7kybjOMNbZG26gnWmSPcV9/wxmOUcsVB+qbLWgexnynvlHDj86NqSPT5vPUD9/YCuzNFaGiFoMb4M+44YzPbEfQkFCcz15/oC6WR5PZyqcjHX3yf1iC0PPxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bw3WU28kazDnkrM6BXLcnnpg4zm9KvcXi98KY3KnJbo=;
 b=gNk+y61iO+yCAbd1oT3LGLyU+Zbk/xT6HZ4kcQJWCTdxBJkzQYOR8VRNyy/3ueOvjb/Ig8lwoKg3PPBB7MJGFpwkUqdDfQHJyve3TxBnUHnYqtkJmph7VUaxkxeynpSMUmkAy9Zflu63ONHBogFuZ0D1FWO5CAf2LlaY4ZTrRdMl95P625fV2RDX1R95kNpRpF3KAwOF/o/TCT9t8Z8tZJQ2JQFE0gtdyH3+4UyABWRHSMNceaGkPq6mik9Jr/y9i2k0RP6P5K7Nuoqo6ZGTupzPQZAk04hbom/2tt6reU4a9gtK6DohNnjZZPP8VAFOvaZSrohcTM1SF1MJFdfi9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bw3WU28kazDnkrM6BXLcnnpg4zm9KvcXi98KY3KnJbo=;
 b=IYBtX/UJGtRnxZGKzDh/Pqn9ND852Eo9MjSJ/9abP/zJNqcZ7lIRxbyS1Bf87TXaVlfsEmwhAAj/qNFLbJZ8S9Es+Ev+HDEL9HSBGyJ1T4jvii6v7Tutc2FKYolQKpvSdYaOlF5vsOHWtRDgFsYGRI6SlY4eC4oquBidpwP3yFY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM8PR04MB7730.eurprd04.prod.outlook.com (2603:10a6:20b:242::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 18 Feb
 2021 05:28:22 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:22 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 08/15] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Thu, 18 Feb 2021 10:56:47 +0530
Message-Id: <20210218052654.28995-9-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:28:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f7f83195-0459-4971-a045-08d8d3ce01bd
X-MS-TrafficTypeDiagnostic: AM8PR04MB7730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB773080BEB8B5306C47043C8FD2859@AM8PR04MB7730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LHYtbaYpEn7whOdUgBmaPiaobIijlhArLZraBOiiBZOh9OPyBxPMzYUaKNn490zvwwmKG62CAiUKOsTBF3sdxgS4jmBtG4i9EZU/hbXrZuEiVWWHox6wO+NrcnqV04zn00C/BPiasd2c0+up0f6YMSVtiaI0J+bOpBS9qZ27QG3oO20LX4bxPbNoCMqYyzKjT4DGN3o1FWvpj2IIRamuFxtCbMc6WkEmM0VM8Qcd9OOc+ucZY5rUqtdTEP4oGhvdcG40QhLhUZfkOeOVoit7WCzxqNCZd1Kx617kcedVYO1AkG3if+51lPEA7aw5aOBwIcWDyXA9Zx0BsQntXxElqh1BbHGH4G0p9dNnCOFgNEtb9l9AtkSGMn79D6FWRZMbzfmKNFSTOy2HWkuoKbd4MoZq2aoJojO+ru+/EYbu9siojbS42rS9VMyUYSsHMP/HWsxFp0C9tRtrXRvi0RlmrIdKFoeYHJNgD7aVrHBWcNdnSKw+7++/XuhUsVmG7ZGZI/VCvk/t7QvoSLohWB/wlH4VhLF23xhajEaeGKsBGDHDRl7SednhfXsq6SVsuPPubM5ENbwaoqaVTq1otRqGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(26005)(8936002)(52116002)(16526019)(921005)(478600001)(1076003)(6486002)(8676002)(55236004)(83380400001)(5660300002)(186003)(44832011)(110136005)(6512007)(956004)(54906003)(316002)(66946007)(2906002)(2616005)(1006002)(66476007)(86362001)(7416002)(6506007)(6666004)(4326008)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?35ahNdjXgKF81JBMpKXbuFDB8jBJ6fjFIXoOTVmj1iBldqFcRoTwZI+VZgL8?=
 =?us-ascii?Q?eaQ1EHZ8DqtjRPZ8cCI/IG1gOnXPCJ73E/iS+/VhUmVvA1ckxDX9ofDCsNDY?=
 =?us-ascii?Q?BmaxmP7IHrEbSl9sNhTAo5/gzGcDLSPwxZ3OlNS/6yhHRNFogT+LPzBuuWWL?=
 =?us-ascii?Q?eKzTLp9A6lpGP2zvGpFXiSwN5ByHvy6z2zYBIcFkb6YfzHdGML7IqRdEZCvi?=
 =?us-ascii?Q?JygZJyWKnVb07ctkUmMmsVhsBiySy2DAT4Qr+9mcWIQO2Bg/yZrSjxPYv1f4?=
 =?us-ascii?Q?fMEi1v3sk+2CTbJnyPbkvrogYY+RCIOErr6BxJolR+2GjT567dBfvgFC83ul?=
 =?us-ascii?Q?pAvDHdoCw1Qip3+LfJ18mGNntaIH+Wm2Na/CvIfYQUKAqk5d53c4xwvJwgRw?=
 =?us-ascii?Q?YW4oRIQ/uHaGsj4Ihr9mzOMhtESpQViggQcxgQiumbKOW2W9TKbisAzk1M61?=
 =?us-ascii?Q?hNTdgPe64qQal1jTCfJSTx1UWrCnQnNZy1Fi0tGl9D6ukwB1Y+mrGjO/MOH6?=
 =?us-ascii?Q?y87Gsu9jLHhZKOPPrhQfXpY3svqcZ9pBjNo+73OFIZm6MSLdV3N3JbBMQoI9?=
 =?us-ascii?Q?G39L0GJb02LpPBGyj4fL4fNXWZvxs9SOTk7TCAS7lKN67KSk8T3qFbdzSgun?=
 =?us-ascii?Q?MIx5w1V1smaUiSNf+FekLc5E/Afcoh7gJELvRltUCQJfgFvAFpOGTSD8d1Kx?=
 =?us-ascii?Q?5+iZlpkiLCETRXgjZvTaawtdjQi1M7thH3yTNWq5xB8CLVYBxZyV/TOafNXH?=
 =?us-ascii?Q?bok1TX7UZZN4slat10CuQEacuxV4VFtVmDS8HSOJAMWBq/buXuX2ilaxsMsh?=
 =?us-ascii?Q?JdeoGqONKXFY+dArNkuAifxruBYTZDq0RJ/Vy9ARGSPyushecg2G2JBkA5/U?=
 =?us-ascii?Q?mhEcqgy4qD8TO29CfwLnUR/aUMXMUG3gUW9x6mT7CxBBlgXZjbMuFKh4RNKq?=
 =?us-ascii?Q?e3bmz4QFJao+00NPX3azb2fMmMZtOtj9Tz9eqSwdtyXmt1dxHZL0FltVCX57?=
 =?us-ascii?Q?U9ySUBxH8usk9hsQ93aRqaok7Ff58N/zNG3y/zpmwFU4ZWl1aAM+KyMltMfn?=
 =?us-ascii?Q?jwLmNgpJqiU3LoSHktVMi70zEHdHxud60CkVNDN8lDkYNViIs199wesNJscE?=
 =?us-ascii?Q?4k3B0Vm0lTvAI1PAmoOMV2qscSp8Yxwr4jsVvOxhpkW412ibijlZoSgEj//F?=
 =?us-ascii?Q?LfV1hppS1HAhYsQ3qUfsRVm1KwE/rqQzw/M0FK7SEXWhLmaeT2G0OziEWPgW?=
 =?us-ascii?Q?hpGO7/yCFHuDZXgfjj9LcJktw8iXdtXgFXlmJH2PiuGVwVyM/YNln41dPBvb?=
 =?us-ascii?Q?EHhuo98nrvJJMFIhZEZXQr4z?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f83195-0459-4971-a045-08d8d3ce01bd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:22.1392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYbxxXjsszG66UL39wzhVIJYJkX5VGYLIf5XWH3+ZtBsMNoBjE4DtIeF0hSQlfdrFH6XjbBrxeVv6QUMY97MPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7730
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 40 +-------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index d3f7f104f1ed..a0d804cfc1f0 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -98,45 +98,7 @@ EXPORT_SYMBOL(of_mdiobus_phy_device_register);
 static int of_mdiobus_register_phy(struct mii_bus *mdio,
 				    struct device_node *child, u32 addr)
 {
-	struct mii_timestamper *mii_ts;
-	struct phy_device *phy;
-	bool is_c45;
-	int rc;
-	u32 phy_id;
-
-	mii_ts = of_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts))
-		return PTR_ERR(mii_ts);
-
-	is_c45 = of_device_is_compatible(child,
-					 "ethernet-phy-ieee802.3-c45");
-
-	if (!is_c45 && !of_get_phy_id(child, &phy_id))
-		phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
-	else
-		phy = get_phy_device(mdio, addr, is_c45);
-	if (IS_ERR(phy)) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		return PTR_ERR(phy);
-	}
-
-	rc = of_mdiobus_phy_device_register(mdio, phy, child, addr);
-	if (rc) {
-		if (mii_ts)
-			unregister_mii_timestamper(mii_ts);
-		phy_device_free(phy);
-		return rc;
-	}
-
-	/* phy->mii_ts may already be defined by the PHY driver. A
-	 * mii_timestamper probed via the device tree will still have
-	 * precedence.
-	 */
-	if (mii_ts)
-		phy->mii_ts = mii_ts;
-
-	return 0;
+	return fwnode_mdiobus_register_phy(mdio, of_fwnode_handle(child), addr);
 }
 
 static int of_mdiobus_register_device(struct mii_bus *mdio,
-- 
2.17.1

