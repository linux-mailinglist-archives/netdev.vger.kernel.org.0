Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB754249EE
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239722AbhJFWk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239779AbhJFWkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:40:23 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2002DC06136E;
        Wed,  6 Oct 2021 15:37:28 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id g6so8972491ybb.3;
        Wed, 06 Oct 2021 15:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=El8xgii0miK9wdp95H0ci9RxSrj37YXXjsNsZAOWyDQ=;
        b=EiaD2aKNLD/AzSjRN7rXNOwuaqNZA0+/zKRnrw0T45I5GyOCRqy7VGsDTznYkowG5k
         PFQm0JY3ZTfXqXONoSvnR6DslULir0Sym3RqRST4B9pS+wCvTn1aRypI8WbbbMLp2ubL
         B/q5EZrusRZO/uJb/FO5eNSHW+I6b0iWVODY2TacV11XlAsUtMOqrmAZQT1ZI8w0BIuK
         ZRtAB6xfA6vjkN+9/qskjJDby49F+51pwmYcDM03v/T1k0gTAQ/UTni/2qljP/MUDY7u
         9bYXAj4cKvZKHHVjfqWBcA3kVsLFtiupnnwnEd2kwnZFRkbqMXdgGoZeZ6GOaapDUjFN
         Tmig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=El8xgii0miK9wdp95H0ci9RxSrj37YXXjsNsZAOWyDQ=;
        b=oPh87Lz7o+doKlrUUHdh0Cjg+KV4mMGy4sGrWgQMewlfQehamygvJYi/0+WBC94rmQ
         3kMWxHPFV++Voeuy+lOhKyV1JT4TYlbhYAnVF/spROikLjJQjlRVa7TZR2h3zlUJ7p6t
         jaPnfuuIZRYmFap3LToYVmgQ/fcsCZm0wW5cYMYkaMKKcA5paevizHibN1wrb1jr003+
         mhbBrcxTKgeyWOWo2rXtqdgezH8mTbZD+CjfN4gjfEZiRQbcEF1TyY0xgw2OPCSfjOKI
         9Ax9YiW4SXqHWyfAIymxF/RxCMD8uQ6OcYAaZ1XLiGSztRyaFxY85U6+Sv2tz84pAo0D
         oDiA==
X-Gm-Message-State: AOAM531zCZ1kCpRUNeYoy4TtoqvTDTeEs1TVoEbFA7SZ/MMp5mi8bbpO
        AZkV6IN/vkS9AX97AQ84HBNxp+Qi2hMtO59GVFk=
X-Google-Smtp-Source: ABdhPJzKMZAt5W3/de7ps/eTKOWcjTBt+gnEkuVijzmw7ZaUJe2oy5ajUPhK9lVevo9Gopcz5O4GR5Zw+6cK1A+dW88=
X-Received: by 2002:a25:5606:: with SMTP id k6mr862386ybb.51.1633559847302;
 Wed, 06 Oct 2021 15:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <YV1hRboJopUBLm3H@krava> <CAEf4BzZPH6WQTYaUTpWBw1gW=cNUtPYPnN8OySgXtbQLzZLhEQ@mail.gmail.com>
 <YV4Bx7705mgWzhTd@krava> <CAEf4BzbirA4F_kW-sVrS_YmfUxhAjYVDwO1BvtzTYyngqHLkiw@mail.gmail.com>
 <YV4dmkXO6nkB2DeV@krava>
In-Reply-To: <YV4dmkXO6nkB2DeV@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 15:37:16 -0700
Message-ID: <CAEf4BzYBS8+9XADjJdvKB=_6tf8_t19UVGfm2Lk1+Nb6qWk5cw@mail.gmail.com>
Subject: Re: [RFC] store function address in BTF
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 3:05 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Oct 06, 2021 at 02:22:28PM -0700, Andrii Nakryiko wrote:
> > On Wed, Oct 6, 2021 at 1:06 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Wed, Oct 06, 2021 at 09:17:39AM -0700, Andrii Nakryiko wrote:
> > > > On Wed, Oct 6, 2021 at 1:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > hi,
> > > > > I'm hitting performance issue and soft lock ups with the new version
> > > > > of the patchset and the reason seems to be kallsyms lookup that we
> > > > > need to do for each btf id we want to attach
> > > > >
> > > > > I tried to change kallsyms_lookup_name linear search into rbtree search,
> > > > > but it has its own pitfalls like duplicate function names and it still
> > > > > seems not to be fast enough when you want to attach like 30k functions
> > > >
> > > > How not fast enough is it exactly? How long does it take?
> > >
> > > 30k functions takes 75 seconds for me, it's loop calling bpf_check_attach_target
> > >
> > > getting soft lock up messages:
> > >
> > > krava33 login: [  168.896671] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [bpftrace:1087]
> > >
> >
> > That's without RB tree right? I was curious about the case of you
> > converting kallsyms to RB tree and it still being slow. Can't imagine
> > 30k queries against RB tree with ~160k kallsyms taking 75 seconds.
>
> yep, that's the standard kallsyms lookup api
>
> I need to make some adjustment for rbtree kalsyms code, I think I found
> a bug in there, so the numbers are probably better as you suggest

