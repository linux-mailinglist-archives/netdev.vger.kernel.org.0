Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E037EB33A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbfJaOwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:52:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29484 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728302AbfJaOwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572533561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Br/pVIeopOexMRdit1UgpyI3J2jmcX3ZsQH9LphgRUs=;
        b=hZSo4Aip6eA6hXdU/Pv7HPY3Qek5HaNYJ7oXI1ayaouqPRbEqsjBNbDsXXnXd3/OxZvVkB
        RsOaYnFUGH6koU+EEPPZDwzg6PE+Fac0m/RjhDPwoBQVh0XlYCZBuPX0Idbsl6WaZmZRHW
        hS5Fzkmd6EFTbxP4yE2zJjIHcv0mvek=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-EAMUJj77NGW3N1zO_9RULA-1; Thu, 31 Oct 2019 10:52:37 -0400
Received: by mail-lf1-f71.google.com with SMTP id p4so1459245lfo.10
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 07:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Mv0pgq6n/5fDFiIucejQhqR+ae//0GDCi/KlF2QfeEY=;
        b=aGEQtf+AmNV3GCglkbKtW3ZYPMMo8uDXEk1FGk3OOp2bBxnt4hV0ooyNtk9af1GT9c
         H3vTKz27uXEQOiqlZJEOI1hsx2pCdz3LqZ4pqQUJfg8HrCo+vN5w9VlT5HRjBruXfUUH
         x1ypJlpC9E7gDr/P4VAMzS5nDEig/YE6mWzJ8TC6+reo7UjczDZFsAOYR4xcuIqL5p5p
         s4NmSXT6fWOPEPfzIpyU4CoBd9mOmeaAg5LMVPhNuFBhk9Qr92/ZNGNgBLxxXSSWYXjm
         oRyhzj0QorrEBoaiSHmIXkhOZoW5kN3I7/QSaNj7INm+d5eRUkBPg9xM8PaDmPILe9b2
         Vn3w==
X-Gm-Message-State: APjAAAVrlBqO2q6bdMIFp2Ddpqrz0e0hWOWqa0eto3kB/sl2TOwwImkd
        tGvLRP3WZH5TvMRVUHYqY8Z7SD2+fOJ1KUBhYbalLHckvr3i1N961Lyxow+wleRvtr9cju6KHni
        1JJYGmOAN8cgqF90E
X-Received: by 2002:a2e:3514:: with SMTP id z20mr4348533ljz.84.1572533556379;
        Thu, 31 Oct 2019 07:52:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwozLeK1OulL35EZ+FygdO+ykmIkeqzGoXA1isTbaOGYie2IPmnWzcNoUS8Vkha1W7BxCKrZA==
X-Received: by 2002:a2e:3514:: with SMTP id z20mr4348516ljz.84.1572533556118;
        Thu, 31 Oct 2019 07:52:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id f14sm1225293ljn.105.2019.10.31.07.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 07:52:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B49761818B5; Thu, 31 Oct 2019 15:52:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
In-Reply-To: <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com> <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com> <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com> <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com> <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com> <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 15:52:34 +0100
Message-ID: <87d0ednf0t.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: EAMUJj77NGW3N1zO_9RULA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Oct 31, 2019 at 7:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >>
>> >> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@=
gmail.com> wrote:
>> >> >>
>> >> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@gma=
il.com> wrote:
>> >> >> >
>> >> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen=
 <toke@redhat.com> wrote:
>> >> >> > >
>> >> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
>> >> >> > >
>> >> >> > > > When the need_wakeup flag was added to AF_XDP, the format of=
 the
>> >> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to =
the
>> >> >> > > > kernel to take care of compatibility issues arrising from ru=
nning
>> >> >> > > > applications using any of the two formats. However, libbpf w=
as
>> >> >> > > > not extended to take care of the case when the application/l=
ibbpf
>> >> >> > > > uses the new format but the kernel only supports the old
>> >> >> > > > format. This patch adds support in libbpf for parsing the ol=
d
>> >> >> > > > format, before the need_wakeup flag was added, and emulating=
 a
>> >> >> > > > set of static need_wakeup flags that will always work for th=
e
>> >> >> > > > application.
>> >> >> > >
>> >> >> > > Hi Magnus
>> >> >> > >
>> >> >> > > While you're looking at backwards compatibility issues with xs=
k: libbpf
>> >> >> > > currently fails to compile on a system that has old kernel hea=
ders
>> >> >> > > installed (this is with kernel-headers 5.3):
>> >> >> > >
>> >> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
>> >> >> > > In file included from <stdin>:1:
>> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__ne=
eds_wakeup=E2=80=99:
>> >> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WA=
KEUP=E2=80=99 undeclared (first use in this function)
>> >> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
>> >> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
>> >> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier=
 is reported only once for each function it appears in
>> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract=
_addr=E2=80=99:
>> >> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_B=
UF_ADDR_MASK=E2=80=99 undeclared (first use in this function)
>> >> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
>> >> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract=
_offset=E2=80=99:
>> >> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_B=
UF_OFFSET_SHIFT=E2=80=99 undeclared (first use in this function)
>> >> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
>> >> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> >> >> > >
>> >> >> > >
>> >> >> > >
>> >> >> > > How would you prefer to handle this? A patch like the one belo=
w will fix
>> >> >> > > the compile errors, but I'm not sure it makes sense semantical=
ly?
>> >> >> >
>> >> >> > Thanks Toke for finding this. Of course it should be possible to
>> >> >> > compile this on an older kernel, but without getting any of the =
newer
>> >> >> > functionality that is not present in that older kernel.
>> >> >>
>> >> >> Is the plan to support source compatibility for the headers only, =
or
>> >> >> the whole the libbpf itself? Is the usecase here, that you've buil=
t
>> >> >> libbpf.so with system headers X, and then would like to use the
>> >> >> library on a system with older system headers X~10? XDP sockets? B=
TF?
>> >> >
>> >> > libbpf has to be backward and forward compatible.
>> >> > Once compiled it has to run on older and newer kernels.
>> >> > Conditional compilation is not an option obviously.
>> >>
>> >> So what do we do, then? Redefine the constants in libbpf/xsh.h if
>> >> they're not in the kernel header file?
>> >
>> > why? How and whom it will help?
>> > To libbpf.rpm creating person or to end user?
>>
>> Anyone who tries to compile a new libbpf against an older kernel. You're
>> saying yourself that "libbpf has to be backward and forward compatible".
>> Surely that extends to compile time as well as runtime?
>
> how old that older kernel?
> Does it have up-to-date bpf.h in /usr/include ?
> Also consider that running kernel is often not the same
> thing as installed in /usr/include
> vmlinux and /usr/include are different packages.

In this case, it's a constant introduced in the kernel in the current
(5.4) cycle; so currently, you can't compile libbpf with
kernel-headers-5.3. And we're discussing how to handle this in a
backwards compatible way in libbpf...

-Toke

