Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1738F304975
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbhAZF2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:28:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14828 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbhAYSqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 13:46:13 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f11b90001>; Mon, 25 Jan 2021 10:45:13 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 18:45:12 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 18:45:03 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 18:45:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YV8qDjlr1pKsP9zBIytQYQiheRheqs83z6ekeewoaRYrfxxDXF1gePQfoxkJunSbdAg+wUrEwzoweqrNf6bOsf5ytPxqAFwf9siVQ/kZbK5g4YWS9eVpNO3eSuo6/X14D6i6fuc5MP/Vb7Rpj5EfxyNB3rgplTRjlybv5GBbZ8t0TAxeKET8XDMtAUvidpc6zh6D/0lzLWAi6B/kV7zZwG0a/tYa7Vh4GupKV98hw/ZGjqNBhrdUHCP6n7+kf7OKaC/k3ZHz02pxdr3DRLuto3dUS3Z+V4VfcB7uMSo5q2xVbxlstFGu/M2Ms088VQE2QqHh0kNQeotwtJzV5JL+FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSy2yYBC/NjThR93iPuQBSOuGsHdFHqfmT4NoBDJ7oY=;
 b=VyIUepXciwsYlScZRbI7qv3GUmUwCdIwhby6xS/2//LPhQQ5wNjklLdzHNPDXlsFsEdZ7AsectpmUbn9l9wqZl4Qx9JxU8WtjWvJYMKz3sSedTnZowad3lcXqebCZRrc7cQ9P0bl9w8XYBUW9dqAV0g9/Vnc91aNA+a61ux5oUKezSVC+PSEDD8LPsM2DjcnYCIgY+TkcOH+BbY4LMIMgsFTSkOZbgiYi/fKhHcEKC+KbHrnD/hARiEz2T6O1OdfdLza5l2ELNdCmcD66CBNm8cplxPpJGWb1PJkSKHmbmmYGT6gEQZ9+6VihqIZN4yolQ2KRR4p4MGtiglPBK7Vtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1882.namprd12.prod.outlook.com (2603:10b6:3:112::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 18:45:01 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 18:45:01 +0000
Date:   Mon, 25 Jan 2021 14:44:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 00/22] Add Intel Ethernet Protocol Driver for RDMA (irdma)
Message-ID: <20210125184459.GT4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-1-shiraz.saleem@intel.com>
X-ClientProxiedBy: MN2PR17CA0006.namprd17.prod.outlook.com
 (2603:10b6:208:15e::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR17CA0006.namprd17.prod.outlook.com (2603:10b6:208:15e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15 via Frontend Transport; Mon, 25 Jan 2021 18:45:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l46rD-006hBO-Qs; Mon, 25 Jan 2021 14:44:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611600313; bh=dSy2yYBC/NjThR93iPuQBSOuGsHdFHqfmT4NoBDJ7oY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=QoSROKaRfO6p+TafXU0lNRP3I2Li6ZGzreDaS8z6d7JdVOTEXJcPL5gAUGPEJZW0V
         PlXHZuKwIWjjaUsOWd5kAzNpa71qS+ZFkMGuPi8uKuNyXYTwF5q8kcTyC0rewO5RvO
         sXyRf1tGQaiPCMd0PuhEcjFWXWTMMZSLZuswpjeWB6AK3ZKu+KFxdu86QpGhMPOBc9
         AGEgrV+9Zlej+rhjnoUcmYp8F030Q4ofd7ZzwSZBflSBEHQFELwnBBIQrQAskIoZfh
         QZ0yL26wnaLP9EEqk4/p2VhmVyxqF/7WZxAd/J7OHgFvwIymVi9A0bMXDAuB/pRSCY
         ACVYDmRtZ7cBw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:05PM -0600, Shiraz Saleem wrote:
> From: "Shiraz, Saleem" <shiraz.saleem@intel.com>
> 
> The following patch series introduces a unified Intel Ethernet Protocol Driver
> for RDMA (irdma) for the X722 iWARP device and a new E810 device which supports
> iWARP and RoCEv2. The irdma driver replaces the legacy i40iw driver for X722
> and extends the ABI already defined for i40iw. It is backward compatible with
> legacy X722 rdma-core provider (libi40iw).
> 
> X722 and E810 are PCI network devices that are RDMA capable. The RDMA block of
> this parent device is represented via an auxiliary device exported to 'irdma'
> using the core auxiliary bus infrastructure recently added for 5.11 kernel.
> The parent PCI netdev drivers 'i40e' and 'ice' register auxiliary RDMA devices
> with private data/ops encapsulated that bind to an 'irdma' auxiliary driver. 
> 
> This series is a follow on to an RFC series [1]. This series was built against
> rdma for-next and currently includes the netdev patches for ease of review.
> This include updates to 'ice' driver to provide RDMA support and converts 'i40e'
> driver to use the auxiliary bus infrastructure .
> 
> Once the patches are closer to merging, this series will be split into a
> netdev-next and rdma-next patch series targeted at their respective subsystems
> with Patch #1 and Patch #5 included in both. This is the shared header file that
> will allow each series to independently compile.
> 
> [1] https://lore.kernel.org/linux-rdma/20200520070415.3392210-1-jeffrey.t.kirsher@intel.com/
> 
> Dave Ertman (4):
>   iidc: Introduce iidc.h
>   ice: Initialize RDMA support
>   ice: Implement iidc operations
>   ice: Register auxiliary device to provide RDMA
> 
> Michael J. Ruhl (1):
>   RDMA/irdma: Add dynamic tracing for CM
> 
> Mustafa Ismail (13):
>   RDMA/irdma: Register an auxiliary driver and implement private channel
>     OPs
>   RDMA/irdma: Implement device initialization definitions
>   RDMA/irdma: Implement HW Admin Queue OPs
>   RDMA/irdma: Add HMC backing store setup functions
>   RDMA/irdma: Add privileged UDA queue implementation
>   RDMA/irdma: Add QoS definitions
>   RDMA/irdma: Add connection manager
>   RDMA/irdma: Add PBLE resource manager
>   RDMA/irdma: Implement device supported verb APIs
>   RDMA/irdma: Add RoCEv2 UD OP support
>   RDMA/irdma: Add user/kernel shared libraries
>   RDMA/irdma: Add miscellaneous utility definitions
>   RDMA/irdma: Add ABI definitions

I didn't check, but I will remind you to compile with make W=1 and
ensure this is all clean. Lee is doing good work making RDMA clean for
W=1.

Thanks,
Jason
