Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D1047575E
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbhLOLIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236790AbhLOLI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:08:28 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7775CC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:08:28 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id v64so54133027ybi.5
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0vP+/wf7tROPM54COWXj5vF8GszBwkxGxw5qfBgKPU=;
        b=AB+xftGZiEk7z+rq+DSOxL1xuqffrnZpqo3Bqtw/vwKWVCLMWBqHVjFBXWZNTN4e0Q
         KIRKVQt146GIvEnvUysFH+Vq2bH+uLeGfTdKaaqeChakJAa9xiS2pAEDhdWIP0ab4bj+
         AWzokV3zO32QvhoNQJ8ET+K72rpmC7pCvzwMYChjLu6aXHpIYGxCdtNbFtodHd1oOmeJ
         Oh2iGoWDDkg5TJYKA3vv3YNJy2tPb61jGxhlaPYVJf4b7kkUgMjeMsNd7PGJHba0ScwC
         UkVf4H8Trn60CU0B8MEjp+JwuWjOmAd0Mi0VxxBziOfffn9lYxUYcaLPLgtVpBCsSTmS
         u48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0vP+/wf7tROPM54COWXj5vF8GszBwkxGxw5qfBgKPU=;
        b=KLyaIMzzmI+5Q7hAuFTlgGB35tLZP6es9Ihgc9v0cWocwr7aYCY/faHwFhpbtOhJix
         b5hfFltq9NY4aVnp3phGfDh9/6ZNonuDH2dWR79W7CWfDsadm+zcdVg82oda4aSj8YYg
         SPIrcpkaLI8omVRz9vknfZpQdBKNY2lXTuSdUETH/eDQoYfiNxE/7eT61qqe/vnHB5ag
         mrfV8Pm+Re3JFdX7Gx78qrOXet/fFli/eBVDwCu7NqgqboP35EhYm+AVMHkB5dDc0l2L
         jwIJZAFN5FlyTexvrjU/GSk7NRSpcLjxh1JE1UFKXp+koMTT3f+wIZCWHv7neq1ujhLM
         O/bw==
X-Gm-Message-State: AOAM5314p9lns7GPMZUmhRyLAYTHc7V8DROJ3D0O+eSrA8yBzF5a3RBv
        5jlWXI1LDApqmAtOzwtTXgHgm4uP7U08PHMAi+Hczw==
X-Google-Smtp-Source: ABdhPJy8YejpFy3uOY9TFh9jJILgF70D/7YLJk7RIDdmvk4UN8+402gWwBI9l8Qlzuv7W1GFUmhvovQK2uB44YjpZMk=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr5797147ybg.711.1639566507334;
 Wed, 15 Dec 2021 03:08:27 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <20211205042217.982127-2-eric.dumazet@gmail.com> <a6b342b3-8ce1-70c8-8398-fceaee0b51ff@gmail.com>
 <CANn89iLCaPLhrGi5FyDppfzqdtsow2i6c5+E7pjtd47hwgvpGA@mail.gmail.com>
 <CANn89iLzZaVObgj-OSG7bT2V8q2AdqUekc2aoiwG7QeRyemNLw@mail.gmail.com> <45c1b738-1a2f-5b5f-2f6d-86fab206d01c@suse.cz>
In-Reply-To: <45c1b738-1a2f-5b5f-2f6d-86fab206d01c@suse.cz>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 15 Dec 2021 03:08:15 -0800
Message-ID: <CANn89iK+a5+Y=qCAERMBKAL8WRmZw3UOQiwoerse1cmxbTbFZw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 01/23] lib: add reference counting tracking infrastructure
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Jiri Slaby <jirislaby@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 2:57 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
>
> On 12/15/21 11:41, Eric Dumazet wrote:
> > On Wed, Dec 15, 2021 at 2:38 AM Eric Dumazet <edumazet@google.com> wrote:
> >>
> >> On Wed, Dec 15, 2021 at 2:18 AM Jiri Slaby <jirislaby@gmail.com> wrote:
> >> >
> >> > On 05. 12. 21, 5:21, Eric Dumazet wrote:
> >> > > From: Eric Dumazet <edumazet@google.com>
> >> > >
> >> > > It can be hard to track where references are taken and released.
> >> > >
> >> > > In networking, we have annoying issues at device or netns dismantles,
> >> > > and we had various proposals to ease root causing them.
> >> > ...
> >> > > --- a/lib/Kconfig
> >> > > +++ b/lib/Kconfig
> >> > > @@ -680,6 +680,11 @@ config STACK_HASH_ORDER
> >> > >        Select the hash size as a power of 2 for the stackdepot hash table.
> >> > >        Choose a lower value to reduce the memory impact.
> >> > >
> >> > > +config REF_TRACKER
> >> > > +     bool
> >> > > +     depends on STACKTRACE_SUPPORT
> >> > > +     select STACKDEPOT
> >> >
> >> > Hi,
> >> >
> >> > I have to:
> >> > +       select STACKDEPOT_ALWAYS_INIT
> >> > here. Otherwise I see this during boot:
> >> >
> >>
> >> Thanks, I am adding Vlastimil Babka to the CC
> >>
> >> This stuff has been added in
> >> commit e88cc9f5e2e7a5d28a1adf12615840fab4cbebfd
> >> Author: Vlastimil Babka <vbabka@suse.cz>
> >> Date:   Tue Dec 14 21:50:42 2021 +0000
> >>
> >>     lib/stackdepot: allow optional init and stack_table allocation by kvmalloc()
> >>
> >>
> >
> > (This is a problem because this patch is not yet in net-next, so I really do
> > not know how this issue should be handled)
>
> Looks like multiple new users of stackdepot start appearing as soon as I
> touch it :)
>
> The way we solved this with a new DRM user was Andrew adding a fixup to my
> patch referenced above, in his "after-next" section of mm tree.
> Should work here as well.
>
> ----8<----
> From 0fa1f25925c05f8c5c4f776913d84904fb4c03a1 Mon Sep 17 00:00:00 2001
> From: Vlastimil Babka <vbabka@suse.cz>
> Date: Wed, 15 Dec 2021 11:52:10 +0100
> Subject: [PATCH] lib/stackdepot: allow optional init and stack_table
>  allocation by kvmalloc() - fixup4
>
> Due to 4e66934eaadc ("lib: add reference counting tracking infrastructure")
> landing recently to net-next adding a new stack depot user in lib/ref_tracker.c
> we need to add an appropriate call to stack_depot_init() there as well.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

I guess this minimal fix will do.

In the future, when net-next (or net tree) has everything in place,
I will probably un-inline ref_tracker_dir_init() to avoid pulling
all these includes...

Reviewed-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jiri Slab <jirislaby@gmail.com>
