Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD5168AB91
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjBDRN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjBDRN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:13:27 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2530D36471
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:12:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PSYvbzeufF60ffkF6QJaiwMoAdLK2Oiu9rBL8gJ0Qh0ZwA7pNL4babXjWyXgwR4O05I5renaBDSSWQmrRuB4NAInaHDleNcMoWFMcjm1mmmVG1hFnF3jkSh+tFIIeL5tyqO0gg928/CZoK/CgM2PEyl8jW1vSCnsc/xvI041snHUq4elyMUNfmADtaX7xuL6g3RFXM7K5dtlma+U4cWedAMo8pLItXykrdnaLAGqnwKngIyWgdaZzNmsb5wgR1KlXevXa5lSuFzcB2dVbN6yfmzJhap+cdWIc3ULoc6U0G/8/2wtoGc0qhwaIDD1FfPmONGxhxWDzDyISdaCcY9/tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZYSHmCaoG4j2fFWRbMgJl0+SoxGapBIcuw1/KpNU5A=;
 b=mRRqRvktRWQhtor8vG7icDGtxCNeT2wtautcop7PJxh8bDcQlSDqQ4k5aEPsNBRYFVLBmU2VbUnnwl227GOwW2kzQbcZ48YiAHcNafn2iB6GeJ9GJjDxj3+d8D7YZsBsXE5IPeoK2Vogrh1KptmipeR7K1LtJekTJOliltq9rB3QtVyEFzfVi3CzsGV8PnoCYG8CKnNEkWIcI7XLk8Hd3lUiMan8Bpw8q9Zu8TmS+hDELk8hla1y/RXW1bNy5jnM3Czc1bo9lUa7NSFjQR+y1fDdFI/Fd5hI1o/ZINwN6IutdG4Z28HWDZQnH6kgPIWjmZ5N5JS6nE05cbA1vnyzJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZYSHmCaoG4j2fFWRbMgJl0+SoxGapBIcuw1/KpNU5A=;
 b=ha7iQQrKB9JW07ILIxR1UgItFVc/uT4xI2tIgIgTsFmgIQMzylQT8483qH8fc9PiPYJI/QEORYfEcEovydLHpwMGpo58IxOjkuqAPv1K3Vgo0X+PePKVNuowzjOBmwhqUnYqvCvH6+GWfIFNZO6Y6gCv4JSPJLPSKWcVMCU62pv/I3nXzq/lNlZ073TDQb7eBUJzInV9RbNiGUuTVedWaUo8JBpdLVDDyoKR/1djZJ5wVzvOHszLWJqTDS2ryQcQRxVdBIgGtk9OA1RiAUtec+1vAGZr5GZOS/TvJmzhmK8Ihj2qika0rXMixWGDvwmLsLgaPf1w97oAm5ftOPoUyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 10/13] vxlan: mdb: Add MDB control path support
Date:   Sat,  4 Feb 2023 19:07:58 +0200
Message-Id: <20230204170801.3897900-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0041.eurprd07.prod.outlook.com
 (2603:10a6:800:90::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c4dc11c-ad3e-4b72-2554-08db06d30ae9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WdCuxu5UXxJmT98KYkxUJImEt5OCU1NKq/VUGaxOLJSjedZ6+b46EHQqcb8F0SQwmRvRSTPQDqVbAn3C2+xwkfom15LX6O5yd66vtusDc6eS4Hk9YGREDr8/jnpukEuwQkY5UPvM2tZUMTmJ5Jy17qIhvYu7ctVlPvilyzg5hllHqgtNN7Ntuz63GJSzF0FQtHWWiUjjyfPuBCfhHmFosGlYGpTIwJXCmQGMqb5/F/9jkodrw2J+Pyd5wgJddoR87d7OYCtLZqGcGNpPfiPX0Rz9fPLAins20mZQBPNwLzV7Ch4mb88gqLtBfKp5S+ngm/IfNh1Vj/ABt5CsYwYK4UXSwAgFQx6+yT99KnBbDztKAyefJlXrp6ZANRcW61YZEPF+4doDHUPqV+E/M5OQljx3vgNHY3IhPrMLng2xc845IodP6UtDngTUAd9XrVsTgJvbU9psRUfVIlJYBIfsC3URycj0lQ7es3f2Ka4QYn3h0py8AiacewuCF16R9oj2vqbM72xRKbBn+d6t5hN07XiHF+7T6BkVlCQzI+9KvoNTnVG8mihqbka/+vZ4AL1em3gtu5kiyhlN397gJUcatYjFBtp1Jjs44NIHWOK1vby1XLM8zxqyTezN1oSPmAlin9BaxTxmqEwKdnHTUfeWDmYy45wWIv+TcZb1Ywe6D6+EgrwlulmX1F3SO8wAsSPtKzbcJ40ag+KI3GhZneiNSgAZPGlTstjK5y5kArHmBWE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8936002)(36756003)(5660300002)(30864003)(107886003)(1076003)(6666004)(316002)(6506007)(478600001)(38100700002)(966005)(6486002)(66476007)(4326008)(8676002)(66946007)(2616005)(83380400001)(66556008)(41300700001)(86362001)(186003)(2906002)(6512007)(26005)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r30df/1Ne9x37e+xrQ2gzjzGVXWUdSDeHKSd4QGX6jrrkNKpO0TgtcbXbsKN?=
 =?us-ascii?Q?3O4b/e/By3gO7XjIfOKY6sN6J9HTa1qtyGXQIJFxdEul/PDOTdtOIQQUo3ju?=
 =?us-ascii?Q?Jgj6ezz+9MnqR016mclP8v5xc95laFh3e5VDlDKOA1z7g6cy0OlQfQHMvP6Y?=
 =?us-ascii?Q?BvTxxNWOITPVKLDjNEZd137ZG/dmlF2XNn/PG9dRDJ/zgjPGZ2Dqj/NWiCIA?=
 =?us-ascii?Q?rzucRGexK9s6gm4LHV0u3Xgg+/XiUXc6YzOjDcqQXFx9YXHkyUwpqyYAy6zc?=
 =?us-ascii?Q?s7zdWnPUCvKY3ZXwOWZ6v1LL6QRe3nYXvu6MOgP6LJzSG3jLoFMo1AgrWrJn?=
 =?us-ascii?Q?NzFZqkZVfEi440ZECKu7L9bKpBWTF76kP6BzYJBPBVffuiqtOQ5plpBT+36/?=
 =?us-ascii?Q?QjmaG5A86ZQOD3B5JOe/xHsKBXgP6OirmIYuBiLCQbmk1fVFjyDDNaHUKIR8?=
 =?us-ascii?Q?eCs5VFKH+H+DNUJi/is7U0oeLYJP39LOMm4OVeU6d8reVe+aayxJw/cBHGve?=
 =?us-ascii?Q?Bponzk331HKmvxwVVqYClHW8kIysgbOnPI1Ha8Z9S9ZH6efxfRGyFMZxJR4N?=
 =?us-ascii?Q?ppiT7hEV62myD70U4Ggy4RfwDVe1gP+ChQkDXfOUAZTZ68MUyybQncRhbMWu?=
 =?us-ascii?Q?jUM3evx7tqEvDpndSTF22vqH7tVezKVOR4XRNc3+EJmqnwf0IjJ5Vk9IX/EL?=
 =?us-ascii?Q?vHo0KEQZ6e04+u2tpTXaX1NQFIQED8PsJIatuLVRoRJvfYOw/7atMAATuT2u?=
 =?us-ascii?Q?+0INDAeKOoFyfduZ09+XPXqVAONu//TdULUdBfM/gv4I0yYXzEIswAHsLGEO?=
 =?us-ascii?Q?iMxWPxJUEZoOhIH/xqHtN8jQ+4DgxmanTOWN1q8AB5snYRTuKUO0ut4At8WM?=
 =?us-ascii?Q?ypE/6epgmFJSgBf5WX8hdYKH8ZryOpJilfkg0a7xUgZmrfHM9SoqCIAxnSsf?=
 =?us-ascii?Q?ra2PCxLBty2QogSSt+ygml08+tKb2ym2QSEtIHmo5JrPHM+sm/qaVlJNfHRJ?=
 =?us-ascii?Q?o//CvCyBoso79YI2b45u7BDVzLdfCBxOCcbkPLZXPhd4VkTUxm381HhoJMun?=
 =?us-ascii?Q?Sd8rF9JlOevBXaB+TjpIfw5yL7ybGxHRKiegIfdaWGItaSsVYe0djkxqebNW?=
 =?us-ascii?Q?rp4Xdv62lcPd6VKwQbzWacHoM+S6/1cGwAcqtjCafO6XE8uiSinhzsdsXptQ?=
 =?us-ascii?Q?oeJISL/VF+zVgtxbRRIQB14kCKg4k3HSLL5xtc4MTrPZbZ1BdagsLJdWwB2f?=
 =?us-ascii?Q?axJByC9K1Iv4bLem7dobDOH8lW3lZOQFSoufaM/BXYPyxQTTggJF8fn8J7o+?=
 =?us-ascii?Q?+K34nFFlPl8sZ/pFl8dI1UHgMcGS7PDgAVYqOs9Rzs/mGD5c34WPEPnK3Lsc?=
 =?us-ascii?Q?DPoqDc3OWFMwvWEHocuIp/rXw4DCdgLyVaLt6D9sfe2l6OFIEE42Zo04pgO2?=
 =?us-ascii?Q?0opLxmdm9QDWxGvb5VpoKhyu5VY9xQLLEM6sYRzdQu+76ENnAoaWf3UZc2jN?=
 =?us-ascii?Q?PXuRDgwrma7C90B/fyikqM9mcLtG3KBglH+sSjAqvu4E9mSXjsX0k3ffT5V8?=
 =?us-ascii?Q?fwh1QUKRiB/5fGsjIBzo9Aymmu5PsYjyOia5vSEG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c4dc11c-ad3e-4b72-2554-08db06d30ae9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:49.6630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +455yyFoEryAvLugBYsHSdm78UCLfVvjqIFwFd7mGG7J0z/z3ziXeX/nJGtogxcJRrUDgF2mQrQIyvFyW/cuNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement MDB control path support, enabling the creation, deletion,
