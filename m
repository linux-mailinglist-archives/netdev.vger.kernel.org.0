Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9288E30491D
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387548AbhAZFaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:30:02 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14825 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731509AbhAYTRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:17:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f190e0002>; Mon, 25 Jan 2021 11:16:30 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:16:27 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.50) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 19:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKttc8vS+IMK7C/6WFmQB5W+CH3LrxuZz549Mz9fZfI3gT4dSNW5rgUArCIy/mzgpqIBjWRwWVhn/pOv/f+VmF1HIFxSCZpAcouol5G2ch5tRtb2/Cx3n4UMvAAEdyHuVw+vlAHBxMaavtYiFef5IHn492RUuwgwhj1sRj5tb+JDKLT908Nwa/NMx07v+4dpQuTFMGsqZ9tBsiftTsa2PI7JKDYtcomZ3o4LjJo3WNvhA5p+TTEDgmQlrH8e/AX4D0hbCVTO8z2LwZEWE5yUGP6WPHjKQhP4DGJzexU6zYJqPGkOA+48AhbgdCY8pFzUB6wJtZYNT39bsEfPbhedUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iq205kGSdLIdROtYgzFvv/cnHyeAbnz8UZMyR0oRauM=;
 b=d3/3SfwFhoxMNqeFq+gCvTxpBk7k3fsRTQTCwqmc8riLIXw4evG/wv4IUHu83mlTWIO+W3BhEX2G+Zx+89thGmqxpsYKTAIV/n35emf+eV0Y75BwogdfyfcSqFOgAZFAJHneePjgccHlOKD+jKhSBHU9UEaJFQ/c9tK4oekEyt165AV8Du+s9e39F17LxjRL0u/IJvxF0ytShhTTMPJCQFpQek0Z7t7KLB0lXPRllZ5CDD34Mmdxgy3l6+XM5BDbTphDEbx8O+oxh1hWVaWMFzKZhaJKwKBxJEmbYjB2h4QUDHdiq170G4+OsapuBrekz6lcoJ9gNAMTRjVNgLCx6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4268.namprd12.prod.outlook.com (2603:10b6:5:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 19:16:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:16:25 +0000
Date:   Mon, 25 Jan 2021 15:16:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210125191622.GA1599720@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-8-shiraz.saleem@intel.com>
X-ClientProxiedBy: BL1PR13CA0502.namprd13.prod.outlook.com
 (2603:10b6:208:2c7::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0502.namprd13.prod.outlook.com (2603:10b6:208:2c7::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.5 via Frontend Transport; Mon, 25 Jan 2021 19:16:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l47La-006iDJ-W5; Mon, 25 Jan 2021 15:16:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611602190; bh=Iq205kGSdLIdROtYgzFvv/cnHyeAbnz8UZMyR0oRauM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=B52Aod8Sw5eCFNoo/2MkeBU+t44Mt0D0qpnjM9oME+1YBCrER5A9hQq83Pifc7fVt
         x+h2xoucNJ057WBtDfmV+buvOctL1aoi6GH2QMsVeRmN+dgV8wAvCXaURNx8EdJiqy
         +gaQgxvfRdzLXme64K9wNLbA6cTWdUTTwKyy5cwGL+Wui14S+IL8j/LzllmZ1mWmvb
         Asj4fYhr85A4P831C7+cp2psbKh4nLKo0Ur+KHLVs5DBOtzV8mxlTerxJavnFXetVW
         KIXOcAKPvPdlAStTiojdOcwSyXZkdZAa9gndCLx+fx9CgeFkeGRhzZP21AfKQZKIr4
         4St8dPzhOB+lw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:

> +static int irdma_probe(struct auxiliary_device *aux_dev,
> +		       const struct auxiliary_device_id *id)
> +{
> +	struct irdma_drvdata *drvdata;
> +	int ret;
> +
> +	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
> +	if (!drvdata)
> +		return -ENOMEM;
> +
> +	switch (id->driver_data) {
> +	case IRDMA_GEN_2:
> +		drvdata->init_dev = irdma_init_dev;
> +		drvdata->deinit_dev = irdma_deinit_dev;
> +		break;
> +	case IRDMA_GEN_1:
> +		drvdata->init_dev = i40iw_init_dev;
> +		drvdata->deinit_dev = i40iw_deinit_dev;
> +		break;
> +	default:
> +		ret = -ENODEV;
> +		goto ver_err;

Also don't do this, if the drivers are so different then give them
different aux bus names and bind two drivers with the different
flow.

I suppose the old i40e can keep its weird registration thing, but ice
should not duplicate that, new code must use aux devices properly, as
in my other email.

Jason
