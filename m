Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD8A6B3F6F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 13:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCJMgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 07:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjCJMgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 07:36:51 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6391C1135FF;
        Fri, 10 Mar 2023 04:36:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kvl5pxdLROcO3glkFiWiQR9xSAt+/zGFbJo/7IM79gYZWqdyTnvQAJNh0mGNzvzFrLCtpNnSXTDI/pkgd9kDfe/L4+8HR1oEh4wbqSpPE/2kEgph9DYjvuooJQaecZn97uoFERreKhJCKrpR4tLOCOjUsoC2stA0TUAryeqYEus1gYSfjX5u7GTtPHk+thnmOEwM+ucRmzgaQ7xmnlfANP+04g0WNzE8356IK2zIynJeoZ+sx/PqQmw2J/xF78rU1Pikh9Nm3cWTIzCHtNXAkPi2kjQIJHKPPBZAxi8t31hhTEyHaVKhVQHUo8TQHEjYj7C4dk7PHbk84rh+wRXJ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qfAe0UXQ64SHpD0PnmTVJtHb/00llIsYoVOllzSpxXM=;
 b=Gicp/D5lhe9ELwoUdIPG3x/chmXNVzIgqJYUH6lkPOUW6DCqWC1F/Pm4379nXOT3uvtq1pfCu6jEwB4fpMwjKoZaghfkhLCgpS4BYHNjgeYeBuGN7KhRgzEPDyfKrez7KATgFJXsoDAAolPI7kdAk0xzzEaYtM3XVHjleBaYEaldtHmUOZPBc3PHbvNzPj2U5Svjl0q8kRCwFbnlVo4vMfU2+IJC7VMjJ8BMc+OVzrQ6K8do+wTOuRJ5c4DmjPRkWycLRsEFik6KNkLlBwlkXtMbdsLX9bBaWYNMqWEOS0rt81fDOpTSBN/ovcKKOfkgiEbxi+wTDvcAbsZGIHKJ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfAe0UXQ64SHpD0PnmTVJtHb/00llIsYoVOllzSpxXM=;
 b=tUVaTFtpStgyTy9TpvxCjWz6NUMY2HTKCSNul3BEMMmy+j5RsjFQjqXPTAMGU4uo9R1s/Ktf31GMIjhb2/Ec2127gb34hS2Lz7LGL19h17caoKJ3pngBjyjcsBfh3tW//XTfjtRV4ZytTtZ5PqRBAAkojj5ds8Jl0NrBD6RiqBmK9vgZQENeEtWHptGZdDxGomkpmF+i+o/lRd/p3LJK6xOTqNX7J3zs4O2qDt6PQrxaCn2tCUYgBIT3FcXkOtjHc7xrtjajqmICLWHK5KKY5/suqZlq4B1Qg8jMpD9w57PsNHHBU8T84WFZfbOqFBwqHLIWO2+jNLNTi4b0hgCnWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB7991.namprd12.prod.outlook.com (2603:10b6:a03:4c3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 12:36:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 12:36:09 +0000
