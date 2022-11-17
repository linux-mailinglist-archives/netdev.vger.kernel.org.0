Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D49E62CF64
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiKQATd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:19:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbiKQAT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:19:28 -0500
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1125645EF1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:19:27 -0800 (PST)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-13be3ef361dso373396fac.12
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 16:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9TyfACSP5CqF7d2bU0CR499dqnJ0ios8jlp6awifBbA=;
        b=QMh1jxbmXAlGrPRYJzRrdSZvo8/qsta5NZeB7ogVkdggT3zXN8WtZwiCmncdXyNXv9
         fT7T+cz1CuHRmrpJIT4FCo8nvMfcNXgVMewB7wKwd0jlXSlqQWB5KdEz+/zjwpPvYQ3t
         4o4ZkCjVlTvmlCeSJl2XybJ82DnRpSx/aJXzWsx4NwLxbtpAR2TQjbqDqnhqGvHFRqdJ
         WxBCSMauFzqZ5kjUUhRDwJmIb4peATuiAjpNlfoud6E9dqnj4i6dPihLLZbjTH67SpMI
         golmjyGFBaJN7oDRVDUt4eGRj9lITu40jL6k8HKy1JPPGTfYT/J1CevDPQcqLoiz3haj
         A8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9TyfACSP5CqF7d2bU0CR499dqnJ0ios8jlp6awifBbA=;
        b=mulQT9YuaGaWt1EULYcAsOoSuiZSbTZ5PE5/XCBfIg9zg+fv7wM8/3hkUnWzHs13qp
         mlxlOl0L0v0gFcRmheRitR5BKJMd45u+ecz5f+xkWjvxUToedX531zhOV+uOu5KI5SVf
         Ovl0uK4GPzQskgQ9hLU7YA9DXh2eFmQbl2ThI2kqk3No5Vo7GaKAU21m/i038cF2kerO
         TH25DwPDfw2RAatoK+mksTkp6vciOrjqJUZe0U7Xz82HpUYJ352roLRF1qcEMz3ePHyb
         cqUN6hv7QAJfsJGymd5UpHBfaKRBrSj7wr7AUfv80RAvlQIUAGdp7r4fO0q1AuNDwjyo
         ekwQ==
X-Gm-Message-State: ANoB5plWq2qQCXBG1qwyemuIb9br99YQRAvVjHvNXD91Hwl99Z5znHiT
        7gakP1PpMgEd036uGU3BeK7wJLRzd95AueC3XVxX5w==
X-Google-Smtp-Source: AA0mqf6W+h9P6ndCz0Dggo99+ASBIRvPTwqdxKgS71+gKGygKFJU/nFdcZ8e+IYnspiA5M16G/tzdKWR3tPtJqvust0=
X-Received: by 2002:a05:6870:9d95:b0:13b:a163:ca6 with SMTP id
 pv21-20020a0568709d9500b0013ba1630ca6mr3240757oab.125.1668644366268; Wed, 16
 Nov 2022 16:19:26 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com> <637576962dada_8cd03208b0@john.notmuch>
In-Reply-To: <637576962dada_8cd03208b0@john.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 16 Nov 2022 16:19:15 -0800
Message-ID: <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     John Fastabend <john.fastabend@gmail.com>
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

On Wed, Nov 16, 2022 at 3:47 PM John Fastabend <john.fastabend@gmail.com> w=
rote:
>
> Stanislav Fomichev wrote:
> > On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > > Martin KaFai Lau <martin.lau@linux.dev> writes:
> > > >
> > > > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > > > >>>>>>> +static void veth_unroll_kfunc(const struct bpf_prog *prog,=
 u32 func_id,
> > > > >>>>>>> +                           struct bpf_patch *patch)
> > > > >>>>>>> +{
> > > > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA=
_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > > >>>>>>> +             /* return true; */
> > > > >>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG=
_0, 1));
> > > > >>>>>>> +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_M=
ETADATA_KFUNC_RX_TIMESTAMP)) {
> > > > >>>>>>> +             /* return ktime_get_mono_fast_ns(); */
> > > > >>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_g=
et_mono_fast_ns));
> > > > >>>>>>> +     }
> > > > >>>>>>> +}
> > > > >>>>>>
> > > > >>>>>> So these look reasonable enough, but would be good to see so=
me examples
> > > > >>>>>> of kfunc implementations that don't just BPF_CALL to a kerne=
l function
> > > > >>>>>> (with those helper wrappers we were discussing before).
> > > > >>>>>
> > > > >>>>> Let's maybe add them if/when needed as we add more metadata s=
upport?
> > > > >>>>> xdp_metadata_export_to_skb has an example, and rfc 1/2 have m=
ore
> > > > >>>>> examples, so it shouldn't be a problem to resurrect them back=
 at some
