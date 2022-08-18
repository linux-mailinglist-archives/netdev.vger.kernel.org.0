Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1636598957
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345040AbiHRQqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345022AbiHRQqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:46:39 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2080.outbound.protection.outlook.com [40.107.22.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4E2BA9DE;
        Thu, 18 Aug 2022 09:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMeLELl1z8NjZtD8WgZHyDEtb6vAIyYHhafrlgIbEYMz+0PwMU9pwuju0mzJxm+2JKBgdWBwKvC+8qBn3ROsgIs1shj2Mj/9TUBK4q+ISoZKdHTiE5lAaQyLN+M/rSJPiEc3Gk7X12t2gdmWQiTlqO2I0yLODXmx/ue818egMkKnimdkpdvLbmyitDTSeZ44L0GfYYorlZiaPzo8ijNGvaIwmA1c1mlbYjcx/5wglj7GykHdHo6bd/ulKM0vsKnSqhhFVlf2nEgcGdSBwOgaEVE5BIwu+15e/bwVm/b5ZcigcuCW5fSTNGVnSGdacRNMrpdDswPTjVr14eynBwNiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQ+H5k3+A2zqjZSCDnlVcICVZH/ycKjZOAAfIjl7c8Q=;
 b=U0OkAXsK1hbE42nFE8hJyQ6SrLhwGxIg2X/pMc50xh0KT1QJST00FkMKIoXKEY0UFJFRu4r9lM3aDhJtStqCNt9nTfaZgRoQXg9EcZsfGMnGm7kZ5m/0qoPkcjDLQ5EHnaKUA7hcymsyg3ZlK//SQtiLJLQC7KtKz5sWXny3QmwtBc4eGCNDDQbnpzzIQx1bYxh8M3nJA4rAGErfoBqNYmfItOvdpeT3vgg/ohVcHoQD+v+6Nay8jx1s5U/20CDydxnifs1KNdvFlH5sPqcM+79xHAAK7h7CwjUigk6ppp/BXYkUJGSu6eeDU8jEKZjGPcFESsNrBatyyVJm1o+Q9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQ+H5k3+A2zqjZSCDnlVcICVZH/ycKjZOAAfIjl7c8Q=;
 b=kYtpDc5Yv6+FaDoqd/WOZ66w4DsWyDkaMy2hT9TswbbG+hRRfzeySYbDKF/6d6hnbgC81knmOpiDrPcn1yox8IXqhIaFLF5zpLV4+t06qp1V98m/M7vVabElBV0tz6GqZX/N0mdtL3rru0+0FwcgOQi2dVnlQKd2JTCMszfKp43OViHB3PZMQhVNweamAYCCQ4hM2v6/G/5Bjr2jiTf0ee+GkUa6bT2cWiNzWuNT3X7MTwTGH6leI6CNq4otGSNbPLuI+dQxGq6516KN/rnlCjoXNAx4mkwEEnOBYN/Zae+H0BPJ3TXY9KWsa1BsUdzjp7qvdIIPFiewproE8HOE2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7649.eurprd03.prod.outlook.com (2603:10a6:102:1dc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:46:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:46:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH net-next v4 06/10] net: phy: Add support for rate adaptation
Date:   Thu, 18 Aug 2022 12:46:12 -0400
Message-Id: <20220818164616.2064242-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818164616.2064242-1-sean.anderson@seco.com>
References: <20220818164616.2064242-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9deac057-1468-4e73-4560-08da81393752
X-MS-TrafficTypeDiagnostic: PAXPR03MB7649:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zunI1smg5cMJUPMpskZCXcJF/aPJOkz5GNKAptyXTBQvYpA/epa+61zJGfmOtTFh1ce5Kk85i5/nrOHVUuLmujKFW8ygQOg2P0KXUS0dabDwYAG8RyLcoGIiVeAsJF4KtY3RgEifU+1aUS5fsv/8d3e9ACkamaJmWTDvs/sUGganrv1gOFucwXy3wex45m4X9/yFSwLpMyyixGvmOxHvWiJAKWsdA8wsVXWBKBw7jEA+JmkyEiQ38Wkdd1VPaf8uLnGoP5Q8+tyVKveT57vxZs6ofeoU27KqT+e7Eeo8AkcQ0mxWXvLuaO46ide/zxSTf4bTvrCbdZERgNxWr4CPmU1CJ6Xt4lp73dQjSp7YrDqDuC3FYDXWqMld6HogWWE5jQ988BeJsf739naKwD/crkU0rfPG8bOeAfWUHyzKuEwNtg30nJVziUwgQma8VCsQiZnKCMzj+L4cZpTHbSdvS7IMQNi9f6HpIQlELuewSs8BijFYmwptJKuJsQsm0vcXKKfdshEgVW2g63Zv9IYUPjp4tqZzSvZ3oT+tT5kxWZOcBscMjP1hxqo8Wwz+yiY0jmXYY7bxP3ZBWWEcbF2u2XzSb2a+Ty127H6L/DEirh9MzssQKhMkZQfn6J6CDcps2qPrAKP5pshBgdoNh0NGIRZDbvCMyIuj6yF1643vslS5i3l40HxG8u1oP3twfKUQLtKj/B54Zm3KoLFJoC2ZhgyHLbmTPeP2rRgZTw5xbL4UBE9udw9EwRFC7NEB0KSzNxhtALWg4kTcSj6Q162NDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(396003)(346002)(376002)(366004)(136003)(66476007)(66946007)(478600001)(66556008)(6486002)(8676002)(2906002)(41300700001)(6512007)(86362001)(52116002)(4326008)(6666004)(186003)(1076003)(2616005)(7416002)(44832011)(30864003)(5660300002)(26005)(8936002)(36756003)(54906003)(110136005)(6506007)(38350700002)(38100700002)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ooH0INar260WsmiLXQ8Z2j0vTSTk3PWUUKdOc4Kf2FYhRVLtCqziduFjvBlq?=
 =?us-ascii?Q?FCBGlem56+ByBnsp+XYfrnMm2g5jeYUmt5B10NRqXI1r9rg6wBg/IylklDFU?=
 =?us-ascii?Q?v1IEM/8TjX20jsdldZUHtn/NB+l8sgjmicM1GG7uT3K4Fp3iZHmmSv1AR/Ry?=
 =?us-ascii?Q?7dboO3psrPaVOjfkPVEdIqVTr9XVSSnXEI8f+m1sViSiAurP3gYwOXVDcqZu?=
 =?us-ascii?Q?8CuE6h+kZKefZRjFZENbSQLLQeKHenzgx5URno+zqHm/JsZ5EdL0Nz1m3zY7?=
 =?us-ascii?Q?4KlNdA/CpJPni4UpKLXAEyIuFIvU0VupDPbZgf+kZAjPKWkbWjxuwy1K85hX?=
 =?us-ascii?Q?6zo9900MDAfvREkh0p8oi6hf4NFAVCoOHKsdHqUql07yAheL3UsVtMvJrqFS?=
 =?us-ascii?Q?SbgmkncEvuyfjolVf23/DAfiXblvGU/J1NC7ac6dGjnYYkIr2iECFcIkqF/Q?=
 =?us-ascii?Q?ehx65il87nqp9D/TXNy47S78ow59AuFjJZ3xldZhsyXO5extS3pl8yealSwH?=
 =?us-ascii?Q?7NnghZ1feA1hHG1ZIGYsJ/BD0nCDxGylgWkYd+vFmUvDuxdFXLNJPtB3amfU?=
 =?us-ascii?Q?7LNT0D1odA54Ybi+GxGhtxAfja7nqLnQFpvAVJzEkWTwHhbKUyLkpFOKGE6d?=
 =?us-ascii?Q?MIFpF+DDfyxdmVybY5IOPGdXU1SS7PCO49chga0b5uV1xqj5Ypqhd8yKA8Qp?=
 =?us-ascii?Q?W620J+SpR821jluMmx6/evgkHjEIK//1znrCVRopzppRd924n4YExQhqpizJ?=
 =?us-ascii?Q?UOLzawrYXz5P4xSdL60JP7hMxtp5cb9VE3aXx6OlM0iLSWYlc42Xkb55AtAy?=
 =?us-ascii?Q?9iP9p92N+5VOf8gSZnT4hsRAf8e5VtIF0YbKuvzp2JrlnGA7sj2auAE6UQEV?=
 =?us-ascii?Q?8GHaIotUU5ODRFr8D3MpD3D7CjQrDbV7EgdN6Z8aaS71/yt5mPT7d+B0aVZn?=
 =?us-ascii?Q?8XxBPwR7ANHASEDaVQJLbhsM9HFT0YvxOw6WgOAQCa/7c6cvUuHArvBOwU28?=
 =?us-ascii?Q?qzlq/Xh76MzOh0ivN1OV1/iN5kIKa9p6oHjjYAYowxRvmjJUJLQnzMAjueDo?=
 =?us-ascii?Q?eAQX5egoxVnMEnNFtdHg8QERrqmKEr2Z7v132NclaMj0qBKWzDJYGurl50Vx?=
 =?us-ascii?Q?05JE2kTGa/Me4XJg/DeVPKBwVkIkoafLFA3uGxNQUKVJXZoC6o7+Y5wXACCh?=
 =?us-ascii?Q?byfNNr1l2Nalfcqj24Jcjz90dp1ZtHtY0pDs+RN1kt/UnDKDninZ500cuWhw?=
 =?us-ascii?Q?sarG34m5ve/VMx1eqXozbXI4dhb9kJeZ0My9W7WyLkskVDnaMLR02A92dTJB?=
 =?us-ascii?Q?M/uVlW05smWlo01jEiWN+iEG5IdTV16c2wPESLJ3m46q2o7UMpl6wXyjehgC?=
 =?us-ascii?Q?Eied3feWaty8vQR3zqfCp6OCF6nSard+D+o5W3K6zgT8IBXW7Ej15oHakdpO?=
 =?us-ascii?Q?oBiDVR6hnKbhaehMctntq1P14Zb0rmEPRMZBjsJeIX14lmrmjFgMfhQ5kzrW?=
 =?us-ascii?Q?QsZi7gDiVkj4P5LSdBAAujhRCfdBLDnmUpSqNJxXKLNfdbdPVZtD3jLoVnLQ?=
 =?us-ascii?Q?6SDtT5cJqdTyLYbbCwXnMlMo0p2j2GpyZze0zsUdhw2hCxmomYCwmKgdfMzx?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9deac057-1468-4e73-4560-08da81393752
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:46:36.9478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zqglQ1x7/VxBn6ZkPQvJobb4GqIWl3CDHXAAHMtMuxmfqjtx3j/WPdJikc6nzPkuWtQigLnDF0M11zPmhAKV8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7649
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/phy/phy-core.c                   | 16 +++++++++++
 drivers/net/phy/phy.c                        | 28 ++++++++++++++++++++
 include/linux/phy.h                          | 22 ++++++++++++++-
 include/uapi/linux/ethtool.h                 | 18 +++++++++++--
 include/uapi/linux/ethtool_netlink.h         |  1 +
 net/ethtool/ioctl.c                          |  1 +
 net/ethtool/linkmodes.c                      |  5 ++++
 8 files changed, 90 insertions(+), 3 deletions(-)

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
index 1f2531a1a876..a09ed0013f04 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -74,6 +74,22 @@ const char *phy_duplex_to_str(unsigned int duplex)
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
+EXPORT_SYMBOL_GPL(phy_rate_adaptation_to_str);
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

