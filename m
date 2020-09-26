Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF64279CE2
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgIZXha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 19:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgIZXh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 19:37:29 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681DFC0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 16:37:29 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l17so6197329edq.12
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 16:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BbwnYnWC0cCXGwH/gAFdJLc+PzVzKl1UUj0YTgWDF5w=;
        b=YVVbPOo+Q0u0GlfKgcanhJrGNwrfpP/ZPQbejU5/8uwO7WpBo9a6I4JIp/iKF8uhcO
         NHmvUCnBcB9t7Lnn6A8DAUWcbp3+ZpA0OsMaOlzOmw3Z/Yasb2YHWfrTg9XSaIr/kSj3
         GAdm2epwhuiETB21rdbsB3dBirBSbDNMaj5Khx/T+eqoCu9vo8ogJJ+biocj7wa/leUg
         LbPB440owQLoLVlYa0G3qAwmwUFa/OIsZ0WGg2xMEapGx67qlcFo6pc+O+qsqhD2rW0C
         uI/rgfg883qEpmQQx9qXtvlQZLMFjXrJdXcloJ7jmLjngZoY3Khb6L2S5CFYBxis62QB
         4zqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BbwnYnWC0cCXGwH/gAFdJLc+PzVzKl1UUj0YTgWDF5w=;
        b=LvM9QjC+0CneyGHOLHr/QgRo5mkb5ZHAkoYK97SGauQHwnhv3bocg+oz8YAf2Eg5Sd
         bWx4e28EC0VNPIodaOxXQsfeyp0cWVJjUunckk4LQozVI2MRjX6VoCa5TlZaBYojUQTQ
         VomU4D7cz1CWv19n43cBF+ioLbljv7UnHSEoieemFGDgFpm0oASDZ9j67BBDcwbXI5Bc
         9IV4FiLN/wSgNv8Z3u0KmJBEurokGx4IC7esmI1Fs9fNBadhG2MeUYdNhwHIvafrutT/
         PN3qX9Loo5dkTmWXl2avFmLbAQ/EaWvOpxFJyQs7g8+XKgymSXVKkS1AakzBanbxUeZ3
         mo0A==
X-Gm-Message-State: AOAM533HXv8ePiYDrU3K+tg54RULbsiTXBcXrZORZ3dG9xNtUaw9utfi
        OdPgdeQKKzY1G4JfMsIjsmk=
X-Google-Smtp-Source: ABdhPJyR0isdLTrXEngmXDK2o6r+EgYfRFfZmP3gtUR2Njz4kdNbdr7RvX35h46PoA9eH2dGBN9/Xw==
X-Received: by 2002:a05:6402:1353:: with SMTP id y19mr8708093edw.71.1601163447923;
        Sat, 26 Sep 2020 16:37:27 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k19sm5001761ejo.40.2020.09.26.16.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2020 16:37:27 -0700 (PDT)
Date:   Sun, 27 Sep 2020 02:37:25 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 3/7] net: dsa: Register devlink ports before
 calling DSA driver setup()
