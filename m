Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725F8F53AE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfKHSn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:43:28 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36192 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfKHSn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:43:28 -0500
Received: by mail-pf1-f193.google.com with SMTP id v19so5211952pfm.3;
        Fri, 08 Nov 2019 10:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HOpLK1w/qhJoesKNOR8u2qvXt9U8qsoD3oRvjl03HUQ=;
        b=QIHuZNt/LevlJDgPCe/zb4b8ZQqjU7tPyEcoRrMwAAokexGpwwBN4eApY7R/VaKbkq
         ssqL64T/SH1tj0PMGO5zPNrjZK/+QzjHZv1EfhFBQcA6ISJXqioK7MBkqdKPUBOtMrWX
         irYWLIz/Zzcv3huK7x77xS8PyFt0wG4VN6rbT6/pH5ooXTSnsErU+hXmvHUeosHs8agB
         xz+8s6FeYyqzzzRYFYseE8Ay4CNsb1Bn7M30IwGts5gW1aUSyBEpeYv3jFu/RaOWD7v5
         Rb8hvCdsfx83qSCsi2y6IGx9GBXPe0de9iuDigci4Le6rORSO1MkmMDcUjWkx/r8ViQZ
         nnRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HOpLK1w/qhJoesKNOR8u2qvXt9U8qsoD3oRvjl03HUQ=;
        b=PlgV4k8VoqrFU/qbizMhEs/nlYyF+vGqLNXNh1gugYSCa+529FkTmKx1YQIxWwonIY
         mQM72lElKoqGGeO78C2Oy1yB9g049SNQdZzo/rAFGQsmXOxiYtP8ygpZ+y9WfyWZgKeY
         l5ViLDzjto+WoCOJtoKws7bawF5Eh85VtChpzAx5YuAkW8K/FiCriVtU1YxRxv0EyYnj
         HQa4N6Ts0wMp2pDALFlwCpiiGixVwzYzKGZGb7Qo8imd9hDde96wCoxljbvnzTcn1nUr
         AExArEbSw8B56KcD5HOg7sNXbjGTjqQt/ZdQ8ahPX/IDPa8hY+K91f3206rE0mT9Tikq
         cwYg==
X-Gm-Message-State: APjAAAWUYPQYwa9kJ57QR5b1VfX5zkAMzgIs15Xo2NSHe+YDf2ndcKah
        eY3FGowx3QEvOcsgODYEumZCn9vz4LM=
X-Google-Smtp-Source: APXvYqy/GuDm863eWXETUUmoMmn3Tpm11h8lFMjRzjpLZXzae+P2n2v+2MYhett9nKRjhehGVHGZSg==
X-Received: by 2002:a63:9543:: with SMTP id t3mr13783191pgn.350.1573238602403;
        Fri, 08 Nov 2019 10:43:22 -0800 (PST)
Received: from gmail.com ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id g6sm6397548pfh.125.2019.11.08.10.43.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 10:43:21 -0800 (PST)
Date:   Fri, 8 Nov 2019 10:43:20 -0800
From:   William Tu <u9012063@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/5] libbpf: support XDP_SHARED_UMEM with
 external XDP program
Message-ID: <20191108184320.GC30004@gmail.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com>
 <20191108180314.GA30004@gmail.com>
 <CAJ8uoz0DJx0sbsAU1GyjZcX3JvcEq7QKFRM5sYrZ_ScAHgEE=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz0DJx0sbsAU1GyjZcX3JvcEq7QKFRM5sYrZ_ScAHgEE=A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 07:19:18PM +0100, Magnus Karlsson wrote:
