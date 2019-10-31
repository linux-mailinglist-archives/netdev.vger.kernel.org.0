Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95466EB6D0
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbfJaSTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:19:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33121 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbfJaSTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:19:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so5448568lfc.0;
        Thu, 31 Oct 2019 11:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AJQ2rsLSeZTK9Oodg0QgTqZ4wxuuSIu2sZR6PbU5h+M=;
        b=VS5GevqqBGZyy64IvcODYwTBI3bIOVqKpxKEpsxRAbLaiB6K6SzTleNipOoi3N+JWL
         Po1Wm/WjKEOUXp5kff2c/RvVyh9jcajmyQG0v7xEzpeb89c/N3SKPD917PbZxJOlgiEH
         xfCjmxl1UYVTmDQyEpRLpDtaYxNYRZ85sTQ/wVEy1PpSgYyMxnPWg2zBzAc7KzcAa5Sv
         C7tuxouu7Y2eKXdJuxhr8701DM4Q4uoi8rX+xNaeADjgNU/4pzwD5K8gdBYIMw0SmAwj
         pF1FK1vSEXUMADBgxOP3RX1IpFnYv0QjjX0Xkd2A96pyhPI2fOKhrujZ5RP/5WV/VExt
         9/3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AJQ2rsLSeZTK9Oodg0QgTqZ4wxuuSIu2sZR6PbU5h+M=;
        b=Kfu1CHPfIJgm/vJlmomkrKNtM4B8IxGbkiwv0GdYKTzDkM3cZGlnR6ANwEsp5WWvpb
         idqqNOSN34cGYTugxGErpIPcsXunnwoSRzmK+7+gg0hKF+VVXjLWynUgSShkdofSWEZU
         p6R3y+0u20VwKqSvTsBAm1Z+rOMBj7d4A2JN5kdv8QGdpQ6DUCTnPSiAIvP3PK/AHg1M
         Ypm+iGA/Uw6eTtzNoOIRb7Ri16+baWXywUjIKCaDOffo3+wMWJwYQ8eB9ejdOLczbv0M
         h1xDAojUfmBOvbQwq3dZqXN95/LAxGyW/B/4OHHMr82oL4+Wo0AMNxeKfFngVGpAjWR3
         r80Q==
X-Gm-Message-State: APjAAAWmc1qYytkqfgBh0o9lOVGUA5JBFufIKIxXLCHwyllEG5ckRji3
        1NFsph4GZusblrGb4xj3bKqmvQAPnI7pYJUp5yo=
X-Google-Smtp-Source: APXvYqwtVfKHqWi3LEektanSzMpOuMPZ/pRV0QPv21WYehK2oLf72R3V3hFQHvn0uKR4BEafz+6sMYh9v1JG7btdYBM=
X-Received: by 2002:a19:ac48:: with SMTP id r8mr4682911lfc.181.1572545972959;
 Thu, 31 Oct 2019 11:19:32 -0700 (PDT)
MIME-Version: 1.0
References: <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
 <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
 <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk> <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
 <20191031174208.GC2794@krava>
In-Reply-To: <20191031174208.GC2794@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 11:19:21 -0700
Message-ID: <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
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

On Thu, Oct 31, 2019 at 10:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 31, 2019 at 08:17:43AM -0700, Alexei Starovoitov wrote:
> > On Thu, Oct 31, 2019 at 7:52 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> > >
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >
> > > > On Thu, Oct 31, 2019 at 7:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> > > >>
> > > >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > >>
> > > >> > On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgensen=
 <toke@redhat.com> wrote:
> > > >> >>
> > > >> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > >> >>
> > > >> >> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.=
topel@gmail.com> wrote:
> > > >> >> >>
> > > >> >> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlss=
on@gmail.com> wrote:
> > > >> >> >> >
> > > >> >> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8r=
gensen <toke@redhat.com> wrote:
> > > >> >> >> > >
> > > >> >> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> > > >> >> >> > >
> > > >> >> >> > > > When the need_wakeup flag was added to AF_XDP, the for=
mat of the
> > > >> >> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was add=
ed to the
> > > >> >> >> > > > kernel to take care of compatibility issues arrising f=
rom running
> > > >> >> >> > > > applications using any of the two formats. However, li=
bbpf was
> > > >> >> >> > > > not extended to take care of the case when the applica=
tion/libbpf
> > > >> >> >> > > > uses the new format but the kernel only supports the o=
ld
> > > >> >> >> > > > format. This patch adds support in libbpf for parsing =
the old
> > > >> >> >> > > > format, before the need_wakeup flag was added, and emu=
lating a
> > > >> >> >> > > > set of static need_wakeup flags that will always work =
for the
> > > >> >> >> > > > application.
> > > >> >> >> > >
> > > >> >> >> > > Hi Magnus
> > > >> >> >> > >
> > > >> >> >> > > While you're looking at backwards compatibility issues w=
ith xsk: libbpf
> > > >> >> >> > > currently fails to compile on a system that has old kern=
el headers
> > > >> >> >> > > installed (this is with kernel-headers 5.3):
> > > >> >> >> > >
> > > >> >> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> > > >> >> >> > > In file included from <stdin>:1:
> > > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_pr=
od__needs_wakeup=E2=80=99:
> > > >> >> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_N=
EED_WAKEUP=E2=80=99 undeclared (first use in this function)
> > > >> >> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> > > >> >> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
> > > >> >> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared iden=
tifier is reported only once for each function it appears in
> > > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__e=
xtract_addr=E2=80=99:
> > > >> >> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALI=
GNED_BUF_ADDR_MASK=E2=80=99 undeclared (first use in this function)
> > > >> >> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> > > >> >> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__e=
xtract_offset=E2=80=99:
> > > >> >> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALI=
GNED_BUF_OFFSET_SHIFT=E2=80=99 undeclared (first use in this function)
> > > >> >> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> > > >> >> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > >> >> >> > >
> > > >> >> >> > >
> > > >> >> >> > >
> > > >> >> >> > > How would you prefer to handle this? A patch like the on=
e below will fix
> > > >> >> >> > > the compile errors, but I'm not sure it makes sense sema=
ntically?
> > > >> >> >> >
> > > >> >> >> > Thanks Toke for finding this. Of course it should be possi=
ble to
> > > >> >> >> > compile this on an older kernel, but without getting any o=
f the newer
> > > >> >> >> > functionality that is not present in that older kernel.
> > > >> >> >>
> > > >> >> >> Is the plan to support source compatibility for the headers =
only, or
> > > >> >> >> the whole the libbpf itself? Is the usecase here, that you'v=
e built
> > > >> >> >> libbpf.so with system headers X, and then would like to use =
the
> > > >> >> >> library on a system with older system headers X~10? XDP sock=
ets? BTF?
> > > >> >> >
> > > >> >> > libbpf has to be backward and forward compatible.
> > > >> >> > Once compiled it has to run on older and newer kernels.
> > > >> >> > Conditional compilation is not an option obviously.
> > > >> >>
> > > >> >> So what do we do, then? Redefine the constants in libbpf/xsh.h =
if
> > > >> >> they're not in the kernel header file?
> > > >> >
> > > >> > why? How and whom it will help?
> > > >> > To libbpf.rpm creating person or to end user?
> > > >>
> > > >> Anyone who tries to compile a new libbpf against an older kernel. =
You're
> > > >> saying yourself that "libbpf has to be backward and forward compat=
ible".
> > > >> Surely that extends to compile time as well as runtime?
> > > >
> > > > how old that older kernel?
> > > > Does it have up-to-date bpf.h in /usr/include ?
> > > > Also consider that running kernel is often not the same
> > > > thing as installed in /usr/include
> > > > vmlinux and /usr/include are different packages.
> > >
> > > In this case, it's a constant introduced in the kernel in the current
> > > (5.4) cycle; so currently, you can't compile libbpf with
> > > kernel-headers-5.3. And we're discussing how to handle this in a
> > > backwards compatible way in libbpf...
> >
> > you simply don't.
> > It's not a problem to begin with.
>
> hum, that's possible case for distro users.. older kernel, newer libbpf

yes. older vmlinux and newer installed libbpf.so
or any version of libbpf.a that is statically linked into apps
is something that libbpf code has to support.
The server can be rebooted into older than libbpf kernel and
into newer than libbpf kernel. libbpf has to recognize all these
combinations and work appropriately.
That's what backward and forward compatibility is.
That's what makes libbpf so difficult to test, develop and code review.
What that particular server has in /usr/include is irrelevant.
