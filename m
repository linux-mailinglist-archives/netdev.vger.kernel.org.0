Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00EE2F4537
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 08:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbhAMHaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 02:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbhAMHaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 02:30:04 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E6DC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:29:24 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m5so611330pjv.5
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 23:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cQJ6LhoRoBeAUuhCdV6OHzUgTYDtqGqBBm2yZZjVgY8=;
        b=AjUJQRKWl2d71+JzI54zxAzKVmLoNdusKbua+V7qTUE0yUVjm+r6JjXWA4bavIjjie
         9nWuAXq1pC9i4hPC3zeou0F/AyZOmmpXjt4dsAqSPzGl3ckYPvc9gjO3RP2wgRnbz/83
         uOb58frDLyNTLDJCyEtgdMrZzmAbmTCFrehrFdqxSOPboGPSvK7zaVAS0lkBIhz9QGKc
         62psP6EFDMA6QNsRn0dF5Hv4vM2DzFHHaJqmAGIapcOfFHyRdn0FbRFXW8ou4NPCPmny
         nmkRQOU+kQFu8YWVWaTyt/w2sKPt7Tf/Ss5IsZMUOZA5UcbLmro/WcmpLrD+iAZBwfZn
         K0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cQJ6LhoRoBeAUuhCdV6OHzUgTYDtqGqBBm2yZZjVgY8=;
        b=JJD0aY/bksSlxnndeIAwQJ2Nf6mdhmnVRR6BpS8sCF/4o8uTajduxLkbIp1mfXhCsR
         x78n9Pg5bYxbIi2GLRGJ7o+7WtOpQGFv/mHa2bbxXiz/F2QrgxAgH+RBGxYmC0eZpRth
         8+VpgP4V3v5mwiVHxvDuy6i8lCGfmQ/WUIzTJ3bW5t4VgCnq8/CohFFNOpZ6zE+KO/wr
         6AYk+wyWoYb2ZH01X6/hPiNUxZYxDVsEpkHxMH5SEOKQIcffBdG4Z0jy+2RrIIO5udeD
         7GykGfVOuOqpWpLNsI7gyCIRX8qsc9NIGVTFNan9rZm10tjJ53S6DSOP/unwHXMIlMoo
         EGCg==
X-Gm-Message-State: AOAM530wCbYebrrLQZb4EQ4+9Qc/PoVIiyGcd8zEuJFBxe4HB6R5VMWi
        TcnE6HI7O2qeHoMNShaDmNzP3ZOo/T3wFw4meH5zYGJIssY=
X-Google-Smtp-Source: ABdhPJx5OQsTysL1b3pCns7kHJNfAARYww94taJPuHbil6E2V0F1PJwEdWWfWXpxN5m90e7sCmhffpiB5rpgqxhnYeg=
X-Received: by 2002:a17:902:7c04:b029:dc:99f2:eea4 with SMTP id
 x4-20020a1709027c04b02900dc99f2eea4mr1027250pll.43.1610522964249; Tue, 12 Jan
 2021 23:29:24 -0800 (PST)
MIME-Version: 1.0
References: <1609757998.875103-1-xuanzhuo@linux.alibaba.com>
 <741209d2a42d46ebdb8249caaef7531f5ad8fa76.camel@kernel.org>
 <CAJ8uoz0xkGUd6V9-+x6pfMoqz0UjhkSBWz-dBChi=eNGM2cS4w@mail.gmail.com> <06917964a6abf26ddad21a22b29d760fc89cfcf7.camel@kernel.org>
In-Reply-To: <06917964a6abf26ddad21a22b29d760fc89cfcf7.camel@kernel.org>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 13 Jan 2021 08:29:13 +0100
Message-ID: <CAJ8uoz1yFtqO1nx=768Fv2tcWSko9hFALpcPKE74EGLuxbY1Yg@mail.gmail.com>
Subject: Re: mlx5 error when the skb linear space is empty
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 9:35 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Mon, 2021-01-11 at 09:02 +0100, Magnus Karlsson wrote:
> > On Tue, Jan 5, 2021 at 9:51 PM Saeed Mahameed <saeed@kernel.org>
> > wrote:
> > > On Mon, 2021-01-04 at 18:59 +0800, Xuan Zhuo wrote:
> > > > hi
> > > >
> > > > In the process of developing xdp socket, we tried to directly use
> > > > page to
> > > > construct skb directly, to avoid data copy. And the MAC
> > > > information
> > > > is also in
> > > > the page, which caused the linear space of skb to be empty. In
> > > > this
> > > > case, I
> > > > encountered a problem :
> > > >
> > > > mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn
> > > > 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
> > > > 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
> > > > WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
> > > > 00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
> > > > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > 00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
> > > > 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
> > > >
> > > >
> > > > And when I try to copy only the mac address into the linear space
> > > > of
> > > > skb, the
> > > > other parts are still placed in the page. When constructing skb
> > > > in
> > > > this way, I
> > > > found that although the data can be sent successfully, the
> > > > sending
> > > > performance
> > > > is relatively poor!!
> > > >
> > >
> > > Hi,
> > >
> > > This is an expected behavior of ConnectX4-LX, ConnectX4-LX requires
> > > the
> > > driver to copy at least the L2 headers into the linear part, in
> > > some
> > > DCB/DSCP configuration it will require L3 headers.
> >
> > Do I understand this correctly if I say whatever is calling
> > ndo_start_xmit has to make sure at least the L2 headers is in the
> > linear part of the skb? If Xuan does not do this, the ConnectX4
> > driver
> > crashes, but if he does, it works. So from an ndo_start_xmit
> > interface
> > perspective, what is the requirement of an skb that is passed to it?
> > Do all users of ndo_start_xmit make sure the L2 header is in the
> > linear part, or are there users that do not make sure this is the
> > case? Judging from the ConnectX5 code it seems that the latter is
> > possible (since it has code to deal with this), but from the
> > ConnectX4, it seems like the former is true (since it does not copy
> > the L2 headers into the linear part as far as I can see). Sorry for
> > my
> > confusion, but I think it is important to get some clarity here as it
> > will decide if Xuan's patch is a good idea or not in its current
> > form.
> >
>
> To clarify:
> Connectx4Lx, doesn't really require data to be in the linear part, I
> was refereing to a HW limitation that requires the driver to copy the
> L2/L3 headers (depending on current HW config) to a special area in the
> tx descriptor, currently the driver copy the L2/L3 headers only from
> the linear part of the SKB, but this can be changed via calling
> pskb_may_pull in mlx5 ConnectX4LX tx path to make sure the linear part
> has the needed data ..

That made it clear. Thank you.

> Something like:
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 61ed671fe741..5939fd8eed2c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -159,6 +159,7 @@ static inline int mlx5e_skb_l2_header_offset(struct
> sk_buff *skb)
>  {
>  #define MLX5E_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
>
> +       /* need to check ret val */
> +       pskb_may_pull(skb, MLX5E_MIN_INLINE);
>         return max(skb_network_offset(skb), MLX5E_MIN_INLINE);
>  }
>
>
