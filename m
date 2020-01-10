Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 446421375F5
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgAJSTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:19:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57292 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726346AbgAJSTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 13:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578680388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jzram1FRym4assHuYKz5RLnVkuAZq6KU9/jOfjkk4No=;
        b=IYpMFtnj11RV5IvQFT8cPEZhEDEcUHHG2xQ2ILT1mmnO/Jm7g9Kqe/j3pOz5Pgj8Y+QTPz
        XAfSqo+4CByMOM9sZf3NizkPg9kynFtC7T+F7Cq/DmcpMuiY1kZh8nzu5ebqEwpaYK3nlr
        w+ILLG3xIrhVqtqXS8NLZy0XGratx0Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-CDIJ1iHJOj6DFCicnagzwA-1; Fri, 10 Jan 2020 13:19:45 -0500
X-MC-Unique: CDIJ1iHJOj6DFCicnagzwA-1
Received: by mail-wr1-f69.google.com with SMTP id r2so1288184wrp.7
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 10:19:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jzram1FRym4assHuYKz5RLnVkuAZq6KU9/jOfjkk4No=;
        b=Kv6ALzPYPgucUmjYJA5RIUgwIrrGtknZPJYUWrin4J2CbEHRJZ8+D7Gq2TWivTK8rB
         OMR+2hhEpJIqPp1e+S3Aq8h6XViRJQ3Jtqcf4EcONaasRyIQrhy3zxnawqfWQCA15GGN
         Vql3S8UyPZbYkv01FW2pOrjOzWrUSXd0kTQ6QNlGaFRKl2hCio78phvwSkP4jN58ECBQ
         W0aE8cBO+Id8yOXMwDB5z/xev5ghdn0RsJEkoTBlJA6420mKCmznjIIMtJw8ZAc9W18X
         ULxrJlQPF0RqYLwkjXhnbY+RiUKRU4Bqc3Jt/wiJS8JtxhGSTNqTvtdZZmdXsIRp8Tk4
         U55g==
X-Gm-Message-State: APjAAAWz3AXk8qZkPp8zsRU/IxuNdTWKmA3scQOKYEMK03mmgbpmn4CP
        fdoAuYr6954WRYQ2VGCZMmbgISpeVw9BNaz5p3ZzqOyJcmNAExrSZGLjFz5IH5Wx/BfLsEs8ow8
        R/ShMUDJa65JfO8Wv
X-Received: by 2002:a1c:7203:: with SMTP id n3mr5470384wmc.119.1578680384322;
        Fri, 10 Jan 2020 10:19:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqxr35Wh7fKGBdqaC7TlXBbg47dFEO3bfLZmzwRrtD5NphdBGrTbnw1NT4T2jEMxYqxmdbBKhQ==
X-Received: by 2002:a1c:7203:: with SMTP id n3mr5470370wmc.119.1578680384093;
        Fri, 10 Jan 2020 10:19:44 -0800 (PST)
Received: from localhost.localdomain (mob-176-246-50-46.net.vodafone.it. [176.246.50.46])
        by smtp.gmail.com with ESMTPSA id v22sm3087405wml.11.2020.01.10.10.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 10:19:43 -0800 (PST)
Date:   Fri, 10 Jan 2020 19:19:40 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next] net: socionext: get rid of huge dma sync in
 netsec_alloc_rx_data
Message-ID: <20200110181940.GB31419@localhost.localdomain>
References: <81eeb4aaf1cbbbdcd4f58c5a7f06bdab67f20633.1578664483.git.lorenzo@kernel.org>
 <20200110145631.GA69461@apalos.home>
 <20200110153413.GA31419@localhost.localdomain>
 <20200110183328.219ed2bd@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <20200110183328.219ed2bd@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, 10 Jan 2020 16:34:13 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > > On Fri, Jan 10, 2020 at 02:57:44PM +0100, Lorenzo Bianconi wrote: =20
> > > > Socionext driver can run on dma coherent and non-coherent devices.
> > > > Get rid of huge dma_sync_single_for_device in netsec_alloc_rx_data =
since
> > > > now the driver can let page_pool API to managed needed DMA sync
> > > >=20
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > > Changes since v1:
> > > > - rely on original frame size for dma sync
> > > > ---
> > > >  drivers/net/ethernet/socionext/netsec.c | 43 +++++++++++++++------=
----
> > > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > > >  =20
> >=20
> > [...]
> >=20
> > > > @@ -883,6 +881,8 @@ static u32 netsec_xdp_xmit_back(struct netsec_p=
riv *priv, struct xdp_buff *xdp)
> > > >  static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_pro=
g *prog,
> > > >  			  struct xdp_buff *xdp)
> > > >  {
> > > > +	struct netsec_desc_ring *dring =3D &priv->desc_ring[NETSEC_RING_R=
X];
> > > > +	unsigned int len =3D xdp->data_end - xdp->data; =20
> > >=20
> > > We need to account for XDP expanding the headers as well here.=20
> > > So something like max(xdp->data_end(before bpf), xdp->data_end(after =
bpf)) -
> > > xdp->data (original) =20
> >=20
> > correct, the corner case that is not covered at the moment is when data=
_end is
> > moved forward by the bpf program. I will fix it in v3. Thx
>=20
> Maybe we can simplify do:
>=20
>  void *data_start =3D NETSEC_RXBUF_HEADROOM + xdp->data_hard_start;
>  unsigned int len =3D xdp->data_end - data_start;
>=20

Hi Jesper,

please correct me if I am wrong but this seems to me the same as v2. The le=
ftover
corner case is if xdp->data_end is moved 'forward' by the bpf program (I gu=
ess
it is possible, right?). In this case we will not sync xdp->data_end(new) -=
 xdp->data_end(old)

Regards,
Lorenzo

> The cache-lines that need to be flushed/synced for_device is the area
> used by NIC DMA engine.  We know it will always start at a certain
> point (given driver configured hardware to this).
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXhjAOQAKCRA6cBh0uS2t
rOm+AP4kHwhWoy/Pe40tWRZl5ATMNejzdZksoTiGWme6Lrm33QEAr9CG+LyOGMoI
4i8bH7soCRTYodduTm5jEzh7fgZLwwg=
=O51v
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--

