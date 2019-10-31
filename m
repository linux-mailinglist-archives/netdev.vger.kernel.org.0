Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A094EACDD
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfJaJum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:50:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20351 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727130AbfJaJul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572515439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2L4Tl+UeB1xHx8kUfxkmKnMRxJrK1JkQKe0a5oMFop8=;
        b=d8Nz61OiUB/VImvn/LZASkq4RpojJwKSjCclkjPP28BDtb/j/ysbJmqgVoxesA4EaFPnRf
        r8WDjdDdnkBi9ijQxrKrgK1aiM7meVD4DJhCRbJWjpR/Hlm16fIS3fLCw4Ill91H+PtNY2
        nbWpqGsDa6EuXegEtoe7QgUxjAfGEwc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-9PgWN7kUNQalus9HVqzKCA-1; Thu, 31 Oct 2019 05:50:38 -0400
Received: by mail-lf1-f70.google.com with SMTP id c15so1185710lfg.4
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 02:50:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=2L4Tl+UeB1xHx8kUfxkmKnMRxJrK1JkQKe0a5oMFop8=;
        b=NUsSoPL3UBoKGmiYwhnm7UDOuwXF0jxNuuCCDuowks9wshu4W+T8e3D7uPZLmTtTFA
         l5VmwXgwnKYOl3Uc1QSZvvFKUAlBSdD26fM+RPcsGvzXI6L0Vv5BqIOaj7IHQIMJoot8
         Ul3A+hbfoKC9lplPeCD9esDiz0NygRXhJ3WyZYEGIZL5uBycW8/hqjabDJQyTN1q4/5w
         p6N2ymF+xVoKSuWe2cPqUBtZSIXll5kzX1EcmNvQOYlwRdjHvLqAIZPFDVhFzdbG379T
         hQTWEG+WX3IY23uCrtj/S7OcVtbnNulqgIsXBNnXyzBwPP/W2Cwv/cERPaGFd+bik52K
         aEiA==
X-Gm-Message-State: APjAAAV8x4V0fV1Gi8jXsbg88f5QnThBn9QCvmfSsiS7p+4gZ6gBGjjK
        d4oyHFjHtbT3YbcGxB+kxTpOFicUNybSvMrZRcCXEDaWHY822ptaIY8UDrNuifB2L6W5ggzTdsm
        /wWXuIuD6NUC33Ifr
X-Received: by 2002:a05:651c:331:: with SMTP id b17mr3394291ljp.133.1572515436556;
        Thu, 31 Oct 2019 02:50:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwQA6mGOciiyXa4d/BkzuBNJn3vEC2QlCbs9tLwzRYN2dK8f0Z47d0SO8jPQjzNUx0Rux4h7Q==
X-Received: by 2002:a05:651c:331:: with SMTP id b17mr3394275ljp.133.1572515436336;
        Thu, 31 Oct 2019 02:50:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y189sm2311572lfc.9.2019.10.31.02.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 02:50:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D0B421818B5; Thu, 31 Oct 2019 10:50:34 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFQ=?= =?utf-8?B?w7ZwZWw=?= 
        <bjorn.topel@intel.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
In-Reply-To: <CAJ8uoz0XTo=LcTxL_tBwzz0TAYw+=M6EDXHW7P5_LG3SN3+NBQ@mail.gmail.com>
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com> <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com> <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com> <CAJ8uoz0XTo=LcTxL_tBwzz0TAYw+=M6EDXHW7P5_LG3SN3+NBQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 10:50:34 +0100
Message-ID: <87eeytp7kl.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 9PgWN7kUNQalus9HVqzKCA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson <magnus.karlsson@gmail.com> writes:

> On Thu, Oct 31, 2019 at 9:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
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
> Good question. I let someone with more insight answer this. Providing
> the support Toke wants does make the header files less pleasant to
> look at for sure. But in any case, I think we should provide an error
> when you try to enable a new kernel feature using an old libbpf that
> has no support for it. Just in case someone mixes things up.

Yup, I agree. Removing the functions completely is fine with me. As for
the flags, I agree that having a check in libbpf would make sense; I can
see someone upgrading their kernel, but still using the distro-specified
libbpf and running into weird errors otherwise.

Maybe we should define XDP_FLAGS_ALL in if_xdp.h and use that for the
check in both libbpf and the kernel? We'd still need conditional defines
for backwards compatibility, but at least we wouldn't need to keep
updating that as new flags are added?

-Toke

