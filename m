Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD6057977E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiGSKSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiGSKSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:18:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEEAA2A736
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658225923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bcjtNV9wmZc8THaTXZx2TGH+KDR4cetIcGJyUCqmf7U=;
        b=i5xpA2qg/7z/id9TsVV54TR8jv9SFIoIl2mO1xSC4fnk9AzDpeOv7i+8RIDsiYzvaT9W/d
        44kSrhQaRFxqdfi9gLDfgim33La/OfkTTssBqMPJpoNNCIRc0GzjUg7qgBG1KGygYTOLGG
        6CTt1Nq3AHiHMtRzPTqxbVvHwMw1rGw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-EEVDTGuaOkabGXIC3LiPSA-1; Tue, 19 Jul 2022 06:18:41 -0400
X-MC-Unique: EEVDTGuaOkabGXIC3LiPSA-1
Received: by mail-wm1-f72.google.com with SMTP id a6-20020a05600c348600b003a2d72b7a15so10046718wmq.9
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bcjtNV9wmZc8THaTXZx2TGH+KDR4cetIcGJyUCqmf7U=;
        b=synFp28UyskQYIwIekLqOQW7m4eGncMdyMJvzxCLFT6I9AKIQOZ4qVZO072uKOorfZ
         m7SZXIDdfsslO6+6U6CH+2OEEEvIbM7NbpDAilgl52qM95sCCbjTOr0Q3K9nNKzTcBDF
         M5G3ufp2ROGWXDc4xFW1R9ttH16nZNAAVhSL7t0SgZzae5NInYqXEONWt5eyhJao0nd8
         MS6EOpd36l2AZ9NiG9X16k1F8pZYpGvN6RKuUCLLG6BNLCigr4vgIbVDlte39x4hZ39a
         2/kJLH8a77C1HyytLesY9+78maLc7bHGJehZvQALAJ0TaxwSQl+p7RiHMql5FAX9yqNO
         gK9w==
X-Gm-Message-State: AJIora8nwGyOgEJAseflbaeJ4fcp+jBN6KW58bEB6W/9jue/dn/3m7xD
        iaWGOyi4PfFgqIxsaq1ozI9GEqL/4mPpAi1Lt7RRyKGUHaqu2Gb6g33mry74lWPdg/WafYt2qkR
        ex5c00u+Gjl5osHZD
X-Received: by 2002:adf:f492:0:b0:21d:89d5:9443 with SMTP id l18-20020adff492000000b0021d89d59443mr25729800wro.201.1658225920319;
        Tue, 19 Jul 2022 03:18:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t+M6eTgVqsnCSPqeqomALCw6aMTVg+qP8eQypC4kapQKeN4OsBGXpfQ8ticMzI81qfRUHLsw==
X-Received: by 2002:adf:f492:0:b0:21d:89d5:9443 with SMTP id l18-20020adff492000000b0021d89d59443mr25729775wro.201.1658225920107;
        Tue, 19 Jul 2022 03:18:40 -0700 (PDT)
Received: from localhost (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e9-20020adfef09000000b0021b89f8662esm12922622wro.13.2022.07.19.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 03:18:39 -0700 (PDT)
Date:   Tue, 19 Jul 2022 12:18:36 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com
Subject: Re: [PATCH v3 net-next 5/5] net: ethernet: mtk_eth_soc: add support
 for page_pool_get_stats
Message-ID: <YtaE/KJDNOqkvLml@localhost.localdomain>
References: <cover.1657956652.git.lorenzo@kernel.org>
 <8592ada26b28995d038ef67f15c145b6cebf4165.1657956652.git.lorenzo@kernel.org>
 <43ff0071f0ce4b958f27427acebcf2c6ace52ba0.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8SZvmLJxItoVIA7C"
Content-Disposition: inline
In-Reply-To: <43ff0071f0ce4b958f27427acebcf2c6ace52ba0.camel@redhat.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8SZvmLJxItoVIA7C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 2022-07-16 at 09:34 +0200, Lorenzo Bianconi wrote:
> > Introduce support for the page_pool stats API into mtk_eth_soc driver.
> > Report page_pool stats through ethtool.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/mediatek/Kconfig       |  1 +
> >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 40 +++++++++++++++++++--
> >  2 files changed, 38 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethern=
et/mediatek/Kconfig
> > index d2422c7b31b0..97374fb3ee79 100644
> > --- a/drivers/net/ethernet/mediatek/Kconfig
> > +++ b/drivers/net/ethernet/mediatek/Kconfig
> > @@ -18,6 +18,7 @@ config NET_MEDIATEK_SOC
> >  	select PHYLINK
> >  	select DIMLIB
> >  	select PAGE_POOL
> > +	select PAGE_POOL_STATS
> >  	help
> >  	  This driver supports the gigabit ethernet MACs in the
> >  	  MediaTek SoC family.
> > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/=
ethernet/mediatek/mtk_eth_soc.c
> > index abb8bc281015..eba95a86086d 100644
> > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > @@ -3517,11 +3517,19 @@ static void mtk_get_strings(struct net_device *=
dev, u32 stringset, u8 *data)
> >  	int i;
> > =20
> >  	switch (stringset) {
> > -	case ETH_SS_STATS:
> > +	case ETH_SS_STATS: {
> > +		struct mtk_mac *mac =3D netdev_priv(dev);
> > +		struct mtk_eth *eth =3D mac->hw;
> > +
> >  		for (i =3D 0; i < ARRAY_SIZE(mtk_ethtool_stats); i++) {
> >  			memcpy(data, mtk_ethtool_stats[i].str, ETH_GSTRING_LEN);
> >  			data +=3D ETH_GSTRING_LEN;
> >  		}
> > +		if (!eth->hwlro)
>=20
> I see the page_pool is enabled if and only if !hwlro, but I think it
> would be more clear if you explicitly check for page_pool here (and in
> a few other places below), so that if the condition to enable page_pool
> someday will change, this code will still be fine.

Hi Paolo,

page_pool pointer is defined in mtk_rx_ring structure, so theoretically we =
can have a
page_pool defined for queue 0 but not for queues {1, 2, 3}. "!eth->hwlro" m=
eans
there is at least one page_pool allocated. Do you prefer to do something li=
ke:

bool mtk_is_pp_enabled(struct mtk_eth *eth)
{
	for (i =3D 0; i < ARRAY_SIZE(eth->rx_ring); i++) {
		struct mtk_rx_ring *ring =3D &eth->rx_ring[i];

		if (ring->page_pool)
			return true;
	}
	return false;
}

Regards,
Lorenzo

>=20
> Thanks!
>=20
> Paolo
>=20

--8SZvmLJxItoVIA7C
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYtaE+QAKCRA6cBh0uS2t
rEC5AQDq6EMtRHb11mzlTo2GCWmwsHt8GBeA4GkaEOItm4V61AD9GDfcR58iPC2G
KiaDgzLAhaM4cRamwlleYBG9gLFClgk=
=7eQa
-----END PGP SIGNATURE-----

--8SZvmLJxItoVIA7C--

