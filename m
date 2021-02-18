Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D78731E5A5
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhBRFdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:33:09 -0500
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:24352
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229594AbhBRF3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:29:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lspK+Pha5cKSGFsp8JMvvPMYbyFeIGvznp3nW9Zv1kUcS+EJ84MsF7Oks0i1rthnVGYE/PfZcEhbr3N6/d49MA+wycQdMO1551iDl8k5GS5knsEexYXU8aCmu26HtogaQN8VW8zEQ7YJg8zYwbt+j3h8NlsGX467pqqbdUk0Ytn4Skw2OWvHNp2kVhKLUwql6UEC2KavRBI3KS6jYsuTisxrmZV++XTicFi7xV5BVqL7Mw8b4d2qzqv4a2W59JhsLdeDuoL+JSwPC9M8s7VVlfDit8ea5CMj3Npvn/3LeS0t2daYBQ4V6plx8WX+GULh+tkIbDWOxul26I47Je88Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hJLB304LdQ/4Q0axIjEskvifwLDS0QY8l75kFdPAwo=;
 b=jzWiVG29U+wjoKqrR9NI+W726HG9Nbxc/vpN4SsmejtL+VToZlOmbe99CN78bwIrDMR9IZ4Mb9XAkPDeHSzh+RoUa152hUXXZZZQA/me0HkLo2REfBoW3mv07Mg/N6+fSo+adRAfmSduVnEnhoyXRrL93nWNqYy3JyugiXNajr9pZq3lSA1SSbr1S3XHHHkmbmdV/b3e14BvjxOCB3s4sjf5NpKZT6l4dM7HBwoTWdJ0yAbVyIVc/clV+tYHIAW8GZJBSWYyNTryvaNJloYB25Aum9sV/iQCp+Skjhso2KoOuq1k3ksDJGT7qeskizuwi7c/W6kMXpAL6lO3zov8VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hJLB304LdQ/4Q0axIjEskvifwLDS0QY8l75kFdPAwo=;
 b=VhfHvbClcbK84JincCuc/+EbW4QLcYrz8ZCTaH1k/Mt3S+C4zOVHBU8AhSqIPHtXBeL4vlmr4luQpFu7hTzPfRoBd8vRJZirQ14BTyUOr3dEG6hIizB/Z+wsWaY6z0Jy0NwCvhXBazafMQue6uJSD3JZUmnhybKfjuBelF5u4Vc=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.42; Thu, 18 Feb
 2021 05:28:00 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:28:00 +0000
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
Subject: [net-next PATCH v6 05/15] net: phy: Introduce fwnode_get_phy_id()
Date:   Thu, 18 Feb 2021 10:56:44 +0530
Message-Id: <20210218052654.28995-6-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:27:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7a8f3ef7-5f66-4f25-5bc6-08d8d3cdf4de
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34424E8904CAFF46945DE5F3D2859@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZzoZwnjieoSfY5i43wdfoh1OBTMXnKtvVtI3vNJWpcFrZlLdB1iagxAIzjxOBqnx8CAuluxE7s/gGdVpq/FLCRSR1BlCTG1FvOkol58dwoURumA0yBeUIfdjxqxTBcGNi/+87y2PtvR8s1ghawPjt2PLYikXRGiKoE70lDaHO+m2rp00R9bhWRdUjR3JkPpvSUPGu3fB6du2UYofUt0OOkh7fERh+g5KJggxKODB805mA34nn1+SpZTLPWp+V+4NYjuf83O+NPKKI3RnHzAySB9xFvg2Se5Tn1MndAQDTPZwc4Fvogl37YLRrNmlo9cL6DJybSt3lmkN1H7xSHGFYxYiVLjJaz08Xf12Ocost/lPFLUzB7XJxN6Iv8E/akOuyK8FXbnsMvK0dWnMDhjhmaHc6PLH5NOCp7+vkCn0Hb7m5+g4R0Cq4xjUSZ7PKU89a8qSuCaWpmyEKdjNsCE0Pa836GmsIQvdArY/XXOT9XkHFgALOIiYPfhDPhYu/b2kLhN/cd+pHXII7D3nEK0w2OFYzg70dx9FLTV1bFsEiS6bymTwfUgNN3MlyFVI7so1o5+gvarN5UvlrHaB2Iw42sy6kmACYa2jKrcZeIifqI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(44832011)(6486002)(26005)(7416002)(16526019)(110136005)(956004)(2616005)(186003)(55236004)(1076003)(6666004)(4326008)(316002)(1006002)(54906003)(8936002)(5660300002)(921005)(2906002)(52116002)(478600001)(86362001)(8676002)(6512007)(66946007)(6506007)(66476007)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4ZNW2UYpu2qaNsd2f0+Ysls+tdgWZAX3T1byYppWFcwLdsWM+lcGG7mGQ7p7?=
 =?us-ascii?Q?5nxHRUNecM9arUl4f4hxbXeOPjwkvUlV3TigUkmqlcF3WRpsv88Nit11stTy?=
 =?us-ascii?Q?Bkt9kiAhwnntfQ4oZonjw+oY87cQavBPVlSa0y9Uk2q9HisGqVg5eXaJogbI?=
 =?us-ascii?Q?DKJW8w4K9h51AbMoiNOfoDO3+nOKSC8O/gmHqrlcPMofIfF4wN41OSYB13TU?=
 =?us-ascii?Q?xYGPdN/qphXN0bYaWPIgLHu3kV1zZ6J8jP8FMihQbPeLlwRK3NvL2MJinWEC?=
 =?us-ascii?Q?ntyqEbP7YC54TBgPDUFOXm5m5xg5diqOl3Vfivo9Ci0z2nWWcLF9nAzVHE01?=
 =?us-ascii?Q?gQgJsVhng85Zvy7VIT0u5UgJw9P2Yo9ghnwVEkDo/hQBVd4uo8zYnTgv3Anx?=
 =?us-ascii?Q?j5tpoh8l7eTYA1WxZsjseAc1AMAPxl3+HLfgl3E1ylwImd2fqpbzvfykHqOS?=
 =?us-ascii?Q?bNNdW/9Q4EADH7u4as/p8C+48itBsm4Adekk1vugI6PBpj/DyhfuDpQe3Uv9?=
 =?us-ascii?Q?c5CShVRh+ucUNgR56Ou0SK/iz3Tvu7V6HJfO/dvVtQe0NEHOuZw8Vq5Iwcge?=
 =?us-ascii?Q?Xhp9+BMaMWdWCIkiEicmp1GOsO8zd49P59JAeHTAwaPIqUyaU6A0cfVkJ2RF?=
 =?us-ascii?Q?AD2sO/bNSg7NIe5Nmp7OuDStiHDWQiiZjXkw8jsZAjLxGJe1exlovlyHD9Zh?=
 =?us-ascii?Q?q7lkst0OrFmEj4YMyF3Fe19oMRxBuMartVkIrJfTYYwyTdg2gF5BEC2uYGBU?=
 =?us-ascii?Q?Wr89/CG5/wEQ92zJpgmCiOgiKjDGxGbGD6u8LTDkaXVhRrQTUJGjWTLpVEyZ?=
 =?us-ascii?Q?ohl7DZM6YAUYxrdC/55Hm03uMhJLDyo1XhRbjDwZn/+0PJ/qWLRRF1lzoX31?=
 =?us-ascii?Q?Y/qc2OwLXPXtm9EfEcHhLU6uvknUSNeANORogvTITM5FYMBqFJTfdmIF9Vub?=
 =?us-ascii?Q?ZEx8ZSx79bs+t74ee4gsofwPTK6JtHGOUBkg8E9lXGjewN6n+oPFxbExlsbS?=
 =?us-ascii?Q?nYRRcRbLpDQEjA22s/8XXqAfFa/0wcOJYCGpoMJ39+g1TMEZaszC523XhsMI?=
 =?us-ascii?Q?YEUpPjLw/67FVhGJmvhkk6ozliSmE5uLrI9kJwiImDADWCz6O9iRJljajc0C?=
 =?us-ascii?Q?jTCnBijcld2khqfmgUm29/OsaJLGwfNi9BlIJU5hxILVsQYWmAajLJ6OuMCF?=
 =?us-ascii?Q?nc9pC7E1FjtmPx6wmwJJ/guZQK+Afl1NddcF5iMvE0xyK2/aSQc81aWHdQfm?=
 =?us-ascii?Q?uVzspDELN+vFr1XDEZLnzsJ3zYHO1d2ZA/7wt00nxBvLrK+QDKzo1Wu06QBK?=
 =?us-ascii?Q?ZGyuNOx6gW99E6ObH+hMhz6E?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8f3ef7-5f66-4f25-5bc6-08d8d3cdf4de
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:28:00.7232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJCphG7TxecaBRMIcyeVBILJtuWEUwxJnV434nv5b2Zq7fs6Z5b3wg4KKuH2k756Mhip4oopK9yKeFVWNlkGFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- Use traditional comparison pattern
- Use GENMASK

Changes in v2: None

 drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
 include/linux/phy.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 537a25b9ee94..5703d4229821 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -819,6 +819,27 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
 	return 0;
 }
 
+/* Extract the phy ID from the compatible string of the form
+ * ethernet-phy-idAAAA.BBBB.
+ */
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	unsigned int upper, lower;
+	const char *cp;
+	int ret;
+
+	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
+	if (ret)
+		return ret;
+
+	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) != 2)
+		return -EINVAL;
+
+	*phy_id = ((upper & GENMASK(15, 0)) << 16) | (lower & GENMASK(15, 0));
+	return 0;
+}
+EXPORT_SYMBOL(fwnode_get_phy_id);
+
 /**
  * get_phy_device - reads the specified PHY device and returns its @phy_device
  *		    struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 720a2a8cf355..4b004a65762e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1366,6 +1366,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
@@ -1374,6 +1375,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	return 0;
+}
 static inline
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
 {
-- 
2.17.1

