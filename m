Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C82C220817
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 11:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgGOJEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 05:04:38 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:46210
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727930AbgGOJEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 05:04:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofpuwDb9c3Roj936upXSDSjoiFUsW4+T3x2p7TE6X0WEY7J26GkjsK6WdddqNkHsYXHWoQC8u1ldvnY4xmmcP1qzo2xmBGqfB6NYwMJj+M5sH1ZT09jpPr+itYCnW9aTt/7bWfV5XdW/fPOMrkKE5Aw1tHaMX1R+Ya0jvkPzxStG89ou1je9wkRS+5/2lYpVeaV9LkX2IZoPhE9ZlSz/iM+80dPoBMevWtF/RIM9kobzYWNBAJBdgwjwweU+FDI2kXSfuap90Cqr7vUXedn2+LvMNR/rvfet4/xczCKyOnU6tIpAw2YtDQ7MqwJ+EKihncw6CJPt0dKXxLvhwWrxsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ5XZbCs8RAzB9lYlq+k6vXcMgO69MZn9141tCuCJnc=;
 b=c0A1gBsbPDqmaHQzEjZIWMWNDOQlnAL7o5kC3UoiWiB9/Y8APQOrHXBVk54iGvkubtVE81abXnKEQjLN3hbEtm1eHNsdhUqz8BwdZyR/pQ0AiP59kJH6CaW7dhFoCH7PfekNLdKjON5KRX0EqYqRnq3mWY7gb+9Qr4N2IbSzAyuHqpaYNfhWNvLJLF6YUSHNRp5CXrDbFDGQ4y9u8aMopLXYzS4rBQJbzuyzpYeHiJuWGxFWd2hgPeQ6cc3KMDQlYpfazt/wxopi7/n+AhxVld2PFcUJWHmrdUnwXzp3olm9/0vpimOV2rmUPLw3O+e9+D2LDyt5fQDXfYKxvAcm4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ5XZbCs8RAzB9lYlq+k6vXcMgO69MZn9141tCuCJnc=;
 b=V/zv+qxOIQL9J1JmDG0VranoeInquNJkCdZPbVGCSWJzliTH1Id8S6Wn+0j8BBBBRUaF+GKl5ERg9oXOsuHPtb/CeTWvrHUmbBWI1wFWnNLYLemrWxkWVn1oKOOu47oZqikOWEI3KpB9HIsAJDl5Om8BtI02yzSmOFO4OI2dVvE=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5203.eurprd04.prod.outlook.com (2603:10a6:208:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Wed, 15 Jul
 2020 09:04:34 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 09:04:34 +0000
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
Subject: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Wed, 15 Jul 2020 14:33:55 +0530
Message-Id: <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0070.apcprd02.prod.outlook.com (2603:1096:4:54::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Wed, 15 Jul 2020 09:04:30 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 342b8908-4354-4e8d-d8c6-08d8289e1790
X-MS-TrafficTypeDiagnostic: AM0PR04MB5203:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5203E27405B13588EFE2E2F7D27E0@AM0PR04MB5203.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBkCSq+3odw7n6NsoUNF2XOta3Pd+JSjoMUU9LgGZNOQbIXOrTj9v98LinO32QZRy6oVA2cQQTEuaVIGB6joKpFoe9TFZC+u0n+FZUz8N01i3/fnFmZmf2Dr/G2gOQua031fYYe9PVWXUKvYptEk+U9+71/a8Kx80IwUSceIJbhqNGp80J3MaksegvrrMvwjkIp8zw23V5XqNAjWt2Yv0rV+U8wMcQtzh5FPjmhlgQWhN0/LId0LciuAxZ/g/d3PIiY5tYsdmfZ9p3SwoRgTrU/XPi3pcO8yla7AKqTC/c8E0DphasCg9WEXYZFxCKxgYMSvRzo/ZkgNIeHXK4bMQ0VmrNjJYz42TCguDm45YN+scG0q14/xFHc0tICcxLdh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(86362001)(6512007)(8676002)(55236004)(6486002)(6506007)(8936002)(5660300002)(52116002)(316002)(1076003)(4326008)(6666004)(1006002)(110136005)(2906002)(6636002)(478600001)(16526019)(66556008)(186003)(66476007)(956004)(2616005)(44832011)(26005)(66946007)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9t97ghRdAd/CkaQvE6X/i07710+nmR644TWb+xCCVsX0/74ScMm5vrH1rqZj/4/TIgQCnBYM63TdxlzIUCbXx/x5T0vnZBszSJyli+/SLmLVJnb9Ig8lcjVHh9uSD7kJf93h39N3oBLfb4CWJrKeryVOQaFfj40ZSSW+z1eXpyRP7csKbRrMUnP9M5CYtgiyMIvFkEnld0aJAhcIAb4NXQIEX9mYrxfIQpQmYNJP6bW3IgqINoE2MOt/MWy68kWKIzGdPmFVIE9ieOSrEEdiP3840v8jlAxtvzCdF4J4cCuP7FyfTQ4saH/QOH0y+uUvvjWowXgY8grw+iHR2B5n5rdeVxSSGzWIzWrirD0X3juxX1naqFFKuEe9J2bC90Fy3AzBZ2umioDuIYhz28n6nXgajBr4cXhKeanDpnsNTaKf0/h8f0WehCIGjxCh5iAUZCMs+53cBM67SfX7leAF5uBRiry1/547cmAk6KDvDhmJe1wy6XwjWRvAFdnwqpll
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342b8908-4354-4e8d-d8c6-08d8289e1790
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 09:04:34.0036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCxwYTqmbg8fa0EIbHZJx6oMAt/6aIcdzNbOADS99J4064CIQbvttFfN6U7Ahx8iphEqICXM4tQRnIC3CkALbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5203
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

Changes in v7: None
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

