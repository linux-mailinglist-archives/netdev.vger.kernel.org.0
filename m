Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58A96F4464
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbjEBNCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233787AbjEBNCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:02:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739055252;
        Tue,  2 May 2023 06:02:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldYrpGu1U7X6kxaPQ9Lz+xk6/hwKfD1lRue8pdQUTXzO44BCwk0ukBmN01vsi00rfcOdqSr2DJVbwMhQswpdAiei2PwPvwMXY6Sn2l3ZD2m3Vw1PxGUj7wOAnAeROWA0Kq6/SHUxtV6wSEptq2XVFjPNqWXj6zbN1o9Vkso5GcchyVNrBP7aOWiyJGegsER+oStQBX6ErkCDR4u1WDgbYBaCQu3xlKZJAa0Q7nMFw5854lPPRN81qTSHQebkyp0O5nZxYO19tTMmzZaB6kJgqn1322pOWy8Jib7clYL7MT4pxhslCuJpg8hFJ+50gCHPcZk2Hveko1iqNT24ZXivxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fy+3gqQF3+UJalR4Zrh6YwEtgeURGbGhUxxm8kfMfy0=;
 b=NpW10l2mP7S1R+YKHs5vZJbYBzuv/faehcTCfL1I1JKIyHSyCWJZsdwbL/KiS1curWSJPtPU/vloW9LeEcdxKxijhUXL9qRdauT2m0p8RFA13dqjgzUurNPKjTVA3qsZE+ztgfUIbyIQNYg+8u4zQOABX5Gok8e2P5Mqd59zXwMS4NcOvF8PaYfbHVpAPLVLq6BiW7vyN8VhNkFEt/i4S4i7O+7qdu+oFz5/DvEYEhMFZalUG/0kFgCnMZgUpMAXjlwkBmac80ze4lJnfeIAThHDjIj7BpAJhqzpgKZKn6dsswKbYJnv+yixlCqamHj8codluMZYbqIibJ4NudyYCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fy+3gqQF3+UJalR4Zrh6YwEtgeURGbGhUxxm8kfMfy0=;
 b=Wb8wwmFKXOuvE7LQptKxzNnLnRHLdWxN9iupY4Nj9HZ9xg2LXEhVrDzmIcY5njknvdVNIG/ROycM1ZaRmFNFPaJtJmyJXziEpTmUTvTYMypSjqzY4gpv7GcrjtKplMcQsJ/cvrVhT+RpzaCgjJb84BNYjkNApc2Bo5ucdsXORTBaAN7Z9OsmeEt6aQMk9JWsYwrXDrRJ7mRgh9bzl80k+UaVR9rl+Z4oCCAjzZS3kJCAXnTRc/A5CyPZzi45EkDpIRFpDsYZnAw3bb99M27oGUFOAVCygYv1lt94798sn8tLN1u/xk76jDx+bHAv0v6LH+3d0tAQ46fyC2kbLk//PA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4573.namprd12.prod.outlook.com (2603:10b6:806:9c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 13:02:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 13:02:09 +0000
