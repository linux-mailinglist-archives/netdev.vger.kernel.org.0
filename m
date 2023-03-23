Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DF36C6A63
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjCWOES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjCWOER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:04:17 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732515B87;
        Thu, 23 Mar 2023 07:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679580193; x=1711116193;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w1iJnhrbjO7fEVtRH9WTuWf5xNORLGNEgeXpHdhkKlU=;
  b=jZCCAv3MvmPWen/ACFY4Dafet2ovzCCwoLoRZ8jmsLQcxl6PqQrJZQdn
   oifxetQXYczAu3UNb9JFd1i+lavBvTkKmhIkRHr92WSkFPZ+HFVQxMCLG
   66/y3F1pgTnjj4Ybu83QCHpPRLy5r82188NOWsvnf3dV1hzjvyvWY/w3g
   u2+6uC7Vu95ejnN0NIjd+IntfJPmoP6tq6m6+yxM/iGlW9A3uDDmcfZuq
   nV6kl2eIx1psqjCHnT7S7vL0cC1Zn5bJt7ANcjtdmbG2byx/5tPXzGYF2
   wyiC5YzPG1HWvRKdrUteRxuSh5aK/I1kedCvsVSP8DBKEXpjAO9Rp5mrt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425774278"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="425774278"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 07:03:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="675719703"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="675719703"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007.jf.intel.com with ESMTP; 23 Mar 2023 07:03:07 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfLWz-007X3w-1o;
        Thu, 23 Mar 2023 16:03:05 +0200
Date:   Thu, 23 Mar 2023 16:03:05 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
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
Subject: Re: [PATCH RFC net-next 3/7] net: dsa: use fwnode_get_phy_mode() to
 get phy interface mode
Message-ID: <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 12:00:06PM +0000, Russell King (Oracle) wrote:
> In preparation for supporting the use of software nodes to setup
> phylink, switch DSA to use fwnode_get_phy_mode() to retrieve the
> phy interface mode, rather than using of_get_phy_mode() which is
> DT specific.

...

> +	struct fwnode_handle *fwnode;

> +	fwnode = of_fwnode_handle(dp->dn);

	const struct fwnode_handle *fwnode = of_fwnode_handle(dp->dn);

?

-- 
With Best Regards,
Andy Shevchenko


