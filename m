Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7510294E32
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442460AbgJUODg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 10:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408514AbgJUODg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 10:03:36 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601EFC0613CE
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 07:03:36 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id e3so499846vsr.8
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 07:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Mt3mAo87jYrDQYqAGrh7XLu5+OhammxmGnbBf6ZyaA=;
        b=rTfohEuN3CtB/7cJNnd2AzwBnKbeAX7LdTHSmTPEGvXITveorQFmCR4D2JVJUQcN2f
         cWh200B/L1A/7d+XNDfMv4kHT9tWKJescau9R4n2FCwRk2rX8ez4Sgd3O6rQhE7QcrMd
         /t/S2bqi6PWK/oFfl3mLPzRkfaAZD45IeppQmi+gJEqEqjhWrTXrCIVMDjt0VzLVE3ls
         Vr16LUgZanvw63264H0br8Bzo60YKzDroIOrOVt8BTzO6KCwB6vsmPscbB8golmRViCt
         IQDWpB2Jcp5GGL784yF0F1xGlq0HJCy4/noVUX431msuFthrVBs5G5DVXLG2e2IFqgcW
         mJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Mt3mAo87jYrDQYqAGrh7XLu5+OhammxmGnbBf6ZyaA=;
        b=gZCG9oj/7Y66hNrq5piwNN3Sc9c1+zIIzV8cpOiISv5HwgaVfCw65OGiYyIRg7JlT1
         2A+RUyskSLgogGKx7y9Emo/fhmi5R5Q8hwAmj6kFQ5IY6oSh5nR4lEwrdnH2u6FsDt9T
         Vhen81jMC+JERZqRJs9GnqF8bMhtNnUJaV0/tx5uw/xeXb6ohB2Jh3y4vRwhEy+wakEj
         uy/m0qo8DzgnDXhjvNCJeJAxcgrypPfOaesyluBbcOyp4nGN75SZ1kf4Akwb0Wt94Q0X
         aRx+KeGdoLYZCtYAMNvK7HzGHyYvOMak6aIp5y5Wsv6KSRiyjnIHZF/zkt3vKAegE1JJ
         Cd6g==
X-Gm-Message-State: AOAM531kD9fxTPjb55NG2AK7I9xZ1joOpp4ySp/44Vwti+vwprQum8hK
        qMRHTLIuajguNePvZRzuoHoBSu+TZIk=
X-Google-Smtp-Source: ABdhPJx0pFxWpot8Lmpf2hE1TgfQEmaDzoP5XZPbLrt8Udmocegl+DWDe8lfBm44RwXrK7RklphzJA==
X-Received: by 2002:a67:cc2:: with SMTP id 185mr1923669vsm.42.1603289014975;
        Wed, 21 Oct 2020 07:03:34 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id z1sm296777vkf.41.2020.10.21.07.03.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2020 07:03:33 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id t67so515005vkb.8
        for <netdev@vger.kernel.org>; Wed, 21 Oct 2020 07:03:33 -0700 (PDT)
X-Received: by 2002:a05:6122:10eb:: with SMTP id m11mr1962518vko.8.1603289012306;
 Wed, 21 Oct 2020 07:03:32 -0700 (PDT)
MIME-Version: 1.0
References: <20201007035502.3928521-1-liuhangbin@gmail.com>
 <20201021042005.736568-1-liuhangbin@gmail.com> <20201021042005.736568-3-liuhangbin@gmail.com>
