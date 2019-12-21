Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CFD128A63
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 17:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLUQYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 11:24:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28949 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbfLUQYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 11:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576945474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mM/O2UmUWT5pwYtZWXzKYITjKsYGiROXs6Zgo37zdg=;
        b=eKYKpkYa1bTWTv4hrfHAsED87lnMU5h+rjS/anfgiMsCLskd4zghoGQdEZwW6rkrerNcRy
        yaZlDvZ4PTV4LaQMVDP4c6ebrCfTN6WbpKsjGFrLPNJ4a0OHVqUyRDS2AMAaVqvagZH/4e
        RfPMYZF1Uv1qeBZhUkd8T2mVj/bnsOY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299--Gu_pEzQN2C4lJqpIGlxOw-1; Sat, 21 Dec 2019 11:24:33 -0500
X-MC-Unique: -Gu_pEzQN2C4lJqpIGlxOw-1
Received: by mail-lj1-f200.google.com with SMTP id f15so1705097ljj.11
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 08:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0mM/O2UmUWT5pwYtZWXzKYITjKsYGiROXs6Zgo37zdg=;
        b=KHFYpwTAKgRHquse49z4Gq/hRfUV15aI1goagGdFtA9+LJxtZGm/nBOJ2oTY+vdoDP
         yPdMpI30kv8mD0Ys4wxed7MwBFNiV/B5q3vn//u/fjuVp0Cu4GvFPMm4Ow3uNG1bR9Cj
         ISyU/fIFqg2sSzFoz5QVlqRiaYEU/hWojlMocV2gt0vbWC3rbCK7uaWGDhuVq4O4vLD4
         5cr6EJwx5foUwRe49ZvcTQSltC4AwB/f0FkjEhcWJCfXtXDz6J6ULli/SMCCdgK0eGz0
         xffl75pP3nvv98F7g8+SiXEI89loskZlPJQTDRq48Y+WNHvPvsLmYtEnCXvMUCbb6HC+
         XSwQ==
X-Gm-Message-State: APjAAAWKf6avjdC1MJUnwpzJoxxgmeEyu/pY174K+itOHbpX47hQQ1Pq
        k7t2qFW2z3fJcSd8X48xZExM2fKtL92dXyuwfyS1HoHFS0xlNqUHU/YmuIivrWwHTEzU1lQk1eU
        LEfWgIyF3GaGgOv2V
X-Received: by 2002:a19:c0b:: with SMTP id 11mr12664200lfm.135.1576945471847;
        Sat, 21 Dec 2019 08:24:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxWis+AezKuBdTb9TCYVxhLvaVdMFmz/rXTn+53cgoo8JXdv1T47lsE8+nlvgGKr7LnytuQDA==
X-Received: by 2002:a19:c0b:: with SMTP id 11mr12664191lfm.135.1576945471572;
        Sat, 21 Dec 2019 08:24:31 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i17sm4100482ljd.34.2019.12.21.08.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 08:24:30 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 83F9D18096B; Sat, 21 Dec 2019 17:24:24 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next 0/3] libbpf: Add support for extern function calls
In-Reply-To: <20191220203045.hmeoum5l4uw7gy5g@ast-mbp.dhcp.thefacebook.com>
References: <157676577049.957277.3346427306600998172.stgit@toke.dk> <20191220203045.hmeoum5l4uw7gy5g@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 21 Dec 2019 17:24:24 +0100
Message-ID: <878sn53avb.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Dec 19, 2019 at 03:29:30PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> This series adds support for resolving function calls to functions marke=
d as
>> 'extern' in eBPF source files, by resolving the function call targets at=
 load
