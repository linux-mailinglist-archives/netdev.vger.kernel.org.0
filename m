Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7058243508E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhJTQsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:48:47 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:10753
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229771AbhJTQsq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 12:48:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUJKfHHQGPWI3OmJBklFWC6B1JKWbd4PUoPRgsHtwVyspwzCNYsjDcFp/wwAyT//odj9ObBHcRGrXYDzZ3MUTasHQN+dE0MTcrebh7E2Ax+hiHE4DpYN/JSnveLD7cCT7B6FV3Rra/Pm9gbIT054KoVAOJ8tjBD/OIrqnQzn+oQYu1/Ma9sy4LgQxe7/bOp9kqU8FE4WqLtG8P/VitxXgnWlqYosW7imEAdCdzunaOYZP1SwkVFhMjeJ8VwMaUyIToHF0CRwv2f0UXCbkQ0GOIftf6nAkxES+bXeZTmrD3pnCVcVb4IDOwS/J7HbbSwA/oE1G69ZPSaU7iggfYgSYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDUjtGrk2rMquAHmUG6WAMbFYStZp0cBvcdsfdiM/nk=;
 b=TZdvEDLOTB/ywBzDYPN2Zt9gQsFMEneTj/JRTyzlqz+/NB8wJ4/8IQSvEm2K83Mo+8irqJ29gWz3WX3fUPUtY12sGwsB1wkxu13XzJz3MaOdX9nUYYNuLngyyNus6heXpCKClr8OU0m/7xJwis5O72QN1L7vDY4cRT0j+6ZkSQfz3suCrDrisevMVjUjmIPJI9WqJ3tWQ34Z6Ottpb0l/2v7RL2tKM1H5mf751LymlZNIHDzO2Fyv0dBhXu4ejNrMh+6UScDP5PzpUUap6A64IkW+cAqtVn8v5bGbV3+aplYRrs4Oz2MhWA2Psf+pp/E+IuX8gzfiPTqv7wwQ/Z/kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDUjtGrk2rMquAHmUG6WAMbFYStZp0cBvcdsfdiM/nk=;
 b=F42lUl/nkthtxpmRNdYXZqcR4kxHgPSr/8rAW02F88qWdbS7cpbgXn06jvnMkjv55VeCElNv1ML5ew7k2Cb6kkxXcDmWx9o5VZ74iT/B1diDKf5qJj40V6u+SOENvHSaOGjvTwGVvEVlz3bBihwHU5swOe97g1dpWQrcd3zvXP0nfG3kgDFchpYnGyCk64YdaDyHUGGBZZJ4jGFpMvN/SZmzd/2Utv5b24MyvTxFDOotznqCfGciwicHbXNAQLMhM3PSvFpwY/vx+PHxBjhH9nsCkFDKAWKh2ISsZmsKVlC6F/GG6yb4vr/3IzdtJl8CPzVzrQD4EaTPak8wV1/wag==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5361.namprd12.prod.outlook.com (2603:10b6:208:31f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 16:46:30 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 16:46:30 +0000
Date:   Wed, 20 Oct 2021 13:46:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 14/14] vfio/mlx5: Use its own PCI reset_done
 error handler
