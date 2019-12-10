Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52A1119ED4
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 23:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfLJW7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 17:59:02 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39444 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfLJW7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 17:59:02 -0500
Received: by mail-pl1-f196.google.com with SMTP id o9so490033plk.6
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 14:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vpFOxiMZI3wLnugiw6ZK5a1MGgcbf1URL3Ew4UkA4vw=;
        b=wcNzTkNRAo8zcaltDabwo/6jjeesZ1t9zuh8cTat1eROxlv9eD0P98UAIRG5f7kIIG
         NPm6dZ28OlSpn4DdnjMi7IFj+IpK7B+St+TCqINRIowPNscwvwg3n6+pcvZ4uDLsUCQc
         RfJJ/hwxxzH/R8KqmXjdTewAswQ/5tBNudkNjInxZmX+1BWxo2YJx05O31IDVixSR4md
         aFGJZWs4NQ4IxeARGNq4G+/rTZJfO2OnByhSr1P7yNIVlyIQcJ3Z/x3j7RfVWiYsGBlu
         oR8yEyjx7GQmga0BxQI+1Ew0fZELTnzu9sQhJrVh4QlfYEq8UcHmuLDZOuydmityK2cS
         uLCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vpFOxiMZI3wLnugiw6ZK5a1MGgcbf1URL3Ew4UkA4vw=;
        b=MR2nMC+9O10LdnznidGhEgYHZF9UutKlb3w+WtnYTeHZvd68vswHpKgghKL+EXAkoK
         w9ewdK70UQE5p1odLymyGCNUlW3Kk5100iwTzxQY1aV25bBF7yebOY6X1Vvh90ux4ZXS
         WFFYpEHX4JzK2240KOE5LP8DHRn5QTOCavam6sBuXlG6/RQpshLFpQOJJBM06NfwKK4/
         bz7Wohrn/Ybc/NLgZ8FMlK0gpeVvl/j1UH4ARhcMilfvjvOPZQOCtSFErgopHifM4w7B
         TpHwQgJ/PS0mCwb1R4kYU2FibtM2MMt3k+tc9y09X9yAZdR/t3i5NSHFIOmM9SBdkzGF
         rYFg==
X-Gm-Message-State: APjAAAW3k5a6bqJ8/v8XZTyex82WP2VIvD5rlNEljV3L3k69QT1J+CEi
        cN6jafEk3ImshoI2VOKkN8DGQA==
X-Google-Smtp-Source: APXvYqwse9t7cYgpMsIPVSQvmp8zy5G48e60UJTJLW0VCZrFhsf/Hqc7ZW1lh7fRy4XaxSGHTG+1FQ==
X-Received: by 2002:a17:90a:f84:: with SMTP id 4mr8275895pjz.74.1576018741580;
        Tue, 10 Dec 2019 14:59:01 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id q6sm83979pfh.127.2019.12.10.14.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 14:59:01 -0800 (PST)
Date:   Tue, 10 Dec 2019 14:59:00 -0800
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
Message-ID: <20191210225900.GB3105713@mini-arch>
References: <20191210011438.4182911-1-andriin@fb.com>
 <20191210011438.4182911-12-andriin@fb.com>
 <20191209175745.2d96a1f0@cakuba.netronome.com>
 <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
 <20191210100536.7a57d5e1@cakuba.netronome.com>
 <20191210214407.GA3105713@mini-arch>
 <CAEf4BzbSwoeKVnyJU7EoP86exNj3Eku5_+8MbEieZKt2MqrhbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbSwoeKVnyJU7EoP86exNj3Eku5_+8MbEieZKt2MqrhbQ@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10, Andrii Nakryiko wrote:
> On Tue, Dec 10, 2019 at 1:44 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 12/10, Jakub Kicinski wrote:
> > > On Tue, 10 Dec 2019 09:11:31 -0800, Andrii Nakryiko wrote:
> > > > On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski wrote:
> > > > > On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:
> > > > > > struct <object-name> {
> > > > > >       /* used by libbpf's skeleton API */
> > > > > >       struct bpf_object_skeleton *skeleton;
> > > > > >       /* bpf_object for libbpf APIs */
> > > > > >       struct bpf_object *obj;
> > > > > >       struct {
> > > > > >               /* for every defined map in BPF object: */
> > > > > >               struct bpf_map *<map-name>;
> > > > > >       } maps;
> > > > > >       struct {
> > > > > >               /* for every program in BPF object: */
> > > > > >               struct bpf_program *<program-name>;
> > > > > >       } progs;
> > > > > >       struct {
> > > > > >               /* for every program in BPF object: */
> > > > > >               struct bpf_link *<program-name>;
> > > > > >       } links;
> > > > > >       /* for every present global data section: */
> > > > > >       struct <object-name>__<one of bss, data, or rodata> {
> > > > > >               /* memory layout of corresponding data section,
> > > > > >                * with every defined variable represented as a struct field
> > > > > >                * with exactly the same type, but without const/volatile
> > > > > >                * modifiers, e.g.:
> > > > > >                */
> > > > > >                int *my_var_1;
> > > > > >                ...
> > > > > >       } *<one of bss, data, or rodata>;
> > > > > > };
> > > > >
> > > > > I think I understand how this is useful, but perhaps the problem here
> > > > > is that we're using C for everything, and simple programs for which
> > > > > loading the ELF is majority of the code would be better of being
> > > > > written in a dynamic language like python?  Would it perhaps be a
> > > > > better idea to work on some high-level language bindings than spend
> > > > > time writing code gens and working around limitations of C?
> > > >
> > > > None of this work prevents Python bindings and other improvements, is
> > > > it? Patches, as always, are greatly appreciated ;)
> > >
> > > This "do it yourself" shit is not really funny :/
> > >
> > > I'll stop providing feedback on BPF patches if you guy keep saying
> > > that :/ Maybe that's what you want.
> > >
> > > > This skeleton stuff is not just to save code, but in general to
> > > > simplify and streamline working with BPF program from userspace side.
> > > > Fortunately or not, but there are a lot of real-world applications
> > > > written in C and C++ that could benefit from this, so this is still
> > > > immensely useful. selftests/bpf themselves benefit a lot from this
> > > > work, see few of the last patches in this series.
> > >
> > > Maybe those applications are written in C and C++ _because_ there
> > > are no bindings for high level languages. I just wish BPF programming
> > > was less weird and adding some funky codegen is not getting us closer
> > > to that goal.
> > >
> > > In my experience code gen is nothing more than a hack to work around
> > > bad APIs, but experiences differ so that's not a solid argument.
> > *nod*
> >
> > We have a nice set of C++ wrappers around libbpf internally, so we can do
> > something like BpfMap<key type, value type> and get a much better interface
> > with type checking. Maybe we should focus on higher level languages instead?
> > We are open to open-sourcing our C++ bits if you want to collaborate.
> 
> Python/C++ bindings and API wrappers are an orthogonal concerns here.
> I personally think it would be great to have both Python and C++
> specific API that uses libbpf under the cover. The only debatable
> thing is the logistics: where the source code lives, how it's kept in
> sync with libbpf, how we avoid crippling libbpf itself because
> something is hard or inconvenient to adapt w/ Python, etc.

[..]
> The problem I'm trying to solve here is not really C-specific. I don't
> think you can solve it without code generation for C++. How do you
> "generate" BPF program-specific layout of .data, .bss, .rodata, etc
> data sections in such a way, where it's type safe (to the degree that
> language allows that, of course) and is not "stringly-based" API? This
> skeleton stuff provides a natural, convenient and type-safe way to
> work with global data from userspace pretty much at the same level of
> performance and convenience, as from BPF side. How can you achieve
> that w/ C++ without code generation? As for Python, sure you can do
> dynamic lookups based on just the name of property/method, but amount
> of overheads is not acceptable for all applications (and Python itself
> is not acceptable for those applications). In addition to that, C is
> the best way for other less popular languages (e.g., Rust) to leverage
> libbpf without investing lots of effort in re-implementing libbpf in
> Rust.
I'd say that a libbpf API similar to dlopen/dlsym is a more
straightforward thing to do. Have a way to "open" a section and
a way to find a symbol in it. Yes, it's a string-based API,
but there is nothing wrong with it. IMO, this is easier to
use/understand and I suppose Python/C++ wrappers are trivial.

As for type-safety: it's C, forget about it :-)
