Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA2C33EF76
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 12:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhCQLZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 07:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhCQLYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 07:24:47 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AFBC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:24:36 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id mm21so1948017ejb.12
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hSS/Mtz25dGTR8AwQy8yx0UIedr/KwWAeWamTDyBego=;
        b=pEydWW//JEWwUFyC3NIb/hTGNrfBwnBU2ofaM9mGJRU9qS2UHuTatEIllREXEeDg8B
         ha+JlZu84KEey1JiACbGlK1BDpXuqVxlrDHw128xkPfoaA+dur8+1k5RWZT9u/rRhhq9
         lN74fVEDjaNdnsny5woJ5KHFb81fcKkm06OjERvKyXcI6omQVK0Y62Or8xDtpSVZiAV7
         Ory/9YYS7cvX5jzyFukGZ031KkrCNCNzYtwdS4QsBxIrAY4TDWsfqK5zSlRq+iOQUYES
         PnoZEFmdGMkUdM/2Q4+6QGgYUizY8T0Sk5BRyJ5CeqmqjsE3Oq78B5YVSqDitjDxfah/
         A3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hSS/Mtz25dGTR8AwQy8yx0UIedr/KwWAeWamTDyBego=;
        b=SN6TUYKP18OdzKKDGeK05J6KCsDZ3840Wp7SMp/mRf7+mjdWlL7YiNHnfNAg+U01QK
         Y/xyYQk+Q1YXuOpH+1ZD/BPhaAejcXBpBFpz4bhMrkx/WSx6XwaMjUg1TiO8AAM6PxVk
         9/TGr7C4gdfaaqmltjViA8rUDcV/qZyTqwRMa9UVwQFxS/DJ4dt8LNFfCn1lEda8RUO9
         LJLg0wwN+Yz7dJIXwVmLuX7kJp/sGCz6ZRT4DhtPe9x3W/rGigJ7BJMGAn1BBTkvqXqK
         /nuNsQqfcmf8XKgR4Ib/9EcQP9CaDNmZOmvvkzyNOeWyTP2LyfooywdvbtnVK83et0yH
         hWNQ==
X-Gm-Message-State: AOAM532O4RuOyDrr2WYQT1RFNCgkZnSGxU5BzkB4fZV2x6w8+gkIaDvY
        ddOuw5H8e9mvvk42+GmIZB0=
X-Google-Smtp-Source: ABdhPJzqaiWIef1wg6CXIH96UbMtjDmyq5fhzjqgqlauAtwWqtYzMoRENNamgVTJ15yzzFRSnlveMQ==
X-Received: by 2002:a17:906:3b99:: with SMTP id u25mr34582607ejf.277.1615980275156;
        Wed, 17 Mar 2021 04:24:35 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s11sm12268876edt.27.2021.03.17.04.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 04:24:34 -0700 (PDT)
Date:   Wed, 17 Mar 2021 13:24:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Offload bridge
 broadcast flooding flag
Message-ID: <20210317112433.byk6gmkrlojz3jlk@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-6-tobias@waldekranz.com>
 <20210316093948.zbhouadshgedktcb@skbuf>
 <87pmzynib9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmzynib9.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 12:14:18PM +0100, Tobias Waldekranz wrote:
> Good point. I see two ways forward:
> 
> - My first idea was to cache a vector per switch that would act as the
>   template when creating a new entry. This avoids having the driver
>   layer knowing about stacked netdevs etc. But I think that Andrew is
>   generally opposed to caching?
> 
> - Add a new helper at the dsa layer that takes a dp and returns the
>   netdev that is attached to the bridge, if any:
> 
>   struct net_device *dsa_port_to_bridge_port(struct dsa_port *dp)
> 
> Any preference or other ideas?

I vote for dsa_port_to_bridge_port. We'll need it anyway for my software
bridging series with sandwiched net devices.

> > Speaking of, shouldn't mv88e6xxx_port_vlan_join also be called from
> > mv88e6xxx_port_bridge_join somehow, or are we waiting for the bridge
> > facility to replay VLANs added to the LAG when we emit the offload
> > notification for it?
> 
> I do not think so. VLANs are always added via the .port_vlan_add
> callback, no?

I got things mixed up in my head while thinking about it.
Yes, of course, the bridge pvid is added via .port_vlan_add as soon as
the port joins the bridge.
What I meant to say is that this sequence of events:

ip link add br0 type bridge
ip link add bond0 type bonding
ip link set bond0 master br0
ip link set lan0 master bond0

will cause lan0 to miss all sorts of information about the bridge port
switchdev objects, including the pvid. My patch series for
SWITCHDEV_BRPORT_OFFLOADED catches this case and asks for a replay.

> Potentially the bridge is of the non-filtering variety, so it could be
> that no VLANs are ever added.

That will not happen unless you set ds->configure_vlan_while_not_filtering = false,
which mv88e6xxx no longer does, so we're in the clear.

> Or do you mean (the most confusingly named feature Marvell LinkStreet
> devices) port-based VLANs? Those are setup on a bridge join via
> mv88e6xxx_port_vlan_map and mv88e6xxx_pvt_map.

Nope, I wasn't thinking about PVTs.

> >> +			/* Skip bridged user ports where broadcast
> >> +			 * flooding is disabled.
> >> +			 */
> >> +			continue;
> >> +
> >>  		err = mv88e6xxx_port_add_broadcast(chip, port, vid);
> >>  		if (err)
> >>  			return err;
> >> @@ -1958,6 +1970,51 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
> >>  	return 0;
> >>  }
> >>  
> >> +struct mv88e6xxx_port_broadcast_sync_ctx {
> >> +	int port;
> >> +	bool flood;
> >> +};
> >> +
> >> +static int
> >> +mv88e6xxx_port_broadcast_sync_vlan(struct mv88e6xxx_chip *chip,
> >> +				   const struct mv88e6xxx_vtu_entry *vlan,
> >> +				   void *_ctx)
> >> +{
> >> +	const char broadcast[6] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
> >
> > MAC addresses are usually defined as unsigned char[ETH_ALEN]. You can
> > also use eth_broadcast_addr(broadcast) for initialization.
> 
> I was going for uniformity with mv88e6xxx_port_add_broadcast. But I will
> add a clean-up commit that fixes the existing code first, and then adds
> this definition in the proper way.

Thanks.
