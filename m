Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA6F6F451C
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbjEBNhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbjEBNhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:37:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3AF6A65;
        Tue,  2 May 2023 06:36:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZf/vu9jgbXr4oN+RbevspXdeqIignokT/g05HTxF2NTvzllaEo+MSI0ixNoFOYmsNlhgBNpvV2JYJARE6d3RWe50rVjECbNK35bNUE2z39rSCXwAEzqxYC0dfm2RFgLwAjr0zu2zfglHGHzdvdu/cNu1rV8cyNki7ZVhlgWtbBm7viByZG3Gh7bcIpQMqBcFsYfWqUYyRT+TBvE4BWMWHZYoO2/SqWc5Ilbu5Dr12oZge5MnDl6qAG9W5VJH7opC153BaQThjmVoLzo2/J5rvbhdwkFLyQxmJkvRB+j1SjBMI8fr3O9ZgieXbTirQQvVZaJYmZh7aEfOlBikECx+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oKdsxuq1Ut15NDYBBPox8iVGp/GgBNamaDiC6ZpJvNw=;
 b=GYj2058PcZ1jTEEBh0UsOb9ti561ndd9X6Qucog617xTnJv6DLpNN453T2likjnh3IS8M9Pp8evLNOBM9Mf++MqP7mJh9N+ssJq8E9MoLspoDX+LWslArBUdrIPsknACccqGg7ufIaS3E4+byMrL6ajl4uAfmQeCzcMmqfDs2jDny/X/BJhjow/SqFdYMDvNPem1n6VZhQL4ce66uhZ0r/NT7+iw5Her3IjiqCT+oog30/c02XyJ1flmX/jq+jQYRqK4c7KaphoGyb0uH4XDhvoHya+gH42LBRSH4Ty8YKBaJZxQtNbognbZqOFw1gi0ydd40y0Log3oA6DpgYvx8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKdsxuq1Ut15NDYBBPox8iVGp/GgBNamaDiC6ZpJvNw=;
 b=V25o/tbVuxZrNjoGP6USigO83Px5Sk/Icwu0m3KmBKphakQXQIpvQka4J+hoHbMY1+8VnF7mDZ7FzChphPTClsje7ShrmGucDAVURrFIa61EcSfrU3KX/y2ObC3tkf6c26KzL9Sk9oJjkh4R/V7uC2A7oiEF63rNFntUfWvj1K7uJZRYnHdlv/VvKhJFQ5vQfJ9MWaF8xZKdcpGK9xi1yL82ZoDfI6YXeAQ/GUIp6pYnIGX9t7r+Epz49cjOgqgx7TA7evKoCostI+a+j175Hu9pMKYJr4Si1YtxkAwjfgxhnlPX9S109q3Pv+vpxwNkKqKuL6jNGSWgEp+HykVuFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 13:36:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 13:36:38 +0000
