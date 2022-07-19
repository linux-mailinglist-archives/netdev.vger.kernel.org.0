Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1AF57965E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 11:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbiGSJdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 05:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236710AbiGSJdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 05:33:07 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2061.outbound.protection.outlook.com [40.107.96.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E6E21E23
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:33:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mreUikQYPtVhrnhq2Pctx5c4gOzuEKSCx02OjNFo/Edws+EKbf+SJNwYkPiy7h+je77/JcSf1qMVoaKd9DXR6OLeZl2c7ZAncBFCyVlKq5VAiFVKln79GB26UmaS5mXgbmWR9OUXv/6P/Sb8gjgzBHMCcwqoma/FT8SUyqcv60ZcsXvCE4WIW32yxCFpSsNGVdRc/iO/sZ9kkrMjXsM2PRcyxrvspcetes9L5dfPrYlvbdWTF9Em4Ik8RHc0sfZFgDm0FizCSC2IH0DkOSlw9uyWjwmxXThQx3s4G1yXRqBG/uejDKnBlB5AeBPsK8yChV/0alZFk7+k3AxbT0qt2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=183WgkDpLzkLD+Geh3YPoCGdCw8ymPy1zkckEGUQdEY=;
 b=BnVHTSR00RyKmYhvdgaA0HrxIKaYLR4rxFrLgJX2f5uudLbhtDFps1SZdJboXhkGxWuMRUgpcE7zxQ1t7ATi/u3vk37yM98Sl7PN0lpBCugqLbatGxBSCRjERP7WiDbHHe2S4WNH4NCNA4NvJ5zAy75NxQquLXcXz3hqclAURErrHhPBPe36ZoY46JAa7amj40eFGv680Qt9tlqGGbOzMlgf1BdmUeaSG1mmmI4eKp324sqHR3crHknuTPiUd5Pw3RKFYPE/t/m1YNtjTFs2r0kd2JnDcUXjzh8BRBb9He5Rn5iq1FaSJmU/8v9kkkBoDZAc/kTqWsiMrr2IXt3KlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=183WgkDpLzkLD+Geh3YPoCGdCw8ymPy1zkckEGUQdEY=;
 b=lMGj1Grr9mgsgDnVIIxE/ak12WNhddR3gtKP/SE/quuuBL0CGga9ho4QMvAprsLBmtNxKamHlFn3u5ImCmqe9r8/x78EZCjc2kMQ19J4fBKZ3ItvTerE3fygEtpXxe805HT1OQ/cJ3eF/SuxMbWQDcCeYtjSrmlysmhALFLcJf+NQabLfEZ12CmlXqmEwCitYTyrNp8yh6hJOlhMPMc6f3CC8CHMWS7+80fndFo0+2EXCsKLT/k4vFCPSBElmXpUU+w9CQfgv2RVyCyw7HrezBuISW1xYyETmwSSB/aknZhTL5DheQB3AEM8SPT3kpXcmtILsli0AS1nXMe6S3MXHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 PH7PR12MB6492.namprd12.prod.outlook.com (2603:10b6:510:1f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 09:33:05 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::1075:9d96:7eaa:3f9f%4]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 09:33:05 +0000
Message-ID: <a3c4a135-672f-0f66-271c-a6071aca7c89@nvidia.com>
Date:   Tue, 19 Jul 2022 12:32:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net/sched: cls_api: Fix flow action initialization
Content-Language: en-US
To:     Baowen Zheng <baowen.zheng@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Roi Dayan <roid@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20220717082532.25802-1-ozsh@nvidia.com>
 <DM5PR1301MB2172BA76D9BAEADF9A40D11CE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <6230396c-afef-c110-3432-d212d2bd77c9@nvidia.com>
 <DM5PR1301MB21727F4E19924E41FCE39790E78F9@DM5PR1301MB2172.namprd13.prod.outlook.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <DM5PR1301MB21727F4E19924E41FCE39790E78F9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0336.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::17) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 958a9adb-a14d-4642-9b26-08da6969aeb9
