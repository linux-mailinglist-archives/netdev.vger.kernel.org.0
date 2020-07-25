Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC4122D81F
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 16:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgGYOZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 10:25:16 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:25203
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgGYOZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 10:25:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=etfvRWs5bBueYGhAOEKL0xoXzZejNEuNfnccDmvzCN72Q8VSHPrYp4/poeUpoK7I02j5MsIIp0FsjkeijR/4uSO06Y2Scy0wkW9027c5aQht6gJn9kJwnpPRfahPq2kgO1CaPSHicrRanu7tz/qIXE2WmEW60HbtFFz5OijCTHxObIbxjv25MDYxd879b18WA13a7JoUSoBXqR95r4CF6bkwuFpEDCYiT3SN5trm4PSMBuNVJV18zZXWRdhzWX8edA9bFq/tiPmyp8jL0D7ZnhQE5CO4SE8JONmy38BRK8vOr9pKBdQ6dTR/QeIclE9re4mLAfUdKcc1k4vg154vBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ziarr/rvHphiexDqWgSBb5gjR25RlLjD89AgsUPmyAc=;
 b=I8lBy9ZETRTvbKl5cG5KIicrYELeZEiRAnJtEvRl3hQmVn18cs2x8TfFJcIo1a1NdqntX4PynZiKhYRWjrPoJ3MemIZA/W5bbDeuyKl/0TGUNGbWtRMifAOucYROAn6Uu5ify5urNdgLdP0HQEpOGTf7WwIDgjUmDiwmUx7dnSuay7kAa4XF2GWNvKs8XM6Kr3P4UKSMqzQmsRXc8mBc3GpsUpp619LunNS2D2ew/uYa6ofSYXeb7pIS63TeFU6I9lRiNH+win1tVkPubkfsYea2Z4xjeGjYarWgat2eCW2Y0jHHBqE+0BQlgJi3jRc3MlLyVmydp/l5xMpKR1JApw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ziarr/rvHphiexDqWgSBb5gjR25RlLjD89AgsUPmyAc=;
 b=VZUYIm1kvUXiv/6OrhyIjEp+VeZKnKYv63rS9fzbuwBJJyPWB9XdMu3hecnVK0rL4DdsrVdgn7Qi0dLz/wfnERZC2y05TmzBXzzN7X/7+gMi4qOk7TIY0aWV23nhIDWSJptxyFNsnnnPgZGy8Ca2L9PQKmWpKycLISHnqttQeSI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sat, 25 Jul
 2020 14:25:12 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 14:25:12 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Al Stone <ahs3@redhat.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux.cj@gmail.com, Paul Yang <Paul.Yang@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 5/6] phylink: introduce phylink_fwnode_phy_connect()
Date:   Sat, 25 Jul 2020 19:54:03 +0530
Message-Id: <20200725142404.30634-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
References: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:3:2::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0018.apcprd03.prod.outlook.com (2603:1096:3:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 14:25:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 030abf9d-da60-4c75-951a-08d830a68a74
X-MS-TrafficTypeDiagnostic: AM0PR04MB4931:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB493197066AA06EFB4A41F2E0D2740@AM0PR04MB4931.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOyhYUEMen80TjLBAeViQd32oW6Yjgs0LnNMnhksxxyO52renYgXBPKK9T3Cnv8S8svDuoVdoVxZlnLDvDppnAl+fgwdSNtAsmLM3vygb8HHu8RpKnuBYyRt1nogyAEwHFZI0FJ5DAT22XXt+Nj/80nSRNwfxzWPFCKmajAyRBtQlVD7AUpAKSZDRfW3tifZT/2fXLHKCK1I+KufOupa9ZAczaV67L/MmAMQ6TyrmA+LqzSk4+/WxuymrhcHvdoCY/LmZnpQh8Jg+SNjM78SnDg0v26F0kDiW6ZUazP+f6AuB5+rRWk2+Ht40P2hu6RBOk2IMTmeMI/wFJyfs1izPmDQP/uesdwc+TGw5oFYOyZKythLBYkeRo6U5itwMrM92Jzrmwa1mFBkDG0OujrJMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66476007)(5660300002)(6506007)(6512007)(86362001)(55236004)(52116002)(478600001)(44832011)(110136005)(8676002)(316002)(54906003)(1076003)(66556008)(4326008)(16526019)(956004)(2616005)(26005)(8936002)(6636002)(186003)(2906002)(6486002)(6666004)(1006002)(7416002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HXRPFCuW3H8Vlu5Alg80OWdt5CtL8Zyh0QlvsQB8KjczW0CUaeXCmh3k2J0KGqDNhdNA00/l47Wq+rYAvac1T9pZwO1Crlgogz6A6OWFJV6BjMuDKZYUmeYiLyI7EeyIDflJh3sbdH3wosr2/dJ1P2X7Zt/19PckxLZF9HZlbtZ2bDp3kpH1V0WsHilDRiHF3tzRDwR+lmi9cT7EpovjzsOozA1iW/TUJFkF0Iq/j38u51jel22GIQs0rVuwSoqZWeumNk1zFPjiv4B0QCBgvyO72IQY+cYRWPG0Dis6ZdItBCbMTFGPNFRJcGFY8LYAj1HX84JZl2CbtmYCmkI35Chx9doXvNfixYDVSeKh0V5wNUnVtY4sB4J4PfGBnbnimLw1sjWrsC4jLuaqU2bG8JMS1tM178f/qc3b9dxrQhd2VvWpHuTS0izJpYr8bI3WncZJ8PQ2taP4fj9mGI9MRZHcnI8OcZvBVCh7BKEfSy8=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 030abf9d-da60-4c75-951a-08d830a68a74
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 14:25:12.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uUeLfwVL6Dzx9OIl9MuEFHN3883qnR+E3mjSn3WDgL8YGE09vSMrpktDSCvZEHybFei8I89yJj3v3yRMlJZ8Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---

Changes in v7:
- assign flags to phy_dev

Changes in v6:
- clean up phylink_fwnode_phy_connect()

Changes in v5:
- return -EINVAL for invalid fwnode

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 32 ++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 35 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 32b4bd6a5b55..c35ae42d9318 100644
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
@@ -1118,6 +1119,37 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
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
+
+	if (is_of_node(fwnode))
+		return phylink_of_phy_connect(pl, to_of_node(fwnode), flags);
+	if (is_acpi_device_node(fwnode)) {
+		phy_dev = phy_find_by_mdio_handle(fwnode);
+		if (!phy_dev)
+			return -ENODEV;
+		phy_dev->dev_flags |= flags;
+		return phylink_connect_phy(pl, phy_dev);
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
+
 /**
  * phylink_disconnect_phy() - disconnect any PHY attached to the phylink
  *   instance.
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 1aad2aea4610..ba23b5a1548f 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -434,6 +434,9 @@ void phylink_destroy(struct phylink *);
 
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
+int phylink_fwnode_phy_connect(struct phylink *pl,
+			       struct fwnode_handle *fwnode,
+			       u32 flags);
 void phylink_disconnect_phy(struct phylink *);
 
 void phylink_mac_change(struct phylink *, bool up);
-- 
2.17.1

