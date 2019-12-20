Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4F612816E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLTR3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:29:01 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:35103 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbfLTR3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:29:00 -0500
Received: by mail-qv1-f67.google.com with SMTP id u10so3838013qvi.2;
        Fri, 20 Dec 2019 09:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5t1TeBIMmhwycAbxoQRw2bQj3rNWWlmJfxaqKNbI5HY=;
        b=VT/SwXIFeeXJP51rnejgcqjFkOyYhrs/qlQGrwQsQKca8DNgWQLQdI0tMOItxdm5T4
         FQLBfsM3ZhJox19NkTohuUnaojI/k9dj46tsiwS2SdWoAoFH1IpUWTLcPd/p/MpkOCyK
         t1f5y8YMFm8ehKkQypoBEW/sCVlXrGY+Wi9DpT+RXU2ef48+NDMp+Aop4lWX1/DfPxoL
         ogbJ3hbs1YH/XI3RPejCSnncW2ODbTyb94ww8dJM4rK1vjCq5bX0wQLA4Befpr6xNOVI
         Qi3/qOUk1mpMYAhduM0zD2l6ByxK0ZKUbiotYJvQAVRLCX9F/Mykpw7RqDUbc4r2h0jL
         DBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5t1TeBIMmhwycAbxoQRw2bQj3rNWWlmJfxaqKNbI5HY=;
        b=unD/x+ro06Cad6viVc6ksLi4U1aKdjMHn7cfgfoZ1cg6EU+sMDLZW8JMrAA3Fxp2OJ
         cs806MIJG1ZhIcUFAQXxkqa2vlmWlTpfm2Kzn7OEk4zjQtdVkfXwff0R/ktQndOsOwrF
         X1aPBaIFt9LbB9J08KhggmkU1+ho5rfABFPKuU+V0x8ZfLfrC1HpfcxR91fPZCiqO63T
         S7gsQFjAWaQCvJWXTxkani2KaG6srf5bL9ICpAdPtDrxNEb2nt50lA9/QtIVn8A/81XM
         vmws8j0Eq6f6GB7UA8sZO2+yiUNoXCQKvICgnLIrMw6O4X+lU1MXMN4+CL/gS9SkWqYa
         l1Ug==
X-Gm-Message-State: APjAAAXlYQnLGU8nNprB2qKCYL2yJoFwNS2g/BnHexrWkDKxoVSPpYtF
        1RhfrHwgnwCjiVyLBflZdphOtdsvqbGtYlgueBo=
X-Google-Smtp-Source: APXvYqyy/fwoRnT43u3WGuVtCg5xYgYDs7aU4LA+tjm4IyVDVnLiTGT+bKFkTsUJ+ify4G4DN+r41IAtCR3L7e6BfRY=
X-Received: by 2002:a0c:990d:: with SMTP id h13mr13157534qvd.247.1576862939310;
 Fri, 20 Dec 2019 09:28:59 -0800 (PST)
MIME-Version: 1.0
References: <157676577049.957277.3346427306600998172.stgit@toke.dk>
 <157676577267.957277.6240503077867756432.stgit@toke.dk> <CAEf4BzZYOrXQFtVbqhw7PagzT6VhfM5LRV93cLuzABy8eHWyqw@mail.gmail.com>
 <87h81v2s0i.fsf@toke.dk>
In-Reply-To: <87h81v2s0i.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Dec 2019 09:28:48 -0800
Message-ID: <CAEf4BzYU4-ZFkZYcga89yNCT82hXp1=AdhOs7rWxsbgtw_2ZzA@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 2/3] libbpf: Handle function externs and
 support static linking
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 2:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Dec 19, 2019 at 6:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> This adds support for resolving function externs to libbpf, with a new=
 API
> >> to resolve external function calls by static linking at load-time. The=
 API
> >> for this requires the caller to supply the object files containing the
> >> target functions, and to specify an explicit mapping between extern
> >> function names in the calling program, and function names in the targe=
t
> >> object file. This is to support the XDP multi-prog case, where the
> >> dispatcher program may not necessarily have control over function name=
s in
> >> the target programs, so simple function name resolution can't be used.
> >>
> >> The target object files must be loaded into the kernel before the call=
ing
> >> program, to ensure all relocations are done on the target functions, s=
o we
> >> can just copy over the instructions.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > A bunch of this code will change after you update to latest Clang with
> > proper type info for extern functions. E.g., there shouldn't be any
> > size/alignment for BTF_KIND_FUNC_PROTO, it's illegal. But that
> > Yonghong already mentioned.
>
> Yup, that fix should be helpful.
>
> > As for the overall approach. I think doing static linking outside of
> > bpf_object opening/loading is cleaner approach. If we introduce
> > bpf_linker concept/object and have someting like
> > bpf_linked__new(options) + a sequence of
> > bpf_linker__add_object(bpf_object) + final bpf_linker__link(), which
> > will produce usable bpf_object, as if bpf_object__open() was just
> > called, it will be better and will allow quite a lot of flexibility in
> > how we do things, without cluttering bpf_object API itself.
>
> Hmm, that's not a bad idea, actually. To me it would make more sense
> with an API like:
>
> linker =3D bpf_linker__new(bpf_prog, opts); // start linking of bpf_prog

