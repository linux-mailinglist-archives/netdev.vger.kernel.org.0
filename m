Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2955731648E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhBJLDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhBJLCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:02:11 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7714C0613D6;
        Wed, 10 Feb 2021 03:01:28 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id w1so3303069ejf.11;
        Wed, 10 Feb 2021 03:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P7dpeQv8L+ojJWKsv0fiRdphbgZkSj83XyvzFv1dYg0=;
        b=NQvrr1NnF2a0L8pXAXZIZvsL/Ubts/f1EJ2TKfE/MYLwTSR7Qv/LcHxZnS7IRSolZa
         cS2fczINHogZ43Y3qGfN2moX96gSK7wgy+fZH5/El+TIseIULsNYNbZbn+xhMBERH8Ye
         icQOixmyEWpBz0rv32Crn0eine21GqEoQTi+ln1Hid9Upm8ssACVg8/ic56pFMmcg70E
         Jh8V5MPS88fmX/F1hF25kj7g8hkQuSA41eBpY1zNV2hNhWQwsS6UHMICByDzBH0Et/g0
         NtOjIsSOTCWBlRZrQhHg58eTmPe3cEgyBx/RujA8au7//sRHzSDdwNo71gZomAeoe97a
         TPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P7dpeQv8L+ojJWKsv0fiRdphbgZkSj83XyvzFv1dYg0=;
        b=GjJmavmDX4NQVfY8M0iwvyM7dhnsE5wlsOilZtyd32xGocXHY4S2UaqzP2iq+6pyOp
         qSHe+/yf3d0IWvIrqZyyrKLNFyMOECQcOMjcLMbtrzwxXml4qzKLZndp8rghTijuw9gc
         jrkV1rYeoiOozXaET2qYVl22hT7t7vzj+gugWT6rfbtm90bCLOUjMYF3OO5SWaU8eDJf
         A/mImsLhQGJXWSx7I8SpLRvOrmtFa3YySQe2WakaMc7TTNNLVETK1PM0ZIMAR5mRtKm+
         S18ppYBfHFS/qsiORhcLx/MXE5uzN8guiDkr0oM7BOFzTiD1spyJ1fgfu1wJqAQBA1wV
         3ACA==
X-Gm-Message-State: AOAM533ACseZVafOqmfWR+oa1JOjJDJch+++L9rZ1JrySN2DU8j2jtv2
        UyhMtod1y9v8X3LL4Oxz2wQ7znR1sUM=
X-Google-Smtp-Source: ABdhPJx9VLiGy+Om+X1nAlGvbd7spo1/LgTCR/DrcqKAW8bcZ1lZtY4ypRO/j0O2SWO4alp4zprMng==
X-Received: by 2002:a17:906:c0d7:: with SMTP id bn23mr2382408ejb.94.1612954887653;
        Wed, 10 Feb 2021 03:01:27 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cf25sm861074ejb.71.2021.02.10.03.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 03:01:26 -0800 (PST)
Date:   Wed, 10 Feb 2021 13:01:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/11] Cleanup in brport flags switchdev
 offload for DSA
Message-ID: <20210210110125.rw6fvjtsqmmuglcg@skbuf>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <a8e9284b-f0a6-0343-175d-8c323371ef8d@nvidia.com>
 <20210210104549.ga3lgjafn5x3htwj@skbuf>
 <a58e9615-036c-0431-4ea6-004af4988b27@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a58e9615-036c-0431-4ea6-004af4988b27@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:52:33PM +0200, Nikolay Aleksandrov wrote:
> On 10/02/2021 12:45, Vladimir Oltean wrote:
> > Hi Nikolay,
> > 
> > On Wed, Feb 10, 2021 at 12:31:43PM +0200, Nikolay Aleksandrov wrote:
> >> Hi Vladimir,
> >> Let's take a step back for a moment and discuss the bridge unlock/lock sequences
> >> that come with this set. I'd really like to avoid those as they're a recipe
> >> for future problems. The only good way to achieve that currently is to keep
> >> the PRE_FLAGS call and do that in unsleepable context but move the FLAGS call
> >> after the flags have been changed (if they have changed obviously). That would
> >> make the code read much easier since we'll have all our lock/unlock sequences
> >> in the same code blocks and won't play games to get sleepable context.
> >> Please let's think and work in that direction, rather than having:
> >> +	spin_lock_bh(&p->br->lock);
> >> +	if (err) {
> >> +		netdev_err(p->dev, "%s\n", extack._msg);
> >> +		return err;
> >>  	}
> >> +
> >>
> >> which immediately looks like a bug even though after some code checking we can
> >> verify it's ok. WDYT?
> >>
> >> I plan to get rid of most of the br->lock since it's been abused for a very long
> >> time because it's essentially STP lock, but people have started using it for other
> >> things and I plan to fix that when I get more time.
> > 
> > This won't make the sysfs codepath any nicer, will it?
> > 
> 
> Currently we'll have to live with a hack that checks if the flags have changed. I agree
> it won't be pretty, but we won't have to unlock and lock again in the middle of the 
> called function and we'll have all our locking in the same place, easier to verify and
> later easier to remove. Once I get rid of most of the br->lock usage we can revisit
> the drop of PRE_FLAGS if it's a problem. The alternative is to change the flags, then
> send the switchdev notification outside of the lock and revert the flags if it doesn't
> go through which doesn't sound much better.
> I'm open to any other suggestions, but definitely would like to avoid playing locking games.
> Even if it means casing out flag setting from all other store_ functions for sysfs.

By casing out flag settings you mean something like this?


#define BRPORT_ATTR(_name, _mode, _show, _store)		\
const struct brport_attribute brport_attr_##_name = { 	        \
	.attr = {.name = __stringify(_name), 			\
		 .mode = _mode },				\
	.show	= _show,					\
	.store_unlocked	= _store,				\
};

#define BRPORT_ATTR_FLAG(_name, _mask)				\
static ssize_t show_##_name(struct net_bridge_port *p, char *buf) \
{								\
	return sprintf(buf, "%d\n", !!(p->flags & _mask));	\
}								\
static int store_##_name(struct net_bridge_port *p, unsigned long v) \
{								\
	return store_flag(p, v, _mask);				\
}								\
static BRPORT_ATTR(_name, 0644,					\
		   show_##_name, store_##_name)

static ssize_t brport_store(struct kobject *kobj,
			    struct attribute *attr,
			    const char *buf, size_t count)
{
	...

	} else if (brport_attr->store_unlocked) {
		val = simple_strtoul(buf, &endp, 0);
		if (endp == buf)
			goto out_unlock;
		ret = brport_attr->store_unlocked(p, val);
	}
