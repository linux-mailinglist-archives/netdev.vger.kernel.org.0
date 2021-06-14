Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB733A70A6
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbhFNUns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbhFNUnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 16:43:42 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89E3C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 13:41:26 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id f84so17383061ybg.0
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 13:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O0UhRDcSo6ocnxdml9EhdnoMC8WTrw2g8TbjqojbzNg=;
        b=SntJ6TUfDJ9C1s7VnfzBlLIvQz8ddDQW/qEHdR+vR0RTZ6Uxd6BVTvXmd4a8wMEcWo
         B7Vdwxa6h698iHV5Y8URao2PDPlycyrispW2sDac8zfS+GAzVvIcD0ZJp69fHDY7mnBL
         hAdIAhV5Ca7L1/JvpjznLTQV9dAhI8feWnmRoEaZCzp8ZD8XH79UEJOyNLkk22Grb4U3
         S+V3SpG3+BR6Jchzcs8ZhcXTLtndQJk6NCRAjxFd/cdA9wAiAXE2xWQUoDSo8r83gLM4
         2JM0og68EOwCzjwbF+rxO0iv6rl2xdK8A+3NXo7QLkOzSvw9qX1Up59DatjvI9IRBgwE
         iN6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O0UhRDcSo6ocnxdml9EhdnoMC8WTrw2g8TbjqojbzNg=;
        b=gJF4TVQNL8DHKSb2q/7/1Hfc9YgQpGxKx+Zt9Kt4Zblb7CKq89Y5SqpqtTxGk0NQ2s
         A6MI+CmoWsdiu9zJXIrPramRurrEfk+mV4Iu/3ieYSxa/ijr9j3RD4Jv7PgcXkYn5Nis
         rPP8Rnfh5cwUjsl+xGvTDbT93GsqwoeAoUQTNVrwXmy9FH2Bl7yJMANj0CSUh3bMqgxB
         S/Kv/fp9WzloR4jpFJHt75+pvI+gLYVD/0SPRqJIeMibhnTcMN+uEDtnN1ke7cYolC4e
         f6IgZj2UI+MMWvALUhEMX5+cEMm+7U5iyfkgE+RqTOIdHKYYQzZGlSJHPVcvSCG7Hllk
         zQEw==
X-Gm-Message-State: AOAM530tXzjNpGCUx/iLbjOE2H91cfLnkviZM7xSD5rkfHWYW0CmugtK
        wdRxxGXcBOdDIUSZS5X5DkyXKXEJzH1XYFlP8wU=
X-Google-Smtp-Source: ABdhPJwPOVjaSeGHaCPTtK4/SWuLZDToZGcsl7+g9FFdrE1Lv0yLYM2An1Rp+CoCe7zBWFUBgbRaaJOMyf717CtKP5Q=
X-Received: by 2002:a25:389:: with SMTP id 131mr28111072ybd.306.1623703286123;
 Mon, 14 Jun 2021 13:41:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com> <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com> <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com> <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com> <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
 <4c80aacf-d61b-823f-71fe-68634a88eaa6@redhat.com> <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
In-Reply-To: <CA+FuTSffghgcN5Prmas395eH+PAeKiHu0N6EKv5GwvSLZ+Jm8Q@mail.gmail.com>
From:   Tanner Love <tannerlove.kernel@gmail.com>
Date:   Mon, 14 Jun 2021 13:41:15 -0700
Message-ID: <CAHrNZNjfNU-XPHk+XHoXQ78PZeFNA3dZAg1kfFexgcH522j=jQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Tanner Love <tannerlove@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 7:13 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Jun 10, 2021 at 11:40 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > =E5=9C=A8 2021/6/11 =E4=B8=8A=E5=8D=8810:45, Willem de Bruijn =E5=86=99=
=E9=81=93:
> > > On Thu, Jun 10, 2021 at 10:11 PM Jason Wang <jasowang@redhat.com> wro=
te:
> > >>
> > >> =E5=9C=A8 2021/6/10 =E4=B8=8B=E5=8D=8810:04, Willem de Bruijn =E5=86=
=99=E9=81=93:
> > >>> On Thu, Jun 10, 2021 at 1:25 AM Jason Wang <jasowang@redhat.com> wr=
ote:
> > >>>> =E5=9C=A8 2021/6/10 =E4=B8=8B=E5=8D=8812:19, Alexei Starovoitov =
=E5=86=99=E9=81=93:
> > >>>>> On Wed, Jun 9, 2021 at 9:13 PM Jason Wang <jasowang@redhat.com> w=
rote:
> > >>>>>> So I wonder why not simply use helpers to access the vnet header=
 like
