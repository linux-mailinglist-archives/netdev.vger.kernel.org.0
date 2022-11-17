Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 471BD62E376
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 18:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239739AbiKQRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 12:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiKQRwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 12:52:00 -0500
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C707EC88
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:51:59 -0800 (PST)
Received: by mail-oo1-xc2c.google.com with SMTP id r10-20020a4aa2ca000000b0049dd7ad4128so399300ool.13
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 09:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jeDzo+Yl5ScTkGqn65I/VZYkKmyZKCr0dky61ugYW4=;
        b=dGr+G3jLZrzGzFLvg0kzCpDcav5A8AGHbD5GL5V2HuO87BG/d3ixMkYQ7S38BYubz5
         +pVmNh4q/OiR+7tb5tI6IF1i1sPmhcrPQSnjbRBU12RvZXExqxX2Vfz0DJn//H3QlQYh
         /9i6lQEVgubnXM3dgXfm6ugiVXlSJZN9L+hpM3FfD+7D5PVEdPBC+ETZRLjLQly3VEWB
         EnSr5xBX3loU1IgVANS82TVdglpHcUYRfOFiQXs2y7UfwBSk1MlQSAL9x8k7YYJYySRR
         Y4XA6yX/bMzTLnQVW9Jphyj5EyRnAWEFWd8fE5IBTU12w53QwGP2sCSxqIRCHCKz+ZRW
         /Zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jeDzo+Yl5ScTkGqn65I/VZYkKmyZKCr0dky61ugYW4=;
        b=Qo2SuGKrAqqJAO0qEb35KoU4CUO0FFtiMQAwKTl+qR6eURHixJYTQ7qSVl7Bc0dYyV
         scBI6YzaN3hMKm/fcUUj0uojqlc3bk7qO+6x7qyaWYRp6jOoQ7xeYByPgnxNVZ+YE6vN
         ea5uHL3ig4wqseP/mT6I/z/ls+fGfSaTGsm35QXgQvXRFEphr10Q0Nx69b/zldaaM51h
         lNCMiFZ7D+rQrwb/QO8z4gsQ2p+FKzn51e9pON6CH9FXwIAzSfES/z2AXNIbr7BsnN74
         L+L53YFrryZpkmmbksRL5/YODT/3yvMYT8rkwxo9DBW+hPrscKt/evjRQQOL0gBzUDE0
         eJJQ==
X-Gm-Message-State: ANoB5plVYG56ZTvb/7LdtOonmfHkZ5csNzYF9ui9P0HSgwM2B7+oemzO
        /3LRgC9S7B4WfJwLi7+gvqw5iSamKSNvWatxEE06SQ==
X-Google-Smtp-Source: AA0mqf6CKzebL3RS3riu7tquORjtUqXLa4pBMVrVQbjNXj9K0eyFiXEZLfbOpHT1vNwTB7GouJ6WFQZjYxwe8RUrsTw=
X-Received: by 2002:a4a:4882:0:b0:480:a6b4:d398 with SMTP id
 p124-20020a4a4882000000b00480a6b4d398mr1812626ooa.86.1668707518394; Thu, 17
 Nov 2022 09:51:58 -0800 (PST)
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
 <CAADnVQLBPCh=80RKe_5sgCt02c2Zat4TG66+PNrVD1a2k=4UfA@mail.gmail.com>
 <CAKH8qBvD=mur1YHf1MLxdxqWXOfvZTor+C2LqNMsvp0p6OhM0A@mail.gmail.com> <6375dad15f11f_9c882208b5@john.notmuch>
In-Reply-To: <6375dad15f11f_9c882208b5@john.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 17 Nov 2022 09:51:46 -0800
Message-ID: <CAKH8qBu6rejvUOX5r=6JP=NoG_3-VZvNXHyfp=gVbr7-OhMGaw@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next 05/11] veth: Support rx timestamp
 metadata for xdp
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

