Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4631D16F42D
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 01:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgBZAUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 19:20:39 -0500
Received: from mga06.intel.com ([134.134.136.31]:58486 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728989AbgBZAUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 19:20:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 16:20:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,486,1574150400"; 
   d="scan'208";a="237850102"
Received: from wtczc53028gn.jf.intel.com (HELO skl-build) ([10.54.87.17])
  by orsmga003.jf.intel.com with ESMTP; 25 Feb 2020 16:20:37 -0800
Date:   Tue, 25 Feb 2020 16:20:26 -0800
From:   "Christopher S. Hall" <christopher.s.hall@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, jacob.e.keller@intel.com, davem@davemloft.net,
        sean.v.kelley@intel.com
Subject: Re: [Intel PMC TGPIO Driver 2/5] drivers/ptp: Add PEROUT2 ioctl
 frequency adjustment interface
Message-ID: <20200226002026.GB32079@skl-build>
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20191211214852.26317-3-christopher.s.hall@intel.com>
 <20200203021429.GB3516@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203021429.GB3516@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Sun, Feb 02, 2020 at 06:14:29PM -0800, Richard Cochran wrote:
> On Wed, Dec 11, 2019 at 01:48:49PM -0800, christopher.s.hall@intel.com wrote:
> > diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h

> > +	int (*counttstamp)(struct ptp_clock_info *ptp,
> > +			   struct ptp_event_count_tstamp *count);
> 
> KernelDoc missing.

> As tglx said, it is hard to guess what this will be used for.  I would
> appreciate a fuller explanation of the new callback in the commit log
> message.

Yes, to both of these above. More incremental patches as you point out
below also helps here. I have replied to tglx and you in another thread.

> In general, please introduce a specific new API with an example of how
> it is used.  In this series you have three new APIs,
> 
>    [Intel PMC TGPIO Driver 2/5] drivers/ptp: Add PEROUT2 ioctl frequency adjustment interface
>    [Intel PMC TGPIO Driver 3/5] drivers/ptp: Add user-space input polling interface
>    [Intel PMC TGPIO Driver 4/5] x86/tsc: Add TSC support functions to support ART driven Time-Aware GPIO
> 
> and then a largish driver using them all.
> 
>    [Intel PMC TGPIO Driver 5/5] drivers/ptp: Add PMC Time-Aware GPIO Driver
> 
> May I suggest an ordering more like:
> 
> [1/5] x86/tsc: Add TSC support functions to support ART...	(with forward explanation of the use case)
> [2/5] drivers/ptp: Add PMC Time-Aware GPIO Driver		(without new bits)
> [3/5] drivers/ptp: Add Enhanced handling of reserve fields	(okay as is)
> [4/5] drivers/ptp: Add PEROUT2 ioctl frequency adjustment interface
> [5/5] implement ^^^ in the driver
> [6/5] drivers/ptp: Add user-space input polling interface
> [7/5] implement ^^^ in the driver

This makes sense. Thanks for the detail here.

> > @@ -164,10 +179,14 @@ struct ptp_pin_desc {
> >  	 * PTP_EXTTS_REQUEST and PTP_PEROUT_REQUEST ioctls.
> >  	 */
> >  	unsigned int chan;
> > +	/*
> > +	 * Per pin capability flag
> > +	 */
> > +	unsigned int flags;
> 
> Please use 'capabilities' instead of 'flags'.

Yes. Makes sense.

> Thanks,
> Richard

Thanks,
Christopher
