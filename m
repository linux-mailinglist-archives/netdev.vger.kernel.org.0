Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84182AAE64
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 00:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgKHX5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 18:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgKHX5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 18:57:06 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C964C0613CF;
        Sun,  8 Nov 2020 15:57:05 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id t9so3501432edq.8;
        Sun, 08 Nov 2020 15:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PGamHc40mKzhU25Zb9aPppdurT1c5ZVz9OGw2I95gP8=;
        b=Hspko1qv5zfA1Es2MVWPFYTvbtzFGM5En5okK739qVJ+3OgS2eUD98hB62XUsUl9W6
         deKwqjNeKJsaHDCyNAtsqH3NbfeGZq7H0F5LFdlaU0cJOZCYLEYe8xxyMO3IDdm0hBLw
         bWtcPmU3GPd0lXdXKlnreIj2rMcVYZ5at/CE5gcWxNTi5ZVekWRpoGjIQI+l4ISm9UXd
         tqSQWQDxc/c97U0IxuY7WVmlOG73lxHL1kdsI74Um1iAz1xfhqdb4mvd+EuDHXr4P6dE
         7stIW5U1eoKLlYox0mbYeTAlYz6Gz7h45wMec9OMXK+MzGfqoRWeXP+/HLbr5TnRrYaX
         sclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PGamHc40mKzhU25Zb9aPppdurT1c5ZVz9OGw2I95gP8=;
        b=seCHg7z3IJbiaFEwmxQ7dZUi/LvFglu91fYXAwPnytznaVy2B5CmZWB/isen5fkr/Y
         dX0sVPsP4vXZy+naOS/l1lHudTsPdIse8EaQabaaNsKArt8hs8B9vKmlpIA67ImGF1qW
         qcA7raretsBv0w/vYdbmgyDgFc/VJMR0gMMM1uuy40sIa0A8wsqwINeM3jsHWwxX3FlJ
         owA0r+VOnnYXRj4IIOlNsxtG7Hb3RbLkwanZCwuuO1nG/w374rFjonLp10iPuJosCjsk
         J3fMaG7fdWTFcDrBEIkgHjScpthEPvIwPsDTbA/dsJbr7Qxm+v4gsIBPems4YQFi/LkK
         t1+g==
X-Gm-Message-State: AOAM531bPyxfjVSnS4XDZAY4K+Ay2x3+tr0K9M0NMgy8O6jm5akvwUlc
        4GfcswglroFKy+CLmbmhfbPxKrtTIKA=
X-Google-Smtp-Source: ABdhPJwO5BzDFLgSKUpwxQd1NhD5tHLkSTpfXkF1RyziA0+JwMhRECfR8DxdX144Gt5zOzo2VHJg6g==
X-Received: by 2002:aa7:d890:: with SMTP id u16mr12805100edq.159.1604879824218;
        Sun, 08 Nov 2020 15:57:04 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id j3sm7339425edh.25.2020.11.08.15.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 15:57:03 -0800 (PST)
Date:   Mon, 9 Nov 2020 01:57:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 1/3] net: dsa: don't use
 switchdev_notifier_fdb_info in dsa_switchdev_event_work
