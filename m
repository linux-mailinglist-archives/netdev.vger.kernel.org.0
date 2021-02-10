Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478B73166CA
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhBJMdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbhBJMax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:30:53 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42498C0613D6;
        Wed, 10 Feb 2021 04:29:40 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id sa23so3865940ejb.0;
        Wed, 10 Feb 2021 04:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Hbh4L5GtmNyFLcCwr1R0/cbGfN1e449n2ask6rOo3Q=;
        b=oClcknaww5YdjnuILv3G7H2TKY6LrWE2JQvfLR3Z1zkSYmBXXIhwOHgeqlUJJmkZ5e
         ZeNVX0Xe0tZKgJrYfGkhfAlJxywjrcteL6+nmzkZfdUkmsPbp/SnkSn+VOiUZN5lsZa4
         yRjesRuv363hfZwLNzBolLLrqUQbeDi1B8Uf8IPy121CwK7YISckSmhPgb9q2kc2CVPv
         jyM0pC3qsiYtJCaBiu9fp0J+xrzCKCSkhNnEJlF+hBF6z5Qf7M4AViv64lrEtJlI82Pc
         BB+U2RYfrueJ2sxf1qnd/CiDD/tbgXs9K6QqqSAoy1Cr9NY+cT6zPBmOB4xyxD6RD9H9
         eIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Hbh4L5GtmNyFLcCwr1R0/cbGfN1e449n2ask6rOo3Q=;
        b=GB5YLyccqn0yVgD5lG2hIo3iyMVof6eWkcN2wdLlUXrLRdWUlBkHcTlSfADStcm+Q4
         yQmWSMYVp/OrxgO/MlHSA+kGnBh+iwTg3RL2KLwvF5yZ30iuzBJ/lJeRvvNVaJp1QIVv
         a2KPWa9lu5yD4RfluW2YFa9uqPH8KlmoRXthliDvD72xEGAy1jg1EW8tD6NyWe0ManE9
         +sHJYHfTkPhbITNebJZr/ESZ4cxrnTmWNDkfLwIQTzzfY+CvyPKJ3zfo/qnP5bE0vP31
         HyGXofuxY5KKqIL6jOt7uJvTFqJnS2iluehEBYRg9SW8aarAnnjS7tpFOHahOj2dr3GH
         s+Aw==
X-Gm-Message-State: AOAM530lrqhPbbOdcTLtSGHzjlJuQN8C/rrZtAvn7nEI4TipoUNqwO1l
        Itcn1lCrcCP1UUGaMKh9A4E=
X-Google-Smtp-Source: ABdhPJxJfZ5XUvTNiEHeS8oTGzuZXIK42iRl/juX3fzLEuTrFUeDQZ32NnkY4JCymM2XRbN3d57weA==
X-Received: by 2002:a17:907:ea3:: with SMTP id ho35mr2694287ejc.396.1612960178950;
        Wed, 10 Feb 2021 04:29:38 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id kz4sm1051619ejc.38.2021.02.10.04.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:29:38 -0800 (PST)
Date:   Wed, 10 Feb 2021 14:29:36 +0200
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
Message-ID: <20210210122936.rpvdh7ksjfh2ee6b@skbuf>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
 <20210210104549.ga3lgjafn5x3htwj@skbuf>
 <a58e9615-036c-0431-4ea6-004af4988b27@nvidia.com>
 <20210210110125.rw6fvjtsqmmuglcg@skbuf>
 <90b255e6-efd2-b234-7bfc-4285331e56b1@nvidia.com>
 <20210210120106.g7blqje3wq4j5l6j@skbuf>
 <20210210122105.GA294287@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210122105.GA294287@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 02:21:05PM +0200, Ido Schimmel wrote:
