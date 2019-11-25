Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCB20109142
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfKYPuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:50:04 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44676 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728604AbfKYPuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:50:03 -0500
Received: by mail-pf1-f194.google.com with SMTP id d199so2919090pfd.11
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 07:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0ckFKBIumj1sJDi2Zyfxfwyz2kYB6ebsq3r778mZurs=;
        b=koqAF3N/gXQXbYqU9E8a4Bk8AbokpYBl2OShtT1Puiug4BBChlUFU3oE7hJpW/Fj3s
         9+SgzAmM7mJIScfTikCRJi6wDus9kznh8659ejhdlYJwjY9EwGYzcUQWsAZ/PZI0Am6I
         /w3w7uGuAM0VdusEjBmvj3aUYjaAA3ykjneGcW9LZI7jqGzNQAlLU0E075eQSoGnLMVM
         PsDxOJCoV/Ya8vQjRBwwjtM3rZpoS8po4rrCwPk2Yr/bAJGZEwWTr+0c2zzPEvbxElg8
         cPegzS+o1Jxkr3NhEFiGkI/gM72mtPhQqOp/psz82ow7Vwt8D/EK2GELe+eM5LjT2Rcm
         AVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ckFKBIumj1sJDi2Zyfxfwyz2kYB6ebsq3r778mZurs=;
        b=cHuDFF8F/qWqmCAL7CoUwb+dkaNenhxjAUfHo4FY/+brFkGP3Ir0b/HNslpfuXyLjl
         lEyg4Q2CrHTbEq55MRPUYnbQ2pymByhlVbF2oQeyHzLRFQKCmITXr2fn6DvitjjKM2/R
         zA1LYAszmwxJAvNUVhqegwpz/ptvJReNQYrmssLBUQosG0mg3GQKMhTc/fGSvkuRKWpC
         Zv6FHeh3sBP420K6B78kr6Z+lIfxxIGVbWSHLX3gXQOU55FFE96p2K0aEGm7DlqeAL1f
         sX3yjRFEzb1jjF52tcVnNM3e7b071IQce8XcvI0KeMP+IB1xHuseJ37Z4Q712SN+MRnn
         Mvsw==
X-Gm-Message-State: APjAAAUGBFBkwtAJ7pLj94jn6MwKbgNWWHnyhjmSklZE/CVkcNYzb7jt
        xWNrdcBv2uhpRnAw4kbEcf/Y19kY
X-Google-Smtp-Source: APXvYqxBcWkZriRZaO33oL+lRvh/WD3xl28KZuu9ZNHP1Gqw3dCy4Lg5i6dq2Cpju2GE2aFGGRrSdw==
X-Received: by 2002:a63:f716:: with SMTP id x22mr33299529pgh.351.1574697002991;
        Mon, 25 Nov 2019 07:50:02 -0800 (PST)
Received: from martin-VirtualBox ([42.109.141.58])
        by smtp.gmail.com with ESMTPSA id p16sm9054685pgm.8.2019.11.25.07.50.01
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 25 Nov 2019 07:50:02 -0800 (PST)
Date:   Mon, 25 Nov 2019 21:19:51 +0530
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
Message-ID: <20191125154951.GA5135@martin-VirtualBox>
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

you meant 
err = skb_mpls_pop(skb, ethertype, skb->mac_len,
                   ovs_key_mac_proto() == MAC_PROTO_ETHERNET); 

Yes we could use it.


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
