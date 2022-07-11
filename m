Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52145707EC
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiGKQGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiGKQFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:05:50 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2077.outbound.protection.outlook.com [40.107.22.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5BD66AF8;
        Mon, 11 Jul 2022 09:05:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNReJdH7g+h4ss/b7oGxw19w+sd1VRPMzURYgdgPckgn8uFHzkD8UL/F04zicrHOV0XC9eOljQo3CWu6pDlp3mEzHJhDrhd2HeYQ7Q4X5vHnhjvk1dlyRCnRS+Sw15f0a011JdcqA1vzEF8WWHpawsA4DVLFbaNVAPM0eI15AeRLWcALF1IYigHy8cxbip9Wa92qZjjhhvR8JcqDORhuNMSypQNkZeLM0gxaodpow6922+3gz0OsDHmswZgWi3Kgx6XmOWm+s+PSStWqeFwZzERnHl6XPlvlhpVdpFhMvVoSIIpL1mGW9NUMt6tG5cPyv7E37rprl0wbtwPbUIguRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGcFzBn3+ID1/5PE8Q8y7BYLqPH86+MBINx0XPSEA6U=;
 b=McaKTiAXOI+yFwWLEGe0GSm+Y5Tv7rKuugMlGdyHLAojIyPq3hnuCKSv6i/6o1sGZXu+Ljjxjdp4ae2nuCFoa9KBOYpd47O3AgxJapWfY4CubAZRmzFnGEmyCLh4Sakpzt9pVOP6M0XcG5k1P/awsgFOfaMQq3UK/t3401BCN1TrDQNSIFtUsWeDRTl7TF5oe27jmtohnpysEkPkAwM+XPXIwdFkc+AtUhbiGWhnGNfSmOwhLmyrJoGbTK5UMazE47oW1sY/pADxDANQKBUgH2n85b5oBsgn8MTwXGsLwLOMEIPMgznypzZW8hImRCakm5mWtt41AN9D49xR/4qhbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGcFzBn3+ID1/5PE8Q8y7BYLqPH86+MBINx0XPSEA6U=;
 b=OwNBhKZInoKsxZ7XD5LTZ4K39NcjIz3EoGZrEIH6ZBohLcorCEQ4iYi90/kD7YUxleDboPyskXxQv8NcUMz7AzD25mmQtVodChWmF11A2qJPvKhE4oV1mUx6inJprv701D3Uy+z6DsOEduQ0X0QTI8drEw7k9mO+kVILIUWqSR71PrVtj+ejp2DXhBYZel0BmBtNTLB8JtJc9mnoCYbwxes6qWeeX6SDfOA9CJ2AvmR2CYuzn0PzbccIewGqFqOhpRj1Us6AJJP7HdNtyAiss9GFM7/YntOpZoKaqL8vlthSbB3fsuxsKNZddCskNmWvRVt7y06oppoaG8Z/Wddi0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:45 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:45 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
Subject: [RFC PATCH net-next 3/9] net: pcs: Add helpers for registering and finding PCSs
Date:   Mon, 11 Jul 2022 12:05:13 -0400
Message-Id: <20220711160519.741990-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92213d74-bd56-418a-c3fa-08da63573638
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gu4olcUnNys6qgC6HsEIyrGAObufz0ugqfWthnHppB/nqqKy4Ch/qh8zixGO2AYxs0xxOD2B0RBHWyMceera1CWtfagMqthBoUU4iW84CxWOYNfX8FIBgTcr9YvzompRW/UpXI4l8ImJcnUjtUWs6GVzA+1kkGTTjj9unc4kTmeIJWkkrTs+Cy/k45E54AtsMAf+zEJdBHwtzCRn4Gh0FiIXBhtU9Ssol+12YVn3Ug7dI1gPn5TXW0x8xXQmw1zJvbHhZ4Xcq5owxEPfngAatpf1qj4zUqvdTxxB60D12Z6+U3kM0spvUuKvqFs4CkY4JZuhqWQb30lsU4DKxeLACrlrnBIjedO0FYx8gFTGQU2cft1q50ym46qNX5N6adxAxbtgcerX11MY9g2C/YkUldwxJZZ8pssWyjuabZLhnGc/Z9/jRf25XHSzuRI+VBlxq/LLgJe9VrjHUaN/W6os6Y0fsYpYtBr/I6V/cNgBZl7r75HCJDCGdFFvxr8JZcTk1upXZyvpoH/gShHoEBRObAS0N/5XgDhdLc1mwISmq4Mc2tFbQ8BuokaQz8TQb9oj8rqMqxpvbz/12A/KJX+ihBQB6747k7x8aLNylCFZBI6bNQW9NvgZnFTRdROWZVgJ0GUz6gkU1rvvIqiH0oqz8xDBz1UklKXR4QzyKbasmfvAXDigaVTL7CNFke0b0qbEOfKVpgmSrRTEF7SI3ZoVLQArFQXw7U28ohP7TMcomYmXpctxH5SNa+0WzUQogwsfo2RHT50uTLE6MxKVIY9i3S1B0xkScLNRtcRAAWB6noC2KcPb9Wru3/QTywE8jvEweEilHMQjh2/Do0AvDiMhJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(30864003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(966005)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KDFBSOFPL5K1Gc0r50A2vzVSTVsqFC8yd1QDPv6b8PptmEHvLVBcnPyRP+gn?=
 =?us-ascii?Q?Gj0PDzmJ5l+H2k5gBcuzqukUDJRe2CQkZmEITqz/YDfWRX2Btcuxq7O7J7gT?=
 =?us-ascii?Q?jIF6bQbJbLR1OwQZl/rjeSZgB5rS6B+Ac8oUio7+UAY4abMc3UYIWt9yHvPk?=
 =?us-ascii?Q?aI0ePmyHmRLzmdtgiTW01S2ehR5hjnvwQmTjmElJ89+mcCG9tSTWwrwHh8yR?=
 =?us-ascii?Q?dcUKkKe9+oBIOrJ1O/TycjgMMEj84mg9hXrPPcNKN/IvXlUmmMzidfrciT6/?=
 =?us-ascii?Q?mPfYme8jhrDK4GttdvdBDZxc5RDkXm4EeWn1+6xi7CUqAT1ROnb52YtQqMVa?=
 =?us-ascii?Q?ICmwVP5TzYCvzp9UfbL7K9Iu6Q2eswbN2Gm/0ZeANjSmvZ8DnWnMVsELUUzH?=
 =?us-ascii?Q?bDp8UnoeoB5SX27p+cDGztW12BbWXqcOKB049UeOQRDd8q133J+5J8L3QBUC?=
 =?us-ascii?Q?j20sLm8vxMiaFGbw/AIfEwlnc7zCcZ6UX+aIHqhi6EQE+BrIgI9Rpi3p0rSl?=
 =?us-ascii?Q?NPBEMmkt0pn9iXIZNOYo87bJpuWyaiMDN3+rXeaBlA6mT1uuB6ynm0ISqhmH?=
 =?us-ascii?Q?DZcO4ee5h6zD42Z1GH1El5eGRABe3bHOHnlTwEnckV1MRLNnkOjFTS7/zOzG?=
 =?us-ascii?Q?NTFr5sG8e4/BDzgVku/2CehVEOLCDMo0PI6YcMNEIukoDd9BnW/v1zfHTd4O?=
 =?us-ascii?Q?bjRMLV+xs5a9wcAviEBClOJ+DRRR4KGUmiEwn/UU4wvUOGDeqcJ/me3lvLDA?=
 =?us-ascii?Q?7NpNWme0BLQbHWj9zqY294933ZqdDywtoB4fyg+ns6ZUUT13zEtlle9hus6+?=
 =?us-ascii?Q?+mYcYVXg1twpuuFqpoItS5fR9o/StVz5M3ZyaeiNvo88KnYr21Zu/iwi6FcD?=
 =?us-ascii?Q?XNZHbT8oh7CRzJq3pyoIkN65IFdrm51qv1gKWFmHIu6GECcRKe10PJzgk6AG?=
 =?us-ascii?Q?Hp0QQfBC2BI0phjZDe+OKLDx1E1wQEdsl/NqiK182DgJZyrGhCmW/YJ+NHbw?=
 =?us-ascii?Q?G9VN/+aa9H9w7XKFCimOV4ZQrsN/dYJYt6gLXqAgNHB7htEq8DPqzti/yEtW?=
 =?us-ascii?Q?JHtr0CcWciVcIOwlIwGbASwdQ+nKRVhNuDZpvmgjsZ3/p/dMN9Hu5itMzfAT?=
 =?us-ascii?Q?m6ZPNxayi+s9M1VJYJf5HydnSYdcZqBUMcGGZMIAeHLABXF7IBNc8JtPTnwI?=
 =?us-ascii?Q?3OpDDU0wi0O5UXUoahmWxfIgIP6kAp2QH6c6YfPVxvGU4e8qpHYYxOV3jjzj?=
 =?us-ascii?Q?gRYamkQl4J9heNX/DIjHtQJ4KltgP2rnuSfAsyd5rw4p17qDaMc4NfIRSC4Z?=
 =?us-ascii?Q?lJ4zLItc7vfzceL4ILyYWZGcgokAnvyjCk85XyqJdvk0GQHAN5lho3tQCmOI?=
 =?us-ascii?Q?lbXgR9PvO8gy/GQE3h4ELKu5sbeAOxzcOTLuMlUxQof8qPbyfIvLNXJMRhwZ?=
 =?us-ascii?Q?7fs7O5+X7xVgRPd5hlBCE9ivLIEX+tHwronY60ob76b1uj9ytZm8NqCxe4sP?=
 =?us-ascii?Q?36b/5xk0Py/HJttKj7RAH3qCwMrrT5dsHLA/ycONjyrlZyUINWzfpScZjbo2?=
 =?us-ascii?Q?LfKa3jn4mbxRM6t//hZlfENEuobnI321QmbmNF7s7x6PGedjF2ABTWg0KoWQ?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92213d74-bd56-418a-c3fa-08da63573638
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:45.6059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJVq4GnuehlWEYIOssmyGJEBGHfJ91mMI/40CRDy7sWUURfWx5Zeb4HPj1POENno+ewy6VmDq27rNXYDEJvH3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for getting PCS devices from the device tree. PCS
drivers must first register with phylink_register_pcs. After that, MAC
drivers may look up their PCS using phylink_get_pcs.

To prevent the PCS driver from leaving suddenly, we use try_module_get. To
provide some ordering during probing/removal, we use device links managed
by of_fwnode_add_links. This will reduce the number of probe failures due
to deferral. It will not prevent this for non-standard properties (aka
pcsphy-handle), but the worst that happens is that we re-probe a few times.

At the moment there is no support for specifying the interface used to
talk to the PCS. The MAC driver is expected to know how to talk to the
PCS. This is not a change, but it is perhaps an area for improvement.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This is adapted from [1], primarily incorporating the changes discussed
there.

[1] https://lore.kernel.org/netdev/9f73bc4f-5f99-95f5-78fa-dac96f9e0146@seco.com/

 MAINTAINERS              |   1 +
 drivers/net/pcs/Kconfig  |  12 +++
 drivers/net/pcs/Makefile |   2 +
 drivers/net/pcs/core.c   | 226 +++++++++++++++++++++++++++++++++++++++
 drivers/of/property.c    |   2 +
 include/linux/pcs.h      |  33 ++++++
 include/linux/phylink.h  |   6 ++
 7 files changed, 282 insertions(+)
 create mode 100644 drivers/net/pcs/core.c
 create mode 100644 include/linux/pcs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ca95b1833b97..3965d49753d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7450,6 +7450,7 @@ F:	include/linux/*mdio*.h
 F:	include/linux/mdio/*.h
 F:	include/linux/mii.h
 F:	include/linux/of_net.h
+F:	include/linux/pcs.h
 F:	include/linux/phy.h
 F:	include/linux/phy_fixed.h
 F:	include/linux/platform_data/mdio-bcm-unimac.h
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index 22ba7b0b476d..fed6264fdf33 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -5,6 +5,18 @@
 
 menu "PCS device drivers"
 
+config PCS
+	bool "PCS subsystem"
+	help
+	  This provides common helper functions for registering and looking up
+	  Physical Coding Sublayer (PCS) devices. PCS devices translate between
+	  different interface types. In some use cases, they may either
+	  translate between different types of Medium-Independent Interfaces
+	  (MIIs), such as translating GMII to SGMII. This allows using a fast
+	  serial interface to talk to the phy which translates the MII to the
+	  Medium-Dependent Interface. Alternatively, they may translate a MII
+	  directly to an MDI, such as translating GMII to 1000Base-X.
+
 config PCS_XPCS
 	tristate "Synopsys DesignWare XPCS controller"
 	depends on MDIO_DEVICE && MDIO_BUS
diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
index 0603d469bd57..1fd21a1619d4 100644
--- a/drivers/net/pcs/Makefile
+++ b/drivers/net/pcs/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Linux PCS drivers
 
+obj-$(CONFIG_PCS)		+= core.o
+
 pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
 
 obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
diff --git a/drivers/net/pcs/core.c b/drivers/net/pcs/core.c
new file mode 100644
index 000000000000..b39ff1ccdb34
--- /dev/null
+++ b/drivers/net/pcs/core.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ */
+
+#include <linux/fwnode.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/pcs.h>
+#include <linux/phylink.h>
+#include <linux/property.h>
+
+static LIST_HEAD(pcs_devices);
+static DEFINE_MUTEX(pcs_mutex);
+
+/**
+ * pcs_register() - register a new PCS
+ * @pcs: the PCS to register
+ *
+ * Registers a new PCS which can be automatically attached to a phylink.
+ *
+ * Return: 0 on success, or -errno on error
+ */
+int pcs_register(struct phylink_pcs *pcs)
+{
+	if (!pcs->dev || !pcs->ops)
+		return -EINVAL;
+	if (!pcs->ops->pcs_an_restart || !pcs->ops->pcs_config ||
+	    !pcs->ops->pcs_get_state)
+		return -EINVAL;
+
+	INIT_LIST_HEAD(&pcs->list);
+	mutex_lock(&pcs_mutex);
+	list_add(&pcs->list, &pcs_devices);
+	mutex_unlock(&pcs_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcs_register);
+
+/**
+ * pcs_unregister() - unregister a PCS
+ * @pcs: a PCS previously registered with pcs_register()
+ */
+void pcs_unregister(struct phylink_pcs *pcs)
+{
+	mutex_lock(&pcs_mutex);
+	list_del(&pcs->list);
+	mutex_unlock(&pcs_mutex);
+}
+EXPORT_SYMBOL_GPL(pcs_unregister);
+
+static void devm_pcs_release(struct device *dev, void *res)
+{
+	pcs_unregister(*(struct phylink_pcs **)res);
+}
+
+/**
+ * devm_pcs_register - resource managed pcs_register()
+ * @dev: device that is registering this PCS
+ * @pcs: the PCS to register
+ *
+ * Managed pcs_register(). For PCSs registered by this function,
+ * pcs_unregister() is automatically called on driver detach. See
+ * pcs_register() for more information.
+ *
+ * Return: 0 on success, or -errno on failure
+ */
+int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs)
+{
+	struct phylink_pcs **pcsp;
+	int ret;
+
+	pcsp = devres_alloc(devm_pcs_release, sizeof(*pcsp),
+			    GFP_KERNEL);
+	if (!pcsp)
+		return -ENOMEM;
+
+	ret = pcs_register(pcs);
+	if (ret) {
+		devres_free(pcsp);
+		return ret;
+	}
+
+	*pcsp = pcs;
+	devres_add(dev, pcsp);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_pcs_register);
+
+/**
+ * pcs_find() - Find the PCS associated with a fwnode or device
+ * @fwnode: The PCS's fwnode
+ * @dev: The PCS's device
+ *
+ * Search PCSs registered with pcs_register() for one with a matching
+ * fwnode or device. Either @fwnode or @dev may be %NULL if matching against a
+ * fwnode or device is not desired (respectively).
+ *
+ * Return: a matching PCS, or %NULL if not found
+ */
+static struct phylink_pcs *pcs_find(const struct fwnode_handle *fwnode,
+				    const struct device *dev)
+{
+	struct phylink_pcs *pcs;
+
+	mutex_lock(&pcs_mutex);
+	list_for_each_entry(pcs, &pcs_devices, list) {
+		if (dev && pcs->dev == dev)
+			goto out;
+		if (fwnode && pcs->dev->fwnode == fwnode)
+			goto out;
+	}
+	pcs = NULL;
+
+out:
+	mutex_unlock(&pcs_mutex);
+	pr_devel("%s: looking for %pfwf or %s %s...%s found\n", __func__,
+		 fwnode, dev ? dev_driver_string(dev) : "(null)",
+		 dev ? dev_name(dev) : "(null)", pcs ? " not" : "");
+	return pcs;
+}
+
+/**
+ * pcs_get_tail() - Finish getting a PCS
+ * @pcs: The PCS to get, or %NULL if one could not be found
+ *
+ * This performs common operations necessary when getting a PCS (chiefly
+ * incrementing reference counts)
+ *
+ * Return: @pcs, or an error pointer on failure
+ */
+static struct phylink_pcs *pcs_get_tail(struct phylink_pcs *pcs)
+{
+	if (!pcs)
+		return ERR_PTR(-EPROBE_DEFER);
+
+	if (!try_module_get(pcs->ops->owner))
+		return ERR_PTR(-ENODEV);
+	get_device(pcs->dev);
+
+	return pcs;
+}
+
+/**
+ * _pcs_get_by_fwnode() - Get a PCS from a fwnode property
+ * @fwnode: The fwnode to get an associated PCS of
+ * @id: The name of the PCS to get. May be %NULL to get the first PCS.
+ * @optional: Whether the PCS is optional or not
+ *
+ * Look up a PCS associated with @fwnode and return a reference to it. Every
+ * call to pcs_get_by_fwnode() must be balanced with one to pcs_put().
+ *
+ * If @optional is true, and @id is non-%NULL, then if @id cannot be found in
+ * pcs-names, %NULL is returned (instead of an error). If @optional is true and
+ * @id is %NULL, then no error is returned if pcs-handle is absent.
+ *
+ * Return: a PCS if found, or an error pointer on failure
+ */
+struct phylink_pcs *_pcs_get_by_fwnode(const struct fwnode_handle *fwnode,
+				       const char *id, bool optional)
+{
+	int index;
+	struct phylink_pcs *pcs;
+	struct fwnode_handle *pcs_fwnode;
+
+	if (id)
+		index = fwnode_property_match_string(fwnode, "pcs-names", id);
+	else
+		index = 0;
+	if (index < 0) {
+		if (optional && (index == -EINVAL || index == -ENODATA))
+			return NULL;
+		return ERR_PTR(index);
+	}
+
+	/* First try pcs-handle, and if that doesn't work fall back to the
+	 * (legacy) pcsphy-handle.
+	 */
+	pcs_fwnode = fwnode_find_reference(fwnode, "pcs-handle", index);
+	if (PTR_ERR(pcs_fwnode) == -ENOENT)
+		pcs_fwnode = fwnode_find_reference(fwnode, "pcsphy-handle",
+						   index);
+	if (optional && !id && PTR_ERR(pcs_fwnode) == -ENOENT)
+		return NULL;
+	else if (IS_ERR(pcs_fwnode))
+		return ERR_CAST(pcs_fwnode);
+
+	pcs = pcs_find(pcs_fwnode, NULL);
+	fwnode_handle_put(pcs_fwnode);
+	return pcs_get_tail(pcs);
+}
+EXPORT_SYMBOL_GPL(pcs_get_by_fwnode);
+
+/**
+ * pcs_get_by_provider() - Get a PCS from an existing provider
+ * @dev: The device providing the PCS
+ *
+ * This finds the first PCS registersed by @dev and returns a reference to it.
+ * Every call to pcs_get_by_provider() must be balanced with one to
+ * pcs_put().
+ *
+ * Return: a PCS if found, or an error pointer on failure
+ */
+struct phylink_pcs *pcs_get_by_provider(const struct device *dev)
+{
+	return pcs_get_tail(pcs_find(NULL, dev));
+}
+EXPORT_SYMBOL_GPL(pcs_get_by_provider);
+
+/**
+ * pcs_put() - Release a previously-acquired PCS
+ * @pcs: The PCS to put
+ *
+ * This frees resources associated with the PCS which were acquired when it was
+ * gotten.
+ */
+void pcs_put(struct phylink_pcs *pcs)
+{
+	if (!pcs)
+		return;
+
+	put_device(pcs->dev);
+	module_put(pcs->ops->owner);
+}
+EXPORT_SYMBOL_GPL(pcs_put);
diff --git a/drivers/of/property.c b/drivers/of/property.c
index 967f79b59016..860d35bde5e9 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1318,6 +1318,7 @@ DEFINE_SIMPLE_PROP(pinctrl6, "pinctrl-6", NULL)
 DEFINE_SIMPLE_PROP(pinctrl7, "pinctrl-7", NULL)
 DEFINE_SIMPLE_PROP(pinctrl8, "pinctrl-8", NULL)
 DEFINE_SIMPLE_PROP(remote_endpoint, "remote-endpoint", NULL)
+DEFINE_SIMPLE_PROP(pcs_handle, "pcs-handle", NULL)
 DEFINE_SIMPLE_PROP(pwms, "pwms", "#pwm-cells")
 DEFINE_SIMPLE_PROP(resets, "resets", "#reset-cells")
 DEFINE_SIMPLE_PROP(leds, "leds", NULL)
@@ -1406,6 +1407,7 @@ static const struct supplier_bindings of_supplier_bindings[] = {
 	{ .parse_prop = parse_pinctrl7, },
 	{ .parse_prop = parse_pinctrl8, },
 	{ .parse_prop = parse_remote_endpoint, .node_not_dev = true, },
+	{ .parse_prop = parse_pcs_handle, },
 	{ .parse_prop = parse_pwms, },
 	{ .parse_prop = parse_resets, },
 	{ .parse_prop = parse_leds, },
diff --git a/include/linux/pcs.h b/include/linux/pcs.h
new file mode 100644
index 000000000000..00e76594e03c
--- /dev/null
+++ b/include/linux/pcs.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Sean Anderson <sean.anderson@seco.com>
+ */
+
+#ifndef _PCS_H
+#define _PCS_H
+
+struct phylink_pcs;
+struct fwnode;
+
+int pcs_register(struct phylink_pcs *pcs);
+void pcs_unregister(struct phylink_pcs *pcs);
+int devm_pcs_register(struct device *dev, struct phylink_pcs *pcs);
+struct phylink_pcs *_pcs_get_by_fwnode(const struct fwnode_handle *fwnode,
+				       const char *id, bool optional);
+struct phylink_pcs *pcs_get_by_provider(const struct device *dev);
+void pcs_put(struct phylink_pcs *pcs);
+
+static inline struct phylink_pcs
+*pcs_get_by_fwnode(const struct fwnode_handle *fwnode,
+		   const char *id)
+{
+	return _pcs_get_by_fwnode(fwnode, id, false);
+}
+
+static inline struct phylink_pcs
+*pcs_get_by_fwnode_optional(const struct fwnode_handle *fwnode, const char *id)
+{
+	return _pcs_get_by_fwnode(fwnode, id, true);
+}
+
+#endif /* PCS_H */
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..a713e70108a1 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -396,19 +396,24 @@ struct phylink_pcs_ops;
 
 /**
  * struct phylink_pcs - PHYLINK PCS instance
+ * @dev: the device associated with this PCS
  * @ops: a pointer to the &struct phylink_pcs_ops structure
+ * @list: internal list of PCS devices
  * @poll: poll the PCS for link changes
  *
  * This structure is designed to be embedded within the PCS private data,
  * and will be passed between phylink and the PCS.
  */
 struct phylink_pcs {
+	struct device *dev;
 	const struct phylink_pcs_ops *ops;
+	struct list_head list;
 	bool poll;
 };
 
 /**
  * struct phylink_pcs_ops - MAC PCS operations structure.
+ * @owner: the module which implements this PCS.
  * @pcs_validate: validate the link configuration.
  * @pcs_get_state: read the current MAC PCS link state from the hardware.
  * @pcs_config: configure the MAC PCS for the selected mode and state.
@@ -417,6 +422,7 @@ struct phylink_pcs {
  *               (where necessary).
  */
 struct phylink_pcs_ops {
+	struct module *owner;
 	int (*pcs_validate)(struct phylink_pcs *pcs, unsigned long *supported,
 			    const struct phylink_link_state *state);
 	void (*pcs_get_state)(struct phylink_pcs *pcs,
-- 
2.35.1.1320.gc452695387.dirty

