Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1183417F2
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 10:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCSJHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 05:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhCSJGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 05:06:46 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D03CC06174A;
        Fri, 19 Mar 2021 02:06:46 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id bx7so9844333edb.12;
        Fri, 19 Mar 2021 02:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aKP03QicqA5/vlB0vrHGDQQvd6eM3wNhFMg2UexZ+IM=;
        b=mkyfEYqdFf3BFXEDBraMynJCTaRuN+te/N31i/d1Oq+OWGLS8xMdzWhtFhudBLBXUK
         CKBImpt54IUick5uh5bSTa+TruNkJcu3/e+jZYcGtZFcAzq4dAr5KfanFrcvWJRquydq
         eAEX8qPrCd39lXL7BraO0DgI1dI4Xj+CA+sDo28LDRHahg//4U0DP7tbAgcoeRn7iSZG
         LhQi+9rRZPO+zegoRFBcQtQJMkblGqVYK3LX3Yh2gvQdRbUvOBL5ARW8fTBdes3jbM9p
         0NhbBD5OYY1aMmmaruig0I4SpCFdhs0dSaWFRbWMk2z4iD1OWCSlX8CkuUY4K49olAcI
         jy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aKP03QicqA5/vlB0vrHGDQQvd6eM3wNhFMg2UexZ+IM=;
        b=WXbPV3jpz5YMO18Ht1ni4xhEqRzVkEJPYYwzsC7yLSkPmIUgjzjwDF/B5m2s7hK77r
         uzK1SSP0Pn2IV3kvkrCdkSkPp8BKU8UYIqpaQ4nuZLkYzj4EIQWHOmKx8VMyB0kVvVeA
         BMy62FlBonx6PA50UVOvABP/S53L+UAo4YRE54QuRdgu47RtH5BkaOotoKDzui09W64R
         VGIr3v9qY5PkHaEB9iV+n2dy40+Jk6h4iXySLj7hv1OjtbXJa7ny8xAuxc+LARDMMmmp
         jK+aHpp+/75pUKCOuZnzrtaSFXIeFwGeg+BLBWF+q1iDOSOMxuQP+oA4vCFebGAW+ju1
         MCzQ==
X-Gm-Message-State: AOAM5307dzRybSawrMdHBpRllxJrHZXHQOeiDY9A/AcmF88wZiKMNlB+
        w4VhhGYwfiFDj5g2gioO4HM=
X-Google-Smtp-Source: ABdhPJzcB8MzAsCV7GydfK8hEv9OYGuaghn1a18MapW1SybIoiQEcMko7PgCOvp2ZJZJnpkGq66Wug==
X-Received: by 2002:aa7:c346:: with SMTP id j6mr8294433edr.386.1616144804948;
        Fri, 19 Mar 2021 02:06:44 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id p3sm3310517ejd.7.2021.03.19.02.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 02:06:44 -0700 (PDT)
Date:   Fri, 19 Mar 2021 11:06:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 14/16] net: dsa: don't set
 skb->offload_fwd_mark when not offloading the bridge
Message-ID: <20210319090642.bzmtlzc5im6xtbkh@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-15-olteanv@gmail.com>
 <20210319084025.GA2152639@haswell-ubuntu20>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319084025.GA2152639@haswell-ubuntu20>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 04:52:31PM +0800, DENG Qingfang wrote:
> On Fri, Mar 19, 2021 at 01:18:27AM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > DSA has gained the recent ability to deal gracefully with upper
> > interfaces it cannot offload, such as the bridge, bonding or team
> > drivers. When such uppers exist, the ports are still in standalone mode
> > as far as the hardware is concerned.
> > 
> > But when we deliver packets to the software bridge in order for that to
> > do the forwarding, there is an unpleasant surprise in that the bridge
> > will refuse to forward them. This is because we unconditionally set
> > skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
> > were already forwarded in hardware by us.
> > 
> > Since dp->bridge_dev is populated only when there is hardware offload
> > for it, but not in the software fallback case, let's introduce a new
> > helper that can be called from the tagger data path which sets the
> > skb->offload_fwd_mark accordingly to zero when there is no hardware
> > offload for bridging. This lets the bridge forward packets back to other
> > interfaces of our switch, if needed.
> > 
> > Without this change, sending a packet to the CPU for an unoffloaded
> > interface triggers this WARN_ON:
> > 
> > void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
> > 			      struct sk_buff *skb)
> > {
> > 	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
> > 		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
> > }
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> > ---
> >  net/dsa/dsa_priv.h         | 14 ++++++++++++++
> >  net/dsa/tag_brcm.c         |  2 +-
> >  net/dsa/tag_dsa.c          | 15 +++++++++++----
> >  net/dsa/tag_hellcreek.c    |  2 +-
> >  net/dsa/tag_ksz.c          |  2 +-
> >  net/dsa/tag_lan9303.c      |  3 ++-
> >  net/dsa/tag_mtk.c          |  2 +-
> >  net/dsa/tag_ocelot.c       |  2 +-
> >  net/dsa/tag_ocelot_8021q.c |  2 +-
> >  net/dsa/tag_rtl4_a.c       |  2 +-
> >  net/dsa/tag_sja1105.c      |  4 ++--
> >  net/dsa/tag_xrs700x.c      |  2 +-
> >  12 files changed, 37 insertions(+), 15 deletions(-)
> > 
> > diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> > index 92282de54230..b61bef79ce84 100644
> > --- a/net/dsa/dsa_priv.h
> > +++ b/net/dsa/dsa_priv.h
> > @@ -349,6 +349,20 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
> >  	return skb;
> >  }
> >  
> > +/* If the ingress port offloads the bridge, we mark the frame as autonomously
> > + * forwarded by hardware, so the software bridge doesn't forward in twice, back
> > + * to us, because we already did. However, if we're in fallback mode and we do
> > + * software bridging, we are not offloading it, therefore the dp->bridge_dev
> > + * pointer is not populated, and flooding needs to be done by software (we are
> > + * effectively operating in standalone ports mode).
> > + */
> > +static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
> > +{
> > +	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
> > +
> > +	skb->offload_fwd_mark = !!(dp->bridge_dev);
> > +}
> 
> So offload_fwd_mark is set iff the ingress port offloads the bridge.
> Consider this set up on a switch which does NOT support LAG offload:
> 
>         +----- br0 -----+
>         |               |
>       bond0             |
>         |               |         (Linux interfaces)
>     +---+---+       +---+---+
>     |       |       |       |
> +-------+-------+-------+-------+
> | sw0p0 | sw0p1 | sw0p2 | sw0p3 |
> +-------+-------+-------+-------+
>     |       |       |       |
>     +---A---+       B       C     (LAN clients)
> 
> 
> sw0p0 and sw0p1 should be in standalone mode (offload_fwd_mark = 0),
> while sw0p2 and sw0p3 are offloaded (offload_fwd_mark = 1).
> 
> When a frame is sent into sw0p2 or sw0p3, can it be forwarded to sw0p0 or
> sw0p1?

bool nbp_switchdev_allowed_egress(const struct net_bridge_port *p,
				  const struct sk_buff *skb)
{
	return !skb->offload_fwd_mark ||
	       BR_INPUT_SKB_CB(skb)->offload_fwd_mark != p->offload_fwd_mark;
}

where p->offload_fwd_mark is the mark of the egress port, and
BR_INPUT_SKB_CB(skb) is the mark of the ingress port, assigned here:

void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
			      struct sk_buff *skb)
{
	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
}

Basically, sw0p0 and sw0p1 have a switchdev mark of 0, and sw0p2 and
sw0p3 have a non-zero switchdev mark, so nbp_switchdev_allowed_egress
returns true in both directions, regardless of the value of
skb->offload_fwd_mark.

> Setting offload_fwd_mark to 0 could also cause potential packet loss on
> switches that perform learning on the CPU port:
> 
> When client C is talking to client A, frames from C will:
> 1. Enter sw0p3, where the switch will learn C is reachable via sw0p3.
> 2. Be sent to the CPU port and bounced back, where the switch will learn C is
>    reachable via the CPU port, overwriting the previous learned FDB entry.
> 3. Be sent out of either sw0p0 or sw0p1, and reach its destination - A.
> 
> During step 2, if client B sends a frame to C, the frame will be forwarded to
> the CPU, which will think it is already forwarded by the switch, and refuse to
> forward it back, resulting in packet loss.
> 
> Many switch TX tags (mtk, qca, rtl) have a bit to disable source address
> learning on a per-frame basis. We should utilise that.

This is a good point actually, which I thought about, but did not give a
lot of importance to for the moment. Either we go full steam ahead with
assisted learning on the CPU port for everybody, and we selectively
learn the addresses relevant to the bridging funciton only, or we do
what you say, but then it will be a little bit more complicated IMO, and
have hardware dependencies, which isn't as nice.
