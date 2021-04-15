Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B743603B4
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 09:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhDOHvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 03:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOHvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 03:51:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C45C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 00:50:48 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id z22so6469122plo.3
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 00:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dD7pS56/DCDsd8Ihm9JpHMtwcQYtu7yWfxnrqTCyTzc=;
        b=ZOOy0c85QsMUUp2qZ0xyGCBeh8F1FEjVflfgYBvfcDqJDzlnqchbCpRrSbxVEYVnZ2
         hz4g8rMXrGEHzqeXD5oLNdjYRW3eKvYpmm+vNn/nduMY+KGpMOubZN47Vfx8ad0SF6EL
         5idUPxbZNsND7lo5rWUMFTfBns5VLPFFoG4WmKx1KfzAmnV8+MKFsgktPU4/z5Hj+kM+
         S9+R4Z9qpWfDbl5Ht40hYehO6/MGyXmABkucHZ6hNaoOeyN6YjTjOOh2QZAG/l30OJ5O
         BUJIQL7sDLT/dWcVMTMfuaTjysqejzhPF4TfyFqcZCK9Coz8GovAfEKbfw+lw2s9uMbr
         ZRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dD7pS56/DCDsd8Ihm9JpHMtwcQYtu7yWfxnrqTCyTzc=;
        b=GOa4wJNKuqR2butWBB69yzzx9HzvHzvgCHid5FAz+tPaOOjUi5b6f5RtLkB/SrSF0V
         d4W6OXqGpIXGbB9saaD8Gbk9PKA7IX4u5U7M0GPxgwDrFeF0qrk4utoEHoIsAmVfK7Wv
         63/yYhYDPp9v8qt+iu+IsQhEHSL6ZgR6Wxh+FducduepP3iXXDv5rI5waaOlvKIVeRpO
         ZaaFKZ9Mm/s0aX+IGUc8ditbIMI5VcAQpp4B/M96eIpOstv6ui/0eFG/8tXk76g49357
         OWG9TAyoEZ4b2TiKXvE2HcgGG22J1BAkpktWZ0EKr7CTKlKU+pK4LMM++Tbg9Uh0mEcf
         MKKA==
X-Gm-Message-State: AOAM531icPIAE5IgHa2xO2xWmbJHcs9mApZ5InNlDbQRIpIMxcI5uWLE
        MTaDTeeQ62JEl+P+4WvSK4b01l8kIjPUQICz
X-Google-Smtp-Source: ABdhPJynbi6dVYSVCDi4dOcSU65giRYCAtU+jnRjin10zA8kP1S+XkQFqaSel0QVAsB4LFTFvomNIg==
X-Received: by 2002:a17:90b:1b42:: with SMTP id nv2mr2487813pjb.190.1618473048184;
        Thu, 15 Apr 2021 00:50:48 -0700 (PDT)
Received: from carbon ([128.106.17.62])
        by smtp.gmail.com with ESMTPSA id h18sm1605235pgj.51.2021.04.15.00.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 00:50:47 -0700 (PDT)
Date:   Thu, 15 Apr 2021 15:50:42 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: sched: tapr: remove WARN_ON() in
 taprio_get_start_time()
Message-ID: <YHfwUmFODUHx8G5W@carbon>
References: <20210415063914.66144-1-ducheng2@gmail.com>
 <5f9f5164-0247-8930-5400-90b7762247b1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f9f5164-0247-8930-5400-90b7762247b1@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, Apr 15, 2021 at 08:56:09AM +0200, Eric Dumazet a écrit :
