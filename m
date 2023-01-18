Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375DA671B2D
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjARLrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjARLpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:45:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87D632E55
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674039964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S5/6Xu0eIIBYkr1j8Gh2sqVw/hOh1Fh381LHNKs7kBE=;
        b=FbSIsNOPD4fb6wGRE/UBbtUhhcRMnpkjRI++lvzpLiVXdHCnCVjtVtA1Wf+Xnd2qcK6Ayc
        totUC2Jdg/b047lEOjBzgC3ckQYUw4eu5/8CiLMTKiD0VEHkmXwVCC7MmG1PRxRofNafUK
        WZKHhJQipBoFyhcYqpw03CmOWxkWJ2k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-35-EN7s5kL8MG-td_6rMzPILA-1; Wed, 18 Jan 2023 06:06:03 -0500
X-MC-Unique: EN7s5kL8MG-td_6rMzPILA-1
Received: by mail-ej1-f70.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso23722696ejb.14
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:06:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5/6Xu0eIIBYkr1j8Gh2sqVw/hOh1Fh381LHNKs7kBE=;
        b=EHrw+NSDujKcqSjW4MY9frdUeXAyMq4SEpn3bdREzjrSSm5KxIwZjUH+fpzeYwEly5
         cBKcC2u4LSdfCCkx3vUxGjcJQ4rFsX7PBHRNvR+EauVdlH8yCpCXzygQuD8xCanP8cw1
         5TNARrC+EfrKWOIVUw11bjLPnQPU/6ezYViFFfmxe+JZImjZ4itNEYROk//QFrvaImjq
         ipL6qQMC41AFOs9m6ixjD8romiLmpWN9MgXQL+n/u8co5muKQO0i1gza0v0OqD3LyD9a
         MofMjtJa5JzsH19yNxAcxNmO9J3RKEfkWv0cHMQrn9PJu2Nj2gFxd3mBBAO9S4Bt28k5
         Jl/Q==
X-Gm-Message-State: AFqh2krJ3bM8w/tGzKxgBnORMHjnLC5TPQvd+10efTqbp2nJM9MKnD4G
        emaSP8bWMU5cnoJ7/FjNYck72Mmwwvb+RZC6bhwfZm0oZFEHChRMhqfWRCJ+nN2QMOvmuKCwfV2
        0fU/G3ji8DGv4aFcV
X-Received: by 2002:a17:907:d38a:b0:86e:c9e2:6313 with SMTP id vh10-20020a170907d38a00b0086ec9e26313mr7126000ejc.32.1674039962504;
        Wed, 18 Jan 2023 03:06:02 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvEy+PvcDTnUWUIM1mRi0DywvS5oO3X8U3KlVPLdv8WhWr4z2y8n+9axR5+Rmd7Av1umWfsfg==
X-Received: by 2002:a17:907:d38a:b0:86e:c9e2:6313 with SMTP id vh10-20020a170907d38a00b0086ec9e26313mr7125985ejc.32.1674039962271;
        Wed, 18 Jan 2023 03:06:02 -0800 (PST)
Received: from localhost (net-37-179-25-230.cust.vodafonedsl.it. [37.179.25.230])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709061da100b0086b7ffb3b92sm6198059ejh.205.2023.01.18.03.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 03:06:01 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:06:00 +0100
From:   Davide Caratti <dcaratti@redhat.com>
To:     Kyle Zeng <zengyhkyle@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
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
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results
 when asked to drop") may be not bug for branch LTS 5.10
Message-ID: <Y8fSmFD2dNtBpbwK@dcaratti.users.ipa.redhat.com>
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
 <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
 <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Tue, Jan 17, 2023 at 05:10:58PM -0700, Kyle Zeng wrote:
> Hi Zhengchao,
> 
> I'm the finder of the vulnerability. In my initial report, there was a
> more detailed explanation of why this bug happened. But it got left
> out in the commit message.
> So, I'll explain it here and see whether people want to patch the
> actual root cause of the crash.
> 
> The underlying bug that this patch was trying to address is actually
> in `__tcf_classify`. Notice that `struct tcf_result` is actually a
> union type, so whenever the kernel sets res.goto_tp, it also sets
> res.class.

From what I see/remember, 'res' (struct tcf_result) is unassigned
unless the packet is matched by a classifier (i.e. it does not return
TC_ACT_UNSPEC).

When this match happens (__tcf_classify returns non-negative) and the
control action says TC_ACT_GOTO_CHAIN, res->goto_tp is written.
Like you say, 'res.class' is written as well because it's a union.

> And this can happen inside `tcf_action_goto_chain_exec`. In
> other words, `tcf_action_goto_chain_exec` will set res.class. Notice
> that goto_chain can point back to itself, which causes an infinite
> loop. To avoid the infinite loop situation, `__tcf_classify` checks
> how many times the loop has been executed
> (https://elixir.bootlin.com/linux/v6.1/source/net/sched/cls_api.c#L1586),
> if it is more than a specific number, it will mark the result as
> TC_ACT_SHOT and then return:
> 
> if (unlikely(limit++ >= max_reclassify_loop)) {
>     ...
>     return TC_ACT_SHOT;
> }

maybe there is an easier reproducer, something made of 2 TC actions.
The first one goes to a valid chain, and then the second one (executed from
within the chain) drops the packet. I think that unpatched CBQ scheduler 
will find 'res.class' with a value also there.
 
> However, when it returns in the infinite loop handler, it forgets to
> clear whatever is in the `res` variable, which still holds pointers in
> `goto_tp`. As a result, cbq_classify will think it is a valid
> `res.class` and causes type confusion.
> 
> My initial proposed patch was to memset `res` before `return
> TC_ACT_SHOT` in `__tcf_classify`, but it didn't get merged. But I
> guess the merged patch is more generic.

The merged patch looks good to me; however, I wonder if it's sufficient.
If I well read the code, there is still the possibility of hitting the
same problem on a patched kernel when TC_ACT_TRAP / TC_ACT_STOLEN is
returned after a 'goto chain' when the qdisc is CBQ.

I like Jamal's idea of sharing the reproducer :)

thanks!
-- 
davide

 

