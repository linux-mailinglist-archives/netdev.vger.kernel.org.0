Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB54355C7
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 06:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFEEOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 00:14:11 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40585 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfFEEOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 00:14:11 -0400
Received: by mail-lj1-f196.google.com with SMTP id a21so6609159ljh.7;
        Tue, 04 Jun 2019 21:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u5kh3HkgEtdzB+tATZkIrGxViqpaCGvIg689Is7QIok=;
        b=lIObTGEeuQPzhwh+eaUEaBGGgAfmV5EdHn39tCbiDeqzbM06KfOXzNz2Y+SPmqnjxk
         cCERYeNW8ANj9scdGLGZM3q9bSn2IHrQ0h7+ZVb6E15RPoEqCmNZMPh4gIdtuvwXBSB4
         VvGGOE6e2j+zlBfWQ+EEHzzbCRC4Dykz2qnmU4EQOJ6wZGHneQmRFiIx+y4YK10Yq+pE
         9j0cfSz70wG9tJEdMWK03xcKYn8hwNpu4m1mZreIPQmCZXtu422CO4hZm+AHLxFsLKne
         kwaQ/Q8Zkc5hrexkLmaj7r2FigH+UU3Nt59jSQ8/cSKvPRa2sP0HDAIbnrSLgGMjKhZj
         Uwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u5kh3HkgEtdzB+tATZkIrGxViqpaCGvIg689Is7QIok=;
        b=DIhZXAC8x4Aa9yDdeZz0yVhvdDIItX2aT+nBNbvGxlCZQ9voF3e8Am9XOJfI+zC2Jg
         Jwom0M0vLyFPyDUvroAnrddkTJVDtLNnHXMQG6LZaNDJjBV+6x451Rjd1zWvIeFCAJBM
         o1XvrPAofO0JIcRNGj5Mm/4Y5DWvsS02jiXm6KUjTbqqxrduy+oEyFFJfra4t8KxaWF0
         PktI3AvSk6awFmNhYqvUTSrhBi2ofJBEKpFuoa0McJ88FiPk7xs9ZrblhE+HWZQGh9I4
         JVGKxYSR4eT19RVqQP4EJCO3KjquQuzUBCvy9geYvEr+q2lsaWMqGYZvN5PHRUDLKDXK
         369A==
X-Gm-Message-State: APjAAAWPuPZ3VZ4cMsYKAa/9ivxaYbBgiBTW+mzCzZSMXruRyW5xteaW
        KoVK+Kbu5I94xv1u79D2LgFwsAL/aPa9mdZLkgg=
X-Google-Smtp-Source: APXvYqyPTFQLC2rG6D3yBPDJMXnxOlq09eHsCSQZHCXbaWE/XEE/cgFY4CPMBElzdLlb3JCnEJin42Z8MIf8FMla55M=
X-Received: by 2002:a2e:9747:: with SMTP id f7mr18689260ljj.34.1559708048359;
 Tue, 04 Jun 2019 21:14:08 -0700 (PDT)
MIME-Version: 1.0
References: <f42c7b44b3f694056c4216e9d9ba914b44e72ab9.1559648367.git.baruch@tkos.co.il>
 <CAADnVQJ1vRvqNFsWjvwmzSc_-OY51HTsVa13XhgK1v9NbYY2_A@mail.gmail.com>
 <CAMuHMdV-0s_ikRmCrEcMCfkAp57Fu8WTUnJsopGagbYa+GGpbA@mail.gmail.com>
 <20190604153028.ysyzvmpxqaaln4v2@ast-mbp.dhcp.thefacebook.com> <20190605040611.dt5fiegte2ys7z7z@sapphire.tkos.co.il>
