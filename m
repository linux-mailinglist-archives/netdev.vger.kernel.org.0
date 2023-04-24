Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D0C6ED4E0
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjDXSy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjDXSy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:54:56 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4CE8F;
        Mon, 24 Apr 2023 11:54:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEe5aFltVsp2COL1K0EkADI5g9ugkr3YTXgoc07Jxeke6VtyijF47QLDVCwZ9Et4q8dUwDEtRNQIqUyHB3d9ezr/CF+2MGNnFKm5afhMes/DAUc90R7c5tuffL8XuYC9XC8omGi/QSe3uvMVwn6kcupjTom7gz2vCb3ZXM7kaXlhl6GOgVRXBo/98vr8L+kfgkOA0G8kL0eo+hHkG2fNQh43jPett1GLq3o5R/JwWUdg5Pw8QkfRdeTRmbTjLLpHU/X3sdP6p+tbf7B5eazwKdU7tGVkp1HvP/LnqIzB1a6IabeCCtOn0NK+TcG+FXmgksS18wAB9sjv01HaSsDjgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pQa4whavOwoZPSDdx4Xp+6qjNXFXSS2p7+NybRM4NI=;
 b=dliudlGwFoop2zTGnqFhuJZtXIhnLJTx7huzhID0rhtxoLhk4704wNVXQUwD7V+ZeqFHzHN/TFlgjE/HLcrtZ0VKPdbKx5NLogCcZrJOZb4je17sEr7AJfiMZGGaUWj7tY1DYPGtFugfX8lM2qhBKjQkYpjcaUKHoSN6jWfHbR8zTMlvcSsb+kSQkUd3wtRVltM5CMXZ9ZyPNCdd//fvjwrgU6rbBXjd00W6ntFjwShszCyGjOdtihkQ6Ox0bUsvEWmjuCwCJNsTwwDynjZiVHEeQTETVhJVfuIRO0PLvm6T4M3Rk3X7RXi8J+fw0OHa3uEN2yQE3hrdOyP4qqoCwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pQa4whavOwoZPSDdx4Xp+6qjNXFXSS2p7+NybRM4NI=;
 b=ETkHU9iWp3DNqSFPoJziaAF6jJd0YIoLhtJHCrPQoUfgLDEkFwrKc6/UB6BotLCzRt19928Y77jI2BNGg3FQM5mN7EaCGPD2RtW0F8cuhroBuMXwzP935ldb5ZfmcB72DCUJv34GPKRQJwc0FEvBmGxFEAbdvLWJ8MF8SQkP6vKenz3koD9pj7/2TmGwYCvXf8pV6AJwavIgPdbLgXagZi9mJKENzIXbm75ePk8IteEsvg7OZY6SPKezDT3qsb0jEXyISLMbZpWn8/PVorXrddzq8zT/px9IvZYY+Jsxjjzp5mssbE1QzsLE+N8w8ZxjUap+9IJCXVSnnIIhw83VZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7319.namprd12.prod.outlook.com (2603:10b6:806:2b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Mon, 24 Apr
 2023 18:54:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 18:54:52 +0000
Date:   Mon, 24 Apr 2023 15:54:48 -0300
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
Message-ID: <ZEbQeImOiaXrydBE@nvidia.com>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
 <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
 <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
X-ClientProxiedBy: BYAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::48) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a35ea9e-a4c2-45ef-d7c8-08db44f562b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tye3Rymzx19k52M7QztE/t1c5gy5TizJHATpSF7nd4vv+ziMEV8/Lxm+K8nbWtSU8j1JPPoVcbE/8NlWZk07T3qWPWXKhPr1Ca5KY8WV3IMYK1tBCtMDSkO0HL0BrPtc0JzfF+ihDjHpfFKSLy04TTGzJq7jMd5lovyTPQk6yBmlujumYy5T8TbuvcXjNesJyjjK7xueFgKqTj0dmfdw3RX44y5I49E/q1DCFW/ZBecYhCopXR1t37E9LvqFO0iA+pFQqrA9Hu/D3iULxS3R3KcPY02dJliRBspGoLj4fDsqWf89jDOVeLkyWN7JnCjBLY9ex/T4+JNWxCytQpSWy3t4T404AFF9evISarWSG9AgppXhoJsprNu/Z9y98PBjhGhFLZEyX58vpyZRN2hPWm5f5LSHy9Zoqtr9jNrrmqgqgBj5DRVsFVQJRdVfR01BSJZh2MPUxFIHMGITRJV7tVrzWs4nzyJ/tUwBKsq9xLRfVZWmCl6/sKcyJ/SUFOhnNfy4LsqJ9sHWSsLRVor+kNQd7WZJTV8bt5qSXPQ4bjhzYmBtW3awXm1AsrptLK4q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(5660300002)(7416002)(54906003)(7406005)(478600001)(8676002)(8936002)(86362001)(38100700002)(2906002)(316002)(6666004)(66946007)(6486002)(6916009)(41300700001)(4326008)(66556008)(66476007)(6506007)(6512007)(26005)(186003)(2616005)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+1apgD1K7jIYt83DaeH2MqgglOy2Q/TnaTwXek35RSGUKWKuIVaKKGPSqSkb?=
 =?us-ascii?Q?sSgYOll1R+xCOMkmbSMEbXgLFHKO5+BMD1Oh/+UkFAoZYXUFy1RdkEM6onof?=
 =?us-ascii?Q?kPePq2sm7wElYKrwfrMLokj8Bjh5IY33wNex9SjoxsH1WsUFhojMh8B1ry5X?=
 =?us-ascii?Q?KBPRuOTTomFbztjGgzQ0iG5nA+6vFuPEMZWCm5e/mrWwio88cFqdx8JF8aDr?=
 =?us-ascii?Q?b9aSGWXUoMthfyzHSHV67aQpMsI184vF+MGma56ssfLfkwF+YxudDBi8Cka4?=
 =?us-ascii?Q?y7l0drysOnX2JJg0KYc+DfNyn4/MBnD4Bwmt8biDTQiqHkDFP3AmpbhzU2L5?=
 =?us-ascii?Q?kDaHlsYU1oItUClKAU5eZZUCvxFksctCdEtu32E9YhLCBiWAva0Qm3QLYUtI?=
 =?us-ascii?Q?h5UcSVUT0IrO7eWkvtBe095rBox6F5mQ7ihQzFrWpI5GC3bU3m8IRIOoCmcm?=
 =?us-ascii?Q?kMPsGYlmBXVBUSEfGFgLJX2drvTXVCaXqplIdw5kWZ4s3vzM4ODgbOoh1XD5?=
 =?us-ascii?Q?U1fxNLsjqW7yiWWHWGdH2safVUBbqq4xYvT8c9qaoG+hX2MUJPgW+hnlxY0n?=
 =?us-ascii?Q?FxVu9hxrhHldduStoxLwUc7FuDtUUFANxgJQq90HJ8P9EDKwx2ldiIkbjmLO?=
 =?us-ascii?Q?bqcl/xduoPlQcjHrJOxxb0xKYAqDFevxHMq14VtYdgN+0nsB8Wq6UQ9asirp?=
 =?us-ascii?Q?G6AKFQvYBGknGyYLI2dFr5EClFDNiqF5tdaFnJrcoFwOuTo0zag1162qNZ01?=
 =?us-ascii?Q?ACWuKwDAPzZQhddeiJgz6giag00L8ooCMA2e/jez9dn+fUy9x29ewRtsB7qw?=
 =?us-ascii?Q?YyzAFfgLPpfbdMFoV/QWsg89FisD1PJB/X5BHWlFfK3honLhOxvl4gWq8wCE?=
 =?us-ascii?Q?t/q4JgAawPxr4JeVCU0Ghx/jMhl+zqs5YdwjCrqHYx3qEMV76F+D9iOOhjjW?=
 =?us-ascii?Q?WvipkxAIeEreF7gNXko4aAmWnI4q0a5g4pSOzq5KZX92XNk23FbgcMlBQZGt?=
 =?us-ascii?Q?VFmRqWQqyPqIBsbuXxAHbvK2uPDAtN6W4lbQMpw1P0jXoAdoRrg3LrhdBMda?=
 =?us-ascii?Q?4+VZOdblNWD9kPgiF8wksn38B0zQfp775wsxL2SoOfIuYRYgNPLGLOw/liPy?=
 =?us-ascii?Q?lUaeBIBnC+phjgWxcjy25JP+gC+AiwWIIUzagVoud9qig3nkB/yaVdd6idMg?=
 =?us-ascii?Q?GtPXiOE1nHiAOwXGat9cUFRHNM6w2sF1wnAF4W6901SYYPk5Cr8Z+Zy7zS+V?=
 =?us-ascii?Q?JM0oRS66XW9Xna8JB+bKuzGIJAjcvZSujoQLTdWJiGwh4kQ8gcx1kRNJMzJA?=
 =?us-ascii?Q?0if7o0ZaUXVmDxnyRWaDYwdLYwJ8+D5X0AqPrC1aOYBAHm7gUDR4Xet6MNTf?=
 =?us-ascii?Q?dROaEc5Nc81KKldPWt04t2C/+fDMzMjtoXHvCpZg3rI0g9dhlich6jsbzwTd?=
 =?us-ascii?Q?Gof5wB5hdwbT0STfUDXisQuJyjGH164aoNvkGXwYDVjLaC/W+eEEbsujjpfy?=
 =?us-ascii?Q?0t1bfFd5Bj2iXaWPZBOzEwaOlaFFO12yVB89DwZdGOfhWUFfGhta4X+wr51M?=
 =?us-ascii?Q?Jbzd5OXvi7alYzBFUbTNvt/5E+Ha3TuM0Rb1YwfX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a35ea9e-a4c2-45ef-d7c8-08db44f562b8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 18:54:51.8841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dLmUrYCJVqEh+V5g5yCzgAdGd6rbJMDTUkGITinp6FFj9D4YdrUDJWDaeO1nANDo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7319
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 07:22:03PM +0100, Lorenzo Stoakes wrote:

