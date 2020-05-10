Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5A51CC999
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 10:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEJIxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 04:53:05 -0400
Received: from mail-eopbgr150057.outbound.protection.outlook.com ([40.107.15.57]:53198
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725994AbgEJIxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 04:53:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHUZRGjJLGkWESEXZLgqt32SwxGIpmr6DwLP4Ac+bTA5tLp2/8aIYw6Xl+80hXP2iSNo6Mn6IP3ucnvp4NQfX6YYcN+1sdIkxn/arhO/AOnhT3WdY80bKlCAWWJQpb0I6NUUhGdElgyfKfLTusnYFH3ypzROJ2us5bthGLyRx2kX7RafD+LZ8suP9cHfaAwvr8LEzikrXGRvzGXN7dndWsIqOvZwtglNPC5/cFqBSwQcjI7uTsFLaVAbD7UFhnDRxFG3//1rnJhUTMLtL7BvQcNVc3V7wqIKmPnkg1LaKNlnPnKiYJ03gwg2ePB6Li217SSaMfp5Ctq1ciG/tr1n5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE1zVSNFrx/t5536W+0rFOH91TMtsCXXOrgmftC0veA=;
 b=L86m2WPFVX9P2wyIi1he69pW8nXMRGh+ODNW6u0J6DchGhPT0Ku9E//9L3jCncLNMJ5I7DwIhkNMf0dOIsrlhOyjDny1Lc8QGdOT8IEkkhOFL8Im2Clxx3ywjNdiMjImcpqMM+9oHhnj+nXyTR/2AsRplW0IUaSC2+kyf4wgjDJKPHBCbCOtN4vPyRKqKabLVenEU2fBG/etoXE3kVtNLhGfqRq189z9kiKs01LNsDOcggBfWRDgwR/gBfmJi5ELy1rK58q+z/vmIn9OIVVWLkhoVhziFGcXz+XW4mDfMugK2yeAmxagGroHEDsQMbhdD4p2qNfeVkunyv06vMJycA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE1zVSNFrx/t5536W+0rFOH91TMtsCXXOrgmftC0veA=;
 b=gE4F1dRQknjMDAK161VoTfkwzmE+U9j0JPD5kA3cJM8kHDSsGiw9Abnwxc5fkI66VetVUjsh8C6uOCiDBz10MAVNXVOXN0zupTdcyd7yPWTtVU7e/4Mkdo3n4cugzZXwE7IK8sKsJKQO9ZVNtzQYsRd7qgeoqSyIXidV4TyliSQ=
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB7PR05MB4937.eurprd05.prod.outlook.com (2603:10a6:10:1d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2979.28; Sun, 10 May 2020 08:52:59 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::39ab:622c:b05b:c86%3]) with mapi id 15.20.2979.033; Sun, 10 May 2020
 08:52:59 +0000
