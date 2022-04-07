Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3A14F812C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343799AbiDGOCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343812AbiDGOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:02:00 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2066.outbound.protection.outlook.com [40.107.96.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010EB1B8FFF;
        Thu,  7 Apr 2022 06:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXUePVq84lXLB0KcovYjwbbx9VfUca8VqkuEa7MjMsjZSPf2SDtZjwiCs7gMQkuCUB4WkaKlU87dSNbJToKdZxqm1/MJr/FOVCs9EKfRGSoB9BnxouCZn6unSztsLJfCzkNOHHOr7WjLWi0y+d7dcd4XBRnIDUJLFQRykhJIl44mSO61cVWIX9GJjZ0dBonX7X4z3Vo5BMcTNpHYBGWO3wy9ZXrArbKgfv+c4QyZ6X9TYbJlSpZVwiww6HFwIA+MwptOA9ATr0NvQZSoqffwwAbtvbVlIqyMEfr6CGXgXTUUwVS8rY2uy7+yoVUKFQRYslgxk/ZqYV2oG1Ty58HvUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=in8jV7pVxGfiRTQUuSVx2MRbF1gMLzJzmfRqepe4/Aw=;
 b=G0jhtSZmI3q6Kq3HCfdbhtmGsbWG+ob6Ict2ehy/yEz1ATZxN+kkxJSl4Zk7LaAP6SI7Mmvc0KqSfgkK7R5WeF1ovRfJP0KY27+/ImLisuOiFir7IGhlaPj0QPZNXG2nGDHlhPCrZ5mu0BcRcP+KVvKOoVswyadWNP7y3td4AA7cBcpQ1WOafFkXxvdroX9mc7BBSZQnRXTHZ7ur39jXfOz8UyzmPRfWK8eQEfs7PlII4TtWLp6gbRbEVKOFbph5B4vuQEyfDRYqMcUzGbVVKyZyJq7f4xOyl2ASrK7nisFnJlfzZvyMFAnR/CdfLROi8MJcdeOB5UXVDwqxGrYXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=in8jV7pVxGfiRTQUuSVx2MRbF1gMLzJzmfRqepe4/Aw=;
 b=LfJ5B5XT3g8y56k4D4u6fUCBPLD+wko4ambX43R0Cmk5/yI+MbUs0fz2YvhKkEpeWionNyZkhZA4NdiEWcOeZWy+tUHMLXs3XaraNPNk7bFR2ukAE0FruWqt/GJAZdnoZYHiV8UhnHe2WFxWyYpyPt6XwF6qFfZJp2lar9uX2KgNFGVTvIR/QTdVCwl+2EcNWl1KnLEHEbvGc9YEtznU8gA61eN6p0JMQfV+rdguVKDmphTWkricxjzlR276f4jXU143EWaEOu3cPFEPT+yjSTzFG7ZYqlZ0M6PmQBnAJ9Vs+bignu3kyqnC3Y2Gwdb+m+7u1BJ1zzODBvDHr5YktQ==
Received: from MW2PR12MB2490.namprd12.prod.outlook.com (2603:10b6:907:9::17)
 by MN2PR12MB3726.namprd12.prod.outlook.com (2603:10b6:208:168::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 13:59:52 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW2PR12MB2490.namprd12.prod.outlook.com (2603:10b6:907:9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 13:59:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 13:59:49 +0000
Date:   Thu, 7 Apr 2022 10:59:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <20220407135946.GM2120790@nvidia.com>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
 <20220406142432.GF2120790@nvidia.com>
 <20220406151823.GG2120790@nvidia.com>
 <20220406155056.GA30433@lst.de>
 <20220406160623.GI2120790@nvidia.com>
 <20220406161031.GA31790@lst.de>
 <20220406171729.GJ2120790@nvidia.com>
 <BN9PR11MB5276F9CEA2B01B3E75094B6D8CE69@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276F9CEA2B01B3E75094B6D8CE69@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT3PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46f52386-948e-46ac-4d6e-08da189ee16c
X-MS-TrafficTypeDiagnostic: MW2PR12MB2490:EE_|MN2PR12MB3726:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB24903E4DB54039B6C016B0FBC2E69@MW2PR12MB2490.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AcGgbpPPb4VQdY9+X56ucgZRT3qlhz1RXDC9g+OT7jT9NvfafpiUwUxke2bV0J1h/WNqE2vALW6zXm4fd2m25hOCyCUarmirKhsm9+twhmCNwny4FTSvwZlj2/L5800gY4BClRvc/I4CuZ81BowtlsEGlg7vhBnxzWPnPgZWNcPF0+WWxohfExqGmRU49FsWL+1UtEZXFeR3Ly6Sn53WdS24PZaAeOs3szfENKz8Dfgr2eiDQgTg5UFUnMQMCdhXGl1SEpKjda6+7IZj0sBdrS5eUVz59T4KEQVJVBR+F0RJQP7e1rH3zJstKH9SR6RAMphErS1rrF+5Fz85ynGp2GScPT62Hb3agow9qYw8Ty6Oo9ZkXLjioIpcP6nClNgAAJEFhCN0Hq/X6pFsni5zF7r+HFdi4sSz/+vtGXleDc8jjflVSqwouWZ1YtJIhNKsneDtUaUhJwHHAWM6IM4OIF0mkgJNwb51AQ9DXqWABPn5P1JADmQHp53XS21lF+gyy0U2cITwGv/aEvq4M0Y1mKxJe2DTt1IvR0PgsJ/rdHt7a2KZzIOauwtVlMSHjaRbVg85BvlnteCRZavOMpbC6dxKBd7ityBgfwCRb2rAbVkwojBxio7NnbykXIUHKp8zEN199Uwk2DsP5eZR9wOrTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2490.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66556008)(66476007)(66946007)(8676002)(316002)(2616005)(1076003)(33656002)(86362001)(6916009)(54906003)(6486002)(508600001)(6512007)(6666004)(8936002)(38100700002)(7416002)(83380400001)(6506007)(186003)(5660300002)(36756003)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tIqCb+zd4BhlIAuqloY2PSR/knYZKVD6yvtACEl+PtLV7/iMfmjgAK6aLr3m?=
 =?us-ascii?Q?Y+cfbPaxXsXmd+aNLAT08B4l0lddX+OI6ArcSVNRzZMJzJcAaVf3Diz3svCZ?=
 =?us-ascii?Q?qyMIyDiYrERULdm+9ZiPgO4GsDGx4pzlVzTPvZeKXATpGBruYgwkwK9NNNJd?=
 =?us-ascii?Q?25/QfAlpaojhP2fgvmD468e66TF4gu/OBA88F/n21hQ3fBZwt2SniqWgeUBm?=
 =?us-ascii?Q?I7oUhvljPdbfZjalPem0OgIwaPaZqmhsWZ99HNK5lszkXN8GjRZz90on5gzZ?=
 =?us-ascii?Q?4I3KTL7oFec3PI0Y0bL8vDVPVKPNTmSN4vBj05OsScoiSFs3yC49IdGlNJ49?=
 =?us-ascii?Q?CigBkvqrbrr6xQzD/8JtICs92RhIl2SpMWyso/H+xxbRYBuw5i5yfo8q4zp3?=
 =?us-ascii?Q?aueSPDAk6Xt+D51Pf1yx4ByX7pNU0D7l5k1vbga0lJyAN2QzwHry/oAr6l5Q?=
 =?us-ascii?Q?ggzWtbPjTLET2sawf7QrEqDCwa8jh64bWT00whfV8E/9x7LaRWevo4y2Ea7C?=
 =?us-ascii?Q?Pe8GLfE+/oD71gno/lGCahybnpXTDcqw9eRmHc+1FQ7tBH2S9wwZxWM8TE/c?=
 =?us-ascii?Q?7H9dPa7Du/KeWGsmGNYRzYjt/PBvr9zL0k+dk9MgGyWMVnfa/HxSzYjPO8d0?=
 =?us-ascii?Q?Uu1WvvcDLp3TyA698+dpjM2VIpcWSYhzW9noxJ0gcY0DJAphL7zg+RUmRBqW?=
 =?us-ascii?Q?qjdsMFn/o3Qxibveb5shTs5icwDfQmLI9aytVssuI5DDNHKj0oSkCyItZ+0P?=
 =?us-ascii?Q?iVSGsJ7rnFnkExBiJHLtA6HvV87s/QmTmLOhkDMjFtLw+DplprHaHZGRC8ug?=
 =?us-ascii?Q?ZHmwH6GFERNRoYXBZdQtSXLBT0CxCYo2sPK3XE0Vo53sUzQiPJ0EG8hmykyR?=
 =?us-ascii?Q?Sg1ETu2H8auhWoOGmLMJ44UUs1yMtdl+eltWbtp7Jqm/2ibHAogrpq/sEEyF?=
 =?us-ascii?Q?4UNI8sJ90/xUduHH1w3CStmlPLi4Fd0RpX6Wq7XZLkegh3h+Y2zo/4V9my89?=
 =?us-ascii?Q?HIgyhiRVGsaqftysEETfAp00+D9jdKqY5+chcy0SHLtaSOYF7bINWxlR2SXl?=
 =?us-ascii?Q?Ufy1AigwdZ/EuJqvuv6r5cJp2EMhbP6OqGzuX2HI0HWPtSlDraGWmKP/4Whp?=
 =?us-ascii?Q?BNPO6Gh5P7GGBvLz/Kgr/vC4MH+X2uFHJvhsaVgueu+oEVdGLCeHhRTteheh?=
 =?us-ascii?Q?isT1qgvth24NnA166KNCW+NnZGXcCSK+FFOGzi2WlhCkpHWFQ8gsVen17vYc?=
 =?us-ascii?Q?APVnOdvXB1vP9D4JKMHg99LYB7exoPWSb+rs8fzvKLBwkJlOrNZgh0MlCrl4?=
 =?us-ascii?Q?w9RxCaEEL36luoLJQ8CPtdgYLYFqMz+4M6mo+M6xLmVQro/I561Nr7AIX0g4?=
 =?us-ascii?Q?iAwmCm7itx+ciHmusFUm8RpevaZXr/PiRCMEc0q+Qn0hJY3X5BStLP9udDy1?=
 =?us-ascii?Q?enOhwMR6zH4ZPtzVERZmY+n59fHrxIWNCrKVL1Knpu+vqPZxXA6UGWSoVUhn?=
 =?us-ascii?Q?uVffi8MkRUTRvGHeqOnXNzXbZSNGyky1pENZdpwUXQ1W5qfmsYzw/k7mWYr4?=
 =?us-ascii?Q?yYW5JeMbH8C3s4IyeZ0x2BAG9VPeZU9M0kyrCu0ZtDtryA7uBl2+Pwru3Mq/?=
 =?us-ascii?Q?mnav5mBeAlZphmFUdiHDonyStYM9d6VCLltAi+mtxxTu2ced8lY5qCmOfzA6?=
 =?us-ascii?Q?gMk/l7T09yMMnStCAt731xZou3jZzykQtt/3ylNww4oK344O0X5i62K6Zx8n?=
 =?us-ascii?Q?kFRHpWSR8g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f52386-948e-46ac-4d6e-08da189ee16c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 13:59:49.4404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EazJpqGqZDT6pBFzSXo8FVJficwJxgCAKvYB5b5ShR7Trjcw2DSljMgiMCOKwRe9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3726
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

On Thu, Apr 07, 2022 at 07:18:48AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, April 7, 2022 1:17 AM
> > 
> > On Wed, Apr 06, 2022 at 06:10:31PM +0200, Christoph Hellwig wrote:
> > > On Wed, Apr 06, 2022 at 01:06:23PM -0300, Jason Gunthorpe wrote:
> > > > On Wed, Apr 06, 2022 at 05:50:56PM +0200, Christoph Hellwig wrote:
> > > > > On Wed, Apr 06, 2022 at 12:18:23PM -0300, Jason Gunthorpe wrote:
> > > > > > > Oh, I didn't know about device_get_dma_attr()..
> > > > >
> > > > > Which is completely broken for any non-OF, non-ACPI plaform.
> > > >
> > > > I saw that, but I spent some time searching and could not find an
> > > > iommu driver that would load independently of OF or ACPI. ie no IOMMU
> > > > platform drivers are created by board files. Things like Intel/AMD
> > > > discover only from ACPI, etc.
> 
> Intel discovers IOMMUs (and optionally ACPI namespace devices) from
> ACPI, but there is no ACPI description for PCI devices i.e. the current
> logic of device_get_dma_attr() cannot be used on PCI devices. 

Oh? So on x86 acpi_get_dma_attr() returns DEV_DMA_NON_COHERENT or
DEV_DMA_NOT_SUPPORTED?

I think I should give up on this and just redefine the existing iommu
cap flag to IOMMU_CAP_CACHE_SUPPORTED or something.

> > We could alternatively use existing device_get_dma_attr() as a default
> > with an iommu wrapper and push the exception down through the iommu
> > driver and s390 can override it.
> > 
> 
> if going this way probably device_get_dma_attr() should be renamed to
> device_fwnode_get_dma_attr() instead to make it clearer?

I'm looking at the few users:

drivers/ata/ahci_ceva.c
drivers/ata/ahci_qoriq.c
 - These are ARM only drivers. They are trying to copy the dma-coherent
   property from its DT/ACPI definition to internal register settings
   which look like they tune how the AXI bus transactions are created.

   I'm guessing the SATA IP block's AXI interface can be configured to
   generate coherent or non-coherent requests and it has to be set
   in a way that is consistent with the SOC architecture and match
   what the DMA API expects the device will do.

drivers/crypto/ccp/sp-platform.c
 - Only used on ARM64 and also programs a HW register similar to the
   sata drivers. Refuses to work if the FW property is not present.

drivers/net/ethernet/amd/xgbe/xgbe-platform.c
 - Seems to be configuring another ARM AXI block

drivers/gpu/drm/panfrost/panfrost_drv.c
 - Robin's commit comment here is good, and one of the things this
   controls is if the coherent_walk is set for the io-pgtable-arm.c
   code which avoids DMA API calls

drivers/gpu/drm/tegra/uapi.c
 - Returns DRM_TEGRA_CHANNEL_CAP_CACHE_COHERENT to userspace. No idea.

My take is that the drivers using this API are doing it to make sure
their HW blocks are setup in a way that is consistent with the DMA API
they are also using, and run in constrained embedded-style
environments that know the firmware support is present.

So in the end it does not seem suitable right now for linking to
IOMMU_CACHE..

Jason
