Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001B162D112
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbiKQCR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKQCR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:17:57 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805C3C779;
        Wed, 16 Nov 2022 18:17:54 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id k2so1733671ejr.2;
        Wed, 16 Nov 2022 18:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeytEidfg15z3/Kw1ktwj9CpONuWGAQGvGODy3kxHnY=;
        b=c/Tv2c61i2D66P7Kb2wyOGck/L6qhzrUL0My7v4/oFLEi+htJTSRd/SHiGwaEf7uty
         gSNu3v0ptlwDxAhU/iI7sL4Or7EXZXAj6OCFe2/oaGapnmAelkSWoIDnrbxgj8gBELuK
         uAoWqA8DOutThFxlH7BcfAjP36ZOolKYTSzD+2j/fLAfQwA3dX/3/9qDY0iQ5XP0HkiP
         wzWZZRNTpxiaMHByrRQzR1IYvXYTZsdRK4/2aEcWwMztum1OGLwOoimsQbemXAfioyPR
         s5Bmv9vytJiWtvlkHwXbv4wizo5bjr44nsOIblv6TPuZzvWwjC3sGxsDB3bNSB51DB2L
         iuvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeytEidfg15z3/Kw1ktwj9CpONuWGAQGvGODy3kxHnY=;
        b=Xm2qmcQj2shmec+DZjElk4NMb7CRt0n3Ydgxn1yTeE5j2eXoagxJOeewbmg7VYDP+5
         h783M+I8nuwPkZ3ZpL53CCI2N8xEG5v3+/61mrI38k0eN/w1uwW69qsq63trI9qRfM4M
         Q0wolyjJLjXW+AHBxq/2UwACplDlWGBMTZEUK0G2JI84yoBUbNQxjJDEkMFSCm9lXsjK
         uq9LZSEWrw4QLcbyKh98CfW3aNVK/0cMyMufBLwvmU8tsyyEUm4s+d+lBW2kYBvAtfp9
         tyB88WRAcNKQHidzJfQl0U+kySVDjUFHdrAeoh7Af2FnWm4pcNxGapqegpha+J+JwD0m
         Lliw==
X-Gm-Message-State: ANoB5pmYE+QNdrn/SgROBpq3D79HsChyJYdg2zAr8ab6GkMQ+TTNAvL0
        H1ypd3Q7fqawxwSdK3L//HtmGLmv/UlHLCuKE/4=
X-Google-Smtp-Source: AA0mqf4+ANk95VTDlgtbyy0jqe3omnZdq2vpU3YAZkeLykrRKdTF8i/UPdIoYxa2UhcbnfldSIhUpAAezbRvpdl+edQ=
X-Received: by 2002:a17:906:4351:b0:78d:513d:f447 with SMTP id
 z17-20020a170906435100b0078d513df447mr444304ejm.708.1668651472434; Wed, 16
 Nov 2022 18:17:52 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch> <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
In-Reply-To: <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 16 Nov 2022 18:17:40 -0800
Message-ID: <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     Stanislav Fomichev <sdf@google.com>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 4:19 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Wed, Nov 16, 2022 at 3:47 PM John Fastabend <john.fastabend@gmail.com>=
 wrote:
> >
> > Stanislav Fomichev wrote:
> > > On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
> > > <john.fastabend@gmail.com> wrote:
> > > >
> > > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > > > Martin KaFai Lau <martin.lau@linux.dev> writes:
> > > > >
> > > > > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > > > > >>>>>>> +static void veth_unroll_kfunc(const struct bpf_prog *pro=
g, u32 func_id,
> > > > > >>>>>>> +                           struct bpf_patch *patch)
> > > > > >>>>>>> +{
> > > > > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADA=
TA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > > > >>>>>>> +             /* return true; */
> > > > > >>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_R=
EG_0, 1));
> > > > > >>>>>>> +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP=
_METADATA_KFUNC_RX_TIMESTAMP)) {
> > > > > >>>>>>> +             /* return ktime_get_mono_fast_ns(); */
> > > > > >>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime=
_get_mono_fast_ns));
> > > > > >>>>>>> +     }
> > > > > >>>>>>> +}
> > > > > >>>>>>
> > > > > >>>>>> So these look reasonable enough, but would be good to see =
some examples
> > > > > >>>>>> of kfunc implementations that don't just BPF_CALL to a ker=
nel function
> > > > > >>>>>> (with those helper wrappers we were discussing before).
> > > > > >>>>>
> > > > > >>>>> Let's maybe add them if/when needed as we add more metadata=
 support?
> > > > > >>>>> xdp_metadata_export_to_skb has an example, and rfc 1/2 have=
 more
> > > > > >>>>> examples, so it shouldn't be a problem to resurrect them ba=
ck at some
> > > > > >>>>> point?
> > > > > >>>>
> > > > > >>>> Well, the reason I asked for them is that I think having to =
maintain the
> > > > > >>>> BPF code generation in the drivers is probably the biggest d=
rawback of
> > > > > >>>> the kfunc approach, so it would be good to be relatively sur=
e that we
> > > > > >>>> can manage that complexity (via helpers) before we commit to=
 this :)
> > > > > >>>
> > > > > >>> Right, and I've added a bunch of examples in v2 rfc so we can=
 judge
