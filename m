Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A929478374
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 04:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhLQDBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 22:01:17 -0500
Received: from mail-vi1eur05on2107.outbound.protection.outlook.com ([40.107.21.107]:39337
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229471AbhLQDBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 22:01:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXgtth7Pl60RpthujR09ApEsDZ6Mn1L45nIdQ7QJpEGRw9OOpxvuWQkRoPlOwGoZF1I2P70A4//qnJK98uYqO8yU1whf3Os5NlLgTeCp3+MDHZzkIXjPcpBZUBeWReqyIrII9JtS2JqcI6eMDGiP/bwfKfGWvNZoaBxpEfGx50DW5VIU4OKSUcCPRMKAlAG9mMObcQwP6d90LBCKDk4j0wkuZlq2Vxg9wEjgbgfrL/L8RLWLgVhnyFzdAGCrYllr0b5H0bRRz2GXC10LfAXpN8dOHjzb0sdZGhLmQ5mR7iF4SkItq0DGJAkrjZQLnQ4pj8oMgky8aK4HskSFuipVog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UeIdukzHBf/JZsN7ZN0kzDzIc+8V7mDabCS5DVlKb34=;
 b=G5giOs69QE+bMaa7jXBi+V1I50hvuWHtpNFMyPFFG/2xKxtutsDlX1qzy2vsqc326n0Y2QV56692/dsn7SL91Jg2R7NnRfyMZDR+MuLYwvt31xOS30MPY+DA/+fzRUEpZKMsZxnrD/cEr6K/TRIyFt7Z/7qQFixQnk80krZJ1vGYGM8JCC9QgiJ9mZjv74XDmadpsfTjfHyIk0aMW3xjtHtHvKN3muRIJO7TisOe8MGpQvaSrrlaQduDuyYmzuIWkStJ0I4jGUrQ7Ivy52SppOKZZTBFzX5c0UXoSumAuxO9zpVzDfHOYPq9zCuSTJr/IbdJsrloW1y2UQ/tjr25Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UeIdukzHBf/JZsN7ZN0kzDzIc+8V7mDabCS5DVlKb34=;
 b=jAQSuKw0TXtZBB/x/o3EYaf/zAJmDE8WrdIyn3ASc2mXo/0XaCT9PX7Xs2C0vdkSPK6ttrydNXSq7872zuNk7TBfRTkIYwIPtUqDFSGhVD8PF1yqgvZv4T+xYO+RdVKcX0ffCIdmNN9tlzcoXNxKlAVYk7TkPB7a2jiRbUknfJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com (2603:10a6:800:1b0::18)
 by VI1PR0502MB2960.eurprd05.prod.outlook.com (2603:10a6:800:ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Fri, 17 Dec
 2021 03:01:13 +0000
Received: from VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::ddd6:43ae:be54:f697]) by VE1PR05MB7327.eurprd05.prod.outlook.com
 ([fe80::ddd6:43ae:be54:f697%5]) with mapi id 15.20.4801.014; Fri, 17 Dec 2021
 03:01:13 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, eric.dumazet@gmail.com
