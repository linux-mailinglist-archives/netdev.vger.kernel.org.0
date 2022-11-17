Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D6D62D14D
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbiKQCyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239143AbiKQCxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:53:51 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3187B4876C
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 18:53:48 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id b124so522662oia.4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 18:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1WiWI19YoHyMhnLxSGvNdwVK87PQdtocGJoZYJrP8w=;
        b=nv4UF/qgrmqTzrar//wrdDt98dkonq6j8OlyfQJnrhLCbJR3RKkUefl7U8OFl16bRf
         nVZYl7gJwq03vaxFt5e3hjlWUbq8IiP174cBTMMlf8YkdaPuW0UMLesal+1z3gTLtbzD
         LAfKx6pj4HeQjkMMZsisFFtRTMB1/7AwQl29BCyzHjLaPWDwak1nsfy7FhqMf0vOvmI4
         BSSZzBOdjIDFmoZCxWuxQKaCJwvooSCWnxnB0hWNwQl7TVfgnLy4lLq4VFFMs9lhLYvM
         n1m9kBPx4sxdyh0qTfRSDDHSD8wCiNm2tcd0YtT3wKtcOPLuYcSUp2SmZsDA1gwRNHsk
         CF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N1WiWI19YoHyMhnLxSGvNdwVK87PQdtocGJoZYJrP8w=;
        b=MNiQQ0n5DnJtVtXHGNUPiqnFlsZYrGynGd+JPnZtB3zbJ4K3kOibgxJZIP20ZYPXJ6
         yO1Vdw8fCrSqJynizxWhMz2txl7rvyQkkZZJsrj7s4tTq2X/8tG3+SzpvVB63m8G3135
         CLpsd9+Xt2hxY65+i9V0LRGhJx20BREdqOl8Rl4/419hAKiTN7dheoqOgeK4AENcFqdj
         aI3nXIOxV4YG4HWPgZkKclicK0fLlxM6jCP665ZTXd8Lpmfr3XRpZLaGk9Vmw/Jsra1m
         D9HOADHIizNf2gjFkaRfEN4K9SkGAbHMFZsj/W+wJQhl2UdnVF9bClWlAUvILK/VX/Ur
         1M7A==
X-Gm-Message-State: ANoB5pm47lwleNXwvyNsVmtxMoEnYoqcPVP9uYrGjo4cajBMGtQzIuXj
        3NLqneI1U2iailecGH7/g5mLJDdTsgw0SeVWKVVFYg==
X-Google-Smtp-Source: AA0mqf6znsj3SSKwj4NdK7G3r/Lu8/Wr7RkL1YYIscb75J6M13IY6mdHJYJBFwzG6Jzcnu1M1iRbHHPLARNf5ycfK5M=
X-Received: by 2002:aca:1802:0:b0:359:e812:69ee with SMTP id
 h2-20020aca1802000000b00359e81269eemr3215524oih.125.1668653627378; Wed, 16
 Nov 2022 18:53:47 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch> <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
