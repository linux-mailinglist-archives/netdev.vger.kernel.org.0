Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711EEBF7B9
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfIZRl2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 13:41:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:58794 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727764AbfIZRl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 13:41:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 10:41:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,552,1559545200"; 
   d="scan'208";a="196450150"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Sep 2019 10:41:27 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 10:41:27 -0700
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.190]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.55]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 10:41:27 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>
Subject: RE: [net-next v2 2/2] net: reject ptp requests with unsupported
 flags
Thread-Topic: [net-next v2 2/2] net: reject ptp requests with unsupported
 flags
Thread-Index: AQHVdBIT+/LmAd3bQk+fhYOFVcDCqKc9y5uAgABu3gA=
Date:   Thu, 26 Sep 2019 17:41:26 +0000
Message-ID: <02874ECE860811409154E81DA85FBB58968D86AE@ORSMSX121.amr.corp.intel.com>
References: <20190926022820.7900-1-jacob.e.keller@intel.com>
 <20190926022820.7900-3-jacob.e.keller@intel.com>
 <20190926040222.GB21883@localhost>
In-Reply-To: <20190926040222.GB21883@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzdiOGIzMWMtM2M5Yy00NGU3LThiOTQtOTc2N2MyN2YwZTEwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOE84KzJSd2FcL1hKdjVnXC9KSGFGbTdXRnRSNTNCeHBtc04rbjlVTVBkSVQ1S3luXC9xWU96NGZ4dGhuWnoxUFJyVSJ9
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
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org] On
> Behalf Of Richard Cochran
> Sent: Wednesday, September 25, 2019 9:02 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Intel Wired LAN <intel-wired-lan@lists.osuosl.org>;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Felipe Balbi
> <felipe.balbi@linux.intel.com>; David S . Miller <davem@davemloft.net>; Hall,
> Christopher S <christopher.s.hall@intel.com>
> Subject: Re: [net-next v2 2/2] net: reject ptp requests with unsupported flags
> 
> On Wed, Sep 25, 2019 at 07:28:20PM -0700, Jacob Keller wrote:
> > This patch may not be correct for individual drivers, especially
> > regarding the rising vs falling edge flags. I interpreted the default
> > behavior to be to timestamp the rising edge of a pin transition.
> 
> So I think this patch goes too far.  It breaks the implied ABI.

Sure, I didn't really know whether the rising vs falling edge and how it was supposed to work for each driver. I just want to ensure that any future flags get rejected until they are actually supported.

> 
> > diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c
> b/drivers/net/ethernet/intel/igb/igb_ptp.c
> > index fd3071f55bd3..2867a2581a36 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_ptp.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
> > @@ -521,6 +521,10 @@ static int igb_ptp_feature_enable_i210(struct
> ptp_clock_info *ptp,
> >
> >  	switch (rq->type) {
> >  	case PTP_CLK_REQ_EXTTS:
> > +		/* Reject requests with unsupported flags */
> > +		if (rq->extts.flags & ~(PTP_ENABLE_FEATURE | PTP_RISING_EDGE))
> > +			return -EOPNOTSUPP;
> 
> This HW always time stamps both edges, and that is not configurable.
> Here you reject PTP_FALLING_EDGE, and that is clearly wrong.  If the
> driver had been really picky (my fault I guess), it should have always
> insisted on (PTP_RISING_EDGE | PTP_FALLING_EDGE) being set together.
> But it is too late to enforce that now, because it could break user
> space programs.

Yes.

> 
> I do agree with the sentiment of checking the flags at the driver
> level, but this needs to be done case by case, with the drivers'
> author's input.

Sure. I think the best immediate approach is to make sure all drivers reject any *new* flags, and each driver can decide whether they should reject rising, falling, etc.

> 
> (The req.perout.flags can be done unconditionally in all drivers,
> since there were never any valid flags, but req.extts.flags needs
> careful attention.)
> 

Right.

> Thanks,
> Richard
