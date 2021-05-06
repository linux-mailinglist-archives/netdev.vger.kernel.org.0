Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7285A375A1E
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 20:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbhEFSXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 14:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbhEFSXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 14:23:19 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DD5C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 11:22:20 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h10so7232587edt.13
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BRQHRkFwEmoQQH23N9E0XGi4S2KTprSInvxvTybpRDo=;
        b=cupWVeZ/u7+KYnd0pZbmw0V8kpVJFidtNQmJJndcFVQDm7Mz9sH12+Lvq5d+q2lORZ
         askoFNLFB+ul/jNYyOaXg2Tc8PAwEkqUta+zAbfyeEtDr204q+upO7tiLAh5wdB9o0aH
         Yb9MtWshSqoRLpE7C2Uc8CPKDNJXhWVFj2EP7zwBz1bdSM1Xiz30uMjFperBXrK3WRdL
         TvwUA8q18G7J4cNgZYHBhFczEjy1UgA0lCqYBSYOIHI9yjJU+kALAz20Y3jyLLnqIuWg
         SSOWEKIM2+jJSkFl8wOFPlyNTFJ8/0LbyLSHTGF3hAHXE3YCmz0LpQKySvdn/GYfM0XB
         2x/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BRQHRkFwEmoQQH23N9E0XGi4S2KTprSInvxvTybpRDo=;
        b=VTcbE7DyXC67cJ7/fuS6gmJwbLgdamR+vantgRR0V4KD9s9S+zhxcfaHeFqMkbPNd3
         dcD6VF2dYZm6BGqv2rvxF4gRgGVW8nCgLebt6zJFimFN8JfiTqMfA9+uCNafZW+Q1Uyj
         AWgnSXddTG3q+YX0L/LEyWCjGEqEnJXQdUT9RvExBxshvQ7RaqRC7xhLF1J8LZhF55gU
         KjNaeF/Zw0LwT4/C5SdufTSWNP8zZq+l8m8ckGliNK+F7gxM6VGeYJ/WAQ2JYUBbR7g4
         pMOad4Zcd3aVHmXbcD7dDrDxM17vCSz9t7H/iV+pQbOhxGpxM/knBXkpSIartOWMxorf
         T6xQ==
X-Gm-Message-State: AOAM533SDpoPuUOwy0fNE4YJsIed77DRqIwXPDmwmlLe/B13bzMqtsff
        XJGeg4wFZsLC8aammVFrTtrQoiLb1TLPdUjg
X-Google-Smtp-Source: ABdhPJygFqbS2Q4RS+eJRhQXtma6ENXH0qg1gp4BjMtugMSUuSUL/AiBbxee0YuofQuNPytNP9B30g==
X-Received: by 2002:a05:6402:5111:: with SMTP id m17mr6949270edd.343.1620325338529;
        Thu, 06 May 2021 11:22:18 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id g17sm2844772edv.47.2021.05.06.11.22.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 11:22:17 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id l2so6606178wrm.9
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 11:22:16 -0700 (PDT)
X-Received: by 2002:a05:6000:188b:: with SMTP id a11mr6776251wri.275.1620325335877;
 Thu, 06 May 2021 11:22:15 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com> <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
 <02c801d7421f$65287a90$2f796fb0$@samsung.com>
In-Reply-To: <02c801d7421f$65287a90$2f796fb0$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 6 May 2021 14:21:37 -0400
X-Gmail-Original-Message-ID: <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
Message-ID: <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: check for data_len before upgrading mss when 6
 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Wed, May 5, 2021 at 10:27 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> On Wed, May 05, 2021 at 09:45:37PM -0400, Willem de Bruijn wrote:
