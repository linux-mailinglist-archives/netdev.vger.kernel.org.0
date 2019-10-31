Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D505EB241
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfJaONr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:13:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbfJaONr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572531225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JaIAZ4/4WxzbjuKpsBwY8dHaK9iBrR7/hmLOLhE1JQ=;
        b=h43OEy8LD/ApMj0gSu8lbeAu4lnkEomU69s2eWEXwnXJ/cgND/6DVsMSGV3IA56c+tsfk3
        GVjx7h4y4TwovEkKDyBCoQ8Ta8do0mYUuqd+652UZ+/MQLheOcedPsiwi/2AODGucxXVD4
        /3fdacNjZhjFQks1lF7Jruq04qOGOjs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-mhrzTP9JOMeztKRXTz1sag-1; Thu, 31 Oct 2019 10:13:44 -0400
Received: by mail-lj1-f200.google.com with SMTP id 62so1006634ljj.19
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 07:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1JaIAZ4/4WxzbjuKpsBwY8dHaK9iBrR7/hmLOLhE1JQ=;
        b=qmnpFtkTH7COOcOM9GlqqwZ37Dtg4kHOd3utLJpJH2ilXy+TU+MaM+y+Yvb+6MAnA6
         2mCHXVo1UuzJHR7MWBE4x6Tqv8jw3mfgDRLA7xrVxdqt8Ti7YgUrt0w1bo8vkiF88jDq
         zqmCeTDIeYwyA15ZdcEXeLi8fiTKMMRySvcw1Kdp3Hv2vLKTi8DR1CevYm+jGFCTS6z5
         NtSG/XUjr+lv0v/4ZraFHem868KWZ/KtPqb+lnCo9JjyRQGjNdb8N48Kc4Lc/6U71i3j
         c9uZdasSJjN00OZYrjFjA7wu4OJQ6ZRbgMCcYkTGIEPOWTo0B6RW0d5hGMi06Cc76Lk/
         sVBg==
X-Gm-Message-State: APjAAAVBHzc8J/qt6DAqtgpDmqapT21IQf7dXNyZlHv50xwe7+UzS8UR
        RhedGptXg/oIQuXxGZD+9WhNHBSXvw7Oua+gttOMQkkiLftWobTwEJP1mkiOeLDNplz8NGrxbYp
        77yOkfSvJMf+1f2HD
X-Received: by 2002:a2e:b4ba:: with SMTP id q26mr4370318ljm.60.1572531222984;
        Thu, 31 Oct 2019 07:13:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzxcrvUEbp2MzgR0pqTNG+cm0wXiNlrT3g+rQZ0fRCzx7+wgXY1DZttCG8Gk45Btxyv5oO5rQ==
X-Received: by 2002:a2e:b4ba:: with SMTP id q26mr4370303ljm.60.1572531222812;
        Thu, 31 Oct 2019 07:13:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id z13sm1364660ljj.34.2019.10.31.07.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 07:13:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C48C81818B5; Thu, 31 Oct 2019 15:13:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?utf-8?B?QmrDtnJu?= =?utf-8?B?IFTDtnBlbA==?= 
        <bjorn.topel@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
In-Reply-To: <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com> <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com> <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com> <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 15:13:40 +0100
Message-ID: <87lft1ngtn.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: mhrzTP9JOMeztKRXTz1sag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
>>
>> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@gmail.com=
> wrote:
>> >
>> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> > >
>> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
>> > >
>> > > > When the need_wakeup flag was added to AF_XDP, the format of the
>> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
>> > > > kernel to take care of compatibility issues arrising from running
>> > > > applications using any of the two formats. However, libbpf was
>> > > > not extended to take care of the case when the application/libbpf
>> > > > uses the new format but the kernel only supports the old
>> > > > format. This patch adds support in libbpf for parsing the old
>> > > > format, before the need_wakeup flag was added, and emulating a
>> > > > set of static need_wakeup flags that will always work for the
>> > > > application.
>> > >
>> > > Hi Magnus
>> > >
>> > > While you're looking at backwards compatibility issues with xsk: lib=
bpf
>> > > currently fails to compile on a system that has old kernel headers
>> > > installed (this is with kernel-headers 5.3):
>> > >
>> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
>> > > In file included from <stdin>:1:
>> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_wa=
keup=E2=80=99:
>> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=
=E2=80=99 undeclared (first use in this function)
>> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
>> > >       |                     ^~~~~~~~~~~~~~~~~~~~
>> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is re=
ported only once for each function it appears in
>> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_addr=
=E2=80=99:
>> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_ADD=
R_MASK=E2=80=99 undeclared (first use in this function)
>> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
>> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_offse=
t=E2=80=99:
>> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_OFF=
SET_SHIFT=E2=80=99 undeclared (first use in this function)
>> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
>> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> > >
>> > >
>> > >
>> > > How would you prefer to handle this? A patch like the one below will=
 fix
>> > > the compile errors, but I'm not sure it makes sense semantically?
>> >
>> > Thanks Toke for finding this. Of course it should be possible to
>> > compile this on an older kernel, but without getting any of the newer
>> > functionality that is not present in that older kernel.
>>
>> Is the plan to support source compatibility for the headers only, or
>> the whole the libbpf itself? Is the usecase here, that you've built
>> libbpf.so with system headers X, and then would like to use the
>> library on a system with older system headers X~10? XDP sockets? BTF?
>
> libbpf has to be backward and forward compatible.
> Once compiled it has to run on older and newer kernels.
> Conditional compilation is not an option obviously.

So what do we do, then? Redefine the constants in libbpf/xsh.h if
they're not in the kernel header file?

-Toke

