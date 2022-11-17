Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5898C62E56E
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 20:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbiKQTsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 14:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbiKQTr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 14:47:59 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25AF88F9D;
        Thu, 17 Nov 2022 11:47:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so2560958pjb.0;
        Thu, 17 Nov 2022 11:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFC1q4ZkMZPGQnYjhTL2+tOzH7rDesMQVYrMtPtNXXI=;
        b=BuX/c6Us8sYBSu8bqyG6N2hwxZx7CV+zs9yjxD3roaCl+2I1bxYLajAUVXODswX4a+
         Ky+LZoflvpqvhxn34eseDuJi3bd82yEzRpgIy1Os+VmofmMAiIdjBFtcSUx8rgNGh0IN
         7xMiM30DXiwsVLkbH9uiijagnGh2usLN46EO48gLKR6yrlAiExFJO9WdiuVIuVUuREoi
         1OCEVuMnKJpJLmSH2bCXkI04ry0xMPwTUIbkBR+DZtLSO5r6hOCkA0S2A6Sfk5Ko+ye1
         Ljm0wtb7LtfdeTM2+djVdjKUurE0/E79WFaWYSX4UVF8y20HXaemQnnfz3H+39TKsTzy
         3WuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xFC1q4ZkMZPGQnYjhTL2+tOzH7rDesMQVYrMtPtNXXI=;
        b=0vEJ678BT1NB1xqcIp8fWVFM1WmGvskB5M8MP73rSc3mYSDoULgB9JRWydf3rBTIGX
         8SSB6pPCYiWp9zbeKRcTMt+pMnrs3K5ljgC1CHrAKhQP5+N1BforBimbvN4SF5st5l0q
         m2HfTEXHhKaQRcX4qVE/EjwwyoBJgOdnYX8eIGEb2+LOK3lyinslV9oOH6+MoiqT5TDv
         OiEAOJU3SbQ6HFtVe4U++Zgw6ZdD/oks/e9tl7SAYOMPcK/wa6ZwMIbwetF55up5a/Yi
         evJCdLQCOJJElu5WpLw6/2+GTK1yWGhr8sE57YzYSXPbiLEwMYkDKJJvFjn2iXE8V+yd
         zsfg==
X-Gm-Message-State: ANoB5pkqyazGIPnSvLhcnWEW6YRvW8o6AQlEqrJ46YH1qQFEPckaZBmA
        QAg5YvP/vf9nX8MRkEN2bZ8=
X-Google-Smtp-Source: AA0mqf6g2m5a8xvZTLDQrxmFYL3ASOAHDM5jlsQuhUq3ZbDMxRJG/Zss311X+fxCYfXLcNf7rUUQOQ==
X-Received: by 2002:a17:90a:4889:b0:20d:d531:97cc with SMTP id b9-20020a17090a488900b0020dd53197ccmr4331993pjh.164.1668714477171;
        Thu, 17 Nov 2022 11:47:57 -0800 (PST)
