Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1F8301DE9
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 18:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbhAXRaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 12:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbhAXRaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 12:30:21 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50147C061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:29:41 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id by1so14718976ejc.0
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 09:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jxlxjYHs9sWiYwAzLKpveJ4rn1wS5sW/Rd41DZjJyBA=;
        b=WDWHmWt6hYJWiWCmI6TPBgkyaxoDrjJ7yvfKOUUL+iXXeePGF7OPZlp0tmzHDop+SR
         wjugka9is6aaHSSmhkSxsvXx2m8GaQImiJCTrap6VwcSzRtzSbQ6RXld63WaqOpjRTCp
         BdkuBvCqDDn64btxgTSCpT5SSNPtBxLCQeuf+rRr+CHuzuUV+MlzuBcBXOhu5ReJDo5T
         Aapi60f9tRoCLVpLIRjeQ+6yX1FuTWsUjNNLLOdfjcR+0trymeJt+rF/9CYE+nTkVWfe
         eR2mJhf9uJ9PhXTa9BRACg2N/ihcchQyhBa4VqXu9+DFyo9nm8gSRxb6JbFQzzxN9pQ8
         P0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jxlxjYHs9sWiYwAzLKpveJ4rn1wS5sW/Rd41DZjJyBA=;
        b=qeCNNQsRCgn0TF0x3S1YXoRBFEqcHme7wSLxCnc52Loav1HrRU3IfXWi1QGXChO1Vx
         skSpA9BN0wkPs8BXLj3mbWDY6CjXYGuVLAy7cN7rEBPwTn41zfg44ep667rT8m/7Derd
         VBuYirqXYhQwY0T8EXy0uQ9Ksn/WCUBDw76eHvxZ6X/ei4F/lrYJAIXmSCL+ATyE+g7g
         6GMUOrcLWYD9weM4Z3uS0nlSGd8kq4LnLY0mQkCnysw4NJDe3r3lS+ggjSwFB9TRT2Ww
         QIPjcdMDRqMsgLl8nQ20B8fzmhJU4fOexGxxnweyqaJKpXbZYr6i8fjlxO9CrrNsPXkm
         Gojw==
X-Gm-Message-State: AOAM532kzUb8w0dZonCshPvMT6LXquUEyVtrimfskh5usPIb9jnp5SoH
        MafmJ6BziSZwYdisr8DfzkPh+r518lk=
X-Google-Smtp-Source: ABdhPJzgPA3R2ujextX7WxSK58R6W4NmDSaMgF/xBzUueuLJiwt9kCblus02U4YIrZY50dHUIEzmoA==
X-Received: by 2002:a17:906:7c57:: with SMTP id g23mr1313823ejp.364.1611509380032;
        Sun, 24 Jan 2021 09:29:40 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s3sm1401733ejn.47.2021.01.24.09.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 09:29:39 -0800 (PST)
Date:   Sun, 24 Jan 2021 19:29:38 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Nishanth Menon <nm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/3] net: hsr: add DSA offloading support
Message-ID: <20210124172938.ikhpe44bqjqmttul@skbuf>
References: <20210122155948.5573-1-george.mccollister@gmail.com>
 <20210122155948.5573-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122155948.5573-3-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 09:59:47AM -0600, George McCollister wrote:
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index f2fb433f3828..fc7e3ff11c5c 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -1924,6 +1924,19 @@ static int dsa_slave_changeupper(struct net_device *dev,
>  			dsa_port_lag_leave(dp, info->upper_dev);
>  			err = NOTIFY_OK;
>  		}
> +	} else if (netif_is_hsr_master(info->upper_dev)) {
> +		if (info->linking) {
> +			err = dsa_port_hsr_join(dp, info->upper_dev);
> +			if (err == -EOPNOTSUPP) {
> +				NL_SET_ERR_MSG_MOD(info->info.extack,
> +						   "Offloading not supported");
> +				err = 0;
> +			}
> +			err = notifier_from_errno(err);
> +		} else {
> +			dsa_port_hsr_leave(dp, info->upper_dev);
> +			err = NOTIFY_OK;
> +		}
>  	}

How is the RedBox use case handled with the Linux hsr driver (i.e. a
HSR-unaware SAN endpoint attached to a HSR ring)? I would expect
something like this:

                   +---------+
                   |         |
                   |   SAN   |
                   |         |
                   +---------+
                        |
                        |
                        |
 +-----------------+---------+------------------+
 |                 |         |                  |
 |  Your           |   swp0  |                  |
 |  board          |         |                  |
 |                 +---------+                  |
 |                    |   ^                     |
 |                    |   |                     |
 |                    |   | br0                 |
 |                    |   |                     |
 |                    v   |                     |
 |       +-----------------------------+        |
 |       |                             |        |
 |       |             hsr0            |        |
 |       |                             |        |
 |       +---------+---------+---------+        |
 |       |         |         |         |        |
 |       |   swp1  |  DAN-H  |  swp2   |        |
 |       |         |         |         |        |
 +-------+---------+---------+---------+--------+
            |   ^               |   ^
    to/from |   |               |   | to/from
     ring   |   |               |   |  ring
            v   |               v   |

Therefore, aren't you interested in offloading this setup as well?
I.e. the case where the hsr0 interface joins a bridge that also
contains other DSA switch ports. This would be similar to the LAG
offload recently added by Tobias.
