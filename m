Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7F3274D5
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 23:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhB1W3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 17:29:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231544AbhB1W3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 17:29:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614551256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0wryWcPaAxfw2RWINGUzgAUwuoqjsVNrZUxTgOc7xsM=;
        b=NfCz3fbcekycYOnL9T5JMdUP8q1r2oTG4YecJySzZDqNVXz4TMLimpB/FO7qnJA4I1UwHQ
        OCVGBeYtf7X9BUVNm8oGGL9Dfc+tsg0Q4wzYRzRgxy48c8aECYXjXky3fZm/YWmZEVYcyD
        0rYTJ0WbdEl1lAEepX0cJ0uGGIJ3PwQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-NNCHEMSFOEyU3u26jwKJIA-1; Sun, 28 Feb 2021 17:27:32 -0500
X-MC-Unique: NNCHEMSFOEyU3u26jwKJIA-1
Received: by mail-wr1-f71.google.com with SMTP id p18so8401413wrt.5
        for <netdev@vger.kernel.org>; Sun, 28 Feb 2021 14:27:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0wryWcPaAxfw2RWINGUzgAUwuoqjsVNrZUxTgOc7xsM=;
        b=XCXr+gGO6dJzXVs+DFNFeYdKIVnqMtDwfZnySW4TuqqBww+Jg9ac2WEocKzU++aQxb
         8jE+P8zmcBftz0HFfwc+hPpmP9V1iWi7Kweewemu8bnT+LMHHp9UZSHh8hVqneVrwyKE
         73yqbJOK3HW26y4MDzwqZAey2LSqWsH8nFxm3Wg1JbAKJDptBgADBjsyan7h+YdeKanz
         vWrSX1dnon7l71o9kWHEVkp0g4h+B4HESS1X6mAhKEicQfw8S5C8D1KKwLxOeYuWNQ5S
         3yiWNGKygZ877Yvpgwx63NjWT+E8sg9Uw2PvwxWSvmw6zqCV08YgaP8YlAJkZZmqTQQ5
         /PzQ==
X-Gm-Message-State: AOAM531oR1MlYhIckb/g1b4hgLzCggzzs2XWC9KG2n1c80gTqCTdSgtH
        SpYNJqarCHFv7rDABlaadeAHWu6fabrJAY+Iiu4BWTwvbqG62o4mbJNOCxZ2slFeEzakvJZ3XfC
        vTbyArAzBn7QiPcbC
X-Received: by 2002:a1c:7513:: with SMTP id o19mr12630013wmc.94.1614551251486;
        Sun, 28 Feb 2021 14:27:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYgvNUHTYNny7jun+QZnBKp5YO+4zPn+Ec4LSYVug/oiTEGiLWtPvA8m6114V++R7TnxKKGg==
X-Received: by 2002:a1c:7513:: with SMTP id o19mr12629985wmc.94.1614551251262;
        Sun, 28 Feb 2021 14:27:31 -0800 (PST)
Received: from localhost ([151.66.54.126])
        by smtp.gmail.com with ESMTPSA id f126sm8306606wmf.17.2021.02.28.14.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:27:30 -0800 (PST)
Date:   Sun, 28 Feb 2021 23:27:25 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, freysteinn.alfredsson@kau.se,
        john.fastabend@gmail.com, jasowang@redhat.com, mst@redhat.com,
        thomas.petazzoni@bootlin.com, mw@semihalf.com,
        linux@armlinux.org.uk, ilias.apalodimas@linaro.org,
        netanel@amazon.com, akiyano@amazon.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, ioana.ciornei@nxp.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, grygorii.strashko@ti.com, ecree.xilinx@gmail.com
Subject: Re: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Message-ID: <YDwYzYVIDQABINyy@lore-laptop-rh>
References: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
 <pj41zly2f8wfq6.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KWqXVpklFboKTwdJ"
