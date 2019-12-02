Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7228810E972
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 12:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfLBLRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 06:17:19 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:41617 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbfLBLRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 06:17:19 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0TjimBZi_1575285425;
Received: from jingxuanljxdeMacBook-Pro.local(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0TjimBZi_1575285425)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Dec 2019 19:17:05 +0800
Subject: Re: [PATCH] net: sched: keep __gnet_stats_copy_xxx() same semantics
 for percpu stats
To:     David Miller <davem@davemloft.net>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        john.fastabend@gmail.com, tonylu@linux.alibaba.com,
        netdev@vger.kernel.org
References: <20191128063048.90282-1-dust.li@linux.alibaba.com>
 <20191130.122239.1812288224681402502.davem@davemloft.net>
From:   Dust Li <dust.li@linux.alibaba.com>
Message-ID: <6681fcbd-938a-0028-1e09-0290d63d55fe@linux.alibaba.com>
Date:   Mon, 2 Dec 2019 19:17:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191130.122239.1812288224681402502.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/1/19 4:22 AM, David Miller wrote:
> From: Dust Li <dust.li@linux.alibaba.com>
> Date: Thu, 28 Nov 2019 14:30:48 +0800
>
>> __gnet_stats_copy_basic/queue() support both percpu stat and
>> non-percpu stat, but they are handle in a different manner:
>> 1. For percpu stat, percpu stats are added to the return value;
>> 2. For non-percpu stat, non-percpu stats will overwrite the
>>     return value;
>> We should keep the same semantics for both type.
>>
>> This patch makes percpu stats follow non-percpu's manner by
>> reset the return bstats before add the percpu bstats to it.
>> Also changes the caller in sch_mq.c/sch_mqprio.c to make sure
>> they dump the right statistics for percpu qdisc.
>>
>> One more thing, the sch->q.qlen is not set with nonlock child
>> qdisc in mq_dump()/mqprio_dump(), add that.
>>
>> Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> You are changing way too many things at one time here.
>
> Fix one bug in one patch, for example just fix the missed
> initialization of the per-cpu stats.
>
> The qlen fix is another patch.
>
> And so on and so forth.
>
> Thank you.

OK, I will separate them. Thanks for review !


Thanks.

Dust Li

