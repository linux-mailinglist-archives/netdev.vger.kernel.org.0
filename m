Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92899344010
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhCVLnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbhCVLn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:43:29 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63187C061574;
        Mon, 22 Mar 2021 04:43:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h13so18901517eds.5;
        Mon, 22 Mar 2021 04:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K+wzoALHYH2CFT6jvBrRv/o6c+xMFYhKuXgkU3L4+xE=;
        b=OBEawwG+XiukXy7wiDxka51smz15Tq/dfez2r/m1ruIEU0kVXP7RF5s1PJV6CiTSRk
         Ma0IYdBs6Tq93H4rMwzcxYNIHfUe65NoxjRSrdvgVZMlmO/ZV1l7naUJrSTi9dPmSCUa
         BjnQIov4mAfhtDQGgaRPujNEejU+w4IfNevYMyFCvKEJxwUT+/oTHTEI/pFP60pOEdbc
         PJa9Lj86EDUzJeW7+Hj8ceSV1XlEtlJEt+U3S3jd9aBX5eANC7yRCZ2p2C+yJdhAR2SG
         ++oD7DmSMksVZ1auk0O9/vnfUXOcFHKwFhgTUA2jr8nzJdrvQY+8aUpTls4BZuAQhc2G
         Mkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K+wzoALHYH2CFT6jvBrRv/o6c+xMFYhKuXgkU3L4+xE=;
        b=uLeXxL4poOqtjLcZXDalQJqdBbZFJAskAjeYNm0tPYgvkR3/sT3k+JJk7gQcv70Ct9
         thRtNbPAnaB3OqcGNFWJ8c3+xxPl4ADBivYTzqsQZZ7elh6QPgNfwlqcYdlmX2KaiVKY
         VIi8SIthdM57QAMrA8FHt1ONy0raTAFZw0m+p43cWczMHcnHmSqmQ8m+frS0FFtZsL/f
         RuCWLB7Jy6UEPc6ghJptv2lRavSM7AOwm1Mt4tZ/nneJgLpbkQLFxWPEUAdVE3H8hLBp
         IevJjKqKK775K9yY8cY22mwFtIB0SAy0WgKTFDZFb/AZ03D6XuK9tboiXcemiCuK0ypj
         CXag==
X-Gm-Message-State: AOAM531+KkQ732MQWiXaAt7chCBwNFA6IbSiPL0GgpLiwPTdVDOK7yg5
        wgZQ6UBDrK2HQTvTbnqBQ5o=
X-Google-Smtp-Source: ABdhPJyDxX98p3hRkjCrSQZv6TNHtVpCJ9VRFkv7po7sYdoYLgEIhgld3q+98Ow8tTTzfYIGa6k0gA==
X-Received: by 2002:a05:6402:382:: with SMTP id o2mr25737957edv.238.1616413408037;
        Mon, 22 Mar 2021 04:43:28 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id u13sm9552307ejy.31.2021.03.22.04.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 04:43:27 -0700 (PDT)
Date:   Mon, 22 Mar 2021 13:43:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [RFC PATCH v2 net-next 06/16] net: dsa: sync multicast router
 state when joining the bridge
Message-ID: <20210322114326.svsj5qnyaqrzj6uh@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-7-olteanv@gmail.com>
 <8735wno2sy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735wno2sy.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 12:17:33PM +0100, Tobias Waldekranz wrote:
> On Fri, Mar 19, 2021 at 01:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > Make sure that the multicast router setting of the bridge is picked up
> > correctly by DSA when joining, regardless of whether there are
> > sandwiched interfaces or not. The SWITCHDEV_ATTR_ID_BRIDGE_MROUTER port
> > attribute is only emitted from br_mc_router_state_change.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/dsa/port.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index ac1afe182c3b..8380509ee47c 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -189,6 +189,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
> >  	if (err && err != -EOPNOTSUPP)
> >  		return err;
> >  
> > +	err = dsa_port_mrouter(dp->cpu_dp, br_multicast_router(br), extack);
> > +	if (err && err != -EOPNOTSUPP)
> > +		return err;
> > +
> >  	return 0;
> >  }
> >  
> > @@ -212,6 +216,12 @@ static void dsa_port_switchdev_unsync(struct dsa_port *dp)
> >  	dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
> >  
> >  	/* VLAN filtering is handled by dsa_switch_bridge_leave */
> > +
> > +	/* Some drivers treat the notification for having a local multicast
> > +	 * router by allowing multicast to be flooded to the CPU, so we should
> > +	 * allow this in standalone mode too.
> > +	 */
> > +	dsa_port_mrouter(dp->cpu_dp, true, NULL);
> 
> Is this really for the DSA layer to decide? The driver has already been
> notified that at least one port is now in standalone mode. So if that
> particular driver then requires all multicast to be flooded towards the
> CPU, it can make that decision on its own.
> 
> E.g. say that you implement standalone mode using a matchall TCAM rule
> that maps all frames coming in on a particular port to the CPU. You
> could still leave flooding of unknown multicast off in that case. Now
> that driver has to figure out if the notification about a multicast
> router on the CPU is a real router, or the DSA layer telling it
> something that it can safely ignore.
> 
> Today I think that most (all?) DSA drivers treats mrouter in the same
> way as the multicast flooding bridge flag. But AFAIK, the semantic
> meaning of the setting is "flood IP multicast to this port because there
> is a router behind it somewhere". This means unknown _IP_ multicast, but
> also all known (IGMP/MLD) groups. As most smaller devices cannot
> separate IP multicast from the non-IP variety, we flood everything. But
> we should also make sure that the port in question receives all known
> groups for the _bridge_ in question. Because this is really a bridge
> setting, though that information is not carried over to the driver
> today. So reusing it in this way feels like it could be problematic down
> the road.

I agree with your objections in principle, but somehow I would like to
make progress with this patch series which is not really about how we
deal with IP multicast flooding to the CPU port in standalone ports
mode, so I would like to not get bogged down too much into this for now.
Don't forget that up until recent commit a8b659e7ff75 ("net: dsa: act as
passthrough for bridge port flags"), DSA drivers had no real idea
whether multicast flooding was meant for IP or not. And in standalone
mode, the way things work now is that the CPU port should see all
traffic, so it isn't wrong to do what this patch does.
Unless you see a breaking change introduced by this patch, we can
revisit this discussion for the "RX filtering on DSA" series, where it
is more relevant.
