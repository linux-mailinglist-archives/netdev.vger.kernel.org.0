Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180FA452AE6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhKPGbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:31:34 -0500
Received: from mail-dm6nam10on2119.outbound.protection.outlook.com ([40.107.93.119]:14080
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231910AbhKPG3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:29:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FGRxlJu0mxigTl2L1oYii/73zsaTSr8J1+/bn22tK2y9xMssQv3MjaCh7F3rBE5xGTnm3a7zqr1NCj5bFoUNNZedo0NjlUzub1dnmksJbe0RwLHPS1RC77f8hiOGnGDzaeR0hi6Ivjsff1k+TL6OO4P9tHNU+thNbyXmIj/VEO2hSdmKGw25LCUD1KexEC2aOEM9P9B97A91BEsFvhyNWZuLLO3BUOVq3Pbhc6SYCCdXvXhctR5uOCHPviuPOrU+A/+6nMKiptyl25rlMi2vSwgiNBbyY+KzcNvkhvl6FSuY+PI8yVESUeGvvyN4dNhXaw5A34vU7gIhIXEPwyHVNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLCR3kk57HMWQWKJr/cxoP2rkhaqsgktRFvEAjqD2dw=;
 b=UUq+zabbGuIt5yQ2ejVvAsONrcK+mbaM3lrduqujXKVRNhC7OYNukYJp4zeWqFQxyLFe0xTwFluHoVFwLIlvqtxr+FUGqPn/JltQ7MGupqo5quZZV7FStWbTrCIdw+rtMixom4FchlYW/XdNDox4D9+ap7bJ9EoU/ue19zEv4QKKjF+KQVTY4Ew99ySs0CjFyfLXail31jaJSHVVCN2YSbd3Sjp1uCf9iJR7H/nQamtb5/KRUllRIVu1eZW8Uzo28dKX32whFy9b5KoCTk1A4OHEl8KZuhLE/6J8YNxuT68OKATZQF0sYgUQ8xJpyrq33okS12W4x6W6GmQCAftlVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kLCR3kk57HMWQWKJr/cxoP2rkhaqsgktRFvEAjqD2dw=;
 b=hsVKjZU2GTiPwOaxfHxWFo5S4B/RRUn0u5njfJcrUDSleuqyANUk6P91LLmXGmPkMMG40Q5HB3Bj2YeNvei6nM2LlLEbzyhxb/td1JJByT6UiKBK70GrrwcR+ZHXTi5NS3pxAZeU2SoRgkl/Y1JdFwUgLtJV7QsTtsc1YBgSJRM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:54 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 15/23] device property: add helper function fwnode_get_child_node_count
