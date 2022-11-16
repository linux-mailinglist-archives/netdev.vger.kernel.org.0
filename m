Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71AC62CF13
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiKPXrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiKPXrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:47:45 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C6E2716;
        Wed, 16 Nov 2022 15:47:36 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id b185so107219pfb.9;
        Wed, 16 Nov 2022 15:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLJQaG7Qw6Ti+p08DYseg+SMtZXW1ctvLXLNxYbwZGk=;
        b=RV31/9qGJoyH11CsSRT+796EmhhTwRGN8+K43aejf9/MNBfT88YDQVR/xxWgBBYhYn
         eL5DKydU60vWAj1WXSVHO7Yl573Azn5KIcynbx1Ew8lRlQJb59/nuWHmb4UYIsa4e6+b
         ECNOhSrbkRS+YnRfDdQ3XVXf2FwD5mKj3S2EqIAA+mIpOhtG+nC8AFWllH6gy4+X+cmO
         urgihTrpnGnXlfzoZWMCvIigIss3PsQrQKHoLOBkfH1JpFpWQdPTh8cVEbhfIHGMdpMb
         woFpvUAnfC1v/QeaNvUk90TZn6tvd1t8NQv4P8GgtlfMm3iSE1yss11ytuysA6AQhAWU
         3qMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hLJQaG7Qw6Ti+p08DYseg+SMtZXW1ctvLXLNxYbwZGk=;
        b=w4y9xqeoIo/MwUrr27OAz5fzH1sEI4QB0ZnXNTPAo0nJ4pOa2RdZ+8ilBTCB7A+hM7
         8U636jjHzrVgbp/enK33dQ/u/P2Z2+B9NQDyDCl7n2f6KXFHwmoeokFF3k27CTEnpkaH
         ysyIK4OoBW/rypenSd+O1GYyyM3KHSKE4Urw68J1RUXVLpsGX5/PfV+iqxZjTusP2U9J
         ZTOboKwB7rbGwOJfVWRzkZVpSGBTJZtgkg2ElFTCprVUB3+tFSZE8FUVyVe3uaosh+7F
         96VL0voFVu4eibAtrC8UcesZHtNK46+qXEcuQ+EdhikOqJJY3GtxkH1lRymfNYoQuvXD
         DuVg==
X-Gm-Message-State: ANoB5pk7/RMSRWwCqMx3CvN/O+eSfoCtx8kj6OtrAobu5phpOrEE8vi+
        mhiY3008ld7Z7gLDgKOI3ZY=
X-Google-Smtp-Source: AA0mqf7YyM/iuvPhwjLw1yrZTYDMDWlo8jWH6hOpE6JfhtgUugDiJiMpDW1M+trvLXv+ZCBHkgztBg==
X-Received: by 2002:a05:6a00:3029:b0:572:8c05:6e2c with SMTP id ay41-20020a056a00302900b005728c056e2cmr271053pfb.85.1668642455984;
        Wed, 16 Nov 2022 15:47:35 -0800 (PST)
Received: from localhost ([2605:59c8:47b:5f10:f84c:a7c:cb7a:c7f7])
        by smtp.gmail.com with ESMTPSA id h3-20020a056a00000300b0056c6c63fda6sm11439082pfk.3.2022.11.16.15.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 15:47:35 -0800 (PST)
Date:   Wed, 16 Nov 2022 15:47:34 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Message-ID: <637576962dada_8cd03208b0@john.notmuch>
In-Reply-To: <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
References: <20221115030210.3159213-1-sdf@google.com>
 <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk>
 <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk>
 <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch>
 <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk>
 <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
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
> On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > Martin KaFai Lau <martin.lau@linux.dev> writes:
> > >
> > > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > > >>>>>>> +static void veth_unroll_kfunc(const struct bpf_prog *prog,=
 u32 func_id,
> > > >>>>>>> +                           struct bpf_patch *patch)
> > > >>>>>>> +{
> > > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA=
_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > >>>>>>> +             /* return true; */
> > > >>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG=
_0, 1));
> > > >>>>>>> +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_M=
ETADATA_KFUNC_RX_TIMESTAMP)) {
> > > >>>>>>> +             /* return ktime_get_mono_fast_ns(); */
> > > >>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_g=
et_mono_fast_ns));
> > > >>>>>>> +     }
> > > >>>>>>> +}
> > > >>>>>>
> > > >>>>>> So these look reasonable enough, but would be good to see so=
me examples
> > > >>>>>> of kfunc implementations that don't just BPF_CALL to a kerne=
l function
> > > >>>>>> (with those helper wrappers we were discussing before).
> > > >>>>>
> > > >>>>> Let's maybe add them if/when needed as we add more metadata s=
upport?
> > > >>>>> xdp_metadata_export_to_skb has an example, and rfc 1/2 have m=
ore
> > > >>>>> examples, so it shouldn't be a problem to resurrect them back=
 at some
