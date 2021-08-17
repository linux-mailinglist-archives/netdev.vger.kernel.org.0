Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C443EEB60
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 13:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhHQLLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 07:11:32 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.33]:39684 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231515AbhHQLLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 07:11:31 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2021 07:11:31 EDT
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1272A2AF59
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:05:10 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E6B416C0081;
        Tue, 17 Aug 2021 11:05:07 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ly33xmsIFpB8Hw6dRxFTTK+lxHeBDGcv+mBkhZ+j18N2PNfwX6xMZeBnIcrYCt36pjR4nZCLVUl9sP4HEjHjASLQsCVde6FXxU3NczxNxIXOH917/QXIBZ2VOnCjjDcLrowO2Mi27ejpNuvgxlaHHo6dFVIZtGfpPGqZ6I9Tr4nPyLKgi7P8XRougtElRujRqh4b+JQzDyZfEngwl54Fj2giMsnOF694YnLOWubXlw+e59h5OruvswsEYEaKrJa00CYFbqyYX76ZtEbQaGMDDzkNMPiP3DaljqtwAlUZjvJvhMZbCFIug3E6keM0Axq12maaaheCcvGglHAYnxNwaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe5hMjx7E6nfKxjDGWg/nKf9APvEllGqxJK8gaaE1jM=;
 b=L1RvdSYX6i7IN4RYVFfKROa4pJO4Nd2bRTNO9pPQe+MifqSr10o8r7KodM3ucJOOjecBXU8Adxqn/EUOxdjC6qMbqiPuPGBhqPI1eno9jMDZFwPoQQqm50cFBga5Jf90339pAuLIw7E+Zmm5QUX7bUqNvIbHjxNNkDdSu51y2lnVjttaES7uD8WRxNputgoCvKtzQacN6wlawSCgHjfsEcEzz4Sro4uELLl+miz4wuCSKzIiiDA/oqkZicMhQEAgvzCqMmBXDBzuG27AI4Y+hQCdKIVwYn8+QQlxCqoROXKBXu1X72AgkMGfhh20h4X4rnNEK31wINkdUzIKJ+ayww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe5hMjx7E6nfKxjDGWg/nKf9APvEllGqxJK8gaaE1jM=;
 b=ann8hbJgURjTJ22iRh9MGsl/On7MdPXXgbhtWq4wq1zklMi3LCc9875sFlCKJyNouSwrf2iQh6yGnJhtVRJYQjtNbo9txaooSpiI1FY1oNCxA56LDGYXwLv2PsdX/0L6Zqa3W2jX0hsjGbk4Th2MXlFF5n8ALt8uOcudbEaY1/U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=drivenets.com;
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AM6PR08MB4627.eurprd08.prod.outlook.com (2603:10a6:20b:d1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 11:05:06 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 11:05:06 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     davem@davemloft.net, kuba@kernel.org, luwei32@huawei.com,
        gnaaman@drivenets.com, wangxiongfeng2@huawei.com,
        ap420073@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: Improve perf of bond/vlans modification
Date:   Tue, 17 Aug 2021 14:04:47 +0300
Message-Id: <20210817110447.267678-1-gnaaman@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0049.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::13) To AM6PR08MB4118.eurprd08.prod.outlook.com
 (2603:10a6:20b:aa::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gnaaman-pc.dev.drivenets.net (199.203.244.232) by LO2P123CA0049.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Tue, 17 Aug 2021 11:05:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15cc0752-4a45-4f6b-d4e8-08d9616ededf
X-MS-TrafficTypeDiagnostic: AM6PR08MB4627:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB46275AE8730D953B10B5A3F5BEFE9@AM6PR08MB4627.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8XdAabCCnGwE6qydPXt/nI8vUE5HDziy3o+1Qu/R6CQCcu/59Ss0IolLqdLI2VYR88LKLH3DYfUDPZ2Pz1NzkH1eLBL2JYs39KtoN0CdzpT+zEFo+E151h2nHp0jqKHERZ7eUoa25dk/s6GqdWQi+YZdMcPLN47J4J7OJeR6zsRuZzFWw6w4+ZytCySmWyfraZGPVh7l/sXn32CyEn5CSMyjxZm/FN6NqSPpa+FkNxUBWzu+6pdDN4QPH68+8FywSVLUjt86Ab7roQPHP2710FiPhPMA1HqxRzsTCO2cYiKto0FBFAeIH6yWUAKz6VUWmrhF/WF6TaoDDkV9cuEHakXEmfpHt3BN9SRUZ6AkraK2iZ6Fo2hqWRtipOXoC5+mvAbRPJp40IO6g30s/L3GMblgn/RzEvNRk+gJqWjXnC+4wAxEstZVNY65P6D0pcLFWB4DcL/MdJTPgS2C/tHyyljXXMxfZcMCF8tIvgbAUAkXrgUSP4SF6L7eM+5G68+cB1PYpt7hM7xi4CaNM73lbmeDgc7F67V4ONG+T/8rEM9yx+jawrGNPKG39tCHiiWOihwL40OxcOmpRnybeCnYuz7BApxrscUnnLvQY0IJOx6MiEB/2lVL3YeDtm2gD9HTBZYyagfOrgwAxZZWj6FpEwZt0uPEh+9ESHdBxZiB40HUZhxf/Vzm3lL9u5GJxVpF6TLLfqhb8SqVqCsBfttaCWLUw88xuLNYt1EiXmr8r58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(39840400004)(136003)(66476007)(66556008)(86362001)(52116002)(66946007)(26005)(8936002)(8676002)(2906002)(186003)(6506007)(30864003)(36756003)(6486002)(5660300002)(1076003)(6512007)(6666004)(316002)(38100700002)(38350700002)(2616005)(956004)(478600001)(4326008)(83380400001)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U9dpdPB8fgzJDR325huKvu0Noy5CHihiEPTUUt2ISXZ9ct4yL2fcugajs8gu?=
 =?us-ascii?Q?PH9a8wj6enY25rDRcObdrmBARTuxErqEoXE7eG005z6R6UTn5SjNtgM/bPgr?=
 =?us-ascii?Q?B0sB28iJDHsN5nd4dFVSvjaF/munL5s4nq5SuUh+z4KJSPfSn3PZlFv3sm0X?=
 =?us-ascii?Q?bihvDjOkcnSpfAsrJFcSdNA3QfdP9E19E1y/bNyI17okmkzQRKuIvAmdO6S7?=
 =?us-ascii?Q?EbBOBNIFrvxzOuxuOtR+opM4aulS2moAfL6BqO6HEvLjRaUly/Sgs73OPufl?=
 =?us-ascii?Q?zvtnKzT9BJvaSxxX7dUczrk9ouMsJHqF9wg/0htaCcAS9MYGf01nDwuCiVim?=
 =?us-ascii?Q?k1UL1Em6nTaFZEE/0lGEY3jEJI1V9yNebRrmwNLXomw+anVyXrhPhpEr/p5u?=
 =?us-ascii?Q?YJZSH0hf+zLLI8s1wbc2OkC/JH/6reNxCfxQK9kDjt+YisakgIqlwoOxatQ2?=
 =?us-ascii?Q?iuEzQUGUSms7dOICc44WIO3xmuck83/KleuTIJu1j/JrgvxqTsrbx8aDgk1a?=
 =?us-ascii?Q?M6JkSZxsbLtQe8FbnqC2i8GIwcuBpVW8brGAfg/bMMWlehZdPN1jBLsE74Wy?=
 =?us-ascii?Q?dQ7t4ciXeD2uOQB0glQTBdw5OkJO/9KDthWAZrvQQ8gSCoGjpmY28iRx1cTB?=
 =?us-ascii?Q?FOKNrSx60/OxZilLjOPEmfFhkSKP6BhjShflgP0taGZXw79EmtJvPULjiJ+J?=
 =?us-ascii?Q?9T6+8MgW6yAFixEsn6tWw0blQbJEpQ5Ok8L97FhF62pOKSxmEtgPTFTvIvmf?=
 =?us-ascii?Q?Br0RXQIxOQxCK6ZD9fjpn1QJULl/KQLdfy4ei6BpbanJfzCPb53ccFtLsntm?=
 =?us-ascii?Q?TeuhHHMkFYDC5rhvwJrCD29ugrOxgC+59aB2YGchaOWb9OBJgX4OwSraIj8N?=
 =?us-ascii?Q?XvqKx0210SlQbp13fdwbABZFDh49bQJfdcLtAOCD8pDRq+iHDuZmYhMOKvLW?=
 =?us-ascii?Q?E+xPLyPk8y4EA5eFPXBFZ8ggVkTTvtBth3EQ74RowdwPBUKPwwffjC1lFrR+?=
 =?us-ascii?Q?stYw6rco5F8uOiFM3byBLIy6UHajwQZg4c8uDB2MdrSuJvTfv4fb2ds0LK27?=
 =?us-ascii?Q?LyVSAx+7WnYoz1i4OVvyccQhcZjSgZrQdNZZ8i41ox3ZuYcUqsRY7RDX2XF3?=
 =?us-ascii?Q?EnQf1wwLHBf6q4piPledy4eBgjR8JdQQJ7ZZMfVOB3bxCKXUaF3883oaPMkP?=
 =?us-ascii?Q?cy+s0Dq7TVLO9YpSY897yI3HPaHE6oGJapj6rZsdmqI+2rZiGEi4H9nk0x0e?=
 =?us-ascii?Q?jni07rVU9vdDNz6kjBR3Gd+KLsiLRCL381h1Yob+IyFdSVp+dVhu8Z7Wk8z/?=
 =?us-ascii?Q?gkyLr6euTPIjAuuOo7vJuLYI?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15cc0752-4a45-4f6b-d4e8-08d9616ededf
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 11:05:06.4852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6CYTDbuvsKQ6TDRSq4sfkGiifu9zvucKtoi+EkKnkaDORO/pkF6b2/y3eWEJaLajnJLa82B4AFazC+SCQmsqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4627
X-MDID: 1629198308-KTup71x8MRfm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a bond have a massive amount of VLANs with IPv6 addresses,
performance of changing link state, attaching a VRF, changing an IPv6
address, etc. go down dramtically.

The source of most of the slow down is the `dev_addr_lists.c` module,
which mainatins a linked list of HW addresses.
When using IPv6, this list grows for each IPv6 address added on a
VLAN, since each IPv6 address has a multicast HW address associated with
it.

When performing any modification to the involved links, this list is
traversed many times, often for nothing, all while holding the RTNL
lock.

Instead, this patch adds an auxilliary rbtree which cuts down
traversal time significantly.

Performance can be seen with the following script:

	#!/bin/bash
	ip netns del test || true 2>/dev/null
	ip netns add test

	echo 1 | ip netns exec test tee /proc/sys/net/ipv6/conf/all/keep_addr_on_down > /dev/null

	set -e

	ip -n test link add foo type veth peer name bar
	ip -n test link add b1 type bond
	ip -n test link add florp type vrf table 10

	ip -n test link set bar master b1
	ip -n test link set foo up
	ip -n test link set bar up
	ip -n test link set b1 up
	ip -n test link set florp up

	VLAN_COUNT=1500
	BASE_DEV=b1

	echo Creating vlans
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test link add link $BASE_DEV name foo.\$i type vlan id \$i; done"

	echo Bringing them up
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test link set foo.\$i up; done"

	echo Assiging IPv6 Addresses
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test address add dev foo.\$i 2000::\$i/64; done"

	echo Attaching to VRF
	ip netns exec test time -p bash -c "for i in \$(seq 1 $VLAN_COUNT);
	do ip -n test link set foo.\$i master florp; done"

On an Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz machine, the performance
before the patch is (truncated):

	Creating vlans
	real 108.35
	Bringing them up
	real 4.96
	Assiging IPv6 Addresses
	real 19.22
	Attaching to VRF
	real 458.84

After the patch:

	Creating vlans
	real 5.59
	Bringing them up
	real 5.07
	Assiging IPv6 Addresses
	real 5.64
	Attaching to VRF
	real 25.37

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Lu Wei <luwei32@huawei.com>
Cc: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
---
 include/linux/netdevice.h |   5 ++
 net/core/dev_addr_lists.c | 163 ++++++++++++++++++++++++++++----------
 2 files changed, 126 insertions(+), 42 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..dc343be9a845 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -47,6 +47,7 @@
 #include <uapi/linux/if_bonding.h>
 #include <uapi/linux/pkt_cls.h>
 #include <linux/hashtable.h>
+#include <linux/rbtree.h>
 
 struct netpoll_info;
 struct device;
@@ -218,12 +219,16 @@ struct netdev_hw_addr {
 	int			sync_cnt;
 	int			refcount;
 	int			synced;
+	struct rb_node		node;
 	struct rcu_head		rcu_head;
 };
 
 struct netdev_hw_addr_list {
 	struct list_head	list;
 	int			count;
+
+	/* Auxiliary tree for faster lookup when modifying the structure */
+	struct rb_root		tree_root;
 };
 
 #define netdev_hw_addr_list_count(l) ((l)->count)
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 45ae6eeb2964..2473d0f401aa 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -12,6 +12,72 @@
 #include <linux/export.h>
 #include <linux/list.h>
 
+/* Lookup for an address in the list using the rbtree.
+ * The return value is always a valid pointer.
+ * If the address exists, `*ret` is non-null and the address can be retrieved using
+ *
+ *     container_of(*ret, struct netdev_hw_addr, node)
+ *
+ * Otherwise, `ret` can be used with `parent` as an insertion point
+ * when calling `insert_address_to_tree`.
+ *
+ * Must only be called when holding the netdevice's spinlock.
+ *
+ * @ignore_zero_addr_type if true and `addr_type` is zero,
+ *                        disregard addr_type when matching;
+ */
+static struct rb_node **tree_address_lookup(struct netdev_hw_addr_list *list,
+					  const unsigned char *addr,
+					  int addr_len,
+					  unsigned char addr_type,
+					  bool ignore_zero_addr_type,
+					  struct rb_node **parent)
+{
+	struct rb_node **node = &list->tree_root.rb_node, *_parent;
+
+	while (*node)
+	{
+		struct netdev_hw_addr *data = container_of(*node, struct netdev_hw_addr, node);
+		int result;
+
+		result = memcmp(addr, data->addr, addr_len);
+		if (!result && (ignore_zero_addr_type && !addr_type))
+			result = memcmp(&addr_type, &data->type, sizeof(addr_type));
+
+		_parent = *node;
+		if (result < 0)
+			node = &(*node)->rb_left;
+		else if (result > 0)
+			node = &(*node)->rb_right;
+		else
+			break;
+	}
+
+	if (parent)
+		*parent = _parent;
+	return node;
+}
+
+
+static int insert_address_to_tree(struct netdev_hw_addr_list *list,
+				  struct netdev_hw_addr *ha,
+				  int addr_len,
+				  struct rb_node **insertion_point,
+				  struct rb_node *parent)
+{
+	/* Figure out where to put new node */
+	if (!insertion_point || !parent)
+	{
+		insertion_point = tree_address_lookup(list, ha->addr, addr_len, ha->type, false, &parent);
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&ha->node, parent, insertion_point);
+	rb_insert_color(&ha->node, &list->tree_root);
+
+	return true;
+}
+
 /*
  * General list handling functions
  */
@@ -19,7 +85,9 @@
 static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 			       const unsigned char *addr, int addr_len,
 			       unsigned char addr_type, bool global,
-			       bool sync)
+			       bool sync,
+			       struct rb_node **insertion_point,
+			       struct rb_node *parent)
 {
 	struct netdev_hw_addr *ha;
 	int alloc_size;
@@ -36,6 +104,10 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 	ha->global_use = global;
 	ha->synced = sync ? 1 : 0;
 	ha->sync_cnt = 0;
+
+	/* Insert node to hash table for quicker lookups during modification */
+	insert_address_to_tree(list, ha, addr_len, insertion_point, parent);
+
 	list_add_tail_rcu(&ha->list, &list->list);
 	list->count++;
 
@@ -47,34 +119,36 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 			    unsigned char addr_type, bool global, bool sync,
 			    int sync_count)
 {
+	struct rb_node **ha_node;
+	struct rb_node *insert_parent = NULL;
 	struct netdev_hw_addr *ha;
 
 	if (addr_len > MAX_ADDR_LEN)
 		return -EINVAL;
 
-	list_for_each_entry(ha, &list->list, list) {
-		if (ha->type == addr_type &&
-		    !memcmp(ha->addr, addr, addr_len)) {
-			if (global) {
-				/* check if addr is already used as global */
-				if (ha->global_use)
-					return 0;
-				else
-					ha->global_use = true;
-			}
-			if (sync) {
-				if (ha->synced && sync_count)
-					return -EEXIST;
-				else
-					ha->synced++;
-			}
-			ha->refcount++;
-			return 0;
+	ha_node = tree_address_lookup(list, addr, addr_len, addr_type, false, &insert_parent);
+	if (*ha_node)
+	{
+		ha = container_of(*ha_node, struct netdev_hw_addr, node);
+		if (global) {
+			/* check if addr is already used as global */
+			if (ha->global_use)
+				return 0;
+			else
+				ha->global_use = true;
 		}
+		if (sync) {
+			if (ha->synced && sync_count)
+				return -EEXIST;
+			else
+				ha->synced++;
+		}
+		ha->refcount++;
+		return 0;
 	}
 
 	return __hw_addr_create_ex(list, addr, addr_len, addr_type, global,
-				   sync);
+				   sync, ha_node, insert_parent);
 }
 
 static int __hw_addr_add(struct netdev_hw_addr_list *list,
@@ -103,6 +177,8 @@ static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
 
 	if (--ha->refcount)
 		return 0;
+
+	rb_erase(&ha->node, &list->tree_root);
 	list_del_rcu(&ha->list);
 	kfree_rcu(ha, rcu_head);
 	list->count--;
@@ -113,14 +189,15 @@ static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 			    const unsigned char *addr, int addr_len,
 			    unsigned char addr_type, bool global, bool sync)
 {
+	struct rb_node **ha_node;
 	struct netdev_hw_addr *ha;
 
-	list_for_each_entry(ha, &list->list, list) {
-		if (!memcmp(ha->addr, addr, addr_len) &&
-		    (ha->type == addr_type || !addr_type))
-			return __hw_addr_del_entry(list, ha, global, sync);
-	}
-	return -ENOENT;
+	ha_node = tree_address_lookup(list, addr, addr_len, addr_type, true, NULL);
+	if (*ha_node == NULL)
+		return -ENOENT;
+
+	ha = container_of(*ha_node, struct netdev_hw_addr, node);
+	return __hw_addr_del_entry(list, ha, global, sync);
 }
 
 static int __hw_addr_del(struct netdev_hw_addr_list *list,
@@ -418,6 +495,7 @@ void __hw_addr_init(struct netdev_hw_addr_list *list)
 {
 	INIT_LIST_HEAD(&list->list);
 	list->count = 0;
+	list->tree_root = RB_ROOT;
 }
 EXPORT_SYMBOL(__hw_addr_init);
 
@@ -552,19 +630,20 @@ EXPORT_SYMBOL(dev_addr_del);
  */
 int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	struct netdev_hw_addr *ha;
+	struct rb_node *insert_parent = NULL;
+	struct rb_node **ha_node = NULL;
 	int err;
 
 	netif_addr_lock_bh(dev);
-	list_for_each_entry(ha, &dev->uc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
-		    ha->type == NETDEV_HW_ADDR_T_UNICAST) {
-			err = -EEXIST;
-			goto out;
-		}
+	ha_node = tree_address_lookup(&dev->uc, addr, dev->addr_len, NETDEV_HW_ADDR_T_UNICAST, false, &insert_parent);
+	if (*ha_node)
+	{
+		err = -EEXIST;
+		goto out;
 	}
+
 	err = __hw_addr_create_ex(&dev->uc, addr, dev->addr_len,
-				  NETDEV_HW_ADDR_T_UNICAST, true, false);
+				  NETDEV_HW_ADDR_T_UNICAST, true, false, ha_node, insert_parent);
 	if (!err)
 		__dev_set_rx_mode(dev);
 out:
@@ -745,19 +824,19 @@ EXPORT_SYMBOL(dev_uc_init);
  */
 int dev_mc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	struct netdev_hw_addr *ha;
+	struct rb_node **ha_node;
+	struct rb_node *insert_parent = NULL;
 	int err;
 
 	netif_addr_lock_bh(dev);
-	list_for_each_entry(ha, &dev->mc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
-		    ha->type == NETDEV_HW_ADDR_T_MULTICAST) {
-			err = -EEXIST;
-			goto out;
-		}
+	ha_node = tree_address_lookup(&dev->mc, addr, dev->addr_len, NETDEV_HW_ADDR_T_MULTICAST, false, &insert_parent);
+	if (*ha_node)
+	{
+		err = -EEXIST;
+		goto out;
 	}
 	err = __hw_addr_create_ex(&dev->mc, addr, dev->addr_len,
-				  NETDEV_HW_ADDR_T_MULTICAST, true, false);
+				  NETDEV_HW_ADDR_T_MULTICAST, true, false, ha_node, insert_parent);
 	if (!err)
 		__dev_set_rx_mode(dev);
 out:
-- 
2.25.1

