Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F4A68AFD1
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBENBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBENBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:01:11 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE16E055
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:01:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmXRg9S+YiTl6FdhA71+nitDDAN4KzZdu1Ft4u1TcNLPrf540+VXBTkxpHEjkopexAZln0czKFksOoosPoae1g75UFhUqGKrvfEl01FD52K4HXWmbzmbzB7Ay5JH4fnUYu7ybZljuYqAWFLq1MfDknfgLbBZE+qVaNTc0B7yudXcZVx8aHJG2IQEOOJ5u/Lk5rfL4bFwk09lwl+ZeDJKDXCmilh3aaGzeU474CV9FxsrG4ntGpgbkhu6aknKxuOGridt608J+lhQieoxHudgIm0PujzaYlooO08anEFvtumb5PNmMgGHKKv4x9CHNy5TuD+vLt6CA7gpadBlXnWdUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NupyvlzRlyk0uZi19NZGXjggKQ5606eaJaLBBp/17xk=;
 b=cQgn7IqBITAA2aeyjRdILSUFggaEJp5DhCzShTwDy/rRp8VV4046aVp2I542DYiJwjnA8Dt7l9zud99q2BFj36WP9uci88nPkOH5lYQTPIkhXHSd3v1t0pEyFJSz648Q+h2K8WxXUXhS1XO0ppjTXYW8cjMcdS9afc7enAu1Ao+SSsaEMjQRw8aios0yJZahTjXW9il3AtVEYjGoKj0zU/Lml6RsyW8opnNmJLkclOFUoZzdenqdMZ9amktYZS7J/KNSD9foKKmx/R/PoP+TgYncqjVVjGu3hVuATLpGzJDjp3ycgMLZAWV2mFq+R1PZ/uKn3A+9Hcs6y6T7eTco1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NupyvlzRlyk0uZi19NZGXjggKQ5606eaJaLBBp/17xk=;
 b=dsqlhlcSx3MEvCmX+u3VCgmFESP0vzMT1NFs/xPLUtItIy8lqpYdOxGsAG0UrGZ9FAatsuBZ11ONsjeH/FPFEqa7fMIlVhHXjAA8L6E6AGzmV3PY0m5R7HSijy42ys+Gv++eHp0U2qkWelliegK9J1q29a4+46NFd7TAWh+M1hVT3dLCLw8rOBlyyx2eifguU6lsxBhwJC++eglxFm6Yo1l9WUSImhHMauMp2KbeSlvKcREh3YAPWhaOiTo+3NjwMAVNt4cpit0HP9kw8VOZ57b4m7Y8jiEDuo/BO+SThn5hiIG4Nl0qP6jnC6q1LBDrRTFCxTXLhnAudbibi2PV6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 SA1PR12MB6872.namprd12.prod.outlook.com (2603:10b6:806:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 13:01:04 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518%10]) with mapi id 15.20.6064.024; Sun, 5 Feb 2023
 13:01:04 +0000
Message-ID: <bb01f89c-194f-ba2b-f899-62818e39341a@nvidia.com>
Date:   Sun, 5 Feb 2023 15:00:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/9] net/sched: act_pedit, setup offload action
 for action stats query
