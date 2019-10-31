Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E97EB85B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfJaUXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:23:19 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46478 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:23:19 -0400
Received: by mail-qk1-f195.google.com with SMTP id e66so8349879qkf.13;
        Thu, 31 Oct 2019 13:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2M2BwaKCLMXwWU2elFFBxvcV56uTW9J4XSP1/NC5+qo=;
        b=q+RyzBCtlH5cQnQw5r9f4hpW8odswvKqF2gB6F0HklcnADHh+hMAkR7dgq0a+7Yi87
         uXawUiGY6JmmFIHfqOq6CpdDT0ZLO+sDEMVVEJkCMGrld34KCIvGUFwTw2Nw70D/pIv7
         zF11Gk1XJepIH075R72oW+cctCcCWoEp7+wHHKt8TWlxBhh/6cpn4G9mhMllT+W0UfYH
         LPwCOoOTRysbzoJe0PKYkQvb+hzNLmTmpa6UPstHqx1IsZxTRQoEytwSl1gYUbv5KF58
         FssZa1zClvOtjq7Wr8LcSTAOVp53DpNC3wtHXVs6xkuT/okgESr9v81dFV7yEHv821Ez
         pQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2M2BwaKCLMXwWU2elFFBxvcV56uTW9J4XSP1/NC5+qo=;
        b=fvxvHosLSrXIaLC15Jss56l8Htk6Vgp5VaTqo/sg3kIDWxMMus2GSGYkITztOI6rJF
         whV5ynuYP6v1ftPf/GecefOsCK2lUIqwojsJKX5v6MLTngd0xIVP+jygsD5t4lyRByRP
         M7EjqbZT3TXxWQLuzEVNE0gOamZl1MhE+9G5FcwJiLZLszKvDrB4KraJa7G7eBPhtRsH
         kWfOQPaUcB9BSW/eUCpb/spvrU+OVqNUySNAWvbY5FZpZF7eW8aFJUWDb+/lWYwh3s3k
         juiQazfW6fO6QumaizAzb5DLHS7TlSZXz7j2f5IcOcaCrXjlHXz0xKJt1PSDen9wmk02
         Q1lA==
X-Gm-Message-State: APjAAAXOMfux+oHo1SvGI7sRXYB4D+9E+M3sQX3PhXEP4VIBFyAMK4/m
        hfYm38WsvHZaai/1ogZyFWNLQde67Txjthdahqc=
X-Google-Smtp-Source: APXvYqxrVW7t0r0wBPC4/KFZD/wbOIYtvHQD/HyzM1AzLs3YP9OZfv8IK/Lva9eBvqwmjU0BxTlIQUHoqMc1zwWylU4=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr7204890qkj.39.1572553397587;
 Thu, 31 Oct 2019 13:23:17 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
 <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
 <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
 <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk> <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
In-Reply-To: <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 13:23:06 -0700
Message-ID: <CAEf4Bzak3Cu1voYvKi1NY_iH61jFzPdb_A5iqo4m=5wyCKNveg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, Oct 31, 2019 at 8:18 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Oct 31, 2019 at 7:52 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >
> > > On Thu, Oct 31, 2019 at 7:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> > >>
> > >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >>
> > >> > On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <=
toke@redhat.com> wrote:
> > >> >>
> > >> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > >> >>
> > >> >> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.to=
pel@gmail.com> wrote:
> > >> >> >>
> > >> >> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson=
@gmail.com> wrote:
> > >> >> >> >
> > >> >> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rge=
nsen <toke@redhat.com> wrote:
> > >> >> >> > >
> > >> >> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> > >> >> >> > >
> > >> >> >> > > > When the need_wakeup flag was added to AF_XDP, the forma=
t of the
> > >> >> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added=
 to the
