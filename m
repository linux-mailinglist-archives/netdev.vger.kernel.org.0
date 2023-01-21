Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85A8676700
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 16:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjAUPDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 10:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjAUPDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 10:03:16 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C54C1E2BF;
        Sat, 21 Jan 2023 07:03:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=da1GLpMN+46623RGkXrjz+yydCdg6wQYCSYysaqdxIXihRB69lZ0Lk1uO2+E/zqcSAhmVsFTZGegx3PWyP4OoTNVLLOm72qvWtOIirKnWecIZ71QK2uO2w2GOH9lLGkyPEzhg1tSPsoduaRKgWd+MDd2lhOftGH95AttK4fkCimS+1Dp7uRbtU62/czuVQxXxXuNNChFz7BAaD1viKTKBoIF/3fTyXzBeEMgJegYme9ENwimwpIp3Svk3sQaZK9MmlYAHq+Y0ZlqeC7w2ADZO192A14jMAy4m5e8G+RoNGFBQTq1VmQUWYHKDuLeZAwG9dXqvfo8zbpQ+kgshRp/5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y5bkh5dkw3jlgawWlJroImGy5kmIR021Jist+9JrbGo=;
 b=ivFIrrVt6dbyrxwO/YG3jPrxWRrbG5p128Ft+aVBofK2X/z1/y7S2kCauDMog3DAGvJoIkwudJmrWlR7cIGrgd3sTw7ID8EZYj/3IBJduidc73TwOL3XHnVZxJSEKD2Vtn1S3/5AtBFsQIg9WN0jD3CQXxCCDJmwtYkURdpxPT0G9tbUkbDrxLiKNmH23pC4dVHphJnW3ol2HalDWH8p+ugAr5Is1I5DBUjlpms0KLwQiZqPot57kyff6McRjGCFMNGSmeVb2r1TuIVRGkDHJrt/kNej12VIffv/fOhXfsC1cdhmbmpAmewLbzvQxXYoa3TQ//QTmOTV/8H1hDQJfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5bkh5dkw3jlgawWlJroImGy5kmIR021Jist+9JrbGo=;
 b=WlWaU14NPkou5u/h/G8mNCzCiNN23WWd0/cQxRfqIwGTK81QH635qtVBhSThWThhf/VZbxqgksIGLuzSBHIX7B8XTuoe2zvrarYi6FsklHtm/jW9fbSPyYZmloYnlW0q4gG/1DSKS78Q2uSgYFEkxDgAmuxmZSg8JIQHVLFOyXfW+xc2qSfa6fYgjvBB7lMGhY540XscJfnFN+x/UF3y8Ui5UuugNoOw0CHfmWIEnqYBpYL1xY0+edmlBxCwRKgxzhArCqS+kIUrfW12VaMX7rjmThoKlip+TLjgz1/JT06qlp2oZS6l1a1BwjIOaHDyMdgdLyj3sD7dni9VYRXF4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Sat, 21 Jan
 2023 15:03:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Sat, 21 Jan 2023
 15:03:06 +0000
