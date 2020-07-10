Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998B021BAFC
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgGJQby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:31:54 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61635
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728317AbgGJQbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:31:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mj4lBU1rp7brwVMaY8xNpMssN80dGOYY69m6lP0ojKJo6oNHG5UYAyppETqUR0eNKg7BlJM7m2gCV35ZSMTnhMoYupIJwmECrGC+w76usqAoA6ICurg/r7/bxZTXefz/390nfsBD5m3owc5k9FwcJlrGL5FTMF7p6w7PjWugp/4zLW+GybZXf8DBEQCazcG6Upk34c5rKjGc+bNHldRasjDIodGvVxyd5N1dd2zXBYeGqvPhut+kHZGCyfxEmWowTzbfHEmdkBmFLu0Lz9x0p7CGDx+CO+XZbhitIJdHimzwKkljGx2OgTr/ZmS77CF8NFx7vaSiyyh2AzlJaRVPNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8imj06fEf6do6x+EnLOlhJiUSVSeYxf8zTMi2DJt9q4=;
 b=OHnTwEpfOozuZzSMpWSUHgWjlnyLfTk5n3JFbBAB0SdBP7YMKzlod57kNsC0Vd81yg+9zcbGPz1TKhISmE10r3VwLPCzw97/gllLO4EO3IfEo3KWwVc4/1IIEKDLQqdiXRuXYiMH0VYPKs4QBfITHL13xOrNKwEuBv9ehSyQYDe+CVdIV+bLnh+4SWpu4diF1tiJNwaIdBz+1vDpv4TW3j7NfHzUHo+tHt1C7hGNstVt2wyQctSFd7fbVzcUYO5rHOOc8lpsI6G+bX3GGreUWTrUF3zP7y16eVFL1TmsnIChW0Ks3iBs0AnRb8K1MOh9sqXNyh7CaO/CUqR2dkAMgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8imj06fEf6do6x+EnLOlhJiUSVSeYxf8zTMi2DJt9q4=;
 b=fY+2sVkI3h2U0kX57feiUeHyJbpuyOFyDtsapYgemv8e7RgwL0uXbLgPaV2F8osEzQfz3zWYEdLeWcs4eqDr8WAT+K0cncWtKV8iX4Z0nWCKXLpc8Mca/Z2OD/MTK342QVBU7gx+kfjKV6uujoEE9jZQclVZbogAiUL1G7a30tg=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3908.eurprd04.prod.outlook.com (2603:10a6:208:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 16:31:47 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:31:47 +0000
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
Subject: [net-next PATCH v5 1/6] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Fri, 10 Jul 2020 22:01:10 +0530
Message-Id: <20200710163115.2740-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0137.apcprd06.prod.outlook.com
 (2603:1096:1:1f::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0137.apcprd06.prod.outlook.com (2603:1096:1:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:31:44 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 04967d99-1ada-4347-1c17-08d824eebd9f
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3908:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3908268966A37FBB2F2943D1D2650@AM0PR0402MB3908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9eh8jycCptHC23zGljya4mltMKbQCAkKzO6gEqSnhXV4NJR8n8Aiac035mlxV8JU1tob7YeHLF4h1GKRqd7MP3qpqdgXJinDo13ca0LWUak6rMqgV8+9+WZqc4FtAtg2huXbwS1PAg43EiQEJLv8miL33uLXeoMA70pjRjqo2DukXFecgKUIOVkGShgG5pibAuNEXCm84m4gzd5ZYqhvdVGhfLCiSIKEysbIlL1Fgf77tiN4g1uexI6/tIQA9h6C6Kc/nhO9pcfqkYTeu/0cgTh5PhbUMn8gOwqtzMFC7vq8arOduD4firv8fArVm1RbRH50ZYulj9zOw1qFSwtakQSPdIO2OMlhmz+N2Z/V+7AsEHSfJyljilO/RmU0okY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(8676002)(2906002)(8936002)(86362001)(26005)(6512007)(52116002)(1076003)(6486002)(316002)(16526019)(110136005)(1006002)(66476007)(66556008)(6666004)(478600001)(956004)(66946007)(44832011)(5660300002)(186003)(6506007)(6636002)(55236004)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DhHiIIPfOli2DqhR2Q9rK8M0nUsnLyFxUKg2QlzNxchCpre+ArTuPTMjHR/ACkQcNKt1C3qTTHyxaIiiGB70B4BCrkkX34K4vEkIPVTCkR4mTrPec1XaxIwWbwQ9TdQC5hjYQcxKamJsATlsjgCwE7QojLC7slfr3AFz8EYdw2DWwYFkm39TUkMJV9y4V4zMmtBJ1deMgsjQMXX1WqCybv/YCtwJDP1SSh/GIa04cdsfVViTDKOcRVKua9O8kMzIi/wYVWPGpUcQVYtdn4ldR7Xmt4ji20oZPss8/G6gogDuOpy82VpUau16YsLAPYFhs5hGSh23sCs+10GO5A3vmsi9/b97SCT4FFEmozVBmouPBQCBllmxAF7v75Bzc1acdSAnfqkcM8120+exJGWvJHAxEyB33Suwgll8HMCwlStpNGiYClgmgdC9THSToVEv2tdFkR+8dM0R8689V46yUvY59STvwgr5eGeFXWxkBiGwR5I0BWnVYd6ZF0RBkxwo
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04967d99-1ada-4347-1c17-08d824eebd9f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:31:47.6611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nmw9nzSNOUyrqHgiFyTsM91YKWRWQbCsxMa/+OxvX0aonnCXQFCs7GIs+yo6VXpYKHBKFnxUutnNPdGJXqXW6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3908
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

