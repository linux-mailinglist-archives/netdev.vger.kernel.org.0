Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC6B3E3AF2
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 17:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhHHPBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 11:01:20 -0400
Received: from mail-bn8nam08on2059.outbound.protection.outlook.com ([40.107.100.59]:50273
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231414AbhHHPBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 11:01:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6fz8FOeCup8MrhjDe2RWXDQxcV1Z8dpE2rY7MB0LAJMSawW9TNAUTCUy/nCl9LuKJDOzse0z7a2OER5xMTQCZPm98rIXCOlq4L/touluc9h4zh0RPojG0tIXDVxEaSFpi7Lji2hg2JloSqXVOb3uIYE09i7VmcPsU3kHHOrvCussdJakIs2KQk+8AOqz/SuUqMJY3NKnMsXNcfn4nEkaP0R5fPtuzTBek0y/BZl+ATjw6wbLtArvDF/M4oG3/cob63vb3OSMYUi+XSzuGPKlWol6zsvQjgn4b5WdxJzL3TY+pJN726qMEF0+8557cSwC+6HxeaGCbNMfQiksQIlmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUitznyxyV0TNd/f8YHPgGJ2/nClv1XytGDPzSzUgUQ=;
 b=G3EFE62KyaH2/7JUAb5/kp2emTQ6sUXlCujM20jLos8A5PDd2htfjL1BYgwvkIysq4JIM7C8kWWwn4DYGAV4XQXl89DFEFnUmjYsdZI/fNSUsOIxdhJaOC/l3Iix+/WuDjCWtX/cg0zBdXMii3bluSVymbI6p6JJRBWGSWu+iIMw8QMsLxVjSY2I3uVUDv1Dh01p03JTbGA8eMtqSyyWipxPHFiBHwEzcQdduy9rnSgX76NKVAjL/ZbEA4glh8mrSY5ItRObD2SUw04Us3ghnFwUdTWlYBy7HnIxEsODA+JgtzlbGpKlG1rOzIRNmRkPMY4uTLxK1u2XPhiKEHEHJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OUitznyxyV0TNd/f8YHPgGJ2/nClv1XytGDPzSzUgUQ=;
 b=SbVYb2Tv+jz7bVmLfYJlVDoQ66xnumtdCB2cLxF2DRB98YGOcWplDQQWMzrIIHVDe3h7HxWo7RKLrc0JhH3NmV2kgBlxykuNkjoP9H261w2QlSpC7/4XmpK/rLBAkGL9oSQ9MfMa/bFOi8TTUFEAOf6cetWMvCmCP43+P06DQ8PzlEpWX1Ou1SJMNgmrBjV2gRa7LopZ/vGnUbe4J0nhzEdD5jM9JyB6x6N9zELDt/tnAyCctnuNSM2jv3cZsU6cEzoZX5AFz8s9G6WWquMGuZzNdRSejnfK7FcYguxA3K/2Lu8cqPH5mWNd8qhLBQ5nzMn/ARmg2xuHWgVKEM8J2Q==
Authentication-Results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4473.namprd12.prod.outlook.com (2603:10b6:303:56::19)
 by MW2PR12MB2362.namprd12.prod.outlook.com (2603:10b6:907:e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Sun, 8 Aug
 2021 15:00:58 +0000
Received: from MW3PR12MB4473.namprd12.prod.outlook.com
 ([fe80::81fb:9d82:3986:4c86]) by MW3PR12MB4473.namprd12.prod.outlook.com
 ([fe80::81fb:9d82:3986:4c86%4]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 15:00:58 +0000
Subject: Re: [PATCH RESEND net-next] net_sched: refactor TC action init API
To:     Ido Schimmel <idosch@idosch.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, vladbu@nvidia.com
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20210729231214.22762-1-xiyou.wangcong@gmail.com>
 <YQ/wWkRmmKh5/bVA@shredder>
From:   Mark Bloch <mbloch@nvidia.com>
Message-ID: <bf87ea8b-5650-6b4d-1968-0eec83b7185d@nvidia.com>
Date:   Sun, 8 Aug 2021 18:00:51 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YQ/wWkRmmKh5/bVA@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0199.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::6) To MW3PR12MB4473.namprd12.prod.outlook.com
 (2603:10b6:303:56::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.26.75.90] (195.110.77.193) by AM0PR02CA0199.eurprd02.prod.outlook.com (2603:10a6:20b:28f::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 15:00:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a266cc1d-4e55-43e5-6c32-08d95a7d5416
X-MS-TrafficTypeDiagnostic: MW2PR12MB2362:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR12MB23627D368BAA60FB5BEF83AEAFF59@MW2PR12MB2362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iMjVlzxeRjyst+sWnlSzvdQ21Ha9by5k3BEh0/+YI164jDmVbAxs4VvJrJlXqMmOWK/H9k2RyeP4lTZ2SRg2xF3Pl/lemxBYS4H5vzwIoP/1xK85gglTXtk/mXM4mtL/nF6ghBgCJ0nCE38A0JlW+wWTaGI/yngeyk/JHkU5A3SsUeazsc9vRhRRFey037cfBH6KXCVoUKA59DrKVVlFRHF1/jpiXTMKYxeLXs0KV1O27nhPLQtduUmZ6cw3LXZk2hqp7QHTLeEVtGwrRbtW1vDDYhIZTAxSMeydYYA/Uak47VqvNUumhyD2x6uMA/CefjkmrN8+wuU01J+CcNI80fJRVDeVsWJEBMS7Athc6R2kbDpaRV/x2G9eTBE4LyW24xhi1zRuz+V7tZ12qus/BCJ9ZXlz5th8rbvAQ+1O4393plwPBDCnreaU062pRLi4dhGHh4H5XxFrhMTXdG28upm51hcKqslWH3BuSt4tAsxSZ+TzvRtWwrgsL5Frb0/N5XHi9gLSW56andSY16K/oTLKgrVpzZ2Lpbfo7fHi2rBPeRxBiWlSWbqGNL47QE5g7TB2GGlBakpOJo+C84hB+PlC1h2kqf51sJrHJ0/5StPmJbb/LtTZrI6+/Rlikd6tZ8Bt5tps6FJ+d8bXk4WaeQEe0KnF8lPXUmyj9+0RCDtM8gm7IdcJUzqJNDCBg5IhovQOzhTbyGq63RKJx9hbxe+cn1f/+6tBlfIBBzr5KPQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(2616005)(66556008)(66476007)(66946007)(83380400001)(31686004)(4326008)(8676002)(6666004)(8936002)(36756003)(16576012)(53546011)(316002)(54906003)(6486002)(110136005)(26005)(55236004)(508600001)(186003)(2906002)(6636002)(38100700002)(31696002)(5660300002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHhrSmxTZEQ4Yy85UUZ4ZFVVbHVLdkRJeVQveWZwMHYyNFIxTDJNWk1TcHZX?=
 =?utf-8?B?Qyt6UndrbFFRRTYydk9ldmp6ak16Q2lza25HR3BrT2hQZUxmZG4rdW13Q2Ra?=
 =?utf-8?B?L1NkZlN0TDI3dk9xVTdSd0wydWdnMDA0OU9lMGRVU09PUXBFR2Zxa3FZMHpJ?=
 =?utf-8?B?a3VEd2V0MVVDSEZUZjA5VHQ0c0dIQmw1Y1BkNFZtYnp6T1ZWTGJvbkhOMkZT?=
 =?utf-8?B?VmlBcUlybndvcElrT3JpYnhrVFlOWG43VTRtZEt3bkNXL3NXYmRYNnVsL3dE?=
 =?utf-8?B?RkdrUTR5eDYwRjJPMytiN1JHZmtqeFNscy9Od2p6RkM2MmxnWlg4dzd4NzRN?=
 =?utf-8?B?Q2xNSnZZYmFJNEVEcmJac2oyQTNWY0ZINTc2WWp0OWhNQ3dndlU0Tld1YkpD?=
 =?utf-8?B?eG5mWkptazg1YW1ZbTVIT0RjOHdETlBiZEl1SnpjWWJyWW5SQmUxU24wS3pN?=
 =?utf-8?B?OGZwdFQ1d0VVSHRIVG1oR0JJT3ZIR3NyQy9Hbmp4SVN1VUtPTmttRk0yRERw?=
 =?utf-8?B?SXJ4WE1QdDUrTStMMURtTmN3YUQyeFBVZy9qQjlWWmY4VWpYUlJadTRxUTFF?=
 =?utf-8?B?akJ0cmUrdHZmMitqRWZjaFp4aTByUU5WZkJkMThRN1ZLdXV4SkpPOElLTUgv?=
 =?utf-8?B?cmQxN3g3d0JoS0hPU2RtL3FuTC9BKzNuT0RjVi9rcUpBajUyNFBoQzlkTkFn?=
 =?utf-8?B?dldMUEhtR3N6SENXQUJhWDJIUjJCc2ZOUXFYUW9nY1l0amluSnROSXRUUGRw?=
 =?utf-8?B?dGw5VDAvdG5OTWtGWDA5MlM1YTNDdHpzU3VhVitXWE9hd0xiYVQ5T3R3bDNO?=
 =?utf-8?B?dVU4NFFEdkcxakMzZWNXcUNHUjVIWCtJa0pnQ3MwKzZCdHgrQjVuYTg5ZW52?=
 =?utf-8?B?U0hBWFo2RDZHSkJJTUVpSFUzVjVMMEwyaXlNWWpGMVFKU2dIZVhCblJPS0FV?=
 =?utf-8?B?Zk1NLzJHNzQ0V09DamwyNVFXaWpLbGVUNTQwSVNIZ2swc3BHTWlWL0RpOEhU?=
 =?utf-8?B?V0lhREkvTERrdnZ2ZmQ1NEd6cjcwUDh0QWRqOUZ5R0VjNnpIOTNSTDdqaG9L?=
 =?utf-8?B?dDJiVVpENXlDYmRUbHFURVU0SkFCd09UWUlGMzl3K1YyOUZEczg4OW1admNT?=
 =?utf-8?B?NnlLczdxU0EvejlCSnNubW44RXlDanBDbFptSVZaM1huNnp6V0lYTnNEOUM1?=
 =?utf-8?B?NThSNlJya1ZLbWNEMk9OU1AxWGduSStvSGx0N2RhbXQ3Z2dMU2hwMEdsSVhY?=
 =?utf-8?B?UFROM3V4TStvb0oyRFNGSUtRT3hMNmVsaFdVUTFKUUlaYkpDUnFvbEl4MzY5?=
 =?utf-8?B?Q2xqMkpYWW1FYytIVDdPb3ZUZTdSWkNEbEErYmNFN2poZVJDUkZRTXBxVzlI?=
 =?utf-8?B?RWtkSGVSTmEydTJmOVRiZ0VzYkd2OCt1cVEzTzlQVjcyUUJHUGFVMFNRUll2?=
 =?utf-8?B?cUVXaWhTU0MxVzdOYXNtRXJqMWxEek9XK004eUFLTVI0UlE0SW9rSjl4TmtR?=
 =?utf-8?B?THNZY0xkN3A0am5LVWxma0MyT1ZIVFoxUGlIZzBtTWprMGExSW5lRmhOMGdJ?=
 =?utf-8?B?NStSRlRxaWdiN1VNQzNuOGFXa2daVHlPUDRQSVdONmFoNGdVRVdLMm5ENVMy?=
 =?utf-8?B?bTBzUDdGblFKQyt5L2ZYUDFhZWpFdTlQOW1tMjVQNStrd0IwcTI3elFDb1dW?=
 =?utf-8?B?STdnenFZckJteUUwVkR2VS9IUi9yYmhDN1pQK1Jxb09LWHdEK2Z5Mk55aThU?=
 =?utf-8?Q?5LmkKh4a2nk3bpIpKgf7iBRkE2VlwGefOFlw76G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a266cc1d-4e55-43e5-6c32-08d95a7d5416
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 15:00:57.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8+0e3pZGsqO+q0zxOZXdqLzd47Z5RalbYw4RNo4JTHPWUD6zpFMpj9U7k4d8G3aCWoik5HUgiWnm3Zik4CcYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/2021 17:55, Ido Schimmel wrote:
> On Thu, Jul 29, 2021 at 04:12:14PM -0700, Cong Wang wrote:
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 7be5b9d2aead..69185e311422 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -1949,6 +1949,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>>  	int err;
>>  	int tp_created;
>>  	bool rtnl_held = false;
>> +	u32 flags = 0;
>>  
>>  	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
>>  		return -EPERM;
>> @@ -2112,9 +2113,12 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>>  		goto errout;
>>  	}
>>  
>> +	if (!(n->nlmsg_flags & NLM_F_CREATE))
>> +		flags |= TCA_ACT_FLAGS_REPLACE;
>> +	if (!rtnl_held)
>> +		flags |= TCA_ACT_FLAGS_NO_RTNL;
> 
> Cong, Vlad,
> 
> I'm getting deadlocks [1] after rebasing on net-next and I believe this
> is the problematic part.
> 
> It is possible that during the first iteration RTNL mutex is not taken
> and 'TCA_ACT_FLAGS_NO_RTNL' is set. However, in the second iteration
> (after jumping to the 'replay' label) 'rtnl_held' is true, the mutex is
> taken, but the flag is not cleared.
> 
> Will submit the following patch after I finish testing it unless you
> have a better idea.
> 
> Thanks
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 69185e311422..af9ac2f4a84b 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -2117,6 +2117,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>                 flags |= TCA_ACT_FLAGS_REPLACE;
>         if (!rtnl_held)
>                 flags |= TCA_ACT_FLAGS_NO_RTNL;
> +       else
> +               flags &= ~TCA_ACT_FLAGS_NO_RTNL;
>         err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
>                               flags, extack);
>         if (err == 0) {
> 
> [1]
> ============================================
> WARNING: possible recursive locking detected
> 5.14.0-rc3-custom-49011-g3d2bbb4f104d #447 Not tainted
> --------------------------------------------
> tc/37605 is trying to acquire lock:
> ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_setup_cb_add+0x14b/0x4d0
> 
> but task is already holding lock:
> ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_new_tfilter+0xb12/0x22e0
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>        CPU0
>        ----
>   lock(rtnl_mutex);
>   lock(rtnl_mutex);
> 
>  *** DEADLOCK ***
>  May be due to missing lock nesting notation
> 1 lock held by tc/37605:
>  #0: ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_new_tfilter+0xb12/0x22e0
> 
> stack backtrace:
> CPU: 0 PID: 37605 Comm: tc Not tainted 5.14.0-rc3-custom-49011-g3d2bbb4f104d #447
> Hardware name: Mellanox Technologies Ltd. MSN2010/SA002610, BIOS 5.6.5 08/24/2017
> Call Trace:
>  dump_stack_lvl+0x8b/0xb3
>  __lock_acquire.cold+0x175/0x3cb
>  lock_acquire+0x1a4/0x4f0
>  __mutex_lock+0x136/0x10d0
>  fl_hw_replace_filter+0x458/0x630 [cls_flower]
>  fl_change+0x25f2/0x4a64 [cls_flower]
>  tc_new_tfilter+0xa65/0x22e0
>  rtnetlink_rcv_msg+0x86c/0xc60
>  netlink_rcv_skb+0x14d/0x430
>  netlink_unicast+0x539/0x7e0
>  netlink_sendmsg+0x84d/0xd80
>  ____sys_sendmsg+0x7ff/0x970
>  ___sys_sendmsg+0xf8/0x170
>  __sys_sendmsg+0xea/0x1b0
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f7b93b6c0a7
> Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48>
> RSP: 002b:00007ffe365b3818 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7b93b6c0a7
> RDX: 0000000000000000 RSI: 00007ffe365b3880 RDI: 0000000000000003
> RBP: 00000000610a75f6 R08: 0000000000000001 R09: 0000000000000000
> R10: fffffffffffff3a9 R11: 0000000000000246 R12: 0000000000000001
> R13: 0000000000000000 R14: 00007ffe365b7b58 R15: 00000000004822c0
> 


Hi Ido,

We hit the same issue, I have the bellow patch and it solved the issue for us:

From e4f9b7f0b067bf17fd0f17d6e2b912d4f348718b Mon Sep 17 00:00:00 2001
From: Mark Bloch <mbloch@nvidia.com>
Date: Sun, 8 Aug 2021 13:23:08 +0000
Subject: [PATCH] net/sched: cls_api, reset flags on replay

tc_new_tfilter() can replay a request if it got EAGAIN. The cited commit
didn't account for this when it converted TC action ->init() API
to use flags instead of parameters. This can lead to passing stale flags
down the call chain which results in trying to lock rtnl when it's
already locked, deadlocking the entire system.

Fix by making sure to reset flags on each replay.

Change-Id: I8351af789386cb89e585d61d8c47e4b92fb80972
Fixes: 695176bfe5de ("net_sched: refactor TC action init API")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
 net/sched/cls_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 69185e311422..4a7043a4e5d6 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1949,7 +1949,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
        int err;
        int tp_created;
        bool rtnl_held = false;
-       u32 flags = 0;
+       u32 flags;

        if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
                return -EPERM;
@@ -1970,6 +1970,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
        tp = NULL;
        cl = 0;
        block = NULL;
+       flags = 0;

        if (prio == 0) {
                /* If no priority is provided by the user,
--
2.14.1
