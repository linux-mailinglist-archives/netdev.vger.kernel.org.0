Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E266836138E
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhDOUgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbhDOUgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:36:18 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0674FC061574;
        Thu, 15 Apr 2021 13:35:54 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v72so6893398ybe.11;
        Thu, 15 Apr 2021 13:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Beg3Gx3LsLmbkpTm4ZfTRdcR9LPJsrn/BvQEGJl7wOE=;
        b=RaHW/XBDAYR+au3FvYrrd49n/ctyt933e05EQKkobuj3UYO42RAHABTRk9HKtlkNKl
         WMHvhse74RJrS+Yccu169FducX+73ma5mkqyMTXXBUrQv0yu3fqm8LZNXvS8OEf6GYUQ
         xQtFIE+CVOGBLFZwGgT6vTV1/++QdeIkeFVrPrXGQqe9aoDkyg6gH8GGGT8XfsuJ78JC
         Fimj269ESIVulmmGZVXdMgYalg5uuR/sjfUGbUt0nycDxf3hENxmtRzOqBsWnFc/oTym
         6OAmL0VqWcKR0yf42JxYdVERAYA1zHbTBBAoTEDKXMFmLjti7O2OwfaoH1yTQzIg8p7Z
         6aDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Beg3Gx3LsLmbkpTm4ZfTRdcR9LPJsrn/BvQEGJl7wOE=;
        b=AL/BCNCSUoHrcUt1D2nK6/gqlE5gkfRiGXBkq/uqaSFa3Evxgo+sZevU44yTYK/97/
         Na/UCRTOWHe4Gge/kTdJWNvoxzgupRsiMuOzcYhD/yGWju4UGSEDYkvZr/27vJQV63/E
         b5Yx7X5JKlSNKS4krwKgYJqEfZpnObFnrApfRyRn4756j0BxScsZKigWWEYN9C7g44Ld
         +6+um0xZwhJkr7ZWqVvmEM2Dd78kNg1lloSFiZmcwXZ2hmxmur32Z2UgfVC4lHCIvfyy
         Yl27Yn+hPLkTB0vxDf4Mg4M67ioo2s7BLzFVrJng0YgOlR4u1+K0kcHQfvXhLnAQsw1P
         XTfw==
X-Gm-Message-State: AOAM530kr6TgUKWN2lQK3ozU/FjOSBsew/cV+a7fkQkXsqs7l/fuGboS
        YgIwVOJZF35bLGA7z7KcQ2sqfTPo3/auKUgvRsYExJV/
X-Google-Smtp-Source: ABdhPJxkI5nPdlM6VeX2nqgaf8VpT2FbVy/2LQtHaAZVJfAoOAxbh1BF5YKv3P13ffWvLBOMJaDOwRHO5HqIX3F6vRc=
X-Received: by 2002:a25:dc46:: with SMTP id y67mr7213937ybe.27.1618518954164;
 Thu, 15 Apr 2021 13:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210414200146.2663044-1-andrii@kernel.org> <20210414200146.2663044-13-andrii@kernel.org>
 <f3f3bcc5-be1a-6d11-0c6e-081fc30367c4@fb.com> <CAEf4BzZnyij-B39H_=RahUV2=RzNHTHt4Bdrw2sPY9eraW4p7A@mail.gmail.com>
 <20210415020138.2dbcflpxq2zwu6b2@ast-mbp>
In-Reply-To: <20210415020138.2dbcflpxq2zwu6b2@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Apr 2021 13:35:43 -0700
Message-ID: <CAEf4BzZXLi8Z=4fy5TpH-po-d__7eg6PrgBJWk_3epmT-n3SMA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 12/17] libbpf: support extern resolution for
 BTF-defined maps in .maps section
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 7:01 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Apr 14, 2021 at 04:48:25PM -0700, Andrii Nakryiko wrote:
> > On Wed, Apr 14, 2021 at 3:00 PM Alexei Starovoitov <ast@fb.com> wrote:
> > >
> > > On 4/14/21 1:01 PM, Andrii Nakryiko wrote:
> > > > Add extra logic to handle map externs (only BTF-defined maps are supported for
> > > > linking). Re-use the map parsing logic used during bpf_object__open(). Map
> > > > externs are currently restricted to always and only specify map type, key
> > > > type and/or size, and value type and/or size. Nothing extra is allowed. If any
> > > > of those attributes are mismatched between extern and actual map definition,
> > > > linker will report an error.
> > >
> > > I don't get the motivation for this.
> > > It seems cumbersome to force users to do:
> > > +extern struct {
> > > +       __uint(type, BPF_MAP_TYPE_HASH);
> > > +       __type(key, key_type);
> > > +       __type(value, value_type);
> > > +       /* no max_entries on extern map definitions */
> > > +} map1 SEC(".maps");
> >
> > The intent was to simulate what you'd have in a language with
> > generics. E.g., if you were declaring extern for a map in C++:
> >
> > extern std::map<key_type, value_type> my_map;
>
> right, because C++ will mangle types into names.
> When llvm bpf backend will support C++ front-end it will do the mangling too.
> I think BPF is ready for C++, but it's a separate discussion, of course.
>
> > > but there is only one such full map definition.
> > > Can all externs to be:
> > > extern struct {} map1 SEC(".maps");
> >
> > I can certainly modify logic to allow this. But for variables and
> > funcs we want to enforce type information, right? So I'm not sure why
> > you think it's bad for maps.
>
> I'm not saying it's bad.
> Traditional linker only deals with names, since we're in C domain, so far,
> I figured it's an option, but more below.
> C++ is good analogy too.
>
> > So if it's just a multi-file application and you don't care which file
> > declares that map, you can do a single __weak definition in a header
> > and forget about it.
> >
> > But imagine a BPF library, maintained separately from some BPF
> > application that is using it. And imagine that for some reason that
> > BPF library wants/needs to "export" its map directly. In such case,
> > I'd imagine BPF library author to provide a header with pre-defined
> > correct extern definition of that map.
>
> I'm mainly looking at patch 17 and thinking how that copy paste can be avoided.
> In C and C++ world the user would do:
> defs.h:
>   struct S {
>     ...
>   };
>   extern struct S s;
> file.c:
>   #include "defs.h"
>   struct S s;
> and it would work, but afaics it won't work for BPF C in patch 17.

