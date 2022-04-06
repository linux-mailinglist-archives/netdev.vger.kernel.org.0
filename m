Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C334F6657
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238562AbiDFRA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiDFRAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:00:49 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2050.outbound.protection.outlook.com [40.107.212.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767DA46E606;
        Wed,  6 Apr 2022 07:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPR1uDKmgNXOHJiYi/X0WY+KGSpItskwKY+x+iJfqw/4eNrUCAjgjrQIgdKZc7HKcYrRIqfWHFngZruQst4FKWuKTmsIJJZ9JTEmmM45LL02Ko6h6XCpSfOzcQxZFjF8LOp3jV4VFIHn+qh6SkM01p5HfMrU7Mz9XN+dKqGo53PiZEyUBeGP0i7P9VJ69UfZouW3qFxxtKoTsWRNLfd2l0Rv/XSnV9i3P3ykh4dVxQObQHWSUPLlu9YLCpyFtXFqL5rlAG3axksNE2BqQRIoOo8GgPraKafVXwazeh7H86GvR5omtf+HLgM3/FCT4CSSxCo4b/t94xCdk7Vv+agYWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uYgX1e2UDd/ai7mblSLjuOtLmcj0q3PDcURNfc0AR8=;
 b=abgZWDRNWEvadotFNh2t6vzrArNqc4bV/lTwWRR5GilcLjTnr+1EG5orGPWPIdv7i1Qod2kvbfq4fUmFmn4m0kCpKp4Ik8VCIlYkjlvHwQj1CQy1aGe5n6EcTPU1mduwUZwJvtXqRYUq1fvqLPt7aoJcsgZOiZ6f8u5UD4Pk3IPBmguKP/bm3bWVzn4qoR5dB1VIMc84lOuiTjE8wEFxN4ugvF7WVzR/G5eLMdIZb6ZVW455nQ1LbTZ+waDA368mO+0PwSkHMjx0DQnb0TKr6bsID+qFjr0M3M64DiTX9G9fSmkRkbZhyROuKNIuO9jsA3vuO4JK0YysewPRW49PNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uYgX1e2UDd/ai7mblSLjuOtLmcj0q3PDcURNfc0AR8=;
 b=naLCcToCto6w/Pgu7y6+Ye2fEe7MQPVHIH0wA4pHwZ4DEqyz0XOX8cSO+Owsl9IQ6l9rZZ6MP4XaGKH5EgyX61xo+kW72B/MGG53GVOx68thK7NrGlf+F4Z8rY7BjoZoBr1ASYPYs5DM74Oby8cmhfImFFBVOUUkZnElToNGzaOc99dJW5tItiDLFiKHLL0anXalP/fIXJs+YsVp9W43vFpZM89k54EHo2xs8E2iMOnacp6REMAAIgp0IGJ4TgWQUO+uhj3hmt+jydVpdclnRjf2DG7hDhcXAg4WntgA43l4FxR0k0B6kJP1hCktFNbSu6qRlNIAACwEOBkcWtvgjw==
Received: from BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20)
 by BYAPR12MB4712.namprd12.prod.outlook.com (2603:10b6:a03:9d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 14:24:36 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3238.namprd12.prod.outlook.com (2603:10b6:a03:13b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 14:24:34 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 14:24:34 +0000
Date:   Wed, 6 Apr 2022 11:24:32 -0300
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
Message-ID: <20220406142432.GF2120790@nvidia.com>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
X-ClientProxiedBy: YT1PR01CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d8ec298-b8a2-45ff-7223-08da17d92c48
X-MS-TrafficTypeDiagnostic: BYAPR12MB3238:EE_|BYAPR12MB4712:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB323843DA0EE80BA62C77C348C2E79@BYAPR12MB3238.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gh+tQlZPlXxnEhaCzL0nbAT5mjIvaVe2/T2LCTIdrNJGlTgI++RGa/sYfQWuGy+0q7R++3Ew1e6UVpVD/jaowunpmt1EymIkASAbW+c0WxHfWLvQZNv18NqtLQ/TI81/OYKLV0WBBQn/cTDmE4M9yPSzBvPx7MUOyrNJfO0oOH9DHkLJAJoC9K3DgJ2kwuWng6NC43doPd07PduBFTwh/DPgH5t9UtHJBJEAU2qLwrHlJfDqfU5mddf5EfF2Qf0IEg9HAwAGHAF5vZoJGOSex4SaDKeQYW6ziaqOoBCUqXkSbfmA0A8er1xAVtcJZKHpFDrhCrKydMpWWHBhhrWz+TQQzmMHuDjJL6nzqwZPjUkB18D0wk5irDF867jCX3o5BcdIQ9aFiY5XCbuPgcvplBlFyUblHHUb+oORGoVXtunTQRy/kx9dG9AXvBaTq/eAIGRIpTMtJJ0d2gTBZnUFwnLQrhmKXyk66mcJ/kxALXZyzDQ5rMQVPh63tkxPzIZE2vgBLvT4srozqZI76UPNZjA7Rs2+JvqeMZlRKbiU1SlcSGhScM8LUIXD4R5xdxjErGFCQGmUdO1dgp2xsWhtmtfqjrfU7W0imj8ixXYcepk414abfPWTbypRgmjjcrBKdiNbDFr9yKZIAMUnTKnJ1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3238.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(8936002)(5660300002)(2906002)(4326008)(8676002)(38100700002)(66476007)(33656002)(86362001)(36756003)(6486002)(508600001)(66556008)(66946007)(6916009)(54906003)(316002)(1076003)(2616005)(6506007)(53546011)(186003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j1Rdld5Fo38ZTjZ38MIPGAsmMA5NX1SD3+L7zg2BUvUp8zp8gn1uG7GZ7Cqf?=
 =?us-ascii?Q?p1p8L1ganek/N/PF3U+4T08mh+V53cV06IHnpXaOs7iFCZ/Qdg2ejWQ+E0ir?=
 =?us-ascii?Q?A01VuBe9zxrWWChmQxx4RxId1+sNfaLbfFeNR6EcMyT+y4I5civOYXSkb2Av?=
 =?us-ascii?Q?VEXAh+wNXv8nwUCeE2odpKNg8cxusNS38ob8bnxk6DpMWwDVk0EqiGfvu0sE?=
 =?us-ascii?Q?swYmaoClsa2c3+HF2Nc/BkNVYWXIm6uRhRU8IG7xwj2nPbCQzx895CXMfMOs?=
 =?us-ascii?Q?2gyL+Wjlm+KYy9lejPTJscm4QdaaJXP1yO7+Ig9zwJkXJHXU3yWUmGdQcRsM?=
 =?us-ascii?Q?bwEqrqEl8XAadOWnT52FDuKs3WJ5HkSVNoF9e9yHw9bxpZjM64FWTTXxuczq?=
 =?us-ascii?Q?kZj3tOLADpCsP0oZgBz9+bzj8cDQn8cqgfFVkgV+Ez7B1Fmy5lqMnRpbqHsC?=
 =?us-ascii?Q?6HVdOw1Cvn5/6aybMEkgqVBqwOrrJMcYD4jcVPEdpRolmd2K7vDTC1zYTdPa?=
 =?us-ascii?Q?trtd9g1v+jxw62zYgdyKPpUkiXQgkL7qHqzhwLI9dPcG7grA/jUV/l6xQYS/?=
 =?us-ascii?Q?m45VA5OebJeGNapmv4FJ4F+fDQEWP1iQr3nN6czi9JyEnWKaE5JtsW1wiKmB?=
 =?us-ascii?Q?RkHzLAFKJywQnDLI8rJUWl3LjpNpz6/mc3pdItQ8a6b23MUhx2h99W7WMlmZ?=
 =?us-ascii?Q?ofjCUs2j99hZTvPiiqPFFm5UQUo5mGQ6X8Ui59ENeJoRLhKk/Sb93cd//+Yy?=
 =?us-ascii?Q?3K5IJK8+cQQ+P3uoRa8vkTp0eivTo6/WeRxLZil5oCQMxIUdu0L+qZ4RFsJi?=
 =?us-ascii?Q?rp5RbYeNZ0IDvPLcHe9IBw5sTdANsbf2kj4+BBLrqy/5Ke78bwHH/VBWjpL4?=
 =?us-ascii?Q?BtZHm5k/sVtzqGgCCZaCS4CukhjWX5lrxi9QDlythZz/javtfMt5MXBu2XBM?=
 =?us-ascii?Q?Tr1S2wPCaev90Q/SfRQjnvsPa4pk1z8IQHrQAQZ9aLiCBeyolZjBBbJzK9YD?=
 =?us-ascii?Q?y+/KPscj829uDe2go1OXAs+B42V5iDaebBeGDjoBsuzJML+4drpBwWaH7jqt?=
 =?us-ascii?Q?mEBF2Bykqa6gRuoTNlS/f6FoQpF0e1xiZe9DiRmdtf9Vha7kQ55HtpfVRzBL?=
 =?us-ascii?Q?oy+LM5GKOV1OI4r9VqLSVPsbGc9uMufyQ89qSn/z0npzPqmn/CPD+9DEanSp?=
 =?us-ascii?Q?+czvtnsa/2ZaWs39mWjTi0rn0nTfvN0N9MKFZH2l04XkVtS08IJgoOGMDD9y?=
 =?us-ascii?Q?xbNnXlSNWUzVhFfTvZsgWEYCLUmTho5knPA9POPAQfTWbwao/BIsMsGjvYbe?=
 =?us-ascii?Q?siozhacB1VGR3473pHktK07LQH915ou6lAa+P3fpnABYNxdex082vKOU7Dg3?=
 =?us-ascii?Q?/9j2IVvYGL0CzYAY8S2QLQC0KZpUAIiLY2eOipwhYGZjO4tlx3rvopo5rlFX?=
 =?us-ascii?Q?XFLC7QiPAqMwiPYm/S2jeKNNWtBrAoo6hoderQALU6DYAp8YtT4Zo0yS6mEL?=
 =?us-ascii?Q?Imv9KbJfHBj21ol8woLA1nBtwzhO2RUXvBL2rkeIE9c2Jv1Xy24Qu6pagkn6?=
 =?us-ascii?Q?4aCL0GdlpPs8Hc0syEJIChGyQ2H+t6KAzNbdhGIYZT4vwfV2wX7eWZ+1HjK0?=
 =?us-ascii?Q?jfzIypDQEIAImv08bfBZjEMZzQKY5wxQGx9HZeGeFlTPtDLPMZF3RdQ8svmF?=
 =?us-ascii?Q?SGxg9vG6mGsnxmqKDZ3WOz0LjqwmeyztO3JmebxMWL6u+EFE9TvuYKImEhhG?=
 =?us-ascii?Q?7joljw21kA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8ec298-b8a2-45ff-7223-08da17d92c48
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 14:24:34.5883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: to0YNbI5NCs1iQcSoMToWSaVLgDn9KA2Utie6CPdXXB5PeX8CcZNQ+XkDmn9wvMQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4712
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 02:56:56PM +0100, Robin Murphy wrote:
> On 2022-04-05 17:16, Jason Gunthorpe wrote:
> > vdpa and usnic are trying to test if IOMMU_CACHE is supported. The correct
> > way to do this is via dev_is_dma_coherent()
> 
> Not necessarily...
> 
> Disregarding the complete disaster of PCIe No Snoop on Arm-Based systems,
> there's the more interesting effectively-opposite scenario where an SMMU
> bridges non-coherent devices to a coherent interconnect. It's not something
> we take advantage of yet in Linux, and it can only be properly described in
> ACPI, but there do exist situations where IOMMU_CACHE is capable of making
> the device's traffic snoop, but dev_is_dma_coherent() - and
> device_get_dma_attr() for external users - would still say non-coherent
> because they can't assume that the SMMU is enabled and programmed in just
> the right way.

Oh, I didn't know about device_get_dma_attr()..

Considering your future issue, maybe this:

/*
 * true if the given domain supports IOMMU_CACHE and when dev is attached to
 * that domain it will have coherent DMA and require no cache
 * maintenance when IOMMU_CACHE is used.
 */
bool iommu_domain_supports_coherent_dma(struct iommu_domain *domain, struct device *dev)
{
	return device_get_dma_attr(dev) == DEV_DMA_COHERENT;
}

? In future it could become a domain op and the SMMU driver could
figure out the situation you described?

Jason
