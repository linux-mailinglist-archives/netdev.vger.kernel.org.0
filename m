Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCCE336C00
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhCKGVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:21:02 -0500
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:23108
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230048AbhCKGUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:20:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z308nNrkKMnyrS+ObIg5OTPsMS7lFcgNt/c/JdyFTcBySNpoZGo7oQzSCCTA55H3uNR/PFxL/yrMzhmLiVgxLuMU9z/a74SIs/eZjffM2kekeoGiA9PoNtYGYbYXddAJaZmzYvzBLcSMCGfeX+qgMwvut+p6sDpMx5OA4Ie7+Du8V6SPDIcHemyIbiwyY5v8zraaXxXeUKz6Cjg9wKoCMHXz4lLO2s5kQS9QrV91ycbX9eETqnk+TUH8+VJ9QwC3VaOPfU3sK6Y0R0UWYprgkuPCSHOsKM/X+Xn3RfOUPS7msxkEEEmy1WB6FrB/ovPKsxuSvxUF0GKrljS+WsDOwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywfRFD+alcZoBdD7gV1eSqnbgfkHyn/q3/vr1iPftP0=;
 b=Pja1W8z1GmmmthVTdBwlkh9+7tKtBS91vUMHHuJk70WgflETaStrmp9gaVolgoAX52E6bE+g/kwdNxPyAP4wYde8UQHeJchtLsaaG2CCw4mzJzXvae0RLZXW9SC/yeteKl+bTcaH+eC5SwUnZRMKwurMwP6E5dyQl6cTVZQ/vBsVKJgq90dliDZQbxFgZldgJBGrxnWZhlsdvK22MYoJBcu6hmP9Q/4QLyd2oVKv8oLuOg+Ez4H3J+RE0Bx5P+pO116A0Lf2zMdNPNW04uM1Ybu7BTT7fYo4WPs4X3XAGJ4YcnpqSDnpBSJ27CB3bX9IT0QoHqSIMBndzfplrafI3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywfRFD+alcZoBdD7gV1eSqnbgfkHyn/q3/vr1iPftP0=;
 b=LRRkBZjVtsWhR5K46QGjOUvFxf3cSiMtzpp/jlXFAmzpYmCyYoPaltDaRq98z0iv17E7m5RiMZq1m2hh3VZkIC07Rd7swwhmbNgyn8rtDgLQmkoFosxld4sqRoobocBGhzplKwGshoRE5eZM2FCbRRAyKV38+moz38v+5/DA1dw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27; Thu, 11 Mar
 2021 06:20:52 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:20:52 +0000
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
Cc:     linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v7 01/16] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Thu, 11 Mar 2021 11:49:56 +0530
Message-Id: <20210311062011.8054-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
References: <20210311062011.8054-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:20:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10f97422-76a9-4771-695c-08d8e455d1b5
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3442047814E9B2637254DEC4D2909@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6y7mOLvW/pUyNn6c3Bh/Cg4wilYBZLqmhX2k+sAOnJW1LyBtSnchsqiowHop5idRlHBok47u7AoTLg63r0INR1fgqlX22cE6XhrMDIq7VLGX1cDfJo6OiSnOQCVED8wbgEHZP7+ZhdNXJg/NhjAt8RfPXR93ubGulSnRTY6nJZgoLianKTDk6eFFTrsjhmN1mdon3XtLS3fDR/43BFaqWY0byaLu0V8+ybgoICN40ZU2zgzWaBVJ6atuYCUHnvFszqeC3UqC0BLdbULOuIjhQP9ON3lp5um1tYAEJNv5+fR3PPrIdIlnK4lfjBkS4UysIiiyD65IMNyIGJrZwt9zuAK1WsQP7+ZITkJIIx0uJlA9IeXpLVpOgDiIeMC/GuAofWTRU8MFYtsjGyW/XGRNVdw/1DLoa1cZIn7dWtPUTnN9RZQSSlQf6bEFyKXUrAxUFfBDZr+qTLIs/vao72Whpq4NyZsFj8xyjxTBPkupA8w3aFhI9u5WzIgOhMTSu5MlRS5ItYTPk5ZTdhSZairwg1WLd7l5soVKkV8hHc0nc1aA/fHrF6l7A1DIwVuu7YKuqCp9qGUsjGpJmosApkbT++r4WwH1h1ZKam6xIJ98UmMlbi61NkLuPMvL1UBnWdoPc4qKXkRmYRb4PHee2KVxSTtg8kRWp6gzrl7Jh1s5af0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(6512007)(2906002)(7416002)(8676002)(6486002)(2616005)(186003)(6506007)(86362001)(26005)(921005)(83380400001)(110136005)(16526019)(956004)(55236004)(316002)(66556008)(44832011)(66476007)(8936002)(1006002)(966005)(4326008)(1076003)(6666004)(66946007)(478600001)(52116002)(54906003)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dlW7zb1zQLAzXhQKMrgL5yG6DlaABx7athdeydei9fgzjyMprafzUn3b0a9S?=
 =?us-ascii?Q?JvYCCpANLxFZcJIHtV3MP2bBi/oiuV664HwcczcV001cMG8+4HEyJQABs4YK?=
 =?us-ascii?Q?SzODT03DyjxNOnfVPTOh4DlbI9F7BSZv/KQZmnKAW95Fk4KRM7tv4lgfsLP2?=
 =?us-ascii?Q?ZmM0DnDUkPPjscOUfkM6jNuCfYjOhdYcpzd9bv5gOptMI8brZE1llOy26/YT?=
 =?us-ascii?Q?SWOmEmkqKL43Vd/9cSG4REUJatt2TrO8Sfk+09uplW7ZJuRgNWx/t3CN6io7?=
 =?us-ascii?Q?SkNI2mVP4aLILPb/H8Yc5NJeTJOKEqAW9mzuQEFeDS9E5YtSMhqGoBfS1Gk2?=
 =?us-ascii?Q?GW6TIt+tatYM1ijOzcIe7wXQ/CCyOdNRRfA6hfL4Vpbq7hwEExi0UjGHVOX/?=
 =?us-ascii?Q?gfRAhDJ1siFGabqSzLN1bE7mpyFch82w/nfPWGdpQTIGSK9JN+IytNfHqLPV?=
 =?us-ascii?Q?1Zmthji/FUVDI6wpmtJc4GX3Iw8xjLNfMShgoJtEol7DndlTaawNn+3/ggGi?=
 =?us-ascii?Q?0DN8hZCH9OwKf7cIURyDLZ4STu2unR4Te9qF8kM01RnZdUcI0gdJstrhvKDG?=
 =?us-ascii?Q?2K1tuQqU4ePUmev1zlSvfngAY9NYY9pXnJUq6pNAl+36FXCAuLWKO11+GJKe?=
 =?us-ascii?Q?z5/P4y8PwWWC0b8lAw544UyVCQch4STzH8ij0uyrNztInDidb3dfimiT988D?=
 =?us-ascii?Q?ARG+EVkNgFai8snIpV5C3tJVa3mF7OnS1K3jNGGHk6pkUSG8ZFMgkNBbTGE2?=
 =?us-ascii?Q?o/pheC9PSGGSBZ43DaCDLm4qGnmuEE+yJxJ3Owah40kfswZAQwauvV+EtHDW?=
 =?us-ascii?Q?ZAXngIf1JLc7E/UoGC9sTHr+eq5X/Ftql1quntMx9rboHd77CXMElUWPlJhL?=
 =?us-ascii?Q?a9HnQIQiPCNBeLOD2vt6QwMhsXRiTjalY60lmaa29Oz70p78E4WiiwtW3b6r?=
 =?us-ascii?Q?Jmy09QiSB2NDjEZK4uNa3bszkSOlxkWw2ci/NWQyq7W/THCRQmDpaJorcurT?=
 =?us-ascii?Q?7GNsEHN3Owsi+DVCNKLeazZZ8Bd7FkUA3/f5OWk1L/dcvYtjni2KUcOUVh9g?=
 =?us-ascii?Q?YVdS7rAsPCmVj5qmSknpdFXHhULRPC5hWfE88aOuh6iCGrdZ1QSpJ6lFlNRY?=
 =?us-ascii?Q?4z3yj/cGvy5Ovnpe0S3Ieod3Mj2YjShpp4TKM9f6LnJQdAd79QOgLB42tjxF?=
 =?us-ascii?Q?/cu2bXsAv0a/dUwReUI6zZtA4tzIYtf3yEYUNJiepa1dkW1U+F/BlFSU+WVN?=
 =?us-ascii?Q?yMv+Mk3ygah/dKE4Pc3XT05skj2orI6huf+3dUnErGWxfNBgWggqLShOHvKg?=
 =?us-ascii?Q?/WsAAjACf60WPN7gvNDfewuk?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10f97422-76a9-4771-695c-08d8e455d1b5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:20:51.8733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cLMZZFdwEHYy9pGJdNyFOmqORSXI6oFGCpDYFJBNX0dpTM9ymE3VdgSBg2Zj+44M1YhYX9Rg/on7z0rDTA7fqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7: None
