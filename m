Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD8F202CB4
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 22:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbgFUUZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 16:25:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27401 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730673AbgFUUZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 16:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592771121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5/416N7OwlJjOjmFHaXcfpzRSt86NuMHjindDKu4elw=;
        b=bt/yIIKrRkjIH/w+D051eMUO2e54tKJOasQo27efcBVyoUquDDgeZYyeALOgO3rIxdXrZZ
        mZGO84X1K1FkdDMyM85z4hVUt0R9WfyZa+mo1wTJek1fQiUiavgIjt6gBw+m0N2mhCW4bd
        zwlTZrkmyYxcbj8YbFllAaPp+Pf9Hkw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-G6_7TRiMP12RH0qeXx5SOg-1; Sun, 21 Jun 2020 16:25:18 -0400
X-MC-Unique: G6_7TRiMP12RH0qeXx5SOg-1
Received: by mail-il1-f197.google.com with SMTP id r4so1045827ilq.20
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 13:25:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5/416N7OwlJjOjmFHaXcfpzRSt86NuMHjindDKu4elw=;
        b=GklDCxzCLozQoK0kXeZZKOkZL2dT94MQQcx31LSJXxE4RNQxGSXZIebWQjyyif7co9
         GvbwTd3of6pMNnmiltq042vBzHNTRB8L+Bt9xI13GZa1V39rS7LvaeQSm4U2M6eorT4K
         2sp02s3JpOzwxX7i6C+b28Ag9gK7AHDBIyVLVtoNvrl3tvWDA23o685cafwoOgYMqMPR
         dQbev4FFbQ5Qs2ewnue5QWK7tpEDE9ITSl7hYG2DFvBfMVGZFK5hcGLDWJ1BNLHFBX5n
         qr2LQNWqEYjkKKO/B0EZVHEWyh/oIdjEbTweVXmqGLDPgB8oNqt96kXypXQnWg4VWz2r
         9eBg==
X-Gm-Message-State: AOAM530rWAYNK8LEzwP5pkWbMYPOR+NsKOWseXll2m3hz4j9/LZgy8a1
        UsZZ6kP1L5w+91vmPfppDdzKX0oDXuHCEepnYJt2fVzhfc3vd4VPpH/rYdIcjwgWcqRhntskN3P
        hRkLX2hP8Z3LH2kc/tILoKofvivuqXs6V
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr14997823jaj.120.1592771118170;
        Sun, 21 Jun 2020 13:25:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKXchW2IkCUudcu/hdCr7QHYigi+b86NqbkSX1mig6hhJzcchDc2IFpZUYJFqMRZrlB3nf0blwbHndk1Ho/BM=
X-Received: by 2002:a05:6638:d96:: with SMTP id l22mr14997805jaj.120.1592771117909;
 Sun, 21 Jun 2020 13:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200608210058.37352-1-jarod@redhat.com> <20200610185910.48668-1-jarod@redhat.com>
 <20200610185910.48668-4-jarod@redhat.com> <68f2ff6ee06bf4520485121b15c0d8c10cad60d2.camel@mellanox.com>
In-Reply-To: <68f2ff6ee06bf4520485121b15c0d8c10cad60d2.camel@mellanox.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Sun, 21 Jun 2020 16:25:07 -0400
Message-ID: <CAKfmpSeM4zf_rY_oLJJcE=vqjS43qKE8C+vAQb2NohXe3Zxxew@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] mlx5: become aware of when running as a
 bonding slave
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 5:51 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> On Wed, 2020-06-10 at 14:59 -0400, Jarod Wilson wrote:
> > I've been unable to get my hands on suitable supported hardware to
> > date,
> > but I believe this ought to be all that is needed to enable the mlx5
> > driver to also work with bonding active-backup crypto offload
> > passthru.
> >
> > CC: Boris Pismenny <borisp@mellanox.com>
> > CC: Saeed Mahameed <saeedm@mellanox.com>
> > CC: Leon Romanovsky <leon@kernel.org>
> > CC: Jay Vosburgh <j.vosburgh@gmail.com>
> > CC: Veaceslav Falico <vfalico@gmail.com>
> > CC: Andy Gospodarek <andy@greyhouse.net>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > CC: Jakub Kicinski <kuba@kernel.org>
> > CC: Steffen Klassert <steffen.klassert@secunet.com>
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: netdev@vger.kernel.org
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > index 92eb3bad4acd..72ad6664bd73 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -210,6 +210,9 @@ static inline int
> > mlx5e_xfrm_validate_state(struct xfrm_state *x)
> >       struct net_device *netdev = x->xso.dev;
> >       struct mlx5e_priv *priv;
> >
> > +     if (x->xso.slave_dev)
> > +             netdev = x->xso.slave_dev;
> > +
>
> Do we really need to repeat this per driver ?
> why not just setup xso.real_dev, in xfrm layer once and for all before
> calling device drivers ?
>
> Device drivers will use xso.real_dev blindly.
>
> Will be useful in the future when you add vlan support, etc..

Apologies, I didn't catch your reply until just recently. Yeah, that
sounds like a better approach, if I can work it out cleanly. We just
init xso.real_dev to the same thing as xso.dev, then overwrite it in
the upper layer drivers (bonding, vlan, etc), while device drivers
just always use xso.real_dev, if I'm understanding your suggestion.
I'll see what I can come up with.


-- 
Jarod Wilson
jarod@redhat.com

