Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8D7430AB
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 22:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388188AbfFLUBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 16:01:23 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37224 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387605AbfFLUBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 16:01:22 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so9467927pfa.4
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 13:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bP4Wv0eOl5zUrh4FGixzw5n7FaG9305MNzDqpGakCSY=;
        b=tpW5VPNsI6iCL3hAEkxdPfyyti5rnZum2zReHc2fepaE38AWaCNZKO/DW2E09xLm2y
         2pDKjC1w9Jrd4s5LV51PGsEhmKxbd7o1PEb5LTz1kJJFW7J3TDX+ol+B4HT6ratLvD/j
         v//01Wnp1emzYMTp+D/PVVPIm7RvwT5JcWN4HtVHPVH5uX3wrRORsX0HdnrsWo/bqHAY
         mbTYzv0EHRBcwliWPtCKTwsIcVlGgP8csjGkNPL7R1Sg975qc+rg3XhJBpnPFDSpg8ld
         DVT4WpzLD6kUxDCPocY5+fW3oXiZ5ZkiaH3NA0BQdXgQlr2Zyd/4bIpzQCVOBBNURJi5
         v8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bP4Wv0eOl5zUrh4FGixzw5n7FaG9305MNzDqpGakCSY=;
        b=DB7Wj8DB2hZvzbSq0xSGv837f1kzN/7U6HCYZpAPWjdBt8fl0KwJZZEJQ39q5Eqv4S
         TutEla4LKRS6yK4MGdRRQJF9J3/BgclazzBwHMqH+nxKhjVJDd9zYrDhS0/9ZJu111nK
         Cdeq4rN4JPFEGs50r/2RR3LRV3cOccYgT66VPnr0quoJ0AIXLJasf5hYtxwWTCak5mOi
         ywLCyCY6Ev8JVX6qmiIeFHVrtrUZJQI6IQqAcn2CEDDyN81D+EI04WcCHpnxluL1kgeN
         IkoN1acuNeV+DmzYdA+X0ijPpx1a7M02OcGw/zzUPZ5rFqMbVJ3rS9Dyl2I+aSeUT8Jg
         tLng==
X-Gm-Message-State: APjAAAVlAk5ADTwzGXwL9x67Mqv5Xv3umk9h7rcaSGIDV2TjAoNUUpDx
        z4D9Br7ejfJxC6F0pFKB/1c=
X-Google-Smtp-Source: APXvYqzDIGuZ1o3GUTP+14uMHWm625/bCQOiMJJwlanXV2QNvmCyKFqM/lNAN07JoKJhUa/ixHsMug==
X-Received: by 2002:a63:5d45:: with SMTP id o5mr27026200pgm.40.1560369681774;
        Wed, 12 Jun 2019 13:01:21 -0700 (PDT)
Received: from localhost ([192.55.54.45])
        by smtp.gmail.com with ESMTPSA id b8sm424659pff.20.2019.06.12.13.01.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Jun 2019 13:01:21 -0700 (PDT)
Date:   Wed, 12 Jun 2019 22:01:05 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf-next v3 2/3] bpf_xdp_redirect_map: Perform map
 lookup in eBPF helper
Message-ID: <20190612220105.00000d39@gmail.com>
In-Reply-To: <87y328f0m9.fsf@toke.dk>
References: <156026783994.26748.2899804283816365487.stgit@alrua-x1>
        <156026784011.26748.7290735899755011809.stgit@alrua-x1>
        <20190611200021.473138bc@carbon>
        <87y328f0m9.fsf@toke.dk>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 20:17:02 +0200
Toke H=F8iland-J=F8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > On Tue, 11 Jun 2019 17:44:00 +0200
> > Toke H=F8iland-J=F8rgensen <toke@redhat.com> wrote:
> > =20
> >> From: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> >>=20
> >> The bpf_redirect_map() helper used by XDP programs doesn't return any
> >> indication of whether it can successfully redirect to the map index it=
 was
> >> given. Instead, BPF programs have to track this themselves, leading to
> >> programs using duplicate maps to track which entries are populated in =
the
> >> devmap.
> >>=20
> >> This patch fixes this by moving the map lookup into the bpf_redirect_m=
ap()
> >> helper, which makes it possible to return failure to the eBPF program.=
 The
