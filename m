Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B87B1FB816
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfKMSvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:51:20 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35800 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbfKMSvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 13:51:20 -0500
Received: by mail-qk1-f193.google.com with SMTP id i19so2713243qki.2;
        Wed, 13 Nov 2019 10:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A+9EBWCze17gVmYr0IvvZOoYtuWUZVAsTSWta4+4FM4=;
        b=Eo7GWVpFWK7UBSIr7Bu2zI+Xia96Z+uGHbF9j7IraQj58z75Qxo/RlMWD3slm5e2J1
         1itCOSxvQvjXWr235spqyIbCV0Z3tWjrFTLoJ5awr6gU762TaiQNBq8oCFdCgTltXMoa
         elDfL/bTeDW4Es4no6xWSLRyu2xWjUox4x76GS47+4xVsQk3kyqNPwBG59y3qtsffS2R
         PdJUpT5lIILxWmhSTlcViuB8ho/28y3Li6eRXdtqsS3nqonQMM46FD5bQlVJRU6igyk2
         V+xQw5Zduu/kAtgn4kYneoHHpKwjuiADYfwhfQsrWTXcwuoxGE3D8+fKRLK3bKQqZ6M1
         xArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A+9EBWCze17gVmYr0IvvZOoYtuWUZVAsTSWta4+4FM4=;
        b=eU4o5Az2jN2oU3WxUKzILcDR03j/emjWDv/Ooekz+2zpJeKuCBWi29ypOtXOVYClPq
         hCvDaveSCCuE3SAIHxT4uzmPqNT+j39QOMLaBd8SXDDjJM/X2JvrtDFXGgWl+zbvjsJt
         G8dBFA4NIqSrIDAtC6sQvImHmwFdykGTB/N1F3abTS7pyNjMRtFBS19pvdccr7UCrfJv
         a5QghFlevUNpAp4JZwo7bIAGCWZvOxGs+TxsC3B8kFEyO9KioUdKbSy0bNYBzOwjBXLC
         +DUmZqPJiRJGcuDH3ZbmO7YKwHvzC2/1PlNF8CHv40XlT12VosFp2tyGszOVsN6oQMJ0
         YbRw==
X-Gm-Message-State: APjAAAURs1Ox9vXWlXA+5OtUXZyYEFmlgULVgeuf15LCu8pdVFNJWtbl
        T3leUmk78K29pOgTfKbVjGZgON7V6Aj9Y/olKj8=
X-Google-Smtp-Source: APXvYqzj56a2MBkTjsIDZfZRBjncUqMhhHrxuag2IIQFTWBtez0qUa1+IRmkecTpxn16J6lhv3pWxl3sPgdg7Jwc81U=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr3920402qkj.39.1573671078783;
 Wed, 13 Nov 2019 10:51:18 -0800 (PST)
MIME-Version: 1.0
References: <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk> <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk> <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk> <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk> <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <8c251f3d-67bd-9bc2-8037-a15d93b48674@solarflare.com> <20191112231822.o3gir44yskmntgnq@ast-mbp.dhcp.thefacebook.com>
 <0c90adc4-5992-8648-88bf-4993252e8992@solarflare.com>
