Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBF362E263
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 17:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiKQQ7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 11:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbiKQQ7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 11:59:41 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7C3D4;
        Thu, 17 Nov 2022 08:59:40 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bj12so6503872ejb.13;
        Thu, 17 Nov 2022 08:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UJ00cgCNlJ+mB8atLzyKdQ/Od+etr01YQTry/q9WgVA=;
        b=eZaAVptCroLm9dhcCc7IPzYmDHeBdnsTGJnt7YVUeroeFEhLLPxUvM1lsKX3hJ00Mg
         Yjf13eRuYjTlyE2pHldq/COjVRkYIEidNzQnJvXYQ0WpVKtX7QfLTUa0mXZgb7/AUPYx
         3pSlZHDFuWiR+/Sms+vgjt08mAgGl8EqNmgm82wco2HVw/kIZwaG6ISknHdwlEE6amgf
         Gm0bhzXVX76snYjqFrG5NBLsp7EKgxs66u5gNYpVLo9Shx7gNNFoKpWYWCHOAZg33xn6
         1O1qUb37EMXECRiutLmvBYwqXrepZcIkS/YmIMQwFdbNnpIgU/o3G77NZ9TKazowmyXZ
         LARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UJ00cgCNlJ+mB8atLzyKdQ/Od+etr01YQTry/q9WgVA=;
        b=LJ3iRgyonFmZQOT7chc0VsuwZE1gKBIfhTWYtz0yZMvbyf2n0SujUaPJL2CBBlAji1
         Y6hw6QvPioXHFWVpP+hkV6k/pBZpuXmdvpNG3pLtWvlELxUo4UXRg/XpIB+JfeuDjcZQ
         BwoDnhcYtqUSipIDE2Ce9wpcPk+j3Bn2jMZ8Idl5hac6mwDjmdsMlSFaY+bRpQA+XIDY
         A8Q0+OgFBFlCR8PBUW0WqMEO+ED4z/l3RdDvzB9RygO2EWL/GoFWYjrUGKVW5bTBUOio
         W20Tn/XF7j3Iadeg4hHufbz1NY6NSjwswH8BIBNXTXh2536czEkeVTAsNNo827/X74eR
         OAsg==
X-Gm-Message-State: ANoB5pk8yeoIAgnXjMgXROzNlBZ7MBOR5GVsr/645xbR+5qxf4XYZEsp
        VRIZpc0oY9ORVIRCwRVzS0pm0aS91hG6bd2Zzz0=
X-Google-Smtp-Source: AA0mqf7WWmZiYm6D/p0xWPQz7NI51bHYCVV/oi4bKGwJYMi8xN+sULf5bPGlrjyCHElWM8LfXYWcAlSFINNAKkYBSiM=
X-Received: by 2002:a17:906:4ed9:b0:7ae:664a:a7d2 with SMTP id
 i25-20020a1709064ed900b007ae664aa7d2mr2875863ejv.676.1668704378567; Thu, 17
 Nov 2022 08:59:38 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch> <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com> <87wn7t4y0g.fsf@toke.dk>
