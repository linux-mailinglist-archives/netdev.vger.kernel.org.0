Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB0721C2E6
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGKG4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:56:40 -0400
Received: from mail-vi1eur05on2070.outbound.protection.outlook.com ([40.107.21.70]:33732
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728086AbgGKG4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 02:56:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mucZXGceOCXQy7TuwPCf2Oh1SSNUsfHFutb0giCJ9GZGPsKVYBo+MRbbdJmDP5+oGlXUQE21O0xva+3YbqSJYJzDS7f62zQWvKnA54tsZzD10EqGNp/c5AWkJ1XEAJGiQKpz2LE4kstopZ2YGuHgdSeZVIrUUVjnxyo2YoGCJtK/KeXya9AvTLS5ppA6aCGGou9BSiyRcua70hjGzHC8mMVvEyiaHp/H8rDzzEcjhBVa082SvvvV+ONtUyBPH2/S7ORz+r/kCK0jkRQxKfgghstJRVme3a9uJUhTrENWBihm8v2677H2B+1+ck+NxGHzdoDv5DwCUCMZnl33iJ0TkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiY8l12SZLqO1UlXDq0SQvbRvbu7GKT9Z72GXeUaEeo=;
 b=m3hsdR8y6XDfCKOWEWrqw1cIz4Bo7/TMo7/aBdVZANFGQYa9CFf4MJO6HqQcXp/UqGUcYVDFqtLJPfPZAprQ60FsxrQWzgEO7CNJpqd2e+Vpw3X540kcoBkd5e9uvQNjwpXCrFtET5WiyD8pHZcA4RdYubDzIkeUuyf4knczDRZess27Z63GVE9lPlZ6oZmaakC1iH09ljL65PaY/6h0oA+HnUA8ey8KUvobL7g5Z9GhXqtvvOHzsLaPf1Y6x6097KvvUo0pbWLR8gxwtKZCs2CaFeEkQwbqxCts7OXg1oLESFZTVEhXEp/uVtAFOs8ndz5w4yj1VBERvffgal1DuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiY8l12SZLqO1UlXDq0SQvbRvbu7GKT9Z72GXeUaEeo=;
 b=JFvu80jgDA1mbNZp4vfK4I506Wciiv9LUfOq2PvSi0SbWHDcAS52fYBvy9GYFHzkQ5HoD2bhq7lsXqyx3td92dR8K9t4rZelwiTG2RO9mewweZF3Wlkz5/D8J3lRPqTf85Oqz4OcUOzVo+Ie18bPms/KhhsqZBHMVKEwAKyiYws=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6961.eurprd04.prod.outlook.com (2603:10a6:208:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sat, 11 Jul
 2020 06:56:35 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Sat, 11 Jul 2020
 06:56:35 +0000
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
Subject: [net-next PATCH v6 1/6] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Sat, 11 Jul 2020 12:25:55 +0530
Message-Id: <20200711065600.9448-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0132.apcprd06.prod.outlook.com
 (2603:1096:1:1d::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0132.apcprd06.prod.outlook.com (2603:1096:1:1d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sat, 11 Jul 2020 06:56:32 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a190828c-2b26-46bd-739c-08d825678d4d
X-MS-TrafficTypeDiagnostic: AM0PR04MB6961:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB69614D47D1A3945B92B26981D2620@AM0PR04MB6961.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNpe1crDu3noWp7ku99y9tkLolozMuKIKMUX1QNWzJctNw4c7sxe1+el2jumgiSye8iKGive6g/3PTag7zQK3ZjthlP8hkMt77HJ3/5sE9s3jwPXpbCAxweRDQhvDzZXnuJnSbg/XpbXltfYNokavLKI2oOj0DdqG9BK7o/tcEreoLVft4+ZF3XIU4w4TT5iFQpdlEW355iMkCEAJV2DaBUq+P+/uaDH+DK/K8mhwQcgQTVRTTEVe9ZHtiVYDqniBoVyQIRCR+/jBk/uM2aOzh8BFS90wmpn9AWcOWzDW33crXxV7S7wJDVP5XN3KPuiFI9Q9lHfLip1/NI5cgG5hVvK6fA7FqJfLrNzJ7YRcTjdY+QiZm/pEGy5ckQmVtgj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(26005)(6636002)(16526019)(186003)(110136005)(55236004)(66476007)(44832011)(6666004)(66946007)(66556008)(5660300002)(2616005)(8676002)(52116002)(1006002)(6512007)(316002)(6486002)(6506007)(956004)(1076003)(4326008)(2906002)(478600001)(8936002)(86362001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L/15utOBep16o9nv6HziFyOllN8d4am5XJOLdVnIEgA08qP57PA8NmliqnZRB7YoiCjyGFO3zbg48ooHb4BFewaIApBuGC08fk0JEd1d7ECJt6eHgq3l0Q8rAaSuLv1o4Vz6qZ4uzwB/hSvWsqnPJHc5jLumsxPFRT2If0vkzVwjtUxGakqD3K+9/H61iuj1DwZBdoJ6KCStsP+wqYKvIjmUIqlgSh7jFLRUWmCu5Af5Pt4bJWgjWhGtVU3xd3mGT61FV+y/4J1bP9PyrZNzQjrzO4u2F90rCsTaN9bRy9ZRJkJxuzuNhX9PjBIBQIMMlVWRurXpL0sai2mbmS6dZWtAb8dtbIydT+arVMfO+9SsXTpp5etW5THc/4PrdmFstm9aWLVct7WT286W7wbYWOD6gRxbRD+hmLwLoqJ3BZAIajcflFMGlyGvLoDfck1xSHQ5D8Bn+jCvy9++/AznhUVFuXnxGx4e/IJpEG01YPCxGTysSHAk+5xGGqFc58S4
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a190828c-2b26-46bd-739c-08d825678d4d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2020 06:56:35.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StCChTJBzU/mfg6mcfR8Xyz6J2zZv9ei0TmiGfwRpXt7CbG+UgusAFoSHSKWEWr95jg/EJwx25sNPZGl5Ehz3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

An ACPI node property "mdio-handle" is introduced to reference the
MDIO bus on which PHYs are registered with autoprobing method used
by mdiobus_register().

Describe properties "phy-channel" and "phy-mode"

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
- cleanup based on v2 comments
- Added description for more properties
- Added MDIO node DSDT entry

Changes in v2: None

 Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
new file mode 100644
index 000000000000..0132fee10b45
--- /dev/null
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -0,0 +1,90 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+MDIO bus and PHYs in ACPI
+=========================
+
+The PHYs on an mdiobus are probed and registered using mdiobus_register().
+Later, for connecting these PHYs to MAC, the PHYs registered on the
+mdiobus have to be referenced.
+
+mdio-handle
+-----------
+For each MAC node, a property "mdio-handle" is used to reference the
+MDIO bus on which the PHYs are registered. On getting hold of the MDIO
+bus, use find_phy_device() to get the PHY connected to the MAC.
+
+phy-channel
+-----------
+Property "phy-channel" defines the address of the PHY on the mdiobus.
+
+phy-mode
+--------
+Property "phy-mode" defines the type of PHY interface.
+
+An example of this is shown below::
+
+DSDT entry for MAC where MDIO node is referenced
+------------------------------------------------
+	Scope(\_SB.MCE0.PR17) // 1G
+	{
+	  Name (_DSD, Package () {
+	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package () {"phy-channel", 1},
+		     Package () {"phy-mode", "rgmii-id"},
+		     Package () {"mdio-handle", Package (){\_SB.MDI0}}
+	      }
+	   })
+	}
+
+	Scope(\_SB.MCE0.PR18) // 1G
+	{
+	  Name (_DSD, Package () {
+	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		Package () {
+		    Package () {"phy-channel", 2},
+		    Package () {"phy-mode", "rgmii-id"},
+		    Package () {"mdio-handle", Package (){\_SB.MDI0}}
+	    }
+	  })
+	}
+
+DSDT entry for MDIO node
+------------------------
+a) Silicon Component
+--------------------
+	Scope(_SB)
+	{
+	  Device(MDI0) {
+	    Name(_HID, "NXP0006")
+	    Name(_CCA, 1)
+	    Name(_UID, 0)
+	    Name(_CRS, ResourceTemplate() {
+	      Memory32Fixed(ReadWrite, MDI0_BASE, MDI_LEN)
+	      Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
+	       {
+		 MDI0_IT
+	       }
+	    }) // end of _CRS for MDI0
+	    Name (_DSD, Package () {
+	      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+	      Package () {
+		 Package () {"little-endian", 1},
+	      }
+	    })
+	  } // end of MDI0
+	}
+
+b) Platform Component
+---------------------
+	Scope(\_SB.MDI0)
+	{
+	  Device(PHY1) {
+	    Name (_ADR, 0x1)
+	  } // end of PHY1
+
+	  Device(PHY2) {
+	    Name (_ADR, 0x2)
+	  } // end of PHY2
+	}
-- 
2.17.1

