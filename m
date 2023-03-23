Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6920A6C6697
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjCWLbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjCWLbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:31:22 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A083412BC4;
        Thu, 23 Mar 2023 04:31:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEr06WBTVJdBCKY5lTT+AoG5vd98BsglzIcusohVJWmqStFW5GGv8VOlM4m/WzzWAPFGWTJpT0zBvMppLOu07m3bdqUOVivQjRfMOahCHHYQ2BId3qF9XhJ4D9t+qT5tlpyqvFhiw5QSOWLpmQqQSJ90sfJkorztCLXWJd8QOa/cGesr7RBLQ9lkH0QsHd/ZO+7Qr6zT4MrpXgYh0pHeJQ/tGIpfwzGTuYMNS4/GUL43MQplGfddoT6J4KOoAcIFK0kl4Oll/bLJeyG/d/XLNDKp0+2o+8aD5D2773k4r+2/lMoKLx6apriK1ogP8SrVsAzBnqZjHWtSzvQQtwd3Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgwGkRvQGhnQvvV2Qnfi3jU5my70jRonwiuIg94yKUQ=;
 b=SIMZtA6UEbZZUGPd3waL5u5/LvmWLcyQb/s6+PJw83Q5dwdkEVaOZOP85zIahPqSa/CDb552qHaen++fX7u/clV3BDnp6LwlVaQU4oh4AH8ahaxai+/Zc5q5ZAr5EFV6QS5STXRgpvH2V1l931/NNCp0+CPruqzup0hGVRweeTguAZYAyNcE1/2wZ31FYyfuoQJqwSICW59+Xqv90TG+t7jeBpIYDC2DjXfRhoAY0eYiAV8O3Pa31UFBg+uEzHG2CbmGhhj82hAdS3utZpFCySEVC5CyXoci3aUv8t4EKJIRYq6YXmV53BzU2rSzksb9TBJnYQK96lY/RoQROXVsrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgwGkRvQGhnQvvV2Qnfi3jU5my70jRonwiuIg94yKUQ=;
 b=GTe3YcDQxj8+zrU4E2Pmco3EFxvLATiT5p3CceLGTBGnb6yhIocmlCQQZNzIz9XuYj+Bjno5cDB9MKAQq2V0ZNblD3cDtXsnkJ+5HBcPhmcz7dneS4K0H8dOVH9YeaTswV4J0I+6T4/A8nMfQWBtyokRiy0Dn46Ds7WyWPZFI1Inns7Pzv/4h8XJgohZl433yyZS9UN7cfHQ+8PFa7B/XEvULns9O9s0hVvjoY5jI5bS9X3OBQJoR0WtISp3z/TDzKUP9FTxMv/YJbjeRTizmZZt8A92orA/xoB/IvLk2xDdbYLWi8U7L1r9eiUFH2ctYvNuQ4/awjkWGPie4VKerg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 11:31:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 11:31:18 +0000
Date:   Thu, 23 Mar 2023 08:31:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com, Cindy Lu <lulu@redhat.com>
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <ZBw4hGj8oGARaKhW@nvidia.com>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
 <20230217051158-mutt-send-email-mst@kernel.org>
 <Y+92c9us3HVjO2Zq@nvidia.com>
 <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
 <20230310034101-mutt-send-email-mst@kernel.org>
 <CACGkMEsr3xSa=1WtU35CepWSJ8CK9g4nGXgmHS_9D09LHi7H8g@mail.gmail.com>
 <20230310045100-mutt-send-email-mst@kernel.org>
 <ZAskNjP3d9ipki4k@nvidia.com>
 <c6e60ed9-6de2-2f4a-7bd1-52c53ed57a28@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6e60ed9-6de2-2f4a-7bd1-52c53ed57a28@huawei.com>
