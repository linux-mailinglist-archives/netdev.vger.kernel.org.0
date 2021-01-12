Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FC32F3D56
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436801AbhALVh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437064AbhALU4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:56:00 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FF0C061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:55:20 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id j20so3647908otq.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 12:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uD2LwoNsLHO2bQTapcwBrSqoHTZzd1YmNCw2S92ag9Q=;
        b=Y43uZ7bLVKMqH9GbZ4BYcx2lvxcJ2i103HsmZiv7+g4ZppufN2r5P61wpRmKjQtDm+
         6Iw5P4Q3jCWLRJntB2VAsKmOyFWepWSPdDNfMwp7rBHOArihxsXGpviAmbLDbLReNp5T
         1GsQFLXpkPd3O8YBg1d9ys2pl+Y2iRrBcQPXibs/a8PG64RIBsakJm4UbXN4O3AmUBMB
         LcWcVtFHbgPEspus3oJa8xqqPKE6R8KJiuW56r+SCcE5YMmlzY88EwbtWXVIvz2bjoYL
         9avkyk50tPvH0NmYp6atvBDNCPwlyY5Wzt+QY/5vlJHqedpwjVB5eQYvs1hgfE8jwBFg
         z4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uD2LwoNsLHO2bQTapcwBrSqoHTZzd1YmNCw2S92ag9Q=;
        b=kGMlG0hgdPkfE9fhnJDggSDw9TW9mw0G4PyxggOJ6Z4dw742fgg2p+I7fzELzTf3pQ
         rR3ZaRqz33IOOxyT6nZ5FYRP0gSU/Pkv+CQar6Tojr+kdjjC4VirB1XZpRsGoi375Gpp
         AN9YefKE4wVjurt1UlLgVukvQu6wfiB2hoGNHJoZGiEx9wQYPQOK/tbuAMIaKDPQ3loA
         IF+3uuRAEjpWZzdZtUcFwvp2jIBn8IFqS97sShTom5qDjCiTRtNpVDgSrT6Yv5L2qDkr
         ipq6ph0tMd0ebb1Hgizcq0ucPN+eGeSDnkVQth7rZW63j6nEykPN1MDk3GT90a8vmD+h
         3yuw==
X-Gm-Message-State: AOAM533b8XUKH2wXqlXpLBg9/9Mi1T4cc8bx8CFt+u3N2kPaYez1SeiB
        moaRx+S2HWkv3OK621/rUSrEm1X4BxYDTv1nbnfZvw==
X-Google-Smtp-Source: ABdhPJyg8eUeNmxDa4BkruWI0L3XjU5KjUa3gveljnrKGwGHBS2TJW6ZNkMgbXD0kYdCRDnkUgmQJ6NHb8T8kPmTb+c=
X-Received: by 2002:a05:6830:572:: with SMTP id f18mr874911otc.109.1610484919603;
 Tue, 12 Jan 2021 12:55:19 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <20210112194143.1494-4-yuri.benditovich@daynix.com> <CAOEp5Ocz-xGq5=e=WY0aipEYHEhN-wxekNaAiqAS+HsOF8TcDQ@mail.gmail.com>
In-Reply-To: <CAOEp5Ocz-xGq5=e=WY0aipEYHEhN-wxekNaAiqAS+HsOF8TcDQ@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 12 Jan 2021 22:55:07 +0200
Message-ID: <CAOEp5OevYR5FWVMfQ_esmWTKtz9_ddTupbe7FtBFQ=sv2kEt2w@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, rdunlap@infradead.org,
        willemb@google.com, gustavoars@kernel.org,
        herbert@gondor.apana.org.au, steffen.klassert@secunet.com,
        pablo@netfilter.org, decui@microsoft.com, cai@lca.pw,
        jakub@cloudflare.com, elver@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        bpf@vger.kernel.org
Cc:     Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 10:40 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> On Tue, Jan 12, 2021 at 9:42 PM Yuri Benditovich
> <yuri.benditovich@daynix.com> wrote:
> >
> > This program type can set skb hash value. It will be useful
> > when the tun will support hash reporting feature if virtio-net.
> >
> > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > ---
> >  drivers/net/tun.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index 7959b5c2d11f..455f7afc1f36 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
> >                 prog = NULL;
> >         } else {
> >                 prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
> > +               if (IS_ERR(prog))
> > +                       prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);
> >                 if (IS_ERR(prog))
> >                         return PTR_ERR(prog);
> >         }
>
> Comment from Alexei Starovoitov:
> Patches 1 and 2 are missing for me, so I couldn't review properly,
> but this diff looks odd.
> It allows sched_cls prog type to attach to tun.
> That means everything that sched_cls progs can do will be done from tun hook?

We do not have an intention to modify the packet in this steering eBPF.
There is just one function that unavailable for BPF_PROG_TYPE_SOCKET_FILTER
that the eBPF needs to make possible to deliver the hash to the guest
VM - it is 'bpf_set_hash'

Does it mean that we need to define a new eBPF type for socket filter
operations + set_hash?

Our problem is that the eBPF calculates 32-bit hash, 16-bit queue
index and 8-bit of hash type.
But it is able to return only 32-bit integer, so in this set of
patches the eBPF returns
queue index and hash type and saves the hash in skb->hash using bpf_set_hash().

If this is unacceptable, can you please recommend a better solution?

> sched_cls assumes l2 and can modify the packet.

The steering eBPF in TUN module also assumes l2.

> I think crashes are inevitable.
>
> > --
> > 2.17.1
> >
