Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1BD3A39E0
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhFKCsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFKCsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:48:54 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700EBC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:46:41 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ba2so33644953edb.2
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+JxCOJ5A2lMZYi8lJhjVtVf/w1e/mdUdx+3UWmlpfvs=;
        b=TvhxzhTzsnfNXHJVkJdKU9SMd3+K/ntmP/8uSv5CMezInFPj603SN9fb49gh0oJZNY
         H04eEuqx/KKuB35y6yvn2kJCkx0rs2uCaSpe4U3alCK4cngFoEyuNS5nKvJ4WPzjhnNM
         +2ViUyRv2j64Ok0r4bUmDbulva887vis/YDDB3Aqcxfwf59HDsyS7wzlL8PevIgZRctq
         KRDWDTbyAo9mGTIAxHVmydKJ1NcP2n6py2Gi2cfqiXEwKXtyregER+ALOFnUl3pCak48
         OiwPeiEcm2sX+surVQCKuEMVfderCBdRxw5z7+wAZfd4/ZjnlV3NtNyzyjpZDlhzQlNl
         I3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+JxCOJ5A2lMZYi8lJhjVtVf/w1e/mdUdx+3UWmlpfvs=;
        b=XxLWwRuNoQRr+u9WKySv76u4bOBwEBTIPwzYfQ0Hlp7/n2/jJk/JbMq3n7WWiNwX58
         0n3E8KkC1+qy/e+C2+/sDZZr8+Gt3O4Up52WeNiIijCAoy3be7+XUsH2fPz+aYsvflko
         jBjmJg8AyXshSti/HbCL3FDjRdZbwvkpcphgXprruR7WzU1L0QlyiA7xCn9X/jzcF6FF
         36bgGhMMuoPc02GZfbb0CNAm0pRzzO8aeDvVR5Tnf8DkorGo4EB8miCZkjOwbNTg4zY+
         /dk7C3FsUObVzZEX3i6oD9Imakgdv3Qs0z1jtZ712gnV5keoZ28jhFLTTx8uwZ2qsCWP
         WpHg==
X-Gm-Message-State: AOAM533aMWRz4qi5wv2BOOzNpyJ01QQHkTbvUV8wTJWjyeh7BIpYCwfV
        WE4Lj1N/o4C2QTBoFZ3d8t5uTlYXlTRGVg==
X-Google-Smtp-Source: ABdhPJxY/tttJO1qGK/xE7PNu7NMjB+CkKhMkcOHJDSRIN438KTToMqCJuy96jKMtiEnQFryEabaWg==
X-Received: by 2002:a05:6402:1652:: with SMTP id s18mr1304242edx.131.1623379598910;
        Thu, 10 Jun 2021 19:46:38 -0700 (PDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com. [209.85.221.43])
        by smtp.gmail.com with ESMTPSA id r19sm2110581eds.75.2021.06.10.19.46.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 19:46:37 -0700 (PDT)
Received: by mail-wr1-f43.google.com with SMTP id l2so4356935wrw.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 19:46:37 -0700 (PDT)
X-Received: by 2002:a5d:6209:: with SMTP id y9mr1381208wru.50.1623379597018;
 Thu, 10 Jun 2021 19:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-3-tannerlove.kernel@gmail.com> <17315e5a-ee1c-489c-a6bf-0fa26371d710@redhat.com>
 <CA+FuTSfvdHBLOqAAU=vPmqnUxhp_b61Cixm=0cd7uh_KsJZGGw@mail.gmail.com>
 <51d301ee-8856-daa4-62bd-10d3d53a3c26@redhat.com> <CAADnVQKHpk5aXA-MiuHyvBC7ZCxDPmN_gKAVww8kQAjoZkkmjA@mail.gmail.com>
 <6ae4f189-a3be-075d-167c-2ad3f8d7d975@redhat.com> <CAADnVQL_+oKjH341ccC_--ing6dviAPwWRocgYrTKidkKo-NcA@mail.gmail.com>
 <2fd24801-bf77-02e3-03f5-b5e8fac595b6@redhat.com> <CA+FuTSeuq4K=nA_JPomyZv4SkQY0cGWdEf1jftx_1Znd+=tOZw@mail.gmail.com>
 <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com>
In-Reply-To: <8f2fd333-1cc6-6bcc-3e7d-144bbd5e35a3@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Jun 2021 22:45:58 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
Message-ID: <CA+FuTSdhL+BsqzRJGJD9XH2CATK5-yDE1Uts8gk8Rf_WTsQAGw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tanner Love <tannerlove.kernel@gmail.com>,
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

