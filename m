Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CDC62CB6D
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbiKPUvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiKPUvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:51:05 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF1F623AE
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:51:04 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id t19-20020a9d7753000000b0066d77a3d474so7334962otl.10
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3N0wFzR5FyAsFWPa4gr/lirFit7N85TOT/gSD2G/EnU=;
        b=P+cNr2w4eA7F8agu2DRBP6C6+6wLNr9sT4+rS3IsXP31Hm0qi0/XDOP0R1wPuytgLP
         0ES4Urij55T+wlxYO9QJ94NNyI996E7MXbEOjwxsNpMOGE/KtQxTffIkHL2qcxZdZHDt
         4N2vZNCbISbTPmmxw8y/q5ZJeLdZrFCvhqewPOBQIV+4EohDCaeP9XEdAN7cdSbQOum2
         lOqRcHdgdy+jeUkhZ2IdynmF/HE/WHRnzC8znsURMWTkeyK/35qIO1mS/9JI4bRVmFgv
         ozMMZjN1xNW/PjOgWh+tFIvWwq+PzcWzRlqZyQP9Uqo/E7uRIXyGih0La05egx13dB63
         B0Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3N0wFzR5FyAsFWPa4gr/lirFit7N85TOT/gSD2G/EnU=;
        b=YBLCjkdmEyR0sYYFVZSGDzOfK7dcWi648Jmyw6z7RLj7KGTYe3SUdojFlddiewVHhN
         09n93D/jdA/gxzznjKgdRbCvrzrynR1BsPz3bSuES1al7/Xse+2djNyPMYLqVgR6AJ88
         KmyFpY/0e4F7nGVY8XhhIAVuQWOwnjlo/MoxEjEy0XaWqmJdWXMh3YKenOjDiqBl+QKu
         MzitvRThiX6UvUurxbFxeoH3/3taAqy0SOzBo/KPDFd23/1cp7v9YfRJAR7zXStjuSPV
         aNlb1AIUwjswDlUW4CEksyKrUAl4iV1lj3XH45YCceFE2krRMijz1takmIRdrCeeDhSb
         g7cg==
X-Gm-Message-State: ANoB5pnh9D+HR95g8zIVlT0DnS3ZQplo+SSLel4ozWbeUgW+az698bhx
        oLTmK/V1ni4sCwZBpaHyVWrys3v9ShzQwivg77AE1w==
X-Google-Smtp-Source: AA0mqf6Kl2xcBdgYVmS4QSY1eOzyavqDPQPoApoPvXKoW4JBG4LXtttbFXJJIm/75GeGSjxeqar7eTB4yJB6Tqs47ko=
X-Received: by 2002:a9d:685a:0:b0:66c:dd29:813d with SMTP id
 c26-20020a9d685a000000b0066cdd29813dmr12288355oto.312.1668631863360; Wed, 16
 Nov 2022 12:51:03 -0800 (PST)
MIME-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com> <20221115030210.3159213-6-sdf@google.com>
 <87h6z0i449.fsf@toke.dk> <CAKH8qBsEGD3L0XAVzVHcTW6k_RhEt74pfXrPLANuznSAJw7bEg@mail.gmail.com>
 <8735ajet05.fsf@toke.dk> <CAKH8qBsg4aoFuiajuXmRN3VPKYVJZ-Z5wGzBy9pH3pV5RKCDzQ@mail.gmail.com>
 <6374854883b22_5d64b208e3@john.notmuch> <34f89a95-a79e-751c-fdd2-93889420bf96@linux.dev>
 <878rkbjjnp.fsf@toke.dk> <6375340a6c284_66f16208aa@john.notmuch>
In-Reply-To: <6375340a6c284_66f16208aa@john.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 16 Nov 2022 12:50:52 -0800
Message-ID: <CAKH8qBs1rYXf0GGto9hPz-ELLZ9c692cFnKC9JLwAq5b7JRK-A@mail.gmail.com>
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

