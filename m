Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CFF68C9D7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 23:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBFW4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 17:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBFW4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 17:56:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA00199C8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 14:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675724111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5BMxmF2QM4fBq+3cTZMsRqiaXUUE3XWKiUfkoH7JsxM=;
        b=KrxPXT5NVYAfD2BNo9eVyH0xyVUwR0SiVUSayeLuobi+SIb5940Dc+OUWbyJd/+DfPWynM
        BSxwPUku8aLdOx/0pG3nTPcLEBjxzG8JE3gxJ2c41EFO96ogpsU7bln1OWDi/bYi1EJSyJ
        tu0OrhiJt/Y/JuLSmo+0VE3mHKwti7I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-B-saFHc_NuqNKTtrXtZ9bA-1; Mon, 06 Feb 2023 17:55:07 -0500
X-MC-Unique: B-saFHc_NuqNKTtrXtZ9bA-1
Received: by mail-wm1-f70.google.com with SMTP id o2-20020a05600c510200b003dc51c95c6aso38306wms.0
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 14:55:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BMxmF2QM4fBq+3cTZMsRqiaXUUE3XWKiUfkoH7JsxM=;
        b=UiMUO1U6UYIzszcWkNOSec+Mf/VahsNmLZdcSHahfhoBCF1yvkRFm1SnRTgfkIhDky
         xL5qasRWpJFavFCXwK+sP9KHxQg4Gk6IUYjxkLokTEuDRtducCya3Q8nybUuITl8mJzz
         UcaUW9zHJm0+1brG3q1MjsYAg1/f/j2LeKpgr7VI39uoNrsvnWPFpbuCGCo35Xd1ua8r
         MtSVLVXyxu6kJf8r7DnEMniuFNBXohEHQwVTwEFj4yqu+l3jg8y5sziRFnIL0EwFwSp2
         zxcPBXG7S9AI+PS/UCbQsS7jycqdimI7MxQLsMF0N9b8erJjk9yOEjDnduitufhaffRe
         cRaw==
X-Gm-Message-State: AO0yUKWX2dUv9tk6oYD/qVxBINo1ZucWJXxmZUYX5DErLCBo4p4anMOR
        86FdE5Q1x2GVwqdTXMLoo8OJ+WBaRLeN4Nqpoq090OzcThvhUPhkj9N/ztkMusbgbwfBw0rfPr3
        Kqis+C3hHos5jDeeg
X-Received: by 2002:a05:600c:230f:b0:3da:f665:5b66 with SMTP id 15-20020a05600c230f00b003daf6655b66mr1785152wmo.6.1675724106430;
        Mon, 06 Feb 2023 14:55:06 -0800 (PST)
X-Google-Smtp-Source: AK7set9bGZQlwzoKZ+U5jL/lcK74l/5ol5+6MgkpECWBCB+hBsXFHBrRpsWvuzWHuhyXlrl7ZLRDSA==
X-Received: by 2002:a05:600c:230f:b0:3da:f665:5b66 with SMTP id 15-20020a05600c230f00b003daf6655b66mr1785126wmo.6.1675724106210;
        Mon, 06 Feb 2023 14:55:06 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id z17-20020a7bc7d1000000b003dc3f07c876sm17528965wmk.46.2023.02.06.14.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 14:55:04 -0800 (PST)
Date:   Mon, 6 Feb 2023 23:55:02 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        martin.lau@linux.dev, sdf@google.com, gerhard@engleder-embedded.com
Subject: Re: [PATCH v5 bpf-next 5/8] libbpf: add API to get XDP/XSK supported
 features
Message-ID: <Y+GFRm+z1Ry9ssnk@lore-desk>
References: <cover.1675245257.git.lorenzo@kernel.org>
 <a72609ef4f0de7fee5376c40dbf54ad7f13bfb8d.1675245258.git.lorenzo@kernel.org>
 <CAEf4BzZS-MSen_1q4eotMe3hdkXUXxpwnfbLqEENzU1ogejxUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0XM81ACP0nEwcCmt"
Content-Disposition: inline
In-Reply-To: <CAEf4BzZS-MSen_1q4eotMe3hdkXUXxpwnfbLqEENzU1ogejxUQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0XM81ACP0nEwcCmt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Feb 1, 2023 at 2:25 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > Extend bpf_xdp_query routine in order to get XDP/XSK supported features
> > of netdev over route netlink interface.
> > Extend libbpf netlink implementation in order to support netlink_generic
> > protocol.
> >
> > Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > Co-developed-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Marek Majtyka <alardam@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.h  |  3 +-
> >  tools/lib/bpf/netlink.c | 96 +++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/nlattr.h  | 12 ++++++
> >  3 files changed, 110 insertions(+), 1 deletion(-)
> >
>=20
> [...]
>=20
> > @@ -366,6 +433,10 @@ int bpf_xdp_query(int ifindex, int xdp_flags, stru=
ct bpf_xdp_query_opts *opts)
> >                 .ifinfo.ifi_family =3D AF_PACKET,
> >         };
> >         struct xdp_id_md xdp_id =3D {};
> > +       struct xdp_features_md md =3D {
> > +               .ifindex =3D ifindex,
> > +       };
> > +       __u16 id;
> >         int err;
> >
> >         if (!OPTS_VALID(opts, bpf_xdp_query_opts))
> > @@ -393,6 +464,31 @@ int bpf_xdp_query(int ifindex, int xdp_flags, stru=
ct bpf_xdp_query_opts *opts)
> >         OPTS_SET(opts, skb_prog_id, xdp_id.info.skb_prog_id);
> >         OPTS_SET(opts, attach_mode, xdp_id.info.attach_mode);
> >
> > +       if (!OPTS_HAS(opts, feature_flags))
> > +               return 0;
> > +
> > +       err =3D libbpf_netlink_resolve_genl_family_id("netdev", sizeof(=
"netdev"), &id);
> > +       if (err < 0)
> > +               return libbpf_err(err);
> > +
> > +       memset(&req, 0, sizeof(req));
> > +       req.nh.nlmsg_len =3D NLMSG_LENGTH(GENL_HDRLEN);
> > +       req.nh.nlmsg_flags =3D NLM_F_REQUEST;
> > +       req.nh.nlmsg_type =3D id;
> > +       req.gnl.cmd =3D NETDEV_CMD_DEV_GET;
> > +       req.gnl.version =3D 2;
> > +
> > +       err =3D nlattr_add(&req, NETDEV_A_DEV_IFINDEX, &ifindex, sizeof=
(ifindex));
> > +       if (err < 0)
> > +               return err;
>=20
> just noticed this, we need to use libbpf_err(err) here like in other
> error cases to set errno properly. Can you please send a follow up?

sure, I will post a fix.

Regards,
Lorenzo

>=20
> > +
> > +       err =3D libbpf_netlink_send_recv(&req, NETLINK_GENERIC,
> > +                                      parse_xdp_features, NULL, &md);
> > +       if (err)
> > +               return libbpf_err(err);
> > +
> > +       opts->feature_flags =3D md.flags;
> > +
> >         return 0;
> >  }
> >
>=20
> [...]
>=20

--0XM81ACP0nEwcCmt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY+GFRgAKCRA6cBh0uS2t
rFT4AP9GXZT3c5tPEuaCysaaoxeuf3d+mSQMBZlko6/+JEzp+AD7BZykMXY9uY8O
JNVIS3KVeZoDsBk1415C9OCu36uW4wM=
=RfPO
-----END PGP SIGNATURE-----

--0XM81ACP0nEwcCmt--

