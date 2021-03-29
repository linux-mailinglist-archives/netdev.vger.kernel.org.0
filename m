Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CDF34D489
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 18:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhC2QIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 12:08:24 -0400
Received: from mail-bn8nam12on2071.outbound.protection.outlook.com ([40.107.237.71]:15297
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229910AbhC2QHz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 12:07:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PIASu2vB0+63BdkDt6kTccNGted0Y4mmq+QxLuG64s/eYKxZ2ZDxctOop2fEcr4WTN6Rtu1QtrDveVKQyZXbzwjzVZhys09J9wFvgu3u6jX8J2sUZ9JvgwXhdRbHQBmD5+uBUILgeMAe+TAKujvykMj1Efe/u9yk7hkKJzLphX965/aBwy50rZGDx7x/Uvi0fvxmoMGp+F69jkZmtFDWnCAFZ4s1slquO7XvvTKgXRZDAkoPicxw8+I1MOQtmhoq+Vy2mniuzGWgagXxjEENcAPk5I2QjPBapAb4K07aDYMh8z7Y/diMnvoPiyxbTUs5mqPnd4hM6WGjFxQHeIfvyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDwd6AAytr6q0P2d85b2dFhVaOmLS6hYI9OVs/ofP0k=;
 b=hUhDPpRqqIw/+euN62qprcgLP02FwhiwkfuAGCYdlt9ME2g5qJfUIqEoPNvzOJXgp74bSXB1AId45NsNHEuh6hunUHSTr8tZNlInYGPbfWHRVG5SrqsZkddQmJCZgGGQJoE4fIuHIP6wn5g+oSvlKbEtemDaHZDeo3sU2nvKJAuiUPSdacr/3m5YAIh/yIV5x/yCddHjAnpPhJG4nmrCEznOhpv1UeS3zh875FKI1aQkfLh5mWICXNskpHfJEMh0qTRc1xsmxrYqyIQLzn1dr+yUVgK029WX1j5kEdbNJb76jq28WmvDbWZMzALlHY6rduwFiCqBlG/g0S9IUMBYDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDwd6AAytr6q0P2d85b2dFhVaOmLS6hYI9OVs/ofP0k=;
 b=qsi7abo0vfTM6SO3cqsdI50Pva932/4/2DDP866ez6Klk9bGnIdGdFvalB7biDO9pMp3YAgb3WzvrW7U2q+m+02qNFoEN3YAOkkKeXQTzf5wPc2sNUZj0epfaOB3w9YDKFsxGf1ePlLIJnWCZhUy8gnfOKVVPLmSKlTmZxJGGpo5IrMmO+n3RPpmd0NNkXRgd7hWqCs55yNyonEnXHLCiwN3QkBKOIqEXvaYIEYGOJpKmM2dxe1P/psImWUvTplkdTSMaOuGVfUofdCU+wl8PFPi0V6zPJMaEUMKRyzVQsmPCm64zkGMuPl8NHYefCeFBYEiC0wvnXPVVZtUFNl+xg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3596.namprd12.prod.outlook.com (2603:10b6:5:3e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32; Mon, 29 Mar
 2021 16:07:53 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 16:07:53 +0000
Date:   Mon, 29 Mar 2021 13:07:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v2 05/23] ice: Add devlink params support
Message-ID: <20210329160751.GE2356281@nvidia.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-6-shiraz.saleem@intel.com>
 <BY5PR12MB43228B823CA619460AAF2099DC639@BY5PR12MB4322.namprd12.prod.outlook.com>
 <9ae54c8e60fe4036bd3016cfa0798dac@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ae54c8e60fe4036bd3016cfa0798dac@intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT2PR01CA0030.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::35) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT2PR01CA0030.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:38::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.32 via Frontend Transport; Mon, 29 Mar 2021 16:07:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lQuQh-00572e-Io; Mon, 29 Mar 2021 13:07:51 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b341f24-0cb2-4471-0867-08d8f2cccefd
