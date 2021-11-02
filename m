Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07E8443464
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhKBRPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhKBRPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 13:15:15 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF423C061714;
        Tue,  2 Nov 2021 10:12:40 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id d10so92126ybe.3;
        Tue, 02 Nov 2021 10:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Xq8AsbqsOaKjIvdptZcSBgPskzpXvIr/+0PC7RddRQ=;
        b=JvvgQO1mCugdERhCmkPEpFqXivjcP0yzyis/FJpVOVFuuP0VkLrYufzhq9rg4SQPK/
         g2eUIDXY/3OpGzp+Ua+NQJshEubSUybkvJOIkeUvCDMZ0i4e6AMyva+NQvAe+R2MHBBe
         qefzALxpGFraymLaW/Ps4I2pwKNDHT5Qgpks1hDkt59+2Nc7rYM77/Y6sLYsE3gmnikK
         0pmCLYVMo7MWbEQ0+wmNE8DORNsfSBoXo+g1a+ySvD+5blleH4mIDKrEeku2HaoUhPkT
         BoJ0PUgSuaynlVN6/j3/SfiNzZRzzPfY93npB0h69jq0f91O8xVWMzWnFHXZdYy5Qb1l
         RLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Xq8AsbqsOaKjIvdptZcSBgPskzpXvIr/+0PC7RddRQ=;
        b=XAdjuBYnoH0GG7JubRj8Utoch1SCqrHqnk49S7e/o8cggR8CsjExyOF21mwQHPeut6
         rQ7b5vzpoZGXpoFhgw1NToTe4cuB6XRRx7aU51luVrFnYA+S4h4VHHPIBIzdyiuE/4jR
         MVPIgPh8REb9oN+S6sT2RWif7pTFHjMCQduWbl0pcf/OGbuf+7YVE95x9k7208hH0HJY
         qTQUb1muRopfAi619XDY83TodFSlXE7m9ZHnIobbYSVL7DE15oA04SPmtTIQXY6pfE6x
         NaIVxJ6JdKd2YA2wEmrCfTV1JtFCq3WnAB0hC3bgKT1R9+qVkLV8vkYISk3Jq7GWIAnS
         fl+A==
X-Gm-Message-State: AOAM532Xng+618plQqoUEh1yE8OdU4aBgY1kwwpOI4NwqjgnsANT7NQP
        zx2zrn/FZKxnIUnmRbPRPc/YPZc85r4eU1k+mVdUjo58jhE=
X-Google-Smtp-Source: ABdhPJyk1SaGKzxC/FcfFZLffU9qDryj0vPPnBkPElVPp7ZDgPYhX1gJpsCMoOrh5SFCCOVFor9iZYbg4D+9hoxZK5w=
X-Received: by 2002:a05:6902:1023:: with SMTP id x3mr10873607ybt.267.1635873159908;
 Tue, 02 Nov 2021 10:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
 <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com>
 <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com> <CAMy00i1NZk-33fZxMq_iLpkcgL+oNNm0hqoX-u_n6OpnWxWhww@mail.gmail.com>
