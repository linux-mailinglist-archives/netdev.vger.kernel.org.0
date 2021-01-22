Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8B9300B67
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbhAVSUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:20:14 -0500
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:21476
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729136AbhAVPp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:45:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbRoIfNeim54e4fyb/qfpwxTkNZ3+VRpsiEjgJvSGdG4P0MSPwkA47xZDTpmPSJaTMC8m6F/yQhjh84LrYSk5gRSpmzbpBOv9PEW2ksP6dkNI16dpeiyetMGr3oUmQRKAh05jBzJnRkp706tmiAJYpziFXQFWqTrGmpp2zprkFu2bf5qhsoRbiQ9gsKJswzu/AZDewDn9iEOD3CI/k6yU/Nl9Z3g4rH1NBHTs75YzH6CZwF2HMAYtqi/lPi7WnD/7NKMm17hutj818TMZHxjn3r62+WgewbIXSPDZ2VLkwqoNETxZ9aZYvYlCY3PBRlRrGXGF6Z11nOfNw3FCjjtuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJ2smfaUneArAo4LdK1zXMSBOITFv94TpLE+4NmDJgE=;
 b=Tr4ogXHhef/4jaVR9pzRIlOuR5KChajh6JtXNxUkkIDLqYBDohbCALnJGd6LTkJrzZKXU3AaOT1k9of4JK4VdLQvKVDQjqZtOIO5o0nnMGVmxzYFb2LazvUSO/8bQAtez8OD7g811ZXVNr0h1MgKOGiZjungMxWJEWFwS/iskiUhUTVEQ1CFVuCBNMKzkn65VZ9VJAwZxhQcRhBkkoM6SGuLNL5Hn8AotsImg/iv2ZfVDg6w631CGa/VO4jn8MmIUBwENTORd80xkSqWgmv08ZhTw/ErokLNBrQgbbJvLBaOgQ1QpRWMq9PQab2k4AnADstbfr4oDMAIdRRYPSjtdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJ2smfaUneArAo4LdK1zXMSBOITFv94TpLE+4NmDJgE=;
 b=MopWTBgRkl5yCsc2o/1byESl5EAOLwjFP3Keuw6lrpnbcJ21ye0Wu+K03FE92DWYVWOVfqPG73qBXvz3WZikpac2iB7f1oPsa8UiROmOp2tW20TAZhrfPnOpzstRlL2tt1ZL3+q43TvqpBsx1VGVCVj9uopSySblhmSgcvMxONs=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:44:16 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:44:16 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v4 05/15] net: phy: Introduce fwnode_get_phy_id()
