Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66358696342
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbjBNMPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjBNMO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:14:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD53626847
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 04:14:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OC1eGbmdNbqIvMQsopo6tkOW+sBUS2jld8I6S4FDF/6WoJNKbvUPtJ0BZDn/Uly9X0Jljbu/4YcD/AI09fzZSpdGQ+Cc25tErvdLAe2iJYs7odkmuVgm2Jq0vc4n8rYE3yYVDCDN94wrIf9edEhT7AXIr7UihSrCNNKvA72EbMyCPruhx2MJNIrOP3NDJnbaYb0FWwCtL4jy8FQyNVMGaCJniBkr0q7i4wsR47O1KvEJs8dRkG94dx4T/lATSKWECi15Fa9rEyn/zOdxO0jeEE24vwA4IhscsRsAu5OJB7xLxIu/Rc4CWOJS8nBiJqi3GieRCiv9d6Ry+hkDIioARg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/g0cYFhBTcuukNpC4or/v/On6U3bateUCRAMhTR/Pw=;
 b=BumySqg2w1Bl/mABSXM3GJjyd4xHVqvJb9vAQrS533+kxicp1Yc4liZOFfeetu53FIuFxK0m6XTOV2kwHQvf6iYkiyjrytailgVxMiT8skynXCw2S7K3E5y0XPx080swVdplkwLC/ZXBcq54kpn6Hl2QuXGApgcw20EZjQvR6atFefV/Jtvy/W09tLRE52Yv6/eNQTOOh4ii6rAczDEVtpbfw/zV+9uKNe8uuMNNAN8z2CAY+TTzTBvl1+Hmi8CLecHkEDMgv5oNdm3knYDoTbUABYnsEBP034warEBdXIHLk7xqAafupjgoJDcTMnKyzhT2Yi1EE3WDg94ShsP3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/g0cYFhBTcuukNpC4or/v/On6U3bateUCRAMhTR/Pw=;
 b=mBxwJrAvtSM1quo+lRl2D2f2eznBWJYZqKr49xHavy5+iaUuhbvVM9pROutP0TzbU0IWj31khhoDdnX0j9FCiv6JJjqakr18Da2m5+BsM5q+nQ38HsEyyyzq8Tx7qa1w28Jbf1ceKoH5BbYaSFkbG7NcV6UFviXW2wCK+yR026sCts3pzbKxIjQdoaEGyJFSfSHiSg61S38a35T4iWdz3pz/Ovr3bNJoUj1LVnH7yfyvVPg8WiYee4yOmagHdfv+8z2rfV1XJmCQz6K6Ry2xS8FIpoXC9ds6PpJcogMfB8imyuy/1VMs8siawZGiewjvYEYC2a4j+/8r/Q2ACNQH5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by MW4PR12MB6921.namprd12.prod.outlook.com (2603:10b6:303:208::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 12:14:51 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::9af2:d4fc:43e2:cacd%9]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 12:14:51 +0000
Message-ID: <a3f14d60-578f-bd00-166d-b8be3de1de20@nvidia.com>
Date:   Tue, 14 Feb 2023 14:14:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v9 1/7] net/sched: cls_api: Support hardware miss
 to tc action
Content-Language: en-US
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230206174403.32733-2-paulb@nvidia.com>
 <20230210022108.xb5wqqrvpqa5jqcf@t14s.localdomain>
 <5de276c8-c300-dc35-d1a6-3b56a0f754ee@nvidia.com>
 <Y+qE66i7R01QnvNk@t14s.localdomain>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <Y+qE66i7R01QnvNk@t14s.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0485.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::10) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|MW4PR12MB6921:EE_
