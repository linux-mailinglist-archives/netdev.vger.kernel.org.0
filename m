Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE31034C38E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 08:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbhC2GJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 02:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhC2GJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 02:09:35 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148BAC061574;
        Sun, 28 Mar 2021 23:09:35 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id w8so12634259ybt.3;
        Sun, 28 Mar 2021 23:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sdx5Mc3Htz7C10+Xmh6PLUuDt04/Ybhjrk76NAZeuPk=;
        b=USv8jinF0wyZbzkJKITcWEu39IPFD9V6x1LlMD21ZJ036cnSWFq7cJKZvM8+chx48I
         n+9E5IAE8C/Zk/gZBkqasTqC7q6N6KSBF47LfqEZA983tAIZ6/oeDqDuzc5s1Bi++dWY
         lsG78V1sKnCYPziZBWag3Ahli21fd+h3NuQCChqSuIQn3bzBjMFsodlCKZc3sd/Ef2nP
         gtMsqUEMBIk9WmeClGMC74uHJouY6z47Q/hzO/y1fN+46c9P72TlE5twbGaT6o61yyHs
         KHURvpk+FQB60QYMR3GexjYLak214abCkXPmoPFavcZkoaGb066sYYxcEU5mv1tGNTX4
         Umng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sdx5Mc3Htz7C10+Xmh6PLUuDt04/Ybhjrk76NAZeuPk=;
        b=YPPXX9LTZPQ+M8DdRCHEA7VeQ28Foi/LFkbkpltbHl5Fin1LJYAtx7graN04kd2QWk
         vSY0L9QTyZMbIysO7yZjco56uI0ksfMhDatIYquFsHXLWMEX/RvdbGZ0FuBJCrFRAuIG
         yDjpaCzsdrXbe3m8YO42sp2dn0jyLmse6x1YaZaNrNkfsMdK0k142cNOvfP2Goev7Lo2
         FbsfNX/1yTf+GoxXmM9O1+bMXDeg69FQsqTWPbBKUBm6InIaWwzLWZ0cOL3VLHm2SoDg
         YGx7grI6GW+V7lgU336f5GPOyUhols5SD/dnVwgIHlEPqc6b8VuxAIgjDe5ksO3skqDa
         2Kiw==
X-Gm-Message-State: AOAM531zIHqIQyVgoFkVikVXlMojBtLt8iESAxuHYNR956go630fu1B1
        cV8OH2BsWwB7htAG8Sjldici8D9UlcbNbhrsrkA=
X-Google-Smtp-Source: ABdhPJxIeklYhOQVK0NWdRYtHwncG7e3namoOkLIgegdv+23UNdH7dMcTQ3J+VdXLw9V9kU94HdoguDUkDrE41tO1pk=
X-Received: by 2002:a25:874c:: with SMTP id e12mr34870225ybn.403.1616998174150;
 Sun, 28 Mar 2021 23:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210319205909.1748642-1-andrii@kernel.org> <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp> <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
 <20210322010734.tw2rigbr3dyk3iot@ast-mbp> <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
 <20210322175443.zflwaf7dstpg4y2b@ast-mbp> <CAEf4BzYHP00_iav1Y_vhMXBmAO3AnqqBz+uK-Yu=NGYUMEUyxw@mail.gmail.com>
 <CAADnVQKDOWz7fW0kxGEeLtMJLf7J5v9Un=uDXKmwhkweoVQ3Lw@mail.gmail.com>
In-Reply-To: <CAADnVQKDOWz7fW0kxGEeLtMJLf7J5v9Un=uDXKmwhkweoVQ3Lw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 28 Mar 2021 23:09:23 -0700
Message-ID: <CAEf4Bza-uieOvR6AQkC-suD=_mjs5KC_1Ra3xo9kvdSxAMmeRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 6:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Mar 26, 2021 at 9:44 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > > Because they double the maintenance cost now and double the support forever.
> > > We never needed to worry about skeleton without BTF and now it would be
> > > a thing ? So all tests realistically need to be doubled: with and without BTF.
> >
> > 2x? Realistically?.. No, I wouldn't say so. :) Extra test or a few
> > might be warranted, but doubling the amount of testing is a huge
> > exaggeration.
>
> It's not only doubling the test coverage, but it would double the development
> effort to keep everything w/BTF and w/o BTF functional.
> So 2x is far from exaggeration.

We must be talking about different things, because I don't understand
where you get all this doubling of development effort from.

