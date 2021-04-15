Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DEC3602CA
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhDOG4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhDOG4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 02:56:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DBCC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:56:12 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id p6so15454504wrn.9
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 23:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Du5SDuDI5m4xNKlONgH4QccxlDqscFDrvpw/nPkTXUY=;
        b=dsTNnbhIGmizthNZdNNEjKpiV65IeE385vWJ/1Qcb4v9Z+SbE4slYG3vZlXGhm/JmM
         VMrW/hBLZHUiqY/K8aRGrEwKWR0boqv+ZFsoY5j4eZ2gOAtFMPTMPOmWvDhZNs6erAvB
         A9+vuIVQsuezt13bVBZ+QyHLnbiy5X3Vg8YVaNfDcQBDYdelI1ABcJ0WB1oLYJz2s8Ev
         uQc94GMGGJs3sf6uUOZ+X4yqTtb44ew533zWNoW0LB2X387CEhbnvRHCle3ooxtn9Ptl
         hGW4ogt2Jt0aceatrh8c+lGz49EouIvO4sudh/yQbuDvwAL4WzVNqzBigxF4bT5cBMrc
         EKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Du5SDuDI5m4xNKlONgH4QccxlDqscFDrvpw/nPkTXUY=;
        b=Pc773gEcdrO17hQFTvbHhLqCVGQ8mMv2BHZ1Swm8rG352++Dmw1dEbDCXMZcmLRbOQ
         23hge8rgRS5s//HX3DU3/zFoWANYXRdxFedonFWtA5/GuLKh4RlmCWhRTgQgO7U9kg9I
         w5HYtiFt6yNDzbbSIL2mLTwS3y7GfKxG0iwk2aragTm2sB6CARI7gvYenlppVtZw7b+z
         BTMEwo+9xEeRfWyafH0N0nzGiXTqjAxTtr+Vb+/gzkiUoSDdzG5Ny4lnzJ/cmkMdxFTW
         c9zjR1RpO3hC1OKPnKmWKhMQ4Ok7qSUE2n3dWmQ+vRKioe/P4i/x6bEd9uf6z3m6Aieq
         h/Iw==
X-Gm-Message-State: AOAM531+h1z24BDi/CIpYBLHuxH6Kl6MLpwxt7+wKMoBeWuzHmB4cz2N
        EcDj6wN2N4CHtJKbHlse2q/FLPj98ZA=
X-Google-Smtp-Source: ABdhPJxckleu4Qm62t/OgHzC0GPIv1EpGMyZ5bot0fa1olwr9txbJMPovVv/eOD14h7O4bsJ2bpCOg==
X-Received: by 2002:a05:6000:1acd:: with SMTP id i13mr1725417wry.48.1618469771613;
        Wed, 14 Apr 2021 23:56:11 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.86.66])
        by smtp.gmail.com with ESMTPSA id f25sm1643236wrd.43.2021.04.14.23.56.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 23:56:11 -0700 (PDT)
Subject: Re: [PATCH] net: sched: tapr: remove WARN_ON() in
 taprio_get_start_time()
To:     Du Cheng <ducheng2@gmail.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
References: <20210415063914.66144-1-ducheng2@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5f9f5164-0247-8930-5400-90b7762247b1@gmail.com>
Date:   Thu, 15 Apr 2021 08:56:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415063914.66144-1-ducheng2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/21 8:39 AM, Du Cheng wrote:
> There is a reproducible sequence from the userland that will trigger a WARN_ON()
> condition in taprio_get_start_time, which causes kernel to panic if configured
> as "panic_on_warn". Remove this WARN_ON() to prevent kernel from crashing by
> userland-initiated syscalls.
> 
> Reported as bug on syzkaller:
> https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c
> 
> Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
> Signed-off-by: Du Cheng <ducheng2@gmail.com>
> ---
> Detailed explanation:
> 
> In net/sched/sched_taprio.c:999
> The condition WARN_ON(!cycle) will be triggered if cycle == 0. Value of cycle
> comes from sched->cycle_time, where sched is of type(struct sched_gate_list*).
> 
> sched->cycle_time is accumulated within `parse_taprio_schedule()` during
> `taprio_init()`, in the following 2 ways:
> 
> 1. from nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
> 2. (if zero) from parse_sched_list(..., tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], ...);
> 
> note: tb is a map parsed from netlink attributes provided via sendmsg() from the userland:
> 
> If both two attributes (TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
> TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST) contain 0 values or are missing, this will result
> in sched->cycle_time == 0 and hence trigger the WARN_ON(!cycle).
> 
> Reliable reproducable steps:
> 1. add net device team0 
> 2. add team_slave_0, team_slave_1
> 3. sendmsg(struct msghdr {
> 	.iov = struct nlmsghdr {
> 		.type = RTM_NEWQDISC,
> 	}
> 	struct tcmsg {
> 		.tcm_ifindex = ioctl(SIOCGIFINDEX, "team0"),
> 		.nlattr[] = {
> 			TCA_KIND: "taprio",
> 			TCA_OPTIONS: {
> 				.nlattr = {
> 					TCA_TAPRIO_ATTR_PRIOMAP: ...,
> 					TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST: {0},
> 					TCA_TAPRIO_ATTR_SCHED_CLICKID: 0,
> 				}
> 			}
> 		}
> 	}
> }
> 
> Callstack:
> 
> parse_taprio_schedule()
> taprio_change()
> taprio_init()
> qdisc_create()
> tc_modify_qdisc()
> rtnetlink_rcv_msg()
> ...
> sendmsg()
> 
> These steps are extracted from syzkaller reproducer:
> https://syzkaller.appspot.com/text?tag=ReproC&x=15727cf1900000
> 
>  net/sched/sch_taprio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8287894541e3..5f2ff0f15d5c 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -996,7 +996,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
>  	 * something went really wrong. In that case, we should warn about this
>  	 * inconsistent state and return error.
>  	 */
> -	if (WARN_ON(!cycle))
> +	if (!cycle) {
>  		return -EFAULT;
>  
>  	/* Schedule the start time for the beginning of the next
> 

This 'fix' is wrong, not even compiled, thus not tested.

 sched->cycle_time MUST not be zero ever, there are plenty
of other places where other crashes will happen.

You are silencing a condition that should be caught much earlier.

There is even a fat comment to explain this, that can be partially seen in your patch.


Correct fix will probably be :

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8287894541e3ce5f290be2e592c0dcbdf2ec6b60..189c617a582a2eecc92e35187379d4c2889289df 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -901,6 +901,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
 
                list_for_each_entry(entry, &new->entries, list)
                        cycle = ktime_add_ns(cycle, entry->interval);
+               if (!cycle)
+                       return -EINVAL;
                new->cycle_time = cycle;
        }
 