Content-Disposition: inline
In-Reply-To: <pj41zly2f8wfq6.fsf@u68c7b5b1d2d758.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KWqXVpklFboKTwdJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > ...
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > index 102f2c91fdb8..7ad0557dedbd 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > ...
> >=20
> > @@ -339,8 +337,8 @@ static int ena_xdp_xmit(struct net_device *dev, int
> > n,
> >  			struct xdp_frame **frames, u32 flags)
> >  {
> >  	struct ena_adapter *adapter =3D netdev_priv(dev);
> > -	int qid, i, err, drops =3D 0;
> >  	struct ena_ring *xdp_ring;
> > +	int qid, i, nxmit =3D 0;
> >  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> >  		return -EINVAL;
> > @@ -360,12 +358,12 @@ static int ena_xdp_xmit(struct net_device *dev,
> > int n,
> >  	spin_lock(&xdp_ring->xdp_tx_lock);
> >  	for (i =3D 0; i < n; i++) {
> > -		err =3D ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 0);
> >  		/* The descriptor is freed by ena_xdp_xmit_frame  in case
> >  		 * of an error.
> >  		 */
>=20
> Thanks a lot for the patch. It's a good idea. Do you mind removing the
> comment here as well ? ena_xdp_xmit_frame() no longer frees the frame in
> case of an error after this patch.

ack, will do in v3

>=20
> > -		if (err)
> > -			drops++;
> > +		if (ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 0))
> > +			break;
> > +		nxmit++;
> >  	}
> >  	/* Ring doorbell to make device aware of the packets */
> > @@ -378,7 +376,7 @@ static int ena_xdp_xmit(struct net_device *dev, int
> > n,
> >  	spin_unlock(&xdp_ring->xdp_tx_lock);
> >  	/* Return number of packets sent */
> > -	return n - drops;
> > +	return nxmit;
> >  }
> > ...
> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > index 85d9d1b72a33..9f158b3862df 100644
> > --- a/kernel/bpf/devmap.c
> > +++ b/kernel/bpf/devmap.c
> > @@ -344,29 +344,26 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue
> > *bq, u32 flags)
> >    	sent =3D dev->netdev_ops->ndo_xdp_xmit(dev, bq->count,  bq->q, flag=
s);
> >  	if (sent < 0) {
> > +		/* If ndo_xdp_xmit fails with an errno, no frames have
> > +		 * been xmit'ed.
> > +		 */
> >  		err =3D sent;
> >  		sent =3D 0;
> > -		goto error;
> >  	}
> > +
> >  	drops =3D bq->count - sent;
> > -out:
> > -	bq->count =3D 0;
> > +	if (unlikely(drops > 0)) {
> > +		/* If not all frames have been transmitted, it is our
> > +		 * responsibility to free them
> > +		 */
> > +		for (i =3D sent; i < bq->count; i++)
> > +			xdp_return_frame_rx_napi(bq->q[i]);
> > +	}
>=20
> Wouldn't the logic above be the same even w/o the 'if' condition ?

it is just an optimization to avoid the for loop instruction if sent =3D bq=
->count

Regards,
Lorenzo

>=20
> > +	bq->count =3D 0;
> >  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
> >  	bq->dev_rx =3D NULL;
> >  	__list_del_clearprev(&bq->flush_node);
> > -	return;
> > -error:
> > -	/* If ndo_xdp_xmit fails with an errno, no frames have been
> > -	 * xmit'ed and it's our responsibility to them free all.
> > -	 */
> > -	for (i =3D 0; i < bq->count; i++) {
> > -		struct xdp_frame *xdpf =3D bq->q[i];
> > -
> > -		xdp_return_frame_rx_napi(xdpf);
> > -		drops++;
> > -	}
> > -	goto out;
> >  }
> >    /* __dev_flush is called from xdp_do_flush() which _must_ be
> > signaled
>=20
> Thanks, Shay
>=20

--KWqXVpklFboKTwdJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYDwYygAKCRA6cBh0uS2t
rC7XAQDElqjB70+Zyd/zfSOqd/TH+ol9lqLT2/vEfd89FBRRygEAuHTAFaKkSa6F
NvoBNEPeg0Ouo66iX1+db8owSyBTZQk=
=V7NY
-----END PGP SIGNATURE-----

--KWqXVpklFboKTwdJ--

