Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18B562B373
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiKPGix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiKPGiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:38:11 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151A820BC4;
        Tue, 15 Nov 2022 22:38:03 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id o7so15684915pjj.1;
        Tue, 15 Nov 2022 22:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIc3+RIY7d97yigBT6m6AQ6R3emdA7PRnJWgakTYKg4=;
        b=MPpCV1kYtdWVpb1GUxXbGtwi88E/gYr7jaWZpSHNULkYE93sHVpMk5zXQViiCid/rt
         xHm7qoGClq8QoiQhAlT5DlcHiBcZqmEUj5EvL2H5rcWrCm6e03A25fPbRUzCe9Alu3+H
         y0YNYpw1l7slWwZ/OAJhoKyMaWfblolFAWfzX6HS7Bry4EgBcR3e15A8kk1xQEc3+WVU
         h4NdSkVkt8Sbwydfc0vbkz1uYP+EIFPNJ46XRNruHmgkbNgKHrtCSdfJ8WxznZoLjAZs
         u5TWRQJFM3GiYngRFAqCv/MeYyET86MeT5cpR6hDl3aQfioHGbGp50AR/xEYXzZUXc9N
         +FCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZIc3+RIY7d97yigBT6m6AQ6R3emdA7PRnJWgakTYKg4=;
        b=HAW+GmNbN02AuWynVIlIJlT/UIEhQeHn+zD0QtucVU3IGX5Yhyp2cdfumBIygq+Alb
         fo+NaGW+SXLEcBuCjOKTAueLysjkeeNiGbYaOj86672rKV8NlaGYfg6RXJF+V2hO4xqN
         hCICP1zexPRHFv2BDLVXCVkdJ1dNyGg5lnTy3EVpSiU9LMphSQF31C86bNcWOi/HPWBO
         h7hKgH1SzbE4P9OVdC9Q7DtH+aomiNJ3APDwSg4H4gZMVOwxwgw7ZItfFQdymYe1Ragm
         eV6fNLECcvsKEC2O7gL56NzWPDDv8rKJk680w7EKQTvWfIuQp4pMz18at0KtBJqd9AQo
         dOEA==
X-Gm-Message-State: ANoB5pnLaCoJfzuE9aDXK3H/pzQY1JtE1LyJrCVOMz0pfjYgsr849FJ6
        zwKGwBxTkWRv/2qNDkwxHsY=
X-Google-Smtp-Source: AA0mqf7Bd4vSxEjwLwUf7X/jxgPrYfN7jXbgv4IydiRWAKttYUaYglICmqsqHy0kev1KdBKe+lrKCA==
X-Received: by 2002:a17:903:25d5:b0:186:a2ef:7a69 with SMTP id jc21-20020a17090325d500b00186a2ef7a69mr7606784plb.77.1668580682466;
        Tue, 15 Nov 2022 22:38:02 -0800 (PST)
Received: from localhost ([2605:59c8:163:c10:44a4:6cfd:760b:2a1d])
        by smtp.gmail.com with ESMTPSA id p129-20020a622987000000b0055f209690c0sm9946316pfp.50.2022.11.15.22.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 22:38:01 -0800 (PST)
Date:   Tue, 15 Nov 2022 22:38:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Message-ID: <6374854883b22_5d64b208e3@john.notmuch>
In-Reply-To: <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk>
 <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
 <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
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

