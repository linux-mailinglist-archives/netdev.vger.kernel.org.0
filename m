Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2895B559448
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiFXHit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFXHis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:38:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E6056FB3
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:38:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZvqF1NTTkhiQIY+DX0OFuJQLn7vbQCS34UfgG/PJZNE0GutUC6helJTQ4TAoIzbOPhqilO5bW/n+oBmv//hncbV4s+/cMatgXvbhuILOptI0i7iyH0nwnA7CUnoiF/aqSVJgmv2PTW/tNBbbLBVVmxNkbHR5d7QfhqVM1Fi+ozY7sEEzfvejOY567kG8IRp9UpUE9XIyhxh1TkyaqVBXaW2xYZOYxX/2XUw5mgnAKx9Fh8S3J+ntC00jvQNc1+SG+tXbLwHZCHzNAsDp3caJh2HWTagmWQW4NUFYm9QzFRASamjzvngI/aieayBoNY0MSP4IrvxAzKvHHUzfBTacA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q1wkKi6Jt3OcQ8ZbxV7yPa83TDDRgZlMKzZyD5DQqRU=;
 b=McWCTue8Fx10ISSziK6+cKIS5y1Yjta5CclckpOQ86jZ8AHi0qiiIoA0oYzj8Z04NrWx1zVFnl9oDUYtTQ5oFirvxo2YhGeViLAnwcAr1+ApnRsHS+9vQN52URdk7FXw4TlWXaB4AXYfxhM0qHFVx8k0YWMsEYRV+9acyjJl12VKelJHYOBv5TxMs0F9DzvBvBAnRQHFNt3NX5oNzfM9kBkuiUH9i1+ycrZV9+rhhYPfzUzrK04ZN9XZdzkk3WRT7Wf81dUWyb4xATzSFa2yUG3uh9ha0xXyqDLzL0j7SBRwwvuAH88bbkZG2kpNDGyijCSMPIuBPtcFh1Dm613YGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q1wkKi6Jt3OcQ8ZbxV7yPa83TDDRgZlMKzZyD5DQqRU=;
 b=be+pmqrYC+b2zH5ClVRbWSHuHSFZ0XYRP1OU7s743atL3D9xa94xCazUGz/jM2EnVytI7aF01ZaU+C9mCG9wEqDBj8II3pZNy4v0rh2inN6+hpzM5tBKVNLiP9SGSLDOH2+8HrebPepftehQsteOgvNr4paz7/hLwcZgpI/8d/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CY4PR13MB1494.namprd13.prod.outlook.com (2603:10b6:903:13b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 07:38:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::b18b:5e90:6805:a8fa%6]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 07:38:45 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next 1/2] nfp: support vepa mode in HW bridge
