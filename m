Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC6E11C3A2
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 03:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfLLC5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 21:57:40 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35573 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLLC5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 21:57:39 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so371787pgk.2
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 18:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zuWq2zzlYuzeSxp5YU2vjFxRXp8n1TI+tTBsBxjLs4E=;
        b=Hbfv/WjbEqB56iGW+iakmBRMVSeb6cIlrUErA84dfstDfRY1EhHEiXkSjvz2cjgvNj
         brjtPcZR7nYpSDA8jrYbW6ejuEzyUFtlq9PHr7NRgN2ZkJ4N3y/h17kZdM6o+yiMHu7o
         9aiei3kcG3ZsVDhiWLmBhWLmIXNZitIktWYsykiTcQI+r8iT/2nIlN1XRQnBHjho90Yu
         Q3YclImXvPaEWtAYZNGibVi1bhYUd134KMdorTxoZvBWtdRpfhK4HArgw2jf+t+mxLL1
         Dn+OFr6dhetgYhrfpI7GRq9yTpTmW2VDNzGb9eBawHGTjQL5ti1Vc33a5zOrEVh+N9xV
         WOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zuWq2zzlYuzeSxp5YU2vjFxRXp8n1TI+tTBsBxjLs4E=;
        b=OXltdYu/Caq23QeHcFiMj7+Z+QWuk531G+Z1gG4FLxzHIW1/4yIXuiSxM1XfPW8Upo
         S81bBNtPqTUpYeqbgKhwS8bOYjn++dS7WL45WYZOBQc0HTKF/xIKWbtA4BR/opeIPWjI
         LH+/5va/Aqk3GYjVZdICrfzCm5uqDKQFSVb+20tplVa7SvFN2h6Smi5ekPb+1ArLzAJb
         ANlSh7SgTTFptrZN0W/V84UbHgqcsVNVr/ZAUFKSruTh4kh2DJp4QLLmO5wiQGi+DjeX
         iUIniQPMnn2WV7OyHGlucblsNL1vu4tOsHcb7Cgwt4OfS/y9P2eTdCrM1yAccB3i10fy
         AKPQ==
X-Gm-Message-State: APjAAAVQ+WYqw+4F9AjR/SLkP+QPjnMtWRpetmanrNgLltyXZlIMV2QJ
        kB0KV2IHh01aYBs35rFG7zBBgKbMp4M=
X-Google-Smtp-Source: APXvYqyaSDrkL+8WrhSo7lYgJjHA+IfIzY3qpf9q6mky4id0vqseKZxGqzMLSuT9ApUwd8Wg9k8fKQ==
X-Received: by 2002:a63:9d8f:: with SMTP id i137mr7896670pgd.33.1576119456900;
        Wed, 11 Dec 2019 18:57:36 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id m127sm4530444pfm.167.2019.12.11.18.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 18:57:36 -0800 (PST)
Date:   Wed, 11 Dec 2019 18:57:35 -0800
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
Message-ID: <20191212025735.GK3105713@mini-arch>
References: <20191210214407.GA3105713@mini-arch>
 <CAEf4BzbSwoeKVnyJU7EoP86exNj3Eku5_+8MbEieZKt2MqrhbQ@mail.gmail.com>
 <20191210225900.GB3105713@mini-arch>
 <CAEf4BzYtqywKn4yGQ+vq2sKod4XE03HYWWBfUiNvg=BXhgFdWg@mail.gmail.com>
 <20191211172432.GC3105713@mini-arch>
 <CAEf4Bzb+3b-ypP8YJVA=ogQgp1KXx2xPConOswA0EiGXsmfJow@mail.gmail.com>
 <20191211191518.GD3105713@mini-arch>
 <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
 <20191211200924.GE3105713@mini-arch>
 <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11, Andrii Nakryiko wrote:
