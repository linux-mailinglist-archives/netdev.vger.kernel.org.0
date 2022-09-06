Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF975AF0CF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 18:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiIFQl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 12:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbiIFQk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 12:40:56 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CABB1180E;
        Tue,  6 Sep 2022 09:19:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YERYhQjdHh83GfqZBlS7JpGpcsWkO2vGXYO3PN4h+LR2WGISuLQuHXq+Pn+ny0Mlpkhj+0iZ9TxbkmFMVnb6GN6UUdLYPnwNzSFf2AIi00nU8WN9YnhLkILdIP2vAkNq/m5CsXkMGVdj4UYdHibHnVYrvezKA9QGCmJDvl3oKR8NwPSNZojia3X63xW6D+LdlxNZu/1jx9mFQi/kl+qPW9Mr9QR6sR5Ga8RbbM9VnU1j+cdYWuDflYHI2C0a1LEXCQHHRZP/RtOF7QCVVlz/0SoTN29PkWpxA5TGGmF/dHXxElUmxync63TwJa4XGCouauKDOhXkaoZG5XeZQZ/7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9ab12zLu+CoupxeVw1PyM77upmEUbTnNz6ECUzXr98=;
 b=c4MINsEtHrF+/CDRz5FkFAe92CrQxXK+lK4l/PIjgLx+1J/eEzpvatOKtz2q0cPcJD9+vKkQwlArmAPy8TrmY60uml8yr8KNGlXGzFN3plHBJNjcjo8RzH3TBbK25yzGYuz0IMYgZ2iaegDGowJP3qhVBCazOjYp4qAwsMp3z4On8jIghmVmLNG9+z1NH/5DG+nm7o6KaDzy407ZoYrQNXcW2WyM+bAw+agA4LSFlO7p9E0gpEuzHMR6nJGJ0etQD8h52MexVU0TnvJwALWfhyjLIwBYa2paN/JcJCtJlqJLBgn6WQp3H5ESVjKY9BsWIMVsJaxclGijbShich4FBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9ab12zLu+CoupxeVw1PyM77upmEUbTnNz6ECUzXr98=;
 b=pUfuTXrw0I+gfVq9KgnleHI3RMjLp40T6/dMhQeLXkYW9ldJ3ujqQ0wWCSt43UBmBvJYzZvjitVf3HLySvmkb8NLMcV57MuQLnayFR+6a42RVONZ5ZeAWRtlMRHfLsE0/lyKAbcjpvMFQWpU8emg+eKlHdyfISnlAlqtmdIF+i1wMo27LmNbozyJg5gWzEpeXCdez9m+WEJOmIKBsgv73zgZ9tdp4Eq8sfceV4kV0qoKI0WyNZTKTVeNemOgu1J1RBVtLEDUqdGg0wmNyhsr9RM/v0lj3Sh/BU57xL2K0pjFYoqWR8l8CMcV7yumbNqDIwAjdhnZVnTSDJmGIDefWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by VI1PR0301MB2254.eurprd03.prod.outlook.com (2603:10a6:800:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 16:19:12 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 16:19:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next v5 4/8] net: phy: Add support for rate adaptation
