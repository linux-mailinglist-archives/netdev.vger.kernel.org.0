Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C134A375DF1
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 02:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233765AbhEGAll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 20:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhEGAlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 20:41:40 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF19BC061574;
        Thu,  6 May 2021 17:40:41 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id k19so6426375pfu.5;
        Thu, 06 May 2021 17:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+6aCk5HTju9cPmZgMXn1TZ8gh0W3uhsXC9LAK6Kp7A=;
        b=owv7fsRKClwXIjkpRj88urdJdXTVrES++rIXjWgWg76GtHdJ+/PZNnLDmYpVV4pp5a
         HVVWi6UBRem5+I8n5i0chKSGXksst7baqneIMAdnO1QGat9kbqXP17kFBXx8iYbqgUqk
         ojo9mOaptutjkYGRJZPZoGxigZy7bgrsiP6OVj7pzSD5+5kVNHRbQd9F69mhnbXqqMsf
         WhaehLCYZ8FXqLrEgx0uxw1lWHWo+e9QmAiFlgg0YzY+rQZC/htX4JRdj1T8FWY77ahx
         iAnvA5qYTMptr1l5IAkLJLMp8hhCi/hyG2zeS+0EleJLf//E69FppbKgH8WGMNBywOxL
         AAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+6aCk5HTju9cPmZgMXn1TZ8gh0W3uhsXC9LAK6Kp7A=;
        b=U3KRAirMr3zBl+KX0msTa4pJ5LohGsRPeNcqqnSgb3hUszr3cVw+kNR/p/OX1jHxjp
         HlCTeiTX6K5QH+B/FzkuXj6bwUyxrerADulmS5AP1875JPOMPyqSx1o++L8fOpnEUATg
         8TYAycpIocD+fjbfNesCHzfhWNI8jDNeQQY3ovsFd4c+oHPG/herVmab3UsDkIwshHpK
         LtJ8fE7AGCE2jhwa4xCTxwgqTwumWbDd9pjIoXRnzB88gVOMGPsH37Oqn1LgAf0zXOQh
         OPj5zakXP2MOFp/gUhce6QxPGr2hLJl3wKT2sQXQPIWPCm6qUh51uP9T5klflppSUzHl
         fTpw==
X-Gm-Message-State: AOAM530Yw/+t15+uG6LXKItKzwPdar2lO7EpCur5YoDQNZIPBjRAOFvw
        YJmpJI89oYlYN7348ArqyxPvUKpwMG4OJSTlg8A=
X-Google-Smtp-Source: ABdhPJzFlMqZ0efn8khSNXFAAH59ahct1SnfrFEr0/AkR4YUJa8sDs/6M899Sz6QFsBXgVgame/L2nVab7SsT/6bVZQ=
X-Received: by 2002:a65:45c3:: with SMTP id m3mr6909587pgr.179.1620348041346;
 Thu, 06 May 2021 17:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210505200242.31d58452@gmail.com>
In-Reply-To: <20210505200242.31d58452@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 6 May 2021 17:40:30 -0700
Message-ID: <CAM_iQpUSek_wYBCbnuDRF8AB5vTVPppsLaeYa9jt2dqidYSWhg@mail.gmail.com>
Subject: Re: GPF in net sybsystem
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 10:36 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Hi, netdev developers!
>
> I've spent some time debugging this bug
> https://syzkaller.appspot.com/bug?id=c670fb9da2ce08f7b5101baa9426083b39ee9f90
> and, I believe, I found the root case:
>
> static int nr_accept(struct socket *sock, struct socket *newsock, int flags,
>                      bool kern)
> {
> ....
>         for (;;) {
>                 prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>                 ...
>                 if (!signal_pending(current)) {
>                         release_sock(sk);
>                         schedule();
>                         lock_sock(sk);
>                         continue;
>                 }
>                 ...
>         }
> ...
> }
>
> When calling process will be scheduled, another proccess can release
> this socket and set sk->sk_wq to NULL. (In this case nr_release()
> will call sock_orphan(sk)). In this case GPF will happen in
> prepare_to_wait().

Are you sure?

How could another process release this socket when its fd is still
refcnt'ed? That is, accept() still does not return yet at the point of
schedule().

Also, the above pattern is pretty common in networking subsystem,
see sk_wait_event(), so how come it is only problematic for netrom?

Thanks.
