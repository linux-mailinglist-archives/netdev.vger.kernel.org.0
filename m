Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83D857D2CE
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiGURxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiGURxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:53:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C27E8AB11
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:53:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id d7-20020a17090a564700b001f209736b89so6018607pji.0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bVxUuMH2K4/3xSGEVwgyfRhArnGbYyZKUTLiFm9ahIM=;
        b=kmmioxovSdVGYFxvK07nBGQVjfxU7OYjZYxbZzdsdTTULfQkE8Bp+3tAZmvvuXluAe
         B7llqf41ywZ0Dkp9rJc/J0zJAK6KDZZNKfm27o1I8N9RRNvaWrU1fEQCZ1Rc08AaXeB0
         sS/vEQaIlqHANycTwgptI/XbKiBixSn5XkN0kj0EOo/SzvEzYfKqdeVP6Vag4i5JnCX0
         PxvUCQbNDXhtbvFLisjRZDbqS/2q5FclxrhL3aKLO+l6M16PPzlhmmhgvK3edUAy3pL3
         irvOTdY5UvCC6AxUTWYfRkQ6dnIYh6SunoUIqO0j9s5O46SEZKpJoiWo/zvfbBIw61a5
         FkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bVxUuMH2K4/3xSGEVwgyfRhArnGbYyZKUTLiFm9ahIM=;
        b=zLp+Dmt0VAGZEkAS8yK5pe8O00AEG7ZTI0N/v1d7eoLDEvdfljjivhjd3zNBzzXsCA
         cI3H4LctZw1miOhbq0apwMT8lqtHfqKNGHB53bTKJj/6Yez4UlYEhIjWehmK4Swuck4T
         Fuy5tMGA/W0Eur3Mi9H+GYFfNv04E5PcZZ6bMZKa2X2TAfMuxpeYQK6xeBS9xpkcfsHF
         OEx+bxYH7abNSvcuK69J3QUrVOZUSWM4NXZBueoSeQg2h6AnyvZlmgzmdBZYxwych3ct
         tSVrLe0Lf9lnOgCzQuA59YjNDsuQqyQaTvczAtoW+igzc3Ws74woYZNjodTRvRIltOaI
         Ow3Q==
X-Gm-Message-State: AJIora/w2kz8wq5d0kd9PoPMY3ZOqmPi69Kh386FJHbAYY5Oxj88+D7M
        HjMnTDOhYwh0A6r7DxWSods=
X-Google-Smtp-Source: AGRyM1t5SCPLrTWUXqvSsSMIkJcTgAsh8mNDa3kyfwRepVL/QaEdop+AOckUKAuTrWaevuxD1vjYag==
X-Received: by 2002:a17:90b:17c4:b0:1f0:4482:8efc with SMTP id me4-20020a17090b17c400b001f044828efcmr12109610pjb.207.1658425993805;
        Thu, 21 Jul 2022 10:53:13 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id 6-20020a620606000000b005255489187fsm2086799pfg.135.2022.07.21.10.53.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 10:53:13 -0700 (PDT)
Message-ID: <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
Date:   Fri, 22 Jul 2022 02:53:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: mld: do not use system_wq in the mld
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20220721120316.17070-1-ap420073@gmail.com>
 <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,
Thank you so much for your review!

On 7/21/22 23:04, Eric Dumazet wrote:
 > On Thu, Jul 21, 2022 at 2:03 PM Taehee Yoo <ap420073@gmail.com> wrote:
 >>
 >> mld works are supposed to be executed in mld_wq.
 >> But mld_{query | report}_work() calls schedule_delayed_work().
 >> schedule_delayed_work() internally uses system_wq.
 >> So, this would cause the reference count leak.
 >
 > I do not think the changelog is accurate.
 > At least I do not understand it yet.
 >
 > We can not unload the ipv6 module, so destroy_workqueue(mld_wq) is 