In-Reply-To: <87wn7t4y0g.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Nov 2022 08:59:26 -0800
Message-ID: <CAADnVQJMvPjXCtKNH+WCryPmukgbWTrJyHqxrnO=2YraZEukPg@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 3:32 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Stanislav Fomichev <sdf@google.com> writes:
>
> >> > Doesn't look like the descriptors are as nice as you're trying to
> >> > paint them (with clear hash/csum fields) :-) So not sure how much
> >> > CO-RE would help.
> >> > At least looking at mlx4 rx_csum, the driver consults three differen=
t
> >> > sets of flags to figure out the hash_type. Or am I just unlucky with
> >> > mlx4?
> >>
> >> Which part are you talking about ?
> >>         hw_checksum =3D csum_unfold((__force __sum16)cqe->checksum);
> >> is trivial enough for bpf prog to do if it has access to 'cqe' pointer
> >> which is what John is proposing (I think).
> >
> > I'm talking about mlx4_en_process_rx_cq, the caller of that check_csum.
> > In particular: if (likely(dev->features & NETIF_F_RXCSUM)) branch
> > I'm assuming we want to have hash_type available to the progs?
>
> I agree we should expose the hash_type, but that doesn't actually look
> to be that complicated, see below.
>
> > But also, check_csum handles other corner cases:
> > - short_frame: we simply force all those small frames to skip checksum =
complete
> > - get_fixed_ipv6_csum: In IPv6 packets, hw_checksum lacks 6 bytes from
> > IPv6 header
> > - get_fixed_ipv4_csum: Although the stack expects checksum which
> > doesn't include the pseudo header, the HW adds it
> >
> > So it doesn't look like we can just unconditionally use cqe->checksum?
> > The driver does a lot of massaging around that field to make it
> > palatable.
>
> Poking around a bit in the other drivers, AFAICT it's only a subset of
> drivers that support CSUM_COMPLETE at all; for instance, the Intel
> drivers just set CHECKSUM_UNNECESSARY for TCP/UDP/SCTP. I think the
> CHECKSUM_UNNECESSARY is actually the most important bit we'd want to
> propagate?
>
> AFAICT, the drivers actually implementing CHECKSUM_COMPLETE need access
> to other data structures than the rx descriptor to determine the status
> of the checksum (mlx4 looks at priv->flags, mlx5 checks rq->state), so
> just exposing the rx descriptor to BPF as John is suggesting does not
> actually give the XDP program enough information to act on the checksum
> field on its own. We could still have a separate kfunc to just expose
> the hw checksum value (see below), but I think it probably needs to be
> paired with other kfuncs to be useful.
>
> Looking at the mlx4 code, I think the following mapping to kfuncs (in
> pseudo-C) would give the flexibility for XDP to access all the bits it
> needs, while inlining everything except getting the full checksum for
> non-TCP/UDP traffic. An (admittedly cursory) glance at some of the other
> drivers (mlx5, ice, i40e) indicates that this would work for those
> drivers as well.
>
>
> bpf_xdp_metadata_rx_hash_supported() {
>   return dev->features & NETIF_F_RXHASH;
> }
>
> bpf_xdp_metadata_rx_hash() {
>   return be32_to_cpu(cqe->immed_rss_invalid);
> }
>
> bpf_xdp_metdata_rx_hash_type() {
>   if (likely(dev->features & NETIF_F_RXCSUM) &&
>       (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP | MLX4_CQE_STATUS_UD=
P)) &&
>         (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
>           cqe->checksum =3D=3D cpu_to_be16(0xffff))
>      return PKT_HASH_TYPE_L4;
>
>    return PKT_HASH_TYPE_L3;
> }
>
> bpf_xdp_metadata_rx_csum_supported() {
>   return dev->features & NETIF_F_RXCSUM;
> }
>
> bpf_xdp_metadata_rx_csum_level() {
>         if ((cqe->status & cpu_to_be16(MLX4_CQE_STATUS_TCP |
>                                        MLX4_CQE_STATUS_UDP)) &&
>             (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IPOK)) &&
>             cqe->checksum =3D=3D cpu_to_be16(0xffff))
>             return CHECKSUM_UNNECESSARY;
>
>         if (!(priv->flags & MLX4_EN_FLAG_RX_CSUM_NON_TCP_UDP &&
>               (cqe->status & cpu_to_be16(MLX4_CQE_STATUS_IP_ANY))) &&
>               !short_frame(len))
>             return CHECKSUM_COMPLETE; /* we could also omit this case ent=
irely */
>
>         return CHECKSUM_NONE;
> }
>
> /* this one could be called by the metadata_to_skb code */
> bpf_xdp_metadata_rx_csum_full() {
>   return check_csum() /* BPF_CALL this after refactoring so it is skb-agn=
ostic */
> }
>
> /* this one would be for people like John who want to re-implement
>  * check_csum() themselves */
> bpf_xdp_metdata_rx_csum_raw() {
>   return cqe->checksum;
> }

Are you proposing a bunch of per-driver kfuncs that bpf prog will call.
If so that works, but bpf prog needs to pass dev and cqe pointers
into these kfuncs, so they need to be exposed to the prog somehow.
Probably through xdp_md ?
This way we can have both: bpf prog reading cqe fields directly
and using kfuncs to access things.
Inlining of kfuncs should be done generically.
It's not a driver job to convert native asm into bpf asm.
