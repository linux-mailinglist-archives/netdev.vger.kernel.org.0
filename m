Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3C5294B0
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390047AbfEXJdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:33:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41410 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389745AbfEXJdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 05:33:35 -0400
Received: by mail-lj1-f196.google.com with SMTP id q16so8052396ljj.8
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 02:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brouer-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CDrBIURYymJhz6Hcmi/PXMKCap0E5jl5+yhVbBrxMlw=;
        b=bIarGdTxWRyT23u5/8+3/AQw/cCuVKNd4Itrpsk5TpF1VwkAPPFk1c2Ms6qKlIYmM6
         0ekXN0v8ulg9WPpbTZuaESi/6W8pfIWAhtevzPbYuuq2/6sBf4+kU3SrUSK8NMUl2FD6
         7yq/66Bsn1aaU5qQavoyT+541Kt4bG64JJoYSHMMjOc9wBWr17NA10AztS5TLoM+5Gpc
         J6FZC6ErsjuTDifeGAgOsZpJPRD5ZTuINF4XK8C60GA9CKobDycw7NjzQZ8SCEj/yO/J
         mGixMk1rFWWJTCsDubR2xD4UEYEvRMu4goh1XcWGofcB+f9XrHvYeHTFCv80X2mkk1pe
         1mHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CDrBIURYymJhz6Hcmi/PXMKCap0E5jl5+yhVbBrxMlw=;
        b=rd1sWKOCVwmvu7g/M5lCqygNi49yzKUgTAzP9WqyjWsDm/rMSTeaIu1XeIxf+JLR7y
         ujYKglbGYFpS3bxAqww7P+snR6K/w5hNshaeq6guOFqTMfYLLxRVWp/c/moUvlsWZ7p1
         bCfB3f78uTwWfqo1DnKsjwRvYqhroWTKsucuNTcjOI1riCHC9sD7Bd/s6wbCrFj7l+Cc
         Ro2HjhB9Mvu25CP/y0c7sZXSoqhFxT0m40MTZWVzfRkBBUs7MkhENYE/1P+GwiDaPqmT
         +i/bDufK/OoJwhnOcO2LdQZC3rlqIjhPwTNZwz+YQFJ2dWrQL0xxDXwPymE5WbQJ8Mmn
         Yk0g==
X-Gm-Message-State: APjAAAV5AqwiKta1zhgktcPAEhmCIMs6BvSzNw1Sgx7nNlPvknJFmgmP
        6U7FgGQ7y4wlG6EjyXRwUezJXg==
X-Google-Smtp-Source: APXvYqyJP+9cF7ZfUAJla8YknTNHPPOT0Dcu2LasAfmBTl6KVK0bmVNTIGEzspnig7vgE9a/SSwpcA==
X-Received: by 2002:a2e:84a:: with SMTP id g10mr4283040ljd.98.1558690412836;
        Fri, 24 May 2019 02:33:32 -0700 (PDT)
Received: from carbon (80-167-222-154-cable.dk.customer.tdc.net. [80.167.222.154])
        by smtp.gmail.com with ESMTPSA id m5sm490073lfb.47.2019.05.24.02.33.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 02:33:32 -0700 (PDT)
Date:   Fri, 24 May 2019 11:33:06 +0200
From:   Jesper Dangaard Brouer <netdev@brouer.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH v3 2/2] net: core: support XDP generic on stacked
 devices.
Message-ID: <20190524113306.28b83b1f@carbon>
In-Reply-To: <20190523131544.6d8a28f7@hermes.lan>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
        <20190523175429.13302-3-sthemmin@microsoft.com>
        <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
        <20190523131544.6d8a28f7@hermes.lan>
