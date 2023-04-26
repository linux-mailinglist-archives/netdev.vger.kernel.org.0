Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF86EF658
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240813AbjDZOZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjDZOZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:25:58 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2116.outbound.protection.outlook.com [40.107.96.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4F84219
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:25:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klBkkjCJLOES9nQeg/gq/E5UmqRwPV3wJC7CyRhirSOnjWdE3tFilbQ2nZ4EjUVecbJ/a6+W22izD0nHJNV+r0W6m0sPIyXe7xy3qriM9yrG8wUrcLHmewikePzp5/S/CHBecf+vEVoTDeSqnIvYfMVBa2WhsFXKJ0UDsHrgQ2qy3Y1BGZqksBOjQ/Cpk3/4YwgKq4+PsX2xuNp2Ems4XUNh4GkqJS2DzHCAN+TVpSv9Lcb222jKHcdRaiaT7+m3qOFp99wdy7Ial1f5bVCm5+3fjlH5frLBaTb46m0hsVcBz/iWYwwb2akJQlfaYRX8tZg+tSb5FCZerXiWuCe+cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JduGgPmzmkVOJ8m3d4p/gqbQO+oB/bGxCJLnlsDGYa8=;
 b=IQIl1ZhC03kH8cpKJg0Sy6ddumywsFz5kEm8KYPDW2+TnDxFqQ11/bbQUtGkObNpfcKSPKn9lvgN+dd27ZLdIZZ7WU9XPt5dQiWULEis6BxVTxOGcZ5Fvu65IQpso8v5MLyCRvU90sh+WLdGqUyOHabXafxcH4oqEP5Aqb2tfuiMUfSw2ANBUfrXtMPWo9dGPOHS7aBKOlCilcM6vwzgNQFA6LlZ9wUU/nor2W/RYlRYt60WT5XSvtRDGOlmxrv9QuBtmYo1eqthPbr1QeHFP7XY8BKzgY+5cBeCVDDamsgzVsDlUmIKBZahVHKQkD+DtsHZyfuexSAIOJdsEA/otQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JduGgPmzmkVOJ8m3d4p/gqbQO+oB/bGxCJLnlsDGYa8=;
 b=P2ZDtL24Fja66JZT2MN3t/n/k8in1Bwn/ZZ4UhMsF+zVsyuR2D0RvuoLR1hJ9Wwfems7NqoT20rttTOrRkwZH+CVqD3fILFp+3TL1bHCQlPlEZbGdSF0yTxCv/tAM/QY5iPJqK5lecHNsV/tMot/ZDxIGRaw/KFcY3gNruu7FK8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4906.namprd13.prod.outlook.com (2603:10b6:510:a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Wed, 26 Apr
 2023 14:25:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 14:25:51 +0000
Date:   Wed, 26 Apr 2023 16:25:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, paulb@nvidia.com
Subject: Re: [PATCH net 1/2] net/sched: flower: fix filter idr initialization
Message-ID: <ZEk0WeVkx84TXbti@corigine.com>
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-2-vladbu@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426121415.2149732-2-vladbu@nvidia.com>
X-ClientProxiedBy: AM4PR05CA0001.eurprd05.prod.outlook.com (2603:10a6:205::14)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4906:EE_
X-MS-Office365-Filtering-Correlation-Id: accf256e-23f3-46d0-d0a2-08db46622342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hbOgtsmwjhSFCCwrFhOiOwd6ohU16+lhO5b8faPC8P/inrl3CwPhKblYr88DbXynrGck1mprgaoN86cwhVJH6Vu9i46MRntP+0sIAVxtEZlIp2mtwhFjc1feggRNyYoixlkXws8zGjrQLWGdqf3FKq4mbag6Gfpsq8eHKKH4nKmItMFTfu/Be1elapxL2QaRaXdvcV8QKZ7Q6vSgl896Lfy+tl/riEsERBqQup2t2P45sbnaEFxLXerChgEehed/pHJeatszM+lDEl+1quCKC9eYpuuR/0t/ewBonw338Qyw5UMIo5FghUdgBrRne9+0Giws44Y0viIyynJys5W3WQefBiyA3kWlOEijf0HY6BCf7+LLewlydQEhK4OFk3QUvp6crjWGYpeGNdM6c5jbfqSgWn1dNagubk3t9dVfxpTICaWlgW3kXG9f67LYvnsIybJEpzKLlKG4m99BsaeMPzABK3u0C6zZA+sizrI1eHRPmvpxHj76AN7XPDgKikQ0tU1e6bEETVXL6u9q6JYvg0JW/xBW+dWpaZP7b0NW8o2uO/x7pv2/Re04cAlL0lT6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39840400004)(136003)(366004)(451199021)(478600001)(45080400002)(83380400001)(2616005)(66556008)(6506007)(6512007)(6666004)(6486002)(66946007)(186003)(41300700001)(38100700002)(5660300002)(316002)(44832011)(4326008)(6916009)(86362001)(66476007)(2906002)(8676002)(8936002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PGwO5YAq8IfWcavCNEZiZ2kOIa1bXVPUJfXQSdHEEWOl1LCWOM4svNOANlmE?=
 =?us-ascii?Q?sMt8wDz1hqWlijlIz2PnCy7R6X7s9+oCWyU0EvBW87Y04fs14+L+SzVs9TAm?=
 =?us-ascii?Q?dzdz9X78pyD+iRxx2HzMArPGF9ZQTvZ21vrEL99pJ1sI/zM79CiQhydx8EBQ?=
 =?us-ascii?Q?F+cPaqeWienIKL0gRsbtvzXYfORleiyMeM69ZHwdYgj/xFx+4foTQLhsFxzj?=
 =?us-ascii?Q?iNIgBUzjVkT6lhImlkCmEQsYXEsyXKOOgH7EqfFjymDcIfFWioC7hxZsx8Ve?=
 =?us-ascii?Q?2YE0eKW7gSDceigpqtuRRJ5UHTIjxCdwAEqBff2b3RaGie4NA+BGW8fOQrig?=
 =?us-ascii?Q?iRIKDvZV/X5HQfbJ9+1UwSvJAJv8oia7VPHEceQXPVaqpHJyULtrSTCMgD3X?=
 =?us-ascii?Q?5OpahXo0gHQrC3hYWKG960U+NmIdMaWUD7Ox9aXLkKbXt2ped8GGgqU9Mg8n?=
 =?us-ascii?Q?It6BsBU6+cDXuCD1vpn3A9tHs/q1EmSZApFKRflNYv4Ky8QvhL2ZZliNHtwQ?=
 =?us-ascii?Q?imMaw6EQM4J3uQ+a9ebnkZE4T8pnMqRvHRh3ob+CAEt4RM5nBnQnhm54OPJf?=
 =?us-ascii?Q?f4cLn/xyWu1C/76tZDJA1ZWVrFyqr8WxtFVJdt8baOrhdZk3aGXKxXF90NgM?=
 =?us-ascii?Q?rzVxqjaz0fEQ2HezZ/FdnUAj8UX5esRPU3ynXe5+uPoR1ystn4pqqRGPlQzm?=
 =?us-ascii?Q?Gm6Ou9S9H0wYBMxBwtuSx4jznpArVVDsMOfEOXReVJVYcZ63p1RVyD7655lN?=
 =?us-ascii?Q?z1gdaF++X0Di6aU46+vZyZDHHefPYV0RNzKWSCz2R1rLLEyzIy9fespOjzYD?=
 =?us-ascii?Q?jP9hfJhD79gCMbibh2kOHlQy+lTd8LFW1LzdKy1d9FTswB3mkOhKL4sezDIk?=
 =?us-ascii?Q?pz5SNQ9pwXZvHRzVEZolx0N5Uwb7eFHWOI37YxfPa1EPl8ahjxJECrusITb1?=
 =?us-ascii?Q?xEO9b33tyQEStSJ5Ecc4qnTpJ4DOGW0v8m4oDGqwRipxhqaah/V8EXTQPn8d?=
 =?us-ascii?Q?TdyVGFoRE76llaXaIqDXYojP9dEKBYDTKJSieIzndh/sunQOsEHZnuttNxUI?=
 =?us-ascii?Q?WNCnV4erwNPkE9v/ZuVbbNjAY80g0OSd6977gV3+ixM1kqel+TCQ8OGnpPDR?=
 =?us-ascii?Q?sNy/HJQRv9/eYtRlPqPevoONYaTNNdIyyQzOQ0dN/7oAxWsmDgyEyMahhgqK?=
 =?us-ascii?Q?qsMDbTvZlRABluaGXILen9fTQlB0qSap+msB0QxAyl4krg2pSISuvROAyrpy?=
 =?us-ascii?Q?R/wDMxUflVbIavW7+GCLTvoTZoTjqkUvP+jaRjmPET/T6L2jXeO3qXvLHznw?=
 =?us-ascii?Q?/3uyH+Wh3SDZADrx5VSZp7JTOeeXmz7rIn19Zdj9LJICgyeq2lVX1AONjWOP?=
 =?us-ascii?Q?AvmIGY3Ef2qhIUs7zWyN2LKpollKeeaDLDgNLz9bGIuYv9AB4lbpTIzR9jOz?=
 =?us-ascii?Q?DiqTAdaxxw7zmUCiL8+uZCMPI0epFiIkcZJgu6lf25Cdinr3I3mcQ0vHHeyO?=
 =?us-ascii?Q?WHIn2oAG7fYXJKFyo8baxXTMln5IT/VYA20yzMM4Ul6InN1LtjzoBkmHsbH5?=
 =?us-ascii?Q?X3fTK8+bJJfN6YaIcSWYuPj0jRoTPj/VOZtwGj/tiRM/hY1bdtS5Vcf+B3QK?=
 =?us-ascii?Q?vJTTrX5Pt3+3YcPEeuyfJ1BCmWVuZHLeZSGyPO6vh02NkzM8lP9s8GovHR1X?=
 =?us-ascii?Q?Uvaz6A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: accf256e-23f3-46d0-d0a2-08db46622342
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 14:25:51.6885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjTsHC+eNIreWTZC635wIv1WxTULXnvFe+I5jrxqqYSGRluSgb5SAHTrS2SEyI/EmCuDzXrZISLBcmXN7WovkBXOAXFsYVXWxnC3mkNkC30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4906
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 02:14:14PM +0200, Vlad Buslov wrote:
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>

