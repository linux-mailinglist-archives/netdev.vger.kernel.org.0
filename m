Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18091304939
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387741AbhAZFaj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 00:30:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:62493 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbhAZBZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:25:37 -0500
IronPort-SDR: TeK1a5Fxp3qDwua5YrFZzv2jviMJPZWu/JIg24LaGRxRHr3Tq8SU1XZsWp78QoXzchMEYtk6Up
 tmAM1VsHgjwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179973518"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179973518"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 16:42:17 -0800
IronPort-SDR: +WLzoT/SZhh9m4E8YZGzc1lPOGb+FkQw6G4F3aPCmon1LBU5YxL6iyF/nJ/PZetzxRb3lXTAJE
 ud7PX6hy483Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="356532897"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 25 Jan 2021 16:42:17 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 25 Jan 2021 16:42:16 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 25 Jan 2021 16:42:16 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Mon, 25 Jan 2021 16:42:16 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
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
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5N6oA//+n/DA=
Date:   Tue, 26 Jan 2021 00:42:16 +0000
Message-ID: <99895f7c10a2473c84a105f46c7ef498@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
In-Reply-To: <20210125184248.GS4147@nvidia.com>
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

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > +/**
> > + * irdma_init_dev - GEN_2 device init
> > + * @aux_dev: auxiliary device
> > + *
> > + * Create device resources, set up queues, pble and hmc objects.
> > + * Return 0 if successful, otherwise return error  */ int
> > +irdma_init_dev(struct auxiliary_device *aux_dev) {
> > +	struct iidc_auxiliary_object *vo = container_of(aux_dev,
> > +							struct
> iidc_auxiliary_object,
> > +							adev);
> > +	struct iidc_peer_obj *peer_info = vo->peer_obj;
> > +	struct irdma_handler *hdl;
> > +	struct irdma_pci_f *rf;
> > +	struct irdma_sc_dev *dev;
> > +	struct irdma_priv_peer_info *priv_peer_info;
> > +	int err;
> > +
> > +	hdl = irdma_find_handler(peer_info->pdev);
> > +	if (hdl)
> > +		return -EBUSY;
> > +
> > +	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
> > +	if (!hdl)
> > +		return -ENOMEM;
> > +
> > +	rf = &hdl->rf;
> > +	priv_peer_info = &rf->priv_peer_info;
> > +	rf->aux_dev = aux_dev;
> > +	rf->hdl = hdl;
> > +	dev = &rf->sc_dev;
> > +	dev->back_dev = rf;
> > +	rf->gen_ops.init_hw = icrdma_init_hw;
> > +	rf->gen_ops.request_reset = icrdma_request_reset;
> > +	rf->gen_ops.register_qset = irdma_lan_register_qset;
> > +	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
> > +	priv_peer_info->peer_info = peer_info;
> > +	rf->rdma_ver = IRDMA_GEN_2;
> > +	irdma_set_config_params(rf);
> > +	dev->pci_rev = peer_info->pdev->revision;
> > +	rf->default_vsi.vsi_idx = peer_info->pf_vsi_num;
> > +	/* save information from peer_info to priv_peer_info*/
> > +	priv_peer_info->fn_num = PCI_FUNC(peer_info->pdev->devfn);
> > +	rf->hw.hw_addr = peer_info->hw_addr;
> > +	rf->pcidev = peer_info->pdev;
> > +	rf->netdev = peer_info->netdev;
> > +	priv_peer_info->ftype = peer_info->ftype;
> > +	priv_peer_info->msix_count = peer_info->msix_count;
> > +	priv_peer_info->msix_entries = peer_info->msix_entries;
> > +	irdma_add_handler(hdl);
> > +	if (irdma_ctrl_init_hw(rf)) {
> > +		err = -EIO;
> > +		goto err_ctrl_init;
> > +	}
> > +	peer_info->peer_ops = &irdma_peer_ops;
> > +	peer_info->peer_drv = &irdma_peer_drv;
> > +	err = peer_info->ops->peer_register(peer_info);
> > +	if (err)
> > +		goto err_peer_reg;
> 
> No to this, I don't want to see aux bus layered on top of another management
> framework in new drivers. When this driver uses aux bus get rid of the old i40iw
> stuff. I already said this in one of the older postings of this driver.
> 
> auxbus probe() for a RDMA driver should call ib_alloc_device() near its start and
> ib_register_device() near the end its end.
> 
> drvdata for the aux device should point to the driver struct containing the
> ib_device.
> 
> Just like any ordinary PCI based rdma driver, look at how something like
> pvrdma_pci_probe() is structued.
> 

I think this essentially means doing away with .open/.close piece. Or are you saying that is ok?
Yes we had a discussion in the past and I thought we concluded. But maybe I misunderstood.

https://lore.kernel.org/linux-rdma/9DD61F30A802C4429A01CA4200E302A7DCD4FD03@fmsmsx124.amr.corp.intel.com/

The concern is around losing the resources held for rdma VFs by rdma PF due to underlying config changes which require a de-reg/re-registration of the ibdevice.
Today such config changes are handled with the netdev PCI driver using the .close() private callback into rdma driver which unregister ibdevice in PF while allowing
the RDMA VF to survive.

Shiraz

