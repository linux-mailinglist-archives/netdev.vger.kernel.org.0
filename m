Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961C3207A97
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405617AbgFXRrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405546AbgFXRri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:47:38 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208E3C061573;
        Wed, 24 Jun 2020 10:47:37 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id j80so2670648qke.0;
        Wed, 24 Jun 2020 10:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDeplexJYKJFCmTXHzaNlUT1Wfw0viZhbSjttAQq4LI=;
        b=glVB/WzKznagnqZDGM8md/Q8riLN5132elJ75PCMplN141a0dEEICbCNnSNaqHGvik
         GnWA5H2jkJ2QAcdSYiFZR0WiKNch9UssTnitvtLis256n6IZIe4iE1e4II+seDlGM6le
         81JXCRgJ8OL96NNH6HjpMjxmqinuqbqmUEa6XWC16wjUErSno9MJzBH9GWPH/wIu9GgU
         s8BnbwyQDZ8Plrpiv5KHqUndIP+DXIrYdxKEtK7YfBoQNOp0rYl0Onb9F4jbwiIdDc6c
         EMaaQmkU0fmi2u5j+2Cn8oyZIlkw0uIxCpz0oL5n/DTiUTc8gmreVxQIl7pFfGoXDXz6
         5TDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDeplexJYKJFCmTXHzaNlUT1Wfw0viZhbSjttAQq4LI=;
        b=seD09HkU+isHvgyVWHZnXrPBNrvLYmr1RM8e35lvEzV5an9P08d4VGIzKa3qIWwQAj
         U0ufxofvetem1Bl8Ev94NEXKiREhx7pruVDLZ7/H33eRXSMU0hDruQ1QtD9Ayvz5KVA7
         fgY/qh08KGAolvEpQp6x7V7Lnctufre1hbJLLuO5AG2p3Wa83aZb+mJNQ5O6CL0f50Rb
         aPZGlsnXAZYbgbfDkImqxHsnihPDV5ieUHfe4avMfEBExqZSf4nc5VzxnegKh9K1tWYg
         ACy/lbOf/aTPVMu+f3hEyKxlXed4yIBy0Pb0Q75gXQohxNT7vAA1XIBdnKrn0sC8UM0O
         dLNQ==
X-Gm-Message-State: AOAM533uQHyEQmJdSwxkHwv5/tPZBL2a5YQ/46TmvfkYk//AS3HJW4f6
        mRSwKatnAUBuAsM/l6knRrOXR4dYejHAcPj+J4U=
X-Google-Smtp-Source: ABdhPJz6uDyVsH4O0gdOogOtMBxKskLO+U90ygxqrR7eZ2ML+RC/gG9gO6T4Yw1xaFOKljkc/CtcILQU4CFxLvZ7pV8=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr20555327qkn.36.1593020856292;
 Wed, 24 Jun 2020 10:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200623103459.697774-1-jakub@cloudflare.com> <20200623103459.697774-3-jakub@cloudflare.com>
 <87o8p8mlfx.fsf@cloudflare.com>
