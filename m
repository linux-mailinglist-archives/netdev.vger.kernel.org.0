Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643026F1D79
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346370AbjD1Rbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjD1Rbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:31:47 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D371C2735;
        Fri, 28 Apr 2023 10:31:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzBPScrY5O4KQ7zUXgCWw+sB+tFk4U2ct9qnm0RFL1Xag9SrHTHQxfmteyiiWx5e0TiCOSESg/lN99jPuoGdkHYfnUEURN2eFV+jC1GAwc3BizCWL8umzhRvPewA/chrb9AAXSe+BTuqzuWU+hYHogLxXvVShSJLu0ILqg5pq5msCnf72x/5kRyeJkp4KBjSNGs3joV5RhoVbSYMXeDpIyE3eqBy2UWKhNvRXSkk9lgcxR+ew2ZGT97jA1JzZq+LVARP3MwLk9m7k9YKw+mpfU0YLUd9KoLXIDifSTcOAQQTkAfPtyRZ8HzfTQlXlnlASY5XEYIQ+AAJyDisX3uNvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9hCcmYGCg54hor/n3ruFVsyc9Dilaz6NuMi9Qyu3FE=;
 b=E5mzoRb3KeZzTsXdfA+GmKXJ/W4WTV1G70QTSXXcgyhF5zA5e5BC1sy8UarXrMFgm4co/ZjQTNC/jgw8ic0+9ibWjQ5U5rdADsw1hu+mgFmY7EynFFTnfH6J5dEsJlCuzstZvL8NybEpRZjykqqItY8Bbj1cxTvd9Hn50ckZAewv7ntoXBfTI5Dxen7vDD/HR2Sb7MLrfna6mjQSBFjCKYkYfjS+Zi2XYq8QpQb0bDZ4t7AFGdn55n4Kft3bHZw1Ny1HEzLZzbupkow3ftvU9dSMxpc+XbP0L4dCElzYaihALsbP2mdYxNiX/+YdTmW3KYnOI66dvg83R5cWW50kUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9hCcmYGCg54hor/n3ruFVsyc9Dilaz6NuMi9Qyu3FE=;
 b=HjtpwrQrMO2V+8KKVd9ghOmkFV5+DJhDHSKQCsqw6JXlZ8YPzDljtYRbGQ+kGQeN7O5gdKslibs/XSFh6//MtKxdl/Sux7WUPi55BnuNce8i+XhHc7DDu2z7F7MF+TuAaa/eAz7WpQ+wl8yEhHQ5m2ToFMzeSqFBr549VN0SEHdWLmuv0ffcSjxLsbV46gjBoDFJJUfoqB/mGIhFbm/d4/KqXYQqV/alJiFQIVkXXeV5Wh6BYWK79jJRFopWU/ZyIcCOr9nWyJ/yhYmF+ywl1T1cyyMx/VtS2OZ0+tMGPRmDs9rV1TBDGlogONTpGavpy+L6zwxAASjIOTN4NFhVaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4572.namprd12.prod.outlook.com (2603:10b6:303:5e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 17:31:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 17:31:39 +0000
Date:   Fri, 28 Apr 2023 14:31:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     "Kirill A . Shutemov" <kirill@shutemov.name>,
        Peter Xu <peterx@redhat.com>,
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
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEwC+viAMJ0vEpgU@nvidia.com>
References: <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
 <1039c830-acec-d99b-b315-c2a6e26c34ca@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1039c830-acec-d99b-b315-c2a6e26c34ca@redhat.com>
