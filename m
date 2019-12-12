Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F4111C25C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfLLBka convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Dec 2019 20:40:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:7916 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfLLBk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 20:40:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 17:40:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,303,1571727600"; 
   d="scan'208";a="363799229"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga004.jf.intel.com with ESMTP; 11 Dec 2019 17:40:28 -0800
Received: from fmsmsx162.amr.corp.intel.com (10.18.125.71) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 11 Dec 2019 17:40:28 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.10]) by
 fmsmsx162.amr.corp.intel.com ([169.254.5.87]) with mapi id 14.03.0439.000;
 Wed, 11 Dec 2019 17:40:28 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>
Subject: RE: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVruL5SWTxLWjtI0m5sVTIVSLbtKe0QawAgAEkwDA=
Date:   Thu, 12 Dec 2019 01:40:27 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7B6B8FBCA@fmsmsx124.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-6-jeffrey.t.kirsher@intel.com>
 <20191210190438.GF46@ziepe.ca>
In-Reply-To: <20191210190438.GF46@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjc4MjA2ZTItYjhjMC00ZDUzLTg3ZTEtMTFiMjRjZDhkYzM2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUGFLTm04Mm9qeUpnSkFvazFpNHo3eUxsUmcyYVBJdXB2MVBDeElTTTY1VlFPUnRZRTN4ZUlzanhcL2VFY3JnYTcifQ==
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

