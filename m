Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989FF2DEC14
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 00:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgLRXhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 18:37:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1379 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgLRXg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 18:36:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdd3cf20000>; Fri, 18 Dec 2020 15:36:19 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 23:36:14 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 23:36:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUM18Li+OD6oZot96kwzfdpwhALdNg1E86WLn4EGUzQBtmc0og9ERAAY6Pu+uzK1QXAadzF9+MUWIZ3RNbMEeIR74kYVP9EMUrRuqwwaOHTjV1YzazaqWmGZKQZJgL874xkw6dLi8L/vww35ZsapzsWrgF5MjZn5zVe57ZtSjj5OtbpXBjI5c4pbNoS+3D4GvQb6pGff+EZF6xDM8bzkr7YzCFEw7pjqj1kc9AeCeRpCqNaBspHzfVyiHSeTmn78Qhv/ab5iWGdPwKdGLotRlhorNXc5m+qRQkiJUIjM/uoCR0e5vDeSmp31lOqE5BzLVbjVlEYvugH9EzpNYf/ziA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOoZnI1dWjtEDwoJCz481pyZxuXVUsn9C9DiAjS/ycc=;
 b=A5Ag30jNJLzs/wUhvL1apO51GmEta+wao6D+5tRyC2Laah3FEeXbx4l2BpPUVPPplAmakBCeCBvkeR7ucLILW7q/yZ2DOemttstZFBai5h8BUOlGsmiIBczoKwDduA6rWqQSffDWouIpmpFO3kRdq5r/edriqWpqYsrXPHAM6jL5tD6iyCiENnrWH7e6ht7G9JpUcyxAuflMhBMv499wCfNYLAV7RgKv/LqY9+0JMxqgmMdlndIX+nRxXMuOWawJMX6fEDR51k/0x/dgDtLpKBIaDWRhdIkD4dMVlZSYjiTcRpwsE2dOQJpmf0TfRIiD/1oD6UMO7v2kKxAESfZALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4250.namprd12.prod.outlook.com (2603:10b6:5:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Fri, 18 Dec
 2020 23:36:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 23:36:10 +0000
Date:   Fri, 18 Dec 2020 19:36:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <alsa-devel@alsa-project.org>,
        "Kiran Patil" <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Ranjani Sridharan" <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, <lee.jones@linaro.org>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201218233608.GA552508@nvidia.com>
References: <X9xV+8Mujo4dhfU4@kroah.com> <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com> <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com> <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com> <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com> <20201218211658.GH3143569@piout.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201218211658.GH3143569@piout.net>
X-ClientProxiedBy: MN2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:208:23b::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0018.namprd11.prod.outlook.com (2603:10b6:208:23b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 23:36:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kqPI8-00D0qq-6X; Fri, 18 Dec 2020 19:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608334579; bh=bOoZnI1dWjtEDwoJCz481pyZxuXVUsn9C9DiAjS/ycc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=BSODxxd/ar+TcgODfIh6ppHx4AR6kDVAUk470dVqSWPro4nSIQArmHHgV8QOIRbax
         XNR4GetYf9KwxkDhv12jsLKxLGIo0StEMZAAgAEamLUo1fU1oSI8JFsW1VqMmrzVo2
         cNddSRtIQux8jXOzG9f3lRZtWTgoMJmP70XA8JKbCmJk7+zyt2HTDWP6JXo1/hymt8
         TlD/klmyLBZxs5Ogfy/OdwuuzAw6nKIANOyNW0oeegxsBM2q+s0/YLl0sAxQAQ8F7P
         9sP0pLXalIJHG6yC2/tYKfClffHJMYBGBVvp/1gmXIRL80FoYw/oNaAxHy6u3uZo7s
         mUomKkcABraHQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 10:16:58PM +0100, Alexandre Belloni wrote:

> But then again, what about non-enumerable devices on the PCI device? I
> feel this would exactly fit MFD. This is a collection of IPs that exist
> as standalone but in this case are grouped in a single device.

So, if mfd had a mfd_device and a mfd bus_type then drivers would need
to have both a mfd_driver and a platform_driver to bind. Look at
something like drivers/char/tpm/tpm_tis.c to see how a multi-probe
driver is structured

See Mark's remarks about the old of_platform_device, to explain why we
don't have a 'dt_device' today

> Note that I then have another issue because the kernel doesn't support
> irq controllers on PCI and this is exactly what my SoC has. But for now,
> I can just duplicate the irqchip driver in the MFD driver.

I think Thomas fixed that recently on x86 at least.. 

Having to put dummy irq chip drivers in MFD anything sounds scary :|

> Let me point to drivers/net/ethernet/cadence/macb_pci.c which is a
> fairly recent example. It does exactly that and I'm not sure you could
> do it otherwise while still not having to duplicate most of macb_probe.

Creating a platform_device to avoid restructuring the driver's probe
and device logic to be generic is a *really* horrible reason to use a
platform device.

Jason