replacement and dumping of MDB entries in a similar fashion to the
bridge driver. Unlike the bridge driver, each entry stores a list of
remote VTEPs to which matched packets need to be replicated to and not a
list of bridge ports.

The motivating use case is the installation of MDB entries by a user
space control plane in response to received EVPN routes. As such, only
allow permanent MDB entries to be installed and do not implement
snooping functionality, avoiding a lot of unnecessary complexity.

Since entries can only be modified by user space under RTNL, use RTNL as
the write lock. Use RCU to ensure that MDB entries and remotes are not
freed while being accessed from the data path during transmission.

In terms of uAPI, reuse the existing MDB netlink interface, but add a
few new attributes to request and response messages:

* IP address of the destination VXLAN tunnel endpoint where the
  multicast receivers reside.

* UDP destination port number to use to connect to the remote VXLAN
  tunnel endpoint.

* VXLAN VNI Network Identifier to use to connect to the remote VXLAN
  tunnel endpoint. Required when Ingress Replication (IR) is used and
  the remote VTEP is not a member of originating broadcast domain
  (VLAN/VNI) [1].

* Source VNI Network Identifier the MDB entry belongs to. Used only when
  the VXLAN device is in external mode.

* Interface index of the outgoing interface to reach the remote VXLAN
  tunnel endpoint. This is required when the underlay destination IP is
  multicast (P2MP), as the multicast routing tables are not consulted.

All the new attributes are added under the 'MDBA_SET_ENTRY_ATTRS' nest
which is strictly validated by the bridge driver, thereby automatically
rejecting the new attributes.

[1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-3.2.2

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/Makefile        |    2 +-
 drivers/net/vxlan/vxlan_core.c    |    8 +
 drivers/net/vxlan/vxlan_mdb.c     | 1363 +++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h |   31 +
 include/net/vxlan.h               |    5 +
 include/uapi/linux/if_bridge.h    |   10 +
 6 files changed, 1418 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/vxlan/vxlan_mdb.c

diff --git a/drivers/net/vxlan/Makefile b/drivers/net/vxlan/Makefile
index d4c255499b72..91b8fec8b6cf 100644
--- a/drivers/net/vxlan/Makefile
+++ b/drivers/net/vxlan/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_VXLAN) += vxlan.o
 
-vxlan-objs := vxlan_core.o vxlan_multicast.o vxlan_vnifilter.o
+vxlan-objs := vxlan_core.o vxlan_multicast.o vxlan_vnifilter.o vxlan_mdb.o
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index f8165e40c247..1c98ddd38bc4 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2878,8 +2878,14 @@ static int vxlan_init(struct net_device *dev)
 	if (err)
 		goto err_free_percpu;
 
+	err = vxlan_mdb_init(vxlan);
+	if (err)
+		goto err_gro_cells_destroy;
+
 	return 0;
 
+err_gro_cells_destroy:
+	gro_cells_destroy(&vxlan->gro_cells);
 err_free_percpu:
 	free_percpu(dev->tstats);
 err_vnigroup_uninit:
