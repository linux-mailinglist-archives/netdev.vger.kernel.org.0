Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED9A160FDF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 11:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgBQK0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 05:26:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41108 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729100AbgBQK0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 05:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581935161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6epTaHjRmLWv9XYoFLjbZ/bw1j+jKl1wWI0BYO6CRzc=;
        b=a1woZLl75FH/yGy5LZducVvoN02PNESSC0e9QV/feauxXuyVRSOQHgHFD6DTmSddHpJjIJ
        ir7GNHNaqfYwcl6qdzIOqISqMOzhGaqt2k81izmHR5BU4pVYBT0qhevfLio6RvgykuzCjG
        3FYCQuoaex9g8nGEPgbdkc8zWLhjZMA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-oWI1TyjhPre5XXGxt9AcNg-1; Mon, 17 Feb 2020 05:25:56 -0500
X-MC-Unique: oWI1TyjhPre5XXGxt9AcNg-1
Received: by mail-wr1-f72.google.com with SMTP id l1so8763712wrt.4
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 02:25:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6epTaHjRmLWv9XYoFLjbZ/bw1j+jKl1wWI0BYO6CRzc=;
        b=qg5clSyRyj7mKC/ZjfCh78iG6QOogim95cVT0S+0Ggv5WqT0sgVN29erucU5STl127
         8DoxGNFjcuuTxKUc47OoEFECbNr3xJn75a1lXmMq4adr+dBIfUaAVgRL+an8TCIKKutt
         8Ry1bdUl8RhJToC7T4EJSpOan4mwDz7IXbVolyhwnCY5XoDx0cOvdkoJETm8U7d81eOs
         n99mVbwpbSISN7GjSaYEPO0ylzrKmMxEHLyBrXgNk6MjI0im5yazMk4wtL7xjzxr8eg0
         MGDw8WeFnfh0uVTbMGxJ432AHDOPsmKn5z29ms48L+ua0Vu4zIhMeioTOdhL4aZlYox8
         klYg==
X-Gm-Message-State: APjAAAUxLKvKJQL/Luf9UFrevhRkaiBUiZkMSHXGIn90mFshE9UNQBYN
        um/ZQCmJDykpwlhNH8ns/Io0kK8QOcZnJDwjTldr0ndEUNjmY8fyAYjV4ZG+7XUNPj49dLrx+9/
        tUTFxnEKf1z5GBlzX
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr21178392wml.186.1581935155402;
        Mon, 17 Feb 2020 02:25:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCYPBAF1g4WsZRJGvZza5x+Y0tUMSEUKPx9O2i+pTrtH/WoxvArQ5Zggr8eqSx7An2D6AMOQ==
X-Received: by 2002:a7b:cae9:: with SMTP id t9mr21178372wml.186.1581935155149;
        Mon, 17 Feb 2020 02:25:55 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id f127sm51473wma.4.2020.02.17.02.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 02:25:53 -0800 (PST)
Date:   Mon, 17 Feb 2020 11:25:50 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next 4/5] net: mvneta: introduce xdp counters to
 ethtool
Message-ID: <20200217102550.GB3080@localhost.localdomain>
References: <cover.1581886691.git.lorenzo@kernel.org>
 <882d9f03a8542cceec7c7b8e6d083419d84eaf7a.1581886691.git.lorenzo@kernel.org>
 <20200217111718.2c9ab08a@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20200217111718.2c9ab08a@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, 16 Feb 2020 22:07:32 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > @@ -2033,6 +2050,7 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, s=
truct mvneta_tx_queue *txq,
> >  	u64_stats_update_begin(&stats->syncp);
> >  	stats->es.ps.tx_bytes +=3D xdpf->len;
> >  	stats->es.ps.tx_packets++;
> > +	stats->es.ps.xdp_tx++;
> >  	u64_stats_update_end(&stats->syncp);
>=20
> I find it confusing that this ethtool stats is named "xdp_tx".
> Because you use it as an "xmit" counter and not for the action XDP_TX.
>=20
> Both XDP_TX and XDP_REDIRECT out this device will increment this
> "xdp_tx" counter.  I don't think end-users will comprehend this...
>=20
> What about naming it "xdp_xmit" ?

Hi Jesper,

yes, I think it is definitely better. So to follow up:
- rename current "xdp_tx" counter in "xdp_xmit" and increment it for
  XDP_TX verdict and for ndo_xdp_xmit
- introduce a new "xdp_tx" counter only for XDP_TX verdict.

If we agree I can post a follow-up patch.

Regards,
Lorenzo

>=20
>=20
> >  	mvneta_txq_inc_put(txq);
> > @@ -2114,6 +2132,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvn=
eta_rx_queue *rxq,
> > =20
> >  	switch (act) {
> >  	case XDP_PASS:
> > +		stats->xdp_pass++;
> >  		return MVNETA_XDP_PASS;
> >  	case XDP_REDIRECT: {
> >  		int err;
> > @@ -2126,6 +2145,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvn=
eta_rx_queue *rxq,
> >  					     len, true);
> >  		} else {
> >  			ret =3D MVNETA_XDP_REDIR;
> > +			stats->xdp_redirect++;
> >  		}
> >  		break;
> >  	}
> > @@ -2147,6 +2167,7 @@ mvneta_run_xdp(struct mvneta_port *pp, struct mvn=
eta_rx_queue *rxq,
> >  				     virt_to_head_page(xdp->data),
> >  				     len, true);
> >  		ret =3D MVNETA_XDP_DROPPED;
> > +		stats->xdp_drop++;
> >  		break;
> >  	}
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXkpqKwAKCRA6cBh0uS2t
rPJOAQCsUD5KceDQcPI6VgvAeg8OuEyhI6OTjLlLxAgankyQkAD/QNkAyTfPEFFX
KNY6jevHKUqaOKz4B9eC82D+6KCXQAQ=
=OKl2
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--

