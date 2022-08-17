Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6005971A5
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240274AbiHQOnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbiHQOnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:43:17 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526AEB0C
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 07:43:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bI91XXGRoijfgkhhZxfyP4qz+YVkQ1IAIpI0uSuRCHLTNYqQzWh5xKxkxZebnhkG6VWkU2/4QOUxxI9wUeqeo6rgBPrpVIjA6AN9eYBYMqE5B6wGKiLG1pKsrWLLsXsbrLbgbwA5aJAz+Dtv43tEC/DBf//JFPL0cKXbf2/AFDBuzgiIQKXZ69sGb+89tCxlxerMz1xScdoj66Hizqz029QwVBXoCTcBe1hfAIHdK/tHPxRXr+SLvUInYB+jeV75MwyvVrr5G7N8mEHTkZHjS5z10DKRt4AY05RVCEf7Pzd5/an1Q+a6sJLvpL/HPhxGv0JhK0h4/+9zvdBuVdrOrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J6n9rsDtTjphDpGW8ET+i6x9z7f2sD03j9DNLAH7b4Q=;
 b=kbn3+nDVbUXIbrvz3b+CgT2QpJnwr9XAb35VauvtQZQ7NFs5G154q70zSjcdSl7IKuQ9dUoTRz6ErfBb7wV6+JkgqpzGINCd4nHTJBMoDnlNGMisX4ZZ5X5K1awE2wREuNP3m9BTQGrymzODPeCCRskB8pvnXpzzdPYoXL9GiHPwjCJC5+D8sa8l17CqXozLIEt+ZGp3aCQ1SFA80jRQkrCUFE+gnK3grrAtRU/3c6cTCT3iImlc4zK4D3AWATve26iZqHT48QkYUVyjrE5ni48djjKAphgqssJmlvtpEROtp3ujzZi5L4ZCAh6xQGQ1LyUZOExzaNAY2FR6U94A1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6n9rsDtTjphDpGW8ET+i6x9z7f2sD03j9DNLAH7b4Q=;
 b=ezfmJe5Lq+y/tbX9N21jsElCOv2/iN0wUQlRjRZKJ1HWjeOWrW2aSU0+P3YEi+RUekWqdEc5xRlT5xDRzCPyUYBpELKOqBm2t6wnMdEBCv2LXEXwz28NN19HZClwCfvAoRijl3Q51k1bHxhHDGglVVEOHArVtARtPFsdeTjoSZxHFlfCipduNAX5IvG+QWaYK3XA+rj7M75/uSnZOR3Ds7b3msPCbYgmUM5eT1/RovniXJYDDelPZCpewCH5ApW+8ngv+rZPLidqoZKC1QkQB38XeM4Xl0NhlaqhgY3c3/PQHIyJkcMb9s4Cd9YDP3kcG/Twv/ujuTLDPm4hUMng+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 CY4PR12MB1141.namprd12.prod.outlook.com (2603:10b6:903:44::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.19; Wed, 17 Aug 2022 14:43:11 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::a46b:2fd0:ed07:ed7e]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::a46b:2fd0:ed07:ed7e%3]) with mapi id 15.20.5525.019; Wed, 17 Aug 2022
 14:43:11 +0000
Message-ID: <d45b0b59-485b-9fa5-b328-1a7991653b75@nvidia.com>
Date:   Wed, 17 Aug 2022 17:43:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
From:   Oz Shlomo <ozsh@nvidia.com>
Subject: Re: [ RFC net-next 2/3] net: flow_offload: add action stats api
To:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
 <20220816092338.12613-3-ozsh@nvidia.com>
 <8415607a-04b2-1640-1c01-5d2f94330917@gmail.com>
