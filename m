Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C52A3577EC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhDGWqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:46:47 -0400
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:44128
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229449AbhDGWqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:46:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaPGl5um03xYKwtdLqA8odKVmTnZuA1vdD9q/tuK77yE6+ARbQqTQSwHkKdWcBLVqIjla9R1hbJpKexlH0jfvGMfOkzahZD7CuVHn1Xp2Ov+MJk49oae2a8CpZw2dTVHUlONi7bpe3VMYHPxSV2NsbQ3ag6kHo9cxyOELSbtcjXS09bNbwSiW3whunCK6ftR09gVWDZrVacFbOnXLyaQwwe3/O/mG9o08y/m0lEN2cxn97PCxWLjVMOSBvwft/sQfbclvdjrlJ1wnp8X3lv6eTeDDjLLrMKV/Keus2jbEJUN7EoWaIi2qXkG93ygk9hrUevoriIe/5iFpewKMOTDiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYyzsbKx861iDLBXh4zio3y7vfpHpKwE3Kf6P5s+whc=;
 b=LpKvml+vmX/1Z3zeYotUsOsKwnMMHUxS9GBUWZifAHBJSXfwMjG6O7jHEouk8a/uHNAtBrArkHVhif2p68U3LrY/skmQqp/Oxkn8yFBjZmjVXZE+evBclbmS3kkc80zLR4tztoJ2GGVbVesQp0pcnLnONBTEpqaAn9mvDB1Tqhp6xmVKB1sybzM7Hklfpia3rZNaqiH6QYZ8UjMPdhqHaRwWDUNvSpvwAzXtLuXG671kNSx6tPMjEvd4e9/1JRun+ikV6ty9OuyzuhwOtheLgPJBajK8ntV699KB8SFJCCA2zvYzpNku05oOM65PLkGA4ejKCwRsyhT16Yxd9G9l1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XYyzsbKx861iDLBXh4zio3y7vfpHpKwE3Kf6P5s+whc=;
 b=PaliDy7e1q9IEyx1C25vetvA2GW/NsyiQKJZIveVlYUGhR255Bn7qoorcmyV7f5wGpNOgOadcJZgaPVPtnP9oVUV64LfMOkAb1KdGeOOvJXdJGCNf/F/ZrV4N6sCiVBGHyI3KI9TnoprzPM9zXMO+OQlmXKyUnF3my7Zj/Czivk/npzHZXEFPZjGI8fuuQ6kVOWtn08E5Kn2/CO2EPNk3H1bcmz3nNxE0SwBJJDP4wyIIHMQM2YnQbYdGwVTP2ZOltuyLQZ4wDsRL4xSdPWHZZ7yu2zXKs4tjO1EJ9cU15iaxtMb2GmPmiEZMri/POND2l9zt6/dWNKN2wUY5dV6EQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2857.namprd12.prod.outlook.com (2603:10b6:5:184::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 22:46:33 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 22:46:33 +0000
Date:   Wed, 7 Apr 2021 19:46:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
Message-ID: <20210407224631.GI282464@nvidia.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e516fa3940984b0cb0134364b923fc8e@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL1PR13CA0372.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0372.namprd13.prod.outlook.com (2603:10b6:208:2c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.11 via Frontend Transport; Wed, 7 Apr 2021 22:46:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUGwR-002OIM-Us; Wed, 07 Apr 2021 19:46:31 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c4e4f8e-a7e4-4111-9b32-08d8fa16fe00
X-MS-TrafficTypeDiagnostic: DM6PR12MB2857:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2857945E5BD4C17BB0E9BFBEC2759@DM6PR12MB2857.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFuoQ2D2nKhKwZLYI3oDqwZnXSumcxuMOad72tknqRgQHd0Xe2/ep/jt3zBXmarWTdpPyelEiNkCMSlvWedfoiivpaZwqMlhfCjYs9igzfQLl2vUNa/uwRyQO5WU24csdoKe9n5B+4BffiVQdWQN2KeaKiVHZQ6CRTq5escefwUKR8U658uISOlpQT2+h8/WR8GEax0HDDp0UEyNHd82K25Vc8LLk6DSFr4zujvUn5TCn0cFq/OTtl7/eulGcUH3Cc9VUN5oVsu09n0zVD6//r1/HDXNbprgYYuTmy4DVS7uU78XMURCuybNz8Agfm1umUXIbIIdPL5fOTn7ziU8BjiOTJJlTDXnO3mwv3guucF0+2sU0YDNwebip7hjo8B4csw8NkbjLEPY5Z8Cw8354uGlCRui81MWkdPI4xZBcq6tLvX8FIGilS7pgsLggGYn1gmSDqGANT6riqSA/4Kni9lYaO3ySZz2x7EPuDwW/9pTb2ApfhmtFH8waP96rpRbhVIKuGbRV/y9eiUVZ4VZezSCQFNLr3RQA0J9Bbzaqcx2H/JQWsF6se2BNEcm1HLC0tz1dV4DwF3ZBpUKVMifsGxU/kUt0+kAHBwBP1xdCDgJu5BiKbtLjRo/scI8Mu9WSj7bnyMfTYjAZ76Njfe3/5kvfM52t+8qxCLu0FbtSGJM1qoLYLXYrJsKw6dZWf5w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(316002)(2906002)(26005)(5660300002)(54906003)(186003)(9786002)(9746002)(8676002)(66946007)(478600001)(66556008)(8936002)(66476007)(6916009)(1076003)(2616005)(426003)(4326008)(83380400001)(36756003)(33656002)(86362001)(38100700001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pGkV9/MhysbndsHO19ssTb3plN9fSuhz3DR6j512QfUzp7REoLbKK7kfaG6r?=
 =?us-ascii?Q?Nh758lP5yANXOzlc4Dj17HNMryVdqdlAmmcx4TRt3zeEbaaTO4vauhHsQGwX?=
 =?us-ascii?Q?lNatqTnwrGlSQKwU+LSSw01zS5bmhCb/rbUcOTcQ5rQ4Ckl1UgQFf0UTMkM1?=
 =?us-ascii?Q?nQuvD81EGHdRceAuX4a9kJyOEuLBKOS+ElzoZJJMvc26y+YXygCktbuyriGy?=
 =?us-ascii?Q?AuM1ARjmMdPJwVm03OEXec4MwId35Et3YaWCvkOtRS5LxDlEmXk0ToI6MDvP?=
 =?us-ascii?Q?3hAZvtRFo1nopC1PIXdRwCxuYk4hb1wP0Rz7l3RZ6F6aj0mJJmLW9cuRXpDB?=
 =?us-ascii?Q?48XBDb1c6WNlUscwOzU1zq2/7ZcThAVr9Z4qfztAIwcLIAfw2m2bw/Der84Z?=
 =?us-ascii?Q?Lz2UK1eBMycPcaOiloVWCSaukvpiYT9ST0Zh9lcVxW8t6mL+uHfKkVQ3nAnd?=
 =?us-ascii?Q?TqV5Fe/8ugVdoUw0y48wPdGamHhLEQMXn1j9NabCQOGuDLYYwvT32ks4CiqF?=
 =?us-ascii?Q?J1JPj3iGtbnxlFChx8ULbq+JcC6MWgJbsMaZtraCR+AgdS9icjL47uVN3VfL?=
 =?us-ascii?Q?pymZC1gcNHKqii81jJ9aBrIsQ8qrT0P6QojvOCVDjEeb1HKnhKD562BR5UNJ?=
 =?us-ascii?Q?BF2mwlDKemy4Gwrr173/k4WCKbFp+ApQtuHYy+UNS1XX9ezW7n61VHhWVg6v?=
 =?us-ascii?Q?zfkePAL2Fyt8dAndMPOpjE9BN1rMOv5yTn4b/KmdAT/KZ7iSkhOv0E+Utc07?=
 =?us-ascii?Q?ldsRFbm7PZPyGUcrhdmeiq92YloPksuXIu5sWIBJksaPBeVwa7Vte5dzrfH7?=
 =?us-ascii?Q?00/7ZZJRh68pLjGO1rf3KK3BbYkrW2k8raKxQIB9kTmNU1je3D1InY5/DGpm?=
 =?us-ascii?Q?9MgEDg/GJ1XkArRV9beU81EFtC63RmgTprpauVq0v5S1ulpngUZ1/3x4yH71?=
 =?us-ascii?Q?A5BUGFuA/PR+PMWI7up9HpE2TeWipK+H3S16wCpQhyHasR5S5yk19R4b4ADx?=
 =?us-ascii?Q?Iixq9MCxYk1/WEfN6nT3TYJb52/uTFwoUPRFE1Br5yWhqJajDL3MNViEaET9?=
 =?us-ascii?Q?ZeG1QkDrNIwFHiLjyfQnrxBSNlRrPPBe+4t9/uq3Wm+6S28tUVueaTmFRHdx?=
 =?us-ascii?Q?rxij2Y0c/mR6HoT/hxskM5kw/er1caQcqcPfqOnNPX+nz7G3uPVSarXwVCmd?=
 =?us-ascii?Q?0UnY2VHa+38+5m4hmcsWD0SzX/xsMs5fmbhxIsxse+Vd+Hbz+3FhwPuI3cjC?=
 =?us-ascii?Q?j5u4B1au68F+4FXzQfKudBf3dbPf7LWMGGTG5r8wKZbp/1lWh1E1ysfFG66X?=
 =?us-ascii?Q?x42s0UZvCr/HKipJrpF6kRvPq1xNkgfz7/wz4YXjoJa9yQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4e4f8e-a7e4-4111-9b32-08d8fa16fe00
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 22:46:33.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +CK6gY/8f25JHE7AkboDis2byvzzLj2tOjYlk5wTzL80IFKlkzedAcpVMgUftZD7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2857
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 08:58:25PM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> > 
> > On Tue, Apr 06, 2021 at 04:01:07PM -0500, Shiraz Saleem wrote:
> > > Add a new generic runtime devlink parameter 'rdma_protocol'
> > > and use it in ice PCI driver. Configuration changes result in
> > > unplugging the auxiliary RDMA device and re-plugging it with updated
> > > values for irdma auxiiary driver to consume at
> > > drv.probe()
> > >
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > >  .../networking/devlink/devlink-params.rst          |  6 ++
> > >  Documentation/networking/devlink/ice.rst           | 13 +++
> > >  drivers/net/ethernet/intel/ice/ice_devlink.c       | 92 +++++++++++++++++++++-
> > >  drivers/net/ethernet/intel/ice/ice_devlink.h       |  5 ++
> > >  drivers/net/ethernet/intel/ice/ice_main.c          |  2 +
> > >  include/net/devlink.h                              |  4 +
> > >  net/core/devlink.c                                 |  5 ++
> > >  7 files changed, 125 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/Documentation/networking/devlink/devlink-params.rst
> > > b/Documentation/networking/devlink/devlink-params.rst
> > > index 54c9f10..0b454c3 100644
> > > +++ b/Documentation/networking/devlink/devlink-params.rst
> > > @@ -114,3 +114,9 @@ own name.
> > >         will NACK any attempt of other host to reset the device. This parameter
> > >         is useful for setups where a device is shared by different hosts, such
> > >         as multi-host setup.
> > > +   * - ``rdma_protocol``
> > > +     - string
> > > +     - Selects the RDMA protocol selected for multi-protocol devices.
> > > +        - ``iwarp`` iWARP
> > > +	- ``roce`` RoCE
> > > +	- ``ib`` Infiniband
> > 
> > I'm still not sure this belongs in devlink.
> 
> I believe you suggested we use devlink for protocol switch.

Yes, devlink is the right place, but selecting a *single* protocol
doesn't seem right, or general enough.

Parav is talking about generic ways to customize the aux devices
created and that would seem to serve the same function as this.

> > I know Parav is looking at the general problem of how to customize what aux
> > devices are created, that may be a better fit for this.
> > 
> > Can you remove the devlink parts to make progress?
> 
> It is important since otherwise the customer will have no way to use RoCEv2 on this device.

I'm not saying to not having it eventually, I'm just getting tired of
looking at 23 patches. You can argue it out after

I'm also half thinking of applying this under driver/staging or
CONFIG_BROKEN or something just because I am getting sick of looking
at it.

Jason
