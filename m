Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61E957AAA3
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiGSXv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbiGSXvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:51:18 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2078.outbound.protection.outlook.com [40.107.20.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACC05B780;
        Tue, 19 Jul 2022 16:50:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKziDgFsx4mBZd0iDmx78qEPkdWUZzvVq/pZMMatHd8pF2QNB6D5a9RXhVBvT7BHf6X+fcXxzsdkwIzA8Q8L0ZcsWXf6lYSKFA7ShY3RDiG7AWX4rovzBNqoim5En2Orw8srRc+xAZ8oFYjzCEHzbuiNMmIB094majlOSbAq7D/gliyle9GO4pSabCgUh8S+okCZnbMxPOaMaBqtxhPwXB8+y0khB7doGUJAmg6URvY7cnJ412vQY5RZTmPM69ZRQKc8zNUh3pcIr4UQuQO6ot21xZi7Clts0Cx6nVMXcZ8vlttq3P/JgW1NrNbhYuUKShdyUkiXeIhELeOD6ZpURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqTPfITZdN4NPa8I4g1GQWuYXIWkClu8zOxxUyRBNNk=;
 b=A3eAmTUePh3ZWMP/4G1vNXDkgiveRXZhnIP0SpOZRla8eg8DrcydRzOrIlJhMQKaA4yKcBTJruIkv7BcqL18WoVKKpNeNj6AQarS1MBqomKUN31haLvDJv6OVwG1kx9876dcfajAze0cfJT39MebF9/SW7TyXJrDEcg9U4T8zBLl/hPxbTDGepeJEMGb1hZjSLYx7ay2Er0H978YgqY2yqg+E66oijvViqlN0UyEAmv/V5AKs6MP61LY8txeBgExvXVS0kCZkzYiY2LEo8Y/48T4d25g7fbbiQKJo+DB9xkGQOt5VH4LXETurpDwzt6uRfXaNrIBCuuSEzYMG9dsHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqTPfITZdN4NPa8I4g1GQWuYXIWkClu8zOxxUyRBNNk=;
 b=fJvIaWM8UchEBXtCjqHerMvVuaHuRDKS0XSpzSsjosIxxBgWzKiHuIZJ/Ww1j1Z7OZf/neV7al2lVvjnhnMwQYLycnN7PwJ1S5iU+ExmPimh0i0XpqVqLw0GMUpbkraSntcUV+kLe0nNU2fmo4VvYat2Zt3rB+ngZ/PATvEOalyA+8SXNXG+6DQ3pHhaMAlbxkSbIz250KhZ7FsUYCDdV9YU59ZfPuPCg5lwUHmppi8YOP9nAS0MXgYN1/PyP+V5KY4jTpee2s9lMlRgTosXTMHu34kwKRsv0DuPTCA72u9bhb24hQni8BT7V5f/M+ZQTC/dof5/D3pvtabbPagaSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4811.eurprd03.prod.outlook.com (2603:10a6:10:30::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:50:31 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 23:50:31 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH v2 05/11] net: phy: Add support for rate adaptation
Date:   Tue, 19 Jul 2022 19:49:55 -0400
Message-Id: <20220719235002.1944800-6-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220719235002.1944800-1-sean.anderson@seco.com>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0227.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cc5a6c9-5535-4542-8c88-08da69e176f9
X-MS-TrafficTypeDiagnostic: DB7PR03MB4811:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HHAT1xaeRZZkBU6kcT361SP9ZlhOBNJm5OHFf8Dg3lQOy7bFzRSkg6B8ee0p8e4qY3myxo+0DKhvjnFlQxzA5b1gEOxuKv5hVI+pKsNsE5oP6QDtf3h3uh4mPSAZ8OyzCyErhWOAM+w9jTJJPsPDT4bDl4RBKSjB+T7MRMp+9vh0/WP3wnQgPznXpX3Lxl+NBkrKSI18gCi2HDwTsCdak3NsuLn5dDpUJf2K5eAW5kSeH6D1X+Bq9cGyh05HxeDW8HPf04zGwhFxbct+s0u510mTvNn/Y/NShqsQUl3+1ALGx8LcS9Fltl3APG8dcEnLqmOplLzeuvZVyO2oir0plRQZDNV3y9pjlOnXuep1c265OeuehLRGo6Q0Fnv+MYyMqETd3tFXYvYB1mwmf/FySrPwqWI7VweUd0AVu0nGYfEHc1V3QmAhfdVIDS+EalC73S4Fo826kMcOCRBoDYVeYX/sE9bKhnC+aHIqf+gI9m3mkJqbKlSYaQlPqyUoLj8/BlkLjdXPosLCyen5oGICa7NKzejqnQ5Tkol4OhNkq/mKFgXR4KrxXzCYwAb5zWwC7C+wkyQJLkpxgYNFW+e5P3ZzMIMA3hpRUdO0Hv7HHlCJpbsxZBRbRNA9fFoZ+smFKCMjQFufBCMt8gxNLRqRSgBqVg1BsQrBk5PxKOad6d+p7U334L2pXUHKF9U6Lz/msWlJEvSVPfm6NbKLho3elOMlGSKkaxnaw7VKoikSP8K2ZJpGa6naZ6kOMseovBFYeIjxsguZgRV8toYoxY38zD1y98BLVj6SlIvtW7HOo/I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(39850400004)(396003)(376002)(346002)(54906003)(2906002)(1076003)(83380400001)(186003)(66476007)(66946007)(8676002)(6666004)(4326008)(110136005)(36756003)(66556008)(52116002)(26005)(6512007)(6506007)(2616005)(38350700002)(478600001)(86362001)(41300700001)(44832011)(5660300002)(316002)(7416002)(8936002)(30864003)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aMBd31NJ0v0Acdo8yb5kU5xUp0UKpF5I7WncnAewDTXtWrSfMZMtY4TI+Khc?=
 =?us-ascii?Q?ec866os/1bPv7jIIxd6YeZ7LYGrF5qc9dE4wtOOipwDLxAloBtrbkK4rdRAh?=
 =?us-ascii?Q?3yxDHdnXhzLh0mTfdn8WYfRaSsMJc8kk8yJyyZH5eJxb4X32bxhordAYh7cW?=
 =?us-ascii?Q?rnzTFkjC6vMVxXwiG/xkrpG+/BNR3HUH2B0/kJ+ockPp9XlpVfmk1dyGHVUe?=
 =?us-ascii?Q?ftOHAgu5OsiqeliIfBsSy+7EM672eAao16NKtORi3T3UPzH4HdSf1gOzGBuU?=
 =?us-ascii?Q?/ERGoCe6qFr/32MpeWGxVYek3CYm9If7Z65UnHt3U7l1V4MF0XVFuvRxmYeU?=
 =?us-ascii?Q?w2PZ7n1E2Kq5UCW7+M6gRKjAgYSLZh8DqoIMwPI7OJFSUpqM+sUMPbquuWp4?=
 =?us-ascii?Q?jpQQciFc4XNswkryBR4+UsU/yI0eex/6By1aaXoMEDvp93VZdZil64QmT0nR?=
 =?us-ascii?Q?kKmaeEZ90OXuzdeNJcdgZgCuIjFGgI7p8PyMKQk4UrH8wZkNOdPdan6tYBaZ?=
 =?us-ascii?Q?7hNEh9Sdbz75wCWog3d2JgK9M3akxsoi69EBwhnKYj4BXs7r/+Jsqs6LJoB/?=
 =?us-ascii?Q?gWL2PVR70RKSpwtSVnwm9WqTjyeJeHmrJUHAHs4E3w2iRwwy2vcefXgXIuyz?=
 =?us-ascii?Q?+r/Sm8s284X4sjfsgBpQ/NdoARYopJFZ/nWb0v1iSG+YF7WqrpsoQ1C2/kmb?=
 =?us-ascii?Q?qkxhNgIM9dUOxjBKloezXrOD9MLAdZvEUc71F8NK2hcH0RPEybsRPcWFE4oE?=
 =?us-ascii?Q?BmtRSPl/pDxaeVdm2WpjNabTQBF9XHBx4RJ7Jsk647QtQqOIWo5kVBOlJukk?=
 =?us-ascii?Q?sqTYpSjgRLv0T2MmvMdwGBaI+b8Jomr1uXB0vBHD7dPtpdJUMXHRs43C3LGk?=
 =?us-ascii?Q?dTXrzWpiwou7QOzm16C0yydaSvLq5/x0NI/smfrVs8tRA/1nn6fcIe+u2no0?=
 =?us-ascii?Q?NgVDe6SIbcDEhozOd2AJdJj88rntmPytuGPRTAqY3mhvYF7ngTeTalGBtns7?=
 =?us-ascii?Q?zuMMWqrVfJ99OzX1GU0H/usxCt2bVrOda5snNeHQ+SfUBEbOYHs262cvFajb?=
 =?us-ascii?Q?SDOWU8yNYgPGOTLcGbVujt+Y+FCd+xJrk8swJiS/x6gR//Nw5QQbf8lV/ISq?=
 =?us-ascii?Q?zR4NPXYOlQvVUGZhF4UfZQ4pKwdrJNhM866cm9a9hDJ1wYL4ZyQi5S5ZPGpG?=
 =?us-ascii?Q?EDZB1YnvG/R6IbBU61eyaocQLjADnqU+D04ECW3wj77D5mzONrHgIohG4yaE?=
 =?us-ascii?Q?LKddDuS+qsjz6WvmBN2aives05lhooCwHLOZy5dlnOx76GYxJt/jmWL7t+0w?=
 =?us-ascii?Q?GS8C3nJKB9OM50B59tPwW6Ow2MU5LOrUlz8+3QMNRrYuWlvSrfysP2ujMKRG?=
 =?us-ascii?Q?fgDQRHepLAY3MlcP3S5BBTRskQIinyNzd5QP4kMi1lNRmyf/DUTzfV/A8wHo?=
 =?us-ascii?Q?Wf0rX9XkXYFsQW/8kORUP/doES1ZOUzSVo6l3fJ973yEvBkjO9gz/WnLWycd?=
 =?us-ascii?Q?57IwIVFFWNySijtND3kvj79ZOxynm04QpsvQfQw4jnYXtmaa/JKb6vqkL2YR?=
 =?us-ascii?Q?GMbKnVrHqXgWAsBayy6swmnHYAgkKFAe0OLmP1npqodlUHl/6M7jNMDc9plx?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc5a6c9-5535-4542-8c88-08da69e176f9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 23:50:31.2220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vtgVgd3p7mCKP8xuVVLIYXAtGyx3olLbZN8lLTuJ2xyjo9obFWxelMp7irMgQpnxaETB/9bJZn01ZTM4gC8DMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4811
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Changes in v2:
- Use int/defines instead of enum to allow for use in ioctls/netlink
- Add locking to phy_get_rate_adaptation
- Add (read-only) ethtool support for rate adaptation
- Move part of commit message to cover letter, as it gives a good
  overview of the whole series, and allows this patch to focus more on
  the specifics.

 Documentation/networking/ethtool-netlink.rst |  2 ++
 drivers/net/phy/phy-core.c                   | 15 +++++++++++
 drivers/net/phy/phy.c                        | 28 ++++++++++++++++++++
 include/linux/phy.h                          | 22 ++++++++++++++-
 include/uapi/linux/ethtool.h                 | 18 +++++++++++--
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/ioctl.c                          |  1 +
 net/ethtool/linkmodes.c                      |  5 ++++
 8 files changed, 89 insertions(+), 3 deletions(-)

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
index 1f2531a1a876..dc70a9088544 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -74,6 +74,21 @@ const char *phy_duplex_to_str(unsigned int duplex)
 }
 EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
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
+
 /* A mapping of all SUPPORTED settings to speed/duplex.  This table
  * must be grouped by speed and sorted in descending match priority
  * - iow, descending speed.
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
index 81ce76c3e799..4ba8126b64f3 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -276,7 +276,6 @@ static inline const char *phy_modes(phy_interface_t interface)
 	}
 }
 
-
 #define PHY_INIT_TIMEOUT	100000
 #define PHY_FORCE_TIMEOUT	10
 
@@ -570,6 +569,7 @@ struct macsec_ops;
  * @lp_advertising: Current link partner advertised linkmodes
  * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
  * @autoneg: Flag autoneg being used
+ * @rate_adaptation: Current rate adaptation mode
  * @link: Current link state
  * @autoneg_complete: Flag auto negotiation of the link has completed
  * @mdix: Current crossover
@@ -637,6 +637,8 @@ struct phy_device {
 	unsigned irq_suspended:1;
 	unsigned irq_rerun:1;
 
+	int rate_adaptation;
+
 	enum phy_state state;
 
 	u32 dev_flags;
@@ -801,6 +803,21 @@ struct phy_driver {
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
+	 * return that rate adaptation mode (preferring %RATE_ADAPT_PAUSE, to
+	 * %RATE_ADAPT_CRS). If the interface is not supported, this should
+	 * return %RATE_ADAPT_NONE.
+	 */
+	int (*get_rate_adaptation)(struct phy_device *phydev,
+				   phy_interface_t iface);
+
 	/* PHY Power Management */
 	/** @suspend: Suspend the hardware, saving state if needed */
 	int (*suspend)(struct phy_device *phydev);
@@ -967,6 +984,7 @@ struct phy_fixup {
 
 const char *phy_speed_to_str(int speed);
 const char *phy_duplex_to_str(unsigned int duplex);
+const char *phy_rate_adaptation_to_str(int rate_adaptation);
 
 /* A structure for mapping a particular speed and duplex
  * combination to a particular SUPPORTED and ADVERTISED value
@@ -1681,6 +1699,8 @@ int phy_disable_interrupts(struct phy_device *phydev);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
+int phy_get_rate_adaptation(struct phy_device *phydev,
+			    phy_interface_t iface);
 void phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
 void phy_advertise_supported(struct phy_device *phydev);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index e0f0ee9bc89e..3978f9c3fb83 100644
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
 	__u32	link_mode_masks[0];
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
index 6a7308de192d..ef0ad300393a 100644
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