On Wed, Nov 16, 2022 at 10:55 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Stanislav Fomichev wrote:
> > On Wed, Nov 16, 2022 at 6:59 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Nov 16, 2022 at 6:53 PM Stanislav Fomichev <sdf@google.com> w=
rote:
> > > >
> > > > On Wed, Nov 16, 2022 at 6:17 PM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >
> > > > > On Wed, Nov 16, 2022 at 4:19 PM Stanislav Fomichev <sdf@google.co=
m> wrote:
> > > > > >
> > > > > > On Wed, Nov 16, 2022 at 3:47 PM John Fastabend <john.fastabend@=
gmail.com> wrote:
> > > > > > >
> > > > > > > Stanislav Fomichev wrote:
> > > > > > > > On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
> > > > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > > > > > > > > Martin KaFai Lau <martin.lau@linux.dev> writes:
> > > > > > > > > >
> > > > > > > > > > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > > > > > > > > > >>>>>>> +static void veth_unroll_kfunc(const struct bpf=
_prog *prog, u32 func_id,
> > > > > > > > > > >>>>>>> +                           struct bpf_patch *p=
atch)
> > > > > > > > > > >>>>>>> +{
> > > > > > > > > > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc_id(=
XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > > > > > > > > >>>>>>> +             /* return true; */
> > > > > > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_MOV64=
_IMM(BPF_REG_0, 1));
> > > > > > > > > > >>>>>>> +     } else if (func_id =3D=3D xdp_metadata_kf=
unc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> > > > > > > > > > >>>>>>> +             /* return ktime_get_mono_fast_ns(=
); */
> > > > > > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_EMIT_=
CALL(ktime_get_mono_fast_ns));
> > > > > > > > > > >>>>>>> +     }
> > > > > > > > > > >>>>>>> +}
> > > > > > > > > > >>>>>>
> > > > > > > > > > >>>>>> So these look reasonable enough, but would be go=
od to see some examples
> > > > > > > > > > >>>>>> of kfunc implementations that don't just BPF_CAL=
L to a kernel function
> > > > > > > > > > >>>>>> (with those helper wrappers we were discussing b=
efore).
> > > > > > > > > > >>>>>
> > > > > > > > > > >>>>> Let's maybe add them if/when needed as we add mor=
e metadata support?
> > > > > > > > > > >>>>> xdp_metadata_export_to_skb has an example, and rf=
c 1/2 have more
> > > > > > > > > > >>>>> examples, so it shouldn't be a problem to resurre=
ct them back at some
> > > > > > > > > > >>>>> point?
> > > > > > > > > > >>>>
> > > > > > > > > > >>>> Well, the reason I asked for them is that I think =
having to maintain the
> > > > > > > > > > >>>> BPF code generation in the drivers is probably the=
 biggest drawback of
> > > > > > > > > > >>>> the kfunc approach, so it would be good to be rela=
tively sure that we
> > > > > > > > > > >>>> can manage that complexity (via helpers) before we=
 commit to this :)
> > > > > > > > > > >>>
> > > > > > > > > > >>> Right, and I've added a bunch of examples in v2 rfc=
 so we can judge
> > > > > > > > > > >>> whether that complexity is manageable or not :-)
> > > > > > > > > > >>> Do you want me to add those wrappers you've back wi=
thout any real users?
> > > > > > > > > > >>> Because I had to remove my veth tstamp accessors du=
e to John/Jesper
> > > > > > > > > > >>> objections; I can maybe bring some of this back gat=
ed by some
> > > > > > > > > > >>> static_branch to avoid the fastpath cost?
> > > > > > > > > > >>
> > > > > > > > > > >> I missed the context a bit what did you mean "would =
be good to see some
> > > > > > > > > > >> examples of kfunc implementations that don't just BP=
F_CALL to a kernel
> > > > > > > > > > >> function"? In this case do you mean BPF code directl=
y without the call?
> > > > > > > > > > >>
> > > > > > > > > > >> Early on I thought we should just expose the rx_desc=
riptor which would
> > > > > > > > > > >> be roughly the same right? (difference being code em=
bedded in driver vs
> > > > > > > > > > >> a lib) Trouble I ran into is driver code using seqlo=
ck_t and mutexs
> > > > > > > > > > >> which wasn't as straight forward as the simpler just=
 read it from
> > > > > > > > > > >> the descriptor. For example in mlx getting the ts wo=
uld be easy from
> > > > > > > > > > >> BPF with the mlx4_cqe struct exposed
> > > > > > > > > > >>
> > > > > > > > > > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > > > > > > > > > >> {
> > > > > > > > > > >>          u64 hi, lo;
> > > > > > > > > > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4=
_ts_cqe *)cqe;
> > > > > > > > > > >>
> > > > > > > > > > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_l=
o);
> > > > > > > > > > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_=
hi) + !lo) << 16;
> > > > > > > > > > >>
> > > > > > > > > > >>          return hi | lo;
> > > > > > > > > > >> }
> > > > > > > > > > >>
> > > > > > > > > > >> but converting that to nsec is a bit annoying,
> > > > > > > > > > >>
> > > > > > > > > > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev=
,
> > > > > > > > > > >>                              struct skb_shared_hwtst=
amps *hwts,
> > > > > > > > > > >>                              u64 timestamp)
> > > > > > > > > > >> {
> > > > > > > > > > >>          unsigned int seq;
> > > > > > > > > > >>          u64 nsec;
> > > > > > > > > > >>
> > > > > > > > > > >>          do {
> > > > > > > > > > >>                  seq =3D read_seqbegin(&mdev->clock_=
lock);
> > > > > > > > > > >>                  nsec =3D timecounter_cyc2time(&mdev=
->clock, timestamp);
> > > > > > > > > > >>          } while (read_seqretry(&mdev->clock_lock, s=
eq));
> > > > > > > > > > >>
> > > > > > > > > > >>          memset(hwts, 0, sizeof(struct skb_shared_hw=
tstamps));
> > > > > > > > > > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > > > > > > > > > >> }
> > > > > > > > > > >>
> > > > > > > > > > >> I think the nsec is what you really want.
> > > > > > > > > > >>
> > > > > > > > > > >> With all the drivers doing slightly different ops we=
 would have
