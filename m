Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949925BEFDD
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiITWNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiITWND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:13:03 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFFE7820F;
        Tue, 20 Sep 2022 15:12:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKsyU+v4yiZ0ImVyYBTSWJRVwefW5wy6V2sXnV5zUQAr+XaKEF5R9Y8TUyXmibH7na4ZxILR/Ymj/uKQpYY3F0EXkBUbUZbTg7zcYgwm5LZeWTq/vH3qJBoP1J4P26qXf2mpNiQCIylsS0V8Q2z08s7dyvfbc04gopOQ+NFZQ90u89Jhy5c1wKp58DXEsGXbGi6DJDTmR4uPRXFY1I1xvSEVq/xbnrg78/Ej0lG1JjQSstS5zmC91j4A6l8CVieTxQkps5ZYapdHVmhjoengq0vqqNmmaLGBSo6n5FUHbsfgO713mmNWq8ofjoXgQmTGQiQIaKi5E1l9OEkWS84sDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5K0hzmaZzN6bSEjCsP4V2owVLaqDc9PfcuemAwb0l0=;
 b=FDmIHt2fVpSDa92L1gxuKPfBusgvw5IP2h+9+ZB87mbxVrOkiEZCPsvz3Efb9XhuKXxAO/TtV3xa/nNkAtIZeS2QczM4HWjV3TDx8poom1HN2hCRQ4X+dXKFXH8o+jUnd2jbLunZGLxfxihzAs2oPKKElnr1SCollCMKHmmCtWP7/xF1u80GQnmrFNyt79oXQMpP+gWKgjm25DSZpOwlr/C2G8NihukB5130of4X8Ba3Tp3HbVtiVYOFIkFJQDoyliVOQoE6jpF/zLv1JLuZMZ/5EP2ffh+m4AbPl5mR3PdqTRiOqQXn06zQRb8bkzXJjf/C2Zzmk4B48R2eAAAxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5K0hzmaZzN6bSEjCsP4V2owVLaqDc9PfcuemAwb0l0=;
 b=kwun7EeoikwkW9y6XzLCHK4a8ucLpe7x9bq2wqjxWFaZqL+VfHn7iwPbzVL9SsOADSup1XVYMkZkgq+eN+HrdR89QaqsPh+wjV16gGU1GVEixDO9OmU391zoL1rxOx21x5/COc56hbH/G7CwYG5Vc5v/gxLqWAshmkq+5dPoE3/ArJgpxTxo1OsF/kQcdd8RpkZndPoJp3bp94kbEof/XbsuLapUuCMiyhjV0wnptXfoUIDUo3GtZZlYjH55FGalJObclB/MDY/O6hf51hB5jZFvkTgfzHtMiAj82ujCFPmMPOvYycBtO98lhybzMUIgsXcMQPun3BWQjBbaQWvrIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8179.eurprd03.prod.outlook.com (2603:10a6:20b:4e2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.18; Tue, 20 Sep
 2022 22:12:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 22:12:52 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next v6 4/8] net: phy: Add support for rate matching
