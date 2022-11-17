Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA65062D243
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239164AbiKQETu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:19:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239299AbiKQETF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:19:05 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459EE5987E
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:19:00 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id t19-20020a9d7753000000b0066d77a3d474so358727otl.10
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qSak/qr/jY/us4DUA7PGCyWj/+vy2FzPRrnvD5aqAc=;
        b=T2Pp7hL70ckpmFZ3cuMkN80lidRix5ZYKaqjpXJKsUHYFZrCOT8OVeHCtt8AqNFWDY
         jbiQ98asIWLigYladzQDszTzozoFcwmj88lNW5fBH3Uzup7FhDUzilvr1Lk0fnQmBkXX
         PQB2jAL0gdIw275UKdXGYepw9I4Djv4sHh6JcKkxVn6BlaKZXR+L/pXB5+RDMSdHfblA
         nc/MmIFzAc9KHMn5qZ/CTjz3byAiVC7Y7FgaTE/M+7vuJ24d3u1mMyZhLAp2ZB8X70Ez
         PILsjPNCDUQZsSQAd7rB0LEvvkNJOYyIHL/XueVbR52SYN89TOUPKiN8qtCJdQlptn+6
         T3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qSak/qr/jY/us4DUA7PGCyWj/+vy2FzPRrnvD5aqAc=;
        b=cDoSkAh6A21h3jCPu3D+9A46yzXSkqw6KKtI7jxRf6dCE4oEH+og4LQbomUCdQaak/
         zENrP6T8scV7YOwgU8zZBTu8Wbk/+gzrA0/tbHwc/8+eBCSZtKgtCvKb5SLT85JeTonX
         Cm4icXNKfgbmpu1KlOmsCDddOdr6AU3P7mFl9/00xUqAwPafgP2hlEit5JGiOvsK6b8g
         I8VNzItZ+U1mbfB+wtY4X4jXM+hGzgHHAxiFD1iVFii6CQYq5nw//+LBRc0e+iwpC7le
         91CYXhs47IXBkUoiItP4bQuRYAutb0ujRBu2Tdth/Djwwsx/d4TRgMjoevQbOZMZkSRT
         t2bg==
X-Gm-Message-State: ANoB5pnL3ptFYxtOrQenpY44uFGrR0dCZyetZ/yU8G0nURBHrkkVLREH
        3kqepwJ4F7sANZrImX/REXA2GbGHe51HRgdtNBE+tA==
X-Google-Smtp-Source: AA0mqf6ncvCRE2mYDs+bB28jsz7RdsbRfhFBd9lbZVH5ZzJdl1Sb+V74iWZra428m7j8fehXdF9DdXomUNoC39WfDiw=
X-Received: by 2002:a05:6830:18d3:b0:66c:dd29:813d with SMTP id
 v19-20020a05683018d300b0066cdd29813dmr596457ote.312.1668658739410; Wed, 16
 Nov 2022 20:18:59 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
 <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
 <637576962dada_8cd03208b0@john.notmuch> <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com> <CAADnVQLBPCh=80RKe_5sgCt02c2Zat4TG66+PNrVD1a2k=4UfA@mail.gmail.com>
In-Reply-To: <CAADnVQLBPCh=80RKe_5sgCt02c2Zat4TG66+PNrVD1a2k=4UfA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 16 Nov 2022 20:18:48 -0800
Message-ID: <CAKH8qBvD=mur1YHf1MLxdxqWXOfvZTor+C2LqNMsvp0p6OhM0A@mail.gmail.com>
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

