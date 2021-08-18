Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C2E3F02A1
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhHRL0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:26:10 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:54266
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235606AbhHRL0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:26:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IzCXnLR4s48ZtwoCGV1PP6si6xfbTfi47sLJU6pZokeq35fsOQUGTiSyPPabfmyafKZomOmybJfQ+7HNBBYdiotz5IxtlOAE5492P/FaXEvOJhsRr0UkF9b0VYoaI+89QyhpK5BM6HwEyeHqLwqDHswS76y/eA9/cgx34Xsoz5C147EHrnraR1JzDF/Syi+53D5+FFUeJsNoyyb8iLL5mjek700fM+Cg2zlmoZJL0AzwoUj8nfY0/i4SGIbtUyHsv2dN6hNIFTHePqm5vgGh3hAV/aSZKT2t+lFW/BoomsNhl76/RiJoopUUtvVVu7GRmH0tq1WIkfY4OKAdU+J0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzY3aUpPp7menWoUpOHlWn3uOFIR+c64SHOZQjD0XC8=;
 b=ZkTTr4JIuHwWrWZp6icCN7z5gdTy/nrMd/0M11w1c+R0Pvih1YNUY2oat50Kbfvq9ozWMkuH9L/XEHSPtxLYZ42jJvhXUT+wT0E5uGMqanReaewiMk4Ov1H37oid4QrNm8sWfqpfGNpfHERUDQJX0TIG6u71tptTSDwqiApSwYxUlalJlptQEdSnxeN+GA7qqFT/ZL9LsuSkhNaGVdjrkknfbcxQ642AIi2vJZsHhaGc/0ScsIcvC/4e3WWkazJzz62xSXxG/Emb8CztjgU7vzTCr8ckZaEgUy6I5lgAdBzXGW47pfFK1qz5BIZRZqLrjL2nvE6BeKgpzVN8ta4QBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzY3aUpPp7menWoUpOHlWn3uOFIR+c64SHOZQjD0XC8=;
 b=c83s68/A+PB8b+qiz5sqM3DFI9ncPjQiexMKYm6J0QvMcZDBzMVUjnk8WklIH8L8I2wbVeSytngPqJ+vnWe6wky8TDve5XNB3WQx+Vkg1Y++FN0y0fmevwSRc3mYETZicIFARVEnGMDyJQMMA5k+wmC9S+0B00jxfbP9Bf1hRQDFICmFvjpb8Z5TWwF03+M01PXHeOvB6nVwBF5/JAk1c314IyS9SLB6LzWcaRcpLJcMTo+jhSaM9hOHZPmsmnffoGEG/4rKWwqgQ8gc9kLSYysA4pUmJcRz+MCQqMZ2pqmToRbx4WCxMusQxy+9Mf6UxXzlWlhzOvQvOrLNTkGXkw==
Received: from BN6PR11CA0060.namprd11.prod.outlook.com (2603:10b6:404:f7::22)
 by DM4PR12MB5037.namprd12.prod.outlook.com (2603:10b6:5:388::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 11:25:30 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::c7) by BN6PR11CA0060.outlook.office365.com
 (2603:10b6:404:f7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:25:29 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 11:25:28 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:26 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 06/10] RDMA/nldev: Add support to add and remove optional counters
