Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EA162E38B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiKQRxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240329AbiKQRxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:53:13 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654037FF01
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:53:11 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id v81so2684112oie.5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzoP6EPLHpvW7/u1IBkfvZWAk5EqRIxZ6RKDor9Yg48=;
        b=WtVfvAfhFnJqCX0GS5RGt/BaRlkLZvLStqniada84N6lAVgqYZOPYn93C3CVcCHP44
         5NyKApOyiK3n8Q3jlHhheTFRWokjiFrxLqrPyByeJ1qJwCBZQyARbL9euwt99bD5a/9p
         JxI+RKk+2yc8djT6wVJ4O/X1rnd9DZMmThHtYLy0VaLVyMWu5mpWMuD2PYs9s4PL8am0
         g7ywyuhtc5WdTIyK3goy290XQ1nYXe/IsHmxKHIPyU1PvFRviKWcGmH3J0uQyEPWHYZa
         Mo10suEIT5tPixvoRLbbUDBsdzc1OXg9qWLVYcZMZ6kZGX9cXkGJQazxqpzz1WkFRVmu
         BFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IzoP6EPLHpvW7/u1IBkfvZWAk5EqRIxZ6RKDor9Yg48=;
        b=vMQ52osSHpZHkZRLNwoSKBOUM7m1RdQsBd7ROCbER92ksmIEXqjgq/dJy2wof77r3L
         x960MODNUgQ/RSr3NTum7cHOKVLLbX+IwSyL5aW5Bymn5dI2mm4sLXehOvR57Q/zTnSM
         u2yU+5n/hbn7wfYMJEql6nMg6rt/A0Qz1H7cMifA0asfzndHNr7P4gQ1lSpMJ6r8iqoJ
         ufYB5UGFA5i7dvPeAdiKOc4ipNItvl8+ri5glGZYDXmaatiXtIrz5jk6ZTAMMr6vQSm3
         7wUlR9Q5jKhxRKTBOgk0pU2xg+Q0W0bmKXtvDpnbGFh5SBeFbrzbWd4rIR1HXV799mW4
         gX9g==
X-Gm-Message-State: ANoB5pmLYbHhmWtuR91Li4HCAF4+1+M4fzCsZADJhxAFFbcC7+SRpL2l
        vhMajUpvliCsPAFC5LRCRvA81v+XaGLZTZiqMB59Qg==
X-Google-Smtp-Source: AA0mqf4Kjc0nQQtepujdq3yR2VsRhySGgGcFIG7r3ZIM4Zbziy1gCgctRR/8mCDTFJXUhLnK9nzmWwjY1PjuNCcabgQ=
X-Received: by 2002:a05:6808:f09:b0:354:8922:4a1a with SMTP id
 m9-20020a0568080f0900b0035489224a1amr1706884oiw.181.1668707590550; Thu, 17
 Nov 2022 09:53:10 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch> <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
 <87wn7t4y0g.fsf@toke.dk> <CAADnVQJMvPjXCtKNH+WCryPmukgbWTrJyHqxrnO=2YraZEukPg@mail.gmail.com>
In-Reply-To: <CAADnVQJMvPjXCtKNH+WCryPmukgbWTrJyHqxrnO=2YraZEukPg@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 17 Nov 2022 09:52:59 -0800
Message-ID: <CAKH8qBsPinmCO0Ny1hva7kp4+C7XFdxZLPBYEHXQWDjJ5SSoYw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
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

