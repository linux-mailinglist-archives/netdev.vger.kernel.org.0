Return-Path: <netdev+bounces-9569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F88729D15
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:39:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8D401C20E88
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A7D174E0;
	Fri,  9 Jun 2023 14:39:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8447B171B4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:39:19 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BC31BFF;
	Fri,  9 Jun 2023 07:39:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD/V9Uzqq9cPFO7LeSRysVp7i5d9MRKCHocsGMal3LtIJ4dc+tOT84u+Oz/c5D4FWoLQhwHHfnRortHD/K6ufXvfO3ebhV710dvr8lnegQXw4pjCfMKoqCkIQocV7V3nlEpjhcLMFx/CM31EZUQDe9REyZvCOTdGyuAiD/+HLdFT08Wh6eDwX33rWTHchrUjFyiI/Ak544Z5WrosuqB/DpgFQ8UUn7ROjbMQ1n1/LmXpcctGogu9QWZXCE5H0Z71zUNWvyTaw8RSbfD6nf7lH7a1MP6uCOKXTdmIULPU9FtnkkJLrwU+Z0kM1toXA7BCAhPJxorFCELWX1Ac0UXd5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X223P47xiOyiA6AnXC9sh3tg1ii+vMm+98AcE/VPfh8=;
 b=YNzRMV+st0gxY4wMJopR1Rv0cTbOQX7EtIBJj219efVYpVirMV6E+7RjgNS93i0uf62yoy5LpgY0cMXR1qGI5/PQ2bQoLNHAqETKkBHGUfFTCgBTiRUfXrPv6rUO2WFfmd7DRb6ysiwuz9AuteBG/SgrRFt1fxl41NO/16FMKVZSqKtELh1sqOUyvU5TicYpMBX2YdP01kj3h6Hxb7+Rhmz1t58/6oONRKe7e4qHKaVxURzeL3VVwbNjCPYlJUnM4awRtWjezxuvocAnuI9KjXaanm1LteUBqwK/2tmImGNxG/HcH6rTfVaXB4swzrPFN4KaD0AjczCxXlSt1yNovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X223P47xiOyiA6AnXC9sh3tg1ii+vMm+98AcE/VPfh8=;
 b=mXi7ztaRA/SNVhZvDbTeXeBejpTGOMqfRXOzgKkrFztDuKrq0PXsKSmDtujf9YGwh9hvpHpKEGRfF2SnCApWWZlvt/rgsxCRwZmdssh4uqpoHRwVGoE7ipEfDxD6zqj4yTiRRasQ1XANRQz3vorxakEmTN1HildpCejAZxrWYYN+sY7fOThWdufvU0DB24mOSlvJx9T1hnh796FRG9HnKOYZ2UzLcqB3EdiI4Dla1cO/FAUCy3udtzG4Big8+DhjO4Sukst3VlUB+i9TMHz6eO4EWXa7hJ5VGSyXN9cv46hIUOyx6+Nm6RRPWe2FqEBXFWWu+KEuk0C/iEdlwWBNTQ==
