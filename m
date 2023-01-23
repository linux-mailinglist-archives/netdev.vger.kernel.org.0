Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4184677CCE
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 14:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbjAWNoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 08:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjAWNon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 08:44:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE13EFB9;
        Mon, 23 Jan 2023 05:44:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZ/xfSv7aNCNgZ65rAy55Zfp3VdxYNVVZbjWDYYqUfcMI9S8AgNOO5mRjbiZE6FuJ6emJ5UVfRkS/L+oXAjyvvjwqH91Czvn/EOnhTfPAz88J0KMcCmqNZErqxEmMKSmnWNf30QoMfm2wyNOfYb0jT437QxtiUe+cgC8T4v3Qan3gqwRXmqb5PGreVQyCxfXOA4ksLjJi5BrZC7ESJlASSGYHi4w/byGsGxlVEXYes/j2v03Uq9KU4wq1nxoZP6W2914IbdkI6HCPuz0oZw/SHrRnk6bp8Ni/NrGNXCs3jwSbAGQGLglYMuF3ouEuOEx/xHlkQlJQYOL5PfdF3nxLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4g+ZRZZ3P02iR+a24xcW7b7GRi/UZkdAjyi0x+EjP4=;
 b=PaetADv87Uej4k5ZKkFsEqah37M69V32Bge7nmGHEIoPtGXOHwUXWc+nMZ5dd0xZppT9j80vuWck8WRlNEBud4sUxXw8NmRB1KOU8U0a4v1voFCSxZB32r1LFXm+071XY0CJTPEz2G631wnYMWVv3lARfCCiyny2SYgaDafYOjta5hIiAOR144IEg9GOpZCveSOnalC0XbYPV6L87M1Bz6g6RMYhgotbrHRHzQ5tK4WDdjv6G9qgMjwbauAKYVzjsnq924qMCl0uyTPPeWw59l57+TP5jWt6mLoqTpN/CNxaM3c8QDKQLriNq8hvkzVp+oIjyp+rF1mh1KhX34oTHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4g+ZRZZ3P02iR+a24xcW7b7GRi/UZkdAjyi0x+EjP4=;
 b=c+sNb7QSvNggoBZPuJg64jXMhDLFnCk2+ff18sm0Fu3ZQOtYNoO3GFkXk+48g5P/8zHXxC2Ei8fc5PmMEQSwi9jWZShcb/gZgMaomHa/JsX0+e5F+X1nssm7QPivgncdUYakgxX0xIStcJrKfAW65O0F7zBzgmbPihHlhOE5tqM7kjtscgsqk2SR6zkDgedIEl5B5ozEtforigmYTt+39cf40ZXnl9EQ+WDAY/IYsPpC37WjeEFUavluHEQA6Zhr5b2jN62Uxba7LzkNCkxWHNZ1+OIEnm6y2PLKA9ZwNw/CNzo8LOqEa1VBZy6UFVx95UNSxuDSdsFQE3EL4i0BMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7775.namprd12.prod.outlook.com (2603:10b6:208:431::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 13:44:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 13:44:40 +0000
Date:   Mon, 23 Jan 2023 09:44:38 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev, Shakeel Butt <shakeelb@google.com>
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
Message-ID: <Y86PRiNCUIKbfUZz@nvidia.com>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <Y84OyQSKHelPOkW3@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y84OyQSKHelPOkW3@casper.infradead.org>
X-ClientProxiedBy: BL1P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: e6fbd6ef-b9a4-4ee2-2f5d-08dafd47f9c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtVy+qPNcqc3XTSS++Xf3DVAuvd39QV9n4r0zSxq9k0V4x0Fmozd8Up93fPeiVBe6iwSN/s95BN+8D8dPp3zXgQ/ZqPrz0CKAUmGaaWOabynAeU3QByE927cBPiRWEKM4d2C98l3FT6NN2E96l0RSCNc+MVSlBWP6pkF9RBoiZfkkxmNlBfhsoXcIVB76YnIwWkapeATX2ZapSTUUH2ji+7ChqMKlvaxdntKMn+HOe0RzEXEc7cR9Kd43qIsVJb2UdpxO96u4TYe4w5u2m4KsXtHYAEKl7HQDoR4FLbZCYkuNlVYzWxCnr8iiP14wSE2z99FNTXfsCnq0LfGffxqCQIFswFKGHISRE00srtXD16QEC1OZyF5GAk/p/OVAlPaCFRufBdeNsFjbqDz5GbfbRXL0O2Z/17WHA7TmPYaePAgOxloOdzUYJZAuBFNz/l4ucLKMN5fiirQVsCrst26+VvTrrbFhf8yeQPwr27otarLE4sxC37sR7r/4e/F4MqyGwwcWRcBe1MnBbZYUTHyFyXjF9F4aq9V9SHsCzA5JcqYFPnVwkY7JrAiZa3L+HsQwDgrnrEsKdUuhn4FEr9XTmrD85URUmx6SIY/x6ertKDbS3Ti+cLOXa5Miws6TWuMG2yydYZ9JQnGD4CuRSbWKpxMT2oo3rNugtpqlhGrSJYUOX0C0RR/Db2NQHWSODlnNHdaIY8mOcDK4AyZOSzVmxfY5kJ7u4j1jyP6EPVV9wk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(38100700002)(7416002)(41300700001)(86362001)(2906002)(8936002)(5660300002)(4326008)(6916009)(8676002)(26005)(186003)(6512007)(6506007)(66476007)(316002)(54906003)(66946007)(2616005)(66556008)(478600001)(966005)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OKYWfmQrazwz0W2IJv2+yLgd5nEBaDPHYotNbWRP+U8jF9qGeFB3v70MU1sY?=
 =?us-ascii?Q?+8LptTcrcdu+lmZwwoz31WI9qp8gsET6lZankzskvf0SjDlFH3dK+hWArSRw?=
 =?us-ascii?Q?K/DT4AfwBnPzlkrMvd0B+Gq4iLrK/XJtrZECtKj4MpjjRy7d+upFBVjAjAKs?=
 =?us-ascii?Q?G3jr+6xn+TAiGToXZ2lLJe9Vhxyv5teZoVQukIZevm9BzkdSBwC5TbQZEF+m?=
 =?us-ascii?Q?GipMOQ77T8C1VPLb1jqA+ODNSE2SrzbyQ64p6v69CKziunpLJVjWHZp0O48Y?=
 =?us-ascii?Q?MoF8Em/rQ5ugYS7cDGAfgdcuDDI9BL7OnoPZ/Wy1bwwV2FItsdOtsbKoo5Zg?=
 =?us-ascii?Q?TcLqo0ShJ3ykFoEHKhu3LlvwX8LyjanCIaOQ0khtoBlxwQwOZ5YvrFTa61mv?=
 =?us-ascii?Q?BvusC+eaDUo8yr37i+jYTLuQBUJ6HwZI/6yXYLKmtnWjVGrcCCW3Nt2WzADZ?=
 =?us-ascii?Q?T9J1KpiaQursvEeMwcm2c0SGRoyrD+94ZlLLDc2lyH6UVLHw78ovTCU+k9sw?=
 =?us-ascii?Q?fXxOihQlcLvGnlZi1a3XDxliWH0y4RZCXbWQiaDycVAqFh1ySU5bcBPPB6Px?=
 =?us-ascii?Q?XMZUo4efo6LBCC79OtyM81ELnwV2ixvbul8lCz36bpmyJqFjz5FBe5ZwfC7c?=
 =?us-ascii?Q?IvAF36M9LBaPW0dgF4wj59pdmwN+zHxQ+eqsSH2F9eI1zSsz+v+Cj9lWjIPV?=
 =?us-ascii?Q?lEr39iP5Va4hhuYK1RsqfdmPadH/YMSMRnesTzSArK6Jo5eB8ck1zLpyJGNM?=
 =?us-ascii?Q?fH7iGI8Md6ayYx6BnlGifCHDTf0lbhwFBgdjpXlJGMlSwssfhy3amg+c7qx0?=
 =?us-ascii?Q?c5q+o2s5mYyfqKjcRmQBpZGVbVVo/CnoE661EF1ZuaWNZHEBxAC9q2jyTeMY?=
 =?us-ascii?Q?9I2X2A+FW5U7UBkBP+5JQNeoVvxqUGNB7HkEdfP+FNtLsEc41g9sD3c5AQ0Y?=
 =?us-ascii?Q?Om91KAA9yI0fLTKYqrmWJemxV0LreD9/MCHxlRvOAVy2o6RfiHTcA6sHJVYd?=
 =?us-ascii?Q?gCANOeoldXwkzi+qAvrOmR2tG1Va1WlVWx0aiMGuOeyRld+VZpDnT+wSl7oF?=
 =?us-ascii?Q?3I+litGQFncxyXoq24E609McilzIMyK2fts/lfzivmqdtndr88X+MqlPz6pb?=
 =?us-ascii?Q?zrOoyulj364OZYFqdZQSk8UpE5KvShsRjpHcTFEEZZsqGmbklcQOiK3fb3Ej?=
 =?us-ascii?Q?U2J9uLYj9OyM1bZddNLuILPqqqsNksUbftiSEEkKHlXic4RTymbGOzg3/cix?=
 =?us-ascii?Q?LC5ez9BGgJW8LW7HgYbfmBLMaDn4Ah6WVyEo6CeFcAsk9l4tKcUdIpu8Qz9c?=
 =?us-ascii?Q?w4NiGP44V1LVXP1BJADNiIqtApSJRT61n8vL4F0Rn6ZBPz81v+Z1RiA3mKOc?=
 =?us-ascii?Q?eSulMGnfX9mK52XcEhs18QhwNXPwWGImWL+Tf8knqsXu6Arl6vnCwBj72PBr?=
 =?us-ascii?Q?FXUuH22xJtsLw8fCu76CZvpVVKu/2SwyFyVFCXXeXIFAC17JL0fjzAVDWLM/?=
 =?us-ascii?Q?aKQPF42E77ZLgAjcvRfmf1X8X2kDam1Dvik9u+2dYVUVnW9M9kIBL8dAxCii?=
 =?us-ascii?Q?9d6iVYY5u0RQfwrTEymVNT7bx9XwBOEzBtA2RBoG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6fbd6ef-b9a4-4ee2-2f5d-08dafd47f9c4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 13:44:40.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCHJ+Lqu1/pVpzPIkkGaZQ7IHVKxuNEcpqGZknc1RQlS/qzfdzFNw/ePhv+5yIK+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7775
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 04:36:25AM +0000, Matthew Wilcox wrote:

> > I've been working on an implementation and hope to have something
> > draft to show on the lists in a few weeks. It is pretty clear there
> > are several interesting decisions to make that I think will benefit
> > from a live discussion.
> 
> Cool!  Here's my latest noodlings:
> https://git.infradead.org/users/willy/pagecache.git/shortlog/refs/heads/phyr
> 
> Just the top two commits; the other stuff is unrelated.  Shakeel has
> also been interested in this.

I've gone from quite a different starting point - I've been working
DMA API upwards, so what does the dma_map_XX look like, what APIs do
we need to support the dma_map_ops implementations to iterate/etc, how
do we form and return the dma mapped list, how does P2P, with all the
checks, actually work, etc. These help inform what we want from the
"phyr" as an API.

The DMA API is the fundamental reason why everything has to use
scatterlist - it is the only way to efficiently DMA map anything more
than a few pages. If we can't solve that then everything else is
useless, IMHO.

If we have an agreement on DMA API then things like converting RDMA to
use it and adding it to DMABUF are comparatively straightforward.

There are 24 implementations of dma_map_ops, so my approach is to try
to build a non-leaky 'phyr' API that doesn't actually care how the
physical ranges are stored, separates CPU and DMA and then use that to
get all 24 implementations.

With a good API we can fiddle with the exact nature of the phyr as we
like.

I've also been exploring the idea that with a non-leaking API we don't
actually need to settle on one phyr to rule them all. bio_vec can stay
as is, but become directly dma mappable, rdma/drm can use something
better suited to the page list use cases (eg 8 bytes/entry not 16),
and a non-leaking API can multiplex these different memory layouts and
allow one dma_map_ops implementation to work on both.

Thanks,
Jason
