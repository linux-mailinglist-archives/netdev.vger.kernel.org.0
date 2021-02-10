Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE107316F5A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbhBJS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:58:10 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4523 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbhBJS4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:56:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60242c2a0000>; Wed, 10 Feb 2021 10:55:38 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 18:55:37 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 18:55:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8bOV4Ueq91K0CbsOYnPHz8D9+XUKPR0I1LoeYqUkP5jtclHQEaRWBDSyYjd8sc2n1rTFHVAwf7mZvEzrmPPly2tK4NBN7WpXC/m/PtE9Msj02d34wrS530Cl0TBclS0JSKXXWIIrXPiifRcS3P+j2OGelJV5xa0VPiW85anEoZBRNFlicu/cU+d8Ki70fbvKIr6d56UYX6cd0c7loWNaLgbROtKljU3Fng2Pg48pDs7H+z68uw9EkYjWVB0lv/Y2M4uf+Psjlv51h8O3oHHJwlVfxymxD7FIIUeTXglVOmo0zuPfGFeZr9YinOX9cyovh7iqTAuPghVrud/crXPtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYgPlsnyvQtj7YL3GZ4IO1yLvnODq9d0qB/LeIoo8x0=;
 b=ardn2IPjbnPXxWvvcN4BgMp33U6ECWB5kUOAml3LKFSdUJW/64hdNh1YUG1mlKQ1VHmHCd9LnxLYlqd0Fr4NL4/Y9m3r36FRqXoqFx5pumxMy249R6SetmOyatv3vOn5S31VLzm3LJZydUIglcyikonMykgaRFa89g5B1Vvnj0djhmOVRHDZ+bmMOo+E/+EzGygRvs2+wnBU5PGfy2l5HziDx6+2qcAjIsJ08RzT+WiTJFTJTCiWy99lsfjA/FnLA1n2KdMisz6DP3BVRvDA2ZmPo7sRPdMQd5NJRNHJo81UEPdBbfynfyb1aLgm/2T0TyUxRRC/KoUtpxqsEo48nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Wed, 10 Feb
 2021 18:55:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 18:55:36 +0000
Date:   Wed, 10 Feb 2021 14:55:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Nathan Chancellor <nathan@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH RFC/RFT 0/2] W=1 by default for Ethernet PHY subsystem
Message-ID: <20210210185534.GF4247@nvidia.com>
References: <20200919190258.3673246-1-andrew@lunn.ch>
 <CAK7LNASY6hTDo8cuH5H_ExciEybBPbAuB3OxsmHbUUgoES94EA@mail.gmail.com>
 <20200920145351.GB3689762@lunn.ch> <20210210183917.GA1471624@nvidia.com>
 <20210210104329.3ecf3dd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210210104329.3ecf3dd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MN2PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:208:fc::42) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR02CA0029.namprd02.prod.outlook.com (2603:10b6:208:fc::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 18:55:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9ueE-006BGe-Uk; Wed, 10 Feb 2021 14:55:34 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612983338; bh=rYgPlsnyvQtj7YL3GZ4IO1yLvnODq9d0qB/LeIoo8x0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Q8ewS7KGb2DuyAWGkMQM4y+L+t1wSeOD1ROagVYmRpBQL3D6lNwIB9NmptJnV+b2U
         NxCfh4fLPSr1eJFMIyMnmHRn+W7bD7FCCStuRMm2fmZTKhzJdGMNbaNBK3fYRqhw5m
         jwxgwvQdPkvjvPCN3jq+JpGIXAZ+a3w7ufxhGBUMYMnYVJVv1lTVslnTwraHefm8aT
         oWrHM0r84+DmLK+rn5Oov8rIC755v3OVuMnfTHnOjKFbEUsaSxd4fkXdIA0ajtgxnF
         0M4TtYEfL8IZ9qLoPC2RX5mHmOHT0IVc2/KtinV+3rNXO/ypsJG3BfjzKgn2jV+VJf
         UDcCnfhK+JT2w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 10:43:29AM -0800, Jakub Kicinski wrote:
> On Wed, 10 Feb 2021 14:39:17 -0400 Jason Gunthorpe wrote:
> > On Sun, Sep 20, 2020 at 04:53:51PM +0200, Andrew Lunn wrote:
> > 
> > > How often are new W=1 flags added? My patch exported
> > > KBUILD_CFLAGS_WARN1. How about instead we export
> > > KBUILD_CFLAGS_WARN1_20200920. A subsystem can then sign up to being
> > > W=1 clean as for the 20200920 definition of W=1.  
> > 
> > I think this is a reasonable idea.
> > 
> > I'm hitting exactly the issue this series is trying to solve, Lee
> > invested a lot of effort to make drivers/infiniband/ W=1 clean, but
> > as maintainer I can't sustain this since there is no easy way to have
> > a warning free compile and get all extra warnings.  Also all my
> > submitters are not running with W=1
> > 
> > I need kbuild to get everyone on the same page to be able to sustain
> > the warning clean up. We've already had a regression and it has only
> > been a few weeks :(
> 
> Do you use patchwork? A little bit of automation is all you need,
> really. kbuild bot is too slow, anyway.

Yes, I bookmarked your automation scripts, but getting it all setup
for the first time seems like a big mountain to climb..

I already do compile almost every patch, the problem is there is no
easy way to get W=1 set for just a subset of files and still compile
each file only once.

If this makefile change was done then my submitters would see the
warning even before posting a patch. It is already quite rare I see
patches with compile warnings by the time they get to me. Even
unlikable checkpatch warnings have been fairly low..

Jason
