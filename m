Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BB46F482D
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbjEBQT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbjEBQTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:19:20 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2920018E;
        Tue,  2 May 2023 09:19:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ev4aXIbU0YErP34f5ZL7ZbqmL0z2nJQ2m8RBGU59e7Qcfg7dvO+0UbJkK0FTpr4gF6mUxjKh12b5Jkcc6tRqhfQo4MUkO7XnVXAxQh6ZuCAJLVBCecx0ptEu4i3Yv/r+6C4Tr07HciPY1yAlQJZwLBMFW1l0FnNZ83pE9GuaW/sAEDcgPwHS1pn6eXVqoL5Og9XBetATZel9L6oHk/MFu7iVDfvV6i+t8KS34ODgsnXO/rE1MFP8xE0z+IL8jUQtuft3Gdb29d/xMt7of7pSbMXuJuloHot8QlicJ0g//9Osza+n+pToxuFXaoenEe+hc3aXKjaGoctFWe5+FcVCSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ky/VLcY/dge9jtSJ+ToY4py5kMkqSqKN48VhmAgdf2Q=;
 b=DhaERCUh3HXvOVkphG0NHVwMfTuO9dxgT6YNSgupBEe/U+2DbxwxAp8wLLJckknSQJkOSMYArofDqtX0T4FqG6ngvanv4OeRWP/mLwy7ivursbZb/+72+6DsBEX58o779KqMXoWG8Ys5eFCvSKwMmysaNG5aBhpK7BWSh6ycDlPNzU2rVVIQ0CoBG4dJ6PMeGfVbBgYyRNaqwqsaj6xB9pYXwy4DFpa0dujYk9WPWwWBrP3HRgjXlu20lQWM3ExDx9PQUVm5sZL3BXQgsGl/2cuMFJ/oOnUO5K6XyWhzyBKUDJVf+E8xu8cyAboyJrfSzz0tMfRVQ+NZnUHXmdIp2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ky/VLcY/dge9jtSJ+ToY4py5kMkqSqKN48VhmAgdf2Q=;
 b=pxkX/PLul8LLi52bLw21iTMxFwTU5ZyCd1QAZIbSMzxwgk3SJUeOfBj0KCVTtfdBIhR+67V1zot6c2PROx72vBKzN+PmAQZpBbfwy3lVyVH4+X5zOpAJwWoFtcwYX2hKg6ofeF6qhUq9ksWh8P4dFMHr11Qst9d5Bjiv+2JF9BN/R7k8WyvfasLYo1ejiWKI1YNnmjTtG7o6J7O4JGEy1ePfdSz+8g0ak7gqPUUp0a3aiVqGoxc63rsSXR3KWMUkH2CZpX8AfwrftAxa/+A1cWiNjO91h3aJGrxIvDOYVoc3sbg0O1FJA19lO4BRw78pWLjYBsjGnG04SyG2z4XrcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4506.namprd12.prod.outlook.com (2603:10b6:303:53::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 16:19:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 16:19:17 +0000
Date:   Tue, 2 May 2023 13:19:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFE4A7HbM9vGhACI@nvidia.com>
References: <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
 <ZFEYblElll3pWtn5@nvidia.com>
 <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com>
 <ZFEtKe/XcnC++ACZ@x1n>
 <ZFEt/ot6VKOgW1mT@nvidia.com>
 <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
 <ZFE07gfyp0aTsSmL@nvidia.com>
 <1f29fe90-1482-7435-96bd-687e991a4e5b@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f29fe90-1482-7435-96bd-687e991a4e5b@redhat.com>
X-ClientProxiedBy: MN2PR01CA0044.prod.exchangelabs.com (2603:10b6:208:23f::13)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4506:EE_
X-MS-Office365-Filtering-Correlation-Id: 314b91c9-f0d7-4f48-e83a-08db4b28f9e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yv5ZBqqRRQK1WTaU9ORkybCbO4E9ITbm9d5DsuUMQ4wCJQMI+tfEdiTxv2FIivOxUj2wx3eL9ge/sQMEvm9PBt40818GJO5nQdiLzssr32dtjKWnt6aIKgd5xenq1s2tzZIErhgEBaXDpxyYP/2IIpfBdnUkO16QKloilNNgncw0VBiDBOqIs2mFQ6XO9sXam/qUKM2KXO/QTMVAJbL5KY/GdZxfplJB5BwzME8Vmm3LEro3d1fRgjA8cJRyGxKoXKYxoLXwIyOTiynxlbZB9hOddrr2j3B3QsdnGMlz3e8DpXCBLiME0EiEJc0+S2TnYyIfkAqOcPeR6KSnX5sZx1kIZqNmaDJX5fMHf0n06wWiN9whpJFJIFjlOgBJO836u0wu5W3tzUcb99Ff0JoDJBZBN0EHpIpNLhbaXwO+5x+LYgQxWq5hEEj5NSozopRV9ZwDmF/mnuL9yv8Lw0Ka7SapskaBMFfto8rNoFtVRIO6jhOOjVBQ0xDVx1fGRB72X+gOvmXIDMiWqJjImaOy3w585WKClC3/hRhuXOB1tJN3mQWzm/l5xtcdmIaKF+W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199021)(38100700002)(7406005)(86362001)(7416002)(8676002)(8936002)(5660300002)(6916009)(66476007)(4326008)(66946007)(66556008)(41300700001)(316002)(4744005)(2906002)(6512007)(6506007)(26005)(6486002)(186003)(83380400001)(36756003)(2616005)(478600001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W5SyE0O0tmVu/rVkUGSWlrQgcG/a5cZM5FOEWNZY9AF+njYJNwlo0j/Xwuuh?=
 =?us-ascii?Q?+5tT/WpLFLewx0HQwddkh79krqWitlqtLBr1S/F6sZc4oC1DMcyH6H1poVH5?=
 =?us-ascii?Q?epR8arC045CDJFmqJ+PLFSTF8zPVtc8HJkWWIqTrPHV53CGb/ug4CZck6GS/?=
 =?us-ascii?Q?cTHu2QoKF/yXcFaPWezNoaSBccLti2rSC9Fbbr8AaYnMdNx/c9Yqz7TMeTEu?=
 =?us-ascii?Q?00hl0TbImsYf6O5yBHEPgwkjCl5vL1uMF8erBBhq/OsG9CeVRq7c/Il/dnEx?=
 =?us-ascii?Q?MMNNkJzFvjOkUTt92hNTPqKA8DvyAeasFc06jnsILTNIKJo8wMZeCHdG6pVH?=
 =?us-ascii?Q?5oC3aw2MO9y4dfOxgaOUrRk9JuRgcu9U78ZnQi7H2Y8/ooG1AgQpd7JuD629?=
 =?us-ascii?Q?Y4MSyK9fZ3/k85MxS9O9QWmjKvSeout2uVBpvrsCmw0E6vbx3PuxtcKdJjO0?=
 =?us-ascii?Q?PJPeYlwGzvqYDkhuvIjFBRFxdMulGj5V2AytzR+XeJreIxyVjPPHdCmVnWb+?=
 =?us-ascii?Q?4xPmxZEOb6pOl9DLOvCqRdUZ4MV5bduGbFFpAyUWX1vb2UCtqxcH7o5yBY0L?=
 =?us-ascii?Q?K5nqVZhXdNsj6GzDqEnN+WhwCULPQUVaESFU9vbSnhYx8fcScdMRmLCXN43u?=
 =?us-ascii?Q?74hK6qOQAcY1qigQtq1tqh/ox3+VfK21Ojz9s2G2byBxAvdyttFcn7cngvjI?=
 =?us-ascii?Q?vcfRidsDrrUm7HuOuJmTqd2qv60m5ouiNtE/+UEQ5e70B+MOJEz3KNKoJrfy?=
 =?us-ascii?Q?Ogiz3QB5dCOfvtqGGbXTLRKBi/IZgc3G59jRKd5DlfI3Npl1Ii3ml1q8+pUH?=
 =?us-ascii?Q?B84b+f9q4HLfGrH8+AV7ZqWm9zSet81wiVRpLf1CGTSEg4Jd9T8E8LhmN2l/?=
 =?us-ascii?Q?CURctKHf0CPK/5O5odvrZVo8dPV1Aw+hMdy7nSigMjIwjfXhrkqJxEg/NeHy?=
 =?us-ascii?Q?C6qQU6LdSsGNACRD/kPcE5e/lNYwbeMHkA5DRr8fb+0EZsWex4PMbOVUl7tm?=
 =?us-ascii?Q?ymIxqxhwwjTw6N3D0Bmp6K9Gn8yATEqE0S+5B/FvK7Rr1qqQllyrF1IDfUma?=
 =?us-ascii?Q?goW3NemGn/fSOm38VDxcsh9BfBgRxNZnvUmmmgGld9E8S9PTTD4jGZnxB6Zg?=
 =?us-ascii?Q?tUWEdHG0xUIRFbpTtnsReBKTiVi9wA7akJAvsjnb+hvOArLgcRcdFc0+TLs0?=
 =?us-ascii?Q?GasxEMrLIjVbxLcfgTNjSnSgzcYQbdDIgHerRpXtc+4OhI9as/fICA8EdXn8?=
 =?us-ascii?Q?920ZWESsI3aNuAwBzhRuR2Ku/CP0wXViY5hKoWulbUe0CnDYxZuJghaW6MJy?=
 =?us-ascii?Q?ddixp45+yesUGGDWx9GF+auMn8R1i/cY5Zx5loFpWkM6UkMuC3yaE1qeOI0M?=
 =?us-ascii?Q?s3uN/ir2yAHIKXBhZ7PPCeilAWroNpfFoOj/p7Vqoi7qwiFbBP4zsXz+T3C2?=
 =?us-ascii?Q?8yfuEJW16HtHxvbSqB5g6Tk13hXaAARuVeQNqLGTi6RzsxFxkbMQ5A6RnmRW?=
 =?us-ascii?Q?UnU9JMwBwM+cmb2CpSrHIQ1hjBPbT03mcVaNywFIJrQqixHRMHRAKN4nIlb1?=
 =?us-ascii?Q?qCDDy7/Qpvx3FOcyr6YyS7rnyIHhwkJmrZJrSHxB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 314b91c9-f0d7-4f48-e83a-08db4b28f9e4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 16:19:16.9719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8eUn7mYLiAMFsIAC2QL+HOjm7Fj0h0CQi7LGPDcyaYS/44pBcLLgpD1RttvwzgO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4506
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 06:12:39PM +0200, David Hildenbrand wrote:

> > It missses the general architectural point why we have all these
> > shootdown mechanims in other places - plares are not supposed to make
> > these kinds of assumptions. When the userspace unplugs the memory from
> > KVM or unmaps it from VFIO it is not still being accessed by the
> > kernel.
> 
> Yes. Like having memory in a vfio iommu v1 and doing the same (mremap,
> munmap, MADV_DONTNEED, ...). Which is why we disable MADV_DONTNEED (e.g.,
> virtio-balloon) in QEMU with vfio.

That is different, VFIO has it's own contract how it consumes the
memory from the MM and VFIO breaks all this stuff.

But when you tell VFIO to unmap the memory it doesn't keep accessing
it in the background like this does.

Jason
