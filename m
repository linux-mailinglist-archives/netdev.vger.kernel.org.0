Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E8A6BB569
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjCOOAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjCON77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:59:59 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E3483C0;
        Wed, 15 Mar 2023 06:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678888790; x=1710424790;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rbIZoXywsCDn4QFmR1753mHwinQQuUjTjoialLrDo+E=;
  b=BsZP/b0eO+FXgm/9YnerdKPlpdy+VK2NwsogbUiJfHOE56OATXuvX5ir
   qPUDewkJlrtm/DIzpYkMp0QeLiu65X3YlXJaUgDxc3sEl/WH1B28XAWSr
   JQQJXtKPkHGzU8d8PBE+dTf979kLfA/7lesZ5Z3oEHonnajU8YrxmDvh5
   rACfd1oC68VuXn4HE2hK/mPw6vXc0+M3LTQ9W46ZPyaE7kfSUiWEQPggV
   K7Om4js6Wci07DsXM/nuDPn1tTzAxAQOwzw1q8fKe3wyt4ycs07eJuQqX
   o6BKJAet7PQJKs2p9I4p+zrGsnKEbyEFy212mREG1ypuQB3+c0maOs8z8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365390009"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="365390009"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 06:59:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="709692220"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="709692220"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 06:59:46 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1pcRfM-003rBX-17;
        Wed, 15 Mar 2023 15:59:44 +0200
Date:   Wed, 15 Mar 2023 15:59:43 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Nicolas Pitre <npitre@baylibre.com>
Cc:     Tianfei Zhang <tianfei.zhang@intel.com>, netdev@vger.kernel.org,
        linux-fpga@vger.kernel.org, ilpo.jarvinen@linux.intel.com,
        russell.h.weight@intel.com, matthew.gerlach@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, vinicius.gomes@intel.com,
        Raghavendra Khadatare <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
References: <20230313030239.886816-1-tianfei.zhang@intel.com>
 <ZA9wUe33pMkhMu0e@hoboy.vegasvil.org>
 <ZBBQpwGhXK/YYGCB@smile.fi.intel.com>
 <ZBDPKA7968sWd0+P@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBDPKA7968sWd0+P@hoboy.vegasvil.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc: Nicolas

On Tue, Mar 14, 2023 at 12:46:48PM -0700, Richard Cochran wrote:
> On Tue, Mar 14, 2023 at 12:47:03PM +0200, Andy Shevchenko wrote:
> > The semantics of the above is similar to gpiod_get_optional() and since NULL
> > is a valid return in such cases, the PTP has to handle this transparently to
> > the user. Otherwise it's badly designed API which has to be fixed.
> 
> Does it now?  Whatever.
> 
> > TL;DR: If I'm mistaken, I would like to know why.
> 
> git log.  git blame.
> 
> Get to know the tools of trade.

So, the culprit seems the commit d1cbfd771ce8 ("ptp_clock: Allow for it
to be optional") which did it half way.

Now I would like to know why the good idea got bad implementation.

Nicolas?

-- 
With Best Regards,
Andy Shevchenko


