Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D03146C93
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 00:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfFNW4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 18:56:53 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34230 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfFNW4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 18:56:53 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so9326821iot.1
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 15:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxFdnKQOTB7o8G24P/ZswXjyqYk8BQgNmFJixeSSiiQ=;
        b=dR1+xml6tVVMYfb1alPCsa5fAyHwshQq3XZa/TKZikTJhth8FH+H2JIzt4Tw3HBU8V
         8Gyt7a+9JAVBQwGOj9IrYUMv/NhQE1gyF8uFibIti7KPOAGGsWNLzmtViRt6JNQ35Gti
         DwDi7XYHctyhsUNlPFqiSM5E5VWsZIiyGAvMcm2hna8eFqpX4NPmkSZhnPlUNC68Li6M
         xY+C4kaWXg3FV0LAl4EY7ukcnUX4pC6bmKXkUYwQjgIDzcGZ1C3XXt2qWBW5E40o0bOn
         ZFyeBnSdJhaV04h/wnTVCnqS+demlH19cUoDtbwmXTl7peu4/yEF0aTUm8QpJvRz1MmD
         AKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxFdnKQOTB7o8G24P/ZswXjyqYk8BQgNmFJixeSSiiQ=;
        b=SBWpb4Db/5VNjZUdv1je/JIfkVO8jpnnutXOMkCi+8h83zFyM21xgNDHv1cwcgi87y
         MN2ZBmkRq6dKBBus0iqBzz+auzAUZvCRVbwkS0JKwJ4e9TYV6eNJZY0J7LXk+PHhV/+v
         HS1/EN+aZivDVW3EUdDU+F0wb+8WY/WkvnSi5/+yvMwypDvZ7qUfkn6+fiHvwLUrGgKY
         RzM9gSOzPbCCHusRWoH/H9CX3zEGiO73OdGy7LHdFWpShraxMQ1BJXGon+RTikaTFvj7
         AUBm03piZ+1BqpwTUxI8bG6Ny7iaETHEvnV42M4PkuBXHTUv7vBrG5mgGNLFdd1blUaz
         TGfw==
X-Gm-Message-State: APjAAAXf7z8yYaJTePDNg7vteA9+9ngtaa5FQTLdDhTDx+gd/x+YPTZQ
        rLdX+iHgOanQ6e3nNXwCqXrmHYrRcmh6lcjNnuB9bw==
X-Google-Smtp-Source: APXvYqxWcRehOHFQ6E+LBZJaY2z4dZmX1WncgrkAXcQm3+OSakv5L31O11sK3qC2tAQbdoKDF5rZnBdFbJhr+xD62x8=
X-Received: by 2002:a6b:fb10:: with SMTP id h16mr1191044iog.195.1560553012530;
 Fri, 14 Jun 2019 15:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <1560447839-8337-1-git-send-email-john.hurley@netronome.com>
 <1560447839-8337-2-git-send-email-john.hurley@netronome.com> <CAM_iQpU0jZhg60-CVEZ9H1N57ga9jPwVt5tF1fM=uP_sj4kmKQ@mail.gmail.com>
