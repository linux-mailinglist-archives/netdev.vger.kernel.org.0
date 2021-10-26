Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D67143BE24
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhJZXwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:52:31 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:8208
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233019AbhJZXwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:52:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyUb37w4W8X8fIiiR5x+EFV5bTaGNVTO9bFyh5knbTY9lRfIpFNoswNNqm8J9N5EHe8xU/Tw3UQD1ecxtfbSDwsqTgsLDEFqqo4RBJZrOUNdsurL1+RkHvJ3YKB6DIS9RKXymR6mogUIDb+igCWXrr4eGoY9+Jl+v7iibDTX+J+lEqhFRyP6YJY39l3uBMyFydMls5tbgwVbgTZ4dU9Ue5NrtqSUfetTUzKJZcX8A+UiF/zIHUuhRBY8sEnWghzAgzrCxerIJ8i3LHCfHiz1QwG3bKh9Z/S/8XK7CuZCi85XWLVWV73nOcHM04eR06CWZnWRTREfsCu+CZXqYY5MuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+YBruSr2rM8CufOmMx83icRANNErh0k1WeV/rTnhe0=;
 b=KGH/mr6s5GbofrvokrzOwLo7wFNV+4NTf6jrp4WIw8p+u6UofAZK6TsZ36Qre9hb/kUlanGbLjwgiaZRsYdLvoza22EZ0mQ4JQ/eLueT7J2hmZdPxZ1ruQRllbTbPeWb695lZl6O98o/bh/g+sBC7bX3FIWhQ5ccJOJyy65MWQ+aiJtSzIu0M2ebm8Ue+E39E7qFeQFyXFOOurHNEKjvMruFZ58T08/yX4H3c2zg+APmApf9QH0nqD8/zizt+xOLxFQKINAoMVSkaRXJgZ8c8r5f7zM9BbJviMBJabZQ/nlFrKDPvxStx9asWITfYpIrpVXEkkjPsw2JAeWYk1W/8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+YBruSr2rM8CufOmMx83icRANNErh0k1WeV/rTnhe0=;
 b=FTJbvu34570XLUoVbONnQ2gFF9m7prVQh/JZmQsSKYOsR9HZRHNftP1ac9ETh8HOIgME6fPHV4ksHiqazs9tbPvB1RcESvgNPyG9NxsWw6OK1BtCwxuKI1dz8HLmZ/tR/IrUmCx7/NxwmqCvYWvQzyJVIAFqufyTs+qQly1jFxKkfH1BoLLBDr93c7zw5HisIDNxVTgu7rkYJJS2KNM8PAwdpJVY9oc3RCwhKI3tDzdml5G3GG48rfJqk6b2Ly8H31S3c0vApKoTiK922iNnE8CHBSDYCCmGxqgXPpqWg06xwQhYd0PfiL4vccovAD6YTJ+UwcKG90iHu+3F3aknuA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Tue, 26 Oct
 2021 23:50:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 23:50:04 +0000
Date:   Tue, 26 Oct 2021 20:50:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V4 mlx5-next 13/13] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20211026235002.GC2744544@nvidia.com>
References: <20211026090605.91646-1-yishaih@nvidia.com>
 <20211026090605.91646-14-yishaih@nvidia.com>
 <20211026171644.41019161.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026171644.41019161.alex.williamson@redhat.com>
