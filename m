Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF30B21A66F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgGIR6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:58:24 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:27872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726758AbgGIR6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:58:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6fUIXrxTWhEvqZNA6ZgTf9RUZZg3gbMTu2aP1cz8rIB72rlOUiop7K496uJNzxHFyjwDxtZDPzqbN7bE8GHLW1yHXYPz6LHcIPEk23HTc1/1u0oV3dgUOIfOoZWZ71+1rbA1Tqm7CuPS3yhN27gWNDJYFFVaXBKhxm7vyHejIv2uuH4POYdcgTUinr7iB2slZlxRAKuHuXvYjoiMdAqBJhCNL0/HwBNufdRj1aYdsQpzj5v2YWu1tE/ItyMTuuvIJLe90lbsWrbY/mzLrHWteBd37PFsCLjt0ZeYzmSqSuP9IDNnG2SHnnnND2OMxn4aWnZBH/oUO8iCd0hTci4lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCXJp5k0L5AS/FHvBl/Z6w7G3K0qDovYA4QZYZNdzBc=;
 b=K3iq5KA2dGLmAhDVtxCKW9bIxykC3MypvBeQPVZSMgBGU3aL99ZJf19ovZDWPrcgTIBJWXnSK7Y/erCHdfReZ02fpm2ZDNU0Oy7Vtm+O0Wztm09F9lq56tW7Eqy4cG634KN1C713OqdB/DDJZE0h4Dw6XCeAYGvnxM7/ryOGF5fruBltjm+nZeK0Si130cXWvZFq3DAMjqzyFkSx0FjI+l+19Xmq2B1oSp95gDNYJZysK8BApHwTFHWlISVSXKn1E0cwTgfqKnv7UoWleAz5lqWRFgIHC8o8jJy+6415zcwvxN0XmOl6OSl+M7W9Kt9NJXokElRhuBanQoGlOLOlbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCXJp5k0L5AS/FHvBl/Z6w7G3K0qDovYA4QZYZNdzBc=;
 b=FOc46dYjYkP/8PGvmtI/b0n6xU18UN6hnuT0me159flVH93KMfN/uyEoplg/v3Xv7e+6F07SX4XckMRsorentCj0ND/NcdtTFt/0G3+YxJQvBBfG7Km23lyPif6uEJmZKYKWFc4/zgnT7fqxClGwKkNvT7B7mfVYQ304r1iOfMA=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6898.eurprd04.prod.outlook.com (2603:10a6:208:185::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 9 Jul
 2020 17:58:02 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 17:58:02 +0000
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
Subject: [net-next PATCH v4 5/6] phylink: introduce phylink_fwnode_phy_connect()
Date:   Thu,  9 Jul 2020 23:27:21 +0530
Message-Id: <20200709175722.5228-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
References: <20200709175722.5228-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0151.apcprd04.prod.outlook.com (2603:1096:4::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Thu, 9 Jul 2020 17:57:58 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f99e72f7-a704-4107-161f-08d824319f63
X-MS-TrafficTypeDiagnostic: AM0PR04MB6898:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6898972EE27209CD93BF1707D2640@AM0PR04MB6898.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wauimv8RstcknTqvycyuer5//hoiVvTuF1lt5HiCPfu5R4apY7eh+dbgABylGJm6Lu2sSwbfMUg8mHUjPwGHeEXXegMQALZOYT8OoCXd3HEqaiXZZy85iZCvXjmaq6JGvzgVSTJPbAGUqBdvcl7MIKaHZoVzYWpQ2sQfJgPP4EEwglVTvTD3BXG/DiDraTGOiMAymTYZAcdVQzUSh3WuvDw3/uvAoHekNxa6pQhUaH+xp6e8Dr+6lWeSCJU72MyEFpWHH1L2xwyo1VcZ4lK9QMPChJpRlecHEBKW+t03qzIdkoIeV+YK9UbUEoeWTOcqercTkCrSBRuhjo5toOR0d8Nybi+pX7YqmqNe6B+gmIo6h0jT3ZecdDeoM8Mbgx7h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(6666004)(44832011)(1006002)(8936002)(2906002)(52116002)(2616005)(956004)(110136005)(4326008)(316002)(6512007)(66476007)(8676002)(66946007)(86362001)(66556008)(6636002)(16526019)(26005)(5660300002)(478600001)(55236004)(6506007)(6486002)(186003)(1076003)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Sf/vIq7g5+2b+o/YuMkwLrHQuWLqMkLE/EoMGPaXeymXrYDkgmk6RvfqEJZi1Dqu4ucPY50SFl1VeLLxyEuFgOcbvO+6Ll/iPRYAssSO23WO61/1HHWChw5KAKm0Atf/YnHn44LQI00IkiEWjr5u206eEC/+hJGuqRMtVcPUHfFbWkq9BHiH+/xMDdQOCS9K3oNvxxSyN9ODa58hJ8H6bhjbebJpIxqgS1cliHtw3gv9/+RKzv9/2H50FTUo7CZmhdg6DHevGG5tg7SSZtGb8TSoanE+3DeQp4iP5SWBvrEVCeyhAmwxidJUk12DG8wrspfcQld6RvAPOOtw+58v7IvtunXwRIrF7gx7YX/yW6GWf9Ew1arYVlnnON/ceyUsTMtZNgE2GgzI21Rck10AhAn//Pli4yVOI7W4KyVYyzqUgWbssDlHjZk7elPAQ0BP4g2JoAEShcpmD4YyITvKxW9jv+gw01xQPKsxQd7T6/k=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f99e72f7-a704-4107-161f-08d824319f63
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2020 17:58:02.1472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hgH0JhOglIk494K5oxOTWJ9b3lsKepLk+cyZDR8ZvxfZG3Tf/37yWdQjiG+RfJYxW3NRp3XYoXEku8QlQV/dVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6898
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v4: None
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

