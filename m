Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E1711BA33
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 18:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbfLKRYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 12:24:35 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46524 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbfLKRYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 12:24:34 -0500
Received: by mail-pg1-f195.google.com with SMTP id z124so11052758pgb.13
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 09:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kXZ4aqS0uFPSyTpXVREqajZ2V8XvicWtvP1bC/iBXA0=;
        b=MhspcRSZVu7valP3RyaPPWgFdz8/QMgQeVJJ2pRuqjM7KuaSUhImmxUXvLqJHULlV9
         hcfZ3gSd7/E+yG4sAL30QUImCTx2MrAbZB5x3T1/zYZlYdi3uOS2SZOrfVAmPVTArZzx
         kb2Gq4rOUSInPffbEAu3bKqeEIF0dV6jcfPGzPlUknSA+ChqI9BtHhaLc//8vVaz1Gyh
         7xX1GkzwHG0rcacg3f00JYEcLj2vuF+5l1dQh80lRRhtztXlYOlLlNzcjpoBbM4jKPZs
         HyyFsfq6/ykX/17GbAXQbd2ymutX5vArM710aRCUuqVYUQ7VpidmybLDGo/ZpmWy+zxQ
         FNdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kXZ4aqS0uFPSyTpXVREqajZ2V8XvicWtvP1bC/iBXA0=;
        b=EHFO7MhWB7C2uZsso6AhK1Ttp+auK1aMJ/VVqhsPd8Bk7V9hm0kmjzLjfntdhaIfmW
         rrDF3cbKqr7L7Vc9fBV03wX3i3zfw0GA72+OPfqKVsYYKC2GRNBPmnVeRzuSszy0QVGT
         ZsmWrAQtACRMhC0lwU/Cj2w3NEkhYsK9KelO2k27Hz3fqApa2FfJLe2rp3YBFr4WW3aq
         xrN6rKWIXAjhMirtmeu98zbbqby5otMfVy9MTFRksH6RXJVwoq1pWoo4dvixNyCGyO6j
         87DkGSoVPfU0//kvjm8XefCRpjPPicxBv1HRI8Ih5zOuH+JWbdUCEs6oXCC37Y4PScyL
         oafw==
X-Gm-Message-State: APjAAAWaIi/DD5D8/a1P5f0+R7FPZLePj1zfan4Ljxpdd0Ats7SqW8j5
        KvgWEY30PjOEshcQ8dPHlKGxZw==
X-Google-Smtp-Source: APXvYqxoegsHd9PZCcnPqYySFzujS1nwe5vh9qArbS2aDuHtyfBlEKZ7XXcuQbUWiakctxMNds096g==
X-Received: by 2002:a62:446:: with SMTP id 67mr4738128pfe.109.1576085073816;
        Wed, 11 Dec 2019 09:24:33 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id a14sm3619810pfn.22.2019.12.11.09.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 09:24:33 -0800 (PST)
Date:   Wed, 11 Dec 2019 09:24:32 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191211172432.GC3105713@mini-arch>
References: <20191210011438.4182911-1-andriin@fb.com>
 <20191210011438.4182911-12-andriin@fb.com>
 <20191209175745.2d96a1f0@cakuba.netronome.com>
 <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
 <20191210100536.7a57d5e1@cakuba.netronome.com>
 <20191210214407.GA3105713@mini-arch>
 <CAEf4BzbSwoeKVnyJU7EoP86exNj3Eku5_+8MbEieZKt2MqrhbQ@mail.gmail.com>
 <20191210225900.GB3105713@mini-arch>
 <CAEf4BzYtqywKn4yGQ+vq2sKod4XE03HYWWBfUiNvg=BXhgFdWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYtqywKn4yGQ+vq2sKod4XE03HYWWBfUiNvg=BXhgFdWg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10, Andrii Nakryiko wrote:
