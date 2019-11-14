Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B327FD054
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKNV3T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 16:29:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:42670 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfKNV3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 16:29:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 13:29:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,305,1569308400"; 
   d="scan'208";a="208239198"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2019 13:29:14 -0800
Received: from orsmsx112.amr.corp.intel.com (10.22.240.13) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 Nov 2019 13:29:14 -0800
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.169]) by
 ORSMSX112.amr.corp.intel.com ([169.254.3.26]) with mapi id 14.03.0439.000;
 Thu, 14 Nov 2019 13:29:14 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Brandon Streiff <brandon.streiff@ni.com>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Stefan Sorensen <stefan.sorensen@spectralink.com>
Subject: RE: [PATCH net 08/13] ptp: Introduce strict checking of external
 time stamp options.
Thread-Topic: [PATCH net 08/13] ptp: Introduce strict checking of external
 time stamp options.
Thread-Index: AQHVmxuxoPK+e8/gkEmkIRBM+apU76eLCGPggACPRgD//5b+4A==
Date:   Thu, 14 Nov 2019 21:29:14 +0000
Message-ID: <02874ECE860811409154E81DA85FBB589698FABB@ORSMSX121.amr.corp.intel.com>
References: <20191114184507.18937-9-richardcochran@gmail.com>
 <02874ECE860811409154E81DA85FBB589698F6E0@ORSMSX121.amr.corp.intel.com>
 <20191114194410.GB19147@localhost>
In-Reply-To: <20191114194410.GB19147@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTVhZjhlNjYtNGE2Ny00NTg3LWJiYjUtNTMxYWIxN2RkOTQ2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicHNcL0pRbVlEYzVJZThWNkorRFI2R3FGMVlaR3E5QmFWeDltaVdEcHA1TlpjUDVib3hYQkkxTXdWWUNzMXF1NSsifQ==
x-ctpclassification: CTP_NT
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
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, November 14, 2019 11:44 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; David Miller
> <davem@davemloft.net>; Brandon Streiff <brandon.streiff@ni.com>; Hall,
> Christopher S <christopher.s.hall@intel.com>; Eugenia Emantayev
> <eugenia@mellanox.com>; Felipe Balbi <felipe.balbi@linux.intel.com>; Feras
> Daoud <ferasda@mellanox.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com>; Stefan Sorensen
> <stefan.sorensen@spectralink.com>
> Subject: Re: [PATCH net 08/13] ptp: Introduce strict checking of external time
> stamp options.
> 
> On Thu, Nov 14, 2019 at 07:12:38PM +0000, Keller, Jacob E wrote:
> > So, this patch adds the flag *and* modifies the drivers to accept it, but not
> actually enable strict checking?
> >
> > I'd prefer if this flag got added, and the drivers were modified in separate
> patches to both allow the flag and to perform the strict check.. that feels like a
> cleaner patch boundary.
> >
> > That would ofcourse break the drivers that reject the strict command until
> they're fixed in follow-on commands.. hmm
> 
> You are right, but if anything I'd squash the following four driver
> patches into this one.  I left the series in little steps just to make
> review easier.  Strictly speaking, if you were to do a git bisect from
> the introduction of the "2" ioctls until here, you would find drivers'
> acceptance of the new flags changing.  But it is too late to fix that,
> and I doubt anyone will care.
> 
> IMHO it *is* important to have v5.4 with strict checking.
> 
> Thanks,
> Richard

Yes I agree. I think the series is good as is, and having this fixed before the ioctls have been in a full release makes sense.

Thanks,
Jake
