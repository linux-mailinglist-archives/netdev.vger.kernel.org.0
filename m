Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3A05A4542
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 18:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfHaQUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 12:20:02 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42216 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfHaQUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 12:20:01 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so11083511qtp.9
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 09:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=5zFtiCVoYMLZgbsa01BAUY/Q98D44wbb6rK19R1+JG4=;
        b=NQUi/G4l+xTcneVGsKLDzc+Rs+g5bkn9qi2t9YPwL3p22KIIXYF+Fp5Ul4z1WXB5Ve
         in25M4l3O5kOJ76exbig/iadMRYSOggHzTv1ZzBCopsBc7CbrcDeMAP5YMH8yo2rNNnq
         rBk/p2pqJ3/2OC1XfN5nAOR7wvJTjpK+OMxfU8IKheNS6HsT8SKqDGNLNV3nI2/JjbJZ
         lAb0+sKYuZ5Bp6pXBendVLuWbaNS79CWgQUimtXYnfHgNJlhxWWWykrlvnGHRRRSNGAN
         x3JVmpRj1ZUoI59khtb/ThWkhYeD+AH3AEaj1hEnbypQS2XStWjIOPKdYH9nhhlWfobN
         rN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=5zFtiCVoYMLZgbsa01BAUY/Q98D44wbb6rK19R1+JG4=;
        b=W1AlOkvU4qss+/XdEo2flogxswC93MzlfdQU5c9O+6yAOjR5gUKFVt9SEmOkv53lig
         urwlrIonx1P9EFzo6O/ezoi5utBL+Sdb+iqqM6gS2PmgXdImstym9YhKz7lVDdxLb0sc
         wLg18OhPu8qajn3JEAL8moODWB/ZfpxZ2xH6G2glGshHNtzSdmCgXf2c6L0A6ig+b3Xi
         pMY0Xc9/QJrqVxeDRmR6ml98b5+wDpq9pEBvUPexJ5YlUppBYaXPuywG1C3xL5tZdun+
         J2ZkEzwKnh6AYX8JcVEFAn7Sy457kqJxaZ02cJhzzTvf5K+TzYzfI9Vi3ZGc7JhollHr
         MQ2Q==
X-Gm-Message-State: APjAAAVs+93rO89R2rmFiL+Kc4a7D0XbRmxk6xy3oo3aa7XW4VRkBCL/
        /+bIyHvGmlXCWM0KIAjH4H4BJCVX
X-Google-Smtp-Source: APXvYqzdp2L70VVgK8qHhWG0cf1FGSgX97qjrn1jZQq3kHn7ZqETLnGtvO7lRNqjGn0PFerxOcK6ng==
X-Received: by 2002:ac8:48c3:: with SMTP id l3mr21075847qtr.281.1567268400217;
        Sat, 31 Aug 2019 09:20:00 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b5sm4083939qkk.78.2019.08.31.09.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 09:19:59 -0700 (PDT)
Date:   Sat, 31 Aug 2019 12:19:58 -0400
Message-ID: <20190831121958.GC12031@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH] net: dsa: Fix off-by-one number of calls to
 devlink_port_unregister
