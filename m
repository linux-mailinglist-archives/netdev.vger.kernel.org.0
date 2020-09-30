Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CBD27EE41
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731045AbgI3QFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:05:42 -0400
Received: from mail-am6eur05on2070.outbound.protection.outlook.com ([40.107.22.70]:14817
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725355AbgI3QFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:05:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6i1Bh/F8qLzc5Z+6qRYgmDk44vo7aGn3zNXoIGTvSr+0hJNMYRTqzewBAbYaYR7mHiSWZiPOiUSPQ1Ei4cuK8YSEth7Ut6k9rfQ7ujhTwas7dWq21HDIdZZQCAEFFdGtFyZVzJuh4kJze9Yb+jQl8SS7TRJzXUYQCcpM0b4pirf07eJto5R+ywOsXnr6VwcKSrNJtmEmRRGVu4NzySub5sjuhz/aQbUGw2F4xY5xYkc+xhgLVi01B9T91CNK+BiADtmWewY7EVgoyyVt0WPsGUr7uJXyqGD2PA0SYnNJHDAWE5cDtSfCkNzjvWkEJWWgIMN4loMbQYnkShkJY4V4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSrKRNJfdd3fpwcgvzczrJ4gMILmcG/Q02XaX9uDaro=;
 b=f6b1zfurSGwMJa2QMaaVc+8ODU/JEhLyHgh17aAupvh/4+mJH1DWXHGH1HDDuXIymsASswdlhEt3FWT5mRiM5grfFXuXLNmiSxIR260k3gtQdYCXYqu3VJ+muWE6Kkg2aUzNDyiQoIkwATbL4rD+/o2jhXQSx8VGytdVxsGb6m2DXDzAlsOsWBnUn/f3B5HhcnWomvFGcHIGYSh2IqJZFzfYRc0kMGw7uVAc8qWRmw7XtkD7q1sKDcNSyqp7QSTwxbvtBGPKNUNajBGd4uPFmQyau8wHgSi9qfTzlG4hcttYnvkboab6bTudkxwyi6VsrWz5QK27tp/2TapxGedqCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSrKRNJfdd3fpwcgvzczrJ4gMILmcG/Q02XaX9uDaro=;
 b=adZ3Hh9fYpDbhWQf2YCieJ8W4uWCEG8Jg0bVq8fK3kiiOScZclfFrine00692lNrAa3HwuBWSbsw1wB+q/y3odV2EqKJmd+NWEQNhGhn6+vjRXOoMfLIYJrAOG9hf7ZvAR1oxZLntp3dVAZmu4Olkat690QLhnhm2drDnCduhiQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4385.eurprd04.prod.outlook.com (2603:10a6:208:74::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Wed, 30 Sep
 2020 16:05:34 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::a997:35ae:220c:14ef%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 16:05:34 +0000
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
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [net-next PATCH v1 1/7] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Wed, 30 Sep 2020 21:34:24 +0530
Message-Id: <20200930160430.7908-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR03CA0168.apcprd03.prod.outlook.com
 (2603:1096:4:c9::23) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0168.apcprd03.prod.outlook.com (2603:1096:4:c9::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.16 via Frontend Transport; Wed, 30 Sep 2020 16:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93d4abed-5197-4b2a-9d6c-08d8655aa9f2
X-MS-TrafficTypeDiagnostic: AM0PR04MB4385:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4385287FF10A767D83BD6551D2330@AM0PR04MB4385.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DVYBmxncU1AMpypelXXIo2+WmN857MuXq3NYNC0N/9o/r0so+Kwr6k+obU1RDr7uVXWse5gxBVY4CZtq7P5c4flPIgXREeK+kNcMO9pc9OnYcTaaSAb9D7mBlne+f14jFwCDXbE9SpNOWPgr3Wc/+ev8MkwfZEBE6oZ00AeQ3jdRe5YRSzhj3QrsThw8L0XwUQYaa6PnYgALWFctYnPJngx1/gcuJAFkf/+D9RMp4rl0lA1fN4xNTAYtBNxBkZ8KohvE6cWiUONNPXQlr4dlPXGN4JKszdpOW2ci60BpalH23flOCvrmHeO50GV68hnB8vVF5p8p8r3H4LxVTPjl5rRc71IKldoG8Y5DNJOuz/FB7ysgEaDZnFBkldJTEhyY5OiyjEeto/qU0gNkzJ4T4I3z03AHEm0g8Q7fQVYjH6JwNrJTEWjnAUq6k2Ixwic5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(4326008)(2906002)(16526019)(186003)(956004)(2616005)(86362001)(8936002)(55236004)(44832011)(7416002)(66556008)(66476007)(1076003)(26005)(66946007)(8676002)(1006002)(478600001)(6666004)(52116002)(6486002)(6512007)(5660300002)(54906003)(110136005)(316002)(6506007)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GX0OQ9jSPzdrAL4E7AGK7yKwIfQeIhKDDU+DNzlj+LIrisUObs6FbbwliltRJe/1P6vSroLc3Uc6wzH/CyNfuTrSN1OOY/omnwtIZaAPwl070D0+4wLtMLsMv3CTnnOOVSIbhkncFfxCFcuX8ILYonBnlNJpQUYqkrMJKXTm4pqG9wiV/ZyTN/QnYwzC1bq7VrpAmDKTrkvoGG1DXFQOhgD8sfPDwPUaKTqTWoHEL47KhHBCUMaNZl986rCQWCMCgZSciMyg7ZsoS6IBtz7sMfkHrfZTgftutQ4bvq8S/i9BnkZSH3ipQ3Kw+QKL2+jfmbIDolSzvGaZ80ZBFEI1dIaGaQMTG8irhm9z+xnftTCFnZqN65Gt6iULiIOJfaRXkFKF0Xl2B3/75SNj99mK3C79GL9JvUjjGNw5IVeYn0dPQQJilrnh3VHxZPrdps5f870mI0HapKhHnUiUjCAReAlmEyPZZsTvQSuDbT7Qqlr/1JFlNV7rri7Vm8Y5HhoKaO1Kg15pHe7syLmOr/X+TgWR1XvEVaImZfUl6SfONhG4hJKo8NkM5fRki65OcyCPz7EebcMl7NbfwpPcKMC389i7fsFnxitG9LjagreeqW2jyq05d/uo2S01yiWhXzuIA9jjT+y533oVwsR2JYWg+A==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d4abed-5197-4b2a-9d6c-08d8655aa9f2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 16:05:34.7275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZtcJd+17V9hkueCUgbJ/EW1n/AlAM8vQdh6ozfZMF8t1guCpElHexai/27AEJ/t32QnyKZNmr+ErlGWGU6A+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4385
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

Describe properties "phy-handle" and "phy-mode".

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

 Documentation/firmware-guide/acpi/dsd/phy.rst | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
new file mode 100644
index 000000000000..f10feb24ec1c
--- /dev/null
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -0,0 +1,78 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+MDIO bus and PHYs in ACPI
+=========================
+
+The PHYs on an mdiobus are probed and registered using
+fwnode_mdiobus_register_phy().
+Later, for connecting these PHYs to MAC, the PHYs registered on the
+mdiobus have to be referenced.
+
+phy-handle
+-----------
+For each MAC node, a property "phy-handle" is used to reference the
+PHY that is registered on an MDIO bus.
+
+phy-mode
+--------
+Property "phy-mode" defines the type of PHY interface.
+
+An example of this is shown below::
+
+DSDT entry for MACs where PHY nodes are referenced
+--------------------------------------------------
+	Scope(\_SB.MCE0.PR17) // 1G
+	{
+	  Name (_DSD, Package () {
+	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package (2) {"phy-mode", "rgmii-id"},
+		     Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY1}}
+	      }
+	   })
+	}
+
+	Scope(\_SB.MCE0.PR18) // 1G
+	{
+	  Name (_DSD, Package () {
+	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		Package () {
+		    Package (2) {"phy-mode", "rgmii-id"},
+		    Package (2) {"phy-handle", Package (){\_SB.MDI0.PHY2}}
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