In-Reply-To: <CAMy00i1NZk-33fZxMq_iLpkcgL+oNNm0hqoX-u_n6OpnWxWhww@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Nov 2021 10:12:28 -0700
Message-ID: <CAEf4Bza6eqYLKS3GCpO3t2XRneCkZEOEkNFL1U9wBdBT+ZBm1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     Leonardo Di Donato <leodidonato@gmail.com>
Cc:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        leonardo.didonato@elastic.co
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 3:59 AM Leonardo Di Donato <leodidonato@gmail.com> wrote:
>
> On Tue, Nov 2, 2021 at 6:55 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > No, now that I understand what exactly you are doing, it won't work.
> >
> > But ok, I gave it quite a bit of thought and tried to find a good
> > compromise between completely exposing all the libbpf internals as
> > public APIs (which is a huge price I'm not willing to accept) and
> > actually allowing you to achieve your goal (which I think is worthy to
> > achieve).
> >
> > But first. https://github.com/aquasecurity/btfhub/tree/main/tools is
> > awesome. Great work explaining a lot at exactly the right level of
> > technical details. It would be great if you published it as a
> > dedicated blog post, maybe splitting the more general information from
> > the BTF minimization problem. Both are useful, but it's too long for
> > one article. Great job, really!
> >
> > Now, to the problem at hand. And sorry for a long reply, but there is
> > quite a bit of things to unpack.
> >
> > I see this overall problem as two distinct problems:
> >   1. Knowing which fields and types libbpf is using from kernel BTF.
> > Basically, observe CO-RE logic from outside.
> >   2. Knowing information from #1, minimize BTF.
> >
> > Part #2 absolutely doesn't belong in libbpf. Libbpf exposes enough BTF
> > constructing APIs to implement this in any application, bpftool or
> > otherwise. It's also a relatively straightforward problem: mark used
> > types and fields, create a copy of BTF with only those types and
> > fields.
> >
> > So let's talk about #1, because I agree that it's extremely painful to
> > have to reimplement most of CO-RE logic just for getting the list of
> > types and fields. Here we have two sub-problems (assuming we let
> > libbpf do CO-RE relocation logic for us):
> >   a) perform CO-RE relocations but don't create BPF maps and load BPF
> > programs. Dry-run of sorts.
> >   b) exposing calculated relocation information.
> >
> > First, 1a. The problem right now is that CO-RE relocations (and
> > relocations in general) happen in the same bpf_object__load() phase
> > and it's not possible to do them without creating maps and
> > subsequently loading BPF programs first. This is very suboptimal. I've
> > actually been thinking in the background how to improve that
> > situation, because even with the recent bpf_program__insns() API,
> > added a few days ago, you still have to load the BPF program to be
> > able to clone the BPF program, and so I wanted to solve that for a
> > long while now.
> >
> > So how about we split bpf_object__load() phase into two:
> > bpf_object__prepare() and bpf_object__load(). prepare() will do all
> > the preparations (subprogs, ELF relos, also almost complete BPF map
> > relos, but not quite; I'll get to this), basically everything that
> > load does today short of actually creating maps and progs. load() then
> > will ensure that bpf_object__prepare() was called (i.e., user can do
> > just prepare(), prepare() + load() explicitly, or load() which will
> > call prepare() implicitly).
> >
> > The biggest problem I see right now is what we do about BPF map
> > relocations. I propose to perform map relocations but substitute map's
> > internal index (so that if someone dumps prog instructions after
> > prepare(), it's still meaningful, even if not yet validatable by
> > verifier). After maps are actually created, we can do another quick
> > pass over just RELO_DATA and replace map_idx with map's fd.
> >
> > It feels like we should split load further into two steps: creating
> > and pinning maps (+ finalizing FDs in instructions) and actually
> > loading programs. Again, with the same implicit calling of prepare and
> > map creation steps if the user only calls bpf_object__load(). For ease
> > of use and backwards compatibility.
> >
> > So basically, the most granular set of steps would be:
> >   1. bpf_object__open()
> >   2. bpf_object__prepare() (or bpf_object__relocate(), naming is hard)
> >   3. bpf_object__create_maps();
> >   4. bpf_object__load().
> >
> > But the old and trusty bpf_object__open() + bpf_object__load() will
> > work just as well, with load() doing steps #2-#4 automatically, if
> > necessary.
> >
> > So what does that split gives us. Few things:
> >   - it's possible to "simulate" almost all libbpf logic without
> > changing the state of the system (no maps or progs created). Yet you
> > still validate that kconfig externs, per-cpu externs, CO-RE relos, map
> > relos, etc, all that works.
> >   - libbpf can store extra information between steps 1, 2, 3, and 4,
> > but after step #4 all that extra information can be discarded and
> > cleaned up. So advanced users will get access to stuff like
> > bpf_program__insns() and CO-RE information, but most users won't have
> > to pay for that because it will be freed after bpf_object__load(). So
> > in this case, bpf_program__insns() could (should?) be discarded after
> > actual load, because if you care about instructions, you can do steps
> > #1-#3, grab instructions and copy them, if necessary. Then proceed to
> > #4 (or not) and free the memory.
> >
> > The last point is important, because to solve the problem 1b (exposing
> > CO-RE relo info), the best way to minimize public API commitments is
> > to (optionally, probably) request libbpf to record its CO-RE relo
> > decisions. Here's what I propose, specifically:
> >   1. Add something like "bool record_core_relo_info" (awful name,
> > don't use it) in bpf_object_open_opts.
> >   2. If it is set to true, libbpf will keep a "log" of CO-RE
> > relocation decisions, recording stuff like program name, instruction
> > index, local spec (i.e., root_type_id, spec string, relo kind, maybe
> > something else), target spec (kernel type_id, kernel spec string, also
> > module ID, if it's not vmlinux BTF). We can also record relocated
> > value (i.e., field offset, actual enum value, true/false for
> > existence, etc). All these are stable concepts, so I'd feel more
> > comfortable exposing them, compared to stuff like bpf_core_accessor
> > and other internal details.
> >   3. The memory for all that will be managed by libbpf for simplicity
> > of an API, and we'll expose accessors to get those arrays (at object
> > level or per-program level is TBD).
> >   4. This info will be available after the prepare() step and will be
> > discarded either at create_maps() or load().
> >
> > I think that solves problem #1 completely (at least for BTFGen case)
> > and actually provides more useful information. E.g., if someone wants
> > to track CO-RE resolution logic for some other reason, they should
> > have pretty full information (BTFGen doesn't need all of that).
> >
> > It also doesn't feel like too much complication to libbpf internals
> > (even though we'll need to be very careful with BPF map relos and
> > double-checking that we haven't missed any other critical part of the
> > process). And for most users there is no change in API or behavior.
> > And given this gives us a "framework" for more sustainable libbpf
> > "observability", I think it's a justified price to pay, overall.
> >
> > I still need to sleep on this, but this feels like a bit cleaner way
> > forward. Thoughts are welcome.
> >
> > >
> > > > If CO-RE matching style is necessary and it's the best approach then please
> > > > add new logic to bpftool. I'm not sure such api would be
> > > > useful beyond this particular case to expose as stable libbpf api.
> > >
> > > I agree 100%. Our goal is to have this available on bpftool so all the
> > > community can use it. However it'd be a shame if we can't use some of
> > > the existing logic in libbpf.
>
> Hello Andrii,
>
> I was experimenting on implementing this during the last few days by
> using the preprocessor mechanism builtin in libbpf.
>
> The bpf_object__load_progs (which happens after bpf_object__relocate)
> calls bpf_object__load_progs, which calls bpf_program__load that, for
> each program instance, calls a bpf_program_prep_t preprocessor. Such a
> callback gets passed in the current program instance, its index, its
> insn, etc.
> The bpf_object__load_progs function gets called just after
> bpf_object__relocate (in bpf_object__load_xattr) which finds relo
> candidates and applies them.
> But I guess you already know all this.
>
> So my idea was to store  the relocation info into the program
> instances, exposing them to the userspace implementation of the
> aforementioned callback.
> At that point, creating a tailored BTF for the program/s would be just
> a matter of implementing the logic for grabbing and saving them to the
> disk.
>
> Would you think this would be feasible? I think this would be a good
> use case for the preprocessor.

This preprocessor API is deprecated and is going to be removed in
libbpf 1.0. See [0].

  [0] https://patchwork.kernel.org/project/netdevbpf/patch/20211025224531.1088894-4-andrii@kernel.org/

>
> L.
