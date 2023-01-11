Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85335665075
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 01:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbjAKAnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 19:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjAKAnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 19:43:08 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1D853728
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 16:43:08 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so18275447pjk.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 16:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RwApjXazBy03AXl+7agcNPkcdHcmXYisquD+XWuObQI=;
        b=p9Wy3geb4xUP52+NseHNDVhKtGAQ5RMSaJ1ssvzqE+bTGTb2SAwk+nIUX42kU9MOz1
         2hT90NzjYPZ7hZcZDqwAtSO3vrND+xIvSn7OVqn46nCmbbwCaD8i3Qg+cYdcY/cXobRM
         OUHGej7izgzQK95Z+JoD+06+BbKhO0J1WWWgcnnv+i698TWxwh3GsRDCvpsPtvYm0bFI
         95u5TIxGn9ZkRdQ5Q9zJ2n5E6CETzFSfAf/uvLyM8r+vvJl9kgonI57UzVh1PsV7bdXD
         b9KATQ0sVJP+mc4JNYGIAdn2QS78+7//yYUquuIhS2RKZmW61nREKPV49d0VofiiY1oW
         q7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RwApjXazBy03AXl+7agcNPkcdHcmXYisquD+XWuObQI=;
        b=tgpv7pAuTvIhTMkbPlvKd013m0Ng2K8CyubxFEHHiz8EVBlYkPdoO+5g/2P+b0pYRv
         6p98C0HI3kEGLuxKUth4dkgd1NZMiFWpWSFnMi4vPgMYTUYvXAxki0LpWC7kw1Ba5E5x
         SXwqyzNIZPuohdaWtBp71De5Rt6qQM3yuloSKMAeXeH0rouMVeZehMKCO6/VphN0cnAw
         FYMjMOz7D9od83AffIIi3eklMN2C+Xw5tO5i4GzYS7j05+V2dqJ32Cp+gr7zHY0erU9A
         32cjnEdtGk1vp48V6NCqmd5GNuSYgtekx/s1ms4Y332CX9//gr4FPOu31/XVjG/cS+9X
         3FBg==
X-Gm-Message-State: AFqh2koSr4BOg/ARDt4tNolrgkEB4i2Nqafpj32NROmIZz9jniPFLIas
        G/+tR5MzCWkn5OUYboxm3vEbNDq2zOJSxbLTXttSYA==
X-Google-Smtp-Source: AMrXdXvjEJJTwOkPTxwNBMMNhDdENz7RjrHD8iSpfmOBhUPOzKLbPDpIns1ZcBITJYIhnXze4nsYdsIAmJXGjyU39Is=
X-Received: by 2002:a17:90a:1c96:b0:226:3fc:ec4f with SMTP id
 t22-20020a17090a1c9600b0022603fcec4fmr5550824pjt.85.1673397787297; Tue, 10
 Jan 2023 16:43:07 -0800 (PST)
MIME-Version: 1.0
References: <20230110091409.2962-1-sensor1010@163.com> <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
 <20230110163043.069c9aa4@kernel.org>
In-Reply-To: <20230110163043.069c9aa4@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 10 Jan 2023 16:42:56 -0800
Message-ID: <CAEA6p_AdUL-NgX-C9j0DRNbwnc+nKPnwKRY8dXNCEZ4_pnTOXQ@mail.gmail.com>
Subject: Re: [PATCH v1] net/dev.c : Remove redundant state settings after
 waking up
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?5p2O5ZOy?= <sensor1010@163.com>, davem@davemloft.net,
        pabeni@redhat.com, bigeasy@linutronix.de, imagedong@tencent.com,
        kuniyu@amazon.com, petrm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was not able to see the entire changelog, but I don't think
> -               set_current_state(TASK_INTERRUPTIBLE);
is redundant.

It makes sure that if the previous if statement:
    if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken)
is false, this napi thread yields the CPU to other threads waiting to
be run by calling schedule().

And the napi thread gets into running state again after the next
wake_up_process() is called from ____napi_schedule().


On Tue, Jan 10, 2023 at 4:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 10 Jan 2023 10:29:20 +0100 Eric Dumazet wrote:
> > > the task status has been set to TASK_RUNNING in shcedule(),
> > > no need to set again here
> >
> > Changelog is rather confusing, this does not match the patch, which
> > removes one set_current_state(TASK_INTERRUPTIBLE);
> >
> > TASK_INTERRUPTIBLE != TASK_RUNNING
> >
> > Patch itself looks okay (but has nothing to do with thread state after
> > schedule()),
> > you should have CC Wei Wang because she
> > authored commit cb038357937e net: fix race between napi kthread mode
> > and busy poll
>
> AFAIU this is the semi-idiomatic way of handling wait loops.
> It's not schedule() that may set the task state to TASK_RUNNING,
> it's whoever wakes the process and makes the "wait condition" true.
> In this case - test_bit(NAPI_STATE_SCHED, &napi->state)
>
> I vote to not futz with this logic.
