Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E902EEB1FF
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfJaOBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:01:11 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37467 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfJaOBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:01:11 -0400
Received: by mail-lf1-f65.google.com with SMTP id b20so4771709lfp.4;
        Thu, 31 Oct 2019 07:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bge6GLoZUXMCt/tsVrT0fhVdEglwvYwkDp9kDy2ReOY=;
        b=kK9SdjxP9g0QkpknD416zbIjdCGJSvb24I3tzZbIc68h2WGUiruQSvf9dZa5oaDlRA
         rDA+ngxxXgdQWzh381JZMJUz0XpRk+9YmvtikXCDCOiajM2OBVuzIj0MUsjtpDZk+qJX
         MwE1fXwQxCyonyv7Qlx/fneh4ab7zo/Xln3h+vY3S/pcsVg0mKZxqbA5qQd99Fabrlx6
         4CDzvDGOHvNJCVW6/cW39JtMb7CmY6bRe+KW24DVGEEhegZ5cTUkYpIWAEzFd18jytnA
         DLqa0xUI1tLuH1bdgqCy99dJzDu0POVGkMxxc6mpIovJxsKGk1KKBkePVo9flMux0sNJ
         3tCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bge6GLoZUXMCt/tsVrT0fhVdEglwvYwkDp9kDy2ReOY=;
        b=HLwdQdXP9bOBF++Tq729IsShzZIcTpt6EOpS+S8veUv7Hi/ndeifyDN36exA8GD/Y4
         ps9cuCxTbwH6WwwEDrKs2pnZBmewai2TnzaxeG6mSHokUbkHvCeoQ/xcLf0f1Obw3rIX
         DWDPdPuQBHuoxLtJ2jg/+Ve6ZaV2tRjGMXenDxJ7P9IMc/Aj0aDaCy8BOMHxqAW7cfEX
         9i5qQNOIndsDHjIVIAgfONOn9KklRkTEVoCeQqPItW8OibbNHKcBRch0k69dGokIu76g
         U1G8FEgiVLDEllyoW1dmbyTvq0GA90++eJAEd9wQW68ArLvJGOL8FrURdzVCmJOdnm+l
         Ijdw==
X-Gm-Message-State: APjAAAWh73XjFIDZQx94psVt7tb3wlspyqClFo+djv1ORvuCIJneSgll
        StAksdkYIklhi1bLKKdNLoB/Lon4jAf/ZFytaoU=
X-Google-Smtp-Source: APXvYqzG8891cwAwz9CX5GVR/wnZOUzHNkY4s+WVeM/lsh1ReUHmk+riekB2rIy/7o8Q0oSJqRfV+N9+vnbYEswM7Yk=
X-Received: by 2002:a19:4848:: with SMTP id v69mr3660588lfa.6.1572530469094;
 Thu, 31 Oct 2019 07:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
 <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
 <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
In-Reply-To: <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 31 Oct 2019 07:00:55 -0700
Message-ID: <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karlsson@gmail.com>=
 wrote:
> >
> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> > >
> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> > >
> > > > When the need_wakeup flag was added to AF_XDP, the format of the
> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the
> > > > kernel to take care of compatibility issues arrising from running
> > > > applications using any of the two formats. However, libbpf was
> > > > not extended to take care of the case when the application/libbpf
> > > > uses the new format but the kernel only supports the old
> > > > format. This patch adds support in libbpf for parsing the old
> > > > format, before the need_wakeup flag was added, and emulating a
> > > > set of static need_wakeup flags that will always work for the
> > > > application.
> > >
> > > Hi Magnus
> > >
> > > While you're looking at backwards compatibility issues with xsk: libb=
pf
> > > currently fails to compile on a system that has old kernel headers
> > > installed (this is with kernel-headers 5.3):
> > >
> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> > > In file included from <stdin>:1:
> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_wak=
eup=E2=80=99:
> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=E2=
=80=99 undeclared (first use in this function)
> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> > >       |                     ^~~~~~~~~~~~~~~~~~~~
> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is rep=
orted only once for each function it appears in
> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_addr=
=E2=80=99:
> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_ADDR=
_MASK=E2=80=99 undeclared (first use in this function)
> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_offset=
=E2=80=99:
> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_OFFS=
ET_SHIFT=E2=80=99 undeclared (first use in this function)
> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > >
> > >
> > > How would you prefer to handle this? A patch like the one below will =
fix
> > > the compile errors, but I'm not sure it makes sense semantically?
> >
> > Thanks Toke for finding this. Of course it should be possible to
> > compile this on an older kernel, but without getting any of the newer
> > functionality that is not present in that older kernel.
>
> Is the plan to support source compatibility for the headers only, or
> the whole the libbpf itself? Is the usecase here, that you've built
> libbpf.so with system headers X, and then would like to use the
> library on a system with older system headers X~10? XDP sockets? BTF?

libbpf has to be backward and forward compatible.
Once compiled it has to run on older and newer kernels.
Conditional compilation is not an option obviously.
