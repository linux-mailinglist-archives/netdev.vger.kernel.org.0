Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254A758448C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 19:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbiG1RBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 13:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiG1RBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 13:01:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F0D491C0;
        Thu, 28 Jul 2022 10:01:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zm4CoXWPm4/pn0ee/3sVCoTJfuh3QItsuYaEmnJYR7l755h1y6G5JZf6hezUirLIBGBEBGF3zGxqbiTsK8FOGidQjNVf02OZ7K00j6p+2o9yiUW1ZYJCaazrqiudDoWBxJ0bdrkyj59ZeAnSWWyBChwGNYqtlA+v1RKmEvfYMhi8Zaq0OJWbFRJ6+gA09vpZd9SgrJy0pQlDPCtrHBzY3QyFFSGvPwyk7jT5+A3aX3P55VFh8pFEhWOZNectA5lgK9X47Bm/hxgETI8xE9Uhr7cRDdGqCL44588dQ7ENRjZ1UinKVnEeqZXl5rR2J/VLpuYd4jo11oDQM1fPwSV3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiB9f5qp36jmFqf6fMQGJGHHXQ06DZo1TO8WWQnMOhU=;
 b=IadfihJVx1yihr2E/D3oYD05BfhlWchph5wLApGEVKrTZMGpkzVT1nFa5JduSZDQuE4yZsNsLcEPGzwA4hQrMDhLKKVQFAe2oG/Um6lEX712iVXV/WZDf7m+qcQLpQOAUXlZxXJT05ZqWctAD1cYUWuibFSqqcfE4cpIujzads9VoZfh1WchPHyJcw3dHUAaxtPW4WsV7Ut0AgiRiz5pHetzhedSi3deFgd5NmrdFNYipGw8iTM4bzBEt0gR3W2HdbynbWP+elG0cbSIFXkLbKgvUOkoaeYWGuou/uLWBzXIBvKSf3BU+EyKRtnTIOfQsbA316/OsgJlesEEGUWXcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiB9f5qp36jmFqf6fMQGJGHHXQ06DZo1TO8WWQnMOhU=;
 b=bOtmEl+b0Ik8wua7QnbsJC7Js4zad5dREYaVy1mAWoqgEuLByb/wjUMm+7K81i+GVfrSRdLpa5g30h8RxpgRGmeHMKehXqNJvINoKYvjdi00iuQHzdB/xKTgCcaqRVr25Wayi2FpgOjR+67KiB/HQH8kRzqGly8ac/XbyK9GZN4GQ2SK7n0wscIXULXGqC2SnHobn4h7Z+tlFT8+N0vSJ3n+J+PjMNzqZ7MhGjoawOT956DnPz7/Ap+f9VW+lqaAh1rPDFE4kEsGQVqKAmGrPmp+jI29iQS1BI4Uhh1cF4QTYdNT/PbEBlo5P9Yxurr890fRMXHLeSYUcOINEX7i2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4548.namprd12.prod.outlook.com (2603:10b6:5:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 17:01:03 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Thu, 28 Jul 2022
 17:01:03 +0000
Date:   Thu, 28 Jul 2022 09:06:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: Re: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Message-ID: <YuJ7vpwCPqg2l8Nq@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
 <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <eab568ea-f39e-5399-6af6-0518832dfc91@nvidia.com>
 <20220726080320.798129d5.alex.williamson@redhat.com>
 <20220726150452.GE4438@nvidia.com>
 <BN9PR11MB52766B673C70439A78E16B518C969@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766B673C70439A78E16B518C969@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0048.namprd19.prod.outlook.com
 (2603:10b6:208:19b::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc3e3e1b-b70f-4054-03bf-08da70bac113
X-MS-TrafficTypeDiagnostic: DM6PR12MB4548:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tV1g0ND2iWLs6XMeK4MH11ZXIAc1ESE/LXITHSln4UxpI3/k4bv0e1m//QP1IRQQNFCZITMtYxjCk2vWk0SDYdg42KXfGfCXPpPp/iydGguDm+UPTVT4uqy9ObpUQ9mOLEYuiMFEjZl+Lo9fczp9M0PSF3IOAI02MffOv460KsyEA90vGFUdGdGG9SxEnxxLQxJq8bwcR+VDMc9L5wjGvEYKx0+3HQ3g36FN3Sj9eXeN509esUYIKLVncL82q61V1eo45/vSziNhCCnL+yXKtlmBZX3/gxFnl39D0rlXZKj07cJbsrGW5LeQL4nAkiPOIz6YTVJg5HMMIS3KUkkQWLVTVPMcNXILIm/YKz2KwqK18i0LDAGfCfF5FSkFczKdKhJPRIb2x+arjvyBUonY8yogGNcE3dBSXpZ6zipLI5zxUpQKsclEszpzz+HvpyZKkMYMT8cW+KowsX4ZZTsURZ2OUQsiJE8xDx664fXfj5pMkOHkPISAiH1Xq+0BDf73D44QbvNBuS4IdYDbWxzOjAOpxYKSl/dUWqgYueJh+uEKNtNYP2nzUBHHXGhtJETpyPJEUPIFi520t7Q8heGf1RHQTF62cT6EgPExQ0Jah89zwX6JuT9wcG0psbFVeRbKFJ+sHzCGX6EbnaJpdbRM/ymdbw60CDEpqzuQROv+W2/i6dcOOARlVrNcSSP/SE6zEMKlDQAdiqz20oaf4SR3e9OPDEWdnpk/6D4K2Fm8ubAMEG1K6iIWttWQEqGndjB2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(66476007)(8936002)(8676002)(186003)(83380400001)(66556008)(316002)(54906003)(66946007)(5660300002)(4326008)(36756003)(2616005)(6512007)(41300700001)(6862004)(6666004)(6506007)(2906002)(38100700002)(6486002)(86362001)(478600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UvMPc4dBpZT+QKMZ025kZtwAQk/ZpR6QgN7Eysb0PPJ2LqdOE7yrgyCM+S+U?=
 =?us-ascii?Q?f2iXnsSM1dFfKolgjFNDsskAwkDIC2CJXvGQhlSjgUD/XAps+069lGtYU9Yd?=
 =?us-ascii?Q?I1dviyp5ShWloqjRRpWMokOyfo4HSL1v4othgCYGm6DHcVn0rihBItvA0MaX?=
 =?us-ascii?Q?LR95EPieR8XLLgKuuWmy3eR/SKCOWTQ3os0KhtojQHKDCXoOfThPpWH0le6p?=
 =?us-ascii?Q?EAO9Fy2YKz5QIxbe9DhHM1Syy54nWzSDTCc2YJEXB36q08aPq8/th0WhNMNs?=
 =?us-ascii?Q?HnFAd69PZxSsDd5HuSDyzokHU8mspRt6LCnIg+W7OVsB34kJCDeIKfoeSYjT?=
 =?us-ascii?Q?LBPTjOK+1PadzDbmDnlnTICTuQrDP+dQJgBNGK4yMxso3CVP3VL7SQsONAth?=
 =?us-ascii?Q?iZeGCPWH679a+JTlg4qFDhmw2MdZr1WeL6zri1KD58dZUMi+7H5GYUfXEMc1?=
 =?us-ascii?Q?Ea4TOTJ2l6H6Y8GdiTShvgy3MOi1OspE6nJ6Y1sBupiA/hnaU8K6X8ebag2C?=
 =?us-ascii?Q?d29laR3SpCmvNKG2ZTm/LTY6w3D3Se0uesycJTcSY7GDEe6mZ+2eau6Ztdo/?=
 =?us-ascii?Q?U1IeMeH5fAkKHi6t4t2qx8Tjwcekqs6w/CnaN+NyRZOUcCn+2Ed9m4kmRT0X?=
 =?us-ascii?Q?R86q2IFjjHXKVv76XA6DduUQeagmZnxGXXk7kM4n+vcNGoJGH7qGkLnhxjeS?=
 =?us-ascii?Q?vHJCw6U7xWTO9kL4tzz9eif+dJA/BcQtd+xN1FWSmTtXWaOs4WZoltqVi+cq?=
 =?us-ascii?Q?FmuEWUyLZH6ADbf+WW5hORJSb/oCzd4mV7GKxuElGBua7bUNAbjZXJ06Mm98?=
 =?us-ascii?Q?m5E5zr5twMy44jXbXuOd0rF3BkAYlt5OAk/SDBQY95q4skPLE22wFWWCTro9?=
 =?us-ascii?Q?TS+B4mYvJGTW8kNL8MzIcI95EafjcbSjKkAzwXIMAtOgfItmVrFQ7gtmZ8kh?=
 =?us-ascii?Q?zOZ3trdJwNwL4UeKCCRpcSq1rtp+E/SoSoWLscjXRTqpMjVxyDC1jbbhzyrs?=
 =?us-ascii?Q?5lH4SJUopkiIbZXh93103g+Me0IPVTB2joEqA1P9tqw9VPcE52+2tcmW8iJz?=
 =?us-ascii?Q?5wl325YgiuVKE1MBFFlHrtickOxYJk4cjqIRekKfVk7Gbr6Isyt9bYKDzZA4?=
 =?us-ascii?Q?qykcjFpbXCMbTJch7wX78YNIY/QbHiyX2VElvrbbjhHY5EapTNPxIH2s18XF?=
 =?us-ascii?Q?SkaUvavgrh066sD5hqmwRiS2RUkwv0t9JMdVraZ09Sr2fqPXC0ocInvny7aK?=
 =?us-ascii?Q?uk5x2BN3BChx/AQUIP2VtM5AjIjzERyPxaOVVbFx1eIMZplQD2+8Nltzgphx?=
 =?us-ascii?Q?Zf6j5C50ke886koWyA3lBRwyTrc04tLHJLuvlmfulzqBROgb5Mrm0XEO2rM2?=
 =?us-ascii?Q?SxJBM4JXYGOj3NYehOlFFYEL+NiIT00IbJz/Srmuja1Gnaz5x8BDX/lxY4bA?=
 =?us-ascii?Q?cvtiiO3tFSZ84TDqsd+sCfu2ofoXlHmLxq8bCaGdUuDlNWMvS26ZVWsY/bt2?=
 =?us-ascii?Q?pgwtbnHPF6WEai55Y/mqXYBU92A7tNtEs3eYkM2c6n9qrBQLL3VZd7xlrbRF?=
 =?us-ascii?Q?0g8ugDSTFoShJyGq6vKVk/2KB1qt6pkOrkg5Vnkc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3e3e1b-b70f-4054-03bf-08da70bac113
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 17:01:03.3541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YAKwKDCiuh5X9iLUl1nr7NF+u73cywMrQXGvFccXrIU4B2fDAP+hZ9uWQHrdy7by
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4548
X-Spam-Status: No, score=-0.0 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 04:05:04AM +0000, Tian, Kevin wrote:

> > I think this is not correct, just because we made it discoverable does
> > not absolve the kernel of compatibility. If we change the limit, eg to
> > 1, and a real userspace stops working then we still broke userspace.
> 
> iiuc Alex's suggestion doesn't conflict with the 'try and fail' model.
> By using the reserved field of vfio_device_feature_dma_logging_control
> to return the limit of the specified page_size from a given tracker, 
> the user can quickly retry and adapt to that limit if workable.

Again, no it can't. The marshalling limit is not the device limit and
it will still potentially fail. Userspace does not gain much
additional API certainty by knowing this internal limit.

> Otherwise what would be an efficient policy for user to retry after
> a failure? Say initially user requests 100 ranges with 4K page size
> but the tracker can only support 10 ranges. w/o a hint returned
> from the tracker then the user just blindly try 100, 90, 80, ... or 
> using a bisect algorithm?

With what I just said the minimum is PAGE_SIZE, so if some userspace
is using a huge range list it should try the huge list first (assuming
the kernel has been updated because someone justified a use case
here), then try to narrow to PAGE_SIZE, then give up.

The main point is there is nothing for current qemu to do - we do not
want to duplicate the kernel narrowing algorithm into qemu - the idea
is to define the interface in a way that accomodates what qemu needs.

The only issue is the bounding the memory allocation.

Jason