what's bpf_prog her? is it bpf_object or path to some .o file? Also,
for static linking that could be multiple .o files, which will be
merged, so we need to accomodate that.

> bpf_linker__resolve_func_static(linker, "func1", other_obj, "tgt_funcname=
");
> bpf_linker__resolve_func_dynamic(linker, "func1", prog_fd);

It seems like static and dynamic linking are a bit different, though,
so I wouldn't put both of them into bpf_linker. By analogy with
userspace code, there is llc, a static linker, and ld.so, dynamic
linker. They have very different sets of responsibilities and they are
different programs completely.

Static linker puts together inter-connected individual object files
into a single executable (or object file). The end result looks like a
single coherent object file/executable, is if it was all compiled from
single .c file.

Dynamic linker, though, takes already complete single executable, and
then resolves external references to libraries. In BPF case, those
libraries are some other bpf_objects (or maybe even kernel).

So what I'm saying, is that it seems cleaner to have bpf_linker, which
will do static linking only and produce final bpf_object. And then
bpf_object__load() will actually do dynamic linking resolution, based
on extern relocations.

But can you also elaborate why we need this mapping from symbol name
in one object into a completely different name in another object? It
seems to me that for static linking, those should unconditionally
match. Even for dynamic linking, I think we should ensure names match,
otherwise it becomes quite confusing. Do you think ensuring consistent
naming is going to be a big problem?


>
> new_obj =3D bpf_linker__finish();
>
> I'll look into that when I pick this up again after the holidays :)
>
> > Additionally, we can even have bpf_linker__write_file() to emit a
> > final ELF file with statically linked object, which can then be loaded
> > through bpf_object__open_file (we can do the same for in-memory
> > buffer, of course). You can imagine LLC some day using libbpf to do
> > actual linking of BPF .o files into a final BPF executable/object
> > file, just like you expect it to do for non-BPF object files. WDYT?
>
> Hmm, yeah, I don't see why we shouldn't be able to get there in the
> future. Don't really have an opinion on whether it would be useful for
> LLC to pull in the libbpf linker functions, though; maybe? :)
>
> > Additionally, and seems you already realized that as well (judging by
> > FIXMEs), we'll need to merge those individual objects' BTFs and
> > deduplicate them, so that they form coherent set of types.
>
> Yes, will have to look into this; any reason the existing de-duplication
> code can't be reused here? I.e., could we just copy over all the BTF
> info from the target object, and then run the de-duplication logic to
> narrow it back down to one coherent set? Or would something different be
> needed?
>

The algorithm itself will work, but there is a bunch of APIs and
plumbing to be added to support this sort of incremental
deduplication.

> > Adjusting line info/func info is mandatory as well.
>
> Yes, seems just copying it was not enough; will happily admit I was just
> cargo-culting that bit ;) Guess I'll need to go figure out how line/func
> info is actually supposed to work...
>
> > Another thing we should think through is sharing maps. With
> > BTF-defined maps, it should be pretty easy to have declaration vs
> > definiton of maps. E.g.,
> >
> > prog_a.c:
> >
> > struct {
> >     __uint(type, BPF_MAP_TYPE_ARRAY);
> >     __uint(max_entries, 123);
> >     ... and so on, complete definition
> > } my_map SEC(".maps");
> >
> > prog_b.c:
> >
> > extern struct {
> >     ... here we can discuss which pieces are necessary/allowed,
> > potentially all (and they all should match, of course) ...
> > } my_map SEC(".maps");
> >
> > prog_b.c won't create a new map, it will just use my_map from
> > prog_a.c.
>
> Ah, yes, that could be interesting. I guess we could use the same
> "should I re-use" logic as we're doing for pinning map reuse (and
> augment that to consider BTF as well in the process).
>
> Is the existing llvm support sufficient to just mark a map struct as
> 'extern', or would something new be needed? Would it be enough to just
> augment the bpf_object__init_user_btf_maps() to look for extern symbols?

should be, yeah. We have type information for externs, so that should
capture all the info.
>
> > I might be missing something else as well, but those are the top things=
, IMO.
>
> Right; let's see if that is not enough to at least get to an MVP for
> linking. We can always improve things later :)
>
> > I hope this is helpful.
>
> Certainly! Thanks for the feedback!

cool, glad it helped

>
> -Toke
>