Date:   Tue, 20 Sep 2022 18:12:31 -0400
Message-Id: <20220920221235.1487501-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220920221235.1487501-1-sean.anderson@seco.com>
References: <20220920221235.1487501-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 36b62ef9-5957-491b-0ffa-08da9b5542cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caql6kLrz6Nj8HtdP9xFiO9gz3c6boJG0k/0FFSnXyLfAksJ7+FpuOXfY8Jbf+kdDFlqVWR4EjozPHUfki7KP51lyQtVYmQKM7N/Iu/tq5G35xe6jRt8hb3pdOknnyDy6aGCq3LUbLATvtCjYsdZTL694gT5BumvBReWAPDqtGmUb1Mdl0AT+Rfg7YEn+99zKPkEJ6JQRmUEYgP3sY5Ds1xoAjoaSUrnrzobZGk0i/8IIb+EvtelRn++UrmXz35SG1IW6eBBJUPDp4xq3s70cWAX9Yn8b43YmERdIn6UJXL2iBqNJ2BYTdVdQvClEc9pThviqyXG1chrNg1Nb6JoyjhdTc613qFyPWMONqkT6gDEnJo2WNprv0/UIN/wlbgwh490PKsStOollkHsSG84IsmNLFsluu9vD+uM5WJrAOfT4Q7wmC/9+VH8B4VlIx4G2qUjPy03c2hviYJDX8q+jg1CLSO24jYQP6A1y4TjUOn0uT+9rOmq+uboIvxekgu4Wk7ELex/sm5tW4QDW9KIIrVRl0c0vGep8m2zG2zfHh5a4a9BXVxNBHZFiPFUsoP9NjV2KYXZxg8YQMYG5sGedeMQ/t05glXAuXkfXp8UWHwxoa6G3Twsjvz0sFQfDSeVrsNPTAn6SkDBr/xraOqKPpovc8/Q4u3xrG9+BDtylAeXBEC6gmhOscLZC1k05BHSg56kyy4KAz5nGGCgKxys2tShTSppbKjkgSYyhzjeSkRyOvhhmJ3APcj6ktlBpghX22+jhSpu8l3dpQwXJRb0mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(366004)(396003)(376002)(346002)(136003)(451199015)(7416002)(8676002)(186003)(478600001)(1076003)(30864003)(66476007)(66556008)(66946007)(4326008)(5660300002)(2616005)(44832011)(86362001)(8936002)(83380400001)(6486002)(26005)(316002)(54906003)(2906002)(6512007)(36756003)(110136005)(6506007)(38350700002)(6666004)(41300700001)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gy/KYm4cW9/P1vFKk9iMRyMwB7/4FPxSvleOEcwfhUhSEPus2DgBwIxRqtup?=
 =?us-ascii?Q?7GzEhRPj6BMOlZ4kbGTyPcsc8OebNtqRVp/bOFx5JiAVLvhffJxkNAKKMJyX?=
 =?us-ascii?Q?wSfM+WDEXq5W+TPUmZ3u8ZYA6LmOeMLjAp8sCS5P1GRNyA+iS8PAxPJs2gOU?=
 =?us-ascii?Q?qyFqScn5Bk829RLL/BH/AjIw6vOkqkh89oBqMVRqGq0DaFw99K0UeyIFRSnK?=
 =?us-ascii?Q?AFFpgXooJvC3cUcBv54ug5lSP4+CTN6KxY8++0SJYPLFbs/a9rFC2fW940Nj?=
 =?us-ascii?Q?vbFMx5530Ce67eTwwyr3pUQKn3o8YFXF7YSkuw9JFp15Gm9XsSxX9uwHmKA0?=
 =?us-ascii?Q?KZtTfDklmIojaV4KaYlmlZUBmKO1y66V6gSOJGNUs8N/RV5w5rO66c1OGjsn?=
 =?us-ascii?Q?TYvN/3qmhOulMVOlFmgp5kEEGGVV5cPPZ/aQAttV7egQMbMti09aBilLoAyq?=
 =?us-ascii?Q?9487PeO+CwolxsqMkoAafpNNwBIKVL0fdSNI75OHjYG5PQYSe+EWy3KTl5p2?=
 =?us-ascii?Q?AfHNW9I5NmvKPcTdsPuLYfjSgl9/3IqKkYDYVYTyzUlAKgEYsRmUKEhPtVg+?=
 =?us-ascii?Q?mixV1UspWpoRY582izlYJZrxtcVBBetTJ38b2+80PJo/mnjyxfbhXPPXxeaW?=
 =?us-ascii?Q?AJ05EWmyXp1jjoZGlNBvtUoDQq/h/cGVzlWisKNFCKn7M0YXCVLDlvyilBj6?=
 =?us-ascii?Q?tZGZfb8q90m3Xun8jcOYnwXcxi7/LKStgOlxx8AVqjNmaVadkjHF0WjT7jj1?=
 =?us-ascii?Q?/PYzFjY3pSAoxiR4QboF2E8hMVkbWlzgih7gZZEIzYW4/1Yk/pDiy+SxaO4I?=
 =?us-ascii?Q?QCbZtQw8xxQChgA3sMLDRCqSnsjWlTPV32/dCjpYuTP8bJeqUS2iSpUv5G57?=
 =?us-ascii?Q?lnyll5VguhX2QozectRyciUyJxbexRUl5J5Kile9nFSQYaGJT14roju2oHr9?=
 =?us-ascii?Q?33S567BoXYU75kYlKs7HFokt+LNTQ6i7wOXaHXSf+B1gdjA1OeN5QXrGMVA0?=
 =?us-ascii?Q?aNysPJ64TPAD9EWGs8+uVqDXDq/k0qfOl3hb1WJMA+YVTqPOCw4su3xCigHt?=
 =?us-ascii?Q?3+5KpDoL4c6KGOWE/B0Tj3HIL0WeTJeXdKKyDdpqyto5lZ05n+wgAkC4Okq/?=
 =?us-ascii?Q?Wrm18VtdJ9APFrAHYz0kFjfYY92dd/Jqs2odjyCQZXDaVaHtACAMX20JwXry?=
 =?us-ascii?Q?l7ZnpfokG8xbsEv9Ce0i4hsUW59VrdWWloo8LLcRN3LLr7sbXeU+3JIpwuFZ?=
 =?us-ascii?Q?6aVsn413JHSidaPd5uG3AeKpc0iU3ZGibfUgotd2xNiPfT38CzTU9sYlaJpi?=
 =?us-ascii?Q?uZuLNPeEzQ9f1AmdByFXLozYWjYOPz7Q+JV/atqfgqKlRcUtb31tXwmIO4uv?=
 =?us-ascii?Q?MBRcKxqFMGrniWwx9wQD9WakaSe7caxkcgVUY0sxjv8EGKx5/DKxsbWQx392?=
 =?us-ascii?Q?16A64r39Vh2x4cc4EPX/Ammdvp/0bF3yYO7h5zqqVIsrcTPy1sCnFBpFsv06?=
 =?us-ascii?Q?lirp9mNqiOZCuPFA7ExLEsrwHv7pfrQLzq3HLK+3xxLyTjLEmdGIvz91r0H5?=
 =?us-ascii?Q?S2KoQH3tELPg02DBnNdjeAgzxj/Ufl8yku88S8EjkSvLYMdjpC8z+jgc+gFL?=
 =?us-ascii?Q?gQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b62ef9-5957-491b-0ffa-08da9b5542cf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 22:12:52.3144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gv/1vyApYZg4acc7fbr4TPR/DrEJEdurK+BhV1bIwcuSaJd2mvlulSsJdocOgceJmYFBUYbx4jA8jqLt8BmHGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for rate matching (also known as rate adaptation) to
