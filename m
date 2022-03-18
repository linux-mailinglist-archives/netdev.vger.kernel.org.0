Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4867D4DDF1D
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbiCRQeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiCRQeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:34:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A033C2274D7;
        Fri, 18 Mar 2022 09:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647621185; x=1679157185;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=3fSyc4Om/f1qBKQ2VmW5hQXw8+AXsDQPbICnqW/FgR0=;
  b=SQYRr4wrWgQ6XVcfwOPFv9wvNsxbX5FYw9cBThf+WG1+/OJHR1EF27RZ
   QwmN8JNoxFCeLjP9eVCllQFT82JZG9q4U09FVzW4F/1Qh1QLGou/H/jHM
   PoPDI+Fg/h4x/C6EhjBqf2+wu80z931apdivkqk3yQlzmxLmBBqWBZQHT
   DsJTwjCt+ivv/2N3ZahCESP75UGG+iSuO+A3X6sslZpfb24OXWwCjpRp3
   zyrjJ5UoQtw9L+lh0cUobyNWlnme3enQ6qd6SVB5XdBYOvQNgFxRHrGDP
   Iu7ug8XlfC9dELV8gHawI7ddA1f2MFHeZqGWPQJIJeaiZCzF8tkKvsVLf
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="320379302"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="320379302"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:33:02 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="635813087"
Received: from smile.fi.intel.com ([10.237.72.59])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:32:56 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nVFWT-002KJ7-A0;
        Fri, 18 Mar 2022 18:32:17 +0200
Date:   Fri, 18 Mar 2022 18:32:17 +0200
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
Subject: Re: [PATCH 6/6] net: sfp: add support for fwnode
Message-ID: <YjS0EbKOUb4Q++mF@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
 <20220318160059.328208-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318160059.328208-7-clement.leger@bootlin.com>
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

On Fri, Mar 18, 2022 at 05:00:52PM +0100, Clément Léger wrote:
> Add support to retrieve a i2c bus in sfp with a fwnode. This support
> is using the fwnode API which also works with device-tree and ACPI.
> For this purpose, the device-tree and ACPI code handling the i2c
> adapter retrieval was factorized with the new code. This also allows
> i2c devices using a software_node description to be used by sfp code.

> +		i2c = fwnode_find_i2c_adapter_by_node(np);

Despite using this, I believe you may split this patch to at least two where
first one is preparatory (converting whatever parts is possible to fwnode
(looks like ACPI case may be optimized) followed by this change.

-- 
With Best Regards,
Andy Shevchenko


