Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E3763B48E
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiK1V6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiK1V6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:58:34 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF55C1BEAB
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:58:31 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id v82so13182420oib.4
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLDdh0gmgrkHvlbt0Qk6LQBk7G7QNAMnu/OlUpnhiaY=;
        b=pmFNOhjDJ3S/9UxkucZH8qV/+mFGOTZRfZfty5m6BnMywRIVs4duQ9zeB4cVW4N2ey
         AizJNb/312o1Dfy2i1nTZfKnjA2tERK4H8P+KLAkW8kXOoXnBdigBDlfK6l85mvVyeUV
         sTmIX6LP3FVrbycLqFVHWxUrr+pNUeVIlR8AUCbBKcETp6FEgjAaceyuwpbpPDPYPbip
         mMzntF4GN4ncVtsGJcq0mD0YB46e6cOwvWgG7bg9xLS+xPGz7ZMz/ga9uaRjgJV9K7rG
         0ZWf7lHs4y7o7G71XWvaozlk+kYnDpDdbOEI0l0f/bgePC2UiKbHT+pro1YhydXj4VbD
         DcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLDdh0gmgrkHvlbt0Qk6LQBk7G7QNAMnu/OlUpnhiaY=;
        b=UtJr9m3GD69VLrXrXIkVtqG6KVCzSh00KZCZW+o95VUHaXFl5VRex9aJYMPqlQxM8I
         TpfeecxIJrQvq79k35nINC6dSVJLPx7UyTOnsrFyn8Q+mxguTDjHKsbe/wMGHq4jbx2Q
         CiA8ND+B+0QFMolpg+ziJX5dnYs/iZf2Q5Uv7JXaxhG/Novc/rvQ0UW99rrSYU0XYdKs
         aIHb/v8+MhqTlr+vEhkjTdJvtDSO7b4xihc9ecFzSk3E79cKmXpCN1QmPI1k/scl7Wa6
         KNaavDq6KXxSoypKk3LDJIS+6sBpDyIUyrFnUnVFHg5UC7IK28tk5r+6tKa/PCEmkO6Z
         cUnw==
X-Gm-Message-State: ANoB5pkwFlCcilo8oqU0M1wv56nTTQuN6qrpHhAXTBRH1olOyJ2JCtv7
        Bq6MHttXb7/pR3HNKjJQN9QBB5aql+sVJq4uORGbgw==
X-Google-Smtp-Source: AA0mqf4SyYwhb5aXxQg20tTnSaMO0WzbAk/x8Qc3aJFzEDnvety1XxuMhmJYXqcEeyz8MKX7zmGFTQRCqXi4VTomwsA=
X-Received: by 2002:aca:674c:0:b0:35b:79ca:2990 with SMTP id
 b12-20020aca674c000000b0035b79ca2990mr13366020oiy.125.1669672710977; Mon, 28
 Nov 2022 13:58:30 -0800 (PST)
MIME-Version: 1.0
References: <20221121182552.2152891-1-sdf@google.com> <20221121182552.2152891-7-sdf@google.com>
 <874jupviyc.fsf@toke.dk> <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
 <20221123111431.7b54668e@kernel.org> <Y3557Ecr80Y9ZD2z@google.com>
 <871qptuyie.fsf@toke.dk> <20221123174746.418920e5@kernel.org>
 <87edts2z8n.fsf@toke.dk> <Y3+K7dJLFX7gRQp+@boxer> <Y3+XtkkIh0o++Dgr@boxer> <874jun3m58.fsf@toke.dk>
In-Reply-To: <874jun3m58.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 28 Nov 2022 13:58:19 -0800
Message-ID: <CAKH8qBvbYuCq-iiXnMw1QxFbfLFhorpF1+GGqU1yVzX2LhoUzQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 4:36 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
>
> > On Thu, Nov 24, 2022 at 04:17:01PM +0100, Maciej Fijalkowski wrote:
> >> On Thu, Nov 24, 2022 at 03:39:20PM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
> >> > Jakub Kicinski <kuba@kernel.org> writes:
> >> >
> >> > > On Wed, 23 Nov 2022 22:55:21 +0100 Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> >> > >> > Good idea, prototyped below, lmk if it that's not what you had =
in mind.
> >> > >> >
> >> > >> > struct xdp_buff_xsk {
> >> > >> >       struct xdp_buff            xdp;                  /*     0=
    56 */
> >> > >> >       u8                         cb[16];               /*    56=
    16 */
> >> > >> >       /* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --=
- */
> >> > >>
> >> > >> As pahole helpfully says here, xdp_buff is actually only 8 bytes =
from
> >> > >> being a full cache line. I thought about adding a 'cb' field like=
 this
> >> > >> to xdp_buff itself, but figured that since there's only room for =
a
> >> > >> single pointer, why not just add that and let the driver point it=
 to
> >> > >> where it wants to store the extra context data?
> >> > >
> >> > > What if the driver wants to store multiple pointers or an integer =
or
> >> > > whatever else? The single pointer seems quite arbitrary and not
> >> > > strictly necessary.
> >> >
> >> > Well, then you allocate a separate struct and point to that? Like I =
did
> >> > in mlx5:
> >> >
> >> >
> >> > +  struct mlx5_xdp_ctx mlctx =3D { .cqe =3D cqe, .rq =3D rq };
> >> > +  struct xdp_buff xdp =3D { .drv_priv =3D &mlctx };
> >> >
> >> > but yeah, this does give an extra pointer deref on access. I'm not
> >> > really opposed to the cb field either, I just think it's a bit odd t=
o
> >> > put it in struct xdp_buff_xsk; that basically requires the driver to
> >> > keep the layouts in sync.
> >> >
> >> > Instead, why not but a cb field into xdp_buff itself so it can be us=
ed
> >> > for both the XSK and the non-XSK paths? Then the driver can just
> >> > typecast the xdp_buff into its own struct that has whatever data it
> >> > wants in place of the cb field?

Agreed, maybe having an explicit cb field in the xdp_buff is a nice
compromise (assuming, over time, most devices will use it).

> >> Why can't you simply have a pointer to xdp_buff in driver specific
> >> xdp_buff container which would point to xdp_buff that is stack based (=
or
> >> whatever else memory that will back it up - I am about to push a chang=
e
> >> that makes ice driver embed xdp_buff within a struct that represents R=
x
> >> ring) for XDP path and for ZC the pointer to xdp_buff that you get fro=
m
> >> xsk_buff_pool ? This would satisfy both sides I believe and would let =
us
> >> keep the same container struct.
> >>
> >> struct mlx4_xdp_buff {
> >>      struct xdp_buff *xdp;
> >>      struct mlx4_cqe *cqe;
> >>      struct mlx4_en_dev *mdev;
> >>      struct mlx4_en_rx_ring *ring;
> >>      struct net_device *dev;
> >> };
> >
> > Nah this won't work from kfunc POV, probably no way to retrieve the
> > mlx4_xdp_buff based on xdp_buff ptr that needs to be used as an arg.
> >
> > Sorry I'll think more about it, in the meantime let's hear more voices
> > whether we should keep Stan's original approach + modify xdp_buff_xsk o=
r
> > go with Toke's proposal.
>
> OK, so I played around with the mlx5 code a bit more, and I think the
> "wrapping struct + cb area" can be made to work without too many ugly
> casts; I'll send an updated version of the mlx5 patches with this
> incorporated tomorrow, after I've run some tests...

I'll probably send a v3 sometime tomorrow (PST), so maybe wait for me
to make sure we are working on the same base?
Or LMK if you prefer to do it differently..