Subject: [net-next] Revert "tipc: use consistent GFP flags"
Date:   Fri, 17 Dec 2021 10:00:59 +0700
Message-Id: <20211217030059.5947-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0111.apcprd03.prod.outlook.com
 (2603:1096:203:b0::27) To VE1PR05MB7327.eurprd05.prod.outlook.com
 (2603:10a6:800:1b0::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39e4ac94-bf45-410d-ca73-08d9c1097be3
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2960:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2960D4F0A1D24639405447F7F1789@VI1PR0502MB2960.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W5jYcqLw82uwWUbj1rk8R0Gda1zOMESWInV15Mgt/LrQah9+U2+z9FjXmKcRNQQv/s9EYvFt2cMaZBX4rVxjl4sgAEq9WHnLkjqGZEw+5/UPKVKstu0pURQ7JexxpPMiHQZCmuqLMMnBeEbaoHsC9Ycwteuvdoz1C1ZF5pLczrPi+48KXm+3tzwlHca/r/UKgwVDs7lW1aJ262Vj3B5LviTII3G88UGcXz8xS0/bo5hj3IpcIwvvIH0mEcWE9df3W+Rqs70pK0/ADurq+22Ujn8Gl/kLO9fOIlZPPuzxcBeDSwJfYX6C8scB+Bfh1cKbtCp9dR58ZSQSJHjMQbOeHk5m9JuPtNvdao38ekSFe7wLWPbAOtP08+SiL5Higi0FNVzwfh8eqJRaepsAs+OsqB4vJnNA/iVw4TtqUyKwg2V0xEX27OJ/C8sb7iVJdtGV0ez35c53aHZYKnVShXqpyuc+hU1m8W/QVZn/jWKtcNxF/tfFYjS6TOLWmlQByiC9+621bXpDcY35fagbA8TTH2sToDgvJkF/XejDi1ItfMaLDRan0Secz/7sqMtlZFg0Z4QTIZvxa1ucZy+qrmFLqUbxmfwZIldAx5U8Zy+k5jXzQvu1uIe0iQujAu1/0Rbt3/Tjtisc6k9NSUgHiiqsInCKwfHUWzffPd7UamLnazSczsshHPunW3vS1nGEiNtmAm7bKyPmICh8NXkf/pLVgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR05MB7327.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(26005)(38100700002)(38350700002)(8676002)(55236004)(6506007)(52116002)(508600001)(8936002)(2906002)(36756003)(5660300002)(103116003)(316002)(186003)(86362001)(66476007)(1076003)(6666004)(66946007)(2616005)(66556008)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bL+8lzBfTquH/OAtASwMvGnXJJ2jUx9j2NVzr3WSnlfTeMVw1nNdZEk2RHwU?=
 =?us-ascii?Q?o/KfxSq2Kq+v7D0aFYAFVe3tHhezON4FCL6QHouHsINug2Rmg3ewv661jo0I?=
 =?us-ascii?Q?/rmLIC4a53pZJE9fG768ly50C4eqsq/wMq7Os5WTD2RxU4LMVU7JLXzqhQBE?=
 =?us-ascii?Q?fwzeQ21JDZwUroTuc8CSdIA2ni5qYlPnUh0xWcc56EhAK0wgwx9CQ2Cf2jA+?=
 =?us-ascii?Q?wXRNMc+PKJ3S79QpzRq7bU+OVjh+u2RjPWHUzhRNLxEaBcDemGMPyD4oK6cn?=
 =?us-ascii?Q?Xgcdps9acl3r9YsZ3MdzlnEEj5/06gvN20tlMHy1YLuBwf/rrK72qOwp2TLA?=
 =?us-ascii?Q?8fpB08VAfNe9njyOl2M6AWJSOF4XCcn0i/KTEjU/y+wEgw5YSmSo7/rx2tt9?=
 =?us-ascii?Q?NEwRAEsVmfZhmgk6g3w71zz6W9LH447AXkwMNyL2kxm3dlOUBiGmGrU/2Pwq?=
 =?us-ascii?Q?T3v7ruXZOPS+y/xRQ7Ff6Q18rBIqrhab4fjKRrTBTqIPXXUMv+5EYGdMirOX?=
 =?us-ascii?Q?9jccGLL3xU2UH4N3BOYVc7oWJo8tRMernSD8LMmaS0gtEQ2YsuFffig2+iRX?=
 =?us-ascii?Q?KeOEX5kQS836rPuz5YP6Oyid2TrTT71Ss/zTj6VtLJBeqsuvOOCEmWyjWq/V?=
 =?us-ascii?Q?ae8WTLdTLiAb4ne9WtnLK0EpHsJcIE3S0sb/bssLyAwLeQxPU811/LqMh7sE?=
 =?us-ascii?Q?K+uEquPcXkenBSADBeZK/qQR/IyaJ0GSTuuYexWNzfPpfAwlwBSqPtwXy8TQ?=
 =?us-ascii?Q?lH75CQPKZ+CoYB7fm5eJbhGqlrGbg70EAPE9zZwxgOx8XkebXF69HW6GJ9ZB?=
 =?us-ascii?Q?fLdeI18Vg40yNqkTXQVKVW8kerGgo3h7QyG5KQZyOVdU85GTp40JB4x95Tzu?=
 =?us-ascii?Q?VhjFfm1/pczruZ+d6gQAP2/LUpRZ95wO8c5Tt5PpinyuaOP06k7t5W7ITAwk?=
 =?us-ascii?Q?bJwp7Xn9gt4wQy8Wx5LUX3BdgpCL+KP2a2Tc84DM3McHspHwixiQkro43qKn?=
 =?us-ascii?Q?y7KDTPd5YfodwugHEHMQ8E9mcP6cs/86gB1vdupuaTzY7sikF/mt5GmHFZt7?=
 =?us-ascii?Q?AY9FvPxlrXwrsI/zOGcVE4+eZjfJ3oOM1551nI57dF97yHp9GCIo9HioCv0m?=
 =?us-ascii?Q?67KL+LDyFQa3Do2ZEpaljK3CwMJULe8eeoYOU1hBdSyVcfoPjI21cpMKJXxm?=
 =?us-ascii?Q?XEPhPSM5XjzvSyjuGXNCSx4cyGTypz6WF7td/LZLjWqNq4PnbM4O7fdYouU4?=
 =?us-ascii?Q?HcFz0tjoj864j4pPY0KMOTcCkWQTCegzlNPy6qD5Mh6naeG6U2/bvAlSv7Qa?=
 =?us-ascii?Q?3mxhyjApzO0FmuFgOyf1d2vG0TWnGnx9F5JbJG9AUGob9AAPKOM1xjkxbiyN?=
 =?us-ascii?Q?QPAWRPvNx6a+8GmahbJbZIdqi+ovepg2gkzPvn5Q9HWf6AtF0QgE/vMnnq5N?=
 =?us-ascii?Q?1uLhs04eaukNr6ACK96vuo96LCGJfmCKf7mtTlbjlOuR+TRi51rGq98XRllV?=
 =?us-ascii?Q?U5s8LWIeVNMh6+b+25qNx2JX7Y+AtvkCM+V+54X5MlPLugOEERmLYr3tFYg2?=
 =?us-ascii?Q?NmmVuqbI9/TUcyoU6OU1WvQG2ejR4nu8idHD/Yec9OlZvCt/AQZ8Vx+GfiMp?=
 =?us-ascii?Q?2yH4O0vVmpIpDVKjsLZXUC/KpT58LBxraSREoHX7r9K704h92jLlxm7R9ix/?=
 =?us-ascii?Q?6bE6DO+JVt4UDYOMu2b4kfHX00A=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e4ac94-bf45-410d-ca73-08d9c1097be3
X-MS-Exchange-CrossTenant-AuthSource: VE1PR05MB7327.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 03:01:13.0254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ynJGJgGvR67BG4ypRyW5cw1RfEr7X4l8aX/NNy7wkaa5wZz7oubWzK2LH3N+XM2c4P7+ewO8eWQBZjLRkWGz1ZfHGY0ZQcL1L18uOiw41w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2960
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 86c3a3e964d910a62eeb277d60b2a60ebefa9feb.

The tipc_aead_init() function can be calling from an interrupt routine.
This allocation might sleep with GFP_KERNEL flag, hence the following BUG
is reported.

[   17.657509] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:230
[   17.660916] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/3
[   17.664093] preempt_count: 302, expected: 0
[   17.665619] RCU nest depth: 2, expected: 0
[   17.667163] Preemption disabled at:
[   17.667165] [<0000000000000000>] 0x0
[   17.669753] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G        W         5.16.0-rc4+ #1
[   17.673006] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
[   17.675540] Call Trace:
[   17.676285]  <IRQ>
[   17.676913]  dump_stack_lvl+0x34/0x44
[   17.678033]  __might_resched.cold+0xd6/0x10f
[   17.679311]  kmem_cache_alloc_trace+0x14d/0x220
[   17.680663]  tipc_crypto_start+0x4a/0x2b0 [tipc]
[   17.682146]  ? kmem_cache_alloc_trace+0xd3/0x220
[   17.683545]  tipc_node_create+0x2f0/0x790 [tipc]
[   17.684956]  tipc_node_check_dest+0x72/0x680 [tipc]
[   17.686706]  ? ___cache_free+0x31/0x350
[   17.688008]  ? skb_release_data+0x128/0x140
[   17.689431]  tipc_disc_rcv+0x479/0x510 [tipc]
[   17.690904]  tipc_rcv+0x71c/0x730 [tipc]
[   17.692219]  ? __netif_receive_skb_core+0xb7/0xf60
[   17.693856]  tipc_l2_rcv_msg+0x5e/0x90 [tipc]
[   17.695333]  __netif_receive_skb_list_core+0x20b/0x260
[   17.697072]  netif_receive_skb_list_internal+0x1bf/0x2e0
[   17.698870]  ? dev_gro_receive+0x4c2/0x680
[   17.700255]  napi_complete_done+0x6f/0x180
[   17.701657]  virtnet_poll+0x29c/0x42e [virtio_net]
[   17.703262]  __napi_poll+0x2c/0x170
[   17.704429]  net_rx_action+0x22f/0x280
[   17.705706]  __do_softirq+0xfd/0x30a
[   17.706921]  common_interrupt+0xa4/0xc0
[   17.708206]  </IRQ>
[   17.708922]  <TASK>
[   17.709651]  asm_common_interrupt+0x1e/0x40
[   17.711078] RIP: 0010:default_idle+0x18/0x20

Fixes: 86c3a3e964d9 ("tipc: use consistent GFP flags")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/crypto.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 81116312b753..9325479295b8 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -524,7 +524,7 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 		return -EEXIST;
 
 	/* Allocate a new AEAD */
-	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);
 	if (unlikely(!tmp))
 		return -ENOMEM;
 
@@ -1463,7 +1463,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 		return -EEXIST;
 
 	/* Allocate crypto */
-	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	c = kzalloc(sizeof(*c), GFP_ATOMIC);
 	if (!c)
 		return -ENOMEM;
 
@@ -1477,7 +1477,7 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	}
 
 	/* Allocate statistic structure */
-	c->stats = alloc_percpu(struct tipc_crypto_stats);
+	c->stats = alloc_percpu_gfp(struct tipc_crypto_stats, GFP_ATOMIC);
 	if (!c->stats) {
 		if (c->wq)
 			destroy_workqueue(c->wq);
@@ -2450,7 +2450,7 @@ static void tipc_crypto_work_tx(struct work_struct *work)
 	}
 
 	/* Lets duplicate it first */
-	skey = kmemdup(aead->key, tipc_aead_key_size(aead->key), GFP_KERNEL);
+	skey = kmemdup(aead->key, tipc_aead_key_size(aead->key), GFP_ATOMIC);
 	rcu_read_unlock();
 
 	/* Now, generate new key, initiate & distribute it */
-- 
2.30.2

