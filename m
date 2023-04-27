Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759546F0082
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 07:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242714AbjD0FxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 01:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjD0FxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 01:53:19 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E193585
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 22:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXk3OwuRuT7IK7d3Asl3eFP6yy/DzU7hRM6jhMDEq4phw1NI6C30xkLtCGbwkTzw8XNGZxBAwYYCaEqW7wHn1764tQ+8wBtVrobwTUw3TpNIYljQ/NhzbUw+nMiBxvNzfQ4kiAErhYmaUeXZFDqwH9uVos/SM22+D/orpWvYHcZjnE3NNHcDB7aPKOXP2332ie+AdISDm0zLMbw+1rPWHfhtIoC153vLt1OyF2iKKJUbsEEB99sC4snNzXjcIALJZuInoco0GClDJ0xxg/UUBWKNrjseOWKQjlhaiDaHnwHAfzjotMVMhiWGelZ8aL4iFSp+KMLbfe5cWNexAbp2QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lp94jYQTdbku21KjL1lgygDVbGsuJ41YsX3Y2ReCxjc=;
 b=S2xq9yWJ3Te39FQBdMRZvFBhsHlLv4GSjhyQJnMA959HAZM5z5hKHlBd7KMGx5QchjADRo44d8LJRuZNuEvl2On4kiPRmowb4Md4Os2Dauc3bM7QKhybr8uhjEDKLtp1+NZTBsjB/QDjVtsw6zVdzwLX8QqOVaGdNOA7gmsUMaRb0AdBfFMONwzO0X0W+C0sYDhTwpd43v9OpYpbWlF5Nx7TgtMh0140wpTmqvIOFfzkLj75YUL9ZAQUAT1CrQi8SSyNJUcaM7PoKmqPtQJzDMIWDYCc3w2kPUeAa56Tzc+NrL3h5aFE1rjsUK/BMj99J1OSGFTH6N9s/zIk74ygSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lp94jYQTdbku21KjL1lgygDVbGsuJ41YsX3Y2ReCxjc=;
 b=huPbAm2E1uTbNHxvFbu58VHeGKkVf6a6VhYxHJGZIrfSo34tnK7ZbwfwSeD1xU1cPdJRPSRPNhZHRbIfZPOutWnD3tgWoXJUAEEV9dt7uwMgs2JKxsj5X45hce+bf6dUcL4ZVCqqVvXFJgL0OdVDeu/BRsUmzi/6/ioaGw2JkgFZBWMjaZPu9Csd73kpqo8axROExgxVrR9rlLDmUSjIfE0JG1RyKOyqCQoa8hSAfj2QmDFjPSO+pNiOSIJKTSS5FqZsPn7wHNP3fvZ13Opjyd/wSX2MYQtCLHhMGW91mEs9VEK2hWt8zhkvT1zh4lPrif45V8SpJo3BuvsXcB3ZwA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by PH7PR12MB8108.namprd12.prod.outlook.com (2603:10b6:510:2bc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Thu, 27 Apr
 2023 05:53:15 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::d61d:3277:363:c843]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::d61d:3277:363:c843%4]) with mapi id 15.20.6319.034; Thu, 27 Apr 2023
 05:53:15 +0000
