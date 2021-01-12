Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A158A2F31E5
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbhALNm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:42:26 -0500
Received: from mail-eopbgr10085.outbound.protection.outlook.com ([40.107.1.85]:39271
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbhALNmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:42:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrtXBn19Dpr0GCFuYe68C+6WfT0TAEcPurte1oIqBOH5H7L9yzOa25qSavaUiH2o92xL86B0l2fSIIWVfzHeAxVlyWfGaw4mM2QBs2hUdyrkrlRPDf1dRM84dHMYLKH9BCKRr0c9ZHqKSIqTDPA+VwTaUBuFP0KleXiuK3w+j/MWVzCuQSWqKNZdoOQeOC0zSH1x2zEZ1lMfyaQ8wczJD1gUyAuVnm4T1LI+4b2weMrrj3kFhw6ZukGG9UP7bi1ieX64GJ8h7z/AJbMh6cftSC5buk2ftm6ap22s/pRFryAZz7fR7cXrwjc+ZBI22PD9hDQLjpphFPqtnSXUE9DXkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvg99/QHEKQLOMQEtuQ69CsgdJQT8cwBniu9gPnex/k=;
 b=VoBGq1dO48dnK+L3w46h4rOSVFI6uHnh9AXXOy53bZpaf6goWtQtofQW3WsQBx8Et4DDnQhEHUpC5mxwuBqUufyNOjU148PJwC7cmpfm0M7KAxBURNoSSnfs16jguDJNDok2hK0hTST87AcunsQ/frSLWZdqV9kpeDHYmCDcquRULIdkjUPtEqRu3hccOQjOf2/FryKfbZpqvJ4iZNWzQswWZoe6Y77rKmUPpGGJEku1uUVCgodA1irIOGPjB7miwltMQO9dS4zc5S1wPK7Zhy3DSace9IxBj8i7jAi5wCuBKirHTPgRe6XdOKMDbSfCid5rt64VSRzvP+jF+hANsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvg99/QHEKQLOMQEtuQ69CsgdJQT8cwBniu9gPnex/k=;
 b=Qx8EpRy8NuJejF/GqlszzJQB2g7KaA4TMGS2UsI9CuxRMVOE7gqzAVWCz/GorrKAbbKWog8EUAN4iuAxkqf/UfMLiEuKFKIoA2vcSSwl1lFi4z2WYc0ycQJ0sFrHR18GmX67zqnmW5vafD9t3DlSQ3whdsopHXJFYNRiQcUyKaA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3443.eurprd04.prod.outlook.com (2603:10a6:208:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 13:41:34 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 13:41:33 +0000
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
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v3 01/15] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Tue, 12 Jan 2021 19:10:40 +0530
Message-Id: <20210112134054.342-2-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0047.apcprd02.prod.outlook.com (2603:1096:3:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 13:41:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d096dbf6-7626-4aea-e0fe-08d8b6ffc6b1
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3443:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34430A2F2045344047DB1876D2AA0@AM0PR0402MB3443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iPxYBURzv7l14Jg3y840G+gz9bKmakEYEdqWn3Venfcnf/H7OwiEydA1Cwe+fFOtfpahnqraA3TyOZIGhbrBv8L7P9j/Ikjkb7kWyUPWR32b2q2P9vvtP2BaSxPOAtUYQV9qlXRsEuxwugkfOZM2M+d0yNUqdF3PpPN727LksMxd/WnH4tjok/SwjgU+C6WTblvzq5zRytNVENyE+fNVY/BvrbbJnsKwKyCM+c0a8eYcB7Z9Zv4T+H90w2D78IW/YiWh+C1IF88OwNQdZMsHc0fzvbO+ag0vaor1lLIa4aHAH4EMbu2nRNMTFSzASkPnhMb7KeYfnN8rBADGFtrabOH/UKuHul5NeXQQhPscwG2478N37sMqt9hWSow82bg3um2mbwlZz0p3Q81rz8oPQ/X7FtaxtsoeDOoYpLvSmp3wGEBnRz5Q9sOkJmVufmMIu4YTZZuCG9aRpmQC3RWjVm3LM4eS4a+t6eWdTXpfePwkDpPZWV9/jEAojxOikgjF5aljh5CEj/j06CPdiFmRDMKBV8NyUuIrjjSTpIIye5Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(478600001)(1006002)(66946007)(921005)(110136005)(6506007)(54906003)(16526019)(966005)(83380400001)(6666004)(52116002)(2616005)(66556008)(66476007)(186003)(7416002)(4326008)(956004)(1076003)(44832011)(86362001)(55236004)(8676002)(6486002)(6512007)(26005)(5660300002)(316002)(8936002)(2906002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qVKwrRFnlmMXLyNdlrw6EFt9DgkSZlALw95DK4WE+Nwy5BsEINe/S6rLfKet?=
 =?us-ascii?Q?O6NReGhBsk5TJiRInVvcJhIuyLf3XoSNOpDRP/As7L5HA1vEK3rJosKBm30K?=
 =?us-ascii?Q?6aUDMpPI2H+yR4z2AK5I7X6zmMY0gakYnNYsjYMeCO5hF1q5Nt5DSodzOPdt?=
 =?us-ascii?Q?cg2gCLC+cVDxKXn42DFUg+TK/h+8cajEgMI6nUsjzzR9Xwe66rWJFjfHymsY?=
 =?us-ascii?Q?ffdDEYKdqLtrhhk6HTk6TyqpXk/v5UXCrEuceYnHhrWAjRO7SC/hje1/hd0v?=
 =?us-ascii?Q?ZwnpBK+dG3+IzCI30/O6LHnYADWqAF4spFQtZJYYNhjJZHJM4Nl12vayPA2I?=
 =?us-ascii?Q?zL2asxWacWW+XhbcGGPGlVi3EVVqQ6A0zK/fRO4Ex8fls3W2Hb1ZjGecgcEG?=
 =?us-ascii?Q?7qmSt9OeG8J5CJ9zb6a9KQylZtnVWo3ZrxNiFDRivpZijQ6HAy+iO7FEL3Ss?=
 =?us-ascii?Q?jTlWwuytDw4fnTQDmyyEGKCDJMVUZ5RD1stW1Bz2AEJYdZIJxupyirydQkD9?=
 =?us-ascii?Q?KrnEGOmXg2Lz7cnIqpE72dFz73z8Pwy8i79maWpgZl5aQPRO/vvCMn5lVfX6?=
 =?us-ascii?Q?LYYI7j/UeYABXc0WxTxekznfzEeUQCiJdZeFhAYJuI3CHoTaaZlQ4f2Rkpxy?=
 =?us-ascii?Q?aqs5zgLFvbHgJlN2Ugr+e5l3TTiOLx4VrjksrJIQ8q32kj6BWKcwUMR/zarB?=
 =?us-ascii?Q?ExzKaBXyiH7aduc6eGRjpFI5FGCnEvfrphzztYvWnM04FXT2ySbEHHgibot+?=
 =?us-ascii?Q?23JRqkz+y4Bit3jGIuVH8U06ekxvxDylQZKGZ9eKTSSq7t+UtIJ2I8lJ/kWS?=
 =?us-ascii?Q?6SwrBIkE5xcVF7Xuc0YV0oJtfnALIpJPzEAy6ZMgxqh6HGQyk1DmPUvCbDYq?=
 =?us-ascii?Q?AO9ATb60pZ3tvk6A3L5LWM+cnJ3TjvDb+A1wDbwHexeTUWoeIrDbcfxYw/VG?=
 =?us-ascii?Q?/OR/dwaSoYf+Y8PGkcE6WuGPyufoskGML/y2avasihzfFu1wN2RubRFPvRts?=
 =?us-ascii?Q?3Mnf?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 13:41:33.7947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: d096dbf6-7626-4aea-e0fe-08d8b6ffc6b1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Q+YH0jAf3P91+CVk5kvsswan2ClkOBQ9K98PMzK5orMYJZgXBu8HLnUU3weNjq/Yd2VEyIs7/DWj/sYGkTPCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3443
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
Changes in v2:
- Updated with more description in document

 Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
new file mode 100644
index 000000000000..a2e4fdcdbf53
--- /dev/null
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -0,0 +1,129 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+MDIO bus and PHYs in ACPI
+=========================
+
+The PHYs on an MDIO bus [1] are probed and registered using
+fwnode_mdiobus_register_phy().
+Later, for connecting these PHYs to MAC, the PHYs registered on the
+mdiobus have to be referenced.
+
+UUID given below should be used as mentioned in the "Device Properties
+UUID For _DSD" [2] document.
+   - UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
+
+This document introduces two _DSD properties that are to be used
+for PHYs on the MDIO bus.[3]
+
+phy-handle
+----------
+For each MAC node, a device property "phy-handle" is used to reference
+the PHY that is registered on an MDIO bus. This is mandatory for
+network interfaces that have PHYs connected to MAC via MDIO bus.
+
+During the MDIO bus driver initialization, PHYs on this bus are probed
+using the _ADR object as shown below and are registered on the mdio bus.
+
+::
+      Scope(\_SB.MDI0)
+      {
+        Device(PHY1) {
+          Name (_ADR, 0x1)
+        } // end of PHY1
+
+        Device(PHY2) {
+          Name (_ADR, 0x2)
+        } // end of PHY2
+      }
+
+Later, during the MAC driver initialization, the registered PHY devices
+have to be retrieved from the mdio bus. For this, MAC driver needs
+reference to the previously registered PHYs which are provided
+using reference to the device as {\_SB.MDI0.PHY1}.
+
+phy-mode
+--------
+The "phy-mode" _DSD property is used to describe the connection to
+the PHY. The valid values for "phy-mode" are defined in [4].
+
+
+An ASL example of this is shown below.
+
+DSDT entry for MDIO node
+------------------------
+The MDIO bus has an SoC component(mdio controller) and a platform
+component(PHYs on the mdiobus).
+
+a) Silicon Component
+This node describes the MDIO controller,MDI0
+--------------------------------------------
+::
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
+	  } // end of MDI0
+	}
+
+b) Platform Component
+This node defines the PHYs that are connected to the MDIO bus, MDI0
+-------------------------------------------------------------------
+::
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
+
+
+Below are the MAC nodes where PHY nodes are referenced.
+phy-mode and phy-handle are used as explained earlier.
+------------------------------------------------------
+::
+	Scope(\_SB.MCE0.PR17)
+	{
+	  Name (_DSD, Package () {
+	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package (2) {"phy-mode", "rgmii-id"},
+		     Package (2) {"phy-handle", \_SB.MDI0.PHY1}
+	      }
+	   })
+	}
+
+	Scope(\_SB.MCE0.PR18)
+	{
+	  Name (_DSD, Package () {
+	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		Package () {
+		    Package (2) {"phy-mode", "rgmii-id"},
+		    Package (2) {"phy-handle", \_SB.MDI0.PHY2}}
+	    }
+	  })
+	}
+
+References
+==========
+
+[1] Documentation/networking/phy.rst
+
+[2] https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
+
+[3] Documentation/firmware-guide/acpi/DSD-properties-rules.rst
+
+[4] Documentation/devicetree/bindings/net/ethernet-controller.yaml
-- 
2.17.1

