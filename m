Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2363136F4
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhBHPRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:17:44 -0500
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:34240
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233507AbhBHPOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:14:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvAtlLPJaStBIu7tiLdPnNr7kBHWb9n39Hp/1xr4NHvJMBeddgHUpXFMLhhJEHmuozrd3RvlV+8II23sJbgwPMgqREFo8CNXIy3RochIBvwWMzURnlHSHmx7+wAhY11ORR3OdlL8kR0WiOAcg0cdIfsZVT2+g4+i8Pp4K6hj6rA5OhkQio/OaI2lioL+jV2F/yheHkLqndy9i//byICMIspgs68GNR5j3jB5JDj5KMcRPa2HQ7L9F+8cG7YcPOQXVWZcr2I5KxZCp3xS/RsS528Fd7TR73n6vHu5IoBmyedYdCA+m7jv20f1wQvBHTxpDy9UUGrvOOXSi61Pi6Q0vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IofeNANEMuA5JQzSXHIjLaUvM8hwnXoA6MxcQwUcyo=;
 b=E4bgfvJBy2aBWzYt2aujE6iBD27YNVYbYF0U8JOox9Pld7VqctDPuHwMNj4JysgRLm3+ZqyM9WiHRFsYM9FoQxHqw43VStHxuDTPQ9/keBzDfseyveo+dQhRgUj+OjTPvOt/ShcGCR1slCpkJAbHvv2VDcn25rD+8V0yx4U3S1Gs+cqJFecmW/F5r/LgP+hWQbFH5XssCtLrARl7MwdKK6/DVcunoMQ+PPHAZ2RTthqmINxB7CxMiUPvTPJ3OZFdlJ8M89UOV2g2/4lNp9GsVqACYRjFa1ZTem977K3497/JzDa+mxCGMK+oB8KsYTzlzZG5RALlEX6LV4r38a9NxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IofeNANEMuA5JQzSXHIjLaUvM8hwnXoA6MxcQwUcyo=;
 b=f2lAkuVwylJcuNgli1eAzwmFvpjxEQj4ZrMUpEcmgyujLaWSR0jzDtlx15cfqKa16N6LSdbuCsOEs/sgF5n8/YjzH2OZyQHZSgIz6+oOFZy4BaHLLyQgPGEWKeKeCR6fUsyUcn8jiIzLYgQHrsyS1TkDFNkFUqjfNw0m4G0n88A=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:13:25 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:13:24 +0000
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
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v5 01/15] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Mon,  8 Feb 2021 20:42:30 +0530
Message-Id: <20210208151244.16338-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a38f8677-5475-468a-e48b-08d8cc441473
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64350B18921E44D55927185BD28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8MK9Z3T+11WlLdxKJVmSUBl5lDodLlezKXFKu3qM9gZqlDU3ZNk1mgvYZ6+dk/phspN6SbebUz92uaw0WD84edTRM2Z73sR2r+ExjAI+ppSGQb9ELnwXsmCwxMviBRJI9wetEN2KHy5QRbRktwUEXqV3UkFjsjpTITb/IBiDpP0XCi0znZiUvYnQX7RGqXP489+docat+E1PLvYvVruSzdoI+cNIr6+cym7JXPYzvTTom5979rDOSDVcLiw6BjnO0kHuPX9nEMbPPlTa5+tHs8RFPB0LVWekGDZD01iF5tB4smPT5cakbzBz0IOjgQAth+DZA50cwUCCCsi98ckIphK3c3asA+GOlD2RFE6R97IPmEDBQejRq5nOS7IGa6mVJZUMH7jgDeEINr/BVaAwTIAIzmIk1ZdoZiVS9ysyTGT/4t9pcQWjKPiKgOuc9/9tUN57kTQZU0TRe0UUvSBRuu6XADvKpSVedu4qdBxj/6bUUCBNvmLw96/iXmYmCx3vn6pu+ZExKHN4C7w9DETPf0TSfHEXmSiAuzme6D2BJ0/I/nM45lm0t8KVytQGP4nVgRl13Ve8pSrJyCsmCvWU/feIOWrID/JajnmT0n82zkIRDr9w7OZYXUiE8FWjHmIipWqeQkxaSnoJ/purfdwsQVKQQIitsJOPaavxRYRGHnI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(6666004)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(966005)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NGz/uCZvNVCeHR+/GFZjC4VYF4tOzasKlFFQ5rDFnpw5W8F2qAQBCYB0URiY?=
 =?us-ascii?Q?+FLn9cFWew+t9aFxSItv3f+QEFPaiChSoyP00dZmTb14P0/JAEsuS76l+lCa?=
 =?us-ascii?Q?iZCyUEQle/ugM6Vh7uLK1Y/ceODlyj9PLeXKePPTCwNNaeBDWN90FZLzep5p?=
 =?us-ascii?Q?sZBVcsImmtdCzmAItLVJeDJgcejkYAbNDEwBOxxDsQdKkAIBB7MZtpwtg9vC?=
 =?us-ascii?Q?2/+2y5uS8odQm3jPcDHoMgzAEKdZ9fqusTh/7f6xkLaV3/P+uslLDj7yURyD?=
 =?us-ascii?Q?+8tpSkxSTLjmTO0IGmkYfMuUdqV5kIXfez4kkydHeLch65wpgjZqi8+hvbP4?=
 =?us-ascii?Q?VcnXPi54J+F5Ap0Wud54qKdHyrvQgginkAAguhe5Hj3ef54xz2dnqP1INOoK?=
 =?us-ascii?Q?KfBSwC+u6nCeEYN2dL7NFiVlWSPm5AsTL6tB9fevrW4fz8yVyVuxpGsSRuvc?=
 =?us-ascii?Q?mBd8LrDu1dylO4VKQz3OA+YyAQdU26swRfCZqMsLA/exhDHu1w87kLPbSyyZ?=
 =?us-ascii?Q?MiaKsJUPcg/4C6bUip1gAt8Ony24GUJjuDDAJvXBw/GV+86GLgYa2tjRxu1y?=
 =?us-ascii?Q?iQAxY8LQqR4Q6z2W8SzGNzgtAYfgk9CQEKA2WsH8oGXebw8aJUWBCj42DqEZ?=
 =?us-ascii?Q?1Lp7H6ZqalpMgls7So8WV+YmvJRmsXgtBbW72yOtFG+88Dfr+EG7ZYXZvbBh?=
 =?us-ascii?Q?WxDAo9joWPdQygJbPebAydoBL8gIDKPZHrpKgyjqUrLaoRALoY5MXbGIN/ZD?=
 =?us-ascii?Q?RIMzpmsj9KYBqblVzD/lbPmyxV0Y1SqI3kDRqxk3lEY114kMYt3QuNJiVbwQ?=
 =?us-ascii?Q?Fpf5xX3Y/0/E5aUgOXZ1+5f6pKKsFxZ+v8Tz+Xbx3slVre7k/FFn1m8O3m8J?=
 =?us-ascii?Q?4H1croOIIufL9HVivbUi3b/zzZtVdFh2VqMBIIWJGa4899VdSj4r4hG/Cm+J?=
 =?us-ascii?Q?duaH4UOlq1cM6tAaTQvIyz9KH77gvp3LOHq5G4FZWVTzkjvyYMxaSP0hUHC9?=
 =?us-ascii?Q?dd53jPBvjX4xWvVQ4RZhtd7Pku5VAVMncC763NOZu4A2aLiAd4gJ1/ZtgrQQ?=
 =?us-ascii?Q?W4pbiBOoFY7nkCqjbB9BUhNJil+TuLp6zTg4e/b1M09SZJl6z9NpbKUnmHWh?=
 =?us-ascii?Q?eXTrpW2ITZSjILrd7vNz2riJMaapwjvzTZeqZ36rinXhiE6nZBFMt2Pq8XSW?=
 =?us-ascii?Q?JjSTdHEfC3/9rZQQPy+EGiZXHQQo3TqKzifTf+0KAx1cOdSGAgCDmwqAWc9Y?=
 =?us-ascii?Q?/i9czgx0JoMCEhaEoFe1nz8eQEdyOu6Njh8uf9zfzMQd2ln16FNgcuWlCtg0?=
 =?us-ascii?Q?n2h8mBKKAskhK1RacW/UN/d9PmGkCtiXQ9+srJo3vbHLkA=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a38f8677-5475-468a-e48b-08d8cc441473
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:13:24.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o24i5qrsXzQVp8oeZqMsw3HbnoKyQAn7NnBc8Tcx5yJHDPwlZan9d0pOE60cv9/6k73TIzEbHdBtZ/+cxLTjtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

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
index 000000000000..e1e99cae5eb2
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
+Later, for connecting these PHYs to MAC, the PHYs registered on the
+MDIO bus have to be referenced.
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
+have to be retrieved from the MDIO bus. For this, the MAC driver need
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