In-Reply-To: <CAM_iQpU0jZhg60-CVEZ9H1N57ga9jPwVt5tF1fM=uP_sj4kmKQ@mail.gmail.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Fri, 14 Jun 2019 23:56:41 +0100
Message-ID: <CAK+XE=mXVW84MXE5bDYyGhK5XrC_q3ECiaj5=WsXFV0FXBk+eA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: sched: add mpls manipulation actions
 to TC
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 5:59 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Jun 13, 2019 at 10:44 AM John Hurley <john.hurley@netronome.com> wrote:
> > +static inline void tcf_mpls_set_eth_type(struct sk_buff *skb, __be16 ethertype)
> > +{
> > +       struct ethhdr *hdr = eth_hdr(skb);
> > +
> > +       skb_postpull_rcsum(skb, &hdr->h_proto, ETH_TLEN);
> > +       hdr->h_proto = ethertype;
> > +       skb_postpush_rcsum(skb, &hdr->h_proto, ETH_TLEN);
>
> So you just want to adjust the checksum with the new ->h_proto
> value. please use a right csum API, rather than skb_post*_rcsum().
>

Hi Cong,
Yes, I'm trying to maintain the checksum value if checksum complete
has been set.
The function above pulls the old eth type out of the checksum value
(if it is checksum complete), updates the eth type, and pushes the new
eth type into the checksum.
This passes my tests on the checksum.
I couldn't see an appropriate function to do this other than
recalculating the whole thing.
Maybe I missed something?

>
> > +}
> > +
> > +static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
> > +                       struct tcf_result *res)
> > +{
> > +       struct tcf_mpls *m = to_mpls(a);
> > +       struct mpls_shim_hdr *lse;
> > +       struct tcf_mpls_params *p;
> > +       u32 temp_lse;
> > +       int ret;
> > +       u8 ttl;
> > +
> > +       tcf_lastuse_update(&m->tcf_tm);
> > +       bstats_cpu_update(this_cpu_ptr(m->common.cpu_bstats), skb);
> > +
> > +       /* Ensure 'data' points at mac_header prior calling mpls manipulating
> > +        * functions.
> > +        */
> > +       if (skb_at_tc_ingress(skb))
> > +               skb_push_rcsum(skb, skb->mac_len);
> > +
> > +       ret = READ_ONCE(m->tcf_action);
> > +
> > +       p = rcu_dereference_bh(m->mpls_p);
> > +
> > +       switch (p->tcfm_action) {
> > +       case TCA_MPLS_ACT_POP:
> > +               if (unlikely(!eth_p_mpls(skb->protocol)))
> > +                       goto out;
> > +
> > +               if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> > +                       goto drop;
> > +
> > +               skb_postpull_rcsum(skb, mpls_hdr(skb), MPLS_HLEN);
> > +               memmove(skb->data + MPLS_HLEN, skb->data, ETH_HLEN);
> > +
> > +               __skb_pull(skb, MPLS_HLEN);
> > +               skb_reset_mac_header(skb);
> > +               skb_set_network_header(skb, ETH_HLEN);
> > +
> > +               tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> > +               skb->protocol = p->tcfm_proto;
> > +               break;
> > +       case TCA_MPLS_ACT_PUSH:
> > +               if (unlikely(skb_cow_head(skb, MPLS_HLEN)))
> > +                       goto drop;
> > +
> > +               skb_push(skb, MPLS_HLEN);
> > +               memmove(skb->data, skb->data + MPLS_HLEN, ETH_HLEN);
> > +               skb_reset_mac_header(skb);
> > +               skb_set_network_header(skb, ETH_HLEN);
> > +
> > +               lse = mpls_hdr(skb);
> > +               lse->label_stack_entry = 0;
> > +               tcf_mpls_mod_lse(lse, p, !eth_p_mpls(skb->protocol));
> > +               skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> > +
> > +               tcf_mpls_set_eth_type(skb, p->tcfm_proto);
> > +               skb->protocol = p->tcfm_proto;
> > +               break;
>
> Is it possible to refactor and reuse the similar code in
> net/openvswitch/actions.c::pop_mpls()/push_mpls()?
>

This is something I would need to look into

>
>
> > +       case TCA_MPLS_ACT_MODIFY:
> > +               if (unlikely(!eth_p_mpls(skb->protocol)))
> > +                       goto out;
> > +
> > +               if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> > +                       goto drop;
> > +
> > +               lse = mpls_hdr(skb);
> > +               skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> > +               tcf_mpls_mod_lse(lse, p, false);
> > +               skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> > +               break;
> > +       case TCA_MPLS_ACT_DEC_TTL:
> > +               if (unlikely(!eth_p_mpls(skb->protocol)))
> > +                       goto out;
> > +
> > +               if (unlikely(skb_ensure_writable(skb, ETH_HLEN + MPLS_HLEN)))
> > +                       goto drop;
> > +
> > +               lse = mpls_hdr(skb);
> > +               temp_lse = be32_to_cpu(lse->label_stack_entry);
> > +               ttl = (temp_lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
> > +               if (!--ttl)
> > +                       goto drop;
> > +
> > +               temp_lse &= ~MPLS_LS_TTL_MASK;
> > +               temp_lse |= ttl << MPLS_LS_TTL_SHIFT;
> > +               skb_postpull_rcsum(skb, lse, MPLS_HLEN);
> > +               lse->label_stack_entry = cpu_to_be32(temp_lse);
> > +               skb_postpush_rcsum(skb, lse, MPLS_HLEN);
> > +               break;
> > +       default:
> > +               WARN_ONCE(1, "Invalid MPLS action\n");
>
>
> This warning is not necessary, it must be validated in ->init().
>

ack.
Thanks for comments

>
> > +       }
> > +
> > +out:
> > +       if (skb_at_tc_ingress(skb))
> > +               skb_pull_rcsum(skb, skb->mac_len);
> > +
> > +       return ret;
> > +
> > +drop:
> > +       qstats_drop_inc(this_cpu_ptr(m->common.cpu_qstats));
> > +       return TC_ACT_SHOT;
> > +}
>
>
> Thanks.
