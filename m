Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AED4D69ABBD
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBQMnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBQMnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:43:35 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49673D0BE;
        Fri, 17 Feb 2023 04:43:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKVSsWMicc2WwvPxdC8OPry2/Wn5oGIab1Yf23FjcX+Ip141L/RGbsUQ2Mh6jV2os3E5xJ8go3u1xEseM5Hmlrdhr4eJzHq+Em2QqFC2Tm9+Ei5XOwF0kW0mbM3uqM2jOVvsTnbud9mxDQDMR5r4SMDCn0XdHmOR94w79vKHiTZ8/DxvKxdABKePrMvidiMvm4s7AICLGxox/QykrriWbYS9GDBup+kpa8FfAZzI2mNHuuSJ3xxlH6UkfK0OOW0YzravQ4pKOuznOQxjpNIdegLN9C6v7ocfintcq2eGgwgu+Qe8C5wZJAsfIscUskd4FS61HTronQU8zmFlEPZaqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MuG3aX3TMq2RmxOAy+VfL5J2Fb7NQmKAZG86l2joeVk=;
 b=VPJHLIiQSiT7n9cJEo3Oo9s8vSoWO43OS8um6aMNrqOWT9upXAsg0g/dj0kQk1RKVvDe7XUoX36r65v4Dcd8TzYpQN4F0taZk8un68nJD6bGu+xROcDD9aSkS6vE32awKKuGJjPe//GydpJGSIYOZSR27rlUIJv6g8iXtHhS7wMgBaBPVJvNIo+PT3SCvIvgs2tqZoz6j63NaiGxTYj6YJi2gCGW5eMc4koF+RR6e1SHFJWtc7KzBtluBHXO9RwhX06IodchxZIO4VAq5ydmAc6sZHNLO4mEYEo9B9qMIs/dOi4oCBoHPJCL3TFvm1Kbidiaj1WYPettLQeCTfEiTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MuG3aX3TMq2RmxOAy+VfL5J2Fb7NQmKAZG86l2joeVk=;
 b=lSl+FcULk151sgBVdJMDSXAf0KqT/9frOhdxDmNodwXKeqJOw5WOj9POL35wDuYDbbsW7Bmvz9/1tqqu2RHN5CNYfvojKqZ6KbI+uBIuo6iJKt84/T58+vy0wg48nEDMnLwY2rbzUgKIDdkDGNG8f1nHF1VmNfcHlR2ru2YzZHkFQlQb1CMeKQjAJPxIeVu9UlNomVHdjP12e23ihh1MFRmMKcvhaqdGUkF8VFxnv07UbiNob0hluos6VxVAcD37QtCTGh2NX3uZKfXddiRie3b0aTMIflHDhp3T1y5J7WFUh0l32anvCj1PklHwQ+OCDCFS8J7v3F0qPgbmkG8NUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8366.namprd12.prod.outlook.com (2603:10b6:8:f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Fri, 17 Feb
 2023 12:43:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 12:43:32 +0000
Date:   Fri, 17 Feb 2023 08:43:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, jasowang@redhat.com,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, wangrong68@huawei.com
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <Y+92c9us3HVjO2Zq@nvidia.com>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
 <20230217051158-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217051158-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BLAP220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB8366:EE_
X-MS-Office365-Filtering-Correlation-Id: b3d88489-8cd0-47aa-c82c-08db10e49411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MXVxrm0Bbx125tvk0uv5aG59Z12A2TAjUB/FDmKk9pTietr/YwWJCP3Cd7NlLOMkD578NAetVgUtTTNuXU1hUFj9VdE+7lft1DBZ9/02NUN6RvCFlf4WZyT/dZ2MZV9OuOsXJxyi7A9eAqQRR6G9IgQ3wHIUX+Riguz75lGrKO6qBdXX2LcNCAHDb2hej2Pl8RoVWZ7v4YQdFD08M6yja5QtTayBArsE6AyuJx8hWGoyBH7qchlha/iMXQ2h0dqFMEx5QwlK0qELOd+rChkEUAV16KRXuof5hAdsnrYMEnVkJQfn5any4wWn1Yv0CNE1liCnSqfRHlq5rUw5yn3M2TSTKjEhWBvaAlnyqAi+1lqUP9CDYn6xSz+mn4kKccP5hiAINauJQV8SrT1pJZ5yFuekSkuk5LbiS0wo+/ZDHawnb8Z+QZr/rcyQW5MbN7qFLAvJ6K8g2qApJ6mMk4kC4YKOF1Rt8ME+nNywTvx3qt4bAiOGWwexchBRiTBrq//1afkzhWf/Bmnf22C4TnIu2Ri4+dWbWwJNol5kLCsSShor8wO9te+UwmnZ6HzBFxdoKcTmr4JCVVF57uRnYBoZ+vU2JDGjyqdKYm6TURijb7OUCVn5N2vW8s0lbXFtRIZbx7D6kiTmfvfTTc7PRCx/jRuH5YcquyTaUeX3AdO0DpRoRePRW4Hfv6giHVvW7LY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199018)(36756003)(83380400001)(66946007)(66556008)(6916009)(66476007)(8676002)(4326008)(38100700002)(6506007)(316002)(41300700001)(6512007)(6486002)(2616005)(186003)(26005)(7416002)(478600001)(86362001)(5660300002)(8936002)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dPXUrjZLB4KQhBgy0hsoSdtRTWlePXaC6Kv1wShq47Xr9uIyNeIBFXoQAMPM?=
 =?us-ascii?Q?QCP+iFQWzVm45Fo+4YltJ/WhRHPqrVzjwXuiowpG+8FH2dV9lx4Ukn4+UD4w?=
 =?us-ascii?Q?4M9lEgX6wuohQbG4AfcsjOJRnitJCL0jK9bU0ixItPp7G6eWVcSzL5BBjzwi?=
 =?us-ascii?Q?VI9my27xSBPeLPooCifF0qCPHoMhK395VH03x5ezC5iWRh7AsivPWjan+sS6?=
 =?us-ascii?Q?MF6Gell5GoRsS8sisgPXbotDJOcCCEnATnO0aUkOUU+hztqJiuxe66k928ku?=
 =?us-ascii?Q?i3vO53AfBgKMSlbGpjr/LGgYj6MtbD3Dix6MKX7d09uARcLHZ9nCehpCPT8E?=
 =?us-ascii?Q?fkJDVGgp54vIMvBzTXi9A9d4R6dZBt77Fpp+sHBsdXQm3Bagy1HdmihlVpSh?=
 =?us-ascii?Q?PSVip8Twd4Sn88Ss5qeK7Tz8oh00fS0+2KlAExEHs6kSCxu1FR7MubMxHd4e?=
 =?us-ascii?Q?bgM/48WvCynKFMfyuxsF9Dwbx3BUVeLKLfwo/vMx82MyRs7MLJLNuiJxNDYf?=
 =?us-ascii?Q?u8UAeNI9bRYu6KZx6+CsKt4MaklJANMnBRQkYsZ/tY7dIJYYWdzOh5fw8ykM?=
 =?us-ascii?Q?mJDNRf7sSbzNFfsw8n+ZPkCo1PGF0JOUPZyh/LL9NYFVpwiNHaUqj1sy6xjx?=
 =?us-ascii?Q?mS0b+k3D4RkrPTSPmTvK7/uZv+NMQ5HMCU7tSed4qlJ9IC9unMZDu7jOzK11?=
 =?us-ascii?Q?fkSvoYiWpwNHtMepAlSA5Vn9D/H3mWD6iu67Qgjc2ncA+svbZQuqIyg/QlWr?=
 =?us-ascii?Q?6UtLEL1hWITh3cdBWg4uco/dz9IUarkHq3f4bP5Hhu3NUf9w3yPONcTwKXXx?=
 =?us-ascii?Q?NOp9Hxlw8FEuW9xchz9fIjCJR2fAGUZ2fS8grFjRzqiLXVv7mDTEGV60Ftw0?=
 =?us-ascii?Q?yllaK1NavyItiNrAVi+R6SUZL+jI+5885dmHBg9KqxALByH+RodZ0oJsPntG?=
 =?us-ascii?Q?E/gtDdhBDRjhLMn4Sm50RGryLFLNkD05iEOvT5aGf5m1Rv5S70KBrsXnNXP5?=
 =?us-ascii?Q?janB13p88MVONQYXZnb5JK9q4sjNgS+HSlTYZLAKZog91r6WaDiRGovqobvO?=
 =?us-ascii?Q?1zFsokuOH5SAb17HblatCU3DyKVjI3Eye1qko9lwaFXY+DW8M9my4bdRCaNI?=
 =?us-ascii?Q?kpzCYs2PV721SNQMPITZkWskwVsYfbwCUMg06lzyzZA2PCGI0A2AJOElwtQF?=
 =?us-ascii?Q?wL4lDGi+OF9SZ+nSzz9ooKBeUMJdgT+JyuGIY6xrhfybOQa4wOrUN3wNwedD?=
 =?us-ascii?Q?Pgz19SXZ98RXVAxP3Bnz4pMdESqESdxnCvPyDagUvHxgZZB1UKNk7x9PBpXu?=
 =?us-ascii?Q?GpfkvZAnRuRcyhv+qtMv1NDAfiaehBqJlXg4C0Wt8E0epJq5GAO26+Mqq1Xf?=
 =?us-ascii?Q?/lCTEoth/pPBfn6no2MHeeIyEqpHXHbGzEn5moZZycx7yP1/X/QB/UZPphGr?=
 =?us-ascii?Q?WJS5njt36tatur4L3M7xEEeQYqTuHWmqQ82LWhcOVQAft7h5CWhxr88qtwQv?=
 =?us-ascii?Q?ByX1GKkdTxWrubjGq09U+TEsDivG/LmeM3giq5O6lIk7YLT8sraeetpf2F0i?=
 =?us-ascii?Q?UWIP2uBJgmIDvAUgUGhZ4IJt2rStd0+wm/gbIKj9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d88489-8cd0-47aa-c82c-08db10e49411
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 12:43:32.7244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 16UN5vRPfBtf521GLspuPmtwFGkIjTBtD+sinKe6vfgqYmTIsMrC9HyVH1eEe6Xa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8366
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 05:12:29AM -0500, Michael S. Tsirkin wrote:
> On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
> > On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > > From: Rong Wang <wangrong68@huawei.com>
> > > 
> > > Once enable iommu domain for one device, the MSI
> > > translation tables have to be there for software-managed MSI.
> > > Otherwise, platform with software-managed MSI without an
> > > irq bypass function, can not get a correct memory write event
> > > from pcie, will not get irqs.
> > > The solution is to obtain the MSI phy base address from
> > > iommu reserved region, and set it to iommu MSI cookie,
> > > then translation tables will be created while request irq.
> > 
> > Probably not what anyone wants to hear, but I would prefer we not add
> > more uses of this stuff. It looks like we have to get rid of
> > iommu_get_msi_cookie() :\
> > 
> > I'd like it if vdpa could move to iommufd not keep copying stuff from
> > it..
> 
> Absolutely but when is that happening?

Don't know, I think it has to come from the VDPA maintainers, Nicolin
made some drafts but wasn't able to get it beyond that.

Please have people who need more iommu platform enablement to pick it
up instead of merging hacks like this..

We are very close to having nested translation on ARM so anyone who is
serious about VDPA on ARM is going to need iommufd anyhow.

Jason
