Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D04402AFF
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 16:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343535AbhIGOrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 10:47:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245477AbhIGOrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 10:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631025989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OsgjKO/xkIXXMqmMySBL4a/OoZlEznCfkycSG4LTdTc=;
        b=c8XGBeivnSSN6xp4AutPsuzgJ8pG0aAekUzz0x5ureKzWzKYfyIBa/Bxd1anwmkCIli5+T
        9YU2bRHj/PC3yOr5Y3OK4b4INSdtF92xkL3Iff90NGPn4WC1tD9W0j+nxTpBp31vZ3bubf
        Y0rsFDIJRpMADpEGNvz/C2LuYD+23mw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-gIpUi3hbMXqvPaohBkgF_Q-1; Tue, 07 Sep 2021 10:46:27 -0400
X-MC-Unique: gIpUi3hbMXqvPaohBkgF_Q-1
Received: by mail-ed1-f70.google.com with SMTP id u2-20020aa7d982000000b003cda80fa659so4166628eds.14
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 07:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OsgjKO/xkIXXMqmMySBL4a/OoZlEznCfkycSG4LTdTc=;
        b=FoppfWOXxX00I9EuC+S2f5fVq7ONFrxPCCwUxby4mDTZ0b5m+IMpuS2pS8pdU9CSP2
         MPnhhUagUpcL9oTSf3wKu7pdIMuKLnyKSCiipzl4QU9MzLiBSkzSyKim7yzkx9svX2iL
         3biksajUt7spUiNVCwHgDJw+MymxvmTy1VF3haZlEw98I1f91nMSbV5mxm1b8aSljd7V
         5F0XocY4TV/uBmNbLUeDNmDHjyqEB07b7RbCySObu3haQl9WpxEkCG98oDtW1l//krho
         C2TYUxNViyz+VQ7vVCUv3pGF4PWyiwCNFMbJNVxIDAaFnqMnoelNGEbESrigRcjGLou7
         Yv0w==
X-Gm-Message-State: AOAM531kDJ+vPVTMUhoiEOiVOvACh7q2HpZNJrCagfy29PcH+XWvO49I
        ra05OcnsrSUbG9XDWFWg6FTvuvMmkKlia1a8ctvvSiBGmd2izDB+S9NFEFJuIq0uiL0RsX6EUXz
        jyi0iimvxL2a9WH3K
X-Received: by 2002:aa7:ca14:: with SMTP id y20mr18902356eds.2.1631025986666;
        Tue, 07 Sep 2021 07:46:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2JEn+iCBdhPVcPYk7lSbYQYXbz3pwdYtBF3M1ixJ5DRzHYg27uLurVhJSzC9j8sS1Znqd/w==
X-Received: by 2002:aa7:ca14:: with SMTP id y20mr18902339eds.2.1631025986444;
        Tue, 07 Sep 2021 07:46:26 -0700 (PDT)
Received: from localhost (net-37-116-49-210.cust.vodafonedsl.it. [37.116.49.210])
        by smtp.gmail.com with ESMTPSA id q12sm6698885edw.81.2021.09.07.07.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 07:46:26 -0700 (PDT)
Date:   Tue, 7 Sep 2021 16:46:23 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v13 bpf-next 02/18] xdp: introduce flags field in
 xdp_buff/xdp_frame
Message-ID: <YTd7P/XG/2U8w8/J@lore-desk>
References: <cover.1631007211.git.lorenzo@kernel.org>
 <980ad3161b9a312510c9fff76fa74e675b8f9bf3.1631007211.git.lorenzo@kernel.org>
 <52c78ca8-a053-2128-05a0-3aff6f84abd1@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Sdy9MTaWNHDmP6Ag"