In-Reply-To: <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 16 Nov 2022 18:53:36 -0800
Message-ID: <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Wed, Nov 16, 2022 at 6:17 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Nov 16, 2022 at 4:19 PM Stanislav Fomichev <sdf@google.com> wrote=
:
> >
> > On Wed, Nov 16, 2022 at 3:47 PM John Fastabend <john.fastabend@gmail.co=
m> wrote:
> > >
> > > Stanislav Fomichev wrote:
> > > > On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
> > > > <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > > > > Martin KaFai Lau <martin.lau@linux.dev> writes:
> > > > > >
> > > > > > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > > > > > >>>>>>> +static void veth_unroll_kfunc(const struct bpf_prog *p=
rog, u32 func_id,
> > > > > > >>>>>>> +                           struct bpf_patch *patch)
> > > > > > >>>>>>> +{
> > > > > > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_META=
DATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > > > > >>>>>>> +             /* return true; */
> > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF=
_REG_0, 1));
> > > > > > >>>>>>> +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(X=
DP_METADATA_KFUNC_RX_TIMESTAMP)) {
> > > > > > >>>>>>> +             /* return ktime_get_mono_fast_ns(); */
> > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL(kti=
me_get_mono_fast_ns));
> > > > > > >>>>>>> +     }
> > > > > > >>>>>>> +}
> > > > > > >>>>>>
> > > > > > >>>>>> So these look reasonable enough, but would be good to se=
e some examples
> > > > > > >>>>>> of kfunc implementations that don't just BPF_CALL to a k=
ernel function
> > > > > > >>>>>> (with those helper wrappers we were discussing before).
> > > > > > >>>>>
> > > > > > >>>>> Let's maybe add them if/when needed as we add more metada=
ta support?
> > > > > > >>>>> xdp_metadata_export_to_skb has an example, and rfc 1/2 ha=
ve more
> > > > > > >>>>> examples, so it shouldn't be a problem to resurrect them =
back at some
> > > > > > >>>>> point?
> > > > > > >>>>
> > > > > > >>>> Well, the reason I asked for them is that I think having t=
o maintain the
> > > > > > >>>> BPF code generation in the drivers is probably the biggest=
 drawback of
> > > > > > >>>> the kfunc approach, so it would be good to be relatively s=
ure that we
> > > > > > >>>> can manage that complexity (via helpers) before we commit =
to this :)
> > > > > > >>>
> > > > > > >>> Right, and I've added a bunch of examples in v2 rfc so we c=
an judge
> > > > > > >>> whether that complexity is manageable or not :-)
> > > > > > >>> Do you want me to add those wrappers you've back without an=
y real users?
> > > > > > >>> Because I had to remove my veth tstamp accessors due to Joh=
n/Jesper
> > > > > > >>> objections; I can maybe bring some of this back gated by so=
me
> > > > > > >>> static_branch to avoid the fastpath cost?
> > > > > > >>
> > > > > > >> I missed the context a bit what did you mean "would be good =
to see some
> > > > > > >> examples of kfunc implementations that don't just BPF_CALL t=
o a kernel
> > > > > > >> function"? In this case do you mean BPF code directly withou=
t the call?
> > > > > > >>
> > > > > > >> Early on I thought we should just expose the rx_descriptor w=
hich would
> > > > > > >> be roughly the same right? (difference being code embedded i=
n driver vs
> > > > > > >> a lib) Trouble I ran into is driver code using seqlock_t and=
 mutexs
> > > > > > >> which wasn't as straight forward as the simpler just read it=
 from
> > > > > > >> the descriptor. For example in mlx getting the ts would be e=
asy from
> > > > > > >> BPF with the mlx4_cqe struct exposed
> > > > > > >>
> > > > > > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > > > > > >> {
> > > > > > >>          u64 hi, lo;
> > > > > > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4_ts_cqe =
*)cqe;
> > > > > > >>
> > > > > > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_lo);
> > > > > > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !l=
o) << 16;
> > > > > > >>
> > > > > > >>          return hi | lo;
> > > > > > >> }
> > > > > > >>
> > > > > > >> but converting that to nsec is a bit annoying,
> > > > > > >>
> > > > > > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > > > > > >>                              struct skb_shared_hwtstamps *hw=
ts,
> > > > > > >>                              u64 timestamp)
> > > > > > >> {
> > > > > > >>          unsigned int seq;
> > > > > > >>          u64 nsec;
> > > > > > >>
> > > > > > >>          do {
> > > > > > >>                  seq =3D read_seqbegin(&mdev->clock_lock);
> > > > > > >>                  nsec =3D timecounter_cyc2time(&mdev->clock,=
 timestamp);
> > > > > > >>          } while (read_seqretry(&mdev->clock_lock, seq));
> > > > > > >>
> > > > > > >>          memset(hwts, 0, sizeof(struct skb_shared_hwtstamps)=
);
> > > > > > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > > > > > >> }
> > > > > > >>
> > > > > > >> I think the nsec is what you really want.
> > > > > > >>
> > > > > > >> With all the drivers doing slightly different ops we would h=
ave
> > > > > > >> to create read_seqbegin, read_seqretry, mutex_lock, ... to g=
et
> > > > > > >> at least the mlx and ice drivers it looks like we would need=
 some
