Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F65D4C1131
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 12:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239824AbiBWLYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 06:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234705AbiBWLYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 06:24:05 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCDE8AE55;
        Wed, 23 Feb 2022 03:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645615418; x=1677151418;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=FWh5Gytqdi+aFrZmALBpSFgdHMcuZf1UxHQVAqFhB5s=;
  b=Lfd/d5VFioq8U76Z6qj/v1k5QV/dLpXva1E7xYTPBUEOhjljVCAdKtU9
   rug7bkovoW5kFYvhrGaV8P352YAjlvcMndxqY3VMr2lH+7M6e/3FVnMCV
   wZF/biA+fdrZW2K4l4fKYsUln/EHReoBoODToZ6Ach85JCDRTiRra8R2k
   9YbF+4DuXp/B+GbMVFmy+/sbLO2NgHlKoi6QOcrtTf86VlB0jkUNexFXd
   UE4W+nNx+HZWVn1rN91SPV6V0BWF5TcsGibInGGHCfhv+4jPUN+QAucom
   nab+qoJRG+g2njtIYLon/Tl1ApU/awm1p6SjZgwu/aTBIKEZfc7pjMVOR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="231915372"
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="231915372"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 03:23:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,390,1635231600"; 
   d="scan'208";a="532642764"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 03:23:33 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMpjF-007OHE-SU;
        Wed, 23 Feb 2022 13:22:41 +0200
Date:   Wed, 23 Feb 2022 13:22:41 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Hans de Goede <hdegoede@redhat.com>
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
Subject: Re: [RFC 10/10] net: sfp: add support for fwnode
Message-ID: <YhYZAc5+Q1rN3vhk@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-11-clement.leger@bootlin.com>
 <YhPSkz8+BIcdb72R@smile.fi.intel.com>
 <20220222142513.026ad98c@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220222142513.026ad98c@fixe.home>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 02:25:13PM +0100, Clément Léger wrote:
> Le Mon, 21 Feb 2022 19:57:39 +0200,
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> a écrit :
> 
> > On Mon, Feb 21, 2022 at 05:26:52PM +0100, Clément Léger wrote:
> > > Add support to retrieve a i2c bus in sfp with a fwnode. This support
> > > is using the fwnode API which also works with device-tree and ACPI.
> > > For this purpose, the device-tree and ACPI code handling the i2c
> > > adapter retrieval was factorized with the new code. This also allows
> > > i2c devices using a software_node description to be used by sfp code.  
> > 
> > If I'm not mistaken this patch can even go separately right now, since all used
> > APIs are already available.
> 
> This patches uses fwnode_find_i2c_adapter_by_node() which is introduced
> by "i2c: fwnode: add fwnode_find_i2c_adapter_by_node()" but they can
> probably be contributed both in a separate series.

I summon Hans into the discussion since I remember he recently refactored
a bit I2C (ACPI/fwnode) APIs. Also he might have an idea about entire big
picture approach with this series based on his ACPI experience.

-- 
With Best Regards,
Andy Shevchenko


