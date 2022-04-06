Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38B64F66DC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238803AbiDFRUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238839AbiDFRU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:20:26 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359C249E420;
        Wed,  6 Apr 2022 08:18:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYcvb9TpAc76znz33SjakILmvL9A4ke3mzwUeA6StGRAvsHVsJqpj4kazq5OliQeXghoBSjBGsQYn1+mkSIY/mDHuwwyy+gMtgmI2GMKBcXlWK9e9FWSpIa13cjqx34kjeYZaOOjpElR7yKRYh1drLZnm5YTHwUx+IP0/V9n+d9d4ncsvJiM2n+bBOfTt8zbJrQ4kNItikXOqN7G5dvUM8LzFThD6UWzE6ex/BVeg5563S9JpN8VZf7tj3VeAJurXdMUxcpnyWCkhOxEC/3iVd4xEYGPpfFVLvIpJi8EWLFbMaAwe84YFEXsjAF+oVggaPu4JRMzbxNASew2bFh05Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izr1e7RybFAhSwCNQz+TUFcb75nd0zkcZRCsjicNIgw=;
 b=DU9uuWpK7SyWeNOAnWG7Y3PHJngqgbuvAWkujAIRmyN15Y0tXpVHEezJPlXHJxw1jZZeq9yh1kVQvT3fTzpSTNRYhc6gsfmmpK3b3X8N91zMv89Ri1S+WieyPqgTWanJNuvNFX/NveqH/lPJqnJqdkKFi3Av5TyFZMth0np36rmeEK7fL8XYsjBJVkVx2rMTz/GtzHzF+ogxeK/lt+1riKUbQwGh5QOoWdviLgbxKfGILydPxQYHWXQ2/z6Youqo01YPT6yPPnHSBTMqR0xU626BdVWWXWfV327nuvjhxjFMDfBZu14QVhgM6hWky4+PgRtH3ICcmyT85LzeWy/oXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izr1e7RybFAhSwCNQz+TUFcb75nd0zkcZRCsjicNIgw=;
 b=o51/Y+cTXQS/LrSvHUbZa0Lc12L+aZcCHrQ/NCOTXiad99H5a/bZK4thUVVGePWuWRm1S83ZuAohOh4PrGPyqUrw9wLUztRm1e/3PiBgM/8N3SuJoitGVW8o8qTFXrVpoR7hR79JJd+qPOSqcei7ziqv8ThjwOnBFRZALEBAvWoWF+GenTUp6CbhoojFVQ3uDs670GPv1L+a6WuA8co92fBtM41FZY170S8mNH4KrrzlO7oBG8OpJ70J9BF9lmsZ7c7bN9w/r18xLF9OFisP4BUYj5C+dE3KM6J9gjZiRknzhjEX96L6dY01+UONVZVUebULzTwfRmMJRszAMQ/UJA==
