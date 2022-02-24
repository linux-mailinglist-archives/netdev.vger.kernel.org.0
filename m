Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85C094C20F2
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 02:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiBXBag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiBXBaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:30:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F0821BC55;
        Wed, 23 Feb 2022 17:30:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXxrH09PrtpeBTR8SkNpqLXeG+ofVW/8a2iHCw2BcyIAn5OfWJXQmF4OeW3V5A/x7qYE/K+OberliONPLGiWnGw3+XA5h++Aly1W83xD7NxWFtJp8FpzUkckEeLGNdQ6Sx/tett25YXrdjd3bZAy+pvI8h2xfewQNiacl46vmsoLpqMe26t9uRmwIWvN8DG3nl/8SXvl35cThT6v41G1ltoT4R1AVwDKlXVgfhidv96ROXRZiR4SEeUne+rIFL4bb3hB4C76EFX/tiNuVZN0un28rHE6WS2B/ijJjoQCLcQy8NbuNWGaynUk7Nz4lkG+GIE8Uiml38Z74ZkvaJJyFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mg4o6YImHITdebUQDbbLMEJN8ieZm2qfijfVAk+wNfA=;
 b=hLQtSJCrwLHbAyRfZMVVBxcdh31iYqs4pGk870z9x5ZbwyCil3cuB8hQZzTDcW9g5kE1VsIo6S9GGohrX/yWQAj4jL0kG/zvwI4E/8b8QcbNbb6cgZvHb/sgOB4XyIm5+c9oeJu5RPLobYWFriyzPLcIWPjUpX1E1Z2chiXJ7t/asqzG6lyIY7pFhpi4A3SNGEPfeMnT0+eswfG/68rjNpVAzLwogHiqHzlWFWwdvxC5K2+2/XLbfTFFEFRy0T8QphlidhIj//OGybwGCVCZhtqudfnIHlgBxBdy9biMoBlXdFYbBnbOGcz/FntXELnjHbnTniPS9csr3K59VnrWgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mg4o6YImHITdebUQDbbLMEJN8ieZm2qfijfVAk+wNfA=;
 b=gBVaMETg2Odqq7P/Ngpo9DSXsF3NXBKe7ETNKQo9vpOr6WIClPsDkwgWIhPdXgjMRwOiHTELOmQUg5pZwhmqvLlZjwDMVAP2DM7olaaLLW5z0S1TrTiUjCV9FLElA3QfSjt6y0/1zoM4y1C/UmLsSwg1rY9WLyQQiGPUYZUAb1aDHXj6Zwt4rwhMugu1hETh1pBoF9urDQJbAJCcTbYsfD+UOHDi/Mth6BpWYJeBhKRElpLjrjpIvbqR2TY9uDLQCJiTmYr7xNe2UHZOD+ssdYAP3Lo0zAwmJiZ12tJ09pYOXEui2U7m/i8g/tFdzph/m2rPTCfpxwJBHQ9chnamEw==
