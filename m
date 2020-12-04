Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01BB2CE5BF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgLDCer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:34:47 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9590 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgLDCeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 21:34:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc9a01e0001>; Thu, 03 Dec 2020 18:34:06 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Dec
 2020 02:34:02 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 4 Dec 2020 02:34:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neV6i2rTFJzclmRUvqJMdO3c9WRE7DiSo2JSf0ZyExGe73xdxQap1D+vNPlPTY7WLou8mT5ND0kG7tc2fZe/gwRzOH/11sZL7XaSLxYM5/USyUUr5IbrX9a3tzIV9Xq+NFh+dRnaGKgD/Iy/VzR2IAxWL5YOfTZhCijbtovsUPhdzz8z9eUUR/HoDPkOXvMQf8MQ3ODimoeaUpWUAvkx9JfkfdiX3YtFTe52Q839UeHfGb2fNAzB4ejtaZ0l2gOq9LRXEzCYYJ0gLbGqPeEMJfhyc+rB4GjokKeyJDxMSNX6Y3YO8m8uhJ/ea2rYuzRcKxh3ZJ7qSkelQDyQbH7CpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDnLOQm/6hPonXigSnC6fjT0LzfVFaR83ws4ovOlwM4=;
 b=KAn83/RBc8LV7BZJg3Vj4iVANe3HBwgSTwePhD2eLiMoFOXgDqR1Inp0svF7a+i/+NP22sEBxFPELEHSvkAw/fxELHPd3zYZhft/bCNUMiWABzv7ZsEbUuZ60MROuwiHNiH9ZTfNkiRaNVBryUNYbUPTO46ZAhBQ9xT7txGraVdjNbuJD+XmZv2r18D8oEfnQFCdeLPH4tNTjKZVBLtOykNtb2GCrZxorLI2CqIoS/ufLepx73XzqGlJ6sokp3omzPGBujsCwpl+3D6xGlRUx3COSI/hMdTwMfy9TWHKWzue9W9jBEddBC1hDTuSD1ox0t9Hbg2rR5XsLUa2oeQBaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BYAPR12MB3254.namprd12.prod.outlook.com (2603:10b6:a03:137::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Fri, 4 Dec
 2020 02:34:00 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::8526:bac7:a712:ef8e]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::8526:bac7:a712:ef8e%7]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 02:33:59 +0000
Date:   Thu, 3 Dec 2020 22:33:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Dan Williams <dan.j.williams@intel.com>, <broonie@kernel.org>,
        <lgirdwood@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201204023357.GA1337723@nvidia.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8j+8DRrPeXBaTA7@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <X8j+8DRrPeXBaTA7@kroah.com>
X-ClientProxiedBy: BL1PR13CA0064.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::9) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0064.namprd13.prod.outlook.com (2603:10b6:208:2b8::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.7 via Frontend Transport; Fri, 4 Dec 2020 02:33:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kl0uz-005hoX-Cv; Thu, 03 Dec 2020 22:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607049246; bh=MDnLOQm/6hPonXigSnC6fjT0LzfVFaR83ws4ovOlwM4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=hkf7wHAUvczFBSrN6qGp9csG5K8wHFSseqryz8oNV2GLgBd2AU1mVFVaBHDn6RQxq
         FOQ6duy3v+i8Wsof9By2qiSW3DuRGkHnO5amFPB32bNbUw1Ujq3YzRUfnTfPbK7O9i
         bST2WLBOMuAfFp0zi+izUQXL4uqe4WFTRtVSqrr2FfZD4oysG/JYrYEqaE87nDon2x
         sVNIs246xOfVc3/9+QBrK5lG6qcMzTkEFTHoeSyQnWdaaZcsjXNQolvS5T0E4IfUcf
         s61AX1CdQUgcDtiBnjOhJizLrFlq8+nZkE/Q3rHidqESQYmNrFBclYztBtBp62gols
         mRic3tMOwYDFQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 04:06:24PM +0100, Greg KH wrote:

> > ...for all the independent drivers to have a common commit baseline. It
> > is not there yet pending Greg's Ack.
> 
> I have been trying to carve out some time to review this.  At my initial
> glance, I still have objections, so please, give me a few more days to
> get this done...

There are still several more days till the merge window, but I am
going to ask Leon to get the mlx5 series, and this version of the
auxbus patch it depends on, into linux-next with the intention to
forward it to Linus if there are no substantive comments.

Regardless of fault or reason this whole 1.5 year odyssey seems to have
brought misery to everyone involved and it really is time to move on.

Leon and his team did a good deed 6 weeks ago to quickly turn around
and build another user example. For their efforts they have been
rewarded with major merge conflicts and alot of delayed work due to
the invasive nature of the mlx5 changes. To continue to push this out
is disrespectful to him and his team's efforts.

A major part of my time as RDMA maintainer has been to bring things
away from vendor trees and into a common opensource community.  Intel
shipping a large out of tree RDMA driver and abandoning their intree
driver is really harmful. This auxbus is a substantial blocker to them
normalizing their operations, thus I view it as important to
resolve. Even after this it is going to take a long time and alot of
effort to review their new RDMA driver.

Regards,
Jason
