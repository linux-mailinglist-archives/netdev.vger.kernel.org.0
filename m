Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E704108BDC
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfKYKjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:39:41 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:45434 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfKYKjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:39:41 -0500
Received: by mail-pj1-f65.google.com with SMTP id m71so6400815pjb.12
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 02:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j8IqfviksNWRn/4JUtMb0ogOgmVweOO27c0ivfhgjnU=;
        b=GCIQ72xktkJTFyrF1BJhzVWMlQVSu5QJhok7LpjvduB8tWFtCoDWc7xP60hGSKApOt
         9UFUcff83Sh0mlzkJwSFyAJQ5KjLM5bzUjtMIgl9goXOBhEnN78j9RsIyqNrDsnoHwd7
         gjs0LxPLwuBgTvMkiR45OM0a36OoaF5ABscEK2zZIPkTLRC82axZhZa1uP9dYtRkecG+
         4FK08RTZsC829TFYxGGdDsRbSHq0ptKFocfDWE8drKC/AEhauB9MN8aKQemwxX0+USoa
         JrdfB1dznq8hufE4//AEj8xIHrGmjA63rzNTOeBFwHzxyQ/tbg1dJJZV3e/uQ8AP0Ak4
         8VYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j8IqfviksNWRn/4JUtMb0ogOgmVweOO27c0ivfhgjnU=;
        b=ptPSk/reBUZKNj+wIgtJQoz5Q2g/+aGTgZeO+nyj+zig9koUYkYKdpQzIzek+H3KL+
         I/gnADhwkg+01FlB3KGKkZPXnvTi2JHCeMJv2emmpcXAp82O6+zDayUkrckxrZcCiMR0
         a3fGZK4k9U7os8X2QHKaosJRapXHcVyjlvgWf7oFFz0jwpx2HTBc1Ytn3I4tr1udQOOf
         D9uKw8oQ5FctxMVupdmjpi+xL2qk59G+6i4hme8ccpEoiL7pBQXfahTP7mcR0clgNMBf
         y9h9wDbHBL3gcwNDPy4EPq+HjRoppLlC+kqaf48DuPjIxEEDpauF7atdwlfexuUbmSGP
         5SqA==
X-Gm-Message-State: APjAAAXpLBSjx8LjtwiobW4jl19Fp9VoELsjOmRQKHnJ0ex4xVNN5Sg/
        4oXdLJVc8MnS5wVEfMmr6Yhsu5Id
X-Google-Smtp-Source: APXvYqwgWO582ThyVagumKsjSGvE/edrXGDqDMWnFtfEKYeuWq/sSvkrq27T1F3Vz9kZZ3fvoemzTQ==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr14734847pjy.107.1574678378853;
        Mon, 25 Nov 2019 02:39:38 -0800 (PST)
Received: from martin-VirtualBox ([42.109.131.32])
        by smtp.gmail.com with ESMTPSA id b17sm8167162pfr.17.2019.11.25.02.39.37
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 25 Nov 2019 02:39:38 -0800 (PST)
Date:   Mon, 25 Nov 2019 16:09:30 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Subject: Re: [PATCH v2 net-next] Enhanced skb_mpls_pop to update ethertype of
 the packet in all the cases when an ethernet header is present is the
 packet.
