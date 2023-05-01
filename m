Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4242B6F30FF
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 14:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjEAMkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 08:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232376AbjEAMkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 08:40:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE66170C;
        Mon,  1 May 2023 05:39:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJ48wp/CUdFXnn6SIhlyAr3BZT+A97TX5T65pK3uWLMuiOCjRnsKIS/w9VhZynX99dQwBHnIx8QdKwdkU9htWD3aHaIetRoTnhtq13gSLO1F5pNPkMNd8hxss1ORUxxiK6mSzqKvVzEp46kuaQYUUcQA+wId0Zag+saTwoeFRXPEsEmFhLaJXmMWHYUR6Q41+IPMdkTLFhQiVWdYZYIzZy9tQMT0y/RCHl+fKOocDPl5VIdcSYNzwrpDZjDLOPCwF35N7DO73NICQNGD0IbWHLLub4nbGhcWC2oCJzLaZaU5NUhwFa6ua3Vx9okmV0FecEs3OhmO6OzyemlVFoZ8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1PoxOSEquA9qIXW1fp+FUMyyKxLWU/aCjbM6epURWQ=;
 b=lo6BNozabH86NzdPpuupea1+w9CetbvKPAWqdg2dKAzc+Ntwohh+dcGl+FioLp9BDu7cKhIQ/whzwKK1dN1BaVjiVNjXBS00/kjQJTdjRSXpc4EtOkrNZ9wf0LnBXCLRSDb1f4tCEoJPQ5bULRc+ZiUbxwSfMAcF8KX/Si12ZxtmJkj12NhbXIaODa6DhxdRg/TFyW+Dj5oG9nmkFBxPZEVmP0w2/XBtKFUI84O/6fx114T/foI3M0wsjEDu3IZXhDiD4Zp+vyO++BXxvOFb7B6JYzQ5SezE0mHElXzGDa5PUJa/kiFmX0Ie8mVFQU36DGF0Kef1/C/w2ka5u/ydqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1PoxOSEquA9qIXW1fp+FUMyyKxLWU/aCjbM6epURWQ=;
 b=OzI3OgQGG6nHGQJPyjvEXpXFxSh7zEhqZXRUhl4mW1iVKweQTfprSSmImeoxTTmlVbwPCGt3Ix0sEBzg3iug1JlYwbFw9kY6qdva/tm55pqv5oXIOPUSDnO/Z8zrUwzKJgcANljFaGyjeylsYfIDKMmEdLP3B77B6J5nNcp4MjJ1/9HypJHGWzFn/OGjUORKBVdN9t9vbbFUDPPYbwr+UW0xK8iLZP5+NR9G0gaVOUpgRQid5D6bQ0x/JyaO3B52s+N5FwUfzrR2Tg0vlj80Wm+1w7f2zd679bna5P95hRg89PMKERNr9Fv637aW4EDGIkTI7KGh9Bj5cnPQtaWpZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6908.namprd12.prod.outlook.com (2603:10b6:510:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 12:39:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 12:39:24 +0000
Date:   Mon, 1 May 2023 09:39:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Theodore Ts'o <tytso@mit.edu>,
        David Hildenbrand <david@redhat.com>,
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
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZE+y+rA7BCNzV41J@nvidia.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <ZEwPscQu68kx32zF@mit.edu>
 <ZEwVbPM2OPSeY21R@nvidia.com>
 <ZEybNZ7Rev+XM4GU@mit.edu>
 <ZE2ht9AGx321j0+s@nvidia.com>
 <20230501072718.GF2155823@dread.disaster.area>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501072718.GF2155823@dread.disaster.area>
X-ClientProxiedBy: BL1PR13CA0419.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6908:EE_
X-MS-Office365-Filtering-Correlation-Id: 7799b4a8-41c4-4ddf-8ae1-08db4a4117b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wDcAgxJA9yBHwmKZKiCW7VNOk1Gc7HjA+Cb3lBl9ejwfnyy8V5SdUUq2w5Uy9JHqB/5tixoMCIRNVnhxFsfBg4ekvC5Q7YdcM+sokxCfkfiD8w8KlAteoZ84qbA1n5DEJYHDVeL01M5D9rrYKswiRtEMehRfBqK6C+6+BMYMAbvMMKaGYdTsqjdNo3FRmE3dLUff6YoVHoByqXuOYhITpvX0IJ2Tc+Zlosbe14V58Cnj+CR9P51hGyP3VG7wDHKNENOO62DKZ8to1JHkIXWc7fNGCPdXEcY47JnqwSEXWAg7YseaK034EQdxsZsBiUxCE5MMfiTRzhF/x7YwWFUJbKc3PaCrT2Ttcq9ziH8RMMD4a/f6U1aYtnqJSyMfy22R29oxplJ2EzJJNWndWOuGiC9qJSC79QIxYDAkKUNxFqzI6YO8Dekh52YVXRSaaIEcdpVvWCwq+lcr6qdZNsGmczlt3E0b0DAMc4d2DljrpsVaLw8cgPnqUgDT23re26h2G7ILAT2UZicU62yjJtq5gdnfUOinyv+a8pXP6svNzQduDOkNVwUj4I7m3g4M6w6h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(6486002)(83380400001)(36756003)(2616005)(86362001)(38100700002)(186003)(6506007)(6512007)(26005)(54906003)(41300700001)(6916009)(66946007)(66476007)(66556008)(2906002)(4326008)(478600001)(316002)(8936002)(8676002)(7406005)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lMY2WZ7AjcOyPjanL2qEDnEw/PJvTiWtRUAXIyovmLFxFvAc3BZQLueUCcz7?=
 =?us-ascii?Q?DhILEa/KNK1AB1/PvupCpS41vrgAKcr5pr5tUEPRwIPsEZkE5a2HVQyQQIR3?=
 =?us-ascii?Q?GHsHsdya3kYEx5mogsEmczmZLU2zKLFf1aexPK0xzTkbzcDwmPbHliwFa6CI?=
 =?us-ascii?Q?H7LDIcL0LQgi8/FG2JNnmvFMSKHqew0KB6/nwK1ZJsjx/7iuU52cmngdiw6a?=
 =?us-ascii?Q?wMKoD6XnRf3kyp4UzXqDnFLPvhAjzkaaTX57MSOOQvsWCN+d0biHw8IeHnFR?=
 =?us-ascii?Q?w8rmR6fBeKe28rkx16V1F+2JCbK+75AZSA3nqFHKwV7MSJ2OerJeMs9ikrDZ?=
 =?us-ascii?Q?U73L1qi5KBwzRdXjXNT91GY30g3xMm7u9eIhC5VaZmRhphnJFFbfM2hgR28k?=
 =?us-ascii?Q?AgV1uhTlSN3p1Mv4xEfjxzInpvcEcfrohoUmf1ZEG/SNHnTEJhQTAViK6OZr?=
 =?us-ascii?Q?/ZYcGRdAx7qhXtL76R6xhBgj8BrPicZ9SNKbg4PuXnFBTSJLbVycYIRQF8HL?=
 =?us-ascii?Q?4t0rT2AozQDf1LAVyAY+ZPTb3r6GN1tMY+8C67BtDociLy/u6ZGzNgbc6CKo?=
 =?us-ascii?Q?us8RknXxPmmD/kMAqqfCNeOISbO7juatBl3RslTQZmvffvb9+eb1HbNybpOj?=
 =?us-ascii?Q?ZujT8hLKFssxmyKoQ8r8rUcOWITx5AIwulpBfRvwCSaAROZLnHIholUdI2Cu?=
 =?us-ascii?Q?+9N0Pi73UoWA2DakaF8ccD6jvPlxSLfjxewjF+/5/+2Ck+Iy5aDS4VFDhvF8?=
 =?us-ascii?Q?SwCRZ7vkE/RzesQLv/cEE9R+cRc+Ojk9pPRkGYk6OPHDeDzP/L9qjor9qjvQ?=
 =?us-ascii?Q?LP+cXYoTPqihgyhjetuElKlBu3A98xtZnN7iTXCSXVV1Zlc56QtDSFOBybjT?=
 =?us-ascii?Q?C1ggBmJLh7DNepmZnz8CVXcuIT0wRW/GHUhBdYQYbX16XZR2vLDQDInG9ju+?=
 =?us-ascii?Q?p45p50F+SEIRHwKg5fST9rVYOXDElHn8NVevpc48255D5438fpMRj5bjcZ8y?=
 =?us-ascii?Q?1GnY3RYo0OBf3onJYbWu893IluVPiLmDNO6MegUY9bsXxa/FL0736JRzddCD?=
 =?us-ascii?Q?0L3ltGD5Co6DG33v7+mg8DvzIiG/cP3lHMsYBsuT1mRYNo1BGzkG7MN0lZ/6?=
 =?us-ascii?Q?4IsnHD7RwNuiKlDVC2ciZpUdOPPBjpfLDX2e+DpZkCR4Gz8x6f+E+LDPxzJF?=
 =?us-ascii?Q?jwFA5HmNut5/0CYlIYGvKQ9yLj6fCW3a9NdwQQl/EUHV3PRDtgQJA740gKqw?=
 =?us-ascii?Q?palZYtOzZY9POuXpWRjVYovOdiVhT1fXuF7HPWw9qZza3ZFShUqp8hZOJYV6?=
 =?us-ascii?Q?AkZe7PCaa8gqD6Q3SPq24D5+0r1fCeacGpoel/HaU93cyvPDX545JTgY/xIN?=
 =?us-ascii?Q?wkBq1x6nUzDbtgNR7kUGjGznSQoEXMQbdXIarawI/1srH2WKviyf8Y65wgri?=
 =?us-ascii?Q?DTJlAhbCtyFtckM6ozi15WyXUuPSMaVvt3kCQ0NBrzvBA8pIfmBgyIaOJ8nQ?=
 =?us-ascii?Q?lSxOaiDRzQp2d3l3FtrwRcot2bKQpQE7+iAeBZgCE8OrxfKm5il8cENHivCe?=
 =?us-ascii?Q?9hokNmMHkNmzLw3Fcac=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7799b4a8-41c4-4ddf-8ae1-08db4a4117b7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 12:39:23.9384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avPS72XQqgYv1Jm8ogPc8m4Zi38D5WHEAObZRkf5L9TLvpmhrbMEk2XwwbUnIClc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6908
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 01, 2023 at 05:27:18PM +1000, Dave Chinner wrote:
> On Sat, Apr 29, 2023 at 08:01:11PM -0300, Jason Gunthorpe wrote:
> > On Sat, Apr 29, 2023 at 12:21:09AM -0400, Theodore Ts'o wrote:
> > 
> > > In any case, the file system maintainers' position (mine and I doubt
> > > Dave Chinner's position has changed) is that if you write to
> > > file-backed mappings via GUP/RDMA/process_vm_writev, and it causes
> > > silent data corruption, you get to keep both pieces, and don't go
> > > looking for us for anything other than sympathy...
> > 
> > This alone is enough reason to block it. I'm tired of this round and
> > round and I think we should just say enough, the mm will work to
> > enforce this view point. Files can only be written through PTEs.
> 
> It has to be at least 5 years ago now that we were told that the
> next-gen RDMA hardware would be able to trigger hardware page faults
> when remote systems dirtied local pages.  This would enable
> ->page-mkwrite to be run on file backed pages mapped pages just like
> local CPU write faults and everything would be fine.

Things are progressing, but I'm not as optimistic as I once was..

- Today mlx5 has ODP which allows this to work using hmm_range_fault()
  techniques. I know of at least one deployment using this with a DAX
  configuration. This is now at least 5 years old stuff. The downside
  is that HMM approaches yield poor wost case performance, and have
  weird caching corner cases. This is still only one vendor, in the
  past 5 years nobody else stepped up to implement it.

- Intel Sapphire Rapids chips have ATS/PRI support and we are doing
  research on integrating mlx5 with that. In Linux this is called
  "IOMMU SVA".

  However, performance is wonky - in the best case it is worse
  than ODP but it removes ODP's worst case corners. It also makes the
  entire MM notably slower for processes that turn it on. Who knows
  when or what this will turn out to be useful for.

- Full cache coherence with CXL. CXL has taken a long time to really
  reach the mainstream market - maybe next gen of server CPUs. I'm not
  aware of anyone doing work here in the RDMA space, it is difficult
  to see the benefit. This seems likely to be very popular in the GPU
  space, I already see some products announced. This is a big topic on
  its own for FSs..

So, basically, you can make it work on the most popular HW, but at the
cost of top performance. Which makes it unpopular.

I don't expect anything on the horizon to subtantially change this
calculus, the latency cost of doing ATS like things is an inherent
performance penalty that can't be overcome

Jason
