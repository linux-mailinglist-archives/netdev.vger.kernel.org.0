Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC5FA162F67
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgBRTJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:09:10 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41294 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRTJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:09:09 -0500
Received: by mail-qk1-f194.google.com with SMTP id d11so20575813qko.8
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 11:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=Td4LB0UxhUmlCZLysvleIz+839hQOKglA5Z9n8IWCJk=;
        b=qGFK3ge3TOsUxEvNZvB/4L67c3OyvKunokAiqAE7tEb2ojTi8mCqt+0D8CqwlxdRjQ
         hdAa/YOx3HRL0D14l2Oe+6LtN+nTVCksKYXw17GP0n/ANcL0yHxcJY+ttZ+3V1NSt+ny
         GMJV09CRqsa5szY20nCNjEfHz4qq7fGrb/B7eAhQV/szWZQJC9UnZdtA84twVDvDo1Zc
         mnCy3yXN46zEGX9nwUicFDyHJXtEc7nEAkFq1ZgfzhLI299ZX7O8+0l6aZPe73UuUFis
         gvgpH3CA1uw7muobmMlRyNNgUxgwbV2v2IPUpvG+8jqE0swWF7llmHWwETYNoJQ+dyX9
         B2GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=Td4LB0UxhUmlCZLysvleIz+839hQOKglA5Z9n8IWCJk=;
        b=t2Lgx/4hRFQqyRR9A83lZdas/Yoc278lk6R2RecozDRlyVv42EAiWj52vxW+/ftguE
         9ZTiVdJ22s8qgz5hvyRyin5jKFdlWHw50K4WU3lWO2pvJ1pRk2EotohB8jVfF5SnTcmJ
         yYRJ7xquMWogwB2c0ltFWydF4xAEW0bpK0C1StHxKML/GhAX+GV7sQjPKzzySj+tZWKz
         mbbwAipOkeQRwaqpI6mwhcaf6wNJ9yboynzyNuqQ3MxGDWZYKkVZFLEXrmin/reAZitf
         qJiP6nK18Vz6bl0lupfllE228D1Tw4rO7QxUdeMSDgrmMJ793VcPvtH3RKX2B2SaEyTE
         7dIw==
X-Gm-Message-State: APjAAAU75DRRbl0lKteDmfFSu10oPjzvsW447vnvqanzKO8+d0uM71ET
        nXPaTJ8c5diOyVNl9m314nQ=
X-Google-Smtp-Source: APXvYqyuM3X5TzeG7lNDXbuAhoYhUZuZnf5blWd/1+Uk0V77ngJPKud8NM7re/S6Yx06WSF3xfD96g==
X-Received: by 2002:ae9:c014:: with SMTP id u20mr20160941qkk.53.1582052948578;
        Tue, 18 Feb 2020 11:09:08 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id v78sm2381264qkb.48.2020.02.18.11.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:09:07 -0800 (PST)
Date:   Tue, 18 Feb 2020 14:09:07 -0500
Message-ID: <20200218140907.GB15095@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: fix vlan setup
In-Reply-To: <E1j41KW-0002v5-2S@rmk-PC.armlinux.org.uk>
References: <20200218114515.GL18808@shell.armlinux.org.uk>
 <E1j41KW-0002v5-2S@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, 18 Feb 2020 11:46:20 +0000, Russell King <rmk+kernel@armlinux.org.uk> wrote:
> DSA assumes that a bridge which has vlan filtering disabled is not
> vlan aware, and ignores all vlan configuration. However, the kernel
> software bridge code allows configuration in this state.
> 
> This causes the kernel's idea of the bridge vlan state and the
> hardware state to disagree, so "bridge vlan show" indicates a correct
> configuration but the hardware lacks all configuration. Even worse,
> enabling vlan filtering on a DSA bridge immediately blocks all traffic
> which, given the output of "bridge vlan show", is very confusing.
> 
> Provide an option that drivers can set to indicate they want to receive
> vlan configuration even when vlan filtering is disabled. This is safe
> for Marvell DSA bridges, which do not look up ingress traffic in the
> VTU if the port is in 8021Q disabled state. Whether this change is
> suitable for all DSA bridges is not known.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c |  1 +
>  include/net/dsa.h                |  1 +
>  net/dsa/slave.c                  | 12 ++++++++----
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 629eb7bbbb23..e656e571ef7d 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2934,6 +2934,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  
>  	chip->ds = ds;
>  	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
> +	ds->vlan_bridge_vtu = true;
>  
>  	mv88e6xxx_reg_lock(chip);
>  
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 63495e3443ac..d3a826646e8e 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -273,6 +273,7 @@ struct dsa_switch {
>  	 * settings on ports if not hardware-supported
>  	 */
>  	bool			vlan_filtering_is_global;
> +	bool			vlan_bridge_vtu;
>  
>  	/* In case vlan_filtering_is_global is set, the VLAN awareness state
>  	 * should be retrieved from here and not from the per-port settings.
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 088c886e609e..534d511b349e 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -318,7 +318,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
>  	if (obj->orig_dev != dev)
>  		return -EOPNOTSUPP;
>  
> -	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
> +	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
> +	    !br_vlan_enabled(dp->bridge_dev))
>  		return 0;
>  
>  	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
> @@ -385,7 +386,8 @@ static int dsa_slave_vlan_del(struct net_device *dev,
>  	if (obj->orig_dev != dev)
>  		return -EOPNOTSUPP;
>  
> -	if (dp->bridge_dev && !br_vlan_enabled(dp->bridge_dev))
> +	if (dp->bridge_dev && !dp->ds->vlan_bridge_vtu &&
> +	    !br_vlan_enabled(dp->bridge_dev))
>  		return 0;
>  
>  	/* Do not deprogram the CPU port as it may be shared with other user
> @@ -1106,7 +1108,8 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
>  	 * need to emulate the switchdev prepare + commit phase.
>  	 */
>  	if (dp->bridge_dev) {
> -		if (!br_vlan_enabled(dp->bridge_dev))
> +		if (!dp->ds->vlan_bridge_vtu &&
> +		    !br_vlan_enabled(dp->bridge_dev))
>  			return 0;
>  
>  		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
> @@ -1140,7 +1143,8 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
>  	 * need to emulate the switchdev prepare + commit phase.
>  	 */
>  	if (dp->bridge_dev) {
> -		if (!br_vlan_enabled(dp->bridge_dev))
> +		if (!dp->ds->vlan_bridge_vtu &&
> +		    !br_vlan_enabled(dp->bridge_dev))
>  			return 0;
>  
>  		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the

It is confusing to add a Marvell specific term (VTU) in the generic dsa_switch
structure to bypass the fact that VLAN configuration in hardware was already
bypassed for some reasons until vlan filtering is turned on. As you said,
simply offloading the VLAN configuration in hardware and only turning the
ports' 802.1Q mode to Secure once vlan_filtering is flipped to 1 should work
in theory for both VLAN filtering aware and unaware scenarios, but this was
causing problems if I'm not mistaken, I'll try to dig this out.

In the meantime, does the issue you're trying to solve here happens if you
create a vlan-filtering aware bridge in the first place, before any VLAN
configuration? i.e.:

    # ip link add name br0 type bridge vlan_filtering 1
    # ip link set master br0 dev lan1 up
    # bridge vlan add ...


Thank you,
Vivien
