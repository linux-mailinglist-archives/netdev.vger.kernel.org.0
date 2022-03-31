Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176094ED26B
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 06:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiCaEHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 00:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiCaEHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 00:07:47 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680C4287A13
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 20:42:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yu/dxAGHhjm8cAJux3RvsqdblvVVR41FvjE6QpfU9J82WFVguSWXHg7L6Ok2ZhkU+DObIyZWixeM5lkAdX9lOxZyuwxrpBOMndC1K6M7ZqfM8kRU8Jxp722q+PL6IRWnvHvPs3MySwkBjPAyjzSTJ4+HfP5T2Vqqv+XyyIUIzE4koML4IKry+QiNeH/WPmuu120bD4tPnwYZvXV+B/1wjZw2FHHgRk3zAIa6+DBqifymTzoJA9FMoKq5bt/Ew1lvZHVfaUANIY88YHHinnfAJaqC6zT9QjUyC9v8H69nYpkD5lhQmeR+l85oQWd9W0e4OcYW/r2qbpk3i1t8S806Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsJ5eriGNx8p3+k6dXY03p1wLpOn+qxBWH2Cp0B/SFE=;
 b=ARPcZa3oQ4U2NZayIui4fcW3IOO+J2yG3gB12I2yHa6LxG6Kdjk3u6j8FNuOQBQ1P8sjDV8nWjxNQ9VyphvHw27gBJBDwGrhlPdBy1Z+TgxlTg2peXNvMYngW2M4QTQZv3CohGw2fNlLQDTBdZdNrje5if+6nWJ8xIxhPI1PCyMDPbdqJeuJRILQXX+wToYk6H5wNYlIOcX0nPTEFVxPLpytWjciOkLWGXXdTYfLYQYebRpajwsOnEDVJleKySBG2lBslJqzBUTSAW33rqptziFsTRxC8Z29PpLzC6YwEBFb+mijB0DGpqH0CCYuZ2yFwthBykMlcByL5d9hN8SP+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsJ5eriGNx8p3+k6dXY03p1wLpOn+qxBWH2Cp0B/SFE=;
 b=m3MKep8uGhFnbjlXHhv8VL3U/QfD+wQTcZl7a4DyaBgxipV7ivZ5rJQmHRVjwE4kgF9xQYKD50EaVsu3/F+8mA2EtWUyYakJCoZ4QWdc2qYDCBk9w6HwGkrcJmRLpY8q8saW1E8k62SrkLXeSHwl9B5JDcvlBoTBvOgUDT0t2UQO33K/d9kZM0IL9kpRe4UO5bnFbiaXT5gFuXrfmLvI2fYNv6t7v9o9zQGjH/rYUJYgVjsDP9w4/5kkgylzVlwSEa44fUZi2VsOu6dKPFDll571jS5bByVoHgwA8ixYEhap+2o2++wVv/2UhcIBsNA9zsRoa+YcVBig16XExZaiKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CY4PR12MB1141.namprd12.prod.outlook.com (2603:10b6:903:44::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Thu, 31 Mar
 2022 03:14:09 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::1410:fefb:a809:cb2b]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::1410:fefb:a809:cb2b%5]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 03:14:09 +0000
