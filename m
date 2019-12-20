Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6696312798F
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLTKrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:47:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58942 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727177AbfLTKrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 05:47:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576838834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YDedGYVhjV1dEC3uGlEKCLOvO8avCFPJflHV93WfQ/I=;
        b=UlnfE1ff84+Okk8RbbuUfMhz64PftL+Va4CbAbqswZCY1jGgBspVXnsP7OM1t7Kr9mNJYT
        G4ydnQ4m8VceOV+V8L7UDPbjCLqZP3QIAm1CUBsPod50ttnv//0UAboO7QabH26idppNOJ
        kyv+ktnuWTYJT8eJSfRPgp2Cqakaqk8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-cbzF8lh9Mi2-QPR2YXGjug-1; Fri, 20 Dec 2019 05:47:13 -0500
X-MC-Unique: cbzF8lh9Mi2-QPR2YXGjug-1
Received: by mail-lj1-f197.google.com with SMTP id l2so2513709lje.14
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 02:47:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=YDedGYVhjV1dEC3uGlEKCLOvO8avCFPJflHV93WfQ/I=;
        b=X3p1c6XFzLH/b8a/XHLXI9sD4OMfsJUgv5z3y1Ssk6zVhqzZ0x+9b5lDdlJJaK2pGB
         PZjsyDvaHB/BUHEgKhM0pH7v/EBMAGbL+KYPUlSup+teriAEPQmfqnipEeP5TYA+nVhI
         ZYhhCkXgNxT/kqfG2aTqDf6r6zRAIKOg47XHnju48gnr5yPLNKVbsVpQPHj1jujTxhgW
         4ZKJNvspVP5rQ1B+rQWbZy1S7/Aj6hsQnsNR+ibtxq36v5bVACrRa9PZTSHaRsXODefQ
         fSZWgd6TgQsobK1+vCAD3+/ol3Ean7g8XT5TnKODrLjnQacJ8743Oqtc1tIApzga4QaV
         t3iA==
X-Gm-Message-State: APjAAAVxd3gm8KH1faXA1CkEwp0SiCM5hrSH9z4j5axxaTKJYUAdTMS0
        nSnGjzrGllMgxupxfqwRfiMEjbschiZIzyvicwx2dyMKo1IsR5ql4G+x3d6iCojW/tt76pvwYb1
        5hQa8hVsPC70CWoFo
X-Received: by 2002:a2e:9a01:: with SMTP id o1mr8826366lji.247.1576838831807;
        Fri, 20 Dec 2019 02:47:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqyuxub8KraSDCPxOgfp5mivvgakIHX5fLXk8eGW0yqQnlVyjhGk9QQ9J+pJ9iGqiqjCmvXWPg==
X-Received: by 2002:a2e:9a01:: with SMTP id o1mr8826346lji.247.1576838831546;
        Fri, 20 Dec 2019 02:47:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id h19sm4075211ljk.44.2019.12.20.02.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 02:47:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C6DF2180969; Fri, 20 Dec 2019 11:47:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 2/3] libbpf: Handle function externs and support static linking
In-Reply-To: <CAEf4BzZYOrXQFtVbqhw7PagzT6VhfM5LRV93cLuzABy8eHWyqw@mail.gmail.com>
References: <157676577049.957277.3346427306600998172.stgit@toke.dk> <157676577267.957277.6240503077867756432.stgit@toke.dk> <CAEf4BzZYOrXQFtVbqhw7PagzT6VhfM5LRV93cLuzABy8eHWyqw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 20 Dec 2019 11:47:09 +0100
Message-ID: <87h81v2s0i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Dec 19, 2019 at 6:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> This adds support for resolving function externs to libbpf, with a new A=
PI
>> to resolve external function calls by static linking at load-time. The A=
PI
>> for this requires the caller to supply the object files containing the
>> target functions, and to specify an explicit mapping between extern
>> function names in the calling program, and function names in the target
>> object file. This is to support the XDP multi-prog case, where the
>> dispatcher program may not necessarily have control over function names =
in
>> the target programs, so simple function name resolution can't be used.
>>
>> The target object files must be loaded into the kernel before the calling
>> program, to ensure all relocations are done on the target functions, so =
we
>> can just copy over the instructions.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> A bunch of this code will change after you update to latest Clang with
> proper type info for extern functions. E.g., there shouldn't be any
> size/alignment for BTF_KIND_FUNC_PROTO, it's illegal. But that
> Yonghong already mentioned.

