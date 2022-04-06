Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F04F62C6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiDFPLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbiDFPLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:11:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A5922EB3D;
        Wed,  6 Apr 2022 05:11:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAddBGI/bZvKLiGatfWKhfLA9eAm+JA6AeWvjD/t053IJFAVLNxGh1WNeS+JKLGJ1yG+JwSdKbMVOHWBHLef8jfd9HiOUvTquiHAvEkb7MPm5hD04WcnLlmHvJaIm+zq0YL/ztkdMznMQeVOfcwvukWj4fxXsma3kRERd//+dk+u9vkpVUSyG1xc1I0Fb3C727nA//aQwAOnNaNRMknpvYF0q4/ZuQeWPFb9BkODClTM5seNn+vnMu8vGJ+d4c4GrHb6ItqOOOQcZe2bOO9MDIMTmjAduk3L7bQt6l+0NgEh5BwnBXi7La7ho7LP1AQy1ewV74owTdetQdJxdmhQ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maJk1G8B0XfwbBilLG6EGxqigu+g9r6jhgjUxosvpxw=;
 b=ch5G2WUoI96mz/63EfAmySIRO2q+g+KnlEm+A5+wMYP8EBRJrcTpqg9hQoR3bp5Xx8+wNrhLNWdBBqDIq9b4rhffiDD1VKETcTQMpqfCZB2kFc0hVBs/2Tiru3KHJqhhCPleNkQQDgbqOwKqJ4YjRRWNegIkHEvHv3bYx85Yfyx0FAxEB9le0jroiRAJvH0asAcTri+YzGMGZlbMye0y2K/ohJ6aba9hn4EajeU6SaQF586r9iUotnOOtoOjyAzRc4Fh7xJvkOK0l6/HIX/LuttDyxgAz+4xaUOEq1zHTxhpvC6xunZ9aBXKOh34dDAK8uaxT205CHNT1qcPsyFQrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maJk1G8B0XfwbBilLG6EGxqigu+g9r6jhgjUxosvpxw=;
 b=eFQ9gUjBc6K/JV4N/p4+rbqjqlgHj4Uq6GWgX1S5kJplWXLlMcz3tSnLjM4ipAU/bsRRpdhpPmxH1CyfpUUdqreYlTNhdxw/HEy28Hvt3gBFN1GZC5z6xFm4Q2P0NRspEeFCpDjGgeccfmBx6m/H7afk5+2fXtKMv0ElXB9u0BH/8i/RTZ72PTE3k0VcqbzIJKSJs4MGnWKWIOB1mzAQAxa7ekq6CATW3EzGjsw6UOMJO9dkylq+iI7z9jWfVAzWM6B8LMQKjz6ijJVjbr9QL3xUuC/Q76XCrTcGZMFyzMFMDA6hRxBegVSIcJAX1K+ERma1AJiJAtbrnWm/8TMd5A==
