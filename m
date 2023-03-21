Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C5F6C3481
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjCUOkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCUOkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:40:42 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86BB4FF3E;
        Tue, 21 Mar 2023 07:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679409640; x=1710945640;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=avpreVCD80HFe/L5FAIWCSKjQRcBaDRFvTfb+adZrLE=;
  b=WAlsjCR2TnZUD1Gq5B7Yu5s0Rinh26okDz1PHWkHH0AkxR19HrGn53QD
   z4qBpQqfH7JA4kttuu42briZUzX7knt6QQiQS7CThr3xMjrNdw88FKoEV
   DdRV80GO1o7CkQMIVodv/aAdfMmd93r/KqBd67aylQW4dud6CjYDwQrkf
   KWTnuC878zk/N51zxS7CTu5+72jJ/RhMWUODcWpgMgvsMxDYoTHwiHE5D
   VB6F+7ZXAG8/mZ9RbxBJlmeMpk28XKaPFeEg1XRHQxXai1ttd+R8SvwIt
   1Oa5mQr1etJ7FOb+U7D3p4u/PxZpQ13vpekmROWgTLj54ROScxxT9fgCM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="403834435"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="403834435"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2023 07:40:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="770660439"
X-IronPort-AV: E=Sophos;i="5.98,279,1673942400"; 
   d="scan'208";a="770660439"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Mar 2023 07:40:03 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ped9d-006l52-2m;
        Tue, 21 Mar 2023 16:40:01 +0200
Date:   Tue, 21 Mar 2023 16:40:01 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Zhang, Tianfei" <tianfei.zhang@intel.com>
Cc:     Nicolas Pitre <nico@fluxnic.net>,
        Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBnBwa/MLdH0ep3g@smile.fi.intel.com>
References: <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
 <ZBDPKA7968sWd0+P@hoboy.vegasvil.org>
 <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
 <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
 <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
 <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
 <40o4o5s6-5oo6-nn03-r257-24po258nq0nq@syhkavp.arg>
 <ZBmq8cW36e8pRZ+s@smile.fi.intel.com>
 <BN9PR11MB548394F8DCE5AEC4DA553EB6E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB548394F8DCE5AEC4DA553EB6E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:28:15PM +0000, Zhang, Tianfei wrote:
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Sent: Tuesday, March 21, 2023 9:03 PM
> > To: Nicolas Pitre <nico@fluxnic.net>
> > On Mon, Mar 20, 2023 at 04:53:07PM -0400, Nicolas Pitre wrote:
> > > On Mon, 20 Mar 2023, Richard Cochran wrote:
> > > > On Mon, Mar 20, 2023 at 09:43:30AM -0400, Nicolas Pitre wrote:
> > > >
> > > > > Alternatively the above commit can be reverted if no one else
> > > > > cares. I personally gave up on the idea of a slimmed down Linux
> > > > > kernel a while ago.
> > > >
> > > > Does this mean I can restore the posix clocks back into the core
> > > > unconditionally?
> > >
> > > This only means _I_ no longer care. I'm not speaking for others (e.g.
> > > OpenWRT or the like) who might still rely on splitting it out.
> > > Maybe Andy wants to "fix" it?
> > 
> > I would be a good choice, if I have an access to the hardware at hand to test.
> > That said, I think Richard himself can try to finish that feature (optional PTP) and on
> > my side I can help with reviewing the code (just Cc me when needed).
> 
> Handle NULL as a valid parameter (object) to their respective APIs looks a
> good idea, but this will be a big change and need fully test for all devices,

Since it's core change, so a few devices that cover 100% APIs that should
handle optional PTP. I don't think it requires enormous work.

> we can add it on the TODO list.

It would be a good idea.

> So for this patch, are you agree we continue use the existing
> ptp_clock_register() API, for example, change my driver like below:

The problem is that it will increase the technical debt.
What about sending with NULL handled variant together with an RFC/RFT
that finishes the optional PTP support?

>       dt->ptp_clock = ptp_clock_register(&dt->ptp_clock_ops, dev);

	ret = PTR_ERR_OR_ZERO(...);
	if (ret)
		return ...

?

>       if (IS_ERR_OR_NULL(dt->ptp_clock))
>               return dev_err_probe(dt->dev, IS_ERR_OR_NULL(dt->ptp_clock),
>                                    "Unable to register PTP clock\n");


-- 
With Best Regards,
Andy Shevchenko


