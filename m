Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7359B1A6CCC
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 21:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbgDMTqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 15:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387774AbgDMTqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 15:46:00 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C958C0A3BDC;
        Mon, 13 Apr 2020 12:46:00 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id w26so5002008qvd.10;
        Mon, 13 Apr 2020 12:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LWYST+QLnIy00/KXFSYZ6pjER0eBs8+nduvFaVPgAv0=;
        b=soK7rLPyV+Quc/+39BixgttRsD4sbmMFYQ3Eqmkyz9eaJ17P/9563NpeU/2zQnXpPH
         9/dgfBWrmzd3xltfbjgIUiy/fJH3JDf8cJ8tvUl/YdjKPHXqVA9k7+OMwULHBrC+Sduh
         TNz0fR3MmINwwLmSxv/amiUv2dLTLDhsmBSQdWSrb/CcAnzJgLtVBXznIA1ht1Wvyery
         wHZk7z9TbuewopKDI8iSgqkJ7LxY6L7mcB2XIBaANsZTUL7Jml/8cvrGNhWA48Cozo/q
         bgNMv2eyrivmoJXhbaM85qc62zJvI7dBBr6daMFoFbDQGOEZqw/HZ788/L43ALpIK+tI
         3LDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LWYST+QLnIy00/KXFSYZ6pjER0eBs8+nduvFaVPgAv0=;
        b=tFjd28v166DDn1x+CUiznUGSyTa7tH1RpsAsq+dOMDCPY1pzCt3/GpKpdDYWUxecmM
         tu7vGwLn95o5TtmI6c9epGV9PbsG9K7EO2ybsL/F54OeRQUOUpycgjROdfX/mxHoPhRG
         11TAlyyEhZAH9TjKcQHixuBdj0vBfzoDCE9H9JCFVLuc5Efu5pOWXsOeZdXV7tujqteY
         69I6OeEwBiKlRAZNi7a0rNQxxhPxUAemcwRdmIeUfOxwhPzjQLo4aXv5cFEAjJBdwVBL
         lB917vhRKTg7o5ldZjPARQ96u9EeNZdNNZeMnYXd1AF3JlojK1bQHiIhG6Uas+CpNtO1
         hZ9A==
X-Gm-Message-State: AGi0PubyEAbdcNqYz9Ly/bTgcXZnAGEdA8U4fSk1ikInJyYg/H6/3Mb1
        HtcPj5ZWUT1pgGYlk+B/bys+gZbHmviEYwKAhsA=
X-Google-Smtp-Source: APiQypJ22QjKJYVdN7gdVNoErHjREhN7xefrtLBjP+W7xFvyWkOhJL3bqP3j7BOgSe0kxzwBcM/NwaJPdWsnuxS2BFU=
X-Received: by 2002:a05:6214:1801:: with SMTP id o1mr18476073qvw.224.1586807159749;
 Mon, 13 Apr 2020 12:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4BzajwPzHUyBvVZzafgKZHXv7b0pmL_avtFO6-_QHh46z1g@mail.gmail.com> <ed14f5c8-dacc-369f-07d0-f5ee2877e8ea@fb.com>
