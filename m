Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2B122D816
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 16:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgGYOY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 10:24:57 -0400
Received: from mail-eopbgr30079.outbound.protection.outlook.com ([40.107.3.79]:40165
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgGYOY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 10:24:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcuNJJlEO97hAOw4zkeixS+3/coTA491kcvnVbABlNNhbob2VMQRabe0zL7eTvlL4X20ADLP784cULJkpnRlB8vOd+DIoaZPeM+R6+0Pcevm9MGGTqBD/fAZBvAL9fkNTdy4nlc9VNr1zEs/iiKTMoP3UNku6IOu7+0juCuoHfCAz4aqxOy03d1QCMFeZUikmE1S4HpBdZ5MAn6rvHuyFLQ/Wgn64glFixJIbR+Y3FtY35FdQRSvD75X2ZvcqlbFssRmgOx5fpjhfsrIlvG4q7NjvQ9IU5bFheSZ3dkgN+Q4uK6BfAqAsz+MHF+IQA8qSSEIXE3rXUJV5C2RfktPXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ5XZbCs8RAzB9lYlq+k6vXcMgO69MZn9141tCuCJnc=;
 b=i3NHEb3nlsd+LAkUbqvPzhzBjz6kV0BWE+x6P8dcCYWfUhDRSiCZSs7jkMDyX8XiZXCEsJZtCQ6BZqsTw/b+XPUZFWJXRtSSID2ly9soKfD2nmVCfp5zUGk+FZ0aFYG1nF7J7uY4AQ9YSA/L0rvA+SaEkIXOl93Deo5K9mvChwOrgayZl3FK3K8YZDjlXVMwvNllZ56u2JXNVogqARF2tsFwD3zTsXK4UDfnHrk8SckQxj9R4sDD+zslGrf9dlUumXPKR7h+GPxkvvPUsWIXVSDjW5GkHLdQr9fLBUtZFJM4/kHLR8bkrCVtX1hCcjxPmBRs4LvrlJeFLWJslpLgrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJ5XZbCs8RAzB9lYlq+k6vXcMgO69MZn9141tCuCJnc=;
 b=YhpK8PnSk5YjIiGA1M+U/T1Hdd/fmET0xyO0OG10an/XowHklzrctdcXH3F6bvgmOV0UTsaREaGpBJ/xlGwAptTAfPjeAAJebcngrF5Cr7bxF0o2/xYr88w2vGkUeDUK3zefJgd6IaHzF1goGdNwwh2GUUffr+mzZ8E8Ku4m7ME=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sat, 25 Jul
 2020 14:24:52 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 14:24:52 +0000
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
Subject: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Sat, 25 Jul 2020 19:53:59 +0530
Message-Id: <20200725142404.30634-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:3:2::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0018.apcprd03.prod.outlook.com (2603:1096:3:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 14:24:47 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7528a1fb-aeb2-4915-b731-08d830a67ecc
X-MS-TrafficTypeDiagnostic: AM0PR04MB4931:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4931E98FA88A6EAABE6E8FCED2740@AM0PR04MB4931.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0KSzN4liIv+V8qXiPMqVVS9Q2dl8+J9JzikUFvwLqrnLCiVWZb/Smjbpg3UMIih8x5ix5prK3x002l38AUfubbbM7ZWJyBSNOVgWMIhQOC3YrvW4/eR5Eq2rlEFAzsWBGb1CDjBJQVe6iibqBnufKpP0XB8OVcjo8KVL3okTY8TatnZ/4ERYloc3qM4Z/s89IXLrnEqC0TAHB2WZ5qVXJPRHTGMMsVMek7th+Bw+QUJz7J1VE5pLCCPS/stVIu6NPMP0JfR5/zBmQOPE/JKZAqEOIOz1W8QTIL0kBAY6eQqZd/yWOiaAjf/M0tKNRpEQHNeDmLIzzTl7p/aWK10/qjNPkMJ3eajKrrCANwPRSxOnPqA9uWhqgbl68EG4Aj4MsDvt8eE9XD67G1yt2SV9tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66476007)(5660300002)(6506007)(6512007)(86362001)(55236004)(52116002)(478600001)(44832011)(110136005)(8676002)(316002)(54906003)(1076003)(66556008)(4326008)(16526019)(956004)(2616005)(26005)(8936002)(6636002)(186003)(2906002)(6486002)(6666004)(1006002)(7416002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HnM0F4Xdfzp9dHtoBW+KH/1xnNx7asNQNi9js4vtW8N/sbQo9je6OKhlmItKOi58tfsSLGNboJ76vsOJZKwY6gliT86J4KBeYuWNekqPoIWhNzFwQqXX3VhhpllCOlh8DTW38lGOPZnM/i7usidpQ1U+bmQghH2qNb8VK0iQK40yOd+ZK8nwwQgwgzy04227svt4T4RgfBbMs1nGWWd84I6rUQVeQ72NyZZHUTPpCDChD9EWRV1sJAU4Y9t1GQWmXB/0Y/vYx6duEVapP7GjKUQOU3I9D3bkFzaSjRKOkYQAtpeqDodQMIwZ/rqedCEczcI7XvbX2L0SBxCO665IpWy0w89x323+FAfgiWqS0bDfwtst6SnQR2Z4IuR863c1y7vIXWFxhk8/DukPf9IwYwZ3Md3zMNPg753tzHDGXIzycY7QLDTsaL3UPu32jWLoynI1AcaASVlLKikfB7wNfSPIONm5zBm89ekXjXmQJLA=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7528a1fb-aeb2-4915-b731-08d830a67ecc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 14:24:52.4574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cHlp30Pg4TB1mxklaBS3qyMVLmA0aoGdxQTzNcUfE0DD556dutiJ+OqWVexcT2m5u4wJ4BZZF2uaenFHyi2lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
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