Yes, you are right, there is no clean way to avoid defining extern and
full map definition. Which is the case for functions and variables,
except those type signatures tend to be shorter. E.g., if you had

void my_func(int arg) { ... }

you'd still have to duplicate it as at least:

extern void my_func(int);

I don't think you can use typedef for this either.

> If the user does:
> defs.h:
>   struct my_map {
>           __uint(type, BPF_MAP_TYPE_HASH);
>           __type(key, struct my_key);
>           __type(value, struct my_value);
>           __uint(max_entries, 16);
>   };
>   extern struct my_map map1 SEC(".maps");
> file.c:
>   #include "defs.h"
>   struct my_map map1;  // do we need SEC here too? probably not?

yeah, we do, all map "variables" are designated with .maps section,
otherwise they'll be treated as just a normal global variable (there
is no way to distinguish two, generally speaking).

>
> It won't work for another_filer.c since max_entries are not allowed?
> Why, btw?

So the idea was that for consumers of extern map definition map type
and key/value info was the only thing they should care about and
linker should enforce (at least that's how I thought about this and
what I think the typical use case would be). E.g., caring about exact
max_entries, or numa_node, or pinning, or map_flags, etc, shouldn't be
the concern of the consumer of the map.

>
> So how the user suppose to do this? With __weak in .h ?
> But if that's the only reasonable choice whe bother supporting extern in the linker?
>
> > I originally wanted to let users define which attributes matter and
> > enforce them (as I mention in the commit description), but that
> > requires some more work on merging BTF. Now that I'm done with all the
> > rest logic, I guess I can go and address that as well.
>
> I think that would be overkill. It won't match neither C style nor C++.
> Let's pick one.

So I still think we might want to implement it down the road, but
let's stick to something simpler for now. See below.

>
> > So see above about __weak. As for the BPF library providers, that felt
> > unavoidable (and actually desirable), because that's what they would
> > do with extern func and extern vars anyways.
>
> As far as supporting __weak for map defs, I think __weak in one file.c
> should be weak for all attributes. Another_file.c should be able
> to define the same map name without __weak and different types, value/type
> sizes. Because why not? Sort-of C++ style of override.

That's a significant deviation from semantics of weak variables and
functions, but I can see how it's useful. E.g., we can have some
potentially compiled out big map definition, but a __weak fallback to
a small, but compatible one.

>
> > so forcing to type+key+value is to make sure that currently all
> > externs (if there are many) are exactly the same. Because as soon as I
> > allow some to specify max_entries and some don't,
>
> I don't get why max_entries is special.
> They can be overridden in typical skeleton usage. After open and before load.
> So max_entries is a default value in map init. Whether it's part of
> extern or not why should that matter?

This is just a source code-level contract. You can override any
attribute of the map at runtime from user-space code. You can even
replace one map with an entirely different map (using
bpf_map__reuse_fd()). You can change type, etc, etc. The goal here is
to not prevent the abuse (I don't think it's possible at linking
stage, but at least BPF verifier will stop from something totally
stupid), rather for a typical case to make sure that there is no
accidental mismatch at the C code level.

>
> > Maybe nothing, just there is no single right answer (except the
> > aspirational implementation I explained above). I'm open to
> > discussion, btw, not claiming my way is the best way.
>
> I'm not suggesting that extern struct {} my_map; is the right answer either.
> Mainly looking into how user code will look like and trying to
> make it look the most similar to how C, C++ code traditionally looks.
> BPF C is reduced and extended C at the same time.
> BPF C++ will be similar. Certain features will be supported right away,
> some others will take time.
> I'm looking at BTF as a language independent concept.
> Both C and C++ will rely on it.
>
> To summarize if max_entries can be supported and ingored in extern
> when the definition has a different value then it's probably good to enforce
> that the rest of map fields are the same. Then my .h/.c example above will work.
> In case of __weak probably all map fields can change.
> It can be seen as a weak definition of the whole map. Not just weak of the variable.
> It's a default for everything that can be overridden.
> While non-weak can override max_entries only.

How about we start in the most restrictive way first. Each extern
would need to specify all the attributes that should match the map
definition. That includes max_entries. That way the typedef struct {
... } my_map_t re-use will work right out of the box. Later, if we see
this is not sufficient, we can start relaxing the rules. Ultimately
what I proposed above with selective extern attributes enforcement
would allow to cover any scenario. Granted it's special compared to C
linking style, but given the __weak map definition proposal above also
deviates significantly, we can just treat maps specially, but in a
"makes sense" way.

>
> btw for signed progs I'm thinking to allow override of max_entries only,
> since this attribute doesn't affect safety, correctness, behavior.
> Meaning max_entries will and will not be part of a signature at the same time.
> In other words it's necessary to support existing bcc/libbpf-tools.
> If we go with 'allow max_entries in extern' that would match that behavior.

Ok, unless I misunderstood, allowing and checking all map attributes
as a starting point should work, right?