@@ -2904,6 +2910,8 @@ static void vxlan_uninit(struct net_device *dev)
 {
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 
+	vxlan_mdb_fini(vxlan);
+
 	if (vxlan->cfg.flags & VXLAN_F_VNIFILTER)
 		vxlan_vnigroup_uninit(vxlan);
 
diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
new file mode 100644
index 000000000000..079741da2599
--- /dev/null
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -0,0 +1,1363 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/if_bridge.h>
+#include <linux/in.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/netlink.h>
+#include <linux/rhashtable.h>
+#include <linux/rhashtable-types.h>
+#include <linux/rtnetlink.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/netlink.h>
+#include <net/vxlan.h>
+
+#include "vxlan_private.h"
+
+struct vxlan_mdb_entry_key {
+	union vxlan_addr src;
+	union vxlan_addr dst;
+	__be32 vni;
+};
+
+struct vxlan_mdb_entry {
+	struct rhash_head rhnode;
+	struct list_head remotes;
+	struct vxlan_mdb_entry_key key;
+	struct hlist_node mdb_node;
+	struct rcu_head rcu;
+};
+
+#define VXLAN_MDB_REMOTE_F_BLOCKED	BIT(0)
+
+struct vxlan_mdb_remote {
+	struct list_head list;
+	struct vxlan_rdst __rcu *rd;
+	u8 flags;
+	u8 filter_mode;
+	u8 rt_protocol;
+	struct hlist_head src_list;
+	struct rcu_head rcu;
+};
+
+#define VXLAN_SGRP_F_DELETE	BIT(0)
+
+struct vxlan_mdb_src_entry {
+	struct hlist_node node;
+	union vxlan_addr addr;
+	u8 flags;
+};
+
+struct vxlan_mdb_dump_ctx {
+	long reserved;
+	long entry_idx;
+	long remote_idx;
+};
+
+struct vxlan_mdb_config_src_entry {
+	union vxlan_addr addr;
+	struct list_head node;
+};
+
+struct vxlan_mdb_config {
+	struct vxlan_dev *vxlan;
+	struct vxlan_mdb_entry_key group;
+	struct list_head src_list;
+	union vxlan_addr remote_ip;
+	u32 remote_ifindex;
+	__be32 remote_vni;
+	__be16 remote_port;
+	u16 nlflags;
+	u8 flags;
+	u8 filter_mode;
+	u8 rt_protocol;
+};
+
+static const struct rhashtable_params vxlan_mdb_rht_params = {
+	.head_offset = offsetof(struct vxlan_mdb_entry, rhnode),
+	.key_offset = offsetof(struct vxlan_mdb_entry, key),
+	.key_len = sizeof(struct vxlan_mdb_entry_key),
+	.automatic_shrinking = true,
+};
+
+static int __vxlan_mdb_add(const struct vxlan_mdb_config *cfg,
+			   struct netlink_ext_ack *extack);
+static int __vxlan_mdb_del(const struct vxlan_mdb_config *cfg,
+			   struct netlink_ext_ack *extack);
+
+static void vxlan_br_mdb_entry_fill(const struct vxlan_dev *vxlan,
+				    const struct vxlan_mdb_entry *mdb_entry,
+				    const struct vxlan_mdb_remote *remote,
+				    struct br_mdb_entry *e)
+{
+	const union vxlan_addr *dst = &mdb_entry->key.dst;
+
+	memset(e, 0, sizeof(*e));
+	e->ifindex = vxlan->dev->ifindex;
+	e->state = MDB_PERMANENT;
+
+	if (remote->flags & VXLAN_MDB_REMOTE_F_BLOCKED)
+		e->flags |= MDB_FLAGS_BLOCKED;
+
+	switch (dst->sa.sa_family) {
+	case AF_INET:
+		e->addr.u.ip4 = dst->sin.sin_addr.s_addr;
+		e->addr.proto = htons(ETH_P_IP);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		e->addr.u.ip6 = dst->sin6.sin6_addr;
+		e->addr.proto = htons(ETH_P_IPV6);
+		break;
+#endif
+	}
+}
+
+static int vxlan_mdb_entry_info_fill_srcs(struct sk_buff *skb,
+					  const struct vxlan_mdb_remote *remote)
+{
+	struct vxlan_mdb_src_entry *ent;
+	struct nlattr *nest;
+
+	if (hlist_empty(&remote->src_list))
+		return 0;
+
+	nest = nla_nest_start(skb, MDBA_MDB_EATTR_SRC_LIST);
+	if (!nest)
+		return -EMSGSIZE;
+
+	hlist_for_each_entry(ent, &remote->src_list, node) {
+		struct nlattr *nest_ent;
+
+		nest_ent = nla_nest_start(skb, MDBA_MDB_SRCLIST_ENTRY);
+		if (!nest_ent)
+			goto out_cancel_err;
+
+		if (vxlan_nla_put_addr(skb, MDBA_MDB_SRCATTR_ADDRESS,
+				       &ent->addr) ||
+		    nla_put_u32(skb, MDBA_MDB_SRCATTR_TIMER, 0))
+			goto out_cancel_err;
+
+		nla_nest_end(skb, nest_ent);
+	}
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+out_cancel_err:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int vxlan_mdb_entry_info_fill(const struct vxlan_dev *vxlan,
+				     struct sk_buff *skb,
+				     const struct vxlan_mdb_entry *mdb_entry,
+				     const struct vxlan_mdb_remote *remote)
+{
+	struct vxlan_rdst *rd = rtnl_dereference(remote->rd);
+	struct br_mdb_entry e;
+	struct nlattr *nest;
+
+	nest = nla_nest_start_noflag(skb, MDBA_MDB_ENTRY_INFO);
+	if (!nest)
+		return -EMSGSIZE;
+
+	vxlan_br_mdb_entry_fill(vxlan, mdb_entry, remote, &e);
+
+	if (nla_put_nohdr(skb, sizeof(e), &e) ||
+	    nla_put_u32(skb, MDBA_MDB_EATTR_TIMER, 0))
+		goto nest_err;
+
+	if (!vxlan_addr_any(&mdb_entry->key.src) &&
+	    vxlan_nla_put_addr(skb, MDBA_MDB_EATTR_SOURCE, &mdb_entry->key.src))
+		goto nest_err;
+
+	if (nla_put_u8(skb, MDBA_MDB_EATTR_RTPROT, remote->rt_protocol) ||
+	    nla_put_u8(skb, MDBA_MDB_EATTR_GROUP_MODE, remote->filter_mode) ||
+	    vxlan_mdb_entry_info_fill_srcs(skb, remote) ||
+	    vxlan_nla_put_addr(skb, MDBA_MDB_EATTR_DST, &rd->remote_ip))
+		goto nest_err;
+
+	if (rd->remote_port && rd->remote_port != vxlan->cfg.dst_port &&
+	    nla_put_u16(skb, MDBA_MDB_EATTR_DST_PORT,
+			be16_to_cpu(rd->remote_port)))
+		goto nest_err;
+
+	if (rd->remote_vni != vxlan->default_dst.remote_vni &&
+	    nla_put_u32(skb, MDBA_MDB_EATTR_VNI, be32_to_cpu(rd->remote_vni)))
+		goto nest_err;
+
+	if (rd->remote_ifindex &&
+	    nla_put_u32(skb, MDBA_MDB_EATTR_IFINDEX, rd->remote_ifindex))
+		goto nest_err;
+
+	if ((vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA) &&
+	    mdb_entry->key.vni && nla_put_u32(skb, MDBA_MDB_EATTR_SRC_VNI,
+					      be32_to_cpu(mdb_entry->key.vni)))
+		goto nest_err;
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+nest_err:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int vxlan_mdb_entry_fill(const struct vxlan_dev *vxlan,
+				struct sk_buff *skb,
+				struct vxlan_mdb_dump_ctx *ctx,
+				const struct vxlan_mdb_entry *mdb_entry)
+{
+	int remote_idx = 0, s_remote_idx = ctx->remote_idx;
+	struct vxlan_mdb_remote *remote;
+	struct nlattr *nest;
+	int err = 0;
+
+	nest = nla_nest_start_noflag(skb, MDBA_MDB_ENTRY);
+	if (!nest)
+		return -EMSGSIZE;
+
+	list_for_each_entry(remote, &mdb_entry->remotes, list) {
+		if (remote_idx < s_remote_idx)
+			goto skip;
+
+		err = vxlan_mdb_entry_info_fill(vxlan, skb, mdb_entry, remote);
+		if (err)
+			break;
+skip:
+		remote_idx++;
+	}
+
+	ctx->remote_idx = err ? remote_idx : 0;
+	nla_nest_end(skb, nest);
+	return err;
+}
+
+static int vxlan_mdb_fill(const struct vxlan_dev *vxlan, struct sk_buff *skb,
+			  struct vxlan_mdb_dump_ctx *ctx)
+{
+	int entry_idx = 0, s_entry_idx = ctx->entry_idx;
+	struct vxlan_mdb_entry *mdb_entry;
+	struct nlattr *nest;
+	int err = 0;
+
+	nest = nla_nest_start_noflag(skb, MDBA_MDB);
+	if (!nest)
+		return -EMSGSIZE;
+
+	hlist_for_each_entry(mdb_entry, &vxlan->mdb_list, mdb_node) {
+		if (entry_idx < s_entry_idx)
+			goto skip;
+
+		err = vxlan_mdb_entry_fill(vxlan, skb, ctx, mdb_entry);
+		if (err)
+			break;
+skip:
+		entry_idx++;
+	}
+
+	ctx->entry_idx = err ? entry_idx : 0;
+	nla_nest_end(skb, nest);
+	return err;
+}
+
+int vxlan_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+		   struct netlink_callback *cb)
+{
+	struct vxlan_mdb_dump_ctx *ctx = (void *)cb->ctx;
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+	struct br_port_msg *bpm;
+	struct nlmsghdr *nlh;
+	int err;
+
+	ASSERT_RTNL();
+
+	NL_ASSERT_DUMP_CTX_FITS(struct vxlan_mdb_dump_ctx);
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+			cb->nlh->nlmsg_seq, RTM_NEWMDB, sizeof(*bpm),
+			NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	bpm = nlmsg_data(nlh);
+	memset(bpm, 0, sizeof(*bpm));
+	bpm->family = AF_BRIDGE;
+	bpm->ifindex = dev->ifindex;
+
+	err = vxlan_mdb_fill(vxlan, skb, ctx);
+
+	nlmsg_end(skb, nlh);
+
+	cb->seq = vxlan->mdb_seq;
+	nl_dump_check_consistent(cb, nlh);
+
+	return err;
+}
+
+static const struct nla_policy
+vxlan_mdbe_src_list_entry_pol[MDBE_SRCATTR_MAX + 1] = {
+	[MDBE_SRCATTR_ADDRESS] = NLA_POLICY_RANGE(NLA_BINARY,
+						  sizeof(struct in_addr),
+						  sizeof(struct in6_addr)),
+};
+
+static const struct nla_policy
+vxlan_mdbe_src_list_pol[MDBE_SRC_LIST_MAX + 1] = {
+	[MDBE_SRC_LIST_ENTRY] = NLA_POLICY_NESTED(vxlan_mdbe_src_list_entry_pol),
+};
+
+static struct netlink_range_validation vni_range = {
+	.max = VXLAN_N_VID - 1,
+};
+
+static const struct nla_policy vxlan_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
+	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
+					      sizeof(struct in_addr),
+					      sizeof(struct in6_addr)),
+	[MDBE_ATTR_GROUP_MODE] = NLA_POLICY_RANGE(NLA_U8, MCAST_EXCLUDE,
+						  MCAST_INCLUDE),
+	[MDBE_ATTR_SRC_LIST] = NLA_POLICY_NESTED(vxlan_mdbe_src_list_pol),
+	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
+	[MDBE_ATTR_DST] = NLA_POLICY_RANGE(NLA_BINARY,
+					   sizeof(struct in_addr),
+					   sizeof(struct in6_addr)),
+	[MDBE_ATTR_DST_PORT] = { .type = NLA_U16 },
+	[MDBE_ATTR_VNI] = NLA_POLICY_FULL_RANGE(NLA_U32, &vni_range),
+	[MDBE_ATTR_IFINDEX] = NLA_POLICY_MIN(NLA_S32, 1),
+	[MDBE_ATTR_SRC_VNI] = NLA_POLICY_FULL_RANGE(NLA_U32, &vni_range),
+};
+
+static bool vxlan_mdb_is_valid_source(const struct nlattr *attr, __be16 proto,
+				      struct netlink_ext_ack *extack)
+{
+	switch (proto) {
+	case htons(ETH_P_IP):
+		if (nla_len(attr) != sizeof(struct in_addr)) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv4 invalid source address length");
+			return false;
+		}
+		if (ipv4_is_multicast(nla_get_in_addr(attr))) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv4 multicast source address is not allowed");
+			return false;
+		}
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6): {
+		struct in6_addr src;
+
+		if (nla_len(attr) != sizeof(struct in6_addr)) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv6 invalid source address length");
+			return false;
+		}
+		src = nla_get_in6_addr(attr);
+		if (ipv6_addr_is_multicast(&src)) {
+			NL_SET_ERR_MSG_MOD(extack, "IPv6 multicast source address is not allowed");
+			return false;
+		}
+		break;
+	}
+#endif
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Invalid protocol used with source address");
+		return false;
+	}
+
+	return true;
+}
+
+static void vxlan_mdb_config_group_set(struct vxlan_mdb_config *cfg,
+				       const struct br_mdb_entry *entry,
+				       const struct nlattr *source_attr)
+{
+	struct vxlan_mdb_entry_key *group = &cfg->group;
+
+	switch (entry->addr.proto) {
+	case htons(ETH_P_IP):
+		group->dst.sa.sa_family = AF_INET;
+		group->dst.sin.sin_addr.s_addr = entry->addr.u.ip4;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		group->dst.sa.sa_family = AF_INET6;
+		group->dst.sin6.sin6_addr = entry->addr.u.ip6;
+		break;
+#endif
+	}
+
+	if (source_attr)
+		vxlan_nla_get_addr(&group->src, source_attr);
+}
+
+static bool vxlan_mdb_is_star_g(const struct vxlan_mdb_entry_key *group)
+{
+	return !vxlan_addr_any(&group->dst) && vxlan_addr_any(&group->src);
+}
+
+static bool vxlan_mdb_is_sg(const struct vxlan_mdb_entry_key *group)
+{
+	return !vxlan_addr_any(&group->dst) && !vxlan_addr_any(&group->src);
+}
+
+static bool vxlan_mdb_is_all_zeros(const struct vxlan_mdb_entry_key *group)
+{
+	return vxlan_addr_any(&group->dst) && vxlan_addr_any(&group->src);
+}
+
+static int vxlan_mdb_config_src_entry_init(struct vxlan_mdb_config *cfg,
+					   __be16 proto,
+					   const struct nlattr *src_entry,
+					   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBE_SRCATTR_MAX + 1];
+	struct vxlan_mdb_config_src_entry *src;
+	int err;
+
+	err = nla_parse_nested(tb, MDBE_SRCATTR_MAX, src_entry,
+			       vxlan_mdbe_src_list_entry_pol, extack);
+	if (err)
+		return err;
+
+	if (NL_REQ_ATTR_CHECK(extack, src_entry, tb, MDBE_SRCATTR_ADDRESS))
+		return -EINVAL;
+
+	if (!vxlan_mdb_is_valid_source(tb[MDBE_SRCATTR_ADDRESS], proto,
+				       extack))
+		return -EINVAL;
+
+	src = kzalloc(sizeof(*src), GFP_KERNEL);
+	if (!src)
+		return -ENOMEM;
+
+	err = vxlan_nla_get_addr(&src->addr, tb[MDBE_SRCATTR_ADDRESS]);
+	if (err)
+		goto err_free_src;
+
+	list_add_tail(&src->node, &cfg->src_list);
+
+	return 0;
+
+err_free_src:
+	kfree(src);
+	return err;
+}
+
+static void
+vxlan_mdb_config_src_entry_fini(struct vxlan_mdb_config_src_entry *src)
+{
+	list_del(&src->node);
+	kfree(src);
+}
+
+static int vxlan_mdb_config_src_list_init(struct vxlan_mdb_config *cfg,
+					  __be16 proto,
+					  const struct nlattr *src_list,
+					  struct netlink_ext_ack *extack)
+{
+	struct vxlan_mdb_config_src_entry *src, *tmp;
+	struct nlattr *src_entry;
+	int rem, err;
+
+	nla_for_each_nested(src_entry, src_list, rem) {
+		err = vxlan_mdb_config_src_entry_init(cfg, proto, src_entry,
+						      extack);
+		if (err)
+			goto err_src_entry_init;
+	}
+
+	return 0;
+
+err_src_entry_init:
+	list_for_each_entry_safe_reverse(src, tmp, &cfg->src_list, node)
+		vxlan_mdb_config_src_entry_fini(src);
+	return err;
+}
+
+static void vxlan_mdb_config_src_list_fini(struct vxlan_mdb_config *cfg)
+{
+	struct vxlan_mdb_config_src_entry *src, *tmp;
+
+	list_for_each_entry_safe_reverse(src, tmp, &cfg->src_list, node)
+		vxlan_mdb_config_src_entry_fini(src);
+}
+
+static int vxlan_mdb_config_attrs_init(struct vxlan_mdb_config *cfg,
+				       const struct br_mdb_entry *entry,
+				       const struct nlattr *set_attrs,
+				       struct netlink_ext_ack *extack)
+{
+	struct nlattr *mdbe_attrs[MDBE_ATTR_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(mdbe_attrs, MDBE_ATTR_MAX, set_attrs,
+			       vxlan_mdbe_attrs_pol, extack);
+	if (err)
+		return err;
+
+	if (NL_REQ_ATTR_CHECK(extack, set_attrs, mdbe_attrs, MDBE_ATTR_DST)) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing remote destination IP address");
+		return -EINVAL;
+	}
+
+	if (mdbe_attrs[MDBE_ATTR_SOURCE] &&
+	    !vxlan_mdb_is_valid_source(mdbe_attrs[MDBE_ATTR_SOURCE],
+				       entry->addr.proto, extack))
+		return -EINVAL;
+
+	vxlan_mdb_config_group_set(cfg, entry, mdbe_attrs[MDBE_ATTR_SOURCE]);
+
+	/* rtnetlink code only validates that IPv4 group address is
+	 * multicast.
+	 */
+	if (!vxlan_addr_is_multicast(&cfg->group.dst) &&
+	    !vxlan_addr_any(&cfg->group.dst)) {
+		NL_SET_ERR_MSG_MOD(extack, "Group address is not multicast");
+		return -EINVAL;
+	}
+
+	if (vxlan_mdb_is_all_zeros(&cfg->group) &&
+	    mdbe_attrs[MDBE_ATTR_SOURCE]) {
+		NL_SET_ERR_MSG_MOD(extack, "Source cannot be specified for the all-zeros entry");
+		return -EINVAL;
+	}
+
+	if (vxlan_mdb_is_sg(&cfg->group))
+		cfg->filter_mode = MCAST_INCLUDE;
+
+	if (mdbe_attrs[MDBE_ATTR_GROUP_MODE]) {
+		if (!vxlan_mdb_is_star_g(&cfg->group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Filter mode can only be set for (*, G) entries");
+			return -EINVAL;
+		}
+		cfg->filter_mode = nla_get_u8(mdbe_attrs[MDBE_ATTR_GROUP_MODE]);
+	}
+
+	if (mdbe_attrs[MDBE_ATTR_SRC_LIST]) {
+		if (!vxlan_mdb_is_star_g(&cfg->group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list can only be set for (*, G) entries");
+			return -EINVAL;
+		}
+		if (!mdbe_attrs[MDBE_ATTR_GROUP_MODE]) {
+			NL_SET_ERR_MSG_MOD(extack, "Source list cannot be set without filter mode");
+			return -EINVAL;
+		}
+		err = vxlan_mdb_config_src_list_init(cfg, entry->addr.proto,
+						     mdbe_attrs[MDBE_ATTR_SRC_LIST],
+						     extack);
+		if (err)
+			return err;
+	}
+
+	if (vxlan_mdb_is_star_g(&cfg->group) && list_empty(&cfg->src_list) &&
+	    cfg->filter_mode == MCAST_INCLUDE) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot add (*, G) INCLUDE with an empty source list");
+		return -EINVAL;
+	}
+
+	if (mdbe_attrs[MDBE_ATTR_RTPROT])
+		cfg->rt_protocol = nla_get_u8(mdbe_attrs[MDBE_ATTR_RTPROT]);
+
+	err = vxlan_nla_get_addr(&cfg->remote_ip, mdbe_attrs[MDBE_ATTR_DST]);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid remote destination address");
+		goto err_src_list_fini;
+	}
+
+	if (mdbe_attrs[MDBE_ATTR_DST_PORT])
+		cfg->remote_port =
+			cpu_to_be16(nla_get_u16(mdbe_attrs[MDBE_ATTR_DST_PORT]));
+
+	if (mdbe_attrs[MDBE_ATTR_VNI])
+		cfg->remote_vni =
+			cpu_to_be32(nla_get_u32(mdbe_attrs[MDBE_ATTR_VNI]));
+
+	if (mdbe_attrs[MDBE_ATTR_IFINDEX]) {
+		cfg->remote_ifindex =
+			nla_get_s32(mdbe_attrs[MDBE_ATTR_IFINDEX]);
+		if (!__dev_get_by_index(cfg->vxlan->net, cfg->remote_ifindex)) {
+			NL_SET_ERR_MSG_MOD(extack, "Outgoing interface not found");
+			err = -EINVAL;
+			goto err_src_list_fini;
+		}
+	}
+
+	if (mdbe_attrs[MDBE_ATTR_SRC_VNI])
+		cfg->group.vni =
+			cpu_to_be32(nla_get_u32(mdbe_attrs[MDBE_ATTR_SRC_VNI]));
+
+	return 0;
+
+err_src_list_fini:
+	vxlan_mdb_config_src_list_fini(cfg);
+	return err;
+}
+
+static int vxlan_mdb_config_init(struct vxlan_mdb_config *cfg,
+				 struct net_device *dev, struct nlattr *tb[],
+				 u16 nlmsg_flags,
+				 struct netlink_ext_ack *extack)
+{
+	struct br_mdb_entry *entry = nla_data(tb[MDBA_SET_ENTRY]);
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+
+	memset(cfg, 0, sizeof(*cfg));
+	cfg->vxlan = vxlan;
+	cfg->group.vni = vxlan->default_dst.remote_vni;
+	INIT_LIST_HEAD(&cfg->src_list);
+	cfg->nlflags = nlmsg_flags;
+	cfg->filter_mode = MCAST_EXCLUDE;
+	cfg->rt_protocol = RTPROT_STATIC;
+	cfg->remote_vni = vxlan->default_dst.remote_vni;
+	cfg->remote_port = vxlan->cfg.dst_port;
+
+	if (entry->ifindex != dev->ifindex) {
+		NL_SET_ERR_MSG_MOD(extack, "Port net device must be the VXLAN net device");
+		return -EINVAL;
+	}
+
+	/* State is not part of the entry key and can be ignored on deletion
+	 * requests.
+	 */
+	if ((nlmsg_flags & (NLM_F_CREATE | NLM_F_REPLACE)) &&
+	    entry->state != MDB_PERMANENT) {
+		NL_SET_ERR_MSG_MOD(extack, "MDB entry must be permanent");
+		return -EINVAL;
+	}
+
+	if (entry->flags) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MDB entry flags");
+		return -EINVAL;
+	}
+
+	if (entry->vid) {
+		NL_SET_ERR_MSG_MOD(extack, "VID must not be specified");
+		return -EINVAL;
+	}
+
+	if (entry->addr.proto != htons(ETH_P_IP) &&
+	    entry->addr.proto != htons(ETH_P_IPV6)) {
+		NL_SET_ERR_MSG_MOD(extack, "Group address must be an IPv4 / IPv6 address");
+		return -EINVAL;
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY_ATTRS)) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY_ATTRS attribute");
+		return -EINVAL;
+	}
+
+	return vxlan_mdb_config_attrs_init(cfg, entry, tb[MDBA_SET_ENTRY_ATTRS],
+					   extack);
+}
+
+static void vxlan_mdb_config_fini(struct vxlan_mdb_config *cfg)
+{
+	vxlan_mdb_config_src_list_fini(cfg);
+}
+
+static struct vxlan_mdb_entry *
+vxlan_mdb_entry_lookup(struct vxlan_dev *vxlan,
+		       const struct vxlan_mdb_entry_key *group)
+{
+	return rhashtable_lookup_fast(&vxlan->mdb_tbl, group,
+				      vxlan_mdb_rht_params);
+}
+
+static struct vxlan_mdb_remote *
+vxlan_mdb_remote_lookup(const struct vxlan_mdb_entry *mdb_entry,
+			const union vxlan_addr *addr)
+{
+	struct vxlan_mdb_remote *remote;
+
+	list_for_each_entry(remote, &mdb_entry->remotes, list) {
+		struct vxlan_rdst *rd = rtnl_dereference(remote->rd);
+
+		if (vxlan_addr_equal(addr, &rd->remote_ip))
+			return remote;
+	}
+
+	return NULL;
+}
+
+static void vxlan_mdb_rdst_free(struct rcu_head *head)
+{
+	struct vxlan_rdst *rd = container_of(head, struct vxlan_rdst, rcu);
+
+	dst_cache_destroy(&rd->dst_cache);
+	kfree(rd);
+}
+
+static int vxlan_mdb_remote_rdst_init(const struct vxlan_mdb_config *cfg,
+				      struct vxlan_mdb_remote *remote)
+{
+	struct vxlan_rdst *rd;
+	int err;
+
+	rd = kzalloc(sizeof(*rd), GFP_KERNEL);
+	if (!rd)
+		return -ENOMEM;
+
+	err = dst_cache_init(&rd->dst_cache, GFP_KERNEL);
+	if (err)
+		goto err_free_rdst;
+
+	rd->remote_ip = cfg->remote_ip;
+	rd->remote_port = cfg->remote_port;
+	rd->remote_vni = cfg->remote_vni;
+	rd->remote_ifindex = cfg->remote_ifindex;
+	rcu_assign_pointer(remote->rd, rd);
+
+	return 0;
+
+err_free_rdst:
+	kfree(rd);
+	return err;
+}
+
+static void vxlan_mdb_remote_rdst_fini(struct vxlan_rdst *rd)
+{
+	call_rcu(&rd->rcu, vxlan_mdb_rdst_free);
+}
+
+static int vxlan_mdb_remote_init(const struct vxlan_mdb_config *cfg,
+				 struct vxlan_mdb_remote *remote)
+{
+	int err;
+
+	err = vxlan_mdb_remote_rdst_init(cfg, remote);
+	if (err)
+		return err;
+
+	remote->flags = cfg->flags;
+	remote->filter_mode = cfg->filter_mode;
+	remote->rt_protocol = cfg->rt_protocol;
+	INIT_HLIST_HEAD(&remote->src_list);
+
+	return 0;
+}
+
+static void vxlan_mdb_remote_fini(struct vxlan_dev *vxlan,
+				  struct vxlan_mdb_remote *remote)
+{
+	WARN_ON_ONCE(!hlist_empty(&remote->src_list));
+	vxlan_mdb_remote_rdst_fini(rtnl_dereference(remote->rd));
+}
+
+static struct vxlan_mdb_src_entry *
+vxlan_mdb_remote_src_entry_lookup(const struct vxlan_mdb_remote *remote,
+				  const union vxlan_addr *addr)
+{
+	struct vxlan_mdb_src_entry *ent;
+
+	hlist_for_each_entry(ent, &remote->src_list, node) {
+		if (vxlan_addr_equal(&ent->addr, addr))
+			return ent;
+	}
+
+	return NULL;
+}
+
+static struct vxlan_mdb_src_entry *
+vxlan_mdb_remote_src_entry_add(struct vxlan_mdb_remote *remote,
+			       const union vxlan_addr *addr)
+{
+	struct vxlan_mdb_src_entry *ent;
+
+	ent = kzalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return NULL;
+
+	ent->addr = *addr;
+	hlist_add_head(&ent->node, &remote->src_list);
+
+	return ent;
+}
+
+static void
+vxlan_mdb_remote_src_entry_del(struct vxlan_mdb_src_entry *ent)
+{
+	hlist_del(&ent->node);
+	kfree(ent);
+}
+
+static int
+vxlan_mdb_remote_src_fwd_add(const struct vxlan_mdb_config *cfg,
+			     const union vxlan_addr *addr,
+			     struct netlink_ext_ack *extack)
+{
+	struct vxlan_mdb_config sg_cfg;
+
+	memset(&sg_cfg, 0, sizeof(sg_cfg));
+	sg_cfg.vxlan = cfg->vxlan;
+	sg_cfg.group.src = *addr;
+	sg_cfg.group.dst = cfg->group.dst;
+	sg_cfg.group.vni = cfg->group.vni;
+	INIT_LIST_HEAD(&sg_cfg.src_list);
+	sg_cfg.remote_ip = cfg->remote_ip;
+	sg_cfg.remote_ifindex = cfg->remote_ifindex;
+	sg_cfg.remote_vni = cfg->remote_vni;
+	sg_cfg.remote_port = cfg->remote_port;
+	sg_cfg.nlflags = cfg->nlflags;
+	sg_cfg.filter_mode = MCAST_INCLUDE;
+	if (cfg->filter_mode == MCAST_EXCLUDE)
+		sg_cfg.flags = VXLAN_MDB_REMOTE_F_BLOCKED;
+	sg_cfg.rt_protocol = cfg->rt_protocol;
+
+	return __vxlan_mdb_add(&sg_cfg, extack);
+}
+
+static void
+vxlan_mdb_remote_src_fwd_del(struct vxlan_dev *vxlan,
+			     const struct vxlan_mdb_entry_key *group,
+			     const struct vxlan_mdb_remote *remote,
+			     const union vxlan_addr *addr)
+{
+	struct vxlan_rdst *rd = rtnl_dereference(remote->rd);
+	struct vxlan_mdb_config sg_cfg;
+
+	memset(&sg_cfg, 0, sizeof(sg_cfg));
+	sg_cfg.vxlan = vxlan;
+	sg_cfg.group.src = *addr;
+	sg_cfg.group.dst = group->dst;
+	sg_cfg.group.vni = group->vni;
+	INIT_LIST_HEAD(&sg_cfg.src_list);
+	sg_cfg.remote_ip = rd->remote_ip;
+
+	__vxlan_mdb_del(&sg_cfg, NULL);
+}
+
+static int
+vxlan_mdb_remote_src_add(const struct vxlan_mdb_config *cfg,
+			 struct vxlan_mdb_remote *remote,
+			 const struct vxlan_mdb_config_src_entry *src,
+			 struct netlink_ext_ack *extack)
+{
+	struct vxlan_mdb_src_entry *ent;
+	int err;
+
+	ent = vxlan_mdb_remote_src_entry_lookup(remote, &src->addr);
+	if (!ent) {
+		ent = vxlan_mdb_remote_src_entry_add(remote, &src->addr);
+		if (!ent)
+			return -ENOMEM;
+	} else if (!(cfg->nlflags & NLM_F_REPLACE)) {
+		NL_SET_ERR_MSG_MOD(extack, "Source entry already exists");
+		return -EEXIST;
+	}
+
+	err = vxlan_mdb_remote_src_fwd_add(cfg, &ent->addr, extack);
+	if (err)
+		goto err_src_del;
+
+	/* Clear flags in case source entry was marked for deletion as part of
+	 * replace flow.
+	 */
+	ent->flags = 0;
+
+	return 0;
+
+err_src_del:
+	vxlan_mdb_remote_src_entry_del(ent);
+	return err;
+}
+
+static void vxlan_mdb_remote_src_del(struct vxlan_dev *vxlan,
+				     const struct vxlan_mdb_entry_key *group,
+				     const struct vxlan_mdb_remote *remote,
+				     struct vxlan_mdb_src_entry *ent)
+{
+	vxlan_mdb_remote_src_fwd_del(vxlan, group, remote, &ent->addr);
+	vxlan_mdb_remote_src_entry_del(ent);
+}
+
+static int vxlan_mdb_remote_srcs_add(const struct vxlan_mdb_config *cfg,
+				     struct vxlan_mdb_remote *remote,
+				     struct netlink_ext_ack *extack)
+{
+	struct vxlan_mdb_config_src_entry *src;
+	struct vxlan_mdb_src_entry *ent;
+	struct hlist_node *tmp;
+	int err;
+
+	list_for_each_entry(src, &cfg->src_list, node) {
+		err = vxlan_mdb_remote_src_add(cfg, remote, src, extack);
+		if (err)
+			goto err_src_del;
+	}
+
+	return 0;
+
+err_src_del:
+	hlist_for_each_entry_safe(ent, tmp, &remote->src_list, node)
+		vxlan_mdb_remote_src_del(cfg->vxlan, &cfg->group, remote, ent);
+	return err;
+}
+
+static void vxlan_mdb_remote_srcs_del(struct vxlan_dev *vxlan,
+				      const struct vxlan_mdb_entry_key *group,
+				      struct vxlan_mdb_remote *remote)
+{
+	struct vxlan_mdb_src_entry *ent;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(ent, tmp, &remote->src_list, node)
+		vxlan_mdb_remote_src_del(vxlan, group, remote, ent);
+}
+
+static size_t
+vxlan_mdb_nlmsg_src_list_size(const struct vxlan_mdb_entry_key *group,
+			      const struct vxlan_mdb_remote *remote)
+{
+	struct vxlan_mdb_src_entry *ent;
+	size_t nlmsg_size;
+
+	if (hlist_empty(&remote->src_list))
+		return 0;
+
+	/* MDBA_MDB_EATTR_SRC_LIST */
+	nlmsg_size = nla_total_size(0);
+
+	hlist_for_each_entry(ent, &remote->src_list, node) {
+			      /* MDBA_MDB_SRCLIST_ENTRY */
+		nlmsg_size += nla_total_size(0) +
+			      /* MDBA_MDB_SRCATTR_ADDRESS */
+			      nla_total_size(vxlan_addr_size(&group->dst)) +
+			      /* MDBA_MDB_SRCATTR_TIMER */
+			      nla_total_size(sizeof(u8));
+	}
+
+	return nlmsg_size;
+}
+
+static size_t vxlan_mdb_nlmsg_size(const struct vxlan_dev *vxlan,
+				   const struct vxlan_mdb_entry *mdb_entry,
+				   const struct vxlan_mdb_remote *remote)
+{
+	const struct vxlan_mdb_entry_key *group = &mdb_entry->key;
+	struct vxlan_rdst *rd = rtnl_dereference(remote->rd);
+	size_t nlmsg_size;
+
+	nlmsg_size = NLMSG_ALIGN(sizeof(struct br_port_msg)) +
+		     /* MDBA_MDB */
+		     nla_total_size(0) +
+		     /* MDBA_MDB_ENTRY */
+		     nla_total_size(0) +
+		     /* MDBA_MDB_ENTRY_INFO */
+		     nla_total_size(sizeof(struct br_mdb_entry)) +
+		     /* MDBA_MDB_EATTR_TIMER */
+		     nla_total_size(sizeof(u32));
+	/* MDBA_MDB_EATTR_SOURCE */
+	if (vxlan_mdb_is_sg(group))
+		nlmsg_size += nla_total_size(vxlan_addr_size(&group->dst));
+	/* MDBA_MDB_EATTR_RTPROT */
+	nlmsg_size += nla_total_size(sizeof(u8));
+	/* MDBA_MDB_EATTR_SRC_LIST */
+	nlmsg_size += vxlan_mdb_nlmsg_src_list_size(group, remote);
+	/* MDBA_MDB_EATTR_GROUP_MODE */
+	nlmsg_size += nla_total_size(sizeof(u8));
+	/* MDBA_MDB_EATTR_DST */
+	nlmsg_size += nla_total_size(vxlan_addr_size(&rd->remote_ip));
+	/* MDBA_MDB_EATTR_DST_PORT */
+	if (rd->remote_port && rd->remote_port != vxlan->cfg.dst_port)
+		nlmsg_size += nla_total_size(sizeof(u16));
+	/* MDBA_MDB_EATTR_VNI */
+	if (rd->remote_vni != vxlan->default_dst.remote_vni)
+		nlmsg_size += nla_total_size(sizeof(u32));
+	/* MDBA_MDB_EATTR_IFINDEX */
+	if (rd->remote_ifindex)
+		nlmsg_size += nla_total_size(sizeof(u32));
+	/* MDBA_MDB_EATTR_SRC_VNI */
+	if ((vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA) && group->vni)
+		nlmsg_size += nla_total_size(sizeof(u32));
+
+	return nlmsg_size;
+}
+
+static int vxlan_mdb_nlmsg_fill(const struct vxlan_dev *vxlan,
+				struct sk_buff *skb,
+				const struct vxlan_mdb_entry *mdb_entry,
+				const struct vxlan_mdb_remote *remote,
+				int type)
+{
+	struct nlattr *mdb_nest, *mdb_entry_nest;
+	struct br_port_msg *bpm;
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put(skb, 0, 0, type, sizeof(*bpm), 0);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	bpm = nlmsg_data(nlh);
+	memset(bpm, 0, sizeof(*bpm));
+	bpm->family  = AF_BRIDGE;
+	bpm->ifindex = vxlan->dev->ifindex;
+
+	mdb_nest = nla_nest_start_noflag(skb, MDBA_MDB);
+	if (!mdb_nest)
+		goto cancel;
+	mdb_entry_nest = nla_nest_start_noflag(skb, MDBA_MDB_ENTRY);
+	if (!mdb_entry_nest)
+		goto cancel;
+
+	if (vxlan_mdb_entry_info_fill(vxlan, skb, mdb_entry, remote))
+		goto cancel;
+
+	nla_nest_end(skb, mdb_entry_nest);
+	nla_nest_end(skb, mdb_nest);
+	nlmsg_end(skb, nlh);
+
+	return 0;
+
+cancel:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
+static void vxlan_mdb_remote_notify(const struct vxlan_dev *vxlan,
+				    const struct vxlan_mdb_entry *mdb_entry,
+				    const struct vxlan_mdb_remote *remote,
+				    int type)
+{
+	struct net *net = dev_net(vxlan->dev);
+	struct sk_buff *skb;
+	int err = -ENOBUFS;
+
+	skb = nlmsg_new(vxlan_mdb_nlmsg_size(vxlan, mdb_entry, remote),
+			GFP_KERNEL);
+	if (!skb)
+		goto errout;
+
+	err = vxlan_mdb_nlmsg_fill(vxlan, skb, mdb_entry, remote, type);
+	if (err) {
+		kfree_skb(skb);
+		goto errout;
+	}
+
+	rtnl_notify(skb, net, 0, RTNLGRP_MDB, NULL, GFP_KERNEL);
+	return;
+errout:
+	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
+}
+
+static int
+vxlan_mdb_remote_srcs_replace(const struct vxlan_mdb_config *cfg,
+			      const struct vxlan_mdb_entry *mdb_entry,
+			      struct vxlan_mdb_remote *remote,
+			      struct netlink_ext_ack *extack)
+{
+	struct vxlan_dev *vxlan = cfg->vxlan;
+	struct vxlan_mdb_src_entry *ent;
+	struct hlist_node *tmp;
+	int err;
+
+	hlist_for_each_entry(ent, &remote->src_list, node)
+		ent->flags |= VXLAN_SGRP_F_DELETE;
+
+	err = vxlan_mdb_remote_srcs_add(cfg, remote, extack);
+	if (err)
+		goto err_clear_delete;
+
+	hlist_for_each_entry_safe(ent, tmp, &remote->src_list, node) {
+		if (ent->flags & VXLAN_SGRP_F_DELETE)
+			vxlan_mdb_remote_src_del(vxlan, &mdb_entry->key, remote,
+						 ent);
+	}
+
+	return 0;
+
+err_clear_delete:
+	hlist_for_each_entry(ent, &remote->src_list, node)
+		ent->flags &= ~VXLAN_SGRP_F_DELETE;
+	return err;
+}
+
+static int vxlan_mdb_remote_replace(const struct vxlan_mdb_config *cfg,
+				    const struct vxlan_mdb_entry *mdb_entry,
+				    struct vxlan_mdb_remote *remote,
+				    struct netlink_ext_ack *extack)
+{
+	struct vxlan_rdst *new_rd, *old_rd = rtnl_dereference(remote->rd);
+	struct vxlan_dev *vxlan = cfg->vxlan;
+	int err;
+
+	err = vxlan_mdb_remote_rdst_init(cfg, remote);
+	if (err)
+		return err;
+	new_rd = rtnl_dereference(remote->rd);
+
+	err = vxlan_mdb_remote_srcs_replace(cfg, mdb_entry, remote, extack);
+	if (err)
+		goto err_rdst_reset;
+
+	WRITE_ONCE(remote->flags, cfg->flags);
+	WRITE_ONCE(remote->filter_mode, cfg->filter_mode);
+	remote->rt_protocol = cfg->rt_protocol;
+	vxlan_mdb_remote_notify(vxlan, mdb_entry, remote, RTM_NEWMDB);
+
+	vxlan_mdb_remote_rdst_fini(old_rd);
+
+	return 0;
+
+err_rdst_reset:
+	rcu_assign_pointer(remote->rd, old_rd);
+	vxlan_mdb_remote_rdst_fini(new_rd);
+	return err;
+}
+
+static int vxlan_mdb_remote_add(const struct vxlan_mdb_config *cfg,
+				struct vxlan_mdb_entry *mdb_entry,
+				struct netlink_ext_ack *extack)
+{
+	struct vxlan_mdb_remote *remote;
+	int err;
+
+	remote = vxlan_mdb_remote_lookup(mdb_entry, &cfg->remote_ip);
+	if (remote) {
+		if (!(cfg->nlflags & NLM_F_REPLACE)) {
+			NL_SET_ERR_MSG_MOD(extack, "Replace not specified and MDB remote entry already exists");
+			return -EEXIST;
+		}
+		return vxlan_mdb_remote_replace(cfg, mdb_entry, remote, extack);
+	}
+
+	if (!(cfg->nlflags & NLM_F_CREATE)) {
+		NL_SET_ERR_MSG_MOD(extack, "Create not specified and entry does not exist");
+		return -ENOENT;
+	}
+
+	if (!list_empty(&mdb_entry->remotes)) {
+		struct vxlan_rdst *rd;
+
+		remote = list_first_entry(&mdb_entry->remotes,
+					  struct vxlan_mdb_remote, list);
+		rd = rtnl_dereference(remote->rd);
+		if (vxlan_addr_is_multicast(&rd->remote_ip)) {
+			NL_SET_ERR_MSG_MOD(extack, "MDB entry has a multicast destination IP. Cannot add more destinations");
+			return -EINVAL;
+		}
+
+		if (vxlan_addr_is_multicast(&cfg->remote_ip)) {
+			NL_SET_ERR_MSG_MOD(extack, "Cannot add a multicast destination IP to an existing MDB entry");
+			return -EINVAL;
+		}
+	}
+
+	remote = kzalloc(sizeof(*remote), GFP_KERNEL);
+	if (!remote)
+		return -ENOMEM;
+
+	err = vxlan_mdb_remote_init(cfg, remote);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to initialize remote MDB entry");
+		goto err_free_remote;
+	}
+
+	err = vxlan_mdb_remote_srcs_add(cfg, remote, extack);
+	if (err)
+		goto err_remote_fini;
+
+	list_add_rcu(&remote->list, &mdb_entry->remotes);
+	vxlan_mdb_remote_notify(cfg->vxlan, mdb_entry, remote, RTM_NEWMDB);
+
+	return 0;
+
+err_remote_fini:
+	vxlan_mdb_remote_fini(cfg->vxlan, remote);
+err_free_remote:
+	kfree(remote);
+	return err;
+}
+
+static void vxlan_mdb_remote_del(struct vxlan_dev *vxlan,
+				 struct vxlan_mdb_entry *mdb_entry,
+				 struct vxlan_mdb_remote *remote)
+{
+	vxlan_mdb_remote_notify(vxlan, mdb_entry, remote, RTM_DELMDB);
+	list_del_rcu(&remote->list);
+	vxlan_mdb_remote_srcs_del(vxlan, &mdb_entry->key, remote);
+	vxlan_mdb_remote_fini(vxlan, remote);
+	kfree_rcu(remote, rcu);
+}
+
+static struct vxlan_mdb_entry *
+vxlan_mdb_entry_get(struct vxlan_dev *vxlan,
+		    const struct vxlan_mdb_entry_key *group)
+{
+	struct vxlan_mdb_entry *mdb_entry;
+	int err;
+
+	mdb_entry = vxlan_mdb_entry_lookup(vxlan, group);
+	if (mdb_entry)
+		return mdb_entry;
+
+	mdb_entry = kzalloc(sizeof(*mdb_entry), GFP_KERNEL);
+	if (!mdb_entry)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&mdb_entry->remotes);
+	memcpy(&mdb_entry->key, group, sizeof(mdb_entry->key));
+	hlist_add_head(&mdb_entry->mdb_node, &vxlan->mdb_list);
+
+	err = rhashtable_lookup_insert_fast(&vxlan->mdb_tbl,
+					    &mdb_entry->rhnode,
+					    vxlan_mdb_rht_params);
+	if (err)
+		goto err_free_entry;
+
+	return mdb_entry;
+
+err_free_entry:
+	hlist_del(&mdb_entry->mdb_node);
+	kfree(mdb_entry);
+	return ERR_PTR(err);
+}
+
+static void vxlan_mdb_entry_put(struct vxlan_dev *vxlan,
+				struct vxlan_mdb_entry *mdb_entry)
+{
+	if (!list_empty(&mdb_entry->remotes))
+		return;
+
+	rhashtable_remove_fast(&vxlan->mdb_tbl, &mdb_entry->rhnode,
+			       vxlan_mdb_rht_params);
+	hlist_del(&mdb_entry->mdb_node);
+	kfree_rcu(mdb_entry, rcu);
+}
+
+static int __vxlan_mdb_add(const struct vxlan_mdb_config *cfg,
+			   struct netlink_ext_ack *extack)
+{
+	struct vxlan_dev *vxlan = cfg->vxlan;
+	struct vxlan_mdb_entry *mdb_entry;
+	int err;
+
+	mdb_entry = vxlan_mdb_entry_get(vxlan, &cfg->group);
+	if (IS_ERR(mdb_entry))
+		return PTR_ERR(mdb_entry);
+
+	err = vxlan_mdb_remote_add(cfg, mdb_entry, extack);
+	if (err)
+		goto err_entry_put;
+
+	vxlan->mdb_seq++;
+
+	return 0;
+
+err_entry_put:
+	vxlan_mdb_entry_put(vxlan, mdb_entry);
+	return err;
+}
+
+static int __vxlan_mdb_del(const struct vxlan_mdb_config *cfg,
+			   struct netlink_ext_ack *extack)
+{
+	struct vxlan_dev *vxlan = cfg->vxlan;
+	struct vxlan_mdb_entry *mdb_entry;
+	struct vxlan_mdb_remote *remote;
+
+	mdb_entry = vxlan_mdb_entry_lookup(vxlan, &cfg->group);
+	if (!mdb_entry) {
+		NL_SET_ERR_MSG_MOD(extack, "Did not find MDB entry");
+		return -ENOENT;
+	}
+
+	remote = vxlan_mdb_remote_lookup(mdb_entry, &cfg->remote_ip);
+	if (!remote) {
+		NL_SET_ERR_MSG_MOD(extack, "Did not find MDB remote entry");
+		return -ENOENT;
+	}
+
+	vxlan_mdb_remote_del(vxlan, mdb_entry, remote);
+	vxlan_mdb_entry_put(vxlan, mdb_entry);
+
+	vxlan->mdb_seq++;
+
+	return 0;
+}
+
+int vxlan_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		  struct netlink_ext_ack *extack)
+{
+	struct vxlan_mdb_config cfg;
+	int err;
+
+	ASSERT_RTNL();
+
+	err = vxlan_mdb_config_init(&cfg, dev, tb, nlmsg_flags, extack);
+	if (err)
+		return err;
+
+	err = __vxlan_mdb_add(&cfg, extack);
+
+	vxlan_mdb_config_fini(&cfg);
+	return err;
+}
+
+int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
+		  struct netlink_ext_ack *extack)
+{
+	struct vxlan_mdb_config cfg;
+	int err;
+
+	ASSERT_RTNL();
+
+	err = vxlan_mdb_config_init(&cfg, dev, tb, 0, extack);
+	if (err)
+		return err;
+
+	err = __vxlan_mdb_del(&cfg, extack);
+
+	vxlan_mdb_config_fini(&cfg);
+	return err;
+}
+
+static void vxlan_mdb_check_empty(void *ptr, void *arg)
+{
+	WARN_ON_ONCE(1);
+}
+
+static void vxlan_mdb_remotes_flush(struct vxlan_dev *vxlan,
+				    struct vxlan_mdb_entry *mdb_entry)
+{
+	struct vxlan_mdb_remote *remote, *tmp;
+
+	list_for_each_entry_safe(remote, tmp, &mdb_entry->remotes, list)
+		vxlan_mdb_remote_del(vxlan, mdb_entry, remote);
+}
+
+static void vxlan_mdb_entries_flush(struct vxlan_dev *vxlan)
+{
+	struct vxlan_mdb_entry *mdb_entry;
+	struct hlist_node *tmp;
+
+	/* The removal of an entry cannot trigger the removal of another entry
+	 * since entries are always added to the head of the list.
+	 */
+	hlist_for_each_entry_safe(mdb_entry, tmp, &vxlan->mdb_list, mdb_node) {
+		vxlan_mdb_remotes_flush(vxlan, mdb_entry);
+		vxlan_mdb_entry_put(vxlan, mdb_entry);
+	}
+}
+
+int vxlan_mdb_init(struct vxlan_dev *vxlan)
+{
+	int err;
+
+	err = rhashtable_init(&vxlan->mdb_tbl, &vxlan_mdb_rht_params);
+	if (err)
+		return err;
+
+	INIT_HLIST_HEAD(&vxlan->mdb_list);
+
+	return 0;
+}
+
+void vxlan_mdb_fini(struct vxlan_dev *vxlan)
+{
+	vxlan_mdb_entries_flush(vxlan);
+	rhashtable_free_and_destroy(&vxlan->mdb_tbl, vxlan_mdb_check_empty,
+				    NULL);
+}
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index f4977925cb8a..7bcc38faae27 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -110,6 +110,14 @@ static inline int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
 		return nla_put_in_addr(skb, attr, ip->sin.sin_addr.s_addr);
 }
 