In-Reply-To: <20190831124619.460-1-olteanv@gmail.com>
References: <20190831124619.460-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, 31 Aug 2019 15:46:19 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> When a function such as dsa_slave_create fails, currently the following
> stack trace can be seen:
> 
> [    2.038342] sja1105 spi0.1: Probed switch chip: SJA1105T
> [    2.054556] sja1105 spi0.1: Reset switch and programmed static config
> [    2.063837] sja1105 spi0.1: Enabled switch tagging
> [    2.068706] fsl-gianfar soc:ethernet@2d90000 eth2: error -19 setting up slave phy
> [    2.076371] ------------[ cut here ]------------
> [    2.080973] WARNING: CPU: 1 PID: 21 at net/core/devlink.c:6184 devlink_free+0x1b4/0x1c0
> [    2.088954] Modules linked in:
> [    2.092005] CPU: 1 PID: 21 Comm: kworker/1:1 Not tainted 5.3.0-rc6-01360-g41b52e38d2b6-dirty #1746
> [    2.100912] Hardware name: Freescale LS1021A
> [    2.105162] Workqueue: events deferred_probe_work_func
> [    2.110287] [<c03133a4>] (unwind_backtrace) from [<c030d8cc>] (show_stack+0x10/0x14)
> [    2.117992] [<c030d8cc>] (show_stack) from [<c10b08d8>] (dump_stack+0xb4/0xc8)
> [    2.125180] [<c10b08d8>] (dump_stack) from [<c0349d04>] (__warn+0xe0/0xf8)
> [    2.132018] [<c0349d04>] (__warn) from [<c0349e34>] (warn_slowpath_null+0x40/0x48)
> [    2.139549] [<c0349e34>] (warn_slowpath_null) from [<c0f19d74>] (devlink_free+0x1b4/0x1c0)
> [    2.147772] [<c0f19d74>] (devlink_free) from [<c1064fc0>] (dsa_switch_teardown+0x60/0x6c)
> [    2.155907] [<c1064fc0>] (dsa_switch_teardown) from [<c1065950>] (dsa_register_switch+0x8e4/0xaa8)
> [    2.164821] [<c1065950>] (dsa_register_switch) from [<c0ba7fe4>] (sja1105_probe+0x21c/0x2ec)
> [    2.173216] [<c0ba7fe4>] (sja1105_probe) from [<c0b35948>] (spi_drv_probe+0x80/0xa4)
> [    2.180920] [<c0b35948>] (spi_drv_probe) from [<c0a4c1cc>] (really_probe+0x108/0x400)
> [    2.188711] [<c0a4c1cc>] (really_probe) from [<c0a4c694>] (driver_probe_device+0x78/0x1bc)
> [    2.196933] [<c0a4c694>] (driver_probe_device) from [<c0a4a3dc>] (bus_for_each_drv+0x58/0xb8)
> [    2.205414] [<c0a4a3dc>] (bus_for_each_drv) from [<c0a4c024>] (__device_attach+0xd0/0x168)
> [    2.213637] [<c0a4c024>] (__device_attach) from [<c0a4b1d0>] (bus_probe_device+0x84/0x8c)
> [    2.221772] [<c0a4b1d0>] (bus_probe_device) from [<c0a4b72c>] (deferred_probe_work_func+0x84/0xc4)
> [    2.230686] [<c0a4b72c>] (deferred_probe_work_func) from [<c03650a4>] (process_one_work+0x218/0x510)
> [    2.239772] [<c03650a4>] (process_one_work) from [<c03660d8>] (worker_thread+0x2a8/0x5c0)
> [    2.247908] [<c03660d8>] (worker_thread) from [<c036b348>] (kthread+0x148/0x150)
> [    2.255265] [<c036b348>] (kthread) from [<c03010e8>] (ret_from_fork+0x14/0x2c)
> [    2.262444] Exception stack(0xea965fb0 to 0xea965ff8)
> [    2.267466] 5fa0:                                     00000000 00000000 00000000 00000000
> [    2.275598] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    2.283729] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [    2.290333] ---[ end trace ca5d506728a0581a ]---
> 
> devlink_free is complaining right here:
> 
> 	WARN_ON(!list_empty(&devlink->port_list));
> 
> This happens because devlink_port_unregister is no longer done right
> away in dsa_port_setup when a DSA_PORT_TYPE_USER has failed.
> Vivien said about this change that:
> 
>     Also no need to call devlink_port_unregister from within dsa_port_setup
>     as this step is inconditionally handled by dsa_port_teardown on error.
> 
> which is not really true. The devlink_port_unregister function _is_
> being called unconditionally from within dsa_port_setup, but not for

Not from within dsa_port_setup, but from its caller dsa_tree_setup_switches.