Message-ID: <bb6ce697-d952-6b57-d6ba-d30c9849f869@nvidia.com>
Date:   Wed, 30 Mar 2022 20:14:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] vxlan: do not feed vxlan_vnifilter_dump_dev with non
 vxlan devices
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20220330194643.2706132-1-eric.dumazet@gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220330194643.2706132-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::11) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5eefceab-3733-4888-042a-08da12c48595
X-MS-TrafficTypeDiagnostic: CY4PR12MB1141:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1141541C4D61B8828C4298F7CBE19@CY4PR12MB1141.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqlDiKtIfHvdeMf0W8H1v5nPdYglKYZIveoX5/XlgPwkckFTx7UihhwCkxS/r80rQFXdAsBVKVkmSabRbuX9IwWDv87XA0Nia4oh6phE6fFGYwx+C64AR+wTR3f81qSYNi69S/6nEtFqOWF/BEbe7fQ0W4DydbG68KuMdYzqcs847+Ku4vTk61LeRbEI8UMGtRd9hIJyzZv3KSPbRkPKiP47c+aOsgGRsEgdcJL//VHluUTwUOLfwZ24eXdNGViziZJeFRGDvr+KtfmRrMmlQ2bbhdOIMqZGsRWwZFV9uUAW/fBd3JoqEXojp/tSpUEZwkQGj0FsVi9mRAtP+pzONgkk0T6efgo6LXQ+uP+2KmahMt5CAjAsMgXCNWZn8PY41t0UNcTD1Fk9PBhy26ZJLEtIUYC6zE2MG62RBNitbqdahF7kvMiubsLn7lEOQcrvKBXMK2Nx7kOmX4ebVOh5XDLl64epvqzGo3l/xlIyZqsyb+nbo2UuC8k/o4K5Vofy/uJTZJuuBS4v3dNiHkDE1Lj1jCLPEeJd2BYb+M4TWkZyKEIElWcDfn7KGNbmG3LeMv2AlnCUWBWg4U8KTk70NPjXcfpAwgXcnmVvT7wAxwbmb95iAiez3xw+F3JSuXcgwmQrgR812V9b4Fxz9N5lUzAJCGc+kPIAl7IkAYFu93DFZGgv3vmRHtmOST1tACmYPTQZOqFU4a/uR/Iu8GXMQECmVHhIJ6GGBpShV6G+QC0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(5660300002)(86362001)(54906003)(4326008)(316002)(2906002)(66556008)(66946007)(66476007)(8936002)(8676002)(38100700002)(186003)(31686004)(6512007)(53546011)(2616005)(6486002)(508600001)(6506007)(6666004)(26005)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1RSZXQvTlpYVEZtb3lSbWYyWXlOSzhuSGpWU2syOHJWWDkxR3Z6eG9TbG4v?=
 =?utf-8?B?T2lKeTJKS0pvNG41cE80OWVCWVRmUm4vM21qU1ZvbEdFREJwTHVsc2NTeHNF?=
 =?utf-8?B?VGNXVTZHWVcxUG96WHM4R2lNWXRhTTlUUjlNYWswemR5dTh4dEl5QzBIaUFw?=
 =?utf-8?B?emsrUFI5L3BlVEZjakprT0RkVml4dGFNeUFocWMyTHVpbmd3V2haOFJGMUkr?=
 =?utf-8?B?Lzd3UTVtUzNoeHhidzY1YTM3Y1JzVXVwSDgrc0dwQzYveUtlT1JYL0pvQy9H?=
 =?utf-8?B?VEdkb0tISFpydFMzcVFKaXRxZTd0WkdvZE4xWnRzVUtpaGgydzhINDNQbEx4?=
 =?utf-8?B?RFliSnFkbE5sUFNUMlFPVDZDQ2NpRDdnbWRJZXhjLzB1ZHB2QWh0RlVHbk85?=
 =?utf-8?B?aG9WMm1CRG9MQVA3d2ZYWjRiRG1rWEkrMUNyREtNY3FOT2ZIcVZNNUt5ZmxD?=
 =?utf-8?B?UjArRHFPbkttQi9GZzJpZVIrVUIxVW9qQkdua2lpNkZWWUc4Y21yRysyS0Jw?=
 =?utf-8?B?WG9HRnZhc0crc0ZyblhSV1JQMmQ3RFRxUHgyU1NRRFB1SkZLQzc0MlB3dkJZ?=
 =?utf-8?B?bUQxL0IxR1JXUnNUS1hwMVh6K1lYUHU1OGFHQzIwcmdyVXhNcDBIVUoxN1ht?=
 =?utf-8?B?THhZSjI5cWxuT2tGQXNLY3pHdlVSMXhuRkR5eVdpQ2ZSVEdhN0FzTldFUnpI?=
 =?utf-8?B?R21zcWwxVDlWUUU5SmhoQzhWWHNiV3l1bzB5Qmkxa004NkxjR3UyRTI3NXFh?=
 =?utf-8?B?QTc1c1FPUFFuaWUvSzVsei9sNkJmK2w2YWlCMDhhYTZGYTRzNmYxVDdxdGZB?=
 =?utf-8?B?dm1SV3ZzU2FRMGhNVEpzTmVzN21RWkRua3NMaWpRTS9aczVXeUY0T3Z2djlH?=
 =?utf-8?B?dEEwbGJlTW00akJ4VVp4NEllVHMycEE1VTFSMFhjS1VTVFBKYlR6a0RqM1E5?=
 =?utf-8?B?MWxiaGNFekVrNzNsemlIbGV0QXFaampJTVFubzViMGJGb3lDMzA2a3o1bXMy?=
 =?utf-8?B?SDR5bGl5R1pwc3RjM0NJNjlZZzdyWjRqaGlLQ1BTV3RUZGc4aHJNRW1VVVVz?=
 =?utf-8?B?ZUFlUUZZcm8wbmtqUUNadm5IejE3VzkwMVE3MHFjdkttYkYzWHBTZm1VVGp0?=
 =?utf-8?B?eFdCczRsNE44QWJYWUtqNVlpZjlQUUZVTFBQbm52SmNEaHRLMEFSaHBjeGZs?=
 =?utf-8?B?SEpkeG8yVEhtNVNRRlpzN0JCN0RDbTh2bHArMjBuMVlEbU4vaE9nalI4U0tt?=
 =?utf-8?B?aEJHWVFZQmtqTFFhd3RtVDMyM0F2bmU1S1dLVDRVdjd1R0ozSUFES0o5TUVE?=
 =?utf-8?B?bUovSkhwK0JFeEFscklkR01wZ0srbk1iZkk1TU5ENUM2blY1eDJNTnFsVHNI?=
 =?utf-8?B?cktsV2xHTlp3WnRNQVRucnVEN0hoQVg5dnBLb1Q5bklSbXRQMk5Tc2NkVW9w?=
 =?utf-8?B?dkR3eW1kaDFpdDhtVDlYTEJmcm9VdisxRUVWUVdSTjRPYjZMcFEyejVxckZM?=
 =?utf-8?B?dmFaUXZxMFlYQmp2MVV1U0FBK204OEE3ME9UMWppcGVkOFZkVXpXejVWbEVB?=
 =?utf-8?B?T3FHeE16WVY5aXhmNVJQT0tBbDJOLzBBVzBLTHJiUmFKQWdkdDBDOWlUUU5O?=
 =?utf-8?B?L2ZnanZKUnNlRWpnNzd0YjAxSU1rRmQ2ZjIxOERVbEFiWXl0emc5Y05IY3Zv?=
 =?utf-8?B?Nmc2Vm9PekhpNlFrc0pzMk80SXoxbTlRdUdmdk93TFNTeUI2YXVHY2ZRNzB3?=
 =?utf-8?B?dFdTL2o5TzFvaTlFTUJodllqMzlrMFc4WXNySVVjbjhHVU5HaUtyMk1zQ2gw?=
 =?utf-8?B?eHhwRFVGS0JIK0xTcFppdGI1OEtBbWxMT3kzT2NhRGR0a1RvUnV5ZC9zWlNs?=
 =?utf-8?B?bzR0c1hKdlcwd2tzS0VDWGtPVUZleEZCMld5NUhzQVF3V0pJTkJQbE5PS2Js?=
 =?utf-8?B?RlBiTlUyU1FHTTFvdzdHbk1pblZqNnBYN0lEckx1SHR6RGcvci83dHgxVEFs?=
 =?utf-8?B?Q1JTRUgzT0VqR0htSGp6WnJtYm05Y2wzUnIxNFFkM1A2N1BDVWtRYXNsbDRC?=
 =?utf-8?B?ZlFnVCtoNW5CVGhsUXoyYlIrbXBuQ21WaHhsZ3Y2U3BDZ0dMSDhTamNXSzZJ?=
 =?utf-8?B?ejRkR3ZEcnNCRlBFMzJ4QnU0c3Z3UDBSR1R2UytIWnhXQUpCU3VHUmwrUko2?=
 =?utf-8?B?Y1h3Uk9tNzNZN2xmZnEwS3FoUFduYTNpNG1XWjlXdXJrNlhyYzMzKzg2Szg3?=
 =?utf-8?B?elk1NU9yelk0dFB5ZWlDUDZSWS80TGlCc3UydUVYK3cvZ2hNOG9udlREUXZq?=
 =?utf-8?B?Qm85Yk9tQndBRzM4aGZ2Tjdhb2MrK0lpR00zTzAvWUJMUGRuNWRldz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5eefceab-3733-4888-042a-08da12c48595
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 03:14:09.2715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0kbeya+aUgbvKs+o49ghLdNPBU6pdo49ZC+U1psLvQxqlhFkpYOZg0DjHJjQb7djZXMh5Vc8v73XybKmeOnnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1141
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/30/22 12:46, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
>
> vxlan_vnifilter_dump_dev() assumes it is called only
> for vxlan devices. Make sure it is the case.
>
> BUG: KASAN: slab-out-of-bounds in vxlan_vnifilter_dump_dev+0x9a0/0xb40 drivers/net/vxlan/vxlan_vnifilter.c:349
> Read of size 4 at addr ffff888060d1ce70 by task syz-executor.3/17662
>
> CPU: 0 PID: 17662 Comm: syz-executor.3 Tainted: G        W         5.17.0-syzkaller-12888-g77c9387c0c5b #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
>   print_report mm/kasan/report.c:429 [inline]
>   kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
>   vxlan_vnifilter_dump_dev+0x9a0/0xb40 drivers/net/vxlan/vxlan_vnifilter.c:349
>   vxlan_vnifilter_dump+0x3ff/0x650 drivers/net/vxlan/vxlan_vnifilter.c:428
>   netlink_dump+0x4b5/0xb70 net/netlink/af_netlink.c:2270
>   __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2375
>   netlink_dump_start include/linux/netlink.h:245 [inline]
>   rtnetlink_rcv_msg+0x70c/0xb80 net/core/rtnetlink.c:5953
>   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2496
>   netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>   netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>   netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1921
>   sock_sendmsg_nosec net/socket.c:705 [inline]
>   sock_sendmsg+0xcf/0x120 net/socket.c:725
>   ____sys_sendmsg+0x6e2/0x800 net/socket.c:2413
>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f87b8e89049
>
> Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Acked-by: Roopa Prabhu <roopa@nvidia.com>

I thought i had a check there. thanks for the patch eric!.


