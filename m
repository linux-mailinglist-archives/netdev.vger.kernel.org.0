Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839AF4C2BF2
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 13:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiBXMkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 07:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiBXMkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 07:40:03 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A41A2804DB;
        Thu, 24 Feb 2022 04:39:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evoj1SPU9Thg/8RZdYMyITwscmc1IUryXuM+xhQYO0Cpk6/q7UyMUDW1p9DXSpRHQJb1CT12e0IT5f4I9pFXqnMiVerpNcp8ivkFb2FFN/AZYT01TBjc0+UeYMDp/lrTBddK6glquz2vHDyRuLpGAqhBhWqv0Ig0AsKGCdOi9qiuJ86kbEh+aSgqYPK53ZmtLCLkzsDK5CkM5xmnLezv/K/NiDGZ10/HEUIR94irgxqYqD+gbvL6MJm5HTTOWkC55tqVjriZbWYlJJdH+HiHdp+sO2q0YOESEz/ZHYR2Il+v9Zt4k5xgishUXbo6BKcsfR8E+ZNiaCBNR/XY2ESHbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTVYVZzb7GCK2H1yH77k4JRkKr/NAylGUXB/wvw1LJI=;
 b=XDdr0FNQdn0tc/0Rhc9dYIz/nufXlCRnf4oZc5Y/m3oOS4C5RRSYb809aeyZwGZgpOGPnWnmvT4T106Tc7qdmmO7v8Jhaeibq+eWKth4a9UJWc4fNTRn3AMZOpVBZWCTm1htqwZe5Lh3TGlF3HSOobqqxH4bAX/Sq4i+0i1TgAsWbCij1yHrS6gugmoEzUAceLzifrMrWgJpuAjrioTRtqYpvXdkbCENENh2LDtfjUFPdwI8e05VXYqXg2sVkj/zFxPrYBHZdjF2xkxB9zbK5WD8bNhDTKSLWFvNH6fz1JkjfBLhy8w1HCQ+3Y+Hu7DsOBJRSYEspusnxgz8EKi+yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTVYVZzb7GCK2H1yH77k4JRkKr/NAylGUXB/wvw1LJI=;
 b=YC5G/9tRLCzdH9JZpE0CZyYIX13dYhbqm6O7WNuiKZdLB/hZEcFnFSTY5V5cPi3eYbxiHalU4yJVk19/YrKGjnCM4LkKCeYIcgzSuobtFoKotRGLM/MwFl9zxz4PKLlu9jnXHgwIrMB81X6/Q1UUIecPnLvdgCl52IB+Om9DOyxlI8sMKWHP7rmdMHYmfA/VskOC+dpNe5SXJO08qEAJBuTtlJBCSHYhm6+eWlj/7Tn5gQhPxY5ihILASiFN7rielk/NGfLmsHjIOQnYcwRkUe0PUnkwSbz96BMRICtkWJWmqFrln/1SfjNVE1Oeachc1TGT4TF2rVtuE8vbgVXnwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3104.namprd12.prod.outlook.com (2603:10b6:208:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 12:39:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Thu, 24 Feb 2022
 12:39:31 +0000
Date:   Thu, 24 Feb 2022 08:39:29 -0400
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
Message-ID: <20220224123929.GA6413@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-10-yishaih@nvidia.com>
 <87ley17bsq.fsf@redhat.com>
 <20220224004622.GD409228@nvidia.com>
 <87ilt47dhz.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilt47dhz.fsf@redhat.com>
X-ClientProxiedBy: MN2PR05CA0051.namprd05.prod.outlook.com
 (2603:10b6:208:236::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3476490-1896-43b4-294c-08d9f792b439
X-MS-TrafficTypeDiagnostic: MN2PR12MB3104:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3104D9370F98B4AABD3661D3C23D9@MN2PR12MB3104.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ojKRmEPamFifB2ZYz8pvIxrNXEI5GLNU1nUQvuBa1V4rDBwzK9MCwR/ztB1iDThoDypZTNaJZCSnbm55hihcoVa5X5CWUHxacaOTQ6XXUiva+gbN9odw6xrapYQwCJlSkfCnSkSwHhAyf8ibWnYOC4RSb6lNzdsdz/nBZzWKEUGscHBzSUVoVydyJJ+Ik0Tyd5hLtDBlFX9vCU9K8gIymzzUJ9hbnnv02mKDFiXYOnVlrHWbz6Pyf+rQL5UOzrddmEr1cXfNgzcvpYviFowogd6W3hVfM2lqGpB076yYMIBTIy7/Mh6bC1MWd7ECBuGJDzYxFXj2IBPeSkluQqmSxIyOzWszTLZEnLyxMQZ4hyU55hAD+Kg4PcWyFPeABl3s5P68T87MDUv6LBDP0AtBoMIsAEavUlJ/QTQmJAGCvlX29OLfywTv2+UGzaPdHLIQeHQaWd5r8etYJeNHCzn2E6XjMrP4nINGMNll8/spsi8HnzgFp1vUI3X2e6cMkP330//D50SPPYS9DxGD7FeMmi9ltWbAFXMc5J4Q7mrmYUtq7FC5ECndmovCUn6L8JYEvoFWKhJCrVo5Xi2cwh3GTkbiqBG9ri9ghW1u/ZtHIGLa7CrLa2wTrRm624gtuX0WpeiY7NoQOtz0cDZ0Fjde3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(36756003)(8936002)(7416002)(5660300002)(186003)(26005)(2906002)(1076003)(2616005)(508600001)(6512007)(6506007)(33656002)(86362001)(66946007)(66556008)(66476007)(316002)(6916009)(38100700002)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KPFCXDxT26RKTd1NrvZwmxqz6/sLjqyFJQxeD5EQSZlbTedJYMDm0NUEilTQ?=
 =?us-ascii?Q?JgHA4cEyjdJC4NWtSH2ME1+W49yHotg6x16A7QVdXgC8zTXzmp2aVHAwwCzd?=
 =?us-ascii?Q?BVJJi27xAeJj3jBoS8FKM3LZ2kqrdmCKUp/+ockSKRr6LJ3P34tuU/vLKKV1?=
 =?us-ascii?Q?+OKTFMBHtlQrg6GBkg8YQ8QnMb+XKLM/4EruwO8UmbzTSsMlHwYXYQd+AHPJ?=
 =?us-ascii?Q?jePVpInS4Xn4Ag+El9b1aAI11p6yk+RXfzhIqfaAfRsUXJK/TKzCeQ//Pjgy?=
 =?us-ascii?Q?YDlxwz1qDoOInAMSuiP+izpCsuCCN1E/u/Fbe9nf1VmiVLZDk7BU189QMUS+?=
 =?us-ascii?Q?MW2JfdYRDMEQgUVq5YgIV1CMQ6asodNrI14v/40mns7OZ6EN7cMfR+ItLmZM?=
 =?us-ascii?Q?aVDSx6C6p6UTm8KlYQkv7rCSA2w2Vom0XT8iJKFEMlyVkVRZowjCE0brHwCn?=
 =?us-ascii?Q?3B0MVsU0OcSoSmEuaM+Mj0g3FBXkIY9eQZ1gb1xjBUcfZZcLLAcUiw5HwHGw?=
 =?us-ascii?Q?AMY1e/JPnhpcJC8m2epTEq8eBODkKGeHoeG7T7OI+5P+0fY/6zeDA14Mx++N?=
 =?us-ascii?Q?yfcYoLJjQ4ZI5igqxBnMNyLfaF7K3RMBaCDXTO23kt1o3/9YlvN/E/dbS4dV?=
 =?us-ascii?Q?4+2uw3sgW2Zbura/s5dR3Lc+U0HjwLb8IJALidFhlQgbm1epNbOk1c7UFe2m?=
 =?us-ascii?Q?rekFwl2C/Tu/YZA6awfx5EiMae1jFTiWY8JyiE+p6Sop1Igs69jrx15cl/Ar?=
 =?us-ascii?Q?ezmrSLbMWcDjQNJ+a1gb4XmikjwMvlcQBQkcjXhiQHR7db8EvbWm42V5i3Bn?=
 =?us-ascii?Q?E9jA0XTPJpj8o0U99Y5WsdQjqzBl+pkZsn52nroqMIt6iw7nHZYtuzzp2qU+?=
 =?us-ascii?Q?g5my/2y+Sm+u0ezX9Mn8ZXhpuN6lt7QKrUTXTbxJDYardfSv0FHU21GovadX?=
 =?us-ascii?Q?qOKjlKYJIe9nZeh+796OzTTmMeWCrMhMG5T29M4KFFFjrMClmS2OAruH+j5N?=
 =?us-ascii?Q?PpB+uMO6tmXe9VyP4k+ARkdYJAo+/Rg2H4Aql7nLSTz/+dWcxkCK8TxxwZM3?=
 =?us-ascii?Q?fCqydDRKv5GCYI6m1X6jBLoutx+yu0V+YxbiV9SWIERqi4OdG7Lp6EkbfdAE?=
 =?us-ascii?Q?cRyFYq64Motcwwm5gn9kTyI4dXB+5RS9X4r7xAT6tKKSy+rss/uZnc2Eu+k5?=
 =?us-ascii?Q?iZox7zZPI/ktLxPLyksi8n/ISrgbqpdOJ741YSY4CNl9BiEnMYQB83G3Pr/t?=
 =?us-ascii?Q?n1fyCwrh4xjmmU2OPDmQnbjVeo96uJfmHyNgsZkJbV/4C7ZA0hHiGAiTwnUR?=
 =?us-ascii?Q?fptBmdCj7zGTzyd2Jul8S4xXgjc+Ced1ezzca9UnwgDCSxlaOHAn+kpSAB9G?=
 =?us-ascii?Q?4H1lxpGYbkiED/pLcZ2udGtcnMc0SqGXKzHtBBSE6VK5Oa0DBPCIVaHgkk8U?=
 =?us-ascii?Q?T5IP4YwWzGEJ3EUZlXZ1EoAuOU8GacdPPqr9Ho+MWU+zVVMRmDmOooLci3f6?=
 =?us-ascii?Q?tPQnRLCggo57yFvOsnG1j3azdMKaN5b5rseL5zGDw3QtL3y/I99Wh5nDm1eW?=
 =?us-ascii?Q?wWcPQnAN+gmKYkV1rD4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3476490-1896-43b4-294c-08d9f792b439
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 12:39:31.2128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tg+f+OWLVLvoKi8Ld5909B/Q11rkm86+InxMZEKS5bqZI8J+lcRON9x16WgA8J5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3104
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 11:41:44AM +0100, Cornelia Huck wrote:
> On Wed, Feb 23 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Feb 23, 2022 at 06:06:13PM +0100, Cornelia Huck wrote:
> >> On Sun, Feb 20 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> >> > +/*
> >> > + * Indicates the device can support the migration API through
> >> > + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present flags must be non-zero and
> >> > + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported. The RUNNING and
> >> 
> >> I'm having trouble parsing this. I think what it tries to say is that at
> >> least one of the flags defined below must be set?
> >> 
> >> > + * ERROR states are always supported if this GET succeeds.
> >> 
> >> What about the following instead:
> >> 
> >> "Indicates device support for the migration API through
> >> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present, the RUNNING and ERROR
> >> states are always supported. Support for additional states is indicated
> >> via the flags field; at least one of the flags defined below must be
> >> set."
> >
> > Almost, 'at least VFIO_MIGRATION_STOP_COPY must be set'
> 
> It feels a bit odd to split the mandatory states between a base layer
> (RUNNING/ERROR) and the ones governed by VFIO_MIGRATION_STOP_COPY. Do we
> want to keep the possibility of a future implementation that does not
> use the semantics indicated by VFIO_MIGRATION_STOP_COPY? 

Yes we do, and when we do that the documentation can reflect that
world. Today, as is, it is mandatory.

Jason