Date:   Tue,  6 Sep 2022 12:18:48 -0400
Message-Id: <20220906161852.1538270-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220906161852.1538270-1-sean.anderson@seco.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cd29cf2-7f25-452a-0044-08da90238771
X-MS-TrafficTypeDiagnostic: VI1PR0301MB2254:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zjxYidZU3zZDy/uOjEsgFDG+8Wny/vSyvjuGRRap6yo4ONieU9lXd1PJnYW7DF1kPnW8Ej5U13vgtKk5c46PAYak3a6IiUk7YqPbdp4i/6kw6GsSF580BvDJGnvWAGA/jqp5izuOc4lkY/siAc5w3nZJ4ukpOeGpdt0A3rsUnyPjfNj841DdUl99WJZCzu3ZvlNBHUzR+ATToY7FL/BIvA6pTQDML2E3UKu+cLs8UTtvXSZFkBX5F+I7lPz1GG7/vpiuk17cJDzSkGa4121dwAKj0pv2raZtMWUSyBxlUGx6qaPnhr+EurJxWbmTHX7evbFpb5dgomG3kqB9EDOcn7ikDgCMp2DR5geXWwUBTacQAM6UBtv8V04CipJcqkvKOLI4EiUSm3Dc6OTG7A51xd2hZ0WiXYzu1QkFQoRwQRpaTrTaOsKO8EjkwKVxjY8RzPF/uPNpuksy+A6gh+xvOotS3NH/c7mRb/q45LdQBauryQpUi530Es7oT4FLhMaFPddR+TSZCSdQKh5FBUQDZJlykfTNcSeRpM+SjVwNQfUpnJc5qIVgNq50DDCQSRynus4Y6mfyPYlVmy0C6aUdkGpVOdhsPVCSLklklqdwCCS8eV0G5hd90BEhaJDRqLBgmpjBDzRNek5sbK2CPD/u44Mj5MrT/mnnPu5oANBzH0AAZOjHSC0BhdPF465G6UGaaGAiXmHHO+QkLgEQ8wFCwc5EGC6U9UY3aK+Z3h+uNUW8pSLc3oEP7kGDLkFwQF5PYY0Z2rhvj6sj9SzwPlJYyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(366004)(396003)(136003)(39850400004)(38100700002)(54906003)(38350700002)(110136005)(83380400001)(316002)(4326008)(8676002)(66556008)(66476007)(66946007)(2906002)(44832011)(7416002)(8936002)(6506007)(30864003)(5660300002)(2616005)(1076003)(52116002)(186003)(478600001)(41300700001)(6666004)(86362001)(6512007)(26005)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DSXNQFRTzI1yEcguylYHnuWwLF/7U6cqUWunKUBoXvjbKl/ykzqnMFF8laVY?=
 =?us-ascii?Q?ohNoHubkiFFajvMP43bM6H+qWB5FmSBUvJcJLJT7++WEMIDM/kXNovmHyPIb?=
 =?us-ascii?Q?C0kQ0cBborG3zvt9p+/KduAupnoRKKpE5+POlSImMudxqCJGpQtie0Far2zd?=
 =?us-ascii?Q?bTrZzMKUI1kGh/W7/Zny2FOK3MkMw4imJvavVXZ+06sBd/2GlekQiRB8u9b+?=
 =?us-ascii?Q?ZlLbUdGHGFsKQPNBm4xrFnWF1KZUc5w5vBIDkrXYSSuRrwL0sao5N31gIxYi?=
 =?us-ascii?Q?9gdPJjL+EuYwmkm4TeHnb1pAbpKeEiAgntirGYIQ7OoylOJ1mTz4itcKBKoX?=
 =?us-ascii?Q?pxvBIz2VGvWk7z/S48/t3ijwy+Qj6aEsVEzFarAoKg2ckpwAsv7MXy/T5o1O?=
 =?us-ascii?Q?CXarz8Jij0QHEG7BNZ0RlShXnBIQw6Z0yLN7K6p/Cx1KHx0E4a9//tUQXJNK?=
 =?us-ascii?Q?I7z3IQn6G8yzqhBF/HB+O7iG4vWH+UnekNl+VGMD0FZsEkGV9mwtxIthzMUm?=
 =?us-ascii?Q?OafmxIHp+90x7BkgtGyGpsX2viMDzy8mYOWy3UBamUQpKe3SYJjVnj/DfvPK?=
 =?us-ascii?Q?SXSEdlGwffjp9rN9OVERomDkz9U3URtyHOJW82L/YbxnA6i6oOa7m4/ZHoAe?=
 =?us-ascii?Q?xmsw6un6x2/Tftq0xaIp/VsGHsWYODwkPTFVvQ/n4Z4pKvHDEvTtAlP1ROHB?=
 =?us-ascii?Q?KYkgw58TFx2viEO9axiz1GBNqY32RRhKfef9WI+w1CNosdaqh4eOkJ7K54QA?=
 =?us-ascii?Q?YlrnFgeFQsgDHzV+Xnv2LL0dC2HvcmoL1hHsDG6knw+aDkDcuGGmGrwJXfs1?=
 =?us-ascii?Q?/LF7504pdYK/qP4SUyccvQrct+UTyz2yVQ9uplRD3NaWGNNfWd7WEPXqPOIc?=
 =?us-ascii?Q?NyMazPMkTixFbIMeBJZjjHsM0X9Cq79oevukETx4T8pHWgFAoX6QePeh9Dck?=
 =?us-ascii?Q?+f/5JW73vkZUnQf1O3nyfD6J41T0XE80ePqkD4KANSeqaAEfHHJdNosxPsgp?=
 =?us-ascii?Q?CWmHGwblvbgqiSEKkb9ke3raUo4UtnZ06v/sbUIc5VqlNaBfXfV8gja5sz99?=
 =?us-ascii?Q?QwNNHV1jjKWeJaFdDGjWIKWfqA9FmRNF3YBv2/+MnfkJMzQy8a3sUXLiybgo?=
 =?us-ascii?Q?qUqMUINkQ1c4gttmQkzIQ1ocLLJ5XHty7ZPRvLLmw/5+PZxWiFgTLWjEe0Ov?=
 =?us-ascii?Q?nwmc8S/3ILJzFZrIjxYLi/1EUZhYJPX5abe9TNNnMPlp23jqDjSnUpcfqg25?=
 =?us-ascii?Q?w2UKgYMsLYwuSUi7BVySc6pne3wwrmeKBs2zbuEjn+YgT8aw6oavuudO4Tk0?=
 =?us-ascii?Q?Ejpt4dFMAm+CSl7Y4zbgwZFX1NiYuR9nr8CxN34RxJHwTkFlsZi6rWpbyJ/8?=
 =?us-ascii?Q?l/GXjNTg5PYNnParzc0t7ZrS03VJcLVsaOVDcaLE83yzhzVxQbOgmAo4aKan?=
 =?us-ascii?Q?ift4QMTlhpEU5J/yBrxWkBXZ4iiy77YRJkj1ZY0NHkUCsEjGezv8sK3ON+sT?=
 =?us-ascii?Q?8aL5mvzClPxQOn1CblaJDum18pvgARAVziciigUqjATHOdWuY61s79uQXaOT?=
 =?us-ascii?Q?Z6vTGPRRTPmDmOHZ2kmnKFtO90/iEZxSD0VuxR/8pFP7JwLlKahx7NdulA1w?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd29cf2-7f25-452a-0044-08da90238771
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 16:19:09.8493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xr3hpWBIXOTlrbzKPYdkeAuUFJfM/Nj9TfrymZN2jny/a26sWd1/kQWo2JgBoHQW45N9K/shjTV3ew+HwEHXPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0301MB2254
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for rate adaptation to the phy subsystem. The general
idea is that the phy interface runs at one speed, and the MAC throttles
the rate at which it sends packets to the link speed. There's a good
overview of several techniques for achieving this at [1]. This patch
adds support for three: pause-frame based (such as in Aquantia phys),
CRS-based (such as in 10PASS-TS and 2BASE-TL), and open-loop-based (such
as in 10GBASE-W).

