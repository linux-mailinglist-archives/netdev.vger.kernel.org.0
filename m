Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530632DB207
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgLOQpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:45:53 -0500
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:56934
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729854AbgLOQpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:45:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGgvtW1bpfJaXZN+0M9ICc4KeKYtVUVhuEIxjWg3MY0mU3BNuj0TIUr0LV4rqd2+z+EqTi7pRsAlhJ9THmF1zj3/GrcDpg1BlNzGKj2nr6/5BqMEFf+dZp6aEoWjzKX2BIg2hr65rQq65yzoM4p35XijfZ3x4HpbMSUQRS5COHyXq7n5js/ofz2bvwKli9E/w+XCGTos5Koje6p5H2ZAJd+4GjoIN4YNXEhXckfq0Km1oPAnqe4Cuuki8uybhxZdxiOT0RRhM3V4t+biFxvJv5Su22ev7ZFnkqYLbdRM6dlWPcBg0TS8w9r4Ec+XcqknfVN0Z/kImKG4njVXnt1L4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKVabve3Epmt/PcG9wmnhbYs48xlkriLAVvEOXJnIF0=;
 b=S/XtUzevyzbNEF799Uco61GKspN8U9VJ3EsQjAJlPqKwY00+ZAKp7esh4Z1+CIpLhjCWD9VHliKnM4jstklEbFWwegW6/HwnLD4GCTdV+mpg1M7ZYAEGIPga3r4EfJ26W5hNojUfcqxXVN0X+bBfRvs7dHc3KH07y5psyvw18PLjEYDu4ePQEYF4Mbamji3yD0l/3KB+swVHHX4BCOnR43CgcpWJ+VmNxVpJAYJ1pO8f8aiKYY9M4q9GffULZWboswSONVIY9j49GlmIKy0awEfyAqmdVhNGQT8B7HSsCwGvk83vNBwAj91oHqeFQD/pOJaUEQEWFlvdStH3fArNKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKVabve3Epmt/PcG9wmnhbYs48xlkriLAVvEOXJnIF0=;
 b=JvTsi0xKvcoEvfVb3pHT3OQ2tdUmp+oxWoYvaHpP9ZESoYbTwaWtc9WMdqGy/QmrsnhBa10TvNGPQQpyHrrnMnVhuqzfbQPE2dU9PG23bZJLP2EVrthJWeKcQ0JnHEpTKrYPHvhC8SMMTJEO5S9M3gW9vWZ1zyaFIqMAgS5lnG4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:44:16 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:44:16 +0000
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
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v2 04/14] net: phy: Introduce fwnode_get_phy_id()
Date:   Tue, 15 Dec 2020 22:13:05 +0530
Message-Id: <20201215164315.3666-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:44:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5be8dd6-7e48-4e03-7b06-08d8a118a98d
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB696366FBB6BAA1149D9B9BECD2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5ncozxHOtrJ0jfEw7V5s9n+2VcZk2soHGbWdOR8P9zaWbc2ljuUqMjqUzYj5EhxYavwkXSsGnF41SK1eL9s4barjLtHWA/Xqjbm4TwnRVPVx8PJ4qaZ2wOqIrLl7iuoPq1lYfeLRjIgiIT2ftL9BPVWZJemchThenJFObyL+M7B4FCoi4hFql6nlSPnWBoVPSdUOC+jDmc8IQ/ZSbl5aIcwTh1aCnPWOp+bQvwUM12MbACIQARCEriFQLToKTfoaje0z7AJZpDiBFtFzXvrb5Ml9Qo01RDF2XhA57AcV+Ey8kOtgEcUSm/s62YQpoVs2D5W5prg9Gh6C2eHQIIg5SiEsbeooPpCHTXG1cI3gyKo3JLuJP2cQzwc74shxH3jLejQNdgSCfCaI9tPajDqxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(66946007)(921005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IPl2M5c7waTGfhdeYnyuCUK5w7xHoiZuSIAZgOqTBfaMnaJ4zpW4jj0sPP7s?=
 =?us-ascii?Q?9Q2lY+008y5QHvNZzGWR3enXxonrQJHa5nmZKVYBNDfmHbDM3TMcmTSYjQn4?=
 =?us-ascii?Q?bELJu+Scc7dmU5xetqZyas4zJEYEX839C/trxpAoDkJwxuwedyOCL6jctsN2?=
 =?us-ascii?Q?9IOJHMAGnzBR0iTtY3zGZ9hz8tsk+voNbUgVoC7UhMiP9V2iuOm9Rrfs2CQO?=
 =?us-ascii?Q?tLdvLvHlhXUrT1AmNg2z2DpfWfF95Zrg2CBoaYBQJk8V0PGY2qhLiMBwfzbQ?=
 =?us-ascii?Q?wiqDXaIe/BLgJfPd1+hFm/bWCsNSYzsGRA2DkLWDA9zrBvynopZENkPunUVW?=
 =?us-ascii?Q?ABWX6caaJ22pdnocD7rXq5mraol87cYnAHG2INMRPIQi8JSREtDkA8JT7u6T?=
 =?us-ascii?Q?rufz6aVqxe0TEvsU0gNLLR6CSH6gxUiMWRA8T4/ISdGV1nW2bvF8lyrZBUfE?=
 =?us-ascii?Q?aplu20OSUJ4KpqrDKncQCoeFgruz2H/EJknR286gZMI/h4P/G2YnZO8NJ799?=
 =?us-ascii?Q?xJIQqic7ldre8lxZGtXER24CRZAWsasr1t7LiGH+dQ3n1QL0tqly6EVlT6Yp?=
 =?us-ascii?Q?oCOoKmpu8o1FCvn2hD3yRrTSgqaVjU3gcHGXyXj3y+tjuq7GR/+T7dILwr2B?=
 =?us-ascii?Q?/PdibbixJ5MjtpVFzKhZvpu6R2vO/Xd1PCEFMigswI1iE3/bjOTqr51HcIo/?=
 =?us-ascii?Q?AxZcrfGgfP+nrslaJ1kC+YfGRGsx56MulHvPE6HssGVtDErBGsu0XVDj7bVF?=
 =?us-ascii?Q?/nTI4S/YHvGXOVgxLZOhICwAWpBJxqc8PE4Qwx3sW9+rie1AmvbczIEfaUDO?=
 =?us-ascii?Q?MfJsMQdvsTrFZDA0SZ82KKi2ok3dufMUj/1nSgkOrQPtxNJOK2hAzIpJOObN?=
 =?us-ascii?Q?S4jiVFll2P9n+JldeJAxtEGWSAUjHtsTKzS78mdyn6f4v7M5uwRCKJ4Zxsi7?=
 =?us-ascii?Q?6r4+frrgdec8lSeu3eFaASZAr1xjS03Kly6FR1EM2sVVozzyw86cuuqPjuPB?=
 =?us-ascii?Q?8/D+?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:44:16.7834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: a5be8dd6-7e48-4e03-7b06-08d8a118a98d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFmeaO7UfsuiusTzzhELY/D+/VAz7T8/x8v70yPqzhPFLdpI+4qAGPkVafCD8PDalUMvIctae/1PUcUZNFgyZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extract phy_id from compatible string. This will be used by
fwnode_mdiobus_register_phy() to create phy device using the
phy_id.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
 include/linux/phy.h          |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c153273606c1..6fad89c02c5a 100644
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
+	if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
+		*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
+		return 0;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_get_phy_id);
+
 /**
  * get_phy_device - reads the specified PHY device and returns its @phy_device
  *		    struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7790a9a56d0f..10a66b65a008 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1341,6 +1341,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
 struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
@@ -1348,6 +1349,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
+static inline int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
+{
+	return 0;
+}
 static inline
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode)
 {
-- 
2.17.1

