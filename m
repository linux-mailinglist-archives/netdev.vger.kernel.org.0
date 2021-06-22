Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D178A3AFF2C
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 10:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhFVIYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 04:24:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50337 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhFVIYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 04:24:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624350153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J2iS9JSY/lNrYMnrH5OxfhdBNvQ99yA1fxfdCnN3S0g=;
        b=Pavp7gYrfTj4xQD8kURjRkP3rRxHx0n1z6ac0JnGm+76jlzHyPLjdMHNPNFuIYtS4GMy4W
        hxqnjkiwJayGjR89IQVsSiNBT58R02QDB+sx3wzZwdTTrn+MknFdAoE+ayg7hNgu5GYv5Y
        0rn4IFzg7z1gbKn1AlE8w13dO279guM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-heTp2TECNE6YzvnoaFBQkw-1; Tue, 22 Jun 2021 04:22:32 -0400
X-MC-Unique: heTp2TECNE6YzvnoaFBQkw-1
Received: by mail-ej1-f72.google.com with SMTP id lt4-20020a170906fa84b0290481535542e3so5501893ejb.18
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 01:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J2iS9JSY/lNrYMnrH5OxfhdBNvQ99yA1fxfdCnN3S0g=;
        b=hoVMZzWUpmF9RpYqMxV5EHaPzS1uMRn3Wyy1C7E0GRh7wPLKsO67fQvLgiXLZphjt+
         5guM9RAi4YYLwjkNPp8XrZ2CHGU4rZ3pEWfJf1lMr7VOSGmqbJQJpNnNwiRPcFdvfaQm
         wqDB2+XmozmfeK7csY10sveW9m61BLmlDffLOhN+rH4GomUDHcKAAyb30UMVUeGTPycZ
         eFitlUVZWIIb+hznfRacBRmR+gRS405KGOA8MhXbF8ptKlp5AySsrPqPPcu0aDq0QGMg
         3ch+UnStEft7sM78G7W3jU4IYkPXYeDukFuFxPTO52OlgMvbNKBKR2o8fJKF5o4zwomo
         9dBw==
X-Gm-Message-State: AOAM533ulUAytxeAlAil7z1peOYtkLBMDpIu+DC3Ve0zrxklffvfessv
        CuNi2ThI61ZbWZMT3ZCXF/7uYz/ctkSicArm95dx2OOAH5ETH5D5H6a6LqaZUftBUuP2g4rXL13
        cjmZWWsr+g3gmSdEg0f1/jpgdC6rfSkNDPLIdCbjGhuCDd4/P9aO87ik9g+SwRUxMpisEYZiQfr
        NtvUk=
X-Received: by 2002:a05:6402:48f:: with SMTP id k15mr3251363edv.262.1624350150956;
        Tue, 22 Jun 2021 01:22:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCdl80gWI32GZHyQn93FNUG1MAdDECTTma2JjwBK9bauZ/+fTCnt9rrNjYSJT47H9/xRwd6w==
X-Received: by 2002:a05:6402:48f:: with SMTP id k15mr3251339edv.262.1624350150710;
        Tue, 22 Jun 2021 01:22:30 -0700 (PDT)
Received: from localhost (net-130-25-105-72.cust.vodafonedsl.it. [130.25.105.72])
        by smtp.gmail.com with ESMTPSA id u4sm5554444eje.81.2021.06.22.01.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 01:22:30 -0700 (PDT)
Date:   Tue, 22 Jun 2021 10:22:27 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mcroce@linux.microsoft.com, davem@davemloft.net, kuba@kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com, stefanc@marvell.com,
        brouer@redhat.com, thomas.petazzoni@bootlin.com,
        linux@armlinux.org.uk, mw@semihalf.com
Subject: Re: [PATCH net-next] net: marvell: return csum computation result
 from mvneta_rx_csum/mvpp2_rx_csum
Message-ID: <YNGdw+T283xPwQDM@lore-desk>
References: <73619ca7d64b1dee91ed8ed2dcf0ddbbc57b4b0a.1623943981.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PTtSFSYaXmNzBoGR"
Content-Disposition: inline
In-Reply-To: <73619ca7d64b1dee91ed8ed2dcf0ddbbc57b4b0a.1623943981.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PTtSFSYaXmNzBoGR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> This is a preliminary patch to add hw csum hint support to
> mvneta/mvpp2 xdp implementation
>=20
> Tested-by: Matteo Croce <mcroce@linux.microsoft.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Hi Dave and Jakub,

I have just noticed this patch is marked as "Not Applicable" in patchwork. I
tried to rebase it on top of net-next and it applies and compiles so I am
wondering why it is "not applicable". Am I missing something?

Regards,
Lorenzo

