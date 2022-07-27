Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C325827D0
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiG0Nha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiG0Nh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:37:29 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920BD165A4;
        Wed, 27 Jul 2022 06:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658929048; x=1690465048;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6h6fbl/fcUw8hVmup+Sa8ghAZqz2tmJ91kwrtvsGaRg=;
  b=MX+4QzeTBMp8vwC640sWvEFn+lUWdOqb75X+k29Gt5/BSxnppTv/t68X
   D07a9Ecah2HZ/ClJ3p5RGqoqP86d2TgsOQAhcRnldzryMDEqmAbGpsLbF
   91zTsFAfTTVu8kqnE7ZrBKsTts7JssRdyrR+61B5dWM4hxBKVSZV9JRla
   QVUqTfzH9YAgQGgJlC+k0HL8qFy3s7ONovvPsolHRl5ieWywQVWDHYYcb
   22eetKcFAe/2T0j43+TJKsj1iujoIszH6hv0gvhKkpdnKahPw4Nr1D0Vq
   odu4KGaqKQ84AvJMaHDgF+dXVCFRRaPKSGGkSWETKOr8vAkPZpSaQOt3R
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="374532498"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="374532498"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 06:37:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="846270199"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 06:37:22 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oGhDz-001cc7-0Y;
        Wed, 27 Jul 2022 16:37:19 +0300
Date:   Wed, 27 Jul 2022 16:37:18 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH v3 8/8] net: dsa: mv88e6xxx: switch to
 device_/fwnode_ APIs
Message-ID: <YuE/jsHMgDcKKEff@smile.fi.intel.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-9-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727064321.2953971-9-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 08:43:21AM +0200, Marcin Wojtas wrote:
> In order to support both DT and ACPI in future, modify the
> mv88e6xx driver  code to use device_/fwnode_ equivalent routines.
> No functional change is introduced by this patch.

...

>  static int mv88e6xxx_probe(struct mdio_device *mdiodev)
>  {
>  	struct dsa_mv88e6xxx_pdata *pdata = mdiodev->dev.platform_data;

> +	struct fwnode_handle *fwnode = dev_fwnode(&mdiodev->dev);

Move this...

>  	const struct mv88e6xxx_info *compat_info = NULL;
>  	struct device *dev = &mdiodev->dev;
> -	struct device_node *np = dev->of_node;

...here as

	struct fwnode_handle *fwnode = dev_fwnode(dev);

>  	struct mv88e6xxx_chip *chip;
>  	int port;
>  	int err;

> +	if (fwnode)

Redundant check.

> +		compat_info = device_get_match_data(dev);
> +	else if (pdata) {
>  		compat_info = pdata_device_get_match_data(dev);

	compat_info - device_get_match_data(dev);
	if (!compat_info && pdata)
		compat_info = pdata_device_get_match_data(dev);

...

> +		if (fwnode)
> +			device_property_read_u32(dev, "eeprom-length",
> +						 &chip->eeprom_len);
>  		else
>  			chip->eeprom_len = pdata->eeprom_len;

Can be done w/o conditional

		chip->eeprom_len = pdata->eeprom_len;
		device_property_read_u32(dev, "eeprom-length", &chip->eeprom_len);

-- 
With Best Regards,
Andy Shevchenko


