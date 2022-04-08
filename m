Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1EA4F9B6D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 19:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbiDHRQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 13:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbiDHRQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 13:16:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEBC9100A56
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 10:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649438067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A2fhkjb4EBVxVNrfY3jtmKe45au12v2L5fCV5oj5j3A=;
        b=frj1lPbxxyg2DwTavKRrYio9uc6peE1o0pdaKDbHwfUbnTMzh0ZE+VC2XhF4E5dcRvk1SL
        gAv2KV2hDWOeS/nzxMTyulF8GiwMm4apNIyD2xC/LUx4Z5BbZCtpyQlQYLTjrEvQkh5BtE
        2hgPsJdMcVjAgGZeirkhrKUCyOXqAN0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-kt2k1gfMNfuFIHVD4QDbvg-1; Fri, 08 Apr 2022 13:14:25 -0400
X-MC-Unique: kt2k1gfMNfuFIHVD4QDbvg-1
Received: by mail-wm1-f72.google.com with SMTP id v62-20020a1cac41000000b0038cfe6edf3fso6212717wme.5
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 10:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A2fhkjb4EBVxVNrfY3jtmKe45au12v2L5fCV5oj5j3A=;
        b=mJhMekqniPU/8jnJchUxPii94kIEcNGkrf5BI5dAE329Tpk6MxqnhLERiNTfvMMcMj
         8X/BCL1hSSiSO6fKOSPcmY2zmZ0FDxO+p0Z0Z9fgZwT4t6nBVESKapg+kAcVBsNq70kd
         KWxtlNV+uZ+vEt/AALTmbAm2lMjKf7Q9C5k8zIsxz+AFZ71rdm3g6zz9cxbnb5X+ddgE
         /Wj9ZIdtDSnpk3HKBnYHfpaEywqA9tQFK+seNHZ0wKu/T4zkTBLWj7M6ntTg0HkL98FP
         UaVgWmD44BAzIghS+v9EweFYWADkVhZ/fYdJgFU7MAo1L0s9yQUycfHe76S9WP8C2Unp
         rj5A==
X-Gm-Message-State: AOAM533tIxjZD8gqZCJWcyMfEZh/sxht28ceeXEO0dycbpZQQVHZrcfJ
        rG4B9U7yG6++d+cu0sWeP/e4t1kKH5dkiCAyFCJ7bp0q/fh6BqroQtYWF9G9979jfMdbrnnkx9R
        vwy3w3WhWez54Gmrl
X-Received: by 2002:adf:c145:0:b0:207:84dc:3851 with SMTP id w5-20020adfc145000000b0020784dc3851mr7708755wre.182.1649438064755;
        Fri, 08 Apr 2022 10:14:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkHLYFaJBWnENz+M1lkDzLBJ22/HMOsrWmb5iSnrlPmqVqqsZRhymT13AIs7fOl2SN2gamxg==
X-Received: by 2002:adf:c145:0:b0:207:84dc:3851 with SMTP id w5-20020adfc145000000b0020784dc3851mr7708742wre.182.1649438064490;
        Fri, 08 Apr 2022 10:14:24 -0700 (PDT)
Received: from localhost (net-93-71-56-156.cust.vodafonedsl.it. [93.71.56.156])
        by smtp.gmail.com with ESMTPSA id a11-20020a056000188b00b00204109f7826sm22846438wri.28.2022.04.08.10.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 10:14:24 -0700 (PDT)
Date:   Fri, 8 Apr 2022 19:14:22 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH v2 net-next 2/2] net: mvneta: add support for
 page_pool_get_stats
Message-ID: <YlBtbqjblTO2EU6j@lore-desk>
References: <cover.1649405981.git.lorenzo@kernel.org>
 <86f4e67f3f2eaf13e588b4989b364b1616b5fcad.1649405981.git.lorenzo@kernel.org>
 <YlA7yQ0NZi94ob/Q@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jpDXSIzqo9d7ergo"
Content-Disposition: inline
In-Reply-To: <YlA7yQ0NZi94ob/Q@lunn.ch>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jpDXSIzqo9d7ergo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > @@ -4732,9 +4732,13 @@ static void mvneta_ethtool_get_strings(struct ne=
t_device *netdev, u32 sset,
> >  	if (sset =3D=3D ETH_SS_STATS) {
> >  		int i;
> > =20
> > -		for (i =3D 0; i < ARRAY_SIZE(mvneta_statistics); i++)
> > -			memcpy(data + i * ETH_GSTRING_LEN,
> > -			       mvneta_statistics[i].name, ETH_GSTRING_LEN);
> > +		for (i =3D 0; i < ARRAY_SIZE(mvneta_statistics); i++) {
> > +			memcpy(data, mvneta_statistics[i].name,
> > +			       ETH_GSTRING_LEN);
> > +			data +=3D ETH_GSTRING_LEN;
> > +		}
>=20
> You don't need to touch this loop, you can just do:

ack, it was just to avoid a long line, I will fix it.

>=20
> > +
> > +		page_pool_ethtool_stats_get_strings(data +
> 				ETH_GSTRING_LEN * ARRAY_SIZE(mvneta_staticstics)));
> >  	}
> >  }
> > =20
> > @@ -5392,6 +5412,14 @@ static int mvneta_probe(struct platform_device *=
pdev)
> >  	pp->rxq_def =3D rxq_def;
> >  	pp->indir[0] =3D rxq_def;
> > =20
> > +	stats_len =3D ARRAY_SIZE(mvneta_statistics) +
> > +		    page_pool_ethtool_stats_get_count();
> > +	pp->ethtool_stats =3D devm_kzalloc(&pdev->dev,
> > +					 sizeof(*pp->ethtool_stats) * stats_len,
> > +					 GFP_KERNEL);
>=20
> Why do you do this? The page_pool stats are never stored in
> pp->ethtool_stats.

ops, I need to drop this, thanks.

Regards,
Lorenzo

>=20
> 	Andrew
>=20

--jpDXSIzqo9d7ergo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlBtbQAKCRA6cBh0uS2t
rN/JAQDrhhGgufb6qDWjUnMbDXsJSkl4c40FKeyesL8AVWOupQEA2CNXBKqNpH7S
yVD/ZH3OqQC5dGNZWZP+XSJT4AbruA8=
=/qxw
-----END PGP SIGNATURE-----

--jpDXSIzqo9d7ergo--

