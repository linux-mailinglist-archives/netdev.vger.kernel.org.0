Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40E74DDEE8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238954AbiCRQ3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239242AbiCRQ2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:28:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFD218EE8A;
        Fri, 18 Mar 2022 09:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647620805; x=1679156805;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dDLLHCtUYDvBeiYbbGUjNuufSA+5n9Dp9C2i70UwuFA=;
  b=I1r3vVn7dCo/q3W8iBKQNxUWuGXq0/OiiAO8KJWEthjFLNzFmHVJYEqg
   CD1xgUnEo9VaKVweIvyYpW8jYJAsPbBW3TyVqtHCgugCs5uIVvovVoArO
   1wLdsg4l3Jx1s6zKcLkdcv+v/gLm0z469m24OUBnhmChowG4ybfC3q9Jj
   juntF6z6EErZ6Bx+EHZAIIuTgA7eknR/wLBp1Dm6hdTWUqhTa7/ZTq/7x
   iyYWxd54rCCMKRtvOLF/zzXFXxlkFJtXA93bMQAH+kPrOyU/Q5+fiwcCJ
   52PglRQGeB8hsAZzJbMFYKwFkjrX7MeV2aPfI7PjdbRYThHEvf5dweRxJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="257356584"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="257356584"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:26:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="550797917"
Received: from smile.fi.intel.com ([10.237.72.59])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:26:40 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nVFQP-002K9d-3x;
        Fri, 18 Mar 2022 18:26:01 +0200
Date:   Fri, 18 Mar 2022 18:26:00 +0200
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
Message-ID: <YjSymEpNH8vnkQ+L@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
 <20220318160059.328208-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318160059.328208-2-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 05:00:47PM +0100, Clément Léger wrote:
> Add fwnode_property_read_string_index() function which allows to
> retrieve a string from an array by its index. This function is the
> equivalent of of_property_read_string_index() but for fwnode support.

...

> +	values = kcalloc(nval, sizeof(*values), GFP_KERNEL);
> +	if (!values)
> +		return -ENOMEM;
> +
> +	ret = fwnode_property_read_string_array(fwnode, propname, values, nval);
> +	if (ret < 0)
> +		goto out;
> +
> +	*string = values[index];
> +out:
> +	kfree(values);

Here is UAF (use after free). How is it supposed to work?

-- 
With Best Regards,
Andy Shevchenko