On Thu, Nov 17, 2022 at 8:59 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Nov 17, 2022 at 3:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Stanislav Fomichev <sdf@google.com> writes:
> >
> > >> > Doesn't look like the descriptors are as nice as you're trying to
> > >> > paint them (with clear hash/csum fields) :-) So not sure how much
> > >> > CO-RE would help.
> > >> > At least looking at mlx4 rx_csum, the driver consults three differ=
ent
> > >> > sets of flags to figure out the hash_type. Or am I just unlucky wi=
th
> > >> > mlx4?
> > >>
> > >> Which part are you talking about ?
> > >>         hw_checksum =3D csum_unfold((__force __sum16)cqe->checksum);
> > >> is trivial enough for bpf prog to do if it has access to 'cqe' point=
er
> > >> which is what John is proposing (I think).
> > >
> > > I'm talking about mlx4_en_process_rx_cq, the caller of that check_csu=
m.
> > > In particular: if (likely(dev->features & NETIF_F_RXCSUM)) branch
> > > I'm assuming we want to have hash_type available to the progs?
> >
> > I agree we should expose the hash_type, but that doesn't actually look
> > to be that complicated, see below.
> >
> > > But also, check_csum handles other corner cases:
> > > - short_frame: we simply force all those small frames to skip checksu=
m complete
> > > - get_fixed_ipv6_csum: In IPv6 packets, hw_checksum lacks 6 bytes fro=
m
> > > IPv6 header
> > > - get_fixed_ipv4_csum: Although the stack expects checksum which
> > > doesn't include the pseudo header, the HW adds it
> > >
> > > So it doesn't look like we can just unconditionally use cqe->checksum=
?
> > > The driver does a lot of massaging around that field to make it
> > > palatable.
> >
> > Poking around a bit in the other drivers, AFAICT it's only a subset of
> > drivers that support CSUM_COMPLETE at all; for instance, the Intel
> > drivers just set CHECKSUM_UNNECESSARY for TCP/UDP/SCTP. I think the
> > CHECKSUM_UNNECESSARY is actually the most important bit we'd want to
> > propagate?
> >
> > AFAICT, the drivers actually implementing CHECKSUM_COMPLETE need access
> > to other data structures than the rx descriptor to determine the status
> > of the checksum (mlx4 looks at priv->flags, mlx5 checks rq->state), so
> > just exposing the rx descriptor to BPF as John is suggesting does not
> > actually give the XDP program enough information to act on the checksum
> > field on its own. We could still have a separate kfunc to just expose
> > the hw checksum value (see below), but I think it probably needs to be
> > paired with other kfuncs to be useful.
> >
> > Looking at the mlx4 code, I think the following mapping to kfuncs (in
> > pseudo-C) would give the flexibility for XDP to access all the bits it
> > needs, while inlining everything except getting the full checksum for
> > non-TCP/UDP traffic. An (admittedly cursory) glance at some of the othe=
r
> > drivers (mlx5, ice, i40e) indicates that this would work for those
> > drivers as well.
> >
> >
> > bpf_xdp_metadata_rx_hash_supported() {
> >   return dev->features & NETIF_F_RXHASH;
> > }
> >
> > bpf_xdp_metadata_rx_hash() {
> >   return be32_to_cpu(cqe->immed_rss_invalid);
> > }
> >
> > bpf_xdp_metdata_rx_hash_type() {
> >   if (likely(dev->features & NETIF_F_RXCSUM) &&
> >       (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP | MLX4_CQE_STATUS_=
UDP)) &&
> >         (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
> >           cqe->checksum =3D=3D cpu_to_be16(0xffff))
> >      return PKT_HASH_TYPE_L4;
> >
> >    return PKT_HASH_TYPE_L3;
> > }
> >
> > bpf_xdp_metadata_rx_csum_supported() {
> >   return dev->features & NETIF_F_RXCSUM;
> > }
> >
> > bpf_xdp_metadata_rx_csum_level() {
> >         if ((cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP |
> >                                        MLX4_CQE_STATUS_UDP)) &&
> >             (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
> >             cqe->checksum =3D=3D cpu_to_be16(0xffff))
> >             return CHECKSUM_UNNECESSARY;
> >
> >         if (!(priv->flags & MLX4_EN_FLAG_RX_CSUM_NON_TCP_UDP &&
> >               (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IP_ANY))) &&
> >               !short_frame(len))
> >             return CHECKSUM_COMPLETE; /* we could also omit this case e=
ntirely */
> >
> >         return CHECKSUM_NONE;
> > }
> >
> > /* this one could be called by the metadata_to_skb code */
> > bpf_xdp_metadata_rx_csum_full() {
> >   return check_csum() /* BPF_CALL this after refactoring so it is skb-a=
gnostic */
> > }
> >
> > /* this one would be for people like John who want to re-implement
> >  * check_csum() themselves */
> > bpf_xdp_metdata_rx_csum_raw() {
> >   return cqe->checksum;
> > }
>
> Are you proposing a bunch of per-driver kfuncs that bpf prog will call.
> If so that works, but bpf prog needs to pass dev and cqe pointers
> into these kfuncs, so they need to be exposed to the prog somehow.
> Probably through xdp_md ?

So far I'm doing:

struct mlx4_xdp_buff {
  struct xdp_buff xdp;
  struct mlx4_cqe *cqe;
  struct mlx4_en_dev *mdev;
}

And then the kfuncs get ctx (aka xdp_buff) as a sole argument and can
find cqe/mdev via container_of.

If we really need these to be exposed to the program, can we use
Yonghong's approach from [0]?

0: https://lore.kernel.org/bpf/20221114162328.622665-1-yhs@fb.com/

> This way we can have both: bpf prog reading cqe fields directly
> and using kfuncs to access things.
> Inlining of kfuncs should be done generically.
> It's not a driver job to convert native asm into bpf asm.

Ack. I can replace the unrolling with something that just resolves
"generic" kfuncs to the per-driver implementation maybe? That would at
least avoid netdev->ndo_kfunc_xxx indirect calls at runtime..
