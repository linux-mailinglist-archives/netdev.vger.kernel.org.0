Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88936F1D7F
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345311AbjD1Rdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjD1Rdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:33:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185612117;
        Fri, 28 Apr 2023 10:33:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgT3WIM7j3+Kc6+TAShTIyRM4IUOAIARzSCUIR3zYTG9HokeotppAqqnbsXJeIe4LAga/iSG68gyhiDsDhCG/7XQNlT2usvAfnOLxC52xvonAnsQQemVrLOlJWb1WjxNGTh4jaQN2h9XMlGAchGO8CSBmu7dNZUDPq+gZwrcdZY+moSq2tQ4OkhKUhqiBq/+p80jcfyDcPVSB4qKObCd5FFpqb8Ue2IA/JQ82u7vvKuHporYtRZEUOAKomcXL/PSTqqRsgkCpuBeATQ577uF37DJ+Gt5Kp9mRPT/97tDx5w/B6JlDUkkyYksDEkH6AyHN/Xg0KhTT4J/SMaLY1H4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E1Vfgu3cqCPPEyTOt1jyATDNwDp7qFRmohQV5JSOXAc=;
 b=Fodr/Q/8YTXMefndPOky7gzzBasS6lkH3JY3ns1lZLsguGZ+rXHvvxWB13fVImjMnnL3PHD3gpomiZN1R3oUcT20tAcaIlL7tIJTTu/jXHovGI5p1OZfRDSTzvijq5Db5T2wYboTLMr+4OpUVP3zz1Rt+wttU2EXqdgP71dUjLhFJCgLXNHR937wmSvlZIyNXwqSkYnaRUFEzS1BTel9KYXtU1Zi4dmadm2YHh83efpWsf3Yblmf7PhEryqdFSBsjqZG70Xr18m881JUo+UaYAT64JOeIkAw2Vs7WkdS70LhYWEF5JXlZKsLVjNBHG3uu/x8swIV3T/vUmjACv9rNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E1Vfgu3cqCPPEyTOt1jyATDNwDp7qFRmohQV5JSOXAc=;
 b=QiyX6vi0UVtbHfbieKgUA9ThcPokZg8ozDPn8qRAtePc5w6GuPAkPNLnTUZTTMnt2vxJndH8TdjHE/2dOdFN/bOyjBdxAxMTk6cVPo6qUaHqaR4L95kw+A2izcdhdGEUp9vhYxLmumdTl65w4QBbXjjt//7Yec8uCkXQ/IBbuysGXBNI3VS/mbKBC2ASLteXon1qXasEtQ9gFENrDAnSxXEWQWCQWF7/YoJiz7Fg0Hq+NCf9ztFJw5b1Hs0PcB1AKrRZfS8EDoWVbUXqe7jiBmdd/PFG7CvFs5RioECIj9N/QB4W/hOdm57KVIVaxqLWf1tBFO2yJdDwDbRnAO8htg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4572.namprd12.prod.outlook.com (2603:10b6:303:5e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 17:33:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 17:33:47 +0000
Date:   Fri, 28 Apr 2023 14:33:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
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
Message-ID: <ZEwDelszXBRwUGS0@nvidia.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <094d2074-5b69-5d61-07f7-9f962014fa68@redhat.com>
 <400da248-a14e-46a4-420a-a3e075291085@redhat.com>
 <077c4b21-8806-455f-be98-d7052a584259@lucifer.local>
 <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <ZEvsx998gDFig/zq@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEvsx998gDFig/zq@x1n>
