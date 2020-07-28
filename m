Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E80B230D1E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgG1PK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:10:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730556AbgG1PK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595949026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o6I4OEEg092T3ZgLJmyfjLwmqdsftnVLcbFWvSvBCB4=;
        b=BNtYj9UbJ+AE8h4zUyOvUU5durHAR95hW4AOpVCbdOgZRfxu6GJWySoQRFL9qEcNryJuUO
        9GUzZoqE0+g5L5NapT06x/x6ZjR02yBVGKzG1AlVT06fxJpB1H5L46U6UWoMoMJiOOFMHV
        AvyLjssOmIhJKNXgjMJt1XHse7ANNro=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-nu1d_8UWN1uhREJXAlZseQ-1; Tue, 28 Jul 2020 11:10:23 -0400
X-MC-Unique: nu1d_8UWN1uhREJXAlZseQ-1
Received: by mail-wm1-f70.google.com with SMTP id l5so8958897wml.7
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o6I4OEEg092T3ZgLJmyfjLwmqdsftnVLcbFWvSvBCB4=;
        b=IcwNAQ7IU445uz/FMYTx/TLUBCLRK2FSrZQKDEBpXOOCmr9XbEIVin1wVsYc/0+l7E
         W1n6RNKRRNHYWn7u0NdeIB5m0vZPFnUtQ4wDUDku6iu5rP5VLPzW6khTS/imMHLItVAT
         TQiiHy/oI1VL7Sog5wsbqacN7ehNm3878hcJ66EAy5VbckM0YVBc6v/0fAwRNv3DyX72
         7AUTEAKycK1Z0r5Pp0v/OOW3yqyAFn6hZbREPVJCAPxMu4Hmi31aOsWmHVCWdupbuRzx
         nF35WSCH1KIinB7z9bPiWRDI/FhzySsrLm2czSZtZ+znOaDkXj1LcCMGZc0yFV5xhk6a
         cHbg==
X-Gm-Message-State: AOAM530zvnALm8M2/45IterI23dn198p/8wWyOlsMjp0XSJs1k3Z/ME1
        J1Br9quwvosw5zSNH2yjrOyREJ99T7icCX7zFC/shUfDKHRpTIuOUz00MDh1QJ1caIMz7ZAzABZ
        4sCdvrcFn1RCThgWE
X-Received: by 2002:a7b:c921:: with SMTP id h1mr4169517wml.29.1595949022343;
        Tue, 28 Jul 2020 08:10:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJgQAKSEkMEl63w1AvnDC1Q7ykV+T+t/yLYk1ciAU84obyiRZ+I99YmvndPvMVQLGnxBMXkg==
X-Received: by 2002:a7b:c921:: with SMTP id h1mr4169490wml.29.1595949022071;
        Tue, 28 Jul 2020 08:10:22 -0700 (PDT)
Received: from localhost ([151.48.137.169])
        by smtp.gmail.com with ESMTPSA id y17sm18741813wrh.63.2020.07.28.08.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 08:10:21 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:10:17 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, echaudro@redhat.com, sameehj@amazon.com,
        kuba@kernel.org
Subject: Re: [RFC net-next 00/22] Introduce mb bit in xdp_buff/xdp_frame
Message-ID: <20200728151017.GE286429@lore-desk>
References: <cover.1595503780.git.lorenzo@kernel.org>
 <20200728164852.76305a12@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <20200728164852.76305a12@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 23 Jul 2020 13:42:12 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify
> > if shared_info area has been properly initialized for non-linear
> > xdp buffers.
> > Initialize mb to 0 for all xdp drivers
>=20
> It is nice to see that we have some many XDP drivers, but 20 separate
> patches for drivers is a bit much.  Perhaps we can do all the drivers
> in one patch? What do others think?

I am fine with it, not sure what is the best approach.

>=20
> > Lorenzo Bianconi (22):
> >   xdp: introduce mb in xdp_buff/xdp_frame
> >   xdp: initialize xdp_buff mb bit to 0 in netif_receive_generic_xdp
> >   net: virtio_net: initialize mb bit of xdp_buff to 0
> >   net: xen-netfront: initialize mb bit of xdp_buff to 0
> >   net: veth: initialize mb bit of xdp_buff to 0
> >   net: hv_netvsc: initialize mb bit of xdp_buff to 0
> >   net: bnxt: initialize mb bit in xdp_buff to 0
> >   net: dpaa2: initialize mb bit in xdp_buff to 0
> >   net: ti: initialize mb bit in xdp_buff to 0
> >   net: nfp: initialize mb bit in xdp_buff to 0
> >   net: mvpp2: initialize mb bit in xdp_buff to 0
> >   net: sfc: initialize mb bit in xdp_buff to 0
> >   net: qede: initialize mb bit in xdp_buff to 0
> >   net: amazon: ena: initialize mb bit in xdp_buff to 0
> >   net: cavium: thunder: initialize mb bit in xdp_buff to 0
> >   net: socionext: initialize mb bit in xdp_buff to 0
> >   net: tun: initialize mb bit in xdp_buff to 0
> >   net: ixgbe: initialize mb bit in xdp_buff to 0
> >   net: ice: initialize mb bit in xdp_buff to 0
> >   net: i40e: initialize mb bit in xdp_buff to 0
> >   net: mlx5: initialize mb bit in xdp_buff to 0
> >   net: mlx4: initialize mb bit in xdp_buff to 0
> >
> >  drivers/net/ethernet/amazon/ena/ena_netdev.c        | 1 +
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 1 +
> >  drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 1 +
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 1 +
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 1 +
> >  drivers/net/ethernet/intel/ice/ice_txrx.c           | 1 +
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 1 +
> >  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 1 +
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 1 +
>=20
> I see that mvneta is missing, but maybe it is doing another kind of
> init of struct xdp_buff?

yes, mvneta has been done in a previous patch.

Regards,
Lorenzo

>=20
> >  drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 1 +
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 1 +
> >  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
> >  drivers/net/ethernet/qlogic/qede/qede_fp.c          | 1 +
> >  drivers/net/ethernet/sfc/rx.c                       | 1 +
> >  drivers/net/ethernet/socionext/netsec.c             | 1 +
> >  drivers/net/ethernet/ti/cpsw.c                      | 1 +
> >  drivers/net/ethernet/ti/cpsw_new.c                  | 1 +
> >  drivers/net/hyperv/netvsc_bpf.c                     | 1 +
> >  drivers/net/tun.c                                   | 2 ++
> >  drivers/net/veth.c                                  | 1 +
> >  drivers/net/virtio_net.c                            | 2 ++
> >  drivers/net/xen-netfront.c                          | 1 +
> >  include/net/xdp.h                                   | 8 ++++++--
> >  net/core/dev.c                                      | 1 +
> >  24 files changed, 31 insertions(+), 2 deletions(-)
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXyA/1wAKCRA6cBh0uS2t
rNUiAQCJs/hj8x7FP7117v2dpFC8zA26hh8Dazj+YKtbHguQNAEAvh+komwMh5yB
2SFpHz3XB8NTv6Xw738e4IzlzUBTKQk=
=CcBw
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--

