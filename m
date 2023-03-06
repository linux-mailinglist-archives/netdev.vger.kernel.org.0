Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F986ACF66
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCFUp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjCFUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:45:53 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01hn2202.outbound.protection.outlook.com [52.100.5.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B36C6B4;
        Mon,  6 Mar 2023 12:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ra7Is9pH6nXq9clXzSAMBBRadoBgz5BrkgIJ1rwBVo=;
 b=S/e5ClNDdb+o0ZLPRgdD+i9Keq7Wkyy+HotlTbi/PhgolAAYQ0eAUP8Qg1UvFFnVg4AI+eUIw9EpBS4DgS0iOdDhYiVN7vQFuKA/KTzw3mFa4c/S0k1D9FD5ESTdlVcnEUCu9jk0DHEjdQcEZPXmAfkQdJeWiOj5qpNXDZ1NgL0P2Bio4q/8aEeU1lS8MaA5+NsIo0zra3s6CDtsjbUr3bb7ZIdVjAQ+i/a61RUrbxrflyypUM4oW+q+Ejikh4UsO0MOaeM1nVhHHdKLZqAAUBjarSegmO3+/OaG9+HRFNnSYlvHAKhhXrOqdkd7ApAbQNWs+RUmPEv7GohkcQvJ3w==
Received: from FR3P281CA0090.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1f::6) by
 AS8PR03MB7303.eurprd03.prod.outlook.com (2603:10a6:20b:2ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Mon, 6 Mar
 2023 20:45:45 +0000
Received: from VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
 (2603:10a6:d10:1f:cafe::fe) by FR3P281CA0090.outlook.office365.com
 (2603:10a6:d10:1f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16 via Frontend
 Transport; Mon, 6 Mar 2023 20:45:45 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.80)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.80 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.80; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.80) by
 VI1EUR05FT062.mail.protection.outlook.com (10.233.243.189) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 20:45:45 +0000
Received: from outmta (unknown [192.168.82.140])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id AA5E02008026C;
        Mon,  6 Mar 2023 20:45:44 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (unknown [104.47.12.50])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id E572D20080074;
        Mon,  6 Mar 2023 20:44:37 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sl6fOZ1Iy2ATW7UJOGdb6xJj4J6Cq9qmpUVQZgYUJR8Yw1/1z0N4OX9wly+BjGECYRaL1IV8tym3HENaW9azgyMufhzhsF5RkXgvmBX3cgB5NhbEr9sQ9VQ9uXEYrOya0QdUcVuX4/Ps0ZwMxTLfFiFMlyOWSvq5dO6ddBFzZmjDyhqLv3ysF6EC1qDIq6uom+fHDd/JTlw6UbsdxsUY3O7rd+7xsLmDndOqEfL0Kb8vNnViu4093iOlorPQjYmje/0lpIIqMuWn66NNsXktV+El0oCO4u8vQCzeOjhoIN/o8ulgOGAdDYRhWW5IXmb5KlL2mXnaj79h9WCTPvm2kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ra7Is9pH6nXq9clXzSAMBBRadoBgz5BrkgIJ1rwBVo=;
 b=lMQ6iJ/GLKSmNktQl2wYsZCSdI83Dec8NUMDDl/gVbImGR1Bh3onjWTtA7B6ffeCLkGjNTUMbE14pDwW1ai/8ZtHiWZCoI8MDGyU4SnxZxeIrN1bUgNI5fx2LfRUeJsQ3ePgukLCKQDI5/XWY7wvwmATKRTuP1GTkMttSSjU9a5fJQSW5p2opFZuyfZvVZ7l/YMoS/gXcR7jSYxIKmiTNtg4PxkLEfPueiQod5aY3QAa4zkfYNLPSCzLVhShLvDMvBuRtK3D3/ipkmkPWkt7uOdsswBu4AI+fPJp3matv739uM/TF2VCiPHG3Coz+gQNxi8ojgF/UFsQRm7laAgwDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ra7Is9pH6nXq9clXzSAMBBRadoBgz5BrkgIJ1rwBVo=;
 b=S/e5ClNDdb+o0ZLPRgdD+i9Keq7Wkyy+HotlTbi/PhgolAAYQ0eAUP8Qg1UvFFnVg4AI+eUIw9EpBS4DgS0iOdDhYiVN7vQFuKA/KTzw3mFa4c/S0k1D9FD5ESTdlVcnEUCu9jk0DHEjdQcEZPXmAfkQdJeWiOj5qpNXDZ1NgL0P2Bio4q/8aEeU1lS8MaA5+NsIo0zra3s6CDtsjbUr3bb7ZIdVjAQ+i/a61RUrbxrflyypUM4oW+q+Ejikh4UsO0MOaeM1nVhHHdKLZqAAUBjarSegmO3+/OaG9+HRFNnSYlvHAKhhXrOqdkd7ApAbQNWs+RUmPEv7GohkcQvJ3w==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM7PR03MB6673.eurprd03.prod.outlook.com (2603:10a6:20b:1b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 20:45:28 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 20:45:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next] net: mdio: Add netlink interface
