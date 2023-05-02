Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5AC6F475A
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbjEBPgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjEBPgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:36:37 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E01E7;
        Tue,  2 May 2023 08:36:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRChoImyjOEdPG0ZcK95sZqDubKWh5wHbJ9I2SUdo8l6XiwtJrVjZYeUWj8JdBRz0zBxjUIqzU4BhiB2QQPDc7E0l3c/BwnIzk43cdxr1H5M23//Eb5ILJEkWvE2A4Qy2khFv7QlDCbwH6easXG6r+ifWvNC/izJah8bOGCubbeyG5Y1bl8gUzE64hYkoPmlC1NDAOGBMwIbc9pxAv0lXCb4cHwpUEuepV2b3YLUm4DkEW7IyGzPFoDWQQvf1XKNIfYEma9ZMne82X4C+VreIftSQYuPV8lwA6Ifx+r9WCdZa1yjeTOWEOGE3PU3DNtH2ypMLEoUFPL85x/sw+Bo3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoqNzSk7Gg9ENvCVGX4lJCfE019Co1trkdH3CubFIOo=;
 b=cQmP7lJT/FG0aAc4KVgmNmFRRyx+d1+AjgVN8psho3qkZy+EJhlX+Ai1aB/QED/Fdo4lBg3oYGL3J5AI0MJx6r+BYpA7w/7XKJbx3JDD7aspMISXyNR4O6SRv6ZpwqnU8mjEnyr+d/qbWB5l2gaiOZzEemzwcScSzlZVBRwaG/FIp2sZQh17Nk+kbjr4CuiFP5T2KDonYnFKGpnU96n0dM0VZPzCu7VXYA4fQ9Sbn2fc9MsAUfQkLtHn6tzOxO+V/SO3bC0aqHFoiCOj+4cXJirgBGtnX0zQApyan+jc/04CdKkqirNO0n8I9fAr3vXEAxqovrE8VQhmJlCnNHazoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eoqNzSk7Gg9ENvCVGX4lJCfE019Co1trkdH3CubFIOo=;
 b=g4MxU750GMU4IkEQKb2dFVEOjQSPJaGTSv2hvTVbXY//WTPQuDUegyFpflXV54OwWfsZkzZ6syKo3QHmNKdYjWlHMlVibt4Fy70ybc8qIKPvmh7Odsk+Lh1kJsMDpOtjVR6/YvOXbV5YpnkIfPg2OIwyl6KR4VL/OMI4yGqHbfYOo80fsjtPpak0ikH/jmNNfHYqdN+JSUwjXkrCW5MUeCRkO6GfBiMWGQsuKqgMNtugk8MaxHn1uDX+riFoDYE8+K6YJS3ysR8qcFFPMroBnlkoJMcj4FXZhQxsfVL7UDbFiPXAIpslpITUgtFmBxXZfnfA3CibaO8ZrGkdHzPlrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 15:36:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 15:36:32 +0000
Date:   Tue, 2 May 2023 12:36:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
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
Message-ID: <ZFEt/ot6VKOgW1mT@nvidia.com>
References: <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
 <ZFEYblElll3pWtn5@nvidia.com>
 <f0acd8e4-8df8-dfae-b6b2-30eea3b14609@redhat.com>
 <3c17e07a-a7f9-18fc-fa99-fa55a5920803@linux.ibm.com>
 <ZFEqTo+l/S8IkBQm@nvidia.com>
 <ZFEtKe/XcnC++ACZ@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFEtKe/XcnC++ACZ@x1n>
