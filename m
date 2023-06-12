Return-Path: <netdev+bounces-10156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80AE872C949
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:05:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0D0D1C20B61
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6196C1C750;
	Mon, 12 Jun 2023 15:05:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB79AD38
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:05:22 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7A598;
	Mon, 12 Jun 2023 08:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFTEaO0YS6Erp5fYLfpjnw1oQLvfK5cSwXQIBy1Wtmm3YybESsWODid4zLfMgAWnetbh6+NrcMX9FIFMZdKP8UIPpMwGbBW7pCTuUOp7YZW30h+Hg/IRkglDD3wOo7fieNmDXMqDzOwyx3RHM7qpJ5WLGvQ2QLQLEmhohfyojlnoMKYsV5UqWdz0BtMxiSjvvwJdqL4QDe5uxr0suJL4uEe7rOtvXXBAo7wwq4RGgeBfwD4AlK0lc0Y6KgPEMRuZH7pj9slS0JvauAee0i0UpikmbuUQ1X06N6yXtfIVAP1URpMGIsFx0VOPxmaeiLIFqbRqhBidk07Ooi9b4KFBlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJVgIjsfk6QL1fevoqZoS1T5Kqdrc4w27azi/gnr/Fk=;
 b=HtkPCf7NkQYskWp7G9n2gUJNGLKS4QuCBaDdQQk4iwaK2Qhum+sIp30DpLOeV73ECYIscCWbP4JY8mVOgOQzrbwCF+MTGMQwIfgTt7Ym5/B7+PkCRrAHpVpDcWhRF0MtHVcHSuAr1rf6/cybey7mfbkTQgYkvyuT1MZRQ9fwZbyqtRvOR1PE3Q+7aA2ksAG8QK+I9GhPHr4qCIXmXE58JlDrPjH4n3cCoY5w1IzLJ+hEEKNpfVYY37m8kZLoETvlCeRll4A4gncoJxVw1SfbkicsjxHZ5eFD6l08qVSdkloBasdWpVS/+XSkqgx/D5EPU6RmZkCAy79Dlio7kKy/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJVgIjsfk6QL1fevoqZoS1T5Kqdrc4w27azi/gnr/Fk=;
 b=SIvmQ6dqlaLBdtpv/ujirDyB1pX/JzP3p1dxvA7e9xC4CN0SkyDZMnzJPGaLMt5TOW0FphN9V/+24lJyHzbhex8rwOtVJ3JxvrCaLWIiDNiduvcT9SMztdFive8LLse4SUFeHNtbXEMrCzoQ4pX+n1hemEmj3+Tm94vNaE91gYb1j8+vZWQ6lsmrxEuzLo9rsDGqvt64N2ttz21giyugWm5Mhx9HCU+d6mlnIe3kbBod2b3HfHjAmOGxmUHMsHzDe0pnGFVEIJ5dsVc6g3RelrTQWufwUgt1H2jYo14X58WxH/ZkQTTxCKKFRA65Qycmdx67vwqot18cszTkXD306w==