Date:   Mon,  6 Mar 2023 15:45:16 -0500
Message-Id: <20230306204517.1953122-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0023.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::33) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM7PR03MB6673:EE_|VI1EUR05FT062:EE_|AS8PR03MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: e4b89074-dd8b-4bc9-f635-08db1e83c24c
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: j2duYu2eUCE1Un9si+m6iHx/natFsLikhgG7pnqZKDReLYDvreUVpqLtWcy+qq8f4xM8osnLYS25TWeN90N3RAVDgMiuWcFlCA5gl5vDK6lJryKEgR5w5r6l3js7nrCrE9lEgYHYVLV/XX4PrLkjeg7/XCbxVJrMiU5dLbEdKtFjuJ0mAQd+5b+FdsJAjb/1k8BOrLsDBuUuMOuGE19RrJGVrPgddWZnPCNkc2jmMthQ95pA5/X7SS/XrDlPg5FCOCIqnm07f4IvvvwlTL2mO23ELURes1F9Rq4iYJlZRWsfEyH2lOt2M+IvMw6m94F9Xr2Qop3MuebrfPqRXnyJVhh7WslO+NCh12aeG993GeGLYVrzEYdVTvmOkaRE0HIHqGBkUFCTT4Bldzi003TUy8QkS8K4Jd2dmxO3oqfz5O1fIt/Ti+w3oBTLfca08N0sr/IuvblP3Wb6xMt3vgSpsZdB6bIgbd9KCm8ms5HdcYGBR6u4btoUwGa091mtV0HvfiYCAtRfeF1CNz5KWpHJMp6KfEr7zAVTyy4MW/ybpHZ5sz8DhyFULO4cZFp8+C0aKFERAiabZJ5E1RP1jD16M9GiQP12SbH5D62buk3QXvDBIRFt8JNyzmB2OVc05U5paa2chUheGI3/wpjKdFt/y659z9OyZ9O+6WAguAegvdrWEOfxRuxeEiJwlpw8S5Dg
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39850400004)(396003)(346002)(376002)(366004)(451199018)(107886003)(83380400001)(36756003)(478600001)(54906003)(316002)(38350700002)(38100700002)(966005)(5660300002)(6486002)(2616005)(6666004)(6512007)(6506007)(1076003)(186003)(52116002)(26005)(110136005)(41300700001)(30864003)(7416002)(66476007)(44832011)(66946007)(8936002)(2906002)(66556008)(86362001)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6673
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8080f7da-c999-444d-d493-08db1e83b7cc
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BvMqF5P+qf3hQ92zOMCnHyLKmSExAwYgo0pNxwQawfJfFI2bBlnyEl7RNfUzU6xbHsIlZsxPo9CcuMU+eiIpKsT1JAXOCozFUV7S9TQvg5+2JOFW0MZdy1dCxKd2HFJ40hBzff7Txufcghz3M1j76kkWbfFmX3O12LD34WPH/6H0pCO7yC2YxefXGFjRNkXSZz3Sw8rWqVK3/MvKuhHu5sCvwEfo6dQbdqBxdR3wGDR9dVJ21eM6JE0Af9pSsqKGpCgd8FBo4yd+Xti03k7rGPrguRxMgicgCEZ13j+xqZuCF2GUAVPKI/64hi6O/antPH+w/DUoOwwmfhf/Zg0PN7dfPJOHZnXkouKNhwvRO7iiRt3sQa/z7zYhV+S+pYkYXW+JoS2yshOcxMcTH+ANYyFW/M0QKMJ54yPsdwns8ODNDmzMCdct2/GuI4YGqQP6pLb7VmkfXS+dWOKL/lI49+BfpKhF7ouWi9f0R2mbUyMK6iZoGcGS8eN2jQbgqnvr/r2XMad5wGn3hBXYTYdKifwakwGg/u2fHaYUAIkmu5guo1cjr0K/eOfOBzh4M2Xh5/nYdc83GpEUw079oXF+/ZGkOtgyVsj+YYGSBWXDDwmmc904nKTbEuwUlTdqbd0zmuoEsdTp660dt7p4UQzRxGhFKM5xP3CI+/m91PyEqi4MajCxBdzXKqc5cUusJqzVsOR4OezFV3YRaArdT2av6Hwqvgu3Q676GAQTLl21Z5O6i3goAJd2CQJPnzjjBS1x
X-Forefront-Antispam-Report: CIP:20.160.56.80;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(136003)(396003)(39850400004)(376002)(346002)(5400799012)(451199018)(46966006)(36840700001)(40470700004)(36756003)(4326008)(70586007)(70206006)(41300700001)(8676002)(40480700001)(8936002)(44832011)(6506007)(5660300002)(7416002)(30864003)(2906002)(356005)(86362001)(36860700001)(7636003)(7596003)(82740400003)(34020700004)(107886003)(6666004)(1076003)(26005)(966005)(6486002)(54906003)(478600001)(110136005)(316002)(6512007)(82310400005)(83380400001)(47076005)(336012)(2616005)(40460700003)(186003)(12100799021);DIR:OUT;SFP:1501;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 20:45:45.1492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b89074-dd8b-4bc9-f635-08db1e83c24c
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.80];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7303
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a netlink interface to make reads/writes to mdio buses. This
makes it easier to debug devices. This is especially useful when there
is a PCS involved (and the ethtool reads are faked), when there is no
MAC associated with a PHY, or when the MDIO device is not a PHY.

