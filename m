Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0153671E11
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjARNhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjARNgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:36:55 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808525CFC7
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:06:25 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-4d4303c9de6so315455487b3.2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2tVd8BvYfG8rEjPp/LG5ak9bFo4f0BzDm7hRqoflaxU=;
        b=3gYPzYJq9dfpEahYUfv2RJVfRI6RfKcYuajRCOmY9ykwjRwVqTaHJZf/+RcLEuFY50
         Dc65A4nk+4ZWcHaXFOMMXOjcgN6ZQagB7mI5bvYQtNjoQ4NhKCyjS37heLGNApdUZJIK
         enWSMnqxgsmBV9gusLNSDHT8gAeHNcGI2xwn+xPDf3d+3ZE0g36PxqseDWrwmQ2bkqxM
         aBhyzdboDHbElvS8Zwn6uv7OCsk/99lbIPhBAe86UOrXgEFZRRu/U72ZtpWaF5aTCb8/
         uiSPMwhBuBfGX0MTeGVXT6UqtfRgC1Byr7P39h7TaBG313NuaLXcbYiLq5N7kO63/6ua
         cXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2tVd8BvYfG8rEjPp/LG5ak9bFo4f0BzDm7hRqoflaxU=;
        b=b0EKZvvRAX3mlJ4/Re7gHYku51crZNbS5irKKBGGPQwZDpdj/A0gDmwamfbPBZrZXr
         y2eHVUVmo6t3433JxX291JrEKmgD0v+/UO8JY6IyZq2L2yMzK4jdyg5Uu1nGNhr8oIfA
         3RrAkIuo10H45HKzn1VLgZcqB55oQWshDiNwq/brAYEnwDIa7MXwY4T3hDWUgz92WXdq
         0JZjsnsPuJgB0oEEjp1xNEMmW9C9RXjtbSY8a/qK3onBl04kvocX0+/BAkSx1C+EOgka
         xyxG98/yDRPHW5rD8iFv5qiPNk5PJbpnCoXEmszxamCIcpPweNJmjEpS+xIJdY2lgPpQ
         YAKg==
X-Gm-Message-State: AFqh2kpz67Nfm/IGeryOa+p2AdmBzGzJRg9AsuTRRnPgAak8+B8H6qsY
        9CoaDdI+eOgQAKPtVInY+PqNKeuEpAdRjHpAtOeigg==
X-Google-Smtp-Source: AMrXdXt95SGq7esKio7EZ74q2WHQER9E+qLTy5PFuExJIDrO72NIIEv8EfHYID5tw8Eu9Q19mcJeZG0/mnWeVgm2/ps=
X-Received: by 2002:a81:5a86:0:b0:4dd:4477:47b6 with SMTP id
 o128-20020a815a86000000b004dd447747b6mr771173ywb.395.1674047183617; Wed, 18
 Jan 2023 05:06:23 -0800 (PST)
MIME-Version: 1.0
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
 <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
 <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com> <Y8fSmFD2dNtBpbwK@dcaratti.users.ipa.redhat.com>
In-Reply-To: <Y8fSmFD2dNtBpbwK@dcaratti.users.ipa.redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 18 Jan 2023 08:06:12 -0500
Message-ID: <CAM0EoMmhHns_bY-JsXvrUkRhqu3xTDaRNk+cP-x=O_848R0W3Q@mail.gmail.com>
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results when
 asked to drop") may be not bug for branch LTS 5.10
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Kyle Zeng <zengyhkyle@gmail.com>,
        shaozhengchao <shaozhengchao@huawei.com>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reproducer the Kyle included back then was not useful - it seemed
like a cutnpaste
from some syzkaller dashboard (and didnt compile); however, for this one issue,
you can reproduce the problem by creating the infinite loop setup that
Davide describes.

The main issue is bigger than tcf_classify: It has to do with
interpretation of tcf_result
and the return codes.
I reviewed all consumers of tcf_results and only 3 (all happened to be qdiscs)
were fixed in that patch set. Note consumers include all objects in
the hierarchy
including classifiers and action.

Typically, the LinuxWay(tm) of cutting and pasting what other people before you
did works - but sometimes people forget environmental rules even when they are
documented. The main environmental rule that was at stake here is the return
(verdict) code said to drop the packet. The validity of tcf_result in
such a case is
questionable and setting it to 0 was irrelevant. So that is all the
fix had to do for -net.

The current return code is a "verdict" on what happened. Given that
there is potential
to misinterpret - as was seen here - a safer approach is to get the
return code to be either
an error/success code(eg ELOOP for the example being quoted) since
that is a more
common pattern and we store the "verdict code" in tcf_result (TC_ACT_SHOT).
I was planning to send an RFC patch for that.

I am still not clear on the correlation that Zhengchao Shao was making between
Davide's patch and this issue...

cheers,
jamal


On Wed, Jan 18, 2023 at 6:06 AM Davide Caratti <dcaratti@redhat.com> wrote:
>
> hello,
>
> On Tue, Jan 17, 2023 at 05:10:58PM -0700, Kyle Zeng wrote:
> > Hi Zhengchao,
> >
> > I'm the finder of the vulnerability. In my initial report, there was a
> > more detailed explanation of why this bug happened. But it got left
> > out in the commit message.
> > So, I'll explain it here and see whether people want to patch the
> > actual root cause of the crash.
> >
> > The underlying bug that this patch was trying to address is actually
> > in `__tcf_classify`. Notice that `struct tcf_result` is actually a
> > union type, so whenever the kernel sets res.goto_tp, it also sets
> > res.class.
>
> From what I see/remember, 'res' (struct tcf_result) is unassigned
> unless the packet is matched by a classifier (i.e. it does not return
> TC_ACT_UNSPEC).
>
> When this match happens (__tcf_classify returns non-negative) and the
> control action says TC_ACT_GOTO_CHAIN, res->goto_tp is written.
> Like you say, 'res.class' is written as well because it's a union.
>
> > And this can happen inside `tcf_action_goto_chain_exec`. In
> > other words, `tcf_action_goto_chain_exec` will set res.class. Notice
> > that goto_chain can point back to itself, which causes an infinite
> > loop. To avoid the infinite loop situation, `__tcf_classify` checks
> > how many times the loop has been executed
> > (https://elixir.bootlin.com/linux/v6.1/source/net/sched/cls_api.c#L1586),
> > if it is more than a specific number, it will mark the result as
> > TC_ACT_SHOT and then return:
> >
> > if (unlikely(limit++ >= max_reclassify_loop)) {
> >     ...
> >     return TC_ACT_SHOT;
> > }
>
> maybe there is an easier reproducer, something made of 2 TC actions.
> The first one goes to a valid chain, and then the second one (executed from
> within the chain) drops the packet. I think that unpatched CBQ scheduler
> will find 'res.class' with a value also there.
>
> > However, when it returns in the infinite loop handler, it forgets to
> > clear whatever is in the `res` variable, which still holds pointers in
> > `goto_tp`. As a result, cbq_classify will think it is a valid
> > `res.class` and causes type confusion.
> >
> > My initial proposed patch was to memset `res` before `return
> > TC_ACT_SHOT` in `__tcf_classify`, but it didn't get merged. But I
> > guess the merged patch is more generic.
>
> The merged patch looks good to me; however, I wonder if it's sufficient.
> If I well read the code, there is still the possibility of hitting the
> same problem on a patched kernel when TC_ACT_TRAP / TC_ACT_STOLEN is
> returned after a 'goto chain' when the qdisc is CBQ.
>
> I like Jamal's idea of sharing the reproducer :)


> thanks!
> --
> davide
>
>
>
