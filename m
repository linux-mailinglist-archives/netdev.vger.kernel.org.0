Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85E136663D5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjAKTkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbjAKTj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:39:59 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8887AC21
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 11:39:58 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q9so11271331pgq.5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 11:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1XSlpg+EdrcmXerZzrmLDNjZ4Nt/uQNre9/vPO6WsZk=;
        b=IMDrIWgY+v/D6xkyv5JggUKl5j/Pndtiy1QZmDjFblaLCFbBwXba/FvXxUw/mLuvTk
         SQb1rrBdoCPPOiHvpagAlDSixDR54r9p5KReZ/PEOqF+WTvqAYaDZIn5bZfpVgwAJ02+
         Gox8rK6fVp6ReI2nUYtahzFTotrERuUlSyQXDfa8pM7Q3ANEMbHrRxDLOZGQvgsJLLzH
         GIYzSY3RAoxxTYsw+igFmhqeDAFOQlOpZvplzQzbUEm8FoxBpbtmQrCTGAx0yR/RUIrd
         J+6Eyc6hGV99RhEnDdJVPsKoLSrKqyR8D50ITeYxhZckvSkQY6hgOrx9gLG5g7klMykt
         xDpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1XSlpg+EdrcmXerZzrmLDNjZ4Nt/uQNre9/vPO6WsZk=;
        b=fhUKZjDM00vht4SAFuhr7aCn1LhSGg8Bm2c2ma/9ssLhKHrUQccOm+X4EXcCfZwC6s
         79FdhfgtC16ZVM2bI+K6/L9tlse/rb2ZE7L7V2Xks68b+tWi/FTH+XKvJuDD/qTFQMmf
         15BkLTEQr4EqzF/d2bBD/d5NFCI6BqQTeBkIFZ3RmhdHxNfFUpFt/hDC6u3FPqJbKhWc
         sEPJ74AtXq0vzGXVq9TMQ/YZsVxk/EZ6fEiF+pHHmxylvZ9gc9uIPwc94mCOqs2NBpNL
         VJfA7ZMs4n0kwXR1GY9qgIXfGozWX3ClW7II+0Z6vPldB5xR/Wk92zzm9bzGi1/Hp10p
         PR4g==
X-Gm-Message-State: AFqh2krga9/IeN5xLaldGHypt4lQZyARIrc8NXH00RZ/5Ovr3hEhsL2M
        IAiF+oRWmjM/jrwiKVtttjqrmd8cTa46kCdFvH3RQA==
X-Google-Smtp-Source: AMrXdXumOD/ey3V/QkyeIC5FqYO4pBXInckHjGXoe4n57mB6xK/THa7v841uX5NKTNeaUD0/JJVYKoOLmQnMj1tSyi4=
X-Received: by 2002:a05:6a00:52:b0:583:4fd0:61b2 with SMTP id
 i18-20020a056a00005200b005834fd061b2mr1660859pfk.63.1673465997832; Wed, 11
 Jan 2023 11:39:57 -0800 (PST)
MIME-Version: 1.0
References: <20230110091409.2962-1-sensor1010@163.com> <CANn89iL0EYuGASWaXPwKN+E6mZvFicbDKOoZVA8N+BXFQV7e2A@mail.gmail.com>
 <20230110163043.069c9aa4@kernel.org> <CAEA6p_AdUL-NgX-C9j0DRNbwnc+nKPnwKRY8dXNCEZ4_pnTOXQ@mail.gmail.com>
 <Y75mGsoe5XUVtqqa@linutronix.de> <20230111102058.144dbb11@kernel.org>
In-Reply-To: <20230111102058.144dbb11@kernel.org>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 11 Jan 2023 11:39:46 -0800
Message-ID: <CAEA6p_AsyhQbGPrj71iKaScAHbrEBCDLeLyZE1kcT59GS=anzg@mail.gmail.com>
Subject: Re: [PATCH v1] net/dev.c : Remove redundant state settings after
 waking up
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?5p2O5ZOy?= <sensor1010@163.com>, davem@davemloft.net,
        pabeni@redhat.com, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com, netdev@vger.kernel.org,
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

On Wed, Jan 11, 2023 at 10:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 11 Jan 2023 08:32:42 +0100 Sebastian Andrzej Siewior wrote:
> > It made sense in the beginning but now the suggested patch is a clean
> > up. First the `woken' parameter was added in commit
> >    cb038357937ee ("net: fix race between napi kthread mode and busy poll")
> >
> > and then the `napi_disable_pending' check was removed in commit
> >    27f0ad71699de ("net: fix hangup on napi_disable for threaded napi")
> >
> > which renders the code to:
> > |         while (!kthread_should_stop()) {
> > |                 if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken) {
> > |                         WARN_ON(!list_empty(&napi->poll_list));
> > |                         __set_current_state(TASK_RUNNING);
> > |                         return 0;
> > |                 }
> > |
> > |                 schedule();
> > |                 /* woken being true indicates this thread owns this napi. */
> > |                 woken = true;
> > |                 set_current_state(TASK_INTERRUPTIBLE);
> > |         }
> > |         __set_current_state(TASK_RUNNING);
> >
> > so when you get out of schedule() woken is set and even if
> > NAPI_STATE_SCHED_THREADED is not set, the while() loop is left due to
> > `woken = true'. So changing state to TASK_INTERRUPTIBLE makes no sense
> > since it will be set back to TASK_RUNNING cycles later.
>
> Ah, fair point, forgot about the woken optimization.

Agree. I think it is OK to remove this, since woken is set, and this
function will set TASK_RUNNING and return 0. And the next time, it
will enter with TASK_INTERRUPTIBLE and woken = false.
