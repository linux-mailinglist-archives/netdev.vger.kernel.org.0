Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A518342BC0
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhCTLMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhCTLMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:12:12 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669E2C061225;
        Sat, 20 Mar 2021 03:54:16 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v11so11649487wro.7;
        Sat, 20 Mar 2021 03:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9nS82H5+jhXSu92WibyrS34//24+b11GxmQDHPKTCjI=;
        b=mGx9jrsTq6oJ+x2g7ZOy2YRADC+jIp7GRR5zgx49ZbA0o+DMI1iq2cGzHbK1Vs0ocj
         QMxIP5bBsi6805BinBAjOZdfzcP6Y6lwLiB2JtLyJUW9WErWQ4aCD35Ig9d7XSqxriYm
         AtoFKuY1C9lQCaqiml+T70rk7V61JTttMsgyWBh2682OfUo/olI5+FxhyHK56GXP9dH6
         ExpY13ic0ZCcK/tclCKqoP8mX/W3Tv71RNRIvllIzoJId8yO8cFGpT5sbA37Ca66GF1q
         nmJQ6i4rZMQQCpYPW3WqAKsfrERuybbpkz3fXImLv19sLU+Um6sIdCa6xt9ZzDJWnMjD
         9Jow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9nS82H5+jhXSu92WibyrS34//24+b11GxmQDHPKTCjI=;
        b=OtyNB1on7ToSaHEoaijIj90+8UgyoBd7A/7L4Myf/voz/WCRS5+wMpKKUBFqEFIvVz
         ilnVvkJzOmkdra3M9ltUuCx0IfcUtooLhp62irhFmmR8FQZiMWYoAjVAbUoAudviwDLi
         EFgom7WamaRxGRugQIX1DElQEdqk09XGQ0K3DAMPhd3QlpLlZHrC9P95hUi39lUupla6
         md2+UHtmbGD87RzQ+r9H6awoW1+NzOPbQ1E1oBaAmmSxeYYWYEy+0PYFlkTS2rC4FnLA
         REBt+jnFGY87SBECRDEUVTrsBDNj78U6IK96X6nS0ALqlgTEutN9rPdopHkXjo+6FfIE
         f9tw==
X-Gm-Message-State: AOAM530+Tu34+hKLTnPJqOnE91k2yCP76jKIQjltcm47tCBCtOFxOmZ1
        1sICfijyQgzhforK5sVGv/FvNENsQXs=
X-Google-Smtp-Source: ABdhPJxgoNc1rdmXcbDIzcH1me4wA+xPXdNSh/WLv942H3vDdKPvJQvr9kpfalX54XNvIktaMP6yEA==
X-Received: by 2002:a17:906:1453:: with SMTP id q19mr9190999ejc.76.1616234757120;
        Sat, 20 Mar 2021 03:05:57 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id u14sm5008561ejx.60.2021.03.20.03.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 03:05:56 -0700 (PDT)
Date:   Sat, 20 Mar 2021 12:05:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
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
Subject: Re: [RFC PATCH v2 net-next 03/16] net: dsa: inherit the actual
 bridge port flags at join time
Message-ID: <20210320100555.aq3idungcnpzxeee@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-4-olteanv@gmail.com>
 <2d10377e-88d0-6dea-ff12-469dab1aced0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d10377e-88d0-6dea-ff12-469dab1aced0@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 03:08:46PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > DSA currently assumes that the bridge port starts off with this
> > constellation of bridge port flags:
> > 
> > - learning on
> > - unicast flooding on
> > - multicast flooding on
> > - broadcast flooding on
> > 
> > just by virtue of code copy-pasta from the bridge layer (new_nbp).
> > This was a simple enough strategy thus far, because the 'bridge join'
> > moment always coincided with the 'bridge port creation' moment.
> > 
> > But with sandwiched interfaces, such as:
> > 
> >  br0
> >   |
> > bond0
> >   |
> >  swp0
> > 
> > it may happen that the user has had time to change the bridge port flags
> > of bond0 before enslaving swp0 to it. In that case, swp0 will falsely
> > assume that the bridge port flags are those determined by new_nbp, when
> > in fact this can happen:
> > 
> > ip link add br0 type bridge
> > ip link add bond0 type bond
> > ip link set bond0 master br0
> > ip link set bond0 type bridge_slave learning off
> > ip link set swp0 master br0
> > 
> > Now swp0 has learning enabled, bond0 has learning disabled. Not nice.
> > 
> > Fix this by "dumpster diving" through the actual bridge port flags with
> > br_port_flag_is_set, at bridge join time.
> > 
> > We use this opportunity to split dsa_port_change_brport_flags into two
> > distinct functions called dsa_port_inherit_brport_flags and
> > dsa_port_clear_brport_flags, now that the implementation for the two
> > cases is no longer similar.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  net/dsa/port.c | 123 ++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 82 insertions(+), 41 deletions(-)
> > 
> > diff --git a/net/dsa/port.c b/net/dsa/port.c
> > index fcbe5b1545b8..346c50467810 100644
> > --- a/net/dsa/port.c
> > +++ b/net/dsa/port.c
> > @@ -122,26 +122,82 @@ void dsa_port_disable(struct dsa_port *dp)
> >  	rtnl_unlock();
> >  }
> >  
> > -static void dsa_port_change_brport_flags(struct dsa_port *dp,
> > -					 bool bridge_offload)
> > +static void dsa_port_clear_brport_flags(struct dsa_port *dp,
> > +					struct netlink_ext_ack *extack)
> >  {
> >  	struct switchdev_brport_flags flags;
> > -	int flag;
> >  
> > -	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
> > -	if (bridge_offload)
> > -		flags.val = flags.mask;
> > -	else
> > -		flags.val = flags.mask & ~BR_LEARNING;
> > +	flags.mask = BR_LEARNING;
> > +	flags.val = 0;
> > +	dsa_port_bridge_flags(dp, flags, extack);
> 
> Would not you want to use the same for_each_set_bit() loop that
> dsa_port_change_br_flags() uses, that would be a tad more compact.
> -- 
> Florian

The reworded version has an equal number of lines, but at least it
catches errors now:

static void dsa_port_clear_brport_flags(struct dsa_port *dp,
					struct netlink_ext_ack *extack)
{
	const unsigned long val = BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
	const unsigned long mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
				   BR_BCAST_FLOOD;
	int flag, err;

	for_each_set_bit(flag, &mask, 32) {
		struct switchdev_brport_flags flags = {0};

		flags.mask = BIT(flag);
		flags.val = val & BIT(flag);

		err = dsa_port_bridge_flags(dp, flags, extack);
		if (err && err != -EOPNOTSUPP)
			dev_err(dp->ds->dev,
				"failed to clear bridge port flag %d: %d (%pe)\n",
				flag, err, ERR_PTR(err));
	}
}