> On Wed, Dec 11, 2019 at 12:09 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 12/11, Andrii Nakryiko wrote:
> > > On Wed, Dec 11, 2019 at 11:15 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > >
> > > > On 12/11, Andrii Nakryiko wrote:
> > > > > On Wed, Dec 11, 2019 at 9:24 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > > > >
> > > > > > On 12/10, Andrii Nakryiko wrote:
> > > > > > > On Tue, Dec 10, 2019 at 2:59 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > > > > > >
> > > > > > > > On 12/10, Andrii Nakryiko wrote:
> > > > > > > > > On Tue, Dec 10, 2019 at 1:44 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > > > > > > > > >
> > > > > > > > > > On 12/10, Jakub Kicinski wrote:
> > > > > > > > > > > On Tue, 10 Dec 2019 09:11:31 -0800, Andrii Nakryiko wrote:
> > > > > > > > > > > > On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski wrote:
> > > > > > > > > > > > > On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:
> > > > > > > > > > > > > > struct <object-name> {
> > > > > > > > > > > > > >       /* used by libbpf's skeleton API */
> > > > > > > > > > > > > >       struct bpf_object_skeleton *skeleton;
> > > > > > > > > > > > > >       /* bpf_object for libbpf APIs */
> > > > > > > > > > > > > >       struct bpf_object *obj;
> > > > > > > > > > > > > >       struct {
> > > > > > > > > > > > > >               /* for every defined map in BPF object: */
> > > > > > > > > > > > > >               struct bpf_map *<map-name>;
> > > > > > > > > > > > > >       } maps;
> > > > > > > > > > > > > >       struct {
> > > > > > > > > > > > > >               /* for every program in BPF object: */
> > > > > > > > > > > > > >               struct bpf_program *<program-name>;
> > > > > > > > > > > > > >       } progs;
> > > > > > > > > > > > > >       struct {
> > > > > > > > > > > > > >               /* for every program in BPF object: */
> > > > > > > > > > > > > >               struct bpf_link *<program-name>;
> > > > > > > > > > > > > >       } links;
> > > > > > > > > > > > > >       /* for every present global data section: */
> > > > > > > > > > > > > >       struct <object-name>__<one of bss, data, or rodata> {
> > > > > > > > > > > > > >               /* memory layout of corresponding data section,
> > > > > > > > > > > > > >                * with every defined variable represented as a struct field
> > > > > > > > > > > > > >                * with exactly the same type, but without const/volatile
> > > > > > > > > > > > > >                * modifiers, e.g.:
> > > > > > > > > > > > > >                */
> > > > > > > > > > > > > >                int *my_var_1;
> > > > > > > > > > > > > >                ...
> > > > > > > > > > > > > >       } *<one of bss, data, or rodata>;
> > > > > > > > > > > > > > };
> > > > > > > > > > > > >
> > > > > > > > > > > > > I think I understand how this is useful, but perhaps the problem here
> > > > > > > > > > > > > is that we're using C for everything, and simple programs for which
> > > > > > > > > > > > > loading the ELF is majority of the code would be better of being
> > > > > > > > > > > > > written in a dynamic language like python?  Would it perhaps be a
> > > > > > > > > > > > > better idea to work on some high-level language bindings than spend
> > > > > > > > > > > > > time writing code gens and working around limitations of C?
> > > > > > > > > > > >
> > > > > > > > > > > > None of this work prevents Python bindings and other improvements, is
> > > > > > > > > > > > it? Patches, as always, are greatly appreciated ;)
> > > > > > > > > > >
> > > > > > > > > > > This "do it yourself" shit is not really funny :/
> > > > > > > > > > >
> > > > > > > > > > > I'll stop providing feedback on BPF patches if you guy keep saying
> > > > > > > > > > > that :/ Maybe that's what you want.
> > > > > > > > > > >
> > > > > > > > > > > > This skeleton stuff is not just to save code, but in general to
> > > > > > > > > > > > simplify and streamline working with BPF program from userspace side.
> > > > > > > > > > > > Fortunately or not, but there are a lot of real-world applications
> > > > > > > > > > > > written in C and C++ that could benefit from this, so this is still
> > > > > > > > > > > > immensely useful. selftests/bpf themselves benefit a lot from this
> > > > > > > > > > > > work, see few of the last patches in this series.
> > > > > > > > > > >
> > > > > > > > > > > Maybe those applications are written in C and C++ _because_ there
> > > > > > > > > > > are no bindings for high level languages. I just wish BPF programming
> > > > > > > > > > > was less weird and adding some funky codegen is not getting us closer
> > > > > > > > > > > to that goal.
> > > > > > > > > > >
> > > > > > > > > > > In my experience code gen is nothing more than a hack to work around
> > > > > > > > > > > bad APIs, but experiences differ so that's not a solid argument.
> > > > > > > > > > *nod*
> > > > > > > > > >
> > > > > > > > > > We have a nice set of C++ wrappers around libbpf internally, so we can do
> > > > > > > > > > something like BpfMap<key type, value type> and get a much better interface
> > > > > > > > > > with type checking. Maybe we should focus on higher level languages instead?
> > > > > > > > > > We are open to open-sourcing our C++ bits if you want to collaborate.
> > > > > > > > >
> > > > > > > > > Python/C++ bindings and API wrappers are an orthogonal concerns here.
> > > > > > > > > I personally think it would be great to have both Python and C++
> > > > > > > > > specific API that uses libbpf under the cover. The only debatable
> > > > > > > > > thing is the logistics: where the source code lives, how it's kept in
> > > > > > > > > sync with libbpf, how we avoid crippling libbpf itself because
> > > > > > > > > something is hard or inconvenient to adapt w/ Python, etc.
> > > > > > > >
> > > > > > > > [..]
> > > > > > > > > The problem I'm trying to solve here is not really C-specific. I don't
> > > > > > > > > think you can solve it without code generation for C++. How do you
> > > > > > > > > "generate" BPF program-specific layout of .data, .bss, .rodata, etc
> > > > > > > > > data sections in such a way, where it's type safe (to the degree that
> > > > > > > > > language allows that, of course) and is not "stringly-based" API? This
> > > > > > > > > skeleton stuff provides a natural, convenient and type-safe way to
> > > > > > > > > work with global data from userspace pretty much at the same level of
> > > > > > > > > performance and convenience, as from BPF side. How can you achieve
> > > > > > > > > that w/ C++ without code generation? As for Python, sure you can do
> > > > > > > > > dynamic lookups based on just the name of property/method, but amount
> > > > > > > > > of overheads is not acceptable for all applications (and Python itself
> > > > > > > > > is not acceptable for those applications). In addition to that, C is
> > > > > > > > > the best way for other less popular languages (e.g., Rust) to leverage
> > > > > > > > > libbpf without investing lots of effort in re-implementing libbpf in
> > > > > > > > > Rust.
> > > > > > > > I'd say that a libbpf API similar to dlopen/dlsym is a more
> > > > > > > > straightforward thing to do. Have a way to "open" a section and
> > > > > > > > a way to find a symbol in it. Yes, it's a string-based API,
> > > > > > > > but there is nothing wrong with it. IMO, this is easier to
> > > > > > > > use/understand and I suppose Python/C++ wrappers are trivial.
> > > > > > >
> > > > > > > Without digging through libbpf source code (or actually, look at code,
> > > > > > > but don't run any test program), what's the name of the map
> > > > > > > corresponding to .bss section, if object file is
> > > > > > > some_bpf_object_file.o? If you got it right (congrats, btw, it took me
> > > > > > > multiple attempts to memorize the pattern), how much time did you
> > > > > > > spend looking it up? Now compare it to `skel->maps.bss`. Further, if
> > > > > > > you use anonymous structs for your global vars, good luck maintaining
> > > > > > > two copies of that: one for BPF side and one for userspace.
> > > > > > As your average author of BPF programs I don't really care
> > > > > > which section my symbol ends up into. Just give me an api
> > > > > > to mmap all "global" sections (or a call per section which does all the
> > > > > > naming magic inside) and lookup symbol by name; I can cast it to a proper
> > > > > > type and set it.
> > > > >
> > > > > I'd like to not have to know about bss/rodata/data as well, but that's
> > > > > how things are done for global variables. In skeleton we can try to
> > > > > make an illusion like they are part of one big datasection/struct, but
> > > > > that seems like a bit too much magic at this point. But then again,
> > > > > one of the reasons I want this as an experimental feature, so that we
> > > > > can actually judge from real experience how inconvenient some things
> > > > > are, and not just based on "I think it would be ...".
> > > > >
> > > > > re: "Just give me ...". Following the spirit of "C is hard" from your
> > > > > previous arguments, you already have that API: mmap() syscall. C
> > > > > programmers have to be able to figure out the rest ;) But on the
> > > > > serious note, this auto-generated code in skeleton actually addresses
> > > > > all concerns (and more) that you mentioned: mmaping, knowing offsets,
> > > > > knowing names and types, etc. And it doesn't preclude adding more
> > > > > "conventional" additional APIs to do everything more dynamically,
> > > > > based on string names.
> > > > We have different understanding of what's difficult :-)
> > >
> > > Well, clearly... See below.
> > >
> > > >
> > > > To me, doing transparent data/rodata/bss mmap in bpf_object__load and then
> > > > adding a single libbpf api call to lookup symbol by string name is simple
> > > > (both from user perspective and from libbpf code complexity). Because in
> > > > order to use the codegen I need to teach our build system to spit it
> > > > out (which means I need to add bpftool to it and keep it
> > > > updated/etc/etc). You can use it as an example of "real experience how
> > > > inconvenient some things are".
> > >
> > > Yes, you need to integrate bpftool in your build process. Which is
> > > exactly what I'm doing internally for Facebook as well. But it's a
> > > mostly one-time cost, which benefits lots of users who have much
> > > better time with these changes, as opposed to make things simpler for
> > > us, libbpf developers, at the expense of more convoluted user
> > > experience for end users. I certainly prefer more complicated
> > > libbpf/bpftool code, if the resulting user experience is simpler for
> > > BPF application developers, no doubt about it.
> > I'm in the process of going through this with pahole to get proper BTF.
> > I don't think I'm willing yet (without a good reason) to go through
> > this process again :-D (I saw that you've converted a bunch of tests
> > to it which means I might not be able to run them).
> 
> A lot of new functionality is depending on BTF for a really good
> reason (check Alexei's fentry/fexit/btf_tp stuff, allowing for safe
> direct memory reads and extremely low overhead kretprobes). More stuff
> is to come and is going to require in-kernel BTF, so even if it's
> painful right now, it's worth it. Think long term and keep perspective
> in mind.
Oh yeah, that's totally understandable with BTF, that's why I just started
adding it to our build. Still was a bit surprising that one day most
our our testing went red.

