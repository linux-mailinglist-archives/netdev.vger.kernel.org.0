Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05250315AAC
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235006AbhBJAIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbhBIXro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 18:47:44 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F58C061756
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 15:47:02 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t25so27116pga.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 15:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kwOO5Lzqe/DKKRianRqGoIpJuvnD5y6ZAiU+hEXomKc=;
        b=P9RoCCDshP5Gn0qYyglfuavfXhinpG1bvadT4phnPObIejOPsbXe22OpzCmThkSXIy
         LtnP+zriNuoEYPUl1Dm8mhA0stbsX65/NtcV1TBB1BN6RTIeUd2nj0bhWRjLni17xxsm
         d8htLNRDqdyccFzMNjRzk7uXOOHtSF2GGiGcBZSERCNTtfQDI0Hrmn3cu0XxIgaPUQ/H
         jPzpIzYbJQG2QeT7wZQp5dsV2ktviNBL8kF+kRvY2/mOsp+l95H7NgTfQlkG+b9vZ+hg
         fZo8CvkbUfybSiXRhb5QhyyF9kZ8SWMrSwwN0sy8xmQthInY0zxFg29WE5NdUqIA1ZOi
         P95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kwOO5Lzqe/DKKRianRqGoIpJuvnD5y6ZAiU+hEXomKc=;
        b=MMmrBku9pqkqOamtxaDouzxgtkQpDOdNel07bjJvDrYySxV0XwRldC7H07NsHh/1PR
         2DCMyeuvSU6/dKT0tVSBIK5mMoG2yZnCgaCfdJWzmih1IxrKoWJUCdVJBHw/b88GCYje
         eFt82vokaNlH6J+7RAsdEkfF8vhthYsw9HeGTql/t673X3MKSTiRRLef4aVoW6rhIIsK
         b/pgWe7WEF2A5YhpDL+e+Uo9jTOeaMA/J73MCrojcBn1kQyykaage9i1fVeSaMzxxjR3
         cN5v6dpPLxWj00BbHzjLoacs7qIsfzQ+Bslcr+Lc8aioFuP7xh1S0ET66TEwVVupz2H3
         yZow==
X-Gm-Message-State: AOAM530KdB6qGXa3ZO3wIoC1cPvUSDtBVs/4/deDLeUxfhI1+Pn4IGlB
        QK+tCwckwUsQ6czRS6q7Jp/WMlNTG0JmERnIpqyZbw==
X-Google-Smtp-Source: ABdhPJxLBag82vWVtuawEnr6yXdywGwy8KWovw4BfiX8YyTgjoUYX6chlka5RVAKGplTIgMV46LfsQ2S+VV7GgVxt7k=
X-Received: by 2002:aa7:961b:0:b029:1db:532c:9030 with SMTP id
 q27-20020aa7961b0000b02901db532c9030mr483092pfg.30.1612914421469; Tue, 09 Feb
 2021 15:47:01 -0800 (PST)
MIME-Version: 1.0
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal> <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <09fa284e-ea02-a6ca-cd8f-6d90dff2fa00@gmail.com> <20210208185323.11c2bacf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <af35d535-8d58-3cf3-60e3-1764e409308b@gmail.com> <20210209085909.32d27f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209085909.32d27f0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Tue, 9 Feb 2021 15:46:50 -0800
Message-ID: <CAOFY-A3wgGfBM0gia66VJY_iUBueWN1a4Ai8v9MT+at_pcH7-w@mail.gmail.com>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Leon Romanovsky <leon@kernel.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 8:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 8 Feb 2021 20:20:29 -0700 David Ahern wrote:
> > On 2/8/21 7:53 PM, Jakub Kicinski wrote:
> > > On Mon, 8 Feb 2021 19:24:05 -0700 David Ahern wrote:
> > >> That would be the case for new userspace on old kernel. Extending the
> > >> check to the end of the struct would guarantee new userspace can not ask
> > >> for something that the running kernel does not understand.
> > >
> > > Indeed, so we're agreeing that check_zeroed_user() is needed before
> > > original optlen from user space gets truncated?
> >
> > I thought so, but maybe not. To think through this ...
> >
> > If current kernel understands a struct of size N, it can only copy that
> > amount from user to kernel. Anything beyond is ignored in these
> > multiplexed uAPIs, and that is where the new userspace on old kernel falls.
> >
> > Known value checks can only be done up to size N. In this case, the
> > reserved field is at the end of the known struct size, so checking just
> > the field is fine. Going beyond the reserved field has implications for
> > extensions to the API which should be handled when those extensions are
> > added.
>
> Let me try one last time.
>
> There is no check in the kernels that len <= N. User can pass any
> length _already_. check_zeroed_user() forces the values beyond the
> structure length to be known (0) rather than anything. It can only
> avoid breakages in the future.
>
> > So, in short I think the "if (zc.reserved)" is correct as Leon noted.
>
> If it's correct to check some arbitrary part of the buffer is zeroed
> it should be correct to check the entire tail is zeroed.

So, coming back to the thread, I think the following appears to be the
current thoughts:

1. It is requested that, on the kernel as it stands today, fields
beyond zc.msg_flags (including zc.reserved, the only such field as of
this patch) are zero'd out. So a new userspace asking to do specific
things would fail on this old kernel with EINVAL. Old userspace would
work on old or new kernels. New of course works on new kernels.
2. If it's correct to check some arbitrary field (zc.reserved) to be
0, then it should be fine to check this for all future fields >=
reserved in the struct. So some advanced userspace down the line
doesn't get confused.

Strictly speaking, I'm not convinced this is necessary - eg. 64 bytes
struct right now, suppose userspace of the future gives us 96 bytes of
which the last 32 are non-zero for some feature or the other. We, in
the here and now kernel, truncate that length to 64 (as in we only
copy to kernel those first 64 bytes) and set the returned length to
64. The understanding being, any (future, past or present) userspace
consults the output value; and considers anything byte >= the returned
len to be untouched by the kernel executing the call (ie. garbage,
unacted upon).

So, how would this work for old+new userspace on old+new kernel?

A) old+old, new+new: sizes match, no issue
B) new kernel, old userspace: That's not an issue. We have the
switch(len) statement for that.
C) old kernel, new userspace: that's the 96 vs. 64 B example above -
new userspace would see that the kernel only operated on 64 B and
treat the last 32 B as garbage/unacted on.

In this case, we would not give EINVAL on case C, as we would if we
returned EINVAL on a check_zeroed_user() case for fields past
zc.reserved. We'd do a zerocopy operating on just the features we know
about, and communicate to the user that we only acted on features up
until this byte offset.

Now, given this is the case, we still have the padding confusion with
zc.reserved and the current struct size, so we have to force it to 0
as we are doing. But I think we don't need to go beyond this so far.

Thus, my personal preference is to not have the check_zeroed_user()
check. But if the consensus demands it, then it's an easy enough fix.
What are your thoughts?

Thanks,
-Arjun