Content-Disposition: inline
In-Reply-To: <52c78ca8-a053-2128-05a0-3aff6f84abd1@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Sdy9MTaWNHDmP6Ag
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> (Minor changes requested below)
>=20
> On 07/09/2021 14.35, Lorenzo Bianconi wrote:
> > Introduce flags field in xdp_frame and xdp_buffer data structures
> > to define additional buffer features. At the moment the only
> > supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
> > is used to specify if this is a linear buffer (mb =3D 0) or a multi-buf=
fer
> > frame (mb =3D 1). In the latter case the driver is expected to initiali=
ze
> > the skb_shared_info structure at the end of the first buffer to link
> > together subsequent buffers belonging to the same frame.
> >=20
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   include/net/xdp.h | 29 +++++++++++++++++++++++++++++
> >   1 file changed, 29 insertions(+)
> >=20
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index ad5b02dcb6f4..ed5ea784fd45 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -66,6 +66,10 @@ struct xdp_txq_info {
> >   	struct net_device *dev;
> >   };
> > +enum xdp_buff_flags {
> > +	XDP_FLAGS_MULTI_BUFF	=3D BIT(0), /* non-linear xdp buff */
> > +};
> > +
> >   struct xdp_buff {
> >   	void *data;
> >   	void *data_end;
> > @@ -74,13 +78,30 @@ struct xdp_buff {
> >   	struct xdp_rxq_info *rxq;
> >   	struct xdp_txq_info *txq;
> >   	u32 frame_sz; /* frame size to deduce data_hard_end/reserved tailroo=
m*/
> > +	u16 flags; /* supported values defined in xdp_flags */
>                                                   ^^^^^^^^^
> Variable/enum is named "xdp_buff_flags", but comment says "xdp_flags".

ack, I will fix it in v14

>=20
> I think we should change flags to use u32, because xdp_buff already conta=
in
> 4 byte padding. (pahole output provided as help below)

ack, I will fix it in v14
>=20
> >   };
> > +static __always_inline bool xdp_buff_is_mb(struct xdp_buff *xdp)
> > +{
> > +	return !!(xdp->flags & XDP_FLAGS_MULTI_BUFF);
> > +}
> > +
> > +static __always_inline void xdp_buff_set_mb(struct xdp_buff *xdp)
> > +{
> > +	xdp->flags |=3D XDP_FLAGS_MULTI_BUFF;
> > +}
> > +
> > +static __always_inline void xdp_buff_clear_mb(struct xdp_buff *xdp)
> > +{
> > +	xdp->flags &=3D ~XDP_FLAGS_MULTI_BUFF;
> > +}
> > +
> >   static __always_inline void
> >   xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info=
 *rxq)
