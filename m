Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD0423306
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 23:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhJEVtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 17:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhJEVti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 17:49:38 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC21C06174E
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 14:47:47 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so2973978pjb.2
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 14:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/etc7QxniQYv7eDuU6uUoYhn3U/dXvnFGVTlbzcgoc4=;
        b=j/VmuLRl3apJ4GW7p+t9nfV+YHepaSXzOtJ4tdS+B9Uq6F2wU/99wF58qVQlTi0EKk
         0p4K89fydqnmFQ8AsQ3KCdr/sbbVPTQvUkpdOU331FrUhgYnWs+Y+aqhwYNNeL292N9w
         WrWDaRJp9Lb2hd2tSPtjsqnsG/aSZ8poYGriqUPVlGrQ5lauJU81oAkYa0y+W6rB/27q
         fxRqi41YK3kVgzZyMYqQkK3qWU7dVcKFKZ2LYOmLOiEYjoI7fFtvhUw7TBrYmEwVgnzt
         pFHlAZvkEMEjgwQ/e8HEIf4PcNAQZsNMdMpp9F3dg0u0mjSy3U2OBNBsXAYKq8BZeWBA
         JdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/etc7QxniQYv7eDuU6uUoYhn3U/dXvnFGVTlbzcgoc4=;
        b=Gj8+cqbSFkVP6/+iUs8wsExQbnkwiqhmk/yVATldGrAtOfxHL2/HBT5i5N+9++iJkx
         R94LZq6MoPLr6YJVXZqZDXnTTJZUBLgWRelGXFzij81drECrEe4es+WXEFGC5ro7zN9K
         UbvQh0DEX7/ASJqwk59kGxQMzQbeSNO8+OfDFKkaDQotmSaU7FIUaMWettpASTrCQlki
         pKyDtt/2rwRCTPt2sO5tdeqn0OwkJgL8/Te1gtheXkKPxbT9uSbTGmoEzpLdVGNnB5gQ
         CT37waNb6pTzvKXNnopisO01c4DXWUvbvHIgAyrL1mOaqHIT0abTm+BEgoxFo8cwRQ8c
         wZSw==
X-Gm-Message-State: AOAM533EIq1Xs7Eu8vdEkwdDw6AxXIbvdz/baE2A8bxZWGhxEDklxBgQ
        TkSyYqwOA4FvhN3dgxwQJfvwRoMVZRlC10xfvtH/Cw==
X-Google-Smtp-Source: ABdhPJzFFMQ4ylyxJyeZ9wnoMN9Jr2qifxim0wdXZA0QnewMj+3msBKPQotwNLCpBNu3GMgVx4KBvPAdo1zgQ1sXkcA=
X-Received: by 2002:a17:90a:c982:: with SMTP id w2mr6498747pjt.30.1633470466459;
 Tue, 05 Oct 2021 14:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com> <20211005051306.4zbdqo3rnecj3hyv@ast-mbp>
In-Reply-To: <20211005051306.4zbdqo3rnecj3hyv@ast-mbp>
From:   Joe Burton <jevburton@google.com>
Date:   Tue, 5 Oct 2021 14:47:34 -0700
Message-ID: <CAL0ypaB3=cPnCGdwfEHhSLf8zh_mMJ=mL5T_3EfTsPFbNuLSAA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Introduce BPF map tracing capability
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It's a neat idea to user verifier powers for this job,
> but I wonder why simple tracepoint in map ops was not used instead?

My concern with tracepoints is that they execute for all map updates,
not for a particular map. Ideally performing an upgrade of program X
should not affect the performance characteristics of program Y.

If n programs are opted into this model, then upgrading any of them
affects the performance characteristics of every other. There's also
the (very remote) possibility of multiple simultaneous upgrades tracing
map updates at the same time, causing a greater performance hit.

> I don't think the "solution" for lookup operation is worth pursuing.
> The bpf prog that needs this map tracing is completely in your control.
> So just don't do writes after lookup.

