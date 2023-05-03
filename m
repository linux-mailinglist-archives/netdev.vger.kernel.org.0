Return-Path: <netdev+bounces-44-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3F9B6F4E1B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 02:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9B541C209D3
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 00:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF5D64A;
	Wed,  3 May 2023 00:22:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A37C
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 00:22:58 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E909710E3;
	Tue,  2 May 2023 17:22:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqBIOxtUDFHev3gTO8A3nV4lIye3BJBdhpmu0IoRjhw8fzVkUmE6+D3M3X29ioBlkcjJzHX5JoNDsrpWVXiggkBIR47zZBURcHpVWiCeFKq9ufH9au2IfZ9FDFvGzVzKsWxScCygglO60VleS7O62vro/0URzdYaP43+X8tum48xQdRdaU5k9ldXgVWBG4OYGpu21MmMHg9L+0vMlQg9KkmnyhFdQchJAlU/o3ka2BfjT5bMi8St8K5tbpUPb8PtBB3pKyeUsfCkdF42h8a8yp9c0yhuMlijHIYM2zI0jOjeuirQNgKaICOKV+P3TEmODS6ZFCmcTAw+tcj/zwFJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFtEgonXmXxlxN7z6GpX+BzZHLM0EWGeyG4LVPEbNpQ=;
 b=RmFsjlMrFOV3yatTOm4utpaTjFr5rd32AW1tdLZsJxF8no576bn4lbnGc2ul/M4O/6k/4FqYcVDdu4gdRWUdmlJj1Lpg3dVi6yCf69OC4bdHny69iqgWHOb/DjeBfbpL1tbnmmRBp3hjZstEOYj4d1sJHkvnI7Crvv/Zc5xgP6gS2UGLRNA9VQG16VgvI7yNW05fzZgNjsES2kQ65pwfhnbB/qzYVH691Giy30LJYRRJkoiOdn3Cecoc92J9hDL21q5gIa01UKegjifQeE1EXh3U/yu4m9QDd2+2uaUhm7oX1hIO5xkB5mfZT1zK1fewxOjpaUBuCUF+yG5GKYBA8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFtEgonXmXxlxN7z6GpX+BzZHLM0EWGeyG4LVPEbNpQ=;
 b=I1oix9VKLtIbIcDEeJmU9ogA03S2dRSB4gEj+BXVX0OM0qNSGgc2UzNikCVJk1FJCtlnpa6qyrEs9KN2qFL2znfETcNR1Jm4Latb40kFAuVgm5cGdxxhf3K8FEYP2bYmJXs9M52/kOrb5GdlYB5lihZc2fN0XqAR3C4T5Tt0qHMi+ezZhCAB0W9HLZiA0Ebl1BwEW+HrdKbzd9PXTJSUZzLSd1q7F7Nd2i6K9GpaAYcUOaBoiEe/3cRhvZ6KSbk++VK2h5lN7iYpo7YsqgnrEjrv3S7t4zwu0MZyxXv+We+wJ1Yi7GRwkz6UwYq78N/+uwq0Gf8rONNiIPPS2XBpMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7281.namprd12.prod.outlook.com (2603:10b6:510:208::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Wed, 3 May
 2023 00:22:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Wed, 3 May 2023
 00:22:53 +0000
Date: Tue, 2 May 2023 21:22:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: David Hildenbrand <david@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Christian Benvenuti <benve@cisco.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Bjorn Topel <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
	netdev@vger.kernel.org, bpf@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Jan Kara <jack@suse.cz>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v7 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFGpXOWzgMifZpaJ@nvidia.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
 <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
 <ZFFfhhwibxHKwDbZ@nvidia.com>
 <968fa174-6720-4adf-9107-c777ee0d8da4@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <968fa174-6720-4adf-9107-c777ee0d8da4@lucifer.local>
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7281:EE_
X-MS-Office365-Filtering-Correlation-Id: ea6e30c0-a7da-4e79-7758-08db4b6c88e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	W4lVW67PF4e7R/fks303MA5TMNSZoSYuaO5YnS/8FM/4xt1w/QbjjBP9kwTRrLY+IWvMqO8SsYi9S1TvNoEAVphDX4JlP7fkU+FWrs8F3iTb8puaVeMiX6/zY/hh3MGFHo89yOeO/jf1goQ66+FP2GWbGhu037XwfM9jbuW2dOZKJLbc4RPc9fbnvq+7DsYFdM0xQW+6JkqFO739IxAS79vfFvJu0FUGHq+DzjDk4hL89hXO5003EUSO9j7OQTaJBmWCKIIPCZKxjZ+eI/1lx6vLXYZ2PDEuHKFfup315MkkUGTJVvpfLqosaRfx1U0Sep1nXwbg8miZRS6w0IILrNSOne6I3ZLLEul/rC44tei0zlO7ouuTIF1edq/iSiJN/L2LSfLDrPSzVT3aNXpMYvHkKbYj/+VBY99s8FzHFbe1SyEMJSaIrTl4QcZTbM44B6FaYjfertGS/aLkFWDTM6iqvQlGc4YVzG+p1O3nAcUeztl1ABRSSWa7QTa1qrc/jc6D8za3zVy3hu2PM/TMa5P+ZhXaiaJpZIliUNDkWNdyLoXAjTeLkTnOHKM+Hbbh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(7416002)(7406005)(5660300002)(7366002)(86362001)(2616005)(83380400001)(6506007)(26005)(186003)(6512007)(38100700002)(8676002)(8936002)(41300700001)(478600001)(54906003)(6486002)(316002)(6916009)(4326008)(36756003)(66946007)(66556008)(66476007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LHMnBbWudC/3yu9M6VZzgxkWdLtddNdhxjLnmF48b1Vv26JtoSvk8r7saTAf?=
 =?us-ascii?Q?aT+57Kz3ecuGWUqpz2TVZmrgcCXYI4Wvf1flRP4CWFIHbLxwVgbUr7qQpMEX?=
 =?us-ascii?Q?4/8JRawG1Rfhdpc4exyiRHFiMZSSeXkQZNXXxrJ6ouyeFOatgvgXUIQZg1R3?=
 =?us-ascii?Q?MAvUBkCmJaRH445o426PQ+/F4qVmWwwHdUZLKAZatE/g9QgByjq2+kkeJKhR?=
 =?us-ascii?Q?c4A/R7MfXvHl/mLMiTLIwz7nzzK9lZ6vag+v9C8i1VDLGXjDcSWD9lxe5+h2?=
 =?us-ascii?Q?34fmJ+DmFiOmCjdN/WvRffXkcE9CgOorvDU88MQYfjkaKvIBFvQdwalauAZW?=
 =?us-ascii?Q?VaxehGgckEMALdg9igG29BS/RuGKAafnME/5Z8LwsEPrf6VV1/i9BnFwO8vh?=
 =?us-ascii?Q?sjhdsP50LZB/HfyW6+ZCZ/OLJYMPZoSW172jLU+HF5KKWNxrMqJy7pz/lfcA?=
 =?us-ascii?Q?DwKVNGF6GKUQZ+ordpg9xGhXHV4EyKHcnwxNE+SIahj/6dsJ0AN5cQxtVE+C?=
 =?us-ascii?Q?4uHTTcYIVZp1gMLe2fw9sL6Zv8Q/1QdJ/LXiRtohiGTP0TmReIiYhSo01EO+?=
 =?us-ascii?Q?/RczQRHHiw/ya/7Iuvapkq7xcyepXlk9oo3m8xZj4t/NBiMCclk66rKs+CTk?=
 =?us-ascii?Q?qA0p2n+g4IvYPGvZmvT11J9EiEyksFmL9eAUi1TN7Lt3ify9zPbe6oriqxR5?=
 =?us-ascii?Q?KH2cXP5UY8zfY520hs3mRGYj/7hKNX3kRo7zdbORF52mbz65ajb8/WoVJSG5?=
 =?us-ascii?Q?qfy1lF3nrS3od1ZzFIQCB5a/FKwOlYWdvPbj6dQbZF+cGwKAeix5RePJpL+X?=
 =?us-ascii?Q?ZX1faW+8ula9ojSM4GYtyT3iHPBvzQFMT80HYdoQ+EEMCVapGQcOC2laVGb2?=
 =?us-ascii?Q?GsK+BA60d3ZlUS3dQ2UrsrLCv6KLlpVaQFuYm82pdKpDIknXI3a82rQeFJNb?=
 =?us-ascii?Q?W3kOIRr4nW5znvkV5m6rC1Q7SaIO5AY+aZQr2erXZygPlIZBk5fMzluh8An3?=
 =?us-ascii?Q?rzx0IwoTNl5QCz8pa7ZMZnNpciph28TOWU9RkaKlKIG/OIBegABViueio2G+?=
 =?us-ascii?Q?N5g5daiuf/DXgHFMqsMh6oE+DV7EZWph4zTA7g+ucDu8raLkFz8vInfMy6Qr?=
 =?us-ascii?Q?ZymLBCU1tsH9Dx/CNDnM9rYf7YG0gNZ+LUbXZWZyQMhDxNmCh+BKKUAMu0je?=
 =?us-ascii?Q?OIyPwAh72IPiS/m4j1PvyfoAaSXzKgxgQDqzkW8DIju6ZffzuvSR7cmMrS4D?=
 =?us-ascii?Q?kjVzS1xmtyxyBwZR6sKEMavCTfAiLRupoiN/bRQ9tUzt3jw+Uy/nFDaEi/lA?=
 =?us-ascii?Q?y9Kf/0i8sM3DhZXhRvXeovyNVdJfWzsISVKDf+Y9IKFpd5fC6J2hGg88OAMb?=
 =?us-ascii?Q?xPXg8KFzIt06tPjdqpCO4vTzEXt5jdRv3exWlRQlnVWqWvxKp+l6VhTntMCF?=
 =?us-ascii?Q?eBhvA5mqem4m5IAT6zDqhsDL1IwX5du4tG1rDox4qJKV+K3kghwt6Ft8QVw6?=
 =?us-ascii?Q?U756Od85TedjKuRIR8rb6qtNVeIYsXDHnOibVxsHdHK7xiVrvsSoogwHxLIy?=
 =?us-ascii?Q?2odiLNvAzYq4MZqSlE6608VzLcFstL3z+h6Zhvk5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea6e30c0-a7da-4e79-7758-08db4b6c88e8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 00:22:53.0880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xil1LJrAYpp51sIyeF4aEqz99k0dsg3xorbGWj41cVWAF7II2INhzlBIIFLUWo9E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7281
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 08:25:57PM +0100, Lorenzo Stoakes wrote:

> Otherwise, I'm a bit uncertain actually as to how we can get to the point
> where the folio->mapping is being manipulated. Is this why?

On RCU architectures another thread zap's the PTEs and proceeds to
teardown and free the page. Part of that is clearing folio->mapping
under the folio lock.

The IPI approach would not get there, but we can't think in terms of
IPI since we have RCU architectures.

> In any case, I will try to clarify these, I do agree the _key_ point is
> that we can rely on safely derefing the mapping, at least READ_ONCE()'d, as
> use-after-free or dereffing garbage is the fear here.

I didn't chase it down, but as long as folio->mapping is always set to
something that is RCU free'd then this would be OK.
 
> Well that was literally the question :) and I've got somewhat contradictory
> feedback. My instinct aligns with yours in that, just fallback to slow
> path, so that's what I'll do. But just wanted to confirm.

I don't know it well enough to say, it looks like folio->mapping is
almost always set to something from what I can see.. At least NULL
pointer and the anon bits set for instance.

In any case fall back to fast is always safe, I'd just go to the
trouble to check with testing that in normal process cases we don't
hit it.

> The READ_ONCE() approach is precisely how I wanted to do it in thet first
> instance, but feared feedback about duplication and wondered if it made
> much difference, but now it's clear this is ther ight way.

The duplication is bad, and maybe we need more functions to counter
it, but GUP needs to know some of the details a little more, eg a NULL
return from folio_mapping() could inidicate the anon bits being set
which should not flow down to slow.

Jason