Date:   Fri, 10 Mar 2023 08:36:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com, Cindy Lu <lulu@redhat.com>
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <ZAskNjP3d9ipki4k@nvidia.com>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
 <20230217051158-mutt-send-email-mst@kernel.org>
 <Y+92c9us3HVjO2Zq@nvidia.com>
 <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
 <20230310034101-mutt-send-email-mst@kernel.org>
 <CACGkMEsr3xSa=1WtU35CepWSJ8CK9g4nGXgmHS_9D09LHi7H8g@mail.gmail.com>
 <20230310045100-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230310045100-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BYAPR06CA0014.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB7991:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db3b493-5067-4b24-49c4-08db21640656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEu595OGmb3P0NJ6OLpOa6x8ASMlu0l+HgPOixQ3MMD9AF4dsc9/Dw08lUOnB3aA65gkgYD/g5EqdRgEuquVoOCAJmZNoI5IMmaMFmPs++0jc/IHFF/xw0srFhMdwuDr/DUiocKn0SiNuJ+P8Ztza2UM6VPP7MySTteTbFna3vQHjflGAyUKB3QnZ6X9/0HK4ZNqK6VmHAIEt1000kyA8F81n/cqYAKLEqP2tjkwMNNBCvALgmountiG8SC5hcVzDZaeCZqIMU1aLnZ7zExnKaR5jMqmxGOekX0Egg1jEpWPlJfYIdbT0l5MiOTscSFLBv0OudKM+2wVBrvbWips1rabUXSZxJ14JgFbGClYhQT+a6Ke/OyruK0XlFx893glmqfoaSJkHZqI8sO7Zs8D3oAsSxauAnU1ra2C1M62I3sPJBg/GslzV4f5c9oZUf8K4AlCe10nIdfgFM1j523WRPI3G+KR8X89h3X+O9BkdRSRJMBtcMdRrK8ELrIx40jqNqx3nYcoO60LgypYhVifkoLV85GygbPxO5iIhWXONsvSEZ6pSTnP4Q/aSr4WYAwPsQ4h/LK9LPP4b7yF6k2HX27b9XRpA2QhMqCNtGKWSJSwl8zkDO1T+oTd9bGfxqkiF+gYGMUC/qdKPUUOA0mz3ZreQZoD2fEV5Qa4r8oLRTorO1Uk6s7M/mXR/lWGbiOe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199018)(36756003)(86362001)(38100700002)(83380400001)(8936002)(478600001)(2906002)(966005)(6486002)(7416002)(45080400002)(5660300002)(6916009)(4326008)(66476007)(66556008)(8676002)(66946007)(316002)(54906003)(41300700001)(186003)(2616005)(6666004)(53546011)(6512007)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDhndWQ0NmZQMVJkWDl1R0FCa0ZMd2llQnhpTGZENW16dVpEZ1VHaHZJOXFa?=
 =?utf-8?B?NmVzcWFWWW5kNVdzNUdwZEFRRFh5by94ZTB0RXVnRk40K3FOVUJSRXUrcm1B?=
 =?utf-8?B?Y3g2YndUUjdQM0VjVzYwQi82eXNyMUZ1ak8wck9FRUNqcjMyc1hqWHZEbDNt?=
 =?utf-8?B?UVdTYWF6NmM2bVdBcjJYdTFRT2FrdGZyUm8vbWVuSWFBZGVXYy9Wd01TaCs3?=
 =?utf-8?B?YWFscjlSNnplaS9vTHBXMjZOdm5qc0FNNXpYQ00rRjEyVGc1MEVkNUYySEhH?=
 =?utf-8?B?SmlpWGkwclVWSU1SYW5aUG1CQkx5YllRaEtQRGxEQnpUMnZVcU5YTUFVdHpk?=
 =?utf-8?B?KzlHa1ZPc1BqYlZCSndHS21iU2traEdHdUtLcEdqd3hzaUVEOHl2akZhWlpk?=
 =?utf-8?B?MFQyWmRVeVFWbnAydVZxOVdyVGtiWDcrOXhVaml0Z1gwR0k4cDlvMlVPclY4?=
 =?utf-8?B?Tk90TzgzS3lDakJ0RUJRNU1IMkRwcmdzS3R4R0Z6THRsMmZ0c1A0MjJsRVNL?=
 =?utf-8?B?Z1NpTkhFUjFNYWVQeW4vU0J3UDJDcDR0UTlXWnc2RG12TTR4UlZJeE5qRUNv?=
 =?utf-8?B?dmF5QXVyaDRlU2tSV1NwWGRzSGZlbVpiTzlkQS9mM1l1U21UZy9RZ3dkc0ds?=
 =?utf-8?B?OGZwWEpxNEdqNXNWUUJ6enkzKzZBdGlmY3p6RFE5bzc4dEF3R3RqTjRIaVo0?=
 =?utf-8?B?NGhsbWJ4bHJIakhxZlhFdG85aDAzUzRHOHY0RWRiWkdYb01SaDBiMlF4bXg4?=
 =?utf-8?B?YXZBWXd3M1lSeHBzaTFJUGdwMXNEbklUTWgrRU9UMnF2SEVIbVhFUnkxVXZM?=
 =?utf-8?B?a2VPT3FRZWtXZjFrRy9LcFhEbWVYTWd4bXRZRDFkQXJ1QUxiN1NuMk9WRngy?=
 =?utf-8?B?K0JsbzFVZlI4K0w5bFN0WEF4bjNDdFFFelZMd296ck42TXRZTE4zeDY4eU9s?=
 =?utf-8?B?VzNCTHE1RXduOC9rc0FRNDA4RjhCbm9YV3ZuWUxSSkM1RUpyaXBDcFpkRUhP?=
 =?utf-8?B?V1M5U3dtbThzTHY2MGEyYjdOZjdocjNUYjhZL09nR202SmRQRmFpMkxjWEQw?=
 =?utf-8?B?b0xLNG81TEJqVHN3ZmFHeG1WQlhiTi9QM1FJTWVSc3BHbUdTU1lLRllQaUJL?=
 =?utf-8?B?Z0tMQjkrY1NPRXpiUnc2b21tM2Z5RjBFZnhRVE41eDU1SG9SZzBseW1pOHJC?=
 =?utf-8?B?V3BwUHM1Z291aWkxWVhVR3pXMGkyUURBVVVxSm5xODFJRWFTc2JtMjZ3QXZZ?=
 =?utf-8?B?N1BMVVVaVGI3Q1Q2c3cyNTl5dkFGRW9YbllGVWdBV3FEZUFZQzZFdkFqOWZ1?=
 =?utf-8?B?ejExb3l2Z2hVazFsNTRUN1hvdkh5cEVTRHRIR3B1cXZiOGZLeHpjc2ZXZlNL?=
 =?utf-8?B?M1AxSXMxaHhyR1BhNHlBWXluZFd6enRRdUhHc1Vka01wZHFSeVlVZW5KYXZW?=
 =?utf-8?B?NGxiVENPUHhOVGJjTzZrMStobHlBcDVwSFpxQUhHdkx0UC9kTjZFNDRRUnY4?=
 =?utf-8?B?dHVUb1lLZGpDWDVlUkVJZTk0bWR1eVp3TmlkSThoZXFUYjVSWnlGNFNHOTJ3?=
 =?utf-8?B?RXVQNHJuU2NCRExmTFBKOEpnWThld0dQcTh2WGtRZjVTbUY5NlFUT2tjODln?=
 =?utf-8?B?eXpVZ1NvN3U3eGdoRmlVRlU0UHl6M1BkYlFaQnJKVzBtMUcyZkF2RUxIVFVs?=
 =?utf-8?B?QXJxdjcvZDIzZ0p5ajN4cUl4R2NYbmMybVdxZDh0eFphc1lHR2o5ODFQWXhI?=
 =?utf-8?B?NTViTVcwUW5kRE9MUWxSUFFkQ3oyWld6YnZyYndSUmU0Ry95U243T0Y3bHl3?=
 =?utf-8?B?c201S3dNaUpaQllpSnZEZGhxczFyb000S21XWG9tY3A2ZHpXOC8vaTY3QzhL?=
 =?utf-8?B?cFU5KzRiSGxBeG1xbkVXcndpWHR3TG1UTnNYcVpTaWRHWjRFemszZ2grZ2Nj?=
 =?utf-8?B?bTRvenkyejA3SERUOHFIeis2dk9KQjc1bktkWi9QbDc0bkJQQ29Gb1hvK25w?=
 =?utf-8?B?RGk4S1BBTnMwRlJqaC9qOVlnUkFaTHJUazludm9UdVJsQzhoakdBUXZrY3JP?=
 =?utf-8?B?b1drVEdjdUFOandqQmxQWERQaXBJaTQ2ektFT3lkeGhqM280RlNnbEpwM2J4?=
 =?utf-8?Q?ZShN+lj93cV82pvAzaS3Usk4G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db3b493-5067-4b24-49c4-08db21640656
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 12:36:09.1227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dScoqvMjygHrF5uyqJJzIqEqbqsc/XL6LjVAAIqMguy8V1Fj78R+xUQKbGc6qkk8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7991
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 04:53:42AM -0500, Michael S. Tsirkin wrote:
> On Fri, Mar 10, 2023 at 05:45:46PM +0800, Jason Wang wrote:
> > On Fri, Mar 10, 2023 at 4:41 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Feb 20, 2023 at 10:37:18AM +0800, Jason Wang wrote:
> > > > On Fri, Feb 17, 2023 at 8:43 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > > >
> > > > > On Fri, Feb 17, 2023 at 05:12:29AM -0500, Michael S. Tsirkin wrote:
> > > > > > On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
> > > > > > > On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > > > > > > > From: Rong Wang <wangrong68@huawei.com>
> > > > > > > >
> > > > > > > > Once enable iommu domain for one device, the MSI
> > > > > > > > translation tables have to be there for software-managed MSI.
> > > > > > > > Otherwise, platform with software-managed MSI without an
> > > > > > > > irq bypass function, can not get a correct memory write event
> > > > > > > > from pcie, will not get irqs.
> > > > > > > > The solution is to obtain the MSI phy base address from
> > > > > > > > iommu reserved region, and set it to iommu MSI cookie,
> > > > > > > > then translation tables will be created while request irq.
> > > > > > >
> > > > > > > Probably not what anyone wants to hear, but I would prefer we not add
> > > > > > > more uses of this stuff. It looks like we have to get rid of
> > > > > > > iommu_get_msi_cookie() :\
> > > > > > >
> > > > > > > I'd like it if vdpa could move to iommufd not keep copying stuff from
> > > > > > > it..
> > > > > >
> > > > > > Absolutely but when is that happening?
> > > > >
> > > > > Don't know, I think it has to come from the VDPA maintainers, Nicolin
> > > > > made some drafts but wasn't able to get it beyond that.
> > > >
> > > > Cindy (cced) will carry on the work.
> > > >
> > > > Thanks
> > >
> > > Hmm didn't see anything yet. Nanyong Sun maybe you can take a look?
> > 
> > Just to clarify, Cindy will work on the iommufd conversion for
> > vhost-vDPA, the changes are non-trivial and may take time. Before we
> > are able to achieve that,  I think we still need something like this
> > patch to make vDPA work on software managed MSI platforms.
> > 
> > Maybe Nanyong can post a new version that addresses the comment so far?
> > 
> > Thanks
> 
> Maybe but an ack from iommu maintainers will be needed anyway. Let's see
> that version, maybe split the export to a patch by itself to make the
> need for that ack clear.

A patch to export that function is alread posted:

https://lore.kernel.org/linux-iommu/BN9PR11MB52760E9705F2985EACCD5C4A8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com/T/#u

But I do not want VDPA to mis-use it unless it also implements all the
ownership stuff properly.

Jason
