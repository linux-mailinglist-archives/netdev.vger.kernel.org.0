Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C66424D76
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 08:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240220AbhJGG5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 02:57:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57006 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240203AbhJGG5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 02:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633589719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ohI65JdSUSq/+FkxLvHiDlNvOVQLBfq7YkB63w+27PY=;
        b=S2UdPEanNx2jA2haH5fL3bZefcqakmKXT9dl8P1Y0fChzbjZYFNCxJMt0ZQ/FNKORoROAi
        CqF7lyFSaZ9BFdx84pLQr224J+BkJVN1q9HVxwypM/R9Ly/xU8/jwurIXxAfUTz4jetg9j
        kdaRf5a2z1M6PBtJ8RDiSaf53QY+rxU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-QTPjiRMDNzaY-M11tlGr_Q-1; Thu, 07 Oct 2021 02:55:18 -0400
X-MC-Unique: QTPjiRMDNzaY-M11tlGr_Q-1
Received: by mail-wr1-f71.google.com with SMTP id 41-20020adf812c000000b00160dfbfe1a2so199089wrm.3
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 23:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ohI65JdSUSq/+FkxLvHiDlNvOVQLBfq7YkB63w+27PY=;
        b=sf/5gBbp+TYeyhOp1ct4eSlPW/qSAh087ZCuOskIoVKZlknCwIQQwOgFXeykugZftC
         jjy8KjXZh4rU0SO/Vpv/nVsLJj6XLn5+iaol9ShgpSruj5619Yj9xbmU6mwP+DoHlD6k
         uC4+fi3LbaEnoOdpN87+1D+v+xAz26XhwrWTdtekw/MigEks6pNWojxMTF72EId6Dw5f
         ZklUUC9vGdZghBs6GZ9urhimaYsd6xOoEYdh/t651JoM+hFsp7gILNKbtI+P4drT46zJ
         nBMIaQOWJs+cjiR6QAsgjmIFeKRZ0OY25Yy6aQMI0g+PUlma96ih7KiL6Dl+C1pd9wnG
         FqVA==
X-Gm-Message-State: AOAM5313QsCKU1/pUxLM+TvtUDk1VhnMPUMtqwew2owC0O+3w2k4sLtg
        L60T9ktHjchaPfcBLEcYIgy6XpQ423qm9N4gdZwnoaIrQtMB2BMdn4YlAu0A2MNQava1RP9bfEX
        tGLUV/YVGxlyUQWsp
X-Received: by 2002:adf:bc42:: with SMTP id a2mr3233664wrh.4.1633589717326;
        Wed, 06 Oct 2021 23:55:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5a6w4xr73nat5ZurZs/SiSonJ8Oe7P3NpMb3m2k5K8Pdj8CPKOWZcTp+n/GAecCz+b7YeJg==
X-Received: by 2002:adf:bc42:: with SMTP id a2mr3233642wrh.4.1633589717134;
        Wed, 06 Oct 2021 23:55:17 -0700 (PDT)