+static inline bool vxlan_addr_is_multicast(const union vxlan_addr *ip)
+{
+	if (ip->sa.sa_family == AF_INET6)
+		return ipv6_addr_is_multicast(&ip->sin6.sin6_addr);
+	else
+		return ipv4_is_multicast(ip->sin.sin_addr.s_addr);
+}
+
 #else /* !CONFIG_IPV6 */
 
 static inline
@@ -138,8 +146,21 @@ static inline int vxlan_nla_put_addr(struct sk_buff *skb, int attr,
 	return nla_put_in_addr(skb, attr, ip->sin.sin_addr.s_addr);
 }
 
+static inline bool vxlan_addr_is_multicast(const union vxlan_addr *ip)
+{
+	return ipv4_is_multicast(ip->sin.sin_addr.s_addr);
+}
+
 #endif
 
+static inline size_t vxlan_addr_size(const union vxlan_addr *ip)
+{
+	if (ip->sa.sa_family == AF_INET6)
+		return sizeof(struct in6_addr);
+	else
+		return sizeof(__be32);
+}
+
 static inline struct vxlan_vni_node *
 vxlan_vnifilter_lookup(struct vxlan_dev *vxlan, __be32 vni)
 {
@@ -206,4 +227,14 @@ int vxlan_igmp_join(struct vxlan_dev *vxlan, union vxlan_addr *rip,
 		    int rifindex);
 int vxlan_igmp_leave(struct vxlan_dev *vxlan, union vxlan_addr *rip,
 		     int rifindex);
+
+/* vxlan_mdb.c */
+int vxlan_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+		   struct netlink_callback *cb);
+int vxlan_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		  struct netlink_ext_ack *extack);
+int vxlan_mdb_del(struct net_device *dev, struct nlattr *tb[],
+		  struct netlink_ext_ack *extack);
+int vxlan_mdb_init(struct vxlan_dev *vxlan);
+void vxlan_mdb_fini(struct vxlan_dev *vxlan);
 #endif
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index bca5b01af247..110b703d8978 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -3,6 +3,7 @@
 #define __NET_VXLAN_H 1
 
 #include <linux/if_vlan.h>