Date:   Wed, 18 Aug 2021 14:24:24 +0300
Message-ID: <20210818112428.209111-7-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 406bc8d3-5725-4abd-1050-08d9623ae257
X-MS-TrafficTypeDiagnostic: DM4PR12MB5037:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50376F1608D040E64729D9A2C7FF9@DM4PR12MB5037.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Stopjl4xPme16Lc+MgavJErxiE/kOuM7TwFIMyi+KVxhJUSTaYAtd4MznqvAynD+tfqnaCW+BHv2vRF6TgCZ0g37Ip6IfS3KoOEKS85qIytSOSZUHpl9N4BvvdvOHooeZUUratXT1HZNkCXzL36VDRfWAjbCI9mOrj2P+gl9miRfepzchST25IeZO6QbsF1ocoWPt1ws3GG8xhW8BIolgnX0uROd0grkWYPlVwNR0+x82DNgmv46qM1UpLewLqOhay6sgRXtA7Jg6K+DHXvm5RpzkgrJAqZTiifHmh6nEvFNmmhuzfz2C6kTaXSpQsiE2FJ8TTGEG/CgH8jQHybekFHV5ZhGZVKjPyJQDDN3QxteTy+lko0nhShEs+L/Ud0ypOHINp1XCRrmXyr2dAOreyZ3RTNvrJzvepkG4Ht6zhrFrk+LuUz1hjq2StDvdb5qo+GdGywAn4nbAC5BL5JJXBqdCdfy4iP6kQxmpeblZBQParCjW7Gp+kq15X3sVI0Qy+LJdyBVsNelY6tHyDfc/EPqslyEiA8y6fEY2CC6Z3LSekv+bdc5tsqKNA5/J0JDxMqErotGAc3OBvkw+2TEMYnKjwhuVua7kpTP2Cm2FIf79JFw2PQeJZ4VK3+gyTJhSh9orzZgN2ioisZRhkkcz71rPhEKJmZQCxSzDTkHl0hg0t2O3eYz5BdjqdjxdHthOjpKcAd5jaTEJutuX9cTtw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(36840700001)(46966006)(110136005)(4326008)(82740400003)(5660300002)(54906003)(70206006)(70586007)(186003)(316002)(36860700001)(26005)(36756003)(1076003)(7696005)(478600001)(82310400003)(7636003)(6636002)(426003)(8676002)(8936002)(107886003)(336012)(356005)(86362001)(2616005)(47076005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:29.2348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 406bc8d3-5725-4abd-1050-08d9623ae257
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

This patch adds the ability to add/remove optional counter to a link
through RDMA netlink. Limit it to users with ADMIN capability only.

Examples:
$ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
$ sudo rdma statistic remove link rocep8s0f0/1 optional-set cc_rx_ce_pkts

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/counters.c | 50 ++++++++++++++++
 drivers/infiniband/core/device.c   |  2 +
 drivers/infiniband/core/nldev.c    | 93 ++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h            |  7 +++
 include/rdma/rdma_counter.h        |  4 ++
 include/rdma/rdma_netlink.h        |  1 +
 include/uapi/rdma/rdma_netlink.h   |  9 +++
 7 files changed, 166 insertions(+)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index b8b6db98bfdf..fa04178aa0eb 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -106,6 +106,56 @@ static int __rdma_counter_bind_qp(struct rdma_counter *counter,
 	return ret;
 }
 
+static struct rdma_op_counter *get_opcounter(struct rdma_op_stats *opstats,
+					     const char *name)
+{
+	int i;
+
+	for (i = 0; i < opstats->num_opcounters; i++)
+		if (!strcmp(opstats->opcounters[i].name, name))
+			return opstats->opcounters + i;
+
+	return NULL;
+}
+
+static int rdma_opcounter_set(struct ib_device *dev, u32 port,
+			      const char *name, bool is_add)
+{
+	struct rdma_port_counter *port_counter;
+	struct rdma_op_counter *opc;
+	int ret;
+
+	if (!dev->ops.add_op_stat || !dev->ops.remove_op_stat)
+		return -EOPNOTSUPP;
+
+	port_counter = &dev->port_data[port].port_counter;
+	opc = get_opcounter(port_counter->opstats, name);
+	if (!opc)
+		return -EINVAL;
+
+	mutex_lock(&port_counter->opstats->lock);
+	ret = is_add ? dev->ops.add_op_stat(dev, port, opc->type) :
+		dev->ops.remove_op_stat(dev, port, opc->type);
+	if (ret)
+		goto end;
+
+	opc->enabled = is_add;
+end:
+	mutex_unlock(&port_counter->opstats->lock);
+	return ret;
+}
+
+int rdma_opcounter_add(struct ib_device *dev, u32 port, const char *name)
+{
+	return rdma_opcounter_set(dev, port, name, true);
+}
+
+int rdma_opcounter_remove(struct ib_device *dev, u32 port,
+			  const char *name)
+{
+	return rdma_opcounter_set(dev, port, name, false);
+}
+
 static struct rdma_counter *alloc_and_bind(struct ib_device *dev, u32 port,
 					   struct ib_qp *qp,
 					   enum rdma_nl_counter_mode mode)
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 23e1ae50b2e4..b9138f20f9a8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2590,6 +2590,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 		ops->uverbs_no_driver_id_binding;
 
 	SET_DEVICE_OP(dev_ops, add_gid);
+	SET_DEVICE_OP(dev_ops, add_op_stat);
 	SET_DEVICE_OP(dev_ops, advise_mr);
 	SET_DEVICE_OP(dev_ops, alloc_dm);
 	SET_DEVICE_OP(dev_ops, alloc_hw_device_stats);
@@ -2701,6 +2702,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, reg_dm_mr);
 	SET_DEVICE_OP(dev_ops, reg_user_mr);
 	SET_DEVICE_OP(dev_ops, reg_user_mr_dmabuf);