> > >>>>>> how tcp-bpf access the tcp header?
> > >>>>> Short answer - speed.
> > >>>>> tcp-bpf accesses all uapi and non-uapi structs directly.
> > >>>>>
> > >>>> Ok, this makes sense. But instead of coupling device specific stuf=
fs
> > >>>> like vnet header and neediness into general flow_keys as a context=
.
> > >>>>
> > >>>> It would be better to introduce a vnet header context which contai=
ns
> > >>>>
> > >>>> 1) vnet header
> > >>>> 2) flow keys
> > >>>> 3) other contexts like endian and virtio-net features
> > >>>>
> > >>>> So we preserve the performance and decouple the virtio-net stuffs =
from
> > >>>> general structures like flow_keys or __sk_buff.
> > >>> You are advocating for a separate BPF program that takes a vnet hdr
> > >>> and flow_keys as context and is run separately after flow dissectio=
n?
> > >>
> > >> Yes.
> > >>
> > >>
> > >>> I don't understand the benefit of splitting the program in two in t=
his manner.
> > >>
> > >> It decouples a device specific attributes from the general structure=
s
> > >> like flow keys. We have xen-netfront, netvsc and a lot of drivers th=
at
> > >> works for the emulated devices. We could not add all those metadatas=
 as
> > >> the context of flow keys.
> > > What are device-specific attributes here? What kind of metadata?
> >
> >
> > Isn't virtio_net_hdr a virito-net specific metadata?
>
> I don't think it is ever since it was also adopted for tun, tap,
> pf_packet and uml. Basically, all callers of virtio_net_hdr_to_skb.
>
> >
> >
> > >
> > > The only metadata that can be passed with tuntap, pf_packet et al is
> > > virtio_net_hdr.
> > >
> > > I quite don't understand where xen-netfront et al come in.
> >
> >
> > The problem is, what kind of issue you want to solve. If you want to
> > solve virtio specific issue, why do you need to do that in the general
> > flow dissector?

Suppose we determine that it would indeed also be good to add
support for xen-netfront, netvsc validation in this way. Is your
suggestion that these would need to be added all in the same patch
series? Could we not implement just virtio-net first, and add the
others subsequently, if we can demonstrate a feasible plan for
doing so? Thanks