> ---
>  drivers/net/ethernet/marvell/mvneta.c         | 19 +++++++------------
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14 +++++---------
>  2 files changed, 12 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
> index c15ce06427d0..88a755034c39 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1805,18 +1805,14 @@ static void mvneta_rx_error(struct mvneta_port *p=
p,
>  }
> =20
>  /* Handle RX checksum offload based on the descriptor's status */
> -static void mvneta_rx_csum(struct mvneta_port *pp, u32 status,
> -			   struct sk_buff *skb)
> +static int mvneta_rx_csum(struct mvneta_port *pp, u32 status)
>  {
>  	if ((pp->dev->features & NETIF_F_RXCSUM) &&
>  	    (status & MVNETA_RXD_L3_IP4) &&
> -	    (status & MVNETA_RXD_L4_CSUM_OK)) {
> -		skb->csum =3D 0;
> -		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> -		return;
> -	}
> +	    (status & MVNETA_RXD_L4_CSUM_OK))
> +		return CHECKSUM_UNNECESSARY;
> =20
> -	skb->ip_summed =3D CHECKSUM_NONE;
> +	return CHECKSUM_NONE;
>  }
> =20
>  /* Return tx queue pointer (find last set bit) according to <cause> retu=
rned
> @@ -2335,7 +2331,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struc=
t page_pool *pool,
> =20
>  	skb_reserve(skb, xdp->data - xdp->data_hard_start);
>  	skb_put(skb, xdp->data_end - xdp->data);
> -	mvneta_rx_csum(pp, desc_status, skb);
> +	skb->ip_summed =3D mvneta_rx_csum(pp, desc_status);
> =20
>  	for (i =3D 0; i < num_frags; i++) {
>  		skb_frag_t *frag =3D &sinfo->frags[i];
> @@ -2535,7 +2531,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
>  				     rx_bytes);
> =20
>  			skb->protocol =3D eth_type_trans(skb, dev);
> -			mvneta_rx_csum(pp, rx_status, skb);
> +			skb->ip_summed =3D mvneta_rx_csum(pp, rx_status);
>  			napi_gro_receive(napi, skb);
> =20
>  			rcvd_pkts++;
> @@ -2584,8 +2580,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
>  		skb_put(skb, rx_bytes);
> =20
>  		skb->protocol =3D eth_type_trans(skb, dev);
> -
> -		mvneta_rx_csum(pp, rx_status, skb);
> +		skb->ip_summed =3D mvneta_rx_csum(pp, rx_status);
> =20
>  		napi_gro_receive(napi, skb);
>  	}
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/ne=
t/ethernet/marvell/mvpp2/mvpp2_main.c
> index 9bca8c8f9f8d..01f6078bc859 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3543,21 +3543,17 @@ static void mvpp2_rx_error(struct mvpp2_port *por=
t,
>  }
> =20
>  /* Handle RX checksum offload */
> -static void mvpp2_rx_csum(struct mvpp2_port *port, u32 status,
> -			  struct sk_buff *skb)
> +static int mvpp2_rx_csum(struct mvpp2_port *port, u32 status)
>  {
>  	if (((status & MVPP2_RXD_L3_IP4) &&
>  	     !(status & MVPP2_RXD_IP4_HEADER_ERR)) ||
>  	    (status & MVPP2_RXD_L3_IP6))
>  		if (((status & MVPP2_RXD_L4_UDP) ||
>  		     (status & MVPP2_RXD_L4_TCP)) &&
> -		     (status & MVPP2_RXD_L4_CSUM_OK)) {
> -			skb->csum =3D 0;
> -			skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> -			return;
> -		}
> +		     (status & MVPP2_RXD_L4_CSUM_OK))
> +			return CHECKSUM_UNNECESSARY;
> =20
> -	skb->ip_summed =3D CHECKSUM_NONE;
> +	return CHECKSUM_NONE;
>  }
> =20
>  /* Allocate a new skb and add it to BM pool */
> @@ -4012,7 +4008,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct=
 napi_struct *napi,
> =20
>  		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
>  		skb_put(skb, rx_bytes);
> -		mvpp2_rx_csum(port, rx_status, skb);
> +		skb->ip_summed =3D mvpp2_rx_csum(port, rx_status);
>  		skb->protocol =3D eth_type_trans(skb, dev);
> =20
>  		napi_gro_receive(napi, skb);
> --=20
> 2.31.1
>=20

--PTtSFSYaXmNzBoGR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYNGdvwAKCRA6cBh0uS2t
rJ5DAQDc0jynUWFts6fyHTw3EW2wV7JJfS1iW+E0J3LunrwDiwEAlMfnyktEE38C
Q5dh+MGy/mx/HOaL1lDPnBa05SgHHw8=
=zKFB
-----END PGP SIGNATURE-----

--PTtSFSYaXmNzBoGR--

