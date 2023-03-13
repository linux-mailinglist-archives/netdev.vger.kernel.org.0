Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B4C6B7B67
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjCMPCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCMPCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:02:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249931EBCB
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 08:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHxIyIVgdNALaR+Sm4djG47LHo/WNxyBo6xStOmrClJbZ8MBVtDDRLht3RkHPNlf2/HWbH4jnTszIe60/ZMD3DV7RbPXVJr48Eta/KO2lVPFtmuK5lKikPE01W2rXoTA79qdIs2gpEQ3qT6yLU4y+lbOnh/+1ypi5x944I+chykNz5iUU/jZ2nR8wtEhh2knoeOImxuEyuVQAe920m8AbOH9DzeR+YcFdQQmWjnx2XgccMVKVaaJB28/vU3lUx0mxuyH8NgxlHQcxAxPZ8j8lYfTQRupEdAyRrgC2XblszgQQaV06ib+i1zSLMWDHw4vu4CK7IvjcpOt2zKJK7k9kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FC4VO4w2QmyrIOfZWpUAe7Zj0Wob2iGYViX3lpEqYSU=;
 b=YQ39opTqtK5TJ59pSXFNF39NJvSDfYabipJSX9I/xS3Thi1c2OVGwjg56BAcQYlW9pTUsM6S/R62vWLlnusbV5ZJG8PhyBGJm4jmsWWQ00MPSRg5ymcVYeKBcKDuQNT89poYT3aGsibqyZQewKBdpQtp4wHjyt/IJJCZBA8pHbSOpFQCV3yQeRy+yipcNyoHKdLcakXyOefgTukV4VkgocbXjLQLoQwdogAOwW29zC6hi+fmDnYMZORewZBzhfUyvG8UAfd5Dchzg1J0XqWOayjZ5flozuBnUyJyB7hRBOBkCG+0kY4iZci9Dvm+kDAxhMp4yMMvSesndpabbWIh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FC4VO4w2QmyrIOfZWpUAe7Zj0Wob2iGYViX3lpEqYSU=;
 b=Fn8ApQDCxQHiNG5WtwECUrh5cMjEGN5saaRxUlmAsCo+xLKIS9WyPqNAw+N5wrtxM0VOOl8pyrOd47mSAe4CIepGZnd3HlbdzFWhiVeTmXusVqnz+HlvtxOWXWZwDfJUORWfnRhccvJg9KKfNenQk7IOJmLdVxabTTKFAVcyHXrFaeoeS2KjSYZgjjEoLxePtCa4XF5oG+4iTyXGmRNUnYauSLTfqB9yBLNF2wxVR2v04oOPveMG4QAqM+DWI2paGczT8lwURTQUu3UHtisETzS0v2TDGZmpTBuYkpKzK23oGpomDjitNvg1g24Dd2PGMnbNTlAWTccQHSYgcqenuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:55:56 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:55:56 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/11] vxlan: mdb: Add MDB control path support
