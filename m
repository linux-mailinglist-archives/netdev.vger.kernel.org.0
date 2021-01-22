Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243073007B6
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbhAVPqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:46:33 -0500
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:32288
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729130AbhAVPpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:45:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UY+7c/NjaQLNQ8k3Rpm1NMBDR2JAFIBuZbfXUYoZB2fh/UNk7jxaKii9RkfONXvmQ2UDSWiAgHWO/ZzX/K/hryI2H0AVBjRToU+BjPhutsJddZ0cwLxK11JQWdAJy1ruZkZ11lk99l29fo5uk9fCUGhY/3KnXNeWM2GmybYF2Fv7n08e+pbgIZ0x07CETYVte4GpsMFaGoGqihLFXIAMWQtqxbHA5AG8/3jN/Q0nWyT59s+/TbXscfwj1zvwLaG2jx0lc/ttiOwg7JZdPidPXYQZO4yH4k4mtkq0ZsouM2QKwhabJMDQi403ByxWGJEPWqtN3lFGVuhY06VlB6W+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJAZc1k9hiCNT4jIbpi0ax6tyq+zZ7HxsGISpBv5t60=;
 b=T47pe2ZPWfr1Aj0/gk+c7UE9ZrAiqszIPVt9ApnpG5OvmE9Uww3K2B6SKmkNSs0i4dIuelkxbYXD8Cg4WJICcy4r/ipC3uXe/VgPzjbZ2Aw1iFO6zdNYjnCck88caLKFE7gj7xefYKnko4YVjoiky0FcTROzdTCxbRgOOS0Shx6qCVQfCZ+DOCl1esHrxbJGW/4HdV+SVECmiaoYAp7YjvOz31B2pLOdF7FLkVZS4BDp6r2uR75By6TznkJuO1zWQOpL9MhI6cAegIQwMA7Yv43Vh3nFgCcQthYm6xQ4rxHwrIbx0r+KTMMq/K4CHii2vEKj4hGeATL+aJiF+GV/6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJAZc1k9hiCNT4jIbpi0ax6tyq+zZ7HxsGISpBv5t60=;
 b=QbAQ9k1/7+uAHHdV7l7WBK7IeCb6U6ZyatVlNju5MPuvgzaaHGboCwH47G6Ni2LgygtAb4Z8ZNlchk/xg6GQii3DbC+sYV324DYZ9ASOXx5cepkEmv/oaPhxYf1fwZKv21Uxfq4B0nD4l2YOB5WVfbKGpcgVOZoSmTTFqLO984c=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3764.eurprd04.prod.outlook.com (2603:10a6:208:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:43:48 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:43:48 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v4 01/15] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Fri, 22 Jan 2021 21:12:46 +0530
