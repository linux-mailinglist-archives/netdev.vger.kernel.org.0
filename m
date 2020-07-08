Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29363218E51
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgGHRfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:35:10 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:43335
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726806AbgGHRfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:35:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9nHVLN0Bfej7m0BEsqrmApWbOsEBeQeR/rSlvkC7aUJAYhZ1s6k7bZ8SbMMfACKDDjgNdJ+VJcVBJgaWUVF9TfcIVUqNKXF7OQfFaCuGkLef2bJpCvdqkpfpuMiREqAfYDEXrNx5t5HcDgiqBYtb7OIQQfPqOn2Q+8HqsF+ygI2eTjzCa39q+8CvDqdlTgPMXdBww+e+VPgtJDNmQDFsOxqwUI+z1NJy1cO+3B+xUxqN+l1m+AkNtaUIxwxNDCspJKuHd5P9u+Mof1lhj1fZqgdFItaPGoH2L46GOXqeeMagU0rAldD+gIy2OzGFV9frhBzNhqMTTIld3L8yUDLDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSEk3yiu/72qlamL/tARgk+t6Hx6AevGNzkASxvnVJA=;
 b=fiY1BP8Mryd/hgVpzpQQmMHhNfk/eseRj63tN1W343uHN1wTz14zzRYBpRLEUPxZhfdqvQWls2rjpY6r1p3TDaCqvfv8zce3Jo/MNgkTwC5PZIe3CgdAYfomnWC2+8YEwDYCoXeURltEYjnWpH88UprEKBxoWFb6Ar9mECxNQKV3KufmaKCHsrIg7d+Y059HGkdtlQFS6aMaV6+7xNGTEjrWHoXxghqpMTm3gewcqWLwUZgjzHyqoUdNSxAXIXLtbl7Ll2MMznWcunSx+E6XV3Mo5n1amPrXG03hFQ8ptFS7oOleCZ22LLtDpKigb9QGWKY5smenHvLjfRtS8xIifA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSEk3yiu/72qlamL/tARgk+t6Hx6AevGNzkASxvnVJA=;
 b=lRK9jQ0Hp+fd7Dn7zIM9DwcxWW/Y4TL6yFrHfJPgpt3e/NI+Icvy/U9Zjmy6R2ZYniv+qs4vhnYEwrnuos4mkmRrjyMfXShl4WRNGNwTNgfTmZFOuZC8RcXpAJgmoECdNniJiuw5DFPWGTboCvrxX5IFiZte5ovXOSqxZAk1L5Q=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5730.eurprd04.prod.outlook.com (2603:10a6:208:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 17:35:04 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 17:35:04 +0000
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
Cc:     linux.cj@gmail.com, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 1/5] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Wed,  8 Jul 2020 23:04:31 +0530
Message-Id: <20200708173435.16256-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 17:35:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ab4375a-091c-4fe9-1a69-08d823653f88
X-MS-TrafficTypeDiagnostic: AM0PR04MB5730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5730E4782026BEA4F3670D96D2670@AM0PR04MB5730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huBWg4rvyxYGUvSGVgil4QhthuE3bi2/XqrKXedZzREhdTw0cQDcsLJaSesVlO26Kw4XhcONFN3wfxTUqULeUfEoZBD6kzYOhgLXm9jKmHmg2oO/rN8GdiFNa11VMPl8a/ZfbrW8pEM/usV+y6rgW1UR/SAeYO0ksaeocKZC0yqQXN7FlREc4Zaw7V3kp6PguZWmnoAKTahOM+6MBPzuLwQxuC3+cR5dHhU/5sUco6iABIHpdmuyxJMbEyC3iIMqV4PR5Nj79Uy/ZWQWe45AZy8isClpE1Tkajw5A+1APYnpP+7Nyn2xofmB8wiIfTdHSA2amysmj+sBWlrvwYegmbeOPEbUc+m+CUpQzY2gNL+UcEWciHI1IbiD/Kvt5k/b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(2906002)(186003)(16526019)(956004)(2616005)(8676002)(316002)(8936002)(1006002)(6666004)(478600001)(6512007)(5660300002)(44832011)(55236004)(66556008)(1076003)(66476007)(6636002)(86362001)(6506007)(66946007)(52116002)(26005)(110136005)(4326008)(6486002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +EcWecnwO+D49n2w/eeQ8dDDHo0HTNChf5xttv4E1Da0fZpbqAXPpLtkO/IxOATwtvfgclQ6O+FroYOSa3pmyQqdloqh678WENMwm8NJjfD6tXyIAAEch/1IrilW4IIYpBxD0TezZmnE1TPJfUcdL3Wgfca2BGCCpl0psEZSovJTty4/k4dyoP6poL8yk6ob5/D1M20rgXV5dHvTpexzUeCCWinwIEDmSV61QFv664BqUerYx8XtCVeIudcnOPmSA9LzXIOwBBq6Ud8vZRujIakjO0uH380ZunMMllgpdvpYG/MGDFlMklLc+y9X7+UbtshLfhn6P7ACKr5kKVHKjJh4sKcUs89hSj7bc2lCMWoZ7raczBDOebfWKnwoDNmRp70bZ8KBQNhxXCl/2O8sfQtTDsSN3P602jP43MUFcJlSDGqLFsy4i7/I093sV81YGJlss0abo6J+M+acRztRdIhaRI2hDitHfuRt/2jV1d8=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ab4375a-091c-4fe9-1a69-08d823653f88
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 17:35:03.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pacjqd9Xo67PdK20W6pQpjR0FHL1VciLk5Hfncv4xBKEYNf9mDVFgDXJjDR825JrbISFKYc441Vy6oHwTIvpnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5730
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