Message-ID: <20201108235702.eoxxekhynkaqnotw@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201108131953.2462644-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 08, 2020 at 03:19:51PM +0200, Vladimir Oltean wrote:
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 59c80052e950..30db8230e30b 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2062,72 +2062,62 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
>  	return NOTIFY_DONE;
>  }
>  
> -struct dsa_switchdev_event_work {
> -	struct work_struct work;
> -	struct switchdev_notifier_fdb_info fdb_info;
> -	struct net_device *dev;
> -	unsigned long event;
> -};
> +static void
> +dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
> +{
> +	struct dsa_switch *ds = switchdev_work->ds;
> +	struct dsa_port *dp = dsa_to_port(ds, switchdev_work->port);
> +	struct switchdev_notifier_fdb_info info;
> +
> +	if (!dsa_is_user_port(ds, dp->index))
> +		return;
> +
> +	info.addr = switchdev_work->addr;
> +	info.vid = switchdev_work->vid;
> +	info.offloaded = true;
> +	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
> +				 dp->slave, &info.info, NULL);
> +}
>  
>  static void dsa_slave_switchdev_event_work(struct work_struct *work)
>  {
>  	struct dsa_switchdev_event_work *switchdev_work =
>  		container_of(work, struct dsa_switchdev_event_work, work);
> -	struct net_device *dev = switchdev_work->dev;
> -	struct switchdev_notifier_fdb_info *fdb_info;
> -	struct dsa_port *dp = dsa_slave_to_port(dev);
> +	struct dsa_switch *ds = switchdev_work->ds;
> +	struct dsa_port *dp;
>  	int err;
>  
> +	dp = dsa_to_port(ds, switchdev_work->port);
> +
>  	rtnl_lock();
>  	switch (switchdev_work->event) {
>  	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> -		fdb_info = &switchdev_work->fdb_info;
> -		if (!fdb_info->added_by_user)
> -			break;
> -
> -		err = dsa_port_fdb_add(dp, fdb_info->addr, fdb_info->vid);
> +		err = dsa_port_fdb_add(dp, switchdev_work->addr,
> +				       switchdev_work->vid);
>  		if (err) {
> -			netdev_dbg(dev, "fdb add failed err=%d\n", err);
> +			dev_dbg(ds->dev, "port %d fdb add failed err=%d\n",
> +				dp->index, err);
>  			break;
>  		}
> -		fdb_info->offloaded = true;
> -		call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev,
> -					 &fdb_info->info, NULL);
> +		dsa_fdb_offload_notify(switchdev_work);
>  		break;
>  
>  	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> -		fdb_info = &switchdev_work->fdb_info;
> -		if (!fdb_info->added_by_user)
> -			break;
> -
> -		err = dsa_port_fdb_del(dp, fdb_info->addr, fdb_info->vid);
> +		err = dsa_port_fdb_del(dp, switchdev_work->addr,
> +				       switchdev_work->vid);
>  		if (err) {
> -			netdev_dbg(dev, "fdb del failed err=%d\n", err);
> -			dev_close(dev);
> +			dev_dbg(ds->dev, "port %d fdb del failed err=%d\n",
> +				dp->index, err);
> +			if (dsa_is_user_port(ds, dp->index))
> +				dev_close(dp->slave);

Not sure that this dev_close() serves any real purpose, it stands in the
way a little. It was introduced "to indicate inconsistent situation".

commit c9eb3e0f870105242a15a5e628ed202cf32afe0d
Author: Arkadi Sharshevsky <arkadis@mellanox.com>
Date:   Sun Aug 6 16:15:42 2017 +0300

    net: dsa: Add support for learning FDB through notification

    Add support for learning FDB through notification. The driver defers
    the hardware update via ordered work queue. In case of a successful
    FDB add a notification is sent back to bridge.

    In case of hw FDB del failure the static FDB will be deleted from
    the bridge, thus, the interface is moved to down state in order to
    indicate inconsistent situation.

I hope it's ok to only close a net device if it exists, I can't think of
anything smarter.

>  		}
>  		break;
>  	}
>  	rtnl_unlock();
>  
> -	kfree(switchdev_work->fdb_info.addr);
>  	kfree(switchdev_work);
> -	dev_put(dev);
> -}
> -
> -static int
> -dsa_slave_switchdev_fdb_work_init(struct dsa_switchdev_event_work *
> -				  switchdev_work,
> -				  const struct switchdev_notifier_fdb_info *
> -				  fdb_info)
> -{
> -	memcpy(&switchdev_work->fdb_info, fdb_info,
> -	       sizeof(switchdev_work->fdb_info));
> -	switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN, GFP_ATOMIC);
> -	if (!switchdev_work->fdb_info.addr)
> -		return -ENOMEM;
> -	ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
> -			fdb_info->addr);
> -	return 0;
> +	if (dsa_is_user_port(ds, dp->index))
> +		dev_put(dp->slave);
>  }

The reference counting is broken here. It doesn't line up with the
dev_hold(dev) done in the last patch, which is on a non-DSA interface.
Anyway I think a net_device refcount is way too much for what we need
here, which is to ensure that DSA doesn't get unbound. I think I'll just
simplify to get_device(ds->dev) and put_device(ds->dev).
