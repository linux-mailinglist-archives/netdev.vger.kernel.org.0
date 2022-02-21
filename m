Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375AF4BEA1B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiBUSCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:02:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiBUSAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:00:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256E813F42;
        Mon, 21 Feb 2022 09:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645465942; x=1677001942;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=OrEv3F6FgsXMjqfDJb0SV1SRw1/e6rm3avDRQpoxBMw=;
  b=ePu6voQ5Ls9nnCOG+jpW7TLNde1JAnHHkhZuMX2cinkHFemtX+bZd/I0
   c4xgyFG8pGRf8no8vtMmQhmOOG6ZBOhcwqXP3Z64V5K7cgPHnRQvcamN0
   wJuRV0Nmu7r32n7js8C3R1RlQw4fL56JHgmXFR4fLmzu8HIlZD5wVLO7s
   ocdcPG1dwY3/F/PVz1hFA0kOzSjMXpylqky2tR9SAIl5YQ9MnhZWeGcW4
   93dH66qaxqWS4j39GHy+m0u+hB10emIOihcCo2ZPTqNXVoUdBrxaVA5L5
   yOXBo61ys29yDvky1rZdrnHwzI7I3RQXEHc98j9ZMDW4/lklydWh6aCuA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251306658"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="251306658"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:52:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="627436451"
Received: from smile.fi.intel.com ([10.237.72.59])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:52:17 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMCqL-006s3s-4m;
        Mon, 21 Feb 2022 19:51:25 +0200
Date:   Mon, 21 Feb 2022 19:51:24 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
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
Subject: Re: [RFC 04/10] property: add a callback parameter to
 fwnode_property_match_string()
Message-ID: <YhPRHJWGYKjM4kk7@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-5-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221162652.103834-5-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:26:46PM +0100, Clément Léger wrote:
> This function will be modified to be reused for
> fwnode_property_read_string_index(). In order to avoid copy/paste of
> existing code, split the existing function and pass a callback that
> will be executed once the string array has been retrieved.
> 
> In order to reuse this function with other actions.

...

> +int fwnode_property_match_string(const struct fwnode_handle *fwnode,
> +				 const char *propname, const char *string)
> +{
> +	return fwnode_property_string_match(fwnode, propname,
> +					    match_string_callback,

> +					    (void *)string);

We want to keep const qualifier.

> +}

-- 
With Best Regards,
Andy Shevchenko


