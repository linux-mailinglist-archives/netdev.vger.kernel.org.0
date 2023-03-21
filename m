Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AD46C3237
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCUNC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjCUNC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:02:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784954C6D0;
        Tue, 21 Mar 2023 06:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679403767; x=1710939767;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mU0w+6vPoa9VqcdZNUiRI7ygCVjLzagiuS87ndt2sjQ=;
  b=EP3J2ZDAwdw7UmuRbTbDrUXOkLoF7Mwc+ZNYi2UWvAehQ7p3QgzF3no3
   qE673+XPORh/ifOpUY+UWsKoNalNxWEyA4jJ7FCcoPsdkhO1yxIVF0eCw
   hWeU2fUWwqWjmOApR5aRWEaCX3T9o/IaBjtEpfT4357PdhjFG0IMus0rb
   b41zjRgFadCGb6r1y5kcJEjdw4PWDNlIxdTILEeMCL7ps7EXOdSx2LoDy
   MwIRz30MocbT/6BbwTbs/N6ypYN8kabyyuOGfF4eYowJGLEMdW8QCMKKB
   aZrIchTkdhdDO46XWwI2C6QnsArn5eiBoS8IxugbXs/xkhobF0zGN26Xk
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="338967430"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="338967430"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 06:02:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="658761799"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="658761799"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 21 Mar 2023 06:02:43 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pebdR-006idl-2M;
        Tue, 21 Mar 2023 15:02:41 +0200
Date:   Tue, 21 Mar 2023 15:02:41 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Nicolas Pitre <nico@fluxnic.net>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Tianfei Zhang <tianfei.zhang@intel.com>,
        netdev@vger.kernel.org, linux-fpga@vger.kernel.org,
        ilpo.jarvinen@linux.intel.com, russell.h.weight@intel.com,
        matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBmq8cW36e8pRZ+s@smile.fi.intel.com>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
 <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
 <ZBDPKA7968sWd0+P@hoboy.vegasvil.org>
 <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
 <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
 <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
 <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
 <40o4o5s6-5oo6-nn03-r257-24po258nq0nq@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40o4o5s6-5oo6-nn03-r257-24po258nq0nq@syhkavp.arg>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 04:53:07PM -0400, Nicolas Pitre wrote:
> On Mon, 20 Mar 2023, Richard Cochran wrote:
> 
> > On Mon, Mar 20, 2023 at 09:43:30AM -0400, Nicolas Pitre wrote:
> > 
> > > Alternatively the above commit can be reverted if no one else 
> > > cares. I personally gave up on the idea of a slimmed down Linux kernel a 
> > > while ago.
> > 
> > Does this mean I can restore the posix clocks back into the core
> > unconditionally?
> 
> This only means _I_ no longer care. I'm not speaking for others (e.g. 
> OpenWRT or the like) who might still rely on splitting it out.
> Maybe Andy wants to "fix" it?

I would be a good choice, if I have an access to the hardware at hand to test.
That said, I think Richard himself can try to finish that feature (optional PTP)
and on my side I can help with reviewing the code (just Cc me when needed).

-- 
With Best Regards,
Andy Shevchenko


