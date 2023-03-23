Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DAF6C6ED2
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 18:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjCWR2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 13:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjCWR2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 13:28:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1856E19A6;
        Thu, 23 Mar 2023 10:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679592497; x=1711128497;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UIc1/ThXJFz9AMzhIAkZvLIUVpbC0O3PE+XwWoKlAGM=;
  b=nQ1zsANUptFMhb8iqzcdbB1fOgFVKlguLruH9AGnwtk7e8LXGaHPnrBW
   SSDIrTU6FsbRgZxCOgfg8AbJSSsGe6BRVwptK0MvYnzvY+BvdRubprotp
   uaoKY1JImZrqXIVjOfC2k4kST7o7gsJqbnbo7lfoY9XOWaQWzddTA99/o
   nG4yR8wzph30V0oLrl6M1c2nOI4J+FPhrzo2rW+xjWIXcUjy7uWEFnY2P
   72QsMY0FqQM/Fk2v5HIttH5SXY9Uo4Ww9X6KBHPCQ32fdwnbPsJHQnneN
   DjBoHaaWS9RDktRbo33l1MHu75xakrhTVPpwRg3Yq7HXcKOqRXA/bo3Da
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="337074673"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="337074673"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2023 10:28:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="746822505"
X-IronPort-AV: E=Sophos;i="5.98,285,1673942400"; 
   d="scan'208";a="746822505"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 23 Mar 2023 10:28:09 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pfOjP-007agn-1P;
        Thu, 23 Mar 2023 19:28:07 +0200
Date:   Thu, 23 Mar 2023 19:28:07 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <ZByMJxwwPTG2qGO8@smile.fi.intel.com>
References: <E1pex8Q-00Dvnr-5y@rmk-PC.armlinux.org.uk>
 <ZBxcGXSVe0dlzKZb@smile.fi.intel.com>
 <ZBxiqJo470A7bkig@shell.armlinux.org.uk>
 <ZBxkZYXrfugz0gYw@smile.fi.intel.com>
 <ZBxm3XrQAfnmbHoF@shell.armlinux.org.uk>
 <ZBxpeLOmTMzqVTRV@smile.fi.intel.com>
 <ZBxu4FvyO2JDwmMq@shell.armlinux.org.uk>
 <ZBx7xxs0NQV25cFn@shell.armlinux.org.uk>
 <ZBx/mO/z3t3dQCAx@smile.fi.intel.com>
 <ZByHKXgIuNI683kN@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZByHKXgIuNI683kN@shell.armlinux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 05:06:49PM +0000, Russell King (Oracle) wrote:

OK, you are right as always, I'm wrong. Case closed. Thank you.

-- 
With Best Regards,
Andy Shevchenko


