Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68AD4BEABC
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 20:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbiBUSMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:12:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiBUSL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:11:26 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C274113D23;
        Mon, 21 Feb 2022 10:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645466509; x=1677002509;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=sPqVwHORdIP+AJZPTEY+6JZ34Z1q+gC7lEhyccc3C9s=;
  b=idiQfNBX1z29w3l1eyKvEtrDaFm7KOkZ0BPo/FaXf6XKNp0vkKs+6DOS
   WT5qgwJQrulGfijUv+ibkRnn6g6wjAWUJvwtfYt+mpiEKl+GyDx5SlkzU
   /wUR2kTusnsI/5jvxRVJdSPcNvfPcIhjYaLap6wCAwHoAkDUH5+jX/eyT
   uyzgpsGfPqAo5q4eKKxH29mqe4Sih0U3MU4JKwdGK79o1bdsP+vwhlF7F
   9fteBMvTIotyu/6GHCdT8jqJUxDDP0/ZolDlUeVnOudd6NONpZBWjjHxp
   uyDM6pJhpGUXmRv+opFdcISA5lAwHZ0/2u5fjCTfQCq3ztt+Nw8elIV6s
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="235091315"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="235091315"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 10:01:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="547418308"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 10:01:44 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMCzU-006sBe-2m;
        Mon, 21 Feb 2022 20:00:52 +0200
Date:   Mon, 21 Feb 2022 20:00:51 +0200
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
Subject: Re: [RFC 06/10] i2c: fwnode: add fwnode_find_i2c_adapter_by_node()
Message-ID: <YhPTUxvaqd+1/23a@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221162652.103834-7-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:26:48PM +0100, Clément Léger wrote:
> Add fwnode_find_i2c_adapter_by_node() which allows to retrieve a i2c
> adapter using a fwnode. Since dev_fwnode() uses the fwnode provided by
> the of_node member of the device, this will also work for devices were
> the of_node has been set and not the fwnode field.

...

> +static int fwnode_dev_or_parent_node_match(struct device *dev, const void *data)
> +{

> +	if (dev_fwnode(dev) == data)
> +		return 1;

This can use corresponding match function from bus.h.

> +	if (dev->parent)
> +		return dev_fwnode(dev->parent) == data;
> +
> +	return 0;

The same.

> +}

-- 
With Best Regards,
Andy Shevchenko


