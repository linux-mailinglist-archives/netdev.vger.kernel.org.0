Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41E62DC6E1
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733035AbgLPTE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbgLPTEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:04:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BDFC061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:04:15 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jx16so34306568ejb.10
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HJ7b7pR7wNTl2wrm1XFV7Dp/dzTRmLymXDNlAhzoP+Q=;
        b=hReZYDRZqMP+jLbB0STU48V54F0mdO9VtDQXA6ayqlP88e5erQ9n7FaRh49SVQj5k5
         An3Q6Q7QnWhL9eOHnVyxop4utyNeamgBJfmZzgcpCw5Eko+KWJMqxleREEAMTddDBKvt
         CArasyHHWts1Bje+RCxX6MNorN6Jm4aOpaApezIutHhLqn5lwHM7lIi56l2l9FeqbpOD
         2stFZpSdNLKLwumgv7GqDj+MrEKBh4h3ufdV5QP7OMG6JyAQa7Mlnb8EB45yCeBfZJeO
         93vJ0trJZ2w+cY62CXDGgbB+cIAm6VY5xfKW2ucdCt05P4W4XEwEVHSiTXk+bVm41onW
         kQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HJ7b7pR7wNTl2wrm1XFV7Dp/dzTRmLymXDNlAhzoP+Q=;
        b=RCrdYXlAfNd2Lhc25OZSjTZaLtfuEbbMSxtBVx70EiOSmmdN79E26fjqFsLaX+ahba
         RFd8Ufo+7+AgZ/ZbdHPO4yqyiwA9xmkdVN5SjDljoHtBdmJHF0Xrkyvys6nU8QcAGBmx
         ajCTSyBA55fj0PZYqsRnDN57/iwxHgyqJ5SYXB2+yPJfuFEElPmu+asUBZm1laXtlQN9
         YftD15yUlsesFVvBuuNPdcXNq+myO1jVaf8Or+LE4JeK+3xDf523egI8KfuvrK5W5hzH
         nRIDiWMYjRGEDAUL8eZAU60rnbMIVqloxIaU6Q5MkS2BUC9mvwqIK/EWtMpxif4ByCpj
         VdMA==
X-Gm-Message-State: AOAM530JHye57zo07ixEbizlBbQz7Y4oaXEAEYBekyBffctqyaXNwRiA
        p/IuXBNupWbn8KlFuozWJWA=
X-Google-Smtp-Source: ABdhPJzopj2x9GlUfICC6pYgDbJdRpcXUDKic27UslD0jCfI9M6cWORH4fFpfyrq4QvOGkCWVK796Q==
X-Received: by 2002:a17:907:1607:: with SMTP id hb7mr31234397ejc.81.1608145453750;
        Wed, 16 Dec 2020 11:04:13 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id s26sm21359420edc.33.2020.12.16.11.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 11:04:12 -0800 (PST)
Date:   Wed, 16 Dec 2020 21:04:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 4/5] net: dsa: mv88e6xxx: Link aggregation
 support
Message-ID: <20201216190410.2mgrujtjfd2uvnwu@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com>
 <20201216160056.27526-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216160056.27526-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 05:00:55PM +0100, Tobias Waldekranz wrote:
> Support offloading of LAGs to hardware. LAGs may be attached to a
> bridge in which case VLANs, multicast groups, etc. are also offloaded
> as usual.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c    | 298 +++++++++++++++++++++++++++-
>  drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
>  drivers/net/dsa/mv88e6xxx/global2.h |   5 +
>  drivers/net/dsa/mv88e6xxx/port.c    |  21 ++
>  drivers/net/dsa/mv88e6xxx/port.h    |   5 +
>  5 files changed, 329 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index eafe6bedc692..bd80b3939157 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1189,7 +1189,8 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
>  }
>  
>  /* Mask of the local ports allowed to receive frames from a given fabric port */
> -static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
> +static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port,
> +			       struct net_device **lag)
>  {
>  	struct dsa_switch *ds = chip->ds;
>  	struct dsa_switch_tree *dst = ds->dst;
> @@ -1201,6 +1202,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>  	list_for_each_entry(dp, &dst->ports, list) {
>  		if (dp->ds->index == dev && dp->index == port) {
>  			found = true;
> +
> +			if (dp->lag_dev && lag)
> +				*lag = dp->lag_dev;
>  			break;
>  		}
>  	}

I'll let Andrew and Vivien have the decisive word, who are vastly more
familiar with mv88e6xxx than I am, but to me it looks like a bit of a
hack to put this logic here, especially since one of the two callers
(i.e. half) doesn't even care about the LAG.

> @@ -1396,14 +1402,21 @@ static int mv88e6xxx_mac_setup(struct mv88e6xxx_chip *chip)
>  
>  static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
>  {
> +	struct net_device *lag = NULL;
>  	u16 pvlan = 0;
>  
>  	if (!mv88e6xxx_has_pvt(chip))
>  		return 0;
>  
>  	/* Skip the local source device, which uses in-chip port VLAN */
> -	if (dev != chip->ds->index)
> -		pvlan = mv88e6xxx_port_vlan(chip, dev, port);
> +	if (dev != chip->ds->index) {
> +		pvlan = mv88e6xxx_port_vlan(chip, dev, port, &lag);
> +
> +		if (lag) {
> +			dev = MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK;
> +			port = dsa_lag_id(chip->ds->dst, lag);
> +		}
> +	}

What about the following, which should remove the need of modifying mv88e6xxx_port_vlan:

static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
{
	struct dsa_switch *ds = chip->ds;
	struct net_device *lag = NULL;
	u16 pvlan = 0;

	if (!mv88e6xxx_has_pvt(chip))
		return 0;

	/* Skip the local source device, which uses in-chip port VLAN */
	if (dev != ds->index) {
		pvlan = mv88e6xxx_port_vlan(chip, dev, port);
		struct dsa_switch *other_ds;
		struct dsa_port *other_dp;

		other_ds = dsa_switch_find(ds->dst->index, dev);
		other_dp = dsa_to_port(other_ds, port);

		/* XXX needs an explanation for the reinterpreted values of
		 * dev and port
		 */
		if (other_dp->lag_dev) {
			dev = MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK;
			port = dsa_lag_id(ds->dst, other_dp->lag_dev);
		}
	}

	return mv88e6xxx_g2_pvt_write(chip, dev, port, pvlan);
}

>  
>  	return mv88e6xxx_g2_pvt_write(chip, dev, port, pvlan);
>  }
> @@ -5375,6 +5388,271 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
>  	return err;
>  }
>  
