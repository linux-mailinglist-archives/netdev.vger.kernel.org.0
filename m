Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3883F1444
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbhHSHSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:18:20 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:33160 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231951AbhHSHST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:18:19 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C8C449C0085;
        Thu, 19 Aug 2021 07:17:41 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wbb0mlX9JKbJkN9PHuzy9OlUh4wPtbI7z9O6m/HWa5+drHnMSWF2eXr03LXl8rixyAWtL57LPgkRX7vwHAy91SjQXdR6HxhldVnDSMsY+C0Hw2SjenctiMlpb/9uwdHDkQW1ks6EM63MaWXfD5M0h8f3twOXgyf8W4hLD7lCAMk3hhJ7QT8xvByUacsc8aDbFEApl8mLvFtTc+0tPeRNYt7aAEZ1j39igKTESl/LV27NwkF9GkMh+VM7lnGB+tTG8FdNQ/sftv4kuLJhiWfpvZMIOOXwFUdDgvhnAYCd3cryJGU793HLgYHL0yk+7sZKsl0qQu6jPAIpfX///QSAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZjHQsB2vf3/J30xtwqKw56g1cA6e57mcT9A2poYGMk=;
 b=OjioCAFzM31VBtVjS708i2coQlrywIZIbuJP5mESZNlaCyd1LQUaU20HiKsVqqOgGnNoqtyNggJiQDR0bpJQlTu595sMwLqHJDHvpNEourNLtX8EDGtUxp5C48We9CG9wypITph8nn0QCsFql0nmSyJFxAVu2pE4yhSI+Yz4X3OozEGhsKeeybHdUSriPY+bmaArmiLelbStgwVAsOtYV62MmrLL68RavY20LmUNlzRjfLOd1D4QZ0x3zH8dbLlKV7RmrSTJD9Wkz+flLZwdSLtf4yd0Rr81+2mmEAXZakMnTM9Gctv/jB3GdZl/1zsZlIsxulBLLjAfDtpiMR62gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ZjHQsB2vf3/J30xtwqKw56g1cA6e57mcT9A2poYGMk=;
 b=amw2weTSyD5S1KIOQDnJCozAvVJKtJ3d4moVGYXhk6A67LO6192uOp6ctGW7PHBe52jWB3o+ZvEEPuUJmNYCEnMJKzl96urFmzknqm7GLDRr1hUzwo/8+xNMBdmqAbkIDGMlJMaHhcYYqR6aDCe2BP3JBvo/ShINLmNmFzAYVE0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=drivenets.com;
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AM5PR0801MB1858.eurprd08.prod.outlook.com (2603:10a6:203:47::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 19 Aug
 2021 07:17:40 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 07:17:40 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     davem@davemloft.net, kuba@kernel.org, luwei32@huawei.com,
        gnaaman@drivenets.com, wangxiongfeng2@huawei.com,
        ap420073@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH v3] net-next: When a bond have a massive amount of VLANs with IPv6 addresses, performance of changing link state, attaching a VRF, changing an IPv6 address, etc. go down dramtically.