> > I just hope bpftool codegen doesn't become a requirement for
> > any new useful feature; same happened to BTF, which was optional
> > for a while and now I can't run a single selftest without it.
> > I can totally understand the BTF requirement though, but I don't buy the
> > "codegen makes user experience simple for bpf application developers",
> > sorry (I guess, at this point, it's all about preference).
> 
> Bpftool is going to be a requirement for selftests. And it's a good
> thing because it allows us to continuously test not just libbpf,
> kernel, but now also related tooling. I haven't converted all of the
> selftests to skeleton, but given enough time I'd do that, just for the
> cleaner and shorter plumbing code it gives.
Then why all the talk about --experimantal flags if you've set up your
mind on converting everything already?

Btw, how hard it would be to do this generation with a new python
script instead of bpftool? Something along the lines of
scripts/bpf_helpers_doc.py that parses BTF and spits out this C header
(shouldn't be that hard to write custom BTF parser in python, right)?

Python might be easier to integrate with other projects (our build system,
cilium, etc).

> > > > > > RE anonymous structs: maybe don't use them if you want to share the data
> > > > > > between bpf and userspace?
> > > > >
> > > > > Alright.
> > > > >
> > > > > >
> > > > > > > I never said there is anything wrong with current straightforward
> > > > > > > libbpf API, but I also never said it's the easiest and most
> > > > > > > user-friendly way to work with BPF either. So we'll have both
> > > > > > > code-generated interface and existing API. Furthermore, they are
> > > > > > > interoperable (you can pass skel->maps.whatever to any of the existing
> > > > > > > libbpf APIs, same for progs, links, obj itself). But there isn't much
> > > > > > > that can beat performance and usability of code-generated .data, .bss,
> > > > > > > .rodata (and now .extern) layout.
> > > > > > I haven't looked closely enough, but is there a libbpf api to get
> > > > > > an offset of a variable? Suppose I have the following in bpf.c:
> > > > > >
> > > > > >         int a;
> > > > > >         int b;
> > > > > >
> > > > > > Can I get an offset of 'b' in the .bss without manually parsing BTF?
> > > > >
> > > > > No there isn't right now. There isn't even an API to know that there
> > > > > is such a variable called "b". Except for this skeleton, of course.
> > > > >
> > > > > >
> > > > > > TBH, I don't buy the performance argument for these global maps.
> > > > > > When you did the mmap patchset for the array, you said it yourself
> > > > > > that it's about convenience and not performance.
> > > > >
> > > > > Yes, it's first and foremost about convenience, addressing exactly the
> > > > > problems you mentioned above. But performance is critical for some use
> > > > > cases, and nothing can beat memory-mapped view of BPF map for those.
> > > > > Think about the case of frequently polling (or even atomically
> > > > > exchanging) some stats from userspace, as one possible example. E.g.,
> > > > > like some map statistics (number of filled elements, p50 of whatever
> > > > > of those elements, etc). I'm not sure what's there to buy: doing
> > > > > syscall to get **entire** global data map contents vs just fetching
> > > > > single integer from memory-mapped region, guess which one is cheaper?
> > > > My understanding was that when you were talking about performance, you
> > > > were talking about doing symbol offset lookup at runtime vs having a
> > > > generated struct with fixed offsets; not about mmap vs old api with copy
> > > > (this debate is settled since your patches are accepted).
> > >
> > > Oh, I see. No, I didn't intend to claim that performance of looking up
> > > variable by name in BTF is a big performance concern. Settled then :)
> > >
> > > >
> > > > But to your original reply: you do understand that if you have multiple
> > > > threads that write to this global data you have a bigger problem, right?
> > >
> > > Not necessarily. BPF has atomic increment instruction, doesn't it? And
> > > can't we still do atomic swap from user-space (it's just a memory,
> > > after all), right? I haven't tried, tbh, but don't see why it wouldn't
> > > work.
> > Atomics are even worse because you get all these nice cache bouncing effects.
> > That's why I didn't understand initialy the argument about performance.
> 
> Depends on problems you are trying to solve. I bet it's still cheaper
> than doing map updates under lock, don't you think?
Exactly, depends on the problem. But still, if you need frequent reads
of that global data, it means there are frequent writes, which is
a problem on its own.