X-ClientProxiedBy: BL0PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:208:51::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4572:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9cba5e-00eb-4965-557b-08db480eb8fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JUcEFjaNrY7RIBySwyEAWv4dlsYdb+0F6yLHwPlDrHKdDzY2GN2ibABkha96m1iyA7GOcQOIS25zNwyaU+LuyM2mQtSjP1vMvYV+yY4UuJbpOuV+xBqzK1yRjKJ2tTg/YhmXgGKkQCVtQX3waCNMVWTkcg/rWAJp5dLzP2iFuUZdkTqd8bNdU+EmfykCoztkWVR5PCpZwgAhuK7RisVANvCX3JN03qsuDht8ooWSkO7fATrVqCVU7CQBBisfLWp33kvVyuAvFB51kpkDhpRrZfZy5YRVwfo9ECAy9pUU3g6X4X3BlasKWUAsSWfXw2MdI6BIzEVNWZ79A6GcnKZLpRj4ShBL7xytdznXub0cqCoixqcN4HCWeAIhWGUyiMiH+wFKlqVtrSMSULO/C3I1b5j0W3HcVZMC5oEQD5QG+CuEM5xTMQ1374t1lyucR4yGT5qHRwlAng2kpL4ptNj0JZ9mft4H6kBWoOe1pJNrfznzb4gWP00zwGVBAQ0YRinycsGH+0gYZY5ZmVs8sft7B6va/QaKcUVUMXQsNgu7ZAQwPZQuURoly+RcLjgrdlA7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(451199021)(36756003)(26005)(6512007)(6506007)(186003)(6916009)(66476007)(66946007)(66556008)(4326008)(316002)(86362001)(478600001)(54906003)(8676002)(8936002)(5660300002)(7406005)(7416002)(38100700002)(4744005)(2906002)(83380400001)(41300700001)(6486002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gCst05YJ2moqIhX9sX+LLoAStVoFy5D/7SBajLa2l8VZSYKdwbFsAcN34h1O?=
 =?us-ascii?Q?DB4pUVEawB8oykHQVW75+nF1KUU67oqKLf59MUXN14swmtScx5OpAkPW8+ow?=
 =?us-ascii?Q?mKHa+FuEoncdJFtU39aWcRZwOLOo7Xp/czWAAz/4rgV+Jo+0PJQLAg2GkAa3?=
 =?us-ascii?Q?4R6m+QP5YU9dmbEpDi1XQPtGU0DLtzbLHPAikbq8dhx6+aKAeZbiuFiv3ail?=
 =?us-ascii?Q?Gw6f52JAF15bLyp9BJ6GuuFwuZwAmyWyttwrdkAMPy9XZg3sDYfM62lbQsWX?=
 =?us-ascii?Q?woO5WuLjLw3H323xCKVSqdPpsyX1tZm7Tpx/2EqIOgINifxIcaacgtJdEl5F?=
 =?us-ascii?Q?X+UjmsuR5o23FLOMY5V8d+6f4BfjxsMwsEuiszHp+Uc3pCiIAhIQBQbDcsDC?=
 =?us-ascii?Q?jrmDqyJ3Kcm9F1r84ACnJ+dkjdeCI0rlKIjSpVBf3lg430sQaxazg1rvtC/A?=
 =?us-ascii?Q?Ej+f3Iu36amBxS2THziDgQNcRmi9MZuQ2bbL+ACq3smOnVcTnO4T1US4QnaF?=
 =?us-ascii?Q?8bEQGw1G88ZTFZSK5WYWSF0JnBoGCcfhPQl/NgYbFY/a0NjdJ+s0rAFgx5qD?=
 =?us-ascii?Q?756z8+Yq8/1qcpdlsr5y18Ms3lS2Tigb2nsdvn+3Q6TbMzVsGBeaBxoQVNFa?=
 =?us-ascii?Q?h8Tf2FGQTlnZCR6ppa1lWc3RxWb8Bq2igGgi4hfU5l2ycFRKrIfVLXGa2oV9?=
 =?us-ascii?Q?NhMTfCCqsnWS/2Y8w8rR1DDLaLHzJYmFNg/uuUHLloeUrDcVWxlyd6ARoYqp?=
 =?us-ascii?Q?RPfvpAAsG0rNzqHe4+Oa2e4D7ldkiho8OkUPX0QLOOKm9H/9Mmv+IaW75ng2?=
 =?us-ascii?Q?fDxXVTqpshaKZTkNRik+Kiz9dMwY/5ToXgkCLPzOQ9VZIXbHvBc4hhnOf0oo?=
 =?us-ascii?Q?rYNGJojOzF4rAdbrM5cngurcFEGvyqcgfkcdGD4Di3wqdMuq6m7vxoC77QnU?=
 =?us-ascii?Q?x3CGi4wjIfyu6XXPxSJJkFF+1s+82uN5FvklD4veJ7nOy6VXa04TLuixyT6f?=
 =?us-ascii?Q?LriagI9xfaMYfSPhV031pIH/EhauFs3AEHriwy06AGDee/9zPJoEvwa+QiOP?=
 =?us-ascii?Q?IsnoA6m37ylkIPGZFXh179wR7oHgPUqOrm8qZAwN37A1ixUfzLiDSqiBtiRv?=
 =?us-ascii?Q?uGhiCXTlLbW5oW6lUpANFbg+BLvTZAO4f2FxEFmFmryGcia/O0uyDo0qLhYD?=
 =?us-ascii?Q?LS9GplZ1gx3wVeKb+1bvna6+sZXTeWXXw2weTyn4bU51DPN1c/kZ5QkS/Cb9?=
 =?us-ascii?Q?1P1G8Geom/2LmMgidmkjdR1+cVrsMRSDAu0gI1j3bHocA8xz8gh13xV3Fn5z?=
 =?us-ascii?Q?qqJP768G8zzCYRLBGxiVimNu+3y8FK9sX3uztrLGsa7KvIsQEdA7SUDaFVi/?=
 =?us-ascii?Q?9oJsAJ7kVUolcelM6mcqRf/GpYDoGmLeiwfNVP8cfh+V8cQBXQdj5AyCFuY6?=
 =?us-ascii?Q?vZAgbu2GQ8duOH8fFsChNo3Pru4/e33iwmPsNSOnidryswEBIavFLNObHDZ2?=
 =?us-ascii?Q?YYQ0ELNO+zW6jZaV6u5jOKF38GPJ64SeFe2yxRKdTuoqmpylzv2U4feQ74sb?=
 =?us-ascii?Q?9rUJGu0qNrIlkmUZMM7Kay9FOUYuLmoys0qEcwp2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9cba5e-00eb-4965-557b-08db480eb8fe
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 17:33:47.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bz/XCfi9YFwdmbgjZW7VPPpHyDuRTAAxFr1u0cj67+WAMow5aLRO/C4IYW8LSFl2
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

On Fri, Apr 28, 2023 at 11:56:55AM -0400, Peter Xu wrote:

> > PageAnon(page) can be called from GUP-fast after grabbing a reference. See
> > gup_must_unshare().
> 
> Hmm.. Is it a good idea at all to sacrifise all "!anon" fast-gups for this?
> People will silently got degrade even on legal pins on shmem/hugetlb, I
> think, which seems to be still a very major use case.

Remember gup fast was like this until quite recently - DAX wrecked it.

I fixed it when I changed DAX to not post-scan the VMA list..

I'm not sure longterm and really fast need to go together.

Jason
