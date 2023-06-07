Return-Path: <netdev+bounces-8900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2AA726398
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43015281296
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA6C1ACBF;
	Wed,  7 Jun 2023 15:02:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3A1ACBB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:02:24 +0000 (UTC)
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348E42103
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:02:15 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1a196784a4cso467168fac.1
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 08:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686150133; x=1688742133;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2qAxT/R+HpbFYxwfQDqG6aZkmtWtVsKV+dhh4zLlAns=;
        b=0M0PNhqz0V8jzCyGAmgRGORAji7GQ49SGXAzpQvPg/kFnLDM/PmFxALmgCURiD+5Pp
         Bl6r0ivWp/XgZE9ncF2S88XxqgdwygXvPqDK1GXdxBpE5TjiuXQo2jNUxjVTY4cf81Sr
         EgUHSclPc78WOq4L1cI9kAnBXMWvd06T3oqRydgIoXnsDCxBh7PKlbmAtpXSYnr4GZ4d
         VJS5lZxwiwSft60iTmtjDFFHX/InlgkJcSmgSqhZg9wyEh72saAHrIr1tLEgnrE+OZaT
         6X2q9MnhjW8MvWn8EShkimGeT4GEfQd7zLUkiLdm3vIysjCbnMUavPATluXqIk51MrTR
         +MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686150133; x=1688742133;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qAxT/R+HpbFYxwfQDqG6aZkmtWtVsKV+dhh4zLlAns=;
        b=d+5Ycs3TuELLTEADdMrtKwOusfrAtV+h19YGdFz4Wvey9jAUqoN0EYoYBN85O/4OmW
         QlwqbJgRiPQbKC3/ugWbyxK9ThzpiNReX53xSry5a/4pDwolH06sFUVz8+h+Dp780hMY
         sgWPNJXjVr6PMRyPxNBUy3nREGiUGQ6sfrt52oohKK8gcgdVRoZurZzccUbG9+Q7b+Uy
         FOvI9vvnRawAFOn9kAn6yaVdvH9lemPaWaVHAjyqSX994a2dvWtEpINzFgSjyPTmCldE
         sQOkOSYIZCngDvMblehk7V/jgzmYZZMsd3B5Crdjcu4JsAth6hwMVvBoC+SJMHcUcmY0
         THRg==
X-Gm-Message-State: AC+VfDxzHksANmYm7q5bXHk2TtxmCGK1yNUGcJbABsp5N2MUO3HSqFPj
	GIimCwIykiXQQmc5z5QG3tChlV4DnPi9mijrIRQ=
X-Google-Smtp-Source: ACHHUZ5QcMrIID6RYx/DVnVKpV935j4lAhZVf5FPs7QTeWboIgReIZ2/M0vn42FjqV65jj1LqFXYng==
X-Received: by 2002:a05:6870:148e:b0:1a2:865c:eadc with SMTP id k14-20020a056870148e00b001a2865ceadcmr3383577oab.29.1686150133322;
        Wed, 07 Jun 2023 08:02:13 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:9148:dfc3:4a0d:3b4e? ([2804:14d:5c5e:44fb:9148:dfc3:4a0d:3b4e])
        by smtp.gmail.com with ESMTPSA id n1-20020a056870e40100b0019a3bbeeb34sm5944311oag.40.2023.06.07.08.02.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 08:02:12 -0700 (PDT)
Message-ID: <3679ed57-a0b9-4af2-cf83-e8aaa4bbd29e@mojatatu.com>
Date: Wed, 7 Jun 2023 12:02:07 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] net/sched: Set the flushing flags to false to prevent an
 infinite loop
Content-Language: en-US
To: renmingshuai <renmingshuai@huawei.com>
Cc: caowangbao@huawei.com, davem@davemloft.net, edumazet@google.com,
 jhs@mojatatu.com, jiri@resnulli.us, kuba@kernel.org, liaichun@huawei.com,
 linux-kernel@vger.kernel.org, liubo335@huawei.com, netdev@vger.kernel.org,
 pabeni@redhat.com, xiyou.wangcong@gmail.com, yanan@huawei.com
References: <81cd0ecb-29a6-d748-8962-dc741a02e691@mojatatu.com>
 <20230607041920.2012792-1-renmingshuai@huawei.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230607041920.2012792-1-renmingshuai@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 07/06/2023 01:19, renmingshuai wrote:
>> On 06/06/2023 11:45, renmingshuai wrote:
>>> When a new chain is added by using tc, one soft lockup alarm will be
>>>    generated after delete the prio 0 filter of the chain. To reproduce
>>>    the problem, perform the following steps:
>>> (1) tc qdisc add dev eth0 root handle 1: htb default 1
>>> (2) tc chain add dev eth0
>>> (3) tc filter del dev eth0 chain 0 parent 1: prio 0
>>> (4) tc filter add dev eth0 chain 0 parent 1:
>>
>> This seems like it could be added to tdc or 3 and 4 must be run in parallel?
> 3 and 4 do not need to be run inparallel. When a new chain is added by the
>   way as step 1 and the step 3 is completed, this problem always occurs
>   whenever step 4 is run.

Got it,
The test still hangs with the provided patch.

