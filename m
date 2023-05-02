Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842866F4588
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbjEBNvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbjEBNvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:51:05 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E007ED;
        Tue,  2 May 2023 06:51:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCh1srkLKlLKofa84a28whfTxtC2m9GwDqUriAwAHfkxrdVtCEJmfDHoGFYU34rXcStJclwhcMovS/DMTBZZckIh7I4zE3ml10U4q+rY0kbR6Mkl12uOramTcpJtC7gUkMkB17/sE4GFFyVKIHvmzvhJzgpDh+PFsHvsQ1BFUUhIkevgzl3u8JNuTE28sfMbcBFkcG/1YDYabXAMmAudDs5UUWbDz301eoUh3ClEUwh81FRjwbHSj9bxn/slVEO1qcwB+Y+7i6kKiWfMoDYHwxoXEaaSA9TWv6w6L2Yj+1N6tXdGO297GXQb6EJhB8HN9PPd6XUZju/uNFLdOhFFEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDTBnVrE1AVnGhJc0W5eeVhuAe7pnI+KUoY3IACpHM4=;
 b=GeWThYnrV2N+pMmjUmio2xbe8c9Q5Ij9VCklcLIRQv7hrGIO/Fyf4G+9YRYXWgpi79DiqMNCiVoGARDaM6dy+Y78+bownia1t1UUR8bKQ7jcJQyW+14oZ9Urz73Ul9zKBTQLLlDBos0XYYnF9dUtlIjuOU7Zd2wTK9GXdQuU8VoEBGXNX+WrwIs2PRtyGvQhNORsice0pT14fPYspZACdIBT218tKDTxEhPHNCDHhKpWJALI7rBSJOyMJzox8kzRaBDBVAXKTO8ENEn54isfe3feKk0i4VfH5lh4ksitEDvU05DCgASuKsBbSaCpOca4lkPDoWRN+38zcOdTVVJLRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDTBnVrE1AVnGhJc0W5eeVhuAe7pnI+KUoY3IACpHM4=;
 b=UABZPazuOn3gEjNzYeS7DmbyY4/ZIKVeI3TlliuTKxYYzPNPMPkeWmLsvHn85p8KqzUuRns07bEHQ5UO/Bfdlq/01+EkZmgLd1J7DOlNgnWUccyHmstXqH9Dr06ztD07UJZdmO/209+MTBrBW3X8LseC8K33zQ6aHi2z1dSiQ77dDZvsgfSQhcJssK7EnVuay6hBb6bswu2b/F2aD1bFPa1bFyZm/RgI0wVUTWdMEEPN7kEK2crupCYUx8AbJglu+iBNeXTCRQVdD5TgOMBbiChYuJHiJY5MjymEgYdavVXa6vuCJp41MpTEu+fsFbPZHsAnhg/mnyt1R1NGPrR5/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7012.namprd12.prod.outlook.com (2603:10b6:510:21c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 13:50:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 13:50:59 +0000
Date:   Tue, 2 May 2023 10:50:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
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
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <ZFEVQmFGL3GxZMaf@nvidia.com>
References: <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
 <fbad9e18-f727-9703-33cf-545a2d33af76@linux.ibm.com>
 <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
X-ClientProxiedBy: BLAPR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:208:32a::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7012:EE_
X-MS-Office365-Filtering-Correlation-Id: c1dccf04-bcc1-40b0-1f24-08db4b144266
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HEIgO10zT/RXASXzrLZFMzaiKU4Mq1aHXtPh+7K9zIF3nECChMSKxRWoCPpJk1bXLTt8HLfJbnRJYZbTbIX1Su0Z3i5+xWZfEWmkou99HrVr5SODlDtBh7wX0NRVam6I/2sdfIsCycig4d8vtfgHRrMfKQUA/0vWUaDmS0vHUNbHep7jcrQldYqJchTZBYfekePAnNj3P5+L5/NtK9MPmM3F7497kwJC/bb9qh8LqqWY2SaXwcwS1m1N1EybkScYqGLDm07YFbg9aKrQf/XqddSrFxiuul+lwgTCvv/qIrOgfdjTVw2C16EzM8s5E8hjH4YeQFFok9ShZFcUOctTgbZcrefJCZKsXQRBHPZg8aEC/6va7V35HD8y81peYaXdj6Ne7/kAU1vBIhPwHB+yYIthclPjBye4qkgN6nbX7252E9w5LyD7h7nlYw3NlOf9Em18HL9tnUbP1sqt+ypXVfEgsDwprxDFgSW5VAr9ZI0GZDeTwYA3/Tlmj0GX8hpj6P+muLyEXqABiA6IoCzBv0q+xdYwNh5Oz75vDLDgnhiatDttuYcr1FLYS6cscNx2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(5660300002)(2906002)(186003)(54906003)(7416002)(7406005)(8676002)(8936002)(66476007)(26005)(6512007)(6506007)(4744005)(478600001)(86362001)(6486002)(2616005)(38100700002)(36756003)(66556008)(6916009)(66946007)(316002)(41300700001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mrj5DnBw1hwoUFfjXdvV/oeVoUY44Q8dLwJls//LAu+puWagrJj7mxRipwbn?=
 =?us-ascii?Q?nogXX2xVIoHmADPl7QnHMjXwtzHfx7FU2oFeWMGrZ5ZVwSdiDQQ5A9zFNdPC?=
 =?us-ascii?Q?jp0iq0aFK4eHEe6+vTUhN3bN4ktygw5/gaZGkkBsuu6WIemZs8GjSz6w8Q5i?=
 =?us-ascii?Q?tn7YAqGCWLSvtFYWI/qA4hoqlPeL4lWduPwQAWaVqfrFif0/UNrKLzNevm1Y?=
 =?us-ascii?Q?lH346iu+uRsRAhhByyNb3bTSRaxbyY0REi7OvOnIdcq/BYC46IiXeKxHyop6?=
 =?us-ascii?Q?Y+3KFBIu8CQ27tcYYopE/8IfLBx7eQVLlNHCB166MC2YaLR+jX82ckdl5vhp?=
 =?us-ascii?Q?ITDFqWF/nuTeMpLEgycR070AEHXSy8hO9Yi7XpNG7IUf1iijCbU0xbnDlc2Q?=
 =?us-ascii?Q?RHlLWT4oEyE8CNRVnv7jRypOEP+nhbD9mUh7HDzABOeQv/+4WN8sPBEAHzB1?=
 =?us-ascii?Q?+I3DYtExoVb6l+rH9NPnpMIKmou+CrfGc8VJB+sO2CaEohHits6ZCSSi9WDG?=
 =?us-ascii?Q?o0W4Iqi/8AjahuYZROHUvEQXMg2sO//Gi95o2EuMZZDzOWfncSTaySKJ07OR?=
 =?us-ascii?Q?Mg+KKDmA3FwiO3+3VABYTuCTMB/HYG567iA871TxndLsHmwceJ0bftIhFiUl?=
 =?us-ascii?Q?xTGEYXXqZFeh6bF4cxQU38YR/JnBXwTMDguW6r+afu3s5PIWMYYhdK+zGbaQ?=
 =?us-ascii?Q?XSKs0DvXFS3E5uthQ3z1T5o/ZQ5wwk/ZHwgcX8HZq7MDfGDg3jBJ6JYzBS7a?=
 =?us-ascii?Q?pp3N3yAF3RrIzrvcWVER/Eei6xNcu7JtWL9wtH8UYKGw8fTHWtXQyxTcDmbe?=
 =?us-ascii?Q?Kq5J3QaX5DqF1V+HvJYyo2fpr6l0yZMJzNtOi9F07qjYwGkv9knrtC+4fXsb?=
 =?us-ascii?Q?goz1CejdDOW3RLD6uy0NqlIszRk0O55kq+fZ5zEaz6G6TGZXxdTJlLV1x9lj?=
 =?us-ascii?Q?egl4fC60469aktzaST2RBwCCHT54mxPezEo3EKa1meBhsE5Ym2pVTolCUg8s?=
 =?us-ascii?Q?GdaBHN8MvN9w5aBOMQtT7zm2pOnAlkQ7/etHnJ5She2D7feH2n1dEgWbrfIG?=
 =?us-ascii?Q?3c34h4PxWpHxB/uJHWC1wd4HNBawXp4jK87wBo4dRlyCJ8Q3m2+KH41lchl+?=
 =?us-ascii?Q?osV+dgSHjpN/mrDbYtNVHjKmBdg7ie7l9eMC0xQd6htCn6bdIPgys3CmhlTP?=
 =?us-ascii?Q?mRs77N+oy+kgbeMooS5G6VTJv5atBM5QnQRNKoa30+3hkUMuMf84Y0xRcY1a?=
 =?us-ascii?Q?bWbY/UDqvtTDLjxhMPhNGa7fl8A1GSWrngx21w5Bk2/ZA5U4rC0xknVDcGrN?=
 =?us-ascii?Q?hea4AMazfzxWKmMMpKVkl0aEXBIoEXK1Z5cdvOmQXhhPZ7NRpxxSajPvaCCm?=
 =?us-ascii?Q?xAJziv4lCV1A49krBMbzvbf+h9G/Il5RT3T/QPY5XLBd5bmm2b1qCfgsgUgm?=
 =?us-ascii?Q?PUL/7Es+o3+LSjZYylOAO/LenLhoZRCS45YVrhiL+b5nA1s7NA45mqMgBlrk?=
 =?us-ascii?Q?kLUF1s3+imF4XuSyhmKSeXEVXNd1v70zk95y1hwUGVCFgAMk5z8EfhErrPZm?=
 =?us-ascii?Q?YA2KTzbafV9bgAAHe1eDv7YONBtI4nlUQ0cUMSzM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1dccf04-bcc1-40b0-1f24-08db4b144266
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 13:50:59.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ueCrK4TS9J1krYwHAd++AdGaeE0+lgdNsuKSqeP7B2xHrt2Cfex2pM339KHYujmO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7012
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
> > Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
> 
> Okay, so IIRC we'll fail starting the domain early, that's good. And if we
> pin all guest memory (instead of small pieces dynamically), there is little
> existing use for file-backed RAM in such zPCI configurations (because memory
> cannot be reclaimed either way if it's all pinned), so likely there are no
> real existing users.

Right, this is VFIO, the physical HW can't tolerate not having pinned
memory, so something somewhere is always pinning it.

Which, again, makes it weird/wrong that this KVM code is pinning it
again :\

Jason