Date:   Thu, 19 Aug 2021 10:17:27 +0300
Message-Id: <20210819071727.1257434-1-gnaaman@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0185.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::10) To AM6PR08MB4118.eurprd08.prod.outlook.com
 (2603:10a6:20b:aa::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gnaaman-pc.dev.drivenets.net (82.166.105.36) by LO4P123CA0185.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a4::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 07:17:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cea273d0-9958-4774-cec7-08d962e16dc1
X-MS-TrafficTypeDiagnostic: AM5PR0801MB1858:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5PR0801MB1858474CDC19816ABF65D89CBEC09@AM5PR0801MB1858.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: soc1b8CLSNweeRV5sA4ysJP84LnI7Fy8qKFZsmsPSVfgntuFPcl6aVGdHz/P+hSCylm4/0UQ1M1TGQJdW7DIGVz6gkgj152tKxyWBjbiPuFLRiCrYyIKOcMBM1Szy4DwXQghpTXT3OYA+6ChEhKaoLI4eAmwim8pY5RXUme54fX0F3lWucgZr9Q2oNtEd8qzwodspJZWGdw4cMFwegzf0y9qh6WJ4BjhtkhPpwhKBM8Rcrfui5Nz5iQQCGMKG5FUTQNB+W+qcoutOeJD6VZggc5EulBHiv/1xlyTXP5MgUjxT9VMp2N4TntOkWEPWM/XtChc+46xQEevQ8nC14PUhT4zvOnYCWk+Jr4uDbxQ/hWJBvz9uq1RIOpmDv1CuIHF3LwX67EMnOf7I11ynvzRpq8HzkyUpRAHmZOHgFe9A7Vps/OLTsaMMDvOhG3a9qY60W+jgUWVKIO7k0dlyWUokVGJYZDuDnztfzSzW7KiTtZEmQ7SZXf6RGeLEKYA+4I6rRdWFYZYbV/rYESgQpq4J6z0Mk0SUbBLHvaku5XED7ZHdh/rAAYR9j8K2Lv9by4NopsDahs1/l9Hv99Zk+d8/RURWWkD+UQ5hdSCIspEBCRgx2zSDWvdd9UXy7fy90NfOoGa1lbd2iiYw7bRKZIPHXLyafebp8Wzt6YScCTeheGySwbY36pXEsOjX6ubfHXnN6cWX0iDAQAl27yuX6uOtC8Sxj3zDbetFJmNm7SnVWzUgdWhFsiwgyAtMbaF/S3i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39830400003)(136003)(396003)(366004)(66946007)(26005)(6512007)(4326008)(186003)(66476007)(30864003)(38100700002)(1076003)(66556008)(38350700002)(52116002)(316002)(36756003)(6506007)(5660300002)(8936002)(83380400001)(2906002)(478600001)(956004)(2616005)(8676002)(86362001)(6666004)(6486002)(14583001)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R9IJgkcdy+aMpNRk2uftVWePojVQ4LAw37x1jlrYawh0Aa7y7luZKVHSkuCv?=
 =?us-ascii?Q?N2d6K++387gUGhgsvLxdzJvqeucOCS2fU9dka/26ucTTz1IFE18PsqrtyDI0?=
 =?us-ascii?Q?uPiPeYWBwoJ3NcNnOe8K+7qieeruwZDg1gmng83Ax4lerEpdgcj6abecLMUq?=
 =?us-ascii?Q?5esVeKEJCquok9RLSEmV9Ke2xBcZhdCOyFbqW9wPFD5i7RMx6J2gG1PGjqB2?=
 =?us-ascii?Q?lrCebQt6Rx/qUicT8EBin58+a5Q3asqrIu4oroLXTEiIN4GXXEVwsanNSILm?=
 =?us-ascii?Q?pEoZCJL3D3NJFLPtXTkVmwlCeregyFERpUEzqnB9zQKl/KJX1r3wa6wtL79m?=
 =?us-ascii?Q?8tSBsqkNmxskY09lYCCSoePD/1q2Bmf8EqHFLTKEv3v2GvK4jRJaj37vJJ6v?=
 =?us-ascii?Q?sM9jg6go4dggtk8W3pMqMstTE3CCW0i0Kio0BO6LSxJtetWdG8DDV9raP211?=
 =?us-ascii?Q?K7TSi4R/Ji1NTspVhq+EnVQ8Hv9SYWuRcBZEAtQM1IOUBk9rEQs6g06/jDOV?=
 =?us-ascii?Q?gk4XLLS0n45Yt/R/9kx/0seQUuzZTzXVn3D///8WZE4KEu4nIq/5zdaF2MqK?=
 =?us-ascii?Q?VzAlgiLWw6tttZsovAW7dSl2+9KxFGWGU+llzwit1kHCv9N116j1wb7LAEqL?=
 =?us-ascii?Q?tvPlHL7BcJahFX6YXuOQ0wijwpHSJs826goVrYPwH3pv898ftgu9EdowOVw4?=
 =?us-ascii?Q?pxrTzLLcvA467vHk5mfTz1MYM/KaDu96DQqIU2xEc7ZzGA0embV8Oc2HHMqf?=
 =?us-ascii?Q?kgtN+u/sFuHjH1g86vmvAbCNhlTUe1z63wCnmMAkmH3YzNp4fD/2TP69t8XN?=
 =?us-ascii?Q?VXhkUGCjbG04KbSzrrCjroptkcDWA5rYULHe/3OvfwDgbeZxkHyvw8zSxGKN?=
 =?us-ascii?Q?eSgybUvrftOolW0MORXQRC+lW972ZmXPSWSAxBKCYBGxdgBEIQhFkG/VcNTl?=
 =?us-ascii?Q?vo8ysltuCXUCBwceOF+qs63NQ7pbWqnbeab5Zi8sVJ5ZTypO8PS+p0AAPtVf?=
 =?us-ascii?Q?lEOoRNJwN/S4HWNdWAoAMr9njuHG/Qw9kSk5+sSWlCMzVR5oiTb2IObH8w4D?=
 =?us-ascii?Q?zMye5Qsvco7OYN2sS6WJ+c5mCe/e2hZvOqe/n87G/hzLWc9CCcJn40vKweT+?=
 =?us-ascii?Q?Zj0n8rLdcE4ppnGuhxtZFDzhFZCNZ+IJKNEgkidozVygFd3jQGkIQrvGZE83?=
 =?us-ascii?Q?Fk4Bh6qJYTUmXuu9q0IvCqVB2ENZg8JoD2J6JEdY+l67HcgDF7fymVNc0Eoh?=
 =?us-ascii?Q?SRL3l8YPMfFftv6VsjNYRnF5oq4GnYng3xZfd+lkgp+zqJqwXX6yn279WX/x?=
 =?us-ascii?Q?OOhoWx0HtRgBMpF9uZM1zui7?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cea273d0-9958-4774-cec7-08d962e16dc1
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 07:17:40.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jq3P7MDx/4ig3OpYYHanfBQYO7G6IpxLxf1WklHD5qoXqcsK9io/8VXH02suHloE6ViMcW4XShKVff7kiCvViQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1858
X-MDID: 1629357462-g_MxSwArIlvv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