Date:   Sat, 21 Jan 2023 11:03:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, linux-rdma@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <Y8v+qVZ8OmodOCQ9@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: MN2PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:208:fc::40) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: d602da7c-5402-4b94-bfa4-08dafbc09a19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CRMnbebuCwY2XUAUG4zSwIe1enDOU/bfPiLcADCdQWxpsMCkdoJxHYf+cjIoUZr0NB9zAFxBWbxtCvRqATlQWLYjPoQbGR8HtbMM3sCogJQZGMHYmL6H8sT8yeRg/U4YDYLGC43S75B5xNvJvace83NECE8PxAVPWQTh66/lCHMId+12NsKq6ajdT6rZVUPnh0dAhynnwoyHpI8WlD9qNjK9z9vDSJz2t1cLg4zeTdAFmzzEhw3GjPPvBY9/hZThbMe//HOTRrpyBpJnewnFpcN1/4iwos+01yYdpe348F/aDtA0x1xNlUAtoR5LJt1/9xgC3tYUH+HK3ll9/BCI8b4KbG47SVArAXz4bQrj9/hMW4weqCmZMxoz6FtIFXtY9VOqoFiEU4/4zN1zLyo7WYCWr+dyduK4bW3EK8a2dR5SXWckscDqA1/r83Zb5RlY2yfUDTmzsPNYjFTeqABjjZqqUKeAWHgHpbWdBhO9u+1u/DpF26/zzKGpzUOQbT42SNynbGmzgp10wEvDuoOex5gc6+4ZBx7k5zASKCgX05U5vmq1huJm22wAMdZwJ5Dm2eSegKXO7P/ishk6d2LScQLI0X8jSEiV57uO2KqFRYECJcOj20aKI3PptY2nldJYVyh/pHQFWjeVm8f2C98qx3GyHxMlkKjiD0TOmEejlk6f/U12cIzVM1mo7u4AWftwlhdEaPVG+jHkNTqsSc2CeT69J1112T4exZLRVgIfpYMxlAwJEQKbbJTEmq/V7MnJZ3jvlTEfGNnscM9llCIzm5dWWJjLx0L9dLXkAN5TTKUw2hcPyVvJrhyire921RQO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199015)(2616005)(36756003)(6512007)(6486002)(966005)(478600001)(26005)(186003)(5660300002)(7416002)(66476007)(6506007)(41300700001)(2906002)(8936002)(54906003)(4326008)(316002)(66946007)(8676002)(66556008)(86362001)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F3BtidbfOpqNrP0AWXf8iW9XqvsJOhqseIZ2Oll+rGUOB/hTWmy3UCsqFod7?=
 =?us-ascii?Q?EHZJ48jGqvFDAuVpNk3DepjhbbhpO1E0BMOBmAfJ4rKCqKGwS2KpsrM9LWFR?=
 =?us-ascii?Q?7eJxJthEf/0oBMBDcvB3Jt8cnGJ7A586GXqzmVnJNd6DzfGCgB1d79l6RcS8?=
 =?us-ascii?Q?hCRwH6IaEUT2KnG8Ds7MBt0UEpJ2jYR7MtjV33rMMXx2AmfyYIvKsWDfzRUe?=
 =?us-ascii?Q?ZpHG62etWXCkt+DvDL7X4tDN/YG9gxM/xej6jWOQeXAX78AfXpKo0tSw9i1V?=
 =?us-ascii?Q?bflChshYSj51Y69JQBNf2y2XYY+VSBRPSrQFfwgWBPi2St2owQOjbTDYVfFv?=
 =?us-ascii?Q?Z8RH+DpQoG9IpJ7RQ0Ra1Xs2NWuODxG0RknEASsZahiaRgzmLJVqIBVRNBOg?=
 =?us-ascii?Q?eYULA7UsBkIaZiM/L7HahjyEL5fTXiRkqbA5y+dWwnFW/YvIauyIBc0pZqU4?=
 =?us-ascii?Q?5LoKOMezuI6aVGejSzTfIN/vZG4lg4w082yiC53xU4Jq5XG0ka9OkpE94Uc2?=
 =?us-ascii?Q?e9Dcte51ghX0eXrxLMrlcyOX/SkFHxAaxIV8srbzj56mA8tM0zCACEBFoy2G?=
 =?us-ascii?Q?LSWLWCPj4B+KdOquV84fsUN3l9UpNXFAjuqApmyTofj1d6PTLqia+phcgrOx?=
 =?us-ascii?Q?2DyS8lXJEoykDS4JCNH42JwSfCnOOALsNjcFOk1PY6J8nPnLzH7Ct13SDcI3?=
 =?us-ascii?Q?/j5DvU+OlUxeZYitNQN9HH9TWwzDKx0HFfIykfSAw25WAq/PnnF3sqJDJnaz?=
 =?us-ascii?Q?osvsWOEJ2zQcS6bb4dDIsNPBRnENan6Zp/XwTNOH0mnPC6GiWlMatL8TtmBZ?=
 =?us-ascii?Q?qVw3R+jjsbumSmMWEzkT0q1fKGwaV+5GQbVLF/yCQHhFAU3m/wKRwwk3cWtp?=
 =?us-ascii?Q?CQ1QmGSKvKwkYF0ANWtCGKsU1xr3TuAyQFpHPBBrJwVMsTD+CXmyXZFBIRUN?=
 =?us-ascii?Q?gc36PyLroat6wu2kmYVAvkRu484uJOXLT5uGjWXaNmNfFia1RSzHcyD0oXKT?=
 =?us-ascii?Q?FzzS0D0bMDG4Zo/DaWXDx1tixhc2iz53HaKOVZuRh+BE82yGW05HhJ2BGONG?=
 =?us-ascii?Q?6VEQKTSz6akReE6feMADA0IxXewPkJZncMebPBJWvQpnMpgzdaYnZHeNyxPQ?=
 =?us-ascii?Q?gjDqWDs1xtnqJW6m8IXXQOizVpC6e1EthJul59fkqSAfP3pb5nrIpGjAMqkk?=
 =?us-ascii?Q?9G3rw7HbWISHlhPUVGFWBY9EskHVQdlQavSiyhtU2IBTaU+AcRU3QALi6x9H?=
 =?us-ascii?Q?RgCwVdgoqmKN1w4Y3VoRSp8wWoutCeskSGpDtrLPA/fJhR46wJRYgB6zpriX?=
 =?us-ascii?Q?ue5d/zzAGN4yGE3RaztmUfL8jYn8niqrz/EbYRz/fF6pGHr/OpQkQ6VrjYz5?=
 =?us-ascii?Q?q2j506TjFvq0PWNP4GhYaBTcqxIu1EIc48oKTruujAlv2nEzEtyYvhchKkmt?=
 =?us-ascii?Q?RV1IC9yWhf6cThBjmr+gQLmSj25bh9yXPeOLST+fvT7lYe4lW3xsrZn/Sn1S?=
 =?us-ascii?Q?UU8FwZw8HaCkkoKaXuZ3BM8/Da4FHDmanqT2JIxQWrbewVODe1pj5aV6pYfJ?=
 =?us-ascii?Q?jsHWLEC2J8rISIaIWyRmJPK3PbxUJC1AIS4lXOBs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d602da7c-5402-4b94-bfa4-08dafbc09a19
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 15:03:06.5736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FLLeQpTT5r0fWJNmbBRqDe+jOyxVxW50i+u69QNjWEcPeRiCqI2DsfTswcC9pgN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I would like to have a session at LSF to talk about Matthew's
physr discussion starter:

 https://lore.kernel.org/linux-mm/YdyKWeU0HTv8m7wD@casper.infradead.org/