Received: from MWHPR12MB1519.namprd12.prod.outlook.com (2603:10b6:301:d::22)
 by CH0PR12MB5217.namprd12.prod.outlook.com (2603:10b6:610:d0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 24 Feb
 2022 00:46:27 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1519.namprd12.prod.outlook.com (2603:10b6:301:d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Thu, 24 Feb
 2022 00:46:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Thu, 24 Feb 2022
 00:46:23 +0000
Date:   Wed, 23 Feb 2022 20:46:22 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220224004622.GD409228@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-10-yishaih@nvidia.com>
 <87ley17bsq.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ley17bsq.fsf@redhat.com>
X-ClientProxiedBy: BLAPR03CA0086.namprd03.prod.outlook.com
 (2603:10b6:208:329::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55fb08bd-38e6-431a-2028-08d9f72f1499
X-MS-TrafficTypeDiagnostic: MWHPR12MB1519:EE_|CH0PR12MB5217:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1519AF83D35DF208E16E4B5DC23D9@MWHPR12MB1519.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ww0Cf9phWtDCXSqwe5om5e4sUnLJHlGduzQg8uAu2xLrpmKeXZY41L2sS2ofVN+gK+l6/hIApmbbP/45UiQHuX67vJTCSaQo/dULZxRmVYc3IzVwUNqnMM9Nqhum/LZclzveEiNjHKntZr0/3hFzvj2PPWRMaSRExdaPcVgU4qD6U4raIKYNk9Oq6ge0U6eht8qNvyKpMZmGmLNkW1kL798IZYzz2rA8I8j/jKtnWMW98pY0oumX33sNMuEiVluh95TRxviYD63r0djY1K5B1MCM6AqUrj6Quqg1FKfwzgw5sjKkhg5n3+xh37g1sXF2myjySGVH8SH9SNRrHFPhW21BMsILMym1q3jro8uhC5kLhB+YeG4R/Yl9eDY93z3p2ScNF1yKlSk0EZhFkE8h5YkZfceQUarOgrMe6Ncw1kBYU7tW2nbDFO1C0kXTclRSy9DkBnazz2/nnVcHYRvmEmrCl8tAOx7E4Zn0Ntoki3mWQzl/RLLwr5+4M9Ce/n9KraMNlSnjkvIEt6jBreQi34cqo+HVK5g4AjaEUrs9Er5ozPoXOApsOZaHLsKxM/V3mU+FhFlW0Ek3U4EqVkxiqlcrGJvVrUP6ISrunE3yIMrHjVA1YPEXbvBnsvONyLc/hCxZmfs7nH6fNH9PcKt6+DF28Na+eW0a1cqSOwC+2sYn8DhsEhy0uSecURxVMXfxGTxWLL4Bog18tZs/RMjYSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1519.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(36756003)(6916009)(7416002)(86362001)(6512007)(5660300002)(38100700002)(8936002)(66946007)(66556008)(66476007)(4326008)(316002)(8676002)(6486002)(508600001)(6506007)(1076003)(186003)(2616005)(83380400001)(26005)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Mrn8aSWoqHa/5/zhLG5WvKoPNDsMMSLLQd1/UFva86+BRutJEKvZtLfZc8J?=
 =?us-ascii?Q?3fP+OHvwr1sXXOPjCJUMXUXwKwjToEFzxTjERWiccJeiIhX1BDXG2/+Sm6ii?=
 =?us-ascii?Q?e/odjX8Is6lbUMA+QpiKSX0Zb164dR/QwJU0ug64RRLogAJTnUjyCqHIpz3o?=
 =?us-ascii?Q?nmAlq0mgV3Wd20ctTrIJQEP59mEFd/G+WfOkr68J7kXbgRLBoKd0lxLVHTrR?=
 =?us-ascii?Q?D+4PH/YsGl8H+wWUL9jothP+00ziyh0A+uS0ahjTjRu57OcNC2v5AVYLeiou?=
 =?us-ascii?Q?cK4bDtfIUQTiacruLVnPXWp3kZv8CGo8i7qswwV42p+sp1D53LukvWkzikFg?=
 =?us-ascii?Q?sXvVlqrwhaf0ZkM1bFB7AtB5jRxwJ5yErHdj10QjUbITX38lTKskjAw2HFZX?=
 =?us-ascii?Q?7ojK6ug1b3IbM/4lOV+7IubCfR2I7L/B33qB1086OXkd/Ee4obZTcMu3/9y5?=
 =?us-ascii?Q?8r0J6ZVJMx946oZQpjg48sEjdxpAL/flEgjaNMSOlxJOqnVHCuzDplDJfF5V?=
 =?us-ascii?Q?c7EjYtQtMR5h3q0LU0IfupGAhpGleNe8MMh/6eZA9b+5trjelTKI5U+lfCGf?=
 =?us-ascii?Q?KJ0/ITypuEpchd+z3qYNIGeq63mpJHCJxSZkgoBXZJGv06xjv6aa3jYpUEOJ?=
 =?us-ascii?Q?/6sHRgYvAXzjNR3fk7NeFqq6U7NXxXzrSMmIkFkdyPfLoat/PtK7HWaMm//z?=
 =?us-ascii?Q?cSxgKTQ3hPgu2aDM7S/UfMhkPf91tPSghLq+xJK/8+hKelmr7152HuUJDuDy?=
 =?us-ascii?Q?l/BrynH7ascrfya/iTCHpkVHjv/nKbD4d1EvwK6cFVZMV2VtB91axjiSmidl?=
 =?us-ascii?Q?85lr/i7j4b+k3qDjc8bYAOJmArBkv77uMQNRyM+qP7f2RKZ2eXMAImk3aFxW?=
 =?us-ascii?Q?BaQrdIz6XqWPPFOed8PFWse6MckdzJExyYNhYypVFg/VcHWLLtcQL2aIMFTj?=
 =?us-ascii?Q?yDOT1A3C9aYI4rd2jJ7CH2x6uh0Flo67fSrO2nR3DQSBFznI43GBNQRg8W+r?=
 =?us-ascii?Q?2kd8qwHDMROLKUEIlko9Y5WaIPzHIt3eIkL3ecx3/DC2Llv5doeLKKc/Q+yC?=
 =?us-ascii?Q?EdGsCdgUdal12UgpdUMG7THyuV7zj+v+TlKbkyJjCQ0FhxxGaDub83pS9gOP?=
 =?us-ascii?Q?GDFGbbQP638IA01GzcQ9jijBFx+am4YUhIm1UUjBZ6sbTEHnKcpbNz6OjiAF?=
 =?us-ascii?Q?BYL5FQiSHkmd5hArQ7ann1GAXzYlWFK3YHO7r3dPpK6S9x4Ltvi8D1ex0+mI?=
 =?us-ascii?Q?FCbMfDE9fUiWKzwt5mb/q5UWTnrFJCmnV382ifqwrH237nbW3QZBVIGDNPgC?=
 =?us-ascii?Q?NrgBQETWsgd1FeBiMJ3D3J8g8TFdDBTDgj3tak7dnVFh2TQ4S5BhhD2Aa0jH?=
 =?us-ascii?Q?IlbNViHGcxjPDFnRrYuET0U1NjSplT75ML7A9J3jgZd9jsjNH/TL/N14EeBb?=
 =?us-ascii?Q?Aw7c6Q22ARUhVf/9PhBUnNLn6ZTXmwdibLn/SNoIty4yE+RPxx6m+M3ZRRNw?=
 =?us-ascii?Q?fVw26ZKorI01V4i4GbK4talAkQQfmmVfpkxD5zTutkO6blQVWnkzGKGUIE3C?=
 =?us-ascii?Q?Ldj4vOUMoyp4gjMYcTI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55fb08bd-38e6-431a-2028-08d9f72f1499
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 00:46:23.2613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Vma+04qiHKYN7sf3Xo5WMr1Hf4ylQV/DGMBkzxTkIqUt7RAIZoEohpvJkbyyrxF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5217
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 06:06:13PM +0100, Cornelia Huck wrote:
> On Sun, Feb 20 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index ca69516f869d..3bbadcdbc9c8 100644
> > +++ b/include/linux/vfio.h
> > @@ -56,6 +56,14 @@ struct vfio_device {
> >   *         match, -errno for abort (ex. match with insufficient or incorrect
> >   *         additional args)
> >   * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
> > + * @migration_set_state: Optional callback to change the migration state for
> > + *         devices that support migration. The returned FD is used for data
> > + *         transfer according to the FSM definition. The driver is responsible
> > + *         to ensure that FD reaches end of stream or error whenever the
> > + *         migration FSM leaves a data transfer state or before close_device()
> > + *         returns.
> > + * @migration_get_state: Optional callback to get the migration state for
> > + *         devices that support migration.
> 
> Nit: I'd add "mandatory for VFIO_DEVICE_FEATURE_MIGRATION migration
> support" to both descriptions to be a bit more explicit.

Ok

> > +/*
> > + * Indicates the device can support the migration API through
> > + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present flags must be non-zero and
> > + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported. The RUNNING and
> 
> I'm having trouble parsing this. I think what it tries to say is that at
> least one of the flags defined below must be set?
> 
> > + * ERROR states are always supported if this GET succeeds.
> 
> What about the following instead:
> 
> "Indicates device support for the migration API through
> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present, the RUNNING and ERROR
> states are always supported. Support for additional states is indicated
> via the flags field; at least one of the flags defined below must be
> set."

Almost, 'at least VFIO_MIGRATION_STOP_COPY must be set'

Thanks,
Jason