I eventually want to support apps that use local storage. Those APIs
generally only allow updates via a pointer. E.g. bpf_sk_storage_get()
only allows updates via the returned pointer and via
bpf_sk_storage_delete().

Since I eventually have to solve this problem to handle local storage,
then it seems worth solving it for normal maps as well. They seem
like isomorphic problems.

On Mon, Oct 4, 2021 at 10:13 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 29, 2021 at 11:58:57PM +0000, Joe Burton wrote:
> > From: Joe Burton <jevburton@google.com>
> >
> > This patch introduces 'map tracing': the capability to execute a
> > tracing program after updating a map.
> >
> > Map tracing enables upgrades of stateful programs with fewer race
> > conditions than otherwise possible. We use a tracing program to
> > imbue a map with copy-on-write semantics, then use an iterator to
> > perform a bulk copy of data in the map. After bulk copying concludes,
> > updates to that map automatically propagate via the tracing
> > program, avoiding a class of race conditions. This use case is
> > demonstrated in the new 'real_world_example' selftest.
> >
> > Extend BPF_PROG_TYPE_TRACING with a new attach type, BPF_TRACE_MAP,
> > and allow linking these programs to arbitrary maps.
> >
> > Extend the verifier to invoke helper calls directly after
> > bpf_map_update_elem() and bpf_map_delete_elem(). The helpers have the
> > exact same signature as the functions they trace, and simply pass those
> > arguments to the list of tracing programs attached to the map.
>
> It's a neat idea to user verifier powers for this job,
> but I wonder why simple tracepoint in map ops was not used instead?
> With BTF the bpf progs see the actual types of raw tracepoints.
> If tracepoint has map, key, value pointers the prog will be able
> to access them in read-only mode.
> Such map pointer will be PTR_TO_BTF_ID, so the prog won't be able
> to recursively do lookup/update on this map pointer,
> but that's what you need anyway, right?
> If not we can extend this part of the tracepoint/verifier.
>
> Instead of tracepoint it could have been an empty noinline function
> and fentry/fexit would see all arguments as well.
>
> > One open question is how to handle pointer-based map updates. For
> > example:
> >   int *x = bpf_map_lookup_elem(...);
> >   if (...) *x++;
> >   if (...) *x--;
> > We can't just call a helper function right after the
> > bpf_map_lookup_elem(), since the updates occur later on. We also can't
> > determine where the last modification to the pointer occurs, due to
> > branch instructions. I would therefore consider a pattern where we
> > 'flush' pointers at the end of a BPF program:
> >   int *x = bpf_map_lookup_elem(...);
> >   ...
> >   /* Execute tracing programs for this cell in this map. */
> >   bpf_map_trace_pointer_update(x);
> >   return 0;
> > We can't necessarily do this in the verifier, since 'x' may no
> > longer be in a register or on the stack. Thus we might introduce a
> > helper to save pointers that should be flushed, then flush all
> > registered pointers at every exit point:
> >   int *x = bpf_map_lookup_elem(...);
> >   /*
> >    * Saves 'x' somewhere in kernel memory. Does nothing if no
> >    * corresponding tracing progs are attached to the map.
> >    */
> >   bpf_map_trace_register_pointer(x);
> >   ...
> >   /* flush all registered pointers */
> >   bpf_map_trace_pointer_update();
> >   return 0;
> > This should be easy to implement in the verifier.
>
> I don't think the "solution" for lookup operation is worth pursuing.
> The bpf prog that needs this map tracing is completely in your control.
> So just don't do writes after lookup.
>
> > In addition, we use the verifier to instrument certain map update
> > calls. This requires saving arguments onto the stack, which means that
> > a program using MAX_BPF_STACK bytes of stack could exceed the limit.
> > I don't know whether this actually causes any problems.
>
> Extra 8*4 bytes of stack is not a deal breaker.
