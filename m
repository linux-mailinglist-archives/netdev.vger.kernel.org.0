Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59DC284FBB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 18:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgJFQV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 12:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFQV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 12:21:28 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D42CC061755;
        Tue,  6 Oct 2020 09:21:28 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e22so11670031ejr.4;
        Tue, 06 Oct 2020 09:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=utcATkzXZqvTDlfmrXPFYbUjw1CLbKQP7goA5lLFq5I=;
        b=UxoyK6YTS5MS3MsTcN/3IgPXSo1AAQuUf7qCwHNzNOX2VdUwEygal7uwgK/qRRlM2l
         BTvVvjxBkyk/qRvu5r2LGTxwWb6ncS+6pFmhSWa4xLjuM76eZAYRSykjozIGEOE84Ojn
         y+RffvMUy01eS2Cq0ptLB2jZGBPxLScOM4tZBmfuz/gIskpn6yIbK641YHSpcrewvVLP
         6aCu3xBjjs5Ubb8NW0mLGcm4Qz4Xe65GqdNC+2+CMf+T0advuhjj9M615Ig6hMjFRX/0
         LasDLU/WvK6EzZGQVP0ELlcRNXtUyml6hcwxMjP1BsHQlXTQKnyhlipjaTh1rfZpLh1k
         k6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=utcATkzXZqvTDlfmrXPFYbUjw1CLbKQP7goA5lLFq5I=;
        b=SARRhAaG+MFTm8wI9SfhGd2vbSUNoVgziKvP72Eoi8CanvtUBuCG+HKwrJX9NIFbXi
         ntDa0diE9IFTl1vDYsZGWglm9s/VWG+6MkBVK8NMRZHdJ05Kb7ojNu4OB1GI9to6gWgi
         4DzmUgZYSsej/z2Q6Y1jKdZXgJfZkDCfjsa/HKQAA8lAxt7c+IK4xN/wKU1gpZwThEJK
         jixnKO5nrvf8qLvzgLvihV1dX6E1nJE0nxN8sLmioJ8DbvtPuuZfquvp3yL1kB5HqVF8
         34KqKAmUSxg8lRngkMIrF51vNUYsRwrPnh8bkiQigRJ6l2X2Jf5sZscSwHWnDLQDQfz1
         rvfQ==
X-Gm-Message-State: AOAM532w1VVjGSGwmFADRbP4PKMyMjZP2Xy6hrj319n7BL3So64qRYAv
        Kb3RCqjEnDqtu9asc5XhN0g=
X-Google-Smtp-Source: ABdhPJzYNowpQbxh/relVjH1VyEPRQH9yPCVD0j6fygXppV4NCkNJhXoDXldseQ8/SF/U5+YxYo/Gg==
X-Received: by 2002:a17:907:4301:: with SMTP id nh1mr240873ejb.397.1602001287054;
        Tue, 06 Oct 2020 09:21:27 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id j11sm2480696ejk.63.2020.10.06.09.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 09:21:26 -0700 (PDT)
Date:   Tue, 6 Oct 2020 19:21:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net v2] net: dsa: microchip: fix race condition
Message-ID: <20201006162125.ulftqdiufdxjesn7@skbuf>
References: <20201006155651.21473-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006155651.21473-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 05:56:51PM +0200, Christian Eggers wrote:
> Between queuing the delayed work and finishing the setup of the dsa
> ports, the process may sleep in request_module() (via
> phy_device_create()) and the queued work may be executed prior to the
> switch net devices being registered. In ksz_mib_read_work(), a NULL
> dereference will happen within netof_carrier_ok(dp->slave).
> 
> Not queuing the delayed work in ksz_init_mib_timer() makes things even
> worse because the work will now be queued for immediate execution
> (instead of 2000 ms) in ksz_mac_link_down() via
> dsa_port_link_register_of().
> 
> Call tree:
> ksz9477_i2c_probe()
> \--ksz9477_switch_register()
>    \--ksz_switch_register()
>       +--dsa_register_switch()
>       |  \--dsa_switch_probe()
>       |     \--dsa_tree_setup()
>       |        \--dsa_tree_setup_switches()
>       |           +--dsa_switch_setup()
>       |           |  +--ksz9477_setup()
>       |           |  |  \--ksz_init_mib_timer()
>       |           |  |     |--/* Start the timer 2 seconds later. */
>       |           |  |     \--schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
>       |           |  \--__mdiobus_register()
>       |           |     \--mdiobus_scan()
>       |           |        \--get_phy_device()
>       |           |           +--get_phy_id()
>       |           |           \--phy_device_create()
>       |           |              |--/* sleeping, ksz_mib_read_work() can be called meanwhile */
>       |           |              \--request_module()
>       |           |
>       |           \--dsa_port_setup()
>       |              +--/* Called for non-CPU ports */
>       |              +--dsa_slave_create()
>       |              |  +--/* Too late, ksz_mib_read_work() may be called beforehand */
>       |              |  \--port->slave = ...
>       |             ...
>       |              +--Called for CPU port */
>       |              \--dsa_port_link_register_of()
>       |                 \--ksz_mac_link_down()
>       |                    +--/* mib_read must be initialized here */
>       |                    +--/* work is already scheduled, so it will be executed after 2000 ms */
>       |                    \--schedule_delayed_work(&dev->mib_read, 0);
>       \-- /* here port->slave is setup properly, scheduling the delayed work should be safe */
> 
> Solution:
> 1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
> 2. Only queue delayed work in ksz_mac_link_down() if init is completed.
> 3. Queue work once in ksz_switch_register(), after dsa_register_switch()
> has completed.
> 
> Fixes: 7c6ff470aa ("net: dsa: microchip: add MIB counter reading support")
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

You forgot to copy Florian's review tag from v1.

> v2:
> ---------
> - no changes in the patch itself
> - use correct subject-prefix
> - changed wording of commit description
> - added call tree to commit description
> - added "Fixes:" tag
> 
[...]
> 		/* Only read MIB counters when the port is told to do.
> 		 * If not, read only dropped counters when link is not up.
> 		 */
> port_r_cnt() is called independently of p->read and netif_carrier_ok()... What
> is correct here (comment or code)?

port_r_cnt() iterates with mib->cnt_ptr through 2 loops.
Check how mib->cnt_ptr is set before port_r_ctr is called.

> I needed some amount of time to understand the segfault and to draw the
> call stack...

I'm sure you did.

> I am definitely not an expert for this driver. For starting/stopping the
> delayed work on demand, a separate work struct for each port could be useful.
> In this case, struct ksz_port would need a pointer to the ksz_device struct,
> as the ports are allocated seperately and container_of() cannot be used.

Me neither, I'm just a spectator.

> Using a bool variable has the property, that reading the MIB will not be
> performed "immediately" after phylink_mac_down(). But if I am correct, this
> is also not the case today as the work is typically already queued when
> ksz_mac_link_down() is executed.
> 
> - First call of ksz_mac_link_down:
> Work is already queued (prior this patch) or will not be queued (after this
> patch).
> 
> - Further calls:
> Work is already queued (it requeues itself).
> 
> Result (please verify):

I can't verify this. Please ask the Microchip people. But the fix makes
sense.

> - Not scheduling the work in ksz_mac_link_down() won't change anything.
> - Checking for mib_read_interval in ksz_switch_remove() can be obmitted,
>   as the condition is always true when ksz_switch_remove() is called.

If there's an error in the probe path, I expect that the
mib_read_interval will not get set, and the delayed workqueue will not
be scheduled, will it? So I think the check is ok there.

Thanks,
-Vladimir