Message-ID: <20191125103930.GA2684@martin-VirtualBox>
References: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_AeJFYsvTLigMDB=j4XDsDsHR0sKADK33P5Qf7BiMVrug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOrHB_AeJFYsvTLigMDB=j4XDsDsHR0sKADK33P5Qf7BiMVrug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 09:32:21PM -0800, Pravin Shelar wrote:
> On Sat, Nov 23, 2019 at 2:35 AM Martin Varghese
> <martinvarghesenokia@gmail.com> wrote:
> >
> > From: Martin Varghese <martin.varghese@nokia.com>
> >
> > The skb_mpls_pop was not updating ethertype of an ethernet packet if the
> > packet was originally received from a non ARPHRD_ETHER device.
> >
> > In the below OVS data path flow, since the device corresponding to port 7
> > is an l3 device (ARPHRD_NONE) the skb_mpls_pop function does not update
> > the ethertype of the packet even though the previous push_eth action had
> > added an ethernet header to the packet.
> >
> > recirc_id(0),in_port(7),eth_type(0x8847),
> > mpls(label=12/0xfffff,tc=0/0,ttl=0/0x0,bos=1/1),
> > actions:push_eth(src=00:00:00:00:00:00,dst=00:00:00:00:00:00),
> > pop_mpls(eth_type=0x800),4
> >
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > ---
> > Changes in v2:
> >     - check for dev type removed while updating ethertype
> >       in function skb_mpls_pop.
> >     - key->mac_proto is checked in function pop_mpls to pass
> >       ethernt flag to skb_mpls_pop.
> >     - dev type is checked in function tcf_mpls_act to pass
> >       ethernet flag to skb_mpls_pop.
> >
> >  include/linux/skbuff.h    | 3 ++-
> >  net/core/skbuff.c         | 7 ++++---
> >  net/openvswitch/actions.c | 4 +++-
> >  net/sched/act_mpls.c      | 4 +++-
> >  4 files changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index dfe02b6..70204b9 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -3530,7 +3530,8 @@ int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
> >  int skb_vlan_push(struct sk_buff *skb, __be16 vlan_proto, u16 vlan_tci);
> >  int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
> >                   int mac_len);
> > -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len);
> > +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> > +                bool ethernet);
> >  int skb_mpls_update_lse(struct sk_buff *skb, __be32 mpls_lse);
> >  int skb_mpls_dec_ttl(struct sk_buff *skb);
> >  struct sk_buff *pskb_extract(struct sk_buff *skb, int off, int to_copy,
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 867e61d..988eefb 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -5529,12 +5529,13 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
> >   * @skb: buffer
> >   * @next_proto: ethertype of header after popped MPLS header
> >   * @mac_len: length of the MAC header
> > - *
> > + * @ethernet: flag to indicate if ethernet header is present in packet
> >   * Expects skb->data at mac header.
> >   *
> >   * Returns 0 on success, -errno otherwise.
> >   */
> > -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> > +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> > +                bool ethernet)
> >  {
> >         int err;
> >
> > @@ -5553,7 +5554,7 @@ int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> >         skb_reset_mac_header(skb);
> >         skb_set_network_header(skb, mac_len);
> >
> > -       if (skb->dev && skb->dev->type == ARPHRD_ETHER) {
> > +       if (ethernet) {
> >                 struct ethhdr *hdr;
> >
> >                 /* use mpls_hdr() to get ethertype to account for VLANs. */
> > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > index 12936c1..264c3c0 100644
> > --- a/net/openvswitch/actions.c
> > +++ b/net/openvswitch/actions.c
> > @@ -179,7 +179,9 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> >  {
> >         int err;
> >
> > -       err = skb_mpls_pop(skb, ethertype, skb->mac_len);
> > +       err = skb_mpls_pop(skb, ethertype, skb->mac_len,
> > +                          (key->mac_proto & ~SW_FLOW_KEY_INVALID)
> > +                           == MAC_PROTO_ETHERNET);
> >         if (err)
> >                 return err;
> >
> Why you are not using ovs_key_mac_proto() here?
>

ovs_key_mac_proto returns u8  (supposedly enum sw_flow_mac_proto)

The new skb_mpls_pop takes bool as the last argument.
int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
                 bool ethernet)

But if I change the new prototype to take u8(enum sw_flow_mac_proto) as the last argument

I need to make the generic skb_mpls_pop code aware of enum sw_flow_mac_proto defined in Openvswitch/flow.h .

-  if (ethernet) {
+ if(ethernet == MAC_PROTO_ETHERNET)
                struct ethhdr *hdr;

                /* use mpls_hdr() to get ethertype to account for VLANs. */
                hdr = (struct ethhdr *)((void *)mpls_hdr(skb) - ETH_HLEN);
                skb_mod_eth_type(skb, hdr, next_proto);
        }
        skb->protocol = next_proto;

Also ,it means at all the places where skb_mpls_pop is used, this Openvswitch header file (Openvswitch/flow.h)
has to be included, which I assume is not clean.
 
> > diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> > index 4d8c822..f919f95 100644
> > --- a/net/sched/act_mpls.c
> > +++ b/net/sched/act_mpls.c
> > @@ -13,6 +13,7 @@
> >  #include <net/pkt_sched.h>
> >  #include <net/pkt_cls.h>
> >  #include <net/tc_act/tc_mpls.h>
> > +#include <linux/if_arp.h>
> >
> >  static unsigned int mpls_net_id;
> >  static struct tc_action_ops act_mpls_ops;
> > @@ -76,7 +77,8 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
> >
> >         switch (p->tcfm_action) {
> >         case TCA_MPLS_ACT_POP:
> > -               if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
> > +               if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
> > +                                (skb->dev && skb->dev->type == ARPHRD_ETHER)))
> >                         goto drop;
> >                 break;
> >         case TCA_MPLS_ACT_PUSH:
> > --
> > 1.8.3.1
> >
