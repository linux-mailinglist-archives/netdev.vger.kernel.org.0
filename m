Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD9428AE0E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 08:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgJLGEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 02:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLGEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 02:04:45 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A3DC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 23:04:45 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id cv1so7927039qvb.2
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 23:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1yI8jYs2/lZFaIWxLZ/rjVvQ+sNLY30huA6J9bKeQWs=;
        b=RcKAUm7XE30LvjwktSIVOpda8L78FHBfTGbVdFcE2/BPz9VprsI9jUKte8aio2Nnen
         c4VU+029KeHaZBqm3or90rscQ/kZxgV0k2PAXM3VYGsyQNjhuAyPy9BThFX8GcCEQ0In
         9eT4oCCNSrRsFOLWOcMv89Qw+YXdmwN91H5maqzG2xCkk9wlKbeSbAYr6hvKgWUfvjqO
         X9M5okURon1jOYF7xWHWyhCBIRUuHrQPoBs/4yBvwQ5yKv+Ut+8hxwkmp5f4lVUaXKv/
         8HGIZ82BwymAeEUjLbpsSFJIyzoWOcll5IdLRSE4gwprUmA/9OEtXFXT6wcnDbZ0PKYu
         qDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1yI8jYs2/lZFaIWxLZ/rjVvQ+sNLY30huA6J9bKeQWs=;
        b=naLhahoTL1L8MnE16fpWYnDYRYAWrwA9WXRyOHZD3jA4944vYDDZAr0bCF5USql/91
         FVdKdrSj1fWva0OxvMzlbKVjk80ve4CjBL7m146es8xvdCjgnochDiRQxmOiM9NnvwE7
         TSDq2Ef7V1sWUS7EPFK39dE+0UCqLdg/V5cMTfnChPljhpB9RxU4Aec0kMffYHnX/WQ9
         f5CLulZe1NP4CmJMcsfbyX0T/2E/sh/ay4+M6nENZ5TQImsLD/1AjNRNG5ax6scU7cTc
         hQ91InU6Uluc7cWROXFR1GC513QByYUGyRpUB6ACVx0Zk/xvK3i9ig0DOHX3DCELx2Dl
         1aCg==
X-Gm-Message-State: AOAM5334EwnWVtZbyFnTEQXfdjXdOj4O8xa9+vELOwFij7fiVWKSHU8u
        LqEZqX7ehRSkJBzDoCEK+4vnEM5eeNA3CNti48DUDg==
X-Google-Smtp-Source: ABdhPJzk9yyYIHb6tMn3rAnnLaCzCXcPF/2qBusVxjrttHq08TplYv2Tzc1oqd7dVB9eyqXFLmA3t7FgHBFT5milr7k=
X-Received: by 2002:a05:6214:222:: with SMTP id j2mr24604054qvt.32.1602482684327;
 Sun, 11 Oct 2020 23:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201007101726.3149375-1-a.nogikh@gmail.com> <20201007101726.3149375-2-a.nogikh@gmail.com>
 <20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACT4Y+ZF_umjBpyJiCb8YPQOOSofG-M9h0CB=xn3bCgK=Kr=9w@mail.gmail.com> <20201010081431.1f2d9d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201010081431.1f2d9d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 12 Oct 2020 08:04:33 +0200
Message-ID: <CACT4Y+aEQoRMO6eA7iQZf4dhOu2cD1ZbbH6TT4Rs_uQwG0PWYg@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Aleksandr Nogikh <a.nogikh@gmail.com>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 5:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 10 Oct 2020 09:54:57 +0200 Dmitry Vyukov wrote:
> > On Sat, Oct 10, 2020 at 1:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed,  7 Oct 2020 10:17:25 +0000 Aleksandr Nogikh wrote:
> > > > From: Aleksandr Nogikh <nogikh@google.com>
> > > >
> > > > Remote KCOV coverage collection enables coverage-guided fuzzing of the
> > > > code that is not reachable during normal system call execution. It is
> > > > especially helpful for fuzzing networking subsystems, where it is
> > > > common to perform packet handling in separate work queues even for the
> > > > packets that originated directly from the user space.
> > > >
> > > > Enable coverage-guided frame injection by adding a kcov_handle
> > > > parameter to sk_buff structure. Initialization in __alloc_skb ensures
> > > > that no socket buffer that was generated during a system call will be
> > > > missed.
> > > >
> > > > Code that is of interest and that performs packet processing should be
> > > > annotated with kcov_remote_start()/kcov_remote_stop().
> > > >
> > > > An alternative approach is to determine kcov_handle solely on the
> > > > basis of the device/interface that received the specific socket
> > > > buffer. However, in this case it would be impossible to distinguish
> > > > between packets that originated from normal background network
> > > > processes and those that were intentionally injected from the user
> > > > space.
> > > >
> > > > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > >
> > > Could you use skb_extensions for this?
> >
> > Why? If for space, this is already under a non-production ifdef.
>
> I understand, but the skb_ext infra is there for uncommon use cases
> like this one. Any particular reason you don't want to use it?
> The slight LoC increase?
>
> Is there any precedent for adding the kcov field to other performance
> critical structures?

I see. Yes, increase in complexity for no gain.
No, KCOV context wasn't added to anything as critical as sk_buff.
It seems there is no established practice both ways -- I don't see
anything debug-related in sk_buff nor in skb_ext_id...