Date:   Fri, 22 Jan 2021 21:12:50 +0530
Message-Id: <20210122154300.7628-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:44:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e049d92-9a23-47e9-413b-08d8beec931e
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34434251CD9B192B4DCD14DFD2A00@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGhNar0+3+Hu9OA5+J0K25Ax4xRXdjOcylSjpNEH59l+ElY9jSGcXHrS3/qlA5q5wDtovyM91LRWIRenvf66dRh29QMs3y3TrUJjcuYUNLqbEdaRaxMmmvYmn49QQ5vC3gihs1FhIctXW5hRvw0jMrCXiwKM0axDpwuohznJ+tGjl9kK4yy+5uiHd9aKRXJpaLrRuPZRKaR0/CuBJC0qxjfMWMLiNOVq4P++o/WbbjLwBVejV6vBDKcXUYAg8oq73dVpeMClHUb6QWnbTTRPU8yPt3KR1wbkUecDC++PhYni0E8Y+4IK6Wg+dSJ9Efgb5hwYqoheC8xipmfcAuptPFD4af9jYnXN34nXrWE1NWvspo8m/UtLjGHtrJpqwIsKS7vOsQYdBQa3CfGs2KX7XH9M4aHagIM2Zq5eLqlOIVdUdawLglHe3Ca8FdnC4E4CepaRK7i0a5jTFYy91fhnxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(2906002)(6506007)(921005)(6512007)(6666004)(186003)(5660300002)(1006002)(16526019)(52116002)(54906003)(956004)(55236004)(8676002)(66556008)(8936002)(66476007)(2616005)(66946007)(1076003)(478600001)(26005)(110136005)(86362001)(316002)(7416002)(4326008)(6486002)(44832011)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+6P6wZqMBeZIe9KWsOi0Muxreb/tWPy7zXa/K9yNyxh6EoIi9mo0FTzhY/Xl?=
 =?us-ascii?Q?vGnTL1enYQUxMv80Q8y5qyNwrHBij2urqMpaZ7cykOc/+fzlz1gHIzjFe3Os?=
 =?us-ascii?Q?MGlgS9pROHMkaqEK9j7/qUNX2xUWoJojQjnMHWtRFM7kVWpJea+oiy96JFQC?=
 =?us-ascii?Q?UOxUoII4J2D5p5haMA/rhm1S2CL54dQAzM4eGRMkAiNpL5M95NvKVV615w8t?=
 =?us-ascii?Q?LCEIn4seuWrrJ1bcXc9+ayCIzL0WvwiVfH8Po+ZEdMV8VUdPkYHKG1Sv+zRN?=
 =?us-ascii?Q?hVyLz+OmjBrrYjAUj2R3dL+8Ol5+zKkzDE/aDwcJjpTMpcT5vncGRSD8vgS9?=
 =?us-ascii?Q?VrF38nSxgJFIUlHPgoYx6M+7JSQOJbT4a7s0rR1Lh0w5tTPU3DQGspCEpf97?=
 =?us-ascii?Q?U7bdPsxbYF0DcjE5175EvSZ4Gukq4y8CxotW3j5ISjfw+pIs23j4Mk4PGwcc?=
 =?us-ascii?Q?Yn29F6Gf9MxriXj+E3UZjA5rD8zVhzJLSSCND4mXhyptBT02gZmViuKuD8jW?=
 =?us-ascii?Q?9LJEY64hSny0bc/VjTfMjnnVJbaOtlLCL1dCnxxqJ9CwwRR1ITrnDXk311U/?=
 =?us-ascii?Q?lK8pRGABGBZ1YXtjdwO5wKoJsvr0H/eUQVyT+NJMXUVAguFnwFoTYlmHFhUc?=
 =?us-ascii?Q?3MdyoglD9bj+tQti0GqZbrJvyxIsTi4ICO/Ys2nlNP6tVey+wBVJvDzNASEQ?=
 =?us-ascii?Q?P+q5MJn/8rXrI8JrJp9vNIHtSbZnPdsOqaRSEohNzbsKOmGz/2rNvbpyyI/W?=
 =?us-ascii?Q?YI8fnmf0h2fv5xQjvMRJ/3jTjST8s8j88c1UMjf3hZ3TKPKGXeJslvTPdyXR?=
 =?us-ascii?Q?9Bxb3EQnswhAOVxVNmzO8J92q+sU2fDPksJGxvy1oXcGQkRCV6BhmFUPPzCd?=
 =?us-ascii?Q?Sie/wdBCkWIMifojC2b0aMqWV0BIiLP+ZYKBH+4GEMtPXTSq60fV/4S5b7L7?=
 =?us-ascii?Q?WaVrhU3nTajPpsTsn5scvqufqUbJ0YCiHUnJT1xKxURB8sYDiPLpJFX9MQRM?=
 =?us-ascii?Q?JFBuTSeeXEqZnpq2GX+DpnOuOyF6IFiFDZfi4Heyysc5FN0nkKBiiBbIpFOO?=
 =?us-ascii?Q?rvFvn7ZH?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e049d92-9a23-47e9-413b-08d8beec931e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:44:16.5676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kpSzEIF3cCBE/r/V7i4Y4sivPpIw1S6oy+YHLVrjbwIIzvc+ikG721OpNtVugzb0eFIVF2gX+NWJ+vvCO/dydQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
Changes in v3:
- Use traditional comparison pattern
- Use GENMASK

Changes in v2: None

 drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
 include/linux/phy.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 66e779cd905a..6ebb67a19e69 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -846,6 +846,27 @@ static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
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
index dee7064ea4eb..957ce3c9b058 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1349,6 +1349,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
@@ -1357,6 +1358,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
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

