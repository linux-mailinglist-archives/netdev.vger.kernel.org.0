Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99F576F45BC
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbjEBOEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjEBOEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:04:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C0318E;
        Tue,  2 May 2023 07:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vf2u+hq69bmLBrr92m0BZG7RQub7yAuKYjDlTvK7xzyf2g0/FWMFjyDM4n+Bj0pBEHMrix+ieA5IecqYfRiXdYTPvDW5gyot9c8W3OAJC/Z7IYzA9Gj3E4bJ3zHUKyEZXV8Dj/mvaaXbdl7JSYkGq98jmSaoRMt0ohTLcuo/mjgF2lxquvNLyCuHuyrkEbxvpSsDG/3vD+DvyqI8M8S8ZtBliChdKQURpRaW0YwGu5REobQdWbNEU1B7P/KDUQH93g+uW1xsum8Z5VG/tuWkTs/qKbEpn0TqyFKC08k8LdfhjVLwD4v1TF8JCcHEwnGLaBbYcun/E0NoGTsb9d+P5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YWyb8CqJytYwagtqVf04XG779EIGuTcRyCVfyx5n65E=;
 b=ETptffBPU8x1wbxqUm2Y+70XUHUZGzMRNa4yDTAGiUA0mmsuppoKizPD8nk2ZzIjdOlz0CoELRkay9eUdWLGtIUQCMH3nObbKZmUdo9TJjXGFF0b4vb/3lRdaCsgZakNIAZQEuxnXqXU1xYtMPjaXrPyv1m+RCTDHMBbBLrL5Byq8tl+ePgbCMHdXrehkTL0bdDzFC4H2LGytKVrIpmdda0PcT9wxnQttzpdXnQ/C2dwep3PHxaCtPY05NIy1LL5yovm7PfI3cUJ6ehWz/nv40eYNhTc9xST39Of+dfmWiPy0CUpCe/kiyWBFczaNNhckacZOQOkNlPStMGXAQSfrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWyb8CqJytYwagtqVf04XG779EIGuTcRyCVfyx5n65E=;
 b=N6YLmN4o43ttBf56/thx73WBBPnbEnXplXUMPy1wduelYenzMlDNqd2PMDR2SkehsBQGp+THabxKb0WyKkFFgxx8bXoofdNZsNEG5dBiUAR0YEA96ahNUitMt+1FiZ9n8OLsVRTBV91TUbr65JI5Xlwpk048DTT/Uvpcyk7b1pQMvMNZ36ezM2dsu30Vo//zVFfXwBexrucZIMMoEybzrOVAWH6WEWgFIFbvI8/dm+nSu6TwZofs85KX4Qucg/deB8azF1fq0RmVjQpb7KotlaxhzPxEHIvhBGOgzzGbHABRwbS48CQnLKc8KERaRhKSXjHrehddr1dK/Dqfp53AUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4492.namprd12.prod.outlook.com (2603:10b6:303:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 14:04:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 14:04:36 +0000
Date:   Tue, 2 May 2023 11:04:30 -0300
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
Message-ID: <ZFEYblElll3pWtn5@nvidia.com>
References: <7d56b424-ba79-4b21-b02c-c89705533852@lucifer.local>
 <a6bb0334-9aba-9fd8-6a9a-9d4a931b6da2@linux.ibm.com>
 <ZFEL20GQdomXGxko@nvidia.com>
 <c4f790fb-b18a-341a-6965-455163ec06d1@redhat.com>
 <ZFER5ROgCUyywvfe@nvidia.com>
 <ce3aa7b9-723c-6ad3-3f03-3f1736e1c253@redhat.com>
 <ff99f2d8-804d-924f-3c60-b342ffc2173c@linux.ibm.com>
 <ad60d5d2-cfdf-df9f-aef1-7a0d3facbece@redhat.com>
 <ZFEVQmFGL3GxZMaf@nvidia.com>
 <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ffbbfb7-6bca-0ab0-1a96-9ca81d5fa373@redhat.com>