the phy subsystem. The general idea is that the phy interface runs at
one speed, and the MAC throttles the rate at which it sends packets to
the link speed. There's a good overview of several techniques for
achieving this at [1]. This patch adds support for three: pause-frame
based (such as in Aquantia phys), CRS-based (such as in 10PASS-TS and
2BASE-TL), and open-loop-based (such as in 10GBASE-W).

This patch makes a few assumptions and a few non assumptions about the
types of rate matching available. First, it assumes that different phys
may use different forms of rate matching. Second, it assumes that phys
can use rate matching for any of their supported link speeds (e.g. if a
phy supports 10BASE-T and XGMII, then it can adapt XGMII to 10BASE-T).
Third, it does not assume that all interface modes will use the same
form of rate matching. Fourth, it does not assume that all phy devices
will support rate matching (even if some do). Relaxing or strengthening
these (non-)assumptions could result in a different API. For example, if
all interface modes were assumed to use the same form of rate matching,
then a bitmask of interface modes supportting rate matching would
suffice.

For some better visibility into the process, the current rate matching
mode is exposed as part of the ethtool ksettings. For the moment, only
read access is supported. I'm not sure what userspace might want to
configure yet (disable it altogether, disable just one mode, specify the
mode to use, etc.). For the moment, since only pause-based rate
adaptation support is added in the next few commits, rate matching can
be disabled altogether by adjusting the advertisement.

802.3 calls this feature "rate adaptation" in clause 49 (10GBASE-R) and
"rate matching" in clause 61 (10PASS-TL and 2BASE-TS). Aquantia also calls
this feature "rate adaptation". I chose "rate matching" because it is
shorter, and because Russell doesn't think "adaptation" is correct in this
context.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
Should the unimplemented adaptation modes be kept in?

Changes in v6:
- Rename rate adaptation to rate matching

Changes in v5:
- Document phy_rate_adaptation_to_str
- Remove unnecessary comma

Changes in v4:
- Export phy_rate_adaptation_to_str

Changes in v2:
- Add (read-only) ethtool support for rate adaptation
- Add locking to phy_get_rate_adaptation
- Move part of commit message to cover letter, as it gives a good
  overview of the whole series, and allows this patch to focus more on
  the specifics.
