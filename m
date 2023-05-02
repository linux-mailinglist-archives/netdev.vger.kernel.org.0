Return-Path: <netdev+bounces-43-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2236F4DD6
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 01:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B60A61C209C2
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:51:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA066BA35;
	Tue,  2 May 2023 23:51:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D799456
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 23:51:28 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF4D2680;
	Tue,  2 May 2023 16:51:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LG6mwrumHQj+Bf0zmWNqG59Dtz1FCEzssNtx5Rb2bTQp3c18jLaVBzne+1uF9RpwmMk9ehurUH0/GD6brKt9vZpc0VcRtYexHhNdjAboxhlkTC5w/aOfYetzZ68u01QK5lYgUS5IKXMYj/ZxtGw6mW9VwyrKrrgN8UV8WgZSNZTaFfjVX/Y2Uyx4lHmqJ8qhone9lJavXxkMr/ALruERDaGIV2MV0VulMDxMhdh7f48+NldNx0BfZWbSRymM6D4/SQnnkfZ0PHyBFU2r18hJMTt9LRnmG3J+vfVN9I6dsYP0N+k49knVH3PrJSkKr4/eQCL2RIAeG2Eti8St/pSyJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tI42fWb7O4ZBTxRJZJlh7kTTKnisXbwi27yeiNFo8LA=;
 b=RNdYgPGVr0nsa87dqzPNNm9GpCW2GNDxFQt4vSgmr+OqhzDwvoIPzuM5lQkuDOmZIJ8Xj/Ui/AuTgqp2mE3HUvP+1DGWJtzh/agG93z7Xo7AnWSvtNqXTA5ukSYGSTy3SHKgjkF703YHmEFRnkDO2MefvuAPhSl80y6lWfrwZhw0M6R15PfznC0NcLIeYkpT2UJC/pS2fhcOsEgvEzzcrjr4kX9XCjNwTULT1u091t18GRdfMsXDRo8x01Bv1cjOpEcjImmkulidOkzjia4VKbUrSmpEaKUi/pulRdRIa0bcx6nRD+YPc18HhbGnUY7RkbQLlubzFJImJud3NwFK4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tI42fWb7O4ZBTxRJZJlh7kTTKnisXbwi27yeiNFo8LA=;
 b=l43iKISvKNolPDilldlaBfjMhRgeYo1sUMGloBWb2jJ8rgCBu8WwCGv1Dv6NMOrhHpLJqrYXmJ1ioHLOImq45ofru5Qh1KoK8uUvqsxYlkc5g7Xs2pfLtvhw4STuo8EGl7DtE+Rc3y0Gks/Q0OH0ucLtVOXRTCjMM3oebxYrm0XoWM2P9U5d9zg7t+0TVBYFPQEFhnXVAI6ueaXoUH/C2yZXo/AcC7hGu9n9SYmpuVT+N79hAiztyHB2qGK+Z+mtJxGwCt6ukM5Om2MBWxNA50n5tduUrVCKRVqnvWgfXQ1F0/ebdaTU9eFoOigCdRewr2coZtO7onMLdcP0AcOyMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB5678.namprd12.prod.outlook.com (2603:10b6:510:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 23:51:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 23:51:22 +0000
Date: Tue, 2 May 2023 20:51:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>,
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
Message-ID: <ZFGh+UUd3IMZk0lb@nvidia.com>
References: <cover.1683044162.git.lstoakes@gmail.com>
 <b3a4441cade9770e00d24f5ecb75c8f4481785a4.1683044162.git.lstoakes@gmail.com>
 <1691115d-dba4-636b-d736-6a20359a67c3@redhat.com>
 <20230502172231.GH1597538@hirez.programming.kicks-ass.net>
 <406fd43a-a051-5fbe-6f66-a43f5e7e7573@redhat.com>
 <3a8c672d-4e6c-4705-9d6c-509d3733eb05@lucifer.local>
 <ZFFfhhwibxHKwDbZ@nvidia.com>
 <968fa174-6720-4adf-9107-c777ee0d8da4@lucifer.local>
 <434c60e6-7ac4-229b-5db0-5175afbcfff5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434c60e6-7ac4-229b-5db0-5175afbcfff5@redhat.com>
X-ClientProxiedBy: BL1P223CA0026.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: de5280dd-ad55-467c-777c-08db4b68221a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KuFmLIVn0IREZRn2rAiY9vWLth01bRLoQaZJmWv2v+kqowi8mBhbJVrSe4AaplrH05qrQpcOViBw54Gg27HuAiSoIol6hlqm4QyyO/uEHeNI2zTRJIve4Rbe9sYIZO1HnxH6xTjdE9QP+LqQXdyaKG3DW5bWzBC6byHmqlwMrM56r3KsODJdUbnD07BF8gvmrkD0Xh9HOFYLoCh/7i8b+qv0lN6NYkDJnScOXCtQjQ3bIB7gTFxf7XlrYSeS8cHs232Sj2Rr61wBQPd9xI1+E2JChIxqqMy/K9pnm1CvdicpIrlAGP0KzjuzqeSdtm1PKLzfaxJenpJwYwwHhCksuRoQRfbW7G+Kj9p+2wkxr6BsZu5CTsfJQKj1X1Eh9/wMGHosW+niBVIjyFyekgl1Khj2q18Y5RGTrcnPqd9nF7PaC+yWRz7f25Ca6vvslN972vDrx6ElaHnTShZcOY+mbavI1xR+2oBNA2IuyFt7DvVsRTiF+2UPo6LPUoAuIGBOk/ZUBUGooidZSZ/X7rjRdWzVacF1dwNJQ4ZjuKUJuK7powHxcA/TjgvJZap0MKGNrNS9WJoDbsZmv2jMeX+Wh5gLspQtCEAWzak1HO9Uqx41gLY1rfZL9Mt71d087G70WOegRh5pHMeaGin7D0s9Zg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199021)(8936002)(8676002)(2616005)(38100700002)(966005)(2906002)(478600001)(6486002)(6512007)(186003)(86362001)(6506007)(36756003)(26005)(7416002)(7366002)(7406005)(316002)(5660300002)(83380400001)(4326008)(6916009)(66946007)(66476007)(66556008)(54906003)(41300700001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F5W4ZtYq6mDMWVRjaIK8JRKZ49ohKBRBD1GTWiqQAbwlFBuhb5Epk04xQpHV?=
 =?us-ascii?Q?E/8E/3tCd8IFfiyRUJGzVr3lgSdaVRP1cFyJ/J1C/xRfhBEHasNGtfncpdwR?=
 =?us-ascii?Q?Zx9bkgzx7GgufqwLqZqKASQ72tkydIp6KYxFfgSEM3uDYY0HFgAPnXWVc869?=
 =?us-ascii?Q?sYLPkjEYILM297p59DWcjIgYu8/9Khi9pGB1hz5zl8SPdQJRYs2Uq89jvRxX?=
 =?us-ascii?Q?N1VpbfYUMYn5IGzR3eNtL/CFeDoKcusRhRHKtzJFzzHdAVZDlvI8YzxSThHx?=
 =?us-ascii?Q?dleCb6ST7PXUPyFJrlKDobuII4Tuc44JyaCwFQhUTlMfKGLd+h/yfGhYeOcS?=
 =?us-ascii?Q?DxFfkrbkf2WshcJ6XgqgC6Z8H8wU3T5pe6i9roZNxpf15Zmph//OLnBzmt0v?=
 =?us-ascii?Q?IK8muw+rvfQZ+oGoRNqEf6pA+3uttddL9hpAmbHa+ZXlstRsg5gMJs2muq3L?=
 =?us-ascii?Q?pOSZgP+qSyuI86kQEo/jPOjNssb0l/Yq0Af4MfzJ0S5YAGQekYV52vwikh3g?=
 =?us-ascii?Q?tX1U54pJvu7Xk2ip33ObcZokaB+A9iHGFCLT3vIib7JtbcRfe3w1GQCEPssW?=
 =?us-ascii?Q?k3LS3MTeF6snlzUqJ5dGAE0B3ST1NPBGO7g+7hR9hCIkLX2mzUZAzNP12xgR?=
 =?us-ascii?Q?BThYw//c0j6jKBzYqTtCVAloC0eXQXA6mqOM+beEc741mXBW18wDOvtdhBNJ?=
 =?us-ascii?Q?2fMI/wQUuES3YlCXf4qA3i1ov+Qzx+4ayPi10kAO7+fQk/zGJSZXpHLQSipc?=
 =?us-ascii?Q?5LHmuqH6dT9wc9TIjgesvF/EZUQ8F0gUXPGZhNN08AOVAheYRo13Rsjx1PEU?=
 =?us-ascii?Q?lTfQX76O7z+XwHLDtcwQvKulpgBLBQDxPX+V2jOaxkm21We6m8S1i3qRZRUy?=
 =?us-ascii?Q?v6kVw95gODZKoN3+4DTgpv0BD+INHIDIdeglWb+3vwSkamy9ip5JFVWttYyM?=
 =?us-ascii?Q?Mq1awaCHgi3X+UWiXKl7wHa/rvkc8uuVIyeNWm+vpuOPANujoxwmIAfy+45R?=
 =?us-ascii?Q?D4RZ1Veikj6nQNk6tsnnYBnKrUX7rvNo3XeHh60kiQG0uxzwbZbwQ7gJvS6x?=
 =?us-ascii?Q?4UWx942gGr6AlZRSbvPvfzcaVh8VvfCcthmYWf9ibQ3C9j1RgpZD3VtixIHI?=
 =?us-ascii?Q?+0lSmlw8Ta1kENsAswporPYDjENFNms7uFlx6Z94U2f5oC1dgEdCkT1J7aKm?=
 =?us-ascii?Q?swz/CXA8Z6HEoCS8QUt2exN1cDM+iaxpWcBLH2eoHeETel1i7zBDGextSars?=
 =?us-ascii?Q?MmxA2/otcvSKYKS/x0hL+G4cSd7UN8U5v3XvnYS+jvzmNR1H3F/uutDEwWdf?=
 =?us-ascii?Q?NxPw/Z5r27tVXkJbsK4BJ4gZSGaR896OSYQJkfPC5FRfnKNP1xfgWGOYJpUi?=
 =?us-ascii?Q?Qgbpr+8vp86Ru8wWAK5EsWUjAjcrn0HxpPW/m6k/bXm+ykbg6tXdZwTETnDc?=
 =?us-ascii?Q?URU9RrltsQKxK2Rm/Uu696ZYl8ivLHA3BO9+HIpQn1i516gGMt268H11/dWu?=
 =?us-ascii?Q?YV59y5aq2Kb8cudK7EkxhjCTcXquQvruVa3q1svDuFzH4mfrwEir00jjf2Y8?=
 =?us-ascii?Q?4hWNORBJAcEwCiylnrk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de5280dd-ad55-467c-777c-08db4b68221a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 23:51:22.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsJnFoyRfEThWk7J0c1ECDhozQtjwhYzoIjFxzEBgVb19w5uJPlXna7xCG+SaLA0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5678
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 09:33:45PM +0200, David Hildenbrand wrote:

> I'll just stress again that I think there are cases where we unmap and free
> a page without synchronizing against GUP-fast using an IPI or RCU.

AFAIK this is true on ARM64 and other arches that do not use IPIs for
TLB shootdown.

Eg the broadcast TLBI described here:

https://developer.arm.com/documentation/101811/0102/Translation-Lookaside-Buffer-maintenance

TLB invalidation of remote CPUs Is done at the interconnect level and
does not trigger any interrupt.

So, arches that don't use IPI have to RCU free the page table entires
to work with GUP fast. They will set MMU_GATHER_RCU_TABLE_FREE. The
whole interrupt disable thing in GUP turns into nothing more than a
hacky RCU on those arches.

The ugly bit is the comment:

 * We do not adopt an rcu_read_lock() here as we also want to block IPIs
 * that come from THPs splitting.

Which, I think, today can be summarized in today's code base as
serializing with split_huge_page_to_list().

I don't know this code well, but the comment there says "Only caller
must hold pin on the @page" which is only possible if all the PTEs
have been replaced with migration entries or otherwise before we get
here. So the IPI the comment talks about, I suppose, is from the
installation of the migration entry?

However gup_huge_pmd() does the usual read, ref, check pattern, and
split_huge_page_to_list() uses page_ref_freeze() which is cmpxchg

So the three races seem to resolve themselves without IPI magic
 - GUP sees the THP folio before the migration entry and +1's the ref
   split_huge_page_to_list() bails beacuse the ref is elevated
 - GUP fails to +1 the ref because it is zero and bails,
   split_huge_page_to_list() made it zero, so it runs
 - GUP sees the THP folio, split_huge_page_to_list() ran to
   completion, and then GUP +1's a 4k page. The recheck of pmd_val
   will see the migration entry, or the new PTE table pointer, but
   never the original THP folio. So GUP will bail. The speculative
   ref on the 4k page is harmless.

I can't figure out what this 2014 comment means in today's code.

Or where ARM64 hid the "IPI broadcast on THP split" :)

See commit 2667f50e8b81457fcb4a3dbe6aff3e81ea009e13

> That's one of the reasons why we recheck if the PTE changed to back off, so
> I've been told.

Yes, with no synchronizing point the refcount in GUP fast could be
taken on the page after it has been free'd and reallocated, but this
is only possible on RCU

> I'm happy if someone proves me wrong and a page we just (temporarily) pinned
> cannot have been freed+reused in the meantime.

Sadly I think no.. We'd need to RCU free the page itself as well to
make this true.

Jason