On Wed, Nov 16, 2022 at 6:59 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Nov 16, 2022 at 6:53 PM Stanislav Fomichev <sdf@google.com> wrote=
:
> >
> > On Wed, Nov 16, 2022 at 6:17 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Nov 16, 2022 at 4:19 PM Stanislav Fomichev <sdf@google.com> w=
rote:
> > > >
> > > > On Wed, Nov 16, 2022 at 3:47 PM John Fastabend <john.fastabend@gmai=
l.com> wrote:
> > > > >
> > > > > Stanislav Fomichev wrote:
> > > > > > On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
> > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > >
> > > > > > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > > > > > > Martin KaFai Lau <martin.lau@linux.dev> writes:
> > > > > > > >
> > > > > > > > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > > > > > > > >>>>>>> +static void veth_unroll_kfunc(const struct bpf_pro=
g *prog, u32 func_id,
> > > > > > > > >>>>>>> +                           struct bpf_patch *patch=
)
> > > > > > > > >>>>>>> +{
> > > > > > > > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_=
METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > > > > > > >>>>>>> +             /* return true; */
> > > > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM=
(BPF_REG_0, 1));
> > > > > > > > >>>>>>> +     } else if (func_id =3D=3D xdp_metadata_kfunc_=
id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> > > > > > > > >>>>>>> +             /* return ktime_get_mono_fast_ns(); *=
/
> > > > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL=
(ktime_get_mono_fast_ns));
> > > > > > > > >>>>>>> +     }
> > > > > > > > >>>>>>> +}
> > > > > > > > >>>>>>
> > > > > > > > >>>>>> So these look reasonable enough, but would be good t=
o see some examples
> > > > > > > > >>>>>> of kfunc implementations that don't just BPF_CALL to=
 a kernel function
> > > > > > > > >>>>>> (with those helper wrappers we were discussing befor=
e).
> > > > > > > > >>>>>
> > > > > > > > >>>>> Let's maybe add them if/when needed as we add more me=
tadata support?
> > > > > > > > >>>>> xdp_metadata_export_to_skb has an example, and rfc 1/=
2 have more
> > > > > > > > >>>>> examples, so it shouldn't be a problem to resurrect t=
hem back at some
> > > > > > > > >>>>> point?
> > > > > > > > >>>>
> > > > > > > > >>>> Well, the reason I asked for them is that I think havi=
ng to maintain the
> > > > > > > > >>>> BPF code generation in the drivers is probably the big=
gest drawback of
> > > > > > > > >>>> the kfunc approach, so it would be good to be relative=
ly sure that we
> > > > > > > > >>>> can manage that complexity (via helpers) before we com=
mit to this :)
> > > > > > > > >>>
> > > > > > > > >>> Right, and I've added a bunch of examples in v2 rfc so =
we can judge
> > > > > > > > >>> whether that complexity is manageable or not :-)
> > > > > > > > >>> Do you want me to add those wrappers you've back withou=
t any real users?
> > > > > > > > >>> Because I had to remove my veth tstamp accessors due to=
 John/Jesper
> > > > > > > > >>> objections; I can maybe bring some of this back gated b=
y some
> > > > > > > > >>> static_branch to avoid the fastpath cost?
> > > > > > > > >>
> > > > > > > > >> I missed the context a bit what did you mean "would be g=
ood to see some
> > > > > > > > >> examples of kfunc implementations that don't just BPF_CA=
LL to a kernel
> > > > > > > > >> function"? In this case do you mean BPF code directly wi=
thout the call?
> > > > > > > > >>
> > > > > > > > >> Early on I thought we should just expose the rx_descript=
or which would
> > > > > > > > >> be roughly the same right? (difference being code embedd=
ed in driver vs
> > > > > > > > >> a lib) Trouble I ran into is driver code using seqlock_t=
 and mutexs
> > > > > > > > >> which wasn't as straight forward as the simpler just rea=
d it from
> > > > > > > > >> the descriptor. For example in mlx getting the ts would =
be easy from
> > > > > > > > >> BPF with the mlx4_cqe struct exposed
> > > > > > > > >>
> > > > > > > > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > > > > > > > >> {
> > > > > > > > >>          u64 hi, lo;
> > > > > > > > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4_ts_=
cqe *)cqe;
> > > > > > > > >>
> > > > > > > > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_lo);
> > > > > > > > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_hi) =
+ !lo) << 16;
> > > > > > > > >>
> > > > > > > > >>          return hi | lo;
> > > > > > > > >> }
> > > > > > > > >>
> > > > > > > > >> but converting that to nsec is a bit annoying,
> > > > > > > > >>
> > > > > > > > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > > > > > > > >>                              struct skb_shared_hwtstamps=
 *hwts,
> > > > > > > > >>                              u64 timestamp)
> > > > > > > > >> {
> > > > > > > > >>          unsigned int seq;
> > > > > > > > >>          u64 nsec;
> > > > > > > > >>
> > > > > > > > >>          do {
> > > > > > > > >>                  seq =3D read_seqbegin(&mdev->clock_lock=
);
> > > > > > > > >>                  nsec =3D timecounter_cyc2time(&mdev->cl=
ock, timestamp);
> > > > > > > > >>          } while (read_seqretry(&mdev->clock_lock, seq))=
;
> > > > > > > > >>
> > > > > > > > >>          memset(hwts, 0, sizeof(struct skb_shared_hwtsta=
mps));
> > > > > > > > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > > > > > > > >> }
> > > > > > > > >>
> > > > > > > > >> I think the nsec is what you really want.
> > > > > > > > >>
> > > > > > > > >> With all the drivers doing slightly different ops we wou=
ld have
> > > > > > > > >> to create read_seqbegin, read_seqretry, mutex_lock, ... =
to get
> > > > > > > > >> at least the mlx and ice drivers it looks like we would =
need some
> > > > > > > > >> more BPF primitives/helpers. Looks like some more work i=
s needed
> > > > > > > > >> on ice driver though to get rx tstamps on all packets.
> > > > > > > > >>
> > > > > > > > >> Anyways this convinced me real devices will probably use=
 BPF_CALL
> > > > > > > > >> and not BPF insns directly.
> > > > > > > > >
> > > > > > > > > Some of the mlx5 path looks like this:
> > > > > > > > >
> > > > > > > > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SE=
C + ((u64)low))
> > > > > > > > >
> > > > > > > > > static inline ktime_t mlx5_real_time_cyc2time(struct mlx5=
_clock *clock,
> > > > > > > > >                                                u64 timest=
amp)
> > > > > > > > > {
> > > > > > > > >          u64 time =3D REAL_TIME_TO_NS(timestamp >> 32, ti=
mestamp & 0xFFFFFFFF);
> > > > > > > > >
> > > > > > > > >          return ns_to_ktime(time);
> > > > > > > > > }
> > > > > > > > >
> > > > > > > > > If some hints are harder to get, then just doing a kfunc =
call is better.
> > > > > > > >
> > > > > > > > Sure, but if we end up having a full function call for ever=
y field in
> > > > > > > > the metadata, that will end up having a significant perform=
ance impact
> > > > > > > > on the XDP data path (thinking mostly about the skb metadat=
a case here,
> > > > > > > > which will collect several bits of metadata).
> > > > > > > >
> > > > > > > > > csum may have a better chance to inline?
> > > > > > > >
> > > > > > > > Yup, I agree. Including that also makes it possible to benc=
hmark this
> > > > > > > > series against Jesper's; which I think we should definitely=
 be doing
> > > > > > > > before merging this.
> > > > > > >
> > > > > > > Good point I got sort of singularly focused on timestamp beca=
use I have
> > > > > > > a use case for it now.
> > > > > > >
> > > > > > > Also hash is often sitting in the rx descriptor.
> > > > > >
> > > > > > Ack, let me try to add something else (that's more inline-able)=
 on the
> > > > > > rx side for a v2.
> > > > >
> > > > > If you go with in-kernel BPF kfunc approach (vs user space side) =
I think
> > > > > you also need to add CO-RE to be friendly for driver developers? =
Otherwise
> > > > > they have to keep that read in sync with the descriptors? Also ne=
ed to
> > > > > handle versioning of descriptors where depending on specific opti=
ons
> > > > > and firmware and chip being enabled the descriptor might be movin=
g
> > > > > around. Of course can push this all to developer, but seems not s=
o
> > > > > nice when we have the machinery to do this and we handle it for a=
ll
> > > > > other structures.
> > > > >
> > > > > With CO-RE you can simply do the rx_desc->hash and rx_desc->csum =
and
> > > > > expect CO-RE sorts it out based on currently running btf_id of th=
e
> > > > > descriptor. If you go through normal path you get this for free o=
f
> > > > > course.
> > > >
> > > > Doesn't look like the descriptors are as nice as you're trying to
> > > > paint them (with clear hash/csum fields) :-) So not sure how much
> > > > CO-RE would help.
> > > > At least looking at mlx4 rx_csum, the driver consults three differe=
nt
> > > > sets of flags to figure out the hash_type. Or am I just unlucky wit=
h
> > > > mlx4?
> > >
> > > Which part are you talking about ?
> > >         hw_checksum =3D csum_unfold((__force __sum16)cqe->checksum);
> > > is trivial enough for bpf prog to do if it has access to 'cqe' pointe=
r
> > > which is what John is proposing (I think).
> >
> > I'm talking about mlx4_en_process_rx_cq, the caller of that check_csum.
> > In particular: if (likely(dev->features & NETIF_F_RXCSUM)) branch
> > I'm assuming we want to have hash_type available to the progs?
> >
> > But also, check_csum handles other corner cases:
> > - short_frame: we simply force all those small frames to skip checksum =
complete
> > - get_fixed_ipv6_csum: In IPv6 packets, hw_checksum lacks 6 bytes from
> > IPv6 header
> > - get_fixed_ipv4_csum: Although the stack expects checksum which
> > doesn't include the pseudo header, the HW adds it
>
> Of course, but kfunc won't be doing them either.
> We're talking XDP fast path.
> The mlx4 hw is old and incapable.
> No amount of sw can help.
>
> > So it doesn't look like we can just unconditionally use cqe->checksum?
> > The driver does a lot of massaging around that field to make it
> > palatable.
>
> Of course we can. cqe->checksum is still usable. the bpf prog
> would need to know what it's reading.
> There should be no attempt to present a unified state of hw bits.
> That's what skb is for. XDP layer should not hide such hw details.
> Otherwise it will become a mini skb layer with all that overhead.

I was hoping the kfunc could at least parse the flags and return some
pkt_hash_types-like enum to indicate what this csum covers.
So the users won't have to find the hardware manuals (not sure they
are even available?) to decipher what numbers they've got.
Regarding old mlx4: true, but mlx5's mlx5e_handle_csum doesn't look
that much different :-(

But going back a bit: I'm probably missing what John has been
suggesting. How is CO-RE relevant for kfuncs? kfuncs are already doing
a CO-RE-like functionality by rewriting some "public api" (kfunc) into
the bytecode to access the relevant data.
