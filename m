Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA5F687651
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 08:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjBBHV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 02:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjBBHV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 02:21:26 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173D942BEB
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 23:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJaP6/0MqzfYay/DLWgqdPTAqpHundac3mIM9RWRxW+lETewOF9u7BM9tB1zfVR1tZGg+Eu/skGB/y+s3L6/1VM4YpQmcumR4TCAdhjPvWHF5xJrReRxwK8Eeh6xiCMj6oEsFtEAGPDH/PxT3Vr6vQvmcCUVaGy0x4kK+lohkgwLbBe6uxWrIsTwKj7uzeXNSvlZcnLq1mtFv777Mppk1XvGgiwHiaW+lB54MauqRiMU4xpYopldRAt9hZ9PkvLZEJE4nlGsFHQEcrHR3XiSVY09p+m0/CKhqA4Olu6w0xPbnpxbtqP8NlPK2gpqvxZvXv4fTpHRpqjCLMGGr07npw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqAUGEFVG5lmFQDcp60lJGfQj9+jlFQw6zSBfHVFfRY=;
 b=Pe4+Xb1yw6KkWyAzfjcMiIT++IS3gmf7o0YHws7Jx0Qgb/uVTPQZ6HA7URa5X+hd5AtUpfE0LK+7fLS8LF5QOkX/sgjmLjBPlGhvSx5TNCuMK0AkfthXnOgzSwYFH6MoVjHVOwV87P+ssHu400dNWdlrG4cJdZk61AMVt9mRce+auEz4WBOxnn+QxpIHMt5ulPS5Tp8o6zwtgw3KtawUdggWx4qEaQcozvZHSFHjyqwSUJLNnUWBbttw1GnBR/z6krVC8OVwYhYU02ig54lL9LdMfwDjZ7M3vJiOdSFRIGjm364mFjMbQDAUFl7PeCJdCF8o7kn8i7i4gFCLc1aEaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqAUGEFVG5lmFQDcp60lJGfQj9+jlFQw6zSBfHVFfRY=;
 b=U54Z/AhwWlT4xauwu0u94tOfxBslUfNIPleYgtD0e/Usmpwj0KGaSopUsYVW1ekSMBxbn/lTtkB2lkuBpgGPGId7DmTLJ32naWCKi2IZ/QafEegA2r5K2BkI8GHxLRjCrnwP27/7hu1ENkgstWqFChFVnJnvK9SZkjPA4d74CxMZamLLpir8+P7OGK9xvgwbs2Hz0HzyPyAd+NGdgd0M554YqBO3j4Gk1nY93QxsLGQC/ZwWsEL27F53Q1rUD8xNK14tbVXHz6BZCXF9cRQBx//Hi18tDZ1rIn5F2pD1eJR56mjoMQR/WUTZvFLWBJvso8GXFOixHXDOUUWWEZcuhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 MN0PR12MB5715.namprd12.prod.outlook.com (2603:10b6:208:372::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23; Thu, 2 Feb
 2023 07:21:23 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518%10]) with mapi id 15.20.6064.024; Thu, 2 Feb 2023
 07:21:23 +0000
Message-ID: <cfbbbbbe-0a23-749f-f611-6d2438f797e4@nvidia.com>
Date:   Thu, 2 Feb 2023 09:21:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/9] net/sched: act_pedit, setup offload action
 for action stats query
Content-Language: en-US
To:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-3-ozsh@nvidia.com>
 <a32d4a16-90d9-06b5-c56f-aaa4304795e5@mojatatu.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <a32d4a16-90d9-06b5-c56f-aaa4304795e5@mojatatu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0199.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::16) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|MN0PR12MB5715:EE_