> > > > >>>>> point?
> > > > >>>>
> > > > >>>> Well, the reason I asked for them is that I think having to ma=
intain the
> > > > >>>> BPF code generation in the drivers is probably the biggest dra=
wback of
> > > > >>>> the kfunc approach, so it would be good to be relatively sure =
that we
> > > > >>>> can manage that complexity (via helpers) before we commit to t=
his :)
> > > > >>>
> > > > >>> Right, and I've added a bunch of examples in v2 rfc so we can j=
udge
> > > > >>> whether that complexity is manageable or not :-)
> > > > >>> Do you want me to add those wrappers you've back without any re=
al users?
> > > > >>> Because I had to remove my veth tstamp accessors due to John/Je=
sper
> > > > >>> objections; I can maybe bring some of this back gated by some
> > > > >>> static_branch to avoid the fastpath cost?
> > > > >>
> > > > >> I missed the context a bit what did you mean "would be good to s=
ee some
> > > > >> examples of kfunc implementations that don't just BPF_CALL to a =
kernel
> > > > >> function"? In this case do you mean BPF code directly without th=
e call?
> > > > >>
> > > > >> Early on I thought we should just expose the rx_descriptor which=
 would
> > > > >> be roughly the same right? (difference being code embedded in dr=
iver vs
> > > > >> a lib) Trouble I ran into is driver code using seqlock_t and mut=
exs
> > > > >> which wasn't as straight forward as the simpler just read it fro=
m
> > > > >> the descriptor. For example in mlx getting the ts would be easy =
from
> > > > >> BPF with the mlx4_cqe struct exposed
> > > > >>
> > > > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > > > >> {
> > > > >>          u64 hi, lo;
> > > > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4_ts_cqe *)cq=
e;
> > > > >>
> > > > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_lo);
> > > > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !lo) <=
< 16;
> > > > >>
> > > > >>          return hi | lo;
> > > > >> }
> > > > >>
> > > > >> but converting that to nsec is a bit annoying,
> > > > >>
> > > > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > > > >>                              struct skb_shared_hwtstamps *hwts,
> > > > >>                              u64 timestamp)
> > > > >> {
> > > > >>          unsigned int seq;
> > > > >>          u64 nsec;
> > > > >>
> > > > >>          do {
> > > > >>                  seq =3D read_seqbegin(&mdev->clock_lock);
> > > > >>                  nsec =3D timecounter_cyc2time(&mdev->clock, tim=
estamp);
> > > > >>          } while (read_seqretry(&mdev->clock_lock, seq));
> > > > >>
> > > > >>          memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
> > > > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > > > >> }
> > > > >>
> > > > >> I think the nsec is what you really want.
> > > > >>
> > > > >> With all the drivers doing slightly different ops we would have
> > > > >> to create read_seqbegin, read_seqretry, mutex_lock, ... to get
> > > > >> at least the mlx and ice drivers it looks like we would need som=
e
> > > > >> more BPF primitives/helpers. Looks like some more work is needed
> > > > >> on ice driver though to get rx tstamps on all packets.
> > > > >>
> > > > >> Anyways this convinced me real devices will probably use BPF_CAL=
L
> > > > >> and not BPF insns directly.
> > > > >
> > > > > Some of the mlx5 path looks like this:
> > > > >
> > > > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + ((u6=
4)low))
> > > > >
> > > > > static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *=
clock,
> > > > >                                                u64 timestamp)
> > > > > {
> > > > >          u64 time =3D REAL_TIME_TO_NS(timestamp >> 32, timestamp =
& 0xFFFFFFFF);
> > > > >
> > > > >          return ns_to_ktime(time);
> > > > > }
> > > > >
> > > > > If some hints are harder to get, then just doing a kfunc call is =
better.
> > > >
> > > > Sure, but if we end up having a full function call for every field =
in
> > > > the metadata, that will end up having a significant performance imp=
act
> > > > on the XDP data path (thinking mostly about the skb metadata case h=
ere,
> > > > which will collect several bits of metadata).
> > > >
> > > > > csum may have a better chance to inline?
> > > >
> > > > Yup, I agree. Including that also makes it possible to benchmark th=
is
> > > > series against Jesper's; which I think we should definitely be doin=
g
> > > > before merging this.
> > >
> > > Good point I got sort of singularly focused on timestamp because I ha=
ve
> > > a use case for it now.
> > >
> > > Also hash is often sitting in the rx descriptor.
> >
> > Ack, let me try to add something else (that's more inline-able) on the
> > rx side for a v2.
>
> If you go with in-kernel BPF kfunc approach (vs user space side) I think
> you also need to add CO-RE to be friendly for driver developers? Otherwis=
e
> they have to keep that read in sync with the descriptors? Also need to
> handle versioning of descriptors where depending on specific options
> and firmware and chip being enabled the descriptor might be moving
> around. Of course can push this all to developer, but seems not so
> nice when we have the machinery to do this and we handle it for all
> other structures.
>
> With CO-RE you can simply do the rx_desc->hash and rx_desc->csum and
> expect CO-RE sorts it out based on currently running btf_id of the
> descriptor. If you go through normal path you get this for free of
> course.

Doesn't look like the descriptors are as nice as you're trying to
paint them (with clear hash/csum fields) :-) So not sure how much
CO-RE would help.
At least looking at mlx4 rx_csum, the driver consults three different
sets of flags to figure out the hash_type. Or am I just unlucky with
mlx4?
