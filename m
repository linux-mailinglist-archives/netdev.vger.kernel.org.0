Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714F321BB07
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgGJQcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:32:11 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:61635
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbgGJQcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 12:32:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ch3fc9/vjWZg5n1o88wQRjQebC8nIxqopZAvFOEo5UPutDFrL1Uu6DbYYbBW46kHeTkjsFLjn8VyC1Lln7T8Hk/KtpAN4mo8HW2Q5hgUEyaxE4m9oCmAxgScUuZEI/2aRKnYTjDlhNeIC6lpSEBp2xQL351XtlTA2Fp7cBFIPq4CYwN1wMN0deUo7KLqNveo6tkKF9q+zCjoxUJHX2lo2L+SPovvMysNbzfAXLQiU1xcXkflH0pzbJhPitHKe+aaE0ryHbcMyNU8JaFsf5c+GAL7WOt6tev6PCERq1wNRtUpcF3/j02hu6lyupBiuHH8m88Vb9nY553B3qZkk/Vdtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH7d5di8jh7O6rh9DUWCVSFi5M0AUpUv8cdPDI1FvIA=;
 b=M7/msdJeKsW7OeH1SRDQqD6SMj4aOFosVqnL8SHVbwvODPBXg9MKUAehMGJTToPFWkRfimijo2AClMLY8C4iih1avGJCzbO/jyYsgBr78SRytzfEWmqoEX6zbfMo683GuL1A7Z8OsqopQKx3FYhjM+h0diFQYgZMS6fVbG+AaA+tmM/41NTXgKGoqdHn+DdZ7Jc44BKUsTtpnBXMJDvbDUNK6IvwfFAhyKilZXXb08zS8fNJRKf0WzrC8VLw+aOhDXOlgWHgfkOVUgal8bZdEWi5OIc5dCP0B08nvxeQQt6uW/Ss2bUR3nmnGVSQvcqqQrNGICfAfDgw2ZsXAS01jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH7d5di8jh7O6rh9DUWCVSFi5M0AUpUv8cdPDI1FvIA=;
 b=HVfJ2YwHTdfGZoAsRuheGt8wpq1AM2ce70j/vyK0hUfiOg9TwZWZI+Q/5t1gW4codfHIeoYHXlvUl1JpROfRMYZR8k5GMvfxkzOr5clxZq1/f+KUmj1UEqlnVWlpCZ+nXF99usSc7sHFydqmy/FWZdJoTxZOuUNulU9+HaVOv10=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3908.eurprd04.prod.outlook.com (2603:10a6:208:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 16:32:03 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 16:32:02 +0000
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
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v5 5/6] phylink: introduce phylink_fwnode_phy_connect()
Date:   Fri, 10 Jul 2020 22:01:14 +0530
Message-Id: <20200710163115.2740-6-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
References: <20200710163115.2740-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0137.apcprd06.prod.outlook.com
 (2603:1096:1:1f::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0137.apcprd06.prod.outlook.com (2603:1096:1:1f::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 16:31:59 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4d2fc518-0b64-496e-09b4-08d824eec661
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3908:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3908CC2DCFEFBEC7E4835C8FD2650@AM0PR0402MB3908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGDoTl0oLrGJN3xHYtHKUNylMuxY5t3WRWjZw0pw4FML65B+ciQBtfhF1L55zS96qXkmwT9bNtQIS+EfXIutOonXsRJ3ApeRhDqTWrzcFTRyIyns33KRU7tK6251h19WPHI47J5zhq0NtoKXOlLhuM8TCNXhNPJBl7yQlToCVthXv5NCMck2Sw4EdjoNXA9w/YSNAY9aX+qcIoXIkqTtZlioWctnyk5fsY+J/x0UT++0DPWsiabolhQpqAq8AAtrL84UlBWs75Q+r73xgvHPSb61bEXONc0wuakmq/zQoy6sqec2JGPY37sD3uJslZsKDLfrkN1H/z5UMg9kEq+2jp69rT8J2tBnRxGP/3VEoKPA2SXrtsMno5+Uxx8yx7r1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(4326008)(8676002)(2906002)(8936002)(86362001)(26005)(6512007)(52116002)(1076003)(6486002)(316002)(16526019)(110136005)(1006002)(66476007)(66556008)(6666004)(478600001)(956004)(66946007)(44832011)(5660300002)(186003)(6506007)(6636002)(55236004)(2616005)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3gPOYExidBXsKt1CwRTiT//Hs7O+RqmqnJa5ITRuiupAgGqKrQOtboMnKypyHuypuo2Zc/lvKeQfMJlfGMhRzDOCxCIiIE8C2jcFmQt5GMSoSI8E2hh102jy1h9Bh7TbzoC8Cuh17nB18mGxH3QXRqEWkCIj+5VAYur59BwAjddjBsBd67qH/l7DfiI+/Mx7ZNFc9zj9oeysDx8b/bGOMyYB98xRmUqty8yXZgaV3CVw7olSwDlqw15D35Y8aZduYKnmaYn2Tk3tpQfvOVdbSCC8AQmgackr7i7mY2dPxnMqGQSdidq57YEjt22TOTqvOJJnXXDvueZM7MhBo73G94aAzGGqSyW3Er/Fx3wLnUgac9gazEMl1qXQLSiwsGtpcW4BVN8hQJ5LfuJwXm5UpJRhCCNl2iGguo4uJdhLhIiA4BGBsqg2d/FuOek1xykpSCvsnmcI7Fpo4sU1tyGEcCFG5VakQaEx56g1/oSD0bLYW7Wi66a8Nn4ZGlaywG05
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d2fc518-0b64-496e-09b4-08d824eec661
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 16:32:02.4648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwTSmo4StZAjiMKHOGopHwNeOun0KtmkSdTWQ3VV+4DWZWMWETivOhBu2lGtzZRJHV7JcRNB7tB6LYkVh5YFsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3908
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define phylink_fwnode_phy_connect() to connect phy specified by
a fwnode to a phylink instance.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

---

Changes in v5:
- return -EINVAL for invalid fwnode

Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/phy/phylink.c | 35 +++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 +++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index dae6c8b51d7f..44095e02d18e 100644
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
@@ -1017,6 +1018,40 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
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
+		phy_dev = phy_find_by_mdio_handle(fwnode);
+		if (!phy_dev)
+			return -ENODEV;
+		ret = phylink_connect_phy(pl, phy_dev);
+	} else {
+		ret = -EINVAL;
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