Date:   Tue, 2 May 2023 10:02:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFEJz4s/95t1I4+7@nvidia.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
X-ClientProxiedBy: BL0PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:208:91::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: fc7c1fe2-a315-4db8-72cf-08db4b0d6fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1eReNb4F+L6k9mSphgj5qOP/9n+0haaWQuDbh0/LpieqND2QwoMn/5Fn0gGsED0+1htdWWLzBKnuGyFBuKxSwRR+xdcEivWAWyuncniME7wSgh5voySR6B+13Q8D8O7RRPdsfy5kkFW3N5R0Ou4xSM3Gvd6PBJRs7VZvXa/We5r4ZVnO60b5HZ+hv56RXg1lsmTJO4rnwk8j0/1d1mArrmxOB4AauAmpEHTmUZlpcJCXaNDeMrs1Itpc5vZo4/q0miKCCOZdOW3XDEjNkxUbzEyFXBCx83LPVoxBzefROKkd0ry0Cs/Tliql2k9HOde9/6hSMBhqWkfn9rR4cpmSf/8kVkocTPs1FGshaqnYeB7zcdfHnm8sl6NKoql2U+aCDkoiU+Q9MMIW+Jcj7Fs9ZVCJsO5DqSlN0p5ENxcCklBiFhBflESPJ/XkJcZ+Te7xMakaKx8r268QPJ20B4r4mD9zRq4BIQMqbgynbeFA+UwmYcX09xBgpgmwfeE97qeSZP1AC2su1mjOkmbWnm0p1JBIf/aHvWxXKtBvxlk/XEdfW9UPTSLbOLWQ638l+Jx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199021)(2616005)(6512007)(26005)(6506007)(478600001)(186003)(6916009)(54906003)(6486002)(7416002)(2906002)(7406005)(8936002)(86362001)(8676002)(66946007)(5660300002)(38100700002)(66476007)(66556008)(36756003)(41300700001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPW+z/1M1uAKHrO/05aotVZFipi0fvpSE4hEh+S+Vm9ksXboWTDM3K+qmdfh?=
 =?us-ascii?Q?5XcJkZXEMWSpYw4MExxt5fJIaySR720b6mwObrt1bxneUPFehj2e0DC70Fb1?=
 =?us-ascii?Q?66U429YmE0t5DZBlVqyjLw0UqrlA0NNmY1AMT66kM44QtRVPan50Rkz7mUIF?=
 =?us-ascii?Q?IoUrDSBKIAEbTXSUsEApgTYlu/wcBI/Us8Kys0hO/lNHa7LCUDZb/QJMInDk?=
 =?us-ascii?Q?GV9CMgZCutnSzbNPTtYVG4+wN5sJ1DAMWClgAbltCDYkKuXtLHPnwezKFItQ?=
 =?us-ascii?Q?sxR5rAhEhfcUjsVeUmkZEaYiCuDDaDaBHlqaxR/9fRBw9UwMdUZaYfQQ1gyF?=
 =?us-ascii?Q?f7xII1DY85eYcJKpdmJP1ZY0dt0M2iKNEarbkBaNuEw2YhKadgRzY0Oanl63?=
 =?us-ascii?Q?yoU4lPXk2HPZnqpimkfS0m1oUMHG3K5Z4VfhzYLwZ5HmDl88BIeI5lm65ItW?=
 =?us-ascii?Q?GAbd2Hog/MVZPl799YGwyycUVrQTT6Z3DwbcuvK5UV1WAnzP7eW/Dvh1atDx?=
 =?us-ascii?Q?Yq7Y/W/oKpl1TUbBax37L4HzG/Tt10dJEMoUw1PNZqKnRGfeq5titQ/u+RgV?=
 =?us-ascii?Q?ZpX6Dt3aZ9aw3K0nF7durUazCAGSaDLC64V6ptDGVtzDIoxJtEBzuSGdQWLy?=
 =?us-ascii?Q?HnWEknDwgLm0PQZPHykfCqA7flRLCbKFTo2kgHk3su1eb5PwLcdftq5OvNpZ?=
 =?us-ascii?Q?gxXWyMI0WU5ea8ZoYcZbNkSBUHGuSgqCkixOVJ/LL1JP0egWq9SH/LbP1s6X?=
 =?us-ascii?Q?BMjjkk4Uabk2IgBoIDQZY1RI0CScBIR1Sg8qExyUPXS8YPMBcB/iQND4StGe?=
 =?us-ascii?Q?nNUCtifvpix4GccgVxYBasRqy1kzL6zIUn049AhdJU5qBki7CdrWt/cZEQ/e?=
 =?us-ascii?Q?CwuqE9Nf4ILSI07zUE9MOxGaAADiXTdKg6wO7Nup20U1y26sbxYjasVdrTlD?=
 =?us-ascii?Q?5LWykP39ngiU0zjmpqCzkkxj5tIKtM0ptx6ybRXNxvSJvMzJNks6TSTZmXwy?=
 =?us-ascii?Q?gWTFSPVjR/yli/oLh/565WaGcYcQQXgq+LOTdnA4IE67v7vprHgKrSOpnjS7?=
 =?us-ascii?Q?4yxeSW/DbD5nZzQUffgmVLV+mqlDgNUUsSei6iQVLVaxzUNNnFpqh4hdgpDm?=
 =?us-ascii?Q?T19RWmeoenFigqLtEpD3uDcwIFPBrYzcnEMLWXcrXWGkZ2xnidRl4sCeEIbd?=
 =?us-ascii?Q?m5frk/l8D6BEnJYEOpQPzBtlQepTA0l0+tn8giAEu+jKWO6W4a7cqhG3zlE2?=
 =?us-ascii?Q?C0bTHDkm5EKQo7lG88aqr82GMgsNCWjufjk+YLClZXRIgQ8A39PUY1sXv8a0?=
 =?us-ascii?Q?q57p4qe2Hakg7pxaxFYR7WjrznQNRFm/2C2lumsDxioYiqIVbn3n4oOexSqG?=
 =?us-ascii?Q?kTCdeuTxDm+iEgtFtqhoruYGmBMSDHBoIkdXOQKQPtjz0+EscdnKuOqPGczY?=
 =?us-ascii?Q?gN/nafrvIZWMlBQnz78UVnS9MZlgIsMJJIKkAaPzuY+grI7HF50GO20jGB77?=
 =?us-ascii?Q?p0zo0Bx+UTzcLabqPmkasRbXk730fVorb0bowsfMHHqRCW4YoEP2Lbixh4Qj?=
 =?us-ascii?Q?xuyLNFzzm48I+pfE+6Dc2nZGWmZzXO/x8XAYg1GP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc7c1fe2-a315-4db8-72cf-08db4b0d6fe4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 13:02:08.9331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKy0mJq9ChuheWxZ+40dlOzGlkIDxcSGYSWvjwkXjLRf9Gv5YcQUE8qeKIx42Omq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4573
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 01:54:41PM +0100, Lorenzo Stoakes wrote:
> On Tue, May 02, 2023 at 02:46:28PM +0200, Christian Borntraeger wrote:
> > Am 02.05.23 um 01:11 schrieb Lorenzo Stoakes:
> > > Writing to file-backed dirty-tracked mappings via GUP is inherently broken
> > > as we cannot rule out folios being cleaned and then a GUP user writing to
> > > them again and possibly marking them dirty unexpectedly.
> > >
> > > This is especially egregious for long-term mappings (as indicated by the
> > > use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as
> > > we have already done in the slow path.
> >
> > Hmm, does this interfer with KVM on s390 and PCI interpretion of interrupt delivery?
> > It would no longer work with file backed memory, correct?
> >
> > See
> > arch/s390/kvm/pci.c
> >
> > kvm_s390_pci_aif_enable
> > which does have
> > FOLL_WRITE | FOLL_LONGTERM
> > to
> >
> 
> Does this memory map a dirty-tracked file? It's kind of hard to dig into where
> the address originates from without going through a ton of code. In worst case
> if the fast code doesn't find a whitelist it'll fall back to slow path which
> explicitly checks for dirty-tracked filesystem.

This looks like the same stuff David was talking about, a qemu guest
with VFIO backed by a filesystem file..

Broadly though, arch kvm code should not call pin_user_pages().

Either it is KVM focused and it should use the shadow table and it's
existing mmu_notifier synchronization scheme

Or it is VFIO focused so it should use mdev/etc and have an unmap call
back.

I'm not really sure what this is for though..

Jason
