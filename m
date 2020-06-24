Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCC8207B71
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406045AbgFXSYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405694AbgFXSYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:24:21 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F392CC061573;
        Wed, 24 Jun 2020 11:24:19 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id g7so1490618qvx.11;
        Wed, 24 Jun 2020 11:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ncMvwWx9CvMBp/lRUpOz/mE27cQlw4qGmZzQ0V/hiNo=;
        b=IagU8y17desKqz/4FVjYJswixhy2fbLchv6JKqR5u/nAJZaJrdYpY8qfKf/FCfF5VF
         q2xhrVQEFmwlo8dgdRO4QRrgn7kGehLF/j/rqUzESBE+q8UjTcDojOidbG6ucayfJ907
         XuG69ZEkxKbNTgsf6M0Z1sd/rbcd1fq35W53rCTmTs6foSoNtDu+rTXlniyyGBREgKi9
         KTBohpvaSEpcx/PupSys66XYR0qY3w5Nvtkb0yXKbG4lKen8SKxGzktCCdTRhoT8YPXe
         EffM2lMCKS9V2Pjf9Xf9UaGCz1j+9RyVVT+sWirBEAka3o7GatCKtemXarlQNAPx7jPP
         y6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ncMvwWx9CvMBp/lRUpOz/mE27cQlw4qGmZzQ0V/hiNo=;
        b=V4rLP4X7DVMYRnkI70NTIhMZACbBr6ikhjq9GWnMOtxvjugaMe4fsidM1AjGsOUjl4
         xGCYwP95HyTkEZlfIH60tL/up4BrHxDgqYPjfFHjzd7lc5YX6BwoguHx5a5110vbMrNr
         EeZZIVgi3y0jvZ7Sn43bLK7OHFakKqd93gsqZQ2gSLQSAYaReJAtzSLjyIO7EmeoM+WH
         oUQ4V4Q+4mSobKSRl+2T4bXlztoa4QuI+Iw9UFuRTtC4oALg+w3kZBeA8mWDD4LsAK5Q
         YVUQKim0JHTrMQBziX1F+UinsAww8tZkhMkcqKuuXhkEOncFSrZFk4aPmTCTymqd00GF
         37rw==
X-Gm-Message-State: AOAM531wAFBzPIkruyuongkBt5NRR1DS9v0GBt6FQtVmyl+gji84t/0I
        9X3QsLrbT0zmlbNDh/4n6NJ1gwFGvmq6tULhdlI=
X-Google-Smtp-Source: ABdhPJzIBjhEoR8V7WdtLOiB3VPDEAPKhLicr6rSURO+Jw383fl/f4Zz7AtkWdqhAOItmVpWLS5Vu14YNoA/NS/+Al0=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr31680368qvf.247.1593023058924;
 Wed, 24 Jun 2020 11:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200623103459.697774-1-jakub@cloudflare.com> <20200623103459.697774-3-jakub@cloudflare.com>
 <87o8p8mlfx.fsf@cloudflare.com> <CAEf4BzYZLTYmLcaSrrXptD8fOX3O9TdT2yQcbbGZiaqt6s3k4g@mail.gmail.com>
 <87lfkcmiw0.fsf@cloudflare.com>
In-Reply-To: <87lfkcmiw0.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Jun 2020 11:24:07 -0700
Message-ID: <CAEf4BzZYjPL+TmqFfuEFgzm+qUh_T2zHsRZjq-BE+LMu+25=ZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in bpf_prog_array
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 11:16 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Jun 24, 2020 at 07:47 PM CEST, Andrii Nakryiko wrote:
> > On Wed, Jun 24, 2020 at 10:19 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> On Tue, Jun 23, 2020 at 12:34 PM CEST, Jakub Sitnicki wrote:
> >> > Prepare for having multi-prog attachments for new netns attach types by
> >> > storing programs to run in a bpf_prog_array, which is well suited for
> >> > iterating over programs and running them in sequence.
> >> >
> >> > Because bpf_prog_array is dynamically resized, after this change a
> >> > potentially blocking memory allocation in bpf(PROG_QUERY) callback can
> >> > happen, in order to collect program IDs before copying the values to
> >> > user-space supplied buffer. This forces us to adapt how we protect access
> >> > to the attached program in the callback. As bpf_prog_array_copy_to_user()
> >> > helper can sleep, we switch from an RCU read lock to holding a mutex that
> >> > serializes updaters.
> >> >
> >> > To handle bpf(PROG_ATTACH) scenario when we are replacing an already
> >> > attached program, we introduce a new bpf_prog_array helper called
> >> > bpf_prog_array_replace_item that will exchange the old program with a new
> >> > one. bpf-cgroup does away with such helper by computing an index into the
> >> > array from a program position in an external list of attached
> >> > programs/links. Such approach fails when a dummy prog is left in the array
> >> > after a memory allocation failure on link release, but is necessary in
> >> > bpf-cgroup case because the same BPF program can be present in the array
> >> > multiple times due to inheritance, and attachment cannot be reliably
> >> > identified by bpf_prog pointer comparison.
> >> >
> >> > No functional changes intended.
> >> >
> >> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> > ---
> >> >  include/linux/bpf.h        |   3 +
> >> >  include/net/netns/bpf.h    |   5 +-
> >> >  kernel/bpf/core.c          |  20 ++++--
> >> >  kernel/bpf/net_namespace.c | 137 +++++++++++++++++++++++++++----------
> >> >  net/core/flow_dissector.c  |  21 +++---
> >> >  5 files changed, 132 insertions(+), 54 deletions(-)
> >> >
> >>
> >> [...]
> >>
> >> > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> >> > index b951dab2687f..593523a22168 100644
> >> > --- a/kernel/bpf/net_namespace.c
> >> > +++ b/kernel/bpf/net_namespace.c
> >>
> >> [...]
> >>
> >> > @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
> >> >               goto out_unlock;
> >> >       }
> >> >
> >> > +     run_array = rcu_dereference_protected(net->bpf.run_array[type],
> >> > +                                           lockdep_is_held(&netns_bpf_mutex));
> >> > +     if (run_array)
> >> > +             ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);
> >>
> >> Thinking about this some more, link update should fail with -EINVAL if
> >> new_prog already exists in run_array. Same as PROG_ATTACH fails with
> >> -EINVAL when trying to attach the same prog for the second time.
> >>
> >> Otherwise, LINK_UPDATE can lead to having same BPF prog present multiple
> >> times in the prog_array, once attaching more than one prog gets enabled.
> >>
> >> Then we would we end up with the same challenge as bpf-cgroup, that is
> >> how to find the program index into the prog_array in presence of
> >> dummy_prog's.
> >
> > If you attach 5 different links having the same bpf_prog, it should be
> > allowed and all five bpf_progs should be attached and called 5 times.
> > They are independent links, that's the main thing. What specific BPF
> > program is attached by the link (or later updated to) shouldn't be of
> > any concern here (relative to other attached links/programs).
> >
> > Attaching the same *link* twice shouldn't be allowed, though.
>
> Thanks for clarifying. I need to change the approach then:
>
>  1) find the prog index into prog_array by iterating the list of links,
>  2) adjust the index for any dummy progs in prog_array below the index.
>
> That might work for bpf-cgroup too.
>

