Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8306F4A23
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjEBTIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 15:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjEBTIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 15:08:31 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF8E1FC9;
        Tue,  2 May 2023 12:07:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Au6Iu+PGkkJxFRJ5rkhCB4fvCH2A8ByDQAAyhcmxKB3BsMsk+2WPsUaa3cJKu6f8G0n9uTbgNt0bTgu7gRwJuhNfyX8spt3bTWBYs/tUjZ7f1iFw0LYcSYx7T4ryXU6x0KKQDhPPDe9RHrY1GQz7rqZdY2hJk5ZBt2jisj2L1ZNoxxO5Hpmw00AXRsv8XtTWADwebHg5fBIuYi7kC+H15SamSO+FB5GFQbugCF3zq7nIAFXt0Unn8kH+Vqa6zsHB0rVv8qxGghR89LsCJNYIo1E3hwHvTrmMNawmr+a2eR4ZMioLSpkYqnQ6TfsEHxzRKz80l9yT1jYsLtOPk3fYMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zso6nAwkfYahKIHNnfnxhgFgOBd5n36lWUYGGLjxEw8=;
 b=ekc6/fzU8V1DMgVgACVdEmIfZBLiYZ/f93n12kqIQvgNBcdxboMjbrHRKupOhhln4T0RsHjk6pT82qXSAMy3iBelrJFROPfqLOwlly7cMJ4B2Q0exIRl+gmaav/keysy5GJZ1xzM3Lh905rnEN3zbkgluuWWWrDpMLfvb521b9vtkwXbDM+nJB5oW5defUQOcpDi4EXe+b07cuhpH1oW2SnpUpfx/fhjy4QUO5b/wQW+0Hbq8cud36WrGcpyF1vu7zwQrg3dyC1sc7nLcr8zOH/lZmLeeg6xecYXgu9QCJUxLsHpTL67xVK/u1eYA9ug4+PhxuX0WARtDwtKIszfKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zso6nAwkfYahKIHNnfnxhgFgOBd5n36lWUYGGLjxEw8=;
 b=j0jufX2iB4DFlLZfA2me1bxo7RIxvd8ZVTuJPH1b9DluUkjjp7dD0uLDG7PJkCChkIgCe0z6QjhfQZ2AQhSv+xZWSjsIwKnzJW3nVr5aymOKNYRYrk0aFsmUpxc2al8OtwTTAXN88oVvS5ZBfI3jdV+SKP3Vmoiy7+W0l+iv15fqjfMTtlQdUOEHiQGql9uxAtaKyuZ2/9vHTczNZRFGN9RNzcXZ4K18AZk/SaIm8Y5w2BWi+nTPH/mI/2sW7nqUo7zkk093PeQxWuIIY/T1jkUjocjNKDdS6w9gtQ7hEyiRaN4Op6ask1GCI1eG0rnRnW16v8GW3Lf0mvP8vSOo8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6252.namprd12.prod.outlook.com (2603:10b6:930:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.27; Tue, 2 May
 2023 19:07:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 19:07:52 +0000
Date:   Tue, 2 May 2023 16:07:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
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
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFFfhhwibxHKwDbZ@nvidia.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
 <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
X-ClientProxiedBy: MN2PR19CA0024.namprd19.prod.outlook.com
 (2603:10b6:208:178::37) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: a1483502-3122-4086-8642-08db4b408710
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZtDEPeNGskBY92K+zfkWrYKXmcoup/fVXU5xNze6em4WuuazmAM4v4+bgV03W76hnsNOdRODEF7rshFTC7T9uxlkyINRpH8+n6jvrC+oTVu0Wcm+sazLVsWOBw4NuVZLRW3oDy26fMcI5OmIl7jo1VfR2s9oqV8z2VcD9x2xzRZM4YDeaOHZsCRA2Aw4ZvxIpD5SherdMbSVrekoEDPqU3ZL2odLEPrnhADDSQiPNzFzdiyYOi8AUXH/gTM4hXXtTXruLRXZyA4CsxcZKkt17W2T+PAaCO+yixjQ6txGcPISqTOIcPxWwqVzTRg76F6xvMvrxyIiA0c0qYXGVHAEHWzpxuUXbY4wcgWigBAp2uwGZclmqs5gMRm3uo+5BUkf1hKyLvVu9Lyom/2qHFsTjZKileR0H4TquuA3PrvTupyLj2ToFTmLOkwkCLhVCu7AaXWX28vttL4HwhS4VDjRl6miPQ4D73vMVLHvUEukL1PVq3VuLfVaT1Jf01DzUS5FrchuQ7HJfxjmiKrWCRUa5ghkHsDzCfIb7kC7HRP1+2jyLGhINpFdwT/iG+aYbHn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(316002)(66476007)(54906003)(66946007)(478600001)(6916009)(8936002)(7366002)(7416002)(8676002)(7406005)(41300700001)(5660300002)(38100700002)(186003)(2616005)(83380400001)(6486002)(66556008)(4326008)(6506007)(26005)(6512007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FxtfqHHSyLd9n9sc/ZWm9KftE5czF0j9kVVPaUFlyjvU7qDo2SA+XE4CLhAP?=
 =?us-ascii?Q?CV+6KfzDhH6RNKrz6svKpZybXeflf3RZgJUO5/S4y0pHobKEDZOUNf9ZSE+W?=
 =?us-ascii?Q?UgdkJxOqSXvp3m47cJLcxtC186Lo85cj0jGOU0zvNDzoaosDdRgy/LEG8yWl?=
 =?us-ascii?Q?5RAWry4NggstK926ShGkOFUIh7PqZJPgGLz8W1X2HTbH4VM0+MizVPAr3u3f?=
 =?us-ascii?Q?W5XQyU9xtnSLb7dSkDDjQqDMX7/B1aQvAol/2v1Yn9cqacQnWG4Pr66GX8x/?=
 =?us-ascii?Q?I2PI9jS4jCXEvRqXQFrEYlPuByMTlD5t21/Yh4i4iEOJFkaODrigNPhUjKlu?=
 =?us-ascii?Q?W9v/nug0sFY1pOwT2zqlBWrxUbeyB79fBXr5cgt/r8xgGxusaCSt0kJJFCqg?=
 =?us-ascii?Q?CqrPPwqGE9urJ9XTg81QgJvO9s0/MyLzwFJnPZKTKseoPtr007TWWbM+Gnn3?=
 =?us-ascii?Q?zYXuzoBvvHH84GxIXiMvqViR+lGhx7yt1hyb945YlGsO1ToXDmC4kMtbRczK?=
 =?us-ascii?Q?Q1zwDZBPTTtfHh+QGtGtMC8yL4kMDqNg8zCnUtPv0H8O6gpn9IFcG0hj1QE5?=
 =?us-ascii?Q?M/Wd3IGkyuhxoTPIBaeMgDN98Wb4U1FQTndwMPsqTi/vbc3o9DFOjJySHk6j?=
 =?us-ascii?Q?xAkgFiQkkqOIPL8Q2IhLRtAdFoXoUtse//2+s9Lo8pYrnZJZYc51GHRPVIXo?=
 =?us-ascii?Q?c46xhCUdNxC1c55vkqTEOonG46IkESOC9relWSbo85C6YIoE6tXeJyxXPZgd?=
 =?us-ascii?Q?aQqWWwrxjZTfTs/hJzETTShZ1V1V9oCrYZIwagpBaUDhfGxknsL+dsHlCh16?=
 =?us-ascii?Q?TDkbGgerNRWrMh4dW4LEhlMqkQrwXj3rZHw+Aa09QN+GJC6aCrbgiTb3BDdi?=
 =?us-ascii?Q?cExcZWYrvVejM840tvXIHqVsqJD9kU8PfeRxGdI0BkTAuqKCmJ/MbpicUteu?=
 =?us-ascii?Q?Fzi8zZZ+ynRD8MeowTlQx8Y1zDFMQRMc5lwymcad0slqFqFaa+I7j7iZLuhK?=
 =?us-ascii?Q?KV0J4PVy1oOT+4EyKifwwJhORJaFaiDAWFQ/5wKL0cBGNdrakXPHryim9UIJ?=
 =?us-ascii?Q?5QC1361+H9dPGy906q//Jp6IXUhDAV+I+GA3xN8eZYTsP9k7QKiHE0Z/qbTa?=
 =?us-ascii?Q?Cn2o263HIA70XFF2p7s1elYtrtRo7C4412jNPgW1nloElKweDQYqpctoT4rQ?=
 =?us-ascii?Q?y7/8S4ai+YJ8T6pf8ihXdNrfHBzODVw3mdS4W23JhXkgMLcAPhBUUAqwAvu4?=
 =?us-ascii?Q?vH/4C/gHjnqcO8nvGwmo7Rt2BTM6LwWhKApkm1mOuGc+iK4e4mltDYbG2ee0?=
 =?us-ascii?Q?a6g/ICwOaJT6KuJhGr3ICJJl7nXvvXeqVDNtkw8bLbu0+o3ed6lYmRq7ZJSa?=
 =?us-ascii?Q?KCGjuDGd0tmULFAlc0d9sjf16IdAXQ57p2ekmsH0toOT/2nDtgxIMBI4Mgpz?=
 =?us-ascii?Q?Uf4gkEN+ePdQ2we6z8HDDSfEKAXSmNcTiAnfVEZH4dmjBN8pO2oPaUe1NB/M?=
 =?us-ascii?Q?W8pEM9SPrGB2pudnoUK+7i9a01KhbYFnE219Sj25JGBIXPI8Sy/5nTHW8Mh/?=
 =?us-ascii?Q?xfLBnsjuoTulXFNMW1QShDIWurCF4mpq3XLv+chp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1483502-3122-4086-8642-08db4b408710
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 19:07:52.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K/s22OhUo/v6QS3aMY2yki75vXSkdrXwFlYqQUBcS4B+2FceL8MF3MzZAR0JEdS/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6252
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 07:17:14PM +0100, Lorenzo Stoakes wrote:

> On a specific point - if mapping turns out to be NULL after we confirm
> stable PTE, I'd be inclined to reject and let the slow path take care of
> it, would you agree that that's the correct approach?

I think in general if GUP fast detects any kind of race it should bail
to the slow path.

The races it tries to resolve itself should have really safe and
obvious solutions.

I think this comment is misleading:

> +	/*
> +	 * GUP-fast disables IRQs - this prevents IPIs from causing page tables
> +	 * to disappear from under us, as well as preventing RCU grace periods
> +	 * from making progress (i.e. implying rcu_read_lock()).

True, but that is not important here since we are not reading page
tables

> +	 * This means we can rely on the folio remaining stable for all
> +	 * architectures, both those that set CONFIG_MMU_GATHER_RCU_TABLE_FREE
> +	 * and those that do not.

Not really clear. We have a valid folio refcount here, that is all.

> +	 * We get the added benefit that given inodes, and thus address_space,
> +	 * objects are RCU freed, we can rely on the mapping remaining stable
> +	 * here with no risk of a truncation or similar race.

Which is the real point:

1) GUP-fast disables IRQs which means this is the same context as rcu_read_lock()
2) We have a valid ref on the folio due to normal GUP fast operation
   Thus derefing struct folio is OK
3) folio->mapping can be deref'd safely under RCU since mapping is RCU free'd
   It may be zero if we are racing a page free path
   Can it be zero for other reasons?

If it can't be zero for any other reason then go to GUP slow and let
it sort it out

Otherwise you have to treat NULL as a success.

Really what you are trying to do here is remove the folio lock which
would normally protect folio->mapping. Ie this test really boils down
to just 'folio_get_mapping_a_ops_rcu() == shmem_aops'

The hugetlb test is done on a page flag which should be stable under
the pageref.

So.. Your function really ought to be doing this logic:

        // Should be impossible for a slab page to be in a VMA
	if (unlikely(folio_test_slab(folio)))
	   return do gup slow;

	// Can a present PTE even be a swap cache?
   	if (unlikely(folio_test_swapcache(folio)))
	   return do gup slow;

	if (folio_test_hugetlb(folio))
	   return safe for fast

	// Safe without the folio lock ?
   	struct address_space *mapping = READ_ONCE(folio->mapping)
	if ((mapping & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_ANON)
	   return safe for fast
	if ((mapping & PAGE_MAPPING_FLAGS) == 0 && mapping)
	   return mapping->a_ops == shmem_aops;

        // Depends on what mapping = NULL means
	return do gup slow

Jason
