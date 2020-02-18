Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47024162C68
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBRRRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgBRRRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 12:17:24 -0500
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 800F920801;
        Tue, 18 Feb 2020 17:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582046243;
        bh=DC3QOtStPYmy8FjeUcg3gf5NTM6iB9ATdmpBeqbkG3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0RN1kAUWFsr22PLXDqPewV/aqKHXaCseg820hjnFmFGNtBARrLXaRKbhqM3FyXP4Y
         LRHbLIGKyCP9vj7ZHSJiWwjdLElq4NtKwkOEx7rB6zUub3CD2xLeTHDBbdypndv5b/
         9uuWjzm/Pe2lrXPY4NddM7AypcGYLw50RC8gkJMY=
Date:   Tue, 18 Feb 2020 18:17:16 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, andrew@lunn.ch,
        dsahern@kernel.org, bpf@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200218171716.GA13376@localhost.localdomain>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
 <20200218180210.130f0e6d@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20200218180210.130f0e6d@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 18 Feb 2020 01:14:29 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > Introduce "rx" prefix in the name scheme for xdp counters
> > on rx path.
> > Differentiate between XDP_TX and ndo_xdp_xmit counters
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++-----
> >  1 file changed, 17 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index b7045b6a15c2..6223700dc3df 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -344,6 +344,7 @@ enum {
> >  	ETHTOOL_XDP_REDIRECT,
> >  	ETHTOOL_XDP_PASS,
> >  	ETHTOOL_XDP_DROP,
> > +	ETHTOOL_XDP_XMIT,
> >  	ETHTOOL_XDP_TX,
> >  	ETHTOOL_MAX_STATS,
> >  };
> > @@ -399,10 +400,11 @@ static const struct mvneta_statistic mvneta_stati=
stics[] =3D {
> >  	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
> >  	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
> >  	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
> > -	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
> > -	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
> > -	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
> > -	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
> > +	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
> > +	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
> > +	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
> > +	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx_xmit", },
>=20
> Hmmm... "rx_xdp_tx_xmit", I expected this to be named "rx_xdp_tx" to
> count the XDP_TX actions, but I guess this means something else.

just reused mlx5 naming scheme here :)

>=20
> > +	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },
>=20
> Okay, maybe.  I guess, this will still be valid for when we add an XDP
> egress/TX-hook point.

same here

>=20
> >  };
> > =20
> >  struct mvneta_stats {
> > @@ -414,6 +416,7 @@ struct mvneta_stats {
> >  	u64	xdp_redirect;
> >  	u64	xdp_pass;
> >  	u64	xdp_drop;
> > +	u64	xdp_xmit;
> >  	u64	xdp_tx;
> >  };
> > =20
> > @@ -2050,7 +2053,10 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, =
struct mvneta_tx_queue *txq,
> >  	u64_stats_update_begin(&stats->syncp);
> >  	stats->es.ps.tx_bytes +=3D xdpf->len;
> >  	stats->es.ps.tx_packets++;
> > -	stats->es.ps.xdp_tx++;
> > +	if (buf->type =3D=3D MVNETA_TYPE_XDP_NDO)
> > +		stats->es.ps.xdp_xmit++;
> > +	else
> > +		stats->es.ps.xdp_tx++;
>=20
> I don't like that you add a branch (if-statement) in this fast-path code.
>=20
> Do we really need to account in the xmit frame function, if this was a
> XDP_REDIRECT or XDP_TX that started the xmit?  I mean we already have
> action counters for XDP_REDIRECT and XDP_TX (but I guess you skipped
> the XDP_TX action counter).=20

ack, good point..I think we can move the code in
mvneta_xdp_xmit_back/mvneta_xdp_xmit in order to avoid the if() condition.
Moreover we can move it out the for loop in mvneta_xdp_xmit().
I will fix in a formal patch

>=20
>=20
> >  	u64_stats_update_end(&stats->syncp);
> > =20
> >  	mvneta_txq_inc_put(txq);
> > @@ -4484,6 +4490,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_po=
rt *pp,
> >  		u64 xdp_redirect;
> >  		u64 xdp_pass;
> >  		u64 xdp_drop;
> > +		u64 xdp_xmit;
> >  		u64 xdp_tx;
> > =20
> >  		stats =3D per_cpu_ptr(pp->stats, cpu);
> > @@ -4494,6 +4501,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_po=
rt *pp,
> >  			xdp_redirect =3D stats->es.ps.xdp_redirect;
> >  			xdp_pass =3D stats->es.ps.xdp_pass;
> >  			xdp_drop =3D stats->es.ps.xdp_drop;
> > +			xdp_xmit =3D stats->es.ps.xdp_xmit;
> >  			xdp_tx =3D stats->es.ps.xdp_tx;
> >  		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
> > =20
> > @@ -4502,6 +4510,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_po=
rt *pp,
> >  		es->ps.xdp_redirect +=3D xdp_redirect;
> >  		es->ps.xdp_pass +=3D xdp_pass;
> >  		es->ps.xdp_drop +=3D xdp_drop;
> > +		es->ps.xdp_xmit +=3D xdp_xmit;
> >  		es->ps.xdp_tx +=3D xdp_tx;
> >  	}
> >  }
> > @@ -4555,6 +4564,9 @@ static void mvneta_ethtool_update_stats(struct mv=
neta_port *pp)
> >  			case ETHTOOL_XDP_TX:
> >  				pp->ethtool_stats[i] =3D stats.ps.xdp_tx;
> >  				break;
> > +			case ETHTOOL_XDP_XMIT:
> > +				pp->ethtool_stats[i] =3D stats.ps.xdp_xmit;
> > +				break;
> >  			}
> >  			break;
> >  		}
>=20
> It doesn't look like you have an action counter for XDP_TX, but we have
> one for XDP_REDIRECT?

I did not get you here sorry, I guess they should be accounted in two separ=
ated
counters.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXkwcGgAKCRA6cBh0uS2t
rLgZAQCtbifJsoKgfCA98o+Y+EOZ0Zj9ZAycb4WL9KBN/QzZuwEAjnTwEZ2Gtma+
VHxRgrDObJ3s4xXZvbqMzXtTQTNNEAQ=
=dJC+
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
