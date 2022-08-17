Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFF0596E7B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 14:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiHQMf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 08:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiHQMf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 08:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E95953D1D;
        Wed, 17 Aug 2022 05:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C121560D30;
        Wed, 17 Aug 2022 12:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98430C433D6;
        Wed, 17 Aug 2022 12:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660739757;
        bh=uPBnEcIkcRgRNxL+nKEo5ooLQQVvrZSwQ28Yvg3ToOw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/HSmj70dwKVN7bI+Nq3I1gqd2CFn9nyTO7Nw52yruJQvV0gRhIJkcqIo9cerK5uC
         GMThzhsapOUDvFJutfKgOps6ZHdZrQt8JzW+fXbA8FyjdF5as53w6Gu5PVHAFy1g0L
         Tj6t5o4KTVF7YW+3Y6cFIW1p9m4A6P0GobtC0vBHLjTHWysHpEI1i960zr9R7Bf2qO
         4KXLkmtf4IuBN/aSp6MZ9aONHHJS/m2ojUK5ok2qIqIRAXpuN1FJ4J/y7of3ld2pwK
         2mZ2Cni3g+HloCO0WLoPQ06+A/QgeXdAXkmRvlqJ0ipzXhnGHGUCKy5jpOgXhdKlh9
         4IxqGsHQL8FSg==
Date:   Wed, 17 Aug 2022 14:35:53 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     bpf@vger.kernel.org, brouer@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH bpf-next] xdp: report rx queue index in xdp_frame
Message-ID: <YvzgqWUDWpu9bxNN@lore-desk>
References: <181f994e13c816116fa69a1e92c2f69e6330f749.1658746417.git.lorenzo@kernel.org>
 <ccccfb6b-b72f-382f-48f6-c639b8b0b2cd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1I8mjSPP+taJB0+p"
Content-Disposition: inline
In-Reply-To: <ccccfb6b-b72f-382f-48f6-c639b8b0b2cd@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1I8mjSPP+taJB0+p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> On 25/07/2022 12.56, Lorenzo Bianconi wrote:
> > Report rx queue index in xdp_frame according to the xdp_buff xdp_rxq_in=
fo
> > pointer. xdp_frame queue_index is currently used in cpumap code to cove=
rt
> > the xdp_frame into a xdp_buff.
>=20
> Hmm, I'm unsure about this change, because the XDP-hints will also
> contain the rx_queue number.

ack, but in this way each driver needs to fill this info, right? Maybe we c=
an
keep rx_queue number here and remove it from XDP-hints metadata?

>=20
> I do think it is relevant for the BPF-prog to get access to the rx_queue
> index, because it can be used for scaling the workload.
>=20
> > xdp_frame size is not increased adding queue_index since an alignment p=
adding
> > in the structure is used to insert queue_index field.
>=20
> The rx_queue could be reduced from u32 to u16, but it might be faster to
> keep it u32, and reduce it when others need the space.

ack, agree.

Regards,
Lorenzo

>=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   include/net/xdp.h   | 2 ++
> >   kernel/bpf/cpumap.c | 2 +-
> >   2 files changed, 3 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 04c852c7a77f..3567866b0af5 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -172,6 +172,7 @@ struct xdp_frame {
> >   	struct xdp_mem_info mem;
> >   	struct net_device *dev_rx; /* used by cpumap */
> >   	u32 flags; /* supported values defined in xdp_buff_flags */
> > +	u32 queue_index;
> >   };
> >   static __always_inline bool xdp_frame_has_frags(struct xdp_frame *fra=
me)
> > @@ -301,6 +302,7 @@ struct xdp_frame *xdp_convert_buff_to_frame(struct =
xdp_buff *xdp)
> >   	/* rxq only valid until napi_schedule ends, convert to xdp_mem_info =
*/
> >   	xdp_frame->mem =3D xdp->rxq->mem;
> > +	xdp_frame->queue_index =3D xdp->rxq->queue_index;
> >   	return xdp_frame;
> >   }
> > diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> > index f4860ac756cd..09a792d088b3 100644
> > --- a/kernel/bpf/cpumap.c
> > +++ b/kernel/bpf/cpumap.c
> > @@ -228,7 +228,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_=
map_entry *rcpu,
> >   		rxq.dev =3D xdpf->dev_rx;
> >   		rxq.mem =3D xdpf->mem;
> > -		/* TODO: report queue_index to xdp_rxq_info */
> > +		rxq.queue_index =3D xdpf->queue_index;
> >   		xdp_convert_frame_to_buff(xdpf, &xdp);
>=20

--1I8mjSPP+taJB0+p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYvzgqQAKCRA6cBh0uS2t
rK55AQCUkU5MKyA8yldjd4coU/wugxff4mlmYYORDwn5vARMYAEA2MgWTjQQObQP
PggWkkDXVmc391OHQfvCbyfLNjZeYg0=
=An7V
-----END PGP SIGNATURE-----

--1I8mjSPP+taJB0+p--