- Use int/defines instead of enum to allow for use in ioctls/netlink

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
index dbca3e9ec782..09fb1d5ba67f 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -426,6 +426,7 @@ Kernel response contents:
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE``  u8      Master/slave port state
+  ``ETHTOOL_A_LINKMODES_RATE_MATCHING``       u8      PHY rate matching
   ==========================================  ======  ==========================
 
 For ``ETHTOOL_A_LINKMODES_OURS``, value represents advertised modes and mask
@@ -449,6 +450,7 @@ Request contents:
   ``ETHTOOL_A_LINKMODES_SPEED``               u32     link speed (Mb/s)
   ``ETHTOOL_A_LINKMODES_DUPLEX``              u8      duplex mode
   ``ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG``    u8      Master/slave port mode
+  ``ETHTOOL_A_LINKMODES_RATE_MATCHING``       u8      PHY rate matching
   ``ETHTOOL_A_LINKMODES_LANES``               u32     lanes
   ==========================================  ======  ==========================
 
diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 2a2924bc8f76..2c8bf438ea61 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -74,6 +74,27 @@ const char *phy_duplex_to_str(unsigned int duplex)
 }
 EXPORT_SYMBOL_GPL(phy_duplex_to_str);
 
+/**
+ * phy_rate_matching_to_str - Return a string describing the rate matching
+ *
+ * @rate_matching: Type of rate matching to describe
+ */
+const char *phy_rate_matching_to_str(int rate_matching)
+{
+	switch (rate_matching) {
+	case RATE_MATCH_NONE:
+		return "none";
+	case RATE_MATCH_PAUSE:
+		return "pause";
+	case RATE_MATCH_CRS:
+		return "crs";
+	case RATE_MATCH_OPEN_LOOP:
+		return "open-loop";
+	}
+	return "Unsupported (update phy-core.c)";
+}
+EXPORT_SYMBOL_GPL(phy_rate_matching_to_str);
+
 /**
  * phy_interface_num_ports - Return the number of links that can be carried by
  *			     a given MAC-PHY physical link. Returns 0 if this is
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 8d3ee3a6495b..e741d8aebffe 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -114,6 +114,33 @@ void phy_print_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(phy_print_status);
 
+/**
+ * phy_get_rate_matching - determine if rate matching is supported
+ * @phydev: The phy device to return rate matching for
+ * @iface: The interface mode to use
+ *
+ * This determines the type of rate matching (if any) that @phy supports
+ * using @iface. @iface may be %PHY_INTERFACE_MODE_NA to determine if any
+ * interface supports rate matching.
+ *
+ * Return: The type of rate matching @phy supports for @iface, or
+ *         %RATE_MATCH_NONE.
+ */
+int phy_get_rate_matching(struct phy_device *phydev,
+			  phy_interface_t iface)
+{
+	int ret = RATE_MATCH_NONE;
+
+	if (phydev->drv->get_rate_matching) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->get_rate_matching(phydev, iface);
+		mutex_unlock(&phydev->lock);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(phy_get_rate_matching);
+
 /**
  * phy_config_interrupt - configure the PHY device for the requested interrupts
  * @phydev: the phy_device struct
@@ -256,6 +283,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 	cmd->base.duplex = phydev->duplex;
 	cmd->base.master_slave_cfg = phydev->master_slave_get;
 	cmd->base.master_slave_state = phydev->master_slave_state;
+	cmd->base.rate_matching = phydev->rate_matching;
 	if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
 		cmd->base.port = PORT_BNC;
 	else
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 337230c135f7..9c66f357f489 100644
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
+ * @rate_matching: Current rate matching mode
  * @link: Current link state
  * @autoneg_complete: Flag auto negotiation of the link has completed
  * @mdix: Current crossover
@@ -641,6 +641,8 @@ struct phy_device {
 	unsigned irq_suspended:1;
 	unsigned irq_rerun:1;
 
+	int rate_matching;
+
 	enum phy_state state;
 
 	u32 dev_flags;
@@ -805,6 +807,21 @@ struct phy_driver {
 	 */
 	int (*get_features)(struct phy_device *phydev);
 
+	/**
+	 * @get_rate_matching: Get the supported type of rate matching for a
+	 * particular phy interface. This is used by phy consumers to determine
+	 * whether to advertise lower-speed modes for that interface. It is
+	 * assumed that if a rate matching mode is supported on an interface,
+	 * then that interface's rate can be adapted to all slower link speeds
+	 * supported by the phy. If iface is %PHY_INTERFACE_MODE_NA, and the phy
+	 * supports any kind of rate matching for any interface, then it must
+	 * return that rate matching mode (preferring %RATE_MATCH_PAUSE to
+	 * %RATE_MATCH_CRS). If the interface is not supported, this should
+	 * return %RATE_MATCH_NONE.
+	 */
+	int (*get_rate_matching)(struct phy_device *phydev,
+				   phy_interface_t iface);
+
 	/* PHY Power Management */
 	/** @suspend: Suspend the hardware, saving state if needed */
 	int (*suspend)(struct phy_device *phydev);
@@ -971,6 +988,7 @@ struct phy_fixup {
 
 const char *phy_speed_to_str(int speed);
 const char *phy_duplex_to_str(unsigned int duplex);
+const char *phy_rate_matching_to_str(int rate_matching);
 
 int phy_interface_num_ports(phy_interface_t interface);
 
@@ -1687,6 +1705,8 @@ int phy_disable_interrupts(struct phy_device *phydev);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
+int phy_get_rate_matching(struct phy_device *phydev,
+			    phy_interface_t iface);
 void phy_set_max_speed(struct phy_device *phydev, u32 max_speed);
 void phy_remove_link_mode(struct phy_device *phydev, u32 link_mode);
 void phy_advertise_supported(struct phy_device *phydev);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 2d5741fd44bb..fe9893d1485d 100644
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
+/* No rate matching performed. */
+#define RATE_MATCH_NONE		0
+/* The phy sends pause frames to throttle the MAC. */
+#define RATE_MATCH_PAUSE	1
+/* The phy asserts CRS to prevent the MAC from transmitting. */
+#define RATE_MATCH_CRS		2
+/* The MAC is programmed with a sufficiently-large IPG. */
+#define RATE_MATCH_OPEN_LOOP	3
+
 /* Which connector port. */
 #define PORT_TP			0x00
 #define PORT_AUI		0x01
@@ -2033,8 +2047,8 @@ enum ethtool_reset_flags {
  *	reported consistently by PHYLIB.  Read-only.
  * @master_slave_cfg: Master/slave port mode.
  * @master_slave_state: Master/slave port state.
+ * @rate_matching: Rate adaptation performed by the PHY
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
+	__u8	rate_matching;
 	__u32	reserved[7];
 	__u32	link_mode_masks[];
 	/* layout of link_mode_masks fields:
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index d2fb4f7be61b..408a664fad59 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -242,6 +242,7 @@ enum {
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
 	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
+	ETHTOOL_A_LINKMODES_RATE_MATCHING,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9298eb3251cb..57e7238a4136 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -571,6 +571,7 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 		= __ETHTOOL_LINK_MODE_MASK_NU32;
 	link_ksettings.base.master_slave_cfg = MASTER_SLAVE_CFG_UNSUPPORTED;
 	link_ksettings.base.master_slave_state = MASTER_SLAVE_STATE_UNSUPPORTED;
+	link_ksettings.base.rate_matching = RATE_MATCH_NONE;
 
 	return store_link_ksettings_for_user(useraddr, &link_ksettings);
 }
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index 99b29b4fe947..126e06c713a3 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -70,6 +70,7 @@ static int linkmodes_reply_size(const struct ethnl_req_info *req_base,
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_SPEED */
 		+ nla_total_size(sizeof(u32)) /* LINKMODES_LANES */
 		+ nla_total_size(sizeof(u8)) /* LINKMODES_DUPLEX */
+		+ nla_total_size(sizeof(u8)) /* LINKMODES_RATE_MATCHING */
 		+ 0;
 	ret = ethnl_bitset_size(ksettings->link_modes.advertising,
 				ksettings->link_modes.supported,
@@ -143,6 +144,10 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
 		       lsettings->master_slave_state))
 		return -EMSGSIZE;
 
+	if (nla_put_u8(skb, ETHTOOL_A_LINKMODES_RATE_MATCHING,
+		       lsettings->rate_matching))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
-- 
2.35.1.1320.gc452695387.dirty

