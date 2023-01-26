Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C63267CF04
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 15:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjAZOzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 09:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjAZOzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 09:55:11 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF75E10D6;
        Thu, 26 Jan 2023 06:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674744909; x=1706280909;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FEz9CKiJLBT5n3U8/37EjkzAAVbIya2ifV79yxHOuys=;
  b=Uuefvi0KoYyPbgq/7sq0jGOI3iKKruit/mYWJJQUvVaLq4C0PhWMtsAz
   B+6MS5/bXhjZqmHc2ZbPgxyiIFCN4d/KwZ7ze8Q4Lcx2DkMQ/IMM5QXsS
   0yrM58uUr5+gjZ2RfMVIndY8eVsWLLYOV3wDkpdjDBvJLPwFj+K/8Pisb
   JKPw1d7gJMQzl05QBpkAS3IC7UH6jXPkIsyQmoeLR/wNdaFFt5fJS2gxp
   VbAGTLNhavvO9uNgUM5XkJpOmsrDKRezRLVKM1AFRUe3LlwHXiKw/SUJb
   9NBVgr9qmb74O+AxRH63iHLgSh7WkgpnTO5jaxHfkvyznyLi7ssuSuonk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="328926205"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="328926205"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 06:24:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="908241064"
X-IronPort-AV: E=Sophos;i="5.97,248,1669104000"; 
   d="scan'208";a="908241064"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jan 2023 06:24:27 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pL3Av-00FRH9-0v;
        Thu, 26 Jan 2023 16:24:25 +0200
Date:   Thu, 26 Jan 2023 16:24:24 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] at86rf230: convert to gpio descriptors
Message-ID: <Y9KNGPTGK/Os4gZe@smile.fi.intel.com>
References: <20230126135215.3387820-1-arnd@kernel.org>
 <20230126151243.3acc1fe2@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126151243.3acc1fe2@xps-13>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 03:12:43PM +0100, Miquel Raynal wrote:
> arnd@kernel.org wrote on Thu, 26 Jan 2023 14:51:23 +0100:

...

> > There are no remaining in-tree users of the platform_data,
> > so this driver can be converted to using the simpler gpiod
> > interfaces.
> > 
> > Any out-of-tree users that rely on the platform data can
> > provide the data using the device_property and gpio_lookup
> > interfaces instead.

[...]

> > @@ -1682,7 +1650,7 @@ MODULE_DEVICE_TABLE(spi, at86rf230_device_id);
> >  static struct spi_driver at86rf230_driver = {
> >  	.id_table = at86rf230_device_id,
> >  	.driver = {
> > -		.of_match_table = of_match_ptr(at86rf230_of_match),
> > +		.of_match_table = at86rf230_of_match,linux-gnueabihf embed a C library which relies on kernel headers (for example, to provide an open API which translates to an open syscall), for exam
> 
> Looks like an unrelated change? Or is it a consequence of "not having
> any in-tree users of platform_data" that plays a role here?

This enables this driver to work on ACPI-based platforms without needed the
legacy platform data. Dunno if it will be ever the case, but still...

> Anyhow, the changes in the driver look good, so:
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

Thank you!

-- 
With Best Regards,
Andy Shevchenko


