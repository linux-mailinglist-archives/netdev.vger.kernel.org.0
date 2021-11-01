Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BB8441978
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 11:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhKAKKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 06:10:10 -0400
Received: from mail-dm6nam11on2081.outbound.protection.outlook.com ([40.107.223.81]:16199
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231981AbhKAKJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 06:09:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMu4jztcyOj+y76QD+tlXKpwMIThwP54I3e4GUCLiroSLHbpIB4UfeoqoBQH/ymg1dU1NjzPc/hZ5L2h7w67Npo1AdwhIQ4rPWw1CZRhgBzdes11njYG4REALokpy0e86MuUQw0Xyu7KePO9jv56fqp/dN92c39kUl3kOuRunYdgPgOvAZy9tJ5KD68HazIxhci0Q46WlXtQV6itNOoiISr0oXmGKLLuQKBv6aUDDZ3GbvzGfgN8/45aphl2kG+NWi/qwSB6ZXaUtcy3yjG/xEIg16DEJciKEHZk8sdgb/gn647TnyyXnzxf2iaJZ90uufKUNmwmaJ9L6sDoKYGACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NSNrNJFBW2VNdEBFIfUzb+04+9E+k+xGmKdGGkhNPY=;
 b=QIUla/jiBqXcWOSIS2qm/jm5hjHBLzhQBmAah6aDtribpgHbmeY59IDT1znnvINZoOy23etHwwBBH8tC2BXuUcu4ymAhaniVwabL18es+3rSeLLW5YKF8e8bj5H2E1ltEEdjWflvcuWxxZRe2+b2YbzLqhSeY3QDbbk+V9Jc3mdfPuulKLAYZoWCAgM/v9EqOZzrzbWO+WhQbyi+9ugSoP1sM/Q9KKnjfDljicuuyk7sQ02IwaVhFKPf6Z99+moBm2Hy9tsCU5EyhwZLgDcAsDCiN55tbS8yBQ04/28WY5jprznfDcvAQgZN/zrikqhMriu7xvsIILDlcuig7VbjzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NSNrNJFBW2VNdEBFIfUzb+04+9E+k+xGmKdGGkhNPY=;
 b=t+NMjueA8XTJpM0oyBdPYleILBEja0xUOUtbUOr9rEspqSY9B4If1z7g9nK7iUHN12LxmYFL1sB2FuumwHwIPVG39QQh3czc0squk6QTc3b+CYao1T6FPlBbuJ3LhHR/3NyWjCUblR9omURblK7iTw7yP2AgnEzdoDJWVAFx3VGyk3XluLJru0GOLEKNpCj4lEz8N5rgQQoZAnQYpti4UazaFVwE21KUqwxp6OEXNwWrNgRZiHTRTZSPW9KIvrPOAU2xMg0/XpNjxLeN4gAyLwpogcXQuQHfMl1bsipNwrKg9xTHsZIMEisQQ/UCpeNpGjlZffr8VQ/+dvKQcVryVg==
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 10:07:13 +0000
Received: from BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440]) by BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440%9]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 10:07:13 +0000
Message-ID: <2d6daa85-97b9-140a-5e92-0d775ba246d0@nvidia.com>
Date:   Mon, 1 Nov 2021 12:07:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 3/8] flow_offload: allow user to offload
 tc action to net device
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-4-simon.horman@corigine.com>
 <cf6ebe6c-d852-e934-cbb3-03220d5eedf8@nvidia.com>
 <DM5PR1301MB2172C90CF04E14EA7FAD5528E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <DM5PR1301MB2172C90CF04E14EA7FAD5528E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P191CA0108.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::49) To BL1PR12MB5379.namprd12.prod.outlook.com
 (2603:10b6:208:317::15)
