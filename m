Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA2BD380
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 22:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406216AbfIXUXc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Sep 2019 16:23:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:48717 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfIXUXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 16:23:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 13:23:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,545,1559545200"; 
   d="scan'208";a="201020453"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga002.jf.intel.com with ESMTP; 24 Sep 2019 13:23:31 -0700
Received: from orsmsx161.amr.corp.intel.com (10.22.240.84) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Sep 2019 13:23:31 -0700
Received: from orsmsx109.amr.corp.intel.com ([169.254.11.122]) by
 ORSMSX161.amr.corp.intel.com ([169.254.4.111]) with mapi id 14.03.0439.000;
 Tue, 24 Sep 2019 13:23:31 -0700
From:   "Hall, Christopher S" <christopher.s.hall@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 2/2] PTP: add support for one-shot output
Thread-Topic: [PATCH v4 2/2] PTP: add support for one-shot output
Thread-Index: AQHVaGh/aGiLTWXDV0O998th8wsGNac7v5sA//+O24A=
Date:   Tue, 24 Sep 2019 20:23:30 +0000
Message-ID: <B79D786B7111A34A8CF09F833429C493BCA528D5@ORSMSX109.amr.corp.intel.com>
References: <20190911061622.774006-1-felipe.balbi@linux.intel.com>
 <20190911061622.774006-2-felipe.balbi@linux.intel.com>
 <02874ECE860811409154E81DA85FBB58968D24E2@ORSMSX121.amr.corp.intel.com>
In-Reply-To: <02874ECE860811409154E81DA85FBB58968D24E2@ORSMSX121.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Keller, Jacob E
> Sent: Tuesday, September 24, 2019 12:23 PM
> To: Felipe Balbi <felipe.balbi@linux.intel.com>; Richard Cochran
> <richardcochran@gmail.com>
> Cc: Hall, Christopher S <christopher.s.hall@intel.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH v4 2/2] PTP: add support for one-shot output
> 
> 
> 
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On
> > Behalf Of Felipe Balbi
> > Sent: Tuesday, September 10, 2019 11:16 PM
> > To: Richard Cochran <richardcochran@gmail.com>
> > Cc: Hall, Christopher S <christopher.s.hall@intel.com>;
> netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Felipe Balbi
> <felipe.balbi@linux.intel.com>
> > Subject: [PATCH v4 2/2] PTP: add support for one-shot output
> >
> > Some controllers allow for a one-shot output pulse, in contrast to
> > periodic output. Now that we have extensible versions of our IOCTLs, we
> > can finally make use of the 'flags' field to pass a bit telling driver
> > that if we want one-shot pulse output.
> >
> > Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> > ---
> >
> > Changes since v3:
> > 	- Remove bogus bitwise negation
> >
> > Changes since v2:
> > 	- Add _PEROUT_ to bit macro
> >
> > Changes since v1:
> > 	- remove comment from .flags field
> >
> >  include/uapi/linux/ptp_clock.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/uapi/linux/ptp_clock.h
> b/include/uapi/linux/ptp_clock.h
> > index 9a0af3511b68..f16301015949 100644
> > --- a/include/uapi/linux/ptp_clock.h
> > +++ b/include/uapi/linux/ptp_clock.h
> > @@ -38,8 +38,8 @@
> >  /*
> >   * Bits of the ptp_perout_request.flags field:
> >   */
> > -#define PTP_PEROUT_VALID_FLAGS (0)
> > -
> > +#define PTP_PEROUT_ONE_SHOT (1<<0)
> > +#define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT)
> >  /*
> >   * struct ptp_clock_time - represents a time value
> >   *
> > @@ -77,7 +77,7 @@ struct ptp_perout_request {
> >  	struct ptp_clock_time start;  /* Absolute start time. */
> >  	struct ptp_clock_time period; /* Desired period, zero means disable.
> */
> >  	unsigned int index;           /* Which channel to configure. */
> > -	unsigned int flags;           /* Reserved for future use. */
> > +	unsigned int flags;
> >  	unsigned int rsv[4];          /* Reserved for future use. */
> >  };
> >
> > --
> > 2.23.0
> 
> Hi Felipe,
> 
> Do you have any examples for how you envision using this? I don't see any
> drivers or other code on the list for doing so.
> 
> Additionally, it seems weird because we do not have support for specifying
> the pulse width. I guess you leave that up to driver choice?
> 
> Thanks,
> Jake

Jake,

Good catch on the terminology. This is an API that produces edges not pulses.
This flag causes the PEROUT ioctl to ignore the period argument and produce a
single edge. Currently, the igb driver implements the same function, but uses
a "magic" invalid period specification to signal that the period argument
should be ignored (use_freq == 0):

		if (on && ((ns <= 70000000LL) || (ns == 125000000LL) ||
			   (ns == 250000000LL) || (ns == 500000000LL))) {
			if (ns < 8LL)
				return -EINVAL;
			use_freq = 1;
		}

The proposal is to support this function without magic period specifications
using an explicit flag instead. An example use case is pulse-per-second
output. While PPS is periodic, time-aware GPIO is driven by (an
unadjustable) Always Running Timer (ART). It's necessary to schedule each
edge in software to produce PPS synced with system time.

Chris
