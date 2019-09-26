Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568D7BFA4F
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfIZTu6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 15:50:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:5625 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbfIZTu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 15:50:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 12:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="341562623"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga004.jf.intel.com with ESMTP; 26 Sep 2019 12:50:57 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 12:50:57 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 FMSMSX112.amr.corp.intel.com ([169.254.5.177]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 12:50:56 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Topic: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Index: AQHVdInYTQG+jfjOOUaMtwzDEA3cFqc+rlEAgAAA0YD//672cA==
Date:   Thu, 26 Sep 2019 19:50:56 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC702C0D@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
 <20190926173710.GC14368@unreal> <20190926174001.GG19509@mellanox.com>
In-Reply-To: <20190926174001.GG19509@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmM3ZjRiZDItOWFkYS00ZDExLWE5MzUtZTE5YTQ2Mzk1MmI2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidVpKOGRJMlZLanYyd0U2bG8wZE5qTVFuNXF0dENIOUJUT2VCeUs3Y1k1M0NmRE5ZVDdRWmtjc1dITGlQZ01CTiJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
> 
> On Thu, Sep 26, 2019 at 08:37:10PM +0300, Leon Romanovsky wrote:
> > On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Implement device supported verb APIs. The supported APIs vary based
> > > on the underlying transport the ibdev is registered as (i.e. iWARP
> > > or RoCEv2).
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > >  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
> > >  drivers/infiniband/hw/irdma/verbs.h      |  199 +
> > >  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
> > >  3 files changed, 4546 insertions(+)  create mode 100644
> > > drivers/infiniband/hw/irdma/verbs.c
> > >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> > >
> > > diff --git a/drivers/infiniband/hw/irdma/verbs.c
> > > b/drivers/infiniband/hw/irdma/verbs.c
> > > new file mode 100644
> > > index 000000000000..025c21c722e2
> > > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > > @@ -0,0 +1,4346 @@
> > > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > > +/* Copyright (c) 2019, Intel Corporation. */
> >
> > <...>
> >
> > > +
> > > +	size = sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> > > +	       (rqdepth << 3);
> > > +	iwqp->kqp.wrid_mem = kzalloc(size, GFP_KERNEL);
> 
> This weird allocation math also looks sketchy, should it be using one of the
> various anti-overflow helpers, or maybe a flex array?
> 

OK. We ll review this.
