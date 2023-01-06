Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597F5660A51
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbjAFXgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbjAFXgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:36:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F136688DCA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 15:36:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGOm9QJgcveqvuORvdbdrOmjhOet9NYFGgvHfXi/JzYKBD3XjiOCmuNb5gT1yk4p+p2/GuunyzXoKXJsScrUaBnwNVdWx28eE3kMupUiHJfjv5+3sOzPdHoOYPg8rqVA2K9EEH+gmA4oxYfJMeKBHJg1Ew4pECjpsET/SbNZbNOjoicCmbFv9yjsCNHiGesbdjyQjE7uijAoJrtTuVNHeLvIqw9gY9czCmeYwsABp3pqcKTfX6vS4BBpYICpKW1uFySuqAfaD/3iyfzPbIlYmex8Myj5UqHQKOMjnI3hl6/ZhbmUlJ33Ej3IQEqcwVhxas//LlIH7e7q4BVdLT93Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8p57ChKAh8mml9hat3HTm9iuj8SIx45rGhXmBpWyabM=;
 b=oOuVdptdZjXsII5EGCNXr38IXnkAEKFcjrzBlwes51jqQw3wnijy7jbCZljJ1EFMFTcXJeLwfdW4SnehClFu0fJ/fUtX6ZmaCj6+rxRS5h8+IbQW9loWBcVSBOhRtRbGBGUao0IvwiupSYUyOPnuTlg1NHvYUXwHEqhAkhLmwyI/ExcuTcifvZgf7Qzp/jIMXcT8apSpc6yjIf35jxaaehqLDm2wUWOtXb3tUa1Kr07IEB13t7rE6bAqZyVIfUyrIfMCYxlHJXR4ny18IIKh0dncLPrsQbZ0Jx5phwzYZT2+wm74VUQJsenCr29LCLFUIRHMJVXL80tRDL9by7inDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8p57ChKAh8mml9hat3HTm9iuj8SIx45rGhXmBpWyabM=;
 b=CLVtMx9lXJi1aiMV5sRPJiXX2LN4C6G6J1TudijWOaDgQRYDsWytsJOBXwPcbCwZqlP36YDc6Kk6i5YQIUJGAA7o3XnQCZEO+ifEGzdOK2K/PBmNhFeA5/IetcUTkuEmhOiedNGcDX/1Fh+kwYWaWCYdrgyRc9SGrB9CU+1ZHvsTEHN1x+19kG4fh8P+hfWTJ6pP+hqwKxetCSLPntn+Jh6Oj+or2v5Y/Lv2vZ6zLkp+ZKBCefjm5xR6GUecMug+3dBgDLUdtByrT9iR5DqWEs4vne7jVSpkAASJAwWB6O6RSA7QMlrDuSZKmniGOsDcvQRNjwfOPH1sRGbLlRW5Kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DS7PR12MB5888.namprd12.prod.outlook.com (2603:10b6:8:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 23:36:48 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175%5]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 23:36:48 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] sch_htb: Fix prematurely activating netdev during
 htb_destroy_class_offload
References: <20230104174744.22280-1-rrameshbabu@nvidia.com>
        <CAKErNvojEx1jeWfqoo+CA3iSJpc2URVbUvmdc=QtVEuif4_YNQ@mail.gmail.com>
        <878rihplfy.fsf@nvidia.com>
        <CAKErNvqDfnQM03Npj7Z2dfz_ATcPPuwvSng6MqqX1q=g2z8AWQ@mail.gmail.com>
