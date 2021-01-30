Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E6730942E
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhA3KOx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 30 Jan 2021 05:14:53 -0500
Received: from mga17.intel.com ([192.55.52.151]:12310 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232457AbhA3BVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:21:52 -0500
IronPort-SDR: JotDG3ZaFip/TXao1gIefvKlsBuTSfe890nA0ULi7+zcpBzI/DmMpO9ecntGQAYFYOAC4My9Zo
 hxOLUhdK+oEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="160276968"
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="160276968"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 17:19:24 -0800
IronPort-SDR: WJZvA0QGnMHbFWRsrHykCeaazQRCSxfdhqiJTnzGMzHgjDF1Qeki9OLLpndlowFlTXx1xpBtWF
 7wtGXLnlW3vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="411803208"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Jan 2021 17:19:24 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:19:23 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:19:23 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 29 Jan 2021 17:19:23 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5N6oAgAC2+ACAAms5oA==
Date:   Sat, 30 Jan 2021 01:19:22 +0000
Message-ID: <ccf8895d9ac545e1a9f9f73ca1d291bf@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com> <20210126053740.GO579511@unreal>
In-Reply-To: <20210126053740.GO579511@unreal>
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

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Mon, Jan 25, 2021 at 02:42:48PM -0400, Jason Gunthorpe wrote:
> > On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > > +/**
> > > + * irdma_init_dev - GEN_2 device init
> > > + * @aux_dev: auxiliary device
> > > + *
> > > + * Create device resources, set up queues, pble and hmc objects.
> > > + * Return 0 if successful, otherwise return error  */ int
> > > +irdma_init_dev(struct auxiliary_device *aux_dev) {
> > > +	struct iidc_auxiliary_object *vo = container_of(aux_dev,
> > > +							struct
> iidc_auxiliary_object,
> > > +							adev);
> > > +	struct iidc_peer_obj *peer_info = vo->peer_obj;
> > > +	struct irdma_handler *hdl;
> > > +	struct irdma_pci_f *rf;
> > > +	struct irdma_sc_dev *dev;
> > > +	struct irdma_priv_peer_info *priv_peer_info;
> > > +	int err;
> > > +
> > > +	hdl = irdma_find_handler(peer_info->pdev);
> > > +	if (hdl)
> > > +		return -EBUSY;
> > > +
> > > +	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
> > > +	if (!hdl)
> > > +		return -ENOMEM;
> > > +
> > > +	rf = &hdl->rf;
> > > +	priv_peer_info = &rf->priv_peer_info;
> > > +	rf->aux_dev = aux_dev;
> > > +	rf->hdl = hdl;
> > > +	dev = &rf->sc_dev;
> > > +	dev->back_dev = rf;
> > > +	rf->gen_ops.init_hw = icrdma_init_hw;
> > > +	rf->gen_ops.request_reset = icrdma_request_reset;
> > > +	rf->gen_ops.register_qset = irdma_lan_register_qset;
> > > +	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
> > > +	priv_peer_info->peer_info = peer_info;
> > > +	rf->rdma_ver = IRDMA_GEN_2;
> > > +	irdma_set_config_params(rf);
> > > +	dev->pci_rev = peer_info->pdev->revision;
> > > +	rf->default_vsi.vsi_idx = peer_info->pf_vsi_num;
> > > +	/* save information from peer_info to priv_peer_info*/
> > > +	priv_peer_info->fn_num = PCI_FUNC(peer_info->pdev->devfn);
> > > +	rf->hw.hw_addr = peer_info->hw_addr;
> > > +	rf->pcidev = peer_info->pdev;
> > > +	rf->netdev = peer_info->netdev;
> > > +	priv_peer_info->ftype = peer_info->ftype;
> > > +	priv_peer_info->msix_count = peer_info->msix_count;
> > > +	priv_peer_info->msix_entries = peer_info->msix_entries;
> > > +	irdma_add_handler(hdl);
> > > +	if (irdma_ctrl_init_hw(rf)) {
> > > +		err = -EIO;
> > > +		goto err_ctrl_init;
> > > +	}
> > > +	peer_info->peer_ops = &irdma_peer_ops;
> > > +	peer_info->peer_drv = &irdma_peer_drv;
> > > +	err = peer_info->ops->peer_register(peer_info);
> > > +	if (err)
> > > +		goto err_peer_reg;
> >
> > No to this, I don't want to see aux bus layered on top of another
> > management framework in new drivers. When this driver uses aux bus get
> > rid of the old i40iw stuff. I already said this in one of the older
> > postings of this driver.
> >
> > auxbus probe() for a RDMA driver should call ib_alloc_device() near
> > its start and ib_register_device() near the end its end.
> >
> > drvdata for the aux device should point to the driver struct
> > containing the ib_device.
> 
> My other expectation is to see at least two aux_drivers, one for the RoCE and
> another for the iWARP. It will allow easy management for the users if they decide
> to disable/enable specific functionality (/sys/bus/auxiliary/device/*). It will simplify
> code management too.
> 

Do you mean 2 different auxiliary device names - one for RoCE and iWARP?
The drv.probe() and other callbacks will be very similar for gen2, so one gen2 aux driver
which can bind to iW and RoCE aux device should suffice.

Shiraz