Received: from krava (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id b190sm1353711wmd.25.2021.10.06.23.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 23:55:16 -0700 (PDT)
Date:   Thu, 7 Oct 2021 08:55:14 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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
Subject: Re: [RFC] store function address in BTF
Message-ID: <YV6Z0jcB8jdsG4Ly@krava>
References: <YV1hRboJopUBLm3H@krava>
 <CAEf4BzZPH6WQTYaUTpWBw1gW=cNUtPYPnN8OySgXtbQLzZLhEQ@mail.gmail.com>
 <YV4Bx7705mgWzhTd@krava>
 <CAEf4BzbirA4F_kW-sVrS_YmfUxhAjYVDwO1BvtzTYyngqHLkiw@mail.gmail.com>
 <YV4dmkXO6nkB2DeV@krava>
 <CAEf4BzYBS8+9XADjJdvKB=_6tf8_t19UVGfm2Lk1+Nb6qWk5cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYBS8+9XADjJdvKB=_6tf8_t19UVGfm2Lk1+Nb6qWk5cw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 03:37:16PM -0700, Andrii Nakryiko wrote:
> On Wed, Oct 6, 2021 at 3:05 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Oct 06, 2021 at 02:22:28PM -0700, Andrii Nakryiko wrote:
> > > On Wed, Oct 6, 2021 at 1:06 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Wed, Oct 06, 2021 at 09:17:39AM -0700, Andrii Nakryiko wrote:
> > > > > On Wed, Oct 6, 2021 at 1:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > >
> > > > > > hi,
> > > > > > I'm hitting performance issue and soft lock ups with the new version
> > > > > > of the patchset and the reason seems to be kallsyms lookup that we
> > > > > > need to do for each btf id we want to attach
> > > > > >
> > > > > > I tried to change kallsyms_lookup_name linear search into rbtree search,
> > > > > > but it has its own pitfalls like duplicate function names and it still
> > > > > > seems not to be fast enough when you want to attach like 30k functions
> > > > >
> > > > > How not fast enough is it exactly? How long does it take?
> > > >
> > > > 30k functions takes 75 seconds for me, it's loop calling bpf_check_attach_target
> > > >
> > > > getting soft lock up messages:
> > > >
> > > > krava33 login: [  168.896671] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [bpftrace:1087]
> > > >
> > >
> > > That's without RB tree right? I was curious about the case of you
> > > converting kallsyms to RB tree and it still being slow. Can't imagine
> > > 30k queries against RB tree with ~160k kallsyms taking 75 seconds.
> >
> > yep, that's the standard kallsyms lookup api
> >
> > I need to make some adjustment for rbtree kalsyms code, I think I found
> > a bug in there, so the numbers are probably better as you suggest
> 
> ok, cool, let's see what are the new numbers then
> 
> >
> > >
> > > But as I said, why not map BTF IDs into function names, sort function
> > > names, and then pass over kallsyms once, doing binary search into a
> > > sorted array of requested function names and then recording addr for
> > > each. Then check that you found addresses for all functions (it also
> > > leaves a question of what to do when we have multiple matching
> > > functions, but it's a problem with any approach). If everything checks
> > > out, you have a nice btf id -> func name -> func addr mapping. It's
> > > O(N log(M)), which sounds like it shouldn't be slow. Definitely not
> > > multiple seconds slow.
> >
> > ok, now that's clear to me, thanks for these details
> 
> great
> 
> >
> > >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > so I wonder we could 'fix this' by storing function address in BTF,
> > > > > > which would cut kallsyms lookup completely, because it'd be done in
> > > > > > compile time
> > > > > >
> > > > > > my first thought was to add extra BTF section for that, after discussion
> > > > > > with Arnaldo perhaps we could be able to store extra 8 bytes after
> > > > > > BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
> > > > > > indicate that? or new BTF_KIND_FUNC2 type?
> > > > > >
> > > > > > thoughts?
> > > > >
> > > > > I'm strongly against this, because (besides the BTF bloat reason) we
> > > > > need similar mass attachment functionality for kprobe/kretprobe and
> > > > > that one won't be relying on BTF FUNCs, so I think it's better to
> > > > > stick to the same mechanism for figuring out the address of the
> > > > > function.
> > > >
> > > > ok
> > > >
> > > > >
> > > > > If RB tree is not feasible, we can do a linear search over unsorted
> > > > > kallsyms and do binary search over sorted function names (derived from
> > > > > BTF IDs). That would be O(Nlog(M)), where N is number of ksyms, M is
> > > > > number of BTF IDs/functions-to-be-attached-to. If we did have an RB
> > > > > tree for kallsyms (is it hard to support duplicates? why?) it could be
> > > > > even faster O(Mlog(N)).
> > > >
> > > > I had issues with generic kallsyms rbtree in the post some time ago,
> > > > I'll revisit it to check on details.. but having the tree with just
> > > > btf id functions might clear that.. I'll check
> > >
> > > That's not what I'm proposing. See above. Please let me know if
> > > something is not clear before going all in for RB tree implementation
> > > :)
> > >
> > >
> > > But while we are on topic, do you think (with ftrace changes you are
> > > doing) it would be hard to support multi-attach for
> > > kprobes/kretprobes? We now have bpf_link interface for attaching
> > > kprobes, so API can be pretty aligned with fentry/fexit, except
> > > instead of btf IDs we'd need to pass array of pointers of C strings, I
> > > suppose.
> >
> > hum, I think kprobe/kretprobe is made of perf event (kprobe/kretprobe
> > pmus), then you pass event fd and program fd to bpf link syscall,
> > and it attaches bpf program to that perf event
> >
> > so perhaps the user interface would be array of perf events fds and prog fd
> >
> > also I think you can have just one probe for function, so we will not need
> > to share kprobes for multiple users like we need for trampolines, so the
> > attach logic will be simple
> 
> creating thousands of perf_event FDs seems expensive (and you'll be
> running into the limit of open files pretty soon in a lot of systems).
> So I think for multi-attach we'll have to have a separate way where
> you'd specify kernel function name (and maybe also offset). I'm just
> saying that having BPF_LINK_CREATE command, it's easier (probably) to
> extend this for kprobe multi-attach, than trying to retrofit this into
> perf_event_open.

ah true.. I wonder we could bypass perf by using directly kernel
kprobe interface

jirka

