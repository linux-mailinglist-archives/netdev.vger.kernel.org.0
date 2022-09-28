Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642E45EDFF4
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 17:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbiI1PUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 11:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbiI1PUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 11:20:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0E72A418
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 08:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYlkBIwx5+YQTkH5t97S22yUXTAFynhvIZktIGM8rvHjIX9AXjsVQj44OQOmkmgvRRbvMhCVxlibAiEnwddrgnjN3FqUVupUKn9+moNGCrpTyLF6HbBONr9A1l4G1F1AtEo64vNCC8lSLneYBLQ3xdBHCg97HSwW9mjwqRIw5MtyidhL9ee4tXd6pMKaGlucnOukkzblFpvmapi0NJVQsocOTJvWjGgEAOlc/haYyOMwKVPQMT1h2T8flpyftYYvkGHuKxBzvASO369enAhO8H08UowAsGGVevDPuyHXzmNpOO51mR9bELfhLWwHBjriprL7uSWunX8qyIcTnk0Ebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b8vMe6i1xLzCWBvchF6/vpdsgz/F+oGhnqYuqOqnUWE=;
 b=SrDJmr6qdXb8gvOvAIp6gHqqNwfA83Qmxh3DR0IUu83f0L183Fuodo/8Vi7C7DVdRH9nluP7ZoaMlW9J4b1a2LPD+7sAwf5hytlnYAsCN0QJehs5dHqCrLZN1yRh331uRe6CtjdQwxDq8/68M83cYJRMxZ650f3OZGCoJc7a6A8xk7ceUsJd7SHGvH52/ZwTTIiUhLi4Gc+Dx81XtFoQzNEIanhYT+dLZl8rEcikI9z2cgKVV3IyGaW/TkGQNC87Vp0EoaqDOKCQcz9Ut12oLPl8oDu7b/+VptBl2lmFY6l1IJm/2fCST4jd4qxPQYuEPG0l+2f4G4WNQ3jiWInjKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b8vMe6i1xLzCWBvchF6/vpdsgz/F+oGhnqYuqOqnUWE=;
 b=jzaDUSikFmO/BsqRiiRdyI09MbcsX4pVt7uEt8iW0/Hp5OLpIQ1k/paMJeaaxuQ/juwclhmTV2BO5Twd9SWG15MovgferQ6zRNkl5a680hl1Iw+LUiKLikLMuJ2W07mhcoTkwLAegpKPyE+M7Bi9MbVHNrKcvD+9pVEEhjZ+YP9psDlz5P5Ppp9wOQVQSWZZb5EiX001ZFnXa70PUeiAIKsir7BZ57xiYwcB4YWJGHp/Il45+ypnRpWLoM9v/tbFNquDz8J8lCnC3LXbf/PcjSzbZL5O2O0NEYWVcJnSkIpNPy89NMqpKmO8Lq6Mw/v8+PmMcJEI078btGbdPDEP5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Wed, 28 Sep 2022 15:20:04 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::8912:c51b:5164:603e]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::8912:c51b:5164:603e%12]) with mapi id 15.20.5676.017; Wed, 28 Sep
 2022 15:20:04 +0000
Message-ID: <a2928082-3764-3765-13cb-68be519f88f2@nvidia.com>
Date:   Wed, 28 Sep 2022 18:19:56 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [ RFC net-next 2/3] net: flow_offload: add action stats api
Content-Language: en-US
From:   Oz Shlomo <ozsh@nvidia.com>
To:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
 <20220816092338.12613-3-ozsh@nvidia.com>
 <8415607a-04b2-1640-1c01-5d2f94330917@gmail.com>
 <d45b0b59-485b-9fa5-b328-1a7991653b75@nvidia.com>
