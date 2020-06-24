Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7F720737C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389327AbgFXMhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:37:42 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:16397
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388942AbgFXMha (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 08:37:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCPcZbrEFi9mYw7dGSGQ/uzZpy8KY+2PYyZ7wtW3rPnFvqNxoPcd+Z3ANESUjJVR3//49Et5fBlnLqPdTbt5TdEHt3sSkkTzL3Fbwo/ToeT0dI3tRzuRIoPZZG/GTz6kVr3Awn3waeWc/xPUjcu7ZqOqxIxEPUdGe9DIpjMrNXcXHQD2obthGfs1San6KfSmljpqHCWB57+aW97y2ZvwrsZvRFA1iLC5PA5XODPq/Nkb8oGanXkNr8PN6ixTCwXbgQGGZUuR5c+8bG04DYQg+KH14QjE0s5ne6iIREecAu0HVp9iEZjPFJvqcYiAZx4PrJySKvIm4/8qEt9XfbBU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/J4w7TsVzcNWgrnEPW1BS4lLJ3feMaFz3FcS3W7Pp8=;
 b=RZ9PG9aPfda1rbxVsyRkF0Q64Fp1whXp3YS/WIvXY96Cvvjl9yyhjkg68fCM2dxWNQS9UsO7YLoJuZEWKFHG8Sg8BlIPvVp/Bu++7ui8hGOOr6T4Pl22eiLcI+lpefFUaoJXVwVe+3mZUIHZ00jYZ5ZoBhx5MsuC8pTo0lQCNU9wcv7PO7C+6mPHtMk8aWriH48J0JVtI1QEEZIUXYwKfs/pJsttTI00ffjZR7IMBmMugVwExrKX2NQc0L/uPfMcHdY+coBssFhDSEhP2tQsTjZtkgOITIRRaQ41muEv8VJqu1IHGbrFbjaCFZ2rKea1TN7vkILDpw+maPeFo7GdOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/J4w7TsVzcNWgrnEPW1BS4lLJ3feMaFz3FcS3W7Pp8=;
 b=R6TVC/jAElRvabxf8dWvULOnqA1+uUy9bjZ7fK74xK5/a57pQWNZqXLIo2l8SjU6bqJetp06RFRxJF8b5GBnz+QfOChjUjrAo2cLBM8g9CrB03GXP0rGPlBT1MyKshI36ZDQICkSCQjfm5eQi0P2Xr7O9GYtdHiHgQYUCLJl06Q=
Authentication-Results: ucloud.cn; dkim=none (message not signed)
 header.d=none;ucloud.cn; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB7027.eurprd05.prod.outlook.com (2603:10a6:20b:18e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Wed, 24 Jun
 2020 12:37:24 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::d067:e4b3:5d58:e3ab%6]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 12:37:24 +0000
References: <vbfbll8yd96.fsf@mellanox.com> <20200624103057.GA30577@salvia> <vbfmu4s8xgt.fsf@mellanox.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Majd Dibbiny <majd@mellanox.com>,
        Maor Dickman <maord@mellanox.com>, wenxu <wenxu@ucloud.cn>
Subject: Re: Crash in indirect block infra after unloading driver module
In-reply-to: <vbfmu4s8xgt.fsf@mellanox.com>
Date:   Wed, 24 Jun 2020 15:37:20 +0300
Message-ID: <vbfk0zwy70f.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by AM4PR07CA0014.eurprd07.prod.outlook.com (2603:10a6:205:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.11 via Frontend Transport; Wed, 24 Jun 2020 12:37:23 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: efad5239-a72e-4ce9-a633-08d8183b587a
X-MS-TrafficTypeDiagnostic: AM7PR05MB7027:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB702719D19DC1770DD9CC0E1DAD950@AM7PR05MB7027.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N9vkDwxrlg8PQZBeZhOV2z8Izajep+psNh0hBSQotfYZVzUWyfScC1ZhfFQjn35FfmYzcWZjxrxgh6KFfDoW2fndOYpJsAlZ7dVATt1Onjfc4bKIT9ba1O+GgIwQvXkghfkOY3TsPUKvH2Is+JlAu65ebmyayR20bTEYwZpVu793p8TGwwC/SJOPFGLB6PD5+Q1im/3UxrAotuCOPjmaOHG0+vP47AWl5j0f2yclhdZB8IxN3msqDIWsL0lBHa5c5uBjDFknc0M4EMfKegojm1+FRn1ZgTvje9e5wYa/8e09VKBecqSZEaqlmYz/DoiI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(5660300002)(36756003)(66556008)(66946007)(66476007)(2906002)(478600001)(6862004)(6486002)(4326008)(86362001)(956004)(2616005)(6200100001)(83380400001)(186003)(16526019)(316002)(26005)(8676002)(7696005)(52116002)(54906003)(8936002)(37006003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YkHyyI+DRsF9insi24dQV9s0ckRJAAxakpZNi1u/wfLbuHnkhWHOm7BzGbE0Jubk/OXup6AV+UagDnBnFTCciAJ6jJOmjLSXaLy0zW9BMDPGXVjuX4WivitdSk2hmNkah+XUIUBYi8nQTS/yZYsR2wZBKquEj8puKRtBqUpTBR1wBsD3FjtdiyZo9uyY6eVaCdo7hqGr7rnCn/3gadvLp5Arv8fe6h1jrw8WkSgjQDCOq2IZrFx26Yvw2oM9y8vJ46VVvMoXAaU3wJGekMTXbXJ+p5vHG0fbEtS6R/BRh2pJ5VIydpN0g9UgMAMlChcVigandwGW6To1weOP4bi44ENxV9yD6IDiSo4D0VikquVcvDAUVH/vVNimCQAGoYow6hGIyV2n35QO2PjJCRgS+d2fhgDa2L9NpZ2pXkQNvwncU287Kn0Va16/AmPWGvZJ9zIARQokJGG+nXDyrTUhDeD/qDPDgxVgxrAkuJyuWk0=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efad5239-a72e-4ce9-a633-08d8183b587a
X-MS-Exchange-CrossTenant-AuthSource: AM7PR05MB6995.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 12:37:24.1028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXIzbalnfKXEUKSHbCePRkuAHtxV6G3m6p6KfJS/0SgiYGoyZLadEF1iRoKBOhsfpsPNePBR9477uDDdyL7BuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed 24 Jun 2020 at 15:22, Vlad Buslov <vladbu@mellanox.com> wrote:
> On Wed 24 Jun 2020 at 13:30, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Wed, Jun 24, 2020 at 01:22:29PM +0300, Vlad Buslov wrote:
>>> Hi Pablo,
>>> 
>>> I've encountered a new issue with indirect offloads infrastructure. The
>>> issue is that on driver offload its indirect callbacks are not removed
>>> from blocks and any following offloads operations on block that has such
>>> callback in its offloads cb list causes call to unmapped address.
>>> 
>>> Steps to reproduce:
>>> 
>>> echo 1 >/sys/class/net/ens1f0/device/sriov_numvfs
>>> echo 0000:81:00.2 > /sys/bus/pci/drivers/mlx5_core/unbind
>>> devlink dev eswitch set pci/0000:81:00.0 mode switchdev
>>> 
>>> ip link add vxlan1 type vxlan dstport 4789 external
>>> ip addr add 192.168.1.1 dev ens1f0
>>> link set up dev ens1f0
>>> ip link set up dev ens1f0
>>> tc qdisc add dev vxlan1 ingress
>>> tc filter add dev vxlan1 protocol ip ingress flower enc_src_ip 192.168.1.2 enc_dst_ip 192.168.1.1 enc_key_id 42 enc_dst_port 4789 action tunnel_key unset action mirred egress redirect dev ens1f0_0
>>> tc -s filter show dev vxlan1 ingress
>>> 
>>> rmmod mlx5_ib
>>> rmmod mlx5_core
>>> tc -s filter show dev vxlan1 ingress
>>
>> On module removal, the representors are gone and the ->cleanup
>> callback should be exercised, this callback removes the flow_block and
>> removes the rules in the driver.
>>
>> Can you check if the ->cleanup callback is exercised?
>
> I added some traces. On module unload mlx5e_cleanup_rep_tx() and
> flow_indr_dev_unregister() are called, but not tc_block_indr_cleanup().
> Maybe this is the problem that wenxu fixed in one of his patches? I'll
> try to reproduce on net branch.

Indeed, on net branch tc_block_indr_cleanup() is called and crash is not
reproduced. It seems to be fixed by a1db217861f3 ("net: flow_offload:
fix flow_indr_dev_unregister path"). 

>
>>
>>> Resulting dmesg:
>>> 
>>> [  153.747853] BUG: unable to handle page fault for address: ffffffffc114cee0
>>> [  153.747975] #PF: supervisor instruction fetch in kernel mode
>>> [  153.748071] #PF: error_code(0x0010) - not-present page
>>> [  153.748189] PGD 5b6c12067 P4D 5b6c12067 PUD 5b6c14067 PMD 35b76b067 PTE 0
>>> [  153.748328] Oops: 0010 [#1] SMP KASAN PTI
>>> [  153.748403] CPU: 1 PID: 1909 Comm: tc Not tainted 5.8.0-rc1+ #1170
>>> [  153.748507] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
>>> [  153.748638] RIP: 0010:0xffffffffc114cee0
>>> [  153.748709] Code: Bad RIP value.
>>> [  153.748767] RSP: 0018:ffff88834895ef00 EFLAGS: 00010246
>>> [  153.748858] RAX: 0000000000000000 RBX: ffff888330a30078 RCX: ffffffffb2da70ba
>>> [  153.748975] RDX: ffff888333635d80 RSI: ffff88834895efa0 RDI: 0000000000000002
>>> [  153.752948] RBP: 0000000000000002 R08: 0000000000000001 R09: ffffed106614600c
>>> [  153.759173] R10: ffff888330a3005f R11: ffffed106614600b R12: ffff88834895efa0
>>> [  153.765419] R13: 0000000000000000 R14: ffffffffc114cee0 R15: ffff8883470efe00
>>> [  153.771689] FS:  00007f6f6ac12480(0000) GS:ffff888362e40000(0000) knlGS:0000000000000000
>>> [  153.777983] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  153.784187] CR2: ffffffffc114ceb6 CR3: 000000035eb9e005 CR4: 00000000001606e0
>>> [  153.790567] Call Trace:
>>> [  153.796844]  ? tc_setup_cb_call+0xd8/0x170
>>> [  153.803164]  ? fl_hw_update_stats+0x117/0x280 [cls_flower]
>>> [  153.809516]  ? 0xffffffffc1328000
>>> [  153.815766]  ? _find_next_bit.constprop.0+0x3e/0xf0
>>> [  153.822079]  ? __nla_reserve+0x4c/0x60
>> [...]
>>> 
>>> I can come up with something to fix mlx5 but it looks like all other
>>> drivers that support indirect devices are also susceptible to similar
>>> issue.
>>
>> How does the fix you have in mind look like?
>
> To call flow_indr_dev_unregister() from right path. But you are right,
> it is already called, so we just need to determine why it doesn't
> perform the proper cleanup.
>
>>
>> Thanks.

