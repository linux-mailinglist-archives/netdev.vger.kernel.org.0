Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46C33340D6
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 15:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhCJOyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 09:54:53 -0500
Received: from mail-eopbgr690040.outbound.protection.outlook.com ([40.107.69.40]:4352
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229602AbhCJOyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 09:54:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXEbEH10SupqIJRo5Ci9y6jjhp2+fQ1bX/DSsLi1DWkN0/IIGkB3DY4Xxi5PKhl6+40k++mk4sPBFZ3UD3fSblx9P11TQhLpYXkErhOqamAd7LKPW+jj96vevoaoBnTIkqWv7RAN0DexzHI5c+aeLZn3Bk+ucw+pXTvOH0yqVUVq0rzTE/nCVvOL/3kphred5Ox0V7oLRebCtEsAjwTGiJAYkdyVbK3aTMa2x0jr97ky72KrQRNr/Tdj7rwyCi8x/TGKYbnhbVf5R7vceYdR1QswtK45xeREV4hSd6vHw1BMwwBaAfEfq/BkAnFVfcJx0tNGdH+4lKha/5mEZApfdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CfCnwAdVcMxY1N7NnIjNcEzvO1CWUz+1id4hRAI/1M=;
 b=HNcX+udRV1SuHzn/Py3KrWDDeOPPlXXhv8+TyCYa7PK5K9gnC4zIm0mXVYRAjqaJrKA5T1bm5j7MDSmGLW74uxjAfzbUoNFIH+SCGnJtv5fbgAXjssQ/a/rGbKsvuv7nPslhBsRd8t/LIG7LPYgT0khx4OhtLvXVn9RbpvC2Sv74MUgSo4euZkHxz7G9aqK+JyFfq+YX67py8TBoWmqjAeYLwxfF8pCJZzaEFTibZgyaRizUrZKbr2PETP1oEF1iLsym/ulL1nI7qRDOWLujqTg9CO6tyP9Df379asFFgb3I0K+kF3R95hxHbfzCSZvryYWzWj+f9cE2FRkXxGXkyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CfCnwAdVcMxY1N7NnIjNcEzvO1CWUz+1id4hRAI/1M=;
 b=bCI+Liod70OnCVRUYH1jsMwgkYpmkxIsO72lOet63Mqa8FuOP1/taTVUGxHw/D5zHwAQdJwtta6EqtELB3gSJ4gRZNbqofg/hoqNeKLTNYg2FUv/ntmRbiP/FxDV8NUF9I4p/jEArpY6++v1YfNTILuOrxhlqRe0sTq+IsmrdETQMVBzaraJAjW048TqSGWVP7m/ZbmPWWzpt8pKd5r6zUfBUIyX8H4CYne9F+BDkPR/H4j5yIGGX0jyYHkHtA10iQgblsFxFuMhmDR2up+Pd1JWgvZKYbDhS9gpl0/PH7JyZKj0+8ysah75IKdVE4dqFv6AYE/6HeOMDKNbV1mTMw==
Received: from MWHPR14CA0048.namprd14.prod.outlook.com (2603:10b6:300:12b::34)
 by CH2PR12MB4264.namprd12.prod.outlook.com (2603:10b6:610:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 14:54:33 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::8b) by MWHPR14CA0048.outlook.office365.com
 (2603:10b6:300:12b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 14:54:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 14:54:32 +0000
Received: from [172.27.15.160] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 14:54:28 +0000
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 htb_select_queue
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <maximmi@mellanox.com>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>, <tariqt@nvidia.com>,
        <xiyou.wangcong@gmail.com>
References: <000000000000c0510605bd1bfd39@google.com>
 <21985b6f-a13b-2208-790a-bfe42e1b1985@gmail.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <cb2163b1-8b63-1934-b786-050e903785b4@nvidia.com>
Date:   Wed, 10 Mar 2021 16:54:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <21985b6f-a13b-2208-790a-bfe42e1b1985@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79dc9f0b-6a0a-47be-f8e0-08d8e3d46a46
X-MS-TrafficTypeDiagnostic: CH2PR12MB4264:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4264C449B02AE3789F0E4C5CDC919@CH2PR12MB4264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zkiE4LwaBLOw7fkhnDtAMQul5gaA27ew1AVzA7wjV2SC6YfwQfB66+9Pt09i82e+OH4Xw5r90ZpT1XiVZj3IncsBn2YbrQtxRnAXZx8TqTj7xKwWkxPW6E+T2I9y55C4y7iOGLH32DH85GZuX3Wm7MTYfDsXqz/JD4oqlCzuU/3CID2PflP0HhiNWOqT6RY/M+1dluyjbLj2BCqLCzi81/fHuoQUw8bpXIfRO1Lfo/BRzx+RHIgkvNE3V790FWTbz95R+htczC7nTuG0Fb/bnt1SDeKZu7Xq9F1tsw3Pw4mNk5WFh5BQrIGb86VK3xefOIzPoQWYXiPbPJ5kvLpRFYDbJIGO+svfpWuTED1IiaTuLHiI1bQjA2MTWMR2rnquT3TwzE+QHomlYeHVGW+QSEMJ8zAKmocr8dqcPJQAXSM5iKZCySj08rXheSFyBJRkMU9CIoxXWt0KjINjLWJTNpwTo3QUaun+AbTquBHPZNAiw0H5gGqxy4OU/EiBltPuXP2bqRk3RANs8YDbD7rPNXXF6jM7vTWZjChFhWFdSP24DXOj3hbv4NXD4Huq+ZkPlgQV5MHeVOcfMH8ZlnDJdAu593Zk6u/Z6q5uxMegEwoN3mrUlZuekTvy6im7svMuKOJx7uc5leBMAEDB7RPQ4/ZYlmJQQPjvRQAKfeMB6IDOCDl8eLh7fdvzV3s2CN0xtDxgmvUpXskomEqbytbG7S1u/vU0SmPBSryXARhakGWLwBhyDT4GtxnzeC06VEz8UVRQttmVJ4ESP490RxjLBtsZj+2trWlJ9rkweA1H2wnpxhSTkRkbWCydvUTKH1pgNwIMPQLGvT03ycwFKYS+OC0RX6pDnErPcA7dajJdg3odj9cGKdQ1OfiFEddJoMqz
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(396003)(136003)(36840700001)(46966006)(2906002)(110136005)(6666004)(478600001)(356005)(7636003)(70586007)(82310400003)(70206006)(426003)(2616005)(34020700004)(53546011)(83380400001)(45080400002)(16526019)(336012)(7416002)(316002)(26005)(31696002)(921005)(36906005)(8936002)(36860700001)(5660300002)(36756003)(82740400003)(86362001)(31686004)(186003)(8676002)(966005)(16576012)(47076005)(99710200001)(83996005)(2101003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 14:54:32.7184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79dc9f0b-6a0a-47be-f8e0-08d8e3d46a46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4264
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-09 17:20, Eric Dumazet wrote:
> 
> 
> On 3/9/21 4:13 PM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    38b5133a octeontx2-pf: Fix otx2_get_fecparam()
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=166288a8d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=dbc1ca9e55dc1f9f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=b53a709f04722ca12a3c
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119454ccd00000
>>
>> The issue was bisected to:
>>
>> commit d03b195b5aa015f6c11988b86a3625f8d5dbac52
>> Author: Maxim Mikityanskiy <maximmi@mellanox.com>
>> Date:   Tue Jan 19 12:08:13 2021 +0000
>>
>>      sch_htb: Hierarchical QoS hardware offload
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13ab12ecd00000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=106b12ecd00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ab12ecd00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com
>> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>> #PF: supervisor instruction fetch in kernel mode
>> #PF: error_code(0x0010) - not-present page
>> PGD 183fe067 P4D 183fe067 PUD 21aef067 PMD 0
>> Oops: 0010 [#1] PREEMPT SMP KASAN
>> CPU: 0 PID: 10125 Comm: syz-executor.0 Not tainted 5.11.0-rc7-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:0x0
>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>> RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
>> RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
>> RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
>> RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
>> R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
>> R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
>> FS:  00007f73f9698700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   htb_offload net/sched/sch_htb.c:1011 [inline]
>>   htb_select_queue+0x17f/0x2c0 net/sched/sch_htb.c:1349
>>   tc_modify_qdisc+0x44a/0x1a50 net/sched/sch_api.c:1657
>>   rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
>>   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>>   netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>>   netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>>   netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>>   sock_sendmsg_nosec net/socket.c:652 [inline]
>>   sock_sendmsg+0xcf/0x120 net/socket.c:672
>>   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
>>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
>>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
>>   do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x466019
>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007f73f9698188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466019
>> RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
>> RBP: 00000000004bd067 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
>> R13: 00007fffefccc11f R14: 00007f73f9698300 R15: 0000000000022000
>> Modules linked in:
>> CR2: 0000000000000000
>> ---[ end trace e1544e8206616773 ]---
>> RIP: 0010:0x0
>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>> RSP: 0018:ffffc9000a9c74e8 EFLAGS: 00010246
>> RAX: dffffc0000000000 RBX: 1ffff92001538e9e RCX: 0000000000000000
>> RDX: ffffc9000a9c7520 RSI: 0000000000000012 RDI: ffff88802d158000
>> RBP: ffff88802d158000 R08: 00000000fffffff1 R09: 0000000000000400
>> R10: ffffffff871631c4 R11: 0000000000000000 R12: ffffffff89ea6b40
>> R13: dffffc0000000000 R14: ffff888012b79c00 R15: 00000000ffff0000
>> FS:  00007f73f9698700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffffffffffffd6 CR3: 00000000173b5000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
>>
> 
> 
> Hmm... what about this :
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index f87d07736a1404edcfd17a792321758cd4bdd173..680afb5bfe2294a5531c7aaeed698b95ea3ab20c 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1651,15 +1651,16 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>                          err = -ENOENT;
>                  }
>          } else {
> -               struct netdev_queue *dev_queue;
> +               struct netdev_queue *dev_queue = NULL;
>   
>                  if (p && p->ops->cl_ops && p->ops->cl_ops->select_queue)
>                          dev_queue = p->ops->cl_ops->select_queue(p, tcm);
> -               else if (p)
> -                       dev_queue = p->dev_queue;
> -               else
> -                       dev_queue = netdev_get_tx_queue(dev, 0);
> -
> +               if (!dev_queue) {
> +                       if (p)
> +                               dev_queue = p->dev_queue;
> +                       else
> +                               dev_queue = netdev_get_tx_queue(dev, 0);
> +               }
>                  q = qdisc_create(dev, dev_queue, p,
>                                   tcm->tcm_parent, tcm->tcm_handle,
>                                   tca, &err, extack);
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index dff3adf5a9156c2412c64a10ad1b2ce9e1367433..cc6eccd688701ae00255f07e32fb4b0efbaf45ce 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -1008,6 +1008,8 @@ static void htb_set_lockdep_class_child(struct Qdisc *q)
>   
>   static int htb_offload(struct net_device *dev, struct tc_htb_qopt_offload *opt)
>   {
> +       if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
> +               return -EOPNOTSUPP;

My fault, all calls to htb_offload must be protected by if (q->offload). 
Rather than checking tc_can_offload and ndo_setup_tc in htb_offload 
every time, I suggest to fix htb_select_queue:

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index dff3adf5a915..b23203159996 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1340,8 +1340,12 @@ htb_select_queue(struct Qdisc *sch, struct tcmsg 
*tcm)
  {
  	struct net_device *dev = qdisc_dev(sch);
  	struct tc_htb_qopt_offload offload_opt;
+	struct htb_sched *q = qdisc_priv(sch);
  	int err;

+	if (!q->offload)
+		return sch->dev_queue;
+
  	offload_opt = (struct tc_htb_qopt_offload) {
  		.command = TC_HTB_LEAF_QUERY_QUEUE,
  		.classid = TC_H_MIN(tcm->tcm_parent),

htb_init ensures that tc_can_offload and ndo_setup_tc are checked if 
q->offload is true. Also, we can avoid changing tc_modify_qdisc if 
htb_select_queue mimics its behavior in non-offload mode, as shown above.

There is also a case where htb_select_queue returns NULL on errors, and 
that is handled in qdisc_create (the error message will be "No device 
queue given"), which I think is a sane behavior.

What do you think of this fix? If it fits, I'll send it as a patch.

>          return dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_HTB, opt);
>   }
>   
> 

