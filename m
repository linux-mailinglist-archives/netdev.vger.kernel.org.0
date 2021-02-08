Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2BB31370D
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhBHPTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:19:20 -0500
Received: from mail-db8eur05on2054.outbound.protection.outlook.com ([40.107.20.54]:24577
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232754AbhBHPPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:15:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TtepjvLnH6jtwLyMFAXaSNy2V2AfcRhAYQmFvdoNKFDS4nHhePEFL9CXVnobuJ71ybEdLXvlme3YlHLg+Lnp/XUPgBU6X4nxb+gNzt2lo2/XtK/1IWmADhDYKMiSxePrdnGli1fZ5/TxM/SHMZiLRzszhAZiksDRKBhlC0n57xMmrtCFJYw0cKFi55wlgnXw0XQdPXedNJxG1LAKr/T5VlxDss6d0R+byZAZxR9VR8LBPOP1/xQnrGu+dhTqKH9gsbB0+eIagiFJxCOx7U13EUpIF3ghMNQN7s2s2JPNBSAwqJS/8skiNBGT8twRu7h04gf+HNVZAr85Qe6ilUm2pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZ/gH5MpDExS/V5Jml4xSI44t2ZxUavt+yfu94WPViQ=;
 b=CvG0jrmUn5aM1kikcorjLl20M0rPB0XlolIkKlFL90RhlYdRnGDUkN7K9mRa1kQj4jx4Xs4XsCsbXli050YvmPWUh/Pr7gRTIL4THeNzmSiP6ut+eCsIGSgZLPzTtlbkn7mxKqQGjxUzTkbyJuxnD6MzH2aVEku6bZs8VwMrQrzZUi8SXC8pVOVqriY8FyzOfunXhzlgWNQc+/yY9toPcEmin/vZrpS+xOSParvzDGesdkfMSIWs32vMvBN/hMXbURz5vHpD0hY57hkkWAfNd9lc3Y4RY+sZDuzpD8Iwwi3kB6pmF/X68vBsv6AZUxdw0XoVvE7qwkJ/OeSuYi+H+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZ/gH5MpDExS/V5Jml4xSI44t2ZxUavt+yfu94WPViQ=;
 b=geTM3QI4+FaGkOaVIONo381+hbvpYjTjws/SBjiaiQIPB8I6nWDZtB0/k9rjUNXnAMKbs2xv9Ug2gxllCQxEM5YBOocVuEhwILbV6qtU5NnZ8UX744WZC69+SUsXGgBueu3IQ6E9Tz6/v1DSBicYQyZZHR9vaMEtUexjLybHhNw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:13:31 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:13:31 +0000
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
Subject: [net-next PATCH v5 02/15] net: phy: Introduce fwnode_mdio_find_device()
Date:   Mon,  8 Feb 2021 20:42:31 +0530
Message-Id: <20210208151244.16338-3-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc86f187-1312-40fd-dff2-08d8cc44187b
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6435E61702E4F33707802813D28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GFBnEMKX2foI/nNq3PjWQ2nxKM/Ufs9bXFo7DeTzpH5Y/m3T3nkEJb2/54Oc+i/pnDkxsOwcdoSy2PqA/UCOGyi3Sk2FVs/LSkBvPSadmlHiMKL2dMa9ZIYD2gELRGr2CwN5m6IHpGJq44fUHdQMVIGnP/1kUVmPY11UGSWxpA+PByHOqrhfZU5tAMkOr3EEzrCWKFUbhC7OpGoGR5vvJcWdaI3HQwV02bkPxYbM6IOlpZxquzkAcDaeYB8rWTvWQRx92A+5rD3dm8r9BolkQD9+imrAKfA1lXqyuFipt0BGAVM7DyWLWzqiHmmtGZLdROnJGl0xq1SONJBbYupxvyg/ygnU0yZjCJXml6lHScYGA5y1hlM5OosZIwGSOl7a6vjxgjCZ/ruAg0BZhvC6w8GPrzhV8QlEV8WrwjhOOOv/63r2k4z7cXsR0Qb7FOAH+W+TACCW1sb1Ts5/ykNJS5cMfQSe7tXi931tDItk1ooUYjF+z91vjCldu53UolB/tpxcyn+tc8Y0eIP9ugT0PgoOKe3l7nqWrh2aMHkeaO39vWVdR26IhwFIgNlYpV7nBgcshM76vItho2FdHc5ViREBkxzk9uPtDz2PVWLPL6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(6666004)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eyOsrh9O5Y5Dkg1ZQUy8gHs7MyJZtdjM0KI7+Gno4o8LVbKWysjktlQfkhOu?=
 =?us-ascii?Q?hBlFTbbWxRgAZMk1+2KKmTGs7Zn+LhDP0OaULLu5JJcpPmu+ZMni8yBpXevT?=
 =?us-ascii?Q?lfGY32PzXKI6VeRxAn0tSrdRw5o/hbrUPAFnB1fnRD2ZkeD6F+CYIqG6u5OK?=
 =?us-ascii?Q?4CZWaMD9GYGkn69Gym7wFwpuWgXtOs5npN4nAVlvwu9f9IWBd53feAvkup+9?=
 =?us-ascii?Q?cTEaImbavzzTsalnXt08mt3pldp26KULZn8WEXWx0dsf1Lujrp33FoeHFUcx?=
 =?us-ascii?Q?AiCmjYTsOeu6QZ0MrdgWi1F/Zl2FbdlFclWrM51v3dFdpbB9qdiZFqcKBz0p?=
 =?us-ascii?Q?/dLOD/W5OctF6L8D3h/l/p7RqV8sUR7UaXPk+D64aRP8orRqxjrqVbmwGu4f?=
 =?us-ascii?Q?PxuNpbFfFd2OeCEQPb25Gs5/LVcvvWBppWx66OfsoDDExdLANweVpS1bS/HK?=
 =?us-ascii?Q?PYhAyRr+PXlo6ilKHcnGGGJHBScDltIFYT1Ci5OhHmVFstvbDFMPZZHQulgo?=
 =?us-ascii?Q?MZEp6sGKegstpX3G15S2GTG2aIECz9SfXkDltTcBPWP2OHR3g3BV/QpzsPN7?=
 =?us-ascii?Q?NUDXwRZEyDfIOR7LQ2pFAbj87k4fFzGrmpJpsAitB6ftNFB0OlnurWQ6Tt0H?=
 =?us-ascii?Q?erJ5MclWPg98Re1BdvLeM1KXufbQGd4JyLPoFJdy7BpVgXVDTFmcuAFKB04Z?=
 =?us-ascii?Q?n5dNA2ns9tjSRRIf2A0GLatqHLLiNxWLfgaGj0WAduxTGP74X/3XLI0Xh/LC?=
 =?us-ascii?Q?zYC3gOrkIPoVfXLaFKUe4qPHGy7zgwGU9J+8yp/cAmEYH5M5T0Dcy6bGosEZ?=
 =?us-ascii?Q?+oRUhgwU2Qqween3voWViOTXo3C+aIvzNAUFBW41lLn9iJKeJH8GHZ9HFhmf?=
 =?us-ascii?Q?RSuFN5fvciM+C9sowI3sWjmlB0MgWBxy4C0wifNgYsSyiDHHtyMPKzHywHg7?=
 =?us-ascii?Q?uOy7PP2xFadmDrbSgMMMfSgwQuCKawcjd46ivRSsHsEN17uvXNrUGmC167um?=
 =?us-ascii?Q?6gjdNqP3dyqfDHgQ42UkclgHE2T0dlIucXVjzZwqAbKOnKuRwJSkEKEM43Z2?=
 =?us-ascii?Q?aD6ufMbSoLxehDgzM1voZlNZsA0ENS6usolhhSSpTTfb/Xza9OlRec47odQN?=
 =?us-ascii?Q?KpTqm9kyHS9xqv7ZJIcMG6QVKrG0+YwRyc5YsGV5XN1MiR69ekqIAojRhKEz?=
 =?us-ascii?Q?Cfp8uCKZDwRnXwOpplvxZlg7dLuVyYAbX6tkuYn+bx6l/v1O283b1BOKp6oT?=
 =?us-ascii?Q?t51cyMz5orndoCgzzfSolF6rlWDU+Qf3neTiZyUeNLLJWGb7C5l4eXmJoZT9?=
 =?us-ascii?Q?bBJqmz1DK9QKNTc3L4zygd5aZlYeYg/iFAfvZ86aeVQi/w=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc86f187-1312-40fd-dff2-08d8cc44187b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:13:31.6827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SWzSnfYyT+ZRTcqRbjrSESXHl+u+XA8MLcEHtxxpuToVlznycBdhUEgasR0XGVeTnXaN4NDAfecUBrOAvzYrdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define fwnode_mdio_find_device() to get a pointer to the
mdio_device from fwnode passed to the function.

Refactor of_mdio_find_device() to use fwnode_mdio_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c   | 11 +----------
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 4daf94bb56a5..7bd33b930116 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -347,16 +347,7 @@ EXPORT_SYMBOL(of_mdiobus_register);
  */
 struct mdio_device *of_mdio_find_device(struct device_node *np)
 {
-	struct device *d;
-
-	if (!np)
-		return NULL;
-
-	d = bus_find_device_by_of_node(&mdio_bus_type, np);
-	if (!d)
-		return NULL;
-
-	return to_mdio_device(d);
+	return fwnode_mdio_find_device(of_fwnode_handle(np));
 }
 EXPORT_SYMBOL(of_mdio_find_device);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8447e56ba572..06e0ddcca8c9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2829,6 +2829,29 @@ static bool phy_drv_supports_irq(struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * fwnode_mdio_find_device - Given a fwnode, find the mdio_device
+ * @np: pointer to the mdio_device's fwnode
+ *
+ * If successful, returns a pointer to the mdio_device with the embedded
+ * struct device refcount incremented by one, or NULL on failure.
+ * The caller should call put_device() on the mdio_device after its use
+ */
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	struct device *d;
+
+	if (!fwnode)
+		return NULL;
+
+	d = bus_find_device_by_fwnode(&mdio_bus_type, fwnode);
+	if (!d)
+		return NULL;
+
+	return to_mdio_device(d);
+}
+EXPORT_SYMBOL(fwnode_mdio_find_device);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
diff --git a/include/linux/phy.h b/include/linux/phy.h
index bc323fbdd21e..8314051d384a 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1349,11 +1349,17 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids);
 #if IS_ENABLED(CONFIG_PHYLIB)
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
 #else
 static inline
+struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode)
+{
+	return 0;
+}
+static inline
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
 	return NULL;
-- 
2.17.1

