Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F0C4DE101
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240086AbiCRSZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238890AbiCRSZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:25:36 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE3CEDF2F;
        Fri, 18 Mar 2022 11:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647627857; x=1679163857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=wpIS4R443Nce+z/m4Mc2carJ5M+X4U+cG/spU7q0iJU=;
  b=MBb9M1/vjaNnIKvN8fe/t0g9yLSMQIIQPN9P1ZDa04QpAGJGvLqt6Py1
   cikhcOfVVFRghA2XRHU4B2rHS4Vl27I+LONmU/hWbE6rPNTfkeBZejJpw
   wNFWsnvA0uQVcSeGNAD4qMdC3F/oR2IIl5G67CPhyJGqnu1l6SAINfFbl
   c+JPjC7e/ENy2GJds6OYdGuWPn9NXInB9OWMhUwnfhQUb5LyAH7YzEk6y
   z6OHoa66psdsHwIXZKuTdKybAoFGs6KzqSiWE6H135jaH6z+h70/PFkeO
   67hCvIKfenfSIyYGWfzxUX9t+UzsIwHN8TiLnXvAPRaZ4dB8BcY0JUpvJ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="320404134"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="320404134"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 11:12:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="550837171"
Received: from smile.fi.intel.com ([10.237.72.59])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 11:12:08 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nVH4S-002Ns0-Qz;
        Fri, 18 Mar 2022 20:11:28 +0200
Date:   Fri, 18 Mar 2022 20:11:28 +0200
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
Subject: Re: [PATCH 4/6] i2c: mux: pinctrl: remove CONFIG_OF dependency and
 use fwnode API
Message-ID: <YjTLUL0umgw+ZVTU@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
 <20220318160059.328208-5-clement.leger@bootlin.com>
 <YjSzPeWpcR/SSX1a@smile.fi.intel.com>
 <20220318175630.0e235f41@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318175630.0e235f41@fixe.home>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 05:56:30PM +0100, Clément Léger wrote:
> Le Fri, 18 Mar 2022 18:28:45 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> > On Fri, Mar 18, 2022 at 05:00:50PM +0100, Clément Léger wrote:
> > > In order to use i2c muxes with software_node when added with a struct
> > > mfd_cell, switch to fwnode API. The fwnode layer will allow to use this
> > > with both device_node and software_node.  
> > 
> > > -	struct device_node *np = dev->of_node;
> > > +	struct fwnode_handle *np = dev_fwnode(dev);  
> > 
> > np is now a misleading name. Use fwnode.
> 
> Ok I thought np was meaning "node pointer" and it looked like okay to
> avoid avoid a diff that is too huge. But agreed, I'll rename that.

It's rather "in practice", np stands for "OF node pointer", while fwnode
stands for "firmware node handle".

-- 
With Best Regards,
Andy Shevchenko


