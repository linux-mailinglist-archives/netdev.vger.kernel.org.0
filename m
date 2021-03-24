Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89483474A3
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 10:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbhCXJ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 05:29:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234779AbhCXJ2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 05:28:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616578123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fIa5MTTbbF2h5i82NLwRCE2FeeKGdQ6mEyVMr3p46EA=;
        b=E3qsDSqadghYwVdxI2X57bKjwpat6JPxPbdldw6M0FETnwwTf26cThVwyQ6o6+LKYbZbIH
        Akrhe9mZJmvuJYDOUlve3lY/lSSlPmjta9vvxHsE76GuEU92o014ctK6lwNRkLHep93lLG
        g5Q6oySE7jIHC91LkGEMYbbmTO47yS0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-yUDOqw_iMPyjX1UeFTOmAQ-1; Wed, 24 Mar 2021 05:28:41 -0400
X-MC-Unique: yUDOqw_iMPyjX1UeFTOmAQ-1
Received: by mail-wr1-f71.google.com with SMTP id t14so810316wrx.12
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 02:28:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fIa5MTTbbF2h5i82NLwRCE2FeeKGdQ6mEyVMr3p46EA=;
        b=jFPO7wMS1CGD1S86ZEhYXJhzCc+wFa3vL2sQblGRBuRLLZKHkVYBrEPASI3QTM6LyC
         tQ1G1NJZR+vY95N3Pdt1wfhOBIRo3n2+dwAlJ/kY4eEdB6kCfA0G+PN15ghEoFrEdObs
         /KShZX9qmAJK6RfgSqGD+N6ClJ9WQUoXiJjE8FuvRjhWnVLtSc4MST+4AcG9VR20mrjs
         CvhCRdDHtSzg9ZnWl2bNHA23rf3+nHP0cwGJ5mvTDG05qpYgOuHuTPBc0WBSF5h8yGL5
         JnwRdiMmp2AfEbzWdm45ki/D5I4xjoDjWxOO6rpbG/zeZh+u/4zx19ksQJLquK1N+abb
         frQQ==
X-Gm-Message-State: AOAM531jo+0+pJH+UWtmkle4igj+pFw6J83pNnNElyv/LBM7ItYmkE/0
        zIkVnDbGHTZiWvJ8KUnbSHlnY9bLMXuvbI23nQOR9vzvz+xlEZeyGE/0yVM93HOaVAHARQZiRN9
        pSeNg7J9QWZcjE/Is
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr1961701wmo.8.1616578119233;
        Wed, 24 Mar 2021 02:28:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYbWDW+MGBZ81vAKerZL7OP61pFoC017ZeK3TIAR0+ikJWUeuGMb3jeM4vhALe/X4IJ8Y3dA==
X-Received: by 2002:a05:600c:2312:: with SMTP id 18mr1961690wmo.8.1616578119072;
        Wed, 24 Mar 2021 02:28:39 -0700 (PDT)
Received: from localhost ([151.66.54.126])
        by smtp.gmail.com with ESMTPSA id e17sm2493386wra.65.2021.03.24.02.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 02:28:38 -0700 (PDT)
Date:   Wed, 24 Mar 2021 10:28:35 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 6/6] mvneta: recycle buffers
Message-ID: <YFsGQx6XMbYRtBOR@lore-desk>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
 <20210322170301.26017-7-mcroce@linux.microsoft.com>
 <20210323160611.28ddc712@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PFe7S71U15D4cqrp"
Content-Disposition: inline
In-Reply-To: <20210323160611.28ddc712@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PFe7S71U15D4cqrp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index a635cf84608a..8b3250394703 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2332,7 +2332,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, str=
uct mvneta_rx_queue *rxq,
> >  	if (!skb)
> >  		return ERR_PTR(-ENOMEM);
> > =20
> > -	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> > +	skb_mark_for_recycle(skb, virt_to_page(xdp->data), &xdp->rxq->mem);
> > =20
> >  	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> >  	skb_put(skb, xdp->data_end - xdp->data);
> > @@ -2344,7 +2344,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, str=
uct mvneta_rx_queue *rxq,
> >  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> >  				skb_frag_page(frag), skb_frag_off(frag),
> >  				skb_frag_size(frag), PAGE_SIZE);
> > -		page_pool_release_page(rxq->page_pool, skb_frag_page(frag));
> > +		skb_mark_for_recycle(skb, skb_frag_page(frag), &xdp->rxq->mem);
> >  	}
> > =20
> >  	return skb;
>=20
> This cause skb_mark_for_recycle() to set 'skb->pp_recycle=3D1' multiple
> times, for the same SKB.  (copy-pasted function below signature to help
> reviewers).
>=20
> This makes me question if we need an API for setting this per page
> fragment?
> Or if the API skb_mark_for_recycle() need to walk the page fragments in
> the SKB and set the info stored in the page for each?

Considering just performances, I guess it is better open-code here since the
driver already performs a loop over fragments to build the skb, but I guess
this approach is quite risky and I would prefer to have a single utility
routine to take care of linear area + fragments. What do you think?

Regards,
Lorenzo

>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--PFe7S71U15D4cqrp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYFsGQAAKCRA6cBh0uS2t
rFgiAP0c8Q5ppxzpPYMYk5waAY9QN9APUtx2G3i42vTAQpux1wEAsok6G5Kdb/ww
bYEkrUU4/iizc56IifIQQ8iY05slpgk=
=h2Ta
-----END PGP SIGNATURE-----

--PFe7S71U15D4cqrp--

