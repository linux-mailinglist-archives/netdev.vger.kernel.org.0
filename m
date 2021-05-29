Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865EF394C54
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhE2NgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 09:36:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhE2NgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 09:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B1B3611EE;
        Sat, 29 May 2021 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622295263;
        bh=vMdb9sEEvGE5sNyUs+EwE/C6Rs43J/Ef6VATm9L+VI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q1dr8vmNoiBGuExFhs7yCkLgjZoPq995nxmiu3sGmC5hcXiAAW8Qyu1HL4OcQPDam
         6mpj7rHAI3asl6zZxNx/FLNvgswlBL3EWyzStuplPSD/Ea8P3bbgEEXdrTEwfrcj0C
         dT0JGWHHQQ7OVG3lC+oH4W2XCX8vw7fyM1btYhULthYjsXEGMDQUyB9Mgvql97qSyr
         SkaxrixHgm31mvL5HZvF2b8XGXVEFCcugL4HSHCtp20LDfP0f8p1ZFwRnytRbV40ee
         HR470a1bg0HUh6IrMpDQ030TytXn3tNTgzcTSjnV/RpSTDNTmppM3KObJgvizdHpIo
         KWlKn9bM+Zukw==
Date:   Sat, 29 May 2021 15:34:18 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Tom Herbert <tom@herbertland.com>
Cc:     bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        David Ahern <dsahern@gmail.com>, magnus.karlsson@intel.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, bjorn@kernel.org,
        Maciej =?utf-8?Q?Fija=C5=82kowski_=28Intel=29?= 
        <maciej.fijalkowski@intel.com>,
        john fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 1/4] net: xdp: introduce flags field in xdp_buff
 and xdp_frame
Message-ID: <YLJC2ox7HmAL8dnX@lore-desk>
References: <cover.1622222367.git.lorenzo@kernel.org>
 <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
 <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TQqiyunuxeWmkKQ7"
Content-Disposition: inline
In-Reply-To: <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--TQqiyunuxeWmkKQ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, May 28, 2021 at 10:44 AM Lorenzo Bianconi <lorenzo@kernel.org> wr=
ote:
> >
> > Introduce flag field in xdp_buff and xdp_frame data structure in order
> > to report xdp_buffer metadata. For the moment just hw checksum hints
> > are defined but flags field will be reused for xdp multi-buffer
> > For the moment just CHECKSUM_UNNECESSARY is supported.
> > CHECKSUM_COMPLETE will need to set csum value in metada space.
> >
> Lorenzo,

Hi Tom,

>=20
> This isn't sufficient for the checksum-unnecessary interface, we'd
> also need ability to set csum_level for cases the device validated
> more than one checksum.

ack, right. I guess we can put this info in xdp metadata or do you think we=
 can
add it in xdp_buff/xdp_frame as well?

>=20
> IMO, we shouldn't support CHECKSUM_UNNECESSARY for new uses like this.
> For years now, the Linux community has been pleading with vendors to
> provide CHECKSUM_COMPLETE which is far more useful and robust than
> CHECSUM_UNNECESSARY, and yet some still haven't got with the program
> even though we see more and more instances where CHECKSUM_UNNECESSARY
> doesn't even work at all (e.g. cases with SRv6, new encaps device
> doesn't understand). I believe it's time to take a stand! :-)

I completely agree CHECKSUM_COMPLETE is more useful and robust than
CHECSUM_UNNECESSARY and I want to add support for it as soon as we
agree on the best way to do it. At the same time there are plenty of
XDP NICs where this feature is quite useful since they support just
CHECSUM_UNNECESSARY.

Regards,
Lorenzo

