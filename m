Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EABBD41A
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 23:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410730AbfIXVQH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Sep 2019 17:16:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:32964 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410672AbfIXVQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 17:16:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 14:16:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,545,1559545200"; 
   d="scan'208";a="189483403"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga007.fm.intel.com with ESMTP; 24 Sep 2019 14:16:06 -0700
Received: from orsmsx116.amr.corp.intel.com (10.22.240.14) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Sep 2019 14:16:06 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.190]) by
 ORSMSX116.amr.corp.intel.com ([169.254.7.232]) with mapi id 14.03.0439.000;
 Tue, 24 Sep 2019 14:16:05 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 2/2] PTP: add support for one-shot output
Thread-Topic: [PATCH v4 2/2] PTP: add support for one-shot output
Thread-Index: AQHVaGiJVAygg13ZgEaRBcEK9JTjfKc7SaLQgACGwQD//5gpUA==
Date:   Tue, 24 Sep 2019 21:16:05 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58968D3696@ORSMSX121.amr.corp.intel.com>
References: <20190911061622.774006-1-felipe.balbi@linux.intel.com>
 <20190911061622.774006-2-felipe.balbi@linux.intel.com>
 <02874ECE860811409154E81DA85FBB58968D24E2@ORSMSX121.amr.corp.intel.com>
 <B79D786B7111A34A8CF09F833429C493BCA528D5@ORSMSX109.amr.corp.intel.com>
In-Reply-To: <B79D786B7111A34A8CF09F833429C493BCA528D5@ORSMSX109.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDE2ZmE1ZmEtNGUzYS00NmYwLWJlNmItMmY5NDk3MWI3NzdhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMU9zdnY5ZXBRSFdkcnByV0R5aFFkNHJCWTNBY0dmSEFzXC9yUHlTSnV1WVwvVlwvZm9SdnlON2srODFaRE1CM3czQyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Hall, Christopher S
> Sent: Tuesday, September 24, 2019 1:24 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>; Felipe Balbi
> <felipe.balbi@linux.intel.com>; Richard Cochran <richardcochran@gmail.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH v4 2/2] PTP: add support for one-shot output
> 
> Good catch on the terminology. This is an API that produces edges not pulses.
> This flag causes the PEROUT ioctl to ignore the period argument and produce a
> single edge. Currently, the igb driver implements the same function, but uses
> a "magic" invalid period specification to signal that the period argument
> should be ignored (use_freq == 0):
> 
> 		if (on && ((ns <= 70000000LL) || (ns == 125000000LL) ||
> 			   (ns == 250000000LL) || (ns == 500000000LL))) {
> 			if (ns < 8LL)
> 				return -EINVAL;
> 			use_freq = 1;
> 		}

From my understanding, the use_freq = 0 is intended to perform a clock using the target time registers with an interrupt to re-trigger the next toggle.

If you use a frequency not supported by freqout, it will result in an interrupt that re-toggles the target time, not a single edge.

> 
> The proposal is to support this function without magic period specifications
> using an explicit flag instead. An example use case is pulse-per-second
> output. While PPS is periodic, time-aware GPIO is driven by (an
> unadjustable) Always Running Timer (ART). It's necessary to schedule each
> edge in software to produce PPS synced with system time.
> 
> Chris

Oh, so "one shot" will simply toggle the clock output once. I see.

So this won't really work for generating a pulse per second, and we would possibly still want an API for that?

Thanks,
Jake
