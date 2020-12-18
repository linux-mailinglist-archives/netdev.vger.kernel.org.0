Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAECF2DEBB0
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 23:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgLRWkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:40:46 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:27453
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726117AbgLRWkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 17:40:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+q59MoHR1CP3CrBdZ+b6DUceSf47oQR6xZDHqgyTv+ThB7pmZIBX5qiLO1drqD9cmyFIcnUkFpHyOQjSF7Rm90dJJ8cMpqxdXgT4US2SCc5ieGJYS66W5bjsyBvys74Htapehc3rvnsCtiDK9uHIuDwLaO/gGPoYSxFD9DQF0fS0O7+zj6udgrKDBXzBfgaV+79zHrsJW4lnMaSgfdKWEAUQNOvrji2Y1duLjNe6L4w9B8NJ/YtrO2e+swMUDu1cvVaezaUou8dS3TpTiCaQpR8pwVLVr53d5KwdrhaNpGEcU9PPMUzR5Yo6OH5L0iUUN/KOWMRD//o+BJisU5apw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjpZf3haDDYaMwkVc7gTUXZZcDHe66vTb5U2c4i8hRg=;
 b=W2lFgQBN/RmQy+3zn2pg0iKPxKY5nQVyl4kI980BL+iistvwDOrb2YUEcJEiCxdiTzLMfGTAkOM0ngIGR3vmDgkMv0VZ8yfL29289H6jtbFgtNccPAUCy1Uxhw1kwxX5+cF1SiPyuU1vVPQ6kwhb5Y8/b4dWNH8UQNdnrs0QJeuEDi3CKgjo9J3jxCf6PSrQWk94m8AZORMZowjeSCElPAW+mzuQXIz7gSUzZKxe4UndXWAm748+yTamRGWvEL3ljlV5nxi4if2IM+6CNPkhs1Mj83xGG64/KfFZB51Kt1PTMTz0j7cIB0xyBlCjwdUDuIkWxT72EcezXFeXKi7TyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjpZf3haDDYaMwkVc7gTUXZZcDHe66vTb5U2c4i8hRg=;
 b=H2o+B/rB9tjCEcHdKBNoV11qhOsRK/WZclKzXgZiSBtZjz9wu8oIYCwoftgQ/iBk8am8aAOQcduBA5/xjS+ZJQsNDSNkjF4du+tu7QDSGEQLtEy7NBYBEbeJxtkQ/WStvS+RhQE478ngGldeL8RwdgLQ7uysExWjBfWAIeaoBxo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 22:39:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 22:39:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 1/4] net: dsa: move the Broadcom tag information in a separate header file
