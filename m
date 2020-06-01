Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398BC1EB1E6
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgFAWwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgFAWwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:52:16 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CCEC05BD43;
        Mon,  1 Jun 2020 15:52:16 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k22so9138837qtm.6;
        Mon, 01 Jun 2020 15:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wCyXF8Y44pWVAvvZQ9x9wVuqA2QTlbBJnNFE9gJZajQ=;
        b=pahSlszMnsYp0pnlcAdDrpI0EJt741LCW1wq2iR1By+45yrOjC2pjue7pBBMWjEbWi
         H+GU5ocdaHZkOsTu3ochFBvoQFFjlCHZzBdBhoOZkInYuB3/TL7L4Emup/K8v8uC3DtQ
         FwRgg+Wy/qRGuc//nenUI3+BhX9XL+yCbsXnsz12Deq87tn03PBUEMSqyy6jDPidEel7
         WW1L4kSthNZJUJnD5iEmeZe3n+Gu6mzTqvxjhMYXGda8jGKFArpJVhy+kEAq3mDX3KkE
         Tv/5IJchseRlGDk/++F4Sj4Xh4OhhZ9v7zS+CEumBdsklLWxKjD3D0yYEgTlj/viZs0k
         TTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wCyXF8Y44pWVAvvZQ9x9wVuqA2QTlbBJnNFE9gJZajQ=;
        b=GNAPnl5lxAqaNIhGhla7f2EgxdmRnJ0inwgvVcQRGirC6j37D2V9OHojsASuXIkjha
         1rdxZWPyyGhuxkfjRZOU21azjIDHwg06Gwjs1N0reaQ5Pd8YnZ4xAbmOKxxjrCXNrcnM
         OuQDdNpNcEaXfrohHvZBqdKIZnvgtj4yY+yyBFdMKHIjsDuD4cW+UPjmPaUmCpOpKg9f
         bU/irct+tiarqUtDtqx2CkDNVNzCybsLU2Rq7/EH+MGi5rkBThSynBb3t0K4SBlGg3+2
         uY6CHb7ssakCipsv+inr2ZhHXakvCRnKmUoTRWBt/y1Y18JbVCdWBq0jwovVFkFQRmmg
         GdMg==
X-Gm-Message-State: AOAM533aXWr41vkcq7fe8yyRFG3kbswxBQcBhaGPf57SjoJYxGARHB0x
        rWzqDcz8sN6GUmachl+jtyWXh1v0Zis0h/WK0lo=
X-Google-Smtp-Source: ABdhPJzVkls1pq9JurS6uAvuSLgFP7czzFrScE6MzwZrvFE5wxU4s3cADPA83p++zIpe+zqjAS3eZneBgWC986m+Gs8=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr23632959qta.141.1591051936014;
 Mon, 01 Jun 2020 15:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200529220716.75383-1-dsahern@kernel.org> <CAADnVQK1rzFfzcQX-EGW57=O2xnz2pjX5madnZGTiAsKnCmbHA@mail.gmail.com>
 <ed66bdc6-4114-2ecf-1812-176d0250730b@gmail.com>
In-Reply-To: <ed66bdc6-4114-2ecf-1812-176d0250730b@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jun 2020 15:52:05 -0700
Message-ID: <CAEf4BzaYU7-JhjnStL_JWVtL1-8wuB1ZcJkxoN01_bbKvdyaqA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/5] bpf: Add support for XDP programs in
 DEVMAP entries
To:     David Ahern <dsahern@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 3:28 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/1/20 3:12 PM, Alexei Starovoitov wrote:
> > In patch 5 I had to fix:
> > /data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_dev=
map_attach.c:
> > In function =E2=80=98test_neg_xdp_devmap_helpers=E2=80=99:
> > /data/users/ast/net-next/tools/testing/selftests/bpf/test_progs.h:106:3=
:
> > warning: =E2=80=98duration=E2=80=99 may be used uninitialized in this f=
unction
> > [-Wmaybe-uninitialized]
> >   106 |   fprintf(stdout, "%s:PASS:%s %d nsec\n",   \
> >       |   ^~~~~~~
> > /data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_dev=
map_attach.c:79:8:
> > note: =E2=80=98duration=E2=80=99 was declared here
> >    79 |  __u32 duration;
>
> What compiler version? it compiles cleanly with ubuntu 20.04 and gcc
> 9.3. The other prog_tests are inconsistent with initializing it.

Do you have specific examples of inconsistencies? Seems like duration is:
1. either static variable, and thus zero-initialized;
2. is initialized explicitly at declaration;
3. is filled out with bpf_prog_test_run().

>
> >
> > and that selftest is imo too primitive.
>
> I focused the selftests on API changes introduced by this set - new
> attach type, valid accesses to egress_ifindex and not allowing devmap
> programs with xdp generic.
>
> > It's only loading progs and not executing them.
> > Could you please add prog_test_run to it?
> >
>
> I will look into it.