> On Wed, Feb 10, 2021 at 02:01:06PM +0200, Vladimir Oltean wrote:
> > On Wed, Feb 10, 2021 at 01:05:57PM +0200, Nikolay Aleksandrov wrote:
> > > On 10/02/2021 13:01, Vladimir Oltean wrote:
> > > > On Wed, Feb 10, 2021 at 12:52:33PM +0200, Nikolay Aleksandrov wrote:
> > > >> On 10/02/2021 12:45, Vladimir Oltean wrote:
> > > >>> Hi Nikolay,
> > > >>>
> > > >>> On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
> > > >>>> Hi Vladimir,
> > > >>>> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
> > > >>>> that come with this set. I'd really like to avoid those as they're a recipe
> > > >>>> for future problems. The only good way to achieve that currently is to keep
> > > >>>> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
> > > >>>> after the flags have been changed (if they have changed obviously). That would
> > > >>>> make the code read much easier since we'll have all our lock/unlock sequences
> > > >>>> in the same code blocks and won't play games to get sleepable context.
> > > >>>> Please let's think and work in that direction, rather than having:
> > > >>>> +	spin_lock_bh(&p->br->lock);
> > > >>>> +	if (err) {
> > > >>>> +		netdev_err(p->dev, "%s\n", extack._msg);
> > > >>>> +		return err;
> > > >>>>  	}
> > > >>>> +
> > > >>>>
> > > >>>> which immediately looks like a bug even though after some code checking we can
> > > >>>> verify it's ok. WDYT?
> > > >>>>
> > > >>>> I plan to get rid of most of the br->lock since it's been abused for a very long
> > > >>>> time because it's essentially STP lock, but people have started using it for other
> > > >>>> things and I plan to fix that when I get more time.
> > > >>>
> > > >>> This won't make the sysfs codepath any nicer, will it?
> > > >>>
> > > >>
> > > >> Currently we'll have to live with a hack that checks if the flags have changed. I agree
> > > >> it won't be pretty, but we won't have to unlock and lock again in the middle of the
> > > >> called function and we'll have all our locking in the same place, easier to verify and
> > > >> later easier to remove. Once I get rid of most of the br->lock usage we can revisit
> > > >> the drop of PRE_FLAGS if it's a problem. The alternative is to change the flags, then
> > > >> send the switchdev notification outside of the lock and revert the flags if it doesn't
> > > >> go through which doesn't sound much better.
> > > >> I'm open to any other suggestions, but definitely would like to avoid playing locking games.
> > > >> Even if it means casing out flag setting from all other store_ functions for sysfs.
> > > >
> > > > By casing out flag settings you mean something like this?
> > > >
> > > >
> > > > #define BRPORT_ATTR(_name, _mode, _show, _store)		\
> > > > const struct brport_attribute brport_attr_##_name = { 	        \
> > > > 	.attr = {.name = __stringify(_name), 			\
> > > > 		 .mode = _mode },				\
> > > > 	.show	= _show,					\
> > > > 	.store_unlocked	= _store,				\
> > > > };
> > > >
> > > > #define BRPORT_ATTR_FLAG(_name, _mask)				\
> > > > static ssize_t show_##_name(struct net_bridge_port *p, char *buf) \
> > > > {								\
> > > > 	return sprintf(buf, "%d\n", !!(p->flags & _mask));	\
> > > > }								\
> > > > static int store_##_name(struct net_bridge_port *p, unsigned long v) \
> > > > {								\
> > > > 	return store_flag(p, v, _mask);				\
> > > > }								\
> > > > static BRPORT_ATTR(_name, 0644,					\
> > > > 		   show_##_name, store_##_name)
> > > >
> > > > static ssize_t brport_store(struct kobject *kobj,
> > > > 			    struct attribute *attr,
> > > > 			    const char *buf, size_t count)
> > > > {
> > > > 	...
> > > >
> > > > 	} else if (brport_attr->store_unlocked) {
> > > > 		val = simple_strtoul(buf, &endp, 0);
> > > > 		if (endp == buf)
> > > > 			goto out_unlock;
> > > > 		ret = brport_attr->store_unlocked(p, val);
> > > > 	}
> > > >
> > >
> > > Yes, this can work but will need a bit more changes because of br_port_flags_change().
> > > Then the netlink side can be modeled in a similar way.
> > 
> > What I just don't understand is how others can get away with doing
> > sleepable work in atomic context but I can't make the notifier blocking
> > by dropping a spinlock which isn't needed there, because it looks ugly :D
> 
> Can you please point to the bug? I'm not following

For example, mlxsw eventually calls mlxsw_sp_fid_flood_set from the
SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS handling data path, and this
function allocates memory with GFP_KERNEL.

Another example is prestera which eventually calls prestera_fw_send_req
which takes a mutex_lock.

Yet another example are mv88e6xxx and b53 which use MDIO and SPI
from their .port_egress_floods implementation, buses which have
might_sleep() in them.
