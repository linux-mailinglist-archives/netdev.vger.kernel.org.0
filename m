Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45082DB1B8
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgLOQpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:45:34 -0500
Received: from mail-eopbgr20071.outbound.protection.outlook.com ([40.107.2.71]:62181
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729523AbgLOQpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:45:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTkBtLrvgj4ErsAJTK4nXz1u7Fe5GjtsVWjtdVLRXYnPBGCL27H2ZccYEgYDjwvtFmic79UX4lwdQId6IVKhoSy6FHAeagqxR9NIOJV+a8PtvV1Hfe4CdtczVH6i1sczy18YJ+rasq64eq8m2TRoG0jp2d97ykE8N4rLFd6u4fCosbaglU9rqPrOy4k36ERpRxoAqXFDIi8Pwt/sUtowfcHkTRIbA2TS7pvBPKiztZg+MHbJzBwqi3izUleH9R4A6e5JqQ8kj4IzzYFQxVc3/h9ngRpTaPM93o0u0CkDa7h35dkyUBuHSLmATiMZpPwNYIjSid7C0MQdcovsHXp61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0Q2UiM5AbjyRcb73lkL0nNYCTf71tN2dPXnwglWh+E=;
 b=ns6YAZTjnk76p5RM69kZu8sUNu2GePzqvcNE+XnKL0GuYklMQPcZ3sD0xaYfMb5HetUASv+HcgrOpQ6QCXtndRI6TeiXfqSpgE9vVfBA/+unN3oD2ZOP4S22KZ5+E//daHV4MH7sBbec87AZd3YGSmQZ6711yGSg3ri3JgbWN6V1OeMBXrSfB5eXCnMcRBWHEMaeXkCLN+1iAgjnVcaqzb0hQlsFMDcYRA9vU5+aSJYfyhmqkNkyicSGycOoxxcaGvdMryq0LoO8digZs7FoDtjgy+xGapHlx0YvpMsu7dW4AkIRBv6JehNAtblNigdJT00NFcujuLuAMaqxFz4tSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0Q2UiM5AbjyRcb73lkL0nNYCTf71tN2dPXnwglWh+E=;
 b=eD9KPsmnej9thPFNuiN4aM2rdQkXRDx4QLDxkQ0H4M2sBXT01xGB0Cd8evRXoSbZtiDfnGN91iIaxFRqA4Wu0tVs5aIMYQyVaYxqpgUMJh2VFTtmEO4X5KkDMmzivBD8evshjlRZQuo9LeFQAJF/LqrhZkyiIp3E/vcDHXUbd4s=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6963.eurprd04.prod.outlook.com (2603:10a6:208:18b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Tue, 15 Dec
 2020 16:43:57 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a891:518d:935c:30dd%6]) with mapi id 15.20.3654.020; Tue, 15 Dec 2020
 16:43:56 +0000
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
Cc:     linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v2 01/14] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Tue, 15 Dec 2020 22:13:02 +0530
Message-Id: <20201215164315.3666-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
References: <20201215164315.3666-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0152.apcprd06.prod.outlook.com
 (2603:1096:1:1f::30) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0152.apcprd06.prod.outlook.com (2603:1096:1:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 16:43:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79d14ee5-2895-4de3-18e1-08d8a1189db0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6963:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6963BD278426D0396231443FD2C60@AM0PR04MB6963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BiaW/SIdeZC5k7Kaykm0mTajYiyERoMBaUZMnsc9BGZQKLRmW1Kf/9mtYMkvXusa0VD8r1HtIDKxmebXHXh8ZbXuii+/Hd4Nr0SsSuidLhacYnAGMkHQdsxYCgw6T4HFiUT/SURaOmi/N/uXBVvQfKTFH3eTJ+j8i8CJLWg8OxvUyI45QNK+y2J+APC2l5+6udFYkh/20niu0sBlI9pmbIgekKHMfHvnf2ibI5A27pd7j962BrGHEjVcIMsno2hoUbg/zuO4jhsg6mgceZ112EYcW1ljZbONNlAczCPlnfrV0DbM16L1kEYQGDUm55ws3gikRGuzuuB8Xl16TpPy5otyWFV2Xq+kXaxL4DwcT1iyuNoTINyhqVIVUbpYp9D1SwPP1oTDdhde5yj/l8HvPnlWqpEwg6oE2cSiqWMC/3m0ndSuDYjrGoiQv8bGLfNa6WAI3EeMZJZWQHYRTrQDCQimmZktvhxpEMyPKX4cPiQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(8936002)(4326008)(6506007)(498600001)(83380400001)(66946007)(921005)(966005)(2616005)(956004)(86362001)(52116002)(16526019)(8676002)(2906002)(26005)(6512007)(44832011)(7416002)(186003)(5660300002)(55236004)(1006002)(1076003)(66476007)(110136005)(6486002)(66556008)(6666004)(110426006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ha4xAf2U4XSU1/qXmGOwDstEYOnncS07EeL8uL0Kk2Zt/qS7l0Z42RxjOm1v?=
 =?us-ascii?Q?4b+HQdNx+09GfeUTucTElEeAFt7l/OD2MM8xlPmcZSAJoMF8X8W7YVx/JbqA?=
 =?us-ascii?Q?1QszdQtNGEbVaFp1ZPEaJZ2mR0lqkKRVEwXc1W8lPeRydjVT/KtClZnbY/p/?=
 =?us-ascii?Q?E2ca7d127aNmUGWos+bv1Vvr8pngAQ2B9c+1DDl0evXjouSl5GwyfYhTKWsx?=
 =?us-ascii?Q?bNRCNArdZoDMU+QxQeS90aRj8UPukz0JvKPFrMsH4zADDyP9u9RSqhpr1+Sj?=
 =?us-ascii?Q?Zs9MbSwXfWmuyflLbfkuigO52PFmFjd7+9LRhl111GVIb8CdvsTVTCRxMDz7?=
 =?us-ascii?Q?cwi85zJfVwDfV8UiU1OP41AjF2j15UQlX62qZVT/0Ag4x3RYwsK6kZjkX4Aq?=
 =?us-ascii?Q?YedfDEUjleBAzaNsMyynubWt9HGi3w66EXcsrQpee0axF1pa/BI0ZkLSQWlZ?=
 =?us-ascii?Q?Zw2qrq3bVGTZ85pnd3MtjpMVGMh9ZDWPHjcdMX/7tT6oajSHUYac2nNQ8/tw?=
 =?us-ascii?Q?1EdAonKMjgiSnCk+XBnI/j4kAzfpVhieYieJen/3c79jjnGCPTrRKj01lF2k?=
 =?us-ascii?Q?I8mC7NUa3iTIsXU7gLrpoh6tE/XudcGtEnucvy7V3/igjMdOlP3iZRPQ4kuh?=
 =?us-ascii?Q?adcAir5DRjF2AISLgPhue0w9OC/7lkYnlMDLoV6AH6iNrwXz9UclM2T65y9F?=
 =?us-ascii?Q?mdxVGvFX1+4SGuS9hTyI7+Y8SL/ax6ei9iJrde0TrPCQgoYdDazCfiZEqPql?=
 =?us-ascii?Q?/KbXJ5UPlPWPS6Etwk39K9cTowHL/SJbSkO41m5k+fmqtMlZq+IHl6gwW3Ak?=
 =?us-ascii?Q?giiZGA/C1KaC7STJpLM2Aetij46JefKHA+c499s1+pmLtq8pVYgTqlAhPiG9?=
 =?us-ascii?Q?sAzDr/R+2NsKPERegAKl8T6chhP1SM2w0ZD59/cgJoqh3KGdgK59sd8vJ92c?=
 =?us-ascii?Q?wt0bRoCmn4odHVFusw1P4/+8gcqdkG3O/Gz3+xx+W0hneh70ut+L9cdMbXNX?=
 =?us-ascii?Q?uobM?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 16:43:56.9276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d14ee5-2895-4de3-18e1-08d8a1189db0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9g1EplVuaoSWvLIybFPdpGLTbQsQ93bEGA+I8pifzjW1IMDZDtyt25hhOtYtwoyhEnJ2s/6SSyC6aZrENh4fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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

