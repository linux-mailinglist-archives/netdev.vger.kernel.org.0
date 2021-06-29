Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455423B789C
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhF2TbM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Jun 2021 15:31:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:51635 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233897AbhF2TbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 15:31:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10030"; a="195374520"
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="scan'208";a="195374520"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2021 12:28:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,309,1616482800"; 
   d="scan'208";a="456915533"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2021 12:28:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 29 Jun 2021 12:28:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 29 Jun 2021 12:28:40 -0700
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.2242.008;
 Tue, 29 Jun 2021 12:28:40 -0700
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/5] ice: add support for auxiliary input/output
 pins
Thread-Topic: [PATCH net-next 2/5] ice: add support for auxiliary input/output
 pins
Thread-Index: AQHXafOQsu1unZMWWk2FI7QX5ZbbUasmyVGAgANBEXCAAVrXAA==
Date:   Tue, 29 Jun 2021 19:28:40 +0000
Message-ID: <30480e4a473146f5a38e83e0602bd36c@intel.com>
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
 <20210625185733.1848704-3-anthony.l.nguyen@intel.com>
 <20210626140245.GA15724@hoboy.vegasvil.org>
 <fcc626d6773745ae9ecee10dfaca1316@intel.com>
In-Reply-To: <fcc626d6773745ae9ecee10dfaca1316@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Keller, Jacob E <jacob.e.keller@intel.com>
> Sent: Monday, June 28, 2021 3:46 PM
> To: Richard Cochran <richardcochran@gmail.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; Machnikowski, Maciej
> <maciej.machnikowski@intel.com>; netdev@vger.kernel.org
> Subject: RE: [PATCH net-next 2/5] ice: add support for auxiliary input/output pins
> 
> 
> 
> > -----Original Message-----
> > From: Richard Cochran <richardcochran@gmail.com>
> > Sent: Saturday, June 26, 2021 7:03 AM
> > To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; Machnikowski, Maciej
> > <maciej.machnikowski@intel.com>; netdev@vger.kernel.org; Keller, Jacob E
> > <jacob.e.keller@intel.com>
> > Subject: Re: [PATCH net-next 2/5] ice: add support for auxiliary input/output
> pins
> >
> > On Fri, Jun 25, 2021 at 11:57:30AM -0700, Tony Nguyen wrote:
> >
> > > @@ -783,6 +1064,17 @@ static long ice_ptp_create_clock(struct ice_pf *pf)
> > >  	info = &pf->ptp.info;
> > >  	dev = ice_pf_to_dev(pf);
> > >
> > > +	/* Allocate memory for kernel pins interface */
> > > +	if (info->n_pins) {
> > > +		info->pin_config = devm_kcalloc(dev, info->n_pins,
> > > +						sizeof(*info->pin_config),
> > > +						GFP_KERNEL);
> > > +		if (!info->pin_config) {
> > > +			info->n_pins = 0;
> > > +			return -ENOMEM;
> > > +		}
> > > +	}
> >
> > How is this supposed to worK?
> >
> > - If n_pins is non-zero, there must also be a ptp_caps.verify method,
> >   but you don't provide one.
> >
> 
> Hmm. Yea, that's missing.

Ok, turns out this is only intended for a later patch that adds support for some pins on E810-T devices, but that work wasn't done yet. We need to split this up more, but currently we never set info->n_pins > 0 so this is effectively dead code.

For now, we need to drop this patch from the series.
