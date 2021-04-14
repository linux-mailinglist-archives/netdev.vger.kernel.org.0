Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194FC35FE96
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhDNXtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhDNXtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 19:49:00 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA34CC061574;
        Wed, 14 Apr 2021 16:48:36 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p3so3433494ybk.0;
        Wed, 14 Apr 2021 16:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0/vPE18xMY4lM2olpoRKj6HDx+ovOHiE7PvZtTg5Jw8=;
        b=MPi+KvwUgnzMbVGey68p6kbyzY69T8MGrQOU1CDlTzgV0fFSukkAuV3Cbvg94/07X4
         1DiR38ZgjXCsiVdI4cmoqYep1oc+S69yd2IB456Xnca0/crePwJF0ZiRA41aHJhY60oY
         pGBZ75gyHn8Ta0Q59usfpvfsPglHw+87z234RInAZrj5nuofLqwk5NCZrKF3nPMpNHbf
         BMqOuzbLpPW/NgU0giuImJ5tupIguTzfnMDfkUdpPPQH8pSyrokdP3xBxEHskE+GJQy7
         LAl1jw/K2nT6v4FtadrBwaaCHWYAqwlvVtQ4C2ceasv8l/0rz6bzDgWSl3gFItsYFGsY
         WfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0/vPE18xMY4lM2olpoRKj6HDx+ovOHiE7PvZtTg5Jw8=;
        b=m8OFnfTPxzPTdVHDSIt/+mvNjAduNlVH+EFEPioeGQAEcf7C+CtHnIlInYo1nzMAny
         KPs30XH2rZ6EGO52WB2FuflOdpSGmpL9AiEQSyxoWuWXgK6kjXT9RaEkchIAponog1FA
         YtDmr5x3HIuqMEZ7f7+hpS+kOk/WBPvHtVQAkecw5LDILK+IGgMWlSDa5zhaCG9hvDxg
         WG3qzwWp7oicfYKS0DGRg/YDGGKO033pj3M59sTQJj0N4Fb2A8qhdYSCoWOiCcvNnX7Z
         GQu/kWqy6Ni2ZShGCaabJ2gIzwM2C7xG1YUB373X+Hfx8bvf8MsftMGSCpuvRyiOLd1+
         0v7g==
X-Gm-Message-State: AOAM531sBsgBiVWScn1TCDfzDzHEgYM+DTSEoDPNpAPEPK1uoWfeVP9y
        teoPE9E1atfa0AoI2J9ze6gxYi53Vn+knYeOFNg=
X-Google-Smtp-Source: ABdhPJyitHTtVuRTq1lodwuaiogp+w3zns01qUb1Mx2G+STLCKKDnHiY1JLsAgIijnCqJY8WdddDFLby+8vZGPk3DHM=
X-Received: by 2002:a25:5b55:: with SMTP id p82mr705910ybb.510.1618444116088;
 Wed, 14 Apr 2021 16:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210414200146.2663044-1-andrii@kernel.org> <20210414200146.2663044-13-andrii@kernel.org>
 <f3f3bcc5-be1a-6d11-0c6e-081fc30367c4@fb.com>
In-Reply-To: <f3f3bcc5-be1a-6d11-0c6e-081fc30367c4@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Apr 2021 16:48:25 -0700
Message-ID: <CAEf4BzZnyij-B39H_=RahUV2=RzNHTHt4Bdrw2sPY9eraW4p7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 12/17] libbpf: support extern resolution for
 BTF-defined maps in .maps section
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 3:00 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 4/14/21 1:01 PM, Andrii Nakryiko wrote:
> > Add extra logic to handle map externs (only BTF-defined maps are supported for
> > linking). Re-use the map parsing logic used during bpf_object__open(). Map
> > externs are currently restricted to always and only specify map type, key
> > type and/or size, and value type and/or size. Nothing extra is allowed. If any
> > of those attributes are mismatched between extern and actual map definition,
> > linker will report an error.
>
> I don't get the motivation for this.
> It seems cumbersome to force users to do:
> +extern struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __type(key, key_type);
> +       __type(value, value_type);
> +       /* no max_entries on extern map definitions */
> +} map1 SEC(".maps");

