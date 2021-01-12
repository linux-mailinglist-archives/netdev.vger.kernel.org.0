Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D856C2F31FE
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbhALNnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:43:16 -0500
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:33088
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728021AbhALNnD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:43:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D22Wmb37Yxl02igHI8V13AlJWAxSeX8HNVPqvzKXB2vehGx0oZ2j3Xb+ZQW+e67vbRpY8w5X6rJ5cGprGujU/qkxACCiLL22dlb2BuCnHGINSdApcB3KtG6KDzXg1q3waZSPTlG1gFwUC8c6qTMPcJYWRkuWkCwuBVTxG8W/Bu1o0q4RDSpJW9nCAItjaKIDQFeivmrizK1Ey4WInU07MXtKBvV6x7rspMrlc9fx4HL1Xts0fSKrgo9BGjj0x70Qwc0De/c+j6y6IHGbJjnotf3EqwuY6CewkBVNtRhUZZ4vivwRWB1a8w0tPxfukdVqebPQVx7ewxrPXtFObkAKVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU6Agl9BCtvbKwJFUqR1SsXarPnk4DZf6Ftd7c2MPmI=;
 b=R/P8i9NR4RIBx3C3gRdk/JMe/Ph7AcS3gw2mpt2RdV7UsbS17MxhxO8GLEq2KQ+Cgc8U8BB3I6nzB4/Vl3RTX9wDRWdH7hxMWN3Jo8KxmzKZMZa8Yb0GtPRsdLYOWGttmzcsOCh/qEDtvtZRSytoLV62DtsCHTyKHDL/+KQEBz6TsdCainrt4QA9PbBMum8kTy39GBTO4IppMukC3VgkqLKFX8PNwb9P4H+C6LcnGcy60kG6yyqxj/qBu57+VydD1Iiehv7/1R7BoOZ78ZNeIPB4KS8CfMs/vGhSxJsqrqpLdieF5i/Mbo7UAfbDWFZTplaTc6b/vG+bxdXZZTkEJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU6Agl9BCtvbKwJFUqR1SsXarPnk4DZf6Ftd7c2MPmI=;
 b=JvI1lvDHXWpYYRMHWkkKsFqWvd8JSiJ3s4XVeR8gc9xCNX4ml9HlCr88l5mvxUguRMmZ3wRDiFgtCVojqjg9f4bWCNwM/gXn2AqQTr2bb0QH/jHz0FsbUoS6KBGZa/feQZ/wSRCEJ1mk4h2cT1avdsALaw6/fVvu9LqdVM19keQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6436.eurprd04.prod.outlook.com (2603:10a6:208:16b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 13:42:06 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:42:06 +0000
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
Subject: [net-next PATCH v3 05/15] net: phy: Introduce fwnode_get_phy_id()
Date:   Tue, 12 Jan 2021 19:10:44 +0530
Message-Id: <20210112134054.342-6-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:41:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cff75985-2acb-4887-c88a-08d8b6ffda34
X-MS-TrafficTypeDiagnostic: AM0PR04MB6436:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64364BC705AAEFAED80E0D3FD2AA0@AM0PR04MB6436.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YjZKlBlXjp5ST7uNRJ2gerEvPU0roc24tUM8/Y+HCkVqt9HiSsNhloWv1gSavX45yoI3tZ5+j/cPHWtQ09IInw3d9Od2CNSvnxVrJ/DIUVekdZkU6KY9koj34laMZBWlqlnwyubwncdbJD5ZtF3zHpVsQ9vwywSHf1EKp/7WDUG5OEG9dtVS9p7iDmqwWtvcDxUGGVFRl9yOroKtiK7/7nQXUcAS/f/cwBR03v3IwYyuBxnfQQtBSvK3bcEQl7qEKYjn+fgYvxaGE4s6oNGv7/d1V7sqcPN0LkemhCGSx0qQjzXA9RRIctdwe549OoOq2EdNGdWToTNtUfJLziU0h0mo5hE4y0FPdwp6tdocl0agN6XxwSqsXfWxXOjuuKHtqOfw9QS7fOBJ1gY/1Yx/qndTIigygm0dgFeCiOgrKQfhW8wYYXPJNYkbk3+MeDp8vQctZUofUn66lCnHS025XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39850400004)(366004)(8676002)(956004)(921005)(6506007)(66556008)(478600001)(66476007)(66946007)(6486002)(8936002)(55236004)(26005)(2616005)(52116002)(16526019)(44832011)(4326008)(316002)(5660300002)(1076003)(54906003)(2906002)(186003)(6666004)(1006002)(86362001)(110136005)(6512007)(7416002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HU59aoD6GwvG/JrO+ET1w6sbkwBX7aT0/HHnUOE21gp62B9Xmp6TG+efmfXZ?=
 =?us-ascii?Q?uuUH548qFxvveHB4Sq+yZdd3VueWCwEzRXaSi3NRoTHGYUJBFZMz4AB/tTJ6?=
 =?us-ascii?Q?8mLNTRrMoU5KCbrQbJBs4zBfoY5XCf0KUh/abETqQ8TpB/VPi0csDM/BdNzi?=
 =?us-ascii?Q?hdQ8tr28UKNlDzqoZZubcTbmiXMdmAgiSP5nE06nD2B+0B3aGHq/oON+iRWW?=
 =?us-ascii?Q?gKoUjTRmS2qVg5+z1Hmo2MjA2iiK6zEVlj/xC03C5y8IiE0CMJYsTKeJe0YF?=
 =?us-ascii?Q?qAECmi3VNbgY3Njkrg/OoOfgIfx6JkDyM2lsLQSggVA8YaiKhYfAApUZl9j8?=
 =?us-ascii?Q?1COpbnrUZ6ai0fwTJMe+HJbeNM48Y2EY9hAGx29KSADRnCWCJUDuJFkLhpJL?=
 =?us-ascii?Q?tBoruRmo0WGyJLITnDvyAZPHjFAKYYwH3hlUj1u9JyyViRgyytQ+RTr0dL73?=
 =?us-ascii?Q?AbxKsTB/vAGCJz8zVv91IfUHMcuwIun7xLFwD8PWxh7V7gq24XwM4E+zqJJU?=
 =?us-ascii?Q?4sf1UjGgfH3bhNWlAnjEnOpQWtECX6v17r7YBORqAPMzhYGmaVmvtpcX4/i3?=
 =?us-ascii?Q?79e1SYPC2ztoUoHy3kuLI8Sr10lqjjKVaZUxPmQOB8a48BS7TewHQWn5FVF9?=
 =?us-ascii?Q?sCJ/ibcZlelxOo2kj5a1xSRNUZXuKNfY+ABN5ExX1x1vCBB5+cBH2A28IuSd?=
 =?us-ascii?Q?OZf1laLG9CfySLcZsNpC+NMOgnPINgTbjgctzBDvhkk75p/tvIL4CSxcRVJC?=
 =?us-ascii?Q?keMidn+33iL9g14vv8u44CjpP3WcOfMl1ODKa2nrXzYY1ZKuFUtiO4QO2KSU?=
 =?us-ascii?Q?h5MxgPYtwF4G9P5dUUSJJzwoOXAnrZiptjowHZQjuUR9Ui6Rek4K8H/LvzUi?=
 =?us-ascii?Q?bg5bEpgk5JI2iG6VNO316vKBl9Oo6xy3f5AugB2wvNWPURMZkuwNl5pfugaH?=
 =?us-ascii?Q?LFVax7SmpD0gCQIJWH5AV5IMreUk+PWP0juv2Ecd/dojS3fXq1CSrwAOWGU1?=
 =?us-ascii?Q?uKmQ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:42:06.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: cff75985-2acb-4887-c88a-08d8b6ffda34
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/3QWbxc0Mn0RaDJ0HDNzk74ufrUOvdvDB+ZmsxoNV3APVMuSFZQ+zahe/5HV1921GR+xc90vwSsGzEkGXG15w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
index 46b9637dc27e..28cd111f1b09 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1342,6 +1342,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
@@ -1350,6 +1351,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
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