Message-ID: <20200926233725.fagc4znatjpufu6q@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926210632.3888886-4-andrew@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 11:06:28PM +0200, Andrew Lunn wrote:
> DSA drivers want to create regions on devlink ports as well as the
> devlink device instance, in order to export registers and other tables
> per port. To keep all this code together in the drivers, have the
> devlink ports registered early, so the setup() method can setup both
> device and port devlink regions.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/dsa.h |   1 +
>  net/dsa/dsa2.c    | 133 ++++++++++++++++++++++++++++------------------
>  2 files changed, 83 insertions(+), 51 deletions(-)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index d16057c5987a..9aa44dc8ecdb 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -208,6 +208,7 @@ struct dsa_port {
>  	u8			stp_state;
>  	struct net_device	*bridge_dev;
>  	struct devlink_port	devlink_port;
> +	bool			devlink_port_setup;
>  	struct phylink		*pl;
>  	struct phylink_config	pl_config;
>  
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 2c149fb36928..90cc70bd7c22 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -251,47 +251,19 @@ static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
>  
>  static int dsa_port_setup(struct dsa_port *dp)
>  {
> -	struct dsa_switch *ds = dp->ds;
> -	struct dsa_switch_tree *dst = ds->dst;
> -	const unsigned char *id = (const unsigned char *)&dst->index;
> -	const unsigned char len = sizeof(dst->index);
>  	struct devlink_port *dlp = &dp->devlink_port;
>  	bool dsa_port_link_registered = false;
> -	bool devlink_port_registered = false;
> -	struct devlink_port_attrs attrs = {};
> -	struct devlink *dl = ds->devlink;
>  	bool dsa_port_enabled = false;
>  	int err = 0;
>  
> -	attrs.phys.port_number = dp->index;
> -	memcpy(attrs.switch_id.id, id, len);
> -	attrs.switch_id.id_len = len;
> -
>  	if (dp->setup)
>  		return 0;
>  
>  	switch (dp->type) {
>  	case DSA_PORT_TYPE_UNUSED:
> -		memset(dlp, 0, sizeof(*dlp));
> -		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;
> -		devlink_port_attrs_set(dlp, &attrs);
> -		err = devlink_port_register(dl, dlp, dp->index);
> -		if (err)
> -			break;
> -
> -		devlink_port_registered = true;
> -
>  		dsa_port_disable(dp);
>  		break;
>  	case DSA_PORT_TYPE_CPU:
> -		memset(dlp, 0, sizeof(*dlp));
> -		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
> -		devlink_port_attrs_set(dlp, &attrs);
> -		err = devlink_port_register(dl, dlp, dp->index);
> -		if (err)
> -			break;
> -		devlink_port_registered = true;
> -
>  		err = dsa_port_link_register_of(dp);
>  		if (err)
>  			break;
> @@ -304,14 +276,6 @@ static int dsa_port_setup(struct dsa_port *dp)
>  
>  		break;
>  	case DSA_PORT_TYPE_DSA:
> -		memset(dlp, 0, sizeof(*dlp));
> -		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
> -		devlink_port_attrs_set(dlp, &attrs);
> -		err = devlink_port_register(dl, dlp, dp->index);
> -		if (err)
> -			break;
> -		devlink_port_registered = true;
> -
>  		err = dsa_port_link_register_of(dp);
>  		if (err)
>  			break;
> @@ -324,14 +288,6 @@ static int dsa_port_setup(struct dsa_port *dp)
>  
>  		break;
>  	case DSA_PORT_TYPE_USER:
> -		memset(dlp, 0, sizeof(*dlp));
> -		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
> -		devlink_port_attrs_set(dlp, &attrs);
> -		err = devlink_port_register(dl, dlp, dp->index);
> -		if (err)
> -			break;
> -		devlink_port_registered = true;
> -
>  		dp->mac = of_get_mac_address(dp->dn);
>  		err = dsa_slave_create(dp);
>  		if (err)
> @@ -345,8 +301,6 @@ static int dsa_port_setup(struct dsa_port *dp)
>  		dsa_port_disable(dp);
>  	if (err && dsa_port_link_registered)
>  		dsa_port_link_unregister_of(dp);
> -	if (err && devlink_port_registered)
> -		devlink_port_unregister(dlp);
>  	if (err)
>  		return err;
>  
> @@ -355,30 +309,77 @@ static int dsa_port_setup(struct dsa_port *dp)
>  	return 0;
>  }
>  
> -static void dsa_port_teardown(struct dsa_port *dp)
> +static int dsa_port_devlink_setup(struct dsa_port *dp)
>  {
>  	struct devlink_port *dlp = &dp->devlink_port;
> +	struct dsa_switch_tree *dst = dp->ds->dst;
> +	struct devlink_port_attrs attrs = {};
> +	struct devlink *dl = dp->ds->devlink;
> +	const unsigned char *id;
> +	unsigned char len;
> +	int err;
> +
> +	id = (const unsigned char *)&dst->index;
> +	len = sizeof(dst->index);
> +
> +	attrs.phys.port_number = dp->index;
> +	memcpy(attrs.switch_id.id, id, len);
> +	attrs.switch_id.id_len = len;
> +
> +	if (dp->setup)
> +		return 0;
>  

I wonder what this is protecting against? I ran on a multi-switch tree
without these 2 lines and I didn't get anything like multiple
registration or things like that. What is the call path that would call
dsa_port_devlink_setup twice?

> +	switch (dp->type) {
> +	case DSA_PORT_TYPE_UNUSED:
> +		memset(dlp, 0, sizeof(*dlp));
> +		attrs.flavour = DEVLINK_PORT_FLAVOUR_UNUSED;

> +		devlink_port_attrs_set(dlp, &attrs);
> +		err = devlink_port_register(dl, dlp, dp->index);

These 2 lines are common everywhere. Could you move them out of the
switch-case statement?

> +		break;
> +	case DSA_PORT_TYPE_CPU:
> +		memset(dlp, 0, sizeof(*dlp));
> +		attrs.flavour = DEVLINK_PORT_FLAVOUR_CPU;
> +		devlink_port_attrs_set(dlp, &attrs);
> +		err = devlink_port_register(dl, dlp, dp->index);
> +		break;
> +	case DSA_PORT_TYPE_DSA:
> +		memset(dlp, 0, sizeof(*dlp));
> +		attrs.flavour = DEVLINK_PORT_FLAVOUR_DSA;
> +		devlink_port_attrs_set(dlp, &attrs);
> +		err = devlink_port_register(dl, dlp, dp->index);
> +		break;
> +	case DSA_PORT_TYPE_USER:
> +		memset(dlp, 0, sizeof(*dlp));
> +		attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
> +		devlink_port_attrs_set(dlp, &attrs);
> +		err = devlink_port_register(dl, dlp, dp->index);
> +		break;
> +	}
> +
> +	if (!err)
> +		dp->devlink_port_setup = true;
> +
> +	return err;
> +}
> +
> +static void dsa_port_teardown(struct dsa_port *dp)
> +{
>  	if (!dp->setup)
>  		return;
>  
>  	switch (dp->type) {
>  	case DSA_PORT_TYPE_UNUSED:
> -		devlink_port_unregister(dlp);
>  		break;
>  	case DSA_PORT_TYPE_CPU:
>  		dsa_port_disable(dp);
>  		dsa_tag_driver_put(dp->tag_ops);
> -		devlink_port_unregister(dlp);
>  		dsa_port_link_unregister_of(dp);
>  		break;
>  	case DSA_PORT_TYPE_DSA:
>  		dsa_port_disable(dp);
> -		devlink_port_unregister(dlp);
>  		dsa_port_link_unregister_of(dp);
>  		break;
>  	case DSA_PORT_TYPE_USER:
> -		devlink_port_unregister(dlp);
>  		if (dp->slave) {
>  			dsa_slave_destroy(dp->slave);
>  			dp->slave = NULL;
> @@ -389,6 +390,15 @@ static void dsa_port_teardown(struct dsa_port *dp)
>  	dp->setup = false;
>  }
>  
> +static void dsa_port_devlink_teardown(struct dsa_port *dp)
> +{
> +	struct devlink_port *dlp = &dp->devlink_port;
> +
> +	if (dp->devlink_port_setup)
> +		devlink_port_unregister(dlp);
> +	dp->devlink_port_setup = false;
> +}
> +
>  static int dsa_devlink_info_get(struct devlink *dl,
>  				struct devlink_info_req *req,
>  				struct netlink_ext_ack *extack)
> @@ -408,6 +418,7 @@ static const struct devlink_ops dsa_devlink_ops = {
>  static int dsa_switch_setup(struct dsa_switch *ds)
>  {
>  	struct dsa_devlink_priv *dl_priv;
> +	struct dsa_port *dp;
>  	int err;
>  
>  	if (ds->setup)
> @@ -433,6 +444,17 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  	if (err)
>  		goto free_devlink;
>  
> +	/* Setup devlink port instances now, so that the switch
> +	 * setup() can register regions etc, against the ports
> +	 */
> +	list_for_each_entry(dp, &ds->dst->ports, list) {
> +		if (dp->ds == ds) {
> +			err = dsa_port_devlink_setup(dp);
> +			if (err)
> +				goto unregister_devlink_ports;
> +		}
> +	}
> +
>  	err = dsa_switch_register_notifier(ds);
>  	if (err)
>  		goto unregister_devlink;

Need to use goto unregister_devlink_ports here.

> @@ -463,6 +485,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  
>  unregister_notifier:
>  	dsa_switch_unregister_notifier(ds);
> +unregister_devlink_ports:
> +	list_for_each_entry(dp, &ds->dst->ports, list)
> +		if (dp->ds == ds)
> +			dsa_port_devlink_teardown(dp);
>  unregister_devlink:
>  	devlink_unregister(ds->devlink);
>  free_devlink:
> @@ -474,6 +500,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  
>  static void dsa_switch_teardown(struct dsa_switch *ds)
>  {
> +	struct dsa_port *dp;
> +
>  	if (!ds->setup)
>  		return;
>  
> @@ -486,6 +514,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
>  		ds->ops->teardown(ds);
>  
>  	if (ds->devlink) {
> +		list_for_each_entry(dp, &ds->dst->ports, list)
> +			if (dp->ds == ds)
> +				dsa_port_devlink_teardown(dp);
>  		devlink_unregister(ds->devlink);
>  		devlink_free(ds->devlink);
>  		ds->devlink = NULL;
> -- 
> 2.28.0
> 
