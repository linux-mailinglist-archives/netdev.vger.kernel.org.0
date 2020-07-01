Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687BD2103B4
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgGAGN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:13:28 -0400
Received: from mail-eopbgr30054.outbound.protection.outlook.com ([40.107.3.54]:63137
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgGAGN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 02:13:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amjo4lCx+2svjmZ46nzkJEbpklYgHLFCQNk5Kjox4ltgNQ6OUSdhgaBV5tqff3g5uFBnF2kkLN4ToEG9iqfjAmnngppaIsFnkJ61cqexlFnZE/7TWrcHHikbdqhMnExQHlRROCJAKbjVhITtgGty+XfMXHbbUDFFmr3qBUrkIky2txA52kw/FLJIQ3uD49G8CDW1PFTFyXW+sqs4YeI2a+SiqdeWgBCr5v1Ot+rqXDRWXo0c1Jke1Sp0C9+9NQg59LniNLHW01oBTfWU1ZHnpjvEJHaeWUpbBpvtLcP4bD/KLa9gpgTojblFRPEnIGyBEHD2UWXVDN2X2r305fX65g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RyyMxoKLb0GzHCNEqeAf9e6bpfPsdTF+a9VNgh+YwA=;
 b=mQIsPVhn+d3/TJ5uFagw5w8VTHnAZT7puUcAoUM/77IfN76V2C9JYV8sVqabVd0Nq9mpkys8r5gD6vqnSoUPUfewu4/GgyZA8ZHIWHLK/zW3Dt1jvfKg5UbOLd3nb2/vq3w9PcT71A6uzAcloOOQwcWOKV/WvGQpuS6Zk4p57waxJL+c2wSWzcH1mzqOtlJfSHa6wzGxfSp/N6Tdmn/HvLwbGj1S3DyGVp7aiC6zV8bhB2ONsQVP/wDO+n3c4HUF8EGP/ZFh3YNJhe16c8gl6KpQcpxmuqzbljDAnjZu+dfRBhkEU3NIgK4ltodwDWQ1w6CWF9QAlNXI4RU8n6uXDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RyyMxoKLb0GzHCNEqeAf9e6bpfPsdTF+a9VNgh+YwA=;
 b=LQmlH0UYRQIXPA3kCnewy45ZE93vejgEPP4IKFM52RUgXEFKGNqEO0gURmFVrAZQutV64nFlgCq93VLENQSq4HX5xfI2jBOHCVxoT/O5ZeaJQcqirMFp6YFj8sF6Bu7LCkQFud5dMHyOyZGLj8dWrGC4HFh5FG/0c8Gr2BlnLpQ=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6066.eurprd04.prod.outlook.com (2603:10a6:208:13e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Wed, 1 Jul
 2020 06:13:23 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3131.026; Wed, 1 Jul 2020
 06:13:23 +0000
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
Cc:     netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux.cj@gmail.com, Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 2/3] Documentation: ACPI: DSD: Document MDIO PHY
Date:   Wed,  1 Jul 2020 11:42:32 +0530
Message-Id: <20200701061233.31120-3-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
References: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0230.apcprd06.prod.outlook.com (2603:1096:4:ac::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Wed, 1 Jul 2020 06:13:19 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eee5a63c-6c7d-4772-4a74-08d81d85dbfe
X-MS-TrafficTypeDiagnostic: AM0PR04MB6066:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB60664DDDF6A3899CE92A88E3D26C0@AM0PR04MB6066.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9KlUPKAsAd29JSUZzR4bn8r2+sZLwjczm9nvL/v4sObki7bfrn//LO2OpaFfxSDmD9Vup+qkwDqXBbNxTpmsWEdr9PHg2MIpQcUuXG4ctEz1/8w0QX5N/9AbxCu8t552wXXP5ZOGikFSMrrAqKdiHgptsvshfWNpIkOf78baVGPywPrONoPxpyyZYIY7/aIzyqRs3rq4P+VccLynvBF3POqDmlR5NPvUrfqasjLeCl0PW3iPDKBwNTjrXAmH6U3C6EEpfM1TKxmdQUglInFXJM4/4bFIkyS6ehvszq66sIrcDO8+inxybmAxDAARMxFroumVFvN0MpvK8vkfHf3xP8sqdBKebySjD5c/IJ1gIAlwOPEarLmXhrUQCYVznMHK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(2906002)(6666004)(4326008)(7416002)(6512007)(316002)(110136005)(54906003)(86362001)(1006002)(8676002)(478600001)(66556008)(55236004)(8936002)(5660300002)(186003)(26005)(52116002)(6506007)(44832011)(16526019)(2616005)(956004)(66946007)(66476007)(1076003)(6486002)(6636002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Uk25naEvgFYP3Cr4uBZ019rH2SDne0E5JeBIUbCy2YgWGc8j4OHfOWSZzhEgv7JugJfzOAK1akGJrZdpvqeDXw241LfyQQ0Wu3eq3FspCkXfEAF7MwLySwJfJjiWHbuCH1r7XMrk35dYlZYJxJlKxLrD+ykNugjdHEIuFthHHvbeIoETmV3F+mT6DDwc0qhzZNP/gesZCykh84XC7yQrdu1dC/WRhm4YPpara4/QCPK8Ah3twQex1ivdTWQ6ezhl8b9T1EaiUpN8c6qgoJjYxw5VD018gDMxCkXUBDQ+nN9Hr+bdHOQZ3FJzYMSboKEjy/juZNqN6hzwQaRH32TH/Kcb3SX3u9ffJtLxtH+LlX7djztYKVSJC1BF2KTVRXjQLlrUZSFefqhFwNRA9b8+ndQcrgc9VmjRIToR2CcJl2M2ycQD0WNbQfGo+yBp/Vj2umGpBYBCrocYMCgZruVU6NtGPkPwLkJS6Ew4J5XLlAA=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eee5a63c-6c7d-4772-4a74-08d81d85dbfe
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 06:13:23.4355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jniY1qajGkesX4vY+QtaBIGrwcigfBn9ZQqa3ABjzgy0VaS+QPTmw3TXmW3JsxMDa9hLi2fkaeAJaSu7Ntxuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6066
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce ACPI mechanism to get PHYs registered on a MDIO bus and
provide them to be connected to MAC.

An ACPI node property "mdio-handle" is introduced to reference the
MDIO bus on which PHYs are registered with autoprobing method used
by mdiobus_register().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v2: None

 Documentation/firmware-guide/acpi/dsd/phy.rst | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
new file mode 100644
index 000000000000..78dcb0cacc7e
--- /dev/null
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -0,0 +1,40 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
+MDIO bus and PHYs in ACPI
+=========================
+
+The PHYs on a mdiobus are probed and registered using mdiobus_register().
+Later, for connecting these PHYs to MAC, the PHYs registered on the
+mdiobus have to be referenced.
+
+For each MAC node, a property "mdio-handle" is used to reference the
+MDIO bus on which the PHYs are registered. On getting hold of the MDIO
+bus, use find_phy_device() to get the PHY connected to the MAC.
+
+
+An example of this is show below::
+
+	Scope(\_SB.MCE0.PR17) // 1G
+	{
+	  Name (_DSD, Package () {
+	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package (2) {"phy-channel", 1},
+		     Package (2) {"phy-mode", "rgmii-id"},
+		     Package (2) {"mdio-handle", Package (){\_SB.MDI0}}
+	      }
+	   })
+	}
+
+	Scope(\_SB.MCE0.PR18) // 1G
+	{
+	  Name (_DSD, Package () {
+	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		Package () {
+		    Package (2) {"phy-channel", 2},
+		    Package (2) {"phy-mode", "rgmii-id"},
+		    Package (2) {"mdio-handle", Package (){\_SB.MDI0}}
+	    }
+	  })
+	}
-- 
2.17.1