Stanislav Fomichev wrote:
> On Tue, Nov 15, 2022 at 2:46 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >
> > Stanislav Fomichev <sdf@google.com> writes:
> >
> > > On Tue, Nov 15, 2022 at 8:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <t=
oke@redhat.com> wrote:
> > >>
> > >> Stanislav Fomichev <sdf@google.com> writes:
> > >>
> > >> > The goal is to enable end-to-end testing of the metadata
> > >> > for AF_XDP. Current rx_timestamp kfunc returns current
> > >> > time which should be enough to exercise this new functionality.
> > >> >
> > >> > Cc: John Fastabend <john.fastabend@gmail.com>
> > >> > Cc: David Ahern <dsahern@gmail.com>
> > >> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
> > >> > Cc: Jakub Kicinski <kuba@kernel.org>
> > >> > Cc: Willem de Bruijn <willemb@google.com>
> > >> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > >> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> > >> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> > >> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> > >> > Cc: Maryam Tahhan <mtahhan@redhat.com>
> > >> > Cc: xdp-hints@xdp-project.net
> > >> > Cc: netdev@vger.kernel.org
> > >> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > >> > ---
> > >> >  drivers/net/veth.c | 14 ++++++++++++++
> > >> >  1 file changed, 14 insertions(+)
> > >> >
> > >> > diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> > >> > index 2a4592780141..c626580a2294 100644
> > >> > --- a/drivers/net/veth.c
> > >> > +++ b/drivers/net/veth.c
> > >> > @@ -25,6 +25,7 @@
> > >> >  #include <linux/filter.h>
> > >> >  #include <linux/ptr_ring.h>
> > >> >  #include <linux/bpf_trace.h>
> > >> > +#include <linux/bpf_patch.h>
> > >> >  #include <linux/net_tstamp.h>
> > >> >
> > >> >  #define DRV_NAME     "veth"
> > >> > @@ -1659,6 +1660,18 @@ static int veth_xdp(struct net_device *de=
v, struct netdev_bpf *xdp)
> > >> >       }
> > >> >  }
> > >> >
> > >> > +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 =
func_id,
> > >> > +                           struct bpf_patch *patch)
> > >> > +{
> > >> > +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_KFUN=
C_RX_TIMESTAMP_SUPPORTED)) {
> > >> > +             /* return true; */
> > >> > +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1=
));
> > >> > +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADA=
TA_KFUNC_RX_TIMESTAMP)) {
> > >> > +             /* return ktime_get_mono_fast_ns(); */
> > >> > +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_mo=
no_fast_ns));
> > >> > +     }
> > >> > +}
> > >>
> > >> So these look reasonable enough, but would be good to see some exa=
mples
> > >> of kfunc implementations that don't just BPF_CALL to a kernel func=
tion
> > >> (with those helper wrappers we were discussing before).
> > >
> > > Let's maybe add them if/when needed as we add more metadata support=
?
> > > xdp_metadata_export_to_skb has an example, and rfc 1/2 have more
> > > examples, so it shouldn't be a problem to resurrect them back at so=
me
> > > point?
> >
> > Well, the reason I asked for them is that I think having to maintain =
the
> > BPF code generation in the drivers is probably the biggest drawback o=
f
> > the kfunc approach, so it would be good to be relatively sure that we=

> > can manage that complexity (via helpers) before we commit to this :)
> =

> Right, and I've added a bunch of examples in v2 rfc so we can judge
> whether that complexity is manageable or not :-)
> Do you want me to add those wrappers you've back without any real users=
?
> Because I had to remove my veth tstamp accessors due to John/Jesper
> objections; I can maybe bring some of this back gated by some
> static_branch to avoid the fastpath cost?

I missed the context a bit what did you mean "would be good to see some
examples of kfunc implementations that don't just BPF_CALL to a kernel
function"? In this case do you mean BPF code directly without the call?

Early on I thought we should just expose the rx_descriptor which would
be roughly the same right? (difference being code embedded in driver vs
a lib) Trouble I ran into is driver code using seqlock_t and mutexs
which wasn't as straight forward as the simpler just read it from
the descriptor. For example in mlx getting the ts would be easy from
BPF with the mlx4_cqe struct exposed

u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
{
        u64 hi, lo;
        struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4_ts_cqe *)cqe;

        lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_lo);
        hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !lo) << 16;

        return hi | lo;
}

but converting that to nsec is a bit annoying,

void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
                            struct skb_shared_hwtstamps *hwts,
                            u64 timestamp)
{
        unsigned int seq;
        u64 nsec;

        do {
                seq =3D read_seqbegin(&mdev->clock_lock);
                nsec =3D timecounter_cyc2time(&mdev->clock, timestamp);
        } while (read_seqretry(&mdev->clock_lock, seq));

        memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
        hwts->hwtstamp =3D ns_to_ktime(nsec);
}

I think the nsec is what you really want.

With all the drivers doing slightly different ops we would have
to create read_seqbegin, read_seqretry, mutex_lock, ... to get
at least the mlx and ice drivers it looks like we would need some
more BPF primitives/helpers. Looks like some more work is needed
on ice driver though to get rx tstamps on all packets.

Anyways this convinced me real devices will probably use BPF_CALL
and not BPF insns directly.=
