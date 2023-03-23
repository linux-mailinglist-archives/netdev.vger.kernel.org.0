Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14046C681A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbjCWMWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbjCWMVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:21:42 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E028F25E30;
        Thu, 23 Mar 2023 05:20:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUyyUNOmlBL3XUZ42cJWCwHjfJf2nBKJsO6ewQwFM+Y1keX3stGObHoocQcUaZJkEYXIpt3QPndUNE7Ow3zVmrrqL4CKLhTmmwSM8P8waa0Dnq3IbmY2xU4ej4sQo9wzl3uE6sfbCTrnqcslXoSj19i7ZNcNCgpu7WqcOpQgF4h20S3cpjr8RbI3pnsChF7PiWdy2AnnKKw+0CJMBnvafKOXY0v0i3PX4/iDOSL20J+14C8NVYIk4K83KY14mmkg6wc/pygkUpZG9BR2hMYtQAPj/PgvE8r+E+/4rt0gVaVZBtDVJrtt9RhbS2DW3s5yaEqIIt5W9K6fI6+GcO7pYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVXqNt90UWn7X1fcI/tovO+d9GW1QWvWcYPgoyk7MKA=;
 b=Lwkx5m94+HtzrMfbBCjfe6L5Ucc0Z3HWCkgSDkFpZRuyVzj1tcDYGnUvrQ6ZypJ6rPF8hRwLqqvgrPDwFMQbQJrP263dK0WBE8iI7yqkpPjZqqWlU+xJ2I5c2w3vXrPFxZouZK9TMxaqhtwMZn0QiMncDbIpJYSkeprA2HaCdmgtm7zrUBG029ljmbMDlWCGeOodE5QGSdfWW21PXysQpo5Ox4TbxghyOEjuDWsL2un+EQe7+/liUpfTahNKN9TlJkA/ifoljd2+E024pzJ6QwDpIC4BNg8s4qVW2CgC08EG28Yhc+GFFZ0L6Lg5b4uchPQw6200g0+Skv2WX6aARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVXqNt90UWn7X1fcI/tovO+d9GW1QWvWcYPgoyk7MKA=;
 b=mxup0iP69LNUu6ZQC61R9BG1UnBqmOGT6E2r4mFXXTU97xwFPGuWG8fgz29WW2EBFP0kXkfn1IAJoTJzsplHYddj4BjjmBsitLepVwttMJbwLXB45kcL2KhRLMzxZhMvGH3FwcVZH0ytnjrhk3jHJ6Y7d1qWOjbIyLFEi+85J26JjdetV+nkVYnGqn2rhdDXJmqKsJ1S1aVSEnZycqVydFw3eEU84TJ+IML+zNR6m5ghibAX26r1Uhlck1CDGvD9YpgtpX54pJSQcfpImOI0M00MgZLKmlnNVHihSMT557gzNFRKBkYNgI7XzSoOibA9RKcn6VuUdh0+bBn2WFY4ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH8PR12MB7136.namprd12.prod.outlook.com (2603:10b6:510:22b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 12:20:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 12:20:46 +0000
Date:   Thu, 23 Mar 2023 09:20:44 -0300
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
Message-ID: <ZBxEHFF9p4wtfcQv@nvidia.com>
References: <20230217051158-mutt-send-email-mst@kernel.org>
 <Y+92c9us3HVjO2Zq@nvidia.com>
 <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
 <20230310034101-mutt-send-email-mst@kernel.org>
 <CACGkMEsr3xSa=1WtU35CepWSJ8CK9g4nGXgmHS_9D09LHi7H8g@mail.gmail.com>
 <20230310045100-mutt-send-email-mst@kernel.org>
 <ZAskNjP3d9ipki4k@nvidia.com>
 <c6e60ed9-6de2-2f4a-7bd1-52c53ed57a28@huawei.com>
 <ZBw4hGj8oGARaKhW@nvidia.com>
 <b2c24e31-a708-8556-0029-93c0aa22a6ef@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2c24e31-a708-8556-0029-93c0aa22a6ef@huawei.com>
X-ClientProxiedBy: YT4PR01CA0205.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH8PR12MB7136:EE_
X-MS-Office365-Filtering-Correlation-Id: 623993bf-5275-42b4-ece0-08db2b9907d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BMA3fItuNYwTa8o5rCNjYB6Uj1Gv17cJz3i2zgre9T0Z49Vf4qbJuQvLdff59aLETgFTxVUcrG2SsB5vjf7JMtdZSMaJbca0uBhhZ6u7qojTYuVsk2p7eDcdinvBqIeYedPKhyGy0xOLhBSz0fis5UP1IYiPJkhhLwInPQDtGizBUPlvfaB8x/Ypc4/uxdXWXD34tLNSXyVgmuC7Erkb041VkW2N1BbbtwMFtnup/lXg4HmnQUolYScFGcWdNwdMPMPIkzZ7kippaw2/qu9EozKfOGGUtHMcgtb2b4YZMoOaOQpe+HmFt1+9CYCD6gpm8AlmTOGe37nOvIpj5EmCM2mrrqr+SBEvL+S3KEhe3ypBlwdawpLJnNgf7tewtDv5kznrO31zQ6uNmMSYvOHSAo3rd3WnDGR5dEoJMsi1TCGg4eWlXMiDVASfTp1uGr0NNfwCbVmz/J0Cy+0IRPsqFQLUcR+EpbWaJfjfxjcWmUFVXJZAhOdKTboNt2DGlZwJjNi8qoNOBMkvZ5MiShX0ZFa0UN/JHF+URiOLVuiY5ncJMGDPlbNSDzga6a9xVEPhpQjNy8edj42nprDUuIrbkRA4MiEfv+QsnRwHVc7TxlbKjq3joPbsVeT0z7tzytcvXK/UdBrymgoCxc9NMSWeiuo7cg0XcX+jRcNXj5B/t905iD+tgkOAPc3TiT81rbv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(4326008)(6916009)(66556008)(66476007)(8676002)(66946007)(316002)(54906003)(5660300002)(7416002)(41300700001)(8936002)(53546011)(26005)(6512007)(6506007)(2616005)(186003)(83380400001)(45080400002)(478600001)(6486002)(966005)(86362001)(36756003)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDVla0l3NHZwY2lEVm9ObExFTmFzU2t1ZWQ3UWUzOE5aMDIwR0NhdmF0SHZX?=
 =?utf-8?B?UWNmTHRqQlBKKy85d1VhN0VoRlYyZGltcTBBQS9Fb1NEdjkvYkpxYU9yV3Q0?=
 =?utf-8?B?alMwSi9tY1AwTy83RmJKTVIwK3p1eXlqNlFIejJyNWRKS29CRTdIc3pWbzVq?=
 =?utf-8?B?eGdhbTliMGk1K3FQaVZsclo5RUVrU3RjSU9nZHJOcjZZSldtNVZ6TFJJZGpW?=
 =?utf-8?B?MDNDcUJ5TmN0ZlZKSUp6cGx4V1Z2dlFTajNKRmxHYTRYQWdCT3FDREU5R1FV?=
 =?utf-8?B?b0VCamN5eFgvTE95NU5tUjRPSDc5MVVZYVpmRmhUa1J0ZUw4NTJ1ZjdrNHM4?=
 =?utf-8?B?Nmg5emY2NE5DSEt0YkphWEFuUXdEd0N0aThvY2hjcCtzUDh0Rm53Q2w2VW1k?=
 =?utf-8?B?RVhXUy9ySmc2R1NuMEhQZFcvQm5GREhCektabmROdFp6dk1nT2x6aC9mYndQ?=
 =?utf-8?B?VFU1OUNrTUtlRE5OVUlxWkU1T0sxNWM0bm4xTVA1REdCZnJUQXFPUmVqYXMy?=
 =?utf-8?B?TDNXOHc1VnVSbWtrNlM2WVYyS29PMnU3NkxoK1BrQ0txdFFESzBDaUtSRXUy?=
 =?utf-8?B?MEhtTWN4bEVobkltMmROWlFiWFZVaS9ibjB5WVpIczdLcXpTcVdQV1N2WkQ2?=
 =?utf-8?B?SmNxR0g0T1dzcVRPVDZPQnNveS9TTDdYVDZXcHN6UnF2NzJvYTNudlBweFZF?=
 =?utf-8?B?UFMzT1J5REEva204YkVWRWdxb2VSWnpyRml1Skh0WWV4bkR6MFFvTDU3Y3pn?=
 =?utf-8?B?L3BGa2kxd0pmWFdRTkJxcjFRL3RVTmZ6M0VhLzZaTTg0Z1NPa2NiK1NOOUFW?=
 =?utf-8?B?UCtJa05nT01lVXA5c2V3UWhHeDNtWWpqaURVRzlRcGtrSzhlUkRtRWUyVHJS?=
 =?utf-8?B?TkxsTzh5U01nU04rZWd1Y01rNzFSd3A0N0FOaFBJRDlBeHhjdXdXajdlbWJF?=
 =?utf-8?B?dFlKVjJIT0JHaDZBb3loamVId2NyRHgzdldWaU80UnNvRFVURnZqbnd6S293?=
 =?utf-8?B?ODRLRVZOZ01ZOG9wZHlFYVRQajk0THQ5ZFdPdENoYmVxaWI5SjArS1NxZTFi?=
 =?utf-8?B?YS9GWHFLeE05cm5na1MvVFhHT05sOC9rQTJuWnR0QnZySCs4a051OTBKOWFS?=
 =?utf-8?B?dzZoUzJrUlZtZW1IbHZ5dm5tNWRnREgycUJlbFkzbVpHZVdzejRtTUZid3A1?=
 =?utf-8?B?OTd1SGR3WFRyYWc4citORy9mbGo0RUlwdkgrRmpOdDdCVGlSTXc0QWw0NXF1?=
 =?utf-8?B?eTBwK21rU0lMcW1LbktPMElHSG9yV3Rva1dpY0Uxd2xxdlNNVkl3OWYyb2Fq?=
 =?utf-8?B?NFNhcEc3QndPaGpSN1dVWURYdktuaDN3VlU3dU14aUQvdHJyUzd5L2JzTEpu?=
 =?utf-8?B?a2hQc3ZYNXN4RkVCNEZ0blFUekorWjFhTVpLTnZLRVlGcm9taHpNa014VHY1?=
 =?utf-8?B?YUo5MmxvN2JKd1FEYnlYa2ZVbmNnL1kxUXcyMWVDYUV5bmtpZjB0YmFobWVo?=
 =?utf-8?B?blZXek95YllzU3VRZ2ZZODIzbThzVW5tQzREZXgwM0E0S3FpWG1RbXcra2t2?=
 =?utf-8?B?YkIzK2RkeWxrR2RzS0hIZEEyRkRVcXVsOHMxYiszQ2JSbHc4UnJSVkY3eGMz?=
 =?utf-8?B?a3VHSHFXcGVjNW1MRkhoVGhQMkRMVFFGUWVTdGZ1R0FDZTNDbDBnYXBLQmNW?=
 =?utf-8?B?WU10ODd5MHE1TWRhK2hQZHVQTm5USis4cUh3d1VieEVkVW1kRHRrbWdwVHgr?=
 =?utf-8?B?WkppUGRNd2tUMU92QlZ2bXFhZEk4bmRrNmNjOW9QU0p6UDIvQ0pRM0owSEJD?=
 =?utf-8?B?WnBCbjQ1TUk1dnFPOFpsYW9rK3ZLZHFCaFVkK3VFWS8zMllZLzFiRnFCTHdZ?=
 =?utf-8?B?UU82SFNMYVpNazF6d2tXM0psalpJYjUrOU1MUjNibHdRZmVsVWI4cERzQnNo?=
 =?utf-8?B?MEtZK1prenRiamRrRDFDeFZMOXltT1BBd0YxSWRqSHZsTmZ0M0pLR0hvQ2dT?=
 =?utf-8?B?b0RlVDcyc3E5WFl2RTUvTkxVb3FGOGhmUS9iYy9wRlhwNGxYK0kvNklxWEgx?=
 =?utf-8?B?SG15WDZxK0s0Y0ZSdS82bVp0YlNKZ3VNMnRJOTJJclRaK3lXWHhTVGVoT2lG?=
 =?utf-8?Q?xA4a0EuaOb5jKKwJkqLYKKjcf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623993bf-5275-42b4-ece0-08db2b9907d8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 12:20:46.6735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGkWQqFiRTL38U5jBr2xMvpWf5II/vM5WvqcfEHYOrARFm8Vmk7FVfZXvDi9PrQK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7136
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:15:44PM +0800, Nanyong Sun wrote:
> On 2023/3/23 19:31, Jason Gunthorpe wrote:
> 
> > On Thu, Mar 23, 2023 at 05:22:36PM +0800, Nanyong Sun wrote:
> > > > A patch to export that function is alread posted:
> > > > 
> > > > https://lore.kernel.org/linux-iommu/BN9PR11MB52760E9705F2985EACCD5C4A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com/T/#u
> > > > 
> > > > But I do not want VDPA to mis-use it unless it also implements all the
> > > > ownership stuff properly.
> > > > 
> > > I want to confirm if we need to introduce iommu group logic to vdpa, as "all
> > > the ownership stuff" ?
> > You have to call iommu_device_claim_dma_owner()
> > 
> > But again, this is all pointless, iommufd takes are of all of this and
> > VDPA should switch to it instead of more hacking.
> > 
> > Jason
> > .
> Yeah,  thanks for your suggestion，but as Michael and Jason Wang said,
> before iommufd is ready, we may need to make vDPA work well on software
> managed MSI platforms.
> To achieve that, basically we have two ways:
> 
> 1. export iommu_get_resv_regions, and get regions device by device.
> 2. introduce iommu group, get regions by iommu_get_group_resv_regions, which
> already exported.

I do not think you should dig the hole deeper. If proper iommu
support is important to you then you should invest in iommufd
conversion.

Jason
