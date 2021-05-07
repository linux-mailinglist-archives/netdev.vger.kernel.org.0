Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AAD376668
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237299AbhEGNvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 09:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhEGNvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 09:51:40 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8F7C061574;
        Fri,  7 May 2021 06:50:40 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id z1so4809432qvo.4;
        Fri, 07 May 2021 06:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ug6/WueshmXOGl23GbAx0pDE7wn9vqsVPBFBKmBVLGM=;
        b=TDS9bgz8iVDh71rpYkpw/zfCPFhq3A+fFAI2QTq4JgMhyjDx+KlWcsMH0UeSM3b2zS
         rjCTkRJCLue0lWWw9Ht+krun3eIPgB9SljgwdOQ9qBWqtRmGKBYme0f1sIXlWkS8RfbX
         4Yi25c+oirAD0GyEOz3ijfu8Ezd1iKX7MRR2eFpFPAf1VfErVLFGHQSjV3ud5JSk3th2
         hTvO0F9wO1qPKgVwhFiny9RLdG5EGa5/zXtyQUZyR+3mWXy2xydd6i+rGdo4HL7JeDbg
         B4Pc18tb1asguAghjMs3MG5/ggP8Z5M2Q+k0BD3JaKd/fNwKFPGyAGxGFsBHIxQ+8MUz
         GRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ug6/WueshmXOGl23GbAx0pDE7wn9vqsVPBFBKmBVLGM=;
        b=qDITt285cVEiZ3eXjLm2qliAuKjlOJvgruC9lmmEnRc3f9+RWU/VoAvloe90WulD0R
         LJId8/ulI5RlJrtEBw2rwahPZdxf//f0WkFxmKl5O961NbjuyTWsy18Ab4rLGMRAGt6k
         GgXKxIvnWp59ZATVJwpYQehqBxm/Ew8TLEyxCuwu419boy/joxJ2uVOt+KanbcdpwKMX
         wsAL3W5B4Evi7AfWtuBrOHcDPagNiuda9XlRjeLI08MC66+tcxKDQ7t3z30JAocalaN3
         7UbrzcdSWEdF+gGynDF3ceiGb4B8V4nM8VpXdKHS3TQXuSysaV2VY5UnOfQAieeuX2wJ
         AIiw==
X-Gm-Message-State: AOAM533QrMVLzeECOfEU32JJiHmv0b/F5+s2e4I2RrzLJMKT9rHNiDGK
        0FjIAv1CGf3bLVVvc3IEGFIDd1UR2tBCNgWDNJg=
X-Google-Smtp-Source: ABdhPJyIERFuH5ORTuocCeqxAS8ubtAt1zYF5HaS9YLJ2GibN5VGNQXk08DgbZPELGXPj9HvmGe7K22cNQjfShlxRgo=
X-Received: by 2002:a0c:f18a:: with SMTP id m10mr10195834qvl.22.1620395439724;
 Fri, 07 May 2021 06:50:39 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com> <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
 <02c801d7421f$65287a90$2f796fb0$@samsung.com> <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
 <001801d742db$68ab8060$3a028120$@samsung.com> <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
 <436dbc62-451b-9b29-178d-9da28f47ef24@huawei.com> <CAF=yD-+d0QYj+812joeuEx1HKPzDyhMpkZP5aP=yNBzrQT5usw@mail.gmail.com>
 <007001d7431a$96281960$c2784c20$@samsung.com>