> > > > > > > > > > >> to create read_seqbegin, read_seqretry, mutex_lock, =
... to get
> > > > > > > > > > >> at least the mlx and ice drivers it looks like we wo=
uld need some
> > > > > > > > > > >> more BPF primitives/helpers. Looks like some more wo=
rk is needed
> > > > > > > > > > >> on ice driver though to get rx tstamps on all packet=
s.
> > > > > > > > > > >>
> > > > > > > > > > >> Anyways this convinced me real devices will probably=
 use BPF_CALL
> > > > > > > > > > >> and not BPF insns directly.
> > > > > > > > > > >
> > > > > > > > > > > Some of the mlx5 path looks like this:
> > > > > > > > > > >
> > > > > > > > > > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PE=
R_SEC + ((u64)low))
> > > > > > > > > > >
> > > > > > > > > > > static inline ktime_t mlx5_real_time_cyc2time(struct =
mlx5_clock *clock,
> > > > > > > > > > >                                                u64 ti=
mestamp)
> > > > > > > > > > > {
> > > > > > > > > > >          u64 time =3D REAL_TIME_TO_NS(timestamp >> 32=
, timestamp & 0xFFFFFFFF);
> > > > > > > > > > >
> > > > > > > > > > >          return ns_to_ktime(time);
> > > > > > > > > > > }
> > > > > > > > > > >
> > > > > > > > > > > If some hints are harder to get, then just doing a kf=
unc call is better.
> > > > > > > > > >
> > > > > > > > > > Sure, but if we end up having a full function call for =
every field in
> > > > > > > > > > the metadata, that will end up having a significant per=
formance impact
> > > > > > > > > > on the XDP data path (thinking mostly about the skb met=
adata case here,
> > > > > > > > > > which will collect several bits of metadata).
> > > > > > > > > >
> > > > > > > > > > > csum may have a better chance to inline?
> > > > > > > > > >
> > > > > > > > > > Yup, I agree. Including that also makes it possible to =
benchmark this
> > > > > > > > > > series against Jesper's; which I think we should defini=
tely be doing
> > > > > > > > > > before merging this.
> > > > > > > > >
> > > > > > > > > Good point I got sort of singularly focused on timestamp =
because I have
> > > > > > > > > a use case for it now.
> > > > > > > > >
> > > > > > > > > Also hash is often sitting in the rx descriptor.
> > > > > > > >
> > > > > > > > Ack, let me try to add something else (that's more inline-a=
ble) on the
> > > > > > > > rx side for a v2.
> > > > > > >
> > > > > > > If you go with in-kernel BPF kfunc approach (vs user space si=
de) I think
> > > > > > > you also need to add CO-RE to be friendly for driver develope=
rs? Otherwise
> > > > > > > they have to keep that read in sync with the descriptors? Als=
o need to
> > > > > > > handle versioning of descriptors where depending on specific =
options
> > > > > > > and firmware and chip being enabled the descriptor might be m=
oving
> > > > > > > around. Of course can push this all to developer, but seems n=
ot so
> > > > > > > nice when we have the machinery to do this and we handle it f=
or all
> > > > > > > other structures.
> > > > > > >
> > > > > > > With CO-RE you can simply do the rx_desc->hash and rx_desc->c=
sum and
> > > > > > > expect CO-RE sorts it out based on currently running btf_id o=
f the
> > > > > > > descriptor. If you go through normal path you get this for fr=
ee of
> > > > > > > course.
> > > > > >
> > > > > > Doesn't look like the descriptors are as nice as you're trying =
to
> > > > > > paint them (with clear hash/csum fields) :-) So not sure how mu=
ch
> > > > > > CO-RE would help.
> > > > > > At least looking at mlx4 rx_csum, the driver consults three dif=
ferent
> > > > > > sets of flags to figure out the hash_type. Or am I just unlucky=
 with