> Subject: Re: [PATCH v3 05/20] RDMA/irdma: Add driver framework definitions
> 
> On Mon, Dec 09, 2019 at 02:49:20PM -0800, Jeff Kirsher wrote:
> > +{
> > +	struct i40e_info *ldev = (struct i40e_info *)rf->ldev.if_ldev;
> 
> Why are there so many casts in this file? Is this really container of?

The casting here is redundant. Will clean up.

> 
> > +	hdl = kzalloc((sizeof(*hdl) + sizeof(*iwdev)), GFP_KERNEL);
> > +	if (!hdl)
> > +		return -ENOMEM;
> > +
> > +	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
> 
> Yikes, use structs and container of for things like this please.

iwdev object alloc should be split here from hdl. Will fix.

> 
> > +	iwdev->param_wq = alloc_ordered_workqueue("l2params",
> WQ_MEM_RECLAIM);
> > +	if (!iwdev->param_wq)
> > +		goto error;
> 
> Leon usually asks why another work queue at this point, at least have a comment
> justifying why. Shouldn't it have a better name?
>

Ugh! The l2 param changes is made synchronous based on
prior feedback from Leon. This wq should be removed.

> > +/* client interface functions */
> > +static const struct i40e_client_ops i40e_ops = {
> > +	.open = i40iw_open,
> > +	.close = i40iw_close,
> > +	.l2_param_change = i40iw_l2param_change };
> 
> Wasn't the whole point of virtual bus to avoid stuff like this? Why isn't a client the
> virtual bus object and this information extended into the driver ops?

These are the private interface calls between lan and rdma.
These ops are implemented by RDMA driver but invoked by
netdev driver.

> 
> > +int i40iw_probe(struct virtbus_device *vdev) {
> > +	struct i40e_info *ldev =
> > +		container_of(vdev, struct i40e_info, vdev);
> > +
> > +	if (!ldev)
> > +		return -EINVAL;
> 
> eh? how can that happen
> 
> > +
> > +	if (!ldev->ops->client_device_register)
> > +		return -EINVAL;
> 
> How can this happen too? If it doesn't support register then don't create a virtual
> device, surely?
> 
> I've really developed a strong distate to these random non-functional 'ifs' that
> seem to get into things.
> 
> If it is functional then fine, but if it is an assertion write it as if (WARN_ON()) to
> make it clear to readers it can't happen by design
>

Yeah. These cant happen by design and should be treated as assertion. Will fix.

> 
> > +/**
> > + * irdma_lan_register_qset - Register qset with LAN driver
> > + * @vsi: vsi structure
> > + * @tc_node: Traffic class node
> > + */
> > +static enum irdma_status_code irdma_lan_register_qset(struct irdma_sc_vsi
> *vsi,
> > +						      struct irdma_ws_node
> *tc_node) {
> > +	struct irdma_device *iwdev = vsi->back_vsi;
> > +	struct iidc_peer_dev *ldev = (struct iidc_peer_dev
> > +*)iwdev->ldev->if_ldev;
> 
> Again with the casts.. Please try to clean up the casting in this driver
>

Ditto as my previous comment.

> > +	struct iidc_res rdma_qset_res = {};
> > +	int ret;
> > +
> > +	if (ldev->ops->alloc_res) {
> 
> Quite an abnormal coding style to put the entire function under an if, just if() return
> 0 ? Many examples of this

Will fix.
> 
> > +/**
> > + * irdma_log_invalid_mtu: log warning on invalid mtu
> > + * @mtu: maximum tranmission unit
> > + */
> > +static void irdma_log_invalid_mtu(u16 mtu) {
> > +	if (mtu < IRDMA_MIN_MTU_IPV4)
> > +		pr_warn("Current MTU setting of %d is too low for RDMA traffic.
> Minimum MTU is 576 for IPv4 and 1280 for IPv6\n",
> > +			mtu);
> > +	else if (mtu < IRDMA_MIN_MTU_IPV6)
> > +		pr_warn("Current MTU setting of %d is too low for IPv6 RDMA
> traffic, the minimum is 1280\n",
> > +			mtu);
> > +}
> 
> Don't use pr_* stuff in drivers that have a struct device.
>
Will fix.

> > +/**
> > + * irdma_event_handler - Called by LAN driver to notify events
> > + * @ldev: Peer device structure
> > + * @event: event from LAN driver
> > + */
> > +static void irdma_event_handler(struct iidc_peer_dev *ldev,
> > +				struct iidc_event *event)
> > +{
> > +	struct irdma_l2params l2params = {};
> > +	struct irdma_device *iwdev;
> > +	int i;
> > +
> > +	iwdev = irdma_get_device(ldev->netdev);
> > +	if (!iwdev)
> > +		return;
> > +
> > +	if (test_bit(IIDC_EVENT_LINK_CHANGE, event->type)) {
> 
> Is this atomic? Why using test_bit?
No its not. What do you suggest we use?

> 
> > +		ldev->ops->reg_for_notification(ldev, &events);
> > +	dev_info(rfdev_to_dev(dev), "IRDMA VSI Open Successful");
> 
> Lets not do this kind of logging..
>

There is some dev_info which should be cleaned up to dev_dbg.
But logging this info is useful to know that this functions VSI (and associated ibdev)
is up and reading for RDMA traffic.
Is info logging to be avoided altogether?

> > +static void irdma_close(struct iidc_peer_dev *ldev, enum
> > +iidc_close_reason reason) {
> > +	struct irdma_device *iwdev;
> > +	struct irdma_pci_f *rf;
> > +
> > +	iwdev = irdma_get_device(ldev->netdev);
> > +	if (!iwdev)
> > +		return;
> > +
> > +	irdma_put_device(iwdev);
> > +	rf = iwdev->rf;
> > +	if (reason == IIDC_REASON_GLOBR_REQ || reason ==
> IIDC_REASON_CORER_REQ ||
> > +	    reason == IIDC_REASON_PFR_REQ || rf->reset) {
> > +		iwdev->reset = true;
> > +		rf->reset = true;
> > +	}
> > +
> > +	if (iwdev->init_state >= CEQ0_CREATED)
> > +		irdma_deinit_rt_device(iwdev);
> > +
> > +	kfree(iwdev);
> 
> Mixing put and kfree? So confusing. Why are there so many structs and so much
> indirection? Very hard to understand if this is right or not.

This does look weird. I think the irdma_get_device() was here
just to get to iwdev. And put_device is releasing the refcnt immediately.
Since we are in a VSI close(), we should not need to take refcnt on ibdev
and just deregister it. Will fix this.

> 
> > new file mode 100644
> > index 000000000000..b418e76a3302
> > +++ b/drivers/infiniband/hw/irdma/main.c
> > @@ -0,0 +1,630 @@
> > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > +/* Copyright (c) 2015 - 2019 Intel Corporation */ #include "main.h"
> > +
> > +/* Legacy i40iw module parameters */
> > +static int resource_profile;
> > +module_param(resource_profile, int, 0644);
> > +MODULE_PARM_DESC(resource_profile, "Resource Profile: 0=PF only,
> > +1=Weighted VF, 2=Even Distribution");
> > +
> > +static int max_rdma_vfs = 32;
> > +module_param(max_rdma_vfs, int, 0644);
> MODULE_PARM_DESC(max_rdma_vfs,
> > +"Maximum VF count: 0-32 32=default");
> > +
> > +static int mpa_version = 2;
> > +module_param(mpa_version, int, 0644); MODULE_PARM_DESC(mpa_version,
> > +"MPA version: deprecated parameter");
> > +
> > +static int push_mode;
> > +module_param(push_mode, int, 0644);
> > +MODULE_PARM_DESC(push_mode, "Low latency mode: deprecated
> > +parameter");
> > +
> > +static int debug;
> > +module_param(debug, int, 0644);
> > +MODULE_PARM_DESC(debug, "debug flags: deprecated parameter");
> 
> Generally no to module parameters

Agree. But these are module params that existed in i40iw.
And irdma replaces i40iw and has a module alias
for it.

> 
> > +static struct workqueue_struct *irdma_wq;
> 
> Another wq already?
This wq is used for deferred handling of irdma service tasks.
Such as rebuild/recovery after reset.

> 
> > +struct irdma_pci_f {
> > +	bool ooo;
> > +	bool reset;
> > +	bool rsrc_created;
> > +	bool stop_cqp_thread;
> > +	bool msix_shared;
> 
> Linus has spoken poorly about lots of bools in a struct. Can this be a bitfield?
Possibly. Yes. Will look into it.

> 
> > +/***********************************************************/
> > +/**
> > + * to_iwdev - get device
> > + * @ibdev: ib device
> > + **/
> 
> Maybe some of these comment blocks are not so valuable :\

Will fix.

> 
> > +	spin_lock_irqsave(&rf->rsrc_lock, flags);
> > +
> > +	bit_is_set = test_bit(rsrc_num, rsrc_array);
> 
> Again, are these atomics? Looks like no, why test_bit?

This helper is not used and to be removed.

But, yes integrity needs to be assured while read/modify rsrc_array. 
irdma_alloc_rsrc() and irdma_free_rsrc() probably warrant
using the non-atomic ver. of set/clear bit since its inside
a lock.

Thanks for the feedback!

Shiraz