Content-Language: en-US
In-Reply-To: <8415607a-04b2-1640-1c01-5d2f94330917@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1PR07CA0207.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::31) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e53d236e-64db-4ca1-1069-08da805eceef
X-MS-TrafficTypeDiagnostic: CY4PR12MB1141:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a213aVh4Uk1BOWlsN3FDMkhSU0I2Q094c3Vyb2xNVk1WZGthKzJFQ1B5WlF4?=
 =?utf-8?B?NVEwWlNXeHJpM1ZYMkNBdFh1eFVFczNoMTVMaTdBamlBWXpnVXJwbHZJeWRH?=
 =?utf-8?B?d2xLT0h1akRJdU81cFVDcEU2ZWZoQUlYaTQxVjJRTnJuaVR0RXBhWVY2TDBB?=
 =?utf-8?B?M0ZGOG9udlRTdlllQUYzdnhhZ3VhMFk5S0FNOFMzdVdyL2FQT3oxSjRKU0Fo?=
 =?utf-8?B?ZllOLzVmUUw3V3lOLzhEMjdHVzhzZ3lud2VGbGMzRGhhSXFCcCtCN0hpVXlI?=
 =?utf-8?B?R05lVll0dDRuc3A2ZFcva1dNRkFORHJMY00vV2ZneEJMU3JDQ1AwKzY2ZXpX?=
 =?utf-8?B?WnFXV0Vxa2xodFc5TXcwNElra1ZQd2xnd01HTHB5WFM0eVl1eHU3UXBVNVk3?=
 =?utf-8?B?UjlvQzV1bGIwS09XWmZkRFcwUUZpSEZzWW10bTZhNitRbDFwaGRUMk9BalJi?=
 =?utf-8?B?bjhiM2JJNmhDK29rcUdSNzN4UDVVQU1qV0wwamgxcFpOUTBtRjlhNEt2anhN?=
 =?utf-8?B?MGJTTDZ4TmV1b2NVSHpaa3hkRDh2elRrQTNUU1VNamUzK0xSWk9qdVUvdU93?=
 =?utf-8?B?bi9DLzgvaGJYUWtPai9mWmRkRHpUQUltekpzekprdXhpcTlQSUJGNVptM1dF?=
 =?utf-8?B?bDlTNDV5SzhITXM5a3hENTBvVkcvU2lSc2lJdTJRRmN2eW1jUWdVUGJUUzRT?=
 =?utf-8?B?ejdnTmhWNzJOMWtNbTB5SmVDV29Pd0lWTFNyNHFOdUVVbjlkOUZJUU1uVzJ4?=
 =?utf-8?B?WVVFYWdjWnppUzdLOXlZQXpSV1RzMkI3LzFPZ1EyTXBQZkxRRkJSd2ZBd29H?=
 =?utf-8?B?RzluU2VZWjY5dTdXRkM1ZklBQStaazdOdit6Y1g4MVd0Y2FhVUhjMS90b2lS?=
 =?utf-8?B?ZUkvNG5OUFhjQmR6dXBsTGg5c2dUbUtEc1JxWHVvcU0wZy9FcDdkbGg5QWpH?=
 =?utf-8?B?VUQyOHFDWEc0NHJ3R2xoc1FpR3g3emswQVpudTZMdGNlOFAxRU84YUlmNlQr?=
 =?utf-8?B?RWZ5MUFxdTFMT0Z2dHZwRmNLREEvQldBVTFpcXpwTE1PQkczV3ZXTCtWcitx?=
 =?utf-8?B?aDM4NDBGMVNpR2R0VU5aQ2gwckZ3bFptZHlQNVlvaUZEZWp0Z3FWdnVwMDBj?=
 =?utf-8?B?Yk92N2FMVndPQll0Qk91UzZPR0c5OUpyNmU1SzhqcVpNSEZTWm81L25nQ3py?=
 =?utf-8?B?Vk9vZUVxaklGQ2p1UWwwUmlKU3pFK1lsanZwWHl1dHlqMHJkQXZZWTR4VU5i?=
 =?utf-8?B?eDlkUnkreGh4NndTMk1FTFRYSkxmOGpXZ1l0KzN6THM3RjlxUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(2616005)(186003)(107886003)(83380400001)(38100700002)(5660300002)(8936002)(4326008)(66946007)(66556008)(36756003)(8676002)(66476007)(2906002)(478600001)(6486002)(966005)(6666004)(6512007)(6506007)(53546011)(41300700001)(26005)(316002)(54906003)(31686004)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUFIeC9GNnhJN0pWZTBvTFNJK1QwanFSUU5ta3FCamRFWUZReXFJV010aS91?=
 =?utf-8?B?T3RDb0hWa3ZSSTJVSmg3anVwTnFKcEtIOVVrLzFhUkcxK1hJd1F0ZkNEK20x?=
 =?utf-8?B?a1ptaDdRbndDU3MyR1dKdVd5SnRkSWF5M1gvdUpFbC9OYjMzeEs3RnpKditk?=
 =?utf-8?B?OWVCSzdOdWxBK2NpV2k0UWwremJpaVhsQ3VVUGdZaG5WRitIM3lMckNJRUZT?=
 =?utf-8?B?SmlKSExkTnk4Sko2V3F0UXlOR1hwRXYyeXdoU1hIaGIxekpya3BYZlFNaVZP?=
 =?utf-8?B?UHNKekhVS3RLeVZCdWRWVzh0S3NjWktyYVRpNUJEWlIvSmtmTUpYODRQRWxQ?=
 =?utf-8?B?MWtzTlBKaEk0NC81anlMUkxwcG9pR2V0TU1HcldCVTFoV1hnTk15OU9ZWmc4?=
 =?utf-8?B?bEw5L2RwM0UzNVRhS1JQY3Rlb0NQSVErNTg4bzJYb2JRN1k4c2xPZFkxR00w?=
 =?utf-8?B?S1luVk1tanR3blV4N3JvTDVDU1Y0N0t5K3dGZkNmalJXSGZLVDRPNnV2WVM1?=
 =?utf-8?B?ZXhtdzNpUU5VYzdkWGZkUUhSaGMwSXdqaUZ3U0M1bGszSTVoVUVZQlNENGFs?=
 =?utf-8?B?cW5YbHJkaHJiVjU2RXFlT0FrMXRPdmF3VGN6VmdueGtGM2NoTEFlbEtGU3Bn?=
 =?utf-8?B?eGFjSGxNR2poSHRMa2RkZ0RMRzYwa2VyR09iVERqWHBaUG91MEJDTUl3b3Z2?=
 =?utf-8?B?MkZnTWVwRmtRVGR0TU1BTkM3VExubnJrME1VTXd0aFJaOVQzTTRETnIrazY5?=
 =?utf-8?B?ZFFha0xReGF1RnlLYm8rU0hHY2kwaTlkRUQ3Qis4QTNqOU5ZS1BYbS81OGtD?=
 =?utf-8?B?TW9ZOTYxdjhRREZwRHlCWHBGQmUrMHorM3VEZzltRGFrMGl3b0IxeDZ0T2Y3?=
 =?utf-8?B?Y1luQStxYUhLcllMU1JqQ3QycmEwQ3E4UFJXeWcxM1IxNkZhWHNBekxLdkVa?=
 =?utf-8?B?ajBvZi9DZU93K1FpbXV2Tmh2bzd5T2dCZjNiYVBDWmNtNDJkOWt1V2RaT0xo?=
 =?utf-8?B?cjUwTjE3NVMxcHBUdGhNcE5sSmZTdVlrUklaS2lOalNIYkhBbHk4YWNaWkJE?=
 =?utf-8?B?bHJ0c0FwSFNZZE5Tb2JPT1VZS0Jrckw0RDM0SHYxTFNJQkdLSXAxcHc3c1Q1?=
 =?utf-8?B?ODhFZnlpdUNhVkNmSUJVNzhDK2pndVhLaktlYWtyZmlnS1JIUjhVNEJ0RGRV?=
 =?utf-8?B?SVFXV2pyNUpiS1dHUjR4bGdjUi91RnFSNXA4Tzc2MXhlWW5MeHZNcm1BK014?=
 =?utf-8?B?UnpleXZiRGhSRy9lYXhEcFBQb0RMRWMzeXpiVm5QNUF6TTFvaGtSb0pZREhp?=
 =?utf-8?B?c3FoVGdzcWI2VmtPM3FMQzJhV0lCUjlUYkVVVkczdlFUdHpLTERpbnFZNVJj?=
 =?utf-8?B?S1ZMUW8zRW1HMHFlM0hOQk9tMDVzb1BvOEFzZ2ZjM1RIMkE5MkVnT3pGbGhn?=
 =?utf-8?B?VzJONkxVbUt3S3JDWTJxcXRVSlBpQWh1YW40MXlJQjVGeHZldEtHaU5MNG94?=
 =?utf-8?B?TkZXVjl3YXVHM05WM3cxY3FlMCtFYXpDVEQwemplaUZFVkRPLytRRDBnREN6?=
 =?utf-8?B?Wk8yeWhXNVJNMG8vNWcydUZlaFpGU0tWTVdUenVURTJlN2hnQk1RWmgvczhk?=
 =?utf-8?B?TjVWdWhIK3pPbU1ER2dmblgzbUZUL3VlbnZTUlhLS3pPeDNubWJ6djZTOEtK?=
 =?utf-8?B?bkhXR0RLNmFoRG0yUzhjMTlrU1c0Q0ZhTkgvb3lvMml1a09XVEF1b2pVRkNY?=
 =?utf-8?B?aUlEdmJyNkIyZTVZZUZ3aUtEeXlCY25OcHVWVm0rTDVrMjV4enkwbnlKVGVZ?=
 =?utf-8?B?ZmhRL3NmUlBiblIwNGpPcE96dEJ4R3QwMXE1RVBmbk0vOU5OQmFpSjFhalFG?=
 =?utf-8?B?UW1EVUtEUkNZcGNyY3h1bG5oR0pCS3JjOFAwWkt6enU4OE4wdm5aSW80SDRM?=
 =?utf-8?B?NGwyQWJraVRGNTNVMTZvQXpVRnNlVnhqUkRSQWh0VlBIazBiUmxWdHB4ekl5?=
 =?utf-8?B?a0lWenhDdG4zMWZCTGI0aDloR0xrYlJrai9EZ3JHWWxsYnpZNm1FRjVGenZS?=
 =?utf-8?B?Y1h1dVlvK1g2VmZLem5iYUZDQ3crNFlkR09JamZUVk0reUhYOE5Ndlk3R2tN?=
 =?utf-8?Q?x7ck=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53d236e-64db-4ca1-1069-08da805eceef
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 14:43:11.6057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IlIn96hS5yZpfaGjnMdP8ZcUAds3v1l+vvulmkQAL80pirZQ//h4s1ENy0+9rgJV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1141
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Edward,