The closest existing in-kernel interfaces are the SIOCG/SMIIREG ioctls, but
they have several drawbacks:

1. "Write register" is not always exactly that. The kernel will try to
   be extra helpful and do things behind the scenes if it detects a
   write to the reset bit of a PHY for example.

2. Only one op per syscall. This means that is impossible to implement
   many operations in a safe manner. Something as simple as a
   read/mask/write cycle can race against an in-kernel driver.

3. Addressing is awkward since you don't address the MDIO bus
   directly, rather "the MDIO bus to which this netdev's PHY is
   connected". This makes it hard to talk to devices on buses to which
   no PHYs are connected, the typical case being Ethernet switches.

To address these shortcomings, this adds a GENL interface with which a user
can interact with an MDIO bus directly.  The user sends a program that
mdio-netlink executes, possibly emitting data back to the user. I.e. it
implements a very simple VM. Read/mask/write operations could be
implemented by dedicated commands, but when you start looking at more
advanced things like reading out the VLAN database of a switch you need
state and branching.

To prevent userspace phy drivers, writes are disabled by default, and can
only be enabled by editing the source. This is the same strategy used by
regmap for debugfs writes. Unfortunately, this disallows several useful
features, including

- Register writes (obviously)
- C45-over-C22
- Atomic access to paged registers
- Better MDIO emulation for e.g. QEMU

