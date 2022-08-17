Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404B5596A4D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiHQHVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiHQHVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:21:09 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5860E71BCE;
        Wed, 17 Aug 2022 00:21:08 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M6zqs59jLz1M95S;
        Wed, 17 Aug 2022 15:17:45 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 15:21:05 +0800
Message-ID: <dcffa2ce-afaf-3e32-26ce-679402029eb7@huawei.com>
Date:   Wed, 17 Aug 2022 15:21:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next] net: sched: make tcf_action_dump_1() static
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220815070122.113871-1-shaozhengchao@huawei.com>
 <CAM0EoMnc3Mc1+SNbKeRf0ecJ4g66=1xqFJ4X=Gb=s125TPucPQ@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CAM0EoMnc3Mc1+SNbKeRf0ecJ4g66=1xqFJ4X=Gb=s125TPucPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/8/15 19:53, Jamal Hadi Salim wrote:
> You shouldnt have so many line changes to remove the EXPORT and change
> "int" to "static int".
> What am i missing?
> Unnecessary line changes add extra effort to git archeology
> 
> cheers,
> jamal
> 
> On Mon, Aug 15, 2022 at 2:58 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>
>> Function tcf_action_dump_1() is not used outside of act_api.c, so remove
>> the superfluous EXPORT_SYMBOL() and marks it static.
>>
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   include/net/act_api.h |   1 -
>>   net/sched/act_api.c   | 100 +++++++++++++++++++++---------------------
>>   2 files changed, 49 insertions(+), 52 deletions(-)
>>
>> diff --git a/include/net/act_api.h b/include/net/act_api.h
>> index 9cf6870b526e..d51b3f931771 100644
>> --- a/include/net/act_api.h
>> +++ b/include/net/act_api.h
>> @@ -215,7 +215,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>>   int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[], int bind,
>>                      int ref, bool terse);
>>   int tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int, int);
>> -int tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int, int);
>>
>>   static inline void tcf_action_update_bstats(struct tc_action *a,
>>                                              struct sk_buff *skb)
>> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>> index b69fcde546ba..9fd98bf5c724 100644
>> --- a/net/sched/act_api.c
>> +++ b/net/sched/act_api.c
>> @@ -510,6 +510,55 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
>>          return -1;
>>   }
>>
>> +int
>> +tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>> +{
>> +       return a->ops->dump(skb, a, bind, ref);
>> +}
>> +
>> +static int
>> +tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>> +{
>> +       int err = -EINVAL;
>> +       unsigned char *b = skb_tail_pointer(skb);
>> +       struct nlattr *nest;
>> +       u32 flags;
>> +
>> +       if (tcf_action_dump_terse(skb, a, false))
>> +               goto nla_put_failure;
>> +
>> +       if (a->hw_stats != TCA_ACT_HW_STATS_ANY &&
>> +           nla_put_bitfield32(skb, TCA_ACT_HW_STATS,
>> +                              a->hw_stats, TCA_ACT_HW_STATS_ANY))
>> +               goto nla_put_failure;
>> +
>> +       if (a->used_hw_stats_valid &&
>> +           nla_put_bitfield32(skb, TCA_ACT_USED_HW_STATS,
>> +                              a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
>> +               goto nla_put_failure;
>> +
>> +       flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
>> +       if (flags &&
>> +           nla_put_bitfield32(skb, TCA_ACT_FLAGS,
>> +                              flags, flags))
>> +               goto nla_put_failure;
>> +
>> +       if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
>> +               goto nla_put_failure;
>> +
>> +       nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
>> +       if (!nest)
>> +               goto nla_put_failure;
>> +       err = tcf_action_dump_old(skb, a, bind, ref);
>> +       if (err > 0) {
>> +               nla_nest_end(skb, nest);
>> +               return err;
>> +       }
>> +
>> +nla_put_failure:
>> +       nlmsg_trim(skb, b);
>> +       return -1;
>> +}
>>   static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
>>                             struct netlink_callback *cb)
>>   {
>> @@ -1132,57 +1181,6 @@ static void tcf_action_put_many(struct tc_action *actions[])
>>          }
>>   }
>>
>> -int
>> -tcf_action_dump_old(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>> -{
>> -       return a->ops->dump(skb, a, bind, ref);
>> -}
>> -
>> -int
>> -tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>> -{
>> -       int err = -EINVAL;
>> -       unsigned char *b = skb_tail_pointer(skb);
>> -       struct nlattr *nest;
>> -       u32 flags;
>> -
>> -       if (tcf_action_dump_terse(skb, a, false))
>> -               goto nla_put_failure;
>> -
>> -       if (a->hw_stats != TCA_ACT_HW_STATS_ANY &&
>> -           nla_put_bitfield32(skb, TCA_ACT_HW_STATS,
>> -                              a->hw_stats, TCA_ACT_HW_STATS_ANY))
>> -               goto nla_put_failure;
>> -
>> -       if (a->used_hw_stats_valid &&
>> -           nla_put_bitfield32(skb, TCA_ACT_USED_HW_STATS,
>> -                              a->used_hw_stats, TCA_ACT_HW_STATS_ANY))
>> -               goto nla_put_failure;
>> -
>> -       flags = a->tcfa_flags & TCA_ACT_FLAGS_USER_MASK;
>> -       if (flags &&
>> -           nla_put_bitfield32(skb, TCA_ACT_FLAGS,
>> -                              flags, flags))
>> -               goto nla_put_failure;
>> -
>> -       if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
>> -               goto nla_put_failure;
>> -
>> -       nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
>> -       if (nest == NULL)
>> -               goto nla_put_failure;
>> -       err = tcf_action_dump_old(skb, a, bind, ref);
>> -       if (err > 0) {
>> -               nla_nest_end(skb, nest);
>> -               return err;
>> -       }
>> -
>> -nla_put_failure:
>> -       nlmsg_trim(skb, b);
>> -       return -1;
>> -}
>> -EXPORT_SYMBOL(tcf_action_dump_1);
>> -
>>   int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[],
>>                      int bind, int ref, bool terse)
>>   {
>> --
>> 2.17.1
>>
> 

Hi Jamal，
	Thank you for your reply. Maybe just declare function in the file 
without moving the line number?

Zhengchao Shao
