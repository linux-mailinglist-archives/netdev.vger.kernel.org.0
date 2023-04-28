Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574396F192A
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 15:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346196AbjD1NRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 09:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240073AbjD1NRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 09:17:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62C41BC5;
        Fri, 28 Apr 2023 06:17:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQqCEVWuLHRkJg4twoSgmV5qXWbUed+WMn9txkKqM3ljoRkBi7a7FvY3vmCATOFgYGzIsh0M/W5PUdHSI3m64ynmlVEgWBGiK9l3kPQ7DmRERLKW11rlI6aEn3Je3UJ+p4hRKKF4DGGsMF9WZpoyluZ+ceiXLMeEIV/5vJ/Pv8vVHGZnMHrCzx+X3H5v94fdPYT8U39GigQbvCCs+C0RZJvtWTtqjGnTSmcrznvDuS1mUY681vBvrzQi4QBnvFaGyNxSFVnfcC+p7PT5vMtnIfWZ62cqaKW6SKJ5mdHCzW5/TVtTyJJTeSHLqu1o965oUbaWnxQIwZxJ5dFKNIstbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7fTcTPVT4LzcS/Vn/r6VsFUFt9CgWOLi+0RBjkHwfoM=;
 b=A+i5EyF2TwGFj/Hojb66HmdNSY5Y92WV+9ADFFfFt4V74YBlNH9NmHxvoFzUGPVuw2wjWb0lxnw5ZNx5OAwjEqVR4e9dHj3xiWr9BvVe/5Zheao8af84NXkNlZK1bBul4mqLxq5hckZmO4BduxJGFH6P1Ym55d4mMuV3cG0bm/3BWr5lCfCraN1Inw9SFTsgSiaSVa2uBNRuQ9UbpZtBlIRaCniU3ozV+Rne/nhoFKXF2JHJ50z9iek1Tu0V33yowuoQ/zrfBHsyUmWspoMH7a7POwHwhJupJd8eXxur3kMXXuf/sFVUVXmg96tl/oOIpeOs9SLMZk3KMtbI7iM25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fTcTPVT4LzcS/Vn/r6VsFUFt9CgWOLi+0RBjkHwfoM=;
 b=mE5tidsR05A+C48dwKAfMt5bt2rC2dlmHBLf8KNLNuMZKR4uXfjya1Dfi1k5gAGAm2w9bpYQrjW0FXOT1PVSn/E47fVoGqZPD1GFk/zyQcxE0X2zGkSs40f6LBYAVtuQhZuBLM63uE4BC0fv+TX/4cwjlm71EClV86G2A5OXUQxuiKC/36kmSdU+PZ1z3RrFx5x+P8piegbiA31NmuEwRjmylSI/wkPQGFHazNGxcye/0B9+ATBjvVV64dEBrIVv657pj8L1VwAyjO3117KFvCa1NJ3Pc3QZYli96OVBrTeqCITB5pnIKttU5ldjXrhmH3inlqH2POuY9InmlqNpMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5962.namprd12.prod.outlook.com (2603:10b6:8:69::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.20; Fri, 28 Apr 2023 13:17:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 13:17:11 +0000
Date:   Fri, 28 Apr 2023 10:17:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
        Mika Penttila <mpenttil@redhat.com>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEvHVnDrz3SRxWv2@nvidia.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
X-ClientProxiedBy: MN2PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:208:23a::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5962:EE_
X-MS-Office365-Filtering-Correlation-Id: d5065df4-7476-4805-396b-08db47eae076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VFCVUfrNVftgi4Pel8cn0mZ43PBrCpB11cbmTGhCC4BrVP74AmsTiWbEXnqCJMilaEoskQGsa3o/quXPvrBO2OeoWXQGhbOpcdUfx2e+J3QhvWf+nmzB2H5eL/4Qrn4HndaxAc9QFqkDfF5bB4KFa4VROv4jyvPAo5xUZq2iUDQBkYqPWwhHKoInw7zdIyBvUsp/fPFxOnq7QeLnkZXTq+HrIQ6b3Ozvd/m7O/StrgYyHnDo0ZHU90nAJet3NAtjtNCmuheCIaD8lGhSUpT5xGlhcYQHuXNZjDn1ERbyTii3Uh0bwBbAcbb+WDz6cryAYp7b/Obo5o5ocYeYDGk/Oza+EcgVsxxaCxHoFMd7QGgATkLvATWnfupyJZBfHNoUR3h2mqGg63AabDhpe/rSm5cGSIuEAovYw9TULo+W8FFizztyHg+0yLLfMEAFIAzb9vAGJCzajXt5RjXg3/rsmrxA+I8hGnfJ+jRJSNDjBTtV1hyrJ/ThJqicpJ4hB3Ua/lQKbcYaM3AmJNY51O0vD67cZ6jKkXXjg9xls4QYj5eLX/I91iksdvM9Iihl52Iq5925z/LGepYGqi84SvhniH/pGrGRhGu+2USrLgl6shg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199021)(86362001)(186003)(66476007)(6916009)(66946007)(4326008)(41300700001)(6512007)(6506007)(66556008)(26005)(316002)(83380400001)(6486002)(2616005)(54906003)(478600001)(36756003)(38100700002)(5660300002)(2906002)(8676002)(8936002)(7416002)(7406005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J27k7ABFtpMJ3KtOVsiokkLIvxnWTtm5y0Di0k4DoLUdmeXMus478NmDYBD1?=
 =?us-ascii?Q?T/EYFUVeRkClDP4cgxRqVslPcNnvMGP1xC3co4JJVb+upBuxL+NacUxXIHej?=
 =?us-ascii?Q?dcsSC7L0VwCcheV55q7/EdInBARWLNlul94nJoGeIt+alGc9ll1FRPVW0uFX?=
 =?us-ascii?Q?sBoJ6hrbZGc3iCsl33yguOJjGe8EStN7wPK6tAdXdbKx/QA/ZBaOBQVaXWbs?=
 =?us-ascii?Q?68itIDzoV6qwRG8M+NV/xhfyX2vleRz5PNnDZR3po7jlsZ9WdxbTNKQNpKRv?=
 =?us-ascii?Q?sKTXpyIdt10BadLtWpxReBstAEkCHMB7lGXJpoO6A/TstVohRLHBcZrczBZp?=
 =?us-ascii?Q?Yp9Y0vzbh3+5Op7qVBiHSDWzjwm12kKOmRn64WN2UthoZ4Uby52FmlzQiP8D?=
 =?us-ascii?Q?JgAq6JP6EDl8e7pkb0+idz5SxK32PwDdC7Jge+bHyZCAZY+d0hvMIGiSnEPF?=
 =?us-ascii?Q?ZvSTDWPZ6nAvgfZIBR0sLdZeMk7EekTkxxo4Q2Wj6ZA81iizD4CT9dXblw1z?=
 =?us-ascii?Q?wySgStmPM/n4SAZBEtNAGOvyrgi/yosTbNlnnMtS9P7/GESFmowXYICIdYEw?=
 =?us-ascii?Q?ryVSIjHnzRitJuVM8c3ID2iQOhThXwp7hNLJcpvQM5lh3A3qR+cTRE563yDR?=
 =?us-ascii?Q?6LLr3F2cYEhAXQd4tCfr6a/zc4R417yyEpkC84qldqfMP8acf31+WPhZWQum?=
 =?us-ascii?Q?W/0VeTg1blJX8l3Ik8zSWXSHsuTcwh89b1WqsB+VsVHLoYJw7a6Vp7GDnQjR?=
 =?us-ascii?Q?m/pqsyeQivgBa824hyXqBh6K8+uxWiOEqttfD1c+clNFAH4nHaGCRTXwZXfb?=
 =?us-ascii?Q?CBJUnDMqWFRGSQCliObf86W/oB5IgbKHetJkIq5s+WbYlZ11RM2+oegdDxc5?=
 =?us-ascii?Q?uWxFnnDSKueQ/pjf3iWplBRCDpW38bm8ynEQurpQ0W7Pzz9NM9XgCa5e+Wes?=
 =?us-ascii?Q?TereIthQ/g6c82lXelcS9j+tAHmwVu8Mk5srU1P2mWv1tT3UEkB9g2oB17jk?=
 =?us-ascii?Q?IWAbhuY+0w3h5Q50OyW+1/9SoaOk6xBNNlNiC3boggWvQn1Zgv97TmzkdgOe?=
 =?us-ascii?Q?u8FgiHCtOeNHUq5bwkNp6/ZMlDW4UdqMzhboeiaDKMdbNGQuH4MscXKiJ05P?=
 =?us-ascii?Q?g9e3AqLpWNPFbMnnJAup968KsuqgvDnKWfeAdrsEN/MzgQcfNU8IUlAEivKK?=
 =?us-ascii?Q?UmrhQLO7hxQfbubfcMAtKJAWZXEggmMmzoXDJb/gJ/yd0ml1n+Zhom9Kl1DL?=
 =?us-ascii?Q?cDG0+R3jBzdvPZqKdSEmWrY00SV+cm4BhUs0UDJN0jt5nMNUBtQqkFexjUEm?=
 =?us-ascii?Q?6iM6GYvie9RlSzDDgX0B7V8M9LCG9mbrvY8NZ5YnY699ED537N1TmzCs5WPC?=
 =?us-ascii?Q?AHHKI6jywf1/igT9OWMgAFOwO6DEHdXVKlppcl5zBTbByw+5VwOlVK/eIacw?=
 =?us-ascii?Q?7AboMtH4MZlqzMoksZsIm4NFuyqa8KpdURKsApFtVb5kK6an8pJO0RdAZP0p?=
 =?us-ascii?Q?TZf4g+JICBj6iIfGAvBGioXjr9ctkGcfJTiMSUOKG0d4XtAnGU6vQH7yEie/?=
 =?us-ascii?Q?b/WLxfYKqpHdmSc12OW7yF3ioJp+wM9fCCb9XK4W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5065df4-7476-4805-396b-08db47eae076
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 13:17:11.8164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A1SSZPTLZ/kK8TCniuCESy/6zL0PzyRvgiowiYvYBHFDO4P4EaperJaKU5oJoefm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5962
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 12:42:32AM +0100, Lorenzo Stoakes wrote:
> Writing to file-backed mappings which require folio dirty tracking using
> GUP is a fundamentally broken operation, as kernel write access to GUP
> mappings do not adhere to the semantics expected by a file system.
> 
> A GUP caller uses the direct mapping to access the folio, which does not
> cause write notify to trigger, nor does it enforce that the caller marks
> the folio dirty.
> 
> The problem arises when, after an initial write to the folio, writeback
> results in the folio being cleaned and then the caller, via the GUP
> interface, writes to the folio again.
> 
> As a result of the use of this secondary, direct, mapping to the folio no
> write notify will occur, and if the caller does mark the folio dirty, this
> will be done so unexpectedly.
> 
> For example, consider the following scenario:-
> 
> 1. A folio is written to via GUP which write-faults the memory, notifying
>    the file system and dirtying the folio.
> 2. Later, writeback is triggered, resulting in the folio being cleaned and
>    the PTE being marked read-only.
> 3. The GUP caller writes to the folio, as it is mapped read/write via the
>    direct mapping.
> 4. The GUP caller, now done with the page, unpins it and sets it dirty
>    (though it does not have to).
> 
> This results in both data being written to a folio without writenotify, and
> the folio being dirtied unexpectedly (if the caller decides to do so).
> 
> This issue was first reported by Jan Kara [1] in 2018, where the problem
> resulted in file system crashes.
> 
> This is only relevant when the mappings are file-backed and the underlying
> file system requires folio dirty tracking. File systems which do not, such
> as shmem or hugetlb, are not at risk and therefore can be written to
> without issue.
> 
> Unfortunately this limitation of GUP has been present for some time and
> requires future rework of the GUP API in order to provide correct write
> access to such mappings.
> 
> However, for the time being we introduce this check to prevent the most
> egregious case of this occurring, use of the FOLL_LONGTERM pin.
> 
> These mappings are considerably more likely to be written to after
> folios are cleaned and thus simply must not be permitted to do so.
> 
> As part of this change we separate out vma_needs_dirty_tracking() as a
> helper function to determine this which is distinct from
> vma_wants_writenotify() which is specific to determining which PTE flags to
> set.
> 
> [1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
> ---
>  include/linux/mm.h |  1 +
>  mm/gup.c           | 41 ++++++++++++++++++++++++++++++++++++++++-
>  mm/mmap.c          | 36 +++++++++++++++++++++++++++---------
>  3 files changed, 68 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