> > >> >> >> > > > kernel to take care of compatibility issues arrising fro=
m running
> > >> >> >> > > > applications using any of the two formats. However, libb=
pf was
> > >> >> >> > > > not extended to take care of the case when the applicati=
on/libbpf
> > >> >> >> > > > uses the new format but the kernel only supports the old
> > >> >> >> > > > format. This patch adds support in libbpf for parsing th=
e old
> > >> >> >> > > > format, before the need_wakeup flag was added, and emula=
ting a
> > >> >> >> > > > set of static need_wakeup flags that will always work fo=
r the
> > >> >> >> > > > application.
> > >> >> >> > >
> > >> >> >> > > Hi Magnus
> > >> >> >> > >
> > >> >> >> > > While you're looking at backwards compatibility issues wit=
h xsk: libbpf
> > >> >> >> > > currently fails to compile on a system that has old kernel=
 headers
> > >> >> >> > > installed (this is with kernel-headers 5.3):
> > >> >> >> > >
> > >> >> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> > >> >> >> > > In file included from <stdin>:1:
> > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod=
__needs_wakeup=E2=80=99:
> > >> >> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEE=
D_WAKEUP=E2=80=99 undeclared (first use in this function)
> > >> >> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> > >> >> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
> > >> >> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identi=
fier is reported only once for each function it appears in
> > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__ext=
ract_addr=E2=80=99:
> > >> >> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGN=
ED_BUF_ADDR_MASK=E2=80=99 undeclared (first use in this function)
> > >> >> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> > >> >> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__ext=
ract_offset=E2=80=99:
> > >> >> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGN=
ED_BUF_OFFSET_SHIFT=E2=80=99 undeclared (first use in this function)
> > >> >> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> > >> >> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >> >> >> > >
> > >> >> >> > >
> > >> >> >> > >
> > >> >> >> > > How would you prefer to handle this? A patch like the one =
below will fix
> > >> >> >> > > the compile errors, but I'm not sure it makes sense semant=
ically?
> > >> >> >> >
> > >> >> >> > Thanks Toke for finding this. Of course it should be possibl=
e to
> > >> >> >> > compile this on an older kernel, but without getting any of =
the newer
> > >> >> >> > functionality that is not present in that older kernel.
> > >> >> >>
> > >> >> >> Is the plan to support source compatibility for the headers on=
ly, or
> > >> >> >> the whole the libbpf itself? Is the usecase here, that you've =
built
> > >> >> >> libbpf.so with system headers X, and then would like to use th=
e
> > >> >> >> library on a system with older system headers X~10? XDP socket=
s? BTF?
> > >> >> >
> > >> >> > libbpf has to be backward and forward compatible.
> > >> >> > Once compiled it has to run on older and newer kernels.
> > >> >> > Conditional compilation is not an option obviously.
> > >> >>
> > >> >> So what do we do, then? Redefine the constants in libbpf/xsh.h if
> > >> >> they're not in the kernel header file?
> > >> >
> > >> > why? How and whom it will help?
> > >> > To libbpf.rpm creating person or to end user?
> > >>
> > >> Anyone who tries to compile a new libbpf against an older kernel. Yo=
u're
> > >> saying yourself that "libbpf has to be backward and forward compatib=
le".
> > >> Surely that extends to compile time as well as runtime?
> > >
> > > how old that older kernel?
> > > Does it have up-to-date bpf.h in /usr/include ?
> > > Also consider that running kernel is often not the same
> > > thing as installed in /usr/include
> > > vmlinux and /usr/include are different packages.
> >
> > In this case, it's a constant introduced in the kernel in the current
> > (5.4) cycle; so currently, you can't compile libbpf with
> > kernel-headers-5.3. And we're discussing how to handle this in a
> > backwards compatible way in libbpf...

If someone is compiling libbpf from sources, he has to make sure to
use libbpf's include directory (see
https://github.com/libbpf/libbpf/blob/master/include/uapi/linux/if_xdp.h),
it has all the latest XDP stuff, including XDP_RING_NEED_WAKEUP.

>
> you simply don't.
> It's not a problem to begin with.
