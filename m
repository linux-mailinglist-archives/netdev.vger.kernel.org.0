Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5050F35C930
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbhDLOvY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Apr 2021 10:51:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:7532 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240199AbhDLOvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:51:24 -0400
IronPort-SDR: NyNqBz8CNtvEAApVZUIjzz1S5QiWQ48cigL4JCB6Oe2PKxZ/NqxMN2zBwdCQPodsDXLPwX42WW
 0zWPqEzpfh8A==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="181332635"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="181332635"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 07:51:05 -0700
IronPort-SDR: Ai1OXhXZ+HFl1g8X2UP4Y6ktg9rQwzWfYVlLgIqmJeQziUlLg+mbzo8kOLxX4Bf7HJyBocXIxg
 Gkv93Vtrkjug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="450011694"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2021 07:51:05 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:51:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 12 Apr 2021 07:51:04 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.013;
 Mon, 12 Apr 2021 07:51:04 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Topic: [PATCH v4 01/23] iidc: Introduce iidc.h
Thread-Index: AQHXKygiEMWtUC1Uo0mj4KR4ZXyZX6qpx+uAgAKRZLA=
Date:   Mon, 12 Apr 2021 14:51:03 +0000
Message-ID: <be4f52362019468b90cd5998fb5cb8b5@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-2-shiraz.saleem@intel.com>
 <20210407173547.GB502757@nvidia.com>
In-Reply-To: <20210407173547.GB502757@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v4 01/23] iidc: Introduce iidc.h
> 
> On Tue, Apr 06, 2021 at 04:01:03PM -0500, Shiraz Saleem wrote:
> 
> > +struct iidc_res_base {
> > +	/* Union for future provision e.g. other res_type */
> > +	union {
> > +		struct iidc_rdma_qset_params qsets;
> > +	} res;
> 
> Use an anonymous union?
> 
> There is alot of confusiong provisioning for future types, do you have concrete
> plans here? I'm a bit confused why this is so different from how mlx5 ended up
> when it already has multiple types.

It was initially designed to be extensible for more resource types. But at this point,
there is no concrete plan and hence it doesn't need to be a union. 

> 
> > +};
> > +
> > +struct iidc_res {
> > +	/* Type of resource. */
> > +	enum iidc_res_type res_type;
> > +	/* Count requested */
> > +	u16 cnt_req;
> > +
> > +	/* Number of resources allocated. Filled in by callee.
> > +	 * Based on this value, caller to fill up "resources"
> > +	 */
> > +	u16 res_allocated;
> > +
> > +	/* Unique handle to resources allocated. Zero if call fails.
> > +	 * Allocated by callee and for now used by caller for internal
> > +	 * tracking purpose.
> > +	 */
> > +	u32 res_handle;
> > +
> > +	/* Peer driver has to allocate sufficient memory, to accommodate
> > +	 * cnt_requested before calling this function.
> 
> Calling what function?

Left over cruft from the re-write of IIDC in v2.
> 
> > +	 * Memory has to be zero initialized. It is input/output param.
> > +	 * As a result of alloc_res API, this structures will be populated.
> > +	 */
> > +	struct iidc_res_base res[1];
> 
> So it is a wrongly defined flex array? Confused

Needs fixing.

> 
> The usages are all using this as some super-complicated function argument:
> 
> 	struct iidc_res rdma_qset_res = {};
> 
> 	rdma_qset_res.res_allocated = 1;
> 	rdma_qset_res.res_type = IIDC_RDMA_QSETS_TXSCHED;
> 	rdma_qset_res.res[0].res.qsets.vport_id = vsi->vsi_idx;
> 	rdma_qset_res.res[0].res.qsets.teid = tc_node->l2_sched_node_id;
> 	rdma_qset_res.res[0].res.qsets.qs_handle = tc_node->qs_handle;
> 
> 	if (cdev_info->ops->free_res(cdev_info, &rdma_qset_res))
> 
> So the answer here is to make your function calls sane and well architected. If you
> have to pass a union to call a function then something is very wrong with the
> design.
> 

Based on previous comment, the union will be removed.

> You aren't trying to achieve ABI decoupling of the rdma/ethernet modules with an
> obfuscated complicated function pointer indirection, are you?

As discussed in other thread, this is part of the IIDC interface exporting the core device .ops callbacks.
> 
> > +/* Following APIs are implemented by auxiliary drivers and invoked by
> > +core PCI
> > + * driver
> > + */
> > +struct iidc_auxiliary_ops {
> > +	/* This event_handler is meant to be a blocking call.  For instance,
> > +	 * when a BEFORE_MTU_CHANGE event comes in, the event_handler will
> not
> > +	 * return until the auxiliary driver is ready for the MTU change to
> > +	 * happen.
> > +	 */
> > +	void (*event_handler)(struct iidc_core_dev_info *cdev_info,
> > +			      struct iidc_event *event);
> > +
> > +	int (*vc_receive)(struct iidc_core_dev_info *cdev_info, u32 vf_id,
> > +			  u8 *msg, u16 len);
> > +};
> 
> This is not the normal pattern:
> 
> > +struct iidc_auxiliary_drv {
> > +	struct auxiliary_driver adrv;
> > +	struct iidc_auxiliary_ops *ops;
> > +};
> 
> Just put the two functions above in the drv directly:

Ok.


> 
> struct iidc_auxiliary_drv {
>         struct auxilary_driver adrv;
> 	void (*event_handler)(struct iidc_core_dev_info *cdev_info, *cdev_info,
> 			      struct iidc_event *event);
> 
> 	int (*vc_receive)(struct iidc_core_dev_info *cdev_info, u32 vf_id,
> 			  u8 *msg, u16 len);
> }
> 
> > +
> > +#define IIDC_RDMA_NAME	"intel_rdma"
> > +#define IIDC_RDMA_ID	0x00000010
> > +#define IIDC_MAX_NUM_AUX	4
> > +
> > +/* The const struct that instantiates cdev_info_id needs to be
> > +initialized
> > + * in the .c with the macro ASSIGN_IIDC_INFO.
> > + * For example:
> > + * static const struct cdev_info_id cdev_info_ids[] =
> > +ASSIGN_IIDC_INFO;  */ struct cdev_info_id {
> > +	char *name;
> > +	int id;
> > +};
> > +
> > +#define IIDC_RDMA_INFO   { .name = IIDC_RDMA_NAME,  .id =
> IIDC_RDMA_ID },
> > +
> > +#define ASSIGN_IIDC_INFO	\
> > +{				\
> > +	IIDC_RDMA_INFO		\
> > +}
> 
> I tried to figure out what all this was for and came up short. There is only one user
> and all this seems unnecessary in this series, add it later when you need it.

No plan for new user, so this should go.

> 
> > +
> > +#define iidc_priv(x) ((x)->auxiliary_priv)
> 
> Use a static inline function
> 
Ok
