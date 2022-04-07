Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8B14F82C1
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344598AbiDGPZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344577AbiDGPZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:25:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533B4215BD2;
        Thu,  7 Apr 2022 08:23:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmTR7UJZLqzCVXxpuBka2gyEL9QtRv4djReAFKSElx9Ml418UsDmmzir02H5KZElEdeE5xxlHrJFn4fkyn2N7Ei94V+C14sQW5aSyrFVRPUoQVmaflxjqxQreetlTDWKd0TgZZ7W+BAGIYMuN87IEeLq2GnXrE6Gy0zMEGhA/zNG6V9iOYoh1GqNzYCWHDjP7+oV7zr+vYCF31fUv+IyeK1qj1VtmmhIboK67VM8PmlZ5yd/0tQ6x14bhSojnskBff8pcIA8s7wwwgrvfLJaAXUI8jOoBtUl3AynYgh/E3Vhjt7s1+wSJWgjZ9yExoIBX8lRSIro5SPiWAE31pLw6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8U+c8ZaSAaeMnIjZ4aTvElznepkwH1fmOf7e03EWloE=;
 b=e43znEiessB8/FgqplAUJqtFSf8UAHxqukat3xdMkZsDwmYRqCm5IYmSWBu4ywy+DcPSD6/B5FSF3XkH6e4rKcBsry9jMmKNEp/s+liVYVlHhUaXonYqvjSYjEyzaWfOmu75/i8adkE4y9Aj0X2u9j6lgvbwTrtlhvBYgccVxXGhLoPAOIVRPvCa+nG8HM9hkR2ZkOIQemgna3YBK9IsT7n0e2yoPK7cmmTdjuhooz3BdxjWzAKelrjf1TsRuJm+Tp+4BbC7q8LLVZ9i5JyJc1D9JiaIm+8evLrxXtu+oWnjZf7unWcCn07ZUo0ewAGDIcdOo93VFzMnLD4h+6BhLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8U+c8ZaSAaeMnIjZ4aTvElznepkwH1fmOf7e03EWloE=;
 b=erQeCJJyXUDTE6CgrsqjImjQ/kx8+jA5ByMQhj9ULpCBRUWIJ2UkUIsyGUZ0h2i5cX0PWMlubfHvx01b2ptOhBpODTc5RdVOFIEiAolyFiMk4ThqRkSxdTfvglbQq+SBPVKLxMszMI7fZhHrVpmKomkUyn6OnBN6sc61vDviMGaqpHHnxCRr4zrKC3QopucNVs2RICMMw4Z6gaE4eYX4UDlouCm4pFYnNhe2dkr98MO3GE2HOnXR16hVGZYWt5GfRZMUOd1DedsmLfJLfsOTf8l6wCTLK8LoC7OEkeJY7DJkGBtS3LbfvIFwIPC4ItYB9kra6PHXOZHgc5sZ0Ahe6g==