MIME-Version: 1.0
Received: from [172.27.13.48] (193.47.165.251) by AM6P191CA0108.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Mon, 1 Nov 2021 10:07:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b52e5bd-17b1-401d-ea88-08d99d1f6001
X-MS-TrafficTypeDiagnostic: BL1PR12MB5143:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5143ED9EAA76781040DA33FBA68A9@BL1PR12MB5143.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MP+HgzXaw+nRoxcd4c1LpNkSMEMfX3FWrMQmry+U8s04tlrPwhi5UxV2kF98Y/9uVrqv0BC29HfjlY3F2UVw/N1OZUIIIdzWaW8YOqSVc5+y5Pwoy02dCY9FZoJfflx0sd8w+xbZluCSUq1timVUnjrUu+Ti1rpWnJ0jJAHqG3vT378skow4Oeb5eNRpaqb4GIPf6u21FNMEMe0ZEltT2+A+vBETagp3xpxkbENtUaS7rgVXsyiXHJ5Tz/2c4IDW2BrBLIX1mfyrUYqG/7kcXn/FSy8GkqEvrjkNqYwnFh1+C19IAynAudxxAT/of3Cn6OldQ2NyCeLxK7H4vdpqf6sLCQKYhXEGCRBfFuxqa7wenQdkL53Yoay/HqF9FHez+zcxi/h9By1FH5BEJRGsq2iYh3Nup/9B7d7xtNYKIZ1+qFuqHizmZPAqOGqUV5/OpTW+XOwb/K1DRvunvohAabFEqJzuseJzeEyYzEqqdf7aWC24Ix1yFUFlZuyPuSVmCRaturGTIXgGkIdTevPsgXeJjg9HqsZ2oVEsE1wZkrIXiIy8G0yObmHDxcNprwKnDvnOGdJUSp+q89yX0lPiE2L82v7rH2N4RZAMIi4d3zgqdLXYjoFCllylApGjoP1Yoep1SWkcBQFrDfKfrCwJreJfqqxdn+mLda3jmFfyg8q4P9ERGI+VxZEEi0y01lopncNizd3hE69/kDE7M3zkr6smzIR0xEQa7HlwMz+Pqnk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(2616005)(4326008)(31686004)(66556008)(66476007)(66946007)(110136005)(30864003)(54906003)(316002)(2906002)(16576012)(36756003)(186003)(38100700002)(86362001)(26005)(8936002)(83380400001)(53546011)(956004)(6486002)(508600001)(31696002)(6666004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFMvMVRkRTFxS1FVQ2dYOHh5aU5hcnE5R1l6Q3V6ckxvSEI1RHBpSWNXM3Zw?=
 =?utf-8?B?d0NxYTV1Z0hIQnVzSDA4anNTdHpJLzN1L0Nsb3QrTGRQejhNQXlocS94T0J1?=
 =?utf-8?B?L0NZa0FaL1pkb3I0UnB1LzdzdFEyelNaNXdnOE1jVndhRUJ6SGZhUEJ1d0p0?=
 =?utf-8?B?OXFzYmhId0Q2b0FaNW5PUkJ6RkJsSnE1Y05XeVRCdXlxbHAxWmYxR05KVkpV?=
 =?utf-8?B?NFBjTXozK1lPL0dYZ0Z3Z3EwNmhRSjRKTVdKUHFBWVZDb25iQ0s2OTJLSys4?=
 =?utf-8?B?MUlHbGRPRDgyaldOZjJMRDZXN1Q4d2N4VE9mbFJRL0lPNWpkSFczQkIzRDF0?=
 =?utf-8?B?Skt6OTBxcDByRjBlWmJ6LzFLdStjWk0wdVJpRmJXOW8vejNwSDJqREU0R1gv?=
 =?utf-8?B?K056Yis3b2NYT3ZMOVVSMUNWYW9mWXRGb0xjK3FBRUJ5TVpFVFpxSFpNU01k?=
 =?utf-8?B?V05ncERobkhOcEVWSVVVcUgxL1diMXNab1JPRDM3RG5jelBwWWZVOC9qanpR?=
 =?utf-8?B?MVkwUHdEK1FiRmViMjZFYi9UQXNLd05DRnpsVTh1Snp1MXZ3cXlUTmVvUE9j?=
 =?utf-8?B?RTg0djRkcUFRSHlXYXVrOUkrUDV3djRERTVrZ3Nkbmk1eERibE9DcFBlSmdy?=
 =?utf-8?B?Q253VnFGV0RvODVoeFJjY2g2ak1tL1UzSHVjL2xOZy9IY3NxTXNYVmRpNGRq?=
 =?utf-8?B?TVBoVVFBclBqc3lkNFM2OW9PQ2szenFQb1BqKzdOSkRYZzBpVzNJQTZxb0pO?=
 =?utf-8?B?c1h4YU01aHdwSVRRUW5nL0tNQ0xkcithNXNpdkNXYWNKTUtESHlGMVVsMVZt?=
 =?utf-8?B?R082ZzA1NW1NSXBSUXYzN3IzdUFWV1FVZmVuS0RwSktmTHZDMi9NVGhyL0Vm?=
 =?utf-8?B?TThJYmJSdE9CUzJZOUJGTm1jS3BiY1pZYVhkY0dLVDVqVThrSFVvQmljUC9h?=
 =?utf-8?B?QXFGdDNTUGRiZkJZRXZBV2FyZWp4NldQaWNsTkdRaVRxanRIcVI0WWM0KzdR?=
 =?utf-8?B?bnRaWGY5dGd1OFFhTnJEbzAvUkZQUHVzc200bnhVRG52bnRpdEhFVml1Ty84?=
 =?utf-8?B?Rk16ekNEYVBwUVQ3SHY2cElJUTkyTjFOMHRWMTNMbGxIbHZPVWg1bURvVXVM?=
 =?utf-8?B?TkpLMk5EbnhkbmVNd1hJYU5XYWczdzNYelBsME5SRS9TR0xkK2Ryc0p2b1RF?=
 =?utf-8?B?cEUzMWVhWUt2Q0x5dzdNMElVaCtmNi9oNFQ4TW5mdmNEUno0aGJrVE4zeFJY?=
 =?utf-8?B?MzBaUDRMQ0JZNTBqTmlGZjV4NU8yTnJZNDBMYnlvN29rZzRyMGsrWGVwaE1W?=
 =?utf-8?B?MFMxVTZMQVNmczUreEUrc1JZc2JZcW9mQzRYbEVMTkdnK3JxdmpXTzBtVHd0?=
 =?utf-8?B?bVFiRlh3Njd1RXdScXQ2ckNiazNuTXl5cG05OE90d1kwR2Z3eE5GZ2g1YTVZ?=
 =?utf-8?B?ZFJBdysraXdnNmZHOVVrazBSUFV5UlFxRUx5YXE1MEJFMndxQ20vR01Vbm14?=
 =?utf-8?B?Zm8vSS83ejJUbWpQM1RkdEVkMWZ2Z3A5NXJwYTJqZ21HVTFnRmxGS04vMFg3?=
 =?utf-8?B?bnlyNU5WdGc2MmJBVFl4MDlYK0RKR1dEejRxQXdvTnV0UGhWc1lvM1kxQWVw?=
 =?utf-8?B?b1JDdkFqS1EzMHpONWtkTVRyTEpMZTEzSmtCZFU0MWJYUVk4WkFuam8zS2Fl?=
 =?utf-8?B?SGo5QmhwSXF2dm5jclQzeXM5S3NuZVVGdTU0S0g5bnJjdlJjSnBGU2VxRElR?=
 =?utf-8?B?N0pzTzkrcG01YmQzem92eUQ0bUhXQWNuazJIdldPLzVXbjRvZVV4RjBHcnVK?=
 =?utf-8?B?UVI3cC9QK3ZDdDIzRVd6OHBiZFBaUmsxVVBBSGVLS1BPU3JMRnl5QytGOGk3?=
 =?utf-8?B?bVhGKzlEUnV4WHlRbVI5NG14YVRTNWhmRXZqQTRDVmx3Rk1aTXphQUVDWUVI?=
 =?utf-8?B?RG5qcTRRNG5STFJ6RTQ3cjYzTE9EbUJzUSsvcXA1b0xSTURqanZBVXRnMFJs?=
 =?utf-8?B?cHJtbDhNVGt2QWxIcU8wdU51NDhJYVJQcjhXekovODhPY1pIOFFMVGt0MEg1?=
 =?utf-8?B?TU9PRTAzcEkzVnBPb1RCeGIyVjY1dERjWFRFc2RBYnk2M29lSE4zSGlna1Mx?=
 =?utf-8?Q?WxnI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b52e5bd-17b1-401d-ea88-08d99d1f6001
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 10:07:13.1972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlnsuCif8wBik5pLLtllZiw0CssnihRijHL8E3J5Hbukqwl/jgrxUP+NDzFLjL6x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2021 4:30 AM, Baowen Zheng wrote:
> On 10/31/2021 5:50 PM, Oz Shlomo wrote:
>> On 10/28/2021 2:06 PM, Simon Horman wrote:
>>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>>
>>> Use flow_indr_dev_register/flow_indr_dev_setup_offload to offload tc
>>> action.
>>
>> How will device drivers reference the offloaded actions when offloading a
>> flow?
>> Perhaps the flow_action_entry structure should also include the action index.
>>
> We have set action index in flow_offload_action to offload the action, also there are > already some actions in flow_action_entry include index which we want to offload.
> If the driver wants to support action that needs index, I think it can add the index later,
> it may not include in this patch, WDYT?

What do you mean by "action that needs index"?

Currently only the police and gate actions have an action index parameter.
However, with this series the user can create any action using the tc action API and then reference 
it from any filter.
Do you see a reason not to expose the action index as a flow_action_entry attribute?


>>>
>>> We need to call tc_cleanup_flow_action to clean up tc action entry
>>> since in tc_setup_action, some actions may hold dev refcnt, especially
>>> the mirror action.
>>>
>>> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
>>> Signed-off-by: Louis Peens <louis.peens@corigine.com>
>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>> ---
>>>    include/linux/netdevice.h  |   1 +
>>>    include/net/act_api.h      |   2 +-
>>>    include/net/flow_offload.h |  17 ++++
>>>    include/net/pkt_cls.h      |  15 ++++
>>>    net/core/flow_offload.c    |  43 ++++++++--
>>>    net/sched/act_api.c        | 166 +++++++++++++++++++++++++++++++++++++
>>>    net/sched/cls_api.c        |  29 ++++++-
>>>    7 files changed, 260 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index 3ec42495a43a..9815c3a058e9 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>>> @@ -916,6 +916,7 @@ enum tc_setup_type {
>>>    	TC_SETUP_QDISC_TBF,
>>>    	TC_SETUP_QDISC_FIFO,
>>>    	TC_SETUP_QDISC_HTB,
>>> +	TC_SETUP_ACT,
>>>    };
>>>
>>>    /* These structures hold the attributes of bpf state that are being
>>> passed diff --git a/include/net/act_api.h b/include/net/act_api.h
>>> index b5b624c7e488..9eb19188603c 100644
>>> --- a/include/net/act_api.h
>>> +++ b/include/net/act_api.h
>>> @@ -239,7 +239,7 @@ static inline void
>> tcf_action_inc_overlimit_qstats(struct tc_action *a)
>>>    void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>>>    			     u64 drops, bool hw);
>>>    int tcf_action_copy_stats(struct sk_buff *, struct tc_action *,
>>> int);
>>> -
>>> +int tcf_action_offload_del(struct tc_action *action);
>>>    int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>>>    			     struct tcf_chain **handle,
>>>    			     struct netlink_ext_ack *newchain); diff --git
>>> a/include/net/flow_offload.h b/include/net/flow_offload.h index
>>> 3961461d9c8b..aa28592fccc0 100644
>>> --- a/include/net/flow_offload.h
>>> +++ b/include/net/flow_offload.h
>>> @@ -552,6 +552,23 @@ struct flow_cls_offload {
>>>    	u32 classid;
>>>    };
>>>
>>> +enum flow_act_command {
>>> +	FLOW_ACT_REPLACE,
>>> +	FLOW_ACT_DESTROY,
>>> +	FLOW_ACT_STATS,
>>> +};
>>> +
>>> +struct flow_offload_action {
>>> +	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS
>> process*/
>>> +	enum flow_act_command command;
>>> +	enum flow_action_id id;
>>> +	u32 index;
>>> +	struct flow_stats stats;
>>> +	struct flow_action action;
>>> +};
>>> +
>>> +struct flow_offload_action *flow_action_alloc(unsigned int
>>> +num_actions);
>>> +
>>>    static inline struct flow_rule *
>>>    flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
>>>    {
>>> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h index
>>> 193f88ebf629..922775407257 100644
>>> --- a/include/net/pkt_cls.h
>>> +++ b/include/net/pkt_cls.h
>>> @@ -258,6 +258,9 @@ static inline void tcf_exts_put_net(struct tcf_exts
>> *exts)
>>>    	for (; 0; (void)(i), (void)(a), (void)(exts))
>>>    #endif
>>>
>>> +#define tcf_act_for_each_action(i, a, actions) \
>>> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
>>> +
>>>    static inline void
>>>    tcf_exts_stats_update(const struct tcf_exts *exts,
>>>    		      u64 bytes, u64 packets, u64 drops, u64 lastuse, @@ -532,8
>>> +535,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>>>    	return ifindex == skb->skb_iif;
>>>    }
>>>
>>> +#ifdef CONFIG_NET_CLS_ACT
>>>    int tc_setup_flow_action(struct flow_action *flow_action,
>>>    			 const struct tcf_exts *exts);
>>> +#else
>>> +static inline int tc_setup_flow_action(struct flow_action *flow_action,
>>> +				       const struct tcf_exts *exts) {
>>> +	return 0;
>>> +}
>>> +#endif
>>> +
>>> +int tc_setup_action(struct flow_action *flow_action,
>>> +		    struct tc_action *actions[]);
>>>    void tc_cleanup_flow_action(struct flow_action *flow_action);
>>>
>>>    int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type
>>> type, @@ -554,6 +568,7 @@ int tc_setup_cb_reoffload(struct tcf_block
>> *block, struct tcf_proto *tp,
>>>    			  enum tc_setup_type type, void *type_data,
>>>    			  void *cb_priv, u32 *flags, unsigned int
>> *in_hw_count);
>>>    unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
>>> +unsigned int tcf_act_num_actions_single(struct tc_action *act);
>>>
>>>    #ifdef CONFIG_NET_CLS_ACT
>>>    int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch, diff
>>> --git a/net/core/flow_offload.c b/net/core/flow_offload.c index
>>> 6beaea13564a..6676431733ef 100644
>>> --- a/net/core/flow_offload.c
>>> +++ b/net/core/flow_offload.c
>>> @@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int
>> num_actions)
>>>    }
>>>    EXPORT_SYMBOL(flow_rule_alloc);
>>>
>>> +struct flow_offload_action *flow_action_alloc(unsigned int
>>> +num_actions) {
>>> +	struct flow_offload_action *fl_action;
>>> +	int i;
>>> +
>>> +	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
>>> +			    GFP_KERNEL);
>>> +	if (!fl_action)
>>> +		return NULL;
>>> +
>>> +	fl_action->action.num_entries = num_actions;
>>> +	/* Pre-fill each action hw_stats with DONT_CARE.
>>> +	 * Caller can override this if it wants stats for a given action.
>>> +	 */
>>> +	for (i = 0; i < num_actions; i++)
>>> +		fl_action->action.entries[i].hw_stats =
>>> +FLOW_ACTION_HW_STATS_DONT_CARE;
>>> +
>>> +	return fl_action;
>>> +}
>>> +EXPORT_SYMBOL(flow_action_alloc);
>>> +
>>>    #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)
>> 		\
>>>    	const struct flow_match *__m = &(__rule)->match;
>> 	\
>>>    	struct flow_dissector *__d = (__m)->dissector;
>> 	\
>>> @@ -549,19 +570,25 @@ int flow_indr_dev_setup_offload(struct
>> net_device *dev,	struct Qdisc *sch,
>>>    				void (*cleanup)(struct flow_block_cb
>> *block_cb))
>>>    {
>>>    	struct flow_indr_dev *this;
>>> +	u32 count = 0;
>>> +	int err;
>>>
>>>    	mutex_lock(&flow_indr_block_lock);
>>> +	if (bo) {
>>> +		if (bo->command == FLOW_BLOCK_BIND)
>>> +			indir_dev_add(data, dev, sch, type, cleanup, bo);
>>> +		else if (bo->command == FLOW_BLOCK_UNBIND)
>>> +			indir_dev_remove(data);
>>> +	}
>>>
>>> -	if (bo->command == FLOW_BLOCK_BIND)
>>> -		indir_dev_add(data, dev, sch, type, cleanup, bo);
>>> -	else if (bo->command == FLOW_BLOCK_UNBIND)
>>> -		indir_dev_remove(data);
>>> -
>>> -	list_for_each_entry(this, &flow_block_indr_dev_list, list)
>>> -		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
>>> +	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
>>> +		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
>>> +		if (!err)
>>> +			count++;
>>> +	}
>>>
>>>    	mutex_unlock(&flow_indr_block_lock);
>>>
>>> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
>>> +	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
>>>    }
>>>    EXPORT_SYMBOL(flow_indr_dev_setup_offload);
>>> diff --git a/net/sched/act_api.c b/net/sched/act_api.c index
>>> 3258da3d5bed..33f2ff885b4b 100644
>>> --- a/net/sched/act_api.c
>>> +++ b/net/sched/act_api.c
>>> @@ -21,6 +21,19 @@
>>>    #include <net/pkt_cls.h>
>>>    #include <net/act_api.h>
>>>    #include <net/netlink.h>
>>> +#include <net/tc_act/tc_pedit.h>
>>> +#include <net/tc_act/tc_mirred.h>
>>> +#include <net/tc_act/tc_vlan.h>
>>> +#include <net/tc_act/tc_tunnel_key.h> #include <net/tc_act/tc_csum.h>
>>> +#include <net/tc_act/tc_gact.h> #include <net/tc_act/tc_police.h>
>>> +#include <net/tc_act/tc_sample.h> #include <net/tc_act/tc_skbedit.h>
>>> +#include <net/tc_act/tc_ct.h> #include <net/tc_act/tc_mpls.h>
>>> +#include <net/tc_act/tc_gate.h> #include <net/flow_offload.h>
>>>
>>>    #ifdef CONFIG_INET
>>>    DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
>>> @@ -148,6 +161,7 @@ static int __tcf_action_put(struct tc_action *p, bool
>> bind)
>>>    		idr_remove(&idrinfo->action_idr, p->tcfa_index);
>>>    		mutex_unlock(&idrinfo->lock);
>>>
>>> +		tcf_action_offload_del(p);
>>>    		tcf_action_cleanup(p);
>>>    		return 1;
>>>    	}
>>> @@ -341,6 +355,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
>>>    		return -EPERM;
>>>
>>>    	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
>>> +		tcf_action_offload_del(p);
>>>    		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
>>>    		tcf_action_cleanup(p);
>>>    		return ACT_P_DELETED;
>>> @@ -452,6 +467,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo
>> *idrinfo, u32 index)
>>>    						p->tcfa_index));
>>>    			mutex_unlock(&idrinfo->lock);
>>>
>>> +			tcf_action_offload_del(p);
>>>    			tcf_action_cleanup(p);
>>>    			module_put(owner);
>>>    			return 0;
>>> @@ -1061,6 +1077,154 @@ struct tc_action *tcf_action_init_1(struct net
>> *net, struct tcf_proto *tp,
>>>    	return ERR_PTR(err);
>>>    }
>>>
>>> +static int flow_action_init(struct flow_offload_action *fl_action,
>>> +			    struct tc_action *act,
>>> +			    enum flow_act_command cmd,
>>> +			    struct netlink_ext_ack *extack) {
>>> +	if (!fl_action)
>>> +		return -EINVAL;
>>> +
>>> +	fl_action->extack = extack;
>>> +	fl_action->command = cmd;
>>> +	fl_action->index = act->tcfa_index;
>>> +
>>> +	if (is_tcf_gact_ok(act)) {
>>> +		fl_action->id = FLOW_ACTION_ACCEPT;
>>> +	} else if (is_tcf_gact_shot(act)) {
>>> +		fl_action->id = FLOW_ACTION_DROP;
>>> +	} else if (is_tcf_gact_trap(act)) {
>>> +		fl_action->id = FLOW_ACTION_TRAP;
>>> +	} else if (is_tcf_gact_goto_chain(act)) {
>>> +		fl_action->id = FLOW_ACTION_GOTO;
>>> +	} else if (is_tcf_mirred_egress_redirect(act)) {
>>> +		fl_action->id = FLOW_ACTION_REDIRECT;
>>> +	} else if (is_tcf_mirred_egress_mirror(act)) {
>>> +		fl_action->id = FLOW_ACTION_MIRRED;
>>> +	} else if (is_tcf_mirred_ingress_redirect(act)) {
>>> +		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
>>> +	} else if (is_tcf_mirred_ingress_mirror(act)) {
>>> +		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
>>> +	} else if (is_tcf_vlan(act)) {
>>> +		switch (tcf_vlan_action(act)) {
>>> +		case TCA_VLAN_ACT_PUSH:
>>> +			fl_action->id = FLOW_ACTION_VLAN_PUSH;
>>> +			break;
>>> +		case TCA_VLAN_ACT_POP:
>>> +			fl_action->id = FLOW_ACTION_VLAN_POP;
>>> +			break;
>>> +		case TCA_VLAN_ACT_MODIFY:
>>> +			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
>>> +			break;
>>> +		default:
>>> +			return -EOPNOTSUPP;
>>> +		}
>>> +	} else if (is_tcf_tunnel_set(act)) {
>>> +		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
>>> +	} else if (is_tcf_tunnel_release(act)) {
>>> +		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
>>> +	} else if (is_tcf_csum(act)) {
>>> +		fl_action->id = FLOW_ACTION_CSUM;
>>> +	} else if (is_tcf_skbedit_mark(act)) {
>>> +		fl_action->id = FLOW_ACTION_MARK;
>>> +	} else if (is_tcf_sample(act)) {
>>> +		fl_action->id = FLOW_ACTION_SAMPLE;
>>> +	} else if (is_tcf_police(act)) {
>>> +		fl_action->id = FLOW_ACTION_POLICE;
>>> +	} else if (is_tcf_ct(act)) {
>>> +		fl_action->id = FLOW_ACTION_CT;
>>> +	} else if (is_tcf_mpls(act)) {
>>> +		switch (tcf_mpls_action(act)) {
>>> +		case TCA_MPLS_ACT_PUSH:
>>> +			fl_action->id = FLOW_ACTION_MPLS_PUSH;
>>> +			break;
>>> +		case TCA_MPLS_ACT_POP:
>>> +			fl_action->id = FLOW_ACTION_MPLS_POP;
>>> +			break;
>>> +		case TCA_MPLS_ACT_MODIFY:
>>> +			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
>>> +			break;
>>> +		default:
>>> +			return -EOPNOTSUPP;
>>> +		}
>>> +	} else if (is_tcf_skbedit_ptype(act)) {
>>> +		fl_action->id = FLOW_ACTION_PTYPE;
>>> +	} else if (is_tcf_skbedit_priority(act)) {
>>> +		fl_action->id = FLOW_ACTION_PRIORITY;
>>> +	} else if (is_tcf_gate(act)) {
>>> +		fl_action->id = FLOW_ACTION_GATE;
>>> +	} else {
>>> +		return -EOPNOTSUPP;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
>>> +				  struct netlink_ext_ack *extack) {
>>> +	int err;
>>> +
>>> +	if (IS_ERR(fl_act))
>>> +		return PTR_ERR(fl_act);
>>> +
>>> +	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
>>> +					  fl_act, NULL, NULL);
>>> +	if (err < 0)
>>> +		return err;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +/* offload the tc command after inserted */ static int
>>> +tcf_action_offload_add(struct tc_action *action,
>>> +				  struct netlink_ext_ack *extack) {
>>> +	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
>>> +		[0] = action,
>>> +	};
>>> +	struct flow_offload_action *fl_action;
>>> +	int err = 0;
>>> +
>>> +	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
>>> +	if (!fl_action)
>>> +		return -EINVAL;
>>> +
>>> +	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
>>> +	if (err)
>>> +		goto fl_err;
>>> +
>>> +	err = tc_setup_action(&fl_action->action, actions);
>>> +	if (err) {
>>> +		NL_SET_ERR_MSG_MOD(extack,
>>> +				   "Failed to setup tc actions for offload\n");
>>> +		goto fl_err;
>>> +	}
>>> +
>>> +	err = tcf_action_offload_cmd(fl_action, extack);
>>> +	tc_cleanup_flow_action(&fl_action->action);
>>> +
>>> +fl_err:
>>> +	kfree(fl_action);
>>> +
>>> +	return err;
>>> +}
>>> +
>>> +int tcf_action_offload_del(struct tc_action *action) {
>>> +	struct flow_offload_action fl_act;
>>> +	int err = 0;
>>> +
>>> +	if (!action)
>>> +		return -EINVAL;
>>> +
>>> +	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
>>> +	if (err)
>>> +		return err;
>>> +
>>> +	return tcf_action_offload_cmd(&fl_act, NULL); }
>>> +
>>>    /* Returns numbers of initialized actions or negative error. */
>>>
>>>    int tcf_action_init(struct net *net, struct tcf_proto *tp, struct
>>> nlattr *nla, @@ -1103,6 +1267,8 @@ int tcf_action_init(struct net *net,
>> struct tcf_proto *tp, struct nlattr *nla,
>>>    		sz += tcf_action_fill_size(act);
>>>    		/* Start from index 0 */
>>>    		actions[i - 1] = act;
>>> +		if (!(flags & TCA_ACT_FLAGS_BIND))
>>> +			tcf_action_offload_add(act, extack);
>>
>> Why is this restricted to actions created without the TCA_ACT_FLAGS_BIND
>> flag?
>> How are actions instantiated by the filters different from those that are
>> created by "tc actions"?
>>
> Our patch aims to offload tc action that is created independent of any flow. It is usually
> offloaded when it is added or replaced.
> This patch is to implement a process of reoffloading the actions when driver is
> inserted or removed, so it will still offload the independent actions.

I see.

>>>    	}
>>>
>>>    	/* We have to commit them all together, because if any error
>>> happened in diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>>> index 2ef8f5a6205a..351d93988b8b 100644
>>> --- a/net/sched/cls_api.c
>>> +++ b/net/sched/cls_api.c
>>> @@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats
>> tc_act_hw_stats(u8 hw_stats)
>>>    	return hw_stats;
>>>    }
>>>
>>> -int tc_setup_flow_action(struct flow_action *flow_action,
>>> -			 const struct tcf_exts *exts)
>>> +int tc_setup_action(struct flow_action *flow_action,
>>> +		    struct tc_action *actions[])
>>>    {
>>>    	struct tc_action *act;
>>>    	int i, j, k, err = 0;
>>> @@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action
>> *flow_action,
>>>    	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE !=
>> FLOW_ACTION_HW_STATS_IMMEDIATE);
>>>    	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED !=
>>> FLOW_ACTION_HW_STATS_DELAYED);
>>>
>>> -	if (!exts)
>>> +	if (!actions)
>>>    		return 0;
>>>
>>>    	j = 0;
>>> -	tcf_exts_for_each_action(i, act, exts) {
>>> +	tcf_act_for_each_action(i, act, actions) {
>>>    		struct flow_action_entry *entry;
>>>
>>>    		entry = &flow_action->entries[j];
>>> @@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action
>> *flow_action,
>>>    	spin_unlock_bh(&act->tcfa_lock);
>>>    	goto err_out;
>>>    }
>>> +EXPORT_SYMBOL(tc_setup_action);
>>> +
>>> +#ifdef CONFIG_NET_CLS_ACT
>>> +int tc_setup_flow_action(struct flow_action *flow_action,
>>> +			 const struct tcf_exts *exts)
>>> +{
>>> +	if (!exts)
>>> +		return 0;
>>> +
>>> +	return tc_setup_action(flow_action, exts->actions); }
>>>    EXPORT_SYMBOL(tc_setup_flow_action);
>>> +#endif
>>>
>>>    unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>>>    {
>>> @@ -3743,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct
>> tcf_exts *exts)
>>>    }
>>>    EXPORT_SYMBOL(tcf_exts_num_actions);
>>>
>>> +unsigned int tcf_act_num_actions_single(struct tc_action *act) {
>>> +	if (is_tcf_pedit(act))
>>> +		return tcf_pedit_nkeys(act);
>>> +	else
>>> +		return 1;
>>> +}
>>> +EXPORT_SYMBOL(tcf_act_num_actions_single);
>>> +
>>>    #ifdef CONFIG_NET_CLS_ACT
>>>    static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>>>    					u32 *p_block_index,
>>>
