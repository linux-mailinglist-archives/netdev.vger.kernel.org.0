Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C751302A93
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 19:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbhAYSn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 13:43:56 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16818 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbhAYSnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 13:43:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f11300001>; Mon, 25 Jan 2021 10:42:56 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 18:42:51 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 18:42:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzqnSrKasQC0vyHcNG2L8aluqHh+6OQWhJU/T92S7q26CTreXlmVqxx6mgJ2hakng9nsfOWahcEgNcIir6+A/ovy2VsheAWF6MyP8ArIaQjCOYz81XrLAcrZFLFKXbnmXlDNckFHLMZdY7Pkbn87LUapHkGSHgaSXcHaVT/H0coDfP1GZOQo5v93BkjVYd3QMWvHJfqLmkR4bvQPqiEnq+S3DquIykUfQvS/+iyjdxFrEkdKg6+wtBgUQ54SxX9kGdPGsL0I/WmpNcORWupU2mPbqGHbAA5S5N46C5kWrk69pvhEdDoVEICtn6OXv9NIRIx62jR9MoZfGmBjIvUAFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJnlRVQbWUFYtdfJUoAHZBn9iVWDj0a8MHB3apfJZZ4=;
 b=fFqbEQwpcBk6h2e3IznUucGF4Cwah0BwTDYf0W9P7KPlxmKL/BdOtlD44lcc27MlsB4gYJb3Gh8DpHGJDovL8Y9LLPTllZqJPoDpJ6ZP5hxBwxZwfceclTFdXzzssvxCEALdCHrcL5NNZd+h5KIljAqaU3N0cW3U27/skvlp5HyX/rHHH9HAYmVS6UcvGut1UacySWj2U8yvsCqEI4Xuu/MknHQTwqDpzIby6EObV6N9YEumCMUwqPTnsYThi7ElYWApo6EdvepCMGAkSecwvpODlMAkVPzXXb1b3Ft1FN4vhXC/0jScrIUfFd7kMwn6noWLXUhGObhxeR5sXzNSuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3308.namprd12.prod.outlook.com (2603:10b6:5:182::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 18:42:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 18:42:50 +0000
Date:   Mon, 25 Jan 2021 14:42:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210125184248.GS4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-8-shiraz.saleem@intel.com>
X-ClientProxiedBy: BL1PR13CA0262.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0262.namprd13.prod.outlook.com (2603:10b6:208:2ba::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Mon, 25 Jan 2021 18:42:50 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l46p6-006h4c-Kz; Mon, 25 Jan 2021 14:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611600176; bh=bJnlRVQbWUFYtdfJUoAHZBn9iVWDj0a8MHB3apfJZZ4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=H4DbTVjXc5jI4m3U23DWpZp2ySuL8d1OZ/dZ9z/FyNb+PBDEyzSwQMfgwDTTjF6bI
         Vh06s4MZWBxmBeAZ4XJ9fETo7UQif5UALTXjUyCQWNvQhroO+dZpiRkde45thGK3oH
         n6jxC7OyAYZc90ZXXIf2uSbrVM3uh0HkkCq3nOySQ+oH75VT3yyDP3c2ZdPTjaJaVa
         5l7bTQ0unio/H5v52FqtYRRMWy8SVh2V4f9hDev92+TA3+hR+w13Q3vMkk6uzWqoXr
         mbjTIwsNyNx4yC/AhNNvp58MZKtYI+IAjfTn9zwq57bWCt0t50e2fV3JNLDhsJeg7T
         q8HdixSSRKz2Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> +/**
> + * irdma_init_dev - GEN_2 device init
> + * @aux_dev: auxiliary device
> + *
> + * Create device resources, set up queues, pble and hmc objects.
> + * Return 0 if successful, otherwise return error
> + */
> +int irdma_init_dev(struct auxiliary_device *aux_dev)
> +{
> +	struct iidc_auxiliary_object *vo = container_of(aux_dev,
> +							struct iidc_auxiliary_object,
> +							adev);
> +	struct iidc_peer_obj *peer_info = vo->peer_obj;
> +	struct irdma_handler *hdl;
> +	struct irdma_pci_f *rf;
> +	struct irdma_sc_dev *dev;
> +	struct irdma_priv_peer_info *priv_peer_info;
> +	int err;
> +
> +	hdl = irdma_find_handler(peer_info->pdev);
> +	if (hdl)
> +		return -EBUSY;
> +
> +	hdl = kzalloc(sizeof(*hdl), GFP_KERNEL);
> +	if (!hdl)
> +		return -ENOMEM;
> +
> +	rf = &hdl->rf;
> +	priv_peer_info = &rf->priv_peer_info;
> +	rf->aux_dev = aux_dev;
> +	rf->hdl = hdl;
> +	dev = &rf->sc_dev;
> +	dev->back_dev = rf;
> +	rf->gen_ops.init_hw = icrdma_init_hw;
> +	rf->gen_ops.request_reset = icrdma_request_reset;
> +	rf->gen_ops.register_qset = irdma_lan_register_qset;
> +	rf->gen_ops.unregister_qset = irdma_lan_unregister_qset;
> +	priv_peer_info->peer_info = peer_info;
> +	rf->rdma_ver = IRDMA_GEN_2;
> +	irdma_set_config_params(rf);
> +	dev->pci_rev = peer_info->pdev->revision;
> +	rf->default_vsi.vsi_idx = peer_info->pf_vsi_num;
> +	/* save information from peer_info to priv_peer_info*/
> +	priv_peer_info->fn_num = PCI_FUNC(peer_info->pdev->devfn);
> +	rf->hw.hw_addr = peer_info->hw_addr;
> +	rf->pcidev = peer_info->pdev;
> +	rf->netdev = peer_info->netdev;
> +	priv_peer_info->ftype = peer_info->ftype;
> +	priv_peer_info->msix_count = peer_info->msix_count;
> +	priv_peer_info->msix_entries = peer_info->msix_entries;
> +	irdma_add_handler(hdl);
> +	if (irdma_ctrl_init_hw(rf)) {
> +		err = -EIO;
> +		goto err_ctrl_init;
> +	}
> +	peer_info->peer_ops = &irdma_peer_ops;
> +	peer_info->peer_drv = &irdma_peer_drv;
> +	err = peer_info->ops->peer_register(peer_info);
> +	if (err)
> +		goto err_peer_reg;

No to this, I don't want to see aux bus layered on top of another
management framework in new drivers. When this driver uses aux bus get
rid of the old i40iw stuff. I already said this in one of the older
postings of this driver.

auxbus probe() for a RDMA driver should call ib_alloc_device() near
its start and ib_register_device() near the end its end.

drvdata for the aux device should point to the driver struct
containing the ib_device.

Just like any ordinary PCI based rdma driver, look at how something
like pvrdma_pci_probe() is structued.

Jason