Organization: Red Hat Inc.
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 13:15:44 -0700
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Thu, 23 May 2019 19:19:40 +0000
> Saeed Mahameed <saeedm@mellanox.com> wrote:
> 
> > On Thu, 2019-05-23 at 10:54 -0700, Stephen Hemminger wrote:  
> > > When a device is stacked like (team, bonding, failsafe or netvsc) the
> > > XDP generic program for the parent device was not called.
> > > 
> > > Move the call to XDP generic inside __netif_receive_skb_core where
> > > it can be done multiple times for stacked case.
> > > 
> > > Suggested-by: Jiri Pirko <jiri@resnulli.us>
> > > Fixes: d445516966dc ("net: xdp: support xdp generic on virtual
> > > devices")
> > > Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> > > ---
> > > v1 - call xdp_generic in netvsc handler
> > > v2 - do xdp_generic in generic rx handler processing
> > > v3 - move xdp_generic call inside the another pass loop
> > > 
> > >  net/core/dev.c | 56 ++++++++++------------------------------------
> > > ----
> > >  1 file changed, 11 insertions(+), 45 deletions(-)
> > > 
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index b6b8505cfb3e..696776e14d00 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -4502,23 +4502,6 @@ static int netif_rx_internal(struct sk_buff
> > > *skb)
> > >  
> > >  	trace_netif_rx(skb);
> > >  
> > > -	if (static_branch_unlikely(&generic_xdp_needed_key)) {
> > > -		int ret;
> > > -
> > > -		preempt_disable();
> > > -		rcu_read_lock();
> > > -		ret = do_xdp_generic(rcu_dereference(skb->dev-    
> > > >xdp_prog), skb);    
> > > -		rcu_read_unlock();
> > > -		preempt_enable();
> > > -
> > > -		/* Consider XDP consuming the packet a success from
> > > -		 * the netdev point of view we do not want to count
> > > -		 * this as an error.
> > > -		 */
> > > -		if (ret != XDP_PASS)
> > > -			return NET_RX_SUCCESS;
> > > -	}
> > > -    
> > 
> > Adding Jesper, 
> > 
> > There is a small behavioral change due to this patch, 
> > the XDP program after this patch will run on the RPS CPU, if
> > configured, which could cause some behavioral changes in
> > xdp_redirect_cpu: bpf_redirect_map(cpu_map).
> > 
> > Maybe this is acceptable, but it should be documented, as the current
> > assumption dictates: XDP program runs on the core where the XDP
> > frame/SKB was first seen.  

This does break some assumptions, that I worry about.  I've not
optimized generic XDP much, as this is suppose to be slow-path, but as
you can see in my evaluation[1] generic-XDP do have a performance
potential (XDP drop: native=12Mpps and generic=8.4Mpps), but the
XDP-generic performance dies as soon as we e.g. do XDP_TX
(native=10Mpps and generic=4Mpps).  The reason is lack of bulking.

We could implement the same kind of RX-bulking tricks as we do for
XDP_REDIRECT, where bpf_redirect_map store frames in the map and send
them once NAPI-poll exit via a xdp_do_flush_map().  These tricks
depend on per-CPU data (bpf_redirect_info), thus I cannot see how this
could work if XDP-generic now happens after RPS on a remote CPU.

Notice, that TX bulking at XDP-generic level, is actually rather
simple, as netstack TX path-code support xmit_more via creating a list
of SKBs... Last time I hacked it up, I saw 20%-30% speedup... anyone
motivated to do this?

> 
> Or maybe XDP should just force off RPS (like it does gro)

I guess, we could force off RPS.  But I do see one valid use-case of
combining CPUMAP redirect with RFS (Receive Flow Steering) which is part
of RPS.  Yes, I know we/I *also* have to implement generic-XDP-cpumap
support. But for native-XDP CPUMAP redirect, from 1-2 RX-CPUs into
N-remote CPUs via CPUMAP, and then lets RFS send SKBs to where the
application runs, does make sense to me. (I do have an "assignment" to
implement this in eBPF here[2]).


[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/Documentation/blogposts/xdp25_eval_generic_xdp_tx.rst

[2] https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap.org#cpumap-implement-dynamic-load-balancer-that-is-ooo-safe
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
