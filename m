Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E65B9EB256
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfJaORq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:17:46 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39326 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaORq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:17:46 -0400
Received: by mail-lj1-f194.google.com with SMTP id y3so6824168ljj.6;
        Thu, 31 Oct 2019 07:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CqSLdhJHV2alIYHd9Xd5+nMCPo8mrIqqMmEoNnII9Fk=;
        b=u+9fFVrzhXVOTcq3P0xY42qTqjtebVrCJoMbMLlvRAJXpQQblQrmiVs84o+AY8xNmS
         1tEH0jgU+JxbbG/6X3AjV7qRa1kFrUYP1bby9YcwiS6hXIDLs8Fp89aViL0Fz1/cgpTV
         7ZXgDaG3embJ4L88o8WwI/7gmPnTRv+hfHDE9nuCwPNr1aePE7FnKz8BIGJWhoa40qj3
         UioiQex4UzF70GuBwDkBFYItQD0RhYrVGsirzfA8zO1B4bjfF0wdEO2ixqub+cAiP8v0
         Fzf2pdCg/uupht8fDVMAqvgu8DdCzA0+LoDV50xgk8su5Ap+1kxH9Ak5ZEio5zIFaphf
         qCfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CqSLdhJHV2alIYHd9Xd5+nMCPo8mrIqqMmEoNnII9Fk=;
        b=BEdLcDFLLZlqv5t8E4GIEwxrGQNJvlfTB2ETlpd2rlHNJ5ucTgD4eFUXWio2r0GTgz
         agwVzWa5zsyDKUpLxHiZKFipBi779XzyXTbCwCIOLa5RRd2XzA85011wF59D4C86HzTI
         mFq4jZ6gfx05bvH1IAihTq5rOdNQyk5FR8tPP6XuC4x3C5f8XDD1QZZhgxoFvEz3VSaY
         ozqJPFFoJUvJ+eBHLa0Pso/XsRHMCphmK5StbhxyFqua5EUktQnBiBSzmVoV1by730ro
         YNLqGOGobY1nhEB7Oe+CrpBX9k9PH/eGkmBUEjgo9+eIO7s4KNqtML8Lzla2Rh4cYGqy
         cdDA==
X-Gm-Message-State: APjAAAU0gESpTKwkXrKp0JOgrd5JkjiwEvUxG/xoKiw0Uo7hhwbpRcZ9
        DFaqVtT6L6fVyfBXEp7olePhrOG+ErhXHPw5QPA=
X-Google-Smtp-Source: APXvYqy611ONv9AAD1TLXYWwNbLNVyMdlHjFgZAtaFEvCPeuO1EJwIgRj07+Fq+FxCXL4lUdSdWhaeUMHbpa88gTOLQ=
X-Received: by 2002:a2e:868d:: with SMTP id l13mr4352182lji.136.1572531463100;
 Thu, 31 Oct 2019 07:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
 <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
 <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com> <87lft1ngtn.fsf@toke.dk>
In-Reply-To: <87lft1ngtn.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 07:17:31 -0700
Message-ID: <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
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

On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmai=
l.com> wrote:
> >>
> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@gmail.c=
om> wrote:
> >> >
> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> > >
> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> >> > >
> >> > > > When the need_wakeup flag was added to AF_XDP, the format of the
> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> >> > > > kernel to take care of compatibility issues arrising from runnin=
g
> >> > > > applications using any of the two formats. However, libbpf was
> >> > > > not extended to take care of the case when the application/libbp=
f
> >> > > > uses the new format but the kernel only supports the old
> >> > > > format. This patch adds support in libbpf for parsing the old
> >> > > > format, before the need_wakeup flag was added, and emulating a
> >> > > > set of static need_wakeup flags that will always work for the
> >> > > > application.
> >> > >
> >> > > Hi Magnus
> >> > >
> >> > > While you're looking at backwards compatibility issues with xsk: l=
ibbpf
> >> > > currently fails to compile on a system that has old kernel headers
> >> > > installed (this is with kernel-headers 5.3):
> >> > >
> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> >> > > In file included from <stdin>:1:
> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_=
wakeup=E2=80=99:
> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=
=E2=80=99 undeclared (first use in this function)
> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is =
reported only once for each function it appears in
> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_add=
r=E2=80=99:
> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_A=
DDR_MASK=E2=80=99 undeclared (first use in this function)
> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_off=
set=E2=80=99:
> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_O=
FFSET_SHIFT=E2=80=99 undeclared (first use in this function)
> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> > >
> >> > >
> >> > >
> >> > > How would you prefer to handle this? A patch like the one below wi=
ll fix
> >> > > the compile errors, but I'm not sure it makes sense semantically?
> >> >
> >> > Thanks Toke for finding this. Of course it should be possible to
> >> > compile this on an older kernel, but without getting any of the newe=
r
> >> > functionality that is not present in that older kernel.
> >>
> >> Is the plan to support source compatibility for the headers only, or
> >> the whole the libbpf itself? Is the usecase here, that you've built
> >> libbpf.so with system headers X, and then would like to use the
> >> library on a system with older system headers X~10? XDP sockets? BTF?
> >
> > libbpf has to be backward and forward compatible.
> > Once compiled it has to run on older and newer kernels.
> > Conditional compilation is not an option obviously.
>
> So what do we do, then? Redefine the constants in libbpf/xsh.h if
> they're not in the kernel header file?

why? How and whom it will help?
To libbpf.rpm creating person or to end user?