X-ClientProxiedBy: MN2PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:208:23d::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4572:EE_
X-MS-Office365-Filtering-Correlation-Id: 825fa88c-3a99-4e9f-47dc-08db480e6c5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OFL7dmUGX+wlp52zW/bRakCIhJIx/p0j5LEnRPbAPyur2lN1MsMgjxhFq/bUaIusG7uyXHBouLPupKdYNeBewE46t0JBbJSpjn8oQrSM2oEw6kBug0mCgtXhF4ZV/WK/0PMH1jMhbes/3xaG5ELA1mQT2HuGVn1pHYj4tnK7gDGuxQ94N5q424kKexdtcbtcydRSlMWS7vCGaZbDnw8k93RKFdxh/F5bCwYer3MTfqlnZqm/F7NeFLSo3/bYWWOBBnrKbx02IEL4S8kxH8l4P39mxHGe6xcAvrmHrX1EgsV8Ziq3ZoMr4rADnc710+lC/GR07nTeEEr3woyNCQwNQpu8SCidUXr+0iqWAETT4yPSbHq4AnJPVFx8ACDU17ldY2uS4g5i+puqvWKpQll2cSrOH4/MrSfNApKj1zlEXV3DumAvOQ3A2QSjSU4CSX8dMNfQ2JeGBGzy9Rw5AHahmiulI1LcNNyfuSXV/sjMZqunYn5E2t4ph/IA10YhNtMpigTH5tEdNIL/4v5xyKMgU8JC76yP0JFwcZm04cYSk4qctMBkUbCOZtLKJ/xzdfJ3RfjQmVZ21sTH6iymDDdiR/oCczeToaPYpVgSg1AyGt0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(36756003)(26005)(6512007)(6506007)(186003)(6916009)(66476007)(66946007)(66556008)(4326008)(316002)(86362001)(478600001)(54906003)(8676002)(8936002)(5660300002)(7406005)(7416002)(38100700002)(4744005)(2906002)(83380400001)(41300700001)(6486002)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ee0JtRZuqJKCdBeARMtykk9oBzZKOq2HgTV9G1G2/o/hgiKUIoAYRk18eJxv?=
 =?us-ascii?Q?EKTp03kJOjub6oxnnPCMyxxo7aycZif7xKF/zoLiPVMe9r3b8QEcDHFTwLD1?=
 =?us-ascii?Q?c8N9/t5vD+2H/n8dmKqRh5Jgh1mT0Hb7Kk/5lbgtNTApW905fZ2axSsoXf0Y?=
 =?us-ascii?Q?Z7geNNml5Br5QCynDM1RQVgQKmGR8JqLNuSdQ3yqakGYJzCneP24T4jhmc49?=
 =?us-ascii?Q?om1OO25LN4DdK2GxY6sZcsRxr9c9jjY6s75mkzJLrYD+WD8eYbGSpgeU/m7K?=
 =?us-ascii?Q?0z2s8h4LMSSsxS1ZmhqPBvQaW0ggxMpbZFubiext4IBmd++IuXmLMr5NtkKQ?=
 =?us-ascii?Q?ADlp3BIemmznuplj9HCN0EqxtT4blceKaJ8oUFJaKXMq2lQSCDwnzTtYXmJa?=
 =?us-ascii?Q?69NPUNwQ8wXTz9Tb61TSR48CiKzZLXO2S1mXZWoUbwTNvFjTk2ElZzBmVkmr?=
 =?us-ascii?Q?qzg7nvQ0V0E0Sy7B6X9bweb8/cNq3y8gmTcDx471wwhoEvXfJRBLlb8g/GA1?=
 =?us-ascii?Q?Lws4ymdjoQ6NgqaVUE67CF5P35UMdt1qd3KlUgZHC4ncY0YBrmLjS8uZudnF?=
 =?us-ascii?Q?myFhDEYaEGkjiD0pj97k2joVTgGRqjd8inGnmY+h5i9H6zthZSmZyv0RNgLx?=
 =?us-ascii?Q?GadnPvjivQrWNGXR0YMeuhwwZ779utb/QunuoterJSQH0Xkw8aJLuCtov+gt?=
 =?us-ascii?Q?5QtKKPPIpzkVRk0PDccFGeupdsmMBpaZjCZuK6RqnVrqtPzjpQ6tsoyxzWvP?=
 =?us-ascii?Q?toCS/m0sU1EeHsXzCqdBj36izPnq7DraYZgtaT0Dcp1oioXvvNoRhqAq+BWo?=
 =?us-ascii?Q?nh8BOCSj5O0Kmzl3SyUxjojukejesHbQ16N0kmxwW0Z1PK1BY9A3sPQ0LJyA?=
 =?us-ascii?Q?PBdTfpYdcZCFNjD/49Rrctm7vcDoFN+NurCngD40xgW8QD0YBGglFquktYx9?=
 =?us-ascii?Q?Gjgpu1ecW668JWJZpLrdFUiS6W0iaPM51Rj8B2gRTdF8CEie5XWl5em4Sx9f?=
 =?us-ascii?Q?5pq24yZKjDH6vzqHFcO7Lv/Hqhmeu+jZ7cOYiPPI0nXH3yH/8sFfrHQrJCkz?=
 =?us-ascii?Q?oFd4gxySiTzIOVbhWQnXYmSvYjwbzJxgUWv8+HCxsvTunK26OJzpl9DksVc2?=
 =?us-ascii?Q?NVjhGvmDyVTyjpzTOjZ9CFiUyfAcg80uTHjoRmCe7hrxmOEOvoi963GdIXw3?=
 =?us-ascii?Q?/wEMhLc5xKtgOLbl2mfGTWy3MI9dvPvj6xf5JdtEkoykRKNPIJBO/ZpoDBBM?=
 =?us-ascii?Q?4KF6iKKtEQx5HgoBZXnOSGAn5fUc/OVBS2HLOencR1XWKzmOioHhxiI2eLSt?=
 =?us-ascii?Q?ZEj9Gyi8jLfzl3Xqr83Hoe5IY7qep4TU3S6Nx7F6lfngueIypNn9F0GMg7Eo?=
 =?us-ascii?Q?uiHOAELHS4eaHOIgdJFq2blPs0FZS2rh4p1JMR8PlbfykVvfAnILgRYzwLPd?=
 =?us-ascii?Q?Lg3dfaK2szpRTlKNFEfg1ckZfG5ELBzRgvp1/0mNMMUFBSqE/eNngpSnYz52?=
 =?us-ascii?Q?f1qfI56pB7dJTpfJNveHTQkjE8QbW0AImFODr0/VEY8NHa/urIn9vMA5N510?=
 =?us-ascii?Q?TFFlw5o3I7N76nXSCzZTWkmI7wQAHrTcNVYbWDpw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825fa88c-3a99-4e9f-47dc-08db480e6c5c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 17:31:39.0038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJaeHR315wTSR8xP4rEn/se47RvBNZoHussyWkQ3zGOT8li5XAQghXYcya+aiQVl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4572
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

On Fri, Apr 28, 2023 at 07:02:22PM +0200, David Hildenbrand wrote:

> > No. VMA cannot get away before PTEs are unmapped and TLB is flushed. And
> > TLB flushing is serialized against GUP_fast().
>
> The whole CONFIG_MMU_GATHER_RCU_TABLE_FREE handling makes the situation more
> complicated.

Yeah, you have to think of gup_fast as RCU with a hacky pre-RCU implementation
on most architectures.

We could make page->mapping safe under RCU, for instance.

Jason
