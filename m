Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842ED65C329
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbjACPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 10:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjACPkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 10:40:02 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A0911C1A;
        Tue,  3 Jan 2023 07:40:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG+3il/qVm/N6UMNmqF7/oJNrHl1YjT5x6reJaV1TxpXS4O65ZZRjZap4sV2mV+kfXSuwsRMzgi+awn3TqKJelgBBcc/D7zZNmyWTR6TvfNTnYSdTEbEG5Lh/3cRfMp/XWQq9nuEmvkENX2r7peSgDfk0MEFb1faIxuqfWmHc92vxRtfreqa01fByuHjXoN+G9j39Xc5yuWOerQugWEvXS/wjfIyHs/W7RWSiLu3Lj5j5ys7/DJ50MSWOdsTX1PegKIwq1y2O0uJzc+glpIw/X+jp9wAi5BSSg1IE9flxcYbO9HTnVH78Zoyx1TJM0NZ194x1mcgOkVS2RoYKfxCTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iOQY0wxj8IGPhcO93ksvwGIBM5d5IId5rRIOBXryFUg=;
 b=NzrtD9/4f74xDvMZVarwgkVtHE+8iIRK0P11dfytbjEfDdqgTQ0UjCRoWre/fvAQLkclyzcUpcERqSkrEHfEBEEpMHnDkBFxdPxH7iVsgkIzlKX5CrgqplHAbPcLtd8uYyPCDZZkvg1lEL0ipka14Ytb88SxFprGgNIbKBCEoWQhsLN1Zbj/MMBfla13PeDyxAcXaRE0Usy6cAcAwqAgSlqxE+yZeoJcK3gKPBScBTcamPzqqsv8TjBJeT0fRJ+QBS/BGdBdNHVITxTfLRrKe5QXUcwaaXapfEkjwpeFga+k6Ccn9zcZwwQs783HFjEreIPyd+h9v515kVEXS12H2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iOQY0wxj8IGPhcO93ksvwGIBM5d5IId5rRIOBXryFUg=;
 b=bWnrN5G/rGwaxi/JEtzQAqzzNWp+PY8G13M/+QFfEA908KDwGlAkinq0/TcbKDOiKZc9m6KE7VE+ylN05C5gyZhSayGQ/YtZAUqE7FzWfqLdT5FX7ccMyY5Kc456j2ezqDzC8HwlcSeNlfc8gqAsBVDx1uc4hmO7kUyZGX/EriY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by CO6PR12MB5428.namprd12.prod.outlook.com (2603:10b6:5:35c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 15:39:51 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::c3f5:aede:fa4d:5411]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::c3f5:aede:fa4d:5411%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 15:39:51 +0000
Message-ID: <ea9c2977-f05f-3acd-ee3e-2443229b7b55@amd.com>
Date:   Tue, 3 Jan 2023 10:39:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [syzbot] WARNING: locking bug in inet_autobind
To:     syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        Alexander.Deucher@amd.com, Christian.Koenig@amd.com,
        David1.Zhou@amd.com, Evan.Quan@amd.com, Harry.Wentland@amd.com,
        Oak.Zeng@amd.com, Ray.Huang@amd.com, Yong.Zhao@amd.com,
        airlied@linux.ie, amd-gfx@lists.freedesktop.org, ast@kernel.org,
        boqun.feng@gmail.com, bpf@vger.kernel.org, daniel@ffwll.ch,
        daniel@iogearbox.net, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, dsahern@kernel.org,
        edumazet@google.com, gautammenghani201@gmail.com,
        jakub@cloudflare.com, kafai@fb.com, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        longman@redhat.com, mingo@redhat.com, netdev@vger.kernel.org,
        ozeng@amd.com, pabeni@redhat.com,
        penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org,
        rex.zhu@amd.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, will@kernel.org, yhs@fb.com,
        yoshfuji@linux-ipv6.org