> OK I guess you mean the folio lock :) Well there is
> unpin_user_pages_dirty_lock() and unpin_user_page_range_dirty_lock() and
> also set_page_dirty_lock() (used by __access_remote_vm()) which should
> avoid this.

It has been a while, but IIRC, these are all basically racy, the
comment in front of set_page_dirty_lock() even says it is racy..

The race is that a FS cleans a page and thinks it cannot become dirty,
and then it becomes dirty - and all variations of that..

Looking around a bit, I suppose what I'd expect to see is a sequence
sort of like what do_page_mkwrite() does:

        /* Synchronize with the FS and get the page locked */
     	ret = vmf->vma->vm_ops->page_mkwrite(vmf);
	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
		return ret;
	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
		lock_page(page);
		if (!page->mapping) {
			unlock_page(page);
			return 0; /* retry */
		}
		ret |= VM_FAULT_LOCKED;
	} else
		VM_BUG_ON_PAGE(!PageLocked(page), page);

	/* Write to the page with the CPU */
	va = kmap_local_atomic(page);
	memcpy(va, ....);
	kunmap_local_atomic(page);

	/* Tell the FS and unlock it. */
	set_page_dirty(page);	
	unlock_page(page);

I don't know if this is is exactly right, but it seems closerish

So maybe some kind of GUP interfaces that returns single locked pages
is the right direction? IDK

Or maybe we just need to make a memcpy primitive that works while
holding the PTLs?

> We definitely need to keep ptrace and /proc/$pid/mem functioning correctly,
> and I given the privilege levels required I don't think there's a security
> issue there?

Even root is not allowed to trigger data corruption or oops inside the
kernel.

Jason
