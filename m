Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0106930533B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhA0Gbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:31:38 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4424 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhA0DIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:08:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010d38d0001>; Tue, 26 Jan 2021 18:44:29 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 02:44:26 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Jan 2021 02:44:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2x5EQpv+D8TL4Av20j4YLUjeNpfGlzadhK5sEWuevfVgMgHA+AIowt9vfqF6bSiNPY+M8cZ5jDUU5SwztJ+YKmeIbPtAc+hqA/oEJNnlEL7/jnObdkP1yo6z9PtKb+QnLLSJx3PH2FdHOvJDo0UBbkqR3JQAw8Du+mNnWdI8Vgx6McRQkHaRsm+jhFkv3amYOFhowpp5loBGrMRWkwCcnrh/pnVgx0WMig2xIfsZjcl/cFJiwtghDtaIhfdtS7vZV8z9YCdldykOtPB90PLoydiy52asjRykeFMzdM6Uh+tOc1hSflJ+apzbMVUPG+s/ywmCi9JtRGa25MAItpLXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9CSOF88e9CdtCrouUZFAmqN8ZA4YXMuAivyQAbPhCo=;
 b=SzNrlg0Zika6voOnmOe8ErV7MSgHh240QyEEGtNl4BDbuTZGLDdZrJuK9G8CfZ2WbFN149nhMHwKlmleB2jlUU5+48qpiFi5D4Uc3QbgVkujKdXE+wtUahMQkzC+As2ymmPncA5eJdMe/vHZA6hbshNFNunai63yo7TeYMtmbXnei0ldI0NaCr47tq9oT3SALVfb52lnJ0kWelIGBsHeWXIYA66Si0u+D58VQ1T8TDaKi7KZvZoaIZi0MeiIOBmNDffjcFz3Kbt88vz0fUDn8XgloeryYvU+j05tmQsTtMZO9dNmM330gHUMboupNRBQW8GbAqkMNGf5SVZPiadG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4513.namprd12.prod.outlook.com (2603:10b6:5:2ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Wed, 27 Jan
 2021 02:44:25 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 02:44:25 +0000
Date:   Tue, 26 Jan 2021 22:44:23 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210127024423.GL4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
 <20210126011043.GG4147@nvidia.com>
 <328b9c06a18e48efbcc4121c5d375cb7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <328b9c06a18e48efbcc4121c5d375cb7@intel.com>
X-ClientProxiedBy: MN2PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:208:23d::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0001.namprd06.prod.outlook.com (2603:10b6:208:23d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 02:44:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4aoh-007KQu-VC; Tue, 26 Jan 2021 22:44:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611715469; bh=F9CSOF88e9CdtCrouUZFAmqN8ZA4YXMuAivyQAbPhCo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=cY9dOkMuTu7z0Z0xDcb2AYTP8tm+3C//uJmSHZ9l8/hXe3Ynz4QehO4K6qIleqspz
         +db6GuKQpHTCFtY8f2IaBgXA9SYES7w1bghuXJyx4xbV51Z2C1MNCsj7pkxRluzWdk
         1w6XzAKMIwD0jnjI0q/9hj2zYLT4M83KhkVXFmFY8LR2/kc6IDYf/yLgKLOip8TgnU
         hbEY/PVP3HfXo2jYkU6FCAlRE7Ia3JJ0qyjDlLIVUQoJTHdSAj9aCGOk1gtr6dc+Ka
         DoMfUBGBmTEWj7qYVmrzZyBfmTuCZW+IcJrgbduwu5+NaD79vAfJ4YRCO8s8/V1ss0
         P6Lr93O6WEvfg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:42:09AM +0000, Saleem, Shiraz wrote:

> > It does, the PCI driver is not supposed to spawn any aux devices for RDMA at all
> > if RDMA is disabled.
> > 
> > For an iWarp driver I would consider ENABLE_ROCE to really be a general
> > ENABLE_RDMA.
> 
> Well the driver supports iWARP and RoCE for E810 device.
> Are you saying that this generic enable_roce devlink param really
> is an enable 'rdma' traffic or not param?

I've thought of it that way, that is what it was created for at least.

Overloading it to be a iwarp not roce switch feels wrong
 
> > Are you sure you need to implement this?
> 
> What we are after is some mechanism for user to switch the protocols iWARP vs RoCE
> [default the device comes up as an iWARP dev]. The protocol info is really needed early-on
> in the RDMA driver.probe(). i.e. when the rdma admin queue is created.

This needs to be a pci devlink at least, some kind of mode switch
seems appropriate
 
> The same goes with the other param resource_limits_selector. It's a
> profile selector that a user can chose to different # of max QP,
> CQs, MRs etc.

And it must be done at init time? Also seems like pci devlink

Generally speaking anything that requires the rdma driver to be
reloaded should remove/restore the aux device.

Mode switch from roce to/from iwarp should create aux devices of
different names which naturally triggers the right kind of sequences
in the driver core

Jason