In-Reply-To: <007001d7431a$96281960$c2784c20$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 7 May 2021 09:50:03 -0400
Message-ID: <CAF=yD-L9pxAFoT+c1Xk5YS42ZaJ+YLVQVnV+fvtqn-gLxq9ENg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 4:25 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> On Thu, May 06, 2021 at 09:53:45PM -0400, Willem de Bruijn wrote:
> > On Thu, May 6, 2021 at 9:45 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> > >
> > > On 2021/5/7 9:25, Willem de Bruijn wrote:
> > > >>>> head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> > > >>>> data_len could be 8 if server sent a small size packet and it is GROed
> > > >>>> to head_skb.
> > > >>>>
> > > >>>> Please let me know if I am missing something.
> > > >>>
> > > >>> This is my understanding of the data path. This is a forwarding path
> > > >>> for TCP traffic.
> > > >>>
> > > >>> GRO is enabled and will coalesce multiple segments into a single large
> > > >>> packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
> > > >>> + 20.
> > > >>>
> > > >>> Somewhere between GRO and GSO you have a BPF program that converts the
> > > >>> IPv6 address to IPv4.
> > > >>
> > > >> Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
> > > >> GSO.
> > > >>
> > > >>>
> > > >>> There is no concept of head_skb at the time of this BPF program. It is
> > > >>> a single SKB, with an skb linear part and multiple data items in the
> > > >>> frags (no frag_list).
> > > >>
> > > >> Sorry for the confusion. head_skb what I mentioned was a skb linear
> > > >> part. I'm considering a single SKB with frags too.
> > > >>
> > > >>>
> > > >>> When entering the GSO stack, this single skb now has a payload length
> > > >>> < MSS. So it would just make a valid TCP packet on its own?
> > > >>>
> > > >>> skb_gro_len is only relevant inside the GRO stack. It internally casts
> > > >>> the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
> > > >>> reused for other purposes later by other layers of the datapath. It is
> > > >>> not safe to read this inside bpf_skb_proto_6_to_4.
> > > >>
> > > >> The condition what I made uses skb->data_len not skb_gro_len. Does
> > > >> skb->data_len have a different meaning on each layer? As I know,
> > > >> data_len indicates the amount of frags or frag_list. skb->data_len
> > > >> should be > 20 in the sample case because the payload size of the skb
> > > >> linear part is the same with mss.
> > > >
> > > > Ah, got it.
> > > >
> > > > data_len is the length of the skb minus the length in the skb linear
> > > > section (as seen in skb_headlen).
> > > >
> > > > So this gso skb consists of two segments, the first one entirely
> > > > linear, the payload of the second is in skb_shinfo(skb)->frags[0].
> > > >
> > > > It is not guaranteed that gso skbs built from two individual skbs end
> > > > up looking like that. Only protocol headers in the linear segment and
> > > > the payload of both in frags is common.
> > > >
> > > >> We can modify netif_needs_gso as another option to hit
> > > >> skb_needs_linearize in validate_xmit_skb. But I think we should compare
> > > >> skb->gso_size and skb->data_len too to check if mss exceed a payload
> > > >> size.
> > > >
> > > > The rest of the stack does not build such gso packets with payload len
> > > > < mss, so we should not have to add workarounds in the gso hot path
> > > > for this.
> > > >
> > > > Also no need to linearize this skb. I think that if the bpf program
> > > > would just clear the gso type, the packet would be sent correctly.
> > > > Unless I'm missing something.
> > >
> > > Does the checksum/len field in ip and tcp/udp header need adjusting
> > > before clearing gso type as the packet has became bigger?
> >
> > gro takes care of this. see for instance inet_gro_complete for updates
> > to the ip header.
>
> I think clearing the gso type will get an error at tcp4_gso_segment
> because netif_needs_gso returns true in validate_xmit_skb.

Oh right. Whether a packet is gso is defined by gso_size being
non-zero, not by gso_type.

> >
> > > Also, instead of testing skb->data_len, may test the skb->len?
> > >
> > > skb->len - (mac header + ip/ipv6 header + udp/tcp header) > mss + len_diff
> >
> > Yes. Essentially doing the same calculation as the gso code that is
> > causing the packet to be dropped.
>
> BPF program is usually out of control. Can we take a general approach?
> The below 2 cases has no issue when mss upgrading.
> 1) skb->data_len > mss + 20
> 2) skb->data_len < mss && skb->data_len > 20
> The corner case is when
> 3) skb->data_len > mss && skb->data_len < mss + 20

Again, you cannot use skb->data_len alone to make inferences about the
size of the second packet.

>
> But to cover #3 case, we should check the condition Yunsheng Lin said.
> What if we do mss upgrading for both #1 and #2 cases only?
>
> +               unsigned short off_len = skb->data_len > shinfo->gso_size ?
> +                       shinfo->gso_size : 0;
> [...]
>                 /* Due to IPv4 header, MSS can be upgraded. */
> -               skb_increase_gso_size(shinfo, len_diff);
> +               if (skb->data_len - off_len > len_diff)
> +                       skb_increase_gso_size(shinfo, len_diff);

That generates TCP packets with different MSS within the same stream.

My suggestion remains to just not change MSS at all. But this has to
be a new flag to avoid changing established behavior.
