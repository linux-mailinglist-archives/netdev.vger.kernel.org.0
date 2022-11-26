Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDFE6396E7
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 16:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiKZPoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 10:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiKZPoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 10:44:08 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E0EF7A;
        Sat, 26 Nov 2022 07:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669477447; x=1701013447;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=TYZva1qhZaDDzx7ssD6565IlpCg24ayIFbcaC7tY8Tc=;
  b=afaV5wieNPUjxu0caJC6JdakAXQOqaG+mJP11E9sBOfdvxW/FCdDmoSq
   uszGkpjb5nf3De548PRwyr8tA0gjYkdzZijT5eCkTI9MaUL7wuDEK5FNd
   DHxxEedinEuG50v1wryTy8tuS2GfxLpPE0gycyCpJAkwIvhrwC+gn8YZP
   vqGEDAZKZz5uKM+4zWczaOB+RJUrHWVl1v9DiPG/G1MsaoSG/5NPhScuG
   JcNKVf2MOUenZM/iTJdfierEPIRgcSWgA7CVeokYeMdRvPe3t3BpDN/xD
   57LDEQ+dPBOukc9S9pF7aZDWoHCdzdL+VmK/32YN6VaBwDrOJGpoZ9vaZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10543"; a="376747252"
X-IronPort-AV: E=Sophos;i="5.96,196,1665471600"; 
   d="scan'208";a="376747252"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2022 07:44:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10543"; a="620587303"
X-IronPort-AV: E=Sophos;i="5.96,196,1665471600"; 
   d="scan'208";a="620587303"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 26 Nov 2022 07:43:54 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@intel.com>)
        id 1oyxLL-000Bco-1n;
        Sat, 26 Nov 2022 17:43:51 +0200
Date:   Sat, 26 Nov 2022 17:43:51 +0200
From:   Andy Shevchenko <andriy.shevchenko@intel.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Jonathan Cameron <jic23@kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        alsa-devel@alsa-project.org, linux-staging@lists.linux.dev,
        linux-pwm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        linux-serial@vger.kernel.org, linux-input@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-watchdog@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-actions@lists.infradead.org, linux-gpio@vger.kernel.org,
        Angel Iglesias <ang.iglesiasg@gmail.com>,
        gregkh@linuxfoundation.org, linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Purism Kernel Team <kernel@puri.sm>,
        patches@opensource.cirrus.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Wolfram Sang <wsa@kernel.org>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-integrity@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 000/606] i2c: Complete conversion to i2c_probe_new
Message-ID: <Y4I0N3KpU/LSJYpd@smile.fi.intel.com>
References: <20221118224540.619276-1-uwe@kleine-koenig.org>
 <20221122185818.3740200d@jic23-huawei>
 <20221122201654.5rdaisqho33buibj@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221122201654.5rdaisqho33buibj@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 09:16:54PM +0100, Uwe Kleine-König wrote:
> On Tue, Nov 22, 2022 at 06:58:18PM +0000, Jonathan Cameron wrote:

> > Queued all of the below:
> > with one tweaked as per your suggestion and the highlighted one dropped on basis
> > I was already carrying the equivalent - as you pointed out.
> > 
> > I was already carrying the required dependency.
> > 
> > Includes the IIO ones in staging.
> > 

> > p.s. I perhaps foolishly did this in a highly manual way so as to
> > also pick up Andy's RB.  So might have dropped one...
> 
> You could have done:
> 
> 	H=$(git rev-parse @)
> 	b4 am -P 49-190 20221118224540.619276-1-uwe@kleine-koenig.org
> 	git am ...
> 	git filter-branch -f --msg-filter "grep -v 'Signed-off-by: Jonathan'; echo 'Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>'; echo 'Signed-off-by: Jonathan Cameron <jic23@kernel.org>'" $H..
> 
> (untested, but you get the idea).

That's, for example (just last from the history as is), how I usually do it
(tested):

 git filter-branch --msg-filter 'sed -e "/Signed-off-by: Andy Shevchenko/ a Tested-by: Daniel Scally <dan.scally@ideasonboard.com>"' -f HEAD~4..HEAD


-- 
With Best Regards,
Andy Shevchenko


