Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1514BE9FD
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiBURvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 12:51:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiBURth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 12:49:37 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12A3117A;
        Mon, 21 Feb 2022 09:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645465634; x=1677001634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xpY7J7nzp9IuhJIMZ851JicROXwhZoI/6l0O+HJAEo8=;
  b=GBRxerXbwmzIP4iSg2vDwF1rgS+bXrKjjW86h+5XXOKyFr2M7xlV77Tr
   UDWFGbejeu4bBU8U+R5NxXN5Wewuw0gFzqxjjd9d8EgLqLjryN73UMXkJ
   ms/UQSoWuKBsDIca70N3xbJKlAmS6wCfN+hapGXJthbZq8tP7iYkAjmjs
   pC/Pbm0jQ6N/+F4hjYCRHwuJgxSfhRKszd/GpHGtafe51y/kqDQhL0t1l
   qd1AIR4CY6f4RV6Z8r8N6o9P3FHpUlRKyrRYD/nNpZfa9Gfe7QU9b2eWt
   8GoNf901lpihBfs0hPbYrbrlxj3Dw1AcbTwPfBUkuuxXoaivgGwCm2KnO
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="235089559"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="235089559"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:47:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="505162234"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:47:05 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMClJ-006rzr-6u;
        Mon, 21 Feb 2022 19:46:13 +0200
Date:   Mon, 21 Feb 2022 19:46:12 +0200
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
Subject: Re: [RFC 02/10] property: add fwnode_get_match_data()
Message-ID: <YhPP5GWt7XEv5xx8@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221162652.103834-3-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:26:44PM +0100, Clément Léger wrote:
> Add fwnode_get_match_data() which is meant to be used as
> device_get_match_data for fwnode_operations.

...

> +const void *fwnode_get_match_data(const struct fwnode_handle *fwnode,
> +				  const struct device *dev)
> +{
> +	const struct of_device_id *match;
> +
> +	match = fwnode_match_node(fwnode, dev->driver->of_match_table);
> +	if (!match)
> +		return NULL;
> +
> +	return match->data;
> +}

It's OF-centric API, why it has fwnode prefix? Can it leave in drivers/of instead?


-- 
With Best Regards,
Andy Shevchenko