> > > > > > mlx4?
> > > > >
> > > > > Which part are you talking about ?
> > > > >         hw_checksum =3D csum_unfold((__force __sum16)cqe->checksu=
m);
> > > > > is trivial enough for bpf prog to do if it has access to 'cqe' po=
inter
> > > > > which is what John is proposing (I think).
>
> Yeah this is what I've been considering. If you just get the 'cqe' pointe=
r
> walking the check_sum and rxhash should be straightforward.
>
> There seems to be a real difference between timestamps and most other
> fields IMO. Timestamps require some extra logic to turn into ns when
> using the NIC hw clock. And the hw clock requires some coordination to
> keep in sync and stop from overflowing and may be done through other
> protocols like PTP in my use case. In some cases I think the clock is
> also shared amongst multiple phys. Seems mlx has a seqlock_t to protect
> it and I'm less sure about this but seems intel nic maybe has a sideband
> control channel.
>
> Then there is everything else that I can think up that is per packet data
> and requires no coordination with the driver. Its just reading fields in
> the completion queue. This would be the csum, check_sum, vlan_header and
> so on. Sure we could kfunc each one of those things, but could also just
> write that directly in BPF and remove some abstractions and kernel
> dependency by doing it directly in the BPF program. If you like that
> abstraction seems to be the point of contention my opinion is the cost
> of kernel depency is high and I can abstract it with a user library
> anyways so burying it in the kernel only causes me support issues and
> backwards compat problems.
>
> Hopefully, my position is more clear.

Yeah, I see your point, I'm somewhat in the same position here wrt to
legacy kernels :-)
Exposing raw descriptors seems fine, but imo it shouldn't be the goto
mechanism for the metadata; but rather as a fallback whenever the
driver implementation is missing/buggy. Unless, as you mention below,
there are some libraries in the future to abstract that.
But at least it seems that we agree that there needs to be some other
non-raw-descriptor way to access spinlocked things like the timestamp?


> > > > I'm talking about mlx4_en_process_rx_cq, the caller of that check_c=
sum.
> > > > In particular: if (likely(dev->features & NETIF_F_RXCSUM)) branch
> > > > I'm assuming we want to have hash_type available to the progs?
> > > >
> > > > But also, check_csum handles other corner cases:
> > > > - short_frame: we simply force all those small frames to skip check=
sum complete
> > > > - get_fixed_ipv6_csum: In IPv6 packets, hw_checksum lacks 6 bytes f=
rom
> > > > IPv6 header
> > > > - get_fixed_ipv4_csum: Although the stack expects checksum which
> > > > doesn't include the pseudo header, the HW adds it
> > >
> > > Of course, but kfunc won't be doing them either.
> > > We're talking XDP fast path.
> > > The mlx4 hw is old and incapable.
> > > No amount of sw can help.
>
> Doesn't this lend itself to letting the XDP BPF program write the
> BPF code to read it out. Maybe someone cares about these details
> for some cpumap thing, but the rest of us wont care we might just
> want to read check_csum. Maybe we have an IPv6 only network or
> IPv4 network so can make further shortcuts. If a driver dev does
> this they will be forced to do the cactch all version because
> they have no way to know such details.
>
> > > > So it doesn't look like we can just unconditionally use cqe->checks=
um?
> > > > The driver does a lot of massaging around that field to make it
> > > > palatable.
> > >
> > > Of course we can. cqe->checksum is still usable. the bpf prog
> > > would need to know what it's reading.
> > > There should be no attempt to present a unified state of hw bits.
> > > That's what skb is for. XDP layer should not hide such hw details.
> > > Otherwise it will become a mini skb layer with all that overhead.
> >
> > I was hoping the kfunc could at least parse the flags and return some
> > pkt_hash_types-like enum to indicate what this csum covers.
> > So the users won't have to find the hardware manuals (not sure they
> > are even available?) to decipher what numbers they've got.
> > Regarding old mlx4: true, but mlx5's mlx5e_handle_csum doesn't look
> > that much different :-(
>
> The driver developers could still provide and ship the BPF libs
> with their drivers. I think if someone is going to use their NIC
> and lots of them and requires XDP it will get done. We could put
> them by the driver code mlx4.bpf or something.
>
> >
> > But going back a bit: I'm probably missing what John has been
> > suggesting. How is CO-RE relevant for kfuncs? kfuncs are already doing
> > a CO-RE-like functionality by rewriting some "public api" (kfunc) into
> > the bytecode to access the relevant data.
>
> This was maybe a bit of an aside. What I was pondering a bit out
> loud perhaps is my recollection is there may be a few different
> descriptor layouts depending features enabled, exact device loaded
> and such. So in this case if I was a driver writer I might not want
> to hardcode the offset of the check_sum field. If I could use CO-RE
> then I don't have to care if in one version is the Nth field and later on
> someone makes it the Mth field just like any normal kernel struct.
> But through the kfunc interface I couldn't see how to get that.
> So instead of having a bunch of kfunc implementations you could just
> have one for all your device classes because you always name the
> field the same thing.
