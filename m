Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC3AEC5E6
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfKAPvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:51:55 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37802 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbfKAPvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:51:55 -0400
Received: by mail-lj1-f196.google.com with SMTP id v2so10725595lji.4;
        Fri, 01 Nov 2019 08:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xqzdx/d3uT46BorrAyM2SzON5tjFMVs4yg7a19FHARE=;
        b=hPxJOJJ+qkRi1rxrm9Lq6VU4WIRBITiNPdv1np3f1JmUZ+v7oDJsL9PdVSTQU4lc5U
         hmi+63G+RJIwk28JKDLg38zObHcx9tspyYKFUUFre7kF7ozohyoabbb0JdYsdemjI4XQ
         dYDJYY9aUosBXKbDSasIlPngZq0dnI5zCMGnVvIKje0kqW1Xk6ES3eNK2reMOrK0KScv
         gdVzG0p7nebt45oBfGx0oMhSXwfjzWMTKYnHn8H1hgu2V478Y4l6sCSYWiejrf7L6wwY
         tgePJFAjhym+5ngICVdcwuBBuqTx2s9KPqbC28zAy8GZM1vZ1+a58xPU5wuisukLhTcH
         /8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xqzdx/d3uT46BorrAyM2SzON5tjFMVs4yg7a19FHARE=;
        b=skg8oXm2Hr/Wn+fcnBWy5CNU01j9Ah3qa5FSuRaXVBxf15uj3rfQHoI5L75gNHPeQW
         Brrf3EpNsHuyBzeDo7h9MOtRqGBNI0uJcme4/eD+a6MiZPkTDJtHKyW8RAx9c2LjsGIZ
         NbnncqDcgTCzOD0vEaLrbjUOTTq4kB5Tolcee/4E8EoWNUxkOn08yLJ4W1wPFXhedKKy
         R6RbWy2Ggg2XWX12wNMXQ8Hqd9sk2fHp1Z8SegWP3rnJTDBXNcjFanCSzF/EnDBWIP2C
         1eGm2xLmcwc2d7sSooRxoZY1ghF7YoXUyRBVJusz8jKLgFXKQpi1Doe7I6lmZOcAGcsJ
         Hy3w==
X-Gm-Message-State: APjAAAVQwIqTuVxAA0DCAMYJEhzMU3uGNiIzIcNRbNbtdkhHKujZn8U5
        XO/o7GdDFPrFQ3/mH4n//2ZWh1fv7tyj9I67K3o=
X-Google-Smtp-Source: APXvYqxbKPJsbuzH8apAhGmlTFlRzl+ch2quU5PkH9PNsb4giYQKfKQ8BtOdgjBwHpsR34rKjckfiULkTftgkqoObgo=
X-Received: by 2002:a2e:2e10:: with SMTP id u16mr4962034lju.51.1572623513309;
 Fri, 01 Nov 2019 08:51:53 -0700 (PDT)
MIME-Version: 1.0
References: <87lft1ngtn.fsf@toke.dk> <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk> <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk> <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
 <20191031174208.GC2794@krava> <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
 <20191031191815.GD2794@krava> <CAADnVQJdAZS9AHx_B3SZTcWRdigZZsK1ccsYZK0qUsd1yZQqbw@mail.gmail.com>
 <20191101072707.GE2794@krava>
In-Reply-To: <20191101072707.GE2794@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 1 Nov 2019 08:51:41 -0700
Message-ID: <CAADnVQJnTuADcPizsD+hFx4Rvot0nqiX83M+ku4Nu_qLh2_vyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels without need_wakeup
To:     Jiri Olsa <jolsa@redhat.com>
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

On Fri, Nov 1, 2019 at 12:27 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Oct 31, 2019 at 01:39:12PM -0700, Alexei Starovoitov wrote:
> > On Thu, Oct 31, 2019 at 12:18 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > yes. older vmlinux and newer installed libbpf.so
> > > > or any version of libbpf.a that is statically linked into apps
> > > > is something that libbpf code has to support.
> > > > The server can be rebooted into older than libbpf kernel and
> > > > into newer than libbpf kernel. libbpf has to recognize all these
> > > > combinations and work appropriately.
> > > > That's what backward and forward compatibility is.
> > > > That's what makes libbpf so difficult to test, develop and code rev=
iew.
> > > > What that particular server has in /usr/include is irrelevant.
> > >
> > > sure, anyway we can't compile following:
> > >
> > >         tredaell@aldebaran ~ $ echo "#include <bpf/xsk.h>" | gcc -x c=
 -
> > >         In file included from <stdin>:1:
> > >         /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__n=
eeds_wakeup=E2=80=99:
> > >         /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_W=
AKEUP=E2=80=99 undeclared (first use in this function)
> > >            82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> > >         ...
> > >
> > >         XDP_RING_NEED_WAKEUP is defined in kernel v5.4-rc1 (77cd0d7b3=
f257fd0e3096b4fdcff1a7d38e99e10).
> > >         XSK_UNALIGNED_BUF_ADDR_MASK and XSK_UNALIGNED_BUF_OFFSET_SHIF=
T are defined in kernel v5.4-rc1 (c05cd3645814724bdeb32a2b4d953b12bdea5f8c)=
.
> > >
> > > with:
> > >   kernel-headers-5.3.6-300.fc31.x86_64
> > >   libbpf-0.0.5-1.fc31.x86_64
> > >
> > > if you're saying this is not supported, I guess we could be postponin=
g
> > > libbpf rpm releases until we have the related fedora kernel released
> >
> > why? github/libbpf is the source of truth for building packages
> > and afaik it builds fine.
>
> because we will get issues like above if there's no kernel
> avilable that we could compile libbpf against

what is the issue again?
bpf-next builds fine. github/libbpf builds fine.
If distro is doing something else it's distro's mistake.