>
> > > Even more so for static linking. If one .o has BTF and another doesn't
> > > what linker suppose to do? Keep it, but the linked BTF will sort of cover
> > > both .o-s, but line info in some funcs will be missing.
> > > All these weird combinations would need to be tested.
> >
> > BPF static linker already supports that mode, btw.
>
> Are you considering one-liner commit 78b226d48106 ("libbpf: Skip BTF
> fixup if object file has no BTF")
> as support for static linking w/o BTF?

No, of course not. I'm talking about 8fd27bf69b86 ("libbpf: Add BPF
static linker BTF and BTF.ext support"), which does sensible thing
when some of input object files miss BTF. It still generates valid BTF
with as much data as it is possible to collect from the remaining
object files' BTFs. All the DATASECs will still have variable info and
correct offsets for all the variables that have BTF associated with
them.

78b226d48106 ("libbpf: Skip BTF fixup if object file has no BTF") was
a bug fix for one condition I missed in the original commit. I feel
bad about the inconveniences it caused to you and Jiri, but bugs do
slip up. Which is why I added selftests in this patch, to catch that
next time.


> Jiri's other email pointed out another place in libbpf that breaks w/o BTF.

Jiri's last issue is with add_dummy_ksym_var(), added recently in
kernel function calls support patch set. add_dummy_ksym_var()
shouldn't be called if bpf_object is missing BTF. Previously
find_extern_btf_id() would return -ESRCH in such a case, but
add_dummy_ksym_var() is now called before it.

> The only thing the commit 78b226d48106 achieved is it closed
> the one case of static linker crashing w/o BTF.
> Does linker do anything sensible when a mix of .o with and without BTF
> is given? No.
> It happens not to crash w/o BTF. That's about it.

No, see above.

>
> > And yes, it
> > shouldn't crash the kernel. And you don't need a skeleton or static
> > linker to do that to the kernel, so I don't know how that is a new
> > mode of operation.
> >
> > > The sensible thing to do would be to reject skel generation without BTF
> > > and reject linking without BTF. The user most likely forgot -g during
> > > compilation of bpf prog. The bpftool should give the helpful message
> > > in such case. Whether it's generating skel or linking. Silently proceeding
> > > and generating half-featured skeleton is not what user wanted.
> >
> > Sure, a warning message makes sense. Outright disabling this - not so
> > much. I still can't get why I can't get BPF skeleton and static
> > linking without BTF, if I really want to. Both are useful without BTF.
>
> What are the cases that would benefit?
> So far skeleton was used by tracing progs only. Those that need CO-RE.
> Which means they must have BTF.
> Networking progs didn't need CO-RE and no one bothered adopting
> skeleton because of that.
> Are you implying that a BTF-less skeleton will be useful for
> networking progs? What for?

Yes, I'm outright claiming that it would be useful even without BTF.
skel->progs.my_prog and skel->maps.my_map is extremely useful and cuts
down on boilerplate and accidental prog/map name typos, saving
development time. And it was used for that reason even in
selftests/bpf, just to make tests shorter and nicer. Auto mmap-ed
.data/.rodata, even without BTF, are still usable, if you collect all
your variables into a single struct. Which was the typical case before
the BPF skeleton came about.

So, not having to manually mmap() .rodata/.data/.bss is beneficial.
And it doesn't come at a lot of cost. But again, I'm not advocating
for such an approach, and I'm not saying we should encourage it. But
as I already said, I like tools that don't make unnecessary
assumptions, especially if that doesn't come at huge cost, which I
still think is the case here.

As for why networking folks haven't adopted it. I'd ask networking
folks, but I assume inertia has its place there as well, which is to
be expected and is not bad per se. Changes take time. If they already
have working applications, why bother changing anything?

> So far I see only downsides from increasing the amount of work needed
> to support skel and static linking w/o BTF. The extra 100% or just 1%
> would be equally taxing, since it's extra work for the foreseeable future and
> compounded 1% will add up.
>
> Looking at it from another angle... the skeleton generation existed
> for more than
> a year now and it implicitly required BTF. That requirement was not
> written down.
> Now you're proposing to support skeleton gen w/o BTF when not a single user
> requested it and not providing any advantages of such support while
> ignoring the long term maintenance of such effort.

BPF skeleton works just fine without BTF, if BPF programs don't use
global data. I have no way of knowing how BPF skeleton is used in the
wild, and specifically whether it is used without BTF and
.data/.rodata. But artificially failing BPF skeleton generation now
for such a case would be an obvious regression.

I think those maintenance costs are exaggerated, we are probably not
going to agree on this. I fixed the bug in BPF skeleton making
unnecessary assumptions of BTF DATASEC presence, where it's not
strictly necessary for correctness. I don't see it as an ugly hack or
maintenance burden. It shouldn't need constant attention and shouldn't
break.

>
> Another angle... I did git grep in selftests that use skeleton.
> Only a handful of tests use it as *skel*__open_and_load() w/o global data
> (which would still work w/o BTF)
> and only because we forcefully converted them when skel was introduced.
> bcc/libbpf-tools/* need skel with BTF.
> I couldn't find a _single_ case where people use
> skeleton and don't need BTF driven parts of it.

And I've found a few at Facebook that don't need any BTF and use
open_and_load() and skel->maps and skel->progs accessor. But I don't
know what either of those prove?.. libbpf-tools obviously are using
BTF, because I've set up everything so that BTF is always generated
and I've suggested use of global variables for each converted tool.
But again, how is that an argument for anything. We can't know
everything that people are doing.

I'll say that again. I hate when tools assume how I'm going to use
them. They should do what they are meant to do and don't impose
unnecessary restrictions.

>
> > So I don't know, it's the third different argument I'm addressing
> without any conclusion on the previous two.
>
> So far you haven't addressed the first question:
> Who is asking for a BTF-less skeleton? What for? What features are requested?
> I've seen none of such requests.

No one is asking for that, but they might be already using BTF-less
skeleton. So I'm fixing a bug in bpftool. In a way that doesn't cause
long term maintenance burden. And see above about my stance on tools'
assumptions.

BPF skeleton wasn't added specifically to access global variables.
skel->maps and skel->progs were enough motivation for me to add BPF
skeleton. And still is enough.


>
> BTF is not a debug info of the BPF program.
> If it was then I would agree that compiling with and without -g shouldn't
> make a difference.

It effectively doesn't in a lot of cases (all the "classic" BPF
programs that used kprobes, tracepoints, perfbuf, maps, etc). But I'm
not arguing for not using BTF at all. I've myself contributed a lot of
time and effort to make BTF almost universal in BPF ecosystem. If I
didn't believe in BTF, I wouldn't add BTF-defined maps, just as a one
example of reliance on BTF.

All I'm asking is to let me fix a bug in BPF skeleton generation and
have a test validating that it is fixed.

> But BTF is not a debug-info. It's type and much more description of the program
> that is mandatory for the verification of the program.
> btf_id-based attach, CO-RE, trampoline, calling kernel funcs, etc all
> require BTF.

If fentry/fexit (whether it is btf_id-based or trampoline in your
classification), then BTF for the BPF program itself is not required
for it to work at all. Only kernel BTF is a requirement for those. But
we both know this very well. But just as a fun exercise, I just
double-checked by compiling fentry demo from libbpf-bootstrap ([0]).
It works just fine without `-g` and BTF.

  [0] https://github.com/libbpf/libbpf-bootstrap/blob/master/src/fentry.bpf.c


> Not because it's convenient to use BTF, but because assembly doesn't
> have enough information.
> There is no C, C++, Rust equivalent of BTF. There is none in the user
> space world.

Right, because of CO-RE relocations.

> Traditional languages translate a language into assembly code and cpus
> execute it.
> Static analyzers use high level languages to understand the intent.
> BPF workflow translates a language into assembly and BTF, so that the verifier
> can see the intent. It could happen that BPF will gain something else beyond BTF
> and it will become a mandatory part of the workflow. Just like BTF is today.

Yeah, that's fine and we do require BTF for new features (where it
makes sense, of course, not just arbitrarily). Both in kernel and in
libbpf. But kernel doesn't artificially impose BTF restrictions
either. See above about fentry/fexit, they work just fine without BTF.
So do a lot of other features. Same for libbpf, see libbpf_needs_btf()
and kernel_needs_btf().


> At that point all new features will be supported with that new
> "annotation" only,
> not because of "subjective personal preferences", but because that is
> a fundamental
> program description.

Map relocations, BPF-to-BPF calls, global variables, even multiple BPF
programs per-section are all pretty fundamental to BPF programming
with libbpf and they work just fine without BTF. But I agree, BTF is
great and should be leveraged where it provides extra value.