+ tc qdisc add dev lo root handle 1: htb default 1
+ tc chain add dev lo
+ tc filter del dev lo chain 0 parent 1: prio 0
[   68.790030][ T6704] [+]
[   68.790060][ T6704] chain refcnt 2
[   68.790951][ T6704] [-]
+ tc filter add dev lo chain 0 parent 1:
<hangs>

Also please add this test to tdc, it should be straightforward.

>>>
>>>
>>> The refcnt of the chain added by step 2 is equal to 1. After step 3,
>>>    the flushing flag of the chain is set to true in the tcf_chain_flush()
>>>    called by tc_del_tfilter() because the prio is 0. In this case, if
>>>    we add a new filter to this chain, it will never succeed and try again
>>>    and again because the refresh flash is always true and refcnt is 1.
>>>    A soft lock alarm is generated 20 seconds later.
>>> The stack is show as below:
>>>
>>> Kernel panic - not syncing: softlockup: hung tasks
>>> CPU: 2 PID: 3321861 Comm: tc Kdump: loaded Tainted: G
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>>> Call Trace:
>>>    <IRQ>
>>>    dump_stack+0x57/0x6e
>>>    panic+0x196/0x3ec
>>>    watchdog_timer_fn.cold+0x16/0x5c
>>>    __run_hrtimer+0x5e/0x190
>>>    __hrtimer_run_queues+0x8a/0xe0
>>>    hrtimer_interrupt+0x110/0x2c0
>>>    ? irqtime_account_irq+0x49/0xf0
>>>    __sysvec_apic_timer_interrupt+0x5f/0xe0
>>>    asm_call_irq_on_stack+0x12/0x20
>>>    </IRQ>
>>>    sysvec_apic_timer_interrupt+0x72/0x80
>>>    asm_sysvec_apic_timer_interrupt+0x12/0x20
>>> RIP: 0010:mutex_lock+0x24/0x70
>>> RSP: 0018:ffffa836004ab9a8 EFLAGS: 00000246
>>> RAX: 0000000000000000 RBX: ffff95bb02d76700 RCX: 0000000000000000
>>> RDX: ffff95bb27462100 RSI: 0000000000000000 RDI: ffff95ba5b527000
>>> RBP: ffff95ba5b527000 R08: 0000000000000001 R09: ffffa836004abbb8
>>> R10: 000000000000000f R11: 0000000000000000 R12: 0000000000000000
>>> R13: ffff95ba5b527000 R14: ffffa836004abbb8 R15: 0000000000000001
>>>    __tcf_chain_put+0x27/0x200
>>>    tc_new_tfilter+0x5e8/0x810
>>>    ? tc_setup_cb_add+0x210/0x210
>>>    rtnetlink_rcv_msg+0x2e3/0x380
>>>    ? rtnl_calcit.isra.0+0x120/0x120
>>>    netlink_rcv_skb+0x50/0x100
>>>    netlink_unicast+0x12d/0x1d0
>>>    netlink_sendmsg+0x286/0x490
>>>    sock_sendmsg+0x62/0x70
>>>    ____sys_sendmsg+0x24c/0x2c0
>>>    ? import_iovec+0x17/0x20
>>>    ? sendmsg_copy_msghdr+0x80/0xa0
>>>    ___sys_sendmsg+0x75/0xc0
>>>    ? do_fault_around+0x118/0x160
>>>    ? do_read_fault+0x68/0xf0
>>>    ? __handle_mm_fault+0x3f9/0x6f0
>>>    __sys_sendmsg+0x59/0xa0
>>>    do_syscall_64+0x33/0x40
>>>    entry_SYSCALL_64_after_hwframe+0x61/0xc6
>>> RIP: 0033:0x7f96705b8247
>>> RSP: 002b:00007ffe552e9dc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f96705b8247
>>> RDX: 0000000000000000 RSI: 00007ffe552e9e40 RDI: 0000000000000003
>>> RBP: 0000000000000001 R08: 0000000000000001 R09: 0000558113f678b0
>>> R10: 00007f967069ab00 R11: 0000000000000246 R12: 00000000647ea089
>>> R13: 00007ffe552e9f30 R14: 0000000000000001 R15: 0000558113175f00
>>>
>>> To avoid this case, set chain->flushing to be false if the chain->refcnt
>>>    is 1 after flushing the chain when prio is 0.
>>>
>>> Fixes: 726d061286ce ("net: sched: prevent insertion of new classifiers during chain flush")
>>> Signed-off-by: Ren Mingshuai <renmingshuai@huawei.com>
>>> ---
>>>    net/sched/cls_api.c | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>>> index 2621550bfddc..68be55d75831 100644
>>> --- a/net/sched/cls_api.c
>>> +++ b/net/sched/cls_api.c
>>> @@ -2442,6 +2442,13 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>>>    		tfilter_notify_chain(net, skb, block, q, parent, n,
>>>    				     chain, RTM_DELTFILTER, extack);
>>>    		tcf_chain_flush(chain, rtnl_held);
>>> +		/* Set the flushing flags to false to prevent an infinite loop
>>> +		 * when a new filter is added.
>>> +		 */
>>> +		mutex_lock(&chain->filter_chain_lock);
>>> +		if (chain->refcnt == 1)
>>> +			chain->flushing = false;
>>> +		mutex_unlock(&chain->filter_chain_lock);
>>>    		err = 0;
>>>    		goto errout;
>>>    	}


