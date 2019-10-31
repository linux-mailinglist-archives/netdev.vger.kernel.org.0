Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43A0EB2A3
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfJaO0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:26:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53853 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727742AbfJaO0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:26:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572532008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4PtaMv/mx6H1gx+P01eE+sC5t1/ey3YFIgDcXaawuk=;
        b=MfT+Xo5ZVInI1x+tWym+zqES/R86p3uMZWOAw6j6oCRXRk0Wo1Z5nBDU5BK0upZYPjo5hs
        qfu+NObYjWhu0wjRMX4A50NPvblRdkAFjfGu5dNamT32X2fHs9JJ1mtnSYunb3TosWomIA
        67cpY22K6Rjy+YV02CqiT/hax6y+4/Q=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-bzGQdVt9MpiiogHRZL7afA-1; Thu, 31 Oct 2019 10:26:46 -0400
Received: by mail-lf1-f70.google.com with SMTP id t27so1437601lfk.21
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 07:26:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=SdvY/IpPAnteFJxMnLEdwIM/xtRBnQEbsXrCmc7D72s=;
        b=DhJJ8y7aufSRrwLHtUNu//Umm2OoIUHT8UZhupGwHI0aMYMbgL0SWF71h75zxOI8ld
         sQxwxy5OqD4tMNAxAdwJe6KJA7Ym/yFcSgQK/efYhvXhd8l4b9h69gP6wZYRwhrwsdGO
         DPG+WFXc7V37jGhTLsf8r1XHYoFTjnt9bCBOPollmCTaON+CRuOYLmgDGaPb325Idnkz
         dX8nXndQQzykJA77KjiiKi4Cn7uAVWNHOIRfbL62VeZNZrxdVR8y3jIkzLABDCwz97FK
         SNGUej/jmvt5sA0uK2DD6AvD9oeYLYxZ5iWiaUu5yRe8WpKmgHN7rVNzXPBVL5gEO+6J
         FVWA==
X-Gm-Message-State: APjAAAUnlGBuN0v2gOEHf+frjSI61kUm0VHFemthAT+Ln0LH+yUnvN3Z
        NoCecRAMGXdN04rlE/dFqDdWDQQm/BB0sYxaaW8qAWjsE3AW2Pw08sTd5suCwhHqgecJas/JUUc
        8XIfWZH6rLTAyDOBw
X-Received: by 2002:a05:6512:21e:: with SMTP id a30mr3742751lfo.175.1572532004778;
        Thu, 31 Oct 2019 07:26:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw/i1gRLT3vkwvi9aiSmG8wB2tFV/fxLAnutqKXEtpAhkgtXTCtfGK9C7+UrODuo1A8nfyvVA==
X-Received: by 2002:a05:6512:21e:: with SMTP id a30mr3742741lfo.175.1572532004595;
        Thu, 31 Oct 2019 07:26:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a26sm1736690lfg.50.2019.10.31.07.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 07:26:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0E3321818B5; Thu, 31 Oct 2019 15:26:43 +0100 (CET)
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
In-Reply-To: <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com> <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com> <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com> <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com> <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 15:26:43 +0100
Message-ID: <87imo5ng7w.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: bzGQdVt9MpiiogHRZL7afA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gma=
il.com> wrote:
>> >>
>> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@gmail.=
com> wrote:
>> >> >
>> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
>> >> > >
>> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
>> >> > >
>> >> > > > When the need_wakeup flag was added to AF_XDP, the format of th=
e
>> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
>> >> > > > kernel to take care of compatibility issues arrising from runni=
ng
>> >> > > > applications using any of the two formats. However, libbpf was
>> >> > > > not extended to take care of the case when the application/libb=
pf
>> >> > > > uses the new format but the kernel only supports the old
>> >> > > > format. This patch adds support in libbpf for parsing the old
>> >> > > > format, before the need_wakeup flag was added, and emulating a
>> >> > > > set of static need_wakeup flags that will always work for the
>> >> > > > application.
>> >> > >
>> >> > > Hi Magnus
>> >> > >
>> >> > > While you're looking at backwards compatibility issues with xsk: =
libbpf
>> >> > > currently fails to compile on a system that has old kernel header=
s
>> >> > > installed (this is with kernel-headers 5.3):
>> >> > >
>> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
>> >> > > In file included from <stdin>:1:
>> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs=
_wakeup=E2=80=99:
>> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEU=
P=E2=80=99 undeclared (first use in this function)
>> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
>> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
>> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is=
 reported only once for each function it appears in
>> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_ad=
dr=E2=80=99:
>> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_=
ADDR_MASK=E2=80=99 undeclared (first use in this function)
>> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
>> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_of=
fset=E2=80=99:
>> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_=
OFFSET_SHIFT=E2=80=99 undeclared (first use in this function)
>> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
>> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> >> > >
>> >> > >
>> >> > >
>> >> > > How would you prefer to handle this? A patch like the one below w=
ill fix
>> >> > > the compile errors, but I'm not sure it makes sense semantically?
>> >> >
>> >> > Thanks Toke for finding this. Of course it should be possible to
>> >> > compile this on an older kernel, but without getting any of the new=
er
>> >> > functionality that is not present in that older kernel.
>> >>
>> >> Is the plan to support source compatibility for the headers only, or
>> >> the whole the libbpf itself? Is the usecase here, that you've built
>> >> libbpf.so with system headers X, and then would like to use the
>> >> library on a system with older system headers X~10? XDP sockets? BTF?
>> >
>> > libbpf has to be backward and forward compatible.
>> > Once compiled it has to run on older and newer kernels.
>> > Conditional compilation is not an option obviously.
>>
>> So what do we do, then? Redefine the constants in libbpf/xsh.h if
>> they're not in the kernel header file?
>
> why? How and whom it will help?
> To libbpf.rpm creating person or to end user?

Anyone who tries to compile a new libbpf against an older kernel. You're
saying yourself that "libbpf has to be backward and forward compatible".
Surely that extends to compile time as well as runtime?

-Toke