> >   {
> >   	xdp->frame_sz =3D frame_sz;
> >   	xdp->rxq =3D rxq;
> > +	xdp->flags =3D 0;
> >   }
> >   static __always_inline void
> > @@ -122,8 +143,14 @@ struct xdp_frame {
> >   	 */
> >   	struct xdp_mem_info mem;
> >   	struct net_device *dev_rx; /* used by cpumap */
> > +	u16 flags; /* supported values defined in xdp_flags */
>                                                   ^^^^^^^^^
> Variable/enum is named "xdp_buff_flags", but comment says "xdp_flags".
>=20
> Here (for xdp_frame) I also think we should change flags to u32, because
> adding this u16 cause extra padding anyhow. (pahole output provided as he=
lp
> below).

ack, I will fix it in v14
>=20
>=20
> >   };
> > +static __always_inline bool xdp_frame_is_mb(struct xdp_frame *frame)
> > +{
> > +	return !!(frame->flags & XDP_FLAGS_MULTI_BUFF);
> > +}
> > +
> >   #define XDP_BULK_QUEUE_SIZE	16
> >   struct xdp_frame_bulk {
> >   	int count;
> > @@ -180,6 +207,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *fr=
ame, struct xdp_buff *xdp)
> >   	xdp->data_end =3D frame->data + frame->len;
> >   	xdp->data_meta =3D frame->data - frame->metasize;
> >   	xdp->frame_sz =3D frame->frame_sz;
> > +	xdp->flags =3D frame->flags;
> >   }
> >   static inline
> > @@ -206,6 +234,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
> >   	xdp_frame->headroom =3D headroom - sizeof(*xdp_frame);
> >   	xdp_frame->metasize =3D metasize;
> >   	xdp_frame->frame_sz =3D xdp->frame_sz;
> > +	xdp_frame->flags =3D xdp->flags;
> >   	return 0;
> >   }
> >=20
>=20
>=20
>=20
> Details below... no need to read any further
>=20
> Investigating struct xdp_frame with pahole:
>=20
> $ pahole -C xdp_frame net/core/xdp.o
> struct xdp_frame {
> 	void *                     data;             /*     0     8 */
> 	u16                        len;              /*     8     2 */
> 	u16                        headroom;         /*    10     2 */
> 	u32                        metasize:8;       /*    12: 0  4 */
> 	u32                        frame_sz:24;      /*    12: 8  4 */
> 	struct xdp_mem_info        mem;              /*    16     8 */
> 	struct net_device *        dev_rx;           /*    24     8 */
>=20
> 	/* size: 32, cachelines: 1, members: 7 */
> 	/* last cacheline: 32 bytes */
> };
>=20
>=20
>  pahole -C xdp_frame net/core/xdp.o
> struct xdp_frame {
> 	void *                     data;             /*     0     8 */
> 	u16                        len;              /*     8     2 */
> 	u16                        headroom;         /*    10     2 */
> 	u32                        metasize:8;       /*    12: 0  4 */
> 	u32                        frame_sz:24;      /*    12: 8  4 */
> 	struct xdp_mem_info        mem;              /*    16     8 */
> 	struct net_device *        dev_rx;           /*    24     8 */
> 	u16                        flags;            /*    32     2 */
>=20
> 	/* size: 40, cachelines: 1, members: 8 */
> 	/* padding: 6 */
> 	/* last cacheline: 40 bytes */
> };
>=20
>=20
> $ pahole -C xdp_frame net/core/xdp.o
> struct xdp_frame {
> 	void *                     data;             /*     0     8 */
> 	u16                        len;              /*     8     2 */
> 	u16                        headroom;         /*    10     2 */
> 	u32                        metasize:8;       /*    12: 0  4 */
> 	u32                        frame_sz:24;      /*    12: 8  4 */
> 	struct xdp_mem_info        mem;              /*    16     8 */
> 	struct net_device *        dev_rx;           /*    24     8 */
> 	u32                        flags;            /*    32     4 */
>=20
> 	/* size: 40, cachelines: 1, members: 8 */
> 	/* padding: 4 */
> 	/* last cacheline: 40 bytes */
> };
>=20
>=20
> Details for struct xdp_buff, it already contains 4 bytes padding.
>=20
> $ pahole -C xdp_buff net/core/xdp.o
> struct xdp_buff {
> 	void *                     data;             /*     0     8 */
> 	void *                     data_end;         /*     8     8 */
> 	void *                     data_meta;        /*    16     8 */
> 	void *                     data_hard_start;  /*    24     8 */
> 	struct xdp_rxq_info *      rxq;              /*    32     8 */
> 	struct xdp_txq_info *      txq;              /*    40     8 */
> 	u32                        frame_sz;         /*    48     4 */
> 	u16                        flags;            /*    52     2 */
>=20
> 	/* size: 56, cachelines: 1, members: 8 */
> 	/* padding: 2 */
> 	/* last cacheline: 56 bytes */
> };

ack, right.

Regards,
Lorenzo

>=20

--Sdy9MTaWNHDmP6Ag
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYTd7PAAKCRA6cBh0uS2t
rBEBAP9tmgIQxl0vUSLVblsDKeUE8sOcZNKkVPb3FGvI9qIkxgD/eWDgeD9Xw4sX
nMlox64EfRPyAAPvC11PTOeAOo0B/w8=
=O3aw
-----END PGP SIGNATURE-----

--Sdy9MTaWNHDmP6Ag--

