Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43926372CD9
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 17:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhEDPWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 11:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhEDPWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 11:22:05 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A96C061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 08:21:09 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id a4so9883752wrr.2
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 08:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aEdqS7pdiyLCIJYayaS5kAzFZi2LdXOPyRL1s5b/IaQ=;
        b=WUOchx6Oj9YGBrY7qf+3qjv/qNzHkallUzcwBmPKlWOefziMZkAaWpfsTgSQuxnUm0
         lQr3fc/suIPheBR/w6ktptLAA2yW0NpcABuSJnu4AAzAWJcBmoFhs00HQi0Ke4lWp62W
         HNDMvxd/ptJXzEC85Yx7rbGRdMsJPRp2c7c/GzHCog1wHbKJ9UO8UK8yAplrlx4I3X0I
         RjkH8gNin9XI+UYr0fCTSmI0MXIhidj4PEFzvHNivQgUjYbnexdsxkmw7hnYIhvsbCze
         xucudSW5sJcoV0QsEkwJTuGgvJP6zen/lny4H3n+6elArkvRDV6BoHHpX0Jxtw+/jfpK
         hYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aEdqS7pdiyLCIJYayaS5kAzFZi2LdXOPyRL1s5b/IaQ=;
        b=CJNS3K4rGLJnAo87J2l2ZRwvWeLZb3EQlVcgD3XAC5/M3yXwnBtD/GLhD5xz/1D5ZZ
         Ma/N4+LJu+l9zlev06dP03yNIGqDH+7XeRfi3HTGwUoygLO68ZRjzdPvqVa3LO5Yu9t3
         VPrbYIGidrH2UIGD9E1OCTo+/mTSJwVtdBGGyW2tFKK0avoslkSftWo9no6NcPbA9mg/
         GyWgGQAMkwCcNL/PIylxbcrWVkA7gQm12KzhCtz0D2Ulevu5MU5GdlWTjs5t0HgjD/Le
         wrToCZbezNWFdpXFOTJFGRX4NWW3qQV6l+aM9uOExkKkRR40Jx/G7xjLRkxTtc1RiwW/
         xwUA==
X-Gm-Message-State: AOAM533/S125ALYQsrx6Uvsh7MDf1JzwbdDCB/numkTT0wQxKnVIsI6h
        rvmYYBz8VxJwU/SmUZ/XkoM=
X-Google-Smtp-Source: ABdhPJy7fE67VnlN/DspgkVj7/i00iFH0dLw21s/qf0G3KegfdlGuchgdnPD3NyHSEuyCgma1Jy2fg==
X-Received: by 2002:adf:c002:: with SMTP id z2mr32603841wre.100.1620141668484;
        Tue, 04 May 2021 08:21:08 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id m7sm2786817wrv.35.2021.05.04.08.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 08:21:08 -0700 (PDT)
Date:   Tue, 4 May 2021 18:21:06 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, jiri@resnulli.us, idosch@idosch.org,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 6/9] net: dsa: Forward offloading
Message-ID: <20210504152106.oppawchuruapg4sb@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-7-tobias@waldekranz.com>
 <20210427101747.n3y6w6o7thl5cz3r@skbuf>
 <878s4uo8xc.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878s4uo8xc.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 04:44:31PM +0200, Tobias Waldekranz wrote:
> On Tue, Apr 27, 2021 at 13:17, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Apr 26, 2021 at 07:04:08PM +0200, Tobias Waldekranz wrote:
> >> Allow DSA drivers to support forward offloading from a bridge by:
> >> 
> >> - Passing calls to .ndo_dfwd_{add,del}_station to the drivers.
> >> 
> >> - Recording the subordinate device of offloaded skbs in the control
> >>   buffer so that the tagger can take the appropriate action.
> >> 
> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> ---
> >>  include/net/dsa.h |  7 +++++++
> >>  net/dsa/slave.c   | 36 ++++++++++++++++++++++++++++++++++--
> >>  2 files changed, 41 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/include/net/dsa.h b/include/net/dsa.h
> >> index 1f9ba9889034..77d4df819299 100644
> >> --- a/include/net/dsa.h
> >> +++ b/include/net/dsa.h
> >> @@ -119,6 +119,7 @@ struct dsa_netdevice_ops {
> >>  
> >>  struct dsa_skb_cb {
> >>  	struct sk_buff *clone;
> >> +	struct net_device *sb_dev;
> >>  };
> >>  
> >>  struct __dsa_skb_cb {
> >> @@ -828,6 +829,12 @@ struct dsa_switch_ops {
> >>  					  const struct switchdev_obj_ring_role_mrp *mrp);
> >>  	int	(*port_mrp_del_ring_role)(struct dsa_switch *ds, int port,
> >>  					  const struct switchdev_obj_ring_role_mrp *mrp);
> >> +
> >> +	/* L2 forward offloading */
> >> +	void *	(*dfwd_add_station)(struct dsa_switch *ds, int port,
> >> +				    struct net_device *sb_dev);
> >> +	void	(*dfwd_del_station)(struct dsa_switch *ds, int port,
> >> +				    struct net_device *sb_dev);
> >>  };
> >>  
> >>  #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
> >> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> >> index 77b33bd161b8..3689ffa2dbb8 100644
> >> --- a/net/dsa/slave.c
> >> +++ b/net/dsa/slave.c
> >> @@ -657,6 +657,13 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
> >>  	return dsa_enqueue_skb(nskb, dev);
> >>  }
> >>  
> >> +static u16 dsa_slave_select_queue(struct net_device *dev, struct sk_buff *skb,
> >> +				  struct net_device *sb_dev)
> >> +{
> >> +	DSA_SKB_CB(skb)->sb_dev = sb_dev;
> >> +	return netdev_pick_tx(dev, skb, sb_dev);
> >> +}
> >> +
> >
> > DSA_SKB_CB is going away:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20210427042203.26258-5-yangbo.lu@nxp.com/
> >
> > Let's either negotiate with Yangbo on keeping it, or make
> > .ndo_select_queue a bypass towards the tagger, where it can use its own
> > SKB_CB structure and be more flexible in general (I think I'm leaning
> > towards the latter).
> 
> Thus far, Yangbo is a tough negotiator, giving me the silent treatment:
> 
> https://lore.kernel.org/netdev/87y2d2noe5.fsf@waldekranz.com/
> 
> :)
> 
> That memset is giving me a hard time. I have just disabled it on my
> branch at the moment. Any ideas on how to get rid of it without breaking
> timestamping?

:)

Is there any guarantee written somewhere that the ownership of skb->cb
belongs to the NIC driver at the time of the ndo_select_queue call?

If there is, then the trivial solution is to just move the memset in
ndo_select_queue.

If there isn't, then we've got bigger issues (such as, for example, the
qdisc layer being able to overwrite your DSA_SKB_CB(skb)->sb_dev).
