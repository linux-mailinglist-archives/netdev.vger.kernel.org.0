Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2382D162DB7
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgBRSDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:03:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726403AbgBRSDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582049028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tz9guKow86Vbwd5hgkcMKfdNy+latkJoDwKVTGU+PJo=;
        b=VIpSHPJ71Wjg+defV/7kPYcv5BUlul3STSqtB8Sb62WZI5RY66D45p0uceWRvrR8o3RmjT
        QXuKf+tllz2xm9+wdKgC9yJmtPFNGlzgT+R41y65TYfZxIkhK8BIyKpFp4P7MCZHXWCimk
        bFXOOO4anTah4Z88UT/mJdA02F5IcqE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-TA0vzn4POKa6YH1lk3KUkQ-1; Tue, 18 Feb 2020 13:03:42 -0500
X-MC-Unique: TA0vzn4POKa6YH1lk3KUkQ-1
Received: by mail-wr1-f70.google.com with SMTP id j4so11235139wrs.13
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 10:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tz9guKow86Vbwd5hgkcMKfdNy+latkJoDwKVTGU+PJo=;
        b=OJjG+sWSGENDgrQawQoVcI4iyL8DSvEobmFbSOBo094HNRDMbk2OJorMFSauY/9xnk
         kE+JxlBTKdnvk1Kk9IvWGdPlj67jBReacnCy9srVBxPjy9vklJFBEpSHjMS8h2Fy1D2l
         Bb6/pnZjTg17tAn8Q4H0+VYxbIt8UDV3nm4Ry/0Y8Uz8Fd1F5zshcd2aNIQv8LmngBf5
         DbGfaGKmtMbKe6iRiKC5UlUFmzrLxpTjy7D0Jsq515qLfhkQPjPKLvU7v9Kj4k511x2h
         toIa9cP/uYJQCjJUOu33r9UHj4O4akXfLmoA4Fgk7h7T8V2iAWf9LlczJFN21nBNV+w3
         orHQ==
X-Gm-Message-State: APjAAAXdFRWe9egKC/AVaLUIegZwwZ+zK7m2d8+6gj36Oae+SyzXeXpy
        P2+PtFHeb5f0vOw6De8+HItrNYfu8X6dNOouanqpMQMrxFPWcxgGmbvEPfx/Qi8up+PGQC6kZdq
        6gIWbnJ2olqznpjXJ
X-Received: by 2002:adf:a389:: with SMTP id l9mr29874256wrb.411.1582049020607;
        Tue, 18 Feb 2020 10:03:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqzkSujjdQl/sTXGYqTq/WN+L/WqySCdtSRhZEvFfx21923VNz0mw5VPJ339KNh9WuRBqv0T4Q==
X-Received: by 2002:adf:a389:: with SMTP id l9mr29874229wrb.411.1582049020263;
        Tue, 18 Feb 2020 10:03:40 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x10sm6982242wrp.58.2020.02.18.10.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 10:03:39 -0800 (PST)
Date:   Tue, 18 Feb 2020 19:03:36 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, andrew@lunn.ch,
        dsahern@kernel.org, bpf@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200218180336.GB13376@localhost.localdomain>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
 <20200218180210.130f0e6d@carbon>
 <20200218171716.GA13376@localhost.localdomain>
 <20200218184831.4359a61a@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20200218184831.4359a61a@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 18 Feb 2020 18:17:16 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > > On Tue, 18 Feb 2020 01:14:29 +0100
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >  =20
> > > > Introduce "rx" prefix in the name scheme for xdp counters
> > > > on rx path.
> > > > Differentiate between XDP_TX and ndo_xdp_xmit counters
> > > >=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++-----
> > > >  1 file changed, 17 insertions(+), 5 deletions(-)
> > > >=20
> > > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/et=
hernet/marvell/mvneta.c
> > > > index b7045b6a15c2..6223700dc3df 100644
> > > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > > @@ -344,6 +344,7 @@ enum {
> > > >  	ETHTOOL_XDP_REDIRECT,
> > > >  	ETHTOOL_XDP_PASS,
> > > >  	ETHTOOL_XDP_DROP,
> > > > +	ETHTOOL_XDP_XMIT,
> > > >  	ETHTOOL_XDP_TX,
> > > >  	ETHTOOL_MAX_STATS,
> > > >  };
> > > > @@ -399,10 +400,11 @@ static const struct mvneta_statistic mvneta_s=
tatistics[] =3D {
> > > >  	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
> > > >  	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
> > > >  	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
> > > > -	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
> > > > -	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
> > > > -	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
> > > > -	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
> > > > +	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
> > > > +	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
> > > > +	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
> > > > +	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx_xmit", }, =20
> > >=20
> > > Hmmm... "rx_xdp_tx_xmit", I expected this to be named "rx_xdp_tx" to
> > > count the XDP_TX actions, but I guess this means something else. =20
> >=20
> > just reused mlx5 naming scheme here :)
>=20
> Well, IMHO the naming in mlx5 should not automatically be seen as the
> correct way ;-)

sure, I have no prefernces actually :)

