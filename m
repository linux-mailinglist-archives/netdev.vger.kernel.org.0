Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C72D6E518D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjDQUUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjDQUUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:20:35 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072B11723;
        Mon, 17 Apr 2023 13:20:34 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50672fbf83eso15922048a12.0;
        Mon, 17 Apr 2023 13:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681762832; x=1684354832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSacyJ8CfD1haQX/1ScXD9msxefVSPmbKcZe4LjVLXk=;
        b=eYwW2f+nLx9BT0fDL99JudU/CPHTgqc+PU4ZDSn3AbX1YDtkhCIb+olpmT80B4gBCo
         tS6l4XQ8dFUyT7NwOMM/yqLtKAEdLmHYfgu59b0HJU4mPr9bkdcrw/kkLFrP684byZwW
         pmA+rQvpglHX1J8DW2sN72cTmHakExPWrk5TPiHcwkZL6ZJLOs784h0HYLlALfjBK/TE
         gpJkO2lcUcejhJlgBS56Dv/aQQRSJYqebH5pfF+B64x62J4ZvU31Qja5VDmurVTSEDLS
         lg2sOHD2EAzeP/s4r609hA/+lr4NFI1VsBMiD/KVajtQG2E+CS9y6JqrDK1bEXVfC44u
         tLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681762832; x=1684354832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xSacyJ8CfD1haQX/1ScXD9msxefVSPmbKcZe4LjVLXk=;
        b=gER/dvXl75COl3epyb4aP6BlbpvamN91ypEWzvumzIgMZB2DNZ6WtUMGoOjbA5svLV
         l8a63DUhTXkksdgWOY3Ss+BeJMnJf3J+H6XQlL5zthaLhuCTRY+3IO3R2lwxj5+50Bpp
         NJJJPyTJz32WSveQSnlCf5s8aP7wbAc50JaoIk0cVH99VhWXwbwOHqfI2PdT2EbfKH0W
         7VcZ4CUZgguZXwqZT82qGAFPVgrF7NgGOVIGdbUjdX1fPuXOr9VtDzFZHXYD7X5Mp9Wh
         aj1/Kdpq1GCxTy/N2yKg9I/tnhyDCZoIV06iJpEWYczZ6YhW2HhkmfXhtqHnj9v0htwb
         A5Ww==
X-Gm-Message-State: AAQBX9c2EqbCUafUoNJCKA9a26FofJx1koVbIMiMKvwRvQPSqFIc4ybW
        GtS+KuzFzas5j3xxKzGH/wd4kA3wf5poeDCiUO+x6a11
X-Google-Smtp-Source: AKy350ZaF43FrQEJJxJHfp5gOZBMhBbWRmKjQxu14QbxWj+jK6WUpmfqGjJE2t2fs3ti+u6hblaEWaxOJ1DtWtCFrVY=
X-Received: by 2002:a05:6402:1950:b0:506:7c85:f470 with SMTP id
 f16-20020a056402195000b005067c85f470mr149194edz.3.1681762832337; Mon, 17 Apr
 2023 13:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <73f0028461c4f3fa577e24d8d797ddd76f1d17c6.1681507058.git.lorenzo@kernel.org>
 <dc994c7b-c8fe-df8e-7203-0d6dae8dee9f@iogearbox.net> <ZDnPXYvfu46i0YpE@lore-desk>
 <dc040740-6823-c524-2580-e9604e04dcb0@iogearbox.net> <ZDqFKnW/3ML7GAOz@lore-desk>
In-Reply-To: <ZDqFKnW/3ML7GAOz@lore-desk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 17 Apr 2023 13:20:21 -0700
Message-ID: <CAADnVQKcoozpmR+C9Ys3uLabq+7DRqVjkZbeMHnyU0FpZh9LNQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix xdp_redirect xdp-features for
 xdp_bonding selftest
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jussi Maki <joamaki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 4:06=E2=80=AFAM Lorenzo Bianconi <lorenzo@kernel.or=
g> wrote:
>
> > On 4/15/23 12:10 AM, Lorenzo Bianconi wrote:
> > > > On 4/14/23 11:21 PM, Lorenzo Bianconi wrote:
> > > > > NETDEV_XDP_ACT_NDO_XMIT is not enabled by default for veth driver=
 but it