In-Reply-To: <0c90adc4-5992-8648-88bf-4993252e8992@solarflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 Nov 2019 10:51:07 -0800
Message-ID: <CAEf4BzZesSqGVf4FYodfuQz3VnWiyJe4CdN4=sVuYtt891kh5w@mail.gmail.com>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
To:     Edward Cree <ecree@solarflare.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 10:30 AM Edward Cree <ecree@solarflare.com> wrote:
>
> On 12/11/2019 23:18, Alexei Starovoitov wrote:
> > On Tue, Nov 12, 2019 at 09:25:06PM +0000, Edward Cree wrote:
> >> Fwiw the 'natural' C way of doing it would be that for any extern symbol in
> >>  the C file, the ELF file gets a symbol entry with st_shndx=SHN_UNDEF, and
> >>  code in .text that uses that symbol gets relocation entries.  That's (AIUI)
> >>  how it works on 'normal' architectures, and that's what my ebld linker
> >>  understands; when it sees a definition in another file for that symbol
> >>  (matched just by the symbol name) it applies all the relocations of the
> >>  symbol to the appropriate progbits.
> >> I don't really see what else you could define 'extern' to mean.
> > That's exactly the problem with standard 'extern'. ELF preserves the name only.
> > There is no type.
> But if you have BTFs, then you can look up each symbol's type at link time and
>  check that they match.  Point being that the BTF is for validation (and

There is no BTF for extern right now, though. Not even expected size
(for extern variables), it's always zero. So until we have BTF emitted
with type information for externs (either variable or funcs), there is
not "expected type", it's just a name of a symbol.

>  therefore strictly optional at this point) rather than using it to identify a
>  symbol.  Trouble with the latter is that BTF ids get renumbered on linking, so
>  any references to them have to change, whereas symbol names stay the same.
>
> > There is also
> > no way to place extern into a section. Currently SEC("..") is a standard way to
> > annotate bpf programs.
> While the symbol itself doesn't have a section, each _use_ of the symbol has a
>  reloc, and the SHT_REL[A] in which that reloc resides has a sh_info specifying
>  "the section header index of the section to which the relocation applies."  So
>  can't that be used if symbol visibility needs to depend on section?  Tbh I
>  can't exactly see why externs need placing in a section in the first place.

That reloc section is a section in which the **code** that uses extern
is located. It's always going to be program or sub-program section, so
not that useful.

With section names for externs, we can use them as a namespace of
sorts, specifying whether the symbol has to come from kernel itself,
some named BPF object (where name comes from section name as well), or
from libbpf itself. This can be specified if symbol name is ambiguous
and defined in multiple places. Or always just for explicitness.

>
> > I think reliable 'extern' has to have more than just
> > name. 'extern int foo;' can be a reference to 'int foo;' in another BPF ELF
> > file, or it can be a reference to 'int foo;' in already loaded BPF prog, or it
> > can be a reference to 'int foo;' inside the kernel itself, or it can be a
> > reference to pseudo variable that libbpf should replace. For example 'extern
> > int kernel_version;' or 'extern int CONFIG_HZ;' would be useful extern-like
> > variables that program might want to use. Disambiguating by name is probably
> > not enough. We can define an order of resolution. libbpf will search in other
> > .o first, then will search in loaded bpf progs, than in kernel, and if all
> > fails than will resolve things like 'extern int CONFIG_HZ' on its own. It feels
> > fragile though.
> It sounds perfectly reasonable and not fragile to me.  The main alternative
>  I see, about equally good, is to not allow defining symbols that are already
>  (non-weakly) defined; so if a bpf prog tries to globally declare "int CONFIG_HZ"
>  or "int netif_receive_skb(struct sk_buff *skb)" then it gets rejected.
>
> > I think we need to be able to specify something like section to
> > extern variables and functions.
> It seems unnecessary to have the user code specify this.  Another a bad
>  analogy: in userland C code you don't have to annotate the function protos in
>  your header files to say whether they come from another .o file, a random
>  library or the libc.  You just declare "a function called this exists somewhere
>  and we'll find it at link time".

With userspace linking, you control which libraries you are trying to
resolve against. Here it might be against any loaded BPF object in a
system. One way around this would be to specify object names to check
(or kernel) programmatically to libbpf on open/load, but it would be
good to be able to do that declaratively as well, IMO.

>
> > I was imagining that the verifier will do per-function verification
> > of program with sub-programs instead of analyzing from root.
> Ah I see.  Yes, that's a very attractive design.
>
> If we make it from a sufficiently generic idea of pre/postconditions, then it
>  could also be useful for e.g. loop bodies (user-supplied annotations that allow
>  us to walk the body only once instead of N times); then a function call just
>  gets standard pre/postconditions generated from its argument types if the user
>  didn't specify something else.
>
> That would then also support things like:
> > The next step is to extend this thought process to integers.
> > int foo(struct xdp_md *arg1, int arg2);
> > The verifier can check that the program is valid for any valid arg1 and
> > arg2 = mark_reg_unbounded().
> ... this but arg2 isn't unbounded.
> However, it might be difficult to do this without exposing details of the
>  verifier into the ABI.  Still, if we can it sounds like it would make John
>  quite happy too.  And of course it doesn't need to have the user annotations
>  from the beginning, it can start out as just the kernel generating pre/post
>  conditions internally.
>
> -Ed
