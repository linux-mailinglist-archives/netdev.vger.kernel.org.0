Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3604E2466
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346364AbiCUKeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiCUKeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:34:07 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2B8F3F88;
        Mon, 21 Mar 2022 03:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647858762; x=1679394762;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=uW0WOPC73UEvk44rb2hIDfT3tEzB1IDsf3NCkLUv0rE=;
  b=J3WH2DC4l++3oDpMURG+Z9t4ovQWuTQNMeMzAJCWN08WkVdgYL1zKGIB
   Q0zxrcBMMyHS2KpcDusRSORt9cqBmQkQ4w1efTmeHco+1BcbmXH1G8erB
   mgYHnWkU8DNK9Kzyx3L9ZlzAtKP4bItAwxIuYVdkdunhzDQKWzP17oQzW
   wmah6Ew96VwybQvHfhq9lg+7WO3gZLDvcPlMfg+coc+v9uUo2y5Je1KLl
   XkfBgYEYf+4pYYteAnluQTkTwUNUPfti0eAer1uOYhIJaqYADt9/+y9I4
   4LCm7v4NdsN26+LKiSzmX2bbMVrm7OXptvC8nemAY3DpJTRbJ2sM9lems
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10292"; a="255083998"
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="255083998"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 03:32:42 -0700
X-IronPort-AV: E=Sophos;i="5.90,198,1643702400"; 
   d="scan'208";a="582820837"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 03:32:36 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nWFKQ-003p5V-A4;
        Mon, 21 Mar 2022 12:31:58 +0200
Date:   Mon, 21 Mar 2022 12:31:58 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] property: add fwnode_property_read_string_index()
Message-ID: <YjhUHjeqL2UpB0Gm@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
 <20220318160059.328208-2-clement.leger@bootlin.com>
 <YjSymEpNH8vnkQ+L@smile.fi.intel.com>
 <20220318174912.5759095f@fixe.home>
 <YjTK4UW7DwZ0S3QY@smile.fi.intel.com>
 <20220321084921.069c688e@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220321084921.069c688e@fixe.home>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 08:49:21AM +0100, Clément Léger wrote:
> Le Fri, 18 Mar 2022 20:09:37 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> > On Fri, Mar 18, 2022 at 05:49:12PM +0100, Clément Léger wrote:
> > > Le Fri, 18 Mar 2022 18:26:00 +0200,
> > > Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :  
> > > > On Fri, Mar 18, 2022 at 05:00:47PM +0100, Clément Léger wrote:  

...

> > > > > +	values = kcalloc(nval, sizeof(*values), GFP_KERNEL);
> > > > > +	if (!values)
> > > > > +		return -ENOMEM;
> > > > > +
> > > > > +	ret = fwnode_property_read_string_array(fwnode, propname, values, nval);
> > > > > +	if (ret < 0)
> > > > > +		goto out;
> > > > > +
> > > > > +	*string = values[index];
> > > > > +out:
> > > > > +	kfree(values);    
> > > > 
> > > > Here is UAF (use after free). How is it supposed to work?  
> > > 
> > > values is an array of pointers. I'm only retrieving a pointer out of
> > > it.  
> > 
> > I see, thanks for pointing out.
> > 
> > Nevertheless, I don't like the idea of allocating memory in this case.
> > Can we rather add a new callback that will provide us the necessary
> > property directly?
> > 
> 
> IMHO, it would indeed be better. However,
> fwnode_property_match_string() also allocates memory to do the same
> kind of operation. Would you also like a callback for this one ?

But matching string will need all of them to cover all possible cases.
So, it doesn't rely on the certain index and needs allocation anyway.

-- 
With Best Regards,
Andy Shevchenko