> On Tue, Dec 10, 2019 at 2:59 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 12/10, Andrii Nakryiko wrote:
> > > On Tue, Dec 10, 2019 at 1:44 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 12/10, Jakub Kicinski wrote:
> > > > > On Tue, 10 Dec 2019 09:11:31 -0800, Andrii Nakryiko wrote:
> > > > > > On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski wrote:
> > > > > > > On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:
> > > > > > > > struct <object-name> {
> > > > > > > >       /* used by libbpf's skeleton API */
> > > > > > > >       struct bpf_object_skeleton *skeleton;
> > > > > > > >       /* bpf_object for libbpf APIs */
> > > > > > > >       struct bpf_object *obj;
> > > > > > > >       struct {
> > > > > > > >               /* for every defined map in BPF object: */
> > > > > > > >               struct bpf_map *<map-name>;
> > > > > > > >       } maps;
> > > > > > > >       struct {
> > > > > > > >               /* for every program in BPF object: */
> > > > > > > >               struct bpf_program *<program-name>;
> > > > > > > >       } progs;
> > > > > > > >       struct {
> > > > > > > >               /* for every program in BPF object: */
> > > > > > > >               struct bpf_link *<program-name>;
> > > > > > > >       } links;
> > > > > > > >       /* for every present global data section: */
> > > > > > > >       struct <object-name>__<one of bss, data, or rodata> {
> > > > > > > >               /* memory layout of corresponding data section,
> > > > > > > >                * with every defined variable represented as a struct field
> > > > > > > >                * with exactly the same type, but without const/volatile
> > > > > > > >                * modifiers, e.g.:
> > > > > > > >                */
> > > > > > > >                int *my_var_1;
> > > > > > > >                ...
> > > > > > > >       } *<one of bss, data, or rodata>;
> > > > > > > > };
> > > > > > >
> > > > > > > I think I understand how this is useful, but perhaps the problem here
> > > > > > > is that we're using C for everything, and simple programs for which
> > > > > > > loading the ELF is majority of the code would be better of being
> > > > > > > written in a dynamic language like python?  Would it perhaps be a
> > > > > > > better idea to work on some high-level language bindings than spend
> > > > > > > time writing code gens and working around limitations of C?
> > > > > >
> > > > > > None of this work prevents Python bindings and other improvements, is
> > > > > > it? Patches, as always, are greatly appreciated ;)
> > > > >
> > > > > This "do it yourself" shit is not really funny :/
> > > > >
> > > > > I'll stop providing feedback on BPF patches if you guy keep saying
> > > > > that :/ Maybe that's what you want.
> > > > >
> > > > > > This skeleton stuff is not just to save code, but in general to
> > > > > > simplify and streamline working with BPF program from userspace side.
> > > > > > Fortunately or not, but there are a lot of real-world applications
> > > > > > written in C and C++ that could benefit from this, so this is still
> > > > > > immensely useful. selftests/bpf themselves benefit a lot from this
> > > > > > work, see few of the last patches in this series.
> > > > >
> > > > > Maybe those applications are written in C and C++ _because_ there
> > > > > are no bindings for high level languages. I just wish BPF programming
> > > > > was less weird and adding some funky codegen is not getting us closer
> > > > > to that goal.
> > > > >
> > > > > In my experience code gen is nothing more than a hack to work around
> > > > > bad APIs, but experiences differ so that's not a solid argument.
> > > > *nod*
> > > >
> > > > We have a nice set of C++ wrappers around libbpf internally, so we can do
> > > > something like BpfMap<key type, value type> and get a much better interface
> > > > with type checking. Maybe we should focus on higher level languages instead?
> > > > We are open to open-sourcing our C++ bits if you want to collaborate.
> > >
> > > Python/C++ bindings and API wrappers are an orthogonal concerns here.
> > > I personally think it would be great to have both Python and C++
> > > specific API that uses libbpf under the cover. The only debatable
> > > thing is the logistics: where the source code lives, how it's kept in
> > > sync with libbpf, how we avoid crippling libbpf itself because
> > > something is hard or inconvenient to adapt w/ Python, etc.
> >
> > [..]
> > > The problem I'm trying to solve here is not really C-specific. I don't
> > > think you can solve it without code generation for C++. How do you
> > > "generate" BPF program-specific layout of .data, .bss, .rodata, etc
> > > data sections in such a way, where it's type safe (to the degree that
> > > language allows that, of course) and is not "stringly-based" API? This
> > > skeleton stuff provides a natural, convenient and type-safe way to
> > > work with global data from userspace pretty much at the same level of
> > > performance and convenience, as from BPF side. How can you achieve
> > > that w/ C++ without code generation? As for Python, sure you can do
> > > dynamic lookups based on just the name of property/method, but amount
> > > of overheads is not acceptable for all applications (and Python itself
> > > is not acceptable for those applications). In addition to that, C is
> > > the best way for other less popular languages (e.g., Rust) to leverage
> > > libbpf without investing lots of effort in re-implementing libbpf in
> > > Rust.
> > I'd say that a libbpf API similar to dlopen/dlsym is a more
> > straightforward thing to do. Have a way to "open" a section and
> > a way to find a symbol in it. Yes, it's a string-based API,
> > but there is nothing wrong with it. IMO, this is easier to
> > use/understand and I suppose Python/C++ wrappers are trivial.
> 
> Without digging through libbpf source code (or actually, look at code,
> but don't run any test program), what's the name of the map
> corresponding to .bss section, if object file is
> some_bpf_object_file.o? If you got it right (congrats, btw, it took me
> multiple attempts to memorize the pattern), how much time did you
> spend looking it up? Now compare it to `skel->maps.bss`. Further, if
> you use anonymous structs for your global vars, good luck maintaining
> two copies of that: one for BPF side and one for userspace.
As your average author of BPF programs I don't really care
which section my symbol ends up into. Just give me an api
to mmap all "global" sections (or a call per section which does all the
naming magic inside) and lookup symbol by name; I can cast it to a proper
type and set it.

RE anonymous structs: maybe don't use them if you want to share the data
between bpf and userspace?

> I never said there is anything wrong with current straightforward
> libbpf API, but I also never said it's the easiest and most
> user-friendly way to work with BPF either. So we'll have both
> code-generated interface and existing API. Furthermore, they are
> interoperable (you can pass skel->maps.whatever to any of the existing
> libbpf APIs, same for progs, links, obj itself). But there isn't much
> that can beat performance and usability of code-generated .data, .bss,
> .rodata (and now .extern) layout.
I haven't looked closely enough, but is there a libbpf api to get
an offset of a variable? Suppose I have the following in bpf.c:

	int a;
	int b;

Can I get an offset of 'b' in the .bss without manually parsing BTF?

TBH, I don't buy the performance argument for these global maps.
When you did the mmap patchset for the array, you said it yourself
that it's about convenience and not performance.

> > As for type-safety: it's C, forget about it :-)
> 
> C is weakly, but still typed language. There are types and they are
> helpful. Yes, you can disregard them and re-interpret values as
> anything, but that's beside the point.
My point was that there is a certain mental model when working
with this type of external symbols which feels "natural" for C
(dlopen/dlsym).

But I agree with you, that as long as code-gen is optional
and there is an alternative api in libbpf, we should be good.
