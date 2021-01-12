Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381BF2F3201
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbhALNnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:21 -0500
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:39271
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732511AbhALNnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LH1nhfvt/92uKEn5Kom68t9D6KlS9foh0jIeWk7yi+M5TtB9hPXXWesvjzcKPLLZqCjJET5JedoSRm0ag2gJwUxUFzGcIInAqPDvGb8ezxRQwrgUk4b6Eaj8uTKDQYklnkoLILeBrEnrPif20n/FG8h8YbGiCzJfSEPZ9xMO4X41ObpF/B6YEe0xN6NJuCN2vUyjq/LgV4Fp5G9MQL7Hwziu/+R0SAYGSN1r3CkzilQUoB3koMh831vdkcb3MFH20gZVKfg8/Bl3LRLRR2GUdBtYJzBMcsRbEqTjQmS48pFh1rktmoyuB3JK2uvA6mP9P0ffWhfe1FFYsoMilW5CQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gp8+C4+GyIcKgNA/yl43KwX4z7y6gjRWwU9ttMhRdjI=;
 b=l3xNoINlkE39pJ681rAcgA/0m1nnB76N4K3T/fXNUtqyAhxcaAKByjCiYI7h7rEHWO+2OdZjpkGAhuCLlzi3HR+hNNrsKP2x0YIUDiCWQwKHssDLL79ttjLTP323kmV/WOhLpJTxsWjG5gxuQFvdV8rG3xWEqPsWMKnvI7UBAIuu4Hyu75dOVKFmpMddwp9KGoWFEugGhQ6EjVBtiyRJq+BtjW6w+5V5X/QV6MAwcOrPMDIcMdLjh6Ro11fV3MJJfvVIGMu4ImG9+vt37LCCv2DxXzKvru3U651cvFSM7yNdEQwSWicB5enqAT+dI90eEOo4hGm9RlGh+orOl+JhLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gp8+C4+GyIcKgNA/yl43KwX4z7y6gjRWwU9ttMhRdjI=;
 b=mXgiZMnBbxo3FMU53Arlz3Z9pKWbkG9z7aZxCBB8jz8hoErFHmkNpkfz0k++mBnxzGVj+yPB5Gh+I8KqtZ8/4pUqXtMQFeST94H2T+YriKNa74u9Rz438sO5q9B/ByOewuToWUX6chsQF/gWg1IiyiUQM+2hsz6qBQk1CkAjRng=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:42:27 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:42:27 +0000
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
        Jon <jon@solid-run.com>
