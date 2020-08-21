Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E471B24CFCB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgHUHny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:43:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgHUHnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597995831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vzVEe5ldU0YK9FvJc2MYX/lHhroDBWwW0KlWM9zR6uw=;
        b=jRtqs55tyuUqacjC3jb6O1KAIDamVOPryEJG7SAJsElPNXo2v93/6L7bvIvEwCTnIsCxQe
        mEF55gNXwB8cf9Dt62few8Xr1IfyzyD4PeR4wqbdHoUC2zPRex0j/yRTVEsqVFWfrqrV2Y
        O3YHLzkI6NBEjHWYONWDSca0M+p9Ahs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-qQ_9s-u9MhmtHd40wbb-eA-1; Fri, 21 Aug 2020 03:43:48 -0400
X-MC-Unique: qQ_9s-u9MhmtHd40wbb-eA-1
Received: by mail-wm1-f69.google.com with SMTP id q15so496590wmj.6
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vzVEe5ldU0YK9FvJc2MYX/lHhroDBWwW0KlWM9zR6uw=;
        b=Etq+noK/LTTnr7Kw14MlztDv71oQOizE1zGwz3BeBnIo7pjaGb3OFLGBwtDR1ZHRPA
         Lr3S+Ovx1dystYm74BtKpwSJxTAA/X7kpq7PpPmCoz+p3jVDboBQrPo3L87dKej1LUGT
         IUXggRqPtG/HMBKBXj+JVgGJEKebqmJ/RS4mCxoS9gznxNk8/mJdqqF5bz9/IO3waif1
         hjuWWbaxEv6RDnvkssWqhMoX1PWhGE7uWOwMahqyugICuDbnQDtU3G+WzqozlsFJdeDc
         qbijb7iStN7TktvaxCHZ5XMtjkvNwIKUFu8ZyMTKlktbV0i5DY1H4fBc0SbqmrGKmbnu
         pvDg==
X-Gm-Message-State: AOAM532N/BUy2ooMsB9TSZnNGhTcC9pPiWb/bi3fKyoQfGj0qR0e3RKi
        SvMMOljPi5XlSX0y9Ih3ohc55+7b4fiDMhq5TtQlyuhhs27tYaMb3QLunhJBWW4pgxoziOAqkID
        PoiUwLJ6+WxiRAoJX
X-Received: by 2002:adf:e504:: with SMTP id j4mr1528967wrm.205.1597995827680;
        Fri, 21 Aug 2020 00:43:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwunzmAUDJwMgZhZpYwZLsaG5YOILWmOHjbKJRu2NYgPBBI8+mNpK0Hed10CgM/inUDGeeJXQ==
X-Received: by 2002:adf:e504:: with SMTP id j4mr1528945wrm.205.1597995827399;
        Fri, 21 Aug 2020 00:43:47 -0700 (PDT)
Received: from localhost ([151.48.139.80])
        by smtp.gmail.com with ESMTPSA id l21sm2911950wmj.25.2020.08.21.00.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:43:46 -0700 (PDT)
Date:   Fri, 21 Aug 2020 09:43:43 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org
Subject: Re: [PATCH net-next 3/6] net: mvneta: update mb bit before passing
 the xdp buffer to eBPF layer
Message-ID: <20200821074343.GF2282@lore-desk>
References: <cover.1597842004.git.lorenzo@kernel.org>
 <08f8656e906ff69bd30915a6a37a01d5f0422194.1597842004.git.lorenzo@kernel.org>
 <20200820193814.GB12291@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NGIwU0kFl1Z1A3An"
Content-Disposition: inline
In-Reply-To: <20200820193814.GB12291@ranger.igk.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--NGIwU0kFl1Z1A3An
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Aug 20, Maciej Fijalkowski wrote:
> On Wed, Aug 19, 2020 at 03:13:48PM +0200, Lorenzo Bianconi wrote:
> > Update multi-buffer bit (mb) in xdp_buff to notify XDP/eBPF layer and
> > XDP remote drivers if this is a "non-linear" XDP buffer
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethern=
et/marvell/mvneta.c
> > index 832bbb8b05c8..36a3defa63fa 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -2170,11 +2170,14 @@ mvneta_run_xdp(struct mvneta_port *pp, struct m=
vneta_rx_queue *rxq,
> >  	       struct bpf_prog *prog, struct xdp_buff *xdp,
> >  	       u32 frame_sz, struct mvneta_stats *stats)
> >  {
> > +	struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(xdp);
> >  	unsigned int len, data_len, sync;
> >  	u32 ret, act;
> > =20
> >  	len =3D xdp->data_end - xdp->data_hard_start - pp->rx_offset_correcti=
on;
> >  	data_len =3D xdp->data_end - xdp->data;
> > +
> > +	xdp->mb =3D !!sinfo->nr_frags;
>=20
> But this set is not utilizing it from BPF side in any way. Personally I
> would like to see this as a part of work where BPF program would actually
> be taught how to rely on xdp->mb. Especially after John's comment in other
> patch.
>=20

Sameeh is working on them. I did not include the patches since IMO they are
not strictly related to this series. I will include Sameeh's patches in v2.

Regards,
Lorenzo

> >  	act =3D bpf_prog_run_xdp(prog, xdp);
> > =20
> >  	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> > --=20
> > 2.26.2
> >=20
>=20

--NGIwU0kFl1Z1A3An
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXz97LAAKCRA6cBh0uS2t
rCTbAQDi2djNpXhdIka4+dZjOelVRVncRay1DIsriUeeJKpLtAD/dIvBVSbompr6
7TVr9YrA2Hb1ReT9AtP35I8P8N6fxQ4=
=7Blx
-----END PGP SIGNATURE-----

--NGIwU0kFl1Z1A3An--

