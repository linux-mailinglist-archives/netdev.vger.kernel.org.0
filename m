Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A40C2632EB
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbgIIQEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730872AbgIIQDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:03:42 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F3CC061757;
        Wed,  9 Sep 2020 09:03:41 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c8so3218219edv.5;
        Wed, 09 Sep 2020 09:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gSugijFx5V7kzK4lMfXIO1khu0NC9tFrZN8JKiYCPrs=;
        b=gcOkmgf3/euQ/71l8vtiwdsCusWd8/ewwfsjfCgg3O2bK19ySZOiAODe50EVUbCyi/
         aqA5bonY2kp0frFfOxgUEOW2I1/wnA+D1aEwVWlD3IX9sTIjKiu8FCQFKFPG+3m5/NZH
         AM1QQf5ElvTAEqP+PfC5ZsxKU+q9+RSkrZiQr2eJQxQPcE1uxUP6m+j2UvM04J+jZX8u
         f2x4nxgjG1j1SfovV3GSl2hxXgt/JuFwOGsmfJNlPGTyk3Sf0pJsBAJcT8Ir2R8Ovsh7
         4YDwWeqRQ4yBdbGO6DeGojZGxt4Epkl1enawI8jNfZuPLRfbgDCOi72U+df8ogGP6qfe
         W6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gSugijFx5V7kzK4lMfXIO1khu0NC9tFrZN8JKiYCPrs=;
        b=jcdDWknRs/mOBjDB5esh/bibkgJTOBLu1cj1lHtX31vG6Wt7L22r6rapOJLoPIDHbi
         HOCGr3TMm/8w0y5JEpPp697VSw6SLhqUBuE/hZ8MUoU0rWQOQ3S+qos2cwUg8A2Voto9
         oCcFLTuI7gCttPu4X2be2pWz82tTrJXrK5iG4CgXTRTbBVuHs0ESRlXa1qa1G+nOYDYv
         NIvWkV3nbRfO0DwkAZ2lAHOtXltiWQrXYKPSa5JaDSkUQOfNNRg44Sq5jTILyYNECF5H
         iSdsnLHnMc9lOYoeDrLbhTBciL72gbam/mM0VPjgc6jjyHXDIXPIM6OuH/79bGBgV/2k
         b/og==
X-Gm-Message-State: AOAM533Hg7mvIZgjMjG34IG066A11IC2wHf1yHUc5PutzImlNTIt27Hm
        54ocI5cC1ttIJrqwUNOCDT0=
X-Google-Smtp-Source: ABdhPJxq4yyeFtzTm7k62Y9Ml2VFgIKy66ho+z1E3G6HQz+kDJjS/DjS8XCAxj/0STt8kVUtWqTYCA==
X-Received: by 2002:aa7:d558:: with SMTP id u24mr4885402edr.336.1599667419694;
        Wed, 09 Sep 2020 09:03:39 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id m4sm3102244ejn.31.2020.09.09.09.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:03:39 -0700 (PDT)
Date:   Wed, 9 Sep 2020 19:03:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: b53: Report VLAN table occupancy via
 devlink
