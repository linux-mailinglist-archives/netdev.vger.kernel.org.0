Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA9643B55C
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236693AbhJZPVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:21:20 -0400
Received: from mail-mw2nam10on2071.outbound.protection.outlook.com ([40.107.94.71]:51361
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231931AbhJZPVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:21:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Avw3rKCn2slISFS4st9TFGlt4O1aj6hP7nyWo7RnUlpHfOPVuckN+ocvvDRJutw2e49FkrYyK2hAucmPWE8nzNuq5sHnd/FXPQQW6ORbk5QRhEqXlfnC5W8gYmW+xGzEzlV7xWOHlOxs54vEZVzeeN+8WWffZdEpYmY9AUjWoYBcw7cAtHpk3sBzSeWuo0uulJM82BLVXlm/cf9jlBKdxbDNfKtr3zlfqE7B8SFCNaNr5huQ0SMTpk0JGkJ3TVEPxMn2GjUGsKnUDAtrHu7sT/xI9AMbOtpk8tKvRKKw80MKKv0eWtbHMfprccyk3sfdBKHECXtOTnWHuDwILqys9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0YHHvrj6ubxORinrSPsxq8BOV1e/180dDA0Oawk3CE=;
 b=dq0QH6oJTvT89eEJp9z23KB4nW5zCE+g4dwZX5Bhu1/DtRLv4IYEq4C+FSCz0bSYjP4tBdNgG5aR1i9uZx2LSWMjDmwPaLIkHy2qZvt43mn9hW6Wh9sETAl1CVtuNswyXIsqMZDJ4ttonZcxpga6aI9476SBvExhMTglE7kg1oBBKDiqtUsZ5VGTG2Xu5KA7P0Fzu0ZG7LiD9NnmM+gj22dpm4fnYrqlBwHLflGl43m4emTNWw9V3NQOOd3osX5LQTKW6RcR4ZxP3f0MYibnVc9Y5DB8TyGUvOKTl14qPMhT/CGXDVgnhKMwSWW5ztX84ZJ2Lu2VozweWwh23usJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0YHHvrj6ubxORinrSPsxq8BOV1e/180dDA0Oawk3CE=;
 b=LKdxUGzPcKMqJML2A5raN/2XytpUfzk/GU85Z3PnjAicsGEpnee/6w654m/QDRVb2yTOZwDM2LLWXPql3nL9YgR7a9b9TzHGUnJtW8y9ZKsMueclmXMsv25bD4YCg6sTgUJq4ko9rySCiDiUt8+2NMim7zX38mFMWPGabOaOq3jT2Ev/yBv1WAZqiRs9XYBQmPjtaJjrVAx9Rtu/cJc+PkVSbkSzbY12SyieWsiH/Xq04JKnI+O/HVzmASd4GrSHywLWzyhqybr4xX3eVTqu93uwqnQ03Cw1WYYRsA0l1yOHtG+5ubR49sT785xnxbKpjw0qxkkFd35Omt1pRPY/gQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5319.namprd12.prod.outlook.com (2603:10b6:208:317::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Tue, 26 Oct
 2021 15:18:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.014; Tue, 26 Oct 2021
 15:18:53 +0000
Date:   Tue, 26 Oct 2021 12:18:51 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026151851.GW2744544@nvidia.com>
References: <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
 <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026084212.36b0142c.alex.williamson@redhat.com>
X-ClientProxiedBy: CH2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:610:4e::36) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR02CA0026.namprd02.prod.outlook.com (2603:10b6:610:4e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 26 Oct 2021 15:18:53 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mfODz-0027Pu-J4; Tue, 26 Oct 2021 12:18:51 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fd17228-f916-4f7b-5b4e-08d99893ebb0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5319:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5319946F1A84B4C41DB49017C2849@BL1PR12MB5319.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sIoA+cWQuECoKY032TvhFOZg3ziIHRRzj7P4kFstbQcdnWpTNTBwC0udB1iOk/nbYnF+ska5dGXbeKKoN3wGdYl3SLvVpks3piWORbh8GbxDGlO7PA4iOrEnm51ujz7WiU+mPIbY75vekRebX9bzuu8otnCoMiiQYeLkTWsTuORS6oxd5Jl3WMd48koQln2L0PfyLF7/lasFm3nhO2UcPUjbGeFiFvsBQCdC5DJ9bIlIJM/wR2Q0fQbHgGseA/lLmdvLLpkMOQEs7tTLljljFzKqHwjcjo4DFX0KN1zyCupBlTrSs/JGzwXDh2PTq81NlZ7mzOvQCeQUN56PmVB030AR5jWzkxUXO0vUMXrMnOYqpmW5ZG26KtQ2fP0/Ouw9nctJN6lyfNBHV/2EN2TbWwkqQeHAE4e5gljaj+RTTY/Pg2wkwqb61+SjdG46t9xP/NzfaPgFwIeivIpAKQKxx0MswMh8HoxubpjogBurDc481eZrIVz70ko4WMLmY1BR6Q1hFuhySs5aZRMXi/Db25TiM4XFxoa6WGoCVqCWANGHS8lTOZkKEgvjQLxBS9xDd05u/T+VJ7+BhcyTBE/rXN2GU2XoVloGDA0p/wAXt7A26WIRiU6n3yZZy90jc8aoNIlFzdxyzjHdf8glhUUsYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(1076003)(54906003)(8936002)(426003)(66946007)(26005)(66476007)(86362001)(4326008)(9746002)(9786002)(66556008)(38100700002)(36756003)(5660300002)(186003)(8676002)(33656002)(6916009)(508600001)(2616005)(2906002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zquaeeR3Yh1TbOubo7jeoovyUGjRdrUR+P+dCd3gxIx3uofmGxDy6B7EPzIA?=
 =?us-ascii?Q?kJNtopPwnhJDBW+I8jThhYzVvlVJWPI2iQ59I8lGeWGVnXyQnXcsDvxU4ee7?=
 =?us-ascii?Q?JepjEIgTKtnPPAlFLz02kRad7WXEQV/T0TMHDaWYyMJtF4GusVoB8Ld1/VVo?=
 =?us-ascii?Q?vGjKaBz4RT0QYkjKaRy+oKJkFboa59NEDTkAiy3egevJ5tvaZUlh/hTBGfeq?=
 =?us-ascii?Q?sgXUvIVfxcETsE5bZ8nR6AsoClfWf9E+9YIZHTdgJGnaEqvkexHUqv+kbGJB?=
 =?us-ascii?Q?nbl8vIDx6NSKSV/mshuTfnMFWSSEemtmB+JF1S5gKvnjtZg3nsy56ITBBivd?=
 =?us-ascii?Q?xm2cnnztvwDMOMj+sV3YkrqMgsmplmbzr3ux+rO/+UvuyVloWk0c0odWnzGX?=
 =?us-ascii?Q?Y68o9iNnY/G4D/LY8rHVMvz6+PUARgAReonQ2wRzmKkpUxhGiEBqlO+ylqtN?=
 =?us-ascii?Q?rHXeDBTmqI+8MCsR36IiRqnq1c2RSA5qobLi/sAVCB63ct3mBpBiO6ah8/7K?=
 =?us-ascii?Q?wzQGLhE4wr8zqH3cdN68+Cvqx1/gugJleoV4dN+IOZRn+YZ80NpBFHV/BC35?=
 =?us-ascii?Q?hfUypxookuAMzKIEDAZ+8juVvtgYNVabfs6heBmgrgjkQdgJo86RZRR6CY5j?=
 =?us-ascii?Q?SySTzmqJtApTEoFt2DSzzX4OzNPLo1eOPKvoihUky5lOZOf27LiAfr6CwMG+?=
 =?us-ascii?Q?VQioMLy4LXrCZcj7KxrrHLAH6a7PasGrnzthoMeLr75keglfXrlIvzfsTinY?=
 =?us-ascii?Q?T4zdGLapwwb/G6NC0X/PEC5rBudtTo7KFZQ6iC++xCDUWDYIBs7YYS2RgFq9?=
 =?us-ascii?Q?iGbgnoaeteWpKYUrf4PrUwdo3nJGtA+CwWZBPIsyCEdBN+0/pJvR501C5Qpg?=
 =?us-ascii?Q?vHZERodUb1j5fd2VXqIHsMfjaWNbVp4MWbe1jl4irRYQ8Pn14jR0Wp/Q4UNl?=
 =?us-ascii?Q?LaHQwcNHE9pm0gAQ/iXg9XeRrwjiOQHLDrKctaO8jIVY9LCi7spM5QNfqKIL?=
 =?us-ascii?Q?MclJpZcFXitWSIMUitQ3in759JeC2XFV5p7JqzWBQ6qDTZWvQQTIaPrLiihT?=
 =?us-ascii?Q?4MhKuC5tsnin4O9wEpH89c9rbtYb/Re1z3kfyodImJ+qWb/x9cmp2dlrwuSI?=
 =?us-ascii?Q?bPHemc6yfwCx0pI/OS9SMuPj0bvEx4/Qg+U0uzkbg9r4/neCnqeDo453af2o?=
 =?us-ascii?Q?kaUZQCjLb+qrs7WKRmSsr71c5/aVehfoKt3jH1FYAD1UII12PZgayDW23y5P?=
 =?us-ascii?Q?bg45X8pQgDx2zy6+Mb3O7XKpC0iHz1jg2NHETRxSKTA/bC5vga5JdaD4iaKR?=
 =?us-ascii?Q?stTqwZEWow6i7KY9fqWHud1Uy3RzlK60gfN5ystYi+C8gfV/3/Zf6Yim283M?=
 =?us-ascii?Q?vYx67NpgQ6YG3RTYNO58QekujSVHMoc7r7WGSwK3jfY68TdMDBG1y+81mC5H?=
 =?us-ascii?Q?VWYwNU5zE/3NQKKHxchLPuP0a1Vb5I8sWeqvpFPKD7T0rLsQA29OEqCvxV22?=
 =?us-ascii?Q?wqYRO267LsvS38XfqfDaw6ki9bqh5lUGHvjx2mqBCwJWHP9LNyxIlhk3PVRP?=
 =?us-ascii?Q?vICAPB/bhoejvtD/2YI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd17228-f916-4f7b-5b4e-08d99893ebb0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 15:18:53.2738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDbHQOZ+efKP+P/h9tFRPWn6VZ02d1/TS5FfDub65Rag8Iccm6tl/zJtDPxOW1Vu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5319
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:

> > This is also why I don't like it being so transparent as it is
> > something userspace needs to care about - especially if the HW cannot
> > support such a thing, if we intend to allow that.
> 
> Userspace does need to care, but userspace's concern over this should
> not be able to compromise the platform and therefore making VF
> assignment more susceptible to fatal error conditions to comply with a
> migration uAPI is troublesome for me.

It is an interesting scenario.

I think it points that we are not implementing this fully properly.

The !RUNNING state should be like your reset efforts.

All access to the MMIO memories from userspace should be revoked
during !RUNNING

All VMAs zap'd.

All IOMMU peer mappings invalidated.

The kernel should directly block userspace from causing a MMIO TLP
before the device driver goes to !RUNNING.

Then the question of what the device does at this edge is not
relevant as hostile userspace cannot trigger it.

The logical way to implement this is to key off running and
block/unblock MMIO access when !RUNNING.

To me this strongly suggests that the extra bit is the correct way
forward as the driver is much simpler to implement and understand if
RUNNING directly controls the availability of MMIO instead of having
an irregular case where !RUNNING still allows MMIO but only until a
pending_bytes read.

Given the complexity of this can we move ahead with the current
mlx5_vfio and Yishai&co can come with some followup proposal to split
the freeze/queice and block MMIO?

Jason
