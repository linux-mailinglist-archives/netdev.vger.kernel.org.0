Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AEB6F47EF
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 18:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjEBQGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 12:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEBQGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 12:06:13 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A8E2729;
        Tue,  2 May 2023 09:06:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhmGzh681uutod86E8L+sutKfbq5MPT76xKlekrrPfKuNAh/FTAaFkio7AOo4dVU7gGiZg7vZxLAUOmfr/WEBp+thgjnWie18ci5VgLqjHbHQu/r1ZZsOpcIYkxGwVSDrqjLEuZRMSbYnW1FGfmQGi6DYdMZUe6aEsvD28VUgn58U2HABB3xTAFMasMLa/xUwj1fj1VMQlsB4L52/2m8L+3g39lNAFWdyuypmrLIu1yhrrxe/k6DR6/hnbS/41Eg6a9w+vycr6O73sD0sGg9Zz5BtazezbFusfqoVyYPSQISaU6mb7yAn8gua+fIR9NT6RDk8r6hc34n38arYxc4Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PvsjZKlfUz8S70g1y0riYC6e/TEogbaKLWsZdxnFqwQ=;
 b=mmRiezjh1pvT0RpGDMf8NOKvriwq/KilGV/vM5wJ8HaPDipmjjht0OPoOZsJX0fW1m952pK/og4/5t5Yr/QDPFOMYrK0KH0qkZkB+6V+eSjuGCwprKvVHmuwHpf5429FydnMovlf9QjUIvMJyL2g4vlXCxs7UDWUutbdTkiut8N3CSEPo+5ZV/sHCqjyVEtnRAhXUtt68+PNtJi6igQxM3+z6Rs9C/11n7IlOuxGWn+iwLD2tx8/DzK9Hb5T+klilKDJb20QeL1SU1y3MGBpuXxvtFQHNm/DDD1lnvE2e7nizdGuea9fzYD5ugGAPeogn8UyZ//1WHW/GhXwyjqrWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PvsjZKlfUz8S70g1y0riYC6e/TEogbaKLWsZdxnFqwQ=;
 b=PuZzf4aE4qb9ylVDOWUK43OmTysBG7xoBBPS3hJHyNgMweHEl4u+T1yPglkAQM/lOI19mtmon+681mjgmMxS50CDTliJDmBAAimKFDbPPgYQTb+g82SrsUUoAPDWIGffJhNCFhXm67B9UvqKWC3YkiyirwwFqsoU5yZtzriWf+G+GEGueKvdztMvfQqLmkY3u3hwxJ8sFXFmBr2qwQ85SrSIZ6ZyFWS9OeQA39/LXp96wsT+hfU2gwd2ck2lT4QIk0lm1BJTOYU0SEwhtTelmz87UPf6ypjNI1D6YquZ7cYBp0xIMM8LS48ec2cbrnCbNhEHLN87H+N3qAI/Xq1IlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB7496.namprd12.prod.outlook.com (2603:10b6:208:418::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 16:06:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 16:06:09 +0000
Date:   Tue, 2 May 2023 13:06:06 -0300
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
Message-ID: <ZFE07gfyp0aTsSmL@nvidia.com>
References: <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
 <ZFEYblElll3pWtn5@nvidia.com>
 <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com>
 <ZFEtKe/XcnC++ACZ@x1n>
 <ZFEt/ot6VKOgW1mT@nvidia.com>
 <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fd5f74f-3739-f469-fd8a-ad0ea22ec966@redhat.com>
X-ClientProxiedBy: BL1PR13CA0345.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB7496:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dcadfd7-c335-471a-7577-08db4b27242d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tjayExv7THwfCl1MZy4iRcE70yt92ZXuCOxJWLAunijHpdMjKGrYBVym2uCDi1jPxVzh41tfbYSucz0NqIUeVO3UqHik7U51ehnXzT5cYV9/Mi4A9gogJOl+LSEty0xj9e9sRCXHJhRaaeSVpsUDE8bJHTtxfpjlZEWkPwtZ7v4y5rzDzJprG+SZQAky37WfXjljsX0Z6xLboAJjp5/2T/QxMy9rYoJNDvcb1z74b0TaOkyf92qwgEgmPDzzsU9dKav4Pgmu7rCil4EhDgedTOdab9PPcdhEbTHMSPp+LW+FDotbRT7Tqf2YUsogMjhddYwGjfZAwCF7Gnvfrs/qpcc7r28vOAogjXdZI06HflmPwGQLB1I1KNTaR8fVaw7blzh3qvY/lQf4Q5u7NkbPDIy1mK5QjA9Jf6hEu7u7tHw6WbcfFrSr81d3LOWAPQ/NHBOlPxnlF47Y88tXvwlekgNgJ8wXujWioNvxB//ML2quMZcfpWjCymIgHl8U9H3er1vfBr2S9PokbjQQdu2ksih0XLhfcad9kPknD4YaQcm7SLEEQvD7KLOtzy6jQvRJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199021)(26005)(186003)(54906003)(2616005)(83380400001)(53546011)(6512007)(2906002)(6506007)(7416002)(7406005)(66476007)(66556008)(66946007)(38100700002)(5660300002)(8676002)(8936002)(41300700001)(86362001)(36756003)(478600001)(316002)(6916009)(6666004)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EyfrVfisrQXbXsv3vSilyaqAZvp91G83EvPKjJ7zwaTkB7YmWUL1DiPhcF0M?=
 =?us-ascii?Q?vlBotcLbL/B8fqtZ4+2M5jXNAJmTs6MmzimPlHWwltykbQFJ2Fka+46FoNHT?=
 =?us-ascii?Q?EtyZ1IXwj3Y+enXIPtOXlf9/z8S6POgSeyCHfNncok7MmOK5VpeyJbuTCpns?=
 =?us-ascii?Q?hEI5ZP/lqswrfPtvrGZ5Oh1/CORMwcJbTozsH6Fz24ogniKlV2iheBvetCmf?=
 =?us-ascii?Q?RUDz7eD/gwo2DBTLE7mYXTy4btnpTEaVOALb81E+U/iZYieGD+I5EBj4XxwX?=
 =?us-ascii?Q?WbJq2fXCZgqbSrP9iFc1wrR22+luaj30wv+njQg4jAIMI4rbaaWMhf8N2GRy?=
 =?us-ascii?Q?XMc5tP/bGmy7DbKo6futpJmrHdUSgFml/x0kDQufQNhnlmu5UCMjDu5t2Sex?=
 =?us-ascii?Q?1wG/FmGZKw1g11MQiYX6qFzjOhn8ri/pBq1xF0nqeWeASFyr/7vL6zKu8AAo?=
 =?us-ascii?Q?WmvyBXcgXVefPYicSVswfO+iu3jaYRNPiZSQ0zjbQCSPGhJ3sI2n9YJ7fHSe?=
 =?us-ascii?Q?A+xzHg+izRHm6uksVkUabL7t9LlLjotMfIIFzTyj2mwDJZNuJ8jbi1TnKfZW?=
 =?us-ascii?Q?zLlLomKNo5Eggf43VtD6PR0e28eX6HgBtMdHw37gRqIR/RtgvhyBj+NC3voh?=
 =?us-ascii?Q?q3qL6WKSoF/0uQp4Wt4jqIV9p2QkgFY4e+4em+hIo6QKDL3TfLvz2WVwqgO1?=
 =?us-ascii?Q?8aL37orQRDtPqcTsO91Bw+QvjDbbRTJZVKKGcu61n1Cw9AjxUd0jdixojU62?=
 =?us-ascii?Q?xf1JzdyD3wPu/YujHKShl/dluMgZyTpBxkhYpkSvGT2V4981O56+PXs40fAU?=
 =?us-ascii?Q?+UbHQgWuwFihhjpfkV7xiBdo2NYbB3GEEPNLn6hg39BqO62v1kO28uao4xUU?=
 =?us-ascii?Q?696LCYHVmxCLBD5S5WMl1g35pOea/iSI96D+hdiSlNzvR9lwIkpjlQPDyHC4?=
 =?us-ascii?Q?Xk2VpkYtQV6+zSR8U1SMpO5tyIFtMvO4p984YkOGPUXnZsLw8nEASQhjptG9?=
 =?us-ascii?Q?DTIhYAD8eBt6WtFVPhky9bMuMOXEkwA17FD8z6yIxtWLa/OLMn19l8sIIlYF?=
 =?us-ascii?Q?gbOEw/NPEYytdanvzAZTm+OrT+/K3vlo28HNkQ4FLvQ3SIvLABhZOfnQghhx?=
 =?us-ascii?Q?7Pm79i4bLT9t+03pbQ6dQDxHOynsi4Awmh9oocAENXpL4Rysdy7lZq1CHiDM?=
 =?us-ascii?Q?q9BSjqJz3UIu9XNL5qR2licARyeL1cgvSbCS0qh1DBo5JS3ttH8TN5OkSmoe?=
 =?us-ascii?Q?H3nxXvl9N2BCNkfmeUQz35X+FkXq8PxAm7IBbTe594xXKezdKkclLcI6wTOa?=
 =?us-ascii?Q?OqCUN/RuiUpZCu+I2jy8W+SbJWyrWljpDJoGAkmitD5V/AVeWIH0D7oh03rj?=
 =?us-ascii?Q?67tDrUElu8rrmRvRwftar3UTzBu2lAAN7DN4B/e5E5Omc9ikQLLSqjbW4L14?=
 =?us-ascii?Q?6TAGwclD+SjOS+wDQTNqfvAQeFMAUpBZ8VU0AxKOILuQyXc638JK2Ait02yQ?=
 =?us-ascii?Q?1aAK79EFQgxnbJnFhKZKfzq5mqB1UGTJqH+CR3KG6c2T4IlcSMstMQDKzm4K?=
 =?us-ascii?Q?+HetzouApPdXQ7Ldcz3ZK+cUVYsUMPjUrBVCvI0U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dcadfd7-c335-471a-7577-08db4b27242d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 16:06:08.7890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvjkgzuqOIMkwUwm3XciPFwIr6BgvB8jvTItrVjP548EMk8AepW6KVfEhhnnctaL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7496
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 05:45:40PM +0200, David Hildenbrand wrote:
> On 02.05.23 17:36, Jason Gunthorpe wrote:
> > On Tue, May 02, 2023 at 11:32:57AM -0400, Peter Xu wrote:
> > > > How does s390 avoid mmu notifiers without having lots of problems?? It
> > > > is not really optional to hook the invalidations if you need to build
> > > > a shadow page table..
> > > 
> > > Totally no idea on s390 details, but.. per my read above, if the firmware
> > > needs to make sure the page is always available (so no way to fault it in
> > > on demand), which means a longterm pinning seems appropriate here.
> > > 
> > > Then if pinned a must, there's no need for mmu notifiers (as the page will
> > > simply not be invalidated anyway)?
> > 
> > And what if someone deliberately changes the mapping?  memory hotplug
> > in the VM, or whatever?
> 
> Besides s390 not supporting memory hotplug in VMs (yet): if the guest wants
> a different guest physical address, I guess that's the problem of the guest,
> and it can update it:
> 
> KVM_S390_ZPCIOP_REG_AEN is triggered from QEMU via
> s390_pci_kvm_aif_enable(), triggered by the guest via a special instruction.
> 
> If the hypervisor changes the mapping, it's just the same thing as mixing
> e.g. MADV_DONTNEED with longterm pinning in vfio: don't do it. And if you do
> it, you get to keep the mess you created for your VM.
> 
> Linux will make sure to not change the mapping: for example, page migration
> of a pinned page will fail.
>
> But maybe I am missing something important here.

It missses the general architectural point why we have all these
shootdown mechanims in other places - plares are not supposed to make
these kinds of assumptions. When the userspace unplugs the memory from
KVM or unmaps it from VFIO it is not still being accessed by the
kernel.

Functional bug or not, it is inconsistent with how this is designed to
work.

Jason