Cc:     Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v3 08/15] of: mdio: Refactor of_mdiobus_register_phy()
Date:   Tue, 12 Jan 2021 19:10:47 +0530
Message-Id: <20210112134054.342-9-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
References: <20210112134054.342-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:42:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 670108d2-e047-4305-07b4-08d8b6ffe6e2
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34434256A6253D4CAC6F55BDD2AA0@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e+0TgMcgowGRWj276NL9kifU200Qi2aYgIeV46XjeEUARyL6htWWXfB3LaR+8sR7aJrzqo8m4NrSEy8plgqpFK7wQ+p2MpE7abIb5/459wWurHCIKOacLT32o+tHWncqytS15aU9HQrOm9ErjPMc3c1c9ZDZRZTaPblWBexk6bAWBgTev1Uo5jea4LmQJ7VZ9tU76OanYxcPLeZ9qSZOZoTwGFx9oXnEqKPCX/MZsFw8PmRgbIBLszHag/tcj3eRvDJTt6AXX8FH6tPpqU7dDodzznA2vzwQMgtOcWj10afvIJcdol7tFivTCRB9FiuJNtMc4SXdNM5aSxFkALuOuUAUTyrtkN1MdhHG9v0H8f1+Et6b3wob9ZfBm2WsTsz/MzLJ1V2CVRr9ZVpBxAXTlnoowqQtgMhc0RxeD/EGLI5ldmVTxbGdMlNqaLl589Su6zD3QxNNQxArwgO7o70qGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(478600001)(1006002)(66946007)(921005)(110136005)(6506007)(54906003)(16526019)(83380400001)(6666004)(52116002)(2616005)(66556008)(66476007)(186003)(7416002)(4326008)(956004)(1076003)(44832011)(86362001)(55236004)(8676002)(6486002)(6512007)(26005)(5660300002)(316002)(8936002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XptPvauEbP0x5ldR4DLV69MZtG+X6DRwE403T56rob6HxVTAWEIw8j+HArP2?=
 =?us-ascii?Q?JDam8TSfCgcwjXhq/+j6c+HMFeHjiI1/7ZqdCDSqdg0pDOiNhI36VLGEmTJP?=
 =?us-ascii?Q?3gwyPKvWLE865MayA3DdJ8oTfcBQX+wv/befnyN4JSz6yQPso40QwFOoZni/?=
 =?us-ascii?Q?oa5J53PUncTtnztoGds1MfQidNwdJzYyrLV2WPvUbUTzQ8CoJN1p3NqBDPNo?=
 =?us-ascii?Q?Yz37novEXJIpfu6y+0xvfAL91n1M5X55qQtmoTvVhwUeKfgm1jpn9syWFb9P?=
 =?us-ascii?Q?MGFdYp0We41JS9OmRNDggDznWsZ77Fst/RD96d9xM+ay2TLuRluYCgeOVUAK?=
 =?us-ascii?Q?T1FdkWCJ49rijcX2IJy6kgXkNdKVq50n6kBIVySBlw1P2RYd0oK5EUsL+aEH?=
 =?us-ascii?Q?okUPfPepqzxOq0bL2XnhF/p56OdAwKm38h4I4zk9164lf1gw+Hgj940fg8ta?=
 =?us-ascii?Q?71G3CIhBdyeVMGcygX7Nd+NzFodHC5EoiOAp64+YLRHwlQ9dXH7joMsMfQZO?=
 =?us-ascii?Q?yBgWINLDaQxGX2T8s8HD4pcimZHI2uIlGDaxHQ2yswt839B6U5Mbol0zVjW5?=
 =?us-ascii?Q?DwF4ZwGcWDU1X62JLmWBR4zQqQ9rE6MpVJ7xK3StnkxYuFYVj21Z0GTXiyIH?=
 =?us-ascii?Q?qJ94blYoJ4AvsAnLJwhYj3/JCBpS4JLh2rSy3miPs2X82rcHdXFrl5wkQtop?=
 =?us-ascii?Q?vnSA51J51x73tlE60ZByteEAgZWctB0oHouQ4KY62hafOcEngMmTy+rp2lT5?=
 =?us-ascii?Q?T5j14ZKS+sE1isGMsLOY+nfUPK2NdWRAqnlLR9ghEbgZ3r48H0m+DErde0VI?=
 =?us-ascii?Q?O40n0xgKuPS7DhfEe9md23TF/NdQPwHZPAfJcd+zoVlORev0S0WM7ZL5jsug?=
 =?us-ascii?Q?hrE2td/rDjwEj8BENrnnnTXhgeT1Yj2rwnIBWfbsGDInk88IA1GouWmZXrMF?=
 =?us-ascii?Q?CeRkTY7APDEkWv2WonQvaR+Hr75dx066pQF0T8xBrR46lfkd2BebCqhTr2sK?=
 =?us-ascii?Q?Q3P6?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:42:27.8494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 670108d2-e047-4305-07b4-08d8b6ffe6e2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUQkdQTVh4q3U3pR2qjbHHzwxZ9jRKvA0uupwp539/ilqkI0dKP81hz6Kw+IZZhn8DFUPS+8Rz3vdXolNVCTWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_mdiobus_register_phy() to use fwnode_mdiobus_register_phy().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 40 +-------------------------------------
 1 file changed, 1 insertion(+), 39 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index cd7da38ae763..1b561849269e 100644
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

