Return-Path: <netdev+bounces-2640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37670702C63
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DC611C20B65
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26845C8CB;
	Mon, 15 May 2023 12:12:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D12EC8C0;
	Mon, 15 May 2023 12:12:54 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A107D1AB;
	Mon, 15 May 2023 05:12:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZbzkACfo0vrr08uwcPAqfESg8dm8tUXn9bd091xAYZ8hMykx3Q9Yxr2J7MOg4QcGIvWKvGhzzWr/23nP83M0iKq/GYKMxP3ZnAd2BO3yk2wLI5sa9/nOh6dCYiUkkzWYWmVfyeo6onIVTA0KRTFAhd/vGGEUPfTheqqQ91N7avxw9hJdnXOk9n01d+e3D4Po4tzKZ+ZROLXEfb3RnXRTYDwcFRuCs3OawDI8cL215yyKZLOn1vgZzAr5iDQikAxKOgwFaCi/69wSdUmzeXrAadMcJPilTjuqo36vjlta2aS61JOrBsZ2cnWVU7/CpcIRtyBtDEc+Lx1DZ0NxJXX6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo2okyu9q4O73CTCXQvO2hUuvIL9+MVHCkrrCKsE8as=;
 b=C7WEr6hBBfoJRfJkl/zV8y27JXx+CpRaq5csiCtifgrb5IHxy0z6544f08OFc61vTVehtzzqLCc2D0YDqReNokxEq+ZMyHeUDci+J7icwg58mMeOmV5eTexHygpEcGcJaWc9JaoyQ8uIF0hJV6wGMHqSXiCBALaSSQ73NdHPl77A0nSCDq1iZf6o2Caabhe9swArFgBaaDJoKlVljCYXWuVS3yE3dmn1bXqKNiHl0Taf6kbF9QcetrBaHDun71Cq6s1UiQ4HLdPjADQtNDMKUwaBH6MMHQPVGFZ5J4afyyFVPIXGDeI2ipEHT4cDj7SSGyC3fmv5jPI+/k2tQK8BeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo2okyu9q4O73CTCXQvO2hUuvIL9+MVHCkrrCKsE8as=;
 b=sludTHXMA373Qn9ggvQsmqJFZB1roS03FR2loxOUAbrcy3lm60ODvyNd2TI/Z9zre4o9nUZIO5jcooarRjZvTxGKitSX1K5eN6OhEztM34W9zAPDeGTCrvUBBDhKiwZpEBrLpeomekqVUWbfNvDIVk6kXOBvcUREri7uW0zRTNN75InKTpiPkG4u04JyhrbUCuF2LLmeUs4OeFruyzt9fLIMGhs07Yy8CnTpsP1u0jvgGthlJV3oaV6pmc+ePq3bPntlyyBpyHaWNuU6SYV3mHBxjy/cz6OcRrN9oW5br9CzhvAcYtY6uC3wUsordoyssd+zzI2QR3Dxt08UaMrhTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4321.namprd12.prod.outlook.com (2603:10b6:a03:204::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 12:12:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 12:12:50 +0000
Date: Mon, 15 May 2023 09:12:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>,
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
	Jan Kara <jack@suse.cz>, Pavel Begunkov <asml.silence@gmail.com>,
	Mika Penttila <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v9 0/3] mm/gup: disallow GUP writing to file-backed
 mappings by default
Message-ID: <ZGIhwZl2FbLodLrc@nvidia.com>
References: <cover.1683235180.git.lstoakes@gmail.com>
 <20230515110315.uqifqgqkzcrrrubv@box.shutemov.name>
 <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f6dbe36-88f2-468e-83c1-c97e666d8317@lucifer.local>
