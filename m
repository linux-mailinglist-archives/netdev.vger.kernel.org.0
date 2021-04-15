Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF26361081
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbhDOQy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhDOQyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:54:54 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B89C061756;
        Thu, 15 Apr 2021 09:54:30 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e2so8104115plh.8;
        Thu, 15 Apr 2021 09:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t6+Ib1ChpAOXnBtNGjoiDzvtXLgDYp5L8cXPxkw88KI=;
        b=SS+wdoC3jTZO3q6l97sZan3UJT0ZFIDpPPakIwz5mq/vkz3EmB0XQZaovBD9A1zS3W
         fVeFcdoBtRnpLriV8gLHUD7JjC60Hx102MnzAUnocvv0OP42mCRHAYxMik08H9xgVvbE
         Tbpn6XwcDhJdcCaujFgmTYxlA9e16+mbh09ZGi+7O79BW9luQthw5qhLr4rFTlzRG12Z
         NfPk0NX4Y72IMmIAcydeLCrJcR1yVh+tze7K+6s9a/CuUWto1GaH/g0sxlqNGX3iyeSg
         n9vmU5NWtPs3/XVgb4gBaHzSiN8HwMhM4fUphd9gXpM6RGeiFVq3Rw4McLFfmGfQ8TBq
         /y8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t6+Ib1ChpAOXnBtNGjoiDzvtXLgDYp5L8cXPxkw88KI=;
        b=t+rfXqdIDNinyuAqwJWBMsk6e9U+Mk3y37JgVOtS+1EhTuptJitWj4M0f2IkwTO8iO
         vgIn/Q3QkKp7Dz7b+DCPRM4MhhpTiw+Tl8cEP87fxlzxeJDxVg6Yo7hMJqZHbIH/EegY
         vglWW3YmNAF8kr/IojVa3rHYXFXBCj8/SWC8yaNLb9T6Br8fUf1rLaoNEsoWo5gq1mm0
         WENzUK7rciRN33O6ZVRMfOEkVANjRwji75uJo+myVQwcKrCYpYzfNUSZzQMzKwesDjw3
         dM1Y0LYCP9Kcm5HKhevNF2xgaxtk5gXyarSkeen/+ksJmhNva1jjqC7l3N+Vnjcku94v
         uQKw==
X-Gm-Message-State: AOAM531vIOdnKLtN66wodA/iH4OUm4dboXZ8uuBaErv9Veb75AOQJ3ja
        fYOgRT9kTm0MGj/ouTfgmtrMfAYOXmvVdA==
X-Google-Smtp-Source: ABdhPJztE+x+ADXySpEjI0QAgY+K+xJQ2ZC2r/Kv5mzuyDmX0YabtvPw4BhIJls7oaijQ61Hz6R//w==
X-Received: by 2002:a17:90a:fa84:: with SMTP id cu4mr5022346pjb.2.1618505670012;
        Thu, 15 Apr 2021 09:54:30 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id j16sm2576105pfa.213.2021.04.15.09.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 09:54:29 -0700 (PDT)
Date:   Thu, 15 Apr 2021 19:54:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/5] net: dsa: Allow default tag protocol to
 be overridden from DT
