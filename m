Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F682F9D03
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389162AbhARKms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388562AbhARJRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 04:17:34 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4952DC061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 01:16:52 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id o5so3935607oop.12
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 01:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSK+lvyQA4uXA5xPhZ/8h6A7IFG5qSuPlS2fMmSK9uE=;
        b=g0OihKEQp3iql/CK/5EC0JwmqXVTR+AOVENIOuGMPFsGSeHvvkxftBiA9Mu5HHh+Dt
         yvdAaWFsnRmu/efRdYIFkFNmcwDY8n4XbSXOGUbzF5HMyG2W6010KLYjXpnOvsskibZO
         41hEyNwNAI1zV/ra54yz7iIQq6oPLY47r80NacYWAAwb5D3RUTBWZXYtnHP66WVTtG6g
         9MLMjmxBLg1sV9mbRo4JoyerLfkcZl/BKB52D6wLSbFj5QWAETS8bW05NLyQ1eOxD3DM
         RwBSlkQU9mbctTrNWvRgt1eLrUWZbgF/aXRyp0nsHBbGv+pc8JZJer9XJF9JbSxim1YM
         0wEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSK+lvyQA4uXA5xPhZ/8h6A7IFG5qSuPlS2fMmSK9uE=;
        b=cuJi0q4JhCXBgM7moWXonHWseScRyUavXKSzq10uwdR/FfPOOsqL1HNCP+ont6ytJU
         nYV7mX7056+d4F/SxYK8FU+5kjdlKb5guCF3d407aYFAv7pkc2O78pmWAmdNYEblYSwr
         udwCWN17CXc98X0FH3OJE2KszxG2jigw78MeOKncMN/B0nxvgDbK8OTAJ8NzLNrQ9CV/
         YV++6jP5LlTaqsqlSZgxgXKRKqoL/UH1kEcvITTEbzuEkkNt11NX9ULf4xZ4XyyXx/EA
         qtW86+8lAuv8Gw+rB0a2Ld4HAnuZZCg+zMpzTQJbiwFT/Wa8LVnV+6EeyH7SD895Z3I3
         bGPQ==
X-Gm-Message-State: AOAM533EIjtK/leYRt4S+ENpA3shdHTLjIy0t1kDjDJwzDrjUusnKNjo
        KKaSMPvkNr33voYuPukDoxr1OII3JQ/91+VWFhAhnA==
X-Google-Smtp-Source: ABdhPJzqTOl3MqL0bVrAhDZtCS3mLYK4WgEB46OSUFecnlcwl11ttUt9pEepSbvh3bw3kfb4oCIECDbWZljHghrIAlk=
X-Received: by 2002:a4a:d396:: with SMTP id i22mr16311455oos.55.1610961411680;
 Mon, 18 Jan 2021 01:16:51 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <20210112194143.1494-4-yuri.benditovich@daynix.com> <CAOEp5Ocz-xGq5=e=WY0aipEYHEhN-wxekNaAiqAS+HsOF8TcDQ@mail.gmail.com>
 <CAOEp5OevYR5FWVMfQ_esmWTKtz9_ddTupbe7FtBFQ=sv2kEt2w@mail.gmail.com>
In-Reply-To: <CAOEp5OevYR5FWVMfQ_esmWTKtz9_ddTupbe7FtBFQ=sv2kEt2w@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Mon, 18 Jan 2021 11:16:40 +0200
Message-ID: <CAOEp5OeQscazq2bSkT7ocnHZ5q_+ffSUcBqbUZpSz+dVEDcLhg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
To:     Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>
Cc:     Yan Vugenfirer <yan@daynix.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Willem de Bruijn <willemb@google.com>,
        KP Singh <kpsingh@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Marco Elver <elver@google.com>, decui@microsoft.com,
        cai@lca.pw, Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alexei,

Can you please answer the questions in the last email of this thread?
Your comment will be extremely helpful.

Thanks

On Tue, Jan 12, 2021 at 10:55 PM Yuri Benditovich
<yuri.benditovich@daynix.com> wrote:
>
> On Tue, Jan 12, 2021 at 10:40 PM Yuri Benditovich
> <yuri.benditovich@daynix.com> wrote:
> >
> > On Tue, Jan 12, 2021 at 9:42 PM Yuri Benditovich
> > <yuri.benditovich@daynix.com> wrote:
> > >
> > > This program type can set skb hash value. It will be useful
> > > when the tun will support hash reporting feature if virtio-net.
> > >
> > > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > > ---
> > >  drivers/net/tun.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > > index 7959b5c2d11f..455f7afc1f36 100644
> > > --- a/drivers/net/tun.c
> > > +++ b/drivers/net/tun.c
> > > @@ -2981,6 +2981,8 @@ static int tun_set_ebpf(struct tun_struct *tun, struct tun_prog __rcu **prog_p,
> > >                 prog = NULL;
> > >         } else {
> > >                 prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SOCKET_FILTER);
> > > +               if (IS_ERR(prog))
> > > +                       prog = bpf_prog_get_type(fd, BPF_PROG_TYPE_SCHED_CLS);
> > >                 if (IS_ERR(prog))
> > >                         return PTR_ERR(prog);
> > >         }
> >
> > Comment from Alexei Starovoitov:
> > Patches 1 and 2 are missing for me, so I couldn't review properly,
> > but this diff looks odd.
> > It allows sched_cls prog type to attach to tun.
> > That means everything that sched_cls progs can do will be done from tun hook?
>
> We do not have an intention to modify the packet in this steering eBPF.
> There is just one function that unavailable for BPF_PROG_TYPE_SOCKET_FILTER
> that the eBPF needs to make possible to deliver the hash to the guest
> VM - it is 'bpf_set_hash'
>
> Does it mean that we need to define a new eBPF type for socket filter
> operations + set_hash?
>
> Our problem is that the eBPF calculates 32-bit hash, 16-bit queue
> index and 8-bit of hash type.
> But it is able to return only 32-bit integer, so in this set of
> patches the eBPF returns
> queue index and hash type and saves the hash in skb->hash using bpf_set_hash().
>
> If this is unacceptable, can you please recommend a better solution?
>
> > sched_cls assumes l2 and can modify the packet.
>
> The steering eBPF in TUN module also assumes l2.
>
> > I think crashes are inevitable.
> >
> > > --
> > > 2.17.1
> > >