References: <0000000000002ae67f05f0f191aa@google.com>
Content-Language: en-US
From:   Felix Kuehling <felix.kuehling@amd.com>
In-Reply-To: <0000000000002ae67f05f0f191aa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT1PR01CA0083.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::22) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|CO6PR12MB5428:EE_
X-MS-Office365-Filtering-Correlation-Id: f359f0d4-9294-431c-3208-08daeda0c070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ta77K+TNJn9bPBVSS5yrjUKR+gzZ05bNIHzXRXYB6rDSoOfOS39MdouluhBKn6rgzU2cvidF7bTcDSYzW2r3VLgg809uPcasMQkJu2S6bjushtE9qvezRK/ZlhriAyoqiddwz+JkOAinb9T17QaoPChRqWtCt/p9piPnB+0wK43GShQWRa4j+iV3QITRqOAL0gIcGZKjM7CO/zhi6HmDA1T27sOulUE/gucqHclcowmhme3qmsqGaczTHgv02zNdNVqvwFxkyyknxJvJmaHEd+32d8rCdd9bYQbXcMjyHgkLJK61zb76HpVVYlcmcI5Ln2phyVBEYX0Ff396IotfMdIFy3tAiiEHImd07PjE3q8vOIqTrXXLVkphfMRL/MX1Rk6UMH+SrB67gN6BDquK0k789UkudD9X5NvbcZGfxSQ8VnrZ4TMenV5JD1guXIYogNDDcoCkDUwqs/4m07oeMb/kCyDMlU1kvgDMZRA9QLsMpYZRflWoK+i+eag6NiKqPm3sFLCPNSjO6xOLsLr1/L/TxmyfkC5Idy20/pEFz58ho81m1+XwbIRS7Hb/GLBeZTt5qHxydA+O6xOj5hEXlJeSi0zMt/VDGUacP5Cc99YbkuzgrZJ8c+Da+uOmCaEflCu+yHtrI+AThv3IPBNgMV8BoGaBcTVUWPMitivYK4hJ11lVfZQVX13vz/hnqn+s42RoI7jlAMhIWJGW4Ssrqg0lN7UVfHSZSN/CCZe/X0o+XphkQAjDGmqEHXJhOGloVFkRVs9G2MfBcCfMdOjh5G8nFfUMUloqtFBVgZh4SM8SgjBu0P1qm0WeMAVB7uJMvcU/jCwz4OmINvBdWVMEhVk9uHagqV1LYzdi6usSggE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199015)(31686004)(66476007)(66946007)(66556008)(6506007)(41300700001)(921005)(8676002)(83380400001)(86362001)(2906002)(186003)(6666004)(316002)(26005)(4001150100001)(31696002)(44832011)(478600001)(966005)(6486002)(6512007)(38100700002)(8936002)(45080400002)(5660300002)(7416002)(2616005)(36756003)(22166006)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1VxcCs5ZkRyK01YRHI2Q0taTG5xRkJpYkg5WUQwb2xIWlpnWDdIRDduVS80?=
 =?utf-8?B?OVhvQm0zRHRzTkQzQjRVVUQyeGhoeW5BTGM3S2MrZk5hUVU3ZFhGdldwWlY4?=
 =?utf-8?B?Wm5mSWU3NVFQWTY5RWlyalhMY2gzRkRJam1LYzBidThkL2VXVmRsSG5hQ2s0?=
 =?utf-8?B?Zm9mUFUreUxLWWhSeVZPQjNaZ2paeEk1VHIrYVl3ckpYVWViVjllUXFGbHlG?=
 =?utf-8?B?ZmViTktpU3BzVWJ3VGhSQldwWnAyUDFqdW8xMW1SVUVLcmJrbW1TbElDcEd3?=
 =?utf-8?B?S2puUWhQNmdieHNIUXpWWitpL0M2UlI3bnIvdFJFWDE1REo2TU1RQnZxUDNI?=
 =?utf-8?B?VjBWZElkRjFSa0xBWVkwQ04xOSt2MEZYYkY1Q3N1RW5CZGJqQUt2eFFaZU1k?=
 =?utf-8?B?WGxOS0xwSU5tSTdjYVRwZ1MxODVOVXBqQzNBbkxDLzREbHZlNU5lSk45L3BD?=
 =?utf-8?B?Rnc3U054ZlNldk1tN2txbTRrTkJNZnNoN2JJRzBBQkRnZ0ZJbWJlZjIzOGt6?=
 =?utf-8?B?U1FUa091MHI0b1VVSDdicHkydVJGckFRa2R3NlA0OTZMUlNheVRaem5xQ0hh?=
 =?utf-8?B?VFVvWis4NjM2MFFlVjh6eXNFYW9xbjRRTlZMZ2Q5ZE5WRnNHL1RiV2gwU0VL?=
 =?utf-8?B?M3lQSkpraHVXSXp2VVBJL2JuQnFLS0lMd2phSlpOOUtwSi9ubk9TOHo3WGpq?=
 =?utf-8?B?ZEkyYk5LTmhCVW56LzJFT0RwZ1QwbXArdVpPNEF0cEJ6NE5kbzJ1U0ZZNmh3?=
 =?utf-8?B?amg1M1Y4aXhBY3lKMkhiVXAwUDhlOGVaWDdzb0FSclBKUXVNVTREY2FBL1FT?=
 =?utf-8?B?WGZsUGZLN2xHcUpBRCtjWUcrYnQ1Vm5nUnJWWFllR0t0dXc0anhiYUIzYnpj?=
 =?utf-8?B?SjVGMmdWeERva0p3NnNLQytLOEhWWXQzZHcrM1U5dkkzbUk4dmVPS201NHli?=
 =?utf-8?B?Z3FSRlZLb1I4cVVkWmhOVDRPTFduNjAzczR4V3lxNEZ2RnU4MFNIa2s1UVdH?=
 =?utf-8?B?a0pGNmg4VjJiekdTanoxRTRSRFJEMEk1MjJGQkdhcERHQnlXaTF6Slc1VlU0?=
 =?utf-8?B?UTFvNUdNdVVGUWcrNGF4VVMxNzJkamhnSmc1NUtJN3ByQmlkSnJDMm9WcWZl?=
 =?utf-8?B?NE56OFZ5TUd2YmFhcHZtS2F6ejQ2alI5TjFtWXVsN0pFZG9RNFZXamVnZXlM?=
 =?utf-8?B?N1VsQlJtZElCV2tGK2dld1VWYzQ4NE1iV3lMU2dPQjNyYWJkK1NuajdtU04x?=
 =?utf-8?B?cDhDNnVmMlhkb25iUFpWOTRQQXN6QVVrWFZBOHcrK1d0MVdHZ0NHT2g2dUhZ?=
 =?utf-8?B?Y01YRHVUeitIU3JSTCsrL1V6Mk9rMW9MWEp3U1JySXc2Ri81czIxUDRoenV0?=
 =?utf-8?B?K1YxdlV1UEZzVVVwMitOV015UnV0K3ZjcjRteHVrYjFEVXJ6YlFoYkgrL2FK?=
 =?utf-8?B?TmtneWN6cTMvS3NVUEQ5VUJsWnZnbXZLVUtyd2s4WTBaNWRBeTljMFE2OGZw?=
 =?utf-8?B?SE1SWWpyZ1pSVkN0VmIvdVJiY2UxbnptdFlwcC83RUdwcTRaRDZFdlhRVk1x?=
 =?utf-8?B?WjV1cnQvVUdOS2dWRUFoeWRlUzBPS2NJbGpFZWRkTU9NYUIvdmZ3ajR4eXJv?=
 =?utf-8?B?aXhlTktqQjRDcDNaZ3FpSU1oaTdBaUhIbVljOVFwbFdseXAxSVRYR1l0b0xH?=
 =?utf-8?B?RjNJUmlVRzNKTXRPWEpVeEl5a2RoTXV5WnFQZ1JnSzlhMU9BTjArMHRNSFhV?=
 =?utf-8?B?aWxTRll3Vm52MXQ3QS91bnZxQ3owbTNZUnZ0QllJbjMrTDJRTXlNZmI0SHhI?=
 =?utf-8?B?OWVlQjByYnR3ZVhzbXFCRExYaDMxL09yL05FWWMrZGFpM21yQU5ZQ3pEOCtY?=
 =?utf-8?B?NjZVUWlPM0RETjdYZ1JCbzRlZ1lRMmExRW5XQVllNmhmZDFpSFdDbjJMNmFB?=
 =?utf-8?B?REYzZ1NqSXNhL1JXV2VKaUVIK0J1ZjZ4WVlFUjJmQkVNM3I5cGJYTit3a3Qv?=
 =?utf-8?B?NGg0Nlc5OGJhZUNjcU04eVNqN1dROWVXbzRVK1pKOHJpNTdwK1k1ZHBQc1ht?=
 =?utf-8?B?ekFwTjNqQ2Y0R0ZMZVYrclZCYktreGFvOEJQQXlpeHU5MFNNOGdnd0duQjBC?=
 =?utf-8?Q?fTut3FJf+2/Tj+QYYGN4h86D0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f359f0d4-9294-431c-3208-08daeda0c070
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 15:39:51.0942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8uHx5/d3ETFg9US0LD0mn64uoTcgDYYsKL728eAcjNhjbCRxIS1PvOd0ARSzupac/oDS1dThtnH8DjFE37dHug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5428
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The regression point doesn't make sense. The kernel config doesn't 
enable CONFIG_DRM_AMDGPU, so there is no way that a change in AMDGPU 
could have caused this regression.