Date:   Mon, 15 Nov 2021 22:23:20 -0800
Message-Id: <20211116062328.1949151-16-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9659ca47-02da-4602-919f-08d9a8c9a9c5
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722B8D26E5F46ECD3B8F5F3A4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9OqdySCrX8o3GnfoLJSmRjIBnOqXZtwgNLQjnbpt7G9WUJbnsOY2p/z/W3l7iM3LwEFjunF7l5BjtQsDvscBWpVy0jjuzNE9tyX8oyVsFt9s8t9eeKC+OvM72X4f5HSh+Q8Z2FO/nENK0R7nw3GJI25csDP4naGoBOMX9nWHZMyD33s7TqGypPeCiDx0zmz/ocWlZM/Oacme0YvSNs5SiEkuM92a7EO7qRqvbxIzlAUThP5Gat+FEZgUG84/BnvukwQ6fXW6hjI3xOGzNhJBGA2fnUej0j+m6rGbjVjQ85wpOBDVGTONW1OcWlFYEi04kHwxcQeKfpGECMuF3L+VXiKu8svmLqbhAyUVLjs6ylpBSOJgVB6r4Fv0Q/YJD7pC3nn+miVJY+Tyo1bWvHoUswy0ro6wiAElcoq/MiOzD8dyBBvcciVSFIMGbVi0rypxC+abhkmE5mGkJ+HAl+Q05/MbQFNFfxoXavkjnyP6xk0Tos/iLYOa3RjbWyWXbTeAQgQqKqIX2hvuvVRgi+N50FLAsPzuZ7PuSUSotHxD2Xg2Jpgweo3HXY0PfCbVe2+XxJ9ZLW3s8RT4w3kTu9/hjb8yrT/FrE1JpUl0BO4rpIcKVhkSvZajVDG2iSYhvcraqWAlj3IZUSwTXx3S1nYa3mWY/L1KwJVr6t7/+brawIU9xD/DTPB3aYtUpyjpW7R/eu65S35MRswBP+gmY5CSsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3rYNN1fCdw1EIm+4ttC+ThzvWLJdRlX8NZgEFnKux0sqkqRNokvRPJUc9KhL?=
 =?us-ascii?Q?pDXuclpHLWz6jT+NNWItbsgSz+iEMqhY7/3F0j5ZCBX4m46vx04JIFOh0J+r?=
 =?us-ascii?Q?c2QIE8sjSmtTcztG7lJm5CWE9TY/cGtoR2AtWduGdWZDq9MyZB+nMS/Rdst4?=
 =?us-ascii?Q?Sm+d1/XnvBVTXP+Y3k9/RiPtTSHah6f7tMT8MmjlOcP8gw+jHBLgX8QZQ7zL?=
 =?us-ascii?Q?hgWVz9rfscPojQUeRlEIfAEy4rvBwaf5H6j/4wVIhLix0KFDldZw7FxlnwD2?=
 =?us-ascii?Q?UxpOMnEjXfe/EMhz4aa6zmC8bkzScEnST6ZTejoLMkxMTkonObGJoezKzUWL?=
 =?us-ascii?Q?8pt5gC870upI8bN8FEvZ16b1VYwMhETFnOH2dg/nE4ss+GKNfG9kY3eiLBSk?=
 =?us-ascii?Q?uoaeHYIAF476+ECy6Mnlc3HVgsWLeWfIxsqXndHX7ztOKAdenoDxx2tWVxfO?=
 =?us-ascii?Q?UUKGY7pqCdtsvO16j5Z6jc01LsAgQ95D1XXe9oMRIKvwtKHCQY59IOv7HGP/?=
 =?us-ascii?Q?YW/uNmCSkdThH5TX8Jxuov2dffxKGfSalW5yhy6pGZhlGtB3hG1kR1rmngX6?=
 =?us-ascii?Q?t8Ps5O35IPUbIi2krIuXpa5w1r3ITvZzu4y2cdrgdDQ7dXicNodPxSVNyO95?=
 =?us-ascii?Q?z1h9ycIqldVNQ+hYQSCQiq6YJ/F2hrrTlW2wI9EEnh9QCXWjEQ48BH219faE?=
 =?us-ascii?Q?3uvaxnZEqHYQYyTdJ9uR6d5Se0hVckUD65DK8pF1/eQtVZapx1mCkd5bIKWM?=
 =?us-ascii?Q?acOiiBeF3LoS+evah9QcSfWODb6hvADyPOXfcqW5u4G9KVAVK96OfN/se3se?=
 =?us-ascii?Q?9E2N7fdhcZiMB8Z553xfPC0DOcQV+h06+OH/mrgYp18TI8eJzg9mClkaCoCT?=
 =?us-ascii?Q?Qfbzz2LhLjZ8UVrq09LCr5PfP2I8apfblEtHG5eeOvd9pKAHUtr2h5I/Pnyk?=
 =?us-ascii?Q?jQyhVz17JQdabXGbVLbyhTUvLebM1Xr1frZCs/sx3N1Q3k/JWmjZpjox0r2G?=
 =?us-ascii?Q?RsHkBKq479WU6k+uBJiM+7EfeTUVY8qZlfCatbsWf+ZAibwDrdzO9IRotSOh?=
 =?us-ascii?Q?zI0YjxpgtBuBUdPyKeW9vGu2iqrk1muMoeMEy/Q+p4RNqPOWs7XG5HU3It8b?=
 =?us-ascii?Q?GCqatrqrc9WdN8ratm+j1+Dv4yzie17DXPXhg2KrMGWLDwa9ODdKvlPMm9ti?=
 =?us-ascii?Q?fqHYp5KwlJL8SNimo3MyV0BS5aLiravBlYidndDFqsRQ3q0msO+yLJj2dCSC?=
 =?us-ascii?Q?6ZL6T6a+J9dWxstBR5KttG1H64jG/uxkK4bDLczmNA2hDJwj4DKCMWY7ZwXM?=
 =?us-ascii?Q?qZt6xxVUjs+bj3048zYC4k6/RURVrHv4ezPHlA0f0PUpkLVcRSOl2Kh1M0xb?=
 =?us-ascii?Q?EyEybPdj8zHW8NY9HpCEBd3mrx55ME+w2Di6lyP6qLRW6lpMX2o81c2c1FQF?=
 =?us-ascii?Q?9WBK2OVIDrvlF/U7C8y2ZQB74upeUhYqWLVYHElvGxTkhQYTT3phklaOVjm9?=
 =?us-ascii?Q?MH8fRqJ9qdV9bIoLBCUnmpxkvMK8BteFEGHN/rvXENDF2WQ017TsWwbAU9tI?=
 =?us-ascii?Q?9gW7FNKTTovN4ZZkOzsS2f3m92YnHf09XDjlbX2yRjiKeU3v8uz6PAWA+2mZ?=
 =?us-ascii?Q?7JgJu3+OyuXY4wNWrUK0/tWMS8gC53PIekuOQKTYaV3nYpWc2vvXvc/8xO5g?=
 =?us-ascii?Q?ltIjMoiwRbGXjGnWKRQ+kaPt6jc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9659ca47-02da-4602-919f-08d9a8c9a9c5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:54.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3vh5eA5mUXQw5NhTuyR/JpDbff2V2nK/tNWFm5xW7++Dh2EZgODz0tKOej2awYeyEWUI01Vc3y1m+ZwHNff2JNFHMJNj8RYe8CCQhjMv7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions existed for determining the node count by device, but not by