In-Reply-To: <ed14f5c8-dacc-369f-07d0-f5ee2877e8ea@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 12:45:48 -0700
Message-ID: <CAEf4Bzarg7NjWs=6Pa5rsxJ4EYSCjx-LXZvTthsSVivNogOGbQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 4:41 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/10/20 3:51 PM, Andrii Nakryiko wrote:
> > On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Given a loaded dumper bpf program, which already
> >> knows which target it should bind to, there
> >> two ways to create a dumper:
> >>    - a file based dumper under hierarchy of
> >>      /sys/kernel/bpfdump/ which uses can
> >>      "cat" to print out the output.
> >>    - an anonymous dumper which user application
> >>      can "read" the dumping output.
> >>
> >> For file based dumper, BPF_OBJ_PIN syscall interface
> >> is used. For anonymous dumper, BPF_PROG_ATTACH
> >> syscall interface is used.
> >>
> >> To facilitate target seq_ops->show() to get the
> >> bpf program easily, dumper creation increased
> >> the target-provided seq_file private data size
> >> so bpf program pointer is also stored in seq_file
> >> private data.
> >>
> >> Further, a seq_num which represents how many
> >> bpf_dump_get_prog() has been called is also
> >> available to the target seq_ops->show().
> >> Such information can be used to e.g., print
> >> banner before printing out actual data.
> >>
> >> Note the seq_num does not represent the num
> >> of unique kernel objects the bpf program has
> >> seen. But it should be a good approximate.
> >>
> >> A target feature BPF_DUMP_SEQ_NET_PRIVATE
> >> is implemented specifically useful for
> >> net based dumpers. It sets net namespace
> >> as the current process net namespace.
> >> This avoids changing existing net seq_ops
> >> in order to retrieve net namespace from
> >> the seq_file pointer.
> >>
> >> For open dumper files, anonymous or not, the
> >> fdinfo will show the target and prog_id associated
> >> with that file descriptor. For dumper file itself,
> >> a kernel interface will be provided to retrieve the
> >> prog_id in one of the later patches.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h            |   5 +
> >>   include/uapi/linux/bpf.h       |   6 +-
> >>   kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
> >>   kernel/bpf/syscall.c           |  11 +-
> >>   tools/include/uapi/linux/bpf.h |   6 +-
> >>   5 files changed, 362 insertions(+), 4 deletions(-)
> >>
> >
> > [...]
> >
> >>
> >> +struct dumper_inode_info {
> >> +       struct bpfdump_target_info *tinfo;
> >> +       struct bpf_prog *prog;
> >> +};
> >> +
> >> +struct dumper_info {
> >> +       struct list_head list;
> >> +       /* file to identify an anon dumper,
> >> +        * dentry to identify a file dumper.
> >> +        */
> >> +       union {
> >> +               struct file *file;
> >> +               struct dentry *dentry;
> >> +       };
> >> +       struct bpfdump_target_info *tinfo;
> >> +       struct bpf_prog *prog;
> >> +};
> >
> > This is essentially a bpf_link. Why not do it as a bpf_link from the
> > get go? Instead of having all this duplication for anonymous and
>
> This is a good question. Maybe part of bpf-link can be used and
> I have to implement others. I will check.
>
> > pinned dumpers, it would always be a bpf_link-based dumper, but for
> > those pinned bpf_link itself is going to be pinned. You also get a
> > benefit of being able to list all dumpers through existing bpf_link
> > API (also see my RFC patches with bpf_link_prime/bpf_link_settle,
> > which makes using bpf_link safe and simple).
>
> Agree. Alternative is to use BPF_OBJ_GET_INFO_BY_FD to query individual
> dumper as directory tree walk can be easily done at user space.

But BPF_OBJ_GET_INFO_BY_FD won't work well for anonymous dumpers,
because it's not so easy to iterate over them (possible, but not
easy)?

>
>
> >
> > [...]
> >
> >> +
> >> +static void anon_dumper_show_fdinfo(struct seq_file *m, struct file *filp)
> >> +{
> >> +       struct dumper_info *dinfo;
> >> +
> >> +       mutex_lock(&anon_dumpers.dumper_mutex);
> >> +       list_for_each_entry(dinfo, &anon_dumpers.dumpers, list) {
> >
> > this (and few other places where you search in a loop) would also be
> > simplified, because struct file* would point to bpf_dumper_link, which
> > then would have a pointer to bpf_prog, dentry (if pinned), etc. No
> > searching at all.
>
> This is a reason for this. the same as bpflink, bpfdump already has
> the full information about file, inode, etc.

I think (if I understand what you are saying), this is my point. What
you have in struct dumper_info is already a custom bpf_link. You are
just missing `struct bpf_link link;` field there and plugging it into
overall bpf_link infrastructure (bpf_link__init + bpf_link__prime +
bpf_link__settle, from my RFC) to gain benefits of bpf_link infra.


> The file private_data actually points to seq_file. The seq_file private
> data is used in the target. That is exactly why we try to have this
> mapping to keep track. bpf_link won't help here.

I need to go and re-read all the code again carefully with who stores
what in their private_data field...

>
> >
> >> +               if (dinfo->file == filp) {
> >> +                       seq_printf(m, "target:\t%s\n"
> >> +                                     "prog_id:\t%u\n",
> >> +                                  dinfo->tinfo->target,
> >> +                                  dinfo->prog->aux->id);
> >> +                       break;
> >> +               }
> >> +       }
> >> +       mutex_unlock(&anon_dumpers.dumper_mutex);
> >> +}
> >> +
> >> +#endif
> >> +
> >
> > [...]
> >