Message-ID: <20211020164629.GG2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-15-yishaih@nvidia.com>
 <20211019125513.4e522af9.alex.williamson@redhat.com>
 <20211019191025.GA4072278@nvidia.com>
 <5cf3fb6c-2ca0-f54e-3a05-27762d29b8e2@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cf3fb6c-2ca0-f54e-3a05-27762d29b8e2@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0277.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::12) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0277.namprd13.prod.outlook.com (2603:10b6:208:2bc::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Wed, 20 Oct 2021 16:46:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mdEjV-00HZa7-2z; Wed, 20 Oct 2021 13:46:29 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19b53f20-0747-49c4-3aa8-08d993e92a7a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5361:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53616C85C9079E2D8D6FE175C2BE9@BL1PR12MB5361.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sYXAXarGTUrOe89VDORUdrPw72frxyZFZHcHgTDJqmlmc5G7bFUOPMs86SAc+f/ONGCZW4HnqKx3qIGlaBYX5inGSyN320tIosTE7uc1jhK7ouvf8sB+iwlqXErjPosY6H1pJC9YZs+vpjYU/8fGbXHriGAqAzAIvQZP0MXEWPAyhitO+D6Gle0j0pOhuAEPc3eiwJ0apGQgYQOlAcZ3dIFIl3kmasGLN2XDDhceTIIpIBUQVCv0dZe62QK/DMniwQFqpljLB6j2JHHOuaIAA5fwJZ0sJ0x3N6KJQs5Wh8JwoAMARSCNqL1EZnh30UhKcAwRDONU5mbJgcdKteBq1QQXh03bnkTZ9wtiijb11ektGimVyI7krGLtK19EXC+CoqsmiVp5vucI0T65oZmrjuiNYM8Q574xMAgdnoHF1ZtaK9tzZvcAZT2TCLJTuUwn3mOVAAIMrEACTjjQAqQ3Ek/RK/Rb684kUxEogqEGzpcYkZwjamxEL8ubGN5SbogkYBqU1o4Py3gX+pWW3e5AoXhcBjyY6m+ZxLqsSY+6/HghBFcONi5deqMNrBdIES29/vL30COuCatlXqNGKF1ACHV6A1rYvcHRvl5TXkaFO7zTDjirDovZr53hE1jNBnMGVNL5v8tanb+yE2K2l5+Jqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(508600001)(6636002)(83380400001)(9786002)(9746002)(2906002)(36756003)(8936002)(1076003)(33656002)(26005)(426003)(2616005)(66556008)(37006003)(66476007)(5660300002)(86362001)(186003)(107886003)(4326008)(316002)(6862004)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4ksL6ejytAMNAfytDsoRHFghp2rqGQAVG8DoTgs4cTSCW9/yxa7Cfl8foN21?=
 =?us-ascii?Q?d4QZPCL+PtEKgCs7m+HwpM/RM7QkBeo3hgAg3kyBToMOIJ1xq6syKZk2Q/Cu?=
 =?us-ascii?Q?F8AD1Vmig6g8EQVNK/VbQpzEN85pTf1AbSN6fMTjujoiPyLb4zRRCRTcglc8?=
 =?us-ascii?Q?EHE9BJYCE/+Z7hQqiMwt1FWGpT7S87PzKTbC5xfiKAeBYQHY11cqRDtoKOmi?=
 =?us-ascii?Q?DmIstAenKqZTKpDMKCfacKW+qAeqsQBqxFqVuFJzbKdadHtrVPzsV+m1wHRW?=
 =?us-ascii?Q?L4n8+vRa1FFFgkEtXQCsHD44rhh5fgnI1WfhG2sPg9qNII/dc/dZZp9dANwn?=
 =?us-ascii?Q?kXR2SAjzMnK075thDGCwBEWnWqKF77fZRCYkjqWx5Wn4aVHYprD75t/bbqBY?=
 =?us-ascii?Q?efKTrCcIKNQofm1fCsKmYXBmirTmV07fp30bVFJ30EWHq6n63rrVuH3P0QUn?=
 =?us-ascii?Q?woWFFoDJQV5+BTEqgvDIofmMf82oJnDl0CKpRn92MkY/MjL6Vasp+ZKn43km?=
 =?us-ascii?Q?Q/nDbEycWCk+3Jh86b72hvfFLoY9ZLzbaC/HIT+bJB8GJc/Im1tXaixaSM9T?=
 =?us-ascii?Q?8SZWrVWvbogOdpix/973OShHSFZ3D3niMcDocIYUZXqWezgSIQNEol4ipfxc?=
 =?us-ascii?Q?h+pqP9BTIiVXI5BrHHcNdlcfLuJjYK5a8qo3wXGu/F14y/JFAJ7rn+j5Fltc?=
 =?us-ascii?Q?8lIS2vs3LmnGyQp0MQool6rYsemhhxOsswW5fUxoOZCcqH/7rT1K75mkc348?=
 =?us-ascii?Q?VV5Bfkh8fIYw6egGmVjNZi+bOd7EIGcpMMMvAKXcgrQjIfEpnYIJWACXuUck?=
 =?us-ascii?Q?/+jp7QfS08l1VZq5cdMW5P0+/zV2ZL2KpfwT2JPfrNjhoPlVihSq7ohOhkZP?=
 =?us-ascii?Q?gLm/XdqeK+QXI8q2/gtcGIa8bATDc36hTlz8M4Buh+cH3zb5Wm4haao9GDV3?=
 =?us-ascii?Q?ukKHbX1mos+yZaJM6JQ/85JqevxX+Dp6W3Jz0Qk3FOWx2i76qhxAdRT6T/s3?=
 =?us-ascii?Q?jJpy/2FB7AC11uTBZnenb8DrEALQTRGav2CSKG5PHAKQasEPNIoaKtcrB4wW?=
 =?us-ascii?Q?hhy8CyohjmcePCy4LJinVZl9gegAbDHA7RnymhHobPl22GpNxqF83SfTfT4d?=
 =?us-ascii?Q?xzL0CgZmRI9VLRWlpKjB7WIatfJ0i2c1WshnFcc1LlgGxrFyk9f+L/DlLKej?=
 =?us-ascii?Q?xEDRO8RrAoZumY6Mir7M5Ro+B024LQS2fRNDFs4y8w0q3nLSUvxF/zU8kx17?=
 =?us-ascii?Q?2r3cI8mIUrJCsOz2C6HFC5GouyqB9HQlmP/o58TS+tc4ZV6a2Y5uMuPJ2KF6?=
 =?us-ascii?Q?xc0gesm0+tQ6Vt6iIW6ukY5B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b53f20-0747-49c4-3aa8-08d993e92a7a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 16:46:30.0376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5361
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 11:46:07AM +0300, Yishai Hadas wrote:

> What is the expectation for a reasonable delay ? we may expect this system
> WQ to run only short tasks and be very responsive.

If the expectation is that qemu will see the error return and the turn
around and issue FLR followed by another state operation then it does
seem strange that there would be a delay.

On the other hand, this doesn't seem that useful. If qemu tries to
migrate and the device fails then the migration operation is toast and
possibly the device is wrecked. It can't really issue a FLR without
coordinating with the VM, and it cannot resume the VM as the device is
now irrecoverably messed up.

If we look at this from a RAS perspective would would be useful here
is a way for qemu to request a fail safe migration data. This must
always be available and cannot fail.

When the failsafe is loaded into the device it would trigger the
device's built-in RAS features to co-ordinate with the VM driver and
recover. Perhaps qemu would also have to inject an AER or something.

Basically instead of the device starting in an "empty ready to use
state" it would start in a "failure detected, needs recovery" state.

Not hitless, but preserves overall availability vs a failed migration
== VM crash.

That said, it is just a thought, and I don't know if anyone has put
any resources into what to do if migration operations fail right now.

But failure is possible, ie the physical device could have crashed and
perhaps the migration is to move the VMs off the broken HW. In this
scenario all the migration operations will timeout and fail in the
driver.

However, since the guest VM could issue a FLR at any time, we really
shouldn't have this kind of operation floating around in the
background. Things must be made deterministic for qemu.

eg if qemu gets a guest request for FLR during the pre-copy stage it
really should abort the pre-copy, issue the FLR and then restart the
migration. I think it is unresonable to ask a device to be able to
maintain pre-copy across FLR.

To make this work the restarting of the migration must not race with a
schedule work wiping out all the state.

So, regrettably, something is needed here.

Ideally more of this logic would be in shared code, but I'm not sure I
have a good feeling what that should look like at this
point. Something to attempt once there are a few more implementations.

For instance the if predicate ladder I mentioned in the last email
should be shared code, not driver core as it is fundamental ABI.

Jason