> 
> 
> On 4/15/21 8:39 AM, Du Cheng wrote:
> > There is a reproducible sequence from the userland that will trigger a WARN_ON()
> > condition in taprio_get_start_time, which causes kernel to panic if configured
> > as "panic_on_warn". Remove this WARN_ON() to prevent kernel from crashing by
> > userland-initiated syscalls.
> > 
> > Reported as bug on syzkaller:
> > https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c
> > 
> > Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
> > Signed-off-by: Du Cheng <ducheng2@gmail.com>
> > ---
> > Detailed explanation:
> > 
> > In net/sched/sched_taprio.c:999
> > The condition WARN_ON(!cycle) will be triggered if cycle == 0. Value of cycle
> > comes from sched->cycle_time, where sched is of type(struct sched_gate_list*).
> > 
> > sched->cycle_time is accumulated within `parse_taprio_schedule()` during
> > `taprio_init()`, in the following 2 ways:
> > 
> > 1. from nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
> > 2. (if zero) from parse_sched_list(..., tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], ...);
> > 
> > note: tb is a map parsed from netlink attributes provided via sendmsg() from the userland:
> > 
> > If both two attributes (TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
> > TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST) contain 0 values or are missing, this will result
> > in sched->cycle_time == 0 and hence trigger the WARN_ON(!cycle).
> > 
> > Reliable reproducable steps:
> > 1. add net device team0 
> > 2. add team_slave_0, team_slave_1
> > 3. sendmsg(struct msghdr {
> > 	.iov = struct nlmsghdr {
> > 		.type = RTM_NEWQDISC,
> > 	}
> > 	struct tcmsg {
> > 		.tcm_ifindex = ioctl(SIOCGIFINDEX, "team0"),
> > 		.nlattr[] = {
> > 			TCA_KIND: "taprio",
> > 			TCA_OPTIONS: {
> > 				.nlattr = {
> > 					TCA_TAPRIO_ATTR_PRIOMAP: ...,
> > 					TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST: {0},
> > 					TCA_TAPRIO_ATTR_SCHED_CLICKID: 0,
> > 				}
> > 			}
> > 		}
> > 	}
> > }
> > 
> > Callstack:
> > 
> > parse_taprio_schedule()
> > taprio_change()
> > taprio_init()
> > qdisc_create()
> > tc_modify_qdisc()
> > rtnetlink_rcv_msg()
> > ...
> > sendmsg()
> > 
> > These steps are extracted from syzkaller reproducer:
> > https://syzkaller.appspot.com/text?tag=ReproC&x=15727cf1900000
> > 
> >  net/sched/sch_taprio.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index 8287894541e3..5f2ff0f15d5c 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -996,7 +996,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
> >  	 * something went really wrong. In that case, we should warn about this
> >  	 * inconsistent state and return error.
> >  	 */
> > -	if (WARN_ON(!cycle))
> > +	if (!cycle) {
> >  		return -EFAULT;
> >  
> >  	/* Schedule the start time for the beginning of the next
> > 
> 
> This 'fix' is wrong, not even compiled, thus not tested.
> 
>  sched->cycle_time MUST not be zero ever, there are plenty
> of other places where other crashes will happen.
> 
> You are silencing a condition that should be caught much earlier.
> 
> There is even a fat comment to explain this, that can be partially seen in your patch.
> 
> 
> Correct fix will probably be :
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 8287894541e3ce5f290be2e592c0dcbdf2ec6b60..189c617a582a2eecc92e35187379d4c2889289df 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -901,6 +901,8 @@ static int parse_taprio_schedule(struct taprio_sched *q, struct nlattr **tb,
>  
>                 list_for_each_entry(entry, &new->entries, list)
>                         cycle = ktime_add_ns(cycle, entry->interval);
> +               if (!cycle)
> +                       return -EINVAL;
>                 new->cycle_time = cycle;
>         }
>  
> 
> 

Hi Eric,

Sorry for the typo in the previous PATCH, I must have let the '{' slip out
, when I tried to cleanup my own debugging lines.

Anyway, my intention was indeed to silently return error back to the userland,
if the cycle is 0. The removal of WARN_ON() is so that this would not cause the
kernel to panic.

`cycle` can be 0 if the userland provides invalid input, which should be
anticipated and gracefully handled, hence panic would be too dramatic.

With the removal of WARN_ON(), the original logic was not
altered: return -EINVAL to the userland and abort subsequent steps.

I will later submit a v2 to correct my typo.
Thank you for your input.

Regards,
Du Cheng