Yup, that fix should be helpful.

> As for the overall approach. I think doing static linking outside of
> bpf_object opening/loading is cleaner approach. If we introduce
> bpf_linker concept/object and have someting like
> bpf_linked__new(options) + a sequence of
> bpf_linker__add_object(bpf_object) + final bpf_linker__link(), which
> will produce usable bpf_object, as if bpf_object__open() was just
> called, it will be better and will allow quite a lot of flexibility in
> how we do things, without cluttering bpf_object API itself.

Hmm, that's not a bad idea, actually. To me it would make more sense
with an API like:

linker =3D bpf_linker__new(bpf_prog, opts); // start linking of bpf_prog
bpf_linker__resolve_func_static(linker, "func1", other_obj, "tgt_funcname");
bpf_linker__resolve_func_dynamic(linker, "func1", prog_fd);

new_obj =3D bpf_linker__finish();

I'll look into that when I pick this up again after the holidays :)

> Additionally, we can even have bpf_linker__write_file() to emit a
> final ELF file with statically linked object, which can then be loaded
> through bpf_object__open_file (we can do the same for in-memory
> buffer, of course). You can imagine LLC some day using libbpf to do
> actual linking of BPF .o files into a final BPF executable/object
> file, just like you expect it to do for non-BPF object files. WDYT?

Hmm, yeah, I don't see why we shouldn't be able to get there in the
future. Don't really have an opinion on whether it would be useful for
LLC to pull in the libbpf linker functions, though; maybe? :)

> Additionally, and seems you already realized that as well (judging by
> FIXMEs), we'll need to merge those individual objects' BTFs and
> deduplicate them, so that they form coherent set of types.

Yes, will have to look into this; any reason the existing de-duplication
code can't be reused here? I.e., could we just copy over all the BTF
info from the target object, and then run the de-duplication logic to
narrow it back down to one coherent set? Or would something different be
needed?

> Adjusting line info/func info is mandatory as well.

Yes, seems just copying it was not enough; will happily admit I was just
cargo-culting that bit ;) Guess I'll need to go figure out how line/func
info is actually supposed to work...

> Another thing we should think through is sharing maps. With
> BTF-defined maps, it should be pretty easy to have declaration vs
> definiton of maps. E.g.,
>
> prog_a.c:
>
> struct {
>     __uint(type, BPF_MAP_TYPE_ARRAY);
>     __uint(max_entries, 123);
>     ... and so on, complete definition
> } my_map SEC(".maps");
>
> prog_b.c:
>
> extern struct {
>     ... here we can discuss which pieces are necessary/allowed,
> potentially all (and they all should match, of course) ...
> } my_map SEC(".maps");
>
> prog_b.c won't create a new map, it will just use my_map from
> prog_a.c.

Ah, yes, that could be interesting. I guess we could use the same
"should I re-use" logic as we're doing for pinning map reuse (and
augment that to consider BTF as well in the process).

Is the existing llvm support sufficient to just mark a map struct as
'extern', or would something new be needed? Would it be enough to just
augment the bpf_object__init_user_btf_maps() to look for extern symbols?

> I might be missing something else as well, but those are the top things, =
IMO.

Right; let's see if that is not enough to at least get to an MVP for
linking. We can always improve things later :)

> I hope this is helpful.

Certainly! Thanks for the feedback!

-Toke