Message-ID: <20210415165420.pb5mgxyzhezqnvh5@skbuf>
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415092610.953134-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:26:09AM +0200, Tobias Waldekranz wrote:
> Some combinations of tag protocols and Ethernet controllers are
> incompatible, and it is hard for the driver to keep track of these.
> 
> Therefore, allow the device tree author (typically the board vendor)
> to inform the driver of this fact by selecting an alternate protocol
> that is known to work.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/dsa.h |  5 +++
>  net/dsa/dsa2.c    | 95 ++++++++++++++++++++++++++++++++++++++---------
>  2 files changed, 83 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 1259b0f40684..2b25fe1ad5b7 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -149,6 +149,11 @@ struct dsa_switch_tree {
>  	/* Tagging protocol operations */
>  	const struct dsa_device_ops *tag_ops;
>  
> +	/* Default tagging protocol preferred by the switches in this
> +	 * tree.
> +	 */
> +	enum dsa_tag_protocol default_proto;
> +
>  	/*
>  	 * Configuration data for the platform device that owns
>  	 * this dsa switch tree instance.
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index d7c22e3a1fbf..80dbf8b6bf8f 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -668,6 +668,35 @@ static const struct devlink_ops dsa_devlink_ops = {
>  	.sb_occ_tc_port_bind_get	= dsa_devlink_sb_occ_tc_port_bind_get,
>  };
>  
> +static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
> +{
> +	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
> +	struct dsa_switch_tree *dst = ds->dst;
> +	int port, err;
> +
> +	if (tag_ops->proto == dst->default_proto)
> +		return 0;
> +
> +	if (!ds->ops->change_tag_protocol) {
> +		dev_err(ds->dev, "Tag protocol cannot be modified\n");
> +		return -EINVAL;
> +	}

We validated this already here:

		if (ds->ops->change_tag_protocol) {
			tag_ops = dsa_find_tagger_by_name(user_protocol);
		} else {
			dev_err(ds->dev, "Tag protocol cannot be modified\n");
			return -EINVAL;
		}

> +
> +	for (port = 0; port < ds->num_ports; port++) {
> +		if (!dsa_is_cpu_port(ds, port))
> +			continue;
> +
> +		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
> +		if (err) {
> +			dev_err(ds->dev, "Tag protocol \"%s\" is not supported\n",
> +				tag_ops->name);

Maybe instead of saying "is not supported", you can say
"Changing the tag protocol to \"%s\" returned %pe", tag_ops->name, ERR_PTR(err)
which is a bit more informative.

> +			return err;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int dsa_switch_setup(struct dsa_switch *ds)
>  {
>  	struct dsa_devlink_priv *dl_priv;
> @@ -718,6 +747,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	if (err < 0)
>  		goto unregister_notifier;
>  
> +	err = dsa_switch_setup_tag_protocol(ds);
> +	if (err)
> +		goto teardown;
> +
>  	devlink_params_publish(ds->devlink);
>  
>  	if (!ds->slave_mii_bus && ds->ops->phy_read) {
> @@ -1068,34 +1101,60 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
>  	return ds->ops->get_tag_protocol(ds, dp->index, tag_protocol);
>  }
>  
> -static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
> +static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
> +			      const char *user_protocol)
>  {
>  	struct dsa_switch *ds = dp->ds;
>  	struct dsa_switch_tree *dst = ds->dst;
>  	const struct dsa_device_ops *tag_ops;
> -	enum dsa_tag_protocol tag_protocol;
> +	enum dsa_tag_protocol default_proto;
> +
> +	/* Find out which protocol the switch would prefer. */
> +	default_proto = dsa_get_tag_protocol(dp, master);
> +	if (dst->default_proto) {
> +		if (dst->default_proto != default_proto) {
> +			dev_err(ds->dev,
> +				"A DSA switch tree can have only one tagging protocol\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		dst->default_proto = default_proto;
> +	}
> +
> +	/* See if the user wants to override that preference. */
> +	if (user_protocol) {
> +		if (ds->ops->change_tag_protocol) {
> +			tag_ops = dsa_find_tagger_by_name(user_protocol);
> +		} else {
> +			dev_err(ds->dev, "Tag protocol cannot be modified\n");
> +			return -EINVAL;
> +		}

Your choice, but how about:

		if (!ds->ops->change_tag_protocol) {
			dev_err(ds->dev, "Tag protocol cannot be modified\n");
			return -EINVAL;
		}

		tag_ops = dsa_find_tagger_by_name(user_protocol);

> +	} else {
> +		tag_ops = dsa_tag_driver_get(default_proto);
> +	}
> +
> +	if (IS_ERR(tag_ops)) {
> +		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
> +			return -EPROBE_DEFER;
> +
> +		dev_warn(ds->dev, "No tagger for this switch\n");
> +		return PTR_ERR(tag_ops);
> +	}
>  
> -	tag_protocol = dsa_get_tag_protocol(dp, master);
>  	if (dst->tag_ops) {
> -		if (dst->tag_ops->proto != tag_protocol) {
> +		if (dst->tag_ops != tag_ops) {
>  			dev_err(ds->dev,
>  				"A DSA switch tree can have only one tagging protocol\n");
> +
> +			dsa_tag_driver_put(tag_ops);
>  			return -EINVAL;
>  		}
> +
>  		/* In the case of multiple CPU ports per switch, the tagging
> -		 * protocol is still reference-counted only per switch tree, so
> -		 * nothing to do here.
> +		 * protocol is still reference-counted only per switch tree.
>  		 */
> +		dsa_tag_driver_put(tag_ops);
>  	} else {
> -		tag_ops = dsa_tag_driver_get(tag_protocol);
> -		if (IS_ERR(tag_ops)) {
> -			if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
> -				return -EPROBE_DEFER;
> -			dev_warn(ds->dev, "No tagger for this switch\n");
> -			dp->master = NULL;
> -			return PTR_ERR(tag_ops);
> -		}
> -
>  		dst->tag_ops = tag_ops;

So at the end of dsa_port_parse_cpu, we have a dst->tag_ops which is
temporarily out of sync with the driver. We call dsa_port_set_tag_protocol()
with the new tagging protocol _before_ we call ds->ops->change_tag_protocol.
But as opposed to dsa_switch_change_tag_proto(), if ds->ops->change_tag_protocol
fails from the probe path, we treat it as a catastrophic error. So at
the end there is no risk of having anything out of sync I believe.

Maybe you should write this down in a comment? The logic is pretty
convoluted and hard to follow.

>  	}
>  
> @@ -1117,12 +1176,14 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
>  
>  	if (ethernet) {
>  		struct net_device *master;
> +		const char *user_protocol;
>  
>  		master = of_find_net_device_by_node(ethernet);
>  		if (!master)
>  			return -EPROBE_DEFER;
>  
> -		return dsa_port_parse_cpu(dp, master);
> +		user_protocol = of_get_property(dn, "dsa,tag-protocol", NULL);
> +		return dsa_port_parse_cpu(dp, master, user_protocol);
>  	}
>  
>  	if (link)
> @@ -1234,7 +1295,7 @@ static int dsa_port_parse(struct dsa_port *dp, const char *name,
>  
>  		dev_put(master);
>  
> -		return dsa_port_parse_cpu(dp, master);
> +		return dsa_port_parse_cpu(dp, master, NULL);
>  	}
>  
>  	if (!strcmp(name, "dsa"))
> -- 
> 2.25.1
> 