On 8/16/2022 4:42 PM, Edward Cree wrote:
> On 16/08/2022 10:23, Oz Shlomo wrote:
>> The current offload api provides visibility to flow hw stats.
>> This works as long as the flow stats values apply to all the flow's
>> actions. However, this assumption breaks when an action, such as police,
>> decides to drop or jump over other actions.
>>
>> Extend the flow_offload api to return stat record per action instance.
>> Use the per action stats value, if available, when updating the action
>> instance counters.
>>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> 
> When I worked on this before I tried with a similar "array of action
>   stats" API [1], but after some discussion it seemed cleaner to have
>   a "get stats for one single action" callback [2] which then could
>   be called in a loop for filter dumps but also called singly for
>   action dumps (RTM_GETACTION).  I recommend this approach to your
>   consideration.
> 
> [1]: https://lore.kernel.org/all/9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com/
> [2]: https://lore.kernel.org/all/a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com/
> 

The recent hw_actions infrastructure provides the platform for updating 
stats per action.
However, the platform does introduce performance penalties as it invokes 
a driver api method call per action (compared to the current single api 
call). It also requires the driver to lookup the specific action counter 
- requiring more processing compared to the current flow cookie lookup.
Further more, the current single stats per filter (rather than per 
action) design only breaks when using branching actions (e.g. police), 
which probably applies to a small subset of the rules.

This series proposes two apis:
1. High performance api for filter dump update (ovs triggers a dump per 
rule per second) - extending the current api providing the driver an 
option to update stats per action, if required.
2. Re-use the hw_actions api for tc action list update (see patch #3)

>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>> index 7da3337c4356..7dc8a62796b5 100644
>> --- a/net/sched/cls_flower.c
>> +++ b/net/sched/cls_flower.c
>> @@ -499,7 +499,9 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
>>   	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>>   			 rtnl_held);
>>   
>> -	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
>> +	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.act_stats);
>> +
>> +	kfree(cls_flower.act_stats);
>>   }
> 
> Perhaps I'm being dumb, but I don't see this being allocated
>   anywhere.  Is the driver supposed to be responsible for doing so?
>   That seems inelegant.

You are right, the intention is for the driver to allocate the array and 
for the calling method to free it.

While the proposed design is indeed inelegant, it is efficient compared 
to the possible other alternatives:
1. Dynamically allocated stats array - this will introduce an alloc/free 
calls per stats query (1 / filter/ second), even if per action stats is 
not required.
2. Static action stats array - this has size issues, as this api is 
shared for both tc and nft. Perhaps we can use a hard coded size and 
return an error if the actual counter array size is larger.


> 
> -ed