Received: from MN2PR12MB3422.namprd12.prod.outlook.com (2603:10b6:208:ce::27)
 by BN8PR12MB3090.namprd12.prod.outlook.com (2603:10b6:408:67::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 15:23:34 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3422.namprd12.prod.outlook.com (2603:10b6:208:ce::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 15:23:33 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:23:33 +0000
Date:   Thu, 7 Apr 2022 12:23:31 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220407152331.GN2120790@nvidia.com>
References: <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
 <20220406142432.GF2120790@nvidia.com>
 <20220406151823.GG2120790@nvidia.com>
 <20220406155056.GA30433@lst.de>
 <20220406160623.GI2120790@nvidia.com>
 <20220406161031.GA31790@lst.de>
 <20220406171729.GJ2120790@nvidia.com>
 <BN9PR11MB5276F9CEA2B01B3E75094B6D8CE69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220407135946.GM2120790@nvidia.com>
 <fb55a025-348e-800c-e368-48be075d8e9c@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb55a025-348e-800c-e368-48be075d8e9c@arm.com>
X-ClientProxiedBy: CH0PR03CA0383.namprd03.prod.outlook.com
 (2603:10b6:610:119::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6899a8b9-74e7-4e30-c145-08da18aa940b
X-MS-TrafficTypeDiagnostic: MN2PR12MB3422:EE_|BN8PR12MB3090:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB342278B0AB51FC130D17D66FC2E69@MN2PR12MB3422.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRsvqlZ72Msf6UEVa8iiLdbbI1eVolcb5nKeQqGX1RmpImEsxfvGv2iwGvRIDs9xvl8ooQLeHI3Clb2XbI0fGvBi3PoB/o7jFUpfLNl7ofZzP9KIUFYOBWCwP76401BhQElVV1Fry6/6by/eaCvd6RTcV1S8Lxb+Zs25bvNleaUyFB1p7l9Okta1Kz+qIZCF70zUyOlISJIopiU7mu7bvSjYv0UpYiZCYDd25VxdTEVZ6xcj8jp4giIZethRhMDv2N0T0NQQL/Nv6YQOixjCjhBFOTye/9dgIwbuk7m2BxxJCo48yb5GneojQIUTxy4QSiW1+w3OM9E3IY+AllPrtUhxSc4xqSQ3z9kHD723S13EiS8w9jwGnCQE7VAV8yk88R3G3h7wOfjLz0eCLy0ZcMD7bEJ45ZkLY7m5WXLDIKS4obk6uPzCF/hIk3jCK5fHFFge0gqpK/JD+GOrMhWMlSuAJnadxuOFBWckF0hXhToDVjBMcia+i1UoHKUFiQu5V4lQzylZHlfDiznl6jTUyEfPKBNuHV2ZcXxFEurvuzxMv6yOfHcZUnxqTQIgINwZ72jHweA/Pl7v3C3iuLo5FNn7IOE/ezuV5BnRfGBrXDXeuX05BmHj0lueKRUlOHipxTTOtXFKd2ppXCA2ErDPBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3422.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(1076003)(186003)(2616005)(83380400001)(66556008)(5660300002)(8676002)(4326008)(2906002)(66476007)(8936002)(7416002)(66946007)(36756003)(6916009)(86362001)(33656002)(508600001)(6486002)(54906003)(316002)(6512007)(6506007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b1r1RGQ7At8FCIyQyfZ9zMb81+7cMUK1w0Wy5a76UdaoAqIebwnsJOxehktZ?=
 =?us-ascii?Q?yTXtzSZxQh9Aw+Clme759Hm5TEoNMre5HwkNJdZ2ds1Y8GLxYywiQTQHqWzX?=
 =?us-ascii?Q?wB8F3EhK2gfbO19syqCCFsBoZ1YaKK7X0Sa+E3x90Brkk1VbllHE8Fx4biK8?=
 =?us-ascii?Q?T7CXHOJBGnFH5RiwwU/NXkmy1oMDGM5YweJivIrQX1GJm/kyFyiQjwz83UX8?=
 =?us-ascii?Q?96A4WDu0NATqVJO7AoqCG2T7t7EKSRIOqikeC1vSqPukffzT1lRRhKMAKKfj?=
 =?us-ascii?Q?CBX77R1KYLUOrfPfBVVkHoYmfFMyZps0fQ19ih+og66enkhtpucXzwCb6WDG?=
 =?us-ascii?Q?WymlROJH6Gwzk21+kzAxu/mo+ylBs7L04dH7+yRwijxIcoofxLfwcAvcgQpf?=
 =?us-ascii?Q?AWJVRh9vBYmP7nPM5obedcqJczWvB01Bngw7gV1/nmDjMvRamOWXnbhizptX?=
 =?us-ascii?Q?tBFtbnq+2YwL+F0UThey9ixhGd4ZNWicWFUnOg7Q0Yqq1q92dW02X4ZYPBQT?=
 =?us-ascii?Q?Fb0rmfhQGoX9q0TZcqEvE39RCuk61Gv3NHHlMYOaYP0qDWoSJepFmihp7AhA?=
 =?us-ascii?Q?tS9Q+zIjN+lsw0I6jrU1JyMRk2nnog6c5eOj4vFi5UXPjtYkkVu5VPDbeEWU?=
 =?us-ascii?Q?w3srM4qtEa9shk3xyUejoBUe2rkgP9BSWAE+CeeuN7vJlwZD4nQAQsGGn3ok?=
 =?us-ascii?Q?K8O6vH3oEPK5pBSMZNhiAG7BZ1UnaRF3d3mXkBW9QEiugbktosN6JrpeZAsZ?=
 =?us-ascii?Q?01OIVbuc4vgKPVlfogYcggXiXvHy9ae3Rg2m0Ia6vKaD89OcW7zjuL0hYISm?=
 =?us-ascii?Q?lJ5wiePpQKHuBUiOGWHkJblvirN0lKVxV1TKlQdYqVf/i5Sc+SDUwKUE2Q09?=
 =?us-ascii?Q?PzfqNma1fbdZdpcScZZgRAqtohZyXdF4Ob2JnExXJKSrXEoYEyN7COJX2spd?=
 =?us-ascii?Q?msDZZoU0OPkkfv733OUo0xBGZzdT1DTkuQ0SV2dfOnqN+/d4oacO2xmKaJpk?=
 =?us-ascii?Q?Fc0+oibNsVnraDp9SVKdIUNvtGYL/7O52rehawesE4gMgKPRAXTeh7RvrEh4?=
 =?us-ascii?Q?R9lIwGb6Ncbz+ah7ksN6SsrQn0Y9YTVu5Benqle9oehaVIfK61q8Jpbbsrf4?=
 =?us-ascii?Q?0FIjFBtXl0wHu8MvEpE/n7Dpz5sI0fUQ6yqaosnduGu9MZbj7ScQT/vFd17J?=
 =?us-ascii?Q?V0dNaHiIbfoPj4KNx5jkquGuO63AnDQuYQVMe8lUssBIdzPjgZFWn4nzWdSq?=
 =?us-ascii?Q?lDqh0yGQ2fd874bq4E60G1jTBAk5HXmOYN4SK5K4mPgdQN/HRI3uaoYbHHjr?=
 =?us-ascii?Q?uziNtarXwFhNFmUoH+iifDtSUzSqgybtdoOxnlX4LuigwtbI5RchgnCvP5Sm?=
 =?us-ascii?Q?DpY3hKAOJfMtfYH6dHSWsuGrOeqGTRfdMTDLsSJrqxoIOFXwHqKj66kSDH6l?=
 =?us-ascii?Q?Ubg68GCNQx1mAuNsyYL1eZASEJtUPQ853HecWe1dnW702JBt0fPrijC1Rt70?=
 =?us-ascii?Q?LQ9VHdyUX1sn4hUxwFLYs9eWnOGLVT+iDCVm/si0vn7qRly4sB0x+o4A+ULE?=
 =?us-ascii?Q?lRfe5gV7Aa8f4+s3OPt9gP5Hd0MDu/97RFjbTguw0eZjjD4coR9TemRajFHp?=
 =?us-ascii?Q?GL6SaBGHvr7/aOeZzv3s+b6ylghMG8Zg2nFi0UEdi25M5Y1nHuhgAY8tL4lD?=
 =?us-ascii?Q?Fx39hYwyGhss2NJNyXl78DUu9NGvD2DiLZm7kWy/M+Myw68GbFyQLLtvahKk?=
 =?us-ascii?Q?9WkkGcP8uw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6899a8b9-74e7-4e30-c145-08da18aa940b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:23:33.4804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyi03tivqlR2Hl3E05Avy7OY7hsQFfsbkOBnquJRjebWnDVEkPtPZAfVWmBUsRpN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3090
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 04:17:11PM +0100, Robin Murphy wrote:

> For the specific case of overriding PCIe No Snoop (which is more problematic
> from an Arm SMMU PoV) when assigning to a VM, would that not be easier
> solved by just having vfio-pci clear the "Enable No Snoop" control bit in
> the endpoint's PCIe capability?

Ideally.

That was rediscussed recently, apparently there are non-compliant
devices and drivers that just ignore the bit. 

Presumably this is why x86 had to move to an IOMMU enforced feature..

> That seems a pretty good summary - I think they're basically all "firmware
> told Linux I'm coherent so I'd better act coherent" cases, but that still
> doesn't necessarily mean that they're *forced* to respect that. One of the
> things on my to-do list is to try adding a DMA_ATTR_NO_SNOOP that can force
> DMA cache maintenance for coherent devices, primarily to hook up in Panfrost
> (where there is a bit of a performance to claw back on the coherent AmLogic
> SoCs by leaving certain buffers non-cacheable).

It would be great to see that in a way that could bring in the few other
GPU drivers doing no-snoop to a formal DMA API instead of hacking
their own stuff with wbinvd calls or whatever.

Thanks,
Jason
