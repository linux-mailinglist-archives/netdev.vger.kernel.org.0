Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4607EAB76
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfJaIRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:17:19 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:46870 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:17:18 -0400
Received: by mail-oi1-f196.google.com with SMTP id c2so4388224oic.13;
        Thu, 31 Oct 2019 01:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AsoxtLFxrSGZ7PqCCP0zW/OYHdfQcjb+FPRF8H9eQ1U=;
        b=KP36VZfIvxVgAQohkhE5TvoHB8czoSqH0RwBrBXxfa9WPeprz6hAfknr/hBkyaFnJJ
         U1G9mS/R4aPe6TPScl1d07SBY7wiMPrxaWxVtyLuyo90x0UzJ6+VivkwFM0SB9FdJwuc
         ZIM1XWL4EKRl6N7xLKtppe7ktbaSdq2jNSyNydTz8IdR9hMMzCgT2R8GxmVzf5I3jATd
         1nYcnfkBDi4lweSC0AlgakQcWa2otAsAl+2RY+mKKRyy2lCHvnmh/BT7dTbCevH/UkeJ
         +EUVYv+BHfBFPpqh6WwyFCdKkuPGfT3IObmjEVBzgUb+YZkPahi7I0U/EgMZqrlgYE7Z
         D52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AsoxtLFxrSGZ7PqCCP0zW/OYHdfQcjb+FPRF8H9eQ1U=;
        b=HzN4GELOdXPS7Fjo0L+s+xVeal1Hv35yRq6NqPMzoN/DDlxXNs1OaDJy1x/LeZVvYy
         0rttj5Ss5FfWrIFioJ7wMdaBrYqycplszdAXMStXynnPEI6F1RNKM9Ltz0pQcHvZY8M2
         CYA2LySlUZqQ8Oge7BKMX5PcVY9NrzdNCGINyBO/fyWsxVo8aUp/6UA6knvqWpD5g4vD
         SdtbfO/lalc3XZ+SMCTQ2cZ3/THk8t1lYuPUB7p8AozlpBy5g2j8umQhZkzl+t+tsEvx
         Sw07Ooh9Bjug4seb4jlpEMlhWnHI6kWFdOaCi0/kvF0iil1s4/P4YHSRKsTCnq0Tl+fR
         7nsg==
X-Gm-Message-State: APjAAAWvBaqQT3GCFlpC2Wg9Hpm4LHWa2y0ucW9sizaGts0qUypBscQ4
        dIxXL5Vb7cGkD3GUaxdGVqsU4uLuFNVLBzNH7AV19K5EwdGimw==
X-Google-Smtp-Source: APXvYqyDpa3rDpKYXQ1VbPWKHb8JFVL+mW91QCjTtpW7s2BcJCMtugQKPA3TGnuYaXNs7hsT+1xh38ecossI7jI7PNo=
X-Received: by 2002:aca:c590:: with SMTP id v138mr3024216oif.126.1572509836420;
 Thu, 31 Oct 2019 01:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <1571995035-21889-1-git-send-email-magnus.karlsson@intel.com>
 <87tv7qpdbt.fsf@toke.dk> <CAJ8uoz3BPA41wmT8-Jhhs=kJ=GbsAswSvx2pEmuWJDvh+b+_yw@mail.gmail.com>
 <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
In-Reply-To: <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 31 Oct 2019 09:17:05 +0100
Message-ID: <CAJ8uoz0XTo=LcTxL_tBwzz0TAYw+=M6EDXHW7P5_LG3SN3+NBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
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

On Thu, Oct 31, 2019 at 9:03 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
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

Good question. I let someone with more insight answer this. Providing
the support Toke wants does make the header files less pleasant to
look at for sure. But in any case, I think we should provide an error
when you try to enable a new kernel feature using an old libbpf that
has no support for it. Just in case someone mixes things up.