Message-ID: <0567b910-9a60-8196-4413-dc15fde60ec6@nvidia.com>
Date:   Thu, 27 Apr 2023 08:53:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 1/2] net/sched: flower: fix filter idr initialization
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-2-vladbu@nvidia.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <20230426121415.2149732-2-vladbu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0150.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::8) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|PH7PR12MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: 49a77971-af04-40b5-6bf5-08db46e3b160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4idTEAXZkDVltINo0yi/3niMiBDVblvNtBNIlh5d8hTddcy1g5jkA8w/0KTnzdwMwNHQWXhQINup+kap7VLgoHkJbqNTPy3xHNrRn5we75/32uNm/JV1wGRxTj+C0hRBnI3/o8v2YDojXT9GuDJ2hIz2agzjdcYNvVL0LKEhiL2cwyaM/y7ZLZPktHXhmxfYJTi8mv5G6jF2H8AA+OXWDc7OGwuCVvJ5ApKjr/p/hqOYE2dGQZUnLO6O6pJrMyPIN/UTfZUmIb6BpCrPVbdGVpxtGVfqlITE9+x4uyFkLapL8Pj1IFmhP8SeywmgSGzyWE5mmz4uWxtS+ZrD/8AI8LYJOIeE+JYmO9pArWPjCLBXr2itenzESXVgVm2qxkNSZRo+EJ+UCZ/YBHw+EBNGjCmB8L51scIj3kji96TUHWs8+faicoIOJxApMgP/0eGaBfOz2mwNsqSCsjPoIA58C7PGQEdrqggG+MVBDt7DrhCRAYX+Ev0igI1YFNDFdwNd0/JZtAoYqDie3WZs52fh8ES66PfMcpPwIt+tCdI28Hn9WvYLyXbgEc+ZuX13K7e3XSfJYrXJd4liXnlqkPo14GDQeqMKMp+uKyC+Saz1QXHXL/RhlVCbu2mjyr0uJAPtscWnFo9lgikyZiTGmd7Qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199021)(8676002)(31686004)(66476007)(66556008)(8936002)(45080400002)(31696002)(66946007)(38100700002)(478600001)(86362001)(2906002)(41300700001)(316002)(6666004)(4326008)(6486002)(5660300002)(53546011)(26005)(6506007)(6512007)(186003)(2616005)(36756003)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWt6UzZ0UGFnZlRyS25QWHlEZ01jam1Wb0JUZXUzci9WbDg2Ry9yRTY5aE0v?=
 =?utf-8?B?eTBzWFJ3K3RQSytGalQ1MXJuamVqY0RWTllsd0NxdUg1V0xFVWlha1g2SG1S?=
 =?utf-8?B?eFZYN3lrSng0alIwV0d1RnpzTEdGWVdKTnI3L1lRTnQ1OUVRd0dCTWJtYzli?=
 =?utf-8?B?MXNnWjVFNHRwWjZiWTVtZVV2NkpReFFYeUlQcko5dHFBMHR1Q045YmVEbGZE?=
 =?utf-8?B?eDh0a01XdUNlWnBLUUJtam8rMzZva1NKRm44MVQ4RmxDZDJYUGN4OUtGbnBo?=
 =?utf-8?B?aktzTnc1OWFzMlRMZmYrMEdrY0xWTGg1aG5XMlR6L3J5S3ZwVi9WK21jOXhj?=
 =?utf-8?B?cmZGYzk1Nllqc3hSTGh5bEVrSDh6andWd0RNNmdMN0pSWHRwUmkvbFV3L29N?=
 =?utf-8?B?VmhYTVBkOHFyVjZwS2dYZ2h3REtwR2kyTW4yVk94VFNDK0RsdWROYjQzbjZ1?=
 =?utf-8?B?c0RrMzdkS1VPeE11bk5FTzlDMWtWbHBDUXEzTEZrdTIrSm1OUE14OVpidlVK?=
 =?utf-8?B?c0k0dGpKQjRMTWtEaUFuODB3Yys3NytteTdJaHJReVcrdkxWUzRvQllQZWtJ?=
 =?utf-8?B?RGRZK2hKMWtwQUhUbmRUWDlmSzRud04zMTFqUGRBeWF2SHQ0UlF2TjJGRTdq?=
 =?utf-8?B?TFJTdHJyTE94amo0ay81b2FzUEEwMmNWUm8wUEF3bnc1UkhreDgxVkRTUUkx?=
 =?utf-8?B?aGVUb2Z2MklKOS9TNDhQWWhML2NaRlYvdHIvUkRUQWp2cEZPcTdhTlFwSkph?=
 =?utf-8?B?b0k5elZQWTk3djZVRkpGazRNT3JxTDVWVVBJQy9GdzFkYmM0ZGdncld5TE1Q?=
 =?utf-8?B?eDNqZlFaa2xWanZCVXlZdjdzMStkYzBzUWs2bWF3Kzl4YVJhSjRvOXdYMGhE?=
 =?utf-8?B?U3NkNE5oSWg1NzZ0RmhhWFJSMC82NzgzK20xcTJTSXh2ZXZnTFh3TnNuM2cw?=
 =?utf-8?B?K0ZlVUxtT1pqUkVYNkZTTG15bGNySjBKYzR2bEMyTDVHZXNEeG9mQXpIK2ha?=
 =?utf-8?B?aWVnRmJhVlFkNlI0Wm1OYlF2UEpDMUVHUjVCWFRlSmJBUHRTaTZpVnJ4Z0hp?=
 =?utf-8?B?RkhtR3lhL2E1ZmhXWDlscWlUOXlXK1JLSHZpYlFhZ0l3c2NnbTl0ZXQ3ellU?=
 =?utf-8?B?cWMxcFBsVkFDK1ExR1FYQ0d0TDdvYWJhVVFyKzlkY1crYk9tQzJmbytYK3Js?=
 =?utf-8?B?MFFVc2ptL0tuWkFTSXF2aEdLUThwTzhxNmMrSi82d1lBN1E2NUJFMnM5OFpR?=
 =?utf-8?B?bURDUnJ5OGwzTjVZeWJ5OVE2Y3hLa21qU0hreEFaLzlFQWIrbDIybHdFV1Jt?=
 =?utf-8?B?cFQzbjdvQ05aYldPQlgzUlZkdjNkZ2MwclBMbC9oQTVSYlIwSXZLV2pRTkFD?=
 =?utf-8?B?UlFrQWsxOVBadkVRd1RjcnVNUkJCcjA2OGpHdCtMNzRycnNKZzZlT0NhclJ3?=
 =?utf-8?B?RnZ5Z0pEcTE3OVVqTEhmZEVmcG1KR1phV0o5UlM2ZHdxalI1TmxiTGlobkxJ?=
 =?utf-8?B?aWRMbHI3SmFwZ2MvU1Y4S1pBQ3lveUNYenVCVGlWSU41Mkp0TXZPNHF1WWlF?=
 =?utf-8?B?VURLRmJiME9MMjd3U1M2cHp0TVBJMWNNOXFSZ0NtSFowMHNqYmJ5ZUowNGg1?=
 =?utf-8?B?elJMVXJGSFFMWVVvRDlZc1huR1VTWk1TZVNpbk1FWTlvNnhqdDRsUUJDSVVt?=
 =?utf-8?B?Wk5sODdnTEI0aW1zcnIvUU1semZZaWlPVXdGcU9TWUYwZ0h5by9pWThRaHEz?=
 =?utf-8?B?clNMeGI4YkhKam1CUXNmUXRCNk1VVmdmb2NhaVNUMzhqVEtGWkhITURzQkZS?=
 =?utf-8?B?Z1Z4NExyR1JyOENvYncvai9lcVJqMUFyUEIyMkJHZjUyODZjaWFyQWlneEx2?=
 =?utf-8?B?NVNWZWhYK2x4VHM5NDZjZlJuZGFQTStBbzVWaThQd1lnalgrS1ZJbnF1enJy?=
 =?utf-8?B?YmlZRXk1QnlZc0ZHSG9sTHgvWS9RTE9xc25DaVdCYW1yWkpINndrdEROTlZ4?=
 =?utf-8?B?ZGZ3cnNGSk5FYi9KUUhzandXQUFRcXFOTkpZcW15aC9DOU85UUpvUDBoT0ZM?=
 =?utf-8?B?NnViUlBxKyt0R2s5cXpNVVlFZllOVGw4eHMrTmR2c0lsc2ptVXZnVEhvWEdC?=
 =?utf-8?Q?KH+Iu4oQUqAg+vXB/l8JcTDS5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a77971-af04-40b5-6bf5-08db46e3b160
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 05:53:15.3460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OzvcmXERfQVMYx3vfUP/JAJy5TVUKf30Ia8//PZm5bRoKVOzeIQ0tsDp80hPck4FtGKOKcJWeuXZbRxg0kCpyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8108
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/04/2023 15:14, Vlad Buslov wrote:
> The cited commit moved idr initialization too early in fl_change() which
> allows concurrent users to access the filter that is still being
> initialized and is in inconsistent state, which, in turn, can cause NULL
> pointer dereference [0]. Since there is no obvious way to fix the ordering
> without reverting the whole cited commit, alternative approach taken to
> first insert NULL pointer into idr in order to allocate the handle but
> still cause fl_get() to return NULL and prevent concurrent users from
> seeing the filter while providing miss-to-action infrastructure with valid
> handle id early in fl_change().
> 
> [  152.434728] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN
> [  152.436163] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> [  152.437269] CPU: 4 PID: 3877 Comm: tc Not tainted 6.3.0-rc4+ #5
> [  152.438110] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
> [  152.439644] RIP: 0010:fl_dump_key+0x8b/0x1d10 [cls_flower]
> [  152.440461] Code: 01 f2 02 f2 c7 40 08 04 f2 04 f2 c7 40 0c 04 f3 f3 f3 65 48 8b 04 25 28 00 00 00 48 89 84 24 00 01 00 00 48 89 c8 48 c1 e8 03 <0f> b6 04 10 84 c0 74 08 3c 03 0f 8e 98 19 00 00 8b 13 85 d2 74 57
> [  152.442885] RSP: 0018:ffff88817a28f158 EFLAGS: 00010246
> [  152.443851] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  152.444826] RDX: dffffc0000000000 RSI: ffffffff8500ae80 RDI: ffff88810a987900
> [  152.445791] RBP: ffff888179d88240 R08: ffff888179d8845c R09: ffff888179d88240
> [  152.446780] R10: ffffed102f451e48 R11: 00000000fffffff2 R12: ffff88810a987900
> [  152.447741] R13: ffffffff8500ae80 R14: ffff88810a987900 R15: ffff888149b3c738
> [  152.448756] FS:  00007f5eb2a34800(0000) GS:ffff88881ec00000(0000) knlGS:0000000000000000
> [  152.449888] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  152.450685] CR2: 000000000046ad19 CR3: 000000010b0bd006 CR4: 0000000000370ea0
> [  152.451641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  152.452628] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  152.453588] Call Trace:
> [  152.454032]  <TASK>
> [  152.454447]  ? netlink_sendmsg+0x7a1/0xcb0
> [  152.455109]  ? sock_sendmsg+0xc5/0x190
> [  152.455689]  ? ____sys_sendmsg+0x535/0x6b0
> [  152.456320]  ? ___sys_sendmsg+0xeb/0x170
> [  152.456916]  ? do_syscall_64+0x3d/0x90
> [  152.457529]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.458321]  ? ___sys_sendmsg+0xeb/0x170
> [  152.458958]  ? __sys_sendmsg+0xb5/0x140
> [  152.459564]  ? do_syscall_64+0x3d/0x90
> [  152.460122]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.460852]  ? fl_dump_key_options.part.0+0xea0/0xea0 [cls_flower]
> [  152.461710]  ? _raw_spin_lock+0x7a/0xd0
> [  152.462299]  ? _raw_read_lock_irq+0x30/0x30
> [  152.462924]  ? nla_put+0x15e/0x1c0
> [  152.463480]  fl_dump+0x228/0x650 [cls_flower]
> [  152.464112]  ? fl_tmplt_dump+0x210/0x210 [cls_flower]
> [  152.464854]  ? __kmem_cache_alloc_node+0x1a7/0x330
> [  152.465592]  ? nla_put+0x15e/0x1c0
> [  152.466160]  tcf_fill_node+0x515/0x9a0
> [  152.466766]  ? tc_setup_offload_action+0xf0/0xf0
> [  152.467463]  ? __alloc_skb+0x13c/0x2a0
> [  152.468067]  ? __build_skb_around+0x330/0x330
> [  152.468814]  ? fl_get+0x107/0x1a0 [cls_flower]
> [  152.469503]  tc_del_tfilter+0x718/0x1330
> [  152.470115]  ? is_bpf_text_address+0xa/0x20
> [  152.470765]  ? tc_ctl_chain+0xee0/0xee0
> [  152.471335]  ? __kernel_text_address+0xe/0x30
> [  152.471948]  ? unwind_get_return_address+0x56/0xa0
> [  152.472639]  ? __thaw_task+0x150/0x150
> [  152.473218]  ? arch_stack_walk+0x98/0xf0
> [  152.473839]  ? __stack_depot_save+0x35/0x4c0
> [  152.474501]  ? stack_trace_save+0x91/0xc0
> [  152.475119]  ? security_capable+0x51/0x90
> [  152.475741]  rtnetlink_rcv_msg+0x2c1/0x9d0
> [  152.476387]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
> [  152.477042]  ? __sys_sendmsg+0xb5/0x140
> [  152.477664]  ? do_syscall_64+0x3d/0x90
> [  152.478255]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.479010]  ? __stack_depot_save+0x35/0x4c0
> [  152.479679]  ? __stack_depot_save+0x35/0x4c0
> [  152.480346]  netlink_rcv_skb+0x12c/0x360
> [  152.480929]  ? rtnl_calcit.isra.0+0x2b0/0x2b0
> [  152.481517]  ? do_syscall_64+0x3d/0x90
> [  152.482061]  ? netlink_ack+0x1550/0x1550
> [  152.482612]  ? rhashtable_walk_peek+0x170/0x170
> [  152.483262]  ? kmem_cache_alloc_node+0x1af/0x390
> [  152.483875]  ? _copy_from_iter+0x3d6/0xc70
> [  152.484528]  netlink_unicast+0x553/0x790
> [  152.485168]  ? netlink_attachskb+0x6a0/0x6a0
> [  152.485848]  ? unwind_next_frame+0x11cc/0x1a10
> [  152.486538]  ? arch_stack_walk+0x61/0xf0
> [  152.487169]  netlink_sendmsg+0x7a1/0xcb0
> [  152.487799]  ? netlink_unicast+0x790/0x790
> [  152.488355]  ? iovec_from_user.part.0+0x4d/0x220
> [  152.488990]  ? _raw_spin_lock+0x7a/0xd0
> [  152.489598]  ? netlink_unicast+0x790/0x790
> [  152.490236]  sock_sendmsg+0xc5/0x190
> [  152.490796]  ____sys_sendmsg+0x535/0x6b0
> [  152.491394]  ? import_iovec+0x7/0x10
> [  152.491964]  ? kernel_sendmsg+0x30/0x30
> [  152.492561]  ? __copy_msghdr+0x3c0/0x3c0
> [  152.493160]  ? do_syscall_64+0x3d/0x90
> [  152.493706]  ___sys_sendmsg+0xeb/0x170
> [  152.494283]  ? may_open_dev+0xd0/0xd0
> [  152.494858]  ? copy_msghdr_from_user+0x110/0x110
> [  152.495541]  ? __handle_mm_fault+0x2678/0x4ad0
> [  152.496205]  ? copy_page_range+0x2360/0x2360
> [  152.496862]  ? __fget_light+0x57/0x520
> [  152.497449]  ? mas_find+0x1c0/0x1c0
> [  152.498026]  ? sockfd_lookup_light+0x1a/0x140
> [  152.498703]  __sys_sendmsg+0xb5/0x140
> [  152.499306]  ? __sys_sendmsg_sock+0x20/0x20
> [  152.499951]  ? do_user_addr_fault+0x369/0xd80
> [  152.500595]  do_syscall_64+0x3d/0x90
> [  152.501185]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  152.501917] RIP: 0033:0x7f5eb294f887
> [  152.502494] Code: 0a 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [  152.505008] RSP: 002b:00007ffd2c708f78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [  152.506152] RAX: ffffffffffffffda RBX: 00000000642d9472 RCX: 00007f5eb294f887
> [  152.507134] RDX: 0000000000000000 RSI: 00007ffd2c708fe0 RDI: 0000000000000003
> [  152.508113] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
> [  152.509119] R10: 00007f5eb2808708 R11: 0000000000000246 R12: 0000000000000001
> [  152.510068] R13: 0000000000000000 R14: 00007ffd2c70d1b8 R15: 0000000000485400
> [  152.511031]  </TASK>
> [  152.511444] Modules linked in: cls_flower sch_ingress openvswitch nsh mlx5_vdpa vringh vhost_iotlb vdpa mlx5_ib mlx5_core rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm ib_uverbs ib_core xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat br_netfilter overlay zram zsmalloc fuse [last unloaded: mlx5_core]
> [  152.515720] ---[ end trace 0000000000000000 ]---
> 
> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

Reviewed-by: Paul Blakey <paulb@nvidia.com>
