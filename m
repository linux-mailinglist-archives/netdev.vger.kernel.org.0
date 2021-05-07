Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7B6375E58
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 03:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhEGB1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 21:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbhEGB1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 21:27:36 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1AFC061574;
        Thu,  6 May 2021 18:26:37 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id i17so7012106qki.3;
        Thu, 06 May 2021 18:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RC3HZQRAM0jipTBu9NHkCJdfO2tCCcmqkUY+qLxNsoE=;
        b=dAIVg8KG7fejcsWQh6h/GHyBJLVUw8osR1Zb6TEpHR3E8ZJkY1l66Iv2AInYk4NG4+
         306WO/Ed+ERjeQ9VVxlQSaZg5IoXDvdkgwXhJqYKhu7t96iUQUWT71sq4GcuqlvPezXX
         dPDy8DJcFgekA6O9wDrB5dqJQg7+1zPf3bdA8N7ntyRH+S8sUl3wLKAvJFSNc/tsQZ8E
         JVlJa73R2tokPY1xAJNZCgmT26bOli/qUuR/bLiAagP1BnDR8Ru5CWiYmf31DU5bn7A6
         ZmP71f5hiKeCPKWeRSeu0+0YynNZUyXeP6Fe+9j5SGS5ZpfUNyLTnU1csHIgUC/DCW6N
         skSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RC3HZQRAM0jipTBu9NHkCJdfO2tCCcmqkUY+qLxNsoE=;
        b=rWnpKH+b8Ji5fBv64c9It9h0Q3/o/oztJN3nQaf/elJU8ftYLgvjNx4ydrq8XLLZx5
         j5VH3CP+TTCV/+sr+DYHLJ2iEviEhGZ4gewIIHqjsT69ax+jh2Wc6pvOrHC8UF9wtih0
         BZDBa9ZDUDy7SFsIJNB5RjNw+Oun7FPSHWXXF5QKAF5qEq+MyplxvKvtGge4nVfqTG1W
         KbtDu8CYMo23mqp+Dx7GNHJVgnVVm1Kf6WrRcGaUJssilfqAen4biBLwMnxS9jdrSTVX
         8/xGL0oM8IyovmH/9MWxigkCMQ8yZyU0iK9G9Pdzlp8N/rYU7AL0aCemCicYv3Vm7z5q
         b/mw==
X-Gm-Message-State: AOAM531EMcJpjhIDOyG46PpMsIafXu0VeNl7aaf+/EyYf5MUiUt16zhd
        FLLqvsTLQ4l9MtIVNBYGy+CNgtN3ceudbMJnZl0=
X-Google-Smtp-Source: ABdhPJxSXPwXHxYaiJ1qSY2uuVYIkfteba2pzaF87r3zxueZTC6ZOLqFkB4NCg0WGfvDkgqheztMDxNFrtWD/n0cY6U=
X-Received: by 2002:a37:b8b:: with SMTP id 133mr806568qkl.433.1620350796208;
 Thu, 06 May 2021 18:26:36 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210429102143epcas2p4c8747c09a9de28f003c20389c050394a@epcas2p4.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <8c2ea41a-3fc5-d560-16e5-bf706949d857@iogearbox.net>
 <02bf01d74211$0ff4aed0$2fde0c70$@samsung.com> <CA+FuTScC96R5o24c-sbY-CEV4EYOVFepFR85O4uGtCLwOjnzEw@mail.gmail.com>
 <02c801d7421f$65287a90$2f796fb0$@samsung.com> <CA+FuTScUJwqEpYim0hG27k39p_yEyzuW2A8RFKuBndctgKjWZw@mail.gmail.com>
 <001801d742db$68ab8060$3a028120$@samsung.com>
In-Reply-To: <001801d742db$68ab8060$3a028120$@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 6 May 2021 21:25:59 -0400
Message-ID: <CAF=yD-KtJvyjHgGVwscoQpFX3e+DmQCYeO_HVGwyGAp3ote00A@mail.gmail.com>
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

> > > head_skb's data_len is the sum of skb_gro_len for each skb of the frags.
> > > data_len could be 8 if server sent a small size packet and it is GROed
> > > to head_skb.
> > >
> > > Please let me know if I am missing something.
> >
> > This is my understanding of the data path. This is a forwarding path
> > for TCP traffic.
> >
> > GRO is enabled and will coalesce multiple segments into a single large
> > packet. In bad cases, the coalesced packet payload is > MSS, but < MSS
> > + 20.
> >
> > Somewhere between GRO and GSO you have a BPF program that converts the
> > IPv6 address to IPv4.
>
> Your understanding is right. The data path is GRO -> BPF 6 to 4 ->
> GSO.
>
> >
> > There is no concept of head_skb at the time of this BPF program. It is
> > a single SKB, with an skb linear part and multiple data items in the
> > frags (no frag_list).
>
> Sorry for the confusion. head_skb what I mentioned was a skb linear
> part. I'm considering a single SKB with frags too.
>
> >
> > When entering the GSO stack, this single skb now has a payload length
> > < MSS. So it would just make a valid TCP packet on its own?
> >
> > skb_gro_len is only relevant inside the GRO stack. It internally casts
> > the skb->cb[] to NAPI_GRO_CB. This field is a scratch area that may be
> > reused for other purposes later by other layers of the datapath. It is
> > not safe to read this inside bpf_skb_proto_6_to_4.
>
> The condition what I made uses skb->data_len not skb_gro_len. Does
> skb->data_len have a different meaning on each layer? As I know,
> data_len indicates the amount of frags or frag_list. skb->data_len
> should be > 20 in the sample case because the payload size of the skb
> linear part is the same with mss.

