Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1F6A57FB
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjB1LZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 06:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbjB1LYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 06:24:25 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7C92FCE8
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:24:03 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id f14so3881973iow.5
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 03:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0u2iKp9ldtcgMOD+hKR8kz3k0BOCjo1o/U4cCu8boAs=;
        b=L0u+m/Xvcmz+gegyTZ64Bq2mJd6k/r1EXydm4FVgaQ6f4cz0HqDzFGrIqcKOKeSX4m
         TQ2suA/qG7DQtPqbClxjbKGwj2GKtt6FFwCQFWrQVesEBm4qkMyt9e09ErWg4q4S1J75
         n+o213OvKaZoFEpQM7Hk9gKLAaUlTk305d2L3HUZs/pPqw2e0UIx9zx6fMq0R9+gEEPT
         O34ufDaxKGHtli6AC8vWpEO2KOSke0lMJ2Bnc+ZgrGF33uzfXf/47/wc4NKgmC4rPYU8
         laCKAqxJH/CfzZv3sST8ObLCavdA+kzooEOzZrzU4a8Qxy08Ynv85vjvXyX/9L8+EqaA
         tt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0u2iKp9ldtcgMOD+hKR8kz3k0BOCjo1o/U4cCu8boAs=;
        b=PuAZOkzbx0MegvUzDaqBo7mJbfLm0MDDLNh8g8Xh8c4vM619pC8fTWiwoyKgy5w67m
         VVtY6rErjugHrwpkn+HNRMDxAZH5TVNIZXUkThN8TTcEjj29028oueU4yWXj+opePZXY
         tG6j4bVHralqTHrnHjB1IV+xvZS4Wl9AwsL7kabT6QJ5jkbYFMA2cjFG/GLn9a+x7evL
         xCm8cQWvnEvC1/vIUf9eI3Em1POWtzEdbeWwx07OmDjphf8zih+pRCFjarT5gEfvO1mA
         jSIiII7X6MbGrcV/DUmSENpCOTa7pxh/791xZZ3noscwwfnwH+U9b6XBz+uTc594mFGi
         bpzg==
X-Gm-Message-State: AO0yUKU7lBfLErildepPhDzMH5VInFu0W6SvsqpUjKzyiupqkOqKzFaS
        FeNcuxsq72QY2/QIvxzZ3K8iLLvo0N70hVjl+d7YWg==
X-Google-Smtp-Source: AK7set/XxfKvKpioQb1Ae1RPArAsVZtkPOSIDArcUmsbNHh+ZP+BrV/3l+awhLoUPWogWiBdbkJZzvBuO+cK4uoi2os=
X-Received: by 2002:a05:6602:214b:b0:74c:bb62:6763 with SMTP id
 y11-20020a056602214b00b0074cbb626763mr1138820ioy.1.1677583438043; Tue, 28 Feb
 2023 03:23:58 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e412e905f5b46201@google.com> <CANn89iJ_kLaF0tVVUfzKQwVkQ0VtCca1dL8eF+RrXCVDTK6h2Q@mail.gmail.com>
 <20230227155352.3399bb10@kernel.org>
In-Reply-To: <20230227155352.3399bb10@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Feb 2023 12:23:46 +0100
Message-ID: <CANn89i+ooMT_G9aL8keZ-WOcAKqpC44OLQNGvfUtjA6PW-yxcA@mail.gmail.com>
Subject: Re: [syzbot] [net?] INFO: task hung in tls_sw_sendpage (3)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+9c0268252b8ef967c62e@syzkaller.appspotmail.com>,
        borisp@nvidia.com, bpf@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 12:53=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Mon, 27 Feb 2023 21:35:41 +0100 Eric Dumazet wrote:
> > This looks suspicious to me
> >
> > commit 79ffe6087e9145d2377385cac48d0d6a6b4225a5
> > Author: Jakub Kicinski <kuba@kernel.org>
> > Date:   Tue Nov 5 14:24:35 2019 -0800
> >
> >     net/tls: add a TX lock
> >
> >
> > If tls_sw_sendpage() has to call sk_stream_wait_memory(),
> > sk_stream_wait_memory() is properly releasing the socket lock,
> > but knows nothing about mutex_{un}lock(&tls_ctx->tx_lock);
>
> That's supposed to be the point of the lock, prevent new writers from
> messing with the partially pushed records when the original writer
> is waiting for write space.
>
> Obvious hack but the async crypto support makes TLS a bit of a mess :|
>
> sendpage_lock not taking tx_lock may lead to obvious problems, I'm not
> seeing where the deadlock is, tho..
>

This report mentions sendpage, but sendmsg() would have the same issue.

A thread might be blocked in sk_stream_wait_memory() with the mutex
held, for an arbitrary amount of time,
say if the remote peer stays in RWIN 0 for hours.

This prevents tx_work from making progress, and
tls_sw_cancel_work_tx() would be stuck forever.

The consensus is that the kernel shouts a warning if a thread has been
waiting on a mutex
more than 120 seconds (check_hung_uninterruptible_tasks())
