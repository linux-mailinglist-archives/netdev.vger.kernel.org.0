Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 686FE65C3C2
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbjACQUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjACQUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:20:14 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5611A0;
        Tue,  3 Jan 2023 08:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0VxiybEPKhg+Q+GlqLwHGFxsbecYt2xxY3hE9fg7kzpgLaaJ+TvBFbyoqZk2MdmhTklHOS6sndRIPHOqEsxbpOeokl5KeDa0Fj9kzNoIRQFwhFHG/YeDkTax61jVZnWxpJNyHAAEQOgVO1n4LJKdzDF8o301wRKZpPpun+peA2YQ9vyhscNPZ5gNnvc15+QVVc3mFZsBdfbucn5NTZRToeHuNzGAcYJKzQnfak2SSj9UBr5ayOwvvb1HysgXGPh/DighbKFE6B8o7G57eSOVhKTvXUrECvPj5d6ISIgLgLBrGksbXbajnyQ+wozW4+VPg8sCEfYZ5NwzPYv7wZAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rnYhDXPwmDaZg14MhVpGy/iNv6jZQpJtRlI+6hZXhw=;
 b=baemeL7euCSXsLPYAUCRXzcAneoN1X7B8JjfBmtRSQxwy/7sbwfUW/FIHK+yaf4qnuHhmsWQ/4BV0SzaJeJ7enGaQd2xW+C93EC64L3E+8aImUtBMrAI56KlHZ2hvN9RL9L2Y3QtnqN0ZQRs5pzEqM7mDaiBWEpKgYC4AGMrPcMrrzDN2mwBj0um18VGIYCF25OGRWIM7Wrez+om/f2MYxWYNGnjKg8oLXAA3bdFI3JiUHgU8V7hDl4PFqV46GOwL/nUJXt75rH7nCyKHzPteuRT86icHBOjHuv3PPj4K2H2e620ddkrWykDH11musTj5rt8odIXqFeXHRFK3Y5uSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rnYhDXPwmDaZg14MhVpGy/iNv6jZQpJtRlI+6hZXhw=;
 b=SG3Fds/eRlct2yQ0mIGVbZQQtUpXlDoaPdvxmPmopqf+m7Nn+a7MiwnJLKq9a3lM0VlmDNIEL0uwwXS9y7ChEHiLWYd9ZSBr7KdzIQRQAFKw8lx2OmjXFhhYynYbUB3pZo6ETIaFlaYD5ZEALNDF9p+x1WNeWzcfoDX0MrX0F/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 16:20:04 +0000
