Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791A121A665
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgGIR6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:58:01 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:27872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728442AbgGIR6B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:58:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dyt3YrhxREu1kBjAsQfSs1at079uR1iOoO80JgLWzQb3q8nOHZx9wXqJ6831k8uUSlB9VGXRDbzYF80Xg+sm00WzjVbcf2MVkSI0ZcDS3Wru4PqKI9kYi//+znklRCkZ6i4lAguE351WgZrsSpb4gnqxuZ9n4kCew5KCXLInP9IfosXbz9zA2V0MflzzKqkHD61lorvs05VySr8jW6kRPLbTMt/O77ABuqFRT3+gcK+zLqBbKT/GmU1Cxm6+3ahlGanudrfAGlGfpydFnmo/JEoqgGdfOn0ZCutSYgiLpy/2mCstPCly5zof4BJygb69sXzRgKLKoZkAmXaYDfAdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWmHZJSc1YyebAZEHJKHiy1Xi2FWngIbcOZ5SgJIbmI=;
 b=c9+51X1Zoi7Pq6U8OdSz03rT9LOom+u9SbjQdEYDzka8P6PjxzMAmR9G1BOPmQ7Gx8vcmC5Ceh3sa5FHxtx02iFKAmGpdXrzqnCS2YlF/1qHYgRgRt7kxKjiumWAVJ8im9j8fYZWw68vm2Gsz06mgcyO+mzbVxEvmuMXCiTG34URWtZ9hKfN1gpQNGCY6SrFAOQ3U7PxfgSG5lkmZINRF0UZTLWeng+gTxF1gnQhJ2IFo/1rlWKGzvUJPUB3OCcFmzMWaLicDb1MWiA9TjoF9h3Kz8y+FWDvMPp12mlvlKlr/KqJYIKEOxaORsIZGENxve6zYfFBquBXBldFOsu1nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWmHZJSc1YyebAZEHJKHiy1Xi2FWngIbcOZ5SgJIbmI=;
 b=VU7MkBbzjD1C7Rs+vQVRss4r8oBm0YPqmQtW7P0n47DLmXQBzYWfyuFi96jOx+Pg/XuuzSxn7FdIkknCnZolARVl0zf0VjZJEYH6eUYZwFgCojjcx481EOK0X37kXy2mKU4KmlPtxTp1PgGmqoTGp7hCRkDz5y06KfKJ2Cnz6J0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 17:57:47 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 17:57:47 +0000
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
Cc:     linux-acpi@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v4 1/6] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Thu,  9 Jul 2020 23:27:17 +0530
Message-Id: <20200709175722.5228-2-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 17:57:43 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: efbe856b-0d50-4c66-7c33-08d824319685
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB68982D0D7F088669CE12E01DD2640@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UQNkIsgp0YZb0fiPzzRVR+yqyl9NL0txLRgbtDMhtgZSgmqdRoq6yXDfkjfGCnp/fB22DnnVmySlYwnVJbN/DE4BoIvquH6vWreFZNBKBzTAYPkDcatKaEfRHtmxZfZAucw23ZzcpKLNUXmn6ZEuOwxiP2n6t2IYmyU98ayyQ5ROMugULz5+Y2pXO1iOvDURlmSGmRMvbWcRK2KXJZ9FzXiBkC2+TK9jQFqA08UIJueB3fNsR96aIguf9Hh1nEpj8IlYdxc5dSeUDNMWkOv+t+swqJQhmEssTFtl+pKdGjmZ4Tc1Zq3BRld54MqNOyYILgrmrCy3dV4OoDs8zoR8FI/16wLUbPpOGSpmySyno2I706os2aQMRRV2vHw7xIQ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(6666004)(44832011)(1006002)(8936002)(2906002)(52116002)(2616005)(956004)(110136005)(4326008)(316002)(6512007)(66476007)(8676002)(66946007)(86362001)(66556008)(6636002)(16526019)(26005)(5660300002)(478600001)(55236004)(6506007)(6486002)(186003)(1076003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: KKL3hL0YB9XcQo67yzHth4KpJNsTU+MMA+cAuWY4a+VZVL10jlpn+vR9p1VWYaqGQY4gFwH1fhyzfuWG4AD6lCTLlAFH604sMtfdCt4LTV0Je6uFxlAAj711MC4rFu6a3ZK/ub89L1CDE1ZA5QuvAhaafX33O3vmK5/cp7JLJdeynxnI7GoU91mqr4a6N7O7wR7grMHM+PrVHD8TCeZLO7g0C7Rm9ct2Fyus7urfPHlxfKbfIjoOvPsDMLnBYHv6OjJIKQNaqeyQz3F9xX5E5Q2Ckqil2OLOhtBEyKVZqRu6wGUUspsMvfG+WMXmqb7LoB9TnUE1IYZpyUAhFz1OdOgeZ0DlVpjaabmLKG+Zsu5SsV/hh97pMuk5rVgKsdPsWKtqLvCvbz1s+kHP6gbrEdnxIW+WsKjCOJ/LZtijmvPAvPyiWOQ3TV/lF+1/kTDlNg95ldPA9b1p2sHRiYpGSXoa7O2FHKH4gOScVp7K/Fc=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efbe856b-0d50-4c66-7c33-08d824319685
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 17:57:47.2072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/3bkz/9iyNGE0hMd0vlwJQTZyIUw1v3AEWhoW38y2ex0sZDcXj9Di9YcQumRIAMkubanWluf5+Aoox6fsbaKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
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

