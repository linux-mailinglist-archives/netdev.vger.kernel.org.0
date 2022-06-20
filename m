Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF15522B8
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239172AbiFTRZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiFTRZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:25:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48891EAC9;
        Mon, 20 Jun 2022 10:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655745941; x=1687281941;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BbgzJRwAzZfGnN6+fsR430k9tPyCeFnjovUdsDb86xE=;
  b=dKWdKAyLLj1Meq1T7fN60BxFeHP5t3A7NFxqvOOR9R2fVdbgaEPeUpx5
   /DG+Y3Ux90UN3HVCWddaQicO5q1h5Y3INAJEtTT7s0HUiIZIat+4LuOaE
   awACAJSkJA1scih7VE5a1k9tQxqk+sG2gjENoDbIy3ZoX9Ho2UbF3yHjp
   QHrrlwcFpmsqOKG1Xfud2hNnw+Ngn4a4is2B9/xo0SRIY9ToyJdL1e14B
   Kn7icifMaokzOdzW5BU22LSoG/yPbObPRg9+0Y5XeaSkIk9RZHT7AGhYF
   ZEESiSwhVv3Vu85oJg6UwGmG+SKoSN5VTPkTc9eCHaoGjrOmKbXHd5gUG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="366267955"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="366267955"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:25:41 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="729475487"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:25:37 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3L9Z-000kYr-9m;
        Mon, 20 Jun 2022 20:25:33 +0300
Date:   Mon, 20 Jun 2022 20:25:33 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 01/12] net: phy: fixed_phy: switch to fwnode_
 API
Message-ID: <YrCtjWSokoFPKwoJ@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-2-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-2-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:14PM +0200, Marcin Wojtas wrote:
> This patch allows to use fixed_phy driver and its helper
> functions without Device Tree dependency, by swtiching from
> of_ to fwnode_ API.

...

> -#ifdef CONFIG_OF_GPIO

Nice to see this gone, because it's my goal as well.

...

> -static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
> +static struct gpio_desc *fixed_phy_get_gpiod(struct fwnode_handle *fwnode)
>  {
> -	struct device_node *fixed_link_node;
> +	struct fwnode_handle *fixed_link_node;
>  	struct gpio_desc *gpiod;

> -	if (!np)
> +	if (!fwnode)
>  		return NULL;

Can be dropped altogether. The following call will fail and return the same.

> -	fixed_link_node = of_get_child_by_name(np, "fixed-link");
> +	fixed_link_node = fwnode_get_named_child_node(fwnode, "fixed-link");
>  	if (!fixed_link_node)
>  		return NULL;
>  
> @@ -204,7 +203,7 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
>  	 * Linux device associated with it, we simply have obtain
>  	 * the GPIO descriptor from the device tree like this.
>  	 */
> -	gpiod = fwnode_gpiod_get_index(of_fwnode_handle(fixed_link_node),

> +	gpiod = fwnode_gpiod_get_index(fixed_link_node,
>  				       "link", 0, GPIOD_IN, "mdio");

Can fit one line now.

>  	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
>  		if (PTR_ERR(gpiod) != -ENOENT)
> @@ -212,20 +211,14 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
>  			       fixed_link_node);
>  		gpiod = NULL;
>  	}
> -	of_node_put(fixed_link_node);
> +	fwnode_handle_put(fixed_link_node);
>  
>  	return gpiod;
>  }

...

> -	of_node_get(np);
> -	phy->mdio.dev.of_node = np;
> +	fwnode_handle_get(fwnode);
> +	phy->mdio.dev.fwnode = fwnode;

Please, use device_set_node().

...

> +	fwnode_handle_put(phy->mdio.dev.fwnode);

dev_fwnode()

-- 
With Best Regards,
Andy Shevchenko