Received: from MN2PR12MB3344.namprd12.prod.outlook.com (2603:10b6:208:c5::10)
 by BYAPR12MB3336.namprd12.prod.outlook.com (2603:10b6:a03:d7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 12:07:34 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3344.namprd12.prod.outlook.com (2603:10b6:208:c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 12:07:32 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.021; Wed, 6 Apr 2022
 12:07:32 +0000
Date:   Wed, 6 Apr 2022 09:07:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
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
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220406120730.GA2120790@nvidia.com>
References: <0-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
 <20220406053039.GA10580@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406053039.GA10580@lst.de>
X-ClientProxiedBy: YT3PR01CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ce4e903-65f4-4e65-a5a8-08da17c60766
X-MS-TrafficTypeDiagnostic: MN2PR12MB3344:EE_|BYAPR12MB3336:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB33447FB9A91EA234E565A4E0C2E79@MN2PR12MB3344.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N7JD+kwH+F/mxIav3NbMX6KSHi7GQLHEYcbbzpGCpsfsHzdNTszL0tLM3ZWL3z363bK7MStPf4mxbqE0F04jlx9kWRW37PcBvQR/nlqH4yYI1+CB9m6sfUY7zKWUng0+kU0U46+DfMqhiAHvB0j1o/9aGyj1/PHvEG5GraRhKLHAdOqHI2buea5JJt/CVJ9KpztBFTJmj93lm3P/1q2iImOXE+a1aRH0tFIRB1ac+8KJ3+auX+2PWEOGk5f4E16CyyfBZi7g9ncOLMc/q4ii7SEsz2cD164yDZHN2djBqedNKxpX+3tkpPoGIU6v/BIWBknKqn13quI7tb8gPSgmG3EZJRyLYNBi4uBKn4L3TPUSlKtc0Ytz0D8MpJSTeMn56AfjVFXwNtOClZjV3LSe1Kvmu2WBinAufyvgWEvVxjJvPoHp+DOLSHsMZwE6yirPO/SICikIdyLslKjr5wwwRvLETBFt1z4WnWSsYjdplCBMqzFJ6nqkDyo3kq074Tny4aBvj8lIvw4jt1deu4ILCyplhaYzPjk61OauBdI55HnYvlP/fgazcpvMujeH5IO2Pdy+71EGW/hYO3+v9ecJR6bjV3DmWwFwIQonaX06gO/X/nIyB3h7ZUMkjCSCTULsPEjxXbN6bI+v5GjOyn18vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3344.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(4326008)(66556008)(33656002)(66476007)(316002)(6916009)(54906003)(8676002)(6486002)(38100700002)(36756003)(86362001)(26005)(1076003)(186003)(508600001)(6506007)(6512007)(8936002)(4744005)(2616005)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TlYjIsdBmwLbC0TirZBTT4IXFEbhKW/TsEgQLvqdJHpEFRhET3FVLZ+ezBiu?=
 =?us-ascii?Q?7ECcRvNIlZQ01QEQ5c2smjfCLxBQgHejc38TFDK/41LYl72hLN5DKpBvFwN6?=
 =?us-ascii?Q?F050xtJHfhu4xoDuOgBN/yHqAiMCkNriV1lcQ6NbZdRMjkAI9OpHoiVL7i/E?=
 =?us-ascii?Q?Ou71W6WeogPccoOlIrOCYrjHK6DuX0zY/9agP14hqPnEyk4suftpw44nki4t?=
 =?us-ascii?Q?6Ir4LWsHihECoA5ACg3+5tdVCwEsHbSVLeaXmQcerpuf3k/2dshC/lsliyKT?=
 =?us-ascii?Q?tPEMC7RD+MPx6IggUfY1YOq4d+jaZLyDwzOjZlymPPROwnf3fOh91h7S1M/C?=
 =?us-ascii?Q?prRy2Y2a/Yp6VsLFYZNkihuTI5TyLNPSUyVcjph7zNtXa9lyScqtyQQUiO30?=
 =?us-ascii?Q?gXESldRMiLPQmaEkGG6f6BOM5Bkk4nBZsh9AHDcuTzb3qnnmuPq78rDIOxYu?=
 =?us-ascii?Q?Qo0qwPqjvYvtgwAndnZxV8HyWebMK0ju1G4ntCraoY0TLqHM4vm6INPLNX93?=
 =?us-ascii?Q?srXSnTVH2KzxTOBwrkxvIu4cFT20h6ulMFzCgp5u3Z/lkdyNnXXtL7ZwqqUl?=
 =?us-ascii?Q?zavjQB15ZtLoYV1YFRt+W/IoABup8z7ISvq0NaIxVAso7dO2+4aAZpHizppm?=
 =?us-ascii?Q?1yHh/1Lqff7XkM0vijPCLboZMV/Ibfaf08j/56KnUJDDuL8xM9m5+fJm1y+F?=
 =?us-ascii?Q?qvXxFhGEnweOTrX5u6NafeJg5jRK0ogJB+QaiB72RTD4T5xTYc4zT3fgyXPq?=
 =?us-ascii?Q?vp8mbLEQF4/7JwBP+uHgqkYxGc7v4mrnzeURIzhDKhnUoLYYfbRq3cRnIuj8?=
 =?us-ascii?Q?eogLYILW6M7RmZe6RuhNriAWjJDkpF1qSOS7FMR3NE7R3/3Sw3Ir7WYn/LtM?=
 =?us-ascii?Q?KYYx/30qvURsXLpXmMnuzAY+cYmba2DNjW8VlsrY0v6lbkIoMoURRe8E9tG5?=
 =?us-ascii?Q?ZZ3iEdSCoOcFeLJzmyhJAVWhphAU6cdpIGIrrwEaEsXZcDD3JWzmFqsYpZ8c?=
 =?us-ascii?Q?2bdGjk/0AZHkSeyc/LsjUTRze3gSSHGw6Zsz+bJQUk4nw2x+SEHSPCAdPw52?=
 =?us-ascii?Q?joE3L+DIZ6ElAmp3viy5O/oKXmXIwlfQV7+a3PinhZDSMTxWb24vrDBss2R6?=
 =?us-ascii?Q?r03elvXKkOCuk6mV+wqHVILrJQlF+roRwt8SybKzEk9Ijq3qwQ+iMvMIt7mC?=
 =?us-ascii?Q?YbUErZ6BHN1jou8Q2GUvH4gat+IENTF/Qia/pT0n5drbdJmiUFM+OSKA6WaH?=
 =?us-ascii?Q?7Apprk64vFnMsCqN3Iddze1fHmPM+83MnL6UiwRhTqAY7zBq99uRsBZj/93q?=
 =?us-ascii?Q?1pC4nx4+JqlThj7z5C0EAvRpl5fd7ayTnibe2si+1jFWrsSy21Nv1ORyyQ1x?=
 =?us-ascii?Q?5hDMoCgvh+vWxC+zJAwu2FUdfpwqeBWxwWUKT9z1fc+KP0OA16qQG3yiQWqL?=
 =?us-ascii?Q?DokQw7u+u1yKkmixKVD4kAGzTDkQsvzqbk3sosow3tAAmRKPah5gjEhkEhZW?=
 =?us-ascii?Q?NFNBVDdJ38oQVuFNAldY9KhlGQRl5X0h2zzHMRyJayC1/qi0LhdMJcXTBc5t?=
 =?us-ascii?Q?6mlpu+OZsGPOR8QpYI4XkzET2AfDHUGiZ3YcOsDGSS+htJnREVB855cZ5MNl?=
 =?us-ascii?Q?relNOWPzJBzMABsz2W6c7Wm3C5E9E70Qfumw9I5ufiyMNkFouKwt4WTJ5fmC?=
 =?us-ascii?Q?tGCKkObIe8pGneISmkif8vHyN4uVw3cUaZ4ybkOBYvKi281RizTNMLQDArCi?=
 =?us-ascii?Q?gwQek0fk0A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce4e903-65f4-4e65-a5a8-08da17c60766
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 12:07:32.4132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Lbbj6FnmzszPjVrdqxJmh6hu1XcCqdudqqXpbOy+7hMDO3yZ2aJTx0WOLBfhpWp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3336
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 07:30:39AM +0200, Christoph Hellwig wrote:
> On Tue, Apr 05, 2022 at 01:16:00PM -0300, Jason Gunthorpe wrote:
> > diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> > index 760b254ba42d6b..24d118198ac756 100644
> > +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> > @@ -42,6 +42,7 @@
> >  #include <linux/list.h>
> >  #include <linux/pci.h>
> >  #include <rdma/ib_verbs.h>
> > +#include <linux/dma-map-ops.h>
> >  
> >  #include "usnic_log.h"
> >  #include "usnic_uiom.h"
> > @@ -474,6 +475,12 @@ int usnic_uiom_attach_dev_to_pd(struct usnic_uiom_pd *pd, struct device *dev)
> >  	struct usnic_uiom_dev *uiom_dev;
> >  	int err;
> >  
> > +	if (!dev_is_dma_coherent(dev)) {
> 
> Which part of the comment at the top of dma-map-ops.h is not clear
> enough to you?

Didn't see it

I'll move dev_is_dma_coherent to device.h along with
device_iommu_mapped() and others then

Thanks,
Jason
