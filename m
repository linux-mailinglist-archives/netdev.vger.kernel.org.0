Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7EF55237B
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244815AbiFTSE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241816AbiFTSE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:04:27 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23C618E3B;
        Mon, 20 Jun 2022 11:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655748267; x=1687284267;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bfLyLudysCu4pFYVjfqnWUFHXxxapEagnc+LD8U/m58=;
  b=DT9+so9g2ymLvA1fe17AmoH+qVFpDE45yGDniAZzjKaY1l/QIntfLCpJ
   J5NzdTBMoOBD/Ags8mGoNqKmx1U8Vy59qxf8zycAD0Al1i0kTwPawzpzZ
   NP2MWVwj17kGtLzz27JF1qT/e5EaERxOgcUxZHj6aNsZ8y9Es/0KYP+JW
   ZHrvEi+bY8S72CvYsfl1fFIQntZJZG1ATxWF8evXxwI1Ut3/rLP52p7WX
   qyrNm7ccRCgvZXTsSFzeKSSyeivdo9gDMJngNWanrHR/ShGwNZoPAsFl3
   c/gmDOfUS9pOyqZrSeQ/AN2nBRZiH1+A062KxvRsYvwplQsdoK00b/ekF
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="280681848"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="280681848"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 11:04:26 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="620192479"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 11:04:21 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3Ll4-000kbC-3V;
        Mon, 20 Jun 2022 21:04:18 +0300
Date:   Mon, 20 Jun 2022 21:04:17 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 11/12] net: dsa: mv88e6xxx: switch to
 device_/fwnode_ APIs
Message-ID: <YrC2oV1FiRKwir6u@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-12-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-12-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:24PM +0200, Marcin Wojtas wrote:
> In order to support both ACPI and DT, modify the generic
> DSA code to use device_/fwnode_ equivalent routines.
> No functional change is introduced by this patch.

...

> @@ -6962,16 +6963,16 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
>  	struct dsa_mv88e6xxx_pdata *pdata = mdiodev->dev.platform_data;
>  	const struct mv88e6xxx_info *compat_info = NULL;
>  	struct device *dev = &mdiodev->dev;
> -	struct device_node *np = dev->of_node;
> +	struct fwnode_handle *fwnode = dev->fwnode;

Forgot to mention: dev_fwnode() or respective device_property_ API, please.

-- 
With Best Regards,
Andy Shevchenko


