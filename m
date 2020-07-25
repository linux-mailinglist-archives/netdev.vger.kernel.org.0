Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F3122D818
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 16:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgGYOZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 10:25:01 -0400
Received: from mail-eopbgr30053.outbound.protection.outlook.com ([40.107.3.53]:46987
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgGYOZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 10:25:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQCdhB4PCQB/XAttIT3s7zA5DJLWlB5wOTJDEUDCtFPZ9iELDwmn7fwJdTnHNSpemRrtC4zWpnUdrrySEPtOObCf6NoPZyun2YUk5WcQzQMmgqDhDI6m+WLcq9P8w7y0YNqRrIEGrzYT4UZe5MTKxl07mqlCP/W3nsQgnxzIW3ZuH1hf9Nj4xCm5NEpZ/oHh4UJdK/wsb2OyAO1fulMQBF7ECJ8SLqwfhiEaB3mRpeWpBtNaR6j47sFPXEyUMIDs7UVq0Rkwqau8IxsJGnDtjViXMAaljJhVf3o2mKq0GWn65Qv+0bw6QVad1AqHhw7PfOX66s/3I88V7IrVDlQRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3kdm1lDYjdzIJwkMrYd/NBbXanHVS+ZY/kzco22Wpw=;
 b=WL8KdW89bjoIbfK8Her5uPZ9jHqpOREzq7zxPQEWwMDjp/j/E6rDCdCEJ3cWGA2u80+XtS2sm3z1l/7Sbfnf4pVYGkeyuvDeYZibpEDWBEP9OnYRR+sgnDYX7T0ekdV0X6drj8V+oFwJk+mfdohk2+3Iu368YW+9gEC0RSUp4DIWjn412mBSn/mOkR9hN8bi1DmKQDQsE03eeyoXteC4cFLGomYtsVs+6OplGa5Rqzv5FpTD2o5MLCc4u+qGogsXdjkdmkqop8LyWImZva2B3mtIFxb0DjIyUPl7S1iCgtAF03Adz04d+WQc+2vkR2AAvohxVsiEuoBMo/s/hYkocA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3kdm1lDYjdzIJwkMrYd/NBbXanHVS+ZY/kzco22Wpw=;
 b=IVjqZsG7QFb+05A4Ij5KZczigqj/tkL0OuEMSqTXrhWwWKA1+w8CfejIbgy/rQsTYxIdlFmN9LXF+kvWyWsKCH89Rm5Soc+1uSPEc1OTGYOtuknvKS/srZ3Mw6omzmXZaMrccT/2HB9D0io7kF0svpKQdh4W9NwhUN50vCCSRzg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sat, 25 Jul
 2020 14:24:57 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 14:24:57 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Al Stone <ahs3@redhat.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux.cj@gmail.com, Paul Yang <Paul.Yang@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 2/6] net: phy: introduce device_mdiobus_register()
Date:   Sat, 25 Jul 2020 19:54:00 +0530
Message-Id: <20200725142404.30634-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:3:2::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0018.apcprd03.prod.outlook.com (2603:1096:3:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 14:24:52 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9ff7d112-194a-49da-374e-08d830a681b7
X-MS-TrafficTypeDiagnostic: AM0PR04MB4931:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB49318CBF265B1778C993321AD2740@AM0PR04MB4931.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TllzpI1m15PjFn5bazgfaHJ6DVrCTo1zKaL7/0W40UTPzN4oBveuSEQcuDyak5pM3kY/irlmM1n9QKbEpW41QDFFkKAVYf40HYcB+djZsEnGa1MIgy3uQYEAkYQ2NoKNHHg2KlJWa21aSDzi4Coa1WFGUWR6OuLwdIo0dkXOeCIXeiZgZj88qW80HcdaWJFSpAhJdw8QTpgtM6Oma/QYGWwYHfsZlxmhUFFvlfovbghasxH9rxYEgGWYCpQQH9H3MbI1sppLNVxF4PYeOINIsO/VRuptk6ERl+/oLw6dAxUW8Tk640l2Xvall2Yj+qalBSbRpdt2VqhC5R0eJKSJT2ReGj4INgF5oKmz6BVcmMdJ+ha2WhjwPs3M0jm/3qa5DjALmnSQkFtWK7lOSe5cwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66476007)(5660300002)(6506007)(6512007)(86362001)(55236004)(52116002)(478600001)(44832011)(110136005)(8676002)(316002)(54906003)(1076003)(66556008)(4326008)(16526019)(956004)(2616005)(26005)(8936002)(6636002)(186003)(83380400001)(2906002)(6486002)(6666004)(1006002)(7416002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: raXNd4fChnllcAveXBlfAo49fH3B8yOYZkNPM+DUizupOiX3fWxDO6AXq4Jq4UEKV8Asz4jsUogGofhp4esiuYry4xfFR5Fc/3j96yXQkTf4fEvs4YdtHJtQ1a+o1GgWPFXE/imGdgLwf0kLPqIz7flpsWMZ5//AJkSqZ8mm9u8KoZXpIkEsmbkhwfQorYDlnGAAiJ9Jjr/VG5sAL3wQCvzk9MdS3nxgtjuHzYk5SOYM0mUCUGLYM0dlnOF3WgXGbczD6mu7p9wPUq23hx4gdjjyoQuMKuPLkkJVXYViX9Kw6ahlNKco6XwtKDFb4f6sIANGMQp+2JCol7vQFkDR+4p88hhhcIG2vRr4UPxg+v4mJoaAd3Z7EGAiv6i64d5QxQSoB7onq+dw+PyIS/d8JnV/pc/Ca3E9HbyyYSxTDM9IgJO3fBeJzj+290BfvsG4g31rxPm6MC59TYf1Q++4NmDx5+AiywXHuW78aa6WKRw=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff7d112-194a-49da-374e-08d830a681b7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 14:24:57.3316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ityTJYmiO4q5Y2CoHvi9SW9KeoUc+85RDjs/KHUDAp68BGg+uwSyfPFaZ/ZQvOarA3p6D3dSIGAlj4jM7SPBUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce device_mdiobus_register() to register mdiobus
in cases of either DT or ACPI.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v7: None
Changes in v6:
- change device_mdiobus_register() parameter position
- improve documentation

Changes in v5:
- add description
- clean up if else

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/mdio_bus.c | 26 ++++++++++++++++++++++++++
 include/linux/mdio.h       |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b33701ad4b..8610f938f81f 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -501,6 +501,32 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * device_mdiobus_register - register mdiobus for either DT or ACPI
+ * @bus: target mii_bus
+ * @dev: given MDIO device
+ *
+ * Description: Given an MDIO device and target mii bus, this function
+ * calls of_mdiobus_register() for DT node and mdiobus_register() in
+ * case of ACPI.
+ *
+ * Returns 0 on success or negative error code on failure.
+ */
+int device_mdiobus_register(struct device *dev,
+			    struct mii_bus *bus)
+{
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
+
+	if (is_of_node(fwnode))
+		return of_mdiobus_register(bus, to_of_node(fwnode));
+	if (fwnode) {
+		bus->dev.fwnode = fwnode;
+		return mdiobus_register(bus);
+	}
+	return -ENODEV;
+}
+EXPORT_SYMBOL(device_mdiobus_register);
+
 /**
  * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
  * @bus: target mii_bus
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 898cbf00332a..f454c5435101 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -358,6 +358,7 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
 }
 
+int device_mdiobus_register(struct device *dev, struct mii_bus *bus);
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
-- 
2.17.1