Subject: Re: mlx5: Panic with conntrack offload
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20200424041032.GG2468@localhost.localdomain>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <93e6cc32-c894-0e73-697c-6d950c8063a1@mellanox.com>
Date:   Sun, 10 May 2020 11:52:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200424041032.GG2468@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR04CA0147.eurprd04.prod.outlook.com (2603:10a6:207::31)
 To DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.113.172) by AM3PR04CA0147.eurprd04.prod.outlook.com (2603:10a6:207::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29 via Frontend Transport; Sun, 10 May 2020 08:52:58 +0000
X-Originating-IP: [176.231.113.172]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed42cc8d-3184-45be-51f5-08d7f4bf8a57
X-MS-TrafficTypeDiagnostic: DB7PR05MB4937:|DB7PR05MB4937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB4937F158172C10F840CA9880B5A00@DB7PR05MB4937.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7ZEySKsTlpbWORX4jkP3YvJsL/rvTiOA29v+PCjz5fPFQ0uMKzkXJaGkNlCEX3sy9ekPf8WAsoadoT5xRPiG8vxoXxMK3s7ASJAdHXT6bfeml7x7VBzRUFTNuLC5yvUsZqSmJcrG3ATKpYgE4NkMbhzaG2Z6xYii2E7KHEZaR8NKEL7IKC/P12anjElYkGY6+5fvknK7pjGMTH2ng2cquIqUv+dFK/pCR/5G/3B8JC4Fun6HEdSKcwIrh2WOCbuqAPhcgwiap8TiCODwbIQX0TXlnZtLgBpyFBd2TLE2RrzPz5avaxSm+ai5SJco5J5wb/wfQLJd28aZBjaGU8vgpR2d5+CWi9DSs/x+8F8hcuQrtTqxdjorVBzu+BQsXviUrKG+XECk01a1MDoKdlrSH8mxyHpS8BZFple2VcvbV+xyHuxRzPEWMXTBAcQtmv2csPkr8KcyktfzzxqQVMOHXBw7pok2A2eNy82rHP+kBZ4QIJ1jTQ8NUJkh0t3RZgWhZ1lusa65yksCRn7+VcyBdWL/E1pqFYP4FhBrCtDRtMKKp/oIAUOmEuYy08TPxLlv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(33430700001)(66946007)(66476007)(66556008)(16576012)(53546011)(36756003)(8676002)(33440700001)(16526019)(186003)(316002)(6486002)(2906002)(2616005)(110136005)(31686004)(956004)(52116002)(26005)(5660300002)(86362001)(6636002)(4326008)(8936002)(54906003)(478600001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IAzFihTCfC9WUMoi5OeaWNhA7tXqZIvLfoasQUw2ib5C9CDWWfyd6YWcsGe2uNrmDAMIJhxHcZrnarEVHmUTL9gyCJzSbtdL4cwAi/GR202ZMhnA9jcJujRHIemUyhIsyw1UzBWSo1ybADQJPCb/vtzUWDknHd0wtI5sU95xxDnMvbST62dDAM89ArG0mSV1BqBO3RDpfA3doAJdL62DLnVWlw1744O+sswZ6meYnCDZAqdU3T+l8TIzyUIr25qltbsWcw855trI14huh76BmtBtc6iu5kTgfn/jVIgu6nlZ8uPHWz+fYAsRLtcCnY70NF31spAkm5aIqJ8TMjV9W0a1Ve46R3F4DC8c2Sv2UTVwjV2o88PoTzrKWJ/KFiJyNuDzZ4SX98VVjsOzaR/tQmYad40QkghXPBLfqeYk7lpF5gC3cHZ/iN1AzceyiqmIY4LACJXXe0LYL6GZ5MqmmvaHsWp4Tn0Ew7dgTmcGE/1dxby+XvkN9uaBnQhHy0Wr
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed42cc8d-3184-45be-51f5-08d7f4bf8a57
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 08:52:59.5642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQBmLy48xjJ7Yt6dVrIzZrgw/fngRWO9SJG5FtM3DOQQGunOIfvoe20NPH+emT74Xrsw0sQFjF5qlCq0c8h2Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-04-24 7:10 AM, Marcelo Ricardo Leitner wrote:
> Hi Paul,
> 
> I'm triggering this panic out of 1802136023c01075, net-next today
> (disregard the hash at the end of the kernel version).
> I have a dual-port CX5 with VF LAG, with 1 guest and 2 VFs on it, with
> different subnets. Ovs OF flows steering each subnet to each VF and
> doing conntrack. (flows at the bottom here)
> 
> This happens after 2 or 5 netperf runs. I run netperf, wait for the
> flows to expire, then run it again.
> 
> I'm suspecting this was introduced in 9808dd0a2aee ("net/mlx5e: CT: Use
> rhashtable's ct entries instead of a separate list"), but I didn't
> bisect it yet.  I know it also happens with 2fcd80144b93ff908, FWIW.
> 
> Ideas?

+pablo

Hi Marcelo,

I investigated this and see the root.

In nf flow table offload we create a workqueue with flag WQ_MEM_RECLAIM.
Each CT add/del/stats is queued as work to that workqueue.
In del flow, when we reach mlx5 driver, we reach del_sw_flow_group
and want to release an rhashtable (&fg->ftes_hash).
The rhashtable implementation could also queue a work if rehash is needed.
that work is queued on system_wq which is not created with flag
WQ_MEM_RECLAIM. So if we are now in a del flow work and flush and destroy
the ftes_hash rhashtable and there is a rehash work queue to be flushed
first then we reach in check_flush_dependency() and see target_wq is
system_wq which doesn't have WQ_MEM_RECLAIM flag so we dont return right
away and now checking current_wq_worker() is the nf flow table offload
workqueue which has flag WQ_MEM_RECLAIM.
This generates the warn_once() you see.

        WARN_ONCE(worker && ((worker->current_pwq->wq->flags &                  
                              (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
                  "workqueue: WQ_MEM_RECLAIM %s:%ps is flushing !WQ_MEM_RECLAIM %s:%ps",
                  worker->current_pwq->wq->name, worker->current_func,          
                  target_wq->name, target_func);            

It's only avoided if there is also internal flag __WQ_LEGACY which is being
added only for create workqueue wrappers that creates single thread
workqueue. but we do want multi threaded workqueue.

Using WQ_MEM_RECLAIM means all other wqs being used inside a work should
also have WQ_MEM_RECLAIM. because of rhashtable this is not the case.

WQ_MEM_RECLAIM means the wq is guaranteed to have at least one execution
context regardless of memory pressure.

I think we should maybe remove WQ_MEM_RECLAIM from nf flow table offload
workqueue.  Pablo, Oz, Paul ?

Thanks,
Roi


> 
> Thanks,
> Marcelo
> 
> [  485.557189] ------------[ cut here ]------------
> [  485.562976] workqueue: WQ_MEM_RECLAIM nf_flow_table_offload:flow_offload_worr
> [  485.562985] WARNING: CPU: 7 PID: 3731 at kernel/workqueue.c:2610 check_flush0
> [  485.590191] Kernel panic - not syncing: panic_on_warn set ...
> [  485.597100] CPU: 7 PID: 3731 Comm: kworker/u112:8 Not tainted 5.7.0-rc1.21802
> [  485.606629] Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.4.3 01/177
> [  485.615487] Workqueue: nf_flow_table_offload flow_offload_work_handler [nf_f]
> [  485.624834] Call Trace:
> [  485.628077]  dump_stack+0x50/0x70
> [  485.632280]  panic+0xfb/0x2d7
> [  485.636083]  ? check_flush_dependency+0x110/0x130
> [  485.641830]  __warn.cold.12+0x20/0x2a
> [  485.646405]  ? check_flush_dependency+0x110/0x130
> [  485.652154]  ? check_flush_dependency+0x110/0x130
> [  485.657900]  report_bug+0xb8/0x100
> [  485.662187]  ? sched_clock_cpu+0xc/0xb0
> [  485.666974]  do_error_trap+0x9f/0xc0
> [  485.671464]  do_invalid_op+0x36/0x40
> [  485.675950]  ? check_flush_dependency+0x110/0x130
> [  485.681699]  invalid_op+0x28/0x30
> [  485.685891] RIP: 0010:check_flush_dependency+0x110/0x130
> [  485.692324] Code: ff ff 48 8b 50 18 48 8d 8b b0 00 00 00 49 89 e8 48 81 c6 b0
> [  485.714353] RSP: 0018:ffffa9474aea7a48 EFLAGS: 00010086
> [  485.720724] RAX: 0000000000000000 RBX: ffff912c07c19400 RCX: 0000000000000000
> [  485.729232] RDX: 0000000000000090 RSI: ffffffffaf67e1f0 RDI: ffffffffaf67bd2c
> [  485.737737] RBP: ffffffffade8f8d0 R08: ffffffffaf67e160 R09: 000000000002b6c0
> [  485.746240] R10: 0000017f622837fe R11: 0000000000000e93 R12: ffff9148ad011780
> [  485.754751] R13: ffff914b3f771700 R14: 0000000000000001 R15: ffff914b30f1c1d0
> [  485.763261]  ? rhashtable_insert_slow+0x470/0x470
> [  485.769056]  ? check_flush_dependency+0x110/0x130
> [  485.774856]  __flush_work+0x96/0x1d0
> [  485.779376]  ? work_busy+0x80/0x80
> [  485.783681]  __cancel_work_timer+0x103/0x190
> [  485.788950]  ? _cond_resched+0x15/0x30
> [  485.793634]  ? _cond_resched+0x15/0x30
> [  485.798321]  ? _cond_resched+0x15/0x30
> [  485.803008]  rhashtable_free_and_destroy+0x20/0x140
> [  485.808979]  del_sw_flow_group+0x45/0x2c0 [mlx5_core]
> [  485.815119]  tree_put_node+0xc3/0x150 [mlx5_core]
> [  485.820893]  mlx5_del_flow_rules+0x11c/0x240 [mlx5_core]
> [  485.827344]  __mlx5_eswitch_del_rule+0x20/0xf0 [mlx5_core]
> [  485.833978]  mlx5_tc_ct_entry_del_rule+0x46/0x90 [mlx5_core]
> [  485.840813]  mlx5_tc_ct_entry_del_rules+0x24/0x40 [mlx5_core]
> [  485.847750]  mlx5_tc_ct_block_flow_offload+0x336/0x9f0 [mlx5_core]
> [  485.855153]  ? __wake_up_common+0x7a/0x180
> [  485.860230]  nf_flow_offload_tuple.isra.23+0xca/0x170 [nf_flow_table]
> [  485.867929]  ? __switch_to_asm+0x40/0x70
> [  485.872799]  ? __switch_to_asm+0x34/0x70
> [  485.877646]  ? __switch_to_asm+0x40/0x70
> [  485.882466]  ? __switch_to_asm+0x34/0x70
> [  485.887283]  ? __switch_to_asm+0x40/0x70
> [  485.892082]  flow_offload_tuple_del+0x30/0x40 [nf_flow_table]
> [  485.898917]  flow_offload_work_handler+0x7f/0x270 [nf_flow_table]
> [  485.906139]  ? finish_task_switch+0x19c/0x2a0
> [  485.911412]  process_one_work+0x1a7/0x370
> [  485.916299]  worker_thread+0x30/0x380
> [  485.920797]  ? process_one_work+0x370/0x370
> [  485.925876]  kthread+0x112/0x130
> [  485.929883]  ? kthread_park+0x80/0x80
> [  485.934377]  ret_from_fork+0x35/0x40
> [  486.975616] Shutting down cpus with NMI
> [  486.980297] Kernel Offset: 0x2ca00000 from 0xffffffff81000000 (relocation ra)
> [  486.997713] ---[ end Kernel panic - not syncing: panic_on_warn set ... ]---
> 
> OF flows:
> ovs-ofctl add-flow br0 'in_port=eth4,ip,action=ct(table=10)'
> ovs-ofctl add-flow br0 'in_port=eth4,action=output=bond9'
> ovs-ofctl add-flow br0 'table=10,ct_state=+trk+est,ip,action=output=bond9'
> ovs-ofctl add-flow br0 'table=10,ct_state=+trk+new,tcp,action=ct(commit,table=12)'
> ovs-ofctl add-flow br0 'table=12,action=output=bond9'
> 
> ovs-ofctl add-flow br0 'in_port=eth0,ip,action=ct(table=20)'
> ovs-ofctl add-flow br0 'in_port=eth0,action=output=bond9'
> ovs-ofctl add-flow br0 'table=20,ct_state=+trk+est,ip,action=output=bond9'
> ovs-ofctl add-flow br0 'table=20,ct_state=+trk+new,tcp,action=ct(commit,table=22)'
> ovs-ofctl add-flow br0 'table=22,action=output=bond9'
> 
> ovs-ofctl add-flow br0 'in_port=bond9,ip,action=ct(table=30)'
> ovs-ofctl add-flow br0 'table=30,ct_state=+trk+est,ip,nw_src=172.0.0.1,action=output=eth0'
> ovs-ofctl add-flow br0 'table=30,ct_state=+trk+est,ip,nw_src=172.0.1.1,action=output=eth4'
> ovs-ofctl add-flow br0 'table=30,ct_state=+trk+new,ip,action=ct(commit,table=32)'
> ovs-ofctl add-flow br0 'table=32,ct_state=+trk,ip,nw_src=172.0.0.1,action=output=eth0'
> ovs-ofctl add-flow br0 'table=32,ct_state=+trk,ip,nw_src=172.0.1.1,action=output=eth4'
> 
> ovs-ofctl add-flow br0 'arp,action=NORMAL'
> 