Date:   Fri, 24 Jun 2022 09:38:15 +0200
Message-Id: <20220624073816.1272984-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220624073816.1272984-1-simon.horman@corigine.com>
References: <20220624073816.1272984-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P192CA0003.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4529ec0a-df6a-47f6-58fc-08da55b491bf
X-MS-TrafficTypeDiagnostic: CY4PR13MB1494:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VGnZuuTZsbXzimPQnSeBhy93qBs8XYqWkajo5xLQEwow+MbMnuDZ7td8EfsXuHfCV3PGAHimMpxSjvy50lR+KgO0yUSbsyGabCTiAHu09AAZsk0JAm3WBGdSuq1ZqvVPKnXmwFx+GCmlwubhLFr/7NROt4uABgtkaRy7KqzXL5ZKJkTBgJ1RfRfUiuw085tFfNkoMgp7EYRWJpCRJbTwQdkHVnONlfvrhanafelHtH//HcUYF5wqZHiEZOKH95aI9o9pMwXEtstdajHGggbXP3TSf17/hdz6AmGdLLXC3fanABdr23GfND0pq4hOHNtXpZPZ4NaTirSZvkYhCSDz6NVpHm3SKf+yn4Tj4M+oPEOQt1E2B9CBob1gs25RfjyQRXzjOFfIGSwfW9cs6kBmA0Q1PErx5xPgD/DsVV+sVe/tMDTeQbvE2vDvvUQOB7qO0rHJCAok3p/vvLUkWji0qlwVB5jRj00/NY6i2ZZxkmLfM+cpirq2msorjKb/KPvFoYNWXd3zg8QnSDbJ4KKVxn20BufsPK9Cc4xL3M6jI+s/Fb4HL1yme/4HvgrPxR5v202BrAl7QjCYf2T+zZZCcJJPGt8V7NdJWvY2IDL74Mh6vkgfSwIIK0mgfGo1VtyoSkaomrdOXvmQX+ZkMfNKN8J+0tePTu0XKTF5brk16DsH4YpBchUianxqOTRqGhFOQaQiKoCeeKNBQZ8NDBkdq3lrlBzCZohlLzDuq4Hwy9f62fDFedC/5Cv+da781bh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39830400003)(366004)(376002)(396003)(346002)(316002)(86362001)(8936002)(83380400001)(110136005)(36756003)(6506007)(186003)(8676002)(6486002)(38100700002)(107886003)(6666004)(478600001)(66946007)(66556008)(6512007)(44832011)(66476007)(52116002)(4326008)(2616005)(1076003)(41300700001)(5660300002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mtp7bpfta0Ia5pW1eyJHtLPtMbTvEQeSqRtCRuJixNXlwBU1uYf5D4tWyI87?=
 =?us-ascii?Q?yxn3u4Rc3Y4J7wSbZrKO2PIJAAOszAGsNFp2uIrkQJkbBowhzWjVAtOjZJEr?=
 =?us-ascii?Q?ATUbt2FyOc1N4jEyJhU9cRRcDf+WuaflzUuC50m0m+XYsxPAkSkyIzq4HTnP?=
 =?us-ascii?Q?mT6SwZwJzh+lU9nP0DRrQlizcgosKAFsEJnHaahWgAz2Ypu2g9C6HmbJ8rZe?=
 =?us-ascii?Q?0fN9wj3jO2/1iFYZ9lYUs6At0p5XBZVTfkmJlLXadpR4vsJN1iLv6OdUFJzS?=
 =?us-ascii?Q?bn0V0nC+Y2FOqCZCuXAKSGyaae3Z2qd+TsWLopICchhmplBMf8VFpZuPEZH6?=
 =?us-ascii?Q?l0eb3HnIE1zBjdsPLikqA/5XPNR9eU+TJJobotj086WtA06SNbIS4oIgeEhU?=
 =?us-ascii?Q?yifLG4E4LD8rj6Wng87tm1RncXdVDjcx2UXDfEAZ0JQDR5zCP/iXqZRFMD2r?=
 =?us-ascii?Q?A1mRPwGJBpi+TBJTusPmnX3QatJjuNts0VW41Vwo6rEjwkFMGrBgmXdsxTfO?=
 =?us-ascii?Q?5ZS9D0vQ7vV+F2SMrJqqLG9jqaXrxT3yCtOEuw5bWJgm6wzg3i75bSQdh5yl?=
 =?us-ascii?Q?2O488CHDQtJRfsqLTTdOouRzZyd1twK2mC6QkTY0gcE3hEb/cIbResLDnxkK?=
 =?us-ascii?Q?1N7FJRlN8nTpCTUnbfMjrGxaDW1L2uzK0Ewq4WPKKeiJAWC7j+FFycD99X9D?=
 =?us-ascii?Q?CpLZqJvHZrGAOZRJ/pbjKMhPcpbT8yL/Tia3ZAUVLONzsIm5PeAPFPjfxjja?=
 =?us-ascii?Q?L++FOv21L9OFomjEfr9b+bcwudmHq3Nplw22T8ar6d8yWQOWI3hMmOTjHXWH?=
 =?us-ascii?Q?MM3m4BRPrKam8UPKYOPeajiR3ro46wm5xaxe6bdlqvSv3YxCPdAit9K6NbDk?=
 =?us-ascii?Q?EoZmvIPegMf5IZqYOVEy93D6mC1nqvdNv7RF6THgR295rJ8ZrC6EXhOROfVd?=
 =?us-ascii?Q?0kE6kf8FMoXnuJSNNHS5haxiVl9Gak5qAfdL1WQiIfpyzvPNP7VamY3SYOZG?=
 =?us-ascii?Q?LmySzL1qItD+3drp1LJMgW6ao/rpvvIX6e1nZh4MA5S9xhTyj3emE6kgScaP?=
 =?us-ascii?Q?sq2av7AlNQN/oExkqOm9OG5B3ZWjXsGyqwdK2NixYsMnMWivVHwpXNM7CjgL?=
 =?us-ascii?Q?ZE4ew0J1Ayqumr2YXP+xWlFffgt2gZT3dz/804Yl20rwSyDnU0SJrQCnEiES?=
 =?us-ascii?Q?tkugbyR6+WnyTso43bNytSLp5D8ScjaZSkSgfrghJSCZl5kRBujBXkMl6noC?=
 =?us-ascii?Q?X01P0e29g7WyA9ZKTUvh6tDJerIH4YgpPR7tW7IQPlIhvDg+pQMRfiU4H1vm?=
 =?us-ascii?Q?KlyjKGnQ8f1WTw/VlGt3ImCjdI/KYpfNxp+LYWoie3PwO4L+GW0wrH1MMn/Z?=
 =?us-ascii?Q?Yya/0G/JKXxyJ4innVgXqwluO5D1vDJoB3xR6oTPE8bKyPBNgtTVZHaIGvVt?=
 =?us-ascii?Q?DNqxMbgYM9YDo/QpjH0YEshR0MHDPZt+IjeSIOue+bF6lL2gr72odIk9F2V8?=
 =?us-ascii?Q?k3ujGueP5IxZCRUPpLAqjUKcUbsrlNBHFPTP1qbuWpNYU7D6geAy+v0aJpEh?=
 =?us-ascii?Q?uNTF9p4ZgK8+mwx0LvyZJWVUmV/w7AgiE8VNuHqswvfBRRGpeAnrFkkIOhHz?=
 =?us-ascii?Q?CAbaH6mnnLA6VH8z4RQQKcRRi15wM0Nm5HkuX9QMhMDO1osX3uxc5w2SBJjm?=
 =?us-ascii?Q?nW2F/Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4529ec0a-df6a-47f6-58fc-08da55b491bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 07:38:45.6244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+ctv0C//ZzzRp28qFZ8TUfWHhQc6j/o7oS8m5+YnK5qjq/IZ6h9NwDj8lPrcbLhx1eUcvEJQ/yG/f9V47PTcH+L7WrWzymI8UY0YiFibpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Add support for VEPA mode of HW bridge.
