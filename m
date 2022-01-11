Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB4F48BB28
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 00:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346711AbiAKXCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 18:02:30 -0500
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:22176
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233525AbiAKXC3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 18:02:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5YouJ9Z1ocIP76F20xUNWGaqzFYAK6OODrHT8cxln9yT5qTCig5Ep9ZvzMBKtuWsxnzdImk9klb/xDGzkfgpkTSQyEJpJ70CAgdoaDQEfT18WaPEhAwqjmxNSOicHDyd+H3iHUyRhk7QvGUk7STQpsKsqTi2GUBTsiNXztJHiczJespYdAXUZTQwRCaIQrvk0afElfDyokrhlJlLDrSuozlYosclg0AaJ5wYsSNBecUDOuvHcjIf98MT9zdXgQomXpNTqD35hEXVemygLQ5VirwOTucsC3xKV4J0jl40+Rq+BWTIoAJyJHxiAXjwIA05bVZnQn1bhVpK+2lAAt3uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x54tMoTjEfJVQnrS95FkNyz/p7HeDtF89i4GGKpCwh8=;
 b=JEkxT5uaX0EbnbDyRu5ss2VQt0WD2NDLZLQwo+ojZh/b8uO5UmRIEkymGx6Vip8uVlKaZ4Fbo+pNy9otl9rzytZmHHpGoxua4A+m3qjujb4j16nH4ZH8+VxTOAIdbdbmp7v05YWOi5x2Ofk3zJsijTS9a1ZVa/o4BTuM9ASmj3SuHeQt5tXK0l9dQfkeyL+mf95Pm0mbZebdqmAatMxxcaVO9di4OUozw3seWXFblDaiOb2HrAuwdPmaOlhaB6Aw352ys/fesk4W2woAC2tTgTPPVwuRpNK/RGOPEPvgaXUsVT8qlAV7+qRcxIu7Ezj7QmZ/Ra0RhViAoON8NyqXXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x54tMoTjEfJVQnrS95FkNyz/p7HeDtF89i4GGKpCwh8=;
 b=YPITSwwWgafNYNEcOiC7OoJH9rtKD+ALuXTqh5gQBLQypsT4lAttXNxjV06hHz/F3YppSv47lwLo9jPuY+nKA6mjG84Z36eomErpZZBx6nLxL2gVOdRMnTWzqiwbRwnDXJpBGZmTA/r05ggytL1MMKiPXjS6qYmsqPiOkf1clCgsoBwSumh3x55/gWPajEoQVpNZFaXkNdiXiiRMGQOUFvaIppoJgm41/JDHVK2sbwBGQEXH+cgt8+oEv56Zzojmami1jygi4f4vKDyxhXQ7K7wxSx4mhMaqY+n21zrdUmdEmm3DEoPuO79dmV+cm9vjCrm4WtRQRPTrTsyami8DrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5554.namprd12.prod.outlook.com (2603:10b6:208:1cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 23:02:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::464:eb3d:1fde:e6af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 23:02:27 +0000
Date:   Tue, 11 Jan 2022 19:02:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
Subject: Re: Phyr Starter
Message-ID: <20220111230224.GT2328285@nvidia.com>
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com>
 <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com>
 <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com>
 <Yd311C45gpQ3LqaW@casper.infradead.org>
 <20220111225306.GR2328285@nvidia.com>
 <9fe2ada2-f406-778a-a5cd-264842906a31@deltatee.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fe2ada2-f406-778a-a5cd-264842906a31@deltatee.com>
X-ClientProxiedBy: SJ0PR03CA0257.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 073e8d5d-451a-458c-56c3-08d9d5566ff7
X-MS-TrafficTypeDiagnostic: BL0PR12MB5554:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB55541BD85A097AC3CFD19315C2519@BL0PR12MB5554.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6+ze0FfOHOe3b4UrJsy4b53mO/55aLIaKo+002uJnWg/G4hPVA0EGAQkGMy3VEuk/K3cmRU40tCLoLkzuDpN0ibrl2ryG3+7QLBExrBydJg2uNcrKGLNDiWOjpyHyuG184dy6ep4ZL2xOtgZTFVO6WJqah063dsC+0b5VirijJfs2enn1czl1UPwMw/pfwDhYj+1XhQqT6MriBZpbRNaTOeTpYjux91paYKCuV+T22QyU2CIwK2jpjpaJjQ4U6YI4fSGzYbZ9VNYqslnTn+kBY4GudznvENvUKUaBwuiNnn3HypBgxDV3gY66b9v0X7zorVg5d+tNKGZPjIVMhtQslFB+CJ4+wsvkORpzhacTpmnOS8AA80oM0XlNxX8TPLv63OPduG0rrdREqSLjwXsiHix2HfzSwDv9aDBHJ2vB/OzU821z66yg44dNZUYT6cA50y1plSsH+usr6Tem8PriK0ad+m0QTkwRguO7zZU/45LmNWMO/VNbIROxeihEDmjVCaJz+tkZTQdp6fIQ/X2NqlFJKyhu+GMC6N8i+uCQj8hWADkk7x+cy+RKZTzyGyf9Mux+qcucNbNdHwg9/3Huqgsz5TZBi9rvsNlkX0J7NHrFKZHiTsZQ9Ki+ETrwtclkdCl7nvzQU1RHzpPzlNKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(7116003)(66556008)(66946007)(2906002)(53546011)(33656002)(316002)(4326008)(3480700007)(8936002)(66476007)(6486002)(7416002)(86362001)(6512007)(5660300002)(508600001)(54906003)(4744005)(6506007)(1076003)(8676002)(6666004)(26005)(2616005)(38100700002)(186003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DWYNEIEiJzBaBLaEFyM5prRrkou/MuGzRGa0Peizn/2NuNQL9mGf512D2MaT?=
 =?us-ascii?Q?/KQPPIj2mFCS8z8g/bjzNF4QJjNiyuPvX4YoNJy8htuD/i73OrDE0LuvFmEi?=
 =?us-ascii?Q?2YPq3GxlLbnLuOwCUF1sCZZWUEO+jvcx7/aziD/K5IdneWm4bX2uYMn7p0+8?=
 =?us-ascii?Q?eI/gPODloNT5WttWiNqaTbKcJ0+jYaZwU7jNn7o94dYkPNCcP2V5HwR/zcC3?=
 =?us-ascii?Q?LjsWTqyv2m7s2A994yaoyRB6XXOC/TVRolcvNrsOO67QJE3ea8RvxoVYiLUm?=
 =?us-ascii?Q?llJkK4jUtoepwz8A1juy72KDWVfJrBgy0Ne1TcF972MBzhFJYk8++Gkj4ZsG?=
 =?us-ascii?Q?otUedvVkqWWW6prAd3kIBXlVP7S7OfDQybEMxe8Ll5VTsS/mYRiukHqCMCLx?=
 =?us-ascii?Q?x8QCLRnJOmM6Q24oD0HDAg7/36WEoEyida9+6wjkw2/e5wYI48vMCOiFWSMX?=
 =?us-ascii?Q?g/U66l4AXMw/MqpOMVhOAPMVUu3N5BZQvh2vj+f+8IGtxaH8/+Majhy/sns2?=
 =?us-ascii?Q?TE4OhdKnUzbVY8WNdApJ/HOI0B1k2cHLAqJYHs2mIGHS0CDBHOsbaLWD3cto?=
 =?us-ascii?Q?F6TB2b2KBpGwKuGe6MtuqRZZo0b+dGy3pjWxVHdFvmL2J2WBZtubsNvZdCtQ?=
 =?us-ascii?Q?dOXZYJKmam9r4BhmIM9LQmQh+k8ZqyujKXo99wXgr1gj9Y0uirBDlx5FvKH9?=
 =?us-ascii?Q?kfy7EU+Gb6FjsCHqEUwmJS8whQUbbCF8h7D5wqXNtSnQNI3xkKAO1RlVwpIM?=
 =?us-ascii?Q?I50gGVM/J5Z1X1UFc+84kB+W0HX4Tmb3tw1cU0WTmo7Y2pPF7aWHMmBSg//x?=
 =?us-ascii?Q?hfom6i6PFrOhWgZgiew1J/A/UPvnbrDq/lMnggkQAcXkdsjWRc5jnuIXYdmK?=
 =?us-ascii?Q?5f8XesMeTL3qNV4wr/PIq3cTyJoKxqnPex599G8geir5J7A5cijRJy2ZTJb4?=
 =?us-ascii?Q?GnDCEMUL2ZT6Y2MeSO+RwsWYdOBBc8u3LwZG5ANfbZ8W97UHR71onivjDego?=
 =?us-ascii?Q?qc5YmICBAyqtgTpJ83InWoe//xITmJ/AdPPkW1ml6PSI8hFKBejyJMLXP5ul?=
 =?us-ascii?Q?oNqDe51DrOX+vgVs6+W0TpuQ2tGZRRb3bGeJVhwiSnjmSv+Yv6CB2TXXRQl3?=
 =?us-ascii?Q?4VA/4iuw6x7r9wU5Qt0J8TLHrCNfDEp9VUlaTuoKUDM+/Qi+5+0X+LBSDa0G?=
 =?us-ascii?Q?LeBtBp4I4pbW0Txswszt53w+RqCHe1zXYOhjhOukFVisrXX9nc+mJvoCPs4S?=
 =?us-ascii?Q?VRoHtBQByAG1xo5yjWhoU+YMx7huISoZjbA4RRhWdHw5pWfyIxUhsg/I99Hj?=
 =?us-ascii?Q?EW1J+nO/3V/YaiWiYfwHlT78i5FSyTyLbrVFym4cSDm7B/XMckP/RxNinThX?=
 =?us-ascii?Q?sNNeEQmxi8ho9pcliJ+QwxgI/B3+FHij4o1+FVp3goNUY1J2MikqTy9vecQF?=
 =?us-ascii?Q?t5pQF1dqBeGJc7ImhwJfRae4YFqWuiVR7LlsUHiQQsIXiR3WCdY38IqjDnmF?=
 =?us-ascii?Q?QTqInQjuqNxs8HYu9rNSzgfmT1cySrMJZipIwAXgXf6ufAZ78Rb4/L0VATCZ?=
 =?us-ascii?Q?ouNwgFCIFBguYMzWQa0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073e8d5d-451a-458c-56c3-08d9d5566ff7
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 23:02:27.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFJJTz3Zsl2IVTnLeJGTYn666I9efgAPSPJFJ07E/nFoM0EFuPzq49PSUrpF6fX6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5554
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 03:57:07PM -0700, Logan Gunthorpe wrote:
> 
> 
> On 2022-01-11 3:53 p.m., Jason Gunthorpe wrote:
> > I just want to share the whole API that will have to exist to
> > reasonably support this flexible array of intervals data structure..
> 
> Is that really worth it? I feel like type safety justifies replicating a
> bit of iteration and allocation infrastructure. Then there's no silly
> mistakes of thinking one array is one thing when it is not.

If it is a 'a bit' then sure, but I suspect doing a good job here will
be a lot of code here.

Look at how big scatterlist is, for instance.

Maybe we could have a generic 64 bit interval arry and then two type
wrappers that do dma and physaddr casting? IDK.

Not sure type safety of DMA vs CPU address is critical?

Jason