Regards,
   Felix


Am 2022-12-29 um 01:26 schrieb syzbot:
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    1b929c02afd3 Linux 6.2-rc1
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=145c6a68480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2651619a26b4d687
> dashboard link: https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13e13e32480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13790f08480000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d1849f1ca322/disk-1b929c02.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/924cb8aa4ada/vmlinux-1b929c02.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/8c7330dae0a0/bzImage-1b929c02.xz
>
> The issue was bisected to:
>
> commit c0d9271ecbd891cdeb0fad1edcdd99ee717a655f
> Author: Yong Zhao <Yong.Zhao@amd.com>
> Date:   Fri Feb 1 23:36:21 2019 +0000
>
>      drm/amdgpu: Delete user queue doorbell variables
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1433ece4a00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1633ece4a00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1233ece4a00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
> Fixes: c0d9271ecbd8 ("drm/amdgpu: Delete user queue doorbell variables")
>
> ------------[ cut here ]------------
> Looking for class "l2tp_sock" with key l2tp_socket_class, but found a different class "slock-AF_INET6" with the same key
> WARNING: CPU: 0 PID: 7280 at kernel/locking/lockdep.c:937 look_up_lock_class+0x97/0x110 kernel/locking/lockdep.c:937
> Modules linked in:
> CPU: 0 PID: 7280 Comm: syz-executor835 Not tainted 6.2.0-rc1-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:look_up_lock_class+0x97/0x110 kernel/locking/lockdep.c:937
> Code: 17 48 81 fa e0 e5 f6 8f 74 59 80 3d 5d bc 57 04 00 75 50 48 c7 c7 00 4d 4c 8a 48 89 04 24 c6 05 49 bc 57 04 01 e8 a9 42 b9 ff <0f> 0b 48 8b 04 24 eb 31 9c 5a 80 e6 02 74 95 e8 45 38 02 fa 85 c0
> RSP: 0018:ffffc9000b5378b8 EFLAGS: 00010082
> RAX: 0000000000000000 RBX: ffffffff91c06a00 RCX: 0000000000000000
> RDX: ffff8880292d0000 RSI: ffffffff8166721c RDI: fffff520016a6f09
> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000080000201 R11: 20676e696b6f6f4c R12: 0000000000000000
> R13: ffff88802a5820b0 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007f1fd7a97700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000100 CR3: 0000000078ab4000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   register_lock_class+0xbe/0x1120 kernel/locking/lockdep.c:1289
>   __lock_acquire+0x109/0x56d0 kernel/locking/lockdep.c:4934
>   lock_acquire kernel/locking/lockdep.c:5668 [inline]
>   lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
>   _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
>   spin_lock_bh include/linux/spinlock.h:355 [inline]
>   lock_sock_nested+0x5f/0xf0 net/core/sock.c:3473
>   lock_sock include/net/sock.h:1725 [inline]
>   inet_autobind+0x1a/0x190 net/ipv4/af_inet.c:177
>   inet_send_prepare net/ipv4/af_inet.c:813 [inline]
>   inet_send_prepare+0x325/0x4e0 net/ipv4/af_inet.c:807
>   inet6_sendmsg+0x43/0xe0 net/ipv6/af_inet6.c:655
>   sock_sendmsg_nosec net/socket.c:714 [inline]
>   sock_sendmsg+0xd3/0x120 net/socket.c:734
>   __sys_sendto+0x23a/0x340 net/socket.c:2117
>   __do_sys_sendto net/socket.c:2129 [inline]
>   __se_sys_sendto net/socket.c:2125 [inline]
>   __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2125
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f1fd78538b9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1fd7a971f8 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f1fd78f0038 RCX: 00007f1fd78538b9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 00007f1fd78f0030 R08: 0000000020000100 R09: 000000000000001c
> R10: 0000000004008000 R11: 0000000000000212 R12: 00007f1fd78f003c
> R13: 00007f1fd79ffc8f R14: 00007f1fd7a97300 R15: 0000000000022000
>   </TASK>
>
