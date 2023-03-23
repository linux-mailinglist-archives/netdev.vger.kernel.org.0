Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B376C6A4C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjCWOAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbjCWN7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 09:59:44 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E542A994;
        Thu, 23 Mar 2023 06:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679579957; x=1711115957;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ol1bIa7wEV9vbITom6nkTdY3Vf2gYZ26qp63G/qf9uw=;
  b=WoH6Q8vOac/q7/YRgSYATOukaynsQRcNyl97uCfwovTogF1ZBYBw1EUn
   y94hUOdJ+MIO6yI4gaAmHPAiMMonOfA2cu1E4jXTAaODkp4ITlwzl7BRH
   uob7l6LJmRs4QE6ifdABWEh9GLN4SEoAG92YPlO+voBNoK39KhZx715Qr
   g43/qYeH0ATLaPbfrtHl9o/KPGzEy8mUK0vY3ep3sgk6iwOw8PSBUfze0
   tYFYsTTw1POBagNJIouKNCYLfmolWJ3QhueYH24aNdduapmYQblFuuGKr
   U0rrLibTrpeK0sYhDkrjPeRhS8VywHptFQqXA///XzVSLzCphA4Xc6tVV
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425772877"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="425772877"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 06:59:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="675717822"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="675717822"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 23 Mar 2023 06:59:10 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfLTA-007WzI-0c;
        Thu, 23 Mar 2023 15:59:08 +0200
Date:   Thu, 23 Mar 2023 15:59:07 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 1/7] software node: allow named software
 node to be created
Message-ID: <ZBxbKxAcAKznIVJ2@smile.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8F-00Dvnf-Sm@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pex8F-00Dvnf-Sm@rmk-PC.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 11:59:55AM +0000, Russell King wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Allow a named software node to be created, which is needed for software
> nodes for a fixed-link specification for DSA.

...

> +fwnode_create_named_software_node(const struct property_entry *properties,
> +				  const struct fwnode_handle *parent,
> +				  const char *name)
>  {
>  	struct fwnode_handle *fwnode;
>  	struct software_node *node;
> @@ -930,6 +931,7 @@ fwnode_create_software_node(const struct property_entry *properties,
>  		return ERR_CAST(node);
>  
>  	node->parent = p ? p->node : NULL;
> +	node->name = name;

The same question stays as before: how can we be sure that the name is unique
and we won't have a collision?

>  	fwnode = swnode_register(node, p, 1);
>  	if (IS_ERR(fwnode))
> @@ -937,6 +939,14 @@ fwnode_create_software_node(const struct property_entry *properties,
>  
>  	return fwnode;
>  }
> +EXPORT_SYMBOL_GPL(fwnode_create_named_software_node);


-- 
With Best Regards,
Andy Shevchenko


