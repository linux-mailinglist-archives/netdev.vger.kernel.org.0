Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721BB218E5A
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgGHRfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:35:22 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:43335
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgGHRfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:35:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwUqQWTMwoKdmf7qFU+vr8+4mMrjJTY0s6W8ozitJ6uEpxSdO+fgTlhW45N6BZLJrciM+VWwh9+CRboMZB6bYQUEu3/GAWkMuZ2/vG382fbJ6yzsF9UEbJ9g/44H5uzfNuKb5MtYV8MGOcren1Sei05J1fx0PSORJdEU3rNVqQhqFkRewYVWuKxTIGns6c981NsGiESv96siu+HICofC5aaYH41JWt5ayxHAUQrEhdy1tAFoYR630C4oN1zFojGKm6CekZ3WblUeW+oKP7LX5y/q1GwGGwzGjbwVMTKEppzga/FT70NRvZWAGSapMj1M2LVi4QxqZYMm0yKZJ30Log==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZVPsyvVBYEzD9P7EAvb/lFnlgEL76tyGLwECCXfxe4=;
 b=dGuoM6snB43yKyiGWtzK0f5dqdX3gt1B8YUQu9x54tDOdQ+M56wwLHQAHUUSlwFHNxjCUnOXvKoLIpJaL9S7f3PY/Oyt47DLJzwb7VGmGVzwcVcAzbpH4qpSIZUIxX7y99Pk/7L3oVtY6+QcMDqCdYV9q+8k2LkwwfHo7mJqs2Js0EAPdZi6BqwFUsGuhWX4cPfsCeu56ENzimaKQUQRGWLKlk6aKnLTDVhNvYmyUT5uVS5AEqkYYpLBOV1pXFrNejWvSSyJl0OpWsC3C0uZ6+a83BsuiW7aUhCYidELKJt3owP3Hecc+JIszCeBleTLjvAbdU6udb/ZLoSnKNOGuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZVPsyvVBYEzD9P7EAvb/lFnlgEL76tyGLwECCXfxe4=;
 b=GLU9+bl4YXbwB9pVnh5l4KEUYPs15DCbr1NgyxW5K0C/qgxfRVef8RqOPuFjsiP8qnLqbQUuQN1kTwGBS3Z6EHA6pktG+NglTZxuwZXUoKB2+S5tGIbed10BJrIQvWZ5VhwHHHNmIiQO8g0QtkUdJWkR1PNJKWgvIuRgVFSCwO0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5730.eurprd04.prod.outlook.com (2603:10a6:208:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 17:35:15 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 17:35:15 +0000
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
Subject: [net-next PATCH v3 4/5] phylink: introduce phylink_fwnode_phy_connect()
Date:   Wed,  8 Jul 2020 23:04:34 +0530
Message-Id: <20200708173435.16256-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
References: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 17:35:12 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b1247e1c-f167-42b5-4ba3-08d823654656
X-MS-TrafficTypeDiagnostic: AM0PR04MB5730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5730DBEF125BE95BC38DDB82D2670@AM0PR04MB5730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJ8j7jeRpkcpwooD2wcwo1RH9thjTI9rzcfawrhnk3bjmFaOKAGBE0e5FYO5aiyNTZorMRSOMfuUv4Eyzv4O+KOb5Cef80s1rNqqohJFz+9Gu/xVbR/HmvjZ/ASWmF1/1DSgpl/wcUUY8bubbjSdrrPzLNWXMO5Ko2Z5qICGCVHBHiNZn1jQ3ZDvLHg8wdOyZDchMR29ETP0WSo0GQBPVAbBSuZV3MXxQrHZLRFpdI6h++RW0ijbJ7rsXMroIdy3LbHIAPT1IrkOYygxwwDDlL8oHSMekcVu1SznvhHsmYTLbCsRSS2YljtMNth6wW12JSk72U4YhL10QD1NlIFyFtdn5L2V4ySMRWBThsxmYcd81WQiZEfCTq9zlJurBGTe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(86362001)(6506007)(66946007)(55236004)(1076003)(66476007)(66556008)(6636002)(110136005)(4326008)(26005)(6486002)(52116002)(8936002)(956004)(2616005)(316002)(8676002)(186003)(2906002)(16526019)(6512007)(5660300002)(44832011)(6666004)(1006002)(478600001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XgzT1FIkCEWhSLETMiqZ57mrZ5NPLECfPeCKSjubGDb8JhLzyR0Rl31KHEs9a4vkVPvMooQtJpy1lw9tAJ3TLlkdMkDu7FnJVfzPbiFRfpgRK8LCZEIBnf4sG2Ql+rOcc9yYJTBQRT1O+dMfTI1w3bVgKldT0Nk0bwxQ8Iyzz1GMFmLTvbyL7sztIOlofobk+5UoUjtXtH9ecoopsp6q0xn3iSyRFGmFbEe0VlPJWOaymMvhWbNKXL1jprlOL5t0k76ibJz57mcEustMJiV1ntlUy8UgbZhIfrK87ej0vNyYO+i7uU4VIzf4NMYuI1pe76F3n28E67SLfrvlSxWifm5uv5gpnTycZuwxzqTid+gFGU3kVBUn7WeZcwo4LgqSWf3asufvW5C7QN1hNm4inmaHo1VuDdxekhoKjrbilGc/ATw87J191e/Cra4Rn7eJZqFRVbFxhQPGfvb9/ILa5stxxnWcqOqlt+8FimmCGnA=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1247e1c-f167-42b5-4ba3-08d823654656
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 17:35:15.3763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dr/NZfNd4HdybLfYbum/kRE7eEt9JMwJO2jDI7Vyni5y8PTrOn1a7xfViZjF1FxrLle+jIqQgPNLlCXjeQQUlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 33 +++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index dae6c8b51d7f..35d4dfbf5567 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2015 Russell King
  */
+#include <linux/acpi.h>
 #include <linux/ethtool.h>
 #include <linux/export.h>
 #include <linux/gpio/consumer.h>
@@ -1017,6 +1018,38 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
 }
 EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
 
+/**
+ * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @fwnode: a pointer to a &struct fwnode_handle.
+ * @flags: PHY-specific flags to communicate to the PHY device driver
+ *
+ * Connect the phy specified @fwnode to the phylink instance specified
+ * by @pl. Actions specified in phylink_connect_phy() will be
+ * performed.
+ *
+ * Returns 0 on success or a negative errno.
+ */
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags)
+{
+	struct phy_device *phy_dev;
+	int ret = 0;
+
+	if (is_of_node(fwnode)) {
+		ret = phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
+	} else if (is_acpi_device_node(fwnode)) {
+		phy_dev = phy_find_by_fwnode(fwnode);
+		if (!phy_dev)
+			return -ENODEV;
+		ret = phylink_connect_phy(pl, phy_dev);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
+
 /**
  * phylink_disconnect_phy() - disconnect any PHY attached to the phylink
  *   instance.
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index b32b8b45421b..b27eed5e49a9 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -368,6 +368,9 @@ void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
 void phylink_mac_change(struct phylink *, bool up);
-- 
2.17.1