+#include <linux/rhashtable-types.h>
 #include <net/udp_tunnel.h>
 #include <net/dst_metadata.h>
 #include <net/rtnetlink.h>
@@ -302,6 +303,10 @@ struct vxlan_dev {
 	struct vxlan_vni_group  __rcu *vnigrp;
 
 	struct hlist_head fdb_head[FDB_HASH_SIZE];
+
+	struct rhashtable mdb_tbl;
+	struct hlist_head mdb_list;
+	unsigned int mdb_seq;
 };
 
 #define VXLAN_F_LEARN			0x01
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index d9de241d90f9..417e1aa909b9 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -631,6 +631,11 @@ enum {
 	MDBA_MDB_EATTR_GROUP_MODE,
 	MDBA_MDB_EATTR_SOURCE,
 	MDBA_MDB_EATTR_RTPROT,
+	MDBA_MDB_EATTR_DST,
+	MDBA_MDB_EATTR_DST_PORT,
+	MDBA_MDB_EATTR_VNI,
+	MDBA_MDB_EATTR_IFINDEX,
+	MDBA_MDB_EATTR_SRC_VNI,
 	__MDBA_MDB_EATTR_MAX
 };
 #define MDBA_MDB_EATTR_MAX (__MDBA_MDB_EATTR_MAX - 1)
@@ -726,6 +731,11 @@ enum {
 	MDBE_ATTR_SRC_LIST,
 	MDBE_ATTR_GROUP_MODE,
 	MDBE_ATTR_RTPROT,
+	MDBE_ATTR_DST,
+	MDBE_ATTR_DST_PORT,
+	MDBE_ATTR_VNI,
+	MDBE_ATTR_IFINDEX,
+	MDBE_ATTR_SRC_VNI,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
-- 
2.37.3