fwnode_handle. In the case where a driver could either be defined as a
standalone device or a node of a different device, parsing from the root of
the device might not make sense. As such, it becomes necessary to parse
from a child node instead of the device root node.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/base/property.c  | 20 ++++++++++++++++----
 include/linux/property.h |  1 +
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index f1f35b48ab8b..2ee675e1529d 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -845,19 +845,31 @@ bool fwnode_device_is_available(const struct fwnode_handle *fwnode)
 EXPORT_SYMBOL_GPL(fwnode_device_is_available);
 
 /**
- * device_get_child_node_count - return the number of child nodes for device
- * @dev: Device to cound the child nodes for
+ * fwnode_get_child_node_count - return the number of child nodes for the fwnode
+ * @fwnode: Node to count the childe nodes for
  */
-unsigned int device_get_child_node_count(struct device *dev)
+unsigned int fwnode_get_child_node_count(struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *child;
 	unsigned int count = 0;
 
-	device_for_each_child_node(dev, child)
+	fwnode_for_each_child_node(fwnode, child)
 		count++;
 
 	return count;
 }
+EXPORT_SYMBOL_GPL(fwnode_get_child_node_count);
+
+/**
+ * device_get_child_node_count - return the number of child nodes for device
+ * @dev: Device to count the child nodes for
+ */
+unsigned int device_get_child_node_count(struct device *dev)
+{
+	struct fwnode_handle *fwnode = dev_fwnode(dev);
+
+	return fwnode_get_child_node_count(fwnode);
+}
 EXPORT_SYMBOL_GPL(device_get_child_node_count);
 
 bool device_dma_supported(struct device *dev)
diff --git a/include/linux/property.h b/include/linux/property.h
index 88fa726a76df..6dc71029cfc5 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -122,6 +122,7 @@ void fwnode_handle_put(struct fwnode_handle *fwnode);
 
 int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index);
 
+unsigned int fwnode_get_child_node_count(struct fwnode_handle *fwnode);
 unsigned int device_get_child_node_count(struct device *dev);
 
 static inline bool device_property_read_bool(struct device *dev,
-- 
2.25.1