This patch makes a few assumptions and a few non assumptions about the
types of rate adaptation available. First, it assumes that different phys
may use different forms of rate adaptation. Second, it assumes that phys
can use rate adaptation for any of their supported link speeds (e.g. if a
phy supports 10BASE-T and XGMII, then it can adapt XGMII to 10BASE-T).
Third, it does not assume that all interface modes will use the same form
of rate adaptation. Fourth, it does not assume that all phy devices will
support rate adaptation (even some do). Relaxing or strengthening these
(non-)assumptions could result in a different API. For example, if all
interface modes were assumed to use the same form of rate adaptation, then
a bitmask of interface modes supportting rate adaptation would suffice.

For some better visibility into the process, the current rate adaptation
mode is exposed as part of the ethtool ksettings. For the moment, only
read access is supported. I'm not sure what userspace might want to
configure yet (disable it altogether, disable just one mode, specify the
mode to use, etc.). For the moment, since only pause-based rate
adaptation support is added in the next few commits, rate adaptation can
be disabled altogether by adjusting the advertisement.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
Should the unimplemented adaptation modes be kept in?

Changes in v5:
- Document phy_rate_adaptation_to_str
- Remove unnecessary comma

Changes in v4:
- Export phy_rate_adaptation_to_str

Changes in v2:
- Use int/defines instead of enum to allow for use in ioctls/netlink
- Add locking to phy_get_rate_adaptation
- Add (read-only) ethtool support for rate adaptation
- Move part of commit message to cover letter, as it gives a good
  overview of the whole series, and allows this patch to focus more on
  the specifics.

 Documentation/networking/ethtool-netlink.rst |  2 ++
 drivers/net/phy/phy-core.c                   | 21 +++++++++++++++
 drivers/net/phy/phy.c                        | 28 ++++++++++++++++++++
 include/linux/phy.h                          | 22 ++++++++++++++-
 include/uapi/linux/ethtool.h                 | 18 +++++++++++--
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/ioctl.c                          |  1 +
 net/ethtool/linkmodes.c                      |  5 ++++
 8 files changed, 95 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index dbca3e9ec782..65ed29e78499 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -426,6 +426,7 @@ Kernel response contents:
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port state
+  ``ETHTOOL_A_LINKMODES_RATE_ADAPTATION``     u8      PHY rate adaptation
   ==========================================  ======  ==========================
 
 For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
