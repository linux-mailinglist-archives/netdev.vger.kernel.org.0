Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7BC6F1D9E
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345949AbjD1Rt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjD1Rt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:49:27 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CE71B6;
        Fri, 28 Apr 2023 10:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZumSbkXfELOkQoNRDbqxb9KL7oqpLSXVuBZSuI9ymtZ+xaGbwzgLMjCr1IO1UWxM514pq/ati94h7uTN2cBpBsIDyVxSOJQAbDqtlhrcqsPwEukVf1U7ZmIT22AXreo6AqqWAPmtoxIqqvUeCXg8537SL6O5wn4BMltmX45LFkuKJ/IxpPwXKjYMai2EAKIJHu2lSLjBUGAU7uds38TBeZJVzRpD3mt4mHZYsKdLCEHtU1bWRF+W/llLVG243oQ0LMVkXrbOw8TOTgdpOenvUtqUD46PqQznLfNqvjTR/czFFadVtBGIDN77t5zoKrvCoXP/8X0HW9VJkpjZr52Rag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GJa63KtyRFABesTYtUUJFXxLYeNRMQJG6Pgt8pm6Z+A=;
 b=gqUfiAmjwrUOsKBOag4rzO1BCkeMQWHe4iOEbiOPHoCrYtDnIscazSWAwHqVOdpKR2ekbwpPOw6bkokxZU07vaBl7g6Pdxsuo4lMFExPJ2Z/kFPVjeslhmWn3AmihzZieQ8mUPYsnPTWUeSJq50N1W6OVf+GIly9Qq2SnUVJO8XA331QupWnLq6O5qBKSG0t2/1JqXZMJzooHab+F8bvEfqYpESGBXqr6vbpvbUZEwQL/m8eSCl9WN25s/rsh1xGZaJtlDLdyY8Wrn01jUcc9ZGTM5A+EFG/PpPIfxHxCx+XZjOBzv4O2DrjFBnNJrja+KQa8aXMwMkWSM1BzHh4QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GJa63KtyRFABesTYtUUJFXxLYeNRMQJG6Pgt8pm6Z+A=;
 b=Y+/G/jZMRei9UiazqukLGeqhtyWl0ahjfQOimyIjH4DYffZpz2awJr+o8WLBp3fkMZ45DXuuOTnEwcaVsPuFaxLOk6HNL2RjoFqxf6A2SEweL/CHpRfhkiAaHkRq3rHF5ymD9n2xR8BvGAEbD4msoG85QFQvYWj3WKhZiQXyT3Bod43q8eFeq9OcoXfuUzWtSyKFrZXiihIiqkvIbphGPiYkJFye4RMmq79ow/JqjitY6IiF7FgAiydYDdRgX0MGvwOmP6yJ4ES1ZOUsx/F4YPqB8h5L+LBcqT0TGfiTUbaMOKHW1DWwD6u9/nvkWpAFbC1EmI8GKAuFNTcOmwXCvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB8005.namprd12.prod.outlook.com (2603:10b6:510:26c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Fri, 28 Apr
 2023 17:49:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 17:49:23 +0000
Date:   Fri, 28 Apr 2023 14:49:22 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     David Hildenbrand <david@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
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
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEwHIvoTEA+QGQ8W@nvidia.com>
References: <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
 <1039c830-acec-d99b-b315-c2a6e26c34ca@redhat.com>
 <ZEwC+viAMJ0vEpgU@nvidia.com>
 <34bc4f3c-8dfe-46ec-9f9b-358cdf4c37e3@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34bc4f3c-8dfe-46ec-9f9b-358cdf4c37e3@lucifer.local>
X-ClientProxiedBy: MN2PR12CA0005.namprd12.prod.outlook.com
 (2603:10b6:208:a8::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB8005:EE_
X-MS-Office365-Filtering-Correlation-Id: 72b2c12d-896a-4501-ef50-08db4810e6d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wWvn8t3um7cc2+H3qketfS8kdNeBJnXehi4b9SI6HXAdEQ88/ff2yH5kR1YEWev1erAdnZnbfThNWupqPFmmm4j2VIMWgWodtdBplXmLuVam7MvzP8lWWQ3vDhd9Vyq7l28GK5TuNTx4s56wRA+tt3dbtu/U3pRnVlQ0DnZVffDYt1QC8puYIgX/EB/hl1ZGlhaDRATN7l+XQvVU1rgR/87Pse8JppZLFYZd720lH9a3yQGRVYohcGmFhM2Yb02TOyjHh6ZYGtFLACIO1rZkYU4/4q0NxMfSTGmfdCklC9o1fMU3/rGSU02qbYpN2dt1OkmdRlxhqByNFufCsKjh4KnPDoIfm9X7B7/AhiBEQESwoLL6nj7sxdKpgEeIQthA0o00EjpUftkFv5CArbgtme878Ng1D0lfAt6DqYAvrd7/GyDgX/m9EaJAoLPnlowcE6Y/g86wgZbmfXIK4BZvj8pehf4V2qAja+4nOCvSnSZRyReN8dAwDxmPRHInNX1uO9R2BXnroLbKz7ei2eE1H+jXE2vxX0JD2OR3vJmS/huxlju04T1vB47aXZ7y12aTQ38H/6KNELi5iagpDqVUfKyIo0tyRRMyw0Uoc08UtXc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199021)(316002)(4326008)(6916009)(66476007)(66946007)(66556008)(54906003)(6486002)(8676002)(86362001)(478600001)(36756003)(186003)(6506007)(6512007)(26005)(5660300002)(2616005)(41300700001)(7406005)(2906002)(4744005)(38100700002)(83380400001)(7416002)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8E2oH1uvzhMJL8YRwWQDRNg3O5JzmVjS64k9aZnFx4f7QAPr1KBsXEY++apy?=
 =?us-ascii?Q?g2efpyQp4ciaZvKaVac0pwxtebaZTb9n+ETM617ba5CM7kFuvrkYOAnl8uY1?=
 =?us-ascii?Q?qRQEcNmCeGhfvRUQfsKvykZtyEIERlBBu4VCH30qnmwdwwLXB08Cqb7g5WZt?=
 =?us-ascii?Q?DVYTNcDOK2ShTmTOlkESYllyBVjzUU0nwRW0NowxYRvqVmBtfDpVZnDjyY+G?=
 =?us-ascii?Q?bcQMSwaErvW9QtN2WJfLflfuMuCK/zkA+G2GesJSBOR6xMMdwP9qPb+X5alt?=
 =?us-ascii?Q?8hiBL7LPmzkDw4Ow660RBe/f4Ij2GUH6b57N+yxY1Gg4y9p4GsXOrcv2RysC?=
 =?us-ascii?Q?Pr4W5kwEa3a/RPfgZO2zuYoOiMmdaEN0lXK9guxalgTt6j12l6TiIcEHUCDA?=
 =?us-ascii?Q?sebPd8RhHlD3xkDRSy/ofce9FwPRRNxcoj5E1M1ywqIWO8VRJzI8OrCpDlHR?=
 =?us-ascii?Q?ha1eKND0YcoREBft7a0cE5flHKiLQc/+kCsFCTg3BgDi0uRxADFI5moI5Opl?=
 =?us-ascii?Q?IvXbgZKd50cV0ICNY56xOZp5TJ0+FBJZmRh/YrknFFvR1e8ufj2CjtmYQyQR?=
 =?us-ascii?Q?oifsbtGocKwNDL6ejZOPwDqCOiCsRfyUW516PdlU5f8GdETdJ2qRTwzuUKoZ?=
 =?us-ascii?Q?WW4fvY58/TpKwn1ouGgYqPOzgUDY7ZQdecHH2gsZ8xm1/1MkrFCVbG5wPGPA?=
 =?us-ascii?Q?sXSUuY/xsjtIUCQG808DmKJh7PZ6VMx+v7FwTVQy4Lxc0ZGZ6iRZb4+c0r1b?=
 =?us-ascii?Q?1jpQgmnNQFiQlU6gPMubs6cKHDvzZymLzw4ZlvuSE+xOajd4shCQHO95TBXR?=
 =?us-ascii?Q?4O3kOiF3e8dp0a852ARjiqixNryFmWqhTN3UyUcwfRixxXb9TEOad+NnY38T?=
 =?us-ascii?Q?xjzfxV4KifPyFxClUCX9ozFZCrGtB5k8Ld65qwM8J5vwVHkXzHvXOPUJsZOV?=
 =?us-ascii?Q?vhd4cCqlFsKB36Wmh4ZCYvuL1Ia5zjazk+uJGUnQXNkagoLv7kAjCJ03tzZU?=
 =?us-ascii?Q?cUsKs9sY9sbfSZvvW7XOLNquh3EJRkz+BvgzF9coULboN7xgA0nWuWQppF8t?=
 =?us-ascii?Q?hJbaUO8rsP2g1/oYFUMuYB6vCktSFJSqFhEHDVwNpsTJ6OSCvoR/IhoIVv6m?=
 =?us-ascii?Q?/0nA1VTVegF51dsHP+L2IvgrZJi8EMzsLmkVqzCvvFXNtZusufG6wuJUhR9P?=
 =?us-ascii?Q?fTwcBAMW4vRXdSQuRqVeFFxziIFZ17PSovv0SynWPoTum2l2NeGHHfqSrJ+w?=
 =?us-ascii?Q?6FSRkjRu3cQsfmgAEHtZ5gXLrtuC3V70JWDUUGOSL4f6dQG1b33Is30eLN6P?=
 =?us-ascii?Q?xrCy7BuEQsa9zNSLWMW/wkNHeS//3/5Dee6Esy8Fi8YZlVf5qV+zo1axfn1R?=
 =?us-ascii?Q?/tfVo+1K/P4ofLZwlH/tuj90vxN+74ZCREiFDGScwS59ii6S7XaPnDV+hcZi?=
 =?us-ascii?Q?J/Bwq4rLOdUXLPf39ZV6QQM6KjBEaBYfHRPQqg9goBoi3E462ts2yA2nunHW?=
 =?us-ascii?Q?Ib1x1eQUnDrZEb19FvPslRt8VxsoMvjzylAR0BjKmA/pvKzl0CD4ivq2YC3i?=
 =?us-ascii?Q?6Pkhu5vuz0VxpdiqFj2LaVjCHC59/hnSDVj6Uu3L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b2c12d-896a-4501-ef50-08db4810e6d5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 17:49:23.4788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WOBSiHeSxMV2cuSvzlpDBAZOq2fi6pWOIFx0rSG04SlWpRxM9b4j/qTglsJoA8+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8005
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

On Fri, Apr 28, 2023 at 06:42:41PM +0100, Lorenzo Stoakes wrote:
> On Fri, Apr 28, 2023 at 02:31:38PM -0300, Jason Gunthorpe wrote:
> > On Fri, Apr 28, 2023 at 07:02:22PM +0200, David Hildenbrand wrote:
> >
> > > > No. VMA cannot get away before PTEs are unmapped and TLB is flushed. And
> > > > TLB flushing is serialized against GUP_fast().
> > >
> > > The whole CONFIG_MMU_GATHER_RCU_TABLE_FREE handling makes the situation more
> > > complicated.
> >
> > Yeah, you have to think of gup_fast as RCU with a hacky pre-RCU implementation
> > on most architectures.
> >
> > We could make page->mapping safe under RCU, for instance.
> >
> > Jason
> 
> Does it really require a change though? I might be missing some details,
> but afaict with interrupts disabled we should be ok to deref page->mapping
> to check PageAnon and a_ops before handing back a page right?
 
AFAIK not on all architectures

Jason
