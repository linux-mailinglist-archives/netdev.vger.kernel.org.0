Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31C2444BBB
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 00:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhKCXnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 19:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhKCXnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 19:43:39 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD611C061714;
        Wed,  3 Nov 2021 16:41:02 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id t127so10211667ybf.13;
        Wed, 03 Nov 2021 16:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iSobEc0tLFoBwkHP6wpuX0P36ki0xsRuAYrOL/xunmk=;
        b=Y/0QKojtA+kYcbMNgz7B8NK67vbNO+TEEl7vcjoSO/hlke+eOFlpSaJN2M80O4hU21
         5D9u8FaepiKbn1Usc0a4n0plE4DaDXHGV1TX02yoUJDMbv4YPnfXXhl5z1haxaQ3GOnD
         mpfCECNFijTorqkZTwloRBTAl36OO8UlOKCpE1l4pMYHlFUxApEuuKETM3fwzFnH5onl
         KnpPAXrjl0PdWpY87O/ErVqIcf1FUhCPphwNHwMiwDqZdipCd/f1AJUcKP/oLKjShhNB
         as9vZUpu+cWRjbBdItweyEou6i0UXB+RhC7D3eXsdmjImyRdWV3dMCk5LTBBBreZ++zd
         D8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iSobEc0tLFoBwkHP6wpuX0P36ki0xsRuAYrOL/xunmk=;
        b=Cu5zGHAwn65MXDLmnlKdqV0Zf97M11Y6i8JyUcQTzqP0SkVzSH17lPRNOoDVPbvcx5
         UKBI4JW1SwYlUnawLcrBGRaTmuUlyW0CQPPEIISjeDeYpjqpTT3X8fleaBvb4Br+dQ8L
         T7SkDBbkfGQuXgH0xEtWcVGVzqcixD2oT5dAiEvQ2ePdWivVWHo+FCMuwbXm0ww5njqB
         hgxw41DpkLQgI9dngVQKDEUVjLe/S37JSZUzueeTDxaxpWyiilRxsGFOGebwCfCCV0bU
         r8qkxELEgp6gNBg+ynOhiCQLk6ro+mI3IeShYkTelBl43LVx8ef6TTj1JYmToNh1ImSm
         5qbQ==
X-Gm-Message-State: AOAM5324EwL1r386Ew3CazsJgeiE24SdzX9VMyW0ZpcrCmUCit4CQcXU
        j2EdpGC6LP1TNN4caXus8itSmYI5M0GBJH5JpML6jb6a
X-Google-Smtp-Source: ABdhPJznBhAmLdWt5UAg1k/ZwMCcrSs0IFy0MKUdHziI0BXzKwYFctxjZYQJPOfO+P1hYgPOWVweBTbHM3ZXlJW8sOs=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr48044297ybj.433.1635982861701;
 Wed, 03 Nov 2021 16:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
 <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com> <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com>
