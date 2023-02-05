Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C00068AFD4
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBENCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBENCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:02:40 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BFDE055
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:02:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUungjUUXBVb7HQO4LC7/Yn00GXBTv16Tp58skerqx6IDbD/32Ms+HbtkQlAsPP0CWpaPVa1BtXmnt4XoxjUdodjOK5OUM8vWUMCJyFGs74SvTLnt4yLoha908jlhoZ4dH2EhOK5vt/8z47cw3F7KO5kVIzepZFmKzWe9NBtOC1ITpqwNMA/7cgD2aS7q2DbEXQvTSm0aKJHiDta0J4RYACRg587hLdkEVeNOL5LQXRCs+FP6BSJU42ukYAOlQDh1bTNhBnl2BST0wb/h1SDrlKmU1uKWvcNSNiedMm2CZq6felLxkP3o+YdpKYeXtHD++dUDJxnv7AaA9GjJQVcTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwWMNPmL3jHg/elOSIh7gGzkd/58kg9hiD2AoTrOyko=;
 b=PdyD1rOiLhzXXdLlP368JSWw/nHq6Ebyt6V7LzVA9nrhHko3Ir/s2+eCiB/0h4h2H2lwkZ/ktLc0fqpAhPtnN1Wa/P/lZGJtzQ2dzfHbext4d931BEGFY0E3rOmfbriksq/0z9eVIRPqWVMaBJndnG09VPXKxvVbzZ+LKH+VDGd1ggZAJcUSBcenSVP0vh4XhMkxMy1tjltH99cL2Y7dxzUX+KZZyzsUMNbjHIFvQKPUz3GEGIyXMqMy0y5tFmWii/u/nSZfvjiBR08b5vDTxbtPD/zNb+0EDdPiYbFRoz1n9dnlE8QRzJOka0qt2GfUYZW+t2jR7n/NPqMj9nwzgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwWMNPmL3jHg/elOSIh7gGzkd/58kg9hiD2AoTrOyko=;
 b=qxQ2iUVA4wWZ+an4wBpkRvBVQ5x/mvUXQHEmoEl6y7EQP5PrwMbRoWrxJMIqN7EoU+SwNkFvvz8MNTBGF9I2Q9nQ90X+NwslnYvusNCE/Lgy9O/KSjCh0KpH1SXo2E8sIV1xFbAXwS4TWB3f2q2bFnDpK57nyo/3E4+nnOoKrouc9hC5TWoL5DhcI3Q/0n9wUxzZlSeALoWz96FDDNXHErDweB+8hAlaCHZlOZ5mCVFvirW4w3UsyIRhehD4h7KuGz6KiSSbzgsQCWEOHpVBbYo7xL1GlFqqlXT28FbYt1H2XgKRiY6wiF/mAzUlY4XVlwoDZZF57wCyQ0Kdr5+ReQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 SA1PR12MB6872.namprd12.prod.outlook.com (2603:10b6:806:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 13:02:36 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::b18c:b9c5:b46a:3518%10]) with mapi id 15.20.6064.024; Sun, 5 Feb 2023
 13:02:36 +0000