Date:   Tue, 2 May 2023 10:36:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
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
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFER5ROgCUyywvfe@nvidia.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
X-ClientProxiedBy: MN2PR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5286:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ccd8407-d032-462f-4b4a-08db4b12413a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXwmitepPsGdMZE97EHntuecjkMIm3TpOTNs8/55Qyn/FPKysX5YWtioLZFk0pJBTN8hD4oAKc3v2T4s9KiLtul18+n9lxyCyg2pPm9RJq7jVdbwO9SdwP2RJzw5VR7lql1RHtw4Xeqzwasts9IZfW4LYVzQpHA+9hrMlay1w1W/asFZZxpZaZy5kFIzbcZCYBFjMMtX/iIoRn6geQ8scjRUAWDez8BE3vONvra4fBkLj3leem3gRNR5Hh15orMS21FBxYodX7EnjDX8Q+c7DA+DxiVE02utl3D1KAZyYsC8DvrF/CYneXFlC5OZSEuFJYjfxsxMS0XFqt4KasYorhQ30hpaNQReZrDXZHmHaTlxD0zh0vP5yoUqFg0G886V4oxqHxix5XPjSHl0z+CI1uTqB9SVdP66j0MsuWiwwaTvVf8behLZTKDI4ClKQvaq+Emw/LFgHUuZOidNr2/6XoJuCRE/o0pl3jAnJY8oiZcEJIJosNYF/1hJcfpGhzZhi6tadsTfq2nGwvy9jM726gLeNkpt9nHAc6P2Aj97e93YjpKI+8SUKAwTDfxjPI5hjobh1ui/SgXpFFXOPmw+4d0T/QS06YIiPIDoC3XwzDo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199021)(8936002)(2906002)(38100700002)(41300700001)(7416002)(7406005)(8676002)(5660300002)(36756003)(86362001)(6486002)(6506007)(6512007)(26005)(966005)(53546011)(54906003)(478600001)(2616005)(83380400001)(186003)(4326008)(6916009)(66476007)(66556008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pc/I/jKn9+zmO+S+FIOXNgfgt1BZk5RFOg6TN3ARJ+oKLVUqvOwGcz5wpm95?=
 =?us-ascii?Q?y1vBoTqsejRwlZqnWda1ZXFY25rcReLIwiel0abNMVDrHE3W6rQ5KvJs9qBv?=
 =?us-ascii?Q?3W895KW+93iZ0X39HlipjUASSJ6PHVKphSrnlZHUtFMGlyJULnZQMvN5O2CB?=
 =?us-ascii?Q?TmVlMTc0mHhtAuqbA9M+RSTp7l624Z6yIWHwRzNYWZgQb3MSRhCSrhcaKg9r?=
 =?us-ascii?Q?yQWgP8T1QDiBkXuid1ydhlVkDJRHlZfXV2D2axIkNvnE1cczOZS/gkVfLCQ2?=
 =?us-ascii?Q?LViZe8k/Lcmu2gAYIwohhUX01qIZSAmcUQLFbzrAI1GTsBtUz6xXFn3OHdqR?=
 =?us-ascii?Q?FJ9IXC0C19QHl/SChIkTSm8QyR1kXlEnA0WARwx7c2u4ory5PBuPlPee4HdD?=
 =?us-ascii?Q?RNtrMtI5neF9KQkOY9yNdOxfuVsMHgE1YEyFWgdbPQtSwYqVZfngE4Vun8cM?=
 =?us-ascii?Q?H1s8I7CbmcsQY//PR0aQWII9ttl6AVwBy3aJ/9fVK/fMCbaRErz6VdM4AHn1?=
 =?us-ascii?Q?bdQwfScQD3SKMHA54XFzlleSQgBQIrh7+pj6odg/WOrrj4IRR9NmkwytHaxj?=
 =?us-ascii?Q?DNE+P1Hb2XS3ZwE3XtjUyyIs2fvKWgI1PYs/GO5DHJ0G6NMD8MAns7gUBKKE?=
 =?us-ascii?Q?l7AhWrOhGUgjyftXtySkukwjU9kBWc+XaXEZ01dWftgbTrEwRL9bpFhvhgF2?=
 =?us-ascii?Q?DbtIH29OvLzRaOwIX0rwQv/KX+WSQIAvY7BkUSitjQxGvouQ3jy1p8nneu+w?=
 =?us-ascii?Q?9KC6xWIKV+By9qi6ANmvtvvLZSSkW8B5yMS797W3voxlFmelDwN7fkz6A+MA?=
 =?us-ascii?Q?QC2suzUnhUqJY7sBPhkfUoJkOoEkbjRJBHbPom9wuCJhXwxfSPfh0eWb3Q22?=
 =?us-ascii?Q?Gnhea/eZURKQ4B7disDi4TgciIFz38t8VEUJ74baA7TXMGE6poAlCGUiG5Eq?=
 =?us-ascii?Q?7SlGEnYBt+3MoAoBRIB0B9MAMAje4v53z0uEDKoYxIxt9YU111oYMWoSFP57?=
 =?us-ascii?Q?VZ1YrFf0ijUeqm0ag4i90cscL1Nt0ZapVgHp1FtdaRU69is8Hkp4JfbvUV36?=
 =?us-ascii?Q?mcB7IQIvVOc7C/ghqr4gJ6DxMVKheQvmXaV2w9H1O2+nYQbatXmIRkhpQG6R?=
 =?us-ascii?Q?ff+iFGrvT+SeypZvJiDPVBnE9JfWkroYDnVIATvNIzM5t+OEhCtYkk1eigVc?=
 =?us-ascii?Q?ZdJjpWhjIjK/kG8o36f6oQvOMGlat/zVkt3xCUEJK5mFG89qJWb+0DjHw6Xo?=
 =?us-ascii?Q?vYySeq7c6c5EeBG9hQWK1Qg1l2rnRmvG+ibllxzOmuB0kD32T0dM/N0FkU+S?=
 =?us-ascii?Q?LdhlrAswfaTfFluDFW8bFc3oe3G4uqRik8mRwGS/qP7G0aW0pxozcOQWRYhW?=
 =?us-ascii?Q?iT3KqV9HoSTfI/dije3xtWYkhM+FAqZhSE9lLhb1fn8GEsgO5/SWUtSnkzv+?=
 =?us-ascii?Q?PvUwJXibLVwAFCg+ECw82btHii8j2NGyza6iw9/fMoaCqnMIvaXEV4BpNoC2?=
 =?us-ascii?Q?dKO266XAwqGcJjIK4ApsDnnpCPzNf6keVTOWWrcetgt4Ti4WUsJF4Frstkgj?=
 =?us-ascii?Q?QShb+2Y0mk4e311JZdmRQC/qtCUwtXvS3TM2kJhB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccd8407-d032-462f-4b4a-08db4b12413a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 13:36:38.0998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gk6R+D79M1NZF97mZbnBR4UpfvIL1wwuNiTzQXd0mObWcN9ggWH8udarSplUJ+12
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 03:28:40PM +0200, David Hildenbrand wrote:
> On 02.05.23 15:10, Jason Gunthorpe wrote:
> > On Tue, May 02, 2023 at 03:04:27PM +0200, Christian Borntraeger wrote:
> > \> > We can reintroduce a flag to permit exceptions if this is really broken, are you
> > > > able to test? I don't have an s390 sat around :)
> > > 
> > > Matt (Rosato on cc) probably can. In the end, it would mean having
> > >    <memoryBacking>
> > >      <source type="file"/>
> > >    </memoryBacking>
> > 
> > This s390 code is the least of the problems, after this series VFIO
> > won't startup at all with this configuration.
> 
> Good question if the domain would fail to start. I recall that IOMMUs for
> zPCI are special on s390x. [1]

Not upstream they aren't.

> Well, zPCI is special. I cannot immediately tell when we would trigger
> long-term pinning.

zPCI uses the standard IOMMU stuff, so it uses a normal VFIO container
and the normal pin_user_pages() path.

> [1] https://www.mail-archive.com/qemu-devel@nongnu.org/msg875728.html

AFIACT this is talking about the nested IOMMU translation stuff.
RPCIT is the hypercall to invalidate the nested IOMMU table. I expect s390 is
going to have another go at implementing this using iommufd.

The stuff in that series like KVM_S390_ZPCIOP_REG_IOAT didn't make it
upstream.

Jason