X-ClientProxiedBy: MN2PR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:208:fc::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eae0ddd-3e96-47c6-cd7d-08db4b230138
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtkzqBbvcR6dLa0XCP881ARm451Yc29PzBVIa0dBHsroM527rsepfKMKZ/k7B7aeJhVhxhpphiKoQsml8pa+hdYnhskEVLtgUjJZfJddFgBDQY+Bd41FUwSM1ZBVGjvfG5ZenuBfMPpPM3I//mVLswXmTk5nEckFnidN3kolxlnFJZ4EQyIxvcyYLUTT59SNUgmrRMOxZDLUhKnUB5fDuon81yMuqlHz6euWSDAyj1KyRiXYKTLZPW5qz743GyBgj7bguBgcZ7CyDwn0XwqHmt/LvDSkh3qLgumf6VIH1phsTHYfL77a81+fJL78rVUo2A8YFeXYzs32p1mJRJ5cet7h71PH/pBFAdwP9osWl/gGZtJMR0m+4f++cfHgTpvbovP2g7TNnlvyYNm9Z0xBxlerk5aQgCtODPkQzFbpTigJV+Z/ggU4JnhJn/Wr/JeO1/TKHliRGd2oWGFmrE650Jeuggoc1Kh2A/vk1a+sPwXDqrqOzcRGc6Rm4GQapvkzITgqaoOwXr8820lmBNDzYQS83U6Gkts10ZAV3HmsxJ2sKOVV3LL/xtBnDSVqUbyw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199021)(6486002)(186003)(83380400001)(6506007)(6512007)(26005)(2616005)(36756003)(478600001)(54906003)(66899021)(4326008)(6916009)(66476007)(66556008)(66946007)(316002)(41300700001)(38100700002)(8936002)(8676002)(5660300002)(7406005)(7416002)(4744005)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fGXI12B6+S9ZAnArC2w/Rq2WAs4lKdmNmemzVSFduEtqSAlM2N2lM8UHq4VL?=
 =?us-ascii?Q?JBoFaeHeGkH+wEB5AlgbjxFFDDLan2q4XOlWD//BzrxOA8Y04IH47otWmbza?=
 =?us-ascii?Q?6/qZBRKMNvAB4P7uq4gJUabb8TGGAdwWzdgVsKKIovLwzFGldydFrLT4+3AO?=
 =?us-ascii?Q?cI1yvvJFjZcMyZZp26v52Ql6f9YZK6uSUtq5TNrCryNbp4G1xss9h/prxkb6?=
 =?us-ascii?Q?jSWKUDkNP8/2TfTI4wgFIkF6TWUuX2wJJtbVPemzftoLSWVBz+0WnWjN49PH?=
 =?us-ascii?Q?C7yDb6GRreb3TgxoZQAsBBmeVSDe+hjjao+FCuApr5QwfnoOzJlY9PSC79cV?=
 =?us-ascii?Q?mZgvYMPs7iubUnALOB1qkkee+Xo/khZ9rqeKlqgNHp+ML3lAfGLiJP41siVT?=
 =?us-ascii?Q?B91Zis/FMsu1WlrzE90ZiW7qOLVuDMBc+t8lNywG4QKeiYmrHfuVsjhAgyyl?=
 =?us-ascii?Q?ryK5VbAmhZb0ru0gZklvdmg7dXBHjO07bM7GWyV+MYxFt1bT5XIsNiHQ613r?=
 =?us-ascii?Q?WSvljfUYuAwCf79COAJZURhYH3GsfGx7FWY30cv7vMDt4nvunns8JU68C5Od?=
 =?us-ascii?Q?a+eRHw9/29ks7k4JXfN14k3hhM1bFGFrT/P+o6pP1ECSg3pHHgFOGkLP7Cir?=
 =?us-ascii?Q?s4Mw1d92+Oms82b9t8/QvYaGskwEGJP7Elz1rgDge1MygXDX3tUJ1DykxcB7?=
 =?us-ascii?Q?UUlxhj8iFxf6HdIdkizQwl144AtycGB7z2JBj5IZ5Q8Rd8HzMtYU8ZZG+sf5?=
 =?us-ascii?Q?TLtV/dm3KeyDDby4hKQIIICmwjY7hSXbZW1k88xucRieijNtUFtFFeUltK97?=
 =?us-ascii?Q?AmwjA/W5sOeYSxrJG9aNlkjhst5LgwKfj8aK3w8P/YRxP/WSFqXoj+lPsN31?=
 =?us-ascii?Q?2Wyj53kc5j0W1P4K+5LxMaNzfoEK1tFLnynCCCvLlXeX5ueFVNToVB0UGYzC?=
 =?us-ascii?Q?YmQU+HOoQUofkvhip112AavX2/6aejuGLXbphVC8kT++XUXMfv72t3z+e2YT?=
 =?us-ascii?Q?tU8bJFFV8QaiZOQVYfYvHR3lUCDmkV/xtoevj4vXgdJaVwZeRDaWtnkNFJD+?=
 =?us-ascii?Q?VPpkFNJmhdregZFNmhFyz3b789IlqbaGvqbeLJP2QHzAlYzuxk7l0KybKshd?=
 =?us-ascii?Q?AMyJgHomEyKQKZhrVfR70rhyJ2cvCo9pLsbOh46yb2sgdv5JjKkvS8Qckb5B?=
 =?us-ascii?Q?4VKcWZCDV9+0k9QwiA/WHj3J2mCn857mYdZCsKU3fRaN/JZoH60qJy8rcQRS?=
 =?us-ascii?Q?xeZcHt4gDx12GW4F2kh5h1HXyHDh1IfvkZeXX2K2aeImujlW/bfMUfzTpKBg?=
 =?us-ascii?Q?h2wrujXvq6H8Uv0cnbFVHxFg5SnzB/R2j/oUwEV2vedstMj0bPrZZ294iDap?=
 =?us-ascii?Q?TVA2maRY3YP7Du66YWVYk9GlKnl5I33jPiI8cWjAZ9sbGvxt/sDgdIZgJmz7?=
 =?us-ascii?Q?t+5R7qZ03Ik0sEqFNs3VhgmragsjbOfaid9K2sZKTWlKTcIMQJshX66oUBS7?=
 =?us-ascii?Q?Tk3DE6p+fnkyt8txPaLeEo8j1lNaAWKtf0KycMb4UlrKEwgJsZLS5jYSL8Bs?=
 =?us-ascii?Q?1tz9C5b9aEWtLRNLLUH74hndoUDlyY4mr2ro+1PD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eae0ddd-3e96-47c6-cd7d-08db4b230138
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 15:36:32.2493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SasMgi7G1rUQs1sIkVlh5vRbBa7ySTkvGGHeZtO7rka+wwql43r5M6iu7ZuIMpYD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 11:32:57AM -0400, Peter Xu wrote:
> > How does s390 avoid mmu notifiers without having lots of problems?? It
> > is not really optional to hook the invalidations if you need to build
> > a shadow page table..
> 
> Totally no idea on s390 details, but.. per my read above, if the firmware
> needs to make sure the page is always available (so no way to fault it in
> on demand), which means a longterm pinning seems appropriate here.
> 
> Then if pinned a must, there's no need for mmu notifiers (as the page will
> simply not be invalidated anyway)?

And what if someone deliberately changes the mapping?  memory hotplug
in the VM, or whatever?

We have ways to deal with this class of stuff in kvm and in
iommufd/vfio - this does not.

Jason