> this port that just failed, just for the previous ones which were set
> up.
> 
> ports_teardown:
> 	for (i = 0; i < port; i++)
> 		dsa_port_teardown(&ds->ports[i]);
> 
> Initially I was tempted to fix this by extending the "for" loop to also
> cover the port that failed during setup. But this could have potentially
> unforeseen consequences unrelated to devlink_port or even other types of
> ports than user ports, which I can't really test for. For example, if
> for some reason devlink_port_register itself would fail, then
> unconditionally unregistering it in dsa_port_teardown would not be a
> smart idea. The list might go on.
> 
> So just make dsa_port_setup undo the setup it had done upon failure, and
> let the for loop undo the work of setting up the previous ports, which
> are guaranteed to be brought up to a consistent state.
> 
> Fixes: 955222ca5281 ("net: dsa: use a single switch statement for port setup")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/dsa/dsa2.c | 39 +++++++++++++++++++++++++++++----------
>  1 file changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index f8445fa73448..b501c90aabe4 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -259,8 +259,11 @@ static int dsa_port_setup(struct dsa_port *dp)
>  	const unsigned char *id = (const unsigned char *)&dst->index;
>  	const unsigned char len = sizeof(dst->index);
>  	struct devlink_port *dlp = &dp->devlink_port;
> +	bool dsa_port_link_registered = false;
> +	bool devlink_port_registered = false;
>  	struct devlink *dl = ds->devlink;
> -	int err;
> +	bool dsa_port_enabled = false;
> +	int err = 0;
>  
>  	switch (dp->type) {
>  	case DSA_PORT_TYPE_UNUSED:
> @@ -272,15 +275,19 @@ static int dsa_port_setup(struct dsa_port *dp)
>  				       dp->index, false, 0, id, len);
>  		err = devlink_port_register(dl, dlp, dp->index);
>  		if (err)
> -			return err;
> +			break;
> +		devlink_port_registered = true;
>  
>  		err = dsa_port_link_register_of(dp);
>  		if (err)
> -			return err;
> +			break;
> +		dsa_port_link_registered = true;
>  
>  		err = dsa_port_enable(dp, NULL);
>  		if (err)
> -			return err;
> +			break;
> +		dsa_port_enabled = true;
> +
>  		break;
>  	case DSA_PORT_TYPE_DSA:
>  		memset(dlp, 0, sizeof(*dlp));
> @@ -288,15 +295,19 @@ static int dsa_port_setup(struct dsa_port *dp)
>  				       dp->index, false, 0, id, len);
>  		err = devlink_port_register(dl, dlp, dp->index);
>  		if (err)
> -			return err;
> +			break;
> +		devlink_port_registered = true;
>  
>  		err = dsa_port_link_register_of(dp);
>  		if (err)
> -			return err;
> +			break;
> +		dsa_port_link_registered = true;
>  
>  		err = dsa_port_enable(dp, NULL);
>  		if (err)
> -			return err;
> +			break;
> +		dsa_port_enabled = true;
> +
>  		break;
>  	case DSA_PORT_TYPE_USER:
>  		memset(dlp, 0, sizeof(*dlp));
> @@ -304,18 +315,26 @@ static int dsa_port_setup(struct dsa_port *dp)
>  				       dp->index, false, 0, id, len);
>  		err = devlink_port_register(dl, dlp, dp->index);
>  		if (err)
> -			return err;
> +			break;
> +		devlink_port_registered = true;
>  
>  		dp->mac = of_get_mac_address(dp->dn);
>  		err = dsa_slave_create(dp);
>  		if (err)
> -			return err;
> +			break;
>  
>  		devlink_port_type_eth_set(dlp, dp->slave);
>  		break;
>  	}
>  
> -	return 0;
> +	if (err && dsa_port_enabled)
> +		dsa_port_disable(dp);
> +	if (err && dsa_port_link_registered)
> +		dsa_port_link_unregister_of(dp);
> +	if (err && devlink_port_registered)
> +		devlink_port_unregister(dlp);
> +
> +	return err;
>  }

No no, I'm pretty sure you can tell this is going to be a nightmare to
maintain these boolean states for all port types ;-)

And this is not a proper fix for the problem you've spotted. The problem
you've spotted is that devlink_port_unregister isn't called for the current
port if its setup failed, because dsa_port_teardown -- which is supposed to
be called unconditionally on error -- isn't called for the current port. Your
first attempt was correct, simply fix the loop in dsa_tree_setup_switches
to include the current port:


     ports_teardown:
    -       for (i = 0; i < port; i++)
    +       for (i = 0; i <= port; i++)


As for devlink_port_unregister, most kernel APIs unregistering objects are
self protected, so I'm tempted to propose the following patch for devlink:


    diff --git a/net/core/devlink.c b/net/core/devlink.c
    index 650f36379203..ab95607800d6 100644
    --- a/net/core/devlink.c
    +++ b/net/core/devlink.c
    @@ -6264,6 +6264,8 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
     {
            struct devlink *devlink = devlink_port->devlink;
     
    +       if (!devlink_port->registered)
    +               return;
            devlink_port_type_warn_cancel(devlink_port);
            devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
            mutex_lock(&devlink->lock);


Otherwise we can protect the devlink port unregistering ourselves with:


    if (dlp->registered)
        devlink_port_unregister(dlp);


BTW that is the subtlety between "unregister" which considers that the object
_may_ have been registered, and "deregister" which assumes the object _was_
registered. Would you like to go ahead and propose the devlink patch?


Thanks for pointing this out,

	Vivien