+	SET_DEVICE_OP(dev_ops, remove_op_stat);
 	SET_DEVICE_OP(dev_ops, req_notify_cq);
 	SET_DEVICE_OP(dev_ops, rereg_user_mr);
 	SET_DEVICE_OP(dev_ops, resize_cq);
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index e9b4b2cccaa0..17d55d89f11c 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -154,6 +154,11 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_NET_NS_FD]			= { .type = NLA_U32 },
 	[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]	= { .type = NLA_U8 },
 	[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]	= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_STAT_OPCOUNTERS]       = { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY]  = { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME] = { .type = NLA_NUL_STRING,
+				  .len = RDMA_NLDEV_ATTR_OPCOUNTER_NAME_SIZE },
+	[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE] = { .type = NLA_U64 },
 };
 
 static int put_driver_name_print_type(struct sk_buff *msg, const char *name,
@@ -1888,6 +1893,86 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int nldev_stat_set_op_stat(struct sk_buff *skb,
+				  struct nlmsghdr *nlh,
+				  struct netlink_ext_ack *extack,
+				  bool cmd_add)
+{
+	char opcounter[RDMA_NLDEV_ATTR_OPCOUNTER_NAME_SIZE] = {};
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct ib_device *device;
+	struct sk_buff *msg;
+	u32 index, port;
+	int ret;
+
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, extack);
+
+	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(sock_net(skb->sk), index);
+	if (!device)
+		return -EINVAL;
+
+	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (!rdma_is_port_valid(device, port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	nla_strscpy(opcounter, tb[RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME],
+		    sizeof(opcounter));
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
+					 (cmd_add ?
+					  RDMA_NLDEV_CMD_STAT_ADD_OPCOUNTER :
+					  RDMA_NLDEV_CMD_STAT_REMOVE_OPCOUNTER)),
+			0, 0);
+
+	if (cmd_add)
+		ret = rdma_opcounter_add(device, port, opcounter);
+	else
+		ret = rdma_opcounter_remove(device, port, opcounter);
+	if (ret)
+		goto err_msg;
+
+	nlmsg_end(msg, nlh);
+	ib_device_put(device);
+	return rdma_nl_unicast(sock_net(skb->sk), msg,
+			       NETLINK_CB(skb).portid);
+
+err_msg:
+	nlmsg_free(msg);
+err:
+	ib_device_put(device);
+	return ret;
+}
+
+static int nldev_stat_add_op_stat_doit(struct sk_buff *skb,
+				       struct nlmsghdr *nlh,
+				       struct netlink_ext_ack *extack)
+{
+	return nldev_stat_set_op_stat(skb, nlh, extack, true);
+}
+
+static int nldev_stat_remove_op_stat_doit(struct sk_buff *skb,
+					  struct nlmsghdr *nlh,
+					  struct netlink_ext_ack *extack)
+{
+	return nldev_stat_set_op_stat(skb, nlh, extack, false);
+}
+
 static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
@@ -2342,6 +2427,14 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.dump = nldev_res_get_mr_raw_dumpit,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
+	[RDMA_NLDEV_CMD_STAT_ADD_OPCOUNTER] = {
+		.doit = nldev_stat_add_op_stat_doit,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
+	[RDMA_NLDEV_CMD_STAT_REMOVE_OPCOUNTER] = {
+		.doit = nldev_stat_remove_op_stat_doit,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
 };
 
 void __init nldev_init(void)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 40b0f7825975..fa9e668b9b14 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -600,11 +600,14 @@ static inline struct rdma_hw_stats *rdma_alloc_hw_stats_struct(
 
 /**
  * struct rdma_op_counter
+ * @enabled - To indicate if this counter is currently enabled (as optional
+ *    counters can be dynamically enabled/disabled)
  * @type - The vendor-specific type of the counter
  * @name - The name of the counter
  * @value - The value of the counter
  */
 struct rdma_op_counter {
+	bool enabled;
 	int type;
 	const char *name;
 	u64 value;
@@ -2595,6 +2598,10 @@ struct ib_device_ops {
 	struct rdma_op_stats *(*alloc_op_port_stats)(struct ib_device *device,
 						     u32 port_num);
 
+	int (*add_op_stat)(struct ib_device *device, u32 port,
+			   int optional_stat);
+	int (*remove_op_stat)(struct ib_device *device, u32 port,
+			      int optional_stat);
 	/**
 	 * Allows rdma drivers to add their own restrack attributes.
 	 */
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index 3531c5061718..48086a7248ac 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -63,5 +63,9 @@ int rdma_counter_unbind_qpn(struct ib_device *dev, u32 port,
 int rdma_counter_get_mode(struct ib_device *dev, u32 port,
 			  enum rdma_nl_counter_mode *mode,
 			  enum rdma_nl_counter_mask *mask);
+int rdma_opcounter_add(struct ib_device *dev, u32 port,
+		       const char *name);
+int rdma_opcounter_remove(struct ib_device *dev, u32 port,
+			  const char *name);
 
 #endif /* _RDMA_COUNTER_H_ */
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 2758d9df71ee..ac47a0cc0508 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -10,6 +10,7 @@ enum {
 	RDMA_NLDEV_ATTR_EMPTY_STRING = 1,
 	RDMA_NLDEV_ATTR_ENTRY_STRLEN = 16,
 	RDMA_NLDEV_ATTR_CHARDEV_TYPE_SIZE = 32,
+	RDMA_NLDEV_ATTR_OPCOUNTER_NAME_SIZE = 64,
 };
 
 struct rdma_nl_cbs {
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 75a1ae2311d8..79e6ca87d2e0 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -297,6 +297,10 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_SRQ_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_STAT_ADD_OPCOUNTER,
+
+	RDMA_NLDEV_CMD_STAT_REMOVE_OPCOUNTER,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -549,6 +553,11 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK,	/* u8 */
 
+	RDMA_NLDEV_ATTR_STAT_OPCOUNTERS,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_STAT_OPCOUNTER_ENTRY_VALUE,	/* u64 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.26.2

