Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477B35A5881
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 02:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiH3Ao6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 20:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiH3Ao4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 20:44:56 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0ADA5FD7;
        Mon, 29 Aug 2022 17:44:52 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MGpRj3vxQznTqx;
        Tue, 30 Aug 2022 08:42:25 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 08:44:50 +0800
Message-ID: <368a9fef-740b-eac7-072a-d230cd4f6b1f@huawei.com>
Date:   Tue, 30 Aug 2022 08:44:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next,v2 1/3] net: sched: choke: remove unused
 variables in struct choke_sched_data
To:     Eric Dumazet <edumazet@google.com>
CC:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, <weiyongjun1@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>
References: <20220829081704.255235-1-shaozhengchao@huawei.com>
 <20220829081704.255235-2-shaozhengchao@huawei.com>
 <CANn89iLqXB-O7AP5qf+gGtK48fgYYxpciCyZa76jJNac9Bq1aQ@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CANn89iLqXB-O7AP5qf+gGtK48fgYYxpciCyZa76jJNac9Bq1aQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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



On 2022/8/30 1:08, Eric Dumazet wrote:
> On Mon, Aug 29, 2022 at 1:14 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>
>> The variable "other" in the struct choke_sched_data is not used. Remove it.
>>
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>> v1: qdisc_drop() already counts drops, unnecessary to use "other" to duplicate the same information.
>> ---
>>   include/uapi/linux/pkt_sched.h | 1 -
>>   net/sched/sch_choke.c          | 2 --
>>   2 files changed, 3 deletions(-)
>>
>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
>> index f292b467b27f..32d49447cc7a 100644
>> --- a/include/uapi/linux/pkt_sched.h
>> +++ b/include/uapi/linux/pkt_sched.h
>> @@ -396,7 +396,6 @@ struct tc_choke_qopt {
>>   struct tc_choke_xstats {
>>          __u32           early;          /* Early drops */
>>          __u32           pdrop;          /* Drops due to queue limits */
>> -       __u32           other;          /* Drops due to drop() calls */
> 
> You can not remove a field in UAPI.
> 
>>          __u32           marked;         /* Marked packets */
>>          __u32           matched;        /* Drops due to flow match */
>>   };
>> diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
>> index 25d2daaa8122..3ac3e5c80b6f 100644
>> --- a/net/sched/sch_choke.c
>> +++ b/net/sched/sch_choke.c
>> @@ -60,7 +60,6 @@ struct choke_sched_data {
>>                  u32     forced_drop;    /* Forced drops, qavg > max_thresh */
>>                  u32     forced_mark;    /* Forced marks, qavg > max_thresh */
>>                  u32     pdrop;          /* Drops due to queue limits */
>> -               u32     other;          /* Drops due to drop() calls */
>>                  u32     matched;        /* Drops to flow match */
>>          } stats;
>>
>> @@ -464,7 +463,6 @@ static int choke_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
>>                  .early  = q->stats.prob_drop + q->stats.forced_drop,
>>                  .marked = q->stats.prob_mark + q->stats.forced_mark,
>>                  .pdrop  = q->stats.pdrop,
>> -               .other  = q->stats.other,
>>                  .matched = q->stats.matched,
>>          };
>>
>> --
>> 2.17.1
>>

Hi Eric:
	Thanks for the heads up. I'll pay attention in the future.

Zhengchao Shao
