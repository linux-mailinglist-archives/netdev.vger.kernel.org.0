Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C61289C13
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgJIXRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgJIXRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 19:17:21 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4F5C0613D5
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 16:17:21 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q1so10775270ilt.6
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 16:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d5UVykl6vFQAJIzqjcartjMEXw8zG2By/7jb9cPexgg=;
        b=remOb4y+o0PN7ggMXt7woYRAr61qHbqbbsQ1bNficVw/klvUkcFjctwiG7tnp8C6hX
         Thl9KelMu3jZT2xA4UF7bRtzvi+0k/p3YKoTCCmV1c4SgTqKDUPrDfcpt2Qk3GE6WGbV
         XZ3D4J7QpYVU8gOOo8+0Ri8pZAO5i9BlsgtM9jn8pm0rv8JPgVi4BLRV1m7grozB618p
         sfiWEdloucHm3RS6bLiRxqI05iqzVVlmk/+dM4fYghiKnVdhbBn1lEMEiFll8rZyJ/up
         5pgUZzqUAVEBmtaHDUOITAbIBBNXMmZQo1QaUd8wZrj94HlDEQH91mZR+6wZ+OdkC+yV
         2TdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d5UVykl6vFQAJIzqjcartjMEXw8zG2By/7jb9cPexgg=;
        b=Klw9JWSUIUyqmTWCgqLLLtGAYbxRUYPp8MgRoRihvh2PheUKw3KiVsF6shTAVD8a/t
         zTEyM3epNMD4edV+I2Z0HTbxAD2K6qWx0dqVcKQ2rBFqQCPOSCObE03GaTQPpoia0+8D
         xeKnC2yrFPx5rW03P9BPg3G2f53RTFGj2w/x9tZzrWFXlxCT1Xc0OFeCNk0b+AJnCz3J
         X5CTVx9VhAXtmyW5Jtoa3B/bAjWVewCr2NDGZoQJ7Dkyt4sPIAXpAvUhX+9W+0dhU9P4
         uImw9//ayOWGUYtrbKfb1qvzDkGDuWJrxJ0KI+zVS6iPhH2fXuQf62TLhEQltTGgK2ol
         GAFA==
X-Gm-Message-State: AOAM533vs/Iti7913VaHPuLnR50CZs6WsyaaJSFE5f2CuPNIojlhuNvO
        8gLiJXfwE0zpMr3VTENmDjiUw2UNmDyUg533FiYyxQ==
X-Google-Smtp-Source: ABdhPJwEQOnYe91NS/qikpEonmFUHqFUZGHYVMVzeoNwhCjf907x66rRyimadlCQ8bnU0BSVFHmPhAnhQ/MwkaQNhcs=
X-Received: by 2002:a92:6811:: with SMTP id d17mr11934488ilc.145.1602285440500;
 Fri, 09 Oct 2020 16:17:20 -0700 (PDT)
MIME-Version: 1.0
References: <160216609656.882446.16642490462568561112.stgit@firesoul> <160216616276.882446.17894852306425732310.stgit@firesoul>
In-Reply-To: <160216616276.882446.17894852306425732310.stgit@firesoul>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 9 Oct 2020 16:17:09 -0700
Message-ID: <CANP3RGdr3YF5b0EM54D=SrE6zJ=1eJ37mmjn_hZKVaCexcLp5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 5/6] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 7:09 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> The use-case for dropping the MTU check when TC-BPF does redirect to
> ingress, is described by Eyal Birger in email[0]. The summary is the
> ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> ingress redirect packet and let normal netstack fragment packet as needed.
>
> [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/linux/netdevice.h |    5 +++--
>  net/core/dev.c            |    2 +-
>  net/core/filter.c         |   12 ++++++++++--
>  3 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 28cfa53daf72..58fb7b4869ba 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3866,10 +3866,11 @@ bool is_skb_forwardable(const struct net_device *dev,
>                         const struct sk_buff *skb);
>
>  static __always_inline int ____dev_forward_skb(struct net_device *dev,
> -                                              struct sk_buff *skb)
> +                                              struct sk_buff *skb,
> +                                              const bool mtu_check)

check_mtu might be a better arg name then 'mtu_check'

>  {
>         if (skb_orphan_frags(skb, GFP_ATOMIC) ||
> -           unlikely(!is_skb_forwardable(dev, skb))) {
> +           (mtu_check && unlikely(!is_skb_forwardable(dev, skb)))) {
>                 atomic_long_inc(&dev->rx_dropped);
>                 kfree_skb(skb);
>                 return NET_RX_DROP;
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b433098896b2..96b455f15872 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2209,7 +2209,7 @@ EXPORT_SYMBOL_GPL(is_skb_forwardable);
>
>  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
>  {
> -       int ret = ____dev_forward_skb(dev, skb);
> +       int ret = ____dev_forward_skb(dev, skb, true);
>
>         if (likely(!ret)) {
>                 skb->protocol = eth_type_trans(skb, dev);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5986156e700e..a8e24092e4f5 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
>
>  static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
>  {
> -       return dev_forward_skb(dev, skb);
> +       int ret = ____dev_forward_skb(dev, skb, false);
> +
> +       if (likely(!ret)) {
> +               skb->protocol = eth_type_trans(skb, dev);
> +               skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);

this blindly assumes eth header size in a function that does (by name)
seem ethernet specific...
could this use dev->hard_header_len?  or change func name to be
__bpf_ethernet_rx_skb or something

> +               ret = netif_rx(skb);
> +       }
> +
> +       return ret;
>  }
>
>  static inline int __bpf_rx_skb_no_mac(struct net_device *dev,
>                                       struct sk_buff *skb)
>  {
> -       int ret = ____dev_forward_skb(dev, skb);
> +       int ret = ____dev_forward_skb(dev, skb, false);
>
>         if (likely(!ret)) {
>                 skb->dev = dev;