Received: from MW4PR04CA0220.namprd04.prod.outlook.com (2603:10b6:303:87::15)
 by SA3PR12MB9105.namprd12.prod.outlook.com (2603:10b6:806:382::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Fri, 9 Jun
 2023 14:39:15 +0000
Received: from CO1PEPF000044FA.namprd21.prod.outlook.com
 (2603:10b6:303:87:cafe::8b) by MW4PR04CA0220.outlook.office365.com
 (2603:10b6:303:87::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.27 via Frontend
 Transport; Fri, 9 Jun 2023 14:39:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044FA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.14 via Frontend Transport; Fri, 9 Jun 2023 14:39:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 07:39:06 -0700
Received: from fedora.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 9 Jun 2023
 07:39:02 -0700
References: <20230609094659.4004660-1-renmingshuai@huawei.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: renmingshuai <renmingshuai@huawei.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <liaichun@huawei.com>, <caowangbao@huawei.com>,
	<yanan@huawei.com>, <liubo335@huawei.com>
Subject: Re: [PATCH v2] net/sched: Set the flushing flags to false to
 prevent an infinite loop and add one test to tdc
Date: Fri, 9 Jun 2023 17:35:02 +0300
In-Reply-To: <20230609094659.4004660-1-renmingshuai@huawei.com>
Message-ID: <87legswvi3.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FA:EE_|SA3PR12MB9105:EE_
X-MS-Office365-Filtering-Correlation-Id: 54fe97b9-7c7c-4887-03a2-08db68f74c01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A1zUx+/hjngN04Qpgsu1IEmNqIt7l3feeiomy3GhgZIR8CZ1YMq+BPTRjvNe9aUkD1ONiS0/bgJtBjXsdLkQHPv3KB2t05OET1HH1NkEOHAZ9v522T0nFZsSvi0sUanIQ9rcfa8Zjyb4cLlJ2AqFcii+f5K0nDvEaggoNgBZ97lYUthm95DBfAOGTFpqH+g1CPnDawF7+90vhk8SrDamXIaR0A/nozqN5st8jDzwUyyZQU+SDYeEEvWBzggNlXLXr93wjyi6ZMsSQ2aC0MbhRtZufUsQ5mxhh3L5L5u0Fnp4CS2TKTUFD3QpA8P03ONnYpxtIPYY3f3HRAR5fDdmMxFQW8dMBbrTidr1eVbjsilrLfVJNlrVMw1lgIbH6uRznnPNI7R9lsuD4zS17iyH1yYbrsduE3wXpbORniOWaUwI0hff+9XH4CpSzzjRIzoYfkEVZ68YMH2+FbYtK9djdNS2xXv6kNRPxNozA4b66ElKha0KSy6vHCh9PIjVTcgnB7EIjS86caTnjDCMGQk+4OjffFeCJygTrk6Dc7dNwB1AHL822JgmlTmlboa90kEFTLwMQquY9JinDABm9OrmiuD2Xkdgk4TsJmWZM6zpgJUJWhNMlCE3D2ynmG/5vd+1rmReRwKE5DZXLND0q2W2KAGz6oc6KVGaRgQ92Bjj11u0NjegP1Cf90qPBuz2FVxJb2nFsCTeWTRJn6qO0kij5u+QKKwx74UvTkT4mxF5QeHxoSvXqBaGgrt3W6wGONai
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(40470700004)(36840700001)(46966006)(36756003)(2906002)(86362001)(82310400005)(7416002)(5660300002)(40480700001)(47076005)(7696005)(16526019)(186003)(426003)(336012)(83380400001)(36860700001)(26005)(7636003)(356005)(82740400003)(478600001)(40460700003)(54906003)(70586007)(4326008)(6916009)(2616005)(316002)(70206006)(41300700001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 14:39:14.3465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fe97b9-7c7c-4887-03a2-08db68f74c01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9105
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri 09 Jun 2023 at 17:46, renmingshuai <renmingshuai@huawei.com> wrote:
> When a new chain is added by using tc, one soft lockup alarm will be
>  generated after delete the prio 0 filter of the chain. To reproduce
>  the problem, perform the following steps:
> (1) tc qdisc add dev eth0 root handle 1: htb default 1
> (2) tc chain add dev eth0
> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
> (4) tc filter add dev eth0 chain 0 parent 1:
>
>
> The refcnt of the chain added by step 2 is equal to 1. After step 3,
>  the flushing flag of the chain is set to true in the tcf_chain_flush()
>  called by tc_del_tfilter() because the prio is 0. In this case, if
>  we add a new filter to this chain, it will never succeed and try again
>  and again because the refresh flash is always true and refcnt is 1.
>  A soft lock alarm is generated 20 seconds later.

Hi Mingshuai,

Thanks for investigating and reporting this!

> The stack is show as below:
>
> Kernel panic - not syncing: softlockup: hung tasks
> CPU: 2 PID: 3321861 Comm: tc Kdump: loaded Tainted: G
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> Call Trace:
>  <IRQ>
>  dump_stack+0x57/0x6e
>  panic+0x196/0x3ec
>  watchdog_timer_fn.cold+0x16/0x5c
>  __run_hrtimer+0x5e/0x190
>  __hrtimer_run_queues+0x8a/0xe0
>  hrtimer_interrupt+0x110/0x2c0
>  ? irqtime_account_irq+0x49/0xf0
>  __sysvec_apic_timer_interrupt+0x5f/0xe0
>  asm_call_irq_on_stack+0x12/0x20
>  </IRQ>
>  sysvec_apic_timer_interrupt+0x72/0x80
>  asm_sysvec_apic_timer_interrupt+0x12/0x20
> RIP: 0010:mutex_lock+0x24/0x70
> RSP: 0018:ffffa836004ab9a8 EFLAGS: 00000246
> RAX: 0000000000000000 RBX: ffff95bb02d76700 RCX: 0000000000000000
> RDX: ffff95bb27462100 RSI: 0000000000000000 RDI: ffff95ba5b527000
> RBP: ffff95ba5b527000 R08: 0000000000000001 R09: ffffa836004abbb8
> R10: 000000000000000f R11: 0000000000000000 R12: 0000000000000000
> R13: ffff95ba5b527000 R14: ffffa836004abbb8 R15: 0000000000000001
>  __tcf_chain_put+0x27/0x200
>  tc_new_tfilter+0x5e8/0x810
>  ? tc_setup_cb_add+0x210/0x210
>  rtnetlink_rcv_msg+0x2e3/0x380
>  ? rtnl_calcit.isra.0+0x120/0x120
>  netlink_rcv_skb+0x50/0x100
>  netlink_unicast+0x12d/0x1d0
>  netlink_sendmsg+0x286/0x490
>  sock_sendmsg+0x62/0x70
>  ____sys_sendmsg+0x24c/0x2c0
>  ? import_iovec+0x17/0x20
>  ? sendmsg_copy_msghdr+0x80/0xa0
>  ___sys_sendmsg+0x75/0xc0
>  ? do_fault_around+0x118/0x160
>  ? do_read_fault+0x68/0xf0
>  ? __handle_mm_fault+0x3f9/0x6f0
>  __sys_sendmsg+0x59/0xa0
>  do_syscall_64+0x33/0x40
>  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> RIP: 0033:0x7f96705b8247
> RSP: 002b:00007ffe552e9dc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f96705b8247
> RDX: 0000000000000000 RSI: 00007ffe552e9e40 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000558113f678b0
> R10: 00007f967069ab00 R11: 0000000000000246 R12: 00000000647ea089
> R13: 00007ffe552e9f30 R14: 0000000000000001 R15: 0000558113175f00
>
> To avoid this case, set chain->flushing to be false if the chain->refcnt
>  is 2 after flushing the chain when prio is 0. I also add one test to tdc.
>
> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
> Signed-off-by: Mingshuai Ren <renmingshuai@huawei.com>
> Reviewed-by: Aichun Li <Liaichun@huawei.com>
> ---
> V1 -> V2:
>   * Correct the judgment on the value chain->refcnt and add one test to tdc
> ---
>  net/sched/cls_api.c                           |  7 ++++++
>  .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
>  2 files changed, 32 insertions(+)
>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2621550bfddc..3ea054e03fbf 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2442,6 +2442,13 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>  		tfilter_notify_chain(net, skb, block, q, parent, n,
>  				     chain, RTM_DELTFILTER, extack);
>  		tcf_chain_flush(chain, rtnl_held);
> +		/* Set the flushing flags to false to prevent an infinite loop
> +		 * when a new filter is added.
> +		 */
> +		mutex_lock(&chain->filter_chain_lock);
> +		if (chain->refcnt == 2)
> +			chain->flushing = false;
> +		mutex_unlock(&chain->filter_chain_lock);

I don't think this check is enough since there can be concurrent filter
ops holding the reference to the chain. This just makes the issue harder
to reproduce.

I'll try to formulate a fix that takes any potential concurrent users
into account and verify it with your test.

>  		err = 0;
>  		goto errout;
>  	}
> diff --git a/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> new file mode 100644
> index 000000000000..db3b42aaa4fa
> --- /dev/null
> +++ b/tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
> @@ -0,0 +1,25 @@
> +[
> +    {
> +        "id": "c2b4",
> +        "name": "Adding a new filter after flushing empty chain doesn't cause an infinite loop",
> +        "category": [
> +            "filter",
> +            "chain"
> +        ],
> +        "setup": [
> +            "$IP link add dev $DUMMY type dummy || /bin/true",
> +            "$TC qdisc add dev $DUMMY root handle 1: htb default 1",
> +            "$TC chain add dev $DUMMY",
> +            "$TC filter del dev $DUMMY chain 0 parent 1: prio 0"
> +        ],
> +        "cmdUnderTest": "$TC filter add dev $DUMMY chain 0 parent 1:",
> +        "expExitCode": "2",
> +        "verifyCmd": "$TC chain ls dev $DUMMY",
> +        "matchPattern": "chain parent 1: chain 0",
> +        "matchCount": "1",
> +        "teardown": [
> +            "$TC qdisc del dev $DUMMY root handle 1: htb default 1",
> +            "$IP link del dev $DUMMY type dummy"
> +        ]
> +    }
> +]