X-ClientProxiedBy: YT3PR01CA0042.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0042.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:82::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 23:50:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfWCg-002Etz-DL; Tue, 26 Oct 2021 20:50:02 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22d74b6d-22b8-4923-5829-08d998db54e7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-Microsoft-Antispam-PRVS: <BL1PR12MB508040D4244DA0E8E2AAF01BC2849@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFMCETv21UkQpVJsY3SRiwVSaTKqpPFyim0Z9xEBtwjYwBqEtGIHJ8HReFuWjDfanlDzPFlgUbjOt9XMTb9o2TZNakagIshIr3NGwLhePwZGL7Cxhm5VM+vXDmITAFO+gALiGfxeEIdO2EYxvZIv9gnJZm/a8pSgU0Ib5FJrnStxD1LurN/UUpJJOFBR236HWmobk3zEvIKPy5RFHgQAvy9gTH9go1wOID/cUwHPy0USpxVFkZUoJqm50lcFce+UWi6Jvr/V45pAXgGRmAlUiacIiOeHPBWKBEdXSfi6nFzPiMe9pPwhLQHJgUmtLgg4e/2F3JBqThZGJqRfwAksEhdtwV32a2h6Zx59L4Dep0VUbu5hx7ZWV8NA+O+VFHNXAssL0FAyEu6EtYj96M+aIqgmHCiJ9EECWvCAIOA44KbfpJOYWHRfDXGoUX3FNZHlMWwJM8Hw7aw/ixQd7d67e6WqAQscaIsYW09SBdy3X/OXL8fornx3p4wBnneS2Zl2ta5dM9ggwuQdb1rdP50ZStPnAjFbCPVr1lTmD9LaJbRug8EvxOjSogtTBApkimYR3IBZ/D9X1qANqDBcy52UiVl3NStfWhEyyYQDK0ORMIxk3UJG1ANi/cLGdERyuNhrpz8KczkBnaaUghlhwMTvFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(107886003)(86362001)(8676002)(508600001)(4326008)(1076003)(8936002)(2906002)(186003)(426003)(33656002)(316002)(9786002)(36756003)(66946007)(66476007)(66556008)(2616005)(9746002)(83380400001)(26005)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?De5rIEh9SrahvlIKE2TtwknwnTKjvsOovsZ8ZOuBRSckn+ZbCsLyLxnkIwQY?=
 =?us-ascii?Q?16ulW05ZZkeSRG+wCjTRbgo7E0AJGtcauhj0vELGgIZ0XG1h1DA48MtQWpcC?=
 =?us-ascii?Q?G8IZcLBtWnuUZAjiNR5CB/POVECr0yuaCIJcxio/S7PvQCbXbnm26LHvMBz3?=
 =?us-ascii?Q?hHjW6sH3+vcZufSccCgVe5k6eeuRZKT8t0XUmmr6ldOeiNkmmsNeF1RcLp1I?=
 =?us-ascii?Q?yzvNUnrtm1jhGwo4f1EgpKv/1iNiD85CjNtcifg0qdKrsg5eUoanxeQCsck5?=
 =?us-ascii?Q?398qCUEAlpkRekkmYZsuJo9YQ7EiIykF1zMC25GoxmVqv/ly2qWXYFaJP2Ct?=
 =?us-ascii?Q?C/LwJ4cUwoFjfseU2GVP3HXSeX60WdDGFk8Yw8JXbuYTaRjO2Hou6fX9xWsL?=
 =?us-ascii?Q?s9uZZj26zxIhI754+c7tu37ocWn1m9KmRluvwQgLuavgy4WlWqu4csX73nTg?=
 =?us-ascii?Q?OMk5knMFj6oOaYAFaB3GjrkrfRy5HTpTAqXGy3O8DikP3L0O55e+Ud7/ns7o?=
 =?us-ascii?Q?jSbd6D8zghT/0S02Uv2w4OOZRljPqyIk+lEUHXU5AqVS87nlrMlgc/ypBfk4?=
 =?us-ascii?Q?qWr5TVYQVGRoRVb1TVsCDk53oJiuWiPUo0+VzsY7gH1A4Nl3NSgru/+l8nbI?=
 =?us-ascii?Q?RG+/nCqhHtef294xWj2fMyTv9deXgw4CEGXVlxKkAjCWWQYrLb0RPO8YXHRF?=
 =?us-ascii?Q?1GEaNprfyejrufUFIcHycEYX0/AyKf0Qk6SCseLnaO1iqI+wKn/zizAyZOVl?=
 =?us-ascii?Q?oZGlBmo2FAN3qCdgnQAJi+B0HKyzwRsu9VRLf9ZLb+76FOzCX1bWQMf8oLlV?=
 =?us-ascii?Q?IRhLmAZEUTQsUBzGHXJTcWycp9xvt7hHeJ1uLS15WyyTTpajIbdJJUS8cuRD?=
 =?us-ascii?Q?6gBjSYh4vzGeXiecl1e9+PKkrtWIozAH4JuN3IlFq9ydyUWsI8hfUtNkLI9D?=
 =?us-ascii?Q?B1pWjRWr9Bnl8lVGVS51tqMS6rrJc7aQ8jzrOnAIrx9sj2YlqrNXkMlBa1Yp?=
 =?us-ascii?Q?p9knJHw7zTlSFzj2iaWXyHCLncoi0QuquGzvqe7wfkAf5KV3+THpio1qfQpe?=
 =?us-ascii?Q?b4sFqGF0XDLe23syJQEuU4ONc5jiC/4I0spa0rt4aIjuKm5NaoMfCMju7yqA?=
 =?us-ascii?Q?g+CaFxX3sbwx26xkB1YY/1WCKayyKnkA3dnXMyjXTd8kfFm9AdJwPbdGVJbS?=
 =?us-ascii?Q?1X92uREIwtAkpKx117/N1ZXor9dXXq5s6lU/1VykMfshzFwK+TKr4+vafYVb?=
 =?us-ascii?Q?tgo25WFUCyartG1stwGNWydMNmdKDqEODqBMLIIhhYesYwJWlbC5BNF2Ts/t?=
 =?us-ascii?Q?JvggWberzNuwddobxlF8TLlhR0fR5N2L8pVtTaANjf14qY7uI+aFr/VoL/7j?=
 =?us-ascii?Q?ZRtxVCokh69Mj9+xSIAYSc8297Ix/8VUO3WjfkWrGgbq1bRaeBI8KPN8Q5Si?=
 =?us-ascii?Q?lPwxbV01dj0rKOkMjYBf0jxgNjOZOuz5nchglhWdhE3tiF3H99BAljUy31qd?=
 =?us-ascii?Q?2Xuw5VbISPepMtaqX8/u5f8xUHnRXxKLR1h5T1yPMB3gPV/CqU2VN0Hgtaa4?=
 =?us-ascii?Q?MPS+Cn7ICKC9XvP/6+w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d74b6d-22b8-4923-5829-08d998db54e7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 23:50:04.2101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F+COzOjp9ra1XgWkrpPspPNsBaoRoK3v4h/OKcn5FmeVEEr+Pksudvrgyv6lVTD7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 05:16:44PM -0600, Alex Williamson wrote:
