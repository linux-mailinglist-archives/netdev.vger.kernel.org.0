Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4695414EFA8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgAaPff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:35:35 -0500
Received: from mail-eopbgr150074.outbound.protection.outlook.com ([40.107.15.74]:33723
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728922AbgAaPfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 10:35:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m48LX7QpskF3so0AZVwkIVBMcr28ZKWuqzsQ90Qh/U5+r+ILdOkVoFnALJaIhIWuip2UVrYAtffncnhToEXGutTk/JXikvB3PRs+sEBfsNMgcDlio43TGJpYM8cfE44blLEN9x2XymjKRMRDhkVjyvGWHCUJZiKiee1yitTrfejv9DOHzM/JmsyVKh7GE/3JPPF+kOpnbeHrSzsaSUK7I8MetOcb43dvRYVkPV1bNKdqxAB8dE4aLZfXGofSi1dbrvH9SrC7VBR1OsDM1UdovvGybDQSvlJN9OR4M2+jyvy/GYKGyiWCNWE16+jlc704n/V8DvgrfZuPbLMRbXYs3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTmvw2n9wtw5saaaH5VE2XOgOO3pO3uGIHHnovLbs2Q=;
 b=ACu4u46ViQBU7LFYIkqypNCShwAQjAdSzBwt663y3HADmT7+RtvfkTXO6AlqBhJq1d3InjyJS7ZgEXqiVtCrA9npyx2pLfwj1Po07H6OsAYlbFB4gJRicvZflsTxaYLzBdAZr6Ib7EaVFaQmerizZjd5+uRVy0WS35DYUBJxL5nZHKn6dbKli95Ml1SLFOLzwLtE7DCi0eEdOiV8gw8vDD1eCPptirnUNWBm+f0E93MuX8FzqYUUBk+IjjLyQG07JpPuyTtqfGFLhELVfEQvw+lQfGANpQyUVSd2xkpcMYh16zlCoS83FREl0jIfUgNodIufDs9vpjQBsjAa+BPANQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTmvw2n9wtw5saaaH5VE2XOgOO3pO3uGIHHnovLbs2Q=;
 b=IgCnNWswO/NZzI2mVr3vYRxjFpbZ1oo3Jf01iLN+D7cchP7NKlcDuskaK0PLbplB4+EYfHDjP7uEBe85fwB/OnJNpfN0urnFf82DTjUpbEhMZjQBkiXFJaV7dmNkpZh8Dzoqrphaic9dsW2UTYvu1xChTnjm828gGpr2FqaeFhg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@nxp.com; 
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com (20.179.10.153) by
 DB8PR04MB6730.eurprd04.prod.outlook.com (20.179.249.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 31 Jan 2020 15:35:31 +0000
Received: from DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef]) by DB8PR04MB5643.eurprd04.prod.outlook.com
 ([fe80::e1be:98ef:d81c:1eef%2]) with mapi id 15.20.2686.025; Fri, 31 Jan 2020
 15:35:31 +0000
From:   Calvin Johnson <calvin.johnson@nxp.com>
To:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        linux@armlinux.org.uk, Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v1 2/7] mdio_bus: modify fwnode phy related functions
Date:   Fri, 31 Jan 2020 21:04:35 +0530
Message-Id: <20200131153440.20870-3-calvin.johnson@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200131153440.20870-1-calvin.johnson@nxp.com>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DB8PR04MB5643.eurprd04.prod.outlook.com
 (2603:10a6:10:aa::25)