ok, cool, let's see what are the new numbers then

>
> >
> > But as I said, why not map BTF IDs into function names, sort function
> > names, and then pass over kallsyms once, doing binary search into a
> > sorted array of requested function names and then recording addr for
> > each. Then check that you found addresses for all functions (it also
> > leaves a question of what to do when we have multiple matching
> > functions, but it's a problem with any approach). If everything checks
> > out, you have a nice btf id -> func name -> func addr mapping. It's
> > O(N log(M)), which sounds like it shouldn't be slow. Definitely not
> > multiple seconds slow.
>
> ok, now that's clear to me, thanks for these details

great

>
> >
> >
> > >
> > > >
> > > > >
> > > > > so I wonder we could 'fix this' by storing function address in BTF,
> > > > > which would cut kallsyms lookup completely, because it'd be done in
> > > > > compile time
> > > > >
> > > > > my first thought was to add extra BTF section for that, after discussion
> > > > > with Arnaldo perhaps we could be able to store extra 8 bytes after
> > > > > BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
> > > > > indicate that? or new BTF_KIND_FUNC2 type?
> > > > >
> > > > > thoughts?
> > > >
> > > > I'm strongly against this, because (besides the BTF bloat reason) we
> > > > need similar mass attachment functionality for kprobe/kretprobe and
> > > > that one won't be relying on BTF FUNCs, so I think it's better to
> > > > stick to the same mechanism for figuring out the address of the
> > > > function.
> > >
> > > ok
> > >
> > > >
> > > > If RB tree is not feasible, we can do a linear search over unsorted
> > > > kallsyms and do binary search over sorted function names (derived from
> > > > BTF IDs). That would be O(Nlog(M)), where N is number of ksyms, M is
> > > > number of BTF IDs/functions-to-be-attached-to. If we did have an RB
> > > > tree for kallsyms (is it hard to support duplicates? why?) it could be
> > > > even faster O(Mlog(N)).
> > >
> > > I had issues with generic kallsyms rbtree in the post some time ago,
> > > I'll revisit it to check on details.. but having the tree with just
> > > btf id functions might clear that.. I'll check
> >
> > That's not what I'm proposing. See above. Please let me know if
> > something is not clear before going all in for RB tree implementation
> > :)
> >
> >
> > But while we are on topic, do you think (with ftrace changes you are
> > doing) it would be hard to support multi-attach for
> > kprobes/kretprobes? We now have bpf_link interface for attaching
> > kprobes, so API can be pretty aligned with fentry/fexit, except
> > instead of btf IDs we'd need to pass array of pointers of C strings, I
> > suppose.
>
> hum, I think kprobe/kretprobe is made of perf event (kprobe/kretprobe
> pmus), then you pass event fd and program fd to bpf link syscall,
> and it attaches bpf program to that perf event
>
> so perhaps the user interface would be array of perf events fds and prog fd
>
> also I think you can have just one probe for function, so we will not need
> to share kprobes for multiple users like we need for trampolines, so the
> attach logic will be simple

creating thousands of perf_event FDs seems expensive (and you'll be
running into the limit of open files pretty soon in a lot of systems).
So I think for multi-attach we'll have to have a separate way where
you'd specify kernel function name (and maybe also offset). I'm just
saying that having BPF_LINK_CREATE command, it's easier (probably) to
extend this for kprobe multi-attach, than trying to retrofit this into
perf_event_open.

>
> jirka
>
> >
> > >
> > > thanks,
> > > jirka
> > >
> > > >
> > > >
> > > > >
> > > > > thanks,
> > > > > jirka
> > > > >
> > > >
> > >
> >
>