The default remains VEB mode.
The mode may be configured using ndo_bridge_setlink,
and inspected using ndo_bridge_getlink.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  1 +
 .../net/ethernet/netronome/nfp/nfdk/rings.c   |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 71 ++++++++++++++++++-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  1 +
 4 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index f31eabdc0631..f65851ed5b50 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -251,6 +251,7 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
 	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_RSS |		\
 	 NFP_NET_CFG_CTRL_IRQMOD | NFP_NET_CFG_CTRL_TXRWB |		\
+	 NFP_NET_CFG_CTRL_VEPA |					\
 	 NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE |		\
 	 NFP_NET_CFG_CTRL_BPF | NFP_NET_CFG_CTRL_LSO2 |			\
 	 NFP_NET_CFG_CTRL_RSS2 | NFP_NET_CFG_CTRL_CSUM_COMPLETE |	\
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
index f4d94ae0a349..222ee0e5302f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/rings.c
@@ -171,7 +171,7 @@ nfp_nfdk_print_tx_descs(struct seq_file *file,
 	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
 	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
 	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_IRQMOD |		\
-	 NFP_NET_CFG_CTRL_TXRWB |					\
+	 NFP_NET_CFG_CTRL_TXRWB | NFP_NET_CFG_CTRL_VEPA |		\
 	 NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE |		\
 	 NFP_NET_CFG_CTRL_BPF | NFP_NET_CFG_CTRL_LSO2 |			\
 	 NFP_NET_CFG_CTRL_RSS2 | NFP_NET_CFG_CTRL_CSUM_COMPLETE |	\
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 57f284eefeb3..0991fc122998 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -31,6 +31,7 @@
 #include <linux/ethtool.h>
 #include <linux/log2.h>
 #include <linux/if_vlan.h>
+#include <linux/if_bridge.h>
 #include <linux/random.h>
 #include <linux/vmalloc.h>
 #include <linux/ktime.h>
@@ -1892,6 +1893,69 @@ static int nfp_net_set_mac_address(struct net_device *netdev, void *addr)
 	return 0;
 }
 