In-Reply-To: <20201021042005.736568-3-liuhangbin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 21 Oct 2020 10:02:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdCG4yVDb85M=fChfrkU9=F7j88TJujJy_y0pv-Ks_MwQ@mail.gmail.com>
Message-ID: <CA+FuTSdCG4yVDb85M=fChfrkU9=F7j88TJujJy_y0pv-Ks_MwQ@mail.gmail.com>
Subject: Re: [PATCHv2 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 12:20 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Based on RFC 8200, Section 4.5 Fragment Header:
>
>   -  If the first fragment does not include all headers through an
>      Upper-Layer header, then that fragment should be discarded and
>      an ICMP Parameter Problem, Code 3, message should be sent to
>      the source of the fragment, with the Pointer field set to zero.
>
> As the packet may be any kind of L4 protocol, I only checked if there
> has Upper-Layer header by (offset + 1) > skb->len. Checking each packet
> header in IPv6 fast path will have performace impact, so I put the

nit: performa[n]ce

> checking in ipv6_frag_rcv().
>
> When send ICMP error message, if the first truncated fragment is ICMP
> message, icmp6_send() will break as is_ineligible() return true. So I
> added a check in is_ineligible() to let fragment packet with nexthdr
> ICMP but no ICMP header return false.
>
> v2:
> a) Move header check to ipv6_frag_rcv(). Also check the ipv6_skip_exthdr()
>    return value
> b) Fix ipv6_find_hdr() parameter type miss match in is_ineligible()
>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv6/icmp.c       | 13 ++++++++++++-
>  net/ipv6/reassembly.c | 18 +++++++++++++++++-
>  2 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index ec448b71bf9a..50d28764c8dd 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -145,7 +145,9 @@ static bool is_ineligible(const struct sk_buff *skb)
>         int ptr = (u8 *)(ipv6_hdr(skb) + 1) - skb->data;
>         int len = skb->len - ptr;
>         __u8 nexthdr = ipv6_hdr(skb)->nexthdr;
> +       unsigned int offs = 0;
>         __be16 frag_off;
> +       bool is_frag;
>
>         if (len < 0)
>                 return true;
> @@ -153,12 +155,21 @@ static bool is_ineligible(const struct sk_buff *skb)
>         ptr = ipv6_skip_exthdr(skb, ptr, &nexthdr, &frag_off);
>         if (ptr < 0)
>                 return false;
> +
> +       is_frag = (ipv6_find_hdr(skb, &offs, NEXTHDR_FRAGMENT, NULL, NULL) == NEXTHDR_FRAGMENT);
> +

ipv6_skip_exthdr already walks all headers. Should we not already see
frag_off != 0 if skipped over a fragment header? Analogous to the test
in ipv6_frag_rcv below.

>         if (nexthdr == IPPROTO_ICMPV6) {
>                 u8 _type, *tp;
>                 tp = skb_header_pointer(skb,
>                         ptr+offsetof(struct icmp6hdr, icmp6_type),
>                         sizeof(_type), &_type);
> -               if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
> +
> +               /* Based on RFC 8200, Section 4.5 Fragment Header, return
> +                * false if this is a fragment packet with no icmp header info.
> +                */
> +               if (!tp && is_frag)
> +                       return false;
> +               else if (!tp || !(*tp & ICMPV6_INFOMSG_MASK))
>                         return true;
>         }
>         return false;
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index 1f5d4d196dcc..b359bffa2f58 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -322,7 +322,9 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
>         struct frag_queue *fq;
>         const struct ipv6hdr *hdr = ipv6_hdr(skb);
>         struct net *net = dev_net(skb_dst(skb)->dev);
> -       int iif;
> +       __be16 frag_off;
> +       int iif, offset;
> +       u8 nexthdr;
>
>         if (IP6CB(skb)->flags & IP6SKB_FRAGMENTED)
>                 goto fail_hdr;
> @@ -351,6 +353,20 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
>                 return 1;
>         }
>
> +       /* RFC 8200, Section 4.5 Fragment Header:
> +        * If the first fragment does not include all headers through an
> +        * Upper-Layer header, then that fragment should be discarded and
> +        * an ICMP Parameter Problem, Code 3, message should be sent to
> +        * the source of the fragment, with the Pointer field set to zero.
> +        */
> +       nexthdr = hdr->nexthdr;
> +       offset = ipv6_skip_exthdr(skb, skb_transport_offset(skb), &nexthdr, &frag_off);
> +       if (offset >= 0 && frag_off == htons(IP6_MF) && (offset + 1) > skb->len) {

Offset +1 does not fully test "all headers through an upper layer
header". You note the caveat in your commit message. Perhaps for the
small list of common protocols at least use a length derived from
nexthdr?


> +               __IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev), IPSTATS_MIB_INHDRERRORS);
> +               icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
> +               return -1;
> +       }
> +
>         iif = skb->dev ? skb->dev->ifindex : 0;
>         fq = fq_find(net, fhdr->identification, hdr, iif);
>         if (fq) {
> --
> 2.25.4
>