X-MS-Office365-Filtering-Correlation-Id: 08457e3a-4c92-44ac-6e78-08db04ee1620
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dHnMPvCvfkr2fgDyIVMDCZN8zdV/4MDgzJ4rpZ3JkCderNKUpOtQ2ElUfg0y/yxu4LeRDNLAP1jBIdbk2JPUqez6QnVSy94yB8Mu4P95Fd78dkhntS2jCMBcoXzztYGIptxT1l5gR6k4z+6mcoGkLovVzRyT38YEc0Sm+lr6QjQl5EaI7DTDh6esWp4DQCKDf/PYRxMUtPZzDrVqOE5eEyxtNUgPMr1Zopp2pKligz0WHPzj7KEkHQLbSC18JRdpSJj3avnGNG5Z91VZejJYd9a8DmxrScoFllKFvGclwX1+GDkRRbFRBvDFMh7uGpNt7DCqytjvPvsBUAcFFnWPCNviDPkbU6dcpTbPuC8K97b5ujRMiaUq4yx+tGzT+CHuiV5dgB6j6tJfWcBtfX9YwMaNV7LGSRZD12LwdNu5S2yNFoYF4GOf2levkTwA+/h3VauBzlcKPA0PK+85ZUfFoBsJsX19WUMgHz7PaWr3KLuNKV27/iir4Ua25C5OPPWeMe8gRizuFROcSmPFp6LXJexPVbIGn3tFo5NQ/DA/Qaj4Yr8+tlmJFvZE/WRgIXsHJcO5Oz/ojc+kEnWh3KMUbcaaWHcPqbA3F2vImWhvevuTjdwttHOv7JZTOpCPF7Bt34jW3u+vWaAGnwCwf8hIbs7DYatZFYODUHdWmzHG9NlR46VNMEESVfT51QV3+ujyi+1zfIH36OuSZSXva1RlpFlAOHgLTeN/crYwBhv2Jk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199018)(26005)(6512007)(53546011)(186003)(6506007)(478600001)(6486002)(2906002)(83380400001)(86362001)(31696002)(38100700002)(36756003)(316002)(5660300002)(8676002)(54906003)(6666004)(41300700001)(8936002)(31686004)(2616005)(4326008)(66946007)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFZ6aUFoTWI2OENDanNVVS8rQ1FSdWwrc2pxQzgzbXBxS2pjSW1KZng5Tm5V?=
 =?utf-8?B?SE4vSzhWY3Y5T09uUFJzc3d5Z2FxZjVDV2pKeGJkb1Bva0toTHhickdpL01Q?=
 =?utf-8?B?OWNoMTdOU1QyczZIVEZsWGdSY0hoa0ZjbVVONkNaeWZnaHBWR2QvOGROb3FP?=
 =?utf-8?B?ZUZ2Q2lLTjlBQTQ3Y3Rub0RxdXNTb3R0SXBOYVdEaGVQV0V2SXlxVERITzE4?=
 =?utf-8?B?TEtvUmhEZEQ3YUlzNTRlUCswVVovTUdxeklFdXhEUW14REJpYnJlWis2QWpV?=
 =?utf-8?B?RUpjRHV1dlZsUjc0dzRuT2lnRTlqWVBJZUJDcE50RWJzaVFBQXowNkRzTUFK?=
 =?utf-8?B?dUZTaitiaUtweFUwc1VWcS9tUmxFL3JtREE0dE5ia1dCeXVWdWpkMFZQYnFm?=
 =?utf-8?B?QjF3RHZkekxiUVlwU0NsREZRY1JRWEtaZDdUSVZuK2cwVkp4UFpkTE84b0dz?=
 =?utf-8?B?SGlQWExObzZKWFI5WmJoSFBscEs1MXQ3L2gya2dvajZ4R0ZXUEZyY3pOeXI1?=
 =?utf-8?B?VnNyR3ovaEVIT0ZodGFmQjMxeGRWWVh4a3VxOWh1MkkxKytaaXNHNWJpanNw?=
 =?utf-8?B?bTUvMDNLR2NVRHBHQ243MWpMUm0veHdxQXk3ekdoOXlmVlNkWG9FaG1YSkVo?=
 =?utf-8?B?M0phU3F2eTg2Q0JXQ04vbzRZTnozV2J2bGJiSk9hY3UyaU1uNG5pcldhUkZL?=
 =?utf-8?B?eHpYektycDJwQWJmZXdzTTdRVkVqRzFxOFREbUhCUFY4SGVCaXNRSkdkeTZq?=
 =?utf-8?B?Z0Jibitsa1JFY2lyWGxyVHd0YUNBa0VtRlpxM1M1YUZKelBNanpES0F5aDd0?=
 =?utf-8?B?MFZuRTM5U3pEeVphRzdIZWp1WlRmMmEwQWVVV3FCbk1GTHRNL0UwbE9JSXFU?=
 =?utf-8?B?QklsQXRSWUVNUGxOMHZSd240QkpBVkt0Ny80MzFKSzRlVU8xWnYwRVF4SElK?=
 =?utf-8?B?eVc4YXI5UkxQT2I3eDJuM2ZnaUpEQUFVeHhya0JHUXRhTFoyWi9jU25lMTVS?=
 =?utf-8?B?RFJ2OGI4M1BPOGZzUGVxbFZiREIxRnhLOUVjVXhCWEJTZFFSTU1UTitiYVlP?=
 =?utf-8?B?bnM0NXlTdm1BN0RLaExWbGNiQ1lVcTZaTWZBd2ZCbmdkU0JaaVJHRW5iaE1Z?=
 =?utf-8?B?S1pDRkNTWkNxbEdwMDZ0STF6WUwwRUZ6Tm1icWlpdzdmTVBZQWNYekZmdzBr?=
 =?utf-8?B?QWdrOWpNODU5dTJjd2NmSFlHdUdzdnlvUEppTHovS2FJeHJxekM0UUlRTkxJ?=
 =?utf-8?B?UVNjQUR5cVNkZTlPQUYxcHNhRFFqZEIvZXQ3NFEwRmh1OUpzK0JoekEwSUM1?=
 =?utf-8?B?cy9iQ2ZERzVTd01PSEJWUGM2aVJNdDY2Z2pjMEpSNVMwOG9YcXNFbm0xQmdD?=
 =?utf-8?B?aXRNSUZNSW40NVp3bmN0ZkVrMzEzcmFyYmdhdWYzVmZDdWQ5eitnQUFUaWd1?=
 =?utf-8?B?R0pkam1HdncwR2Vsb2IxdVNRODBKdllWbTlTZldxbWcrenQyNmxuR0I4QVJJ?=
 =?utf-8?B?TlJuQ1BrSmR4dTNMY0UxcXZ5UVZ6SDZXU2ZKQ3MwUVdoYlA3M1lCSW1BWE9v?=
 =?utf-8?B?U1M5Z3ZNZXhFT1hhMnhNSE9xNFhlMEZ3d29Mc1p1TWNxVXVUWkxBbEdGM1Y1?=
 =?utf-8?B?cWxLZW5Gbis1UEF6Q0tQNTRmQnFYNUNPSkZzU0J5QWQ2dXpEenpwZ0tJNmVi?=
 =?utf-8?B?RGUrcFJPZHEvSWlrSXJLOXdqdHBYczk1VU41MmhUSlNZMk9KNTVmTVpYKzVB?=
 =?utf-8?B?aGlxRTk4bDM4a1djZlMxMXI3UmREK2FVM3pTbmRNM01Vd2Z3RnFQWXNHWDl4?=
 =?utf-8?B?VWdDREgxZ3M2T2IvM1ZtVEE1QUlSU015VjAyM1pDenoxNmxLQUpscWRoRHR0?=
 =?utf-8?B?ZjdlK0ZkU3F1bGVTbFd0ZU1wMHBmVWo0cVhUSlRpeTd4bWhhdHFFUUlMQ2RZ?=
 =?utf-8?B?UllLS2lFc3FJRGtZRTVPM2lGcTFicHpQeUtaTXA3TkpFSjgwNDF0eEc2ZndP?=
 =?utf-8?B?UFNPREJJTUNwSFBJMHp3cGtieWRISkR6dzZyK3Y0OTRCcUpxNm42NTdqUlFx?=
 =?utf-8?B?NFdJeFo4MnhUTCt1S3dzdGJOMGcrVk1GS0lud3ZYeFdXTHlVYUpvZUhhRVpK?=
 =?utf-8?Q?+VCNnHMogMufoYqk16MGnsoAx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08457e3a-4c92-44ac-6e78-08db04ee1620
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 07:21:22.5821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LlBcMYHH/MOrX5K9lgDcZlQUbD/ZFe8iGFkc4zRyszqsTWe1OMQi24pPba4Ym926
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5715
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/02/2023 22:59, Pedro Tammela wrote:
> On 01/02/2023 13:10, Oz Shlomo wrote:
>> A single tc pedit action may be translated to multiple flow_offload
>> actions.
>> Offload only actions that translate to a single pedit command value.
>>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> ---
>>   net/sched/act_pedit.c | 24 +++++++++++++++++++++++-
>>   1 file changed, 23 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>> index a0378e9f0121..abceef794f28 100644
>> --- a/net/sched/act_pedit.c
>> +++ b/net/sched/act_pedit.c
>> @@ -522,7 +522,29 @@ static int tcf_pedit_offload_act_setup(struct 
>> tc_action *act, void *entry_data,
>>           }
>>           *index_inc = k;
>>       } else {
>> -        return -EOPNOTSUPP;
>> +        struct flow_offload_action *fl_action = entry_data;
>> +        u32 last_cmd;
>> +        int k;
>> +
>> +        for (k = 0; k < tcf_pedit_nkeys(act); k++) {
>> +            u32 cmd = tcf_pedit_cmd(act, k);
>> +
>> +            if (k && cmd != last_cmd)
>> +                return -EOPNOTSUPP;
>
> I believe an extack message here is very valuable
Sure thing, I will add one
>
>> +
>> +            last_cmd = cmd;
>> +            switch (cmd) {
>> +            case TCA_PEDIT_KEY_EX_CMD_SET:
>> +                fl_action->id = FLOW_ACTION_MANGLE;
>> +                break;
>> +            case TCA_PEDIT_KEY_EX_CMD_ADD:
>> +                fl_action->id = FLOW_ACTION_ADD;
>> +                break;
>> +            default:
>> +                NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit 
>> command offload");
>> +                return -EOPNOTSUPP;
>> +            }
>> +        }
>
> Shouldn't this switch case be outside of the for-loop?

You are right, this can be done outside the for loop.

I will refactor the code

>
>>       }
>>         return 0;
>