However, the read-only interface remains broadly useful for debugging.
Users who want to use the above features can re-enable them by defining
MDIO_NETLINK_ALLOW_WRITE and recompiling their kernel.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This driver was written by Tobias Waldekranz. It is adapted from the
version he released with mdio-tools [1]. This was last discussed 2.5
years ago [2], and I have incorperated his cover letter into this commit
message. The discussion mainly centered around the write capability
allowing for userspace phy drivers. Although it comes with reduced
functionality, I hope this new approach satisfies Andrew. I have also
made several minor changes for style and to stay abrest of changing
APIs.

Tobias, I've taken the liberty of adding some copyright notices
attributing this to you.

[1] https://github.com/wkz/mdio-tools
[2] https://lore.kernel.org/netdev/C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280/

 drivers/net/mdio/Kconfig          |   8 +
 drivers/net/mdio/Makefile         |   1 +
 drivers/net/mdio/mdio-netlink.c   | 464 ++++++++++++++++++++++++++++++
 include/uapi/linux/mdio-netlink.h |  61 ++++
 4 files changed, 534 insertions(+)
 create mode 100644 drivers/net/mdio/mdio-netlink.c
 create mode 100644 include/uapi/linux/mdio-netlink.h

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 90309980686e..8a01978e5b51 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -43,6 +43,14 @@ config ACPI_MDIO
 
 if MDIO_BUS
 
+config MDIO_NETLINK
+	tristate "Netlink interface for MDIO buses"
+	help
+	  Enable a netlink interface to allow reading MDIO buses from
+	  userspace. A small virtual machine allows implementing complex
+	  operations, such as conditional reads or polling. All operations
+	  submitted in the same program are evaluated atomically.
+
 config MDIO_DEVRES
 	tristate
 
diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
index 7d4cb4c11e4e..5583d5b8d174 100644
--- a/drivers/net/mdio/Makefile
+++ b/drivers/net/mdio/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_ACPI_MDIO)		+= acpi_mdio.o
 obj-$(CONFIG_FWNODE_MDIO)	+= fwnode_mdio.o
 obj-$(CONFIG_OF_MDIO)		+= of_mdio.o
+obj-$(CONFIG_MDIO_NETLINK)	+= mdio-netlink.o
 
 obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
 obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