On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Martin KaFai Lau <martin.lau@linux.dev> writes:
> >
> > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > >>>>>>> +static void veth_unroll_kfunc(const struct bpf_prog *prog, u32=
 func_id,
> > >>>>>>> +                           struct bpf_patch *patch)
> > >>>>>>> +{
> > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METADATA_KFU=
NC_RX_TIMESTAMP_SUPPORTED)) {
> > >>>>>>> +             /* return true; */
> > >>>>>>> +             bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, =
1));
> > >>>>>>> +     } else if (func_id =3D=3D xdp_metadata_kfunc_id(XDP_METAD=
ATA_KFUNC_RX_TIMESTAMP)) {
> > >>>>>>> +             /* return ktime_get_mono_fast_ns(); */
> > >>>>>>> +             bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_m=
ono_fast_ns));
> > >>>>>>> +     }
> > >>>>>>> +}
> > >>>>>>
> > >>>>>> So these look reasonable enough, but would be good to see some e=
xamples
> > >>>>>> of kfunc implementations that don't just BPF_CALL to a kernel fu=
nction
> > >>>>>> (with those helper wrappers we were discussing before).
> > >>>>>
> > >>>>> Let's maybe add them if/when needed as we add more metadata suppo=
rt?
> > >>>>> xdp_metadata_export_to_skb has an example, and rfc 1/2 have more
> > >>>>> examples, so it shouldn't be a problem to resurrect them back at =
some
> > >>>>> point?
> > >>>>
> > >>>> Well, the reason I asked for them is that I think having to mainta=
in the
> > >>>> BPF code generation in the drivers is probably the biggest drawbac=
k of
> > >>>> the kfunc approach, so it would be good to be relatively sure that=
 we
> > >>>> can manage that complexity (via helpers) before we commit to this =
:)
> > >>>
> > >>> Right, and I've added a bunch of examples in v2 rfc so we can judge
> > >>> whether that complexity is manageable or not :-)
> > >>> Do you want me to add those wrappers you've back without any real u=
sers?
> > >>> Because I had to remove my veth tstamp accessors due to John/Jesper
> > >>> objections; I can maybe bring some of this back gated by some
> > >>> static_branch to avoid the fastpath cost?
> > >>
> > >> I missed the context a bit what did you mean "would be good to see s=
ome
> > >> examples of kfunc implementations that don't just BPF_CALL to a kern=
el
> > >> function"? In this case do you mean BPF code directly without the ca=
ll?
> > >>
> > >> Early on I thought we should just expose the rx_descriptor which wou=
ld
> > >> be roughly the same right? (difference being code embedded in driver=
 vs
> > >> a lib) Trouble I ran into is driver code using seqlock_t and mutexs
> > >> which wasn't as straight forward as the simpler just read it from
> > >> the descriptor. For example in mlx getting the ts would be easy from
> > >> BPF with the mlx4_cqe struct exposed
> > >>
> > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > >> {
> > >>          u64 hi, lo;
> > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct mlx4_ts_cqe *)cqe;
> > >>
> > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timestamp_lo);
> > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timestamp_hi) + !lo) << 16=
;
> > >>
> > >>          return hi | lo;
> > >> }
> > >>
> > >> but converting that to nsec is a bit annoying,
> > >>
> > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *mdev,
> > >>                              struct skb_shared_hwtstamps *hwts,
> > >>                              u64 timestamp)
> > >> {
> > >>          unsigned int seq;
> > >>          u64 nsec;
> > >>
> > >>          do {
> > >>                  seq =3D read_seqbegin(&mdev->clock_lock);
> > >>                  nsec =3D timecounter_cyc2time(&mdev->clock, timesta=
mp);
> > >>          } while (read_seqretry(&mdev->clock_lock, seq));
> > >>
> > >>          memset(hwts, 0, sizeof(struct skb_shared_hwtstamps));
> > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > >> }
> > >>
> > >> I think the nsec is what you really want.
> > >>
> > >> With all the drivers doing slightly different ops we would have
> > >> to create read_seqbegin, read_seqretry, mutex_lock, ... to get
> > >> at least the mlx and ice drivers it looks like we would need some
> > >> more BPF primitives/helpers. Looks like some more work is needed
> > >> on ice driver though to get rx tstamps on all packets.
> > >>
> > >> Anyways this convinced me real devices will probably use BPF_CALL
> > >> and not BPF insns directly.
> > >
> > > Some of the mlx5 path looks like this:
> > >
> > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSEC_PER_SEC + ((u64)lo=
w))
> > >
> > > static inline ktime_t mlx5_real_time_cyc2time(struct mlx5_clock *cloc=
k,
> > >                                                u64 timestamp)
> > > {
> > >          u64 time =3D REAL_TIME_TO_NS(timestamp >> 32, timestamp & 0x=
FFFFFFFF);
> > >
> > >          return ns_to_ktime(time);
> > > }
> > >
> > > If some hints are harder to get, then just doing a kfunc call is bett=
er.
> >
> > Sure, but if we end up having a full function call for every field in
> > the metadata, that will end up having a significant performance impact
> > on the XDP data path (thinking mostly about the skb metadata case here,
> > which will collect several bits of metadata).
> >
> > > csum may have a better chance to inline?
> >
> > Yup, I agree. Including that also makes it possible to benchmark this
> > series against Jesper's; which I think we should definitely be doing
> > before merging this.
>
> Good point I got sort of singularly focused on timestamp because I have
> a use case for it now.
>
> Also hash is often sitting in the rx descriptor.