+static int nfp_net_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
+				  struct net_device *dev, u32 filter_mask,
+				  int nlflags)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	u16 mode;
+
+	if (!(nn->cap & NFP_NET_CFG_CTRL_VEPA))
+		return -EOPNOTSUPP;
+
+	mode = (nn->dp.ctrl & NFP_NET_CFG_CTRL_VEPA) ?
+	       BRIDGE_MODE_VEPA : BRIDGE_MODE_VEB;
+
+	return ndo_dflt_bridge_getlink(skb, pid, seq, dev, mode, 0, 0,
+				       nlflags, filter_mask, NULL);
+}
+
+static int nfp_net_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh,
+				  u16 flags, struct netlink_ext_ack *extack)
+{
+	struct nfp_net *nn = netdev_priv(dev);
+	struct nlattr *attr, *br_spec;
+	int rem, err;
+	u32 new_ctrl;
+	u16 mode;
+
+	if (!(nn->cap & NFP_NET_CFG_CTRL_VEPA))
+		return -EOPNOTSUPP;
+
+	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
+	if (!br_spec)
+		return -EINVAL;
+
+	nla_for_each_nested(attr, br_spec, rem) {
+		if (nla_type(attr) != IFLA_BRIDGE_MODE)
+			continue;
+
+		if (nla_len(attr) < sizeof(mode))
+			return -EINVAL;
+
+		new_ctrl = nn->dp.ctrl;
+		mode = nla_get_u16(attr);
+		if (mode == BRIDGE_MODE_VEPA)
+			new_ctrl |= NFP_NET_CFG_CTRL_VEPA;
+		else if (mode == BRIDGE_MODE_VEB)
+			new_ctrl &= ~NFP_NET_CFG_CTRL_VEPA;
+		else
+			return -EOPNOTSUPP;
+
+		if (new_ctrl == nn->dp.ctrl)
+			return 0;
+
+		nn_writel(nn, NFP_NET_CFG_CTRL, new_ctrl);
+		err = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_GEN);
+		if (!err)
+			nn->dp.ctrl = new_ctrl;
+
+		return err;
+	}
+
+	return -EINVAL;
+}
+
 const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_init		= nfp_app_ndo_init,
 	.ndo_uninit		= nfp_app_ndo_uninit,
@@ -1919,6 +1983,8 @@ const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_bpf		= nfp_net_xdp,
 	.ndo_xsk_wakeup		= nfp_net_xsk_wakeup,
 	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
+	.ndo_bridge_getlink     = nfp_net_bridge_getlink,
+	.ndo_bridge_setlink     = nfp_net_bridge_setlink,
 };
 
 const struct net_device_ops nfp_nfdk_netdev_ops = {
@@ -1946,6 +2012,8 @@ const struct net_device_ops nfp_nfdk_netdev_ops = {
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
 	.ndo_bpf		= nfp_net_xdp,
 	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
+	.ndo_bridge_getlink     = nfp_net_bridge_getlink,
+	.ndo_bridge_setlink     = nfp_net_bridge_setlink,
 };
 
 static int nfp_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
@@ -1993,7 +2061,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->fw_ver.extend, nn->fw_ver.class,
 		nn->fw_ver.major, nn->fw_ver.minor,
 		nn->max_mtu);
-	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		nn->cap,
 		nn->cap & NFP_NET_CFG_CTRL_PROMISC  ? "PROMISC "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_L2BC     ? "L2BCFILT " : "",
@@ -2012,6 +2080,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->cap & NFP_NET_CFG_CTRL_MSIXAUTO ? "AUTOMASK " : "",
 		nn->cap & NFP_NET_CFG_CTRL_IRQMOD   ? "IRQMOD "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_TXRWB    ? "TXRWB "    : "",
+		nn->cap & NFP_NET_CFG_CTRL_VEPA     ? "VEPA "     : "",
 		nn->cap & NFP_NET_CFG_CTRL_VXLAN    ? "VXLAN "    : "",
 		nn->cap & NFP_NET_CFG_CTRL_NVGRE    ? "NVGRE "	  : "",
 		nn->cap & NFP_NET_CFG_CTRL_CSUM_COMPLETE ?
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 8892a94f00c3..9007675db67f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -94,6 +94,7 @@
 #define   NFP_NET_CFG_CTRL_IRQMOD	  (0x1 << 18) /* Interrupt moderation */
 #define   NFP_NET_CFG_CTRL_MSIXAUTO	  (0x1 << 20) /* MSI-X auto-masking */
 #define   NFP_NET_CFG_CTRL_TXRWB	  (0x1 << 21) /* Write-back of TX ring*/
+#define   NFP_NET_CFG_CTRL_VEPA		  (0x1 << 22) /* Enable VEPA mode */
 #define   NFP_NET_CFG_CTRL_VXLAN	  (0x1 << 24) /* VXLAN tunnel support */
 #define   NFP_NET_CFG_CTRL_NVGRE	  (0x1 << 25) /* NVGRE tunnel support */
 #define   NFP_NET_CFG_CTRL_BPF		  (0x1 << 27) /* BPF offload capable */
-- 
2.30.2