Received: from localhost ([2605:59c8:47b:5f10:a0d4:e73c:3f5b:8b6b])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902d38c00b0017f8094a52asm1810852pld.29.2022.11.17.11.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:47:56 -0800 (PST)
Date:   Thu, 17 Nov 2022 11:47:54 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>,
        John Fastabend <john.fastabend@gmail.com>
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
Message-ID: <63768feaf1324_4101208cf@john.notmuch>
In-Reply-To: <CAKH8qBu6rejvUOX5r=6JP=NoG_3-VZvNXHyfp=gVbr7-OhMGaw@mail.gmail.com>
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
 <637576962dada_8cd03208b0@john.notmuch>
 <CAKH8qBtOATGBMPkgdE0jZ+76AWMsUWau360u562bB=cGYq+gdQ@mail.gmail.com>
 <CAADnVQKTXuBvP_2O6coswXL7MSvqVo1d+qXLabeOikcbcbAKPQ@mail.gmail.com>
 <CAKH8qBvTdnyRYT+ocNS_ZmOfoN+nBEJ5jcBcKcqZ1hx0a5WrSw@mail.gmail.com>
 <CAADnVQLBPCh=80RKe_5sgCt02c2Zat4TG66+PNrVD1a2k=4UfA@mail.gmail.com>
 <CAKH8qBvD=mur1YHf1MLxdxqWXOfvZTor+C2LqNMsvp0p6OhM0A@mail.gmail.com>
 <6375dad15f11f_9c882208b5@john.notmuch>
 <CAKH8qBu6rejvUOX5r=6JP=NoG_3-VZvNXHyfp=gVbr7-OhMGaw@mail.gmail.com>
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
> On Wed, Nov 16, 2022 at 10:55 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Stanislav Fomichev wrote:
> > > On Wed, Nov 16, 2022 at 6:59 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Wed, Nov 16, 2022 at 6:53 PM Stanislav Fomichev <sdf@google.co=
m> wrote:
> > > > >
> > > > > On Wed, Nov 16, 2022 at 6:17 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > >
> > > > > > On Wed, Nov 16, 2022 at 4:19 PM Stanislav Fomichev <sdf@googl=
e.com> wrote:
> > > > > > >
> > > > > > > On Wed, Nov 16, 2022 at 3:47 PM John Fastabend <john.fastab=
end@gmail.com> wrote:
> > > > > > > >
> > > > > > > > Stanislav Fomichev wrote:
> > > > > > > > > On Wed, Nov 16, 2022 at 11:03 AM John Fastabend
> > > > > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > > > > > > > > > > Martin KaFai Lau <martin.lau@linux.dev> writes:
> > > > > > > > > > >
> > > > > > > > > > > > On 11/15/22 10:38 PM, John Fastabend wrote:
> > > > > > > > > > > >>>>>>> +static void veth_unroll_kfunc(const struct=
 bpf_prog *prog, u32 func_id,
> > > > > > > > > > > >>>>>>> +                           struct bpf_patc=
h *patch)
> > > > > > > > > > > >>>>>>> +{
> > > > > > > > > > > >>>>>>> +     if (func_id =3D=3D xdp_metadata_kfunc=
_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
> > > > > > > > > > > >>>>>>> +             /* return true; */
> > > > > > > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_M=
OV64_IMM(BPF_REG_0, 1));
> > > > > > > > > > > >>>>>>> +     } else if (func_id =3D=3D xdp_metadat=
a_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
> > > > > > > > > > > >>>>>>> +             /* return ktime_get_mono_fast=
_ns(); */
> > > > > > > > > > > >>>>>>> +             bpf_patch_append(patch, BPF_E=
MIT_CALL(ktime_get_mono_fast_ns));
> > > > > > > > > > > >>>>>>> +     }
> > > > > > > > > > > >>>>>>> +}
> > > > > > > > > > > >>>>>>
> > > > > > > > > > > >>>>>> So these look reasonable enough, but would b=
e good to see some examples
> > > > > > > > > > > >>>>>> of kfunc implementations that don't just BPF=
_CALL to a kernel function
> > > > > > > > > > > >>>>>> (with those helper wrappers we were discussi=
ng before).
> > > > > > > > > > > >>>>>
> > > > > > > > > > > >>>>> Let's maybe add them if/when needed as we add=
 more metadata support?
> > > > > > > > > > > >>>>> xdp_metadata_export_to_skb has an example, an=
d rfc 1/2 have more
> > > > > > > > > > > >>>>> examples, so it shouldn't be a problem to res=
urrect them back at some
> > > > > > > > > > > >>>>> point?
> > > > > > > > > > > >>>>
> > > > > > > > > > > >>>> Well, the reason I asked for them is that I th=
ink having to maintain the
> > > > > > > > > > > >>>> BPF code generation in the drivers is probably=
 the biggest drawback of
> > > > > > > > > > > >>>> the kfunc approach, so it would be good to be =
relatively sure that we
> > > > > > > > > > > >>>> can manage that complexity (via helpers) befor=
e we commit to this :)
> > > > > > > > > > > >>>
> > > > > > > > > > > >>> Right, and I've added a bunch of examples in v2=
 rfc so we can judge
> > > > > > > > > > > >>> whether that complexity is manageable or not :-=
)
> > > > > > > > > > > >>> Do you want me to add those wrappers you've bac=
k without any real users?
> > > > > > > > > > > >>> Because I had to remove my veth tstamp accessor=
s due to John/Jesper
> > > > > > > > > > > >>> objections; I can maybe bring some of this back=
 gated by some
