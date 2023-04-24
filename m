Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839706ED3B2
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjDXRha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbjDXRhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:37:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CF1974D;
        Mon, 24 Apr 2023 10:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nldD+G+ppU2R/zsYDBCHsWO1igr/13TBUKwID0TDdrtp9mDOCPAZQtw194aBfdQ1TNZBsvKdOnAjAwp1jLNCFcegUhOCImFLWrVwN4nxwgriv48ykSaTNGA+eSQNYkVh1UbtsDjlurmkQY/d85QXp1oKSEO8p22ZP3L14UqeBLDwhHPFqH8NAFnsHkOc0kwcHmipFfoOePiyLeO/PfpuSXEJL8ci9Vr5sgit5TLF9ch0uuUegheixnigKYU2GslcAzrs/wBhdZtaUfRr+3TwOaC2LKtB9Q4974HPEHs+Oab74MxiNhmyj9xkROx5OsoO8FXivTC8sG5TJMcYcoAC/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuIzqzxwk4rNBUXcOjx1dWMmwO4377C1NigcUXvF3/s=;
 b=n/+RbkKFtY5/wjXcs0nQ14XvC5R8xZFzgHwC/lDHwxCUa4GcHxu77O0UfM8BYNK0R2SOeI3lwMHxvcBWwQBWfkyvoTte70B8RJWwRu4DH4GkgLZH96OfGWFFDAgGlhg2vnR9MPwLvwuI8j4gXTdsnQ0gtjd53BPgAsTmftfehbxh8w+5F9CqLRVORjrpjBWt9Hx5uB3NgEOg5vss6GhyMsoh26xAZ2Vjjk5910XBpmdC7puy7VdNbVtKa0RXM4ldZpx7VxJHSc+vGjQwYIrsVT4N+nS9BIU/LMl4bLwqXPqkWAgNp3wQ4LhCHoTc+u1LRjhX/biaBvCzkme0GIrlHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuIzqzxwk4rNBUXcOjx1dWMmwO4377C1NigcUXvF3/s=;
 b=TBTtqZwKUf/msEaFnBOknRsUrT1zwjrekuog2tc9gkfCIz4vGXEuXSH2rRSZ21xBugWIL2dOiN57Bd+BobpQBv9qrhT2+VRPf5S+r0ccGTD7fhpeobDshNoqW9O5sJWCwOdYHVEcfA/PQb9g4aNaQZlj3tY4XX2rpdha3cDvkgkzh3yXQ/On+Kbs2pImOjhBeqXX7kEd78/EpklAHAWz2p5I01bdtloFsjBHpvDm0wu7scOOVJNPo2hf9Opte4NudFnTztasJVY3AjvmSNXyjka+jbQElapwTeT8gI0aUoMtig4sUCrVkgvPXscNbHC/lwdXtKpt4ibtS4ynCK3cYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6523.namprd12.prod.outlook.com (2603:10b6:208:3bf::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 17:36:51 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 17:36:51 +0000
Date:   Mon, 24 Apr 2023 14:36:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
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
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEa+L5ivNDhCmgj4@nvidia.com>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
X-ClientProxiedBy: YT4PR01CA0181.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6523:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a25ebf8-1819-489e-160c-08db44ea7cb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uL8m6NlQxw3mOffdBaxu0SMIWa0o3MUSNIN1bclfhkyXinS89IPjZR80GD+TcEUyZ2bKtxcX124UCz95ffgUMbIGJr4udvzPQEj8mwn0FtXtHr2SRdWaUYZZsOgaY7ZBoD8nX4EPFATd1DKvdqcLutLxBzuKhkae+N+NxOUlpD3B0GPLvrxXSGeaa3usPk4R3iPdw9f5Ad2lshxPEHuBgdRk182x/pNgogYogcNapZvoFn3g+PBxIjCmtwp4n3euhtGI5YFF/Ikktyx84BnL9DF5HFtiu2QBmYUcXZuloL2Kvz2S4xxZLQRpB6jiOM2SsiKPl4Q6F/QFC0SSrq8bnHs3hlPzEnqlpqSEsoT5GCt59F51t5jx3zfrYDzmvQkhAsCGxrARmlmfgwf6VFSaa6wy0FhUJrAmJybtC46hX0NfFHHiK9xjKz+o1r/ELsIDw4qxzWwTVa6C8+g0HutqbjB1r4hWtdcUic57UR74wQomD9uScBYwC84eVWytKT//vQUhPPUh4o+gjCQuZ8JXGhQ2362n3feQGOAVBIRyWP1wj3wUvky/dlB51qBwT0Uh1Q2ph+ay/CZF28Zyt+lVnQBWQDwMn43ZQFmA3CTG9QI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(6512007)(26005)(6506007)(8676002)(8936002)(4326008)(6916009)(66476007)(66556008)(66946007)(54906003)(316002)(36756003)(41300700001)(478600001)(7406005)(7416002)(6486002)(6666004)(5660300002)(38100700002)(86362001)(2906002)(2616005)(186003)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzjXt7yZY8DsN5Mb+yWWLnXgFhIdPkQva9YgzpbHmhADnOHTEwAdb6JmxYv8?=
 =?us-ascii?Q?RjH1fuNJDTjDis8I9V5DLV6VQL+7iO3ZgTdYUmGsFEVYZTMdRHRfi+MogJ2I?=
 =?us-ascii?Q?Thn6n/SacdL2bWi0GVA6AnxqCFRup9OY9oKXpfZecNXHlmndaz4rnkak75Hp?=
 =?us-ascii?Q?91cj3enaNtiLxo8TjS1HJqJvS6brUUCrEc7R+xJ6dAZaKnULe6UVob8owTJe?=
 =?us-ascii?Q?ziYkaIhS5CmgLlJGuRASGdtnFjBjd+SOooLF85/SSgI1ztksKVssUFBvDwq6?=
 =?us-ascii?Q?vGQxe8VGJOJcum+kuPFMYokU8sciyfpiPNyjWfhA/wsX0UBFQlUvANsyMBFE?=
 =?us-ascii?Q?o1aJp0SIRiAZkpw/qKcKvf8TEEXXO/BOvmCAWtZ+zU3mn6RPeuhe7P4Lwxul?=
 =?us-ascii?Q?WoRNjuui7L6XWRitsCBRjv0Uhp0Bz3QCefSRm4ghL/RuO8nil3aC0U/n0wzV?=
 =?us-ascii?Q?dnzgrY5h848GGM8mdcHuj8IbSZckHBiMWowWpXS2Aq7LGmvF854H/PFSpmHg?=
 =?us-ascii?Q?rSSjhPENhBUOeRWmkEWdAIkjxeDB2nAF516te3H+0u0fXZ3VlCyvkxqCgM+K?=
 =?us-ascii?Q?sH9cvZg+fPva/s9Cs5yRFbeZmSRsArvfEV2euTkdzJjm0Jlh6E6DeE6xvlOr?=
 =?us-ascii?Q?WNol8xsHYPAGsXxhR1IZmmrHku17xEYzKraLeq2RA9wJMelFoanYfHMw5+pm?=
 =?us-ascii?Q?G58zcJAtd0eO0gi+z05oeJntxEcX2KOnTD8whRXX44NZl7zJ9WfN+uyC7THh?=
 =?us-ascii?Q?BupZ/kkMP9Hn8GluH11cytuoovsmgZC0MtXTkki5uhxiRarC5Julj6CyqcRH?=
 =?us-ascii?Q?M7WFPuVAO/PflCpRnWb3ENn6URaIrYUs+cV2nU3p5yS55VNtlYh6tHO6BR7Q?=
 =?us-ascii?Q?emm7R6eb/PW2BiSxzEsuegS/LpU1zfkgdvzw3E2oxQ/NvVlA4c8BtZXis6fM?=
 =?us-ascii?Q?2wcOBGkY8pWGMDa28rlgbXZpEuznZzyr3ctokfiWKJsmUqumjD9eR4ao7LXc?=
 =?us-ascii?Q?6GP4vfjcHX0G1bgbYJCaa08L+R0C5VBSaLn6+R7zdF0OhDbBDmoEZa0tiF5n?=
 =?us-ascii?Q?e8ys6scr06sPTGU7lcRPOfONNmdNnv8sWSJT4TZUJpNNyhglsDOEuh2Kyua4?=
 =?us-ascii?Q?8gJwxkCTMpIE9xnz/xUXAu+4ovVYua527oU5R6FqNzfPxw3X+QrWmPP1rl96?=
 =?us-ascii?Q?MbLgyraDBsqDtRN94XMsXqhpSCHJ41TktjI68c5oteScLYV2x0B8ZA6nFk/l?=
 =?us-ascii?Q?0DS80tjlfA7f6Vq/ER7WbzOe982TUS7nHxJnd7jgMV06txfEiSfvI/+N0A57?=
 =?us-ascii?Q?RS/nqH8EGnQkL3RyypP0vvnzqhFvnRwZjy1GqYPdkXLcgr47Kh15VcDWKM0h?=
 =?us-ascii?Q?vrsBj5isjRM8RyQTd+X4YJBVY2ro8Zh9yd/qbI1P9hwapEw341lZRbH9BQWO?=
 =?us-ascii?Q?g2Kl6weZWRd71OKUgL4JWod/bGbVXlZR0Y7EK059G9DnQUvApW7cvHhOxi1y?=
 =?us-ascii?Q?JlEwZi6Ru42TlQrk/++fKf9ZqIcseOWEJHmOa6TvfXoAO0DPHh+QxK09dKQ/?=
 =?us-ascii?Q?GhxzIzphNYELIJLhjX4HbKsPQ6wARv7xAp9fHUxa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a25ebf8-1819-489e-160c-08db44ea7cb1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 17:36:51.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KpVEdGdBAb2mTr21PmeJt5/jtpeoSR0a7by5TaZQterhLw7uuk9lDjwLutIP62hy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6523
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 03:29:57PM +0100, Lorenzo Stoakes wrote:
> On Mon, Apr 24, 2023 at 10:39:25AM -0300, Jason Gunthorpe wrote:
> > On Mon, Apr 24, 2023 at 01:38:49PM +0100, Lorenzo Stoakes wrote:
> >
> > > I was being fairly conservative in that list, though we certainly need to
> > > set the flag for /proc/$pid/mem and ptrace to avoid breaking this
> > > functionality (I observed breakpoints breaking without it which obviously
> > > is a no go :). I'm not sure if there's a more general way we could check
> > > for this though?
> >
> > More broadly we should make sure these usages of GUP safe somehow so
> > that it can reliably write to those types of pages without breaking
> > the current FS contract..
> >
> > I forget exactly, but IIRC, don't you have to hold some kind of page
> > spinlock while writing to the page memory?
> >
> 
> I think perhaps you're thinking of the mm->mmap_lock? Which will be held
> for the FOLL_GET cases and simply prevent the VMA from disappearing below
> us but not do much else.

No not mmap_lock, I want to say there is a per-page lock that
interacts with the write protect, or at worst this needs to use the
page table spinlocks.

> I wonder whether we should do this check purely for FOLL_PIN to be honest?
> As this indicates medium to long-term access without mmap_lock held. This
> would exclude the /proc/$pid/mem and ptrace paths which use gup_remote().

Everything is buggy. FOLL_PIN is part of a someday solution to solve
it.

> That and a very specific use of uprobes are the only places that use
> FOLL_GET in this instance and each of them are careful in any case to
> handle setting the dirty page flag.

That is actually the bug :) Broadly the bug is to make a page dirty
without holding the right locks to actually dirty it.

Jason
