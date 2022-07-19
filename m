Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE06F5797B0
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiGSKbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiGSKbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:31:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D5923F311
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658226670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hO2Yeg1EjCoAnHuO2qJc5128tqfv4keTxr6JIGZsXXw=;
        b=BI+qXY5noqQ+s/TY3IZjx8jeiek/uUHYjVmwcUE3TblyJ9QPAJIZYw3HGIiGHSpDbwl/MQ
        lzBaXTrJOoDFBvM7tpnVkgzCpyNFKqkYk6xOc/Fftquh+Va/C6ELZGrLBXguWAK1gI0OvZ
        YVh1o5pE3lXNBfdJ4WG4oPCBwBQc/qM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-NlKndTgAPpOkdvaX5b9lGg-1; Tue, 19 Jul 2022 06:31:09 -0400
X-MC-Unique: NlKndTgAPpOkdvaX5b9lGg-1
Received: by mail-wm1-f71.google.com with SMTP id bh18-20020a05600c3d1200b003a32044cc9fso1609676wmb.6
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hO2Yeg1EjCoAnHuO2qJc5128tqfv4keTxr6JIGZsXXw=;
        b=Egc2f99stn/fZOkE7jYAi44bP/47txHHwLXdoGl7U206N/8hpRbBEYpk5OyzoCiD3+
         O6fP1MrZ83gal67zgEIn4Q2JOuKfiFt6z1BqG2l2neRK3zfZsDbrsgw8X7RsFIBx0d3Y
         V6hIg8Guw3XxBbR/Ibh5ePKN/KCxLO+bnTO7gottnld+ycFsHmJKPW+DnK3ilD7dgyzN
         F26KN1mUtZu7GxYdJwtvseHm0RdrXW79hUKayP+1ElJ8LTUmCqPmxB66WIoBaSs1kG8R
         x0j2bcdSjWVFOyGEkfcKrJdlelYTFiv0nCKt2vMWhxf1/nAhHgUyk9omWrG5/dIUb7Bx
         7UUw==
X-Gm-Message-State: AJIora8nTgRL/87iQvcH72B2rr1JNg4qpIjJmP/BFfNoVAujjRE6zoKX
        o2qNIF5GNEhTZN1OJEEUItRc9loTCKbOqhvfPG3xyobPs+y8PSpb3OTKUuV2ovh1+boFbhkAhrL
        QNfJYHx01brfUggni
X-Received: by 2002:a05:6000:60a:b0:21d:9451:e91 with SMTP id bn10-20020a056000060a00b0021d94510e91mr26875714wrb.73.1658226667770;
        Tue, 19 Jul 2022 03:31:07 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u5W1ZH8zhxxQtjlgAOgTvXC10C+B+JsErYZGSxT0hoMG5tSx5BYrru2+olfB8xvHNGilqN1w==
X-Received: by 2002:a05:6000:60a:b0:21d:9451:e91 with SMTP id bn10-20020a056000060a00b0021d94510e91mr26875691wrb.73.1658226667533;
        Tue, 19 Jul 2022 03:31:07 -0700 (PDT)
Received: from localhost (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id i3-20020a05600c14c300b003a32251c3f0sm2103638wmh.33.2022.07.19.03.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:31:07 -0700 (PDT)
Date:   Tue, 19 Jul 2022 12:31:03 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com
Subject: Re: [PATCH v3 net-next 2/5] net: ethernet: mtk_eth_soc: add basic
 XDP support
Message-ID: <YtaH523Jz39smaNO@localhost.localdomain>
References: <cover.1657956652.git.lorenzo@kernel.org>
 <b4c7646e70b1b719b8ae87a90bb8e4cf57b1a26d.1657956652.git.lorenzo@kernel.org>
 <5b6d4061bd12a9079e882742c750962816ee6567.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZUXewXXKXjpZZxkt"
Content-Disposition: inline
In-Reply-To: <5b6d4061bd12a9079e882742c750962816ee6567.camel@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZUXewXXKXjpZZxkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 2022-07-16 at 09:34 +0200, Lorenzo Bianconi wrote:
> > Introduce basic XDP support to mtk_eth_soc driver.
> > Supported XDP verdicts:
> > - XDP_PASS
> > - XDP_DROP
> > - XDP_REDIRECT
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 147 +++++++++++++++++---
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.h |   2 +
> >  2 files changed, 131 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/=
ethernet/mediatek/mtk_eth_soc.c
> > index 9a92d602ebd5..bc3a7dcab207 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -1494,11 +1494,44 @@ static void mtk_rx_put_buff(struct mtk_rx_ring =
*ring, void *data, bool napi)
> >  		skb_free_frag(data);
> >  }
> > =20
> > +static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
> > +		       struct xdp_buff *xdp, struct net_device *dev)
> > +{
> > +	struct bpf_prog *prog =3D rcu_dereference(eth->prog);
>=20
> It looks like here you need to acquire the RCU read lock. lockdep
> should splat otherwise.

ack, I will fix it in the next version.

Regards,
Lorenzo

>=20
> /P
>=20

--ZUXewXXKXjpZZxkt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYtaH5AAKCRA6cBh0uS2t
rFf+AP46JU45b0ZcVix0m0IoJyrPrwyRX9cf3KPyrpMERkh+cAD/Wvf0maFDO3Ik
E6XxXoMI1gVlKm5UUawDVfVxPiXrLws=
=m7o8
-----END PGP SIGNATURE-----

--ZUXewXXKXjpZZxkt--