Date:   Sat, 19 Dec 2020 00:38:49 +0200
Message-Id: <20201218223852.2717102-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM8P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::35) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM8P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 22:39:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 120ed5cb-b65e-43b3-aaf3-08d8a3a5c482
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268666D42AE1DAC0AD361B97E0C30@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgvYQY2AUuy+Ae5FuONHNFX2G4KsFwgm6n11APeZjHlTC1mKG8Q9Hmo1GYCagGW8zXhPmh9N/pW90jiS7x4nsZMa2frVSdbMphzpMca20fZYy1XW3GbnJJuS0ESRF5f3CcB/8tdjSFyc6x396ivqEDsILdX2TIKZQ4/fY+/fBZaIFQSt6EP5CN5jc9dsPnrmZYWS7PuJL3H6rZrIur/6fLepprcCLc19CxAOFBqrs9wP8zC3fyzkPgzCPk4rnlhwPdS+RPDv/fvTIbFW2Qf7H4ypIWRvnTSh64ZabasP42krrlFh1POV3QUzd5fKl2rdnqUoubUNox+W/r9hOWQquZxsxujZ3nY0LfYrVqunwLklRv6RHOtSl3ET6Q/Nvd8Ezr10DmdIYvtxl/N+ecgVwhteVTiWRUFjj/0c7GJ10AXk+iW6P6OSTJ7QXLCgYu7Kf1B7IES71KFNu+/0VZvohg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(52116002)(2616005)(66476007)(66556008)(956004)(83380400001)(478600001)(8936002)(69590400008)(86362001)(44832011)(66946007)(6512007)(36756003)(316002)(5660300002)(110136005)(16526019)(186003)(8676002)(26005)(6666004)(1076003)(6486002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EONjPiNI7FxsExCFHq+ZdnvdTP+RtNtmZdjQCsETlfjDmAKas31UO6vraYA0?=
 =?us-ascii?Q?3IZgn6TxN7XgOCNh97+vs5ktUHXrKOjSE9kU08eb8Ppvs8VPPBzG2HRHwgAr?=
 =?us-ascii?Q?exz6G9macGytpUTKW34qmlPbT+eOj+n/6zGKv4JvxcKuRjS56HMJ153IeaOe?=
 =?us-ascii?Q?e39HuCEoL9v9Z2kwbIZSQ2nJw7njPznNT+AksPNEHoFJ09bm8QH3dckR87pJ?=
 =?us-ascii?Q?qIpZ3DhhHKd83Yxa+AZIJ/SwUme6Uok8zF6DfRLMLP5INTbuNFf/kQsM0BFH?=
 =?us-ascii?Q?4Sv3Q0oQzVUNLFoDqFAT7jm7LhZdfi4MtJ/IHivw0NKLZ8KymbCfVwHQPpX1?=
 =?us-ascii?Q?P8i4c+aG2/7+2dzUrDH7xnHHYn4EmKHMxmpnsOVWXTRqBRnlp2PoRV43th21?=
 =?us-ascii?Q?N7S7+eRrTrC80MFLWKverPzHAQvnTNnnFQ3ae9MC+AfEGKleiADnf54jul2E?=
 =?us-ascii?Q?Qcl0S9uPI7es30ZWeQnO1EdBirIiz+nl7Lf23MLuveBGooNiLs8qMfqSmGgD?=
 =?us-ascii?Q?5TlfZpBEGH7vrBvH8KIl37dqz+/O0fEBM0sWpnqs/MKN4/Vz3o1QDKQyGqKb?=
 =?us-ascii?Q?oBJGEa/bjk2NRjJv/EWPCzKlPOl+UM9A/FOXmAanhqxzg3CbZx/U2mEm+eNG?=
 =?us-ascii?Q?yP4g58vlSUkYQ2fK7I4ye/o6I4TmVT+v4lrBELTODrXlNnWjS7VDDF3deB6z?=
 =?us-ascii?Q?P6dRyp+nNmjh+noeoksWpiwU9xoXhyBvbvvwMATn6sfw0Wus1Rg2jqlQWluz?=
 =?us-ascii?Q?Q6X06N7MxBcTsWsGi/EHXCttEl1tE5Vw8vgsSEHzkXQ3bYhf9jO31PeMni/l?=
 =?us-ascii?Q?fN/bXvMzRkCx/CFjrLDK7wS1wDOmoER9ZsE3TLUya6VnMJdyyYqy048eJ4UW?=
 =?us-ascii?Q?EH/JcsUIVQpo5CLRIF0gNSnCxpKT7PysiPC3c13LDuGCyZkD3COanG+NzvlX?=
 =?us-ascii?Q?wTgYg+xPGYTAqA6oBMQIrX3iFTApM0D8Ryh+5Wjv4zbztrHjwV3V0f9W08ue?=
 =?us-ascii?Q?P/Ql?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 22:39:23.4164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 120ed5cb-b65e-43b3-aaf3-08d8a3a5c482
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eWS/hwXXm7eV1StRyTVBUEYrFwpUveKP0XKl5N95VVT1Io6ByYS38wD+y1pZ2BwvafbgADa16erD1/SUr1aEJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a bit strange to see something as specific as Broadcom SYSTEMPORT
bits in the main DSA include file. Move these away into a separate
header, and have the tagger and the SYSTEMPORT driver include them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 MAINTAINERS                                |  1 +
 drivers/net/ethernet/broadcom/bcmsysport.c |  1 +
 include/linux/dsa/brcm.h                   | 16 ++++++++++++++++
 include/net/dsa.h                          |  6 ------
 net/dsa/tag_brcm.c                         |  1 +
 5 files changed, 19 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/dsa/brcm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index a355db292486..e2d1d852a3a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3389,6 +3389,7 @@ L:	openwrt-devel@lists.openwrt.org (subscribers-only)
 S:	Supported
 F:	Documentation/devicetree/bindings/net/dsa/b53.txt
 F:	drivers/net/dsa/b53/*
+F:	include/linux/dsa/brcm.h
 F:	include/linux/platform_data/b53.h
 
 BROADCOM BCM2711/BCM2835 ARM ARCHITECTURE
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0fdd19d99d99..82541352b1eb 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
diff --git a/include/linux/dsa/brcm.h b/include/linux/dsa/brcm.h
new file mode 100644
index 000000000000..47545a948784
--- /dev/null
+++ b/include/linux/dsa/brcm.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ * Copyright (C) 2014 Broadcom Corporation
+ */
+
+/* Included by drivers/net/ethernet/broadcom/bcmsysport.c and
+ * net/dsa/tag_brcm.c
+ */
+#ifndef _NET_DSA_BRCM_H
+#define _NET_DSA_BRCM_H
+
+/* Broadcom tag specific helpers to insert and extract queue/port number */
+#define BRCM_TAG_SET_PORT_QUEUE(p, q)	((p) << 8 | q)
+#define BRCM_TAG_GET_PORT(v)		((v) >> 8)
+#define BRCM_TAG_GET_QUEUE(v)		((v) & 0xff)
+
+#endif
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..af9a4f9ee764 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -873,12 +873,6 @@ static inline int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 }
 #endif
 
-/* Broadcom tag specific helpers to insert and extract queue/port number */
-#define BRCM_TAG_SET_PORT_QUEUE(p, q)	((p) << 8 | q)
-#define BRCM_TAG_GET_PORT(v)		((v) >> 8)
-#define BRCM_TAG_GET_QUEUE(v)		((v) & 0xff)
-
-
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
 int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
 int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index e934dace3922..e2577a7dcbca 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2014 Broadcom Corporation
  */
 
+#include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-- 
2.25.1

