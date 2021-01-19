Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C652FB8D9
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406054AbhASNtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:49:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405145AbhASLEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 06:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611054156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kiLt994IXzu+B0F7u6tIkfDBkyxqYHQz7CiZ5/RLVUY=;
        b=i1Z2Qt0iHD3SdVLvWMAPrAQNaqpjSIxHwfkN6nMSBWadiJuYPFqs8W/ixmPgWpJW8hckD/
        EEu7MF/vKDsLeGYTGysoND3dZiVj+pX/dV2Bs0IcY9I5K1DEQ7M+xNfNh6npj/2lSlwcoY
        mV6C4uAnnVe+4NTmVQAIdn0BY6usoBE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-2GvGq-lWN9qVWhx64uA4Ew-1; Tue, 19 Jan 2021 06:02:35 -0500
X-MC-Unique: 2GvGq-lWN9qVWhx64uA4Ew-1
Received: by mail-wm1-f71.google.com with SMTP id s24so3276178wmj.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 03:02:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kiLt994IXzu+B0F7u6tIkfDBkyxqYHQz7CiZ5/RLVUY=;
        b=kKJNKxFebvxzeC/l8ZiFtcQLinCBFwVKeMuektkF7uUmH+JMN881RoDsHcLQVwvEHh
         XVKo6+j1VZ1FkVuU/06P6DIjcjAhryb5weungUjzI35NXjqyFePY2acdnGIwMhVowQd+
         HlroeCU4w/eeeY5IczG9PfTGlEtQwMbnoRCCj/EResjTsilOfHBfQwHfgD8/A2D0zPWN
         7FIHuSd1prtNNc4CXGKJKpDhAmmu0qZR4ByQdHH2qU3EGhXmQ1fY8wsGgBHxVC219YGS
         hyymHBNfW9VNs+pJf+vV9VYD7H//MNB26V6CYmB/9LwLfSxiSJNTgFLOu8Aj4qBGyin7
         Cdow==
X-Gm-Message-State: AOAM531lQNnE73x0B39M2OzF2j+GerESTEOZW7l0sCye71YjAs1BgYXS
        NF1Kjmzt9UPCmdpXwNGqOvYKMP9iDaU07yagjzYGAjmg+y8oo3fIsL+J/NjNqOrawmCRh1l4DM/
        U5hdIdmgtUjRoGee7
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr3766969wru.215.1611054153256;
        Tue, 19 Jan 2021 03:02:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsn0QhhwxM0iUt4w960LJvOY9PG5C4qB5nxwYI6dFa+qrhGOvysE4HQc58/mKABJu2FbKe7Q==
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr3766950wru.215.1611054153065;
        Tue, 19 Jan 2021 03:02:33 -0800 (PST)
Received: from redhat.com (bzq-79-177-39-148.red.bezeqint.net. [79.177.39.148])
        by smtp.gmail.com with ESMTPSA id p12sm4133067wmi.3.2021.01.19.03.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 03:02:32 -0800 (PST)
Date:   Tue, 19 Jan 2021 06:02:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/3] xsk: build skb by page
Message-ID: <20210119060140-mutt-send-email-mst@kernel.org>
References: <20210119045004-mutt-send-email-mst@kernel.org>
 <1611053609.502882-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611053609.502882-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 06:53:29PM +0800, Xuan Zhuo wrote:
> On Tue, 19 Jan 2021 04:50:30 -0500, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Tue, Jan 19, 2021 at 05:45:09PM +0800, Xuan Zhuo wrote:
> > > v2:
> > >     1. add priv_flags IFF_TX_SKB_NO_LINEAR instead of netdev_feature
> > >     2. split the patch to three:
> > >         a. add priv_flags IFF_TX_SKB_NO_LINEAR
> > >         b. virtio net add priv_flags IFF_TX_SKB_NO_LINEAR
> > >         c. When there is support this flag, construct skb without linear space
> > >     3. use ERR_PTR() and PTR_ERR() to handle the err
> > >
> > >
> > > v1 message log:
> > > ---------------
> > >
> > > This patch is used to construct skb based on page to save memory copy
> > > overhead.
> > >
> > > This has one problem:
> > >
> > > We construct the skb by fill the data page as a frag into the skb. In
> > > this way, the linear space is empty, and the header information is also
> > > in the frag, not in the linear space, which is not allowed for some
> > > network cards. For example, Mellanox Technologies MT27710 Family
> > > [ConnectX-4 Lx] will get the following error message:
> > >
> > >     mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
> > >     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >     00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >     00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
> > >     WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
> > >     00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
> > >     00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >     00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
> > >     00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > >     mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
> > >
> > > I also tried to use build_skb to construct skb, but because of the
> > > existence of skb_shinfo, it must be behind the linear space, so this
> > > method is not working. We can't put skb_shinfo on desc->addr, it will be
> > > exposed to users, this is not safe.
> > >
> > > Finally, I added a feature NETIF_F_SKB_NO_LINEAR to identify whether the
> > > network card supports the header information of the packet in the frag
> > > and not in the linear space.
> > >
> > > ---------------- Performance Testing ------------
> > >
> > > The test environment is Aliyun ECS server.
> > > Test cmd:
> > > ```
> > > xdpsock -i eth0 -t  -S -s <msg size>
> > > ```
> > >
> > > Test result data:
> > >
> > > size    64      512     1024    1500
> > > copy    1916747 1775988 1600203 1440054
> > > page    1974058 1953655 1945463 1904478
> > > percent 3.0%    10.0%   21.58%  32.3%
> >
> > Just making sure, are these test results with v2?
> 
> The data was tested at v1,
> but v2 did not modify the performance-related code.
> 
> Thanks.

Looks like v1 wouldn't even build, or did I miss anything?
It would be nicer if you retested it ...

> 
> >
> > >
> > > Xuan Zhuo (3):
> > >   net: add priv_flags for allow tx skb without linear
> > >   virtio-net: support IFF_TX_SKB_NO_LINEAR
> > >   xsk: build skb by page
> > >
> > >  drivers/net/virtio_net.c  |   3 +-
> > >  include/linux/netdevice.h |   3 ++
> > >  net/xdp/xsk.c             | 112 ++++++++++++++++++++++++++++++++++++++--------
> > >  3 files changed, 99 insertions(+), 19 deletions(-)
> > >
> > > --
> > > 1.8.3.1
> >