@@ -449,6 +450,7 @@ Request contents:
   ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
+  ``ETHTOOL_A_LINKMODES_RATE_ADAPTATION``     u8      PHY rate adaptation
   ``ETHTOOL_A_LINKMODES_LANES``               u32     lanes
   ==========================================  ======  ==========================
 
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2a2924bc8f76..b1c9c40fe378 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -74,6 +74,27 @@ const char *phy_duplex_to_str(unsigned int duplex)
 }
 EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
+/**
+ * phy_rate_adaptation_to_str - Return a string describing the rate adaptation
+ *
+ * @rate_adaptation: Type of rate adaptation to describe
+ */
+const char *phy_rate_adaptation_to_str(int rate_adaptation)
+{
+	switch (rate_adaptation) {
+	case RATE_ADAPT_NONE:
+		return "none";
+	case RATE_ADAPT_PAUSE:
+		return "pause";
+	case RATE_ADAPT_CRS:
+		return "crs";
+	case RATE_ADAPT_OPEN_LOOP:
+		return "open-loop";
+	}
+	return "Unsupported (update phy-core.c)";
+}
+EXPORT_SYMBOL_GPL(phy_rate_adaptation_to_str);
+
 /**
  * phy_interface_num_ports - Return the number of links that can be carried by
  *			     a given MAC-PHY physical link. Returns 0 if this is
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8d3ee3a6495b..77cbf07852e6 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -114,6 +114,33 @@ void phy_print_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_print_status);
 
+/**
+ * phy_get_rate_adaptation - determine if rate adaptation is supported
+ * @phydev: The phy device to return rate adaptation for
+ * @iface: The interface mode to use
+ *
+ * This determines the type of rate adaptation (if any) that @phy supports
+ * using @iface. @iface may be %PHY_INTERFACE_MODE_NA to determine if any
+ * interface supports rate adaptation.
+ *
+ * Return: The type of rate adaptation @phy supports for @iface, or
+ *         %RATE_ADAPT_NONE.
+ */
+int phy_get_rate_adaptation(struct phy_device *phydev,
+			    phy_interface_t iface)
+{
+	int ret = RATE_ADAPT_NONE;
+
+	if (phydev->drv->get_rate_adaptation) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->get_rate_adaptation(phydev, iface);
+		mutex_unlock(&phydev->lock);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_get_rate_adaptation);
+
 /**
  * phy_config_interrupt - configure the PHY device for the requested interrupts
  * @phydev: the phy_device struct
@@ -256,6 +283,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	cmd->base.duplex = phydev->duplex;
 	cmd->base.master_slave_cfg = phydev->master_slave_get;
 	cmd->base.master_slave_state = phydev->master_slave_state;
+	cmd->base.rate_adaptation = phydev->rate_adaptation;
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
 	else
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 337230c135f7..3e784137b2f3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -280,7 +280,6 @@ static inline const char *phy_modes(phy_interface_t interface)
 	}
 }
 
-
 #define PHY_INIT_TIMEOUT	100000
 #define PHY_FORCE_TIMEOUT	10
 
@@ -574,6 +573,7 @@ struct macsec_ops;
  * @lp_advertising: Current link partner advertised linkmodes
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
  * @autoneg: Flag autoneg being used
+ * @rate_adaptation: Current rate adaptation mode
  * @link: Current link state
  * @autoneg_complete: Flag auto negotiation of the link has completed
  * @mdix: Current crossover
@@ -641,6 +641,8 @@ struct phy_device {
 	unsigned irq_suspended:1;
 	unsigned irq_rerun:1;
 
+	int rate_adaptation;
+
 	enum phy_state state;
 
 	u32 dev_flags;
@@ -805,6 +807,21 @@ struct phy_driver {
 	 */
 	int (*get_features)(struct phy_device *phydev);
 