> > @@ -471,6 +474,47 @@ mlx5vf_pci_migration_data_rw(struct mlx5vf_pci_core_device *mvdev,
> >  	return count;
> >  }
> >  
> > +/* This function is called in all state_mutex unlock cases to
> > + * handle a 'defered_reset' if exists.
> > + */
> 
> I refrained from noting it elsewhere, but we're not in net/ or
> drivers/net/ here, but we're using their multi-line comment style.  Are
> we using the strong relation to a driver that does belong there as
> justification for the style here?

I think it is an oversight, tell Yishai you prefer the other format in
drivers/vfio and it can be fixed

> > @@ -539,7 +583,7 @@ static ssize_t mlx5vf_pci_mig_rw(struct vfio_pci_core_device *vdev,
> >  	}
> >  
> >  end:
> > -	mutex_unlock(&mvdev->state_mutex);
> > +	mlx5vf_state_mutex_unlock(mvdev);
> 
> I'm a little lost here, if the operation was to read the device_state
> and mvdev->vmig.vfio_dev_state was error, that's already been copied to
> the user buffer, so the user continues to see the error state for the
> first read of device_state after reset if they encounter this race?

Yes. If the userspace races ioctls they get a deserved mess.

This race exists no matter what we do, as soon as the unlock happens a
racing reset ioctl could run in during the system call exit path.

The purpose of the locking is to protect the kernel from hostile
userspace, not to allow userspace to execute concurrent ioctl's in a
sensible way.

Jason
