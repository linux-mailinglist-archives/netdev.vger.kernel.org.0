Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117375FA107
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 17:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJJPVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiJJPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 11:21:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351F872FC5
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665415306; x=1696951306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RvbHurQc6i7ZqXrYSbT2LbUynrdSg4B8OwwRy2RgEeM=;
  b=TWR9WFJpC7USEVV+c82QaUxPS52GAgFYQGnq2D/E3Lsa4vDeAPNNBByY
   DBPsu6d3+44JL8tXnxsYqfdWzAHciDPHhvngHWSbbJRghTcHvwKuwUtZo
   jr0i5Jp09HU8tStxA0qT/20Baa2M9SzM1ABf6bRxa5QuYaIDjL+7jmBA7
   jvwacBChnBFLKiweZ+BRLYDi9P6K94J99D2F8GdLAoa3iCxhSG5LPmXtX
   MgH37XQ4OEgqJ6mmZxPPMfgfBHRyY6P3LPZzldaJNbGAgcoeFdlbvKk3g
   /ejXIaQdjTPMwiCMxVj9x/VdmjL5JBHCDfeTMQCMVySqwGxf89K6ENE1L
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="330720448"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="330720448"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 08:21:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10496"; a="730575040"
X-IronPort-AV: E=Sophos;i="5.95,173,1661842800"; 
   d="scan'208";a="730575040"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga002.fm.intel.com with ESMTP; 10 Oct 2022 08:21:41 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ohub5-004vGx-2q;
        Mon, 10 Oct 2022 18:21:39 +0300
Date:   Mon, 10 Oct 2022 18:21:39 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "Kancharla, Sreehari" <sreehari.kancharla@linux.intel.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        ricardo.martinez@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next 2/2] net: wwan: t7xx: Add NAPI support
Message-ID: <Y0Q4gwO1uyHFN0XT@smile.fi.intel.com>
References: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com>
 <20220909163500.5389-2-sreehari.kancharla@linux.intel.com>
 <CAMZdPi8KdWCke5s03Bvy_4NZcDsgp+jPW5dqvCHyiU2C==tsmw@mail.gmail.com>
 <40146bed-6547-f9f0-b7cf-e47f628c4dc8@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40146bed-6547-f9f0-b7cf-e47f628c4dc8@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 07:52:49PM +0530, Kancharla, Sreehari wrote:
> On 9/12/2022 6:23 PM, Loic Poulain wrote:
> > On Fri, 9 Sept 2022 at 18:40, Sreehari Kancharla
> > <sreehari.kancharla@linux.intel.com> wrote:

...

> > >          if (!rxq->que_started) {
> > >                  atomic_set(&rxq->rx_processing, 0);
> > > -               dev_err(dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
> > > -               return;
> > > +               dev_err(rxq->dpmaif_ctrl->dev, "Work RXQ: %d has not been started\n", rxq->index);
> > > +               return work_done;
> > >          }
> > > 
> > > -       ret = pm_runtime_resume_and_get(dpmaif_ctrl->dev);
> > > -       if (ret < 0 && ret != -EACCES)
> > > -               return;
> > > +       if (!rxq->sleep_lock_pending) {
> > > +               ret = pm_runtime_resume_and_get(rxq->dpmaif_ctrl->dev);
> > AFAIK, polling is not called in a context allowing you to sleep (e.g.
> > performing a synced pm runtime operation).
> 
> Device will be in resumed state when NAPI poll is invoked from IRQ context,
> but host/driver can trigger RPM suspend to device. so we are using pm_runtime_resume_and_get
> here to prevent runtime suspend.

If it's known that device is always in power on state here, there is no need to
call all this, but what you need is to bump the reference counter. Perhaps you
need pm_runtime_get_noresume(). I.o.w. find the proper one and check that is
not sleeping.

-- 
With Best Regards,
Andy Shevchenko