> =20
> > >  =20
> > > > +	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", }, =20
> > >=20
> > > Okay, maybe.  I guess, this will still be valid for when we add an
> > > XDP egress/TX-hook point. =20
> >=20
> > same here
> >=20
> > >  =20
> > > >  };
> > > > =20
> > > >  struct mvneta_stats {
> > > > @@ -414,6 +416,7 @@ struct mvneta_stats {
> > > >  	u64	xdp_redirect;
> > > >  	u64	xdp_pass;
> > > >  	u64	xdp_drop;
> > > > +	u64	xdp_xmit;
> > > >  	u64	xdp_tx;
> > > >  };
> > > > =20
> > > > @@ -2050,7 +2053,10 @@ mvneta_xdp_submit_frame(struct mvneta_port
> > > > *pp, struct mvneta_tx_queue *txq,
> > > > u64_stats_update_begin(&stats->syncp); stats->es.ps.tx_bytes +=3D
> > > > xdpf->len; stats->es.ps.tx_packets++;
> > > > -	stats->es.ps.xdp_tx++;
> > > > +	if (buf->type =3D=3D MVNETA_TYPE_XDP_NDO)
> > > > +		stats->es.ps.xdp_xmit++;
> > > > +	else
> > > > +		stats->es.ps.xdp_tx++; =20
> > >=20
> > > I don't like that you add a branch (if-statement) in this fast-path
> > > code.
> > >=20
> > > Do we really need to account in the xmit frame function, if this
> > > was a XDP_REDIRECT or XDP_TX that started the xmit?  I mean we
> > > already have action counters for XDP_REDIRECT and XDP_TX (but I
> > > guess you skipped the XDP_TX action counter).  =20
> >=20
> > ack, good point..I think we can move the code in
> > mvneta_xdp_xmit_back/mvneta_xdp_xmit in order to avoid the if()
> > condition. Moreover we can move it out the for loop in
> > mvneta_xdp_xmit().
>=20
> Sure, but I want the "xmit" counter (or what every we call it) to only
> increment if the Ethernet frame was successfully queued. For me that is
> an important property of the counter.  As I want a sysadm to be able to
> use this counter to see if frames are getting dropped due to TX-queue
> overflow by comparing/correlating counters.

yes, it is just a matter of using "num_frame - drops" as counter in
mvneta_xdp_xmit()

>=20
> This also begs the question: Should we have a counter for TX-queue
> overflows?  That will make it even easier to diagnose problems from a
> sysadm perspective?

not yet. Do you want to add it?

>=20
>=20
> > I will fix in a formal patch
>=20
>=20
> > >  =20
> > > >  	u64_stats_update_end(&stats->syncp);
> > > > =20
> > > >  	mvneta_txq_inc_put(txq);
> > > > @@ -4484,6 +4490,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvnet=
a_port *pp,
> > > >  		u64 xdp_redirect;
> > > >  		u64 xdp_pass;
> > > >  		u64 xdp_drop;
> > > > +		u64 xdp_xmit;
> > > >  		u64 xdp_tx;
> > > > =20
> > > >  		stats =3D per_cpu_ptr(pp->stats, cpu);
> > > > @@ -4494,6 +4501,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvnet=
a_port *pp,
> > > >  			xdp_redirect =3D stats->es.ps.xdp_redirect;
> > > >  			xdp_pass =3D stats->es.ps.xdp_pass;
> > > >  			xdp_drop =3D stats->es.ps.xdp_drop;
> > > > +			xdp_xmit =3D stats->es.ps.xdp_xmit;
> > > >  			xdp_tx =3D stats->es.ps.xdp_tx;
> > > >  		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
> > > > =20
> > > > @@ -4502,6 +4510,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvnet=
a_port *pp,
> > > >  		es->ps.xdp_redirect +=3D xdp_redirect;
> > > >  		es->ps.xdp_pass +=3D xdp_pass;
> > > >  		es->ps.xdp_drop +=3D xdp_drop;
> > > > +		es->ps.xdp_xmit +=3D xdp_xmit;
> > > >  		es->ps.xdp_tx +=3D xdp_tx;
> > > >  	}
> > > >  }
> > > > @@ -4555,6 +4564,9 @@ static void mvneta_ethtool_update_stats(struc=
t mvneta_port *pp)
> > > >  			case ETHTOOL_XDP_TX:
> > > >  				pp->ethtool_stats[i] =3D stats.ps.xdp_tx;
> > > >  				break;
> > > > +			case ETHTOOL_XDP_XMIT:
> > > > +				pp->ethtool_stats[i] =3D stats.ps.xdp_xmit;
> > > > +				break;
> > > >  			}
> > > >  			break;
> > > >  		} =20
> > >=20
> > > It doesn't look like you have an action counter for XDP_TX, but we ha=
ve
> > > one for XDP_REDIRECT? =20
> >=20
> > I did not get you here sorry, I guess they should be accounted in two
> > separated counters.
>=20
> Checking code that got applied, you have xdp "action" counters for:
>  - XDP_PASS     =3D> stats->xdp_pass++;
>  - XDP_REDIRECT =3D> stats->xdp_redirect++ (on xdp_do_redirect =3D=3D 0)
>  - XDP_TX       =3D> no-counter

nope, we have a counter for it...it is "rx_xdp_tx_xmit".
Moreover we have "tx_xdp_xmit" for ndo_xdp_xmit

- XDP_TX -> stats->xdp_tx++
- ndo_xdp_xmit -> stats->xdp_xmit++

Regards,
Lorenzo

>  - XDP_ABORTED  =3D> fall-through (to stats->xdp_drop++);
>  - XDP_DROP     =3D> stats->xdp_drop++
>=20
> Notice the action XDP_TX is not accounted, that was my point.  While
> all other XDP "actions" have a counter.
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXkwm9QAKCRA6cBh0uS2t
rCVKAQDjmjqZuy7cV+zoLEMOD45+RxS9EUjprVydj1pY2h8hgQD/fczWJCA61adi
/xexJcqzh8PxOMo2bOPBR2uYegwk6Qo=
=/AF+
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--

