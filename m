Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F923424977
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbhJFWHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:07:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhJFWHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:07:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633557918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WIclh3AdLfVYAiQkIwrJSiR618YUkbU+lYFgoUPsNwE=;
        b=B4YudEVCwmVWt00kVnvNAcdjA0E30XXjeXKDONFY2wxXqams+BxkPTXE6bpikG/n/Q2jA8
        KthIa4GPjsk+v2wU3n0aW7SNWw8tCsh4c3rMvY2dN+z8EQHSrlxEzLx6RqX5cpoBsEk3CL
        OG71cLIFGsi9nFFFhz5rBUiSwVmFGXk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-4RF6okW1Mo2wnVvK-Pg7dg-1; Wed, 06 Oct 2021 18:05:17 -0400
X-MC-Unique: 4RF6okW1Mo2wnVvK-Pg7dg-1
Received: by mail-wr1-f70.google.com with SMTP id d13-20020adfa34d000000b00160aa1cc5f1so3091805wrb.14
        for <netdev@vger.kernel.org>; Wed, 06 Oct 2021 15:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WIclh3AdLfVYAiQkIwrJSiR618YUkbU+lYFgoUPsNwE=;
        b=IFvdKHuOA1bwHyEEO5Xqv6NRzsAqBB5Mop83IWT8KH2a93iP+u1wLsbIoCBoa2lhpt
         0PAYEes5YdbU+zJ1v8Z68araB4QxMmGUrdmH1Tl9Jm9U7vktBnpzIek0eyXLaKpHEnsm
         v2alqQjDoeIpAfSJWA+2cfhaVfl5bXAD5+8KcqkR5oxFfCyvOMGEdHkQ4y3r23lj0wNc
         3F/9T27rI0Pa+z3ZA0giRdoSbO+3A3kG9if2v0TKDvrk9Rz3tP4G1gxo+BScu6AuFweL
         W8WYVk9C+73hRZmjjRNE3BgNp5wGd2jutyK4Kg91Jfuw06hVRxTLtwTJ3RaPsBPfv56R
         oyCA==
X-Gm-Message-State: AOAM530tbQD+hi/goMtlORJiVJWTEI73Ni14OFFDXAqGXv29DdcljpYd
        yGKZW3/ffoogRqDCXtvWgMHfIzNOtgKMpTaaUlPp6eWF8+bBteycmg0thhdfboWGGA/kRwllryT
        wv/Dk0HBhZk8CPoJ+
X-Received: by 2002:adf:b7c1:: with SMTP id t1mr687994wre.387.1633557916603;
        Wed, 06 Oct 2021 15:05:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRTA68peCg8NEEERGtCSLZCyWO84r+k/Kvv8uWPQpdDnts+ZtGWzwc43c2i45LBMnvVeWplA==
X-Received: by 2002:adf:b7c1:: with SMTP id t1mr687965wre.387.1633557916339;
        Wed, 06 Oct 2021 15:05:16 -0700 (PDT)
Received: from krava ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id i6sm12105401wrv.61.2021.10.06.15.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:05:16 -0700 (PDT)
Date:   Thu, 7 Oct 2021 00:05:14 +0200
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
Message-ID: <YV4dmkXO6nkB2DeV@krava>
References: <YV1hRboJopUBLm3H@krava>
 <CAEf4BzZPH6WQTYaUTpWBw1gW=cNUtPYPnN8OySgXtbQLzZLhEQ@mail.gmail.com>
 <YV4Bx7705mgWzhTd@krava>
 <CAEf4BzbirA4F_kW-sVrS_YmfUxhAjYVDwO1BvtzTYyngqHLkiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbirA4F_kW-sVrS_YmfUxhAjYVDwO1BvtzTYyngqHLkiw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 02:22:28PM -0700, Andrii Nakryiko wrote:
> On Wed, Oct 6, 2021 at 1:06 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, Oct 06, 2021 at 09:17:39AM -0700, Andrii Nakryiko wrote:
> > > On Wed, Oct 6, 2021 at 1:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > hi,
> > > > I'm hitting performance issue and soft lock ups with the new version
> > > > of the patchset and the reason seems to be kallsyms lookup that we
> > > > need to do for each btf id we want to attach
> > > >
> > > > I tried to change kallsyms_lookup_name linear search into rbtree search,
> > > > but it has its own pitfalls like duplicate function names and it still
> > > > seems not to be fast enough when you want to attach like 30k functions
> > >
> > > How not fast enough is it exactly? How long does it take?
> >
> > 30k functions takes 75 seconds for me, it's loop calling bpf_check_attach_target
> >
> > getting soft lock up messages:
> >
> > krava33 login: [  168.896671] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [bpftrace:1087]
> >
> 
> That's without RB tree right? I was curious about the case of you
> converting kallsyms to RB tree and it still being slow. Can't imagine
> 30k queries against RB tree with ~160k kallsyms taking 75 seconds.

yep, that's the standard kallsyms lookup api

I need to make some adjustment for rbtree kalsyms code, I think I found
a bug in there, so the numbers are probably better as you suggest

> 
> But as I said, why not map BTF IDs into function names, sort function
> names, and then pass over kallsyms once, doing binary search into a
> sorted array of requested function names and then recording addr for
> each. Then check that you found addresses for all functions (it also
> leaves a question of what to do when we have multiple matching
> functions, but it's a problem with any approach). If everything checks
> out, you have a nice btf id -> func name -> func addr mapping. It's
> O(N log(M)), which sounds like it shouldn't be slow. Definitely not
> multiple seconds slow.

ok, now that's clear to me, thanks for these details

> 
> 
> >
> > >
> > > >
> > > > so I wonder we could 'fix this' by storing function address in BTF,
> > > > which would cut kallsyms lookup completely, because it'd be done in
> > > > compile time
> > > >
> > > > my first thought was to add extra BTF section for that, after discussion
> > > > with Arnaldo perhaps we could be able to store extra 8 bytes after
> > > > BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
> > > > indicate that? or new BTF_KIND_FUNC2 type?
> > > >
> > > > thoughts?
> > >
> > > I'm strongly against this, because (besides the BTF bloat reason) we
> > > need similar mass attachment functionality for kprobe/kretprobe and
> > > that one won't be relying on BTF FUNCs, so I think it's better to
> > > stick to the same mechanism for figuring out the address of the
> > > function.
> >
> > ok
> >
> > >
> > > If RB tree is not feasible, we can do a linear search over unsorted
> > > kallsyms and do binary search over sorted function names (derived from
> > > BTF IDs). That would be O(Nlog(M)), where N is number of ksyms, M is
> > > number of BTF IDs/functions-to-be-attached-to. If we did have an RB
> > > tree for kallsyms (is it hard to support duplicates? why?) it could be
> > > even faster O(Mlog(N)).
> >
> > I had issues with generic kallsyms rbtree in the post some time ago,
> > I'll revisit it to check on details.. but having the tree with just
> > btf id functions might clear that.. I'll check
> 
> That's not what I'm proposing. See above. Please let me know if
> something is not clear before going all in for RB tree implementation
> :)
> 
> 
> But while we are on topic, do you think (with ftrace changes you are
> doing) it would be hard to support multi-attach for
> kprobes/kretprobes? We now have bpf_link interface for attaching
> kprobes, so API can be pretty aligned with fentry/fexit, except
> instead of btf IDs we'd need to pass array of pointers of C strings, I
> suppose.

hum, I think kprobe/kretprobe is made of perf event (kprobe/kretprobe
pmus), then you pass event fd and program fd to bpf link syscall,
and it attaches bpf program to that perf event

so perhaps the user interface would be array of perf events fds and prog fd

also I think you can have just one probe for function, so we will not need
to share kprobes for multiple users like we need for trampolines, so the
attach logic will be simple

jirka

> 
> >
> > thanks,
> > jirka
> >
> > >
> > >
> > > >
> > > > thanks,
> > > > jirka
> > > >
> > >
> >
> 