Ack, let me try to add something else (that's more inline-able) on the
rx side for a v2.

> >
> > > Regardless, BPF in-lining is a well solved problem and used in many
> > > bpf helpers already, so there are many examples in the kernel. I don'=
t
> > > think it is necessary to block this series because of missing some
> > > helper wrappers for inlining. The driver can always start with the
> > > simpler kfunc call first and optimize later if some hints from the
> > > drivers allow it.
> >
> > Well, "solved" in the sense of "there are a few handfuls of core BPF
> > people who know how to do it". My concern is that we'll end up with
> > either the BPF devs having to maintain all these bits of BPF byte code
> > in all the drivers; or drivers just punting to regular function calls
> > because the inlining is too complicated, with sub-par performance as pe=
r
> > the above. I don't think we should just hand-wave this away as "solved"=
,
> > but rather treat this as an integral part of the initial series.
>
> This was my motivation for pushing the rx_descriptor into the xdp_buff.
> At this point if I'm going to have a kfunc call into the driver and
> have the driver rewrite the code into some BPF instructions I would
> just assume maintain this as a library code where I can hook it
> into my BPF program directly from user space. Maybe a few drivers
> will support all the things I want to read, but we run on lots of
> hardware (mlx, intel, eks, azure, gke, etc) and its been a lot of work
> to just get the basic feature parity. I also don't want to run around
> writing driver code for each vendor if I can avoid it. Having raw
> access to the rx descriptor gets me the escape hatch where I can
> just do it myself. And the last piece of info from my point of view
> (Tetragon, Cilium) I can run whatever libs I want and freely upgrade
> libbpf and cilium/ebpf but have a lot less ability to get users
> to upgrade kernels outside the LTS they picked. Meaning I can
> add new things much easier if its lifted into BPF code placed
> by user space.
>
> I appreciate that it means I import the problem of hardware detection
> and BTF CO-RE on networking codes, but we've already solved these
> problems for other reasons. For example just configuring the timestamp
> is a bit of an exercise in does my hardware support timestamping
> and does it support timestamping the packets I care about,  e.g.
> all pkts, just ptp pkts, etc.
>
> I don't think they are mutual exclusive with this series though
> because I can't see how to write these timestamping logic directly
> in BPF. But for rxhash and csum it seems doable. My preference
> is to have both the kfuncs and expose the descriptor directly.
>
> .John