> > > > > > > > > > > >>> static_branch to avoid the fastpath cost?
> > > > > > > > > > > >>
> > > > > > > > > > > >> I missed the context a bit what did you mean "wo=
uld be good to see some
> > > > > > > > > > > >> examples of kfunc implementations that don't jus=
t BPF_CALL to a kernel
> > > > > > > > > > > >> function"? In this case do you mean BPF code dir=
ectly without the call?
> > > > > > > > > > > >>
> > > > > > > > > > > >> Early on I thought we should just expose the rx_=
descriptor which would
> > > > > > > > > > > >> be roughly the same right? (difference being cod=
e embedded in driver vs
> > > > > > > > > > > >> a lib) Trouble I ran into is driver code using s=
eqlock_t and mutexs
> > > > > > > > > > > >> which wasn't as straight forward as the simpler =
just read it from
> > > > > > > > > > > >> the descriptor. For example in mlx getting the t=
s would be easy from
> > > > > > > > > > > >> BPF with the mlx4_cqe struct exposed
> > > > > > > > > > > >>
> > > > > > > > > > > >> u64 mlx4_en_get_cqe_ts(struct mlx4_cqe *cqe)
> > > > > > > > > > > >> {
> > > > > > > > > > > >>          u64 hi, lo;
> > > > > > > > > > > >>          struct mlx4_ts_cqe *ts_cqe =3D (struct =
mlx4_ts_cqe *)cqe;
> > > > > > > > > > > >>
> > > > > > > > > > > >>          lo =3D (u64)be16_to_cpu(ts_cqe->timesta=
mp_lo);
> > > > > > > > > > > >>          hi =3D ((u64)be32_to_cpu(ts_cqe->timest=
amp_hi) + !lo) << 16;
> > > > > > > > > > > >>
> > > > > > > > > > > >>          return hi | lo;
> > > > > > > > > > > >> }
> > > > > > > > > > > >>
> > > > > > > > > > > >> but converting that to nsec is a bit annoying,
> > > > > > > > > > > >>
> > > > > > > > > > > >> void mlx4_en_fill_hwtstamps(struct mlx4_en_dev *=
mdev,
> > > > > > > > > > > >>                              struct skb_shared_h=
wtstamps *hwts,
> > > > > > > > > > > >>                              u64 timestamp)
> > > > > > > > > > > >> {
> > > > > > > > > > > >>          unsigned int seq;
> > > > > > > > > > > >>          u64 nsec;
> > > > > > > > > > > >>
> > > > > > > > > > > >>          do {
> > > > > > > > > > > >>                  seq =3D read_seqbegin(&mdev->cl=
ock_lock);
> > > > > > > > > > > >>                  nsec =3D timecounter_cyc2time(&=
mdev->clock, timestamp);
> > > > > > > > > > > >>          } while (read_seqretry(&mdev->clock_loc=
k, seq));
> > > > > > > > > > > >>
> > > > > > > > > > > >>          memset(hwts, 0, sizeof(struct skb_share=
d_hwtstamps));
> > > > > > > > > > > >>          hwts->hwtstamp =3D ns_to_ktime(nsec);
> > > > > > > > > > > >> }
> > > > > > > > > > > >>
> > > > > > > > > > > >> I think the nsec is what you really want.
> > > > > > > > > > > >>
> > > > > > > > > > > >> With all the drivers doing slightly different op=
s we would have
> > > > > > > > > > > >> to create read_seqbegin, read_seqretry, mutex_lo=
ck, ... to get
> > > > > > > > > > > >> at least the mlx and ice drivers it looks like w=
e would need some
> > > > > > > > > > > >> more BPF primitives/helpers. Looks like some mor=
e work is needed
> > > > > > > > > > > >> on ice driver though to get rx tstamps on all pa=
ckets.
> > > > > > > > > > > >>
> > > > > > > > > > > >> Anyways this convinced me real devices will prob=
ably use BPF_CALL
> > > > > > > > > > > >> and not BPF insns directly.
> > > > > > > > > > > >
> > > > > > > > > > > > Some of the mlx5 path looks like this:
> > > > > > > > > > > >
> > > > > > > > > > > > #define REAL_TIME_TO_NS(hi, low) (((u64)hi) * NSE=
C_PER_SEC + ((u64)low))
> > > > > > > > > > > >
> > > > > > > > > > > > static inline ktime_t mlx5_real_time_cyc2time(str=
uct mlx5_clock *clock,
> > > > > > > > > > > >                                                u6=
4 timestamp)
> > > > > > > > > > > > {
> > > > > > > > > > > >          u64 time =3D REAL_TIME_TO_NS(timestamp >=
> 32, timestamp & 0xFFFFFFFF);
> > > > > > > > > > > >
> > > > > > > > > > > >          return ns_to_ktime(time);
> > > > > > > > > > > > }
> > > > > > > > > > > >
> > > > > > > > > > > > If some hints are harder to get, then just doing =
a kfunc call is better.
> > > > > > > > > > >
> > > > > > > > > > > Sure, but if we end up having a full function call =
for every field in
> > > > > > > > > > > the metadata, that will end up having a significant=
 performance impact
> > > > > > > > > > > on the XDP data path (thinking mostly about the skb=
 metadata case here,
> > > > > > > > > > > which will collect several bits of metadata).
> > > > > > > > > > >
> > > > > > > > > > > > csum may have a better chance to inline?
> > > > > > > > > > >
> > > > > > > > > > > Yup, I agree. Including that also makes it possible=
 to benchmark this
