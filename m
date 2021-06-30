Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D613D3B8A5E
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 00:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbhF3WSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 18:18:41 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:56499 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhF3WSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 18:18:40 -0400
Received: (qmail 1582 invoked by uid 89); 30 Jun 2021 22:16:10 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 30 Jun 2021 22:16:10 -0000
Date:   Wed, 30 Jun 2021 15:16:08 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Message-ID: <20210630221608.h7xdvmsc4tdgqeof@bsd-mbp.dhcp.thefacebook.com>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
 <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
 <20210630144257.GA30627@hoboy.vegasvil.org>
 <PH0PR11MB495167E58F24332D30517809EA019@PH0PR11MB4951.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB495167E58F24332D30517809EA019@PH0PR11MB4951.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 03:55:03PM +0000, Machnikowski, Maciej wrote:
> 
> 
> > -----Original Message-----
> > From: Richard Cochran <richardcochran@gmail.com>
> > Sent: Wednesday, June 30, 2021 4:43 PM
> > To: Jonathan Lemon <jonathan.lemon@gmail.com>
> > Cc: netdev@vger.kernel.org; kernel-team@fb.com
> > Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
> > 
> > On Tue, Jun 29, 2021 at 08:50:31PM -0700, Jonathan Lemon wrote:
> > > The PHC should be sync'd to the PPS coming from the GPS signal.
> > > However, the GPS may be in holdover, so the actual counter comes from
> > > an atomic oscillator.  As the oscillator may be ever so slightly out
> > > of sync with the GPS (or drifts with temperature), so we need to
> > > measure the phase difference between the two and steer the oscillator
> > > slightly.
> > >
> > > The phase comparision between the two signals is done in HW with a
> > > phasemeter, for precise comparisons.  The actual phase
> > > steering/adjustment is done through adjphase().
> > 
> 
> You can use different channel index in the struct ptp_clock_event to receive 
> them from more than one source. Then just calculate the difference between 
> the 1PPS from channel 0 and channel 1. Wouldn't that be sufficient?

This is what is being done right now - just in hardware for higher precision.
I asked the HW guys to check whether doing this in SW instead will provide
the same precision - I should hear back by tomorrow.
-- 
Jonathan
