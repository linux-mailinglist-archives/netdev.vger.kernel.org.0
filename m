Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F673053C6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhA0G7w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jan 2021 01:59:52 -0500
Received: from mga17.intel.com ([192.55.52.151]:39662 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S316666AbhA0BFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:05:05 -0500
IronPort-SDR: LYfsTB4/Hbp9rckVEhrMqwS4TaP1aq4u+D9FeOOWAZayTVaqTctcTP/gcHVjZIw3gi0mPcB2Uu
 6PVdTpDSL3cA==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159774083"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="159774083"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 17:04:08 -0800
IronPort-SDR: 2dpZLcRXxQAPr2mkxGtUNlPrTndI341rYaDBysj45/iQaAxhKhVjLDorMEXIInLt7Z0mDxZT8D
 Yof4wPP1fysQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="353632735"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2021 17:04:07 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 26 Jan 2021 17:04:07 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 26 Jan 2021 17:04:06 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Tue, 26 Jan 2021 17:04:06 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 15/22] RDMA/irdma: Implement device supported verb APIs
Thread-Topic: [PATCH 15/22] RDMA/irdma: Implement device supported verb APIs
Thread-Index: AQHW8Rldbz3Clds6SkW4+UPUppnfoqo3W5wAgALc+wA=
Date:   Wed, 27 Jan 2021 01:04:06 +0000
Message-ID: <140488d229c443a5b4b4a951365fab43@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-16-shiraz.saleem@intel.com>
 <20210124141856.GC5038@unreal>
In-Reply-To: <20210124141856.GC5038@unreal>
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

> Subject: Re: [PATCH 15/22] RDMA/irdma: Implement device supported verb APIs
> 
> On Fri, Jan 22, 2021 at 05:48:20PM -0600, Shiraz Saleem wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Implement device supported verb APIs. The supported APIs vary based on
> > the underlying transport the ibdev is registered as (i.e. iWARP or
> > RoCEv2).
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > ---
> >  drivers/infiniband/hw/irdma/verbs.c     | 4617
> +++++++++++++++++++++++++++++++
> >  drivers/infiniband/hw/irdma/verbs.h     |  218 ++
> >  include/uapi/rdma/ib_user_ioctl_verbs.h |    1 +
> >  3 files changed, 4836 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> 
> <...>
> 
> > +	if (req.userspace_ver > IRDMA_ABI_VER)
> > +		goto ver_error;
> > +
> > +	ucontext->iwdev = iwdev;
> > +	ucontext->abi_ver = req.userspace_ver;
> > +
> > +	uk_attrs = &iwdev->rf->sc_dev.hw_attrs.uk_attrs;
> > +	/* GEN_1 legacy support with libi40iw */
> > +	if (req.userspace_ver <= 5) {
> > +		if (uk_attrs->hw_rev != IRDMA_GEN_1)
> > +			goto ver_error;
> > +
> > +		uresp_gen1.max_qps = iwdev->rf->max_qp;
> > +		uresp_gen1.max_pds = iwdev->rf->sc_dev.hw_attrs.max_hw_pds;
> > +		uresp_gen1.wq_size = iwdev->rf->sc_dev.hw_attrs.max_qp_wr * 2;
> > +		uresp_gen1.kernel_ver = req.userspace_ver;
> > +		if (ib_copy_to_udata(udata, &uresp_gen1,
> > +				     min(sizeof(uresp_gen1), udata->outlen)))
> > +			return -EFAULT;
> > +	} else {
> > +		u64 bar_off =
> > +		    (uintptr_t)iwdev->rf-
> >sc_dev.hw_regs[IRDMA_DB_ADDR_OFFSET];
> > +		ucontext->db_mmap_entry =
> > +			irdma_user_mmap_entry_insert(ucontext, bar_off,
> > +						     IRDMA_MMAP_IO_NC,
> > +						     &uresp.db_mmap_key);
> > +
> > +		if (!ucontext->db_mmap_entry)
> > +			return -ENOMEM;
> > +
> > +		uresp.kernel_ver = IRDMA_ABI_VER;
> > +		uresp.feature_flags = uk_attrs->feature_flags;
> > +		uresp.max_hw_wq_frags = uk_attrs->max_hw_wq_frags;
> > +		uresp.max_hw_read_sges = uk_attrs->max_hw_read_sges;
> > +		uresp.max_hw_inline = uk_attrs->max_hw_inline;
> > +		uresp.max_hw_rq_quanta = uk_attrs->max_hw_rq_quanta;
> > +		uresp.max_hw_wq_quanta = uk_attrs->max_hw_wq_quanta;
> > +		uresp.max_hw_sq_chunk = uk_attrs->max_hw_sq_chunk;
> > +		uresp.max_hw_cq_size = uk_attrs->max_hw_cq_size;
> > +		uresp.min_hw_cq_size = uk_attrs->min_hw_cq_size;
> > +		uresp.hw_rev = uk_attrs->hw_rev;
> > +		if (ib_copy_to_udata(udata, &uresp,
> > +				     min(sizeof(uresp), udata->outlen)))
> > +			return -EFAULT;
> > +	}
> 
> i40iw has different logic here, and in old code, if user supplied "req.userspace_ver
> < 4", he will get an error. In new code, it will pass and probably fail later.
> 

Thanks! We will add that check.