The intent was to simulate what you'd have in a language with
generics. E.g., if you were declaring extern for a map in C++:

extern std::map<key_type, value_type> my_map;

You'd want a linker to make sure that actual my_map definition to
conform to your expectations, no?

>
> > The original intent was to allow for extern to specify attributes that matters
> > (to user) to enforce. E.g., if you specify just key information and omit
> > value, then any value fits. Similarly, it should have been possible to enforce
> > map_flags, pinning, and any other possible map attribute. Unfortunately, that
> > means that multiple externs can be only partially overlapping with each other,
> > which means linker would need to combine their type definitions to end up with
> > the most restrictive and fullest map definition.
>
> but there is only one such full map definition.
> Can all externs to be:
> extern struct {} map1 SEC(".maps");

I can certainly modify logic to allow this. But for variables and
funcs we want to enforce type information, right? So I'm not sure why
you think it's bad for maps.

>
> They can be in multiple .o files, but one true global map def
> should have all the fields and will take the precedence during
> the linking.

So if it's just a multi-file application and you don't care which file
declares that map, you can do a single __weak definition in a header
and forget about it.

But imagine a BPF library, maintained separately from some BPF
application that is using it. And imagine that for some reason that
BPF library wants/needs to "export" its map directly. In such case,
I'd imagine BPF library author to provide a header with pre-defined
correct extern definition of that map.

It's the same situation as with extern functions. You are either
copy/pasting exact function signature or providing it through some
common header. BPF map definition is just slightly more verbose.


>
> The map type, key size, value size, max entries are all irrelevant
> during compilation. They're relevant during loading, but libbpf is
> not going to load every .o individually. So "extern map" can
> have any fields it wouldn't change the end result after linking.
> May be enforce that 'extern struct {} map' doesn't have
> any fields defined instead?

It's easy for me to do that as well, it's just a question of what
behavior makes more sense and what are we trying to achieve. Of course
during the compilation itself it doesn't matter that's the type of map
is or what key/value type/size is. But from the programmer's point of
view, when I do lookup/update, I'd like to know that my map
corresponds to my understanding. So if I assume 4-byte key, and
16-byte value and allocate stack variables according to that
understanding, yet something changes about BPF map definition, I'd
rather notice that during linking, than maybe notice during BPF
verification. So that was the only motivation: catch mismatch earlier.
I originally wanted to let users define which attributes matter and
enforce them (as I mention in the commit description), but that
requires some more work on merging BTF. Now that I'm done with all the
rest logic, I guess I can go and address that as well. So that would
support cases from:

extern struct {} my_map SEC(".maps");

to

extern struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __type(key, int);
    __type(value, struct value_type);
    __uint(map_flags, BPF_F_MMAPABLE); /* because I care for whatever reason */
    __uint(pinning, LIBBPF_PIN_BY_NAME); /* because I can */
} my_peculiar_map SEC(".maps");


But basically, if we allow only `extern struct {} my_map
SEC(".maps");`, why do I even bother with BTF in that case?


> It seems asking users to copy-paste map defs in one file and in all
> of extern is just extra hassle.

So see above about __weak. As for the BPF library providers, that felt
unavoidable (and actually desirable), because that's what they would
do with extern func and extern vars anyways. And that's what we do
with C code today, except linker is oblivious to types (because no BTF
in user-space C world).

> The users wouldn't want to copy-paste them for production code,
> but will put map def into .h and include in multiple .c,
> but adding "extern " in many .c-s and not
> adding that "extern " is the main .c is another macro hassle.
> Actually forcing "no max_entries in extern" is killing this idea.

so forcing to type+key+value is to make sure that currently all
externs (if there are many) are exactly the same. Because as soon as I
allow some to specify max_entries and some don't, then depending on
the order in which I see those externs (before actual definition),
I'll need to merge their definitions (worst case), or at least pick
the most complete one. It's doable, but felt unnecessary for the first
iteration.

> So it's mandatory copy-paste or even more macro magic with partial
> defs of maps?
> What am I missing?

Maybe nothing, just there is no single right answer (except the
aspirational implementation I explained above). I'm open to
discussion, btw, not claiming my way is the best way.