I thought that's what bpf-cgroup already does... Except right now
there could be no dummy progs, but if we do non-failing detachment,
there might be. Then hierarchies can get out of sync and we need to
handle that nicely. It's not super straightforward, that's why I said
that it's a nice challenge to consider :)

But here we don't have hierarchy, it's a happy place to be in :)


> The only other alternative I can think of it to copy the prog array to
> filter out dummy_progs, before replacing the prog on link update.

Probably over-complication. I'd filter dummy progs only on new link
attachment or detachment. Update can be kept very simple.

>
> >
> >>
> >> > +     else
> >> > +             ret = -ENOENT;
> >> > +     if (ret)
> >> > +             goto out_unlock;
> >> > +
> >> >       old_prog = xchg(&link->prog, new_prog);
> >> > -     rcu_assign_pointer(net->bpf.progs[type], new_prog);
> >> >       bpf_prog_put(old_prog);
> >> >
> >> >  out_unlock:
> >>
> >> [...]
> >>
> >> > @@ -217,14 +249,25 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> >> >       if (ret)
> >> >               goto out_unlock;
> >> >
> >> > -     attached = rcu_dereference_protected(net->bpf.progs[type],
> >> > -                                          lockdep_is_held(&netns_bpf_mutex));
> >> > +     attached = net->bpf.progs[type];
> >> >       if (attached == prog) {
> >> >               /* The same program cannot be attached twice */
> >> >               ret = -EINVAL;
> >> >               goto out_unlock;
> >> >       }
> >> > -     rcu_assign_pointer(net->bpf.progs[type], prog);
> >> > +
> >> > +     run_array = rcu_dereference_protected(net->bpf.run_array[type],
> >> > +                                           lockdep_is_held(&netns_bpf_mutex));
> >> > +     if (run_array) {
> >> > +             ret = bpf_prog_array_replace_item(run_array, attached, prog);
> >>
> >> I didn't consider here that there can be a run_array with a dummy_prog
> >> from a link release that failed to allocate memory.
> >>
> >> In such case bpf_prog_array_replace_item will fail, while we actually
> >> want to replace the dummy_prog.
> >>
> >> The right thing to do is to replace the first item in prog array:
> >>
> >>         if (run_array) {
> >>                 WRITE_ONCE(run_array->items[0].prog, prog);
> >>         } else {
> >>                 /* allocate a bpf_prog_array */
> >>         }
> >>
> >> This leaves just one user of bpf_prog_array_replace_item(), so I think
> >> I'm just going to fold it into its only caller, that is the update_prog
> >> callback.
> >
> > That will change relative order of BPF programs, which I think is bad.
> > So I agree that bpf_prog_array_replace_item is not all that useful and
> > probably should be dropped. And the right way is to know the position
> > of bpf_prog you are trying to replace/delete, just like cgroup case.
> > Except cgroup case is even more complicated due to inheritance and
> > hierarchy, which luckily you don't have to deal with here.
>
> I think we are on the same page.
>
> The write to first item could change the relative prog order, and even
> replace the wrong program, but only if we had to deal with a prog_array
> larger > 1.
>
> In this case, direct attachment with PROG_ATTACH to netns, the
> prog_array size is always 1, if it has been allocated already.
>
> That is because I did not plan to enable multi-prog attachment for
> flow_dissector with links. And only flow_dissector uses PROG_ATTACH to
> netns.

I was thinking in general for multi-link case, yeah. For this case, sure.

>
> >
> >>
> >> > +     } else {
> >> > +             ret = bpf_prog_array_copy(NULL, NULL, prog, &run_array);
> >> > +             rcu_assign_pointer(net->bpf.run_array[type], run_array);
> >> > +     }
> >> > +     if (ret)
> >> > +             goto out_unlock;
> >> > +
> >> > +     net->bpf.progs[type] = prog;
> >> >       if (attached)
> >> >               bpf_prog_put(attached);
> >> >
> >>
> >> [...]