Ah, got it.

data_len is the length of the skb minus the length in the skb linear
section (as seen in skb_headlen).

So this gso skb consists of two segments, the first one entirely
linear, the payload of the second is in skb_shinfo(skb)->frags[0].

It is not guaranteed that gso skbs built from two individual skbs end
up looking like that. Only protocol headers in the linear segment and
the payload of both in frags is common.

> We can modify netif_needs_gso as another option to hit
> skb_needs_linearize in validate_xmit_skb. But I think we should compare
> skb->gso_size and skb->data_len too to check if mss exceed a payload
> size.

The rest of the stack does not build such gso packets with payload len
< mss, so we should not have to add workarounds in the gso hot path
for this.

Also no need to linearize this skb. I think that if the bpf program
would just clear the gso type, the packet would be sent correctly.
Unless I'm missing something.

But I don't mean to argue that it should do that in production.
Instead, not playing mss games would solve this and stay close to the
original datapath if no bpf program had been present. Including
maintaining the GSO invariant of sending out the same chain of packets
as received (bar the IPv6 to IPv4 change).

This could be achieved by adding support for the flag
BPF_F_ADJ_ROOM_FIXED_GSO in the flags field of bpf_skb_change_proto.
And similar to bpf_skb_net_shrink:

                /* Due to header shrink, MSS can be upgraded. */
                if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
                        skb_increase_gso_size(shinfo, len_diff);

The other case, from IPv4 to IPv6 is more difficult to address, as not
reducing the MSS will result in packets exceeding MTU. That calls for
workarounds like MSS clamping. Anyway, that is out of scope here.



> >
> >
> > > >
> > > > One simple solution if this packet no longer needs to be segmented
> > > > might be to reset the gso_type completely.
> > >
> > > I am not sure gso_type can be cleared even when GSO is needed.
> > >
> > > >
> > > > In general, I would advocate using BPF_F_ADJ_ROOM_FIXED_GSO. When
> > > > converting from IPv6 to IPv4, fixed gso will end up building packets
> > > > that are slightly below the MTU. That opportunity cost is negligible
> > > > (especially with TSO). Unfortunately, I see that that flag is
> > > > available for bpf_skb_adjust_room but not for bpf_skb_proto_6_to_4.
> > > >
> > > >
> > > > > > > would increse the gso_size to 1392. tcp_gso_segment will get an error
> > > > > > > with 1380 <= 1392.
> > > > > > >
> > > > > > > Check for the size of GROed payload if it is really bigger than target
> > > > > > > mss when increase mss.
> > > > > > >
> > > > > > > Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> > > > > > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > > > > > ---
> > > > > > >   net/core/filter.c | 4 +++-
> > > > > > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > > > index 9323d34..3f79e3c 100644
> > > > > > > --- a/net/core/filter.c
> > > > > > > +++ b/net/core/filter.c
> > > > > > > @@ -3308,7 +3308,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> > > > > > >             }
> > > > > > >
> > > > > > >             /* Due to IPv4 header, MSS can be upgraded. */
> > > > > > > -           skb_increase_gso_size(shinfo, len_diff);
> > > > > > > +           if (skb->data_len > len_diff)
> > > > > >
> > > > > > Could you elaborate some more on what this has to do with data_len specifically
> > > > > > here? I'm not sure I follow exactly your above commit description. Are you saying
> > > > > > that you're hitting in tcp_gso_segment():
> > > > > >
> > > > > >          [...]
> > > > > >          mss = skb_shinfo(skb)->gso_size;
> > > > > >          if (unlikely(skb->len <= mss))
> > > > > >                  goto out;
> > > > > >          [...]
> > > > >
> > > > > Yes, right
> > > > >
> > > > > >
> > > > > > Please provide more context on the bug, thanks!
> > > > >
> > > > > tcp_gso_segment():
> > > > >         [...]
> > > > >         __skb_pull(skb, thlen);
> > > > >
> > > > >         mss = skb_shinfo(skb)->gso_size;
> > > > >         if (unlikely(skb->len <= mss))
> > > > >         [...]
> > > > >
> > > > > skb->len will have total GROed TCP payload size after __skb_pull.
> > > > > skb->len <= mss will not be happened in a normal GROed situation. But
> > > > > bpf_skb_proto_6_to_4 would upgrade MSS by increasing gso_size, it can
> > > > > hit an error condition.
> > > > >
> > > > > We should ensure the following condition.
> > > > > total GROed TCP payload > the original mss + (IPv6 size - IPv4 size)
> > > > >
> > > > > Due to
> > > > > total GROed TCP payload = the original mss + skb->data_len
> > > > > IPv6 size - IPv4 size = len_diff
> > > > >
> > > > > Finally, we can get the condition.
> > > > > skb->data_len > len_diff
> > > > >
> > > > > >
> > > > > > > +                   skb_increase_gso_size(shinfo, len_diff);
> > > > > > > +
> > > > > > >             /* Header must be checked, and gso_segs recomputed. */
> > > > > > >             shinfo->gso_type |= SKB_GSO_DODGY;
> > > > > > >             shinfo->gso_segs = 0;
> > > > > > >
> > > > >
> > > > >
> > >
>