I have become interested in this with some immediacy because of
IOMMUFD and this other discussion with Christoph:

 https://lore.kernel.org/kvm/4-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
    
Which results in, more or less, we have no way to do P2P DMA
operations without struct page - and from the RDMA side solving this
well at the DMA API means advancing at least some part of the physr
idea.

So - my objective is to enable to DMA API to "DMA map" something that
is not a scatterlist, may or may not contain struct pages, but can
still contain P2P DMA data. From there I would move RDMA MR's to use
this new API, modify DMABUF to export it, complete the above VFIO
series, and finally, use all of this to add back P2P support to VFIO
when working with IOMMUFD by allowing IOMMUFD to obtain a safe
reference to the VFIO memory using DMABUF. From there we'd want to see
pin_user_pages optimized, and that also will need some discussion how
best to structure it.

I also have several ideas on how something like physr can optimize the
iommu driver ops when working with dma-iommu.c and IOMMUFD.

I've been working on an implementation and hope to have something
draft to show on the lists in a few weeks. It is pretty clear there
are several interesting decisions to make that I think will benefit
from a live discussion.

Providing a kernel-wide alternative to scatterlist is something that
has general interest across all the driver subsystems. I've started to
view the general problem rather like xarray where the main focus is to
create the appropriate abstraction and then go about transforming
users to take advatange of the cleaner abstraction. scatterlist
suffers here because it has an incredibly leaky API, a huge number of
(often sketchy driver) users, and has historically been very difficult
to improve.

The session would quickly go over the current state of whatever the
mailing list discussion evolves into and an open discussion around the
different ideas.

Thanks,
Jason