In-Reply-To: <20190605040611.dt5fiegte2ys7z7z@sapphire.tkos.co.il>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 4 Jun 2019 21:13:56 -0700
Message-ID: <CAADnVQJXZ=qT+qwp6-Gz2THuOKGmanDJM9pq9M457iFGAqntDg@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix uapi bpf_prog_info fields alignment
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, "Dmitry V . Levin" <ldv@altlinux.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 9:06 PM Baruch Siach <baruch@tkos.co.il> wrote:
>
> Hi Alexei,
>
> (Adding Arnd and linux-arch to Cc)
>
> On Tue, Jun 04, 2019 at 08:30:29AM -0700, Alexei Starovoitov wrote:
> > On Tue, Jun 04, 2019 at 05:23:46PM +0200, Geert Uytterhoeven wrote:
> > > On Tue, Jun 4, 2019 at 5:17 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > > On Tue, Jun 4, 2019 at 4:40 AM Baruch Siach <baruch@tkos.co.il> wrote:
> > > > > Merge commit 1c8c5a9d38f60 ("Merge
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next") undid the
> > > > > fix from commit 36f9814a494 ("bpf: fix uapi hole for 32 bit compat
> > > > > applications") by taking the gpl_compatible 1-bit field definition from
> > > > > commit b85fab0e67b162 ("bpf: Add gpl_compatible flag to struct
> > > > > bpf_prog_info") as is. That breaks architectures with 16-bit alignment
> > > > > like m68k. Widen gpl_compatible to 32-bit to restore alignment of the
> > > > > following fields.
> > > >
> > > > The commit log is misleading and incorrect.
> > > > Since compiler makes it into 16-bit field, it's a compiler bug.
> > > > u32 in C should stay as u32 regardless of architecture.
> > >
> > > C99 says (Section 6.7.2.1, Structure and union specifiers, Semantics)
> > >
> > >     10  An implementation may allocate any addressable storage unit
> > >         large enough to hold a bit-field.
> > >
> > > $ cat hello.c
> > > #include <stdio.h>
> > > #include <stdint.h>
> > > #include <stdlib.h>
> > >
> > > struct x {
> > >         unsigned int bit : 1;
> > >         unsigned char byte;
> > > };
> > >
> > > int main(int argc, char *argv[])
> > > {
> > >         struct x x;
> > >
> > >         printf("byte is at offset %zu\n", (uintptr_t)&x.byte - (uintptr_t)&x);
> > >         printf("sizeof(x) = %zu\n", sizeof(x));
> > >         exit(0);
> > > }
> > > $ gcc -Wall hello.c -o hello && ./hello
> > > byte is at offset 1
> > > sizeof(x) = 4
> > > $ uname -m
> > > x86_64
> > >
> > > So the compiler allocates a single byte, even on a 64-bit platform!
> > > The gap is solely determined by the alignment rule for the
> > > successive field.
> >
> > argh. then we need something like this:
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 7c6aef253173..a2ac0b961251 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3174,6 +3174,7 @@ struct bpf_prog_info {
> >         char name[BPF_OBJ_NAME_LEN];
> >         __u32 ifindex;
> >         __u32 gpl_compatible:1;
> > +       __u32 :31;
> >         __u64 netns_dev;
> >         __u64 netns_ino;
> >         __u32 nr_jited_ksyms;
>
> Is that guaranteed to work across platforms/compilers? Maybe an anonymous

it works on archs I have access to.
please try it on yours.

> union would be safer? Something like:
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 63e0cf66f01a..06c9fb314ea5 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3140,7 +3140,10 @@ struct bpf_prog_info {
>         __aligned_u64 map_ids;
>         char name[BPF_OBJ_NAME_LEN];
>         __u32 ifindex;
> -       __u32 gpl_compatible:1;
> +       union {
> +               __u32 gpl_compatible:1;
> +               __u32 pad;
> +       };

that's a potential uapi breakage.
We use anonymous bitfields in other places in uapi.
If some gcc on some arch doesn't understand them
it's a bigger breakage and such gcc would need
to be fixed regardless.