In-Reply-To: <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Nov 2021 16:40:49 -0700
Message-ID: <CAEf4BzYYXkzmhzt55hGyRLo68orAQD_1SGaFfdAkaNK-shypqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 10:53 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 29, 2021 at 9:12 AM Mauricio V=C3=A1squez Bernal
> <mauricio@kinvolk.io> wrote:
> >
> > > Tracing progs will be peeking into task_struct.
> > > To describe it in the reduced BTF most of the kernel types would be n=
eeded,
> >
> > That's the point of our algorithm. If a program is only accessing
> > 'pid' on 'task_struct' we'll generate a BTF representation of
> > task_struct that only contains the 'pid' member with the right offset,
> > other members are not included and hence we don't need to carry on all
> > those types that are not used by the program.
> >
> > > Have you considered generating kernel BTF with fields that are access=
ed
> > > by bpf prog only and replacing all other fields with padding ?
> >
> > Yeah. We're implicitly doing it as described above.
> >
> > > I think the algo would be quite different from the actual CO-RE logic
> > > you're trying to reuse.
> >
> > I'm not 100% sure it's so easy to do without reimplementing much of
> > the actual CO-RE logic. We don't want to copy all type members but
> > only the ones actually used. So I'm not sure if Andrii's idea of
> > performing the matching based only on the type name will work. I'll
> > try to get deep into the details and will be back to you soon.
>
> No, now that I understand what exactly you are doing, it won't work.
>
> But ok, I gave it quite a bit of thought and tried to find a good
> compromise between completely exposing all the libbpf internals as
> public APIs (which is a huge price I'm not willing to accept) and
> actually allowing you to achieve your goal (which I think is worthy to
> achieve).
>
> But first. https://github.com/aquasecurity/btfhub/tree/main/tools is
> awesome. Great work explaining a lot at exactly the right level of
> technical details. It would be great if you published it as a
> dedicated blog post, maybe splitting the more general information from
> the BTF minimization problem. Both are useful, but it's too long for
> one article. Great job, really!
>
> Now, to the problem at hand. And sorry for a long reply, but there is
> quite a bit of things to unpack.
>
> I see this overall problem as two distinct problems:
>   1. Knowing which fields and types libbpf is using from kernel BTF.
> Basically, observe CO-RE logic from outside.
>   2. Knowing information from #1, minimize BTF.
>
> Part #2 absolutely doesn't belong in libbpf. Libbpf exposes enough BTF
> constructing APIs to implement this in any application, bpftool or
> otherwise. It's also a relatively straightforward problem: mark used
> types and fields, create a copy of BTF with only those types and
> fields.
>
> So let's talk about #1, because I agree that it's extremely painful to
> have to reimplement most of CO-RE logic just for getting the list of
> types and fields. Here we have two sub-problems (assuming we let
> libbpf do CO-RE relocation logic for us):
>   a) perform CO-RE relocations but don't create BPF maps and load BPF
> programs. Dry-run of sorts.
>   b) exposing calculated relocation information.
>
> First, 1a. The problem right now is that CO-RE relocations (and
> relocations in general) happen in the same bpf_object__load() phase
> and it's not possible to do them without creating maps and
> subsequently loading BPF programs first. This is very suboptimal. I've
> actually been thinking in the background how to improve that
> situation, because even with the recent bpf_program__insns() API,
> added a few days ago, you still have to load the BPF program to be
> able to clone the BPF program, and so I wanted to solve that for a
> long while now.
>
> So how about we split bpf_object__load() phase into two:
> bpf_object__prepare() and bpf_object__load(). prepare() will do all
> the preparations (subprogs, ELF relos, also almost complete BPF map
> relos, but not quite; I'll get to this), basically everything that
> load does today short of actually creating maps and progs. load() then
> will ensure that bpf_object__prepare() was called (i.e., user can do
> just prepare(), prepare() + load() explicitly, or load() which will
> call prepare() implicitly).
>
> The biggest problem I see right now is what we do about BPF map
> relocations. I propose to perform map relocations but substitute map's
> internal index (so that if someone dumps prog instructions after
> prepare(), it's still meaningful, even if not yet validatable by
> verifier). After maps are actually created, we can do another quick
> pass over just RELO_DATA and replace map_idx with map's fd.
>
> It feels like we should split load further into two steps: creating
> and pinning maps (+ finalizing FDs in instructions) and actually
> loading programs. Again, with the same implicit calling of prepare and
> map creation steps if the user only calls bpf_object__load(). For ease
> of use and backwards compatibility.
>
> So basically, the most granular set of steps would be:
>   1. bpf_object__open()
>   2. bpf_object__prepare() (or bpf_object__relocate(), naming is hard)
>   3. bpf_object__create_maps();
>   4. bpf_object__load().

Talking with Alexei and digging through libbpf code some more, it
might be a bit premature for now to split out create_maps(). It just
complicates things and doesn't really add anything to the goal of
observing CO-RE relocation results. So let's keep it under
bpf_object__load() for now.

But that made me think we need a separate bpf_object__prepare() step
at all. And I see two ways to go about it.

First approach is as follows.

1. We don't add any new "step", keeping open and load phases only. All
the steps that don't depend on the actual host kernel information
(kallsyms, kconfig, etc) are moved into open() step, keeping it
"unprivileged" and kernel-agnostic step. So as long as BPF object and
its programs are "structurally sounds", meaning that all the subprog
calls are relocated, map references are validated (but no map_fd is
substituted, we just record which map has to be relocated, etc). It's
basically a sanity check step.

2. BTF upload, kallsyms + extern resolution, stops initi, map creation
and prog loading stays in load() step.

So that leaves the CO-RE relocation step. For BTFGen CO-RE has to
happen in open() step. The problem is that CO-RE actually relies on
kernel resource (/sys/kernel/btf/vmlinux + plus possible module BTFs),
so it would have to be in load() step. On the other hand,
bpf_object_open_ops  provide a way to specify custom vmlinux BTF, so
it is possible to avoid libbpf complaining about missing BTF by
providing custom BTF (even if it's an empty BTF).

So, say, for `bpftool gen skeleton`, to avoid libbpf erroring out
during skeleton generation, bpftool can substitute empty BTF as custom
BTF and skeleton generation should succeed (all the CO-RE relocated
instructions will be poisoned, but that's irrelevant for skeleton).

But that does feel a bit hacky. So alternatively, we do add
bpf_object__prepare() step, which performs all those structural steps
and CO-RE relocation. And all the rest stays in load().

I'm still leaning towards adding bpf_object__prepare(), as it has no
changes in the observable behavior for end users. But I wonder if
someone has strong arguments for the first approach?

In either approach, bpf_object__load() will still do anything that
requires root or CAP_BPF and modifies the state of the kernel (BTFs,
maps, progs).

>
> But the old and trusty bpf_object__open() + bpf_object__load() will
> work just as well, with load() doing steps #2-#4 automatically, if
> necessary.
>
> So what does that split gives us. Few things:
>   - it's possible to "simulate" almost all libbpf logic without
> changing the state of the system (no maps or progs created). Yet you
> still validate that kconfig externs, per-cpu externs, CO-RE relos, map
> relos, etc, all that works.
>   - libbpf can store extra information between steps 1, 2, 3, and 4,
> but after step #4 all that extra information can be discarded and
> cleaned up. So advanced users will get access to stuff like
> bpf_program__insns() and CO-RE information, but most users won't have
> to pay for that because it will be freed after bpf_object__load(). So
> in this case, bpf_program__insns() could (should?) be discarded after
> actual load, because if you care about instructions, you can do steps
> #1-#3, grab instructions and copy them, if necessary. Then proceed to
> #4 (or not) and free the memory.
>
> The last point is important, because to solve the problem 1b (exposing
> CO-RE relo info), the best way to minimize public API commitments is
> to (optionally, probably) request libbpf to record its CO-RE relo
> decisions. Here's what I propose, specifically:
>   1. Add something like "bool record_core_relo_info" (awful name,
> don't use it) in bpf_object_open_opts.
>   2. If it is set to true, libbpf will keep a "log" of CO-RE
> relocation decisions, recording stuff like program name, instruction
> index, local spec (i.e., root_type_id, spec string, relo kind, maybe
> something else), target spec (kernel type_id, kernel spec string, also
> module ID, if it's not vmlinux BTF). We can also record relocated
> value (i.e., field offset, actual enum value, true/false for
> existence, etc). All these are stable concepts, so I'd feel more
> comfortable exposing them, compared to stuff like bpf_core_accessor
> and other internal details.
>   3. The memory for all that will be managed by libbpf for simplicity
> of an API, and we'll expose accessors to get those arrays (at object
> level or per-program level is TBD).
>   4. This info will be available after the prepare() step and will be
> discarded either at create_maps() or load().
>
> I think that solves problem #1 completely (at least for BTFGen case)
> and actually provides more useful information. E.g., if someone wants
> to track CO-RE resolution logic for some other reason, they should
> have pretty full information (BTFGen doesn't need all of that).
>
> It also doesn't feel like too much complication to libbpf internals
> (even though we'll need to be very careful with BPF map relos and
> double-checking that we haven't missed any other critical part of the
> process). And for most users there is no change in API or behavior.
> And given this gives us a "framework" for more sustainable libbpf
> "observability", I think it's a justified price to pay, overall.
>
> I still need to sleep on this, but this feels like a bit cleaner way
> forward. Thoughts are welcome.
>
> >
> > > If CO-RE matching style is necessary and it's the best approach then =
please
> > > add new logic to bpftool. I'm not sure such api would be
> > > useful beyond this particular case to expose as stable libbpf api.
> >
> > I agree 100%. Our goal is to have this available on bpftool so all the
> > community can use it. However it'd be a shame if we can't use some of
> > the existing logic in libbpf.