X-ClientProxiedBy: BL1PR13CA0134.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4321:EE_
X-MS-Office365-Filtering-Correlation-Id: e517f40b-794c-47a4-952e-08db553db3b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N/zsEx0MTKHwLUimmYqcbdIfjLizCySoq9C6JCls6zs4LJiqfKG/rA25LDS1Fc8CiqtrCPaq14ntbssBBhPFY93Ui0TwIlq7gWOJY52P3cMfK9+rnlcElAFNkI2JN8lKopgW2fkKb4v3NgaZ3DtPKX2y1+1AzksITHLNqF/NWSqlX1TZ47nKnWM9K5bnkLmJKTGaw0izF5Vi5a0tt+CmBOD9ZZpLnLgAKhS+4SXBSOO8RJ78gMGbnyz1Ye/pgVmu2pRcIrMGSiFVLEepQSWgCj56YpJKg/0PY6R2nsxVL21gnACOYV+AQbkMJfcFygfgGohz2DL3mY67gxuBBZ8LnsfekTMq0FNnRAvOPCtelmrmsC716UrOUUWU55MiTNpbUCWR4Pv2h4L5MaTb3a2hSa9E3UwkKYaNgCY2KBgTDjw9Rvj9SSrNzgGMf3syIN/0tsGm17zxSupG5NWm4fqAH5yLqeGK3ZgAwA7Z7CdMkezZkbfpCWTjp+6TJTa3NC4Q1dWzuVY33ahWRhsuqbMW5U0EJ6R09T6YdoOa142oEzK4GPElzbkHj2lPbhllTvfo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(83380400001)(4326008)(41300700001)(6916009)(316002)(36756003)(2906002)(38100700002)(26005)(6506007)(6512007)(6486002)(478600001)(66946007)(66476007)(66556008)(2616005)(86362001)(5660300002)(8936002)(8676002)(54906003)(7366002)(7406005)(7416002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G+qL5vFMYT6D+nnSgzfuolJgmHEgH4dPR3MTkIhI0WJ3eg35wslLv8EcGLb0?=
 =?us-ascii?Q?XPMpDTl5n+gVUkSBlCATUXkeEkD2tulwBCzDgo/c9CbIq9c/GuEnx7IB4Jgy?=
 =?us-ascii?Q?6yCBn3kJ/QuTVHb/+v23Ikknuh2l+Tjyj2T5HwufyqWM9R9VrgyeSOU9ncne?=
 =?us-ascii?Q?W53kCiR1qM+6BI7ehhrly4/cHMzfiasKYkkb1SJrOxNdNpAkuzSS/j/aa8VX?=
 =?us-ascii?Q?qsnZ3ZEktt6StW1OnQVKxB2U0MO0u/x7LoqQ0Q+0+ztFjHIMqqp/2kQqk078?=
 =?us-ascii?Q?4c5t7Xs8O1jcckkUhxt7fDrD4QHbXzz8k+HCnwnCe8LmObVDQAGrxJgShfQx?=
 =?us-ascii?Q?rhcQxMgObqXWgdt70OWPfj6MfpJUcqNYHR/FctMkNaIiPQ+0iVRsFMLBS3JZ?=
 =?us-ascii?Q?kGKQMAORHxn2i7qkk07xzDGmyhPKfaDGQAAfBbQSUV47IWBS3xbY6Jq0LsMb?=
 =?us-ascii?Q?wKAIKW7KBF8+n0qy+pXsGzl6Q6CrDmbzUS6ujjazVLnnp+puzGqCNvJKi5rW?=
 =?us-ascii?Q?6vij8M6UnhFHgtnIdwTysz+TsrQ8i4Ab9jsbbn1NSBSxR8uO3YWwENeYmZ+3?=
 =?us-ascii?Q?Sj2AheSUFe1hxa6L8uKBluXxwDDFs+CyywNnqwh/wqmgaTdf1DMtO3BBSe32?=
 =?us-ascii?Q?PP/uR2EbfMNIUSre12EwGxlBhYO6zdXIew5kRBKNZBH+hroIIrP93opOLQxs?=
 =?us-ascii?Q?Q6c2cT6mh+W0W+Nad6geqFCejguKSAwh17upFnh7KZj3+J3bHSvihjx6c2jh?=
 =?us-ascii?Q?Iu6VaCPqRGUsQzPII1QEuTNBF79CqgyAdhOGiYP6PZpGWoWYPBHwEufU9gsP?=
 =?us-ascii?Q?c9jSoFiIT85yWl4dHFzwBTDiVQn+YFsXHubFn5aLiUsHq6Tzh+0S/awPF+2E?=
 =?us-ascii?Q?sZv9nGYdPhx68TvqjSlBo3T0ayGbeLVO7IcY8/T6ACoFlvHFp3XzTgwRMTEO?=
 =?us-ascii?Q?36oCA/Ur9l8Mvc52suSFnspxgjtC/wdRwkaqyQYSiJjiQV0pfOAK6A2wRfHP?=
 =?us-ascii?Q?QWu16Ck3nylaL7g/A9tmXyu49JLuiw0nRfzlSVbeM0r/FcfG4/HDvXepeCs4?=
 =?us-ascii?Q?EuQ6xFH+hdrReNqigeBnZJTOvDNs/DEqkCIYnfWDanuae3G787aFrkTTcato?=
 =?us-ascii?Q?jATfBK96zi52PnqHPUT0GVuB1l9y7X5fjH4VoSHljLCe0GO4dxKRtyM/sctv?=
 =?us-ascii?Q?2Sim4aV4DwoX+hMoQroedjQtzpvAoYyPuYwBimAFo8YGgoxq1Bfor2qpYeGm?=
 =?us-ascii?Q?k2L3SrkulKiFqSRPuUeqfbc3YELxnKRCcc29Mo6ilocjjEsiAZX0F9rCqGkZ?=
 =?us-ascii?Q?bKJaY33kmJQCcQ5zsY8bQAgbfGBF61NlDpaGUjQhV53tYJpN0axpZhlDnkTK?=
 =?us-ascii?Q?hLfJgkPqzyzZ2kh5bMRpRHv1lJM88A8CrVjld9HYuq/xCZ//OcWQeAnGiNdL?=
 =?us-ascii?Q?g9AqsFxbEkFIoECXTR3j8GsWlWbT4V6EsS1B5nj3uqJvdvzHi09DV4PTbfIU?=
 =?us-ascii?Q?fdwpnItvvGh+ETUOJk9ljuhbyxc4ELMLBBnqvZVStZ0iEpTDmZ1WeiJe6Vz2?=
 =?us-ascii?Q?HkXq9o4Id3e9FyX79yFP2boAC4P5tgeLP9a4BWz8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e517f40b-794c-47a4-952e-08db553db3b3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 12:12:50.0813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8quOnnNBOxdw4tqchzoE4R9DYph0firWZ099EtdbNRWYDxYS5r2wSK5qv1YCcYK0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4321
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 12:16:21PM +0100, Lorenzo Stoakes wrote:
> > One thing that came to mind is KVM with "qemu -object memory-backend-file,share=on..."
> > It is mostly used for pmem emulation.
> >
> > Do we have plan B?
> 
> Yes, we can make it opt-in or opt-out via a FOLL_FLAG. This would be easy
> to implement in the event of any issues arising.

I'm becoming less keen on the idea of a per-subsystem opt out. I think
we should make a kernel wide opt out. I like the idea of using lower
lockdown levels. Lots of things become unavaiable in the uAPI when the
lockdown level increases already.

> Jason will have some thoughts on this I'm sure. I guess the key question
> here is - is it actually feasible for this to work at all? Once we
> establish that, the rest are details :)

Surely it is, but like Ted said, the FS folks are not interested and
they are at least half the solution..

The FS also has to actively not write out the page while it cannot be
write protected unless it copies the data to a stable page. The block
stack needs the source data to be stable to do checksum/parity/etc
stuff. It is a complicated subject.

Jason 

