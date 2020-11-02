Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D43D2A2FB0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 17:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbgKBQYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 11:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbgKBQYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 11:24:07 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F89BC0617A6;
        Mon,  2 Nov 2020 08:24:07 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id n2so3489024ooo.8;
        Mon, 02 Nov 2020 08:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=w9obkmQ3S9/UrIXW7Ha5Mkw4wWaM4vZoOdxPVxziExw=;
        b=tvYTBXFlUCVjQfTRnYJDT6NQlYaTnsJJaU8gGx3wn41lQKExEgoDWJ/7cQH6kYrVm3
         QYPo/bEfRmU4KxHh/pCOgToQIVgPpSfPtCRK87mBM6Yt8v+0FwQvoeEzmADXJgna4uc8
         R2+3SC91AmBr3PpyTv1Yu392JVLhKaAhC10h3YmXxN3bmcGDS+dKMvzfzXN4MO/WAKt6
         hP8nVSiQvcHNv9FVSSfMuxGRt3+60JIdP4VXhLZ0IhcVxBBOMU5gcaojDRnIVf7U8p5m
         4qkKXqYKduMh5pCUz4mXKNEUBzHkVPt7S5Yg1VpPM9NRF3tpV1lIRCWgghq3llYs1UEf
         jqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=w9obkmQ3S9/UrIXW7Ha5Mkw4wWaM4vZoOdxPVxziExw=;
        b=HCOSHVDpTIFMRvaNS88KVVfa18XU1rdUB4tTwY6/TXS3/gzhSsNTZefVErxFKa3oC/
         7H61xr2E5CrfBxE39Q2/ZbzouPDj9N6o2LxOfHarXj3Fsov9XwZ8ohQzq+8zNGciS1iC
         XtLUjxfmoHO1ZmxF9PazkAaAuzN0OEFX310zBNUNNsQiD+LJzjxYwfJh5f8VdDmmGN4V
         /mO8iFemN2Bw9FT/9YLFsrIcQhWQ7sXEGDY4oP9UubXr4Nrp6KrOvkUY7TXRCWvccca3
         b4aRu5KFUN2UrFy8tKTl3JgTwn2k6j4k0jjHpuczCkgY08n9Ab2bH/vGMnBiKSUmK6bg
         6Hcg==
X-Gm-Message-State: AOAM533f0XcbMbBx5rjiQMEGetr4PyyMtmI2tkITrKFzzRyCAcIeIScc
        iTtbz27DTDrB9O3IgRCKFgw=
X-Google-Smtp-Source: ABdhPJwuc5fsy5LuMol1onjryOdxYujHGid8NoarJ67QL6Br1Pub9kWqvnpB579sINbTvIIU/dYTdg==
X-Received: by 2002:a4a:d6d0:: with SMTP id j16mr12563232oot.38.1604334246777;
        Mon, 02 Nov 2020 08:24:06 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y74sm802223oie.8.2020.11.02.08.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:24:06 -0800 (PST)
Date:   Mon, 02 Nov 2020 08:23:59 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Message-ID: <5fa0329fc0379_1ecdb208de@john-XPS-13-9370.notmuch>
In-Reply-To: <20201102134658.081fd974@carbon>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407666748.1525159.1515139110258948831.stgit@firesoul>
 <5f9c7935c6991_16d420838@john-XPS-13-9370.notmuch>
 <20201102134658.081fd974@carbon>
Subject: Re: [PATCH bpf-next V5 4/5] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Fri, 30 Oct 2020 13:36:05 -0700
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
> > Jesper Dangaard Brouer wrote:
> > > The use-case for dropping the MTU check when TC-BPF does redirect to
> > > ingress, is described by Eyal Birger in email[0]. The summary is the
> > > ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> > > ingress redirect packet and let normal netstack fragment packet as needed.
> > > 
> > > [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> > > 
> > > V4:
> > >  - Keep net_device "up" (IFF_UP) check.
> > >  - Adjustment to handle bpf_redirect_peer() helper
> > > 
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > ---
> > >  include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
> > >  net/core/dev.c            |   19 ++-----------------
> > >  net/core/filter.c         |   14 +++++++++++---
> > >  3 files changed, 42 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 964b494b0e8d..bd02ddab8dfe 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -3891,11 +3891,38 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> > >  bool is_skb_forwardable(const struct net_device *dev,
> > >  			const struct sk_buff *skb);
> > >  
> > > +static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
> > > +						 const struct sk_buff *skb,
> > > +						 const bool check_mtu)  
> > 
> > It looks like if check_mtu=false then this is just an interface up check.
> > Can we leave is_skb_forwardable logic alone and just change the spots where
> > this is called with false to something with a name that describes the check,
> > such as is_dev_up(dev). I think it will make this change smaller and the
> > code easier to read. Did I miss something?
> 
> People should realized that this is constructed such, the compiler will
> compile-time remove the actual argument (the const bool check_mtu).
> And this propagates also to ____dev_forward_skb() where the call places
> are also inlined.

The comment was about human reading the code not what gets generated
by the compiler.

> 
> Yes, this (check_mtu=false) is basically an interface up check, but the
> only place it is used directly is in the ndo_get_peer_dev() case, and
> reading the code I find it more readable that is says
> __is_skb_forwardable because this is used as part of a forwarding step,
> and is_dev_up() doesn't convey the intent in this use-case.

OK.

[...]

> 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index bd4a416bd9ad..71b78b8d443c 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
> >  
> >  static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
> >  {
> > -	return dev_forward_skb(dev, skb);
> > +	int ret = ____dev_forward_skb(dev, skb, false);
> > +
> > +	if (likely(!ret)) {
> > +		skb->protocol = eth_type_trans(skb, dev);
> > +		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > +		ret = netif_rx(skb);
> > +	}
> > +
> > +	return ret;
> >  }
> 
> I'm replicating two lines from dev_forward_skb(), but I couldn't find a
> way to avoid this, without causing larger code changes (and slower code).
> 

OK looks good to me then.

> 
> 
> > Other than style aspects it looks correct to me.
> > 
> > >  	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
> > > -	    unlikely(!is_skb_forwardable(dev, skb))) {
> > > +	    unlikely(!__is_skb_forwardable(dev, skb, check_mtu))) {
> > >  		atomic_long_inc(&dev->rx_dropped);
> > >  		kfree_skb(skb);
> > >  		return NET_RX_DROP;
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 9499a414d67e..445ccf92c149 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -2188,28 +2188,13 @@ static inline void net_timestamp_set(struct sk_buff *skb)
> > >    
> > 
> 
> 
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 