In-Reply-To: <d45b0b59-485b-9fa5-b328-1a7991653b75@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::7) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d6677f-cb65-4e40-ba34-08daa164eb48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k8mmfrGfr2zdFF0dXGVkjjQI70ujIInIXV6EPmxHn1DGS6yrClLzmJnBO/uikZwQTrsjICEoTunZ7ZCdbiE7A03Xc597OwuMK9NIcdcgc8ft03JmsNnPhkTIfS80rPbRRPl/EnaeL6NRlloGE8MVHcqhIORPnfta+EbnXI0kolICT+VMNhWoSxKuWakfQYuF0gKM0gwQjZvhcGRonkeIfFv/pOtDn3m/CynTJPmxHkJaO3tYDwkF3HESUkg5fbti4SseODUaSWZw/8CBk465T0FKYx+pyXPPYK1xEqzf/J87aNI1waPYxYpEwVdfO5+QKX1BeyKIMI6zqWdCXbxkeRhGUTI1Ml/spQUwaM0DtIGdGbSwwAxmmQ8q0SxVrm4pjoYnEhNECkXmSSRyFa2QOCYFwv65VeV+KKOYJMde4EVJCMFpbCRVAv8TM9F7MJMVRx3Cyp0I3Sr1rD7ycrFkX3hGTXJhV/sENGMeVTRRAnggUlUcaa7rVYKItCU0mvW1tbGJ6p8D2eZT0CvYrdH1RkzytppnJC2cCIrJNxx/B04VKDSHcYyIeHXJpcE2iUUuZOCG6CYdqxbJCrO9csLn4hr8zt8SiUAS1XGJUY3wmpIBGsIyoG6RP32V6llBqvpYscWczZX8llKslTzOefNeCoAIpIKAo6Hpq5mQtS/uHy8m+4Cn7MXmWGlUr26cuRizifcX37tac7m8hMTRlsIM4uqBfg9TelWgVXiQnc00T1QPQoJ3JUejnKSws2UMOFCaTrWxnDFanq30QC2vYYJq3PWh1Ej3chfHRME276PZdmzlcmc6HrzqU6ZP6udsjkPMzl8p0UOdp09PbxumRp+F7suQskDCElqy6zEru8bBefGWbqVLCr6llRwDOLV9AMddQnXF2RdVWU6ro3bO4edV/0QFVMzsuC0QnBNMB1FOH4U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199015)(36756003)(8676002)(66556008)(66476007)(4326008)(66946007)(186003)(2616005)(107886003)(6512007)(26005)(54906003)(316002)(6666004)(6506007)(86362001)(2906002)(31696002)(38100700002)(478600001)(53546011)(8936002)(31686004)(5660300002)(83380400001)(966005)(41300700001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1hrYzY2aE8wSkJLR2Y4aDlCNExHMldxZUZoR3VOQUErL2lUWjI5RUhuT1J0?=
 =?utf-8?B?Z080M0hzMUM0WHpOQ1F0NjZET090S1ZKWk9CNWdZOU04MEdzUmhPNW41bVo0?=
 =?utf-8?B?SG84N25EUERJaXlwK0hrdkZvRVQ0bDFZYStUMEszZ0hTejM3dGJpSXVldVFo?=
 =?utf-8?B?VG5CS2szNXAzTWJVUXgwZmxocFIvdUZWUXY5YzNqZUFIN1p3dUNuNjE1aGM3?=
 =?utf-8?B?Vy94QVJLRVBKUzJVcytsWTdDTzdpaGVvajR5VzJQOTBFSDg2Mlk1UW50M0tm?=
 =?utf-8?B?TjAxalcwanI5M2pkeEE1TS9oczVjUndLUWV6S0EzZEFuT2ZDQTdEbUhpMTk3?=
 =?utf-8?B?YmdFR0g1ZVZ3QTZwSXZlK2RPb3ZJK1dxZWpuNENrUnphcU1VbDVOQmloV1Fv?=
 =?utf-8?B?bnFGNkl6VFJaWWErYkxEWUlJeHpiS2NrWGlsSjJSV2xZOUF5YmJSR2NWVmV2?=
 =?utf-8?B?b3EvY0FnMlJzbGhXUm0rRXpsajZUSHkyeloxUzNJVjEwaUoyRWFITmJzMmM5?=
 =?utf-8?B?eENadkZGRzNGbjB2UFE1MDhwTUZKUTM5TGVheWV4TmFqSTcwTEZWTklnOEJ5?=
 =?utf-8?B?a0RZRmVRNmdmTmk4TmlyK0pGYklIK0doUGprNjFocllTYzBQckF6TzhPNk85?=
 =?utf-8?B?ZnhHeGhXaUNKcmFVNlRGQlV2TlA1NXNzRTJpU2pZSmoxRGtvdHduMlRLU1Ry?=
 =?utf-8?B?amR6bXZQazVxZDJHKzdoVjJvWWJtNVk4MjlwZVZCdEFKcEFQZ0xoT0FGbzVF?=
 =?utf-8?B?eCtLVzJZbVJXMkZ6MDhSVS9TcGZyTFIwMEtWMlJleUg1ME9Pdjk4Z0wrSDNL?=
 =?utf-8?B?TW1Qdi9BYkxpVWJWMlpXaTFibTJlTWJBSkFpblFZWFRrbTh6bjVyaEc2MWsz?=
 =?utf-8?B?d0Z0ZWhMUE5jWFlGYitqM0ZsUkpYTnNHUjhwM1VWc01vSkZKVjB4empFMFQv?=
 =?utf-8?B?Y2RPT2pPOG4wb2RrQlNYYk1kWUUyM1BkcnVhb09EdWk1bnZZVXJiSmM5ZWRw?=
 =?utf-8?B?SllZakRnbUJnLzhXSVBOcWJZbjd0c3VJZmhkYVVmKzhNQm0vNDVxeGhYVnN3?=
 =?utf-8?B?eUx0ck5TellEOGZuM2hDeFNCYTd3KzlaZTMvNVVZcDZ6SUhJdHJvd1gxaTcz?=
 =?utf-8?B?b1N4cGNZdFMrZ3o5RFFRT0YwaGVueHVUVllqYnNvNjF6YVFyT1lmRy9yK2xz?=
 =?utf-8?B?Wi8xMzlEaVp4NjNDM1R5bXY3YUtlOXB5RFdZWlI0eTRjNEpTMWJzLzN6MWxt?=
 =?utf-8?B?UnhDUTBNVnJSZDJIclh2VE5DVnlxdGxUb2VMcERacHF3dTVxSmpzdXB3cHpx?=
 =?utf-8?B?RERuVk5EY2IwYmlHTG02VE9wWHQ0V3pLVkFTMkZQL1lVL29ja21iV1BmWlZT?=
 =?utf-8?B?V2NSZEtZZlV6RVdEZWRBMkpQbUsxZ0k2NElXY1cwSFA2UzY0eDZ6RUFGQVZB?=
 =?utf-8?B?ZXdHYTgwT2h3WXZ4VWdlVkJMb1FRYnR6KzlZcmpwalJLS3VtWVdZYU04dEFx?=
 =?utf-8?B?UUZSVFFSME5NdjBHSHhBNm5qRUJkcTdLMVJ2aHNPa1JoQlhkRzlQZjRzUjFz?=
 =?utf-8?B?K21BcFlYNmJ1VXpXQ0tBVzNQZ09Rc3dVUXJsR1pWQ3RmVGF1eitoaVlEMWtH?=
 =?utf-8?B?WnMxOXozdDlRYi9hSVhsNDNIWFpDNERGajNZZmppUFIyR0s4Zm1rRWFiSlR4?=
 =?utf-8?B?cXVRYVFBN3R6MEJ5WXlLVGtaZFhNckUxOGNjK3NmNjBwTkVGUnA4Tm10Tm1S?=
 =?utf-8?B?cmgrMGhSTFQzWS9oTW5PYTRubUYrRWtQM1pWUnk1YW92eFFiV2hXcDdnNkRS?=
 =?utf-8?B?VndSMTdoNkE4WWJ5RkZqenVhekVSQ3JzWFZZTWticzJaY0ZGQzNUMUltOENW?=
 =?utf-8?B?NlBreUNMY0FrT0RaOTZBcjEweVhhWnM5ZXRTallON1BLeFIzZGJJZTgzcWZ6?=
 =?utf-8?B?YTZjd2NOUCsxR1lWdFNDa3lvRUt0NU9JWFB4WW01VzVEWHBrdWtBRVpQSjJV?=
 =?utf-8?B?c0Q5TjVlNXFSekJ4R2VqT1RmeGJKVEhXUzI5cTBnWUxIT2lqbHBTUFFYRnh1?=
 =?utf-8?B?NDJNcXRxelFBaS9FQ1ZkYnI3RENGdDc0c1VaN1RFckdmMmMvVjVQUDJWNTcw?=
 =?utf-8?Q?diGPsvuworLobGyJxBFTxcTOp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d6677f-cb65-4e40-ba34-08daa164eb48
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 15:20:04.5372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDST/lFhrBGCVS+NhnYfbC0BtlTmFjROFCXroGyn1UOIT/mbTX9oVTb9s8Gj72vU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hן Edward,

On 8/17/2022 5:43 PM, Oz Shlomo wrote:
> Hi Edward,
> 
> On 8/16/2022 4:42 PM, Edward Cree wrote:
>> On 16/08/2022 10:23, Oz Shlomo wrote:
>>> The current offload api provides visibility to flow hw stats.
>>> This works as long as the flow stats values apply to all the flow's
>>> actions. However, this assumption breaks when an action, such as police,
>>> decides to drop or jump over other actions.
>>>
>>> Extend the flow_offload api to return stat record per action instance.
>>> Use the per action stats value, if available, when updating the action
>>> instance counters.
>>>
>>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>>
>> When I worked on this before I tried with a similar "array of action
>>   stats" API [1], but after some discussion it seemed cleaner to have
>>   a "get stats for one single action" callback [2] which then could
>>   be called in a loop for filter dumps but also called singly for
>>   action dumps (RTM_GETACTION).  I recommend this approach to your
>>   consideration.
>>
>> [1]: 
>> https://lore.kernel.org/all/9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com/ 
>>
>> [2]: 
>> https://lore.kernel.org/all/a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com/ 
>>
>>
> 
> The recent hw_actions infrastructure provides the platform for updating 
> stats per action.
> However, the platform does introduce performance penalties as it invokes 
> a driver api method call per action (compared to the current single api 
> call). It also requires the driver to lookup the specific action counter 
> - requiring more processing compared to the current flow cookie lookup.
> Further more, the current single stats per filter (rather than per 
> action) design only breaks when using branching actions (e.g. police), 
> which probably applies to a small subset of the rules.
> 
> This series proposes two apis:
> 1. High performance api for filter dump update (ovs triggers a dump per 
> rule per second) - extending the current api providing the driver an 
> option to update stats per action, if required.
> 2. Re-use the hw_actions api for tc action list update (see patch #3)
> 

I tried implementing the per action stats using the hw_action api.
The api proved itself well.
However, it is extremely inefficient to allocate a counter per action in
hardware. As such, the driver is required to lookup the action's counter
(hashtable lookup) and also update all the other action stats hanging on
this hw counter (requiring list iteration and locks).
This introduces quite a complex design with performance overheads.

Stats update is performance sensitive as ovs queries the filters' stats
every second.
Supporting tc action stats api will degrade the performance for existing
use cases.
Extending the existing flow_offload api will preserve the current
functionality (single flow stat which applies to all the actions) and
performance while providing the ability to specify per action stats for
use cases involving branching actions.
In the future we could add driver support for returning a per action
stats using the current hw_action api.
WDYT?

>>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>>> index 7da3337c4356..7dc8a62796b5 100644
>>> --- a/net/sched/cls_flower.c
>>> +++ b/net/sched/cls_flower.c
>>> @@ -499,7 +499,9 @@ static void fl_hw_update_stats(struct tcf_proto 
>>> *tp, struct cls_fl_filter *f,
>>>       tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>>>                rtnl_held);
>>> -    tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
>>> +    tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, 
>>> cls_flower.act_stats);
>>> +
>>> +    kfree(cls_flower.act_stats);
>>>   }
>>
>> Perhaps I'm being dumb, but I don't see this being allocated
>>   anywhere.  Is the driver supposed to be responsible for doing so?
>>   That seems inelegant.
> 
> You are right, the intention is for the driver to allocate the array and 
> for the calling method to free it.
> 
> While the proposed design is indeed inelegant, it is efficient compared 
> to the possible other alternatives:
> 1. Dynamically allocated stats array - this will introduce an alloc/free 
> calls per stats query (1 / filter/ second), even if per action stats is 
> not required.
> 2. Static action stats array - this has size issues, as this api is 
> shared for both tc and nft. Perhaps we can use a hard coded size and 
> return an error if the actual counter array size is larger.
> 
> 

I realized that we cannot assume a 1:1 mapping between tc action and its
corresponding offload action as tc pedit action can create an array of
flow offload actions.
I will fix this in v2.

>>
>> -ed
