Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B43EB3BF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 16:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfJaPR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 11:17:58 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41678 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbfJaPR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 11:17:58 -0400
Received: by mail-lj1-f193.google.com with SMTP id m9so7024405ljh.8;
        Thu, 31 Oct 2019 08:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aDV+4dVJ1sP6YX3kX7oHsVxJ6a46KhnxSb+MYBaqp04=;
        b=hLqr4Q1ANgkj6MJS9bwmtAapdhj4C1XFb7DHs66vbUXQMdfTpPukg2zLcILv9Ghlmz
         xOTb0zf3M1omfIfY8YRZGF+GeY8HwQ2HrmOGwTL9FnYho2Uu7V5NyNph7+39dPak+6Pk
         LHbCGaey8kajrUPRK8lqVsyL+qicKEzSXUXpr+MMAwZi12SWM1fu0sjeRL706F2y8Q2d
         R6GSUm/eUGz/DToNPyYZ6l0sbRkKp0RiiuNxMyJ3ahl9vhzpEpV3QUQz5GT3CjiEbaUQ
         +XgD428T/DqlMb8MyZ4ijrOcaF2wTERIjfpb3eWKGBhJfeRq7IAyAWEi9fB/QK/4DTug
         KfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aDV+4dVJ1sP6YX3kX7oHsVxJ6a46KhnxSb+MYBaqp04=;
        b=XQR3vxrb9b1n8g7g4u04pk96g4YRXMFX4wN+vHL7Rx4nzeyeD/53eZ/2JfNGUyNmDx
         OTX7e7ZMfaVEzVjHFKQIydVSkBZ/UXIKjdns4gnINP5jXpD+aEQo56IRAnmySaCHgoVs
         I/wePeEfE46mSdpwS+8TLP9liY25Po7sBm1Jq2IqMdq23HcajuCGsMX5BpCXdJ9GpxRh
         Xed+pRxMkn19pMwNGKKeWhMCG1oPh4UsTl2uBPWy+Jcch+dO1Fo5mL1rmptg2jQzdozo
         cX/387YWUXbbcGXj+qf+yhRixDUZwq9tz8137/SxZ72qRT+TPcPEhvQE1CtHXG/on28g
         +tZw==
X-Gm-Message-State: APjAAAXHNiVJ+L0yVVn7q12x1eGa77uEiN8v8LJOko6p6IvVKFxcOpxs
        1Hdu4MkoLgmqrEXkin7il7+z+wAecV6whHeGZsY=
X-Google-Smtp-Source: APXvYqy5RIvfHE3UDUVeKeZ4z2D8030osC0mTO6G77wHdu7xFSrg2dhSbIH0O6SKu9YJWiHete5UWppeUhGjozLxk3I=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr769733lju.51.1572535074533;
 Thu, 31 Oct 2019 08:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
 <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
 <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
 <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk>
In-Reply-To: <87d0ednf0t.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 08:17:43 -0700
Message-ID: <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 7:52 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Oct 31, 2019 at 7:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >> >>
> >> >> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.tope=
l@gmail.com> wrote:
> >> >> >>
> >> >> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@g=
mail.com> wrote:
> >> >> >> >
> >> >> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgens=
en <toke@redhat.com> wrote:
> >> >> >> > >
> >> >> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> >> >> >> > >
> >> >> >> > > > When the need_wakeup flag was added to AF_XDP, the format =
of the
> >> >> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added t=
o the
> >> >> >> > > > kernel to take care of compatibility issues arrising from =
running
> >> >> >> > > > applications using any of the two formats. However, libbpf=
 was
> >> >> >> > > > not extended to take care of the case when the application=
/libbpf
> >> >> >> > > > uses the new format but the kernel only supports the old
> >> >> >> > > > format. This patch adds support in libbpf for parsing the =
old
> >> >> >> > > > format, before the need_wakeup flag was added, and emulati=
ng a
> >> >> >> > > > set of static need_wakeup flags that will always work for =
the
> >> >> >> > > > application.
> >> >> >> > >
> >> >> >> > > Hi Magnus
> >> >> >> > >
> >> >> >> > > While you're looking at backwards compatibility issues with =
xsk: libbpf
> >> >> >> > > currently fails to compile on a system that has old kernel h=
eaders
> >> >> >> > > installed (this is with kernel-headers 5.3):
> >> >> >> > >
> >> >> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> >> >> >> > > In file included from <stdin>:1:
> >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__=
needs_wakeup=E2=80=99:
> >> >> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_=
WAKEUP=E2=80=99 undeclared (first use in this function)
> >> >> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> >> >> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
> >> >> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifi=
er is reported only once for each function it appears in
> >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extra=
ct_addr=E2=80=99:
> >> >> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED=
_BUF_ADDR_MASK=E2=80=99 undeclared (first use in this function)
> >> >> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> >> >> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extra=
ct_offset=E2=80=99:
> >> >> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED=
_BUF_OFFSET_SHIFT=E2=80=99 undeclared (first use in this function)
> >> >> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> >> >> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> >> >> > >
> >> >> >> > >
> >> >> >> > >
> >> >> >> > > How would you prefer to handle this? A patch like the one be=
low will fix
> >> >> >> > > the compile errors, but I'm not sure it makes sense semantic=
ally?
> >> >> >> >
> >> >> >> > Thanks Toke for finding this. Of course it should be possible =
to
> >> >> >> > compile this on an older kernel, but without getting any of th=
e newer
> >> >> >> > functionality that is not present in that older kernel.
> >> >> >>
> >> >> >> Is the plan to support source compatibility for the headers only=
, or
> >> >> >> the whole the libbpf itself? Is the usecase here, that you've bu=
ilt
> >> >> >> libbpf.so with system headers X, and then would like to use the
> >> >> >> library on a system with older system headers X~10? XDP sockets?=
 BTF?
> >> >> >
> >> >> > libbpf has to be backward and forward compatible.
> >> >> > Once compiled it has to run on older and newer kernels.
> >> >> > Conditional compilation is not an option obviously.
> >> >>
> >> >> So what do we do, then? Redefine the constants in libbpf/xsh.h if
> >> >> they're not in the kernel header file?
> >> >
> >> > why? How and whom it will help?
> >> > To libbpf.rpm creating person or to end user?
> >>
> >> Anyone who tries to compile a new libbpf against an older kernel. You'=
re
> >> saying yourself that "libbpf has to be backward and forward compatible=
".
> >> Surely that extends to compile time as well as runtime?
> >
> > how old that older kernel?
> > Does it have up-to-date bpf.h in /usr/include ?
> > Also consider that running kernel is often not the same
> > thing as installed in /usr/include
> > vmlinux and /usr/include are different packages.
>
> In this case, it's a constant introduced in the kernel in the current
> (5.4) cycle; so currently, you can't compile libbpf with
> kernel-headers-5.3. And we're discussing how to handle this in a
> backwards compatible way in libbpf...

you simply don't.
It's not a problem to begin with.