Received: from BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::c3f5:aede:fa4d:5411]) by BN9PR12MB5115.namprd12.prod.outlook.com
 ([fe80::c3f5:aede:fa4d:5411%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 16:20:04 +0000
Message-ID: <a47b840f-b2b8-95d7-ddc0-c9d5dde3c28c@amd.com>
Date:   Tue, 3 Jan 2023 11:20:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [syzbot] WARNING: locking bug in inet_autobind
Content-Language: en-US
To:     Waiman Long <longman@redhat.com>,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
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
        mingo@redhat.com, netdev@vger.kernel.org, ozeng@amd.com,
        pabeni@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, rex.zhu@amd.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, will@kernel.org, yhs@fb.com,
        yoshfuji@linux-ipv6.org
References: <0000000000002ae67f05f0f191aa@google.com>
 <ea9c2977-f05f-3acd-ee3e-2443229b7b55@amd.com>
 <3e531d65-72a7-a82a-3d18-004aeab9144b@redhat.com>
From:   Felix Kuehling <felix.kuehling@amd.com>
In-Reply-To: <3e531d65-72a7-a82a-3d18-004aeab9144b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT1PR01CA0118.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::27) To BN9PR12MB5115.namprd12.prod.outlook.com
 (2603:10b6:408:118::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5115:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: 31ff2f31-e497-4d18-d166-08daeda65f46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dq2Tp+gHBUfFNxfGe0itwc/f10k22qm8n499VPSOVnhBErBu9XTTfb4bm/hdjEoGMS2h+nSIt7ZCUOAkQftpIXuABu4uZ7aWQ8NqyPeZBrxePFK2BB9V5EPzgzlfPEaOArBUjwLTTEoMIEf4vhi6xfkePzRJjUoUchANIHM2p5v4ZBeebeNyGMg4wVAcbC+ievUxfaf45rL5KGtUB0jJ5KPXCW5oPBT4pOefWeVQPHOHdTgNNj3pcoSkG5u9KEIpmv8Fay5qzy8sIT3UU4np2LZ3pDEVJGY4at6vPnshNyTv/hh1gSlK5hozjCgBKTZBgiqFB1i/IUB7lE5OrqmU8Hh7UkkNB6K+ps/dYfX6kebZIn0VB13HiQ9QdtTaHxMzqVXsvrayZNGV8uNGfmFetfmpXB96KRGUZ04lZYzoB+wnGsNR97UUWsd9jK5vPXUE2IxvIF5Eum/UOtZ6HrcL/IU2pIULTRpXqer9ZheeOB/zNy3a23cCkyYdilCJjyUiDGOLazbM/7UszYzHMjZLPWy1QzZXqBp6vJ9140+Z2LwhpqyuAUdOtENHV5i6O8NXDcr83o+Gca125/EnHs2zUIxQGBHe5nKOknoTHO3vltoeRqqk7+PZp0eWGaLlKvaWyA7OlcOvYMJE8VplDo3luEmEXi8jVgN23Hb4qXh3LYR9WCxV23TnVmohKSAb1wIJloigpVkrAiQsEKlDqGBfob2x0L5gYH4ADyMGPtrJaGCCC+y9w9Vbgdeqk184urga5Kt5LuchlGp/AYg0qD8JEctlGSxvMqdMbgvtp70eRgKGWAxInIxFsoD1fzHPPWaN5jti8oNKOQ8slSDf/lc4udSTkl3Y3SsWcRbMxBozGNQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5115.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(41300700001)(8936002)(66946007)(8676002)(5660300002)(7416002)(110136005)(31686004)(316002)(4001150100001)(2906002)(6486002)(53546011)(45080400002)(6506007)(966005)(6666004)(66476007)(478600001)(66556008)(44832011)(31696002)(86362001)(186003)(26005)(6512007)(2616005)(83380400001)(38100700002)(36756003)(921005)(22166006)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzdhL3VLdnFuK2pCakQ1SG95MW1jLzh5RndRNHk3K2hWSUs2aHhWdUFESnUy?=
 =?utf-8?B?Y2dOc0IwOXBsN2ZrTXBaVm1EekdSaElpNDR5V3VIK3RJaURUOVJ5aWZ1ZEZH?=
 =?utf-8?B?OERvQzlmeStVRlN5NnBxQm5jMUN1ZmpSZElNbmp5WFltZ0d3R1VpNXFzRDN0?=
 =?utf-8?B?V2k0OEg5NTBMQ3IvTm5hRVlGdXJXNDM3S2FkYmVqbU12R2tHK293dWZuTmJp?=
 =?utf-8?B?OW9tOUhFejlHRW1KcUlCTC9saVlnUmlzb1FKMHdCWUZMUmFueE9heXAxRjdG?=
 =?utf-8?B?bVhldFNmTVdKQ01KUWpocXpMSVpFVmdqellhUlE4UXc3dHlqUHNPc3QzTlNL?=
 =?utf-8?B?N1ZKTmVUbXJHQ0lUSzB0YW1LWGdFSHJoNUtOZGt5eTFTTnFPNnRsZGkvUEJV?=
 =?utf-8?B?T0I1YlNIUjlMSzN6MkRNQWt5MHIrem1XYjhNak52b3Y0RVROWC9WM3hFOGw4?=
 =?utf-8?B?M3pNb3pUTnMydWRhaU40eGZzd0NpMzY0QWRUQVh1S3g5M2x4ZDMva0pmKzUv?=
 =?utf-8?B?VjBNK1NBMU1FdDFlaWRLU2k5eUxOU25kczN1Yi9pSXJneTcrZmorY0d3Nmp3?=
 =?utf-8?B?UW93Z2daRFAxWXNUVjRXYWhzcnZaamExZVpQS3hmTjdmS0pOQmRlNGxuZ013?=
 =?utf-8?B?elNMMkRXbWp0WXMvZnhidGl6ZGlkekk5b2lNKzR3WjJGSndNYjVKSWRUM29E?=
 =?utf-8?B?aXdpenYxNXIzMHVLdzBTOVdCdkNIVUw3ck9DZEhpSGNKUlBZdFJkaGxFRnNl?=
 =?utf-8?B?Y2c4ZWp4czNod1lZOWtOaW15b3NPOGoybFdmU2tIQUY0V3VwTUd2c1lJb1Rj?=
 =?utf-8?B?TldJUmpEMi9TQ0xUWFJWWkRLdHdwdnhrTFBCb2VXV2tLdTVNWk04dXBjaEI2?=
 =?utf-8?B?VGYyOWFsRitHTzlxNGw2U1lEelpOQkFRWW9FSVFKeHVHVGI1QkZoMktoeGFa?=
 =?utf-8?B?OFhIbFBtOE5RRHVURVV0bkhUMzdSSy9GYk9pd05HYlVxenhmZHNkSCtzN1dE?=
 =?utf-8?B?VW83SGtCNlFBWktGU0llNVRveWoydjBtVTlub3laT241bDFObHJTekdCY21D?=
 =?utf-8?B?M3dtbmZGWnVZclJNdENCaEpwd1JtNE9Zc1U2cVY5RGlQVWQ2N1cyaWszaVY0?=
 =?utf-8?B?a2dvWVA3bUJJYlpOUmo3SzRrUkdUenRkNUdKajlLQWRJamp4MnBBSTI4UHFR?=
 =?utf-8?B?Y0Z0bHl5RU9TenNyMzVyYXJNTlZpT0MwWWFJbkxlc3B5ZmIzVGQ1YUF4NGZh?=
 =?utf-8?B?dC9hZjNmV1Nja1YzWVltRWNYYWUrK01oeGNxU3R4THNNakVUU3JrRjRvZCtU?=
 =?utf-8?B?WGhyR2tnTW5WcUU3Qm1GNWUvUEptWjNaWGNkaTRqV3ppUzBQSS9nazFER2Ft?=
 =?utf-8?B?N1ZZcnJvUzlIVzBsaEJrUWtiOUxEQnZVSGtDMUVtYWVXb3RKNGI1YmNiRlZt?=
 =?utf-8?B?RTlJNm84YnpXUVBZMTlxV3drd0tkcVBrVkJFME81d3hMai83UVJGRzVWTXov?=
 =?utf-8?B?RWZsVTUyMTFzaEdNQ2hEb1lLRjRKbHR1UGowOVpKSURVa0JFdXArSXNFZTVQ?=
 =?utf-8?B?d2ViUEN0elZUUFVVOExUZHNNQ0VDZkJpNDArQTFWeTFkcXVpV1JkcUM5SDc1?=
 =?utf-8?B?UW1VSEQyYVVnYnVLWFAxNlVsR3lLOUdVaUM0U3ZNWXNPRGkzNGNlWVE3Y2ls?=
 =?utf-8?B?R05TYU5TYUsxL055bG85c0c3NnFxaFoyNC9jd0hIWmU4UTVoZlhScEk5TlJI?=
 =?utf-8?B?MnhtQzR4bTZGb0o0MVJBY25hdWpDYVl6dkkvN1ZWNXBtUkZZT2x3dS82MVJx?=
 =?utf-8?B?TnI3Z3ZuT0NvSlBIT0NlUlNnU0tzSGVEcklaaklTRWVFdjJYTVh0SStJcnF1?=
 =?utf-8?B?bUJVRVpSTllEMkZ5T1BlazBYVDgyMzA4UHcrQUc5dkcrYkhYOVFaYjB3TldC?=
 =?utf-8?B?c205YXRsSmZoYmpXenQ4MGdoaFFBU1dRa3NxQmJDVmZMcEhicjVDeWswNTRU?=
 =?utf-8?B?Q21UcjUvU1BJS0oyYy9pNEttV25CMGpvL1lOVU5VazArek4rUUN2MVZiTDlB?=
 =?utf-8?B?TG5zbjh4L0NHUnV1V0d5bGRmQmdoQS9Rdm16b3RKVDZ1bThQZDFkbVVMbkt2?=
 =?utf-8?Q?I+2+gyqF7C8wGCGJb+V0rAMPd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ff2f31-e497-4d18-d166-08daeda65f46
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5115.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 16:20:04.7365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rd7Jgb0GF73DkK0L/7u33+dPWdFmagCq7jRIPRqE4nptV1K7ZGDUsOquvsS+/RJue05+5xzooYJS1QUxbzb3EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 2023-01-03 um 11:05 schrieb Waiman Long:
> On 1/3/23 10:39, Felix Kuehling wrote:
>> The regression point doesn't make sense. The kernel config doesn't 
>> enable CONFIG_DRM_AMDGPU, so there is no way that a change in AMDGPU 
>> could have caused this regression.
>>
> I agree. It is likely a pre-existing problem or caused by another 
> commit that got triggered because of the change in cacheline alignment 
> caused by commit c0d9271ecbd ("drm/amdgpu: Delete user queue doorbell 
> variable").
I don't think the change can affect cache line alignment. The entire 
amdgpu driver doesn't even get compiled in the kernel config that was 
used, and the change doesn't touch any files outside 
drivers/gpu/drm/amd/amdgpu:

# CONFIG_DRM_AMDGPU is not set

My guess would be that it's an intermittent bug that is confusing bisect.

Regards,
   Felix


>
> Cheers,
> Longman
>
>
>> Regards,
>>   Felix
>>
>>
>> Am 2022-12-29 um 01:26 schrieb syzbot:
>>> syzbot has found a reproducer for the following issue on:
>>>
>>> HEAD commit:    1b929c02afd3 Linux 6.2-rc1
>>> git tree:       upstream
>>> console output: 
>>> https://syzkaller.appspot.com/x/log.txt?x=145c6a68480000
>>> kernel config: 
>>> https://syzkaller.appspot.com/x/.config?x=2651619a26b4d687
>>> dashboard link: 
>>> https://syzkaller.appspot.com/bug?extid=94cc2a66fc228b23f360
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU 
>>> Binutils for Debian) 2.35.2
>>> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=13e13e32480000
>>> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=13790f08480000
>>>
>>> Downloadable assets:
>>> disk image: 
>>> https://storage.googleapis.com/syzbot-assets/d1849f1ca322/disk-1b929c02.raw.xz
>>> vmlinux: 
>>> https://storage.googleapis.com/syzbot-assets/924cb8aa4ada/vmlinux-1b929c02.xz
>>> kernel image: 
>>> https://storage.googleapis.com/syzbot-assets/8c7330dae0a0/bzImage-1b929c02.xz
>>>
>>> The issue was bisected to:
>>>
>>> commit c0d9271ecbd891cdeb0fad1edcdd99ee717a655f
>>> Author: Yong Zhao <Yong.Zhao@amd.com>
>>> Date:   Fri Feb 1 23:36:21 2019 +0000
>>>
>>>      drm/amdgpu: Delete user queue doorbell variables
>>>
>>> bisection log: 
>>> https://syzkaller.appspot.com/x/bisect.txt?x=1433ece4a00000
>>> final oops: https://syzkaller.appspot.com/x/report.txt?x=1633ece4a00000
>>> console output: 
>>> https://syzkaller.appspot.com/x/log.txt?x=1233ece4a00000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the 
>>> commit:
>>> Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
>>> Fixes: c0d9271ecbd8 ("drm/amdgpu: Delete user queue doorbell 
>>> variables")
>>>
>>> ------------[ cut here ]------------
>>> Looking for class "l2tp_sock" with key l2tp_socket_class, but found 
>>> a different class "slock-AF_INET6" with the same key
>>> WARNING: CPU: 0 PID: 7280 at kernel/locking/lockdep.c:937 
>>> look_up_lock_class+0x97/0x110 kernel/locking/lockdep.c:937
>>> Modules linked in:
>>> CPU: 0 PID: 7280 Comm: syz-executor835 Not tainted 
>>> 6.2.0-rc1-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, 
>>> BIOS Google 10/26/2022
>>> RIP: 0010:look_up_lock_class+0x97/0x110 kernel/locking/lockdep.c:937
>>> Code: 17 48 81 fa e0 e5 f6 8f 74 59 80 3d 5d bc 57 04 00 75 50 48 c7 
>>> c7 00 4d 4c 8a 48 89 04 24 c6 05 49 bc 57 04 01 e8 a9 42 b9 ff <0f> 
>>> 0b 48 8b 04 24 eb 31 9c 5a 80 e6 02 74 95 e8 45 38 02 fa 85 c0
>>> RSP: 0018:ffffc9000b5378b8 EFLAGS: 00010082
>>> RAX: 0000000000000000 RBX: ffffffff91c06a00 RCX: 0000000000000000
>>> RDX: ffff8880292d0000 RSI: ffffffff8166721c RDI: fffff520016a6f09
>>> RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
>>> R10: 0000000080000201 R11: 20676e696b6f6f4c R12: 0000000000000000
>>> R13: ffff88802a5820b0 R14: 0000000000000000 R15: 0000000000000000
>>> FS:  00007f1fd7a97700(0000) GS:ffff8880b9800000(0000) 
>>> knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 0000000020000100 CR3: 0000000078ab4000 CR4: 00000000003506f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> Call Trace:
>>>   <TASK>
>>>   register_lock_class+0xbe/0x1120 kernel/locking/lockdep.c:1289
>>>   __lock_acquire+0x109/0x56d0 kernel/locking/lockdep.c:4934
>>>   lock_acquire kernel/locking/lockdep.c:5668 [inline]
>>>   lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
>>>   __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
>>>   _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
>>>   spin_lock_bh include/linux/spinlock.h:355 [inline]
>>>   lock_sock_nested+0x5f/0xf0 net/core/sock.c:3473
>>>   lock_sock include/net/sock.h:1725 [inline]
>>>   inet_autobind+0x1a/0x190 net/ipv4/af_inet.c:177
>>>   inet_send_prepare net/ipv4/af_inet.c:813 [inline]
>>>   inet_send_prepare+0x325/0x4e0 net/ipv4/af_inet.c:807
>>>   inet6_sendmsg+0x43/0xe0 net/ipv6/af_inet6.c:655
>>>   sock_sendmsg_nosec net/socket.c:714 [inline]
>>>   sock_sendmsg+0xd3/0x120 net/socket.c:734
>>>   __sys_sendto+0x23a/0x340 net/socket.c:2117
>>>   __do_sys_sendto net/socket.c:2129 [inline]
>>>   __se_sys_sendto net/socket.c:2125 [inline]
>>>   __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2125
>>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>>>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>> RIP: 0033:0x7f1fd78538b9
>>> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 15 00 00 90 48 89 f8 48 
>>> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 
>>> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>>> RSP: 002b:00007f1fd7a971f8 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
>>> RAX: ffffffffffffffda RBX: 00007f1fd78f0038 RCX: 00007f1fd78538b9
>>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
>>> RBP: 00007f1fd78f0030 R08: 0000000020000100 R09: 000000000000001c
>>> R10: 0000000004008000 R11: 0000000000000212 R12: 00007f1fd78f003c
>>> R13: 00007f1fd79ffc8f R14: 00007f1fd7a97300 R15: 0000000000022000
>>>   </TASK>
>>>
>>
>
