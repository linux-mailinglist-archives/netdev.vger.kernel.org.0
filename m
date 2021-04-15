Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7933361606
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhDOXUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234735AbhDOXUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 19:20:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD62C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 16:20:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d8so12955963plh.11
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 16:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gEVti7ltVMXtO5AB8HJs2hFmD3crrr6uHtSL3GKFZzU=;
        b=XRpuRUeNi9EfkzmBsE1/RBl4XJsDWsodcPZXzk8g44C1lmm+mOiuvB2Gm9bpG2G7i6
         HJyMFN9XUpRu5tJ8KYWZYHViCFMQ1+obDLtdaf22aGQTqz5fj+8dPtJyJNFYZ1wIQkcj
         FbXigrRdavmkKnE/AoNnwHrB8PcJ04bC90js4FTLDJovH7EmPIjrs6UrPVNAFZoLXTzh
         9aBJ1RnIWWI+6xsQwd6ZfmEzCK5H5tXVa9r755Q7zZeRBXh13T7YdXlq4j5Sy5xsSRes
         2WKxpQEUUZdsBwlSettXQ+QtL7Mt95eWd7789VKlD7gY3KWzCIBnthyosMmfsQJn2c/K
         beiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gEVti7ltVMXtO5AB8HJs2hFmD3crrr6uHtSL3GKFZzU=;
        b=XLM3akvVWGfLvbf1jCa2ReGdW6neqZuqfJmvqZBl/Uci+A3U/vsajru75/j1ekHolS
         BXWvM19SYBZZI1650jmGDEP+iRGGaxFysVL1UC5dLqWCGOyKfArgwqo4WFNDgvqIl7Mb
         w9y9f4uzL5+CpPUaMv+nrqwueKZwDdNNBhRxsEKiIuSKSRNgNJPj8RueviKC3ytc16vv
         XUytjXsTeBnYrGy3lRHxemLKrBkEsWSnSNpg41HBIPTpF/za2nO9c3GT6os4wG7de3pH
         LNUINpmM9NUxua4+jy1wTh8K3c6ylWF3JHp1qi9H072e9FvfFR+Rc32M4lYBUJ/8yQDa
         Aodg==
X-Gm-Message-State: AOAM533Oz1MGYDNZU/yAMDSz78hqhGB10/qeERzd4XbN6IXB8Zk3jvd0
        RPEPvA621Uc05ArO+yvQv/Q=
X-Google-Smtp-Source: ABdhPJwLGqkRCQnzD5imxOV4sPskr7+/+KaGvMhdP411M+KaRd3uH1KpBs7BVflWc2YF0/UsSiW+FQ==
X-Received: by 2002:a17:902:c947:b029:eb:6f61:cde with SMTP id i7-20020a170902c947b02900eb6f610cdemr6303850pla.4.1618528817690;
        Thu, 15 Apr 2021 16:20:17 -0700 (PDT)
Received: from nuc ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id y193sm3327142pfc.72.2021.04.15.16.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 16:20:17 -0700 (PDT)
Date:   Fri, 16 Apr 2021 07:20:13 +0800
From:   Du Cheng <ducheng2@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] net: sched: tapr: remove WARN_ON() in
 taprio_get_start_time()
Message-ID: <YHjKLbYHkCe7yM8c@nuc>
References: <20210415063914.66144-1-ducheng2@gmail.com>
 <20210415075953.83508-1-ducheng2@gmail.com>
 <a4b17cd6-6f00-f760-dbda-f83ff63cae22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4b17cd6-6f00-f760-dbda-f83ff63cae22@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, Apr 15, 2021 at 08:02:45PM +0200, Eric Dumazet a écrit :
> 
> 
> On 4/15/21 9:59 AM, Du Cheng wrote:
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
> > +	if (!cycle)
> >  		return -EFAULT;
> >  
> >  	/* Schedule the start time for the beginning of the next
> > 
> 
> 
> NACK
> 
> I already gave feedback in v1 why this fix is not correct.
> 

Hi Eric,

Oh It must be I did not read your email carefully, and misundertood. I am sorry.
I sent a V3 following your suggestion. Please help review. Thank you!

Regards,
DU Cheng
