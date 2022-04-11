Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6584B4FBC0A
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346062AbiDKMaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346063AbiDKMaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:30:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00343EAB3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 05:28:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E64261669
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201F4C385A3;
        Mon, 11 Apr 2022 12:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649680117;
        bh=OnURoOKYoA3DQyjJOPvXnMPhHGdkXGhl4nDTVzgzpyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y9zO+koONDEF3oWCTcm1t5Y9u8WKyGtYYOq+3MpGeBQ7Xvj32iUFQLWaLgPfYIRor
         zYGAPcSURDDIRt71xyVDg0jMlRYAjzDdUO68wqOLmbiR1cmxvz1uqG+AJxjwTP3ZTM
         e4If+RJyG7/fR7M1T8rM4Rd6pdInxzwUS+AaAEh2p1E24EY7DA79UkHVNWtZ9FHNTS
         qski4vgqRabRm4GrxdcnSq64+OaOeVhXw6fP62gUBbh315gY50Dx5KWWdgOSY7HomB
         CSFHiellOrbCIGrJXRWoHAhqLFWDmANlN5GJ84gfSP/ZZrvYfGe7Y5QB3LoOoNIEdi
         c+MubjLNOo9Vw==
Date:   Mon, 11 Apr 2022 14:28:33 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, linux@armlinux.org.uk,
        jbrouer@redhat.com, jdamato@fastly.com, andrew@lunn.ch
Subject: Re: [PATCH v3 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlQe8QysuyGRtxAx@lore-desk>
References: <cover.1649528984.git.lorenzo@kernel.org>
 <628c0a6d9bdbc547c93fcd4ae2e84d08af7bc8e1.1649528984.git.lorenzo@kernel.org>
 <CAC_iWj+wGjx4uAmtkvP=kJsD1uBKsxUXPfy8YS8Abhz=ooLmkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RfPfkC+F5bOC/ulS"
Content-Disposition: inline
In-Reply-To: <CAC_iWj+wGjx4uAmtkvP=kJsD1uBKsxUXPfy8YS8Abhz=ooLmkg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RfPfkC+F5bOC/ulS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Lorenzo,

Hi Ilias,

>=20
> [...]
>=20
> >
> >         for_each_possible_cpu(cpu) {
> >                 const struct page_pool_recycle_stats *pcpu =3D
> > @@ -66,6 +87,47 @@ bool page_pool_get_stats(struct page_pool *pool,
> >         return true;
> >  }
> >  EXPORT_SYMBOL(page_pool_get_stats);
> > +
> > +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> > +{
> > +       int i;
> > +
> > +       for (i =3D 0; i < ARRAY_SIZE(pp_stats); i++) {
> > +               memcpy(data, pp_stats[i], ETH_GSTRING_LEN);
> > +               data +=3D ETH_GSTRING_LEN;
> > +       }
> > +
> > +       return data;
>=20
> Is there a point returning data here or can we make this a void?

it is to add the capability to add more strings in the driver code after
running page_pool_ethtool_stats_get_strings.

>=20
> > +}
> > +EXPORT_SYMBOL(page_pool_ethtool_stats_get_strings);
> > +
> > +int page_pool_ethtool_stats_get_count(void)
> > +{
> > +       return ARRAY_SIZE(pp_stats);
> > +}
> > +EXPORT_SYMBOL(page_pool_ethtool_stats_get_count);
> > +
> > +u64 *page_pool_ethtool_stats_get(u64 *data, struct page_pool_stats *st=
ats)
> > +{
> > +       int i;
> > +
> > +       for (i =3D 0; i < ARRAY_SIZE(pp_stats); i++) {
> > +               *data++ =3D stats->alloc_stats.fast;
> > +               *data++ =3D stats->alloc_stats.slow;
> > +               *data++ =3D stats->alloc_stats.slow_high_order;
> > +               *data++ =3D stats->alloc_stats.empty;
> > +               *data++ =3D stats->alloc_stats.refill;
> > +               *data++ =3D stats->alloc_stats.waive;
> > +               *data++ =3D stats->recycle_stats.cached;
> > +               *data++ =3D stats->recycle_stats.cache_full;
> > +               *data++ =3D stats->recycle_stats.ring;
> > +               *data++ =3D stats->recycle_stats.ring_full;
> > +               *data++ =3D stats->recycle_stats.released_refcnt;
> > +       }
> > +
> > +       return data;
>=20
> Ditto

same here.

Regards,
Lorenzo

>=20
> > +}
> > +EXPORT_SYMBOL(page_pool_ethtool_stats_get);
> >  #else
> >  #define alloc_stat_inc(pool, __stat)
> >  #define recycle_stat_inc(pool, __stat)
> > --
> > 2.35.1
> >
>=20
> Thanks
> /Ilias

--RfPfkC+F5bOC/ulS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlQe8QAKCRA6cBh0uS2t
rA98AQC7b70a7+97LpYUzdoEGXUT630AO4LhEXn1PJ8B8k4lkAD/Qc3bp9K6oprE
XWhDr27+03jp3J4q2gqdVQcW9XL9HAI=
=Zv0g
-----END PGP SIGNATURE-----

--RfPfkC+F5bOC/ulS--