>> time. For now, this only works by static linking (i.e., copying over the
>> instructions from the function target. Once the kernel support for dynam=
ic
>> linking lands, support can be added for having a function target be an a=
lready
>> loaded program fd instead of a bpf object.
>>=20
>> The API I'm proposing for this is that the caller specifies an explicit =
mapping
>> between extern function names and function names in the target object fi=
le.
>> This is to support the XDP multi-prog case, where the dispatcher program=
 may not
>> necessarily have control over function names in the target programs, so =
simple
>> function name resolution can't be used.
>
> I think simple name resolution should be the default behavior for both st=
atic
> and dynamic linking. That's the part where I think we must not reinvent t=
he wheel.
> When one .c has
> extern int prog1(struct xdp_md *ctx);
> another .c should have:
> int prog1(struct xdp_md *ctx) {...}
> Both static and dynamic linking should link these two .c together without=
 any
> extra steps from the user. It's expected behavior that any C user assumes=
 and
> it should 'just work'.

Sure, absolutely, when we can, we should just auto-resolve function
signatures and names...

> Where we need to be creative is how plug two xdp firewalls with arbitrary
> program names (including the same names) into common roolet.

...however, the "same name" issue is why I started down the path of
specifying links explicitly. I figure it will be somewhat common to have
to link in two independent XDP programs that both picked the same
function name (such as "xdp_main").

> One firewall can be:
> noinline int foo(struct xdp_md *ctx)
> { // some logic
> }
> SEC("xdp")
> int xdp_prog1(struct xdp_md *ctx)
> {
>        return foo(ctx);
> }
>
> And another firewall:
> noinline int foo(struct xdp_md *ctx)
> { // some other logic
> }
> SEC("xdp")
> int xdp_prog2(struct xdp_md *ctx)
> {
>        return foo(ctx);
> }
>
> Both xdp programs (with multiple functions) need to be connected into:
>
> __weak noinline int dummy1(struct xdp_md *ctx) { return XDP_PASS; }
> __weak noinline int dummy2(struct xdp_md *ctx) { return XDP_PASS; }
>
> SEC("xdp")
> int rootlet(struct xdp_md *ctx)
> {
>         int ret;
>
>         ret =3D dummy1(ctx);
>         if (ret !=3D XDP_PASS)
>                 goto out;
>
>         ret =3D dummy2(ctx);
>         if (ret !=3D XDP_DROP)
>                 goto out;
> out:
>         return ret;
> }
>
> where xdp_prog1() from 1st firewall needs to replace dummy1()
> and xdp_prog2() from 2nd firewall needs to replaced dummy2().
> Or the other way around depending on the order of installation.
>
> At the kernel level the API is actually simple. It's the pair of
> target_prog_fd + btf_id I described earlier in "static/dynamic linking" t=
hread.
> Where target_prog_fd is FD of loaded into kernel rootlet and
> btf_id is BTF id of dummy1 or dummy2.

Ah, right; I was thinking it would need a name, but I agree that btf_id
is better.

> When 1st firewall is being loaded libbpf needs to pass target_prog_fd+btf=
_id
> along with xdp_prog1() into the kernel, so that the verifier can do
> appropriate checking and refcnting.
>
> Note that the kernel and every program have their own BTF id space.
> Their own BTF ids =3D=3D their own names.
> Loading two programs with exactly the same name is ok today and in the fu=
ture.
> Linking into other program name space is where we need to agree on naming=
 first.
>
> The static linking of two .o should follow familiar user space linker log=
ic.
> Proposed bpf_linker__..("first.o") and bpf_linker__..("second.o") should =
work.
> Meaning that "extern int foo()" in "second.o" will get resolved with "int=
 foo()"
> from "first.o".
> Dynamic linking is when "first.o" with "int foo()" was already loaded into
> the kernel and "second.o" is loaded after. In such case its "extern int f=
oo()"
> will be resolved dynamically from previously loaded program.
> The user space analogy of this behavior is glibc.
> "first.o" is glibc.so that supplies memcpy() and friends.
> "second.o" is some a.out that used "extern int memcpy()".

Right, this makes sense. Are you proposing that the kernel does this
without any intervention from libbpf when the BTF indicates it has an
extern KIND_FUNC_PROTO? What about overriding the names (dynamically
linking against two programs with identical function names)?

> For XDP rootlet case already loaded weak function dummy[12]() need to
> be replaced later by xdp_prog[12](). It's like replacing memcpy() in glib=
c.so.
> I think the user space doesn't have such concepts. I was simply calling it
> dynamic linking too, but it's not quite accurate. It's dynamically replac=
ing
> already loaded functions. Let's call it "dynamic re-linking" ?

I guess it's kinda akin to LD_PRELOAD? But I'm fine with calling it by a
separate name.

> As far as libbpf api for dynamic linking, so far I didn't need to add new=
 stuff.
> I'm trying to piggy back on fexit/fentry approach.

Cool :)

> I think to prototype re-linking without kernel support. We can do static =
re-linking.
> I think the best approach is to stick with name based resolution. libxdp =
can do:
> - add alias("dummy1") to xdp_prog1() in first_firewall.o
> - rename foo() in first_firewall.o into unique_foo().
> - add alias("dummy2") to xdp_prog2() in second_firewall.o
> - rename foo() in second_firewall.o into very_unique_foo().
> - use standard static linking of first_firewall.o + second_firewall.o + r=
ootlet.o

The alias() would be a BTF annotation? Or something else?

> The static re-linking is more work than dynamic re-linking because it nee=
ds to
> operate in a single name space of final .o. Whereas dynamic re-linking has
> individual name space for every loaded into kernel program.
> I'm hoping to share a prototype of dynamic re-linking soon.

Excellent! At the rate you're going, you'll have the dynamic re-linking
working before I get static linking done :)

-Toke