> > > > > depends on the device configuration. Fix XDP_REDIRECT xdp-feature=
s in
> > > > > xdp_bonding selftest loading a dummy XDP program on veth2_2 devic=
e.
> > > > >
> > > > > Fixes: fccca038f300 ("veth: take into account device reconfigurat=
ion for xdp_features flag")
> > > >
> > > > Hm, does that mean we're changing^breaking existing user behavior i=
ff after
> > > > fccca038f300 you can only make it work by loading dummy prog?
> > >
> > > nope, even before in order to enable ndo_xdp_xmit for veth you should=
 load a dummy
> > > program on the device peer or enable gro on the device peer:
> > >
> > > https://github.com/torvalds/linux/blob/master/drivers/net/veth.c#L477
> > >
> > > we are just reflecting this behaviour in the xdp_features flag.
> >
> > Ok, I'm confused then why it passed before?
>
> ack, you are right. I guess the issue is in veth driver code. In order to
> enable NETDEV_XDP_ACT_NDO_XMIT for device "veth0", we need to check the p=
eer
> veth1 configuration since the check in veth_xdp_xmit() is on the peer rx =
queue.
> Something like:
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index e1b38fbf1dd9..4b3c6647edc6 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1262,11 +1262,12 @@ static void veth_set_xdp_features(struct net_devi=
ce *dev)
>
>         peer =3D rtnl_dereference(priv->peer);
>         if (peer && peer->real_num_tx_queues <=3D dev->real_num_rx_queues=
) {
> +               struct veth_priv *priv_peer =3D netdev_priv(peer);
>                 xdp_features_t val =3D NETDEV_XDP_ACT_BASIC |
>                                      NETDEV_XDP_ACT_REDIRECT |
>                                      NETDEV_XDP_ACT_RX_SG;
>
> -               if (priv->_xdp_prog || veth_gro_requested(dev))
> +               if (priv_peer->_xdp_prog || veth_gro_requested(peer))
>                         val |=3D NETDEV_XDP_ACT_NDO_XMIT |
>                                NETDEV_XDP_ACT_NDO_XMIT_SG;
>                 xdp_set_features_flag(dev, val);
> @@ -1504,19 +1505,23 @@ static int veth_set_features(struct net_device *d=
ev,
>  {
>         netdev_features_t changed =3D features ^ dev->features;
>         struct veth_priv *priv =3D netdev_priv(dev);
> +       struct net_device *peer;
>         int err;
>
>         if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_=
xdp_prog)
>                 return 0;
>
> +       peer =3D rtnl_dereference(priv->peer);
>         if (features & NETIF_F_GRO) {
>                 err =3D veth_napi_enable(dev);
>                 if (err)
>                         return err;
>
> -               xdp_features_set_redirect_target(dev, true);
> +               if (peer)
> +                       xdp_features_set_redirect_target(peer, true);
>         } else {
> -               xdp_features_clear_redirect_target(dev);
> +               if (peer)
> +                       xdp_features_clear_redirect_target(peer);
>                 veth_napi_del(dev);
>         }
>         return 0;
> @@ -1598,13 +1603,13 @@ static int veth_xdp_set(struct net_device *dev, s=
truct bpf_prog *prog,
>                         peer->max_mtu =3D max_mtu;
>                 }
>
> -               xdp_features_set_redirect_target(dev, true);
> +               xdp_features_set_redirect_target(peer, true);
>         }
>
>         if (old_prog) {
>                 if (!prog) {
> -                       if (!veth_gro_requested(dev))
> -                               xdp_features_clear_redirect_target(dev);
> +                       if (peer && !veth_gro_requested(dev))
> +                               xdp_features_clear_redirect_target(peer);
>
>                         if (dev->flags & IFF_UP)
>                                 veth_disable_xdp(dev);
>
> What do you think?

Please send an official patch.
We need to fix this regression asap.
