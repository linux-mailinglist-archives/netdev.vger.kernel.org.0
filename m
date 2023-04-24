Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70D56ECDFA
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbjDXN2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjDXN2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:28:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825266581;
        Mon, 24 Apr 2023 06:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682342904; x=1713878904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eu+Sc69LokNp8v1mXzo9rhtStDP7QgA7iPHkwOtsBFs=;
  b=RHrHEJJM3qTGN/v/fSVRncb+hBF/kGag4f6NFxtz9h1Q1qk9M5w2XD7a
   e2kkjXKsGOzfxXzKTUpIdwGzdNoLf4phzQjI4EGQuDrv26XaFRQfqTdF9
   cHDOgD8TFD1aWYbN1A7YH7MDzl9YmyvqxX5w17cWgj/gogP1YSeh7Gmpx
   1zF1KEaBa3vm95mQ5iGHG0M/1MdyKO/r40PhwXcdrs4BlH+X7unAEjMea
   rOKHCQ8j0jHousV1oTThyidkWxQWZTwmG4awQpUeAJyD4PwouzqNjYxh7
   PqTnu9zIpBPyVEGKcwpwJddvBqeygrRlbWRq9t9ttZo5EwqhdteKrgaTG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="326059795"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="326059795"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 06:28:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="757700335"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="757700335"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008.fm.intel.com with ESMTP; 24 Apr 2023 06:28:03 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pqwEb-004X6c-37;
        Mon, 24 Apr 2023 16:28:01 +0300
Date:   Mon, 24 Apr 2023 16:28:01 +0300
From:   'Andy Shevchenko' <andriy.shevchenko@linux.intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ZEaD4ZTfiEALEaSV@smile.fi.intel.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-3-jiawenwu@trustnetic.com>
 <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
 <000201d9758b$aa3193a0$fe94bae0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201d9758b$aa3193a0$fe94bae0$@trustnetic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 10:31:09AM +0800, Jiawen Wu wrote:
> > > +++ b/include/linux/platform_data/i2c-dw.h
> > 
> > No way we need this in a new code.
> 
> Do I have to rely on OF or ACPI if I need these parameters?
> 
> > 
> > > +struct dw_i2c_platform_data {
> > > +	void __iomem *base;
> > 
> > You should use regmap.
> 
> The resource was mapped on the ethernet driver. How do I map it again
> with I2C offset?

Create a regmap MMIO and pass the pointer to the child driver via existing
private members. See how MFD drivers do that, e.g. intel_soc_pmic_*.c.

> > > +	unsigned int flags;
> > > +	unsigned int ss_hcnt;
> > > +	unsigned int ss_lcnt;
> > > +	unsigned int fs_hcnt;
> > > +	unsigned int fs_lcnt;
> > 
> > No, use device properties.
> > 
> > > +};

-- 
With Best Regards,
Andy Shevchenko


