Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3796A316735
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhBJMz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhBJMzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:55:47 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA66C0613D6;
        Wed, 10 Feb 2021 04:55:04 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id p20so3989657ejb.6;
        Wed, 10 Feb 2021 04:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yvWNSLBnIED6Uz5npYebJVkI215pDH4z2ka4OyJnM00=;
        b=F7gGWbpA3v0TzCV6woadq/YRQHlD1652IP4xmDUBh8NTC4g1/rIL42m20SKaxYTREB
         XYxPTukjIaqI/23Oi3qLjfKQjsuY5HmvJjfg58cP1TAB+RGY8xoEVsM4pp2zJiecDcG9
         dT6rf5JBas8GK7ia9QC7XESY0WdBmDrSoI6ac86ma5E7Cnzxbp/G32+rAtyoUnHTrraA
         RF1OOKof9AfNfiNXWHWriCFzZkZ3T7SxrN6vXozv0uEuB20SxXynIasbj2Ow14mXGYPO
         UKiFnlkmgPKQRmHoovcl4K+uihUMgjFM0/SU3gX7uMyW1xXAQtkTS3L1DgIwxOXDyqVs
         pqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yvWNSLBnIED6Uz5npYebJVkI215pDH4z2ka4OyJnM00=;
        b=XaMb6WjQ4JSG+l2GlBj/8LNyOs+7WWQbAeK1Ms9CAzyGVi/X8WuCQYQSN4AA8xxxuw
         M7Zn0LwPCY7uq2bOD4VluTQlxSm4TxiyoeLi4PfkaxKjIbTJ/sgP9HhzxmXCspexS50V
         e+RAOsO5jyYS8m4aoxMeQukvAA2O4C/XzARO+IgfvoKTuzIxfr0BrGj2TcAN//SVaCUa
         Mxg4v+Z8gxqavVW66KcfFdK2UA2UjP7g7HfD8uGLTvpF8JhI1BS+Mqf/wqwtlCqdpaLL
         H/8Y1alRQGKV9fSl5RbrEMnMweyj1VfXVC4oPNE4TTS3gOKkhF3snQmFK7CFDOCVxKYf
         YioQ==
X-Gm-Message-State: AOAM532IiaVMJv/HdIFdTWD1WsTxSnh0TZ12BS8ilj7lZwUwCjDY2dLy
        oLuz+qvJSymumkH1RJ9d6vE=
X-Google-Smtp-Source: ABdhPJyLGbV/nNAC6T+GUy+trJ3pEdNdQpdiY69d3RcUOMssp7n3ir0Y2vtrY/UNv4XSVjs2vOqMMA==
X-Received: by 2002:a17:907:76c5:: with SMTP id kf5mr2807348ejc.534.1612961703531;
        Wed, 10 Feb 2021 04:55:03 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id v9sm1092989ejd.92.2021.02.10.04.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:55:02 -0800 (PST)
Date:   Wed, 10 Feb 2021 14:55:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/11] Cleanup in brport flags switchdev
 offload for DSA
Message-ID: <20210210125501.f6lbfv5y5zj4qrmi@skbuf>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
 <20210210104549.ga3lgjafn5x3htwj@skbuf>
 <a58e9615-036c-0431-4ea6-004af4988b27@nvidia.com>
 <20210210110125.rw6fvjtsqmmuglcg@skbuf>
 <90b255e6-efd2-b234-7bfc-4285331e56b1@nvidia.com>
 <20210210120106.g7blqje3wq4j5l6j@skbuf>
 <20210210122105.GA294287@shredder.lan>
 <20210210122936.rpvdh7ksjfh2ee6b@skbuf>
 <20210210123823.GA294900@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210123823.GA294900@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:38:23PM +0200, Ido Schimmel wrote:
