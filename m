Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B07B4D1C59
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 16:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347897AbiCHPzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 10:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiCHPzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 10:55:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E154042A2D
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 07:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646754877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d95MYyYSlM7RR5/ZLc51aXvuYkDamcn1aR039lQ9eiQ=;
        b=PRjTC6utrEIxe7J7jbMeG3GBPivI3aq+HdkXF9KbVEf2ziXGzFIndfynkvrjxLpREx9DTd
        TkGi9jsjBKOxKNZTXCaEnaxhSdXO1HSqtVXsKa8jA57v4ifRSq4ncKKuQR9hWSVO4+2d31
        fPNR780ayes5oZgUYkP0yj4vlpaNFnM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-ZBp0Jf87PsyzQFGjI4uBLg-1; Tue, 08 Mar 2022 10:54:36 -0500
X-MC-Unique: ZBp0Jf87PsyzQFGjI4uBLg-1
Received: by mail-qk1-f198.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so14516832qkb.23
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 07:54:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d95MYyYSlM7RR5/ZLc51aXvuYkDamcn1aR039lQ9eiQ=;
        b=1jXAanI2EOdR5685OLEIFC/xBJIfEz/5nKPYRUs63pefOVM06x56By9+z8mPE1z3Zz
         6dm1n5erP+z+3YSIoJbR4zSee7mNmx6jILwBsqDrTiN+zj6sVfel1WYFxri0FR8Irm1H
         tep3BJ6cjvcKnSR9+BnfgXzYjs2OwIfjv3eylZ07vbA4YyPKP8h/5cVY2JOad/2G9Egu
         i+hglOCsfi1WMGhnJs6bDyrdufpnxcFgZc7v0OwwrsA/GUtnNbnQOA12KQESUKaKu9r6
         u11JMunNWOEY1pDT9aoQdxwB+XuuEg3qVnVv7tp5UWv6ZRvx7lrMoZk3NkccyMTYcRQt
         UA1g==
X-Gm-Message-State: AOAM5305k1urNkvN01pd0j+aP7+s44Uh9WKb0VGiO6cDnPQc7E70equo
        j1JloOeNhvF/Z3d/j/sb1xSSvOXxuUp8yTYa/k14uTm5fpmsBfn7IwRMDEgSdS+USyOcbMEKjX4
        z2mLYAlBZZEnVtCGS
X-Received: by 2002:a05:622a:d4:b0:2e0:673f:fd9b with SMTP id p20-20020a05622a00d400b002e0673ffd9bmr8543458qtw.575.1646754875889;
        Tue, 08 Mar 2022 07:54:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypvVr5xG/q5C56DA/V5bm+j9caye7DiiT1SPvbkcZrKFdQf6gemGPWCyYDJAmbvZQG4+CiKQ==
X-Received: by 2002:a05:622a:d4:b0:2e0:673f:fd9b with SMTP id p20-20020a05622a00d400b002e0673ffd9bmr8543448qtw.575.1646754875673;
        Tue, 08 Mar 2022 07:54:35 -0800 (PST)
Received: from localhost ([37.183.9.66])
        by smtp.gmail.com with ESMTPSA id s7-20020a05622a018700b002dfed15c9edsm11001753qtw.74.2022.03.08.07.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 07:54:35 -0800 (PST)
Date:   Tue, 8 Mar 2022 16:54:32 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, toke@redhat.com, pabeni@redhat.com,
        echaudro@redhat.com, toshiaki.makita1@gmail.com, andrii@kernel.org
Subject: Re: [PATCH v3 bpf-next 0/3] introduce xdp frags support to veth
 driver
Message-ID: <Yid8OBYtqEhlr30X@lore-desk>
References: <cover.1645558706.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="E9E7A/WvfuN84J/d"
Content-Disposition: inline
In-Reply-To: <cover.1645558706.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--E9E7A/WvfuN84J/d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Introduce xdp frags support to veth driver in order to allow increasing t=
he mtu
> over the page boundary if the attached xdp program declares to support xdp
> fragments. Enable NETIF_F_ALL_TSO when the device is running in xdp mode.
> This series has been tested running xdp_router_ipv4 sample available in t=
he
> kernel tree redirecting tcp traffic from veth pair into the mvneta driver.

Hi Alexei and Daniel,

please drop this revision, I will post a new version soon adding a check on=
 max
supported mtu when the loaded program support xdp frags.

Regards,
Lorenzo

>=20
> Changes since v2:
> - move rcu_access_pointer() check in veth_skb_is_eligible_for_gro
>=20
> Changes since v1:
> - always consider skb paged are non-writable
> - fix tpt issue with sctp
> - always use napi if we are running in xdp mode in veth_xmit
>=20
> Lorenzo Bianconi (3):
>   net: veth: account total xdp_frame len running ndo_xdp_xmit
>   veth: rework veth_xdp_rcv_skb in order to accept non-linear skb
>   veth: allow jumbo frames in xdp mode
>=20
>  drivers/net/veth.c | 212 +++++++++++++++++++++++++++++----------------
>  include/net/xdp.h  |  14 +++
>  net/core/xdp.c     |   1 +
>  3 files changed, 151 insertions(+), 76 deletions(-)
>=20
> --=20
> 2.35.1
>=20

--E9E7A/WvfuN84J/d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYid8OAAKCRA6cBh0uS2t
rJs6AQDRixs/npYZbWVQwrHy6O7z7k1hHwOnJ5CkmzNPSGfxxQD9GuACLgMgoLp1
hJJRXbs3oQrZ2a7GpHbCIAaY7RtI2Qg=
=GPEP
-----END PGP SIGNATURE-----

--E9E7A/WvfuN84J/d--

