Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EABB18748F
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbgCPVOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:14:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32047 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732608AbgCPVOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:14:09 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 17:14:07 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584393247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q/Na/8w6X02XL1RfzIW809az29ceDHhkkzMSBf0tVfI=;
        b=BnPdgLOAVUCIVJTZ/omMoCVkgdcAOqLFIRaGqVzp3ADzqzlFJiOohfcPIB1RSkJqOrM/GE
        yPOy3tRtE9aKq7i4w42hVsKw64CyhKPswadpYFE5Env7zvKByDuOhRRKznRcF1/zVUF0Ko
        bd7RUInykXR7UJWRpaU+4AJ4tL4u04w=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-Rg_0JViiPbWIPIwkTcsuhQ-1; Mon, 16 Mar 2020 17:07:33 -0400
X-MC-Unique: Rg_0JViiPbWIPIwkTcsuhQ-1
Received: by mail-wm1-f69.google.com with SMTP id a23so6313858wmm.8
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q/Na/8w6X02XL1RfzIW809az29ceDHhkkzMSBf0tVfI=;
        b=AaYDrYS+n8qRmZZ1JFearsJAg8DnmLlzwamTqhMPVCu+BEofXI5Uh3mHTp60ElalB+
         2KB4GoOoABLBPUmaMFOs6QPH69DiC6KLAQtP5MX16PtMntfrWmBzabNyFfEwYhFrasDc
         DOqCIykX3fU2HFJ9UksVqyIL53Da2UVAMF8KGGhqInIr/OiJFTOD8N5d3IzmjCiXgdl6
         1z+dILa/qrjSHWNHMStogmcdpIBKwt0kzueYies3G1JEIh0OfkPF8vBgpmR569h9jcty
         ub5iPxuI2u3hXbTufC0I27poXGTFjaNJDRZFkFh846J5HSm/Aiye0dxj6fSIcWRiJ9ex
         aYiQ==
X-Gm-Message-State: ANhLgQ2JaIBj8B8tcYn/PhSGwCSWFNHvuO7bWBCz6TDFzTdWmat/cILn
        LA3NAdGs7dWGGwoRfFmKOgDZH7onekLiW8jAafi8CDrTIoqWTcAAEo4VK1a+SBnejTChF9z3J4F
        mzFY8WJmTebuDQCE2
X-Received: by 2002:a5d:574e:: with SMTP id q14mr1261279wrw.330.1584392851954;
        Mon, 16 Mar 2020 14:07:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvtq8zWdaq6qlS7PE1oVVIoPaF50e5RWkDpy7c+88dmLOxGcTEuR8pFj1/lMQ32yDb0C8/fyA==
X-Received: by 2002:a5d:574e:: with SMTP id q14mr1261257wrw.330.1584392851622;
        Mon, 16 Mar 2020 14:07:31 -0700 (PDT)
Received: from lore-desk-wlan ([151.48.128.122])
        by smtp.gmail.com with ESMTPSA id c13sm1437511wro.96.2020.03.16.14.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 14:07:30 -0700 (PDT)
Date:   Mon, 16 Mar 2020 22:07:26 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, brouer@redhat.com
Subject: Re: [RFC/RFT net-next] net: ethernet: ti: fix netdevice stats for XDP
Message-ID: <20200316210726.GC3816105@lore-desk-wlan>
References: <82f23afa31395a8ba2a324fcec2e90e45563f9c7.1582304311.git.lorenzo@kernel.org>
 <562239c7-547c-fed6-e3f3-87752f6c7402@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <562239c7-547c-fed6-e3f3-87752f6c7402@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 21/02/2020 19:05, Lorenzo Bianconi wrote:
> > Align netdevice statistics when the device is running in XDP mode
> > to other upstream drivers. In particular reports to user-space rx
> > packets even if they are not forwarded to the networking stack
> > (XDP_PASS) but they are redirected (XDP_REDIRECT), dropped (XDP_DROP)
> > or sent back using the same interface (XDP_TX). This patch allows the
> > system administrator to very the device is receiving data correctly.
>=20
> I've tested it with xdp-tutorial:
>  drop: ip link set dev eth0 xdp obj ./packet01-parsing/xdp_prog_kern.o se=
c xdp_packet_parser
>  tx: ip link set dev eth0 xdp obj ./packet-solutions/xdp_prog_kern_03.o s=
ec xdp_icmp_echo
>=20
> And see statistic incremented.
>=20
> In my opinion, it looks a little bit inconsistent if RX/TX packet/bytes i=
s updated,
> but ndev->stats.rx_dropped is not.

Hi Grygorii,

thanks a lot for testing this patch.
The main idea here is to allow the sysadmin to undertand the device is
receiving frames. We will need to add xdp stats to ethtool to give more det=
ails
about why we are dropping packets

>=20
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > - this patch is compile-only tested
> > ---
> >   drivers/net/ethernet/ti/cpsw.c      |  4 +---
> >   drivers/net/ethernet/ti/cpsw_new.c  |  5 ++---
> >   drivers/net/ethernet/ti/cpsw_priv.c | 13 +++++++++++--
> >   drivers/net/ethernet/ti/cpsw_priv.h |  2 +-
> >   4 files changed, 15 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/c=
psw.c
> > index 6ae4a72e6f43..fe3fd33f56f7 100644
> > --- a/drivers/net/ethernet/ti/cpsw.c
> > +++ b/drivers/net/ethernet/ti/cpsw.c
> > @@ -408,12 +408,10 @@ static void cpsw_rx_handler(void *token, int len,=
 int status)
