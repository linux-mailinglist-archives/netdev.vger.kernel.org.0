Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2E3136EB
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhBHPRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:17:38 -0500
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:34627
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233067AbhBHPOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:14:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E92o0PFFR5dW/w7TWHYo9An4no9035feBSbycOdXgfTyRiUreUej7/124Ck0TzVyWd7lpWXFyf9tdfM+suhq4FmLblJ+dSFbcK5rkPTwA9xANZbUxg8SQJX3IwHk5+/aDIobm8nGx9BqLrJvGzxdkb+SePEsl9dzZwb93psJ/43ucrTNnotJCX+AQjlc+nXYJtU2TiwDh8lyOIkHIydj0Baa+ti08CDiCZd3tRzT2mvj/KNea155obdBetcTv62g4RliZ9XUsPjJscdxbnxVn01BgtpwgoRHEXKhU4ZYx6E8AhQAlUX7BZBx5pHjaCGbZ3U11KAwq0PvOO9iFL5zZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Scqk5oB3H+Ndj6AYV19BYuhlvsger2Q+cn2c3nKQqmc=;
 b=ndP8nqIv4VSNkal4qIB3v7B4wi0cPef3A4+nTa6pqwWZGCcWaPlQh0IICx/esjHDeIzhDt9gwTCi/AMwvl4uPKcyzcqbwA9Qzcd996MFuZNxuqINMgGPPhG2jVodDjq5FrGkr6gUEaEMSNE0yLuczQ5sYHiL6/VbKxK6PgxeH7Wh5Wls30QVN9gdg42GiMDiXN5pc/8nx/oDDARwBPVUmUic2vGBGrAXWx1Vq1fuFI+65Tj8AL2FHwQ1kKjtazK/iKV9CRr17R1PRE1iDp2kt1UMzksnS1LePn08tg25k3XmzSdOJ6ivQ/ZZdcBBzaQQVO472d83yqAvVJr8LLzr+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Scqk5oB3H+Ndj6AYV19BYuhlvsger2Q+cn2c3nKQqmc=;
 b=hdTavwkW5Zdl48PbKVRHR2tJqBx/t7uQ9o+lMx2tkxHuXdliC5ie/MLrRPt/ri3iWWzL9eG4DrsrxjxdzVF8JBDvA6jemEuI18TkB1F+HHrnMTeg2mdQNwvaYdCbIwPpm082DBOHk9oS+QexXOZQQR0sfTFObNePDAZYFw2fOHI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4772.eurprd04.prod.outlook.com (2603:10a6:208:c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 15:13:52 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:13:52 +0000
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
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v5 05/15] net: phy: Introduce fwnode_get_phy_id()
Date:   Mon,  8 Feb 2021 20:42:34 +0530
Message-Id: <20210208151244.16338-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ac400af8-1298-4085-867e-08d8cc4424f2
X-MS-TrafficTypeDiagnostic: AM0PR04MB4772:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB477297F16840D4C6BA1BFD2FD28F9@AM0PR04MB4772.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M5cBnrng8ez3zUY3lTmi6lNSmN7VbOSOB+VbK++YmV1Q/Cb1NeYxrhr31QjQi3FHYzvYZ7pR0cY2mvxVgWc9sVZG5Nh1VYETp8BVN2oUq2aN5YUefRyL89ER5FJJ9XlQhaQrra5e3AUV9JZ5pgfnjdNimTEE0r+qfHfU6KDWtJf7mCtK2sSnttPTcGv7EnrhsJpWRDUsu49ZhheRgV8CLJ+/pg7r5dT1tISMIDtUbojW6eBSYenez/UEz0L6hUZiVOGADGLP00Azv4c1+qLJhBmscs2tQ6vcodeWLQ+PGuVvkcnmtSI8wYEtEQxLH3YJTNedSsatnhqjs3HoDNtHeSos6RsSPLsS0WWq/7t7BZJHMcVEg4DoePWQTJOfv6qrgbJyDAXLgvw4TvGH78cfbrnOdafraEShUxD0IT33k06fPDKTrjTnQRfwk/XyJIoY4FQtWmR9UZe67xwMBScC56k1GDiXtiEIwUADLr82UFYjYCBdPk69ugXKKKOMgtlRbViFBELTLIkhi6ed/tIV2eCPb3yuBS7jTrUJ//VkJR8FigJly6WAgpuhcPJNpZk7W38jACBIfVdMTQFBBAJLqGmRMHQX+qY1JbSxHYoXgx0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(86362001)(8936002)(6486002)(7416002)(16526019)(2906002)(6506007)(478600001)(8676002)(26005)(52116002)(44832011)(2616005)(55236004)(66556008)(66476007)(5660300002)(66946007)(1006002)(316002)(110136005)(6666004)(1076003)(921005)(956004)(6512007)(4326008)(186003)(54906003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EEmpsQ4IGfV6iZH3WzeUnigqPFe6T3AMMKMmOCCc1y8SOI5nVoixu9oFbGYp?=
 =?us-ascii?Q?0t0tRstqMYiK+S3CJe7cAL+I6CY4xQUtGX6cecRQ0mXiTEzffo9plXd44Xwa?=
 =?us-ascii?Q?w4kaeOL8dcNIhY/BMxSUa5i3JQPOeCFDtrttrMOGxNJCw9jgPWhj2UZwAqD8?=
 =?us-ascii?Q?3yJ1c76NYlv1THnoKdPBXKvrNhhDV+uZ499Sua1V7upv7QEhznE50EE82yrN?=
 =?us-ascii?Q?oUOZKvFZ52ZO2dENLZKcRSpmtXVmEHwkpi8DmEqYJb7HMKPmEY0IzbPrNr1B?=
 =?us-ascii?Q?IfqhgqT7dmooX9jhiy3jLFeiJdynpmN2kp6wMspvwu+VFgXgqJLWEkOqU4Lm?=
 =?us-ascii?Q?M1mprO/uFl4AGaJoE3+P5w2cHkOw0JjFakvb3IdESfacVMJK6qB210r/s0zA?=
 =?us-ascii?Q?FItKHbKhGq+PudZRsUOOuQsReAkBc/Iz1nVkZRJPkbG4L183wtcRRxbqAscI?=
 =?us-ascii?Q?qabnCD0FGLt0gBhfz9Kb8jqI4wJS0isSZcbs4SpZHFAJpblHQwhC/KEu/vKP?=
 =?us-ascii?Q?wyp3Jj0K5ltyF2lBBv626hmTygnCCnjDRfU1oX/5ijgSAjmF16KrcCOzSA80?=
 =?us-ascii?Q?UwGlSr470R5sILEJ47OKgDGQ3NFx8qKGMj4PPWYUr/fjDNWDNcnkoyIfOU4g?=
 =?us-ascii?Q?EmCQj5Fy8OdiACEfBBKxObv1V6V0KE9jsfmQJQwivdXs8dpv2XUPoCieGrhG?=
 =?us-ascii?Q?h+2EYyN0yfC7Wj+sxrzeGM3sSnDI34+3tMyxKvn3k2l+mwFP4x0QKOonzIY6?=
 =?us-ascii?Q?vT0Qv9ESWHGVE+LaDLcRg2I6kv27Bj984twGWlCfDOS2A+E0UgEJW3PF5H9P?=
 =?us-ascii?Q?IkCGNn7QOpMJn7PsbXbZuAZ2UoGb0nmnKSiOqMd3XzX+aJZ5NVwq8BgV7PLP?=
 =?us-ascii?Q?fD4JEPOTxfyukrhGLHZ1we8uSk64UlaF+fYxW5LbVoDlBiZTsdAXbR8Vw7aJ?=
 =?us-ascii?Q?+D1ZqWZFv5GLgQhHV7QNvlCu9anuVnsljf+9fKZyFkoI6fMuOEHhmf+84GEk?=
 =?us-ascii?Q?cprDHjcFEbcpFBqTA5V3rf/lMUdUqymL5dqHx4yAe3D+Zd55SSXswLgeSp4a?=
 =?us-ascii?Q?2A1McbHr2tAtcO7qkBznlVInP2gofy20V6MxptPvssLldtHw2w0q7Y0IK6un?=
 =?us-ascii?Q?3PlHSO2w9pqzJ01mGnBQx8FIfSvXLdl4LokYln7W75xgJC1QLxtkodyeivO+?=
 =?us-ascii?Q?Vl/4iyi5OGwBCd1sK2rdWqe8PBwIWWZVAj6sx2N6vZ2Nc8+EEjJsqtHpgHUH?=
 =?us-ascii?Q?AQm27iFNS1zLV3hHkRjRREtuOh4Ce4TAUmMAH2OdAscaxHqS0VEPwiMe66wY?=
 =?us-ascii?Q?NQ4SiaYtUf66RuM8cF2brM0T?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac400af8-1298-4085-867e-08d8cc4424f2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:13:52.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQOeN34nkY45fQ4897HgZBVhwexqU1D996/goALsl2D0K8d2YV7couYlcJT0eLmz/FT/mLAAY0BPp1OCmt1WOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4772
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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

