Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AEA37EE8
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfFFUiB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 16:38:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:40139 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfFFUiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 16:38:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 13:38:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,560,1557212400"; 
   d="scan'208";a="182441324"
Received: from orsmsx101.amr.corp.intel.com ([10.22.225.128])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2019 13:38:00 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX101.amr.corp.intel.com (10.22.225.128) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 6 Jun 2019 13:37:59 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.133]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.242]) with mapi id 14.03.0415.000;
 Thu, 6 Jun 2019 13:37:59 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
Thread-Topic: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
Thread-Index: AQHVG9yW/TezwgfQ60mS3GcVgIS18KaOa00AgACrTtA=
Date:   Thu, 6 Jun 2019 20:37:59 +0000
Message-ID: <02874ECE860811409154E81DA85FBB5896745E05@ORSMSX121.amr.corp.intel.com>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
 <20190605202358.2767-7-jeffrey.t.kirsher@intel.com>
 <20190606032050.4uwzcc7rdx3dkw5x@localhost>
In-Reply-To: <20190606032050.4uwzcc7rdx3dkw5x@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTk5N2FmZDEtZGViOS00YmEzLThhYmQtYjE3OTYxMDE5ZDljIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNlJtUWM4WjZtMXdSYVMya3BpZXJpT0dMdXUwMFdJTzM1R1hGRHhUQU5HSmVhSHFGdW9QYkYrTFdmZkZzREVjdSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On
> Behalf Of Richard Cochran
> Sent: Wednesday, June 05, 2019 8:21 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Keller, Jacob E <jacob.e.keller@intel.com>;
> netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com; Bowers,
> AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 06/15] ixgbe: fix PTP SDP pin setup on X540 hardware
> 
> On Wed, Jun 05, 2019 at 01:23:49PM -0700, Jeff Kirsher wrote:
> > + * It calculates when the system time will be on an exact second, and then
> > + * aligns the start of the PPS signal to that value.
> > + *
> > + * This works by using the cycle counter shift and mult values in reverse, and
> > + * assumes that the values we're shifting will not overflow.
> 
> So I guess that this device can't adjust the frequency in hardware,
> and that is why the driver uses a timecounter.
> 

No. We use the timecounter to track the time offset, not the frequency. That is, our hardware can't represent 64bits of time, but it can adjust frequency. The time counter is used to track the adjustments from adjtime and set time, but not adjfreq.

The timecounter is used to provide two features: (a) storing a full 64bits of time for passing back to the PTP stack and (b) atomic adjustments in adjtime. When programming the SDP we need to reverse the calculations done so that they're in terms of the SYSTIME values. But the frequency changes are all done directly to the SYSTIME increment values, and should be reflected properly in the pin output.

> BUT your PPS will not be correct.  You use the 'mult' to calculate the
> future counter time of the PPS, but as soon as the PTP stack adjusts
> the frequency (and changes 'mult') the PPS will occur at the wrong
> time.

Every path which changes mult (which is only link speed changes as far as I remember offhand) re-programs the PPS. We also re-program the pin at adjtime and settime.

There should be no caller outside of our driver who adjusts the multiplier.

Thanks,
Jake

> 
> Sorry to say it,
> Richard