X-ClientProxiedBy: YT4PR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c73ff28-ac10-4beb-2765-08db2b921e96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +FL3JPEFTilyC3ko+dvlZPOcztc4fUQYrvdIizeWuXUmwuyb/euJ057D6XzssgGmZ0HDM+jAyHAKvhxrqDKNugqhftVgspLGWXtrhNY3SGh0LyzKikng3OfzzfDjN5+iUZP4SJ07tx3mJyqw+nIxwuChK+QEnVBxQ3raxrjnLfPFH/hnERoEFTA5Y9ANLWxncgTHhYSLrcq197KkLui8rODWJbA4uB6oLwED09ifq/03H1Ah0Edn6htHkdnl+ANmHv7Nqk22gYghHZbVGFGd30uRxSsna7RYGBE3QE/y6CLbJO2WfdnPoR7nIismFtEKX1qmUyHcV7+D0hRWbUlgzPQZC9LPsU6hg44PQCfy7Z6cI2FDeYM1T0U91SIL5EkWKu1Vj0bPkDUH3miVzs/shJRLrg9cnafA/zVPNjIbAuD2+18zWHuxeQf9XHrvOAb4hne5TphFvHFOhNS6bIRF4+xhU0AD8Nrusz1twZ/ykpd5tXlFWdFajeF432zl9dN61kna5pzxGIh++eb3i0XP0ojXYx6d0RmaT7rYY9zWDXJKKXGzuM/duzaYzRVm4GM6GrBVsov0jwpqTgIA11NcVN8oj3Jaal3CjIqpNRo4vTaFn5HHqk7fsxqUouVt+BUh9PrcVKpNv8yfZmPYpETm5BOq4iU7LVmMoZ4Q2T9fMhzmKOMdFTxc/S2bagHP8TrZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199018)(66946007)(66556008)(66476007)(8936002)(45080400002)(41300700001)(6916009)(4326008)(86362001)(8676002)(36756003)(38100700002)(26005)(6512007)(6506007)(2616005)(83380400001)(186003)(316002)(478600001)(6486002)(966005)(54906003)(2906002)(5660300002)(7416002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0/Ete/LvgouHTQENTKhUE4z01IwTMicwsXVhLB4iLSKxDP6iekN92gicsmt/?=
 =?us-ascii?Q?FSK00hszWRZ1jXE4d3RqWQNftIN+FRM0DpKAL9qvgJHfGWFAn3RP6SG2FY4n?=
 =?us-ascii?Q?pqUiJHfDERXqMvd670+IJzGHj4oCUrm+uQQ/HvBHIXNDSZYLlKfW6nCFKLyq?=
 =?us-ascii?Q?pGRiNzA/WVfyXxRoEJk2x2weR+SUci7Ujn7Jfrw1hJlH9lVA/FArwGl4q1EA?=
 =?us-ascii?Q?s3R+YNLj0Tw8l4XLv+6yWPz92VhWznF+vgV7Iu5EZ3+MmFH81q0hfKo3bM5z?=
 =?us-ascii?Q?fepbxPL1nF22VbOSgwr84oe7qaUEbNJOO0ZOKjmcO2VQwo1zx++3ONo/gE6h?=
 =?us-ascii?Q?aSQO10OuAQx2H4FbmHfZKqJLslvrXOoHCF0DvtJ+C6OLQFdz702En1Oa6o7s?=
 =?us-ascii?Q?TpeHe0x59WHulYwKt2sEcwhkwBcK8sjNzaVt+JkP6B7MBx1GMvlIOYP8Yxo+?=
 =?us-ascii?Q?8htRr6OucW7JgdyG6Fmx1HAl4GVnzSrxNv1Isrz9toCkBbZwO+P+OVqQwvqB?=
 =?us-ascii?Q?H7lzrLJi2/TZ63Nm6XKTYSdqna1DrknQ0bgHg2tWkQ9xBftDU8xtvwPnzH8f?=
 =?us-ascii?Q?NqYqTKv/ib5symoTYMkIslOHS3dbWZGnIIDmA+fMlQz6PIsi67c5a7ii/bB7?=
 =?us-ascii?Q?8MVXkLJCE9PpKs3I+4weCXOitpH5bDd4odxjXEZk0tEJQkywo0W39QZfX/Q8?=
 =?us-ascii?Q?hoG2cytrW0wliMY7EYCHwKpEjBawC7eF2UJNyD4/atVmlqQbuRn19I+u4q9B?=
 =?us-ascii?Q?lzjwEKfthSGJ3Ipx2B4D+whpwVwLb3XC55xGWPiwqNryCUtt+gJIkzV73QfL?=
 =?us-ascii?Q?aRp9KTCrJAtFB1APuDPlckb6UknqNHcDJFhabo3+QcBDKK6QWBYy++ieM0/C?=
 =?us-ascii?Q?QnR0DpjUXmiAgVyfIsQxZYhaSOw0ln7gTW4QwT3+IJo3FMNU+OtSFw1Riarj?=
 =?us-ascii?Q?pOu9Fe2GU8Y8sFTI7/z8B4xczQO+CD7iZY+VXRGxoiR1HSOwGItiapWYXy08?=
 =?us-ascii?Q?t4glvmnBABGEYC/zm69Jb9z7oLpUQWazxtFhP/r/eD/igEnnDWr7Um3NbWlU?=
 =?us-ascii?Q?zPA3kJxQPpMJ0mYOo/0I9lRyOyZDVDzI242k4xmZ9PcWKFDP7pjPh9WAvYNY?=
 =?us-ascii?Q?u6I+dTrz9Knm84H8GqRYaJKttDnRq1ARX/HhXr10I6mvQ7Ne93lDXWhIjeJ9?=
 =?us-ascii?Q?rSGztysCUan1BxUyYjA4mlfpn6i2SU+Whlfy+XcYjwsTKy9mjr+Ddx2k4HHy?=
 =?us-ascii?Q?AP220ySSg1p9cNwfEl3LjQk5czdZbEGeo8Wgbec1R47EQ/5R3OEjTJdQXPqJ?=
 =?us-ascii?Q?SQ5T8V6bv3Wv76IRi0jvdIyIxgRVp9eYPwWJ0OCV529MrbcZCwaXtthpEilX?=
 =?us-ascii?Q?zDhSKzBpikikZqxP4ZMBiKd9jre+LcxfTOmGmPUDAidK5N37lg1IROY7SLL9?=
 =?us-ascii?Q?DePIfW/LDj9qItvRUKnJ6KyEVQHaVeclep+BFB8eyBj4PTpCgxw5oJlvZZqA?=
 =?us-ascii?Q?J0d7c3Rx2cy2hiOoMT/+iGRD1hbLG1IP39OUZkZ8JJA/+0nXMKI+aFgtbYff?=
 =?us-ascii?Q?Tg2xy5dhaa1I/bmNMzqvhQsOUJqqRoz58oehPNrN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c73ff28-ac10-4beb-2765-08db2b921e96
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:31:18.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kmturz/UnKjDR12kvvLJmogcA0DjRJxHmFARnm0aW8+PQVpQXNBcsb9WujrkpLWG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 05:22:36PM +0800, Nanyong Sun wrote:
> > A patch to export that function is alread posted:
> > 
> > https://lore.kernel.org/linux-iommu/BN9PR11MB52760E9705F2985EACCD5C4A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com/T/#u
> > 
> > But I do not want VDPA to mis-use it unless it also implements all the
> > ownership stuff properly.
> > 

> I want to confirm if we need to introduce iommu group logic to vdpa, as "all
> the ownership stuff" ?

You have to call iommu_device_claim_dma_owner()

But again, this is all pointless, iommufd takes are of all of this and
VDPA should switch to it instead of more hacking.

Jason
