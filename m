Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621DC4248D3
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 23:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbhJFVYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 17:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239680AbhJFVYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 17:24:33 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7AC3C061746;
        Wed,  6 Oct 2021 14:22:40 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id s64so8506896yba.11;
        Wed, 06 Oct 2021 14:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ERup2P4X4JlFTklCDnCypaXBLC87khSfCsez0CZaAIY=;
        b=Wu3VJVh54ROFXtTvqiHW8xjaaxfNIA4uCAZaBbIdcIRnlV2Kj75IHFb7//m/PF+ejV
         3iJf+Dg/0UMnqxLRIt9e50PcFbNov62lynM7HP52/0f3JUZgcVOwhu4sq5RkfjVfJsga
         ur63zrMa46Sa4Q5xl45/6K3ugebCQFwGGwhrYjtVo4tDg8WyAja6KL95tfVEgt/73d9k
         dkAu3dSifrt3co4i5rnujJ1ypDDwltkEpyf5JZsAMl7dxI2wk3WNn3OpDQntOCd7Nn92
         Mqm0lIv1IvP8Wy8w9iORjOEhpcz4eYGW/0lZKce+Iwvo5eOp0Qz0tgScYzP2TmfJW1Al
         HBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERup2P4X4JlFTklCDnCypaXBLC87khSfCsez0CZaAIY=;
        b=FCNuAvNgc/NwhjiTzxg0o3WGucWM0ceoOVhNqiOyLbKQAsUyTZ4oV0gc6W3Be0T8B9
         L1RldBq+zDQhnoUvBMbBBxyIT1Hkk3hoqK/2wtePOGwjjTNA4moVT+iSbBrGuXgJwH3X
         4P6qtX3lhKvAvw0mP06Sq8FQTuDBakKKXrZaVd3gOPsbUc453A7mChs31OfddbMSOfqL
         ZygTejvUu9LR3O0n6img6U5XUV6Bw8OLk61Z1T2XKNLOA519OcLn6GlaJbsgKoDca2/L
         380mSt0YwlzWh126JuA2+wpruxsOCXqT0xArQmOSZhub/J02/vrOtc5HHGqnmR74loM3
         n8LQ==
X-Gm-Message-State: AOAM530TxjiwH7I9zinnRTDAtx5J5EA/O5qFIP7K5FecH/BcxQfUOuOj
        d7mNfxIXpalNLCeDnBLogQ3ro1a9bD0pFclZaes=
X-Google-Smtp-Source: ABdhPJxFzFfaWEnyMyQJph4fhg+XpN3eSQvP3xPWJFC+4HZ3wVwNbTJ2EZeknjsx5pCpOrz19JOrR34BMwg8wJBbn94=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr448250ybj.433.1633555359987;
 Wed, 06 Oct 2021 14:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <YV1hRboJopUBLm3H@krava> <CAEf4BzZPH6WQTYaUTpWBw1gW=cNUtPYPnN8OySgXtbQLzZLhEQ@mail.gmail.com>
 <YV4Bx7705mgWzhTd@krava>
In-Reply-To: <YV4Bx7705mgWzhTd@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 14:22:28 -0700
Message-ID: <CAEf4BzbirA4F_kW-sVrS_YmfUxhAjYVDwO1BvtzTYyngqHLkiw@mail.gmail.com>
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

On Wed, Oct 6, 2021 at 1:06 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Oct 06, 2021 at 09:17:39AM -0700, Andrii Nakryiko wrote:
> > On Wed, Oct 6, 2021 at 1:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > hi,
> > > I'm hitting performance issue and soft lock ups with the new version
> > > of the patchset and the reason seems to be kallsyms lookup that we
> > > need to do for each btf id we want to attach
> > >
> > > I tried to change kallsyms_lookup_name linear search into rbtree search,
> > > but it has its own pitfalls like duplicate function names and it still
> > > seems not to be fast enough when you want to attach like 30k functions
> >
> > How not fast enough is it exactly? How long does it take?
>
> 30k functions takes 75 seconds for me, it's loop calling bpf_check_attach_target
>
> getting soft lock up messages:
>
> krava33 login: [  168.896671] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [bpftrace:1087]
>

That's without RB tree right? I was curious about the case of you
converting kallsyms to RB tree and it still being slow. Can't imagine
30k queries against RB tree with ~160k kallsyms taking 75 seconds.

But as I said, why not map BTF IDs into function names, sort function
names, and then pass over kallsyms once, doing binary search into a
sorted array of requested function names and then recording addr for
each. Then check that you found addresses for all functions (it also
leaves a question of what to do when we have multiple matching
functions, but it's a problem with any approach). If everything checks
out, you have a nice btf id -> func name -> func addr mapping. It's
O(N log(M)), which sounds like it shouldn't be slow. Definitely not
multiple seconds slow.


>
> >
> > >
> > > so I wonder we could 'fix this' by storing function address in BTF,
> > > which would cut kallsyms lookup completely, because it'd be done in
> > > compile time
> > >
> > > my first thought was to add extra BTF section for that, after discussion
> > > with Arnaldo perhaps we could be able to store extra 8 bytes after
> > > BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
> > > indicate that? or new BTF_KIND_FUNC2 type?
> > >
> > > thoughts?
> >
> > I'm strongly against this, because (besides the BTF bloat reason) we
> > need similar mass attachment functionality for kprobe/kretprobe and
> > that one won't be relying on BTF FUNCs, so I think it's better to
> > stick to the same mechanism for figuring out the address of the
> > function.
>
> ok
>
> >
> > If RB tree is not feasible, we can do a linear search over unsorted
> > kallsyms and do binary search over sorted function names (derived from
> > BTF IDs). That would be O(Nlog(M)), where N is number of ksyms, M is
> > number of BTF IDs/functions-to-be-attached-to. If we did have an RB
> > tree for kallsyms (is it hard to support duplicates? why?) it could be
> > even faster O(Mlog(N)).
>
> I had issues with generic kallsyms rbtree in the post some time ago,
> I'll revisit it to check on details.. but having the tree with just
> btf id functions might clear that.. I'll check

That's not what I'm proposing. See above. Please let me know if
something is not clear before going all in for RB tree implementation
:)


But while we are on topic, do you think (with ftrace changes you are
doing) it would be hard to support multi-attach for
kprobes/kretprobes? We now have bpf_link interface for attaching
kprobes, so API can be pretty aligned with fentry/fexit, except
instead of btf IDs we'd need to pass array of pointers of C strings, I
suppose.

>
> thanks,
> jirka
>
> >
> >
> > >
> > > thanks,
> > > jirka
> > >
> >
>