X-ClientProxiedBy: BL1PR13CA0336.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4492:EE_
X-MS-Office365-Filtering-Correlation-Id: c546156f-6cde-46b3-b97b-08db4b162935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U1GA36bOEYwtOLRpwp2p4RCTcX+SPRA/9BZZXTSrjk4MQoFiv2jMDxPDeud0tVlFB+uwbjdSkp3agIBZJD+VweeCg0/lqp4WGA7bubZa5FlMg+riNC2rYxpvelfwGqmUmCSVTg2uf5fCsQLELtKEw+G1CEO/7sDxlQ2apBDaj1rkOlk5/M0s0ahe7Z0k/awqa2uY2jme4zlR50y3LNeo1qigvgDETXs62z7WIBRW1gSrLFWt1FNebtGzpfgbjhy5rJxCgw9rbiGLglv5cFyxjsRCyfGtUnxQb9AjP+tPhzJm+fTi5SUx1OVppB0UGcjhUCdWT2GKBLHbYkv8SXjI8pS54f4ifMDcDl0fwYMItyCPk128K3pG2UQzCy43yqspFuTzY0txUECwflefYDCyElJffJEeHVb2EzUxVbwMOihVldIb1rnLgtuxfw/qL0yNQgwrYqgCbSInhbyXqeX4KPO+HS1jROBy7+0h61lAXmDaw3zXDzX72z2SESFuumrPnBukZEkXkM+WL+Y6+JTacwYvc57c6R9K3EYYpH8uLXyQOP7pAcwUzyXE5meX8qQW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199021)(6486002)(6666004)(83380400001)(36756003)(2616005)(186003)(38100700002)(86362001)(26005)(53546011)(6512007)(6506007)(2906002)(316002)(66946007)(6916009)(66556008)(66476007)(4326008)(478600001)(5660300002)(8676002)(8936002)(41300700001)(7416002)(7406005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gdkk57Lig6+JmaV9iszwCGK+OpaREgDrZRreyK30Sk0FWLAS63KJpy1oaJgZ?=
 =?us-ascii?Q?+IbYUnwxLnRY/mPF/15UvthVrsCQCUdQy8VHZSMNuBaRwixwiWsjUbMLogHJ?=
 =?us-ascii?Q?2+qqw5q/OHvTy3ZEejogJHKEFvw/jrH7Oq4DijEeWXBi73Cge5fRU0lD2/CU?=
 =?us-ascii?Q?fklf4FaKZH4Ibl38h/SStxTDjiHGP0ISMqhYPJO0DET7pLLyoxuFH8OWRjx9?=
 =?us-ascii?Q?Qjf31NckdAYBR/oDcFjNxAT/wUD16SJMx8qtUQYJf/bJBXxGz/AVZJW1uRSu?=
 =?us-ascii?Q?2IwvisyPRwU9vBrfO0NI1TmMHdbFQMhbgdy8HmnMNWXELuwO+XE63XIdmTuw?=
 =?us-ascii?Q?d4WH/IAgnmdIaJb3ythCuEiwQysbw2CFx/xd6o7KzLeHP6yhPzaTl/ZaO+h5?=
 =?us-ascii?Q?QYLBZSA2MPlucT4DnThRbpCYkS3nzT2Z/HzV1eZKMq4Qb5oQfhDyT0JxAe6a?=
 =?us-ascii?Q?IEkhWm+jHW/od7hhqmJ82YY0W73Ym7WZs8PGbJdKKzEhAqkTFt2v5mSlmQ5Q?=
 =?us-ascii?Q?q/Y4fAASl9475PfWBlRkqdoy66neCt/SpO+cCNkU6BhChZJSuMQUKG7WYWxr?=
 =?us-ascii?Q?DzOFQ4erFBX9fICPW+AGg927n0oQrFFvtoWEf6bd7xxHY7ITVtD6zSkHHRHd?=
 =?us-ascii?Q?4/jhfJrx9ruawIaIHsDXCgTa7p8EJ7nWS8FPbLc4bjHtX+ffylHmhQKFvu4l?=
 =?us-ascii?Q?wxJNMt5COwwcdNTPW5PR/gmmKT2Ez2jWRB2gO+mnnvHPkr50PcsFirCKAtJ2?=
 =?us-ascii?Q?1kBjrZZdPLCQWocruZ7VhX3pZKdw4C90vcuks9SiWiCcBhRqlynqvfdEsH1+?=
 =?us-ascii?Q?AQtfyUNJqwcal93NrWdlbBaPA0/oz14QMCAoYoZcxtVfOG0SWddAW/9ob+gn?=
 =?us-ascii?Q?NH7zD3E/QFYcfQ2SrKg1RJLWztzKQagjPgMacS53djQBP2VizE+R19zT4qlD?=
 =?us-ascii?Q?5IDDXPTwoQwO/4dwS52hZtWQo/BV29cOXdPvjdsaMFHffHRS6DnPBk4O2FcW?=
 =?us-ascii?Q?4W32P/4I7Sn/8cwmlaHuFHzOaxG6y6GGFQXxvVmiEudx942F8DgSgC4tgiCn?=
 =?us-ascii?Q?yarVK5cT/MgbJe0snkSArWsNrTWtR8aksnB9dv0tfT1ejWy23l3rJOLv+ynM?=
 =?us-ascii?Q?rSfW0PbSLtKDIMVBZm7fSDnlfbLjKzpoiMlHRsFbfQns7b7F9LX5nYh/usFR?=
 =?us-ascii?Q?aR7sQhFnR7qpVB9c6URN3hym1GUJzAqG8kBYMpgZVhCjGV5ZdmYpymwLOAk8?=
 =?us-ascii?Q?B07Y6Psri4D07etK1PZco/fiqucK3rohZArXp0jkP0Oi8v0nkn/r6cF/gleJ?=
 =?us-ascii?Q?P+afQ1XGDGzPLYP0YdyhRwWVXpxka6cxXdpCHq/dHQvCAzBuRaqWuGI+ku0G?=
 =?us-ascii?Q?y/gFI0HjhB+BFprJsy0cJGiJJcR4/y327HY6VDhaZjsP9DmHTwjUdcV9rlPk?=
 =?us-ascii?Q?M1jma0utuYIavhSQd6gbG5pjkTaZOpy0PT3CzS1JD21tBFU6/7dhIpUVBGjR?=
 =?us-ascii?Q?P9ReUXfx7ttImwz1LgA4dPNxbyu5ZgRaEOeHvQKmeQb3Z4aCNlZ5vARL/jaB?=
 =?us-ascii?Q?kGQJyFxfci5eujstGCXumBz8Jwp/DoUaz8mboxIT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c546156f-6cde-46b3-b97b-08db4b162935
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 14:04:35.8464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6cxgGEN17ViNVOfhHSbG9ogqt3N1ETAkLIrQF8/R2oNl0zKF1hQcp8YqLDksRNk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4492
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 03:57:30PM +0200, David Hildenbrand wrote:
> On 02.05.23 15:50, Jason Gunthorpe wrote:
> > On Tue, May 02, 2023 at 03:47:43PM +0200, David Hildenbrand wrote:
> > > > Eventually we want to implement a mechanism where we can dynamically pin in response to RPCIT.
> > > 
> > > Okay, so IIRC we'll fail starting the domain early, that's good. And if we
> > > pin all guest memory (instead of small pieces dynamically), there is little
> > > existing use for file-backed RAM in such zPCI configurations (because memory
> > > cannot be reclaimed either way if it's all pinned), so likely there are no
> > > real existing users.
> > 
> > Right, this is VFIO, the physical HW can't tolerate not having pinned
> > memory, so something somewhere is always pinning it.
> > 
> > Which, again, makes it weird/wrong that this KVM code is pinning it
> > again :\
> 
> IIUC, that pinning is not for ordinary IOMMU / KVM memory access. It's for
> passthrough of (adapter) interrupts.
> 
> I have to speculate, but I guess for hardware to forward interrupts to the
> VM, it has to pin the special guest memory page that will receive the
> indications, to then configure (interrupt) hardware to target the interrupt
> indications to that special guest page (using a host physical address).

Either the emulated access is "CPU" based happening through the KVM
page table so it should use mmu_notifier locking.

Or it is "DMA" and should go through an IOVA through iommufd pinning
and locking.

There is no other ground, nothing in KVM should be inventing its own
access methodology.

Jason
