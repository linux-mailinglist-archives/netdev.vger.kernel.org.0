Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6572DE3B4
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 15:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgLROJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 09:09:47 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:20939 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbgLROJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 09:09:47 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdcb7fe0000>; Fri, 18 Dec 2020 22:09:02 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 14:09:00 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 14:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JoYn5ucAb62TBndhdo+39D7KTtQVPjq+OLzQ4hgrbDlB+EXonyWGYw+vnkxWSNpVVdO88yPUSP1flStOcbrCsB4meeMWJsOdLMXoeVzxWw8z5BvVX2xXDgJ7vXeN0CnxzlqiyCDsNo1Xhu9mRFMeOzLhZyVJvxF7J/t6iDrM/n68dR63JYD7zyiZYzmLsC9vxU3jfv15RFTRjExVFGi8FTBpHIKQtu8MuCe+bAMRgnEXvKIArQwAefd95EQ7Iuykd42g0I/jso4lk2F06+YIPWm4oNHGMpnM4fj9xLaSArOmoFIOu/UJ7r+Vp34S13cy6ZQltfw3ybLhUsoP6xlXLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqxdLmDnf0NVpgTU0lP9G0CPHgb64TOJPJ/P8z8Dc8U=;
 b=ltvny34KhEquTQoAFGZJSF7E5cVJxFSTZqvN/nr/GEm0FR353/qZOw1Yo1AEx2xTG9bHu4uxEVTBH3qY+LHOSb6cWFOn+gpPpHhjcZmrIy+ggjUHJEkPDzcxpnlq6z8jKEDPLp6nk/xYVrJJJEM9r/ObRlZgS7Kx6wBpJS+YeUdAiEMJ63ZZa6o3UeT3hky1ma5m2PNvvPqYv2xq2vkt2Nnx1lpyyARe8f2DTVulEn7yIV+TGEA1SavfbKPacx8oq9TmybDfmedRqtwRHWYvU0q+nchWhRYZyJu2IQYsADCoGrBBbR3m2ETWuZJrs7eAdKU5Ybx/oGBR/Qu0cIH5xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Fri, 18 Dec
 2020 14:08:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 14:08:55 +0000
Date:   Fri, 18 Dec 2020 10:08:54 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Brown <broonie@kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <alsa-devel@alsa-project.org>, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Dave Ertman" <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, <lee.jones@linaro.org>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201218140854.GW552508@nvidia.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
 <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com> <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com> <20201218131709.GA5333@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201218131709.GA5333@sirena.org.uk>
X-ClientProxiedBy: BL1PR13CA0392.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::7) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0392.namprd13.prod.outlook.com (2603:10b6:208:2c2::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Fri, 18 Dec 2020 14:08:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kqGRC-00Cg9S-2d; Fri, 18 Dec 2020 10:08:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608300542; bh=FqxdLmDnf0NVpgTU0lP9G0CPHgb64TOJPJ/P8z8Dc8U=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=P3bQzSnN2N1kR/c2ruQqvBBXyTIAePZxtznSnSZhxZocH22xrPnPMcj0epcAhzBiA
         D2vmq54B8kq4cn44ri+yJbT/cof450WbIaOnnHoZXAeLrE997aQUbKX2rnnklVGbn1
         p74dBh7ZBNnLPfXVybBas5TYj/NqNd72EgVNZb5/MP3Ws4P+R1l77WLOMcGEGbEiPd
         mh0ICzdJRO9rHLkVfkX/ltcd2BMyUwYBYjo1ceYgoVuwBoumn+19eE16OK+7z3/5ia
         9ZZMYIi6KcCcmBzG1bISAhIox3/suLl/uM/DB2suG9/l+F97CILWWgkAu7O2VZXFvp
         4lSalwb8Kp8Bg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 01:17:09PM +0000, Mark Brown wrote:

> As previously discussed this will need the auxilliary bus extending to
> support at least interrupts and possibly also general resources.

I thought the recent LWN article summed it up nicely, auxillary bus is
for gluing to subsystems together using a driver specific software API
to connect to the HW, MFD is for splitting a physical HW into disjoint
regions of HW.

Maybe there is some overlap, but if you want to add HW representations
to the general auxillary device then I think you are using it for the
wrong thing.

Jason
