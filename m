Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEFF21BAFE
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgGJQb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:31:56 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61635
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726942AbgGJQbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:31:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+xfqUJas4gvmtnF53hVf1CpfWySdcM/1EcU5iZ5tXo0yLTayA0BVj1Eqtos3d5F7l+Mu9RaBunVZuvkzwiucdYJFQtEOA5VnNWNLhr6UOxs/waHQXVHAh+/c4c3+clVtHv/b0YpiOFU2ImKWMoZ3zwBlx3in7KiTciGNFe1orbcDVrbdSaQXJ302XENxXSRVg7QdZtfddDmS4IYf84hU1np9wetpDPnKdxsmfPGoKKEcQ6Xn04rU9hHhx6mC1oUYjXMZQ8u235MZvBzRmkR3WrFWfd4dfFTQSdnb5A+90+nkaNhzydnWDvAOMUu9VYtOScJcz0zHU7VcNDH4BzIfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swYb784uXNNedaZdomPeA3PvhwR1PJcZt5VTKLNVVq8=;
 b=N6Fk31y6BBfV0RBrcIHFMlpk6Gnij/jYv/xq6bTpjzVnp2LjTmYbsadi5RmsBqSa8x/9akjf8LYN4lIUsSg54xBugG2hIAXiqKHShp7XN1YsNRezkgCAWBW2sRFy+BkG1Pepwb0jgRZf24bstXDVriBXypfFhH5QLjcOGqrOfY7iIRK+KWWWlAr8wpBsPpsiHoMry11GCyZnR1KNGMAekdTbOzxO24HnauSA9yb0YXnQ1J1tLjYfAbPkzt/3vzG60fEAYsYVPAgPwt774y4IBQD4xZKlEXihAiT/4FHjJNQxzRuD33mF6c09GdIl1HA6QwzFOaPev9p3c7Si+K7nQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swYb784uXNNedaZdomPeA3PvhwR1PJcZt5VTKLNVVq8=;
 b=YULuQgLj9w2EuySJEz5GQfq73QFuYIo67IEOMe0Ea4U2BI5IapdUuC7sitYTLdMZliTiM6YfQunpI6VC6/z/e9fFwH63pL+mUa610meeNErIC5STop2/BTeyDbSYfHjknDWBMU+RsIv0v3ZjjToXgDFY4SsT8YrfxR8B06kxYMQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3908.eurprd04.prod.outlook.com (2603:10a6:208:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 16:31:51 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:31:51 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v5 2/6] net: phy: introduce device_mdiobus_register()
Date:   Fri, 10 Jul 2020 22:01:11 +0530
Message-Id: <20200710163115.2740-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0137.apcprd06.prod.outlook.com
 (2603:1096:1:1f::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0137.apcprd06.prod.outlook.com (2603:1096:1:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:31:48 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3dac5870-9951-4457-b180-08d824eebfbf
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3908:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB39080E4473E26C0924B332CFD2650@AM0PR0402MB3908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqrgrDoP93iuc5ADDFgJhvSoRmDO7yq+3b92TGyzf17pMdEluDttnwYQkQubW68NlvK88JqY8iyfkHnkRacYfA6mUma+F42+Ji+yJkNL/7XJHtURKwAKptKBn3Aqwr6QyR0vHZhCpDlaxJ1ELEFrhJidQ7B39+IF0oR13zxwwQF/qKCWOfaT7p4+rFhEplcxd+TGtkkoU1fZkF0zWWJi+7McHko1ma6AkH5ikekloDK5ykFsDqkH8RtEWPVhs1JbjIVKnUJ6oVaDbGhogzi+L8vTQ5VR2puZI5ENXkfyHP8vM7eQZ7zSL+sWKTu5+PaLpcYAKoXjLa1K/o3eiHuyI0Hs/Ol68pFRuHe3+KmvidYK1g70TTTKWwiojliBMBUN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(8676002)(2906002)(8936002)(86362001)(26005)(6512007)(52116002)(83380400001)(1076003)(6486002)(316002)(16526019)(110136005)(1006002)(66476007)(66556008)(6666004)(478600001)(956004)(66946007)(44832011)(5660300002)(186003)(6506007)(6636002)(55236004)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: j1Ki6x1fYhV+iie9TLLjX6WRD5LgPVkO5c7u0Q0G8BSVUvg0bD4EpzKrwJV4aJek8DLERwAKHi1i6CkMvs/vUaXvrJB6X0itjbbdroE9bcaEVlvaDP8pWTvV+sIrfQzP1bHUkHbGS0uxKS3bFl3n2E1yf7KkGcerBJ+22ejrl8viKUVtjkf73xaB8pV19dltFA0lyoZwyuCoXtIKC3p9rfGAY0Yipy5uKFaofaHHqt2SVijuEnDLNcuDm+DgrCjYpncrdDt4ZBJgX4oL8OTjR+rF8cLnfmOd6MIwM8FRJs8rz2wTV8fJhiR2M3Fi+7S+Z78LQVFCqiYDu8qjcUAOh7W20I4H7DdMNrtX9wZz/mFQS1fo4JCt4/PbonS9rhWn4YYsayIbnwJcQhfC83iB4soyt4lGmosLRkduGqeYc04P62WwEDNvHocFraQciebSmBnZ+hqqU+MhiSqogsRKVcwUtI2dUdKhlShhDas2vL/Y9z2yxOBVWrDPKzOi7dF3
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dac5870-9951-4457-b180-08d824eebfbf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:31:51.2441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F0M/ZHnFVMbwbDHoXvzrM1kBgfcZv6y9xuXBeXe3OlMruC2IhcXRHIrLJjmvMHXUjJIUmdf9CjPe/ZMAuuBlAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3908
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce device_mdiobus_register() to register mdiobus
in cases of either DT or ACPI.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v5:
- add description
- clean up if else

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/mdio_bus.c | 27 +++++++++++++++++++++++++++
 include/linux/mdio.h       |  1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b33701ad4b..2b6f22e64ad1 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -501,6 +501,33 @@ static int mdiobus_create_device(struct mii_bus *bus,
 	return ret;
 }
 
+/**
+ * device_mdiobus_register - bring up all the PHYs on a given bus and
+ * attach them to bus. This handles both DT and ACPI methods.
+ * @bus: target mii_bus
+ * @dev: given MDIO device
+ *
+ * Description: Given an MDIO device and target mii bus, this function
+ * calls of_mdiobus_register() for DT node and mdiobus_register() in
+ * case of ACPI.
+ *
+ * Returns 0 on success or negative error code on failure.
+ */
+int device_mdiobus_register(struct mii_bus *bus,
+			    struct device *dev)
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
index 898cbf00332a..f78c6a7f8eb7 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -358,6 +358,7 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
 }
 
+int device_mdiobus_register(struct mii_bus *bus, struct device *dev);
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
-- 
2.17.1