X-MS-TrafficTypeDiagnostic: PH7PR12MB6492:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4kh3lwJwJyZAo8x4nWBZSojBhWeiIxnRFkO2mhp04EkI4YkBhGwlev4OvEe2jo+M8jvSTxHs8mye9rVREO+zaWSmmf/Q/0lkE+64aesH81uWbW20iu7II7vnasqFqYGjWnKEXdREizoKToJVWEv6Ff6guIYCRyqrBhUcRBToDRPXljEwRB3qnnnDzQS+epe/OIDxqOG8wlpyRvggt0RQDUng1WYYdu70oR/hU9OOST3gU5Hc9nHJu9OkO+goZF0r2ZoIA1u0PtDz/fcSF+DwBn9yLkGJujUaBRplOzGVHrXBEjDMJk4UYHjihvQqTbL+NYwc5Y7A6vUGmGEhm8Rlbjm/5kTxYW0TIvqtrUywy+gmejEcXDM+7+eQ/xvOCNoj7u72ESuWqj+YH8SKf6hHJ4PG8JQC+ROk8qZdese3Hcebm/sdBEZWHvH3+pFBFfEqbAI6Wi2n7FPKwK2rTenOGeeBSrgVUsw4/RSX0ZWrEeH3NkMHJzo/9K0PJkXo7lF0O9JQWuKwDa1CGbk6fZT/RL6f6WqbyAMq3l+IbjMatjCOGeL0U06TKNYQbHGwQqh9Kp2o+WJFEzX9x+GecLnkmdymdX+/guKliNTcAZmncVaz8u9QbMHdgAiR/mWuym1laH5UE28OMiC6dH6A359HmdDgJX0Pvdh1WditgRNAtVwcIGfMnKxSpt/fCYH41yoVq2+qIY6K63FaGMCRoq/FtnRz8gTCesWC+Hdr7Brm2MzcxUNdCs5A8fmlYO9Ey/7sUR+cZYoT2sMLxoTW3FeT/wjw12Js8wkWNH25jaaEq7omhJCQw7+Rw9HrjYpqkSBG6PqqgTpcaKgHPrBBd6CoPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(54906003)(110136005)(6666004)(41300700001)(6506007)(6512007)(38100700002)(26005)(478600001)(6486002)(53546011)(2906002)(66476007)(8936002)(8676002)(66556008)(66946007)(2616005)(316002)(4326008)(5660300002)(31686004)(31696002)(36756003)(83380400001)(86362001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXNiSEdqNjdTR3B6QWYrVHBNby9KUm5XYkx6Rnd6WkdjWjlpOHFyRlZId1JI?=
 =?utf-8?B?NWRWallvVXFuUkplV1lPM0RDOVJVcERDQ1RxeFdnQkl5bFNndnAwWWpZTTdx?=
 =?utf-8?B?cDV4c2JNNlhjU0llWWkwNFdLeStvUHpDbTNiSnB4R1RvWFlpYnZDdDNmSUdi?=
 =?utf-8?B?K3oyNVpNZnRrdXJvZjlVNmtrQ0ZJVE9WaXlaSHgxVmdNOGFPSHNFbDlGQ3Fq?=
 =?utf-8?B?aEMwSlRiL1NITWVVRzk5QWNneG9DdEFEeVJlM2FpWlExRUZqeHhOT0lGVkJ3?=
 =?utf-8?B?SDZpbHk0Q09jU3Nac0Q1TE15b2puWHR6VzZjb1FydW5XcG5oR0RBZXRnWDdW?=
 =?utf-8?B?ZDdUNGVDRzBoUnc0bmZ4VldFV0hROEpXdFh0eGtzMEtrNHlwclBaYTc1cm54?=
 =?utf-8?B?ODg5aDZyWU92ZG5ZZ2pjeXFhQkdGSzRwVkJ3cUZhSFE0WTNmWWVSd0hCR2Nz?=
 =?utf-8?B?Rmx1QUNsNWt2b25yZWlrK3QrZTExZVBCNit1TXFkZ0paY2JUa01kWHpzS3lK?=
 =?utf-8?B?aDVQRWNOd1FQZ0hwdnExaTRRSjFDNW1vbDRoMHdpK1JCWk9yeFA4RlU0U2tq?=
 =?utf-8?B?bllBZ3ZKSWNYWmE3REpMNEJqU0drUndUaDhHWkxGS20vcFFNSXlIandBWFRz?=
 =?utf-8?B?SEM3Q1hlNXdWUUNYdGtQejlFVEJYSzFxamNMVDh5a3VxcWlhNUJzQjk5eERy?=
 =?utf-8?B?SnFqV1J3NG53WTBCTGw2ZURxbGJNV3VHTnBqVElHbUozRzlVaEJUcWlsR1N2?=
 =?utf-8?B?MGpwLzZaQmE2cjdhRldqU3dsTVdWZC81Z0w3cWFSdHp0bGxZVlRvSldKNEFa?=
 =?utf-8?B?Vnlibkh0Ym95QnZrZUZpUWZSNkpIamFZK1BJUDBaMHhUcWR5a2NWck1wQTI2?=
 =?utf-8?B?cHBxNEo0ZjdiYVQ2aVhQNXoycnBkOWgwUDBkZGF0QnRlTmdjOGl0cms0ZEdM?=
 =?utf-8?B?SG42aUpONHdwUFQ5SUhYUFhFMkN2VTZaZjFsNTR3NnBOcVNjV1VxelZmQ2FU?=
 =?utf-8?B?TnEzd2VqSVBQYTNsQXZPQzJKZk9Ja2VIWXNyb0ZqZm1Ob0J6dmtkQzlvTSt4?=
 =?utf-8?B?ckNRU3ZnYlhaK0pPZWEzNk9kY1JIYW5RNHFwZnNYc0dJa0QzNk5zaFp4djYw?=
 =?utf-8?B?d0tuank5RDBIUExRUmdjT1V1SnhjQlFQOFBqZXJzQktOdFFnWENxb2ZHd0Ux?=
 =?utf-8?B?QmluaTF5MGFCU21IWml6NUt5Y0lPVEl4L0lCSFZoWDIyQ25xUHlCczZoRVha?=
 =?utf-8?B?T2hEQSt1c0s1aWpFRWh0SzN1UURTQ0toOHVlWUljL3BlSkgwVFNJbkFGamRB?=
 =?utf-8?B?L3I0U0tQOVFWYnZrdlRaY1dKYmdQUzJRamNUQkwxZ0R5MXo4NUFKK3lQVGJO?=
 =?utf-8?B?L3MyNzlIQkRyS2RWS2VUYjZrVFdYcnpBS2FYK1c0SndnT0ZTRnJ2L0RRQld2?=
 =?utf-8?B?ZUtXWHA5MjNtTEtraGgxb3VXV3lxZGtrcHBEcEUzelJoZ1k2bXFDS0tOcWcx?=
 =?utf-8?B?TU9VakZiMXBXRFkyRkt1bm02blYxN2xjSnlmcC9UTzhLeGhTWFR1UTlnSW1n?=
 =?utf-8?B?cGQ5VGM3WWduK2xSUzljSW4ramNnVjVBZmVud051VElCbVdtdXNaemRGVExC?=
 =?utf-8?B?UVZrWGd3MWhaMFZyQmErMXpGakhVbmIwTFZyYWF4c3JkbkYyc1Y3U2hnakdj?=
 =?utf-8?B?WkRETVA5K3FsTk9aZlFKSmt3aEQ0TjdGaHVSUHJQaE1LdjJ0WWRpTGpnQURU?=
 =?utf-8?B?d21MU09mNDFJVlRFMjlpU0ZtUGtpL1JoYmJtK3N0OFVQTUlNZSs2SEYrZjQ5?=
 =?utf-8?B?My9pOWdtdkdOWS9aM0xaRWlvVW9lUWtUVjBXd2RQOWg3SXpHQlY1M0p2NlR2?=
 =?utf-8?B?NER1ZjVXS25IYmpLVG0yZkpkWEZqR0lzNlNUaytnTTJ2dGwvQ0FuVTFQazNL?=
 =?utf-8?B?SFB5QmxDUzRYQlc1cjJJWFlCelkrdDVtT1ovZC9iY3BHcnJ3Qkw4TzNEbkF2?=
 =?utf-8?B?N1RvU0w1OWxVZWpHbHkrcnhJUTBld2pxRG9weTJySnE3QVNZUUY0YUR3N1dt?=
 =?utf-8?B?YWkwMlBJckV4UkFCTzY2a0NQcm5DbFU3Z3R4ckx0VCt5ekVjbXlUSU4wcjhN?=
 =?utf-8?Q?kSNSYpVQ+NUQ70E1cRIFU/IZ/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958a9adb-a14d-4642-9b26-08da6969aeb9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 09:33:05.3197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxwQXmEwdYJP+RUHqctWV0jA2ev7FFJXDyllR6H/xO5luN1t77WtwoN/W9QwFAUf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6492
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baowen,

On 7/19/2022 4:30 AM, Baowen Zheng wrote:
> Hi Oz:
> On July 18, 2022 8:29 PM, Oz Shlomo wrote:
>> On 7/18/2022 4:40 AM, Baowen Zheng wrote:
>>> On Sunday, July 17, 2022 4:26 PM, Oz Shlomo wrote:
>>>> Subject: [PATCH net] net/sched: cls_api: Fix flow action
>>>> initialization
>>>>
>>>> The cited commit refactored the flow action initialization sequence
>>>> to use an interface method when translating tc action instances to flow
>> offload objects.
>>>> The refactored version skips the initialization of the generic flow
>>>> action attributes for tc actions, such as pedit, that allocate more
>>>> than one offload entry. This can cause potential issues for drivers mapping
>> flow action ids.
>>>>
>>>> Populate the generic flow action fields for all the flow action entries.
>>>>
>>>> Fixes: c54e1d920f04 ("flow_offload: add ops to tc_action_ops for flow
>>>> action
>>>> setup")
>>>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>>>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>>>> ---
>>>> net/sched/cls_api.c | 17 +++++++++++++----
>>>> 1 file changed, 13 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c index
>>>> 9bb4d3dcc994..d07c04096560 100644
>>>> --- a/net/sched/cls_api.c
>>>> +++ b/net/sched/cls_api.c
>>>> @@ -3533,7 +3533,7 @@ int tc_setup_action(struct flow_action
>> *flow_action,
>>>> 		    struct tc_action *actions[],
>>>> 		    struct netlink_ext_ack *extack) {
>>>> -	int i, j, index, err = 0;
>>>> +	int i, j, k, index, err = 0;
>>>> 	struct tc_action *act;
>>>>
>>>> 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY !=
>> FLOW_ACTION_HW_STATS_ANY); @@
>>>> -3557,10 +3557,19 @@ int tc_setup_action(struct flow_action
>>>> *flow_action,
>>>> 		entry->hw_index = act->tcfa_index;
>>>> 		index = 0;
>>>> 		err = tc_setup_offload_act(act, entry, &index, extack);
>>>> -		if (!err)
>>>> -			j += index;
>>>> -		else
>>>> +		if (err)
>>>> 			goto err_out_locked;
>>>> +
>>>> +		/* initialize the generic parameters for actions that
>>>> +		 * allocate more than one offload entry per tc action
>>>> +		 */
>>>> +		for (k = 1; k < index ; k++) {
>>>> +			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
>>>> +			entry[k].hw_index = act->tcfa_index;
>>> Thanks Oz for bringing this change to us, I think it makes sense for us when
>> the pedit action is offloaded as a single action.
>>> Just a tiny advice for your reference, maybe we can start assignment from k
>> = 0 and delete the first entry assignment above, then we will put all the
>> general assignment in this loop, it will be more clean, WDYT?
>>
>> If we do that then the hw_stats and hw_index parameters will not be
>> available to the offload_act_setup method.
>> AFAIU no tc action actually uses these values (so possibly no
>> regression) but perhaps it is better to leave them initialized.
> thanks for clarify about this, for the use of hw_index and hw_stats in tc_setup_offload_act, since we pass the act to function, I think we can get parameters from act if they are needed.
> What is your opinion?

I agree.
I will send v2.

>>
>>
>>
>>>> +		}
>>>> +
>>>> +		j += index;
>>>> +
>>>> 		spin_unlock_bh(&act->tcfa_lock);
>>>> 	}
>>>>
>>>> --
>>>> 1.8.3.1
>>>
