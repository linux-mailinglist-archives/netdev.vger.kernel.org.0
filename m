Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F783048F4
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbhAZFf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:35:58 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14684 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731269AbhAZCQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:16:38 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f69780000>; Mon, 25 Jan 2021 16:59:36 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 00:59:35 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 00:59:32 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.58) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 00:59:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhcIdDawDpsvXVs+xFNzrwiBrM6Ye218q4Xl1BSIzU0Ig/WgQvtsUSOmuz5KbllFEhmCJ2D0zCMFeS1lg8ua2C+4Pa5zd3fv9PXKsaHiZopWuWNxvJjFhvkg4ngnZmza2igh7hdjgtntlkm/GDG6vYrgg+YnHWO9BsqLbZGQX3fB4x3FLvK/UPnctb/W3RQ2LLqDz0p+FxO42/J0zVLLUw2RPbUMkUCwPsvwOprXu49p5N7aoi3YRgrKFkiTvi+sZ4Rg+QMzqMEzFFEL6i5QX73puhhknpxzxR1tBgMuY+FRbsfdRlv9wu+iSgyKyVpPyE08f6e/8qMlHU3UqrI7nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDaFVbmeFQ0AzNIkoX0Mlv7rJPGfwNx0DNCu5ENH0pI=;
 b=jByClsGDK+36rJxdW3TIlzpawoVRtCbrr1Y21JoZjjsJ+QjTFa0ZjY9iLioSXorXDv27isDmwoBP8jhn+bbbvb1z1mm3qEJhwvfUPQh7XAKLWTocfqM0rVclO3H+GHuv33wD2ckBZplp+YwoSzqrQ6KOSD+gMmtnQvdc8RQwSyGHJ9gkGaYIb2dXp+p5I2I08BB9vsE+3V30flxC9mUQHrLzAnh1v0MQ1/bKQqQ4z3TigCL1V6eXMfhjty5XXmhA3fDROKKduPlOmhoZmDwwIfcVQ5h3JzYnHu9np535wdM6MixOuvBTxaVZLvngKC71KA/aoajDAs7Cb7JYpebWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Tue, 26 Jan
 2021 00:59:30 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 00:59:30 +0000
Date:   Mon, 25 Jan 2021 20:59:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210126005928.GF4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <99895f7c10a2473c84a105f46c7ef498@intel.com>
X-ClientProxiedBy: MN2PR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:208:237::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0063.namprd15.prod.outlook.com (2603:10b6:208:237::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 00:59:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4Chc-006tBh-L1; Mon, 25 Jan 2021 20:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611622776; bh=IDaFVbmeFQ0AzNIkoX0Mlv7rJPGfwNx0DNCu5ENH0pI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Im12xVbjXtaWsZAc1FGPK6Ic241J8zICcrvQjtbgF4eRENPuUP5ZwMpxSfAssRR1U
         P+Zqa1umS91KJsWngWrRoKoGchZ0Xyyid+UyVt2Cx5e4wSnMJtJjEj7kkFsY4B4VpD
         X3B5oe6aS7YRCrbX8gR/Qr4+KYFYdM2Qj/6nf1IiPH8MkowFL8JXcBGbu70AgWgPkB
         GBS6QA0C1573j99zIIeRO6xCAJ+1xOCvFOq3enRy0aKpnpBWL4lN9Umbl7x11o/lmV
         uYR9rukW7+1PVXpcd8bghxPlVvgK3In5fPlQaljoz6JTopDlkePIyRbhdGiO/CluqB
         LViOCSIzENPag==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 12:42:16AM +0000, Saleem, Shiraz wrote:

> I think this essentially means doing away with .open/.close piece. 

Yes, that too, and probably the FSM as well.

> Or are you saying that is ok?  Yes we had a discussion in the past
> and I thought we concluded. But maybe I misunderstood.
> 
> https://lore.kernel.org/linux-rdma/9DD61F30A802C4429A01CA4200E302A7DCD4FD03@fmsmsx124.amr.corp.intel.com/

Well, having now seen how aux bus ended up and the way it effected the
mlx5 driver, I am more firmly of the opinion this needs to be
fixed. It is extremly hard to get everything right with two different
registration schemes running around.

You never answered my question:

> Still, you need to be able to cope with the user unbinding your
> drivers in any order via sysfs. What happens to the VFs when the PF is
> unbound and releases whatever resources? This is where the broadcom
> driver ran into troubles..

?

> PF due to underlying config changes which require a
> de-reg/re-registration of the ibdevice.  Today such config changes
> are handled with the netdev PCI driver using the .close() private
> callback into rdma driver which unregister ibdevice in PF while
> allowing the RDMA VF to survive.

Putting resources the device needs to function in the aux driver is no
good, managing shared resources is the role of the PCI function owning
core driver.

If you put the open/close on the aux device_driver struct and got rid
of the redundant life cycle stuff, it might be OK enough, assuming
there is a good answer to the question above.

Jason