> On Fri, Nov 8, 2019 at 7:03 PM William Tu <u9012063@gmail.com> wrote:
> >
> > Hi Magnus,
> >
> > Thanks for the patch.
> >
> > On Thu, Nov 07, 2019 at 06:47:36PM +0100, Magnus Karlsson wrote:
> > > Add support in libbpf to create multiple sockets that share a single
> > > umem. Note that an external XDP program need to be supplied that
> > > routes the incoming traffic to the desired sockets. So you need to
> > > supply the libbpf_flag XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load
> > > your own XDP program.
> > >
> > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > ---
> > >  tools/lib/bpf/xsk.c | 27 +++++++++++++++++----------
> > >  1 file changed, 17 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index 86c1b61..8ebd810 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -586,15 +586,21 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> > >       if (!umem || !xsk_ptr || !rx || !tx)
> > >               return -EFAULT;
> > >
> > > -     if (umem->refcount) {
> > > -             pr_warn("Error: shared umems not supported by libbpf.\n");
> > > -             return -EBUSY;
> > > -     }
> > > -
> > >       xsk = calloc(1, sizeof(*xsk));
> > >       if (!xsk)
> > >               return -ENOMEM;
> > >
> > > +     err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> > > +     if (err)
> > > +             goto out_xsk_alloc;
> > > +
> > > +     if (umem->refcount &&
> > > +         !(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> > > +             pr_warn("Error: shared umems not supported by libbpf supplied XDP program.\n");
> >
> > Why can't we use the existing default one in libbpf?
> > If users don't want to redistribute packet to different queue,
> > then they can still use the libbpf default one.
> 
> Is there any point in creating two or more sockets tied to the same
> umem and directing all traffic to just one socket? IMHO, I believe

When using build-in XDP, isn't the traffic being directed to its
own xsk on its queue? (so not just one xsk socket)

So using build-in XDP, for example, queue1/xsk1 and queue2/xsk2, and
sharing one umem. Both xsk1 and xsk2 receive packets from their queue.

> that most users in this case would want to distribute the packets over
> the sockets in some way. I also think that users might be unpleasantly
> surprised if they create multiple sockets and all packets only get to
> a single socket because libbpf loaded an XDP program that makes little
> sense in the XDP_SHARED_UMEM case. If we force them to supply an XDP

Do I misunderstand the code?
I looked at xsk_setup_xdp_prog, xsk_load_xdp_prog, and xsk_set_bpf_maps.
The build-in prog will distribute packets to different xsk sockets,
not a single socket.

> program, they need to make this decision. I also wanted to extend the
> sample with an explicit user loaded XDP program as an example of how
> to do this. What do you think?

Yes, I like it. Like previous version having the xdpsock_kern.c as an
example for people to follow.

William

> 
> /Magnus
> 
> > William
> > > +             err = -EBUSY;
> > > +             goto out_xsk_alloc;
> > > +     }
> > > +
> > >       if (umem->refcount++ > 0) {
> > >               xsk->fd = socket(AF_XDP, SOCK_RAW, 0);
> > >               if (xsk->fd < 0) {
> > > @@ -616,10 +622,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> > >       memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
> > >       xsk->ifname[IFNAMSIZ - 1] = '\0';
> > >
> > > -     err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> > > -     if (err)
> > > -             goto out_socket;
> > > -
> > >       if (rx) {
> > >               err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> > >                                &xsk->config.rx_size,
> > > @@ -687,7 +689,12 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> > >       sxdp.sxdp_family = PF_XDP;
> > >       sxdp.sxdp_ifindex = xsk->ifindex;
> > >       sxdp.sxdp_queue_id = xsk->queue_id;
> > > -     sxdp.sxdp_flags = xsk->config.bind_flags;
> > > +     if (umem->refcount > 1) {
> > > +             sxdp.sxdp_flags = XDP_SHARED_UMEM;
> > > +             sxdp.sxdp_shared_umem_fd = umem->fd;
> > > +     } else {
> > > +             sxdp.sxdp_flags = xsk->config.bind_flags;
> > > +     }
> > >
> > >       err = bind(xsk->fd, (struct sockaddr *)&sxdp, sizeof(sxdp));
> > >       if (err) {
> > > --
> > > 2.7.4
> > >
