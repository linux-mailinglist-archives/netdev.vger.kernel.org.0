Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F2F444038
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhKCK6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:58:54 -0400
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:46874
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbhKCK6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 06:58:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2LmN5mWyyBrjt16wrUjHG+1W0H7CEiCwnOoNPEWAsEH0diaSoJVEbhwkZmFSXQthXsowq5twEC4oAx/S9hXTzUjF1aLCBLgc8rAVaI+q6sCh4UuLnEpi83xpH+ZDjIux1+gghO5OQ3wu4Js2WDX3jQ66eSe601vYhl5YyyuBGf/tKH1HdiNW5nPKkH03MWMOMK2iO2VcXSQpHLEUbQjRkKa0xZqy0fpwxQjTMBMg4ZTqK3e4mbCShFM6TzOOyfO9cH9Ucv4zsoqOK+Q319Gsf4FXMBN0I25yIjxC8Do0qGSlZ9vIu7IWtGwA47pvxXr9Ui3hhED/IaMwf9DTlYJmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHys1LjvNmLn8icZ360x2IGnqOD9rXbEmmfct6vuvT0=;
 b=cltVHgA51nxLs1A3KgB7p0wLixpJz5iSNRuWy56J1sXbBTOvYKyhhnE15EHmYzyMEK53/gOR6EXiIp+bOcum4YY1mc31ajLIp397k6MeQsCZefMsFZZGHIzRhfqpcE0nxo05VtmLyLB67bL6DMaylyFcUtz8vopVwxFwdy2fkO4KmweNIqcLsB7699etz5A1K21WwgBJ67Sv2GSIZmcrR2GHlsQa4lBdrEDPvY5FPvpT9SP86V1rk92mzj62Rtoj+FmaMwpsrHNe1ODuLNLz8Op5hBUr0Ks71Ljgs8MYa+EGDgMgS9p+sO7b/rUH1u1ufdreT+mJtAyzt11yNGPjGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHys1LjvNmLn8icZ360x2IGnqOD9rXbEmmfct6vuvT0=;
 b=l9fUV9lUOXxtGr1BRTQoDpXY/2AkH1ND2O6NzwL0Njd5WUQarYLr0YsvVmhKcK3XWPKdNTN0/jHd8kCBS1I9J3316Zztqkb1jNgkN+AIVkOheKOeEEYgFi8RqOp5sIWPICE+AMB3qp2ngc1DHmK1hh7Pg/8XF+DI9Pchpq89iPtcrbP8qaFP6ru4trDFLBQUuS3wdOeX1z+CHp3O+MXnASiY+MjYiToabKOsVSMm++fvwStNZVusbAF/Zo1oxLuTfsn5bQyBdaDdylhrsfZuo128lZzh3tI4hDc7116wotSRX6vBNAvufLkHmKjGncY7a3FREtvgmpnIn+AdTRze3Q==
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5379.namprd12.prod.outlook.com (2603:10b6:208:317::15)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 10:56:15 +0000
Received: from BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440]) by BL1PR12MB5379.namprd12.prod.outlook.com
 ([fe80::205d:a229:2a0f:1440%9]) with mapi id 15.20.4649.019; Wed, 3 Nov 2021
 10:56:15 +0000
Message-ID: <51066434-3973-9b19-85a6-e57fcd67af79@nvidia.com>
Date:   Wed, 3 Nov 2021 12:56:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC/PATCH net-next v3 0/8] allow user to offload tc action to
 net device
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <b409b190-8427-2b6b-ff17-508d81175e4d@nvidia.com>
 <cf86b2ab-ec3a-b249-b380-968c0a3ef67d@mojatatu.com>
 <ygnha6io9uef.fsf@nvidia.com> <20211102125119.GB7266@corigine.com>
 <ygnhzgqm8tdx.fsf@nvidia.com> <20211102161518.GA26566@corigine.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20211102161518.GA26566@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR04CA0057.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::34) To BL1PR12MB5379.namprd12.prod.outlook.com
 (2603:10b6:208:317::15)