Date:   Fri, 06 Jan 2023 15:36:37 -0800
In-Reply-To: <CAKErNvqDfnQM03Npj7Z2dfz_ATcPPuwvSng6MqqX1q=g2z8AWQ@mail.gmail.com>
 (Maxim
        Mikityanskiy's message of "Fri, 6 Jan 2023 14:03:16 +0200")
Message-ID: <87v8ljme0q.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0190.namprd05.prod.outlook.com
 (2603:10b6:a03:330::15) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DS7PR12MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: f226fd05-65d2-407f-ce19-08daf03ee11f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwmc/SzXMn9oKhD9nCJHvF2T2M1W9Tuedshgf82YPE5JCLLtLjpD5HfgXxrerZYu0cEdQVce+wR+yz6bsNrVNbvCqWRchuMwsOBW1Rzexp/f+YiSWLeELgQN1hzFiPubwQY05TF/wTA40kjFkK9wxbS/f9XHn6I7tDGsA+4CqHdgR6h+yQcFjjn5KMfshiR/+Ec4Xk7+5erX52eT9goywtOp8915ed2lY9uwrW7wAmtFn7bNRuikg/0Wu/4P1ebaHmoK+du5XRdO04C1uy4Akrq03h6m45qtcD3DVzPgwvjZKN31vg3l3o4cdhpBziNZ+3VXOc+UqFOoNaR2BFT1Fi8mSb124CMX9NGD+GtFfQvL4N2qhfnvCFyA3zJ5QZRx59BqrNSqS13h4KthEXTCsKICqb1g53zIUYH3Psojfr8HRDM/RFoYWibnQj0VpNZ5nwdjVDyq3fcAicS3qH7kaGBT6OiYpSaXumW+uW8HxocnTbo6l7jz1C9iNlaGoboxwf75kMYQsk8sKHV0yPQDGVm/uPZ3rPfI/Jeom6tw8ExRjo4x0HWhZjCsv3ZZXoJY6F/VeouyQrcxBBVRSb4l47iwlF47gdK71I46fl86HGqLwyh7K07HbhYbXVKGTUjVsCKvh5+cm2mO7Jk2IKHPvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(451199015)(5660300002)(8936002)(4326008)(66476007)(30864003)(8676002)(2906002)(41300700001)(66946007)(66556008)(6916009)(316002)(54906003)(45080400002)(6486002)(478600001)(6506007)(6512007)(186003)(2616005)(83380400001)(6666004)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OxOtksxD1LxZzoPaT2HuDi0wiKmqO85V6Ph+LW2RfCw8jc9u76oiamPPiawa?=
 =?us-ascii?Q?HpJU2Ap1fhTKzqPfNcXI+IhLx5BnaxEb1Wte9RBRGCqwdsHkt5XX9ccbvid+?=
 =?us-ascii?Q?uLqgKJJILxFOJWWIBO+wj+8B73ubs5t2HiuaLGLXAJgwW8XYJ3s5fp7jG0hL?=
 =?us-ascii?Q?XYEG8TxNngSSF2cQgY14DSFetMyudN37pi7as7wdplrNIxxpNDdESHzI45se?=
 =?us-ascii?Q?31iNGgxCJD2Qki3ByXp9RyCNdog+3epfRnWSg2y7fC4bszvkQDuWRvOrxDOC?=
 =?us-ascii?Q?dVWjaS4Wy9p/FT8w6Jxt05DgJRBp7AaUWxEipcjIaHg8sLkL14fcO/jusMOr?=
 =?us-ascii?Q?FSMKhEyJD5dNMce3NlFuCLlTMWxbaZHAXLRvAIHPhPi0TyhEDziAoWUitvJ2?=
 =?us-ascii?Q?naSPTlxIFKPXSDry/b/aesEVQz00bDULpMTwhQba8TvvlzL6LgXuQgBunROT?=
 =?us-ascii?Q?lKHFPmzWUQRQgD2cJvk7EnglA5nEok7lJyrwi6DkBGmWi9xEqrEM2K3UTDff?=
 =?us-ascii?Q?jnQD23vpjXrbVUvNNZbrX+gEz4s9AAV2NDLN1j0zVzocxH8IzsO76BKgDBnZ?=
 =?us-ascii?Q?xvB4UU9I+KHAWuDFuOUDjvI/cJFvX7IjdJq2fgNfAAA0zj8eYLw6JUu74YbA?=
 =?us-ascii?Q?kqu6wnp5bpO2bBXXXqhDW+VYgPTsrM8jyqJoS5hctLSk9tW+5FGn3TXVMz9K?=
 =?us-ascii?Q?BNKPtAJhbhW5Wtp0cVE4k1uTeS4CxuQhwq7AKJIdzuhRGRoA+dxfj82ISE5V?=
 =?us-ascii?Q?l55oE+KfhCOCmHiXa7N+Cl/BWOsxqTx2h0dniNmIvzcVYVL7Wjo3Wg7oUlPK?=
 =?us-ascii?Q?Tt7Js4VgofgTrjkvZMqRw4eFfK4jbS/rcDvnUFKoVB2iOMrp33uAG2wnxVVA?=
 =?us-ascii?Q?VNYw8fvE4qgrxt4xlDdbro4LjaMnxaa4uG8kvod3iekGv/wBG/nVjdW9zpCh?=
 =?us-ascii?Q?PfMz1QT4RCySyBSas19vmoOD6t7vUjNuUdiPWu7+zDy0OZPeINLPF29xnSMY?=
 =?us-ascii?Q?6iSApFiWNnIyKmhVlYCVs3zjeacOyWqYWSnjva7koTs6o798YfE4zo5VWxlo?=
 =?us-ascii?Q?N1eoRCtfELgNnR13dXONn2F2kuaslrMyciD2zuQWvCqCp3M+CBDQAhGY00bp?=
 =?us-ascii?Q?UtPsnYWn5H50wntN1g92wa5xuzI8SyeeSDR2+Ic7S0pP/QH9RCcf4/lN18oL?=
 =?us-ascii?Q?GNjGMWwwF2CIAyZtwKmRu11ZpNYTaq1jg/hf0jmhwwaRMWELqsrGH+ScCf8V?=
 =?us-ascii?Q?V+qJMTfh3aKlRXg7bB882Xi4vKon9Reo3iawuIjhLP5D72Zs5nJvjF68mgRa?=
 =?us-ascii?Q?4qiJbzIwAF4AP5G95e6W4n+AQ/C8ZR0+LT0GUOaWdex/wJRgyQOKekWWp+8y?=
 =?us-ascii?Q?QBGE3KfROaI5o7qZ8e71F8v+eWV32QfU9QN+tBU5OB3PshMtrW7NjMmkvfLT?=
 =?us-ascii?Q?sqU150lm/kV5ISUGMrO2a5bejEbwVDuZ/NSVV03TrW62z+fFxOSXomPFkmwg?=
 =?us-ascii?Q?V+krvFF1Uxi0HibDPVMcohazibCvhP6/42tQzxJd1bI7Mq+cu+oD76S6yCw0?=
 =?us-ascii?Q?Ub9twTzWXxucauHI/DzuQpIQfPDsT98axPnV19SZdXmJ7k8RH4BFm1MMoJ7a?=
 =?us-ascii?Q?Yn5bRuXjCxAB5oA87I7u+gtEBGTk/FFx9be1HXcc9xapdfoFN+4ce1MK1wCa?=
 =?us-ascii?Q?SkJC2Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f226fd05-65d2-407f-ce19-08daf03ee11f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 23:36:48.3974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTbHn23HWer12jEeW1kavILHmy0t6l/cxCxvCm0WO14WWgPp8SodGbkXeuSQLy2uvKR1CcrP735kBs5YITzuSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5888
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxim,

I am working on an updated patch based on your comments. I have further
comments below.

-- Rahul Rameshbabu

Maxim Mikityanskiy <maxtram95@gmail.com> writes:

> On Thu, 5 Jan 2023 at 08:03, Rahul Rameshbabu <rrameshbabu@nvidia.com> wrote:
>>
>> Maxim Mikityanskiy <maxtram95@gmail.com> writes:
>>
>> > On Wed, 4 Jan 2023 at 19:53, Rahul Rameshbabu <rrameshbabu@nvidia.com> wrote:
>> >>
>> >> When the netdev qdisc is updated correctly with the new qdisc before
>> >> destroying the old qdisc, the netdev should not be activated till cleanup
>> >> is completed. When htb_destroy_class_offload called htb_graft_helper, the
>> >> netdev may be activated before cleanup is completed.
>> >
>> > Oh, so that's what was happening! Now I get the full picture:
>> >
>> > 1. The user does RTM_DELQDISC.
>> > 2. qdisc_graft calls dev_deactivate, which sets dev_queue->qdisc to
>> > NULL, but keeps dev_queue->qdisc_sleeping.
>> > 3. The loop in qdisc_graft calls dev_graft_qdisc(dev_queue, new),
>> > where new is NULL, for each queue.
>> > 4. Then we get into htb_destroy_class_offload, and it's important
>> > whether dev->qdisc is still HTB (before Eric's patch) or noop_qdisc
>> > (after Eric's patch).
>> > 5. If dev->qdisc is noop_qdisc, and htb_graft_helper accidentally
>> > activates the netdev, attach_default_qdiscs will be called, and
>> > dev_queue->qdisc will no longer be NULL for the rest of the queues,
>> > hence the WARN_ON triggering.
>> >
>> > Nice catch indeed, premature activation of the netdev wasn't intended.
>> >
>> >> The new netdev qdisc
>> >> may be used prematurely by queues before cleanup is done. Call
>> >> dev_graft_qdisc in place of htb_graft_helper when destroying the htb to
>> >> prevent premature netdev activation.
>> >>
>> >> Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
>> >> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
>> >> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
>> >> Cc: Eric Dumazet <edumazet@google.com>
>> >> Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
>> >> ---
>> >>  net/sched/sch_htb.c | 8 +++++---
>> >>  1 file changed, 5 insertions(+), 3 deletions(-)
>> >>
>> >> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>> >> index 2238edece1a4..f62334ef016a 100644
>> >> --- a/net/sched/sch_htb.c
>> >> +++ b/net/sched/sch_htb.c
>> >> @@ -1557,14 +1557,16 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
>> >>
>> >>         WARN_ON(!q);
>> >>         dev_queue = htb_offload_get_queue(cl);
>> >> -       old = htb_graft_helper(dev_queue, NULL);
>> >> -       if (destroying)
>> >> +       if (destroying) {
>> >> +               old = dev_graft_qdisc(dev_queue, NULL);
>> >>                 /* Before HTB is destroyed, the kernel grafts noop_qdisc to
>> >>                  * all queues.
>> >>                  */
>> >>                 WARN_ON(!(old->flags & TCQ_F_BUILTIN));
>> >
>> > Now regarding this WARN_ON, I have concerns about its correctness.
>> >
>> > Can the user replace the root qdisc from HTB to something else with a
>> > single command? I.e. instead of `tc qdisc del dev eth2 root handle 1:`
>> > do `tc qdisc replace ...` or whatever that causes qdisc_graft to be
>> > called with new != NULL? If that is possible, then:
>> >
>> > 1. `old` won't be noop_qdisc, but rather the new qdisc (if it doesn't
>> > support the attach callback) or the old one left from HTB (old == q,
>> > if the new qdisc supports the attach callback). WARN_ON should
>> > trigger.
>> >
>> > 2. We shouldn't even call dev_graft_qdisc in this case (if destroying
>> > is true). Likewise, we shouldn't try to revert it on errors or call
>> > qdisc_put on it.
>> >
>> > Could you please try to reproduce this scenario of triggering WARN_ON?
>> > I remember testing it, and something actually prevented me from doing
>> > a replacement, but maybe I just missed something back then.
>> >
>>
>> Reproduction steps
>>
>>   ip link set dev eth2 up
>>   ip link set dev eth2 up
>>   ip addr add 194.237.173.123/16 dev eth2
>>   tc qdisc add dev eth2 clsact
>>   tc qdisc add dev eth2 root handle 1: htb default 1 offload
>>   tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil 22500.0mbit burst 450000kbit cburst 450000kbit
>>   tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst 89900kbit cburst 89900kbit
>>   tc qdisc replace dev eth2 root pfifo
>>
>> The warning is indeed triggered because the new root is pfifo rather
>> than noop_qdisc. I agree with both points you brought up in the patch.
>> When I saw the ternary in qdisc_graft for the rcu_assign_pointer call, I
>> was worried about the case when new was defined as a new qdisc rather
>> than defaulting to noop_qdisc but assumed there were some guaratees for
>> htb.
>
> OK, so that means my WARN_ON relies on false guarantees.
>
>> However, I see a number of functions, not
>> just offload related ones, in the htb implementation that seem to depend
>> on the assumption that the old qdisc can safely be accessed with helpers
>> such as htb_graft_helper. One such example is htb_change_class.
>
> htb_graft_helper is only used by the offload, you can see that all
> usages are guarded by if (q->offload).
>
>> The
>> trivial solution I see is to change qdisc_graft to first do a
>> rcu_assign_pointer with noop_qdisc, call notify_and_destroy, and only
>> afterwards call rcu_assign_pointer with the new qdisc if defined. Let me
>> know your thoughts on this.
>
> I don't think it's a good idea to introduce such a change to generic
> code just to fix HTB offload. It would basically remove the ability to
> replace the qdisc atomically, and there will be periods of time when
> all packets are dropped.
>
>> I believe the correct fix for a robust implementation of
>> htb_destroy_class_offload would be to not depend on functions that
>> retrieve the top level qdisc.
>
> This is actually the case. The source of truth is internal data
> structures of HTB, specifically cl->leaf.q points to the queue qdisc,
> and cl->leaf.offload_queue points to the queue itself (the latter is
> very useful when the qdisc is noop_qdisc, and we can't retrieve
> dev_queue from the qdisc itself). Whenever we take a qdisc from the
> netdev_queue itself, it should be only to check consistency with the
> source of truth (please tell me if you spotted some places where it's
> used for something else).

Yeah, I did catch the qdisc taken from the netdev_queue used in such a
way but only in one place. This is in htb_change_class in what appears
to be an offload context (I misread in my earlier comment). It's just
the call to _bstats_update though. Should it be changed to
parent->leaf.q (since it should be the source of truth for the htb
structure in this context) in the event the WARN_ON is encountered
(shouldn't happen normally hence the WARN_ON to ensure this guarantee)?

  dev_queue = htb_offload_get_queue(parent);
  old_q = htb_graft_helper(dev_queue, NULL);
  WARN_ON(old_q != parent->leaf.q);
  offload_opt = (struct tc_htb_qopt_offload) {
    .command = TC_HTB_LEAF_TO_INNER,
    .classid = cl->common.classid,
    .parent_classid =
      TC_H_MIN(parent->common.classid),
    .rate = max_t(u64, hopt->rate.rate, rate64),
    .ceil = max_t(u64, hopt->ceil.rate, ceil64),
    .extack = extack,
  };
  err = htb_offload(dev, &offload_opt);
  if (err) {
    pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
            err);
    htb_graft_helper(dev_queue, old_q);
    goto err_kill_estimator;
  }
  _bstats_update(&parent->bstats_bias,
            u64_stats_read(&old_q->bstats.bytes),
            u64_stats_read(&old_q->bstats.packets));

>
> What I suggest to do to fix this particular bug:
>
> 1. Remove the WARN_ON check for noop_qdisc on destroy, it's simply
> invalid. Rephrase the comment to explain why you WARN_ON(old != q)
> only when !destroying.
>
> 2. Don't graft anything on destroy, the kernel has already replaced
> the qdisc with the right one (noop_qdisc on delete, the new qdisc on
> replace).
>
> 3. qdisc_put down below shouldn't be called when destroying, because
> we didn't graft anything ourselves. We should still call
> qdisc_put(old) when err == 0 to drop the ref (we hold one ref for
> cl->leaf.q and the other ref for dev_queue->qdisc, which is normally
> the same qdisc). And we should still graft old back on errors, but not
> when destroying (we ignore all errors on destroy and just go on, we
> can't fail).

Ack.

>
>>
>>   [  384.474535] ------------[ cut here ]------------
>>   [  384.476685] WARNING: CPU: 2 PID: 1038 at net/sched/sch_htb.c:1561 htb_destroy_class_offload+0x179/0x430 [sch_htb]
>>   [ 384.481217] Modules linked in: sch_htb sch_ingress xt_conntrack
>> xt_MASQUERADE nf_conntrack_netlink nfnetlink xt_addrtype iptable_nat nf_nat
>> br_netfilter overlay rpcrdma rdma_ucm ib_iser libiscsi scsi_transport_iscsi
>> rdma_cm iw_cm ib_umad ib_ipoib ib_cm mlx5_ib ib_uverbs ib_core fuse mlx5_core
>>   [  384.487081] CPU: 2 PID: 1038 Comm: tc Not tainted 6.1.0-rc2_for_upstream_min_debug_2022_10_24_15_44 #1
>>   [  384.488414] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>>   [  384.489987] RIP: 0010:htb_destroy_class_offload+0x179/0x430 [sch_htb]
>>   [  384.490937] Code: 2b 04 25 28 00 00 00 0f 85 cb 02 00 00 48 83 c4 48 44 89 f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 f6 45 10 01 0f 85 26 ff ff ff <0f> 0b e9 1f ff ff ff 4d 3b 7e 40 0f 84 d9 fe ff ff 0f 0b e9 d2 fe
>>   [  384.493495] RSP: 0018:ffff88815162b840 EFLAGS: 00010246
>>   [  384.494358] RAX: 000000000000002a RBX: ffff88810e040000 RCX: 0000000021800002
>>   [  384.495461] RDX: 0000000021800000 RSI: 0000000000000246 RDI: ffff88810e0404c0
>>   [  384.496581] RBP: ffff888151ea0c00 R08: 0000000100006174 R09: ffffffff82897070
>>   [  384.497684] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000001
>>   [  384.498923] R13: ffff88810b189200 R14: ffff88810b189a00 R15: ffff888110060a00
>>   [  384.500044] FS:  00007f7a2e7a3800(0000) GS:ffff88852cc80000(0000) knlGS:0000000000000000
>>   [  384.501390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>   [  384.502339] CR2: 0000000000487598 CR3: 0000000151f41003 CR4: 0000000000370ea0
>>   [  384.503458] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>   [  384.504581] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>   [  384.505699] Call Trace:
>>   [  384.506231]  <TASK>
>>   [  384.506691]  ? tcf_block_put+0x74/0xa0
>>   [  384.507365]  htb_destroy+0x142/0x3c0 [sch_htb]
>>   [  384.508131]  ? hrtimer_cancel+0x11/0x40
>>   [  384.508832]  ? rtnl_is_locked+0x11/0x20
>>   [  384.509522]  ? htb_reset+0xe3/0x1a0 [sch_htb]
>>   [  384.510293]  qdisc_destroy+0x3b/0xd0
>>   [  384.510943]  qdisc_graft+0x40b/0x590
>>   [  384.511600]  tc_modify_qdisc+0x577/0x870
>>   [  384.512309]  rtnetlink_rcv_msg+0x2a2/0x390
>>   [  384.513031]  ? rtnl_calcit.isra.0+0x120/0x120
>>   [  384.513806]  netlink_rcv_skb+0x54/0x100
>>   [  384.514495]  netlink_unicast+0x1f6/0x2c0
>>   [  384.515190]  netlink_sendmsg+0x237/0x490
>>   [  384.515890]  sock_sendmsg+0x33/0x40
>>   [  384.516556]  ____sys_sendmsg+0x1d1/0x1f0
>>   [  384.517265]  ___sys_sendmsg+0x72/0xb0
>>   [  384.517942]  ? ___sys_recvmsg+0x7c/0xb0
>>   [  384.518631]  __sys_sendmsg+0x51/0x90
>>   [  384.519289]  do_syscall_64+0x3d/0x90
>>   [  384.519943]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>   [  384.520794] RIP: 0033:0x7f7a2eaccc17
>>   [  384.521449] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
>>   [  384.524306] RSP: 002b:00007ffd8c62fe78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>>   [  384.525568] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7a2eaccc17
>>   [  384.526703] RDX: 0000000000000000 RSI: 00007ffd8c62fee0 RDI: 0000000000000003
>>   [  384.527828] RBP: 0000000063b66264 R08: 0000000000000001 R09: 00007f7a2eb8da40
>>   [  384.528962] R10: 0000000000405aeb R11: 0000000000000246 R12: 0000000000000001
>>   [  384.530097] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000485400
>>   [  384.531221]  </TASK>
>>   [  384.531689] ---[ end trace 0000000000000000 ]---
>>
>> >> -       else
>> >> +       } else {
>> >> +               old = htb_graft_helper(dev_queue, NULL);
>> >>                 WARN_ON(old != q);
>> >> +       }
>> >>
>> >>         if (cl->parent) {
>> >>                 _bstats_update(&cl->parent->bstats_bias,
>> >> --
>> >> 2.36.2
>> >>