Message-ID: <797faa73-7dc3-d9b4-0410-ea5e9fa23452@nvidia.com>
Date:   Sun, 5 Feb 2023 15:02:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 5/9] net/sched: support per action hw stats
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-6-ozsh@nvidia.com> <Y90fWp0ltyK85WFL@corigine.com>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <Y90fWp0ltyK85WFL@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0009.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::14) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR12MB1307:EE_|SA1PR12MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 31b2fc3f-4cab-45a5-2178-08db077940f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L3hyiNslwTVk13x40ERUDdDgCb8VJE2SOO207OR9a6TSouL45bRuU9uU2LXyazctywEkbg9RTlv2jQOh0+7ZuRzoX617p8IiQUiauaxBBWKC0iHAXwltcIjzWNOgGJSQBPHsvC9abwXDcKfr6+8fRuHU5O0u4VYVn0ZfEypXExrr1WEvJe27vUseI/W1DMwd2VwDaO231EKCdesgfdktriplHOWlF0VBU2nvuQQPVsIzFIHcPga9TzkyozYSYbecaLrtXNRGy7t57A0HWQP77wIbX5RwULewHB9D+6GjQq9v1Nqsv8sY/w4zeCGZ3+BhyH+cYu0xt2rD6EXuq/558zqrMe9xqFnrgHsFvQbqxCSzWKPUhzzkq+ZHWgm9NXgLpTryazni6gZgQXMvZazl2Xn7rJz7cPQxq2rjiBwWyVJ07PTgoS6TRRdn6OrPfFLBe7wR1PhQzs9O0q0yWKJRbrbKmLen4Wfke8Zy7+nP8PeVJoE0n6Qxx48Uh5H5EDJJdF3krpmtyLgvbVl/rxRKhitX3Vzt5kW/rCQhhKDOfB/1+eP9b+a6vZQlxtYwK3IDzMAUxqsstFdANOfphRAF9BO4Ls9EjREfEd0Mh11CEuinudDikMm8VjFxUoaWWq1LkX3G2rN6wbo/H4k+6083jJY688edJ5IXgu42yjeo/1IBAn6ibPkbkb/WUMHtEbF0zjL8A0+wVgbbg5yWsX3LvqQ5QkyaWLcICICjQNNWVUY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(451199018)(31686004)(36756003)(66946007)(66556008)(66476007)(54906003)(4326008)(6916009)(8936002)(8676002)(41300700001)(316002)(5660300002)(31696002)(86362001)(38100700002)(26005)(186003)(6512007)(6506007)(53546011)(6666004)(2906002)(6486002)(478600001)(2616005)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnRBVHdvbjc4NUU5S3pkL29reXR1MXd6WmQ5Q2tKREhmQXJTOVp2di90R2tG?=
 =?utf-8?B?TW9jRnVHZyt4TTNtRWEvTmxDTlQ1bjR1SlYzTHdGcTllZk1kdysrOTlpUmxn?=
 =?utf-8?B?RkxSREpLL0liQkIxcVU1cVd1OWlMNVRibWNaVUt5eG1iWGxjQUJJNlM4L3Vx?=
 =?utf-8?B?ci81cXU2dThHcEk5a0NEeW1KYWZNem1kUG5MYXRYMDlCRWJHSzB0R0NlZEV5?=
 =?utf-8?B?Wmh5aXR3ZUp1NGF1MlhqdEtWVElBMnIvNGNHQ1FMWGx2anB4L2lWNnd3aENU?=
 =?utf-8?B?aWJTS2tBbkw3TGpNbkttNUJzb2RQZVF0KzEwY1NXeU1XTVUwNGhmV0dQVFFq?=
 =?utf-8?B?enpNVXd2ZGkyU1I2azQyb0xKQkg5NmVMT2FRbHhyd000ZkNtYmx6NDFIcGEz?=
 =?utf-8?B?NmttQlJaK1M3anVjSHBOTldkRkxTVEt0WXNHaGhSQnh5WFFSMmZMR3JIci9p?=
 =?utf-8?B?dzZUdTVJQ0xLa2JIdWg2SkYySWRDUjQ3dHRnLytqZ25qdzJaVk95eTBxRU01?=
 =?utf-8?B?QXoxT0Z5Ulp1czRicmQyMDNQODhWN1RTOThKZTNkRVFlWmN1NWFMV2JTUlpr?=
 =?utf-8?B?L3lXTnFQTlExOUJ0a1M4NTI0SjRVVFRPaHk5RVhxTkRLKzY2US91U0lueHJv?=
 =?utf-8?B?SG5nTGdsQy8vSkwyL3pLTGV5TzhqK1pZQnZPa1ZBZjhvaWxkQm5vcDFINGVF?=
 =?utf-8?B?d2VFb0w3b3ZHOWNyTnd4WDBzRUxqbHNZQVlNYWRiL3BnRWIwQ3lYanVncllW?=
 =?utf-8?B?bHBBL0RLOGxJdDBncSsxaUtyUXZZUmEraTZ0YzNjZ25KRFRuRmh6THZrSGVG?=
 =?utf-8?B?L01sZ0UxSlZqR3hRWFQ5NndidVJOUFlPdjNIcVRyYlhnVUd3VFoyZk9UU0pH?=
 =?utf-8?B?WnBybUlyOWlkSlkrc2FkM3JvbGxGbWRBRGpubjJibmh3YmZ1VTR2M1B2MEcx?=
 =?utf-8?B?cXNqcjJ0YzdWVDVZTXRYdm0xZldsRUpwaHRmcHZCQ0hRTkkvVkdUUlp4Uk5x?=
 =?utf-8?B?UHVncndEUitzM3AzWmZndFlzdUxUc3VkK05WQW1ETlUxUzVrTEtVTHM0OXdC?=
 =?utf-8?B?c0xjeVVUWkU0M1FWOURWc0htcWFGZmE5aU9FTmpwYzBXdmNEZEdNUDdOZUs1?=
 =?utf-8?B?cnltemNNNE5NbVBPMnhNRDdIZVZDUmVacGttTVc2T2Fsb2JsYTkwd1BnVkF4?=
 =?utf-8?B?WVUvNlJISTBtdE0xby9saXNiT1BEbUF4MjVjeUF0YlpjTzNHMTN2b2NwQzJo?=
 =?utf-8?B?V3o2TU1hcmpzU2xVaVhCMnFKWjZsL2w1RFM1LzYwb2hqRkhJaHFzYjVTSXBX?=
 =?utf-8?B?TllDbjBPcTFuckdOS0VBNkQ0VG5Td25WRUhDZmRqNmhVUzByQXk5YWpTRUEy?=
 =?utf-8?B?MkM1andGeGMvUjdiMDJiNVNRMFJCVCsyQVlhdm13Ym5RYkhBSjl1SnBERlNu?=
 =?utf-8?B?eXRwYVVReTBnTnpYTjhDWUFqR1hsbzRWMTV0VkpkL0M2c2phb0pReUFhQVRN?=
 =?utf-8?B?RVpGKzB6REVlaVh5Q1B2Rk5lZUQzbk1JOEYveVAvVXFkbDhITnE5VVVtMTlG?=
 =?utf-8?B?M1pSTG9XSTJyNlBIRXN1TnZJSUNwY1k0NXI2c1FMcjhMcjlrM3NOV3NSZDBj?=
 =?utf-8?B?ckRTM3llR0ZCTDQwanUwRlNhc2xJZ0NpL1UyYmdZUUtGS1E4bFkyVmZLSURB?=
 =?utf-8?B?UkhxZHFwLzF6NUZRNGRaNURCTWErbHdPUWFxQVFqOHlDUWQ3VTZSR0pwMXNM?=
 =?utf-8?B?NDdaaWhZa0pTN0hscCt1dm1GQ2VadmtvVXdFV003cnhwU01FS0NrNHg3eVpi?=
 =?utf-8?B?aDgxbmc2TnRsckpkVkg1ZitPS2dXOUxzdU9zZXdXRk9CSSswdkpweVdWQWda?=
 =?utf-8?B?TEVucTBSU0ZQL05NRnZ4WWJBMU5BK0xIZHlQTXFNRlREMHAxTitoeHd1TDh5?=
 =?utf-8?B?b3ZDQ08vTHp3akJoMk0wbnRmSjR6OXJnOUk1aTBIeXNGekI1TFFEQkRCVzhw?=
 =?utf-8?B?eHI5MmRHZjFTb2swUWZiRUZvUjdqT2NUNDc1RmpkS0pZUnlJakdYQWdLaFZH?=
 =?utf-8?B?Y1N6VHZCQTVBNjVhQkdRbE11cGF6dDVzdGFZSkhFUHBlak94Q3NxUjNXdkdn?=
 =?utf-8?Q?yLvnvPNYapBRkiyu0ntB9lR2m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31b2fc3f-4cab-45a5-2178-08db077940f1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:02:36.7695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OBbHHnY2NghXKSRwq4zsRkZyVgsX/dh+J1RFg5QGooM2+RFyGS0ISk26O0ZONn9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6872
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03/02/2023 16:51, Simon Horman wrote:
> On Wed, Feb 01, 2023 at 06:10:34PM +0200, Oz Shlomo wrote:
>> There are currently two mechanisms for populating hardware stats:
>> 1. Using flow_offload api to query the flow's statistics.
>>     The api assumes that the same stats values apply to all
>>     the flow's actions.
>>     This assumption breaks when action drops or jumps over following
>>     actions.
>> 2. Using hw_action api to query specific action stats via a driver
>>     callback method. This api assures the correct action stats for
>>     the offloaded action, however, it does not apply to the rest of the
>>     actions in the flow's actions array.
>>
>> Extend the flow_offload stats callback to indicate that a per action
>> stats update is required.
>> Use the existing flow_offload_action api to query the action's hw stats.
>> In addition, currently the tc action stats utility only updates hw actions.
>> Reuse the existing action stats cb infrastructure to query any action
>> stats.
>>
>> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
>> ---
>>   include/net/flow_offload.h |  1 +
>>   include/net/pkt_cls.h      | 29 +++++++++++++++++++----------
>>   net/sched/act_api.c        |  8 --------
>>   net/sched/cls_flower.c     |  2 +-
>>   net/sched/cls_matchall.c   |  2 +-
>>   5 files changed, 22 insertions(+), 20 deletions(-)
>>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index d177bf5f0e1a..27decadd4f5f 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -597,6 +597,7 @@ struct flow_cls_offload {
>>   	unsigned long cookie;
>>   	struct flow_rule *rule;
>>   	struct flow_stats stats;
>> +	bool use_act_stats;
>>   	u32 classid;
>>   };
> Hi Oz,
>
> It's probably not important, but I thought it is worth bringing
> to your attention.
>
> The placement of use_act_stats above  puts it on a different
> cacheline (on x86_64) to stats. Which does not seem to be idea
> as those fields are accessed together.
>
> There is a 4 byte hole immediately above above cookie,
> on the same cacheline as stats, which can accommodate use_act_stats.