> > > >>>>> point?
> > > >>>>
> > > >>>> Well, the reason I asked for them is that I think having to ma=
intain the
> > > >>>> BPF code generation in the drivers is probably the biggest dra=
wback of
> > > >>>> the kfunc approach, so it would be good to be relatively sure =
that we
> > > >>>> can manage that complexity (via helpers) before we commit to t=
his :)
> > > >>>
> > > >>> Right, and I've added a bunch of examples in v2 rfc so we can j=
udge
> > > >>> whether that complexity is manageable or not :-)
> > > >>> Do you want me to add those wrappers you've back without any re=
al users?
> > > >>> Because I had to remove my veth tstamp accessors due to John/Je=
sper
> > > >>> objections; I can maybe bring some of this back gated by some
> > > >>> static_branch to avoid the fastpath cost?
> > > >>
> > > >> I missed the context a bit what did you mean "would be good to s=
ee some
> > > >> examples of kfunc implementations that don't just BPF_CALL to a =
kernel
> > > >> function"? In this case do you mean BPF code directly without th=
e call?
> > > >>
> > > >> Early on I thought we should just expose the rx_descriptor which=
 would
> > > >> be roughly the same right? (difference being code embedded in dr=
iver vs
> > > >> a lib) Trouble I ran into is driver code using seqlock_t and mut=
exs
> > > >> which wasn't as straight forward as the simpler just read it fro=
m
> > > >> the descriptor. For example in mlx getting the ts would be easy =
from
> > > >> BPF with the mlx4_cqe struct exposed
> > > >>
> > > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > > >> {
> > > >>          u64 hi, lo;
> > > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4_ts_cqe *)cq=
e;
> > > >>
> > > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_lo);
> > > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !lo) <=
< 16;
> > > >>
> > > >>          return hi | lo;
> > > >> }
> > > >>
> > > >> but converting that to nsec is a bit annoying,
> > > >>
> > > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > > >>                              struct skb_shared_hwtstamps *hwts,
> > > >>                              u64 timestamp)
> > > >> {
> > > >>          unsigned int seq;
> > > >>          u64 nsec;
> > > >>
> > > >>          do {
> > > >>                  seq =3D read_seqbegin(&mdev->clock_lock);
> > > >>                  nsec =3D timecounter_cyc2time(&mdev->clock, tim=
estamp);
> > > >>          } while (read_seqretry(&mdev->clock_lock, seq));
> > > >>
> > > >>          memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
> > > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > > >> }
> > > >>
> > > >> I think the nsec is what you really want.
> > > >>
> > > >> With all the drivers doing slightly different ops we would have
> > > >> to create read_seqbegin, read_seqretry, mutex_lock, ... to get
> > > >> at least the mlx and ice drivers it looks like we would need som=
e
> > > >> more BPF primitives/helpers. Looks like some more work is needed=

> > > >> on ice driver though to get rx tstamps on all packets.
> > > >>
> > > >> Anyways this convinced me real devices will probably use BPF_CAL=
L
> > > >> and not BPF insns directly.
> > > >
> > > > Some of the mlx5 path looks like this:
> > > >
> > > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + ((u6=
4)low))
> > > >
> > > > static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *=
clock,
> > > >                                                u64 timestamp)
> > > > {
> > > >          u64 time =3D REAL_TIME_TO_NS(timestamp >> 32, timestamp =
& 0xFFFFFFFF);
> > > >
> > > >          return ns_to_ktime(time);
> > > > }
> > > >
> > > > If some hints are harder to get, then just doing a kfunc call is =
better.
> > >
> > > Sure, but if we end up having a full function call for every field =
in
> > > the metadata, that will end up having a significant performance imp=
act
> > > on the XDP data path (thinking mostly about the skb metadata case h=
ere,
> > > which will collect several bits of metadata).
> > >
> > > > csum may have a better chance to inline?
> > >
> > > Yup, I agree. Including that also makes it possible to benchmark th=
is
> > > series against Jesper's; which I think we should definitely be doin=
g
> > > before merging this.
> >
> > Good point I got sort of singularly focused on timestamp because I ha=
ve
> > a use case for it now.
> >
> > Also hash is often sitting in the rx descriptor.
> =

> Ack, let me try to add something else (that's more inline-able) on the
> rx side for a v2.

If you go with in-kernel BPF kfunc approach (vs user space side) I think
you also need to add CO-RE to be friendly for driver developers? Otherwis=
e
they have to keep that read in sync with the descriptors? Also need to
handle versioning of descriptors where depending on specific options
and firmware and chip being enabled the descriptor might be moving
around. Of course can push this all to developer, but seems not so
nice when we have the machinery to do this and we handle it for all
other structures.

With CO-RE you can simply do the rx_desc->hash and rx_desc->csum and
expect CO-RE sorts it out based on currently running btf_id of the
descriptor. If you go through normal path you get this for free of
course.

.John=
