Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E58E50038F
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 03:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239393AbiDNBW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 21:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiDNBW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 21:22:57 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF6ADFBE;
        Wed, 13 Apr 2022 18:20:34 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z12so4517912edl.2;
        Wed, 13 Apr 2022 18:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBJaBa5zZsVUg4zFeNK9By+C7ZPzPiGkf9byMgfDo6k=;
        b=J+PhxBRf7DHhfvVDE3blFA4M+J6cJKij4CzxJ4x5rlDLvc+XOg6vkX01RfP9B9NY9H
         kjsJxcGjfEHgcVTcfcVJSXkUGIK2Nvq+UCFW3fuQlDpmT+VsaoDiKXXrUx+e8q7szb4F
         /0dxQMXwmTRfZgEq/EVWPvYqW5IeZBscy6t2htQ9yEmJhfj37xI5JxMkFDwduKLmr8JT
         /AN9g/nHgpGglHKjUldiqFel8Jn/a60G4/G3Ig4sXDTJzLki+Qv+L5dAho6oJAD1vKwe
         kJorYOOWZKwIR0nwIG+9mBjL0rO3CppWRVS8fdOX8g2/oa3X0hb/KO1TO8Y+uvW4DtZ+
         Ggzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBJaBa5zZsVUg4zFeNK9By+C7ZPzPiGkf9byMgfDo6k=;
        b=eB00/H9XumpyeebZSF/CT6g8JXZqp9wuvMtUIqekN4Ge6R7BtIb5yQ0pxE7yZGmtR0
         D3iOjKUJgVwja2xakif9kr0KTCuVUWIEUeyIMfPxjhqk12OBg5lSqRUZEL2W0Na6VApf
         XOkiZoD6csJP+7u7letgCJrvl0PzoWIAYaGkpEg6ntd8t1we1y/crmWaRBtZHCtAgKN8
         d6SmpDJQfCfyuQzItsv4GGvsFq/MgVM0HrVr0kFGIG/UXiE+Q45U4zZQ9EMP0erBUyUN
         M43CCQQOehMqkQY4H3Fs+yX874jmBagPf8Sf/sjxXtmUWsHW2hQlpKszc5J92WIf+urC
         d6Rg==
X-Gm-Message-State: AOAM5333vJpsY9GRKOs57iUG6ASfOAQEuqe+lKXdIvEMJ8dxowAKEtZb
        hgOJartb/czJFfcagmSmCDpfYiKn/ESnPKF+c18=
X-Google-Smtp-Source: ABdhPJxAkEjKX0KiPIuW3BGAA+3wZwRvhv2hdZmopdZ+zjhXs7xILXLd/OdgBbStwibPaF8ny30gbXE/cmIQmXodvFE=
X-Received: by 2002:a05:6402:b57:b0:41d:6d9b:7e0d with SMTP id
 bx23-20020a0564020b5700b0041d6d9b7e0dmr399531edb.78.1649899232641; Wed, 13
 Apr 2022 18:20:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220413081600.187339-1-imagedong@tencent.com>
 <20220413081600.187339-9-imagedong@tencent.com> <62903323-d1c0-79cd-7cf8-d6c4b89ff848@gmail.com>
In-Reply-To: <62903323-d1c0-79cd-7cf8-d6c4b89ff848@gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Thu, 14 Apr 2022 09:20:21 +0800
Message-ID: <CADxym3Z+Ginefiw7ymbZFGa3QC5qaT5jM3DjedijzGwYoFqPaw@mail.gmail.com>
Subject: Re: [PATCH net-next 8/9] net: ipv6: add skb drop reasons to ip6_rcv_core()
To:     Eric Dumazet <edumazet@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Biao Jiang <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 4:41 AM Eric Dumazet <edumazet@gmail.com> wrote:
>
>
> On 4/13/22 01:15, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Replace kfree_skb() used in ip6_rcv_core() with kfree_skb_reason().
> > No new drop reasons are added.
> >
> > Seems now we use 'SKB_DROP_REASON_IP_INHDR' for too many case during
> > ipv6 header parse or check, just like what 'IPSTATS_MIB_INHDRERRORS'
> > do. Will it be too general and hard to know what happened?
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > ---
> >   net/ipv6/ip6_input.c | 24 ++++++++++++++++--------
> >   1 file changed, 16 insertions(+), 8 deletions(-)
> >
> > diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> > index b4880c7c84eb..1b925ecb26e9 100644
> > --- a/net/ipv6/ip6_input.c
> > +++ b/net/ipv6/ip6_input.c
> > @@ -145,13 +145,14 @@ static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
> >   static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >                                   struct net *net)
> >   {
> > +     enum skb_drop_reason reason;
> >       const struct ipv6hdr *hdr;
> >       u32 pkt_len;
> >       struct inet6_dev *idev;
> >
> >       if (skb->pkt_type == PACKET_OTHERHOST) {
> >               dev_core_stats_rx_otherhost_dropped_inc(skb->dev);
> > -             kfree_skb(skb);
> > +             kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
> >               return NULL;
> >       }
> >
> > @@ -161,9 +162,12 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >
> >       __IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
> >
> > +     SKB_DR_SET(reason, NOT_SPECIFIED);
> >       if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
> >           !idev || unlikely(idev->cnf.disable_ipv6)) {
> >               __IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
> > +             if (unlikely(idev->cnf.disable_ipv6))
>
> idev can be NULL here (according to surrounding code), and we crash :/

Yeah, you are right :)

Thanks for your fix!

>
>
>
> > +                     SKB_DR_SET(reason, IPV6DISABLED);
> >               goto drop;
> >       }
> >
> > @@ -187,8 +191,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >
> >       hdr = ipv6_hdr(skb);
> >
> > -     if (hdr->version != 6)
> > +     if (hdr->version != 6) {
> > +             SKB_DR_SET(reason, UNHANDLED_PROTO);
> >               goto err;
> > +     }
> >
> >       __IP6_ADD_STATS(net, idev,
> >                       IPSTATS_MIB_NOECTPKTS +
> > @@ -226,8 +232,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >       if (!ipv6_addr_is_multicast(&hdr->daddr) &&
> >           (skb->pkt_type == PACKET_BROADCAST ||
> >            skb->pkt_type == PACKET_MULTICAST) &&
> > -         idev->cnf.drop_unicast_in_l2_multicast)
> > +         idev->cnf.drop_unicast_in_l2_multicast) {
> > +             SKB_DR_SET(reason, UNICAST_IN_L2_MULTICAST);
> >               goto err;
> > +     }
> >
> >       /* RFC4291 2.7
> >        * Nodes must not originate a packet to a multicast address whose scope
> > @@ -256,12 +264,11 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >               if (pkt_len + sizeof(struct ipv6hdr) > skb->len) {
> >                       __IP6_INC_STATS(net,
> >                                       idev, IPSTATS_MIB_INTRUNCATEDPKTS);
> > +                     SKB_DR_SET(reason, PKT_TOO_SMALL);
> >                       goto drop;
> >               }
> > -             if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr))) {
> > -                     __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> > -                     goto drop;
> > -             }
> > +             if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
> > +                     goto err;
> >               hdr = ipv6_hdr(skb);
> >       }
> >
> > @@ -282,9 +289,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
> >       return skb;
> >   err:
> >       __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
> > +     SKB_DR_OR(reason, IP_INHDR);
> >   drop:
> >       rcu_read_unlock();
> > -     kfree_skb(skb);
> > +     kfree_skb_reason(skb, reason);
> >       return NULL;
> >   }
> >
