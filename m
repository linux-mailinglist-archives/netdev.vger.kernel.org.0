Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4F84DDEDC
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbiCRQ1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239197AbiCRQ0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:26:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC346173F40;
        Fri, 18 Mar 2022 09:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647620690; x=1679156690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=TBKjAhVgKP/U4iexVGMziTlOqxmtOpmBiEFBCLgyO5M=;
  b=IyUzd6PRKJimweN4/A0erGJOFlssYw1UaJAt4GStT9zfmBCptVc3gJO4
   Vb4Ovp+kL4qlK6Ce/I1fFlYIwcljJg6N6E3XttyO4G2pXvcBKa2DVJF9l
   9GQLVg6fTagtvfg0MwmTeECOHjFqCL2ylA4aFbBDhIMDvWlVEMnfQdZ3D
   GiPawGqwnIXDK8DYlCELblbmAZokRIgR2vVEsmyCq6nHMH+5Nit180dWK
   F4WTLTcvoESwY9UQTopkbfqU23qsKIVrAZB2g/U6APxDVaiZvXafWp2oJ
   5xLXzLjcVmlGoO2xhwZUbUf+O9Po83RbiDq9jAklsVwCCetXDvM5HCEV5
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="237112862"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="237112862"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:24:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="499309044"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:24:45 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nVFOX-002K6V-Bd;
        Fri, 18 Mar 2022 18:24:05 +0200
Date:   Fri, 18 Mar 2022 18:24:05 +0200
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
Subject: Re: [PATCH 0/6] introduce fwnode in the I2C subsystem
Message-ID: <YjSyJaUa+uuv3+zc@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318160059.328208-1-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 05:00:46PM +0100, Clément Léger wrote:
> In order to allow the I2C subsystem to be usable with fwnode, add
> some functions to retrieve an i2c_adapter from a fwnode and use
> these functions in both i2c mux and sfp. ACPI and device-tree are
> handled to allow these modifications to work with both descriptions.
> 
> This series is a subset of the one that was first submitted as a larger
> series to add swnode support [1]. In this one, it will be focused on
> fwnode support only since it seems to have reach a consensus that
> adding fwnode to subsystems makes sense.
> 
> [1] https://lore.kernel.org/netdev/YhPSkz8+BIcdb72R@smile.fi.intel.com/T/

I have got two copies (?) of the series. I have no idea which one is correct.
So, please take care of it and send the version we are supposed to review.

-- 
With Best Regards,
Andy Shevchenko