> On Wed, Feb 10, 2021 at 02:29:36PM +0200, Vladimir Oltean wrote:
> > On Wed, Feb 10, 2021 at 02:21:05PM +0200, Ido Schimmel wrote:
> > > On Wed, Feb 10, 2021 at 02:01:06PM +0200, Vladimir Oltean wrote:
> > > > On Wed, Feb 10, 2021 at 01:05:57PM +0200, Nikolay Aleksandrov wrote:
> > > > > On 10/02/2021 13:01, Vladimir Oltean wrote:
> > > > > > On Wed, Feb 10, 2021 at 12:52:33PM +0200, Nikolay Aleksandrov wrote:
> > > > > >> On 10/02/2021 12:45, Vladimir Oltean wrote:
> > > > > >>> Hi Nikolay,
> > > > > >>>
> > > > > >>> On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
> > > > > >>>> Hi Vladimir,
> > > > > >>>> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
> > > > > >>>> that come with this set. I'd really like to avoid those as they're a recipe
> > > > > >>>> for future problems. The only good way to achieve that currently is to keep
> > > > > >>>> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
> > > > > >>>> after the flags have been changed (if they have changed obviously). That would
> > > > > >>>> make the code read much easier since we'll have all our lock/unlock sequences
> > > > > >>>> in the same code blocks and won't play games to get sleepable context.
> > > > > >>>> Please let's think and work in that direction, rather than having:
> > > > > >>>> +	spin_lock_bh(&p->br->lock);
> > > > > >>>> +	if (err) {
> > > > > >>>> +		netdev_err(p->dev, "%s\n", extack._msg);
> > > > > >>>> +		return err;
> > > > > >>>>  	}
> > > > > >>>> +
> > > > > >>>>
> > > > > >>>> which immediately looks like a bug even though after some code checking we can
> > > > > >>>> verify it's ok. WDYT?
> > > > > >>>>
> > > > > >>>> I plan to get rid of most of the br->lock since it's been abused for a very long
> > > > > >>>> time because it's essentially STP lock, but people have started using it for other
> > > > > >>>> things and I plan to fix that when I get more time.
> > > > > >>>
> > > > > >>> This won't make the sysfs codepath any nicer, will it?
> > > > > >>>
> > > > > >>
> > > > > >> Currently we'll have to live with a hack that checks if the flags have changed. I agree
> > > > > >> it won't be pretty, but we won't have to unlock and lock again in the middle of the
> > > > > >> called function and we'll have all our locking in the same place, easier to verify and
> > > > > >> later easier to remove. Once I get rid of most of the br->lock usage we can revisit
> > > > > >> the drop of PRE_FLAGS if it's a problem. The alternative is to change the flags, then
> > > > > >> send the switchdev notification outside of the lock and revert the flags if it doesn't
> > > > > >> go through which doesn't sound much better.
> > > > > >> I'm open to any other suggestions, but definitely would like to avoid playing locking games.
> > > > > >> Even if it means casing out flag setting from all other store_ functions for sysfs.
> > > > > >
> > > > > > By casing out flag settings you mean something like this?
> > > > > >
> > > > > >
> > > > > > #define BRPORT_ATTR(_name, _mode, _show, _store)		\
> > > > > > const struct brport_attribute brport_attr_##_name = { 	        \
> > > > > > 	.attr = {.name = __stringify(_name), 			\
> > > > > > 		 .mode = _mode },				\
> > > > > > 	.show	= _show,					\
> > > > > > 	.store_unlocked	= _store,				\
> > > > > > };
> > > > > >
> > > > > > #define BRPORT_ATTR_FLAG(_name, _mask)				\
> > > > > > static ssize_t show_##_name(struct net_bridge_port *p, char *buf) \
> > > > > > {								\
> > > > > > 	return sprintf(buf, "%d\n", !!(p->flags & _mask));	\
> > > > > > }								\
> > > > > > static int store_##_name(struct net_bridge_port *p, unsigned long v) \
> > > > > > {								\
> > > > > > 	return store_flag(p, v, _mask);				\
> > > > > > }								\
> > > > > > static BRPORT_ATTR(_name, 0644,					\
> > > > > > 		   show_##_name, store_##_name)
> > > > > >
> > > > > > static ssize_t brport_store(struct kobject *kobj,
> > > > > > 			    struct attribute *attr,
> > > > > > 			    const char *buf, size_t count)
> > > > > > {
> > > > > > 	...
> > > > > >
> > > > > > 	} else if (brport_attr->store_unlocked) {
> > > > > > 		val = simple_strtoul(buf, &endp, 0);
> > > > > > 		if (endp == buf)
> > > > > > 			goto out_unlock;
> > > > > > 		ret = brport_attr->store_unlocked(p, val);
> > > > > > 	}
> > > > > >
> > > > >
> > > > > Yes, this can work but will need a bit more changes because of br_port_flags_change().
> > > > > Then the netlink side can be modeled in a similar way.
> > > >
> > > > What I just don't understand is how others can get away with doing
> > > > sleepable work in atomic context but I can't make the notifier blocking
> > > > by dropping a spinlock which isn't needed there, because it looks ugly :D
> > >
> > > Can you please point to the bug? I'm not following
> >
> > For example, mlxsw eventually calls mlxsw_sp_fid_flood_set from the
> > SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS handling data path, and this
> > function allocates memory with GFP_KERNEL.
> >
> > Another example is prestera which eventually calls prestera_fw_send_req
> > which takes a mutex_lock.
> >
> > Yet another example are mv88e6xxx and b53 which use MDIO and SPI
> > from their .port_egress_floods implementation, buses which have
> > might_sleep() in them.
>
> Right, but see the code:
>
> ```
> 	attr.id = SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS;
> 	attr.flags = SWITCHDEV_F_DEFER;
> 	attr.u.brport_flags = flags;
>
> 	err = switchdev_port_attr_set(p->dev, &attr);
> ```
>
> And check how SWITCHDEV_F_DEFER is used.
>
> We can squash SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and
> SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS into one blocking notification
> by reducing the scope of the bridge lock like Nik suggested. Currently
> it's just blindly taken around br_setport().

Okay, so the deferred attr_set propagates just a possible ENOMEM from
the deferred work enqueue, not the actual failure if that occurred.

I can leave alone the piece that sends two notifications for now, but I
would still need to deliver the full struct switchdev_brport_flags with
both the flags and the mask to both the PRE_BRIDGE_FLAGS and the
BRIDGE_FLAGS, because I need to deliver an extack from the sja1105 driver
that BR_FLOOD should always have the same value as BR_MCAST_FLOOD.