X-MS-Office365-Filtering-Correlation-Id: cb993f21-4575-4ec6-433f-08db0e8512ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ufjbq37gtAtdtW8+N7cRqCd4wOT/sbgXXfx3Ftd66CWqfNCrj73q2WXe+H+SU19PIklGQOL/f8I5L+xA1zE4ZgPMRFjgo8s/UsJB+c3wleMi2mNg3nbis5ieLVHohnmLb0EwEU2zauRsUXLBRnynNUzqBzmIrJUfa8EWKgdCPzaHOdkCol7Z83BK74swj35jqA3rT+TQ9P27ofArNwr2KDpbw4OksucvA7r8OS+80Hwn8Q0t5xyFqVdhIPzqVYe2JjOIsD2bXWvEDCN2/UoF91bilhxS6NlYWzlc53UsV7yKrCqDJYrn49D/OYilDuyuC5fNjdOF5p1/yTt4bNsP39udFVmj1AzRTVpaHQhytGGoUKSrlBisOA9StwHr1pBZzNAMFpZvDngrJdaqUagN4v3aYFGwTqH+Q2aXrv81SfRNPpm8R47OzoIkYZwnWB7RM7kpkFOjun/n7JOA2TwC/lmxtNDWwV8hedhs1hpKYz2VPfKngs/8oQw44m1d7ML5iFYrVVx8+qviL76uFRics4Qlf2lpe8yVMY2NxxDFrtugk+VqONoVn4Qm5mXUheUQYOBSrutiJpSeWUY3i5yPVEmArs5LS+tX00m4jf1q9e1nwAEbCkxF+S5aNuwVLFqpK5idQAS2MTNp8B42Q02YdtWXMqlm7aFD3q2PeRuhOKXYYO13dh8U1Os6ZwExD1U1Tw4nEnzltUYt0WqvX/5pu93c3vpVtNFGBOitlAWIyc4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199018)(66476007)(66556008)(41300700001)(6486002)(8676002)(4326008)(6916009)(8936002)(5660300002)(66946007)(86362001)(31686004)(31696002)(38100700002)(6512007)(83380400001)(53546011)(186003)(6506007)(26005)(6666004)(478600001)(2616005)(36756003)(54906003)(316002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlA4UTdCdW4zUnFHTjZvYjBWajNwaUV3YWpoL3BqeWdGck5uQW5HSFNNVTd2?=
 =?utf-8?B?YjZlc3krM3V2aDhPbzVjdXo3M3k1TG02dStnY05JZm8weVNPQ1h1amZ4NkJn?=
 =?utf-8?B?SGgyTHhKS2hJRy9lVHFhWFFpcURhZlpDVkR1UktObXhlcWJ6NjI0T25CWVdY?=
 =?utf-8?B?UHZmdC9JQXo2Tys2eWZySnVwOXJHMk13eEQ3RVdBNmkwN2k3UUdNQXhxQS9N?=
 =?utf-8?B?dDlldUNiWExpZmRpT3g0RFBJaWhpV3MzWUVPaDA4TGlTV0hwdWZUUzZBdm4y?=
 =?utf-8?B?UEFTUW1Wb1RObzZ1c25aS3dZZzJFUDN3QUtjN0djOGZKa2o0OGhuMXp5M2Ji?=
 =?utf-8?B?S1RoL0cxTk5vV2pYaExHbVZIWG5STmpyOWtsVko4QUZ2N2dRNXNiaXNVV3Vm?=
 =?utf-8?B?YjRVdWhPd3VYclBGQzAvdWZnd3NVUlpWTDdoRTJaKzA3SHlKbWFaWDJoTlR4?=
 =?utf-8?B?bERoVEMwWkk2QkJPbXlhRGpXSjJJVkJIcmxjWk5PM1IzVkFZRnMra3JSbUhB?=
 =?utf-8?B?WUoxd2RGcXlvT1E3RFFZV3V1c0NRN0toUlpuamRIN2tlaldsa2owbnIreDdw?=
 =?utf-8?B?d1QyczJ4ODRzNENWNkgzM0pxWkRHYmdDVzUrR296anQxM0duQldKZE9GS2dr?=
 =?utf-8?B?OXVVQ05sSUUvNUNRaS9QNHY4YUoyclNRei92bmlhdUkwM2VjamtNclM1aFkv?=
 =?utf-8?B?V1pIcFRRckJsNG5GOUdGZzMwTTIzZWFYb3hYU2dsR2JLdHVRT3RLTHpIei9E?=
 =?utf-8?B?cERXcXc1eWh0TC9WdU05TTNKV25ST0x6em9kSVVHZzcyOG10dE9ISVRIbTRQ?=
 =?utf-8?B?YTBybzIxTWlhZWp1V2VjNjJuK3BBai9KdEQrSWg3ZUxWQWcvZ2dXTGo1RTZ5?=
 =?utf-8?B?NkdzaXVJOERuYXgxN2RnS291Q3FMSlV2NUVzWU1FdlF5NEl0eFRXeXN3elha?=
 =?utf-8?B?b3B2V1h1RGoxZmh1OC9hNVd0ajB6SHR6M0RuMG5sR3NkR3JoaWFIcmtLcVBy?=
 =?utf-8?B?VVpTVWR0N21qTTcxdjNJblpGRFE3anZSQ3UrUTh5YzZOQ3UxZHZtL3c3TXRL?=
 =?utf-8?B?MXRYK1RzQXdlemJTYnZMWktFV0xXbFdTamNnL3lNYmNzbWpIN3BxZHJSbEJh?=
 =?utf-8?B?Tm9TaFpwWTlRZGJmNEZXdVQ0bWV0MDVDOC9SeUxnMnZ4SitWWDQxNXgrdkh6?=
 =?utf-8?B?enRnT1BaVlZxL0c5Q01hVXJRRHRmM3IyRWh6SE9GVGd4dzRpdGVZSkxMRzN2?=
 =?utf-8?B?Rnh4bk1aOXJmWTJURkZZcHNUVktucEsrVUdxVTRhenBGbXlET01UVTBmelhT?=
 =?utf-8?B?SklsNWgyNmtlYloraHJhTzhrZkJ2MlI2MVNQR0IzcjFZeE0xWHpTUUVnZkF0?=
 =?utf-8?B?eUxjSkdMTFhTMmIxMlJ1R21CNkEvQjRETHVEUnpoamozWXBCS2s4ZjVEOWZG?=
 =?utf-8?B?U0oweCt5RmVpSkltYkgvZDVXQ2RnelN0OHdJQ0FLcXpISGpNcHJOeWRpcEVR?=
 =?utf-8?B?eE1PcGFCVk1oYVVXTm9uTHdyNkRPMkFselloaDhaakFiN0s5UWExLy9yZFNR?=
 =?utf-8?B?WjBWZ1MvWWYvMUJOVzVubXRwK08rcHAyM2hNZzFJb3RNdXpBYUhVZXNxcGVD?=
 =?utf-8?B?RjJ5QTkyY1hXVU92KytJSDlNQkd0c2YrR1poZlJKakhWRitWOFltem94cytr?=
 =?utf-8?B?S3FabFpKeDEzcGlaT0RCWDE3Q2F6TFVwV3g4SzMzUW9TNFozRW5INmNaL0lq?=
 =?utf-8?B?TkVrTWxEcEZxaXBlamtkUCsrR1BQc1FQY2hYZmk2RTFFcTdtWFUwM1l5cGRT?=
 =?utf-8?B?dHhwV2poc2pHRU44R3k0NlAzNmJycUt6QWZ1RzdzTHdXTml1WUY1QzBOQ2Qw?=
 =?utf-8?B?ZDhzWUtOa3FTblN2NTNOZUdsZ3BSaVFvMWhJYlYxMHh5OE53UnVSYzZEVEtW?=
 =?utf-8?B?SVd4amUxdFVvTzBaL0JrMWh6Q2FwcUZnZ1FGVjFJNVRncW1Wd2R3eEpCbUx3?=
 =?utf-8?B?empMMktuaDJRM2ZJWENSSDN6SmJtbis3NFp0VWx0QmNSRDhBVW1YRVRDWjMw?=
 =?utf-8?B?UVJuUTA2bkhhOGk5MEV2MTBIVG5jT09vTlI1cngwMHBUa2hqbTJnRUpBenc1?=
 =?utf-8?Q?DNzV/6mXbTTjg5tMkT2gfxwNS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb993f21-4575-4ec6-433f-08db0e8512ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 12:14:51.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osuQ3lDF4aaHRhxESt+dpqYYVfR/cEHcmsKUxCXVz8flaqdWX/9ey7r70+K3tnJ3EQNBFLkLhC58EmIcGb7Lxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6921
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/02/2023 20:43, Marcelo Ricardo Leitner wrote:
> On Mon, Feb 13, 2023 at 06:13:34PM +0200, Paul Blakey wrote:
>>
>> On 10/02/2023 04:21, Marcelo Ricardo Leitner wrote:
>>> On Mon, Feb 06, 2023 at 07:43:57PM +0200, Paul Blakey wrote:
>>>> For drivers to support partial offload of a filter's action list,
>>>> add support for action miss to specify an action instance to
>>>> continue from in sw.
>>>>
>>>> CT action in particular can't be fully offloaded, as new connections
>>>> need to be handled in software. This imposes other limitations on
>>>> the actions that can be offloaded together with the CT action, such
>>>> as packet modifications.
>>>>
>>>> Assign each action on a filter's action list a unique miss_cookie
>>>> which drivers can then use to fill action_miss part of the tc skb
>>>> extension. On getting back this miss_cookie, find the action
>>>> instance with relevant cookie and continue classifying from there.
>>>>
>>>> Signed-off-by: Paul Blakey <paulb@nvidia.com>
>>>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
>>>> ---
>>>>   include/linux/skbuff.h     |   6 +-
>>>>   include/net/flow_offload.h |   1 +
>>>>   include/net/pkt_cls.h      |  34 +++---
>>>>   include/net/sch_generic.h  |   2 +
>>>>   net/openvswitch/flow.c     |   3 +-
>>>>   net/sched/act_api.c        |   2 +-
>>>>   net/sched/cls_api.c        | 213 +++++++++++++++++++++++++++++++++++--
>>>>   7 files changed, 234 insertions(+), 27 deletions(-)
>>>>
>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>>> index 1fa95b916342..9b9aa854068f 100644
>>>> --- a/include/linux/skbuff.h
>>>> +++ b/include/linux/skbuff.h
>>>> @@ -311,12 +311,16 @@ struct nf_bridge_info {
>>>>    * and read by ovs to recirc_id.
>>>>    */
>>>>   struct tc_skb_ext {
>>>> -	__u32 chain;
>>>> +	union {
>>>> +		u64 act_miss_cookie;
>>>> +		__u32 chain;
>>>> +	};
>>>>   	__u16 mru;
>>>>   	__u16 zone;
>>>>   	u8 post_ct:1;
>>>>   	u8 post_ct_snat:1;
>>>>   	u8 post_ct_dnat:1;
>>>> +	u8 act_miss:1; /* Set if act_miss_cookie is used */
>>>>   };
>>>>   #endif
>>>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>>>> index 0400a0ac8a29..88db7346eb7a 100644
>>>> --- a/include/net/flow_offload.h
>>>> +++ b/include/net/flow_offload.h
>>>> @@ -228,6 +228,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
>>>>   struct flow_action_entry {
>>>>   	enum flow_action_id		id;
>>>>   	u32				hw_index;
>>>> +	u64				miss_cookie;
>>> The per-action stats patchset is adding a cookie for the actions as
>>> well, and exactly on this struct:
>>>
>>> @@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
>>>   struct flow_action_entry {
>>>          enum flow_action_id             id;
>>>          u32                             hw_index;
>>> +       unsigned long                   act_cookie;
>>>          enum flow_action_hw_stats       hw_stats;
>>>          action_destr                    destructor;
>>>          void                            *destructor_priv;
>>>
>>> There, it is a simple value: the act pointer itself. Here, it is already more
>>> complex. Can them be merged into only one maybe?
>>> If not, perhaps act_cookie should be renamed to stats_cookie then.
>> I don't think it can be shared, actions can be shared between multiple
>> filters, while the miss cookie would be different for each used instance
>> (takes the filter in to account).
> Good point. So it would at best be a masked value that part A works
> for the miss here and part B for the stats, which is pretty much what
> the two cookies are giving, just without having to do bit gymnasics,
> yes.

act cookie is using 64 bits (to store the pointer and void a mapping), and I'm using at least

32bits, so there is not simple type that will contain both.

So I'll rename the act_cookie to stats_cookie once I rebase.