X-MS-TrafficTypeDiagnostic: DM6PR12MB3596:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB35967F317BC595EF33821B73C27E9@DM6PR12MB3596.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YdNhvYcxmbgkoT7atpYlZYAhEbKFc4Vvi9fE6mHe5mg6aADkRkOxt70hiPUHncveotJgQAwMfE4y0y/yoE8A5pkXUMe4vp0DfkE/PIYyhMzWf8W8uINg3aHeCR5uX9cfWtFwA8ijBDPT12NHPCF5dQY/gVlyW8g0fhrVmHrF0GS264scN4KXioRnCnbSx/uvFdMaeHxrdxX88eAfkr3l5g9fF7/eRyn2y8b6hZlpUBf9iXBjS4RTCAwub3FiKT0a5TMXnPC+dZXUNE3B+0NRNYkkmmLwLaIulxZQVGazVNb52j5heD2rWHpdEq2Zluxyev3Y6X0OdffjLOx+z0DOiFCDlL3qjbArFV+KdQsuErO9Etho2+6ymofIxYYhLCnU2gyoy4wUcxa0LdVtgKDiXDRy/crlzEQq1NnX8iKtA0XZrcdd2aqfa9xNfukvLfg5dqW6d0jlWuH90MLnlWWo/pKZILP9/PQkxvOnUhdUaqZ/ycMruylCvifqFYY5YnJaRbbxQQNMkHg9dozZxFNG3lFb00s9VuRa+SiKeUNBGdyatRZSeYSHAJDtkLYncdea5cCpGvvPVNc91wKfnF+VfnFGlGI/gv5PotkQWm+T5Au/qaioeSflr+0LeujB69DHEp83Hsu8TiYbNq6G4yqz1RUoHy3Es8n9EWyG6A90NzE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(26005)(316002)(6916009)(33656002)(66946007)(83380400001)(2906002)(8936002)(86362001)(1076003)(66476007)(66556008)(8676002)(186003)(5660300002)(2616005)(478600001)(426003)(36756003)(4326008)(9746002)(9786002)(54906003)(4744005)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CSPY1p3fYWuVZS3nqcEi+6HIOzpoaUqOWlgRH4nyLz2iX5JTGksegeQPiq1h?=
 =?us-ascii?Q?7ksVEJMANCIAlVwr1zu+mn1PvVSQoS5/+QSTihQHy8qr5lIB4Uk6diA3c3XU?=
 =?us-ascii?Q?mAiEdec/mLZTyF/LXlbz3QKezVFFNgkJYgZkWI88xKMMgbJq2qxmGJLQFuJt?=
 =?us-ascii?Q?qe0DbAQB2/mZ0bl6tzDmxxty1AIuH0OWcL7tppet6Z4VqVro7t/gngGsUWP/?=
 =?us-ascii?Q?7tVa9CMANPoiPa9ggVmqXmXdYWw0/nDx//CiRkn0J3T1szds/Yz3p3YH2dDY?=
 =?us-ascii?Q?9BpBWkvFS9rtlcSCqY9glV58s6cFXcP8jJfo28A163abKOYr3uj6u/M4wCr4?=
 =?us-ascii?Q?NvmOQoADjHjIOgH5vid99WpkvrUaZw7kE7x7X8W8xnOFweD5Tv/36ju0JsXn?=
 =?us-ascii?Q?LPmey61d0mf0MkW5AaKJQ0cu5uGXM6YngGTMNnH+O9NQ0n9rZLhseVjGeeSH?=
 =?us-ascii?Q?XZQ55CrsOJCSfIdaRxck8a2Avw7vaBa7zggqBWnaG+83J7VMuypfSVbf6Cbg?=
 =?us-ascii?Q?aTMwDGPCvcrDIBaJTffPtUDK3yuu4z5/3qlqxXHyWuxerCx7U5WWaPnhtw8H?=
 =?us-ascii?Q?C+yqw11zlvUT1TbAU20g4TOoW2OXB7DBWlGzOQbYDiyWO11Wc9UKxY6En6jI?=
 =?us-ascii?Q?NRo7s2n4jPVCmxaGHZFE+1FCawSoloLuo16Q93kVPcYuWHYQCDG8Dk07bZiQ?=
 =?us-ascii?Q?YjVnxeCnNPWTH8ijtBkWKLFKZEXsSumSIGPbcikStlUw8W8/KNZRRtGEV05H?=
 =?us-ascii?Q?lM+uCKzyL4ExvuamnF13iCCG5+qNEq+JkKqrixZ8otBVCUPyElTc9r8LG4HE?=
 =?us-ascii?Q?zJgiBn1ovzU6u13KDVS0lCvJYlwLwV1l/46fdxUCZoH8Jmj4qngw3J9EMzfh?=
 =?us-ascii?Q?eWC/mYgK9bAFgZj9iHAxJakDtHhT1YeZ229RO5E7zVAp6cOpE5Kbp+WVJNSo?=
 =?us-ascii?Q?AcUfmJHgO2AEteFeZX/ToZoaKIaBLRgEcKMCi1y9gJgm6wto9S9r+394iK/0?=
 =?us-ascii?Q?3Zzn9oxcrbCuf8K61wFa+qrGxS04Zzxv9oE8UEiq2YP4XH/qGUR/Cb+idz3E?=
 =?us-ascii?Q?vvZNy+Fu4uAMz2HFQ3NFA1x5bplauxy8hhz24jmqDNqgo9sXmL0Kgch0xd7+?=
 =?us-ascii?Q?VcX6KQwTzbNC74S8kuTNQE9oS83I2wMACC/BVDlFzUf9dcXBpUKgKnFoV2hb?=
 =?us-ascii?Q?oiuznWq6wD3OyDWAoyrR0zdpvy5TDOj35Kya1iZCIO2ot6vGY4Fs3iDKwWAR?=
 =?us-ascii?Q?V78zR7Pr8YqoSLIk+dzVB+oiwPYdjY9wt1hitMk/s1mt8uw/qGQ4xUdX4k/2?=
 =?us-ascii?Q?2ddkV/WnVHavgL+ir59ElwYz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b341f24-0cb2-4471-0867-08d8f2cccefd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 16:07:53.6312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSX94XjtMiYwuWpYBF3hTYXE1qNECAmZjvYhwyQD4WHAxVkZOAESIELqji5CDw3G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3596
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 08:10:13PM +0000, Saleem, Shiraz wrote:

> Maybe I am missing something but I see that a devlink hot reload is
> required to enforce the update?  There isn't really a de-init
> required of PCI driver entities in this case for this rdma param.
> But only an unplug, plug of the auxdev with new value. Intuitively
> it feels more runtime-ish.
> 
> There is also a device powerof2 requirement on the maxqp which I
> don't see enforceable as it stands.
> 
> This is not super-critical for the initial submission but a nice to
> have. But I do want to brainstorm options..

devlink upai often seems to be an adventure, can you submit this
driver without devlink (or any other uapis) then debate how to add
them in as followup patches?

Jason
