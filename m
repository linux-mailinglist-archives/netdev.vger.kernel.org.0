Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467A85A3459
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 06:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiH0EUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 00:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH0EUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 00:20:35 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF6814085;
        Fri, 26 Aug 2022 21:20:33 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MF3Nm3w3LzGpkW;
        Sat, 27 Aug 2022 12:18:48 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 12:20:30 +0800
Message-ID: <865db8c4-63c1-d2f4-585f-26c3be713948@huawei.com>
Date:   Sat, 27 Aug 2022 12:20:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH -next] net: sched: sch_skbprio: add support for qlen
 statistics of each priority in sch_skbprio
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20220825102745.70728-1-shaozhengchao@huawei.com>
 <20220826194616.37abfe9e@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20220826194616.37abfe9e@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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



On 2022/8/27 10:46, Jakub Kicinski wrote:
> On Thu, 25 Aug 2022 18:27:45 +0800 Zhengchao Shao wrote:
>> diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
>> index 7a5e4c454715..fe2bb7bf9d2a 100644
>> --- a/net/sched/sch_skbprio.c
>> +++ b/net/sched/sch_skbprio.c
>> @@ -83,6 +83,7 @@ static int skbprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>>   		__skb_queue_tail(qdisc, skb);
> 
> The skb queue called "qdisc" here (confusingly) already maintains
> a length (also called qlen). Can we just access that variable instead
> of maintaining the same value manually?
> 
>>   		qdisc_qstats_backlog_inc(sch, skb);
>>   		q->qstats[prio].backlog += qdisc_pkt_len(skb);
>> +		q->qstats[prio].qlen++;
> 

Hi Jakub:
	Thank you for your reply. You are right, I have missed something. This 
patch seems to be unnecessary.

Zhengchao Shao
