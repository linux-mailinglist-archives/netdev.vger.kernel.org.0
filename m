Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5788137AD46
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhEKRoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbhEKRob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:44:31 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733DAC06174A;
        Tue, 11 May 2021 10:43:23 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id 1so15236604qtb.0;
        Tue, 11 May 2021 10:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7EoUwhxShyIjUyxLCtqm6mHgvtxIMHzCgGW7d5l2nII=;
        b=Z8Avlf4zif1fDxOvVfulUCrBxUGi0vw/phtCGHU+xuYH2PWJ3jqAMa49iFrwbn0n0G
         FI7GdYFCpOnZu3N3k16QhPDJOzhGC/zTqsqWgDQ5TwXf/vY0HJ+yzA1xxzTcq2XSjydN
         of/8IpRrIe/4ptn5UAJYl06+RnLehe9MFV4KMY2pQPomtc/f7ePRq6GNF2jeU5q0ISk7
         jr833Uwh5BOpGMIPpbwC87QTDfQUEtVm9xW6eAemUqjN0fQRAY16NhXyg01z8x5wa8cz
         lY3sEnLGaaeLN602aGywPFu9jNHMYeQ5gpfVK+3Yc9T+PN/5QvvhQ+FeD/5H8f4WQqBe
         GCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7EoUwhxShyIjUyxLCtqm6mHgvtxIMHzCgGW7d5l2nII=;
        b=eMZ/dOQyB37qE9nWMSve4MDjbdEygkxTz8hiGHuet1abJ/q9FwwFUGcJfV53FoSlnF
         S/GXiKbN+tUllurrmUD7dPwI+rpZ6qlGkTSHJji8kRNZ1kkDGLFwT2+l/j82EJLx0uKN
         Jwzr57djov5GxGDRUFRUzqe0dDYI0LZA6zpvPVFt9f+N9R06srZuwWmuqZpgE0a1lJQj
         VHDZ+yUORTo0szT3kvyUOlIohnVkUEpsGgZQguDUWjsQB36bSGFn+xfWLvIcrM7zJHU0
         CzyLm9Ymqg16WJPZX8Le6Xxk1r3fmevTngi6ASuSNXX/H5rhrbC52jSSRlRCRDG1tIRh
         AhGQ==
X-Gm-Message-State: AOAM532AwVtiPafcjdcBBDv6dUS/r8LGC1aXlCYtKdvjTmMfjz6/9Wn8
        458jUkwmXenSiFYTHvlmU/zBlyaORzLLph454bKTddXU
X-Google-Smtp-Source: ABdhPJzcSeFwz9wTQoYIJ5UZhwyJBLphpG+3DMqQdRF0jRSh3zIYTl6mJ2ByBIVkQjMXHgdU9LLV5Z1LM0mvlYNTSjI=
X-Received: by 2002:ac8:5c86:: with SMTP id r6mr28941238qta.216.1620755002701;
 Tue, 11 May 2021 10:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210511065056epcas2p1788505019deb274f5c57650a2f5d7ef0@epcas2p1.samsung.com>
 <1619690903-1138-1-git-send-email-dseok.yi@samsung.com> <1620714998-120657-1-git-send-email-dseok.yi@samsung.com>
In-Reply-To: <1620714998-120657-1-git-send-email-dseok.yi@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 11 May 2021 13:42:46 -0400
Message-ID: <CAF=yD-+8676QHiKD2ZA4e0kVE+11cOi6sa+M-vmx0+05tm1GfQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: check BPF_F_ADJ_ROOM_FIXED_GSO when upgrading
 mss in 6 to 4
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 2:51 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
> coalesced packet payload can be > MSS, but < MSS + 20.
> bpf_skb_proto_6_to_4 will increase the MSS and it can be > the payload
> length. After then tcp_gso_segment checks for the payload length if it
> is <= MSS. The condition is causing the packet to be dropped.
>
> tcp_gso_segment():
>         [...]
>         mss = skb_shinfo(skb)->gso_size;
>         if (unlikely(skb->len <= mss))
>                 goto out;
>         [...]
>
> Allow to increase MSS when BPF_F_ADJ_ROOM_FIXED_GSO is not set.
>
> Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
>
> ---

Thanks. Note that this feature does not preclude the alternatives
discussed, of converting the packet to non-TSO (by clearing gso_size)
or optionally modifying MSS (but that should get okay from TCP
experts).

I would target this for bpf-next and drop the Fixes. But that is
admittedly debatable.

>  net/core/filter.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> v2:
> per Willem de Bruijn request,
> checked the flag instead of a generic approach.
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index cae56d0..a98b28d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3276,7 +3276,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
>         return 0;
>  }
>
> -static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
> +static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
>  {
>         const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
>         u32 off = skb_mac_header_len(skb);
> @@ -3305,7 +3305,8 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
>                 }
>
>                 /* Due to IPv4 header, MSS can be upgraded. */
> -               skb_increase_gso_size(shinfo, len_diff);
> +               if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
> +                       skb_increase_gso_size(shinfo, len_diff);
>                 /* Header must be checked, and gso_segs recomputed. */
>                 shinfo->gso_type |= SKB_GSO_DODGY;
>                 shinfo->gso_segs = 0;
> @@ -3317,7 +3318,7 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
>         return 0;
>  }
>
> -static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
> +static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto, u64 flags)
>  {
>         __be16 from_proto = skb->protocol;
>
> @@ -3327,7 +3328,7 @@ static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
>
>         if (from_proto == htons(ETH_P_IPV6) &&
>               to_proto == htons(ETH_P_IP))
> -               return bpf_skb_proto_6_to_4(skb);
> +               return bpf_skb_proto_6_to_4(skb, flags);
>
>         return -ENOTSUPP;
>  }
> @@ -3337,7 +3338,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
>  {
>         int ret;
>
> -       if (unlikely(flags))
> +       if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
>                 return -EINVAL;

Once allowing this flag, please immediately support it for both
bpf_skb_proto_6_to_4 and bpf_skb_4_to_6.

We cannot do that later if we ignore the second case now.


>         /* General idea is that this helper does the basic groundwork
> @@ -3357,7 +3358,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
>          * that. For offloads, we mark packet as dodgy, so that headers
>          * need to be verified first.
>          */
> -       ret = bpf_skb_proto_xlat(skb, proto);
> +       ret = bpf_skb_proto_xlat(skb, proto, flags);
>         bpf_compute_data_pointers(skb);
>         return ret;
>  }
> --
> 2.7.4
>