Received: from CY5PR15CA0189.namprd15.prod.outlook.com (2603:10b6:930:82::7)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 15:05:13 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:930:82:cafe::b) by CY5PR15CA0189.outlook.office365.com
 (2603:10b6:930:82::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 15:05:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 15:05:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 08:04:52 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 08:04:48 -0700
References: <87legswvi3.fsf@nvidia.com>
 <20230612142914.2404237-1-renmingshuai@huawei.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: renmingshuai <renmingshuai@huawei.com>
CC: <caowangbao@huawei.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
	<liaichun@huawei.com>, <linux-kernel@vger.kernel.org>, <liubo335@huawei.com>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <xiyou.wangcong@gmail.com>,
	<yanan@huawei.com>
Subject: Re: [PATCH v2] net/sched: Set the flushing flags to false to
 prevent an infinite loop and add one test to tdc
Date: Mon, 12 Jun 2023 17:48:29 +0300
In-Reply-To: <20230612142914.2404237-1-renmingshuai@huawei.com>
Message-ID: <874jncwwkx.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|DS7PR12MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: f93e2667-167d-41c7-9887-08db6b566af5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jmbZ5lRXATyca8qm2oBpMaP+ntNkJ6gywacSB9K+MJENib+sfnB9lzKiiKD5QL3Ort0LxpR+xkLwCXhATEQjsNAozhSlCVmmLCsm4CiCjtciy9LgCX4HMhlPmbJs+49dEg21L7X2L0V31+2rgQ6C8WoewYSU8YFhpLs8COZxuorqFrJxMidwgi4S6dFRemWiOcDCA1NTrJkulNhYj+5ApIx6N/LxOF9fJiX8DWKhlFFI+r3ejI2kQNQnziDdmb9w2J2KJD52loC6k19rBQRNqTfAe1knUZqeAhXYi7O3+A362WfDUrC88OWwE/m0PPHMwUS+hXz+jKCBJBwNiFEE9GkBS6W9DPE5rUBNQz9KxPbUVLvfquNHGKCw+852oBMBeb/o5Jh0k95P/dtacu9IJcd1gh8Rp3T1nEmkk+TrNxD5LAO4Yv7ynMtVVb48jdmNHdbDojV2MBo3OmXJrwXime9J8wxsVP8t4+LjDQSS8qnJJcBbJtWQAJLE+Mb8KFAVNLb5rulDUS/HoIRD/sJ92uqq412X8QVzPCvvbotoEcwKnr0r1bTH7xzFSVbdN0jpKrJACY/UQD264rv4OwcYd6PqLapwg6muCf+QuSucwTgF4LM3Es/fgOwFfUWwI1wveKe/D3NN46SoayiVwuZYT6NGG8IyJKO93YEGSOCY5V7ReSTCe8WyIzl6oazrVZnQaq0+lURn96QpxA9aWGEk8btQJiW/iAz1r36NTBzavIEBsyPHBHNAOljaBT3M2/5Z
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(70206006)(70586007)(8936002)(8676002)(36756003)(5660300002)(4326008)(6666004)(6916009)(54906003)(478600001)(40460700003)(41300700001)(316002)(7696005)(356005)(40480700001)(82740400003)(7636003)(336012)(426003)(2616005)(16526019)(26005)(186003)(7416002)(82310400005)(47076005)(83380400001)(86362001)(36860700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:05:10.7490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f93e2667-167d-41c7-9887-08db6b566af5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Mon 12 Jun 2023 at 22:29, renmingshuai <renmingshuai@huawei.com> wrote:
>>On Fri 09 Jun 2023 at 17:46, renmingshuai <renmingshuai@huawei.com> wrote:
>>> When a new chain is added by using tc, one soft lockup alarm will be
>>>  generated after delete the prio 0 filter of the chain. To reproduce
>>>  the problem, perform the following steps:
>>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
>>> (2) tc chain add dev eth0
>>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
>>> (4) tc filter add dev eth0 chain 0 parent 1:
>>>
>>>
>>> The refcnt of the chain added by step 2 is equal to 1. After step 3,
>>>  the flushing flag of the chain is set to true in the tcf_chain_flush()
>>>  called by tc_del_tfilter() because the prio is 0. In this case, if
>>>  we add a new filter to this chain, it will never succeed and try again
>>>  and again because the refresh flash is always true and refcnt is 1.
>>>  A soft lock alarm is generated 20 seconds later.
>>
>>Hi Mingshuai,
>>
>>Thanks for investigating and reporting this!
>>
>>> The stack is show as below:
>>>
>>> Kernel panic - not syncing: softlockup: hung tasks
>>> CPU: 2 PID: 3321861 Comm: tc Kdump: loaded Tainted: G
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>>> Call Trace:
>>>  <IRQ>
>>>  dump_stack+0x57/0x6e
>>>  panic+0x196/0x3ec
>>>  watchdog_timer_fn.cold+0x16/0x5c
>>>  __run_hrtimer+0x5e/0x190
>>>  __hrtimer_run_queues+0x8a/0xe0
>>>  hrtimer_interrupt+0x110/0x2c0
>>>  ? irqtime_account_irq+0x49/0xf0
>>>  __sysvec_apic_timer_interrupt+0x5f/0xe0
>>>  asm_call_irq_on_stack+0x12/0x20
>>>  </IRQ>
>>>  sysvec_apic_timer_interrupt+0x72/0x80
>>>  asm_sysvec_apic_timer_interrupt+0x12/0x20
>>> RIP: 0010:mutex_lock+0x24/0x70
>>> RSP: 0018:ffffa836004ab9a8 EFLAGS: 00000246
>>> RAX: 0000000000000000 RBX: ffff95bb02d76700 RCX: 0000000000000000
>>> RDX: ffff95bb27462100 RSI: 0000000000000000 RDI: ffff95ba5b527000
>>> RBP: ffff95ba5b527000 R08: 0000000000000001 R09: ffffa836004abbb8
>>> R10: 000000000000000f R11: 0000000000000000 R12: 0000000000000000
>>> R13: ffff95ba5b527000 R14: ffffa836004abbb8 R15: 0000000000000001
>>>  __tcf_chain_put+0x27/0x200
>>>  tc_new_tfilter+0x5e8/0x810
>>>  ? tc_setup_cb_add+0x210/0x210
>>>  rtnetlink_rcv_msg+0x2e3/0x380
>>>  ? rtnl_calcit.isra.0+0x120/0x120
>>>  netlink_rcv_skb+0x50/0x100
>>>  netlink_unicast+0x12d/0x1d0
>>>  netlink_sendmsg+0x286/0x490
>>>  sock_sendmsg+0x62/0x70
>>>  ____sys_sendmsg+0x24c/0x2c0
>>>  ? import_iovec+0x17/0x20
>>>  ? sendmsg_copy_msghdr+0x80/0xa0
>>>  ___sys_sendmsg+0x75/0xc0
>>>  ? do_fault_around+0x118/0x160
>>>  ? do_read_fault+0x68/0xf0
>>>  ? __handle_mm_fault+0x3f9/0x6f0
>>>  __sys_sendmsg+0x59/0xa0
>>>  do_syscall_64+0x33/0x40
>>>  entry_SYSCALL_64_after_hwframe+0x61/0xc6
>>> RIP: 0033:0x7f96705b8247
>>> RSP: 002b:00007ffe552e9dc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f96705b8247
>>> RDX: 0000000000000000 RSI: 00007ffe552e9e40 RDI: 0000000000000003
>>> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000558113f678b0
>>> R10: 00007f967069ab00 R11: 0000000000000246 R12: 00000000647ea089
>>> R13: 00007ffe552e9f30 R14: 0000000000000001 R15: 0000558113175f00
>>>
>>> To avoid this case, set chain->flushing to be false if the chain->refcnt
>>>  is 2 after flushing the chain when prio is 0. I also add one test to tdc.
>>>
>>> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
>>> Signed-off-by: Mingshuai Ren <renmingshuai@huawei.com>
>>> Reviewed-by: Aichun Li <Liaichun@huawei.com>
>>> ---
>>> V1 -> V2:
>>>   * Correct the judgment on the value chain->refcnt and add one test to tdc
>>> ---
>>>  net/sched/cls_api.c                           |  7 ++++++
>>>  .../tc-testing/tc-tests/infra/filter.json     | 25 +++++++++++++++++++
>>>  2 files changed, 32 insertions(+)
>>>  create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/filter.json
>>>
>>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>>> index 2621550bfddc..3ea054e03fbf 100644
>>> --- a/net/sched/cls_api.c
>>> +++ b/net/sched/cls_api.c
>>> @@ -2442,6 +2442,13 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>>>  		tfilter_notify_chain(net, skb, block, q, parent, n,
>>>  				     chain, RTM_DELTFILTER, extack);
>>>  		tcf_chain_flush(chain, rtnl_held);
>>> +		/* Set the flushing flags to false to prevent an infinite loop
>>> +		 * when a new filter is added.
>>> +		 */
>>> +		mutex_lock(&chain->filter_chain_lock);
>>> +		if (chain->refcnt == 2)
>>> +			chain->flushing = false;
>>> +		mutex_unlock(&chain->filter_chain_lock);
>>
>>I don't think this check is enough since there can be concurrent filter
>>ops holding the reference to the chain. This just makes the issue harder
>>to reproduce.
>>
>>I'll try to formulate a fix that takes any potential concurrent users
>>into account and verify it with your test.
>
> Thanks for your reply.
> I didn't find any concurrent scenarios that would "escape" this check.
> That's my understanding.
> During the flush operation, after filter_chain_lock is obtained, no new chain reference
>  could be added. After unlock, chain->flushing is set to true. The chain->refcnt and
>  chain->action_refcnt are always different. Therefore, chain->flushing will be never set to false.

I agree with your analysis.

>  Then there seems to be no concurrency problem until flushing is set to true.
> would you mind tell me the concurrent scenario you're talking about?

What if, for example, chain->refcnt==3 after flush because there is
another task inserting filters to the same chain concurrently? In such
case for chains explicitly created with chains API, chain->flushing flag
will never be reset afterwards and user will get the same lockup when
trying to install any following filters. Also, refcnt==2 only means that
there is no concurrent users when flushing explicitly created chains
(because chains API holds a "passive" reference to such chains). For
regular chains implicitly created by filters API refcnt==2 here means
that there are active concurrent users.