MIME-Version: 1.0
Received: from [172.27.15.135] (193.47.165.251) by AM6PR04CA0057.eurprd04.prod.outlook.com (2603:10a6:20b:f0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Wed, 3 Nov 2021 10:56:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9420180-3f0f-438f-3d28-08d99eb88e63
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51270E8F58BA9DA712F0868DA68C9@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LbjPITkWmLJYNjpaJ14EkckN5NyaTNW2gpusoZy+YrLPj2R0QeFs2v6RufpuvrQahj4CLEIAAnxe57TJk7RSH/EkrRE6SNU8hoYHxv4cY1jQmwkmWFcwn7bKmq6cmqQqv7goJc2KdiBc2CH5xl04H5mgxnlysgBoxaBEs0US7SETSLemCZVGe4D8HToIWen9ZMbjD7L+wVJ0vOR2pLmnK+ywW0kbz3pymiDu6KxLywZtyt1sKjCIecn2piG/HKukn5mhClMMHm/dNSwpU5RfMw78lJ8nzY8lmxe7uXv2u4MSLbRUtrA8xXgoQvmXZvnNC3JmABpzuz6DJk+xglYfFbbGCkLGfPl5N0FC/7NDiLQ66XFrQSBHm3pIaftrTxMm8LBG0akFOLyfTXXBGCjKNwNskNsN4Xhe6PAKXCzaHEe0bZTPt59W66B0vHGAZg3sBDBX5cPtFp7NBRxTPfmEGLXeGN2kkCmzLhkABFUR8zzjRsrUVksSEAh4n70JF/IF5ASy5JjZv/j86OkOpFfeLuN+evwNuBlTM0X5z7acg+Xb8YCShFrgqz9JzvIAZGPeWxjdeLTcywiArkrl7yVqz6bf3cM9y16iFlK0UDHfKS//RuJ9ZzXA/kXVPdAEbEtayKWgdsG4ZmB+zK+AYc8rp7Dxq1x76pMW2MzyzqlajaaDTPzCGD4b8bdSAH27lc750eXDcczH0eX/BL2EIbXfvCq54jpTLKySsu98iZ/Pbgs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5379.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38100700002)(8936002)(53546011)(31686004)(36756003)(31696002)(8676002)(4326008)(6486002)(4001150100001)(6636002)(110136005)(83380400001)(956004)(2906002)(508600001)(66476007)(54906003)(66946007)(26005)(316002)(2616005)(66556008)(6666004)(186003)(86362001)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHdWclJ4VmpmcFdkdHRiNE5VWjZpRHFSY3JlZnIzWU4wYUw3L0JOaHVBcjVS?=
 =?utf-8?B?aldOdzlyeUpOc0ZEd0NEZFNXM1NLOHk1K3k0a3Avby93ODk1a2crdytVd2Qy?=
 =?utf-8?B?STdnTzU4MUxUUTMxWUN3YWtNYjdCeld4bW5Kc0xCTjFHTmowQU9aUWlHWHlF?=
 =?utf-8?B?YmZzTFoxdndJNk9GM250bUZIV042dlZkTFpSUmtvMjVwMnFHNjV2aHpJYVlj?=
 =?utf-8?B?RzRpK1hIdVlzZnVjeWQwZ2FVd1lYMzE0UERIbUVsNEpHRk1xZDkxQTFRZVRy?=
 =?utf-8?B?Um1PK1hBSGV5SVp1QUtzK0xLenEwWGJCKzloNmh1UGM0bzBMY2RmNWsvbzRn?=
 =?utf-8?B?L1E3MjNuYjdXeHo4bklIN1FrVXpWN3lYc2swNy9zSENJdkIyd1dhd3diWWpa?=
 =?utf-8?B?QUZ1SlBINk04Z21UTWQvMndrUDl2MlZEOE9vY3YvWjJBbTVlVjY2QTN4OTNL?=
 =?utf-8?B?Z2RQYXJ2cm1wRDl6bHEvcDBiZ01jcXpqNHJkaXg4c2svaU9EWEI4b0pJVXJk?=
 =?utf-8?B?ZXVqNnZkaG92YVMyZy9IMWlhUStHYllGaXdYR2pPWmt5UG0xMUs0a2FJREtH?=
 =?utf-8?B?dThVOENCUG93UEpTaWJ5QnJReU5mSVpOMGNYQjhUd3FRNjJFM1ZrVzVmTkNF?=
 =?utf-8?B?MlprV3hXNXFGaG1vdVEwQVJWL0dBcnp5NWRXcVFFUDltdFdIZWdzNHBRdFNp?=
 =?utf-8?B?MHJTaW41QWpyT0JBV2VXVHpta2hCSDNRU0t6cTNVWFEwZ3FjQWltQnZIcDdi?=
 =?utf-8?B?SWUzOE1UenJ5ckU1OEVWcjhzSXpZc08vQ01rZkRVYWcvc1FqaXB4ZVdEaEJl?=
 =?utf-8?B?Zm9FWkJKTGppTXNQYkhtMEJmajBSYXJnOVFUalFlUUZLTTdZemJWMXJLeXlk?=
 =?utf-8?B?T0tqSVhibHV5ME9oWThpdm9GU2VBaTJDcFoyU3o3dENvVC9WSXF0b3dTc3R6?=
 =?utf-8?B?QTlwRFF2Zys1QU5RTGlQb2F2QVVXRnRzdUEzdCs2NWVxYXRnZkdDMmxLVFlT?=
 =?utf-8?B?blpmK1o5N0NhN1ZtQ3RYaHZ1WmFFNFRhdENRWmk5dUREY25nRkRYWHpETjlR?=
 =?utf-8?B?ZUJ3TEJ3MmxKY2pQZ3NMR3NGbjNoa01hUUpjUnlDMWhoM2hKOExQL2Fqa1Ra?=
 =?utf-8?B?Q0dzcVdDNXlQUlpSTVJBYkRQOGdXNHdRbDNTcHF2Mm9nOTZwbEl6VURrUmpW?=
 =?utf-8?B?eXNhK1lsUnV0cVVwaW1TY3p2Q1A2MEswQkw1S2ZoSGtHTWtQbG9EZ3VrcGlr?=
 =?utf-8?B?VXdidHFtMjdLSW81cmdFeEM1ekhZaWVNUVZLbmMwTlBIUXRZVno0U0lkWTNk?=
 =?utf-8?B?STBXR1kvUjRUNnBSRWk5bThWNHp4MnMyMEx2bDBtRlU1a0ZaTVEyRSt6UEoy?=
 =?utf-8?B?QjRTWWREQ0JrL2F1NlFUd1lDNm1ZVGVxN3VRNG50c0ovcFFhK3Z5UlA3bFF0?=
 =?utf-8?B?WEFyODU2T2M1dzFBMElQOTRqL3NNTDdBNGE3bDQ4dHg0WE1zcld1MXNpM1Ur?=
 =?utf-8?B?cTVCOHFqQzl0a0RIUVhJYVNiWTB4UjBqOVQvdGp2bFJHcldoNEl1UmIxZkZi?=
 =?utf-8?B?aTF5OVg3NUJxTzcxM0E3UWtoUUdJdi9QQ3lxWGIyN2NFNHY2aWxLRk9ySldJ?=
 =?utf-8?B?VkNITEpiMDh0VnJITCtkZzZENHNMbjI0RFlZcmhTSTA1MWw5bGJvOUtremd3?=
 =?utf-8?B?WXlJcGRMVHdFWlpRSTNmeVRpWVpGeXpITkxNQTRmdVZZYzVIcWErQkdWRXFV?=
 =?utf-8?B?Y010cXBrTXp2UEpKZFltYVp3SjlnSUtjRk4yN1U1OVlJR0Z1UVBkUVdCaG9G?=
 =?utf-8?B?eVNsaUZtazRzTXFYNmladGVDSXlQeWx5SUhMQXV1bkRFUmtzSjFKQmpaSXlv?=
 =?utf-8?B?MVJ0bm92TmI1Mis0cjJmb2ZjVStGUHhVN3NpeTE4UXhBcmp2VWhtbXU0cU1B?=
 =?utf-8?B?RGdxOEtVZUZIUEltaUZ3ZUQ3bi8yUWhWWXpiSmh3N2xyc2FJSGF5bGxwMDAr?=
 =?utf-8?B?RWFFVGdMeUVmM1FMelBOQXM1QU1yZjVtak42bWx5YUJYcHRndmp0REJtZk9Z?=
 =?utf-8?B?alN3alIzNUVEQnhhdVVwaDNtdy9CQzNLS0dVK2hnbmZMdjFWUEZkZ2VIeW50?=
 =?utf-8?Q?F8O4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9420180-3f0f-438f-3d28-08d99eb88e63
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5379.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 10:56:15.4474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qV6KFIZbDZ7DhRWnkeAmxxXFm80f6yW04LF/ZqDN+37l6GaiQDJotRmrcCRXH3Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2021 6:15 PM, Simon Horman wrote:
> On Tue, Nov 02, 2021 at 05:33:14PM +0200, Vlad Buslov wrote:
>> On Tue 02 Nov 2021 at 14:51, Simon Horman <simon.horman@corigine.com> wrote:
>>> On Mon, Nov 01, 2021 at 10:01:28AM +0200, Vlad Buslov wrote:
>>>> On Sun 31 Oct 2021 at 15:40, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>>> On 2021-10-31 05:50, Oz Shlomo wrote:
>>>>>>
>>>>>> On 10/28/2021 2:06 PM, Simon Horman wrote:
>>>
>>> ...
>>>
>>>>>> Actions are also (implicitly) instantiated when filters are created.
>>>>>> In the following example the mirred action instance (created by the first
>>>>>> filter) is shared by the second filter:
>>>>>> tc filter add dev $DEV1 proto ip parent ffff: flower \
>>>>>>       ip_proto tcp action mirred egress redirect dev $DEV3
>>>>>> tc filter add dev $DEV2 proto ip parent ffff: flower \
>>>>>>       ip_proto tcp action mirred index 1
>>>>>>
>>>>>
>>>>> I sure hope this is supported. At least the discussions so far
>>>>> are a nod in that direction...
>>>>> I know there is hardware that is not capable of achieving this
>>>>> (little CPE type devices) but lets not make that the common case.
>>>>
>>>> Looks like it isn't supported in this change since
>>>> tcf_action_offload_add() is only called by tcf_action_init() when BIND
>>>> flag is not set (the flag is always set when called from cls code).
>>>> Moreover, I don't think it is good idea to support such use-case because
>>>> that would require to increase number of calls to driver offload
>>>> infrastructure from 1 per filter to 1+number_of_actions, which would
>>>> significantly impact insertion rate.
>>>
>>> Hi,
>>>
>>> I feel that I am missing some very obvious point here.
>>>
>>> But from my perspective the use case described by Oz is supported
>>> by existing offload of the flower classifier (since ~4.13 IIRC).
>>
>> Mlx5 driver can't support such case without infrastructure change in
>> kernel for following reasons:
>>
>> - Action index is not provided by flow_action offload infrastructure for
>>    most of the actions, so there is no way for driver to determine
>>    whether the action is shared.
>>
>> - If we extend the infrastructure to always provide tcfa_index (a
>>    trivial change), there would be not much use for it because there is
>>    no way to properly update shared action counters without
>>    infrastructure code similar to what you implemented as part of this
>>    series.
>>
>> How do you support shared actions created through cls_api in your
>> driver, considering described limitations?
> 
> Thanks,
> 
> I misread the use case described by Oz, but I believe I understand it now.
> 
> I agree that the case described is neither currently supported, nor
> supported by this patchset (to be honest I for one had not considered it).
> 
> So, I think the question is: does upporting this use-case make sense - from
> implementation, use-case, and consistency perspectives - in the context of
> this patchset?
> 
> Am I on the right track?
> 

Currently we don't have a specific application use case for sharing actions that were created by tc 
filters. However, we do have future use case in mind.
We could add such functionality on top of this series when a use case will materialize.
Perhaps, at that point, we can also introduce a control flag in order to avoid unnecessary insertion 
rate performance degradation.
