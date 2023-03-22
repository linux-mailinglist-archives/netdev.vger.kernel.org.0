Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A286C4EF7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjCVPHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjCVPHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:07:18 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE6337725;
        Wed, 22 Mar 2023 08:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679497636; x=1711033636;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yZqq5Ey/D3oqpP0tAIQyzmJSJ0lVKiE9RfUsHTpt3WQ=;
  b=edCkaTu1jfYs0OWc6ovVxSXQTgBV9YKLCXE0BcIWFBefqZQHbubQeMhc
   Om11qMAtsav+tXItmrj3wFnem5wn17EDNnrSplEmWFYw2Kj9YB6ystpJ9
   tqDXvTTJhGzadi02ntHd6qMYu3g8wPOTW/Gues+uLizzjiE1aBlB7k1OG
   LRGsbJI/JRP+bdt/HHXk9WBRY7WQ0RHKh9plZ9SdnphxTnXrPvTuTPigH
   8I4Ex6Eg7Qp+l/c/3uOzKnYwDKJZwXjjAEFMnmHt9WIaJzJLrCI4IW5Cl
   ujupxYz1dpqZD21LXlDFXDjclInW/rF3CgeA4PvSvAJfr1RI9mnACTZ21
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="404121289"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="404121289"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 08:03:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="712252989"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="712252989"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2023 08:03:43 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pf005-007AoY-2N;
        Wed, 22 Mar 2023 17:03:41 +0200
Date:   Wed, 22 Mar 2023 17:03:41 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Zhang, Tianfei" <tianfei.zhang@intel.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Pagani, Marco" <marpagan@redhat.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBsYzZgonva5f3fB@smile.fi.intel.com>
References: <20230322143547.233250-1-tianfei.zhang@intel.com>
 <ZBsVWWe33FJgoj9A@smile.fi.intel.com>
 <BN9PR11MB54839A3B9CBE7BB679FBFE4CE3869@BN9PR11MB5483.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54839A3B9CBE7BB679FBFE4CE3869@BN9PR11MB5483.namprd11.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 02:59:21PM +0000, Zhang, Tianfei wrote:
> > -----Original Message-----
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Sent: Wednesday, March 22, 2023 10:49 PM
> > To: Zhang, Tianfei <tianfei.zhang@intel.com>
> > Cc: richardcochran@gmail.com; netdev@vger.kernel.org; linux-
> > fpga@vger.kernel.org; ilpo.jarvinen@linux.intel.com; Gomes, Vinicius
> > <vinicius.gomes@intel.com>; pierre-louis.bossart@linux.intel.com; Pagani, Marco
> > <marpagan@redhat.com>; Weight, Russell H <russell.h.weight@intel.com>;
> > matthew.gerlach@linux.intel.com; nico@fluxnic.net; Khadatare, RaghavendraX
> > Anand <raghavendrax.anand.khadatare@intel.com>
> > Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
> > 
> > On Wed, Mar 22, 2023 at 10:35:47AM -0400, Tianfei Zhang wrote:
> > > Adding a DFL (Device Feature List) device driver of ToD device for
> > > Intel FPGA cards.
> > >
> > > The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> > > as PTP Hardware clock(PHC) device to the Linux PTP stack to
> > > synchronize the system clock to its ToD information using phc2sys
> > > utility of the Linux PTP stack. The DFL is a hardware List within
> > > FPGA, which defines a linked list of feature headers within the device
> > > MMIO space to provide an extensible way of adding subdevice features.

...

> > > +	dt->ptp_clock = ptp_clock_register(&dt->ptp_clock_ops, dev);
> > > +	if (IS_ERR_OR_NULL(dt->ptp_clock))
> > > +		return dev_err_probe(dt->dev, PTR_ERR_OR_ZERO(dt->ptp_clock),
> > > +				     "Unable to register PTP clock\n");
> > > +
> > > +	return 0;
> > 
> > Can be as simple as:
> > 
> > 	ret = PTR_ERR_OR_ZERO(dt->ptp_clock);
> > 	return dev_err_probe(dt->dev, ret, "Unable to register PTP clock\n");
> 
>             This should be :
>            ret = PTR_ERR_OR_ZERO(dt->ptp_clock);
>            if (ret)
>                     return dev_err_probe(dt->dev, ret, "Unable to register PTP clock\n");
>            return 0;

It depends how you treat the NULL from ptp_clock_register() and why driver will
be still bound to the device even if it doesn't provide PTP facility.

Either way you need to thing about this error handling and come up with
something that you can explain why it's done this way and not another.

>         But this will be introduced one more local variable "ret" in this function.

Is it a problem?

-- 
With Best Regards,
Andy Shevchenko