> > > > > >>> whether that complexity is manageable or not :-)
> > > > > >>> Do you want me to add those wrappers you've back without any =
real users?
> > > > > >>> Because I had to remove my veth tstamp accessors due to John/=
Jesper
> > > > > >>> objections; I can maybe bring some of this back gated by some
> > > > > >>> static_branch to avoid the fastpath cost?
> > > > > >>
> > > > > >> I missed the context a bit what did you mean "would be good to=
 see some
> > > > > >> examples of kfunc implementations that don't just BPF_CALL to =
a kernel
> > > > > >> function"? In this case do you mean BPF code directly without =
the call?
> > > > > >>
> > > > > >> Early on I thought we should just expose the rx_descriptor whi=
ch would
> > > > > >> be roughly the same right? (difference being code embedded in =
driver vs
> > > > > >> a lib) Trouble I ran into is driver code using seqlock_t and m=
utexs
> > > > > >> which wasn't as straight forward as the simpler just read it f=
rom
> > > > > >> the descriptor. For example in mlx getting the ts would be eas=
y from
> > > > > >> BPF with the mlx4_cqe struct exposed
> > > > > >>
> > > > > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > > > > >> {
> > > > > >>          u64 hi, lo;
> > > > > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4_ts_cqe *)=
cqe;
> > > > > >>
> > > > > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_lo);
> > > > > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !lo)=
 << 16;
> > > > > >>
> > > > > >>          return hi | lo;
> > > > > >> }
> > > > > >>
> > > > > >> but converting that to nsec is a bit annoying,
> > > > > >>
> > > > > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > > > > >>                              struct skb_shared_hwtstamps *hwts=
,
> > > > > >>                              u64 timestamp)
> > > > > >> {
> > > > > >>          unsigned int seq;
> > > > > >>          u64 nsec;
> > > > > >>
> > > > > >>          do {
> > > > > >>                  seq =3D read_seqbegin(&mdev->clock_lock);
> > > > > >>                  nsec =3D timecounter_cyc2time(&mdev->clock, t=
imestamp);
> > > > > >>          } while (read_seqretry(&mdev->clock_lock, seq));
> > > > > >>
> > > > > >>          memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
> > > > > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > > > > >> }
> > > > > >>
> > > > > >> I think the nsec is what you really want.
> > > > > >>
> > > > > >> With all the drivers doing slightly different ops we would hav=
e
> > > > > >> to create read_seqbegin, read_seqretry, mutex_lock, ... to get
> > > > > >> at least the mlx and ice drivers it looks like we would need s=
ome
> > > > > >> more BPF primitives/helpers. Looks like some more work is need=
ed
> > > > > >> on ice driver though to get rx tstamps on all packets.
> > > > > >>
> > > > > >> Anyways this convinced me real devices will probably use BPF_C=
ALL
> > > > > >> and not BPF insns directly.
> > > > > >
> > > > > > Some of the mlx5 path looks like this:
> > > > > >
> > > > > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + ((=
u64)low))
> > > > > >
> > > > > > static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock=
 *clock,
> > > > > >                                                u64 timestamp)
> > > > > > {
> > > > > >          u64 time =3D REAL_TIME_TO_NS(timestamp >> 32, timestam=
p & 0xFFFFFFFF);
> > > > > >
> > > > > >          return ns_to_ktime(time);
> > > > > > }
> > > > > >
> > > > > > If some hints are harder to get, then just doing a kfunc call i=
s better.
> > > > >
> > > > > Sure, but if we end up having a full function call for every fiel=
d in
> > > > > the metadata, that will end up having a significant performance i=
mpact
> > > > > on the XDP data path (thinking mostly about the skb metadata case=
 here,
> > > > > which will collect several bits of metadata).
> > > > >
> > > > > > csum may have a better chance to inline?
> > > > >
> > > > > Yup, I agree. Including that also makes it possible to benchmark =
this
> > > > > series against Jesper's; which I think we should definitely be do=
ing
> > > > > before merging this.
> > > >
> > > > Good point I got sort of singularly focused on timestamp because I =
have
> > > > a use case for it now.
> > > >
> > > > Also hash is often sitting in the rx descriptor.
> > >
> > > Ack, let me try to add something else (that's more inline-able) on th=
e
> > > rx side for a v2.
> >
> > If you go with in-kernel BPF kfunc approach (vs user space side) I thin=
k
> > you also need to add CO-RE to be friendly for driver developers? Otherw=
ise
> > they have to keep that read in sync with the descriptors? Also need to
> > handle versioning of descriptors where depending on specific options
> > and firmware and chip being enabled the descriptor might be moving
> > around. Of course can push this all to developer, but seems not so
> > nice when we have the machinery to do this and we handle it for all
> > other structures.
> >
> > With CO-RE you can simply do the rx_desc->hash and rx_desc->csum and
> > expect CO-RE sorts it out based on currently running btf_id of the
> > descriptor. If you go through normal path you get this for free of
> > course.
>
> Doesn't look like the descriptors are as nice as you're trying to
> paint them (with clear hash/csum fields) :-) So not sure how much
> CO-RE would help.
> At least looking at mlx4 rx_csum, the driver consults three different
> sets of flags to figure out the hash_type. Or am I just unlucky with
> mlx4?

Which part are you talking about ?
        hw_checksum =3D csum_unfold((__force __sum16)cqe->checksum);
is trivial enough for bpf prog to do if it has access to 'cqe' pointer
which is what John is proposing (I think).
