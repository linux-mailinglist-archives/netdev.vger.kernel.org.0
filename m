Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8895108C7F
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 12:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfKYLCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 06:02:52 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44316 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfKYLCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 06:02:52 -0500
Received: by mail-pf1-f195.google.com with SMTP id d199so2560278pfd.11
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 03:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MBw3alF7NKYOnY9f5ymUIOAF+u5/t0JakkEQkCeUm9Y=;
        b=g+YOizeBeaEdVLdu/G6pUx6BXZrcT4tiiuOeNNdAtOU2AQ9dxpy0iVkOgANpXVHXY/
         vXVv8jeA86CfWZ3JhPgLg1cpuPZ7vjBl7hMr0vRc6fhyQLuhnfKAnBQM6BRGG50Dz2DH
         +1geWFpFb3jTpUNAlLkc7vZrZSKJsZezmsAR0UN/lboa5o+zykjFGuzQ/TOXI0zfIppz
         yeCBS7bzBJBUp0Pklwz6lR1K0I/XpjGNPJ6rvjGuqtZ8aVP7hp3b2Szcq/LRmnfWkHyj
         0gYTyCV/FDaN3cOukthwUoR5kl0AeMB3iCBCRpMya03488fpK+uziYFuNLRFfcSzGxqh
         Df/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MBw3alF7NKYOnY9f5ymUIOAF+u5/t0JakkEQkCeUm9Y=;
        b=jKA9QzQ0IQapfOqoObDbx91L81aa8fearG5ay9dTlpHhhTayLxPipOfbUOuODXNthv
         pmPGFqo/bg9EYaqbb6njtF1Z81+7NUcrmUwwosYXs6j4VjIsd02zdmbXhBTJF1Li0M0p
         mNNvvRqS4G8Wwa9w/GusnOqcJlTq7PnW2CWyFS+scqKm+chWsrPWLh3OmliJwgj8OTF0
         6Li+qqcutL/ss1MSBLxDHGXBSKsvJYc6oUN/EQ3eI8/oJybrdO7P3JEkcBmO5/InJfd1
         5ZTy8hRKJpjWjIB7/e5DhXVt7oh42m679dvNvdvjdbxGeOQks+MuqGZZCT9QoYNkRxwQ
         2wAQ==
X-Gm-Message-State: APjAAAURG6hmi/rB12y5locLAyFvHTekDM2YM/1NawwClFsb7CS3mXqi
        9TKi4XZxng7PuV1JyVizjNo=
X-Google-Smtp-Source: APXvYqxh2iOEWniYrAmervm5eCL9R6aDNWJzF2J6U/Gn8I0z1qCONTOdyeaIOwXULX8/bFviAYhHyg==
X-Received: by 2002:a63:d550:: with SMTP id v16mr31318326pgi.443.1574679771190;
        Mon, 25 Nov 2019 03:02:51 -0800 (PST)
Received: from martin-VirtualBox ([42.109.147.118])
        by smtp.gmail.com with ESMTPSA id b11sm7795994pfd.83.2019.11.25.03.02.49
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 25 Nov 2019 03:02:50 -0800 (PST)
Date:   Mon, 25 Nov 2019 16:32:34 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        martin.varghese@nokia.com
Subject: Re: [PATCH v2 net-next] Enhanced skb_mpls_pop to update ethertype of
 the packet in all the cases when an ethernet header is present is the
 packet.
Message-ID: <20191125110234.GA2795@martin-VirtualBox>
References: <1574505299-23909-1-git-send-email-martinvarghesenokia@gmail.com>
 <20191124191008.1e65f736@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191124191008.1e65f736@cakuba.netronome.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 24, 2019 at 07:10:08PM -0800, Jakub Kicinski wrote:
> On Sat, 23 Nov 2019 16:04:59 +0530, Martin Varghese wrote:
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
> 
> So this fixes all the way back to commit ed246cee09b9 ("net: core: move
> pop MPLS functionality from OvS to core helper")? Please add a Fixes: tag.
> 
> > Changes in v2:
> >     - check for dev type removed while updating ethertype
> >       in function skb_mpls_pop.
> >     - key->mac_proto is checked in function pop_mpls to pass
> >       ethernt flag to skb_mpls_pop.
> >     - dev type is checked in function tcf_mpls_act to pass
> >       ethernet flag to skb_mpls_pop.
> 
> nit: changelog can be kept in the commit message for netdev patches
>
Multiple versions are mostly due to coding error.do you insist to keep
the change log in commit message ?
 
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
> 
> Please don't remove the empty line between params and function
> description.
> 
> >   * Expects skb->data at mac header.
> >   *
> >   * Returns 0 on success, -errno otherwise.
> >   */
> > -int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len)
> > +int skb_mpls_pop(struct sk_buff *skb, __be16 next_proto, int mac_len,
> > +		 bool ethernet)
> >  {
> >  	int err;
> >  
> 
> > diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
> > index 4d8c822..f919f95 100644
> > --- a/net/sched/act_mpls.c
> > +++ b/net/sched/act_mpls.c
> > @@ -13,6 +13,7 @@
> >  #include <net/pkt_sched.h>
> >  #include <net/pkt_cls.h>
> >  #include <net/tc_act/tc_mpls.h>
> > +#include <linux/if_arp.h>
> 
> Please retain the alphabetical order of includes.
> 
> >  static unsigned int mpls_net_id;
> >  static struct tc_action_ops act_mpls_ops;
> > @@ -76,7 +77,8 @@ static int tcf_mpls_act(struct sk_buff *skb, const struct tc_action *a,
> >  
> >  	switch (p->tcfm_action) {
> >  	case TCA_MPLS_ACT_POP:
> > -		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len))
> > +		if (skb_mpls_pop(skb, p->tcfm_proto, mac_len,
> > +				 (skb->dev && skb->dev->type == ARPHRD_ETHER)))
> 
> Parenthesis unnecessary
> 
> >  			goto drop;
> >  		break;
> >  	case TCA_MPLS_ACT_PUSH:
> 
Thanks for reviewing the patch.