> > > > > > > > > > > series against Jesper's; which I think we should de=
finitely be doing
> > > > > > > > > > > before merging this.
> > > > > > > > > >
> > > > > > > > > > Good point I got sort of singularly focused on timest=
amp because I have
> > > > > > > > > > a use case for it now.
> > > > > > > > > >
> > > > > > > > > > Also hash is often sitting in the rx descriptor.
> > > > > > > > >
> > > > > > > > > Ack, let me try to add something else (that's more inli=
ne-able) on the
> > > > > > > > > rx side for a v2.
> > > > > > > >
> > > > > > > > If you go with in-kernel BPF kfunc approach (vs user spac=
e side) I think
> > > > > > > > you also need to add CO-RE to be friendly for driver deve=
lopers? Otherwise
> > > > > > > > they have to keep that read in sync with the descriptors?=
 Also need to
> > > > > > > > handle versioning of descriptors where depending on speci=
fic options
> > > > > > > > and firmware and chip being enabled the descriptor might =
be moving
> > > > > > > > around. Of course can push this all to developer, but see=
ms not so
> > > > > > > > nice when we have the machinery to do this and we handle =
it for all
> > > > > > > > other structures.
> > > > > > > >
> > > > > > > > With CO-RE you can simply do the rx_desc->hash and rx_des=
c->csum and
> > > > > > > > expect CO-RE sorts it out based on currently running btf_=
id of the
> > > > > > > > descriptor. If you go through normal path you get this fo=
r free of
> > > > > > > > course.
> > > > > > >
> > > > > > > Doesn't look like the descriptors are as nice as you're try=
ing to
> > > > > > > paint them (with clear hash/csum fields) :-) So not sure ho=
w much
> > > > > > > CO-RE would help.
> > > > > > > At least looking at mlx4 rx_csum, the driver consults three=
 different
> > > > > > > sets of flags to figure out the hash_type. Or am I just unl=
ucky with
> > > > > > > mlx4?
> > > > > >
> > > > > > Which part are you talking about ?
> > > > > >         hw_checksum =3D csum_unfold((__force __sum16)cqe->che=
cksum);
> > > > > > is trivial enough for bpf prog to do if it has access to 'cqe=
' pointer
> > > > > > which is what John is proposing (I think).
> >
> > Yeah this is what I've been considering. If you just get the 'cqe' po=
inter
> > walking the check_sum and rxhash should be straightforward.
> >
> > There seems to be a real difference between timestamps and most other=

> > fields IMO. Timestamps require some extra logic to turn into ns when
> > using the NIC hw clock. And the hw clock requires some coordination t=
o
> > keep in sync and stop from overflowing and may be done through other
> > protocols like PTP in my use case. In some cases I think the clock is=

> > also shared amongst multiple phys. Seems mlx has a seqlock_t to prote=
ct
> > it and I'm less sure about this but seems intel nic maybe has a sideb=
and
> > control channel.
> >
> > Then there is everything else that I can think up that is per packet =
data
> > and requires no coordination with the driver. Its just reading fields=
 in
> > the completion queue. This would be the csum, check_sum, vlan_header =
and
> > so on. Sure we could kfunc each one of those things, but could also j=
ust
> > write that directly in BPF and remove some abstractions and kernel
> > dependency by doing it directly in the BPF program. If you like that
> > abstraction seems to be the point of contention my opinion is the cos=
t
> > of kernel depency is high and I can abstract it with a user library
> > anyways so burying it in the kernel only causes me support issues and=

> > backwards compat problems.
> >
> > Hopefully, my position is more clear.
> =

> Yeah, I see your point, I'm somewhat in the same position here wrt to
> legacy kernels :-)
> Exposing raw descriptors seems fine, but imo it shouldn't be the goto
> mechanism for the metadata; but rather as a fallback whenever the
> driver implementation is missing/buggy. Unless, as you mention below,
> there are some libraries in the future to abstract that.
> But at least it seems that we agree that there needs to be some other
> non-raw-descriptor way to access spinlocked things like the timestamp?
> =


Yeah for timestamps I think a kfunc to either get the timestamp or could
also be done with a kfunc to read hw clock. But either way seems hard
to do that in BPF code directly so kfunc feels right to me here.

By the way I think if you have the completion queue (rx descriptor) in
the xdp_buff and we use Yonghong's patch to cast the ctx as a BTF type
then we should be able to also directly read all the fields. I see
you noted this in the response to Alexei so lets see what he thinks.=
