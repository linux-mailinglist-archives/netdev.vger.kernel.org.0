Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C2C2FD98A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390115AbhATTYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389903AbhATSpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 13:45:55 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A44C061575;
        Wed, 20 Jan 2021 10:45:11 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id o17so35520168lfg.4;
        Wed, 20 Jan 2021 10:45:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zrMNRZvlEESWdG6jggtCoB+4numwazy+fXWH/nTPU9U=;
        b=GbiCYI2AOS9Mde7ZZGAB8iKTEaPVyUk3NJn7BsJ4aNMPDW3bfjjQOlDjJVeyI01LfK
         yGrcSPsCfKcKMod8xBD3FRFhA2PKjb0+UA9u+c+PLBc6ucvOs4H76CCyWbj5qRgGzSxL
         YYeBDYP7YKSgdZ2tcOGzhxRWs+uk1fru9f/FsIBpFq4b3uFMzw/dOgkhsRnbJz85JTGD
         OFp28kiITVDeZNpIvktOImEsP9FYI+HUZ15TQ4xgjNS0A45AjvFeCkc/hiGkbKW6oV51
         UkYN9KTEvNSswvk+NvyWRYiqpqIG5SqjCPISQdicL2egTc1jJYF1v01KBc8Pl6R7uTGn
         P/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zrMNRZvlEESWdG6jggtCoB+4numwazy+fXWH/nTPU9U=;
        b=BQqb9xHzS3Q3cW/HfiF08HssFRa7X4tkKto4CQaRFNYQQzYdTk832/+3VIv6E8x+EK
         EaMwg/9gLe9eEeJwrdYBqFN8Xblu8mO7MPFMSuSv5lNCL+jizh/6khQd/7X5Ki3y4Rbc
         YsAN91msjEOo9Nytsqb2qp32kRvO1w2WLdMG/y0/eeAwijR+K2H1cPJKBtGzUcxOJdC+
         Zp0d22MRKB4wqwGV3XbaNhxQQNwGJX9QyGu3rM/BDJ1zCXLauh6PBsmxyQlTTeGoS6yR
         nIqJlkvgxC3hrlecfsCho6C5SDv4b8u8fnj5rwOChyrc03c1hYFCI5TwH/N+DJnKRHEF
         8NQQ==
X-Gm-Message-State: AOAM532QOqGUBY9ruwM2TTcc8NDIkXf+Lq/IztatkLw4Meff+hL4RCDV
        IUCK24Vi5NiTJRjtUHFWiZOIeBAwz0CJB2CFVuE=
X-Google-Smtp-Source: ABdhPJysfNizrzDQUVINGOhhgWus7azEpICiAnwV+p4EXlvDkyaX1pVlGFfbUwglU72IpLHWW5TDXiNALg3A++evFDI=
X-Received: by 2002:a05:6512:34c5:: with SMTP id w5mr4908698lfr.214.1611168309505;
 Wed, 20 Jan 2021 10:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20210112194143.1494-1-yuri.benditovich@daynix.com>
 <20210112194143.1494-4-yuri.benditovich@daynix.com> <CAOEp5Ocz-xGq5=e=WY0aipEYHEhN-wxekNaAiqAS+HsOF8TcDQ@mail.gmail.com>
 <CAOEp5OevYR5FWVMfQ_esmWTKtz9_ddTupbe7FtBFQ=sv2kEt2w@mail.gmail.com>
In-Reply-To: <CAOEp5OevYR5FWVMfQ_esmWTKtz9_ddTupbe7FtBFQ=sv2kEt2w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Jan 2021 10:44:58 -0800
Message-ID: <CAADnVQJLN0sFyKdAmc6Pikv8Ww9OocnK_VXMG=ZLSMONHkqe4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] tun: allow use of BPF_PROG_TYPE_SCHED_CLS program type
To:     Yuri Benditovich <yuri.benditovich@daynix.com>
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
        Willem de Bruijn <willemb@google.com>, gustavoars@kernel.org,
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

On Tue, Jan 12, 2021 at 12:55 PM Yuri Benditovich
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

The intent is irrelevant. Using SCHED_CLS here will let users modify the packet
and some users will do so. Hence the tun code has to support it.

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

bpf prog can only return a 32-bit integer. That's true.
But the prog can use helpers to set any number of bits and variables.
bpf_set_hash_v2() with hash, queue and index arguments could fit this purpose,
but if you allow it for SCHED_CLS type,
tc side of the code should be ready to deal with that too and this extended
helper should be meaningful for both tc and tun.

In general if the purpose of the prog is to compute three values they better be
grouped together. Returned two of them via ORed 32-bit integer and
returning 32-bit via bpf_set_hash is an awkward api.
