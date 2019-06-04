Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD55134B83
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfFDPFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:05:07 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37925 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbfFDPFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:05:07 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so8472990plb.5;
        Tue, 04 Jun 2019 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G7uIiyxYWo4j4Juy7ci2YJOGtQIVLbFD2XwLE2UR30s=;
        b=INYCVXyqyjbAZ3mzQrzKClrncNtWtMVnxtzeJV2V5P+CI9w5Yet5HdwsICjJROhdSw
         2OTm7YA0mIBQJXE+TT0OJLazX3n7wE3S8LmPWZr3MFuzPSJYShKCEKCQ4vq+8iz1LKVP
         oz11HwHJQpjvR699PHfnGZqv4458OmZ4Xx7uomrzF6ITDslfHsgvZqHCQa7uLKzIcQES
         7JpQkbXLGi8RBY4BXn5yxj8xDRRVKw0PWDPn2D0V55NtKscbi1FVeZyAsODi7hYtcAtz
         FmrmMxGmaoKvk7FAspVpXHonmdZTNj4Mk5tT3T3DUSW9NCsOk+KehrlH+2++OfQ5dq4s
         TTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G7uIiyxYWo4j4Juy7ci2YJOGtQIVLbFD2XwLE2UR30s=;
        b=OaU3abkCdR+i/nw96AsT/ACwA4dxKWcEDicfBZA1oBurizLLI3yBLTbCQru6/l8fdT
         rMCwNnN0fgff3C9nZvFGsHLJfhY+BkwauxDRjIdVIVJEOuoIN8IfWAUO7BzSCNN3jN5Y
         TmH2AfZgAXk37iGPxNGWo268RakLRu+fDMDuk1ZMf1pIU7HOqiVFvfm3CEvzCjFrehbI
         MxHBpYM9j2CjoAFElliDSkbPdMUhB17qy4fb3ZeOAn6yqj/CAGPj85oLQL61UcoWIpGF
         XQW4hdPpgdgdNXpQJmEySAnZQA2r3XIKBUQkkofgEJ09MDQVuj1N0h5KJXv6xFdf3Iks
         iBcw==
X-Gm-Message-State: APjAAAVQmAXPE3AJyajtpSG0djrPbWQnlK3F+rmC95q65YmqXyG23e3I
        Wm1M+CbiIZ9NXwtEESFGpbk=
X-Google-Smtp-Source: APXvYqwjVHs/vp1H2Q6Uo8pV0/aHLsiuBsymiiQixlwzjLx4cB1du5CbAE3OthVvzZ9L80I9Sapiaw==
X-Received: by 2002:a17:902:24c7:: with SMTP id l7mr37722019plg.192.1559660705910;
        Tue, 04 Jun 2019 08:05:05 -0700 (PDT)
Received: from localhost ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id d10sm20419654pgh.43.2019.06.04.08.05.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:05:05 -0700 (PDT)
Date:   Tue, 4 Jun 2019 17:04:52 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     magnus.karlsson@intel.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 1/4] libbpf: fill the AF_XDP fill queue
 before bind() call
Message-ID: <20190604170452.00001b29@gmail.com>
In-Reply-To: <76bc124c-46ed-f0a6-315e-1600c837aea0@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-2-maciej.fijalkowski@intel.com>
 <76bc124c-46ed-f0a6-315e-1600c837aea0@intel.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 10:06:36 +0200
Bj=F6rn T=F6pel <bjorn.topel@intel.com> wrote:

> On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> > Let's get into the driver via ndo_bpf with command set to XDP_SETUP_UMEM
> > with fill queue that already contains some available entries that can be
> > used by Rx driver rings. Things worked in such way on old version of
> > xdpsock (that lacked libbpf support) and there's no particular reason
> > for having this preparation done after bind().
> >=20
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Signed-off-by: Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>
> > ---
> >   samples/bpf/xdpsock_user.c | 15 ---------------
> >   tools/lib/bpf/xsk.c        | 19 ++++++++++++++++++-
> >   2 files changed, 18 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > index d08ee1ab7bb4..e9dceb09b6d1 100644
> > --- a/samples/bpf/xdpsock_user.c
> > +++ b/samples/bpf/xdpsock_user.c
> > @@ -296,8 +296,6 @@ static struct xsk_socket_info *xsk_configure_socket=
(struct xsk_umem_info *umem)
> >   	struct xsk_socket_config cfg;
> >   	struct xsk_socket_info *xsk;
> >   	int ret;
> > -	u32 idx;
> > -	int i;
> >  =20
> >   	xsk =3D calloc(1, sizeof(*xsk));
> >   	if (!xsk)
> > @@ -318,19 +316,6 @@ static struct xsk_socket_info *xsk_configure_socke=
t(struct xsk_umem_info *umem)
> >   	if (ret)
> >   		exit_with_error(-ret);
> >  =20
> > -	ret =3D xsk_ring_prod__reserve(&xsk->umem->fq,
> > -				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > -				     &idx);
> > -	if (ret !=3D XSK_RING_PROD__DEFAULT_NUM_DESCS)
> > -		exit_with_error(-ret);
> > -	for (i =3D 0;
> > -	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
> > -		     XSK_UMEM__DEFAULT_FRAME_SIZE;
> > -	     i +=3D XSK_UMEM__DEFAULT_FRAME_SIZE)
> > -		*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) =3D i;
> > -	xsk_ring_prod__submit(&xsk->umem->fq,
> > -			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > -
> >   	return xsk;
> >   }
> >  =20
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 38667b62f1fe..57dda1389870 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -529,7 +529,8 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr,=
 const char *ifname,
> >   	struct xdp_mmap_offsets off;
> >   	struct xsk_socket *xsk;
> >   	socklen_t optlen;
> > -	int err;
> > +	int err, i;
> > +	u32 idx;
> >  =20
> >   	if (!umem || !xsk_ptr || !rx || !tx)
> >   		return -EFAULT;
> > @@ -632,6 +633,22 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr=
, const char *ifname,
> >   	}
> >   	xsk->tx =3D tx;
> >  =20
> > +	err =3D xsk_ring_prod__reserve(umem->fill,
> > +				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > +				     &idx);
> > +	if (err !=3D XSK_RING_PROD__DEFAULT_NUM_DESCS) {
> > +		err =3D -errno;
> > +		goto out_mmap_tx;
> > +	}
> > +
> > +	for (i =3D 0;
> > +	     i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
> > +		     XSK_UMEM__DEFAULT_FRAME_SIZE;
> > +	     i +=3D XSK_UMEM__DEFAULT_FRAME_SIZE)
> > +		*xsk_ring_prod__fill_addr(umem->fill, idx++) =3D i;
> > +	xsk_ring_prod__submit(umem->fill,
> > +			      XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > +
>=20
> Here, entries are added to the umem fill ring regardless if Rx is being
> used or not. For a Tx only setup, this is not what we want, right?

Right, but we have such behavior even without this patch. So I see two opti=
ons
here:
- if you agree with this patch, then I guess we would need to pass the info=
 to
  libbpf what exactly we are setting up (txonly, rxdrop, l2fwd)?
- otherwise, we should be passing the opt_bench onto xsk_configure_socket a=
nd
  based on that decide whether we fill the fq or not?

>=20
> Thinking out loud here; Now libbpf is making the decision which umem
> entries that are added to the fill ring. The sample application has this
> (naive) scheme. I'm not sure that all applications would like that
> policy. What do you think?
>

I find it convenient to have the fill queue in "initialized" state if I am
making use of it, especially in case when I am doing the ZC so I must give =
the
buffers to the driver via fill queue. So why would we bother other applicat=
ions
to provide it? I must admit that I haven't used AF_XDP with other apps than=
 the
example one, so I might not be able to elaborate further. Maybe other people
have different feelings about it.

> >   	sxdp.sxdp_family =3D PF_XDP;
> >   	sxdp.sxdp_ifindex =3D xsk->ifindex;
> >   	sxdp.sxdp_queue_id =3D xsk->queue_id;
> >=20