Changes in v6:
- Minor cleanup

Changes in v5:
- More cleanup

Changes in v4:
- More cleanup

Changes in v3: None
Changes in v2:
- Updated with more description in document

 Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
 1 file changed, 133 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
new file mode 100644
index 000000000000..7d01ae8b3cc6
--- /dev/null
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -0,0 +1,133 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+MDIO bus and PHYs in ACPI
+=========================
+
+The PHYs on an MDIO bus [1] are probed and registered using
+fwnode_mdiobus_register_phy().
+
+Later, for connecting these PHYs to their respective MACs, the PHYs registered
+on the MDIO bus have to be referenced.
+
+This document introduces two _DSD properties that are to be used
+for connecting PHYs on the MDIO bus [3] to the MAC layer.
+
+These properties are defined in accordance with the "Device
+Properties UUID For _DSD" [2] document and the
+daffd814-6eba-4d8c-8a91-bc9bbf4aa301 UUID must be used in the Device
+Data Descriptors containing them.
+
+phy-handle
+----------
+For each MAC node, a device property "phy-handle" is used to reference
+the PHY that is registered on an MDIO bus. This is mandatory for
+network interfaces that have PHYs connected to MAC via MDIO bus.
+
+During the MDIO bus driver initialization, PHYs on this bus are probed
+using the _ADR object as shown below and are registered on the MDIO bus.
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
+have to be retrieved from the MDIO bus. For this, the MAC driver needs
+references to the previously registered PHYs which are provided
+as device object references (e.g. \_SB.MDI0.PHY1).
+
+phy-mode
+--------
+The "phy-mode" _DSD property is used to describe the connection to
+the PHY. The valid values for "phy-mode" are defined in [4].
+
+The following ASL example illustrates the usage of these properties.
+
+DSDT entry for MDIO node
+------------------------
+
+The MDIO bus has an SoC component (MDIO controller) and a platform
+component (PHYs on the MDIO bus).
+
+a) Silicon Component
+This node describes the MDIO controller, MDI0
+---------------------------------------------
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
+The PHY1 and PHY2 nodes represent the PHYs connected to MDIO bus MDI0
+---------------------------------------------------------------------
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
+DSDT entries representing MAC nodes
+-----------------------------------
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