> >   		xdp.rxq =3D &priv->xdp_rxq[ch];
> >   		port =3D priv->emac_port + cpsw->data.dual_emac;
> > -		ret =3D cpsw_run_xdp(priv, ch, &xdp, page, port);
> > +		ret =3D cpsw_run_xdp(priv, ch, &xdp, page, port, &len);
> >   		if (ret !=3D CPSW_XDP_PASS)
> >   			goto requeue;
> > -		/* XDP prog might have changed packet data and boundaries */
> > -		len =3D xdp.data_end - xdp.data;
> >   		headroom =3D xdp.data - xdp.data_hard_start;
> >   		/* XDP prog can modify vlan tag, so can't use encap header */
> > diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/=
ti/cpsw_new.c
> > index 71215db7934b..050496e814c3 100644
> > --- a/drivers/net/ethernet/ti/cpsw_new.c
> > +++ b/drivers/net/ethernet/ti/cpsw_new.c
> > @@ -349,12 +349,11 @@ static void cpsw_rx_handler(void *token, int len,=
 int status)
> >   		xdp.data_hard_start =3D pa;
> >   		xdp.rxq =3D &priv->xdp_rxq[ch];
> > -		ret =3D cpsw_run_xdp(priv, ch, &xdp, page, priv->emac_port);
> > +		ret =3D cpsw_run_xdp(priv, ch, &xdp, page,
> > +				   priv->emac_port, &len);
> >   		if (ret !=3D CPSW_XDP_PASS)
> >   			goto requeue;
> > -		/* XDP prog might have changed packet data and boundaries */
> > -		len =3D xdp.data_end - xdp.data;
> >   		headroom =3D xdp.data - xdp.data_hard_start;
> >   		/* XDP prog can modify vlan tag, so can't use encap header */
> > diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet=
/ti/cpsw_priv.c
> > index 97a058ca60ac..a41da48db40b 100644
> > --- a/drivers/net/ethernet/ti/cpsw_priv.c
> > +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> > @@ -1317,7 +1317,7 @@ int cpsw_xdp_tx_frame(struct cpsw_priv *priv, str=
uct xdp_frame *xdpf,
> >   }
> >   int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
> > -		 struct page *page, int port)
> > +		 struct page *page, int port, int *len)
> >   {
> >   	struct cpsw_common *cpsw =3D priv->cpsw;
> >   	struct net_device *ndev =3D priv->ndev;
> > @@ -1335,10 +1335,13 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch=
, struct xdp_buff *xdp,
> >   	}
> >   	act =3D bpf_prog_run_xdp(prog, xdp);
> > +	/* XDP prog might have changed packet data and boundaries */
> > +	*len =3D xdp.data_end - xdp.data;
>=20
> it should be
>=20
> +       *len =3D xdp->data_end - xdp->data;

ops, right sorry

Regards,
Lorenzo

>=20
>=20
> > +
> >   	switch (act) {
> >   	case XDP_PASS:
> >   		ret =3D CPSW_XDP_PASS;
> > -		break;
> > +		goto out;
> >   	case XDP_TX:
> >   		xdpf =3D convert_to_xdp_frame(xdp);
> >   		if (unlikely(!xdpf))
> > @@ -1364,8 +1367,14 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch,=
 struct xdp_buff *xdp,
> >   		trace_xdp_exception(ndev, prog, act);
> >   		/* fall through -- handle aborts by dropping packet */
> >   	case XDP_DROP:
> > +		ndev->stats.rx_bytes +=3D *len;
> > +		ndev->stats.rx_packets++;
> >   		goto drop;
> >   	}
> > +
> > +	ndev->stats.rx_bytes +=3D *len;
> > +	ndev->stats.rx_packets++;
> > +
> >   out:
> >   	rcu_read_unlock();
> >   	return ret;
> > diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet=
/ti/cpsw_priv.h
> > index b8d7b924ee3d..54efd773e033 100644
> > --- a/drivers/net/ethernet/ti/cpsw_priv.h
> > +++ b/drivers/net/ethernet/ti/cpsw_priv.h
> > @@ -439,7 +439,7 @@ int cpsw_ndo_bpf(struct net_device *ndev, struct ne=
tdev_bpf *bpf);
> >   int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
> >   		      struct page *page, int port);
> >   int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
> > -		 struct page *page, int port);
> > +		 struct page *page, int port, int *len);
> >   irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id);
> >   irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id);
> >   int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget);
> >=20
>=20
> --=20
> Best regards,
> grygorii
>=20

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXm/qiwAKCRA6cBh0uS2t
rPNqAQDceB/R4dSaJExxdCpujLrXlJlw2xGF26Y5jp9bVd/5fwEAl+uzMfQv9n+R
y3PR+zJNg8ri5xYFX/tr9x/X1/UhWQs=
=2Uge
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--