never used.
 >
 >
 >
 >>
 >> splat looks like:
 >>   unregister_netdevice: waiting for br1 to become free. Usage count = 2
 >>   leaked reference.
 >>    ipv6_add_dev+0x3a5/0x1070
 >>    addrconf_notify+0x4f3/0x1760
 >>    notifier_call_chain+0x9e/0x180
 >>    register_netdevice+0xd10/0x11e0
 >>    br_dev_newlink+0x27/0x100 [bridge]
 >>    __rtnl_newlink+0xd85/0x14e0
 >>    rtnl_newlink+0x5f/0x90
 >>    rtnetlink_rcv_msg+0x335/0x9a0
 >>    netlink_rcv_skb+0x121/0x350
 >>    netlink_unicast+0x439/0x710
 >>    netlink_sendmsg+0x75f/0xc00
 >>    ____sys_sendmsg+0x694/0x860
 >>    ___sys_sendmsg+0xe9/0x160
 >>    __sys_sendmsg+0xbe/0x150
 >>    do_syscall_64+0x3b/0x90
 >>    entry_SYSCALL_64_after_hwframe+0x63/0xcd
 >>
 >> Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >> ---
 >>   net/ipv6/mcast.c | 14 ++++++++------
 >>   1 file changed, 8 insertions(+), 6 deletions(-)
 >>
 >> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
 >> index 7f695c39d9a8..87c699d57b36 100644
 >> --- a/net/ipv6/mcast.c
 >> +++ b/net/ipv6/mcast.c
 >> @@ -1522,7 +1522,6 @@ static void mld_query_work(struct work_struct 
*work)
 >>
 >>                  if (++cnt >= MLD_MAX_QUEUE) {
 >>                          rework = true;
 >> -                       schedule_delayed_work(&idev->mc_query_work, 0);
 >>                          break;
 >>                  }
 >>          }
 >> @@ -1533,8 +1532,10 @@ static void mld_query_work(struct work_struct 
*work)
 >>                  __mld_query_work(skb);
 >>          mutex_unlock(&idev->mc_lock);
 >>
 >> -       if (!rework)
 >> -               in6_dev_put(idev);
 >> +       if (rework && queue_delayed_work(mld_wq, 
&idev->mc_query_work, 0))
 >
 > It seems the 'real issue' was that
 > schedule_delayed_work(&idev->mc_query_work, 0) could be a NOP
 > because the work queue was already scheduled ?
 >

I think your assumption is right.
I tested the below scenario, which occurs the real issue.
THREAD0                            THREAD1
mld_report_work()
                                    spin_lock_bh()
                                    if (!mod_delayed_work()) <-- queued
                                            in6_dev_hold();
                                    spin_unlock_bh()
spin_lock_bh()
schedule_delayed_work() <-- return false, already queued by THREAD1
spin_unlock_bh()
return;
//no in6_dev_put() regardless return value of schedule_delayed_work().

In order to check, I added printk like below.
         if (++cnt >= MLD_MAX_QUEUE) { 

                 rework = true; 

                 if (!schedule_delayed_work(&idev->mc_report_work, 0))
                         printk("[TEST]%s %u \n", __func__, __LINE__);
                 break; 


If the TEST log message is printed, work is already queued by other logic.
So, it indicates a reference count is leaked.
The result is that I can see log messages only when the reference count 
leak occurs.
So, although I tested it only for 1 hour, I'm sure that this bug comes 
from missing check a return value of schedule_delayed_work().

As you said, this changelog is not correct.
system_wq and mld_wq are not related to this issue.

I would like to send a v2 patch after some more tests.
The v2 patch will change the commit message.

 >
 >
 >> +               return;
 >> +
 >> +       in6_dev_put(idev);
 >>   }
 >>
 >>   /* called with rcu_read_lock() */
 >> @@ -1624,7 +1625,6 @@ static void mld_report_work(struct work_struct 
*work)
 >>
 >>                  if (++cnt >= MLD_MAX_QUEUE) {
 >>                          rework = true;
 >> -                       schedule_delayed_work(&idev->mc_report_work, 0);
 >>                          break;
 >>                  }
 >>          }
 >> @@ -1635,8 +1635,10 @@ static void mld_report_work(struct 
work_struct *work)
 >>                  __mld_report_work(skb);
 >>          mutex_unlock(&idev->mc_lock);
 >>
 >> -       if (!rework)
 >> -               in6_dev_put(idev);
 >> +       if (rework && queue_delayed_work(mld_wq, 
&idev->mc_report_work, 0))
 >> +               return;
 >> +
 >> +       in6_dev_put(idev);
 >>   }
 >>
 >>   static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, 
int type,
 >> --
 >> 2.17.1
 >>

Thanks a lot!
Taehee Yoo