Good catch.

I will move use_act_stats for better cache alignment.

>>   
>> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
>> index be21764a3b34..d4315757d1a2 100644
>> --- a/include/net/pkt_cls.h
>> +++ b/include/net/pkt_cls.h
> ...
>
>> @@ -769,6 +777,7 @@ struct tc_cls_matchall_offload {
>>   	enum tc_matchall_command command;
>>   	struct flow_rule *rule;
>>   	struct flow_stats stats;
>> +	bool use_act_stats;
>>   	unsigned long cookie;
>>   };
> I believe the same logic applies to this change too.
>
> ...
>
>> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
>> index cb04739a13ce..885c95191ccf 100644
>> --- a/net/sched/cls_flower.c
>> +++ b/net/sched/cls_flower.c
>> @@ -502,7 +502,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
>>   	tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>>   			 rtnl_held);
>>   
>> -	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
>> +	tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.use_act_stats);
>>   }
>>   
>>   static void __fl_put(struct cls_fl_filter *f)
>> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
>> index b3883d3d4dbd..fa3bbd187eb9 100644
>> --- a/net/sched/cls_matchall.c
>> +++ b/net/sched/cls_matchall.c
>> @@ -331,7 +331,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
>>   
>>   	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
>>   
>> -	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
>> +	tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats, cls_mall.use_act_stats);
>>   }
>>   
>>   static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
