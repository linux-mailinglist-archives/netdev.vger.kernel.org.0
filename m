Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2A1EAB42
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfJaIDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:03:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46396 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfJaIDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:03:08 -0400
Received: by mail-qk1-f196.google.com with SMTP id e66so5982407qkf.13;
        Thu, 31 Oct 2019 01:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XHH5Q1E0KLWmxD8JWZZyl3lVQ4k4CZTfpkZ3GVSKivg=;
        b=VV2VdF/Nv9gspv/jQ/9mC2d6jQ8Olv+eZ081oLcIrWq1+orTpxOt+jYkncGoiVzKtm
         92N9yR6EQYm9jzRO/QDaYu8BQIt+K6KCC07Xo8h9T414HqtoOwU50W0Q3tDsAipitulj
         kvIyTC+Ek8/EWYMpY1wBBxNkbUzjAXVGYCF7KAG5r/FIHolZyk76KzSTE6jPxOGLrof+
         okOb3Ei2fOkFGu9sMMRn9TiX2q3iI8Q6HZJZ2qp+wZbzBiY1Ymz1Uaz8g0hYWH6xbnpk
         axcUHZnkZ5bys3iYWRSzl4yntjH1V4qqWVoGkeFLVXM0j3jzg+oGkg2BOVyatGEOTrNT
         Xi9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XHH5Q1E0KLWmxD8JWZZyl3lVQ4k4CZTfpkZ3GVSKivg=;
        b=DCpft+YSJkoZeAh8SbnkxIC5RPErgoWmCxtnUEsgAP00d56OeI2eyg2b3Y3IFtLNtv
         5OUjIKpL8GCqrsGXmldvjcxCnAUQWp+//SFmiy/K+AjFFxLCsjFo77lOMTkJ90knBy/h
         AIyqg+Gqc76jbnledLMUpRUkc38kndALpnF8TCfIgt3wSWy5MvThf4XNvOfW6xPP6Zub
         yF/IC1wmAPkmgsP5f+aWrP/FNGWTEZSeAFP/5JlTlImhHxy66QZOFmz+TP33tfS02ebA
         OycD8PSpxAeiDgqRVvGJGjEfkB1MCHt5vwtL/0PoYO7ClLx3oNWqWuMiGHvGHORVg6mb
         oa3g==
X-Gm-Message-State: APjAAAWZFJczebmkF6R5lWNytFwKsd71CI0+0n2LxgVry1gk8VfLBqWJ
        ovLjuejs9bZXcuJ5XS4ENzh/ZpatmjSKaqFsidI=
X-Google-Smtp-Source: APXvYqz1FSY4r0N2EXGvNQjgSalH60uxTPak8AluAaHp3Ww19sU2qPkPUItzxu78+m6Xv81WS9NUXnPBIdRy6PzHf8g=
X-Received: by 2002:a37:4a14:: with SMTP id x20mr4134973qka.333.1572508987553;
 Thu, 31 Oct 2019 01:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
 <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
In-Reply-To: <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 31 Oct 2019 09:02:56 +0100
Message-ID: <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@gmail.com> w=
rote:
>
> On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> >
> > > When the need_wakeup flag was added to AF_XDP, the format of the
> > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> > > kernel to take care of compatibility issues arrising from running
> > > applications using any of the two formats. However, libbpf was
> > > not extended to take care of the case when the application/libbpf
> > > uses the new format but the kernel only supports the old
> > > format. This patch adds support in libbpf for parsing the old
> > > format, before the need_wakeup flag was added, and emulating a
> > > set of static need_wakeup flags that will always work for the
> > > application.
> >
> > Hi Magnus
> >
> > While you're looking at backwards compatibility issues with xsk: libbpf
> > currently fails to compile on a system that has old kernel headers
> > installed (this is with kernel-headers 5.3):
> >
> > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> > In file included from <stdin>:1:
> > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_wakeu=
p=E2=80=99:
> > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=E2=
=80=99 undeclared (first use in this function)
> >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> >       |                     ^~~~~~~~~~~~~~~~~~~~
> > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is repor=
ted only once for each function it appears in
> > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_addr=E2=
=80=99:
> > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_ADDR_M=
ASK=E2=80=99 undeclared (first use in this function)
> >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_offset=
=E2=80=99:
> > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_OFFSET=
_SHIFT=E2=80=99 undeclared (first use in this function)
> >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> >
> >
> > How would you prefer to handle this? A patch like the one below will fi=
x
> > the compile errors, but I'm not sure it makes sense semantically?
>
> Thanks Toke for finding this. Of course it should be possible to
> compile this on an older kernel, but without getting any of the newer
> functionality that is not present in that older kernel.

Is the plan to support source compatibility for the headers only, or
the whole the libbpf itself? Is the usecase here, that you've built
libbpf.so with system headers X, and then would like to use the
library on a system with older system headers X~10? XDP sockets? BTF?