> > On Wed, May 5, 2021 at 8:45 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> > >
> > > On Wed, May 05, 2021 at 10:55:10PM +0200, Daniel Borkmann wrote:
> > > > On 4/29/21 12:08 PM, Dongseok Yi wrote:
> > > > > tcp_gso_segment check for the size of GROed payload if it is bigger
> > > > > than the mss. bpf_skb_proto_6_to_4 increases mss, but the mss can be
> > > > > bigger than the size of GROed payload unexpectedly if data_len is not
> > > > > big enough.
> > > > >
> > > > > Assume that skb gso_size = 1372 and data_len = 8. bpf_skb_proto_6_to_4
> >
> > Is this a typo and is this intended to read skb->data_len = 1380?
>
> This is not a typo. I intended skb->data_len = 8.
>
> >
> > The issue is that payload length (1380) is greater than mss with ipv6
> > (1372), but less than mss with ipv4 (1392).
> >
> > I don't understand data_len = 8 or why the patch compares
> > skb->data_len to len_diff (20).
>
> skb_gro_receive():
>         unsigned int len = skb_gro_len(skb);
>         [...]
> done:
>         NAPI_GRO_CB(p)->count++;
>         p->data_len += len;
>
> head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> data_len could be 8 if server sent a small size packet and it is GROed
> to head_skb.
>
> Please let me know if I am missing something.

This is my understanding of the data path. This is a forwarding path
for TCP traffic.

GRO is enabled and will coalesce multiple segments into a single large
packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
+ 20.

Somewhere between GRO and GSO you have a BPF program that converts the
IPv6 address to IPv4.

There is no concept of head_skb at the time of this BPF program. It is
a single SKB, with an skb linear part and multiple data items in the
frags (no frag_list).

When entering the GSO stack, this single skb now has a payload length
< MSS. So it would just make a valid TCP packet on its own?

skb_gro_len is only relevant inside the GRO stack. It internally casts
the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
reused for other purposes later by other layers of the datapath. It is
not safe to read this inside bpf_skb_proto_6_to_4.


> >
> > One simple solution if this packet no longer needs to be segmented
> > might be to reset the gso_type completely.
>
> I am not sure gso_type can be cleared even when GSO is needed.
>
> >
> > In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
> > converting from IPv6 to IPv4, fixed gso will end up building packets
> > that are slightly below the MTU. That opportunity cost is negligible
> > (especially with TSO). Unfortunately, I see that that flag is
> > available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
> >
> >
> > > > > would increse the gso_size to 1392. tcp_gso_segment will get an error
> > > > > with 1380 <= 1392.
> > > > >
> > > > > Check for the size of GROed payload if it is really bigger than target
> > > > > mss when increase mss.
> > > > >
> > > > > Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > > > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > > > ---
> > > > >   net/core/filter.c | 4 +++-
> > > > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > index 9323d34..3f79e3c 100644
> > > > > --- a/net/core/filter.c
> > > > > +++ b/net/core/filter.c
> > > > > @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> > > > >             }
> > > > >
> > > > >             /* Due to IPv4 header, MSS can be upgraded. */
> > > > > -           skb_increase_gso_size(shinfo, len_diff);
> > > > > +           if (skb->data_len > len_diff)
> > > >
> > > > Could you elaborate some more on what this has to do with data_len specifically
> > > > here? I'm not sure I follow exactly your above commit description. Are you saying
> > > > that you're hitting in tcp_gso_segment():
> > > >
> > > >          [...]
> > > >          mss = skb_shinfo(skb)->gso_size;
> > > >          if (unlikely(skb->len <= mss))
> > > >                  goto out;
> > > >          [...]
> > >
> > > Yes, right
> > >
> > > >
> > > > Please provide more context on the bug, thanks!
> > >
> > > tcp_gso_segment():
> > >         [...]
> > >         __skb_pull(skb, thlen);
> > >
> > >         mss = skb_shinfo(skb)->gso_size;
> > >         if (unlikely(skb->len <= mss))
> > >         [...]
> > >
> > > skb->len will have total GROed TCP payload size after __skb_pull.
> > > skb->len <= mss will not be happened in a normal GROed situation. But
> > > bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> > > hit an error condition.
> > >
> > > We should ensure the following condition.
> > > total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
> > >
> > > Due to
> > > total GROed TCP payload = the original mss + skb->data_len
> > > IPv6 size - IPv4 size = len_diff
> > >
> > > Finally, we can get the condition.
> > > skb->data_len > len_diff
> > >
> > > >
> > > > > +                   skb_increase_gso_size(shinfo, len_diff);
> > > > > +
> > > > >             /* Header must be checked, and gso_segs recomputed. */
> > > > >             shinfo->gso_type |= SKB_GSO_DODGY;
> > > > >             shinfo->gso_segs = 0;
> > > > >
> > >
> > >
>