In version 1, Nikolay Aleksandrov <nikolay@nvidia.com> asked
why not remove the list entirely in favour of the tree.

Altough this sounds like the right solution,
I am not sure it's possible to do this with RCU-safety in mind, and I
doubt my ability to correctly patch every place in the kernel that uses
the list without introducing further bugs.

v1 -> v2:
	- Formatting/typo fixes
	- Retarget net-next
v2 -> v3:
	- Exclude first list address from tree because it can be
	  changed via `dev->dev_addr` (Thanks <isaac@speedb.io>)

---
 include/linux/netdevice.h |   5 ++
 net/core/dev_addr_lists.c | 144 ++++++++++++++++++++++++++------------
 2 files changed, 103 insertions(+), 46 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 11a52f2fa..c84db4379 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -48,6 +48,7 @@
 #include <uapi/linux/if_bonding.h>
 #include <uapi/linux/pkt_cls.h>
 #include <linux/hashtable.h>
+#include <linux/rbtree.h>
 
 struct netpoll_info;
 struct device;
@@ -202,6 +203,7 @@ struct sk_buff;
 
 struct netdev_hw_addr {
 	struct list_head	list;
+	struct rb_node		node;
 	unsigned char		addr[MAX_ADDR_LEN];
 	unsigned char		type;
 #define NETDEV_HW_ADDR_T_LAN		1
@@ -219,6 +221,9 @@ struct netdev_hw_addr {
 struct netdev_hw_addr_list {
 	struct list_head	list;
 	int			count;
+
+	/* Auxiliary tree for faster lookup on addition and deletion */
+	struct rb_root		tree;
 };
 
 #define netdev_hw_addr_list_count(l) ((l)->count)
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index 2f949b5a1..dc9bc01f2 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -16,10 +16,9 @@
  * General list handling functions
  */
 
-static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
-			       const unsigned char *addr, int addr_len,
-			       unsigned char addr_type, bool global,
-			       bool sync)
+static struct netdev_hw_addr*
+__hw_addr_create(const unsigned char *addr, int addr_len,
+		 unsigned char addr_type, bool global, bool sync)
 {
 	struct netdev_hw_addr *ha;
 	int alloc_size;
@@ -29,32 +28,44 @@ static int __hw_addr_create_ex(struct netdev_hw_addr_list *list,
 		alloc_size = L1_CACHE_BYTES;
 	ha = kmalloc(alloc_size, GFP_ATOMIC);
 	if (!ha)
-		return -ENOMEM;
+		return NULL;
 	memcpy(ha->addr, addr, addr_len);
 	ha->type = addr_type;
 	ha->refcount = 1;
 	ha->global_use = global;
 	ha->synced = sync ? 1 : 0;
 	ha->sync_cnt = 0;
-	list_add_tail_rcu(&ha->list, &list->list);
-	list->count++;
 
-	return 0;
+	return ha;
 }
 
 static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 			    const unsigned char *addr, int addr_len,
 			    unsigned char addr_type, bool global, bool sync,
-			    int sync_count)
+			    int sync_count, bool exclusive)
 {
+	struct rb_node **ins_point = &list->tree.rb_node, *parent = NULL;
 	struct netdev_hw_addr *ha;
 
 	if (addr_len > MAX_ADDR_LEN)
 		return -EINVAL;
 
-	list_for_each_entry(ha, &list->list, list) {
-		if (ha->type == addr_type &&
-		    !memcmp(ha->addr, addr, addr_len)) {
+	while (*ins_point) {
+		int diff;
+
+		ha = rb_entry(*ins_point, struct netdev_hw_addr, node);
+		diff = memcmp(addr, ha->addr, addr_len);
+		if (diff == 0)
+			diff = memcmp(&addr_type, &ha->type, sizeof(addr_type));
+
+		parent = *ins_point;
+		if (diff < 0) {
+			ins_point = &parent->rb_left;
+		} else if (diff > 0) {
+			ins_point = &parent->rb_right;
+		} else {
+			if (exclusive)
+				return -EEXIST;
 			if (global) {
 				/* check if addr is already used as global */
 				if (ha->global_use)
@@ -73,8 +84,25 @@ static int __hw_addr_add_ex(struct netdev_hw_addr_list *list,
 		}
 	}
 
-	return __hw_addr_create_ex(list, addr, addr_len, addr_type, global,
-				   sync);
+	ha = __hw_addr_create(addr, addr_len, addr_type, global, sync);
+	if (!ha)
+		return -ENOMEM;
+
+	/* The first address in dev->dev_addrs is pointed to by dev->dev_addr
+	 * and mutated freely by device drivers and netdev ops, so if we insert
+	 * it into the tree we'll end up with an invalid rbtree.
+	 */
+	if (list->count > 0) {
+		rb_link_node(&ha->node, parent, ins_point);
+		rb_insert_color(&ha->node, &list->tree);
+	} else {
+		RB_CLEAR_NODE(&ha->node);
+	}
+
+	list_add_tail_rcu(&ha->list, &list->list);
+	list->count++;
+
+	return 0;
 }
 
 static int __hw_addr_add(struct netdev_hw_addr_list *list,
@@ -82,7 +110,7 @@ static int __hw_addr_add(struct netdev_hw_addr_list *list,
 			 unsigned char addr_type)
 {
 	return __hw_addr_add_ex(list, addr, addr_len, addr_type, false, false,
-				0);
+				0, false);
 }
 
 static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
@@ -103,24 +131,61 @@ static int __hw_addr_del_entry(struct netdev_hw_addr_list *list,
 
 	if (--ha->refcount)
 		return 0;
+
+	if (!RB_EMPTY_NODE(&ha->node))
+		rb_erase(&ha->node, &list->tree);
+
 	list_del_rcu(&ha->list);
 	kfree_rcu(ha, rcu_head);
 	list->count--;
 	return 0;
 }
 
+static struct netdev_hw_addr *__hw_addr_lookup(struct netdev_hw_addr_list *list,
+					       const unsigned char *addr, int addr_len,
+					       unsigned char addr_type)
+{
+	struct netdev_hw_addr *ha;
+	struct rb_node *node;
+
+	/* The first address isn't inserted into the tree because in the dev->dev_addrs
+	 * list it's the address pointed to by dev->dev_addr which is freely mutated
+	 * in place, so we need to check it separately.
+	 */
+	ha = list_first_entry(&list->list, struct netdev_hw_addr, list);
+	if (ha && !memcmp(addr, ha->addr, addr_len) &&
+	    (!addr_type || addr_type == ha->type))
+		return ha;
+
+	node = list->tree.rb_node;
+
+	while (node) {
+		struct netdev_hw_addr *ha = rb_entry(node, struct netdev_hw_addr, node);
+		int diff = memcmp(addr, ha->addr, addr_len);
+
+		if (diff == 0 && addr_type)
+			diff = memcmp(&addr_type, &ha->type, sizeof(addr_type));
+
+		if (diff < 0)
+			node = node->rb_left;
+		else if (diff > 0)
+			node = node->rb_right;
+		else
+			return ha;
+	}
+
+	return NULL;
+}
+
 static int __hw_addr_del_ex(struct netdev_hw_addr_list *list,
 			    const unsigned char *addr, int addr_len,
 			    unsigned char addr_type, bool global, bool sync)
 {
-	struct netdev_hw_addr *ha;
+	struct netdev_hw_addr *ha = __hw_addr_lookup(list, addr, addr_len, addr_type);
 
-	list_for_each_entry(ha, &list->list, list) {
-		if (!memcmp(ha->addr, addr, addr_len) &&
-		    (ha->type == addr_type || !addr_type))
-			return __hw_addr_del_entry(list, ha, global, sync);
-	}
-	return -ENOENT;
+	if (!ha)
+		return -ENOENT;
+	return __hw_addr_del_entry(list, ha, global, sync);
 }
 
 static int __hw_addr_del(struct netdev_hw_addr_list *list,
@@ -137,7 +202,7 @@ static int __hw_addr_sync_one(struct netdev_hw_addr_list *to_list,
 	int err;
 
 	err = __hw_addr_add_ex(to_list, ha->addr, addr_len, ha->type,
-			       false, true, ha->sync_cnt);
+			       false, true, ha->sync_cnt, false);
 	if (err && err != -EEXIST)
 		return err;
 
@@ -407,6 +472,7 @@ static void __hw_addr_flush(struct netdev_hw_addr_list *list)
 {
 	struct netdev_hw_addr *ha, *tmp;
 
+	list->tree = RB_ROOT;
 	list_for_each_entry_safe(ha, tmp, &list->list, list) {
 		list_del_rcu(&ha->list);
 		kfree_rcu(ha, rcu_head);
@@ -418,6 +484,7 @@ void __hw_addr_init(struct netdev_hw_addr_list *list)
 {
 	INIT_LIST_HEAD(&list->list);
 	list->count = 0;
+	list->tree = RB_ROOT;
 }
 EXPORT_SYMBOL(__hw_addr_init);
 
@@ -552,22 +619,14 @@ EXPORT_SYMBOL(dev_addr_del);
  */
 int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	struct netdev_hw_addr *ha;
 	int err;
 
 	netif_addr_lock_bh(dev);
-	list_for_each_entry(ha, &dev->uc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
-		    ha->type == NETDEV_HW_ADDR_T_UNICAST) {
-			err = -EEXIST;
-			goto out;
-		}
-	}
-	err = __hw_addr_create_ex(&dev->uc, addr, dev->addr_len,
-				  NETDEV_HW_ADDR_T_UNICAST, true, false);
+	err = __hw_addr_add_ex(&dev->uc, addr, dev->addr_len,
+			       NETDEV_HW_ADDR_T_UNICAST, true, false,
+			       0, true);
 	if (!err)
 		__dev_set_rx_mode(dev);
-out:
 	netif_addr_unlock_bh(dev);
 	return err;
 }
@@ -736,22 +795,14 @@ EXPORT_SYMBOL(dev_uc_init);
  */
 int dev_mc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	struct netdev_hw_addr *ha;
 	int err;
 
 	netif_addr_lock_bh(dev);
-	list_for_each_entry(ha, &dev->mc.list, list) {
-		if (!memcmp(ha->addr, addr, dev->addr_len) &&
-		    ha->type == NETDEV_HW_ADDR_T_MULTICAST) {
-			err = -EEXIST;
-			goto out;
-		}
-	}
-	err = __hw_addr_create_ex(&dev->mc, addr, dev->addr_len,
-				  NETDEV_HW_ADDR_T_MULTICAST, true, false);
+	err = __hw_addr_add_ex(&dev->mc, addr, dev->addr_len,
+			       NETDEV_HW_ADDR_T_MULTICAST, true, false,
+			       0, true);
 	if (!err)
 		__dev_set_rx_mode(dev);
-out:
 	netif_addr_unlock_bh(dev);
 	return err;
 }
@@ -764,7 +815,8 @@ static int __dev_mc_add(struct net_device *dev, const unsigned char *addr,
 
 	netif_addr_lock_bh(dev);
 	err = __hw_addr_add_ex(&dev->mc, addr, dev->addr_len,
-			       NETDEV_HW_ADDR_T_MULTICAST, global, false, 0);
+			       NETDEV_HW_ADDR_T_MULTICAST, global, false,
+			       0, false);
 	if (!err)
 		__dev_set_rx_mode(dev);
 	netif_addr_unlock_bh(dev);
-- 
2.25.1