On Thu, Jun 10, 2021 at 10:11 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/10 =E4=B8=8B=E5=8D=8810:04, Willem de Bruijn =E5=86=99=
=E9=81=93:
> > On Thu, Jun 10, 2021 at 1:25 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/6/10 =E4=B8=8B=E5=8D=8812:19, Alexei Starovoitov =E5=86=
=99=E9=81=93:
> >>> On Wed, Jun 9, 2021 at 9:13 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>> So I wonder why not simply use helpers to access the vnet header lik=
e
> >>>> how tcp-bpf access the tcp header?
> >>> Short answer - speed.
> >>> tcp-bpf accesses all uapi and non-uapi structs directly.
> >>>
> >> Ok, this makes sense. But instead of coupling device specific stuffs
> >> like vnet header and neediness into general flow_keys as a context.
> >>
> >> It would be better to introduce a vnet header context which contains
> >>
> >> 1) vnet header
> >> 2) flow keys
> >> 3) other contexts like endian and virtio-net features
> >>
> >> So we preserve the performance and decouple the virtio-net stuffs from
> >> general structures like flow_keys or __sk_buff.
> > You are advocating for a separate BPF program that takes a vnet hdr
> > and flow_keys as context and is run separately after flow dissection?
>
>
> Yes.
>
>
> >
> > I don't understand the benefit of splitting the program in two in this =
manner.
>
>
> It decouples a device specific attributes from the general structures
> like flow keys. We have xen-netfront, netvsc and a lot of drivers that
> works for the emulated devices. We could not add all those metadatas as
> the context of flow keys.

What are device-specific attributes here? What kind of metadata?

The only metadata that can be passed with tuntap, pf_packet et al is
virtio_net_hdr.

I quite don't understand where xen-netfront et al come in.

> That's why I suggest to use something more
> generic like XDP from the start. Yes, GSO stuffs was disabled by
> virtio-net on XDP but it's not something that can not be fixed. If the
> GSO and s/g support can not be done in short time

An alternative interface does not address that we already have this
interface and it is already causing problems.

> then a virtio-net
> specific BPF program still looks much better than coupling virtio-net
> metadata into flow keys or other general data structures.
>
>
> >
> > Your previous comment mentions two vnet_hdr definitions that can get
> > out of sync. Do you mean v1 of this patch, that adds the individual
> > fields to bpf_flow_dissector?
>
>
> No, I meant this part of the patch:
>
>
> +static int check_virtio_net_hdr_access(struct bpf_verifier_env *env,
> int off,
> +                       int size)
> +{
> +    if (size < 0 || off < 0 ||
> +        (u64)off + size > sizeof(struct virtio_net_hdr)) {
> +        verbose(env, "invalid access to virtio_net_hdr off=3D%d size=3D%=
d\n",
> +            off, size);
> +        return -EACCES;
> +    }
> +    return 0;
> +}
> +
>
>
> It prevents the program from accessing e.g num_buffers.

I see, thanks. See my response to your following point.

>
>
> > That is no longer the case: the latest
> > version directly access the real struct. As Alexei points out, doing
> > this does not set virtio_net_hdr in stone in the ABI. That is a valid
> > worry. But so this patch series will not restrict how that struct may
> > develop over time. A version field allows a BPF program to parse the
> > different variants of the struct -- in the same manner as other
> > protocol headers.
>
>
> The format of the virtio-net header depends on the virtio features, any
> reason for another version? The correct way is to provide features in
> the context, in this case you don't event need the endian hint.

That might work. It clearly works for virtio. Not sure how to apply it
to pf_packet or tuntap callers of virtio_net_hdr_to_skb.

>
> > If you prefer, we can add that field from the start.
> > I don't see a benefit to an extra layer of indirection in the form of
> > helper functions.
> >
> > I do see downsides to splitting the program. The goal is to ensure
> > consistency between vnet_hdr and packet payload. A program split
> > limits to checking vnet_hdr against what the flow_keys struct has
> > extracted. That is a great reduction over full packet access.
>
>
> Full packet access could be still done in bpf flow dissector.
>
>
> > For
> > instance, does the packet contain IP options? No idea.
>
>
> I don't understand here. You can figure out this in flow dissector, and
> you can extend the flow keys to carry out this information if necessary.

This I disagree with. flow_keys are a distillation/simplification of
the packet contents. It is unlikely to capture every feature of every
packet. We end up having to extend it for every new case we're
interested in. That is ugly and a lot of busywork. And for what
purpose? The virtio_net_hdr field prefaces the protocol headers in the
same buffer in something like tpacket. Processing the metadata
together with the data is straightforward. I don't see what isolation
or layering that breaks.

> And if you want to have more capability, XDP which is designed for early
> packet filtering is the right way to go which have even more functions
> that a simple bpf flow dissector.
>
> >
> > If stable ABI is not a concern and there are no different struct
> > definitions that can go out of sync, does that address your main
> > concerns?
>
>
> I think not. Assuming we provide sufficient contexts (e.g the virtio
> features), problem still: 1) coupling virtio-net with flow_keys

A flow dissection program is allowed to read both contents of struct
virtio_net_hdr and packet contents. virtio_net_hdr is not made part of
struct bpf_flow_keys. The pointer there is just a way to give access
to multiple data sources through the single bpf program context.

> 2) can't work for XDP.

This future work (AF_?)XDP based alternative to
pf_packet/tuntap/virtio does not exist yet, so it's hard to fully
prepare for. But any replacement interface will observe the same
issue: when specifying offloads like GSO/csum, that metadata may not
agree with actual packet contents. We have to have a way to validate
that. I could imagine that this XDP program attached to the AF_XDP
interface would do the validation itself? Is that what you mean?
