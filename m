Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE2F4DDF35
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbiCRQle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbiCRQld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:41:33 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FE0016E7FE;
        Fri, 18 Mar 2022 09:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647621614; x=1679157614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=eaKEzVQMhfgLDl4Dn7Ns+XQwteg23fcUytz1ubC+krQ=;
  b=VA2VukCQbuGXeXNx5FRAtZaM9NUS+MvxYS4nXL8LQGD9Rl3hr8v6+LY5
   jHqwz5lcPsGS7oy5lKNv/VC/UgtdJu2dDDJSvNTVVWh/Hn8LyjqZo0VUj
   WyUSPImxiAqKykp6oU6zOhNPel2LeG2FhmZx9rR2hcKm9r/PEme+P3p0R
   k2lDHjLPGDeW0yPwoyvaCr9ZUx8mqWRoHymQrSkxvsEvWpa5WfB2EI9IS
   v0OBbLxntO3uviov63R9CQX7G7PgVXc7BXy/pwFJ8RjZu6pgXRPTqwAnf
   oBFiUSbEed0MDWYjVY4Vk9fNYtxw8PO1ihNWQonb6pdXlyVW8Zl992cN0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="254731873"
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="254731873"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:30:25 -0700
X-IronPort-AV: E=Sophos;i="5.90,192,1643702400"; 
   d="scan'208";a="513948960"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 09:30:19 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nVFTw-002KFh-0v;
        Fri, 18 Mar 2022 18:29:40 +0200
Date:   Fri, 18 Mar 2022 18:29:39 +0200
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
Subject: Re: [PATCH 2/6] i2c: fwnode: add fwnode_find_i2c_adapter_by_node()
Message-ID: <YjSzc/Eek8NvqEN6@smile.fi.intel.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
 <20220318160059.328208-3-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220318160059.328208-3-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 05:00:48PM +0100, Clément Léger wrote:
> Add fwnode_find_i2c_adapter_by_node() which allows to retrieve a i2c
> adapter using a fwnode. Since dev_fwnode() uses the fwnode provided by
> the of_node member of the device, this will also work for devices were
> the of_node has been set and not the fwnode field.

> +	/* For ACPI device node, we do not want to match the parent */

Why?
Neither commit message nor this comment does not answer to this question.

-- 
With Best Regards,
Andy Shevchenko