>
> >
> > If you want to solve the general issue of the packet metadata validatio=
n
> > from untrusted source, you need validate not only virtio-net but all th=
e
> > others. Netfront is another dodgy source and there're a lot of implied
> > untrusted source in the case of virtualization environment.
>
> Ah understood.
>
> Yes, the goal is to protect the kernel from untrusted packets coming
> from userspace in general. There are only a handful such injection
> APIs.
>
> I have not had to deal with netfront as much as the virtio_net_hdr
> users. I'll take a look at that and netvsc. I cannot recall seeing as
> many syzkaller reports about those, but that may not necessarily imply
> that they are more robust -- it could just be that syzkaller has no
> easy way to exercise them, like with packet sockets.
>
> >
> > >
> > >> That's why I suggest to use something more
> > >> generic like XDP from the start. Yes, GSO stuffs was disabled by
> > >> virtio-net on XDP but it's not something that can not be fixed. If t=
he
> > >> GSO and s/g support can not be done in short time
> > > An alternative interface does not address that we already have this
> > > interface and it is already causing problems.
> >
> >
> > What problems did you meant here?
>
> The long list of syzkaller bugs that required fixes either directly in
> virtio_net_hdr_to_skb or deeper in the stack, e.g.,
>
> 924a9bc362a5 net: check if protocol extracted by
> virtio_net_hdr_set_proto is correct
> 6dd912f82680 net: check untrusted gso_size at kernel entry
> 9274124f023b net: stricter validation of untrusted gso packets
> d2aa125d6290 net: Don't set transport offset to invalid value
> d5be7f632bad net: validate untrusted gso packets without csum offload
> 9d2f67e43b73 net/packet: fix packet drop as of virtio gso
>
> 7c68d1a6b4db net: qdisc_pkt_len_init() should be more robust
> cb9f1b783850 ip: validate header length on virtual device xmit
> 418e897e0716 gso: validate gso_type on ipip style tunnels
> 121d57af308d gso: validate gso_type in GSO handlers
>
> This is not necessarily an exhaustive list.
>
> And others not directly due to gso/csum metadata, but malformed
> packets from userspace nonetheless, such as
>
> 76c0ddd8c3a6 ip6_tunnel: be careful when accessing the inner header
>
> > >
> > >> then a virtio-net
> > >> specific BPF program still looks much better than coupling virtio-ne=
t
> > >> metadata into flow keys or other general data structures.
> > >>
> > >>
> > >>> Your previous comment mentions two vnet_hdr definitions that can ge=
t
> > >>> out of sync. Do you mean v1 of this patch, that adds the individual
> > >>> fields to bpf_flow_dissector?
> > >>
> > >> No, I meant this part of the patch:
> > >>
> > >>
> > >> +static int check_virtio_net_hdr_access(struct bpf_verifier_env *env=
,
> > >> int off,
> > >> +                       int size)
> > >> +{
> > >> +    if (size < 0 || off < 0 ||
> > >> +        (u64)off + size > sizeof(struct virtio_net_hdr)) {
> > >> +        verbose(env, "invalid access to virtio_net_hdr off=3D%d siz=
e=3D%d\n",
> > >> +            off, size);
> > >> +        return -EACCES;
> > >> +    }
> > >> +    return 0;
> > >> +}
> > >> +
> > >>
> > >>
> > >> It prevents the program from accessing e.g num_buffers.
> > > I see, thanks. See my response to your following point.
> > >
> > >>
> > >>> That is no longer the case: the latest
> > >>> version directly access the real struct. As Alexei points out, doin=
g
> > >>> this does not set virtio_net_hdr in stone in the ABI. That is a val=
id
> > >>> worry. But so this patch series will not restrict how that struct m=
ay
> > >>> develop over time. A version field allows a BPF program to parse th=
e
> > >>> different variants of the struct -- in the same manner as other
> > >>> protocol headers.
> > >>
> > >> The format of the virtio-net header depends on the virtio features, =
any
> > >> reason for another version? The correct way is to provide features i=
n
> > >> the context, in this case you don't event need the endian hint.
> > > That might work. It clearly works for virtio. Not sure how to apply i=
t
> > > to pf_packet or tuntap callers of virtio_net_hdr_to_skb.
> >
> >
> > This requires more thought but it also applies to the version. For
> > tuntap, features could be deduced from the 1) TUN_SET_VET_HDR and 2)
> > TUN_SET_OFFLOADS
> >
> > Note that theatrically features could be provided by the userspace, but
> > version is not (unless it's a part of uAPI but it became a duplication
> > of the features).
> >
> > Actually, this is a strong hint that the conext for packet, tuntap is
> > different with virtio-net (though they are sharing the same (or patial)
> > vnet header structure). E.g tuntap is unaware of mergerable buffers, it
> > just leave the room for vhost-net or qemu to fill that fields.
>
> True. We need to pass the length of the struct along with any
> version/typing information (which is currently only that endianness
> boolean). Also to address the bounds checking issue you raised above.
>
> >
> > >
> > >>> If you prefer, we can add that field from the start.
> > >>> I don't see a benefit to an extra layer of indirection in the form =
of
> > >>> helper functions.
> > >>>
> > >>> I do see downsides to splitting the program. The goal is to ensure
> > >>> consistency between vnet_hdr and packet payload. A program split
> > >>> limits to checking vnet_hdr against what the flow_keys struct has
> > >>> extracted. That is a great reduction over full packet access.
> > >>
> > >> Full packet access could be still done in bpf flow dissector.
> > >>
> > >>
> > >>> For
> > >>> instance, does the packet contain IP options? No idea.
> > >>
> > >> I don't understand here. You can figure out this in flow dissector, =
and
> > >> you can extend the flow keys to carry out this information if necess=
ary.
> > > This I disagree with. flow_keys are a distillation/simplification of
> > > the packet contents. It is unlikely to capture every feature of every
> > > packet.
> >
> >
> > It depends on what kind of checks you want to do. When introducing a ne=
w
> > API like this, we need to make sure all the fields could be validated
> > instead of limiting it to some specific fields. Not all the fields are
> > related to the flow, that's another point that validating it in the flo=
w
> > dissector is not a good choice.
> >
> > For vnet_header fields that is related to the flow, they should be a
> > subset of the current flow keys otherwise it's a hint a flow keys need
> > to be extended. For vnet_header fields that is not related to the flow,
> > validate it in flow dissector requires a lot of other context (features=
,
> > and probably the virtqueue size for the num_buffers). And if you want t=
o
> > validate things that is totally unrelated to the vnet header (e.g IP
> > option), it can be done in the flow dissector right now or via XDP.
>
> But correlating this data with the metadata is needlessly more complex
> with two programs vs one. The issue is not that flow keys can capture
> all vnet_hdr fields. It is that it won't capture all relevant packet
> contents.
>
> >
> > >   We end up having to extend it for every new case we're
> > > interested in. That is ugly and a lot of busywork. And for what
> > > purpose? The virtio_net_hdr field prefaces the protocol headers in th=
e
> > > same buffer in something like tpacket. Processing the metadata
> > > together with the data is straightforward. I don't see what isolation
> > > or layering that breaks.
> >
> >
> > Well, if you want to process metadata with the data, isn't XDP a much
> > more better place to do that?
>
> XDP or bpf flow dissector: they are both BPF programs. The defining
> point is what context to pass along.
>
> > >
> > >> And if you want to have more capability, XDP which is designed for e=
arly
> > >> packet filtering is the right way to go which have even more functio=
ns
> > >> that a simple bpf flow dissector.
> > >>
> > >>> If stable ABI is not a concern and there are no different struct
> > >>> definitions that can go out of sync, does that address your main
> > >>> concerns?
> > >>
> > >> I think not. Assuming we provide sufficient contexts (e.g the virtio
> > >> features), problem still: 1) coupling virtio-net with flow_keys
> > > A flow dissection program is allowed to read both contents of struct
> > > virtio_net_hdr and packet contents. virtio_net_hdr is not made part o=
f
> > > struct bpf_flow_keys.
> >
> >
> > It doesn't matter whether or not it's a pointer. And actually you had
> > vhdr_is_little_endian:
> >
> > @@ -6017,6 +6017,8 @@ struct bpf_flow_keys {
> >         };
> >         __u32   flags;
> >         __be32  flow_label;
> > +       __bpf_md_ptr(const struct virtio_net_hdr *, vhdr);
> > +       __u8    vhdr_is_little_endian;
> >   };
> >
> >
> > And if we want to add the support to validate other untrusted sources,
> > do we want:
> >
> > struct bpf_flow_keys {
> >      /* general fields */
> >      virtio_net_context;
> >      xen_netfront_context;
> >      netvsc_context;
> >      ...
> > };
> >
> > ?
>
> No, I think just a pointer to the metadata context and a
> type/versioning field that tells the program how to interpret it. A
> strict program can drop everything that it does not understand. It
> does not have to be complete.
>
> > >   The pointer there is just a way to give access
> > > to multiple data sources through the single bpf program context.
> > >
> > >> 2) can't work for XDP.
> > > This future work (AF_?)XDP based alternative to
> > > pf_packet/tuntap/virtio does not exist yet, so it's hard to fully
> > > prepare for. But any replacement interface will observe the same
> > > issue: when specifying offloads like GSO/csum, that metadata may not
> > > agree with actual packet contents. We have to have a way to validate
> > > that. I could imagine that this XDP program attached to the AF_XDP
> > > interface would do the validation itself?
> >
> >
> > If the XDP can do validation itself, any reason to duplicate the work i=
n
> > the flow dissector?
> >
> >
> > > Is that what you mean?
> >
> >
> > Kind of, it's not specific to AF_XDP, assuming XDP supports GSO/sg. Wit=
h
> > XDP_REDIRECT/XDP_TX, you still need to validate the vnet header.
>
> The purpose is validation of data coming from untrusted userspace into
> the kernel.
>
> XDP_REDIRECT and XDP_TX forward data within the kernel, so are out of sco=
pe.
>
> In the case where they are used along with some ABI through which data
> can be inserted into the kernel, such as AF_XDP, it is relevant. And I
> agree that then the XDP program can do the validation directly.
>
> That just does not address validating of legacy interfaces. Those
> interfaces generally require CAP_NET_RAW to setup, but they are often
> used after setup to accept untrusted contents, so I don't think they
> should be considered "root, so anything goes".
>
> > Thanks
>
> Thanks for the discussion. As said, we'll start by looking at the
> other similar netfront interfaces.
>
> >
> > >
> >