> >> lower bits of the flags argument is used as the return code, which mea=
ns
> >> that existing users who pass a '0' flag argument will get XDP_ABORTED.
> >>=20
> >> With this, a BPF program can check the return code from the helper cal=
l and
> >> react by, for instance, substituting a different redirect. This works =
for
> >> any type of map used for redirect.
> >>=20
> >> Signed-off-by: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> >> ---
> >>  include/linux/filter.h   |    1 +
> >>  include/uapi/linux/bpf.h |    8 ++++++++
> >>  net/core/filter.c        |   26 ++++++++++++--------------
> >>  3 files changed, 21 insertions(+), 14 deletions(-)
> >>=20
> >> diff --git a/include/linux/filter.h b/include/linux/filter.h
> >> index 43b45d6db36d..f31ae8b9035a 100644
> >> --- a/include/linux/filter.h
> >> +++ b/include/linux/filter.h
> >> @@ -580,6 +580,7 @@ struct bpf_skb_data_end {
> >>  struct bpf_redirect_info {
> >>  	u32 ifindex;
> >>  	u32 flags;
> >> +	void *item;
> >>  	struct bpf_map *map;
> >>  	struct bpf_map *map_to_flush;
> >>  	u32 kern_flags;
> >> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >> index 7c6aef253173..9931cf02de19 100644
> >> --- a/include/uapi/linux/bpf.h
> >> +++ b/include/uapi/linux/bpf.h
> >> @@ -3098,6 +3098,14 @@ enum xdp_action {
> >>  	XDP_REDIRECT,
> >>  };
> >> =20
> >> +/* Flags for bpf_xdp_redirect_map helper */
> >> +
> >> +/* The lower flag bits will be the return code of bpf_xdp_redirect_ma=
p() helper
> >> + * if the map lookup fails.
> >> + */
> >> +#define XDP_REDIRECT_INVALID_MASK (XDP_ABORTED | XDP_DROP | XDP_PASS =
| XDP_TX)
> >> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_INVALID_MASK
> >> + =20
> >
> > Slightly confused about the naming of the define, see later.
> > =20
> >>  /* user accessible metadata for XDP packet hook
> >>   * new fields must be added to the end of this structure
> >>   */
> >> diff --git a/net/core/filter.c b/net/core/filter.c
> >> index 7a996887c500..dd43be497480 100644
> >> --- a/net/core/filter.c
> >> +++ b/net/core/filter.c
> >> @@ -3608,17 +3608,13 @@ static int xdp_do_redirect_map(struct net_devi=
ce *dev, struct xdp_buff *xdp,
> >>  			       struct bpf_redirect_info *ri)
> >>  {
> >>  	u32 index =3D ri->ifindex;
> >> -	void *fwd =3D NULL;
> >> +	void *fwd =3D ri->item;
> >>  	int err;
> >> =20
> >>  	ri->ifindex =3D 0;
> >> +	ri->item =3D NULL;
> >>  	WRITE_ONCE(ri->map, NULL);
> >> =20
> >> -	fwd =3D __xdp_map_lookup_elem(map, index);
> >> -	if (unlikely(!fwd)) {
> >> -		err =3D -EINVAL;
> >> -		goto err;
> >> -	}
> >>  	if (ri->map_to_flush && unlikely(ri->map_to_flush !=3D map))
> >>  		xdp_do_flush_map();
> >> =20
> >> @@ -3655,18 +3651,13 @@ static int xdp_do_generic_redirect_map(struct =
net_device *dev,
> >>  {
> >>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> >>  	u32 index =3D ri->ifindex;
> >> -	void *fwd =3D NULL;
> >> +	void *fwd =3D ri->item;
> >>  	int err =3D 0;
> >> =20
> >>  	ri->ifindex =3D 0;
> >> +	ri->item =3D NULL;
> >>  	WRITE_ONCE(ri->map, NULL);
> >> =20
> >> -	fwd =3D __xdp_map_lookup_elem(map, index);
> >> -	if (unlikely(!fwd)) {
> >> -		err =3D -EINVAL;
> >> -		goto err;
> >> -	}
> >> -
> >>  	if (map->map_type =3D=3D BPF_MAP_TYPE_DEVMAP) {
> >>  		struct bpf_dtab_netdev *dst =3D fwd;
> >> =20
> >> @@ -3735,6 +3726,7 @@ BPF_CALL_2(bpf_xdp_redirect, u32, ifindex, u64, =
flags)
> >> =20
> >>  	ri->ifindex =3D ifindex;
> >>  	ri->flags =3D flags;
> >> +	ri->item =3D NULL;
> >>  	WRITE_ONCE(ri->map, NULL);
> >> =20
> >>  	return XDP_REDIRECT;
> >> @@ -3753,9 +3745,15 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map=
 *, map, u32, ifindex,
> >>  {
> >>  	struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info);
> >> =20
> >> -	if (unlikely(flags))
> >> +	if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
> >>  		return XDP_ABORTED;
> >> =20

Here you don't allow the flags to get different value than
XDP_REDIRECT_ALL_FLAGS.

> >> +	ri->item =3D __xdp_map_lookup_elem(map, ifindex);
> >> +	if (unlikely(!ri->item)) {
> >> +		WRITE_ONCE(ri->map, NULL);
> >> +		return (flags & XDP_REDIRECT_INVALID_MASK); =20

So here you could just return flags? Don't we know that the flags value is
legit here? Am I missing something? TBH the v2 was more clear to me.

> >
> > Maybe I'm reading it wrong, but shouldn't the mask be called the "valid=
" mask? =20
>=20
> It's the mask that is applied when the index looked up is invalid (i.e.,
> the entry doesn't exist)? But yeah, can see how the name can be
> confusing; maybe it should just be "RETURN_MASK" or something like that?

Maybe something along ALLOWED_RETVAL_MASK?

>=20
> -Toke

