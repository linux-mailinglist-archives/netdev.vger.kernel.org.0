Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53764C1AD2
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243737AbiBWSVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:21:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiBWSVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:21:01 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAD149FB8;
        Wed, 23 Feb 2022 10:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645640434; x=1677176434;
  h=date:from:to:subject:message-id:references:mime-version:
   in-reply-to;
  bh=rzWuqP3ripaxaKT5al8d/OWqGFWPXcQTpyLBZCqsFqE=;
  b=aE7fMxpLR9cxMhAsHhdWfgjjsOnjnsUTa6gQg9JjA0UJfa6nzUytNqQm
   zub/mdHiKB8FAHQFrXRvvVdf7Wseyf2IU2JRyx2nOTkzN/fycJY51WD2K
   VAmRMPyCp4NRKeP1Y7xJO1tpwjKQcayt/Lrxof5qmnqoY8laPyOJPsdc/
   IXGYlO1okwN6aU5bNnpqXA5U+ooFO/57w9sb9Pr1pl/kj3QWFMfZkj+AJ
   3cr2pTd3gBM73s9UA9y/hM3H41OU81LanqIahiagi4OiJgcxs6ypJMGU8
   FhAcXhAqi7mXdhMMCEg5LFweS4IJ8Oj9qFBMkyzKlX4Wfk2NaDm7sPT6W
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="250876053"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="250876053"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 10:20:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="506020647"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 10:20:28 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMwEi-007WTl-Ku;
        Wed, 23 Feb 2022 20:19:36 +0200
Date:   Wed, 23 Feb 2022 20:19:36 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Enrico Weigelt <info@metux.net>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YhZ6uAmGcVjvNZy6@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <YhPOxL++yhNHh+xH@smile.fi.intel.com>
 <20220222173019.2380dcaf@fixe.home>
 <YhZI1XImMNJgzORb@smile.fi.intel.com>
 <20220223161150.664aa5e6@fixe.home>
 <YhZRtads7MGzPEEL@smile.fi.intel.com>
 <YhZxyluc7gYhmAuh@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhZxyluc7gYhmAuh@sirena.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 05:41:30PM +0000, Mark Brown wrote:
> On Wed, Feb 23, 2022 at 05:24:37PM +0200, Andy Shevchenko wrote:

...

> There were separately some issues with people trying to create
> completely swnode based enumeration mechanisms for things that required
> totally independent code for handling swnodes which seemed very
> concerning but it's not clear to me if that's what's going on here.

This is the case IIUC.

-- 
With Best Regards,
Andy Shevchenko


