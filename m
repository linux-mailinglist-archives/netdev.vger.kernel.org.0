Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E170EB313
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfJaOoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:44:20 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34558 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfJaOoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:44:20 -0400
Received: by mail-lf1-f67.google.com with SMTP id f5so4902693lfp.1;
        Thu, 31 Oct 2019 07:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GXiVKs8iJm4XXoeUcaASIXeWhThC2LRLVfLLVwcdlq4=;
        b=V2P+QVeu1itlDHHvjWQyXIPHFrdjXS83cITS7KVs1pEVYe1L5XwrYM1G0TP8XTSZuW
         F/1d26T+2D65F/KLNp7eDMWoXaEYTBzO/ktujy6WXgOmlVBtPZGYjXtTwk89xtYoOPpH
         RnJKPVA09PX4vXDQRGDstvXqvf10BdaiZe0TK+tJ+aGNNGmbs5HMiLJh7pl9/tgxR/8+
         5heTbSu0OWLvm6KOWvUBJGTWgWAzXNLTgPsFKYqrcKyZKFey+oCwOEUWMoe1hHFjCjwB
         HkQePqGjZsnw0w1eBagnfxpr5AASYJXL5KT/enjpm3Z7nxYYJWMNFKrImJp8AcQWCdu1
         OJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GXiVKs8iJm4XXoeUcaASIXeWhThC2LRLVfLLVwcdlq4=;
        b=MlhRPjXG3ml1tn40QsGEtrQc98eh84pBz35dGV0jTI8ugmc+9eqvM2EkiizOF0JMfH
         jWVpf3ab0SXlvD4GrXfoO9Uv6v8WyOgrEoiQI8g7eOKz4NWOdy5mONaejEnKyUAR9dbo
         XXfWRYkpodEuD+csIVLmMfsmQBOePZxTtiSU3N7cph1Tmm/CmYPvU+w9LqwdXeIdpIX+
         o/HhM3r3K7LIYt1U1Bn/YoVHZpKKHtDzrE/QuGxmI8zXxiy3ulg0KKrZyzh7Wmzhmh5b
         hEWGNrd1fvg5rP1fll1c7tlS9PHgGb4GzxoSVAqQqf4e5sICRVazmFT9HLaXRhiwO0ja
         ytSw==
X-Gm-Message-State: APjAAAXPrsFfI08tlN7kWhj0ipXuc/9ACcNbCQdmM9Vr/dTQHLHAs24z
        KP23jUjdE22Wfc+M5xP3DEzISePE1t0RIbItGyI=
X-Google-Smtp-Source: APXvYqxmg1U6i2mrZxz+NMeb+trPA6IA2c8sI4Ia4SPO7hDWRHxRjy/ut+aK7o53KLgyaDha3OXVlSa1L4bmZvfatOo=
X-Received: by 2002:a19:800a:: with SMTP id b10mr3864301lfd.15.1572533057261;
 Thu, 31 Oct 2019 07:44:17 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
 <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
 <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
 <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk>
In-Reply-To: <87imo5ng7w.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 07:44:04 -0700
Message-ID: <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
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

On Thu, Oct 31, 2019 at 7:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@g=
mail.com> wrote:
> >> >>
> >> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@gmai=
l.com> wrote:
> >> >> >
> >> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
> >> >> > >
> >> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> >> >> > >
> >> >> > > > When the need_wakeup flag was added to AF_XDP, the format of =
the
> >> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to t=
he
> >> >> > > > kernel to take care of compatibility issues arrising from run=
ning
> >> >> > > > applications using any of the two formats. However, libbpf wa=
s
> >> >> > > > not extended to take care of the case when the application/li=
bbpf
> >> >> > > > uses the new format but the kernel only supports the old
> >> >> > > > format. This patch adds support in libbpf for parsing the old
> >> >> > > > format, before the need_wakeup flag was added, and emulating =
a
> >> >> > > > set of static need_wakeup flags that will always work for the
> >> >> > > > application.
> >> >> > >
> >> >> > > Hi Magnus
> >> >> > >
> >> >> > > While you're looking at backwards compatibility issues with xsk=
: libbpf
> >> >> > > currently fails to compile on a system that has old kernel head=
ers
> >> >> > > installed (this is with kernel-headers 5.3):
> >> >> > >
> >> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> >> >> > > In file included from <stdin>:1:
> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__nee=
ds_wakeup=E2=80=99:
> >> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAK=
EUP=E2=80=99 undeclared (first use in this function)
> >> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> >> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
> >> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier =
is reported only once for each function it appears in
> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_=
addr=E2=80=99:
> >> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BU=
F_ADDR_MASK=E2=80=99 undeclared (first use in this function)
> >> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> >> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_=
offset=E2=80=99:
> >> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BU=
F_OFFSET_SHIFT=E2=80=99 undeclared (first use in this function)
> >> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> >> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >> >> > >
> >> >> > >
> >> >> > >
> >> >> > > How would you prefer to handle this? A patch like the one below=
 will fix
> >> >> > > the compile errors, but I'm not sure it makes sense semanticall=
y?
> >> >> >
> >> >> > Thanks Toke for finding this. Of course it should be possible to
> >> >> > compile this on an older kernel, but without getting any of the n=
ewer
> >> >> > functionality that is not present in that older kernel.
> >> >>
> >> >> Is the plan to support source compatibility for the headers only, o=
r
> >> >> the whole the libbpf itself? Is the usecase here, that you've built
> >> >> libbpf.so with system headers X, and then would like to use the
> >> >> library on a system with older system headers X~10? XDP sockets? BT=
F?
> >> >
> >> > libbpf has to be backward and forward compatible.
> >> > Once compiled it has to run on older and newer kernels.
> >> > Conditional compilation is not an option obviously.
> >>
> >> So what do we do, then? Redefine the constants in libbpf/xsh.h if
> >> they're not in the kernel header file?
> >
> > why? How and whom it will help?
> > To libbpf.rpm creating person or to end user?
>
> Anyone who tries to compile a new libbpf against an older kernel. You're
> saying yourself that "libbpf has to be backward and forward compatible".
> Surely that extends to compile time as well as runtime?

how old that older kernel?
Does it have up-to-date bpf.h in /usr/include ?
Also consider that running kernel is often not the same
thing as installed in /usr/include
vmlinux and /usr/include are different packages.