Message-Id: <20210122154300.7628-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:43:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 08f2a040-6eb0-41a9-0d43-08d8beec8218
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3764:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB376430B5A8C9A91D3BACA08FD2A00@AM0PR0402MB3764.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MkL7vE0xB6QFxMsnYSblF4uenHUxZmUMsfE00Fkq3bDWafTuZVyV9EpMkIEgL5GTk5MfRKSYy1SgOHOc+mNAx77K2+moL4qvJXcVlaQSSEz5HBFRrvQXo3TwCP9zd7E6zdbdxS2xZz9OJkQGEplw19EMuxqZQcVdqhrRnqBMahV3z5f/mYwyETaQLcRKsx3JXrIZb+xhI5j+FPeJBvIxq9nj23EfKGBX4Uo+JWMF/IYft0fPqYz5bJUN6sKcMzPQaXyG0hWvYCAjB1NoMRGk/SWJa3Wo7TuVRxdv7rgthNYEc4iBDF6tKIwVrre56wcP6Hj27LKdMMB7RmT/+7usNjKNZv15/q4EF/807aUEnC55rWt4S+WPceUYDOCbxxpdc317RYRQK/WHhX2EFeuf7ZQqn12H0EPP015hhxUfJ6V5mZwqFkYnJ87brGtR38+h+RKIlaPcInN6IFUKKHSN/DfFe3oAf1a7P6pI6tJkDWkhphBoMSvjpXDIBlFm9SrX4ov3fJrSYSDBloPmBR5b5pZhVlCOc02JvUYC/+bvqFNf5VqHILrUIphYD9+r/kq3Q5ZS3poRDt3KA8PHWcEpLfR1OgAQx6sP/gDJlJNG2ZrAfgp9PFUjjny7fqRFc6jHtTUcw2TdFt3jB4/yGhGih3VljTz3vdL8UfRLD5lgeXI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(346002)(376002)(54906003)(956004)(66946007)(66556008)(1076003)(6486002)(83380400001)(66476007)(8936002)(8676002)(4326008)(55236004)(7416002)(26005)(110136005)(2616005)(86362001)(44832011)(1006002)(478600001)(16526019)(6512007)(316002)(921005)(6506007)(2906002)(52116002)(966005)(186003)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?y4NVImIxhIYVdyHUIOeZMhYK293hlWazqZBEpG8qHircDigVx5h4koOdlyK2?=
 =?us-ascii?Q?pg6sr+hvTKCnqGkvyl3R8dpU2ZVkDnEZNdTKoV/sRWIq7O0lSrexdtuoQuf6?=
 =?us-ascii?Q?to7mbBnR7BSfmrXhpvCGGDqH2+MohtU3pQkC75vntiS+qAdDRki69aqfCpxj?=
 =?us-ascii?Q?ZWEO5AhXy3Mcy6mxrDkhDgFhWfiqGSWhcvsKO14HY39tgOOjoxUVHMoS7xDK?=
 =?us-ascii?Q?Q3lDu5G6cUPF5PQMCdJ8b8/Eb+whkl6q7fbDqLZDTbKT60uxY8cCFbpgXqGE?=
 =?us-ascii?Q?/5RTgqf77qn0syznE6rMd4VYKdt7qwHPsm2YwpUb2DlOP8cQK3HsM8+stFw3?=
 =?us-ascii?Q?ie9SKgdPtxSUll04CiU79a3qtUEBlonkVFA27iwRHI+bM3Ua4AJQ4ObCWUch?=
 =?us-ascii?Q?gHkpm87YAztd4Z40yLVeTPICP7k22uVU6jGwmlEt435TWzavsqhd3yXO4iOD?=
 =?us-ascii?Q?MUUTpU9cWWpVhjkTMm1j9fREExk7H3uEUCSwN7nH6ksMo4ITvJJ33UMrDyKO?=
 =?us-ascii?Q?nk6EDVrE83GEIb7hlomWvgBXXoqd7zGbXVJW65N2JSa3zTf7AWnmyaJ9XlYk?=
 =?us-ascii?Q?jKaZDL5TGXOCfFDNxIwhruJiWc7A1cPFbJyqe5orqwwJvgBIQq654jw1Mf7u?=
 =?us-ascii?Q?RYboN43tJviCf3SPYKH7RJI+kGtM9/nr8FJtSQE7iDFgFBM1HXj22QPkWvv0?=
 =?us-ascii?Q?JODD+WFcVvJ/MU2OvzNxybkoyIxlovJei11WPB07N/EUMxd+vMTEDEigvx82?=
 =?us-ascii?Q?VaRu/7mN09nrzKDIrUC0XOEnIfl9R58fmWt2svxT2mIBPJm7gse1wuYEO69v?=
 =?us-ascii?Q?rmaKSgSY57HbKw8a/1S6a4SU7lC4givz9W8p168Py/7jBw0c5uO16CRSHsUa?=
 =?us-ascii?Q?OBx0BR4KWBdrF5WR/4JRBXKuTtc6ryGlVB9X2jJ+C8PLV5dMEcQfTleR0iQe?=
 =?us-ascii?Q?X8ufC7WoZGLGirpf2lC3Uj5EON8PTeiRGa3pTXgYhzGg8bX921nTGFRCQNmx?=
 =?us-ascii?Q?vxqb98n6TDWvK2OY4T2/+qUggIOX4yakOPi9udQ+yvsUOqAsDiLW4r1r6GHI?=
 =?us-ascii?Q?bC3/7i9h?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f2a040-6eb0-41a9-0d43-08d8beec8218
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:43:48.0666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gusnySP2iVfQRIVsoqpK3TnEAhHAo1m+PQ5g7aAq6UYMRcPKyRy4sbJTXuRVjKiGp34GpMzXX4CIS3YWLNM08A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4:
- More cleanup

Changes in v3: None
Changes in v2:
- Updated with more description in document

 Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
new file mode 100644
index 000000000000..76fca994bc99
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
+MDIO bus have to be referenced.
+
+The UUID given below should be used as mentioned in the "Device Properties
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
+have to be retrieved from the MDIO bus. For this, MAC driver needs
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
+The MDIO bus has an SoC component(MDIO controller) and a platform
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

