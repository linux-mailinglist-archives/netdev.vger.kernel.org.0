Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D47D4F9B6F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 19:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiDHRQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 13:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiDHRQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 13:16:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89039326DA
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 10:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649438086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+siPEu9hX28fqh6hq2jTpSFpq/ubLJn1qxQ7AtI7iCA=;
        b=Ym18ymtvb0tDtPgkH8LruCnz9yCm6hE8ZDxbesGuqRcqUxSpF+KMg0U7kQZkLCXjt7e5x4
        WnksEbYa+N7k91Dwj0RRdkQwskmbMZ+PPIFqFf1ShL/QMPulWsFkBGxDcO0LA76aWq/Y4x
        H7WZzjNmBLdV3AAyFwcuuxX62Umg7SI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-101-YoBLf5ILNjeC81Ml5uqidw-1; Fri, 08 Apr 2022 13:14:43 -0400
X-MC-Unique: YoBLf5ILNjeC81Ml5uqidw-1
Received: by mail-wm1-f72.google.com with SMTP id m31-20020a05600c3b1f00b0038e98dd534aso1290449wms.2
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 10:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+siPEu9hX28fqh6hq2jTpSFpq/ubLJn1qxQ7AtI7iCA=;
        b=IMT4/uaxzfGobLNQikaZTdx7OJ2X4vCJ9g/owcsucL4j6vXqNc1wuhZexXQ8wK1YaM
         h4gPydwc8GV3cDnT4JkfK07yeqbluGKFgT4cmS14bWppHBm8aJB2c4CJ6q/Ed5ohCVYP
         GWhVg10Q7AiWrNF+bAtsJOAunzcQ++eyTnhM32BawA6TaWCJpd3wy1+6lLVFXBMOBj5t
         2VF23qCD1OD1XF6qeR0iF7v0YnxYcIidRlX9a1ra/WjX2VCHPkNBijpH+hZl9q3ozd8o
         fmhibUogHmvoySbVm9UM2PlaGmNtaYkJNel4MBP+mqbEybSgTG9vUDCER0CcxDeyqZyR
         lIfg==
X-Gm-Message-State: AOAM533n9NVuS6H95XY2SVw2ijGPkHScz4lGsfEx4QSGxu71KQHawlJZ
        QTApZJNOSleSExa7/worGITGpxG4nU/wq4i4dWKFwBkdX01Mfaw+2bEkyg5HmPV5H6oiufVuBAv
        IoS1yKHaP24fdIVIT
X-Received: by 2002:a05:600c:4f46:b0:38c:d4cd:ee31 with SMTP id m6-20020a05600c4f4600b0038cd4cdee31mr17816731wmq.16.1649438082512;
        Fri, 08 Apr 2022 10:14:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxurIrIKI2GM/qUTTkNgHQAMWIiRRtLv7HVJKEy6FOvO+2pVk//iJag5q6gpKuSum1FwndkHA==
X-Received: by 2002:a05:600c:4f46:b0:38c:d4cd:ee31 with SMTP id m6-20020a05600c4f4600b0038cd4cdee31mr17816711wmq.16.1649438082329;
        Fri, 08 Apr 2022 10:14:42 -0700 (PDT)
Received: from localhost (net-93-71-56-156.cust.vodafonedsl.it. [93.71.56.156])
        by smtp.gmail.com with ESMTPSA id n22-20020a05600c4f9600b0038c6ec42c38sm10916061wmq.6.2022.04.08.10.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 10:14:41 -0700 (PDT)
Date:   Fri, 8 Apr 2022 19:14:40 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH v2 net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <YlBtgF9vH5uJwmKY@lore-desk>
References: <cover.1649405981.git.lorenzo@kernel.org>
 <63efff0da4235bfa2e326848545eb90c211e5db1.1649405981.git.lorenzo@kernel.org>
 <YlA8kMKK3VpJTjxx@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SLQOCjmg4eAb4klb"
Content-Disposition: inline
In-Reply-To: <YlA8kMKK3VpJTjxx@lunn.ch>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLQOCjmg4eAb4klb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Apr 08, Andrew Lunn wrote:
> > +u8 *page_pool_ethtool_stats_get_strings(u8 *data)
> > +{
> > +	static const char stats[PP_ETHTOOL_STATS_MAX][ETH_GSTRING_LEN] =3D {
> > +		"rx_pp_alloc_fast",
> > +		"rx_pp_alloc_slow",
> > +		"rx_pp_alloc_slow_ho",
> > +		"rx_pp_alloc_empty",
> > +		"rx_pp_alloc_refill",
> > +		"rx_pp_alloc_waive",
> > +		"rx_pp_recycle_cached",
> > +		"rx_pp_recycle_cache_full",
> > +		"rx_pp_recycle_ring",
> > +		"rx_pp_recycle_ring_full",
> > +		"rx_pp_recycle_released_ref",
> > +	};
> > +	int i;
> > +
> > +	for (i =3D 0; i < PP_ETHTOOL_STATS_MAX; i++) {
>=20
> I suggest you move this stats array out of the function, and then you
> can use ARRAY_SIZE(stats) instead of PP_ETHTOOL_STATS_MAX. That is a
> pretty common patters for ethtool statistics.

ack, I will fix it.

Regards,
Lorenzo

>=20
>        Andrew
>=20

--SLQOCjmg4eAb4klb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlBtfwAKCRA6cBh0uS2t
rNwPAP4qw7IMqi8ScRwkb9IiWQd1dzFTpnnkEP0YP6twgkUnOgEAiokCzR1Ip8Nt
iIMlNiGyRWDfTMjqO7CIjYVL0Fl4OQo=
=fZKi
-----END PGP SIGNATURE-----

--SLQOCjmg4eAb4klb--