diff --git a/drivers/net/mdio/mdio-netlink.c b/drivers/net/mdio/mdio-netlink.c
new file mode 100644
index 000000000000..3e32d1a9bab3
--- /dev/null
+++ b/drivers/net/mdio/mdio-netlink.c
@@ -0,0 +1,464 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022-23 Sean Anderson <sean.anderson@seco.com>
+ * Copyright (C) 2020-22 Tobias Waldekranz <tobias@waldekranz.com>
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/phy.h>
+#include <net/genetlink.h>
+#include <net/netlink.h>
+#include <uapi/linux/mdio-netlink.h>
+
+struct mdio_nl_xfer {
+	struct genl_info *info;
+	struct sk_buff *msg;
+	void *hdr;
+	struct nlattr *data;
+
+	struct mii_bus *mdio;
+	int timeout_ms;
+
+	int prog_len;
+	struct mdio_nl_insn *prog;
+};
+
+static int mdio_nl_open(struct mdio_nl_xfer *xfer);
+static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr);
+
+static int mdio_nl_flush(struct mdio_nl_xfer *xfer)
+{
+	int err;
+
+	err = mdio_nl_close(xfer, false, 0);
+	if (err)
+		return err;
+
+	return mdio_nl_open(xfer);
+}
+
+static int mdio_nl_emit(struct mdio_nl_xfer *xfer, u32 datum)
+{
+	int err = 0;
+
+	if (!nla_put_nohdr(xfer->msg, sizeof(datum), &datum))
+		return 0;
+
+	err = mdio_nl_flush(xfer);
+	if (err)
+		return err;
+
+	return nla_put_nohdr(xfer->msg, sizeof(datum), &datum);
+}
+
+static inline u16 *__arg_r(u32 arg, u16 *regs)
+{
+	WARN_ON_ONCE(arg >> 16 != MDIO_NL_ARG_REG);
+
+	return &regs[arg & 0x7];
+}
+
+static inline u16 __arg_i(u32 arg)
+{
+	WARN_ON_ONCE(arg >> 16 != MDIO_NL_ARG_IMM);
+
+	return arg & 0xffff;
+}
+
+static inline u16 __arg_ri(u32 arg, u16 *regs)
+{
+	switch ((enum mdio_nl_argmode)(arg >> 16)) {
+	case MDIO_NL_ARG_IMM:
+		return arg & 0xffff;
+	case MDIO_NL_ARG_REG:
+		return regs[arg & 7];
+	default:
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+}
+
+/* To prevent out-of-tree drivers from being implemented through this
+ * interface, disallow writes by default. This does disallow read-only uses,
+ * such as c45-over-c22 or reading phys with pages. However, with a such a
+ * flexible interface, we must use a big hammer. People who want to use this
+ * will need to modify the source code directly.
+ */
+#undef MDIO_NETLINK_ALLOW_WRITE
+
+static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
+{
+	struct mdio_nl_insn *insn;
+	unsigned long timeout;
+	u16 regs[8] = { 0 };
+	int pc, ret = 0;
+	int phy_id, reg, prtad, devad, val;
+
+	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
+
+	mutex_lock(&xfer->mdio->mdio_lock);
+
+	for (insn = xfer->prog, pc = 0;
+	     pc < xfer->prog_len;
+	     insn = &xfer->prog[++pc]) {
+		if (time_after(jiffies, timeout)) {
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		switch ((enum mdio_nl_op)insn->op) {
+		case MDIO_NL_OP_READ:
+			phy_id = __arg_ri(insn->arg0, regs);
+			prtad = mdio_phy_id_prtad(phy_id);
+			devad = mdio_phy_id_devad(phy_id);
+			reg = __arg_ri(insn->arg1, regs);
+
+			if (mdio_phy_id_is_c45(phy_id))
+				ret = __mdiobus_c45_read(xfer->mdio, prtad,
+							 devad, reg);
+			else
+				ret = __mdiobus_read(xfer->mdio, phy_id, reg);
+
+			if (ret < 0)
+				goto exit;
+			*__arg_r(insn->arg2, regs) = ret;
+			ret = 0;
+			break;
+
+		case MDIO_NL_OP_WRITE:
+			phy_id = __arg_ri(insn->arg0, regs);
+			prtad = mdio_phy_id_prtad(phy_id);
+			devad = mdio_phy_id_devad(phy_id);
+			reg = __arg_ri(insn->arg1, regs);
+			val = __arg_ri(insn->arg2, regs);
+
+#ifdef MDIO_NETLINK_ALLOW_WRITE
+			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+			if (mdio_phy_id_is_c45(phy_id))
+				ret = __mdiobus_c45_write(xfer->mdio, prtad,
+							  devad, reg, val
+			else
+				ret = __mdiobus_write(xfer->mdio, dev, reg,
+						      val);
+#else
+			ret = -EPERM;
+#endif
+			if (ret < 0)
+				goto exit;
+			ret = 0;
+			break;
+
+		case MDIO_NL_OP_AND:
+			*__arg_r(insn->arg2, regs) =
+				__arg_ri(insn->arg0, regs) &
+				__arg_ri(insn->arg1, regs);
+			break;
+
+		case MDIO_NL_OP_OR:
+			*__arg_r(insn->arg2, regs) =
+				__arg_ri(insn->arg0, regs) |
+				__arg_ri(insn->arg1, regs);
+			break;
+
+		case MDIO_NL_OP_ADD:
+			*__arg_r(insn->arg2, regs) =
+				__arg_ri(insn->arg0, regs) +
+				__arg_ri(insn->arg1, regs);
+			break;
+
+		case MDIO_NL_OP_JEQ:
+			if (__arg_ri(insn->arg0, regs) ==
+			    __arg_ri(insn->arg1, regs))
+				pc += (s16)__arg_i(insn->arg2);
+			break;
+
+		case MDIO_NL_OP_JNE:
+			if (__arg_ri(insn->arg0, regs) !=
+			    __arg_ri(insn->arg1, regs))
+				pc += (s16)__arg_i(insn->arg2);
+			break;
+
+		case MDIO_NL_OP_EMIT:
+			ret = mdio_nl_emit(xfer, __arg_ri(insn->arg0, regs));
+			if (ret < 0)
+				goto exit;
+			ret = 0;
+			break;
+
+		case MDIO_NL_OP_UNSPEC:
+		default:
+			ret = -EINVAL;
+			goto exit;
+		}
+	}
+exit:
+	mutex_unlock(&xfer->mdio->mdio_lock);
+	return ret;
+}
+
+struct mdio_nl_op_proto {
+	u8 arg0;
+	u8 arg1;
+	u8 arg2;
+};
+
+static const struct mdio_nl_op_proto mdio_nl_op_protos[MDIO_NL_OP_MAX + 1] = {
+	[MDIO_NL_OP_READ] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg2 = BIT(MDIO_NL_ARG_REG),
+	},
+	[MDIO_NL_OP_WRITE] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg2 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+	},
+	[MDIO_NL_OP_AND] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg2 = BIT(MDIO_NL_ARG_REG),
+	},
+	[MDIO_NL_OP_OR] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg2 = BIT(MDIO_NL_ARG_REG),
+	},
+	[MDIO_NL_OP_ADD] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg2 = BIT(MDIO_NL_ARG_REG),
+	},
+	[MDIO_NL_OP_JEQ] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg2 = BIT(MDIO_NL_ARG_IMM),
+	},
+	[MDIO_NL_OP_JNE] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg2 = BIT(MDIO_NL_ARG_IMM),
+	},
+	[MDIO_NL_OP_EMIT] = {
+		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
+		.arg1 = BIT(MDIO_NL_ARG_NONE),
+		.arg2 = BIT(MDIO_NL_ARG_NONE),
+	},
+};
+
+static int mdio_nl_validate_insn(const struct nlattr *attr,
+				 struct netlink_ext_ack *extack,
+				 const struct mdio_nl_insn *insn)
+{
+	const struct mdio_nl_op_proto *proto;
+
+	if (insn->op > MDIO_NL_OP_MAX) {
+		NL_SET_ERR_MSG_ATTR(extack, attr, "Illegal instruction");
+		return -EINVAL;
+	}
+
+	proto = &mdio_nl_op_protos[insn->op];
+
+	if (!(BIT(insn->arg0 >> 16) & proto->arg0)) {
+		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 0 invalid");
+		return -EINVAL;
+	}
+
+	if (!(BIT(insn->arg1 >> 16) & proto->arg1)) {
+		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 1 invalid");
+		return -EINVAL;
+	}
+
+	if (!(BIT(insn->arg2 >> 16) & proto->arg2)) {
+		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 2 invalid");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mdio_nl_validate_prog(const struct nlattr *attr,
+				 struct netlink_ext_ack *extack)
+{
+	const struct mdio_nl_insn *prog = nla_data(attr);
+	int len = nla_len(attr);
+	int i, err = 0;
+
+	if (len % sizeof(*prog)) {
+		NL_SET_ERR_MSG_ATTR(extack, attr, "Unaligned instruction");
+		return -EINVAL;
+	}
+
+	len /= sizeof(*prog);
+	for (i = 0; i < len; i++) {
+		err = mdio_nl_validate_insn(attr, extack, &prog[i]);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
+static const struct nla_policy mdio_nl_policy[MDIO_NLA_MAX + 1] = {
+	[MDIO_NLA_UNSPEC]  = { .type = NLA_UNSPEC, },
+	[MDIO_NLA_BUS_ID]  = { .type = NLA_STRING, .len = MII_BUS_ID_SIZE },
+	[MDIO_NLA_TIMEOUT] = NLA_POLICY_MAX(NLA_U16, 10 * MSEC_PER_SEC),
+	[MDIO_NLA_PROG]    = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+						    mdio_nl_validate_prog,
+						    0x1000),
+	[MDIO_NLA_DATA]    = { .type = NLA_NESTED },
+	[MDIO_NLA_ERROR]   = { .type = NLA_S32, },
+};
+
+static struct genl_family mdio_nl_family;
+
+static int mdio_nl_open(struct mdio_nl_xfer *xfer)
+{
+	int err;
+
+	xfer->msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!xfer->msg) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	xfer->hdr = genlmsg_put(xfer->msg, xfer->info->snd_portid,
+				xfer->info->snd_seq, &mdio_nl_family,
+				NLM_F_ACK | NLM_F_MULTI, MDIO_GENL_XFER);
+	if (!xfer->hdr) {
+		err = -EMSGSIZE;
+		goto err_free;
+	}
+
+	xfer->data = nla_nest_start(xfer->msg, MDIO_NLA_DATA);
+	if (!xfer->data) {
+		err = -EMSGSIZE;
+		goto err_free;
+	}
+
+	return 0;
+
+err_free:
+	nlmsg_free(xfer->msg);
+err:
+	return err;
+}
+
+static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr)
+{
+	struct nlmsghdr *end;
+	int err;
+
+	nla_nest_end(xfer->msg, xfer->data);
+
+	if (xerr && nla_put_s32(xfer->msg, MDIO_NLA_ERROR, xerr)) {
+		err = mdio_nl_flush(xfer);
+		if (err)
+			goto err_free;
+
+		if (nla_put_s32(xfer->msg, MDIO_NLA_ERROR, xerr)) {
+			err = -EMSGSIZE;
+			goto err_free;
+		}
+	}
+
+	genlmsg_end(xfer->msg, xfer->hdr);
+
+	if (last) {
+		end = nlmsg_put(xfer->msg, xfer->info->snd_portid,
+				xfer->info->snd_seq, NLMSG_DONE, 0,
+				NLM_F_ACK | NLM_F_MULTI);
+		if (!end) {
+			err = mdio_nl_flush(xfer);
+			if (err)
+				goto err_free;
+
+			end = nlmsg_put(xfer->msg, xfer->info->snd_portid,
+					xfer->info->snd_seq, NLMSG_DONE, 0,
+					NLM_F_ACK | NLM_F_MULTI);
+			if (!end) {
+				err = -EMSGSIZE;
+				goto err_free;
+			}
+		}
+	}
+
+	return genlmsg_unicast(genl_info_net(xfer->info), xfer->msg,
+			       xfer->info->snd_portid);
+
+err_free:
+	nlmsg_free(xfer->msg);
+	return err;
+}
+
+static int mdio_nl_cmd_xfer(struct sk_buff *skb, struct genl_info *info)
+{
+	struct mdio_nl_xfer xfer;
+	int err;
+
+	if (!info->attrs[MDIO_NLA_BUS_ID] ||
+	    !info->attrs[MDIO_NLA_PROG]   ||
+	     info->attrs[MDIO_NLA_DATA]   ||
+	     info->attrs[MDIO_NLA_ERROR])
+		return -EINVAL;
+
+	xfer.mdio = mdio_find_bus(nla_data(info->attrs[MDIO_NLA_BUS_ID]));
+	if (!xfer.mdio)
+		return -ENODEV;
+
+	if (info->attrs[MDIO_NLA_TIMEOUT])
+		xfer.timeout_ms = nla_get_u32(info->attrs[MDIO_NLA_TIMEOUT]);
+	else
+		xfer.timeout_ms = 100;
+
+	xfer.info = info;
+	xfer.prog_len = nla_len(info->attrs[MDIO_NLA_PROG]) / sizeof(*xfer.prog);
+	xfer.prog = nla_data(info->attrs[MDIO_NLA_PROG]);
+
+	err = mdio_nl_open(&xfer);
+	if (err)
+		return err;
+
+	err = mdio_nl_eval(&xfer);
+
+	err = mdio_nl_close(&xfer, true, err);
+	return err;
+}
+
+static const struct genl_ops mdio_nl_ops[] = {
+	{
+		.cmd = MDIO_GENL_XFER,
+		.doit = mdio_nl_cmd_xfer,
+		.flags = GENL_ADMIN_PERM,
+	},
+};
+
+static struct genl_family mdio_nl_family = {
+	.name     = "mdio",
+	.version  = 1,
+	.maxattr  = MDIO_NLA_MAX,
+	.netnsok  = false,
+	.module   = THIS_MODULE,
+	.ops      = mdio_nl_ops,
+	.n_ops    = ARRAY_SIZE(mdio_nl_ops),
+	.policy   = mdio_nl_policy,
+};
+
+static int __init mdio_nl_init(void)
+{
+	return genl_register_family(&mdio_nl_family);
+}
+
+static void __exit mdio_nl_exit(void)
+{
+	genl_unregister_family(&mdio_nl_family);
+}
+
+MODULE_AUTHOR("Tobias Waldekranz <tobias@waldekranz.com>");
+MODULE_DESCRIPTION("MDIO Netlink Interface");
+MODULE_LICENSE("GPL");
+
+module_init(mdio_nl_init);
+module_exit(mdio_nl_exit);
diff --git a/include/uapi/linux/mdio-netlink.h b/include/uapi/linux/mdio-netlink.h
new file mode 100644
index 000000000000..bebd3b45c882
--- /dev/null
+++ b/include/uapi/linux/mdio-netlink.h
@@ -0,0 +1,61 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2020-22 Tobias Waldekranz <tobias@waldekranz.com>
+ */
+
+#ifndef _UAPI_LINUX_MDIO_NETLINK_H
+#define _UAPI_LINUX_MDIO_NETLINK_H
+
+#include <linux/types.h>
+
+enum {
+	MDIO_GENL_UNSPEC,
+	MDIO_GENL_XFER,
+
+	__MDIO_GENL_MAX,
+	MDIO_GENL_MAX = __MDIO_GENL_MAX - 1
+};
+
+enum {
+	MDIO_NLA_UNSPEC,
+	MDIO_NLA_BUS_ID,  /* string */
+	MDIO_NLA_TIMEOUT, /* u32 */
+	MDIO_NLA_PROG,    /* struct mdio_nl_insn[] */
+	MDIO_NLA_DATA,    /* nest */
+	MDIO_NLA_ERROR,   /* s32 */
+
+	__MDIO_NLA_MAX,
+	MDIO_NLA_MAX = __MDIO_NLA_MAX - 1
+};
+
+enum mdio_nl_op {
+	MDIO_NL_OP_UNSPEC,
+	MDIO_NL_OP_READ,	/* read  dev(RI), port(RI), dst(R) */
+	MDIO_NL_OP_WRITE,	/* write dev(RI), port(RI), src(RI) */
+	MDIO_NL_OP_AND,		/* and   a(RI),   b(RI),    dst(R) */
+	MDIO_NL_OP_OR,		/* or    a(RI),   b(RI),    dst(R) */
+	MDIO_NL_OP_ADD,		/* add   a(RI),   b(RI),    dst(R) */
+	MDIO_NL_OP_JEQ,		/* jeq   a(RI),   b(RI),    jmp(I) */
+	MDIO_NL_OP_JNE,		/* jeq   a(RI),   b(RI),    jmp(I) */
+	MDIO_NL_OP_EMIT,	/* emit  src(RI) */
+
+	__MDIO_NL_OP_MAX,
+	MDIO_NL_OP_MAX = __MDIO_NL_OP_MAX - 1
+};
+
+enum mdio_nl_argmode {
+	MDIO_NL_ARG_NONE,
+	MDIO_NL_ARG_REG,
+	MDIO_NL_ARG_IMM,
+	MDIO_NL_ARG_RESERVED
+};
+
+struct mdio_nl_insn {
+	__u64 op:8;
+	__u64 reserved:2;
+	__u64 arg0:18;
+	__u64 arg1:18;
+	__u64 arg2:18;
+};
+
+#endif /* _UAPI_LINUX_MDIO_NETLINK_H */
-- 
2.35.1.1320.gc452695387.dirty