>=20
> Tom
>=20
> > Signed-off-by: David Ahern <dsahern@kernel.org>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/xdp.h | 36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >
> > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > index 5533f0ab2afc..e81ac505752b 100644
> > --- a/include/net/xdp.h
> > +++ b/include/net/xdp.h
> > @@ -66,6 +66,13 @@ struct xdp_txq_info {
> >         struct net_device *dev;
> >  };
> >
> > +/* xdp metadata bitmask */
> > +#define XDP_CSUM_MASK          GENMASK(1, 0)
> > +enum xdp_flags {
> > +       XDP_CSUM_UNNECESSARY    =3D BIT(0),
> > +       XDP_CSUM_COMPLETE       =3D BIT(1),
> > +};
> > +
> >  struct xdp_buff {
> >         void *data;
> >         void *data_end;
> > @@ -74,6 +81,7 @@ struct xdp_buff {
> >         struct xdp_rxq_info *rxq;
> >         struct xdp_txq_info *txq;
> >         u32 frame_sz; /* frame size to deduce data_hard_end/reserved ta=
ilroom*/
> > +       u16 flags; /* xdp_flags */
> >  };
> >
> >  static __always_inline void
> > @@ -81,6 +89,7 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, str=
uct xdp_rxq_info *rxq)
> >  {
> >         xdp->frame_sz =3D frame_sz;
> >         xdp->rxq =3D rxq;
> > +       xdp->flags =3D 0;
> >  }
> >
> >  static __always_inline void
> > @@ -95,6 +104,18 @@ xdp_prepare_buff(struct xdp_buff *xdp, unsigned cha=
r *hard_start,
> >         xdp->data_meta =3D meta_valid ? data : data + 1;
> >  }
> >
> > +static __always_inline void
> > +xdp_buff_get_csum(struct xdp_buff *xdp, struct sk_buff *skb)
> > +{
> > +       switch (xdp->flags & XDP_CSUM_MASK) {
> > +       case XDP_CSUM_UNNECESSARY:
> > +               skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> > +               break;
> > +       default:
> > +               break;
> > +       }
> > +}
> > +
> >  /* Reserve memory area at end-of data area.
> >   *
> >   * This macro reserves tailroom in the XDP buffer by limiting the
> > @@ -122,8 +143,21 @@ struct xdp_frame {
> >          */
> >         struct xdp_mem_info mem;
> >         struct net_device *dev_rx; /* used by cpumap */
> > +       u16 flags; /* xdp_flags */
> >  };
> >
> > +static __always_inline void
> > +xdp_frame_get_csum(struct xdp_frame *xdpf, struct sk_buff *skb)
> > +{
> > +       switch (xdpf->flags & XDP_CSUM_MASK) {
> > +       case XDP_CSUM_UNNECESSARY:
> > +               skb->ip_summed =3D CHECKSUM_UNNECESSARY;
> > +               break;
> > +       default:
> > +               break;
> > +       }
> > +}
> > +
> >  #define XDP_BULK_QUEUE_SIZE    16
> >  struct xdp_frame_bulk {
> >         int count;
> > @@ -180,6 +214,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame *fr=
ame, struct xdp_buff *xdp)
> >         xdp->data_end =3D frame->data + frame->len;
> >         xdp->data_meta =3D frame->data - frame->metasize;
> >         xdp->frame_sz =3D frame->frame_sz;
> > +       xdp->flags =3D frame->flags;
> >  }
> >
> >  static inline
> > @@ -206,6 +241,7 @@ int xdp_update_frame_from_buff(struct xdp_buff *xdp,
> >         xdp_frame->headroom =3D headroom - sizeof(*xdp_frame);
> >         xdp_frame->metasize =3D metasize;
> >         xdp_frame->frame_sz =3D xdp->frame_sz;
> > +       xdp_frame->flags =3D xdp->flags;
> >
> >         return 0;
> >  }
> > --
> > 2.31.1
> >

--TQqiyunuxeWmkKQ7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYLJC1gAKCRA6cBh0uS2t
rFSDAQDDTHB8Y+3AZ8tCcK3RnslE+LOUfTICN4BY2c15WQL/ywD/SBdBfgOgU/0R
jl+why1NXe6zHuFmGrd4mu9QmChc0A8=
=Epvt
-----END PGP SIGNATURE-----

--TQqiyunuxeWmkKQ7--
