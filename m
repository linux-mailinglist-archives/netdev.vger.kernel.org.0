Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418674D1E55
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348577AbiCHRST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbiCHRSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:18:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6333852E72;
        Tue,  8 Mar 2022 09:17:21 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bi12so27666599ejb.3;
        Tue, 08 Mar 2022 09:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QN4f7aRfMRy6jjFzTVyfXHZqX7kSLQSGCV4hl7xnDdo=;
        b=TT73bdraUoPqY7Hv+qcsEXvwe+EPtjpOa3Yf+DT5eiC4TWS06FVOn80zFlJHx+XfjO
         HguK1F3joiuVeYAOw5LFJLlteZCqzS8icf1jQbPWBtJEmz4JOOo48IbWPYWPlpu0RvdM
         ZBAF6fPOAU8yO37GY9qmsU6je89NUxuMHbXqiL8EY+ZCiGMrdqWoO6UHehNCVGOdtvkJ
         yllpIFosLxW9z+uLFDPpMA+VVkp5PqdrC1EEETGnHsXoQ0VtaMH6F9t9tuEOtiJJn4m0
         titviv4dUsAN5hh2TmPeXxxAmKgz9RtbBLEtnbwRo6fchg+nsh0XZOUkPIM96bPNBwI/
         Dv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QN4f7aRfMRy6jjFzTVyfXHZqX7kSLQSGCV4hl7xnDdo=;
        b=b4RcROCN6lG6Asq1+QngFRcBrFq0yRNCzrMN6LYqDdzW5fnScaCzfmEBunotWhfUZn
         ad+OkDnoIbVpu8h0o1SwinLJsZjGRyfUe65pdkn0jlww1NkA3T42adtrFQH15KfT9kbo
         ypvdxgQQU4J/J5yHrNEtrVbp0rYt4SyarHwrTmk3xmc+Ijqcz127sf/4ZLHa91I7okVN
         ooalAlOC9U4EUnJyGPpS5KkmHKx9EIqfGigZAhxjz5k51WzY3NHyaiiUI/3UPX/kfmDS
         SBSLuJh1H3NhT7f+EmENQtDqAvAyOG7BReiqr88kshJgapNlehCSBWvMbWd/Owq0dgrV
         N0CA==
X-Gm-Message-State: AOAM532PQy3ewSM/zc8HqMvbwdiD06FzvFtHMI5gD5L1GAVfvZGB5HkD
        mgCUe+EFkA9yTHzueXsJ004=
X-Google-Smtp-Source: ABdhPJxKq7B8zhwV1jSOt8K6TnNnJ9hfc2/PfFK1D2149KXccg1yauJo46R0dZqYgRXN+Czl48JNLQ==
X-Received: by 2002:a17:906:d29b:b0:6da:9e4d:bb7c with SMTP id ay27-20020a170906d29b00b006da9e4dbb7cmr14859587ejb.155.1646759839575;
        Tue, 08 Mar 2022 09:17:19 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id z16-20020a05640240d000b004165f6ce23bsm2312585edb.24.2022.03.08.09.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:17:19 -0800 (PST)
Date:   Tue, 8 Mar 2022 19:17:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 04/10] net: bridge: mst: Notify switchdev
 drivers of VLAN MSTI migrations
Message-ID: <20220308171717.s2hqp6raoe5gcgtl@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-5-tobias@waldekranz.com>
 <20220303205921.sxb52jzw4jcdj6m7@skbuf>
 <87y21kna9r.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y21kna9r.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 09:01:04AM +0100, Tobias Waldekranz wrote:
> On Thu, Mar 03, 2022 at 22:59, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Mar 01, 2022 at 11:03:15AM +0100, Tobias Waldekranz wrote:
> >> Whenever a VLAN moves to a new MSTI, send a switchdev notification so
> >> that switchdevs can...
> >> 
> >> ...either refuse the migration if the hardware does not support
> >> offloading of MST...
> >> 
> >> ..or track a bridge's VID to MSTI mapping when offloading is
> >> supported.
> >> 
> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> ---
> >>  include/net/switchdev.h   | 10 +++++++
> >>  net/bridge/br_mst.c       | 15 +++++++++++
> >>  net/bridge/br_switchdev.c | 57 +++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 82 insertions(+)
> >> 
> >> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> >> index 3e424d40fae3..39e57aa5005a 100644
> >> --- a/include/net/switchdev.h
> >> +++ b/include/net/switchdev.h
> >> @@ -28,6 +28,7 @@ enum switchdev_attr_id {
> >>  	SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED,
> >>  	SWITCHDEV_ATTR_ID_BRIDGE_MROUTER,
> >>  	SWITCHDEV_ATTR_ID_MRP_PORT_ROLE,
> >> +	SWITCHDEV_ATTR_ID_VLAN_MSTI,
> >>  };
> >>  
> >>  struct switchdev_brport_flags {
> >> @@ -35,6 +36,14 @@ struct switchdev_brport_flags {
> >>  	unsigned long mask;
> >>  };
> >>  
> >> +struct switchdev_vlan_attr {
> >> +	u16 vid;
> >> +
> >> +	union {
> >> +		u16 msti;
> >> +	};
> >
> > Do you see other VLAN attributes that would be added in the future, such
> > as to justify making this a single-element union from the get-go?
> 
> I could imagine being able to control things like multicast snooping on
> a per-VLAN basis. Being able to act as a multicast router in one VLAN
> but not another.
> 
> > Anyway if that is the case, we're lacking an id for the attribute type,
> > so we'd end up needing to change drivers when a second union element
> > appears. Otherwise they'd all expect an u16 msti.
> 
> My idea was that `enum switchdev_attr_id` would hold all of that
> information. In this example SWITCHDEV_ATTR_ID_VLAN_MSTI, denotes both
> that `vlan_attr` is the valid member of `u` and that `msti` is the valid
> member of `vlan_attr`. If we add SWITCHDEV_ATTR_ID_VLAN_SNOOPING, that
> would point to both `vlan_attr` and a new `bool snooping` in the union.
> 
> Do you think we should just have a SWITCHDEV_ATTR_ID_VLAN_ATTR for all
> per-VLAN attributes and then have a separate union?

It's the first nested union that I see, and a bit confusing.

I think it would be better if we had a

struct switchdev_vlan_attr_msti {
	u16 vid;
	u16 msti;
};

and different structures for other, future VLAN attributes. Basically
keep a 1:1 mapping between an attribute id and a union.

> >> +};
> >> +
> >>  struct switchdev_attr {
> >>  	struct net_device *orig_dev;
> >>  	enum switchdev_attr_id id;
> >> @@ -50,6 +59,7 @@ struct switchdev_attr {
> >>  		u16 vlan_protocol;			/* BRIDGE_VLAN_PROTOCOL */
> >>  		bool mc_disabled;			/* MC_DISABLED */
> >>  		u8 mrp_port_role;			/* MRP_PORT_ROLE */
> >> +		struct switchdev_vlan_attr vlan_attr;	/* VLAN_* */
> >>  	} u;
> >>  };
> >>  
> >> diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
> >> index 8dea8e7257fd..aba603675165 100644
> >> --- a/net/bridge/br_mst.c
> >> +++ b/net/bridge/br_mst.c
> >> @@ -7,6 +7,7 @@
> >>   */
> >>  
> >>  #include <linux/kernel.h>
> >> +#include <net/switchdev.h>
> >>  
> >>  #include "br_private.h"
> >>  
> >> @@ -65,9 +66,23 @@ static void br_mst_vlan_sync_state(struct net_bridge_vlan *pv, u16 msti)
> >>  
> >>  int br_mst_vlan_set_msti(struct net_bridge_vlan *mv, u16 msti)
> >>  {
> >> +	struct switchdev_attr attr = {
> >> +		.id = SWITCHDEV_ATTR_ID_VLAN_MSTI,
> >> +		.flags = SWITCHDEV_F_DEFER,
> >
> > Is the bridge spinlock held (atomic context), or otherwise why is
> > SWITCHDEV_F_DEFER needed here?
> 
> Nope, just copypasta. In fact, it shouldn't be needed when setting the
> state either, as you can only change the state via a netlink message. I
> will remove it.
> 
> >> +		.orig_dev = mv->br->dev,
> >> +		.u.vlan_attr = {
> >> +			.vid = mv->vid,
> >> +			.msti = msti,
> >> +		},
> >> +	};
> >>  	struct net_bridge_vlan_group *vg;
> >>  	struct net_bridge_vlan *pv;
> >>  	struct net_bridge_port *p;
> >> +	int err;
> >> +
> >> +	err = switchdev_port_attr_set(mv->br->dev, &attr, NULL);
> >
> > Treating a "VLAN attribute" as a "port attribute of the bridge" is
> > pushing the taxonomy just a little, but I don't have a better suggestion.
> 
> Isn't there prior art here? I thought things like VLAN filtering already
> worked like this?

Hmm, I can think of VLAN filtering as being an attribute of the bridge
device, but 'which MSTI does VLAN X belong to' is an attribute of the
VLAN (in itself a switchdev object, i.e. something countable).

If the prior art would apply as straightforward as you say, then we'd be
replaying the VLAN MSTIs together with the other port attributes - in
"pull" mode, in dsa_port_switchdev_sync_attrs(), rather than in "push"
mode with the rest of the objects - in nbp_switchdev_sync_objs().
But we're not doing that.

To prove that there is a difference between VLAN filtering as a port
property of the bridge device, and VLAN MSTIs (or other per-VLAN global
bridge options), consider this.
You create a bridge, add 10 VLANs on br0, enable VLAN filtering, then
delete the 10 VLANs and re-create them. The bridge is still VLAN
filtering.
So VLAN filtering is a property of the bridge.

Next you create a bridge, add 10 VLANs on br0, run your new command:
'bridge vlan global set dev br0 vid <VID> msti <MSTI>'
then delete the 10 VLANs and create them back.
Their MSTI is 0, not what was set via the bridge vlan global options...
Because the MSTI is a property of the VLANs, not of the bridge.

A real port attribute wouldn't behave like that.

At least this is what I understand from your patch set, I haven't run it;
sorry if I'm mistaken about something, but I can't find a clearer way to
express what I find strange.

Anyway, I'll stop uselessly commenting here - I can understand the
practical reasons why you wouldn't want to bother expanding the taxonomy
to describe this for what it really is - an "object attribute" of sorts -
because a port attribute for the bridge device has the call path you
need already laid out, including replication towards all bridge ports.