Content-Language: en-US
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-3-ozsh@nvidia.com>
 <a32d4a16-90d9-06b5-c56f-aaa4304795e5@mojatatu.com>
 <cfbbbbbe-0a23-749f-f611-6d2438f797e4@nvidia.com>
 <CALnP8ZZtqkumhUrRtCAqQDHQfEydG0YaszZrafjuXL2CV_oDCw@mail.gmail.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <CALnP8ZZtqkumhUrRtCAqQDHQfEydG0YaszZrafjuXL2CV_oDCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::13) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|SA1PR12MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: cca4c5c6-bcf5-4d39-585f-08db07790988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JHms09+KoCtXy540eeowKM30aL7UIFYtNx6GSkgrlDYt6M5Qdun/QlvLlpahmUxn09TRnNPwFT+prBBqDy2w6HQoHEwRkpJQ/0/X2CL1p3wT05A07DSUB6PpiHdyHuEE4ifCKlS9cgQ0FtlQ/GQRb6uchi+90GMRQtqGLWOp6l+AUIRBzS0ViLD5KJgijRr/vVOBY2pIW3uEW6RBJ6OrBwjIUT37co75iklBZ86Oyaae9XRNNKM+ssD6eWYwGAztUPDbPkzBB7NbfzGMTHIaI/uhBIgGJRQPgN4REXawYTUxdWg2olIB7dEhlBrhJAo86W0ilQ8PpISjhGHJqcW+OinR+hJ9jSyduV9Ay1XwWC/E5YgAU2prbewwJsaWjL4p1T8gLtFXw4psTHhie8Gzd14l8RyAUIbfVSI5rmir0ETBOSL7Y8BJ1BjDNA6vqldD+18TPm3wl3rceWR2A0sguHwEjKBE0uT+Dp801XHsw4AV1vqU1z+HcJerxgL4nEXKX8uFuWaGXDxHJ/viVVLEna7oiRvnIq9uwZOsXtCl48hvHhhT95WRPE3Dnxn1+VFpHl27cmulDs2SIkitRR5WqOM7D4xTcXCxz4CPvGaCOuUEQGqzXWKcR1MFYaqbdQ7oY8lG/8wapQZ1LmRV9+XEJcXkF8QARwQVkzwo8tYYqa6vP9bQwSZTh3NnFfS1HabjdEsxhsl+4Bs5ws9XENWqx0/X2KnZI/0IquH+xe2CDaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199018)(31686004)(36756003)(66946007)(66556008)(66476007)(54906003)(4326008)(6916009)(8936002)(8676002)(41300700001)(316002)(5660300002)(31696002)(86362001)(38100700002)(26005)(186003)(6512007)(6506007)(53546011)(6666004)(2906002)(6486002)(478600001)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlA5bWQ1SjZ0SjQvdEV0RzlWQnpzQlYwRmRCR0JEbTR5RHd1RTc2bXl1RnN2?=
 =?utf-8?B?ZS81cE9LeTk2eW9EYjQ4elpCTERVNi9sdERTa25MaGg5dytGd29reXRpSVRu?=
 =?utf-8?B?ajhEYUwxUElpanlIZUZxUnlEV2JwQnZXTVFWWEpqakh3Zkl6TlRwWXBhT1JF?=
 =?utf-8?B?Sm00b1h5REJQSG9QV3hCOXN1enJJZ0ZZTUhOSkhtejhwTWNHL1ByaVlML0I5?=
 =?utf-8?B?Y09LQXcvczEyTDBlZnN6MHNJczRyZzAwU25zRG1pSG9DRWY1azNpelUwQXVE?=
 =?utf-8?B?U1JQQjJoQ2V5R3AxR2RGVXQ4NjNYK3BEM3U5Y0NiT0NNNDZTTWwvYjNKclBq?=
 =?utf-8?B?dlNxWnowTFVDdEVRRmMrNUVad0dUamVUUzBwVGhKUmRsZlNIYWRRZnJKaTJ5?=
 =?utf-8?B?UjNxSVNudWtkNEtqR2x6Y2lWU1M3NUtTMUYwS3ZPb0FmQzZoeGp4Ykk1dC9v?=
 =?utf-8?B?MThxQWZXZndPYVJUQjduQzlqQkpOUXY4K0VkeVVLempLOWl1RnRHUGZlOFkx?=
 =?utf-8?B?WWNmeHBuR29SNjlyc2Y1bjFGZ3ZSR2ZhSndvdDh2ZHVvQTdzb0xHSjJpN0VK?=
 =?utf-8?B?cW9kQTMyWFZoS1pCanBzTUl5ME91R1IxZUVTQjVPMXExdVJ0OXZ2WS81TXdP?=
 =?utf-8?B?K0FSKzZLWUEvWWxjSzJ4N1BZWk5SRGZiMjYzTjl2ZXZaMzRRTGhyN1JBMEhX?=
 =?utf-8?B?bnpvcEZaUUo1LzFLY2EycllQdm43U1ZiQXg3cUp3WkxQOVRtTGR2YmVWMWww?=
 =?utf-8?B?SkJyUW1zQ291VUZxTytES1IyVDNFd0k5Y2pKNVcvSDh4b2hoMFZ3MmNncmt6?=
 =?utf-8?B?ZlNhUnVtMlBMUDErQzRpcjdwV1M5T0NLSXY4WnFDUTBUZnAybEFpd2RqRnlF?=
 =?utf-8?B?RkdubTJHQnQzZnJ4T28yZmQzdVFiRVJCeGVVcnZqMGl2MjJqVUVNaHlZWGV4?=
 =?utf-8?B?azFYR2ZTTVRMUjBNenEvWi85cHV4VW5NRURFdHZyMTd4S0VhOGtrc3Q4ZE4w?=
 =?utf-8?B?bzIxQms5QmhkcytYNHpucTdDUWd6OFlpUUc5dGwyS3FCVHZpTHplOC95VlBC?=
 =?utf-8?B?SkpuTHpGQUhDRVh5cjdRY2VjMW5yZnE5clBsWXBlNExyN01xQlk0WllRdXNw?=
 =?utf-8?B?TzZmaDVoL3RicEFFaUNIZkU2TFhqaFd6cXlCTm1veFRVQ0xuVHByQUd0YVNO?=
 =?utf-8?B?dmprdnFPMEFHKytwOXBEZEJWSVFjQjk4TFJLMWNYYkc5WXJPUHM5T2tvZU9j?=
 =?utf-8?B?MVhnampIU0R4S3hzZHkwMXloM0p5b0huWG9BMVJrcThZbzFDWHNyZC9wQm9F?=
 =?utf-8?B?U3V6aDlsc3kvY1dTWXN2cnVQNE1QWFpaOTI4WUh1U1Vra0J3U284bVZwYkxD?=
 =?utf-8?B?MXZFbFdSWTVubHJrSTVQRmhsdDhpdGhIV3ZMN0ZYWHFCakNlOEE0a1hONXNl?=
 =?utf-8?B?YWpuMDJaanQ2ZThlc1MzZGlLUlk1Tm51MGFvNytoclVOQU1sVWxyd0poaTdD?=
 =?utf-8?B?ZHBTTlhrMGVxTTdoSFlOWmY1TVkvcitYU3ZKTE9LMkIxVVducGVVa2crcHVx?=
 =?utf-8?B?NC8rTEJ6eTREOWxqNGZZTW5SVGVtREhtQ3V6SFlzN3lvbnZqVnZ4eDI0THMv?=
 =?utf-8?B?eXFPWnhzSTAzVm54dmZXQTFpdGpTekRNWUZSaU9qLy9kNlNrTFpjV2ZiSXh1?=
 =?utf-8?B?L1E5N296U3I2NmdaT3dORVRzc09hZmtGZnhFM0JsNUpOK0FRdDl1L0x4d1hn?=
 =?utf-8?B?dWFaZjlqYW5lNGwxNmVsMEJ1STlpME9jUEhzUVVCRmRBaHVwdnZlUklidnpI?=
 =?utf-8?B?UGppS3hCL0NSYkVIY285QWc1VzBxSXRWcy9wWlgrdVZ3SVZ3eFVlYXlYZXVZ?=
 =?utf-8?B?ekg1OU9zS2w0eFo4SldUY2tHVDRIQmRCWmNkU1VqanZ4VEl1THdPbEJ3dy91?=
 =?utf-8?B?aXNGOEl5T3g2Mzh5T2pRRGg1MDZMNXdJWkt2bUZGaWVBVnlXeWR6UHduSkhr?=
 =?utf-8?B?Y3lBejJOUTFwUlJxbDdxR2lTcGJkZkpxdmhra3IwV0hjR0ZsRCtLQXovYUc5?=
 =?utf-8?B?d2dzZWxFTGMvc2c2dTEzUGNTb0dqZkVwRklXZFJTUnRlODJBS1VaeG1vWWhM?=
 =?utf-8?Q?zftBots0E+TkGEJaYtMNbfnwc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca4c5c6-bcf5-4d39-585f-08db07790988
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:01:03.8862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LF4ighJRS7Kw2mkjgWBzQEyRilIbs/r6oh2ewnS5YnmdrwO2zqcuCA7KnBSQA8A/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6872
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03/02/2023 17:31, Marcelo Ricardo Leitner wrote:
> On Thu, Feb 02, 2023 at 09:21:15AM +0200, Oz Shlomo wrote:
>> On 01/02/2023 22:59, Pedro Tammela wrote:
>>> On 01/02/2023 13:10, Oz Shlomo wrote:
>>>> A single tc pedit action may be translated to multiple flow_offload
>>>> actions.
>>>> Offload only actions that translate to a single pedit command value.
>>>>
>>>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>>>> ---
>>>>    net/sched/act_pedit.c | 24 +++++++++++++++++++++++-
>>>>    1 file changed, 23 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>>>> index a0378e9f0121..abceef794f28 100644
>>>> --- a/net/sched/act_pedit.c
>>>> +++ b/net/sched/act_pedit.c
>>>> @@ -522,7 +522,29 @@ static int tcf_pedit_offload_act_setup(struct
>>>> tc_action *act, void *entry_data,
>>>>            }
>>>>            *index_inc = k;
>>>>        } else {
>>>> -        return -EOPNOTSUPP;
>>>> +        struct flow_offload_action *fl_action = entry_data;
>>>> +        u32 last_cmd;
>>>> +        int k;
>>>> +
>>>> +        for (k = 0; k < tcf_pedit_nkeys(act); k++) {
>>>> +            u32 cmd = tcf_pedit_cmd(act, k);
>>>> +
>>>> +            if (k && cmd != last_cmd)
>>>> +                return -EOPNOTSUPP;
>>> I believe an extack message here is very valuable
>> Sure thing, I will add one
>>>> +
>>>> +            last_cmd = cmd;
>>>> +            switch (cmd) {
>>>> +            case TCA_PEDIT_KEY_EX_CMD_SET:
>>>> +                fl_action->id = FLOW_ACTION_MANGLE;
>>>> +                break;
>>>> +            case TCA_PEDIT_KEY_EX_CMD_ADD:
>>>> +                fl_action->id = FLOW_ACTION_ADD;
>>>> +                break;
>>>> +            default:
>>>> +                NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit
>>>> command offload");
>>>> +                return -EOPNOTSUPP;
>>>> +            }
>>>> +        }
>>> Shouldn't this switch case be outside of the for-loop?
>> You are right, this can be done outside the for loop.
> To before the for-loop, that is?
> Because otherwise it will parse all commands and then fail, which seems heavier
> than how it is here.
>
> - validate the first one
> - ensure the rest follows
Right
>> I will refactor the code
>>
>>>>        }
>>>>          return 0;
