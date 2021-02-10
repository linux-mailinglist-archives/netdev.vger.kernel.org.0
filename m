Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0456316EFA
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbhBJSna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:43:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2989 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234291AbhBJSkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:40:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6024285e0000>; Wed, 10 Feb 2021 10:39:26 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 18:39:25 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 18:39:23 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 10 Feb 2021 18:39:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZf4KpQZey3x47CcADjBrOvgaZAoh7tjdxV9io9aMH0q3Icl0GQENL763XQQ7pjwyF//XqV9b/4+b3Gk7Dhjf5/3f2XI14KYDfwpskZWS6M8+C5jJqbl6noOXkPlKNHrtkFV/922iLY6DCjMTBmAspbthO6Qm4JnOVM5cTsW18n/YJwv8QKU6HxVQfBTboOhlMkznau8nE4gUXv4NjDP+diUMA10bCCrp2GCxZGm3DwbRf0VHRY6G1zdOTgJPGevgBMpR+cMEqX/uc7U+yG45rnJ35P75i6HT7ZvmbidhA94NnfYdV86x9OATWfwPrPIJpPfc1/g/abkfnN1kDoQxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+1fF3YGvaAwGiuyydZ9vaI+XQmRulIsAF8ttOHCEDs=;
 b=Ma06Wnq9c9tkSX2fGPmHO+Pnt4+fBzRGD2MuvWaZqIlImWNqw3CbhOD/ck+k/DHKQuVhSHkGc6LS8I+gqm9v2ftwTkOeCEJmn78J4mXfphFXGhHvn4FnJdY5iuqy0gkVEXaaEmyRbt4KfF2q/443baYvIgcCbxLB3RzIw/aLmTC+A+GDiWnlO3gWDOiSMI+EfTwGJ00Y2u9wmDSm2yCfMBF+9ZrzVZVQvlrHJxKtVJ8/GAR/epw2vZ8pzzK+4zt57mpZ7kONI+7g0pbGq/qaV10oU4rqxDQWYHJGuEfQQXB3vdMer++CDFRG5RwFHovfBzO67AC/GUVTU8IUQd0KZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3017.namprd12.prod.outlook.com (2603:10b6:5:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Wed, 10 Feb
 2021 18:39:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.027; Wed, 10 Feb 2021
 18:39:19 +0000
Date:   Wed, 10 Feb 2021 14:39:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>, Nathan Chancellor <nathan@kernel.org>
CC:     Masahiro Yamada <masahiroy@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michal Marek" <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH RFC/RFT 0/2] W=1 by default for Ethernet PHY subsystem
Message-ID: <20210210183917.GA1471624@nvidia.com>
References: <20200919190258.3673246-1-andrew@lunn.ch>
 <CAK7LNASY6hTDo8cuH5H_ExciEybBPbAuB3OxsmHbUUgoES94EA@mail.gmail.com>
 <20200920145351.GB3689762@lunn.ch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200920145351.GB3689762@lunn.ch>
X-ClientProxiedBy: BL0PR01CA0028.prod.exchangelabs.com (2603:10b6:208:71::41)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR01CA0028.prod.exchangelabs.com (2603:10b6:208:71::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 18:39:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9uOT-006AsX-UT; Wed, 10 Feb 2021 14:39:17 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612982366; bh=9+1fF3YGvaAwGiuyydZ9vaI+XQmRulIsAF8ttOHCEDs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=OMUBIWj/MhQ50SfYJGpI+ZJuDiy/41MmBsvGNASJ7z2pJHb4Tq/bOpDGjeAaw5tej
         CYuHP5xl869i8qpv0sd5uG7bcOm5zmBSOsuAXzeGiH8y3kGQ2sFzG7xS1D4f1csioG
         RxYQXKjWegWPUNyH33rImLFa+HHT/p4hEo+GOgjdahIxRlpayIUKx0OeI5owrpHUeC
         dGn2DzGK2mCZMR65wjMZwe+7X4XNaVAsNaSFp8bVwf8NdpIQUpzO+DRV+Qd/IQ759l
         PjUOLs86XwSShSFqoSzhA83F0C6qv+dT2pBkufHb9JehHTOLu6kzhbycgGzrrK4IiM
         UtOyYw3iGEoVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 04:53:51PM +0200, Andrew Lunn wrote:

> How often are new W=1 flags added? My patch exported
> KBUILD_CFLAGS_WARN1. How about instead we export
> KBUILD_CFLAGS_WARN1_20200920. A subsystem can then sign up to being
> W=1 clean as for the 20200920 definition of W=1.

I think this is a reasonable idea.

I'm hitting exactly the issue this series is trying to solve, Lee
invested a lot of effort to make drivers/infiniband/ W=1 clean, but
as maintainer I can't sustain this since there is no easy way to have
a warning free compile and get all extra warnings.  Also all my
submitters are not running with W=1

I need kbuild to get everyone on the same page to be able to sustain
the warning clean up. We've already had a regression and it has only
been a few weeks :(

Andrew, would you consider respinning this series in the above form?

Thanks,
Jason