Message-ID: <20200909160337.fp4i5hhryr2by54m@skbuf>
References: <20200909043235.4080900-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909043235.4080900-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 09:32:34PM -0700, Florian Fainelli wrote:
> We already maintain an array of VLANs used by the switch so we can
> simply iterate over it to report the occupancy via devlink.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/b53/b53_common.c | 59 ++++++++++++++++++++++++++++++--
>  drivers/net/dsa/b53/b53_priv.h   |  1 +
>  drivers/net/dsa/bcm_sf2.c        |  8 ++++-
>  3 files changed, 65 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 26fcff85d881..a1527665e817 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -977,6 +977,53 @@ int b53_get_sset_count(struct dsa_switch *ds, int port, int sset)
>  }
>  EXPORT_SYMBOL(b53_get_sset_count);
>  
> +enum b53_devlink_resource_id {
> +	B53_DEVLINK_PARMA_ID_VLAN_TABLE,

Parma is a city in Italy, maybe PARAM?

> +};
> +
> +static u64 b53_devlink_vlan_table_get(void *priv)
> +{
> +	struct b53_device *dev = priv;
> +	unsigned int i, count = 0;

Could you make count an u64 as well, since you're returning it into an
u64?

> +	struct b53_vlan *vl;
> +
> +	for (i = 0; i < dev->num_vlans; i++) {
> +		vl = &dev->vlans[i];
> +		if (vl->members)
> +			count++;
> +	}
> +
> +	return count;
> +}
> +
> +int b53_setup_devlink_resources(struct dsa_switch *ds)
> +{
> +	struct devlink_resource_size_params size_params;
> +	struct b53_device *dev = ds->priv;
> +	int err;
> +
> +	devlink_resource_size_params_init(&size_params, dev->num_vlans,
> +					  dev->num_vlans,
> +					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
> +
> +	err = dsa_devlink_resource_register(ds, "VLAN", dev->num_vlans,
> +					    B53_DEVLINK_PARMA_ID_VLAN_TABLE,
> +					    DEVLINK_RESOURCE_ID_PARENT_TOP,
> +					    &size_params);
> +	if (err)
> +		goto out;
> +
> +	dsa_devlink_resource_occ_get_register(ds,
> +					      B53_DEVLINK_PARMA_ID_VLAN_TABLE,
> +					      b53_devlink_vlan_table_get, dev);
> +
> +	return 0;
> +out:
> +	dsa_devlink_resources_unregister(ds);
> +	return err;
> +}
> +EXPORT_SYMBOL(b53_setup_devlink_resources);
> +
>  static int b53_setup(struct dsa_switch *ds)
>  {
>  	struct b53_device *dev = ds->priv;
> @@ -992,8 +1039,10 @@ static int b53_setup(struct dsa_switch *ds)
>  	b53_reset_mib(dev);
>  
>  	ret = b53_apply_config(dev);
> -	if (ret)
> +	if (ret) {
>  		dev_err(ds->dev, "failed to apply configuration\n");
> +		return ret;
> +	}
>  
>  	/* Configure IMP/CPU port, disable all other ports. Enabled
>  	 * ports will be configured with .port_enable
> @@ -1012,7 +1061,12 @@ static int b53_setup(struct dsa_switch *ds)
>  	 */
>  	ds->vlan_filtering_is_global = true;
>  
> -	return ret;
> +	return b53_setup_devlink_resources(ds);
> +}
> +
> +static void b53_teardown(struct dsa_switch *ds)
> +{
> +	dsa_devlink_resources_unregister(ds);
>  }
>  
>  static void b53_force_link(struct b53_device *dev, int port, int link)
> @@ -2141,6 +2195,7 @@ static int b53_get_max_mtu(struct dsa_switch *ds, int port)
>  static const struct dsa_switch_ops b53_switch_ops = {
>  	.get_tag_protocol	= b53_get_tag_protocol,
>  	.setup			= b53_setup,
> +	.teardown		= b53_teardown,
>  	.get_strings		= b53_get_strings,
>  	.get_ethtool_stats	= b53_get_ethtool_stats,
>  	.get_sset_count		= b53_get_sset_count,
> diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
> index e942c60e4365..c55c0a9f1b47 100644
> --- a/drivers/net/dsa/b53/b53_priv.h
> +++ b/drivers/net/dsa/b53/b53_priv.h
> @@ -328,6 +328,7 @@ void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
>  void b53_br_fast_age(struct dsa_switch *ds, int port);
>  int b53_br_egress_floods(struct dsa_switch *ds, int port,
>  			 bool unicast, bool multicast);
> +int b53_setup_devlink_resources(struct dsa_switch *ds);
>  void b53_port_event(struct dsa_switch *ds, int port);
>  void b53_phylink_validate(struct dsa_switch *ds, int port,
>  			  unsigned long *supported,
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 3263e8a0ae67..723820603107 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -936,7 +936,12 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
>  	b53_configure_vlan(ds);
>  	bcm_sf2_enable_acb(ds);
>  
> -	return 0;
> +	return b53_setup_devlink_resources(ds);
> +}
> +
> +static void bcm_sf2_sw_teardown(struct dsa_switch *ds)
> +{
> +	dsa_devlink_resources_unregister(ds);
>  }
>  
>  /* The SWITCH_CORE register space is managed by b53 but operates on a page +
> @@ -1073,6 +1078,7 @@ static int bcm_sf2_sw_get_sset_count(struct dsa_switch *ds, int port,
>  static const struct dsa_switch_ops bcm_sf2_ops = {
>  	.get_tag_protocol	= b53_get_tag_protocol,
>  	.setup			= bcm_sf2_sw_setup,
> +	.teardown		= bcm_sf2_sw_teardown,
>  	.get_strings		= bcm_sf2_sw_get_strings,
>  	.get_ethtool_stats	= bcm_sf2_sw_get_ethtool_stats,
>  	.get_sset_count		= bcm_sf2_sw_get_sset_count,
> -- 
> 2.25.1
> 

Thanks,
-Vladimir
