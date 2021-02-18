Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC4E31E595
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhBRF3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:29:45 -0500
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:24352
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230211AbhBRF2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:28:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOG+rQXv2+dGcWpB9FRmD0iQnemootuHT13OFrSUYFqBHiKOy0y7P7x+y57eaINDO0doHmXnK/oEschtS1eGwlapJ2u79Mb61NZJXGwvn+2owEPFInc3pM4xeVSYu8UxojgBLuAqW3qfftgRkQmhomwwUBGEtPNE7ebilG/Ii+JL7q+TALefnnH/8BpyVq3NKttnD3pnG7G2rI/Rs2KGHzaa8RvwbOuJEJKep2WjHog7ccqitPbml5+mLI6f3b1sXQS1Se0iSnQhA1K3gNwc7HWpB/g5xXux1kmEGCeWzqoslfY7PLUwzmXjKk8n6hwBRDIvMLtH+qi7AYQyaPxOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psdIIdC5o86VoFSAPcW+NYKghds32St8M1Sjrzx6zwk=;
 b=kUaoXhbiWrRVh4qciarrQcXpio38XTjOvTgOHANo7EiQszmX2VPe0F4TnJhpL/JmBLyygZdSrXRXGpyqkcGdDvtkNSUgSlIf/6vixrY8nwtkb9kD2NGnZIrW+8xenbYAyjTpoegVy8/oCqQV3EH/yB8f1fXwDAMPtSIpi3OHc4ZF0UxqDvFgKnqm2lYwaAPadaT7u6aylo9IA3BxCo9kYmwT6ZTRkO9cgB/JbrmvrVDPSX1TvhNyzm0Hj77RpxKuVVpULFtDqUOgdhukDuwYsDAs2CDG7Zutj2B2kFMFCO+pXFR/OOuA1M5x2Nb92nSoSpvvh3FSvxjAYyZ3I4232w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psdIIdC5o86VoFSAPcW+NYKghds32St8M1Sjrzx6zwk=;
 b=K7MSogCyHL9CtOptV/OUs8xZaKUC4VIMHA42lElSCrc2u4SuA2cSevyC9N6ANaW1ccAeFcbkS+t8KdmzJogLc0gvRVbROZLQg2lIH/IMf14U0GJgOU7xfy+8k2TNegtzRCECsYX6hggjhf+VLgGhpbKGeqzVIhVo9APn1aJ3Tz4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.42; Thu, 18 Feb
 2021 05:27:32 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:27:32 +0000
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
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v6 01/15] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Thu, 18 Feb 2021 10:56:40 +0530
Message-Id: <20210218052654.28995-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:27:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b0dfb8d-6112-4766-64ba-08d8d3cde402
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34420780DB2125CE35D3D130D2859@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwZjy3mR7XVObJfC9tBlY9YFvGHHBjHojWEk/qV3tv2f9WvsBrKjQQ3UfhE/S38miEFDl1azH13dnPC8fPkg0pgklwM8+OFVoBIILArOODcO9QsflmUtTDJZcCo2nu7LeMlvUwVoUBzvJsmsUiCD2W5h7RsZKruzFob2bZkKHE26IHEbyyWEOg7MV7O+abCcMY82IX7kUc/1bSKatgHj9NtNgohmifNsUQR2lJ7kH4dJtK6wW31w6lFWMESvZqgs7KRl77Pogbvi5rGM53us8doa/AIgcsGqRnfo1W+elrLBGzpUK1rpY4IICBF7XXSdMBv8pnbjn3T1Xt+rYEdSl3xA8LwPQLnWhwdZT/2MYAx4HlJoTqvHOmYuCvugf/o2kd13EDNEtodMAyFJHG80GsxwPpQfnGIrnVUwxD8qbjBimfG9EumL5mLRVM/oNtOpFJbA91Xv46NZFIeN3r6Tvj3cvOfanQjG02bV8K/PFfevPlHSSG1bcszb09EuaUbzs2mc4PJwIQTT0TYK0ko2GlOAuIY2HwlI1AseGa6xabWLRne3oZgaU33rPu1WXprUbsIGULKxlFH+WuArPtjHZuvVbqpEhEWu0nI3QgSpNugGlREFzgta7F/u32YuqdOjJqv85NZR0rMX5CF02Yrwe81QAij/h3uTci9IDwbHan0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(44832011)(6486002)(26005)(7416002)(16526019)(110136005)(956004)(2616005)(186003)(55236004)(83380400001)(1076003)(6666004)(4326008)(316002)(1006002)(54906003)(8936002)(5660300002)(921005)(2906002)(52116002)(478600001)(86362001)(8676002)(6512007)(966005)(66946007)(6506007)(66476007)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bz2omJtklhn6s4o+MH4Ck2n4mxPK5iJ/gQsauzwMhgjbwpAKDAgZE/gkdJju?=
 =?us-ascii?Q?AErCwSzj+QRVwapVsURr1jkh+qW0Gkqswzgk0Oe3vI5q5dlvHRtvWVn85mun?=
 =?us-ascii?Q?Z272HdaC9GrHh/HPwRrQ2KojAeNRccvz4397oCfYpY1Bvba+QYL/1aW3eMg7?=
 =?us-ascii?Q?NojUtp4IxDAvgRTgICCeXovY9yCxBqBkzV94FqiWxrhWNLy4JLl1gZLbh/VP?=
 =?us-ascii?Q?3lDF198JUpFzsM/uOx/XLmIKv52OIyz/eJjrAS36YBAlllW6+OZq3wYuBQ50?=
 =?us-ascii?Q?Np8qkivQNJIJe7rc7EFFlKsyMZ+LbgQ4AR/sL1nmMJDYijlfY+kDt6dmcwBo?=
 =?us-ascii?Q?3P1wlL6cu781Pm0mWUSqZ/2lEyi85U2XDwsn5f1PI62Ek9pU8ot1LjS3bcdH?=
 =?us-ascii?Q?EFPvjFImAoj5m0G1lf27YWs1hxH1E4P2NddeKfuvsQBKZswbkU7pia2D0n9Z?=
 =?us-ascii?Q?MKcombzv1mJ4fn1NsBEAcMudcEwxUMCQxnc+fP20Yh+Pu7ipJAnbADYJT1uV?=
 =?us-ascii?Q?qdBQwS/HjNJo8d+Ejg2mqW9WICSvMMCK9lQ+kjbaHkPi25Sz+XxkrQODvh2s?=
 =?us-ascii?Q?XcXdzvvVkgmf7VTh5TiD02rHLZwyCXrxm27ZbmRS8hJhQWlo7OA0uFjMRdFU?=
 =?us-ascii?Q?s4XIOpUKvTIeiakzhr8CN5Kd/bwUCyRpBncA+/mrQT32Uf3lzeQVqQqCSh1U?=
 =?us-ascii?Q?YmOPjNnTXGuCk/4oagkmyGnlxBYPQJ2adhb7/1nPP+7gA7xqHEAVwxYKnsZT?=
 =?us-ascii?Q?b0VXfwP/Zo73zePoQlPbKL9p/mzwtuKVt9dVfPFbWqboTA4UNuz6ptY5QP8W?=
 =?us-ascii?Q?iiu60Y+T7CdaJkAoW4QcF4DqR736FWYgyQd+kQg8QyIZbwVnGe+/eqdh1O2n?=
 =?us-ascii?Q?cRJjhJ1lqETkOkdsfFeZbnmYhHyaUERckLNrI/U6w5MPDjiZwQLETv1tLLlt?=
 =?us-ascii?Q?jaTCBxf8+ub88JmrgmzvapEgLavefn7rEXmUlsMVVBczb3hwyvP4VK1mTBtO?=
 =?us-ascii?Q?oIqDI9SXIk1WmvPaiYdplEOEH+r5+jplzoRZBbkKgio6yB3vor3HvNs8vwTI?=
 =?us-ascii?Q?25SX74EV9JRqbcpO5aO8iFias784SRRQR552Zx2Zvqjwg5DIFJXCh8oP/dNv?=
 =?us-ascii?Q?VbSKjnQpgj1reyWyqGOJgTuLSQ+cZF3qUIO15LA5FNhc+UO6hmETeseI0TV+?=
 =?us-ascii?Q?EPmc2GGraX6bCDzUsM74dVYZOB06BFTH3lj6n8MmnioSNcLBxr9qCu5hz768?=
 =?us-ascii?Q?fiOkDNKD/0pM++/TJzQ0AUAQcLuHJiCh0DCxdt2XtXcSiv5ysrkBJ2VDxAik?=
 =?us-ascii?Q?sUzjMMiMWIFyYZcW7AjibX/BAZfiTP+M1sMEL5lMG9WRCg=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0dfb8d-6112-4766-64ba-08d8d3cde402
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:27:32.4531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MW7WRwujPJKzoML86uDEFBrkQ9mNMRrYdOXYO33SxnitjkdwM+V57zzBn6yz9tuASLuhxCxcv40q4IUYNBvDJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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