+	/**
+	 * @get_rate_adaptation: Get the supported type of rate adaptation for a
+	 * particular phy interface. This is used by phy consumers to determine
+	 * whether to advertise lower-speed modes for that interface. It is
+	 * assumed that if a rate adaptation mode is supported on an interface,
+	 * then that interface's rate can be adapted to all slower link speeds
+	 * supported by the phy. If iface is %PHY_INTERFACE_MODE_NA, and the phy
+	 * supports any kind of rate adaptation for any interface, then it must
+	 * return that rate adaptation mode (preferring %RATE_ADAPT_PAUSE to
+	 * %RATE_ADAPT_CRS). If the interface is not supported, this should
+	 * return %RATE_ADAPT_NONE.
+	 */
+	int (*get_rate_adaptation)(struct phy_device *phydev,
+				   phy_interface_t iface);
+
 	/* PHY Power Management */
 	/** @suspend: Suspend the hardware, saving state if needed */
 	int (*suspend)(struct phy_device *phydev);
@@ -971,6 +988,7 @@ struct phy_fixup {
 
 const char *phy_speed_to_str(int speed);
 const char *phy_duplex_to_str(unsigned int duplex);
+const char *phy_rate_adaptation_to_str(int rate_adaptation);
 
 int phy_interface_num_ports(phy_interface_t interface);
 
@@ -1687,6 +1705,8 @@ int phy_disable_interrupts(struct phy_device *phydev);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
+int phy_get_rate_adaptation(struct phy_device *phydev,
+			    phy_interface_t iface);
 void phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
 void phy_advertise_supported(struct phy_device *phydev);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 2d5741fd44bb..49496acbeac9 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1840,6 +1840,20 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define MASTER_SLAVE_STATE_SLAVE		3
 #define MASTER_SLAVE_STATE_ERR			4
 
+/* These are used to throttle the rate of data on the phy interface when the
+ * native speed of the interface is higher than the link speed. These should
+ * not be used for phy interfaces which natively support multiple speeds (e.g.
+ * MII or SGMII).
+ */
+/* No rate adaptation performed. */
+#define RATE_ADAPT_NONE		0
+/* The phy sends pause frames to throttle the MAC. */
+#define RATE_ADAPT_PAUSE	1
+/* The phy asserts CRS to prevent the MAC from transmitting. */
+#define RATE_ADAPT_CRS		2
+/* The MAC is programmed with a sufficiently-large IPG. */
+#define RATE_ADAPT_OPEN_LOOP	3
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
@@ -2033,8 +2047,8 @@ enum ethtool_reset_flags {
  *	reported consistently by PHYLIB.  Read-only.
  * @master_slave_cfg: Master/slave port mode.
  * @master_slave_state: Master/slave port state.
+ * @rate_adaptation: Rate adaptation performed by the PHY
  * @reserved: Reserved for future use; see the note on reserved space.
- * @reserved1: Reserved for future use; see the note on reserved space.
  * @link_mode_masks: Variable length bitmaps.
  *
  * If autonegotiation is disabled, the speed and @duplex represent the
@@ -2085,7 +2099,7 @@ struct ethtool_link_settings {
 	__u8	transceiver;
 	__u8	master_slave_cfg;
 	__u8	master_slave_state;
-	__u8	reserved1[1];
+	__u8	rate_adaptation;
 	__u32	reserved[7];
 	__u32	link_mode_masks[];
 	/* layout of link_mode_masks fields:
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d2fb4f7be61b..3a5d81769ff4 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -242,6 +242,7 @@ enum {
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
 	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
+	ETHTOOL_A_LINKMODES_RATE_ADAPTATION,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9298eb3251cb..6166f3e6b8d5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -571,6 +571,7 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 		= __ETHTOOL_LINK_MODE_MASK_NU32;
 	link_ksettings.base.master_slave_cfg = MASTER_SLAVE_CFG_UNSUPPORTED;
 	link_ksettings.base.master_slave_state = MASTER_SLAVE_STATE_UNSUPPORTED;
+	link_ksettings.base.rate_adaptation = RATE_ADAPT_NONE;
 
 	return store_link_ksettings_for_user(useraddr, &link_ksettings);
 }
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 99b29b4fe947..7905bd985c7f 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -70,6 +70,7 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_LANES */
 		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
+		+ nla_total_size(sizeof(u8)) /* LINKMODES_RATE_ADAPTATION */
 		+ 0;
 	ret = ethnl_bitset_size(ksettings->link_modes.advertising,
 				ksettings->link_modes.supported,
@@ -143,6 +144,10 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 		       lsettings->master_slave_state))
 		return -EMSGSIZE;
 
+	if (nla_put_u8(skb, ETHTOOL_A_LINKMODES_RATE_ADAPTATION,
+		       lsettings->rate_adaptation))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
-- 
2.35.1.1320.gc452695387.dirty

