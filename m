Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8A28B6A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbfEWUPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:15:54 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44807 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387454AbfEWUPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:15:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id g9so3842224pfo.11
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T+Fi07rL0yHY3bEW+6OOr73hVLQP4WIs0yW0wcsEK6o=;
        b=FM/Q/Ed9xqnyedNJ0+dMD6JyCxDhNoPgpI96oJks/IgRrlNFqT5zdPjd5iKLpmB02o
         71sydt0RHn5QCYg/5UDHrFP+C3tRUsWOwDEuR5chzS3/qaQgYCCo2eHHAO1iTTmX4yMR
         61wQyJEG6AEiVPAunlF6v3JkXZJhqGQTSDjk+WhSunZohkaOP1QceqM68c7W2SV5iwpz
         XAEStFrpH1cDZrd+930HsTazqTM63XoiukisTzA1P+IMrStnjSv0wIQTN5kBJzED0EOD
         pXrR6WZ2UTbqTPt32Gv4dLsJtG3ibqjP1ukYAnTtl3dfBatBlxFSy38q70xvaQZ21V6Y
         KSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T+Fi07rL0yHY3bEW+6OOr73hVLQP4WIs0yW0wcsEK6o=;
        b=NtNOQHvIjLVxas39KI1jfZD8cJywj4tJ/eipVdoG4HESE0sBKTwHEKIhlPD9rAoQ9C
         nlVhlr+WIJjmDLcZaaR7gwt82UkXIoXpZ3sTB1vxyl4327PO/4mdG2kcNjrL4ir3riHc
         bno1FgS0aNhXsM0VeIAYGIzf7tcaCifQG9/PxF8+GUiPg/FzV5camH5qQMalXBVmKzqf
         7vWD+7WCSH694AYyGdf6tHB03GfQXGmDtF3Y3IZG2ib2v+UBlVg405qq6EI0EGgt2ISs
         vY+LijxWMsIP8ZLxQJQ53kmpknSEIyKaz0ofh13RWn7SK0NTKDb7PD5bx57wH2+F18Sq
         T4tw==
X-Gm-Message-State: APjAAAXnWTTEUviaBlY+MiylDoysuVLirwrNvPUDl1dH+c1xwURXdWIe
        mWCeHU7x83vstVnbdNF+PcqhNQ==
X-Google-Smtp-Source: APXvYqxK4XgC4avXmSlD0adsEUE5TRHwpDU48ShkJmbTDQX6WTjR6R6fpx2X6scsW4jrBB2nSi+j/Q==
X-Received: by 2002:a17:90a:308e:: with SMTP id h14mr3843253pjb.13.1558642553495;
        Thu, 23 May 2019 13:15:53 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id g8sm190628pgq.33.2019.05.23.13.15.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 13:15:53 -0700 (PDT)
Date:   Thu, 23 May 2019 13:15:44 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "jesper.brouer@gmail.com" <jesper.brouer@gmail.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] net: core: support XDP generic on stacked
 devices.
Message-ID: <20190523131544.6d8a28f7@hermes.lan>
In-Reply-To: <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
        <20190523175429.13302-3-sthemmin@microsoft.com>
        <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 19:19:40 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> On Thu, 2019-05-23 at 10:54 -0700, Stephen Hemminger wrote:
> > When a device is stacked like (team, bonding, failsafe or netvsc) the
> > XDP generic program for the parent device was not called.
> > 
> > Move the call to XDP generic inside __netif_receive_skb_core where
> > it can be done multiple times for stacked case.
> > 
> > Suggested-by: Jiri Pirko <jiri@resnulli.us>
> > Fixes: d445516966dc ("net: xdp: support xdp generic on virtual
> > devices")
> > Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
> > ---
> > v1 - call xdp_generic in netvsc handler
> > v2 - do xdp_generic in generic rx handler processing
> > v3 - move xdp_generic call inside the another pass loop
> > 
> >  net/core/dev.c | 56 ++++++++++------------------------------------
> > ----
> >  1 file changed, 11 insertions(+), 45 deletions(-)
> > 
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b6b8505cfb3e..696776e14d00 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4502,23 +4502,6 @@ static int netif_rx_internal(struct sk_buff
> > *skb)
> >  
> >  	trace_netif_rx(skb);
> >  
> > -	if (static_branch_unlikely(&generic_xdp_needed_key)) {
> > -		int ret;
> > -
> > -		preempt_disable();
> > -		rcu_read_lock();
> > -		ret = do_xdp_generic(rcu_dereference(skb->dev-  
> > >xdp_prog), skb);  
> > -		rcu_read_unlock();
> > -		preempt_enable();
> > -
> > -		/* Consider XDP consuming the packet a success from
> > -		 * the netdev point of view we do not want to count
> > -		 * this as an error.
> > -		 */
> > -		if (ret != XDP_PASS)
> > -			return NET_RX_SUCCESS;
> > -	}
> > -  
> 
> Adding Jesper, 
> 
> There is a small behavioral change due to this patch, 
> the XDP program after this patch will run on the RPS CPU, if
> configured, which could cause some behavioral changes in
> xdp_redirect_cpu: bpf_redirect_map(cpu_map).
> 
> Maybe this is acceptable, but it should be documented, as the current
> assumption dictates: XDP program runs on the core where the XDP
> frame/SKB was first seen.

Or maybe XDP should just force off RPS (like it does gro)
