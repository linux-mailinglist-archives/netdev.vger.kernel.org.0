Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70424301B9F
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 12:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbhAXLy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 06:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbhAXLxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 06:53:22 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F4FC061756
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 03:52:41 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id r199so2606354oor.2
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 03:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pu6Zr2Jo68blbhpXwzl9uRs7KbDV3skHPD8u3gz3sVI=;
        b=hLK0CiEKpK6Efjx+XUatItsaWE/mRmo/IWq/x6fk1BFPF2i7i2bt6e2DFk6OygAPzE
         skDu0spVWAOL2kvuzdgaIX2Qzsskv8asVzkubHi6iX0Ny6xxFzxJjd3ejJAIKNpcdQmB
         l2s+Xraztpfd/HTF6ODoGotgqxTnd9XN8vvHZVJfZ2UjfoOC1hS7U8dgydDpnwXWPG3Z
         KVKPhLqebfmRllhbj66PsU7MRJ0MA6C01kJ1uNo0VpBNMHDFWjksnk6joesUdAeLg94o
         8DWm9RaNOF0kKvdzaOGdAbgJGAVRkvQey/hZo8Xq3kMC+AYT1hayxKGLfKPk03C3pgXo
         G36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pu6Zr2Jo68blbhpXwzl9uRs7KbDV3skHPD8u3gz3sVI=;
        b=oFqYlfc38ExrbiHrNFfo8rt5mqSa/z9TCQZ81a9e/l52055TUIp8VVLXoiIxZ8a/LL
         dQWOOhE+8z2rzw45/dZzGay99d00kU4WfZbhihcAhxD9l1UDT6fEMi+0Ci0kHqY2yb3I
         jY1oiXjqS5l3G9HWG5cpZv2Bkgrvulo8rH3gX1czOhNPr9VIoxa21XcpeqlrlEkCzuLa
         pRJHoUvJ+hPxwwCFJ49p4U56BqUGfYQwuFL6r8RMcLeWAp1WK2wfoyQID/WU4YCBLCbs
         uE5idxRSCURqIFD6vvOh6Jh/Ws/+7dCd29+TNKlKjPTOgtCnYndxyTkEla3IlLN0kazF
         WqKw==
X-Gm-Message-State: AOAM5326G9TGrAvkwY5OEQLdhuCgVs56d9szSLDTsQI7Y8DH9QLpN+x9
        HoqHcKboEXXkvKsU2jxsiJ4Pi+MQGqeesrrYv6C5Cw==
X-Google-Smtp-Source: ABdhPJwt8xWKLlXxiJG8fjcBaxoKGZnK9ey4WRGE+AXDo7swV/wzVlPEyFF7MT2HJelv6cWoDDRUCoFqXQlbsX91d4E=
X-Received: by 2002:a4a:7353:: with SMTP id e19mr9268056oof.55.1611489161343;
 Sun, 24 Jan 2021 03:52:41 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <20210112194143.1494-4-yuri.benditovich@daynix.com> <CAOEp5Ocz-xGq5=e=WY0aipEYHEhN-wxekNaAiqAS+HsOF8TcDQ@mail.gmail.com>
 <CAOEp5OevYR5FWVMfQ_esmWTKtz9_ddTupbe7FtBFQ=sv2kEt2w@mail.gmail.com> <CAADnVQJLN0sFyKdAmc6Pikv8Ww9OocnK_VXMG=ZLSMONHkqe4Q@mail.gmail.com>
In-Reply-To: <CAADnVQJLN0sFyKdAmc6Pikv8Ww9OocnK_VXMG=ZLSMONHkqe4Q@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Sun, 24 Jan 2021 13:52:29 +0200
Message-ID: <CAOEp5OeV0y5-vw3Kufe_=rszOu8QPsHPrFjtn-fAM_TJtBTuhA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Willem de Bruijn <willemb@google.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, decui@microsoft.com,
        cai@lca.pw, Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>, Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 8:45 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 12, 2021 at 12:55 PM Yuri Benditovich
> <yuri.benditovich@daynix.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 10:40 PM Yuri Benditovich
> > <yuri.benditovich@daynix.com> wrote:
> > >
> > > On Tue, Jan 12, 2021 at 9:42 PM Yuri Benditovich
> > > <yuri.benditovich@daynix.com> wrote:
> > > >
> > > > This program type can set skb hash value. It will be useful
> > > > when the tun will support hash reporting feature if virtio-net.
> > > >
> > > > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > > > ---
> > > >  drivers/net/tun.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > > index 7959b5c2d11f..455f7afc1f36 100644
> > > > --- a/drivers/net/tun.c
> > > > +++ b/drivers/net/tun.c
> > > > @@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
> > > >                 prog = NULL;
> > > >         } else {
> > > >                 prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
> > > > +               if (IS_ERR(prog))
> > > > +                       prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);
> > > >                 if (IS_ERR(prog))
> > > >                         return PTR_ERR(prog);
> > > >         }
> > >
> > > Comment from Alexei Starovoitov:
> > > Patches 1 and 2 are missing for me, so I couldn't review properly,
> > > but this diff looks odd.
> > > It allows sched_cls prog type to attach to tun.
> > > That means everything that sched_cls progs can do will be done from tun hook?
> >
> > We do not have an intention to modify the packet in this steering eBPF.
>
> The intent is irrelevant. Using SCHED_CLS here will let users modify the packet
> and some users will do so. Hence the tun code has to support it.
>
> > There is just one function that unavailable for BPF_PROG_TYPE_SOCKET_FILTER
> > that the eBPF needs to make possible to deliver the hash to the guest
> > VM - it is 'bpf_set_hash'
> >
> > Does it mean that we need to define a new eBPF type for socket filter
> > operations + set_hash?
> >
> > Our problem is that the eBPF calculates 32-bit hash, 16-bit queue
> > index and 8-bit of hash type.
> > But it is able to return only 32-bit integer, so in this set of
> > patches the eBPF returns
> > queue index and hash type and saves the hash in skb->hash using bpf_set_hash().
>
> bpf prog can only return a 32-bit integer. That's true.
> But the prog can use helpers to set any number of bits and variables.
> bpf_set_hash_v2() with hash, queue and index arguments could fit this purpose,
> but if you allow it for SCHED_CLS type,

Do I understand correctly that this means:
1. Creation of new helper like
https://lists.linuxfoundation.org/pipermail/bridge/2020-July/013036.html
2. Validation on tun side that the BPF uses only limited subset of
helpers available for SCHED_CLS

> tc side of the code should be ready to deal with that too and this extended
> helper should be meaningful for both tc and tun.
>
> In general if the purpose of the prog is to compute three values they better be
> grouped together. Returned two of them via ORed 32-bit integer and
> returning 32-bit via bpf_set_hash is an awkward api.
