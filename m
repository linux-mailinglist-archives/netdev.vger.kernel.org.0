Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F31336C33
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhCKGWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:22:45 -0500
Received: from mail-eopbgr20087.outbound.protection.outlook.com ([40.107.2.87]:62542
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229731AbhCKGWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 01:22:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9JeHM1M6YqumzxQWyag2U6BXkTyIRF1OyMCD5i+SmGZPTySckGKfIrNFnLqoMScYGDWt5Yfjq3uqvNy8/i384d/H9T7k8AQ37KvRZtiQTAGd1cc2cfEIw+fLQ/f8IjL00Qma5dT95+9gQ1Y4RZWOfWNMyeSVDHMS1KSNgfdUEn6NjIzutsZltlId15F/011StdHvb3i6QL9s6kqQqB72/g3zQrHcrOc7kaamdoZ2EnEFgph2Aycr7GKOIq8m2zNAGkCN0CxrYZ42wk5JfOwLFxS9WhpodI9u3jw5e6NLJ44s/Rf5BY7zRfFfJupH4oItEqnzIcgcQscETxYvHsTTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbeNqHN9xOSnqFb3oOZPxdTI8st23xm44ggrUr2CeK4=;
 b=M/kTxJ9HBqC2aelBy+6FTTDPOq5gutCViNvpsNDEtPEvu9lha0zcBWlDlayYetA9us2/Ros/+dri2sHFFz65n/P0TucVxpro0s0+Dr4erZtjp3WYSgRy8EtczFxWZvDc/bmaDs5BkviuZIDyLlMaudyU3xK9ZU6suxLwxiTro6fPccz2ww2UTTZKRcWsoaJmYNcjCTNmAaOOrf5smvLdvM6reOhPGLXVBPjoUfPqr1q1F2QbwtPUfhBz7zHmaf5BlRQWOFEHFgSMXvuPIsxvj3GNqRx2nYvOmKtF4HK1vEsliDXwV7HetoHK2DtW4/A9gqoseLGuJ0bjRMNRBgEQBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FbeNqHN9xOSnqFb3oOZPxdTI8st23xm44ggrUr2CeK4=;
 b=k5DipbjriJpySm82S1WYwOV4func9rI+CbglfCLxhO4Xf3bqvipeMsHcs1MXbnUne+hdSXvyAGh/vH6f832n/ej/1KaRGNe4y2pQFma+f36fW9moDqA1YwD+fNOXTZdk7Yw3W2HWF5N2lZ0k64V0Ka5lLYMY9yhrfMWEN4d/HiY=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6611.eurprd04.prod.outlook.com (2603:10a6:208:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 06:22:31 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::1cd:7101:5570:cd79%7]) with mapi id 15.20.3912.027; Thu, 11 Mar 2021
 06:22:31 +0000
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
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v7 12/16] net: mdiobus: Introduce fwnode_mdiobus_register()
Date:   Thu, 11 Mar 2021 11:50:07 +0530
Message-Id: <20210311062011.8054-13-calvin.johnson@oss.nxp.com>
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
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.9 via Frontend Transport; Thu, 11 Mar 2021 06:22:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 55f2d28c-f105-4e60-7ed7-08d8e4560d08
X-MS-TrafficTypeDiagnostic: AM0PR04MB6611:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6611197946D46C1DD6F4ADB6D2909@AM0PR04MB6611.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbKDB6n53heb4je9uikNKVJ2Z2UIWP1/GV+aAJa2/EfZUBjkfcbAUcCsiejNDxk87X8XTKbCCeJtXhVo5TGh5amvtAdj+yc8rMHsaUA3ykMwu5MLzBAPbo2f5XR6iFj3yjpGmqJgirjzu7ex7Xth1uN+z6Mu98VT7HiMeYY+SDzsZktDovEJnMK5fDRzyhtDtqGk8/5jgg+dXIc+6kBfUpMp3Lz9pjwM1Kig/CQCM2z4HyqKCrJakVrRjqUs8gBk1t0dHnOpjjokVbHf/luqwToeEDyOVcTTVaYcR6nU6RZLkfhHCHp2gXMP6eJxBYRpBUEaZgsEqeMTjSrMYgJncpkq6zcNOzEVni93uYGb+Adzn2mtHVFIU1CuoZ71+xgDYCVpKZ3Wyg/lNnYL23GcoHZmNTnyIop4tOjwcB1sWEyEIVkHZPIsJo7qGcUPfqXPw9UzVMExGVsEwNtq++SemPM5UFVZ6UyP8yqFNYsbvSe9AhcUoflfiC1AKTSBYK9LQoCYW5WYn7MJaPd8oguLHdHttAj4MSfAjMn8tsDK3tX1PGIjY4sU74fnwZKLtXjWskduekPh5GruwYgOgnCwy71jfcT0xES1ZeBuJJL7o4c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(2906002)(921005)(16526019)(26005)(186003)(6486002)(8936002)(6506007)(66556008)(66946007)(55236004)(66476007)(44832011)(478600001)(6512007)(2616005)(316002)(54906003)(5660300002)(956004)(1006002)(52116002)(8676002)(6666004)(110136005)(86362001)(4326008)(7416002)(1076003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q0/WAhl1WFRKfhp0SdZdpCB4LgsD136TKY0EHxJexHs5BnD6E8b2osE4z0je?=
 =?us-ascii?Q?17KLZvedzsSSuOhM4aATQBlhsfe7RN6D+86Lv5sT981R1MuT4TiuyfSutyDD?=
 =?us-ascii?Q?xTkGHDudZ2IECb1aGGR02Azvlsu0rEQJVUZLah16PCuQuXOIEm2V8+mcoEsn?=
 =?us-ascii?Q?CSksJFK2n8QFZCnQ2CijHIrZ6KhbpJ1blatjxQcOxF6xwmdwJFwNbVu8FVKz?=
 =?us-ascii?Q?2sGFsMkN1TShY4JSec/OeoHORWVMac0ZBbBf2OB/Q0slxO01dxY6NEzgLQRb?=
 =?us-ascii?Q?fKsjI4Rwx+yMpnOllZ+dEP1f3Btj9tS1fW6RZMuZvBQlGIfxFCOfvbpehIbt?=
 =?us-ascii?Q?OQuiicwrbt3EMeFvMLvUcmVtxucCiSVgcpW1F2W3btZib5pETr7px0EGIM7h?=
 =?us-ascii?Q?nnsjUMAeaszscx1lhU0rUw8UC2vktg4fuPEHFwxnobQYwiLCg7y4RMuEgdgT?=
 =?us-ascii?Q?Spior/AT6Yd8O8QKDymEkU2Q+ZTSEfOgxZ/xdPbPyhzU6IFuB8Qp7kWP93vw?=
 =?us-ascii?Q?Jk6oYXurUv3l3gVKAiQpJ7VmV21W3NlwTwFtchq/nRMWmoe8XLIorEpRedBQ?=
 =?us-ascii?Q?OmuSXlzfrnvjQyntrODuukLJJUMV0xO94W8DyOGixVNvKGBez5jdx/Urv4Zp?=
 =?us-ascii?Q?607yzF4DJeGPRbEyRztb9EoLU4OTGn17WHo/wXhPe9GzX5vXtVzfVkIy5xe6?=
 =?us-ascii?Q?uNIqCFGkcJGb6+tQm1n3ATMgYUnNlLC+ho9rFwFdAbWli6bFaFLNwiqlnqZc?=
 =?us-ascii?Q?D1Wy/ojhiFM0sWoXemBuESXpd+TZtmaG+R2jhkJ+lahWEJf7b2fCsGY7QO1D?=
 =?us-ascii?Q?NiV9hv0DoWw3MAu/v60TEJur7ydfZe3ZXE1HP/hD3uVapYAABeMzc/lfsAUa?=
 =?us-ascii?Q?KrHijX7pnF6XMo0a5S/woh/6gkzy4uqcvBDtSvl6Ycut/z5v0y46Gd6yEtlm?=
 =?us-ascii?Q?89/Q6zyDAnBeoAUtGNm7MoO+ra5mBaWM/P7x9pLsaPP4kyWo55kCYIZuCrHa?=
 =?us-ascii?Q?2q9sDi4a969V9ciBpvIUCTFrAxuDu3I0VMJpZv0b7pSJGCw4lCZbHkIR3xxX?=
 =?us-ascii?Q?S73N3eNvrMKVieNJgRseHkO3+CXHVX9WSvbuWs+kTfw6Ktn9+95+5Olr906B?=
 =?us-ascii?Q?ChjyMroUS9P2fmaxrQ0nKpGc9TaU2xF10aSozbhF1oA+rROGE0ynZyuwWmfj?=
 =?us-ascii?Q?bwV59G9KbRnHCTuwC0G0PPZtmYHpmh8INEBJ7AubsIVlOHffxGCAXhg08xrh?=
 =?us-ascii?Q?06sG7bpj1VkKmCaqqhJgOb0Pvex1A2ONadaoOjZvv/xVZMNlHqCTH0XNwplb?=
 =?us-ascii?Q?o5wVxLJArZIoFfTNHTznW9dG?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f2d28c-f105-4e60-7ed7-08d8e4560d08
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 06:22:31.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icWiSvD9ukvZJtRGgOGwYMRQbfEw2wa3LJt+24OzKyVTwEH7kEN292fmt5cTIfpZzdNJ6R1U+ODiBgdulxM8yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6611
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce fwnode_mdiobus_register() to register PHYs on the  mdiobus.
If the fwnode is DT node, then call of_mdiobus_register().
If it is an ACPI node, then call acpi_mdiobus_register().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v7:
- Move fwnode_mdiobus_register() to fwnode_mdio.c

Changes in v6: None
Changes in v5: None
Changes in v4:
- Remove redundant else from fwnode_mdiobus_register()

Changes in v3:
- Use acpi_mdiobus_register()

Changes in v2: None

 drivers/net/mdio/fwnode_mdio.c | 21 +++++++++++++++++++++
 include/linux/fwnode_mdio.h    |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 0982e816a6fb..523c2778b287 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
@@ -75,3 +76,23 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return 0;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
+/**
+ * fwnode_mdiobus_register - Register mii_bus and create PHYs from fwnode
+ * @mdio: pointer to mii_bus structure
+ * @fwnode: pointer to fwnode of MDIO bus.
+ *
+ * This function returns of_mdiobus_register() for DT and
+ * acpi_mdiobus_register() for ACPI.
+ */
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	if (is_of_node(fwnode))
+		return of_mdiobus_register(mdio, to_of_node(fwnode));
+
+	if (is_acpi_node(fwnode))
+		return acpi_mdiobus_register(mdio, fwnode);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index 8c0392845916..20f22211260b 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -12,6 +12,7 @@
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
+int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode);
 #else /* CONFIG_FWNODE_MDIO */
 static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 					      struct fwnode_handle *child,
@@ -19,6 +20,10 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 {
 	return -EINVAL;
 }
+static int fwnode_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* __LINUX_FWNODE_MDIO_H */
-- 
2.17.1