Received: from DM5PR12MB1130.namprd12.prod.outlook.com (2603:10b6:3:75::19) by
 CH2PR12MB4840.namprd12.prod.outlook.com (2603:10b6:610:c::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.25; Wed, 6 Apr 2022 15:18:27 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB1130.namprd12.prod.outlook.com (2603:10b6:3:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 15:18:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 15:18:27 +0000
Date:   Wed, 6 Apr 2022 12:18:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220406151823.GG2120790@nvidia.com>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
 <20220406142432.GF2120790@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406142432.GF2120790@nvidia.com>
X-ClientProxiedBy: BYAPR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:a03:80::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76c989d6-1d35-46de-9a64-08da17e0b293
X-MS-TrafficTypeDiagnostic: DM5PR12MB1130:EE_|CH2PR12MB4840:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11307CE78E936F1B45C731A9C2E79@DM5PR12MB1130.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RXfWFBGUFm7FZ98mExNlgaYp/7jKqHZIN++P9DojmAiyM6shoEsye0W3VDaz/nvcJQyaMUD+TeELJ3Mg+9W5dbjEo24F39p2iMN9WBAXs2I99K2RsFcaeb3YOm08+EbLdhGx5QCax+Kw2fXjlR9anttwImw37ffUiIh6cfL/0eUFkFPwsmg5clYsIp+BuscRQnXPvY61DbtMas++5sTqKgFTMYL6wxDiIjh+g40KsdjYNUBn4c9xnKbO+P07WmElRQYrXVb4PpLboBkS7aRFfosoyPTetDdC8uIBYtnmPnpPlC4d4akilTgt2QYz8EgXf8QIBpkTDSpMzAtxlm1em54/KiTpTX19w/7x7piKgyAdUxNq6X4Fe3+J/zonTzegncizSv4D5nQpk9FTmd4alL8KVrGmBmBhSUdvrLXkB1xEqafEZp0Irr8L5fhiajiMLHDZ2v7NGtbZF5F3BI58Hx6SSrQeo1CSY0h0Au+ek5d0FhKmu6RLF+mo4oOe4jmTIAzW7k3G2v8927onWg/OD8o4GuZPiB4atA7mzT8MjIyg5C/UmQpQI3ai+t0+goDltenZN7nqt0QsnsQXTWmDw/uBaNdJoIvQV1QnC4TLO+GT25j1QGtFKpWBntYH0GxUffvFLQCzRnG5wPeQDm2oTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(6916009)(1076003)(186003)(66946007)(66556008)(26005)(316002)(38100700002)(33656002)(8936002)(2616005)(66476007)(54906003)(5660300002)(8676002)(6486002)(4326008)(6512007)(508600001)(53546011)(6666004)(86362001)(7416002)(6506007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8OQHGTt2kw6m5Q0TztmYVjuYD2JEIZc/L/U0JCwYO3qpx+dtYRRFlrddnRtk?=
 =?us-ascii?Q?6AN3LKRb/T3M0/u/KU8o4b+lCIcwauJnkKHUFnhUKDGs0mHccOxPVyKXEU3G?=
 =?us-ascii?Q?QTfCu3agxKMtg5Q7X5T8k18HVaYzvcbJROfwQlmWQ8HXCWJRHxdnlD1msJtR?=
 =?us-ascii?Q?TfOvXzC4103a7yO4atVxibTpizs5VlY/nxGyq+wcSByPjUwN2Bsz2tEetK52?=
 =?us-ascii?Q?yMTJnutfjNVOG5PJ1jf9tROUgJX5Gmen47ivxRUorTuXK/tcbbgKCDh+AYBB?=
 =?us-ascii?Q?a62O3aW3AsENGxJCqOfaobOdZTw/N6cGR9ACDPnIMq/amJLX+GN98nKpGOAl?=
 =?us-ascii?Q?ypv6vEwzmg0nouCdS5KV3M8QrJskuUAs+AlYafVCoze7aL2f6I4ACE31dUeu?=
 =?us-ascii?Q?LjkKL/oxmEKN9WY0ORy0fwpBp2/gGSPqZTY7vQCbJv3FJKqCpvG4N+4iYRge?=
 =?us-ascii?Q?PUdXufIwEz13L2cYCsIuSzfkNmJG+B+FYP4NA3vHlD5359jmMtGjhGSj16hO?=
 =?us-ascii?Q?rfQKsFKD7u+Z1F1maM5XybO13lyyufTwE4ssi2lDe00SxxHCesmuNQjXSB1l?=
 =?us-ascii?Q?6Y/pJ5y7u1tf00rDzj3oZqwopPO3R4yjlYCT0OSvOyy3MgKuaGgM8sZ+hesX?=
 =?us-ascii?Q?pzlm0in2/2raW1NqkWJkZAHd+HdeF6Qm/SCzHI46aRURjcSbf7pgivjNv4/g?=
 =?us-ascii?Q?SgZKvhIwbELipflA6/wpP2QkISYo2gelXuBegSaBj0bn5rEQ5xufAQlIGGor?=
 =?us-ascii?Q?Co+IY9tfabaLXMlPzm3KFxRv71r3ZOoHqwApObG41a+Clus+LMaVOX+RJ8Fw?=
 =?us-ascii?Q?AKNsPh1PuTHAlyHVjWSjrlL66S3M8bQF0eNQV/iyMhGDvhjLfbvuTbBxdspQ?=
 =?us-ascii?Q?qBARMYPFOTHQePFNseOhZH4eJLKtSDyKGokcWkkHfed/WCmpu0rcwgnNa2sH?=
 =?us-ascii?Q?qqrkylDx8Ph8wBcxdhg0+oBhqNADb7TzlzsSCUCv6FUY7JynMDwXqhGQ2/nz?=
 =?us-ascii?Q?PLlFIq5sEPZCQyDArKQ7qepwrbxUfZtS2A8IHg+9cuN9kJW1phIgx7GNuGkN?=
 =?us-ascii?Q?c8XP3Yy8K+pvcvv9Eu9v/P75b8lTaHsFLYWoAfr8c+Ia24h1s8euZTj83h1A?=
 =?us-ascii?Q?zKZ6k44S2MnldXxLR/Z7Pi0Ob9cRCBX5kwAq9UW3emhCb/hKDQgQwkS5D2X6?=
 =?us-ascii?Q?RlYVBNKP/nHqhQAIFk+w313bmTfWxo0SQNQqTUu2J+NkiVHBbXjXSRfugu8K?=
 =?us-ascii?Q?k9C5CzEsfxVXEatStZuHf2f8sgJm/JO2aJRwoLGuZwvQxJuWdjMOVSOj6NB2?=
 =?us-ascii?Q?Rh8jWuqPsLhNySWAHSa4j+LGCtsJ0JyWaf/BUx4AvToLgh75c7/kmcXQSW3S?=
 =?us-ascii?Q?8xELz7ev9SCesSSzVOPQBm/pk8Yn095FPLIxxZuElVfrcN+tiU+WlZQvljWi?=
 =?us-ascii?Q?yQKpy/quYSxamhN5fkb9gGcIObrCvX92kGMUK5TWEtFM4DGjRF7BeUvhOy3v?=
 =?us-ascii?Q?6ii90IflpkigjQOu2Vice5axRGeG0weAp81/7CgNZ/OH9L9a3TUBqkZAFbUb?=
 =?us-ascii?Q?kONL95PXeKInrTmH5A0ZVNES/8qFOZr2f+cOWXPwdGkz2IGzeicokZvBWv1c?=
 =?us-ascii?Q?bJ7AjEUuofvSLT+K/NngazeSodEcQPdpCHERDV5uoNc1ogWfwgtBewALuwhB?=
 =?us-ascii?Q?eO3tTBgwWXrZ/5zMtdHDbc7qXWaEL8Gjz3cjrnwrbAd8BrQN5jeQ53a+AK/k?=
 =?us-ascii?Q?0bgaXyXTxQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c989d6-1d35-46de-9a64-08da17e0b293
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 15:18:26.9819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sfI33ZNkKwTIySO2OejdY3xTdJF5KxltkhFd+rz3FlzPz3nIzr1r759XNCs6/SMf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4840
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 11:24:32AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 06, 2022 at 02:56:56PM +0100, Robin Murphy wrote:
> > On 2022-04-05 17:16, Jason Gunthorpe wrote:
> > > vdpa and usnic are trying to test if IOMMU_CACHE is supported. The correct
> > > way to do this is via dev_is_dma_coherent()
> > 
> > Not necessarily...
> > 
> > Disregarding the complete disaster of PCIe No Snoop on Arm-Based systems,
> > there's the more interesting effectively-opposite scenario where an SMMU
> > bridges non-coherent devices to a coherent interconnect. It's not something
> > we take advantage of yet in Linux, and it can only be properly described in
> > ACPI, but there do exist situations where IOMMU_CACHE is capable of making
> > the device's traffic snoop, but dev_is_dma_coherent() - and
> > device_get_dma_attr() for external users - would still say non-coherent
> > because they can't assume that the SMMU is enabled and programmed in just
> > the right way.
> 
> Oh, I didn't know about device_get_dma_attr()..
> 
> Considering your future issue, maybe this:
> 
> /*
>  * true if the given domain supports IOMMU_CACHE and when dev is attached to
>  * that domain it will have coherent DMA and require no cache
>  * maintenance when IOMMU_CACHE is used.
>  */
> bool iommu_domain_supports_coherent_dma(struct iommu_domain *domain, struct device *dev)
> {
> 	return device_get_dma_attr(dev) == DEV_DMA_COHERENT;
> }
> 
> ? In future it could become a domain op and the SMMU driver could
> figure out the situation you described?

I also spent some time looking at something like this:

struct iommu_domain *iommu_domain_alloc_coherent(struct device *device)
{
	if (device_get_dma_attr(device) == DEV_DMA_COHERENT)
		return NULL;
	return __iommu_domain_alloc(device->bus, IOMMU_DOMAIN_UNMANAGED);
}
EXPORT_SYMBOL_GPL(iommu_domain_alloc_coherent);

Which could evolve into to passing the flag down to the iommu driver
and then it could ensure SMMU is "programmed in just the right way"
or fail?

Could also go like this:

#define IOMMU_DOMAIN_FLAG_COHERENT 1
struct iommu_domain *iommu_device_alloc_domain(struct device *device,
                                               unsigned int flags)

A new alloc option is not so easy to fit VFIO into right now though.

Advices?

Thanks,
Jason