MIME-Version: 1.0
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0061.apcprd02.prod.outlook.com (2603:1096:4:54::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.29 via Frontend Transport; Fri, 31 Jan 2020 15:35:27 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e2276173-892e-4593-2fab-08d7a66334dc
X-MS-TrafficTypeDiagnostic: DB8PR04MB6730:|DB8PR04MB6730:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6730A10E9A0155C81AEE432893070@DB8PR04MB6730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:446;
X-Forefront-PRVS: 029976C540
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(52116002)(7696005)(1006002)(66556008)(66476007)(2906002)(66946007)(8676002)(110136005)(55236004)(8936002)(26005)(81156014)(81166006)(316002)(6666004)(478600001)(54906003)(1076003)(36756003)(6636002)(6486002)(186003)(16526019)(5660300002)(956004)(86362001)(44832011)(2616005)(4326008)(110426005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6730;H:DB8PR04MB5643.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AxNB7UktrkaNWw3oBJYBCAx6YEsXWJ83WR7ykL264LHTud/ydYLvFrcMm6gTkYJTtDvCdYHpgPAk/f7V5M5ImrkH7yfZiKVvgQq8vtkoInr6HA5VwKhvscRcC9D6VnZNi8tDx6lsDxcCPI5bUBHocuxYiMY9TRJWYNVQ2oNnBtxiSdeH+rOtZkr+AVcG/iZjwANQuep0DX4hn4bSTy/Epvrtckl8CE3/0kWqKHNvSyoi+gpiZB4If/mckDcoIYw+f+6NnwQjpG5Btf73I6Z/4Sjd3BnQlXpmGY190h5almZtnDCqWdv86R27UfzRMwUepxFEVJmvc7cgcyuO/D4H7v9oGiyP1ulrgaSFQG2oHLHWJPpJd5fNNgCpVXam9CxIVX6jwjqDmJg8r5MPdJFIwZC0Cb4XTmn3T1VCMEy5oO4MeR/bUbh5ZXBB/La+z0c/hdhZvLnaY4B02GriH8N7HKpVlfRqKXthiNnLwLbo+mdefi6kN/agjdwsFHCJPNwQaZr+DMotDGxWitxW1Fj/GH4TbbFMPpdsyPSYXldcPVc=
X-MS-Exchange-AntiSpam-MessageData: C0FladfhhnIZcNalFiDqlYniXCtMWQ3Ti7YTZi6s2TP/Pue6ypHWXAzyTvOlBxA1N1+k2QOVBRrDzZsPIZDaFS2j9BTIFP9rsCnHweb3LqWKJcT9n/mWnop143hh6X22pmB8itZ8hhReGNgZg28vig==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2276173-892e-4593-2fab-08d7a66334dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 15:35:31.6772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/F26sw14MOU9/3TrhPd4uVQ5dC75vVt2yDTt4ynioJt0ae+4u4IuwT6cG+wqdCquJLMNXBoHl/oajHgq9yKWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Calvin Johnson <calvin.johnson@oss.nxp.com>

-Add fwnode_get_phy_id to extract phy_id from fwnode compatible property.
-Modify fwnode_mdiobus_register_phy and fwnode_mdiobus_child_is_phy to
get the compatible string and process accordingly.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 drivers/net/phy/mdio_bus.c | 58 +++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index b1830ae2abd9..d806b8294651 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -726,19 +726,43 @@ static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+/* Extract the clause 22 phy ID from the compatible string of the form
+ * ethernet-phy-idAAAA.BBBB
+ */
+static int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	const char *cp;
+	unsigned int upper, lower;
+	int ret;
+
+	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
+	if (!ret) {
+		if (sscanf(cp, "ethernet-phy-id%4x.%4x",
+			   &upper, &lower) == 2) {
+			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
 static int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				       struct fwnode_handle *child, u32 addr)
 {
 	struct phy_device *phy;
 	bool is_c45 = false;
 	int rc;
+	const char *cp;
+	u32 phy_id;
 
-	rc = fwnode_property_match_string(child, "compatible",
-					  "ethernet-phy-ieee802.3-c45");
-	if (!rc)
+	fwnode_property_read_string(child, "compatible", &cp);
+	if (!strcmp(cp, "ethernet-phy-ieee802.3-c45"))
 		is_c45 = true;
 
-	phy = get_phy_device(bus, addr, is_c45);
+	if (!is_c45 && !fwnode_get_phy_id(child, &phy_id))
+		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
+	else
+		phy = get_phy_device(bus, addr, is_c45);
 	if (IS_ERR(phy))
 		return PTR_ERR(phy);
 
@@ -835,21 +859,23 @@ static int fwnode_mdio_parse_addr(struct device *dev,
 static bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
 {
 	int ret;
+	const char *cp;
+	u32 phy_id;
 
-	ret = fwnode_property_match_string(child, "compatible",
-					   "ethernet-phy-ieee802.3-c45");
-	if (!ret)
-		return true;
-
-	ret = fwnode_property_match_string(child, "compatible",
-					   "ethernet-phy-ieee802.3-c22");
-	if (!ret)
-		return true;
-
-	if (!fwnode_property_present(child, "compatible"))
+	if (fwnode_get_phy_id(child, &phy_id) != -EINVAL)
 		return true;
 
-	return false;
+	ret = fwnode_property_read_string(child, "compatible", &cp);
+	if (!ret) {
+		if (!strcmp(cp, "ethernet-phy-ieee802.3-c22"))
+			return true;
+		else if (!strcmp(cp, "ethernet-phy-ieee802.3-c45"))
+			return true;
+		else
+			return false;
+	} else {
+		return false;
+	}
 }
 
 /**
-- 
2.17.1