In-Reply-To: <87o8p8mlfx.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Jun 2020 10:47:25 -0700
Message-ID: <CAEf4BzYZLTYmLcaSrrXptD8fOX3O9TdT2yQcbbGZiaqt6s3k4g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in bpf_prog_array
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 10:19 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Tue, Jun 23, 2020 at 12:34 PM CEST, Jakub Sitnicki wrote:
> > Prepare for having multi-prog attachments for new netns attach types by
> > storing programs to run in a bpf_prog_array, which is well suited for
> > iterating over programs and running them in sequence.
> >
> > Because bpf_prog_array is dynamically resized, after this change a
> > potentially blocking memory allocation in bpf(PROG_QUERY) callback can
> > happen, in order to collect program IDs before copying the values to
> > user-space supplied buffer. This forces us to adapt how we protect access
> > to the attached program in the callback. As bpf_prog_array_copy_to_user()
> > helper can sleep, we switch from an RCU read lock to holding a mutex that
> > serializes updaters.
> >
> > To handle bpf(PROG_ATTACH) scenario when we are replacing an already
> > attached program, we introduce a new bpf_prog_array helper called
> > bpf_prog_array_replace_item that will exchange the old program with a new
> > one. bpf-cgroup does away with such helper by computing an index into the
> > array from a program position in an external list of attached
> > programs/links. Such approach fails when a dummy prog is left in the array
> > after a memory allocation failure on link release, but is necessary in
> > bpf-cgroup case because the same BPF program can be present in the array
> > multiple times due to inheritance, and attachment cannot be reliably
> > identified by bpf_prog pointer comparison.
> >
> > No functional changes intended.
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > ---
> >  include/linux/bpf.h        |   3 +
> >  include/net/netns/bpf.h    |   5 +-
> >  kernel/bpf/core.c          |  20 ++++--
> >  kernel/bpf/net_namespace.c | 137 +++++++++++++++++++++++++++----------
> >  net/core/flow_dissector.c  |  21 +++---
> >  5 files changed, 132 insertions(+), 54 deletions(-)
> >
>
> [...]
>
> > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> > index b951dab2687f..593523a22168 100644
> > --- a/kernel/bpf/net_namespace.c
> > +++ b/kernel/bpf/net_namespace.c
>
> [...]
>
> > @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
> >               goto out_unlock;
> >       }
> >
> > +     run_array = rcu_dereference_protected(net->bpf.run_array[type],
> > +                                           lockdep_is_held(&netns_bpf_mutex));
> > +     if (run_array)
> > +             ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);
>
> Thinking about this some more, link update should fail with -EINVAL if
> new_prog already exists in run_array. Same as PROG_ATTACH fails with
> -EINVAL when trying to attach the same prog for the second time.
>
> Otherwise, LINK_UPDATE can lead to having same BPF prog present multiple
> times in the prog_array, once attaching more than one prog gets enabled.
>
> Then we would we end up with the same challenge as bpf-cgroup, that is
> how to find the program index into the prog_array in presence of
> dummy_prog's.

If you attach 5 different links having the same bpf_prog, it should be
allowed and all five bpf_progs should be attached and called 5 times.
They are independent links, that's the main thing. What specific BPF
program is attached by the link (or later updated to) shouldn't be of
any concern here (relative to other attached links/programs).

Attaching the same *link* twice shouldn't be allowed, though.

>
> > +     else
> > +             ret = -ENOENT;
> > +     if (ret)
> > +             goto out_unlock;
> > +
> >       old_prog = xchg(&link->prog, new_prog);
> > -     rcu_assign_pointer(net->bpf.progs[type], new_prog);
> >       bpf_prog_put(old_prog);
> >
> >  out_unlock:
>
> [...]
>
> > @@ -217,14 +249,25 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> >       if (ret)
> >               goto out_unlock;
> >
> > -     attached = rcu_dereference_protected(net->bpf.progs[type],
> > -                                          lockdep_is_held(&netns_bpf_mutex));
> > +     attached = net->bpf.progs[type];
> >       if (attached == prog) {
> >               /* The same program cannot be attached twice */
> >               ret = -EINVAL;
> >               goto out_unlock;
> >       }
> > -     rcu_assign_pointer(net->bpf.progs[type], prog);
> > +
> > +     run_array = rcu_dereference_protected(net->bpf.run_array[type],
> > +                                           lockdep_is_held(&netns_bpf_mutex));
> > +     if (run_array) {
> > +             ret = bpf_prog_array_replace_item(run_array, attached, prog);
>
> I didn't consider here that there can be a run_array with a dummy_prog
> from a link release that failed to allocate memory.
>
> In such case bpf_prog_array_replace_item will fail, while we actually
> want to replace the dummy_prog.
>
> The right thing to do is to replace the first item in prog array:
>
>         if (run_array) {
>                 WRITE_ONCE(run_array->items[0].prog, prog);
>         } else {
>                 /* allocate a bpf_prog_array */
>         }
>
> This leaves just one user of bpf_prog_array_replace_item(), so I think
> I'm just going to fold it into its only caller, that is the update_prog
> callback.

That will change relative order of BPF programs, which I think is bad.
So I agree that bpf_prog_array_replace_item is not all that useful and
probably should be dropped. And the right way is to know the position
of bpf_prog you are trying to replace/delete, just like cgroup case.
Except cgroup case is even more complicated due to inheritance and
hierarchy, which luckily you don't have to deal with here.

>
> > +     } else {
> > +             ret = bpf_prog_array_copy(NULL, NULL, prog, &run_array);
> > +             rcu_assign_pointer(net->bpf.run_array[type], run_array);
> > +     }
> > +     if (ret)
> > +             goto out_unlock;
> > +
> > +     net->bpf.progs[type] = prog;
> >       if (attached)
> >               bpf_prog_put(attached);
> >
>
> [...]
