Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485BE670ED2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjARAkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjARAjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:39:42 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD2C367D9
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 16:11:36 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so346828wma.1
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 16:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X/3iYZ9//Pg/OIASjdSN5Aoo4hzdrAQiyMUiOLCRDH8=;
        b=InZeUiyBF8sKjg0AJPHJhYSg9K7NAXgH3GyN3fPBSNneKc2yK42BpVtRou7B/VWaEM
         wn0wNHx4aAxrtvCXy2FDrTdonzB/llgNTU13mOTZvmuBnJxuaZv9ZCAvoYUFgVmyr/JF
         jIcStpgpRfVDjZQ2PFZmcRuuAObn9e50RYjR1Pr8AHkKDTM1u4BAq8woOjY4XbrTVLc6
         A8uSlCH7qBQS/FHmcbBKY7BZS0VVZpZdftxtREK7B5ToECmUTHHAthwYOCmV3/SNxuG0
         NUUuMyESRCAidGtWN9Ipj1qBrZSOhnwoJDRSWHaq6ROqPG4SuVrqBTfKRdvn1LoygoI5
         ikrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X/3iYZ9//Pg/OIASjdSN5Aoo4hzdrAQiyMUiOLCRDH8=;
        b=E85XMYq5000DRhHWBJlARk86rhuueUvWUlw0LeVRsUTtYIIiap76JAgmhfrAbhmMfP
         7dec0PlYLkKnzjk1cYRa0SIMa6g3V3lA8uPz4aFA9Zwlk3nNo8vMUEFq6IqhI3blXFzD
         +oU+yVhKM0TGX7oj9mVXUATDaVhaJibOXo92HH2o+Wb7xzkNI2flOpgz6LYgYBqq0H60
         kHna6h8wf27HQpBC9L6rVR/b1X5AhxSbHEUWtroWxtYJRQrvmDo+uVS4mA4BUWpGOcmE
         7hw1XUvVBoW+lLhAr7QIVq0qCRYPkG6l4/6NG/7PE7bs0/PZ1qbFpSetDUrvbB3vjt4X
         Atbg==
X-Gm-Message-State: AFqh2krOoIlL32iY6h865uGZqRCMjgqKv0+7GHKNclQ78kxDLNXgw7p6
        gn5ojTDCBPRUorgEZduKajS/bNAyiA7q8Vk2zrw=
X-Google-Smtp-Source: AMrXdXt/SGPrnC0DvfxoAo+dvtgA56I9Sc9B6ewR9Ao3FKykXMJCGGa/lYaACYPSxbI3fZ0grZyqa8g05RFv7auvr+0=
X-Received: by 2002:a05:600c:348e:b0:3da:17fb:93f5 with SMTP id
 a14-20020a05600c348e00b003da17fb93f5mr381960wmq.160.1674000695134; Tue, 17
 Jan 2023 16:11:35 -0800 (PST)
MIME-Version: 1.0
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com> <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
In-Reply-To: <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
From:   Kyle Zeng <zengyhkyle@gmail.com>
Date:   Tue, 17 Jan 2023 17:10:58 -0700
Message-ID: <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results when
 asked to drop") may be not bug for branch LTS 5.10
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     shaozhengchao <shaozhengchao@huawei.com>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhengchao,

I'm the finder of the vulnerability. In my initial report, there was a
more detailed explanation of why this bug happened. But it got left
out in the commit message.
So, I'll explain it here and see whether people want to patch the
actual root cause of the crash.

The underlying bug that this patch was trying to address is actually
in `__tcf_classify`. Notice that `struct tcf_result` is actually a
union type, so whenever the kernel sets res.goto_tp, it also sets
res.class. And this can happen inside `tcf_action_goto_chain_exec`. In
other words, `tcf_action_goto_chain_exec` will set res.class. Notice
that goto_chain can point back to itself, which causes an infinite
loop. To avoid the infinite loop situation, `__tcf_classify` checks
how many times the loop has been executed
(https://elixir.bootlin.com/linux/v6.1/source/net/sched/cls_api.c#L1586),
if it is more than a specific number, it will mark the result as
TC_ACT_SHOT and then return:

if (unlikely(limit++ >= max_reclassify_loop)) {
    ...
    return TC_ACT_SHOT;
}

However, when it returns in the infinite loop handler, it forgets to
clear whatever is in the `res` variable, which still holds pointers in
`goto_tp`. As a result, cbq_classify will think it is a valid
`res.class` and causes type confusion.

My initial proposed patch was to memset `res` before `return
TC_ACT_SHOT` in `__tcf_classify`, but it didn't get merged. But I
guess the merged patch is more generic.

BTW, I'm not sure whether it is a bug or it is intended in the merged
patch for this bug: moving `return NULL` statement in `cbq_classify`
results in a behavior change that is not documented anywhere:
previously, packets that return TC_ACT_QUEUED, TC_ACT_STOLEN, and
TC_ACT_TRAP will eventually return NULL, but now they will be passed
into `cbq_reclassify`. Is this expected?

Best,
Kyle Zeng

On Tue, Jan 17, 2023 at 12:07 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> +Cc netdev
>
> On Tue, Jan 17, 2023 at 10:06 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> >
> > Trimmed Cc (+Davide).
> >
> > I am not sure i followed what you are saying because i dont see the
> > relationship between the
> > two commits. Did that patch(9410c9409d3e) cause a problem?
> > How do you reproduce the issue that is caused by this patch that you are seeing?
> >
> > One of the challenges we have built over time is consumers of classification and
> > action execution may not be fully conserving the semantics of the return code.
> > The return code is a "verdict" on what happened; a safer approach is to get the
> > return code to be either an error/success code. But that seems to be a
> > separate issue.
> >
> > cheers,
> > jamal
> >
> > On Mon, Jan 16, 2023 at 3:28 AM shaozhengchao <shaozhengchao@huawei.com> wrote:
> > >
> > > When I analyzed the following LTS 5.10 patch, I had a small question:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=b2c917e510e5ddbc7896329c87d20036c8b82952
> > >
> > > As described in this patch, res is obtained through the tcf_classify()
> > > interface. If result is TC_ACT_SHOT, res may be an abnormal value.
> > > Accessing class in res will cause abnormal access.
> > >
> > > For LTS version 5.10, if tcf_classify() is to return a positive value,
> > > the classify hook function to the filter must be called, and the hook
> > > function returns a positive number. Observe the classify function of
> > > each filter. Generally, res is initialized in four scenarios.
> > > 1. res is assigned a value by res in the private member of each filter.
> > > Generally, kzalloc is used to assign initial values to res of various
> > > filters. Therefore, class in res is initialized to 0. Then use the
> > > tcf_bind_filter() interface to assign values to members in res.
> > > Therefore, value of class is assigned. For example, cls_basic.
> > > 2. The classify function of the filter directly assigns a value to the
> > > class of res, for example, cls_cgroup.
> > > 3. The filter classify function references tp and assigns a value to
> > > res, for example, cls_u32.
> > > 4. The change function of the filter references fh and assigns a value
> > > to class in res, for example, cls_rsvp.
> > >
> > > This Mainline problem is caused by commit:3aa260559455 (" net/sched:
> > > store the last executed chain also for clsact egress") and
> > > commit:9410c9409d3e ("net: sched: Introduce ingress classification
> > > function"). I don't know if my analysis is correct, please help correct,
> > > thank you very much.
> > >
> > > Zhengchao Shao