> > > > > > >> more BPF primitives/helpers. Looks like some more work is ne=
eded
> > > > > > >> on ice driver though to get rx tstamps on all packets.
> > > > > > >>
> > > > > > >> Anyways this convinced me real devices will probably use BPF=
_CALL
> > > > > > >> and not BPF insns directly.
> > > > > > >
> > > > > > > Some of the mlx5 path looks like this:
> > > > > > >
> > > > > > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + =
((u64)low))
> > > > > > >
> > > > > > > static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clo=
ck *clock,
> > > > > > >                                                u64 timestamp)
> > > > > > > {
> > > > > > >          u64 time =3D REAL_TIME_TO_NS(timestamp >> 32, timest=
amp & 0xFFFFFFFF);
> > > > > > >
> > > > > > >          return ns_to_ktime(time);
> > > > > > > }
> > > > > > >
> > > > > > > If some hints are harder to get, then just doing a kfunc call=
 is better.
> > > > > >
> > > > > > Sure, but if we end up having a full function call for every fi=
eld in
> > > > > > the metadata, that will end up having a significant performance=
 impact
> > > > > > on the XDP data path (thinking mostly about the skb metadata ca=
se here,
> > > > > > which will collect several bits of metadata).
> > > > > >
> > > > > > > csum may have a better chance to inline?
> > > > > >
> > > > > > Yup, I agree. Including that also makes it possible to benchmar=
k this
> > > > > > series against Jesper's; which I think we should definitely be =
doing
> > > > > > before merging this.
> > > > >
> > > > > Good point I got sort of singularly focused on timestamp because =
I have
> > > > > a use case for it now.
> > > > >
> > > > > Also hash is often sitting in the rx descriptor.
> > > >
> > > > Ack, let me try to add something else (that's more inline-able) on =
the
> > > > rx side for a v2.
> > >
> > > If you go with in-kernel BPF kfunc approach (vs user space side) I th=
ink
> > > you also need to add CO-RE to be friendly for driver developers? Othe=
rwise
> > > they have to keep that read in sync with the descriptors? Also need t=
o
> > > handle versioning of descriptors where depending on specific options
> > > and firmware and chip being enabled the descriptor might be moving
> > > around. Of course can push this all to developer, but seems not so
> > > nice when we have the machinery to do this and we handle it for all
> > > other structures.
> > >
> > > With CO-RE you can simply do the rx_desc->hash and rx_desc->csum and
> > > expect CO-RE sorts it out based on currently running btf_id of the
> > > descriptor. If you go through normal path you get this for free of
> > > course.
> >
> > Doesn't look like the descriptors are as nice as you're trying to
> > paint them (with clear hash/csum fields) :-) So not sure how much
> > CO-RE would help.
> > At least looking at mlx4 rx_csum, the driver consults three different
> > sets of flags to figure out the hash_type. Or am I just unlucky with
> > mlx4?
>
> Which part are you talking about ?
>         hw_checksum =3D csum_unfold((__force __sum16)cqe->checksum);
> is trivial enough for bpf prog to do if it has access to 'cqe' pointer
> which is what John is proposing (I think).

I'm talking about mlx4_en_process_rx_cq, the caller of that check_csum.
In particular: if (likely(dev->features & NETIF_F_RXCSUM)) branch
I'm assuming we want to have hash_type available to the progs?

But also, check_csum handles other corner cases:
- short_frame: we simply force all those small frames to skip checksum comp=
lete
- get_fixed_ipv6_csum: In IPv6 packets, hw_checksum lacks 6 bytes from
IPv6 header
- get_fixed_ipv4_csum: Although the stack expects checksum which
doesn't include the pseudo header, the HW adds it

So it doesn't look like we can just unconditionally use cqe->checksum?
The driver does a lot of massaging around that field to make it
palatable.