Date:   Mon, 13 Mar 2023 16:53:45 +0200
Message-Id: <20230313145349.3557231-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0043.eurprd05.prod.outlook.com
 (2603:10a6:800:60::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: cc98ac0e-6246-4328-8bbc-08db23d30c76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9tWBtVbfwWC39ihwq1UG1tYuF7xvdi4LQA2eeKnL0/Ts0cgNtvFC7VtSPdEUKbRC7oozSJt7jaObbpTEjmv5Q5VpASyfMKNu66jKI2tOqMssMfHppxt5q03XDU0jXTyyZULnTpdw7v61a0vy74fGdWY8bG1WS+FrW3QgJj9j7BAs1N/OICXhK6C5cPr5z5jnFsIjM1kTSk7OBQD+S5Krs+zAsPnt+qVBJc9XxPZFqyEPqhrBgAM3axkPKGBT4gUlF295jQOcOwjDM6fhVTe2RVeJOR5w1c0N2rRHO4BN2nTgv6N+LaTUfJKlQ393+XsTM0jUPXXsahYXD+KQBJz8ov+ECCH64M8d4kzULtLMafZdVdPrAjQfq+6un2rpzzu4XLtmJapKNTeB8MmXr3YAjnU2xyyeTZH0fzvI86DecUwsFLUNiyAzsARlwxf5uh3ykxBU4RxNUXVb1NwFzvTOhLpwdbuRgSe3Ryfd6e/6BeJZgjVQGq544zjWbnO2iPSEg1oyu3je7db6aJIZVkF1H5J1E6ugXtX5jnLEmIW8OgN+sqqpwmEbFSGyXN8f3uPzsWZRt+Q2b/mzuf8WqKjTOSb9QQuxzqMNXDahuUIyixd1BkilNqH6hCc/Ivx9Rkp8YBeSvZoMUr0fViLjp5hWkpCeN4XvaUIH5Db90suEaNZFos695qHbXMkq3iyR7ru
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(30864003)(5660300002)(66946007)(8676002)(8936002)(66556008)(4326008)(66476007)(38100700002)(316002)(86362001)(478600001)(186003)(2616005)(26005)(6506007)(6666004)(107886003)(6512007)(1076003)(966005)(6486002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+jCdS4NZIaqXcilAqvM/BFEhHLj82BMczTeGXjEmcMOCCzBUQS1x6tDuePbx?=
 =?us-ascii?Q?T9U+vEql8VBgAb7nwZfc31+D5FBqsOOFmUvGg7JC4pgUNuGkE2vy2uV5G6Ag?=
 =?us-ascii?Q?p86huLfXx1Ab1GSgv6hV7PaPIS2kAo5K3MaNeOHgQeCOgNMNxir6DN9Msvfq?=
 =?us-ascii?Q?ueK+oEVZMj1n9u8+kYcMxT5tvuA0OQP7a9MfDMp06vagLFve4Pt2yQqf9WzU?=
 =?us-ascii?Q?Wq5/md7H7egCL/Culc8TRbn4hhNlz00hMpz2TfFn7vBRSnRB9qAsQzrRTinG?=
 =?us-ascii?Q?SWmyj+6tYz4BPpFb0WSETHNo/oi0V20lB3EshacOk3HOU7dD2f4gyQnwNYDA?=
 =?us-ascii?Q?ZF1M2DrshkwxRiNC0n8D/vO5XW7WFYBzBXq9ttZDqDg7CWElW2geKZ8fJbr3?=
 =?us-ascii?Q?wF6qLGjkJQ0lr2NhDa5pmb9II44mA4qt62iidoLuvYjPMxdh2jNqn5RPevVu?=
 =?us-ascii?Q?5KCAxE2PdvbGBkkl5FiVq+jnqCgaW+WpPoCBMdkls1QCa1wFqK0s8Cm4k1ud?=
 =?us-ascii?Q?gBoWIv/ZixkO2dG8PLnhgJHk4D71Vv5sxKkuUKILI/sMvbGBjOep4OEt0TAh?=
 =?us-ascii?Q?fKPdGMq1hcztg0DMJqJzx+06HPjc421hgWuF2Iera+w+fghMDzwVvSOk/unc?=
 =?us-ascii?Q?CD4v9JWDjigj5ohkiVSf3a3QIezZhy+c+MaWvvpqA7WBYGKT9VkdabB3lqSb?=
 =?us-ascii?Q?EnLJqu0+kPoq+8pYLwHMi+FI/Kijxk8hV/GeDHCYavDJ+pOe2E+PSq3JQRng?=
 =?us-ascii?Q?VPA8P8Diwsai7Y2FQD1jDUuY5a2dCJpnYljlJ7T3l7YlHiTWXL4kwAVle4C3?=
 =?us-ascii?Q?GdMRByK08uy0Xl0BfjAjym+Vof+NzzAoL5hmzHFLqoeyRiSu13NtRGrei0DD?=
 =?us-ascii?Q?IQABnBXU/ec9RdjLzInA0yct1pWPAeCEIEgK62trCP0X61afHWqhwC7dPpcm?=
 =?us-ascii?Q?Dc91Xw+q9FTxf5G9wobJp7IqqWuFOF+dIY0Uic0zZbBZkO5vrGGLsje4xtPL?=
 =?us-ascii?Q?DWD5fFHw8NPnBWdMPq1YZV5x8A/ShYXGHkXVpDjFZfDY6GDgH/J5War7cCF9?=
 =?us-ascii?Q?d/ciASB5590LaotEBigs/0LOvAwCQD0Lkvl6Ti7kmM8FYUihfv3cROPaJB1M?=
 =?us-ascii?Q?wwVFV2ETR+C3ubJYpTpDsBPYWLSyXcIlBzkFYGLkPJGeX5KXoAm/zLJEUBAH?=
 =?us-ascii?Q?CGG3PRYITW9EMRG1JOWhbbF4kW2KPbAu+U0z54Bnx4pVomF7KS/XjrM9TTcS?=
 =?us-ascii?Q?CE6G6kFBAtBGJoSapZPubsRgY3ORPj6rMd+jGj4Nwexl5keyMavMaSZIVq6P?=
 =?us-ascii?Q?WESuRvFLB4pJ8mKAD32em4UeRg2aykxdaPLituAY9GSMmZw29MdYumC/W1k2?=
 =?us-ascii?Q?9hyOSzmjQS61JdcAxr8ywL2sdTUlD0Z39o0/PXz53/c+IKPvTZoxtM2hmX7D?=
 =?us-ascii?Q?UU2rTG8teW350x90uMq+Iwvs9c9A7xWWpAcoYbiKqK/ouvdAICscbpqOnN9G?=
 =?us-ascii?Q?WEkSOPTYJqbZd875BkyXwoeXaNXYjqot1smQ3FHmCcFC8X5xZ1vW/YgVAETO?=
 =?us-ascii?Q?mqJi2FAqKPST/v4jDbv9XB33LAkc6PtQ6LOyzyzt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc98ac0e-6246-4328-8bbc-08db23d30c76
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:55:55.9880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jmr//BCVV3YJbXUmt20k/A9upzJ6ZzHCChC4o48gqbh0WIupMXqf+DA63tE4+wWWOtvnOz1GBiecHJyZJq4J1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Notes:
    v1:
    * Remove restrictions regarding mixing of multicast and unicast remote
      destination IPs in an MDB entry. While such configuration does not
      make sense to me, it is no forbidden by the VXLAN FDB code and does
      not crash the kernel.
    * Fix check regarding all-zeros MDB entry and source.

 drivers/net/vxlan/Makefile        |    2 +-
 drivers/net/vxlan/vxlan_core.c    |    8 +
 drivers/net/vxlan/vxlan_mdb.c     | 1341 +++++++++++++++++++++++++++++
 drivers/net/vxlan/vxlan_private.h |   31 +
 include/net/vxlan.h               |    5 +
 include/uapi/linux/if_bridge.h    |   10 +
 6 files changed, 1396 insertions(+), 1 deletion(-)
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
index 000000000000..129692b3663f
--- /dev/null
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -0,0 +1,1341 @@
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
+	if (vxlan_addr_any(&cfg->group.dst) &&
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
index d60c456710b3..c9d624f528c5 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -633,6 +633,11 @@ enum {
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
@@ -728,6 +733,11 @@ enum {
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

