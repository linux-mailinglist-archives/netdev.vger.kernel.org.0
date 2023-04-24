Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702F66ECF5B
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjDXNkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjDXNkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:40:00 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2512976B;
        Mon, 24 Apr 2023 06:39:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V22sSCk6X6DsXp5sBCXeWU7nANsAetN+halNW7LleI55KZk96jGIodVmPkVJsJQ1kjkERablOHxALQCi7AchrVCXAR4DHOsNvLZXj+laoe2vkJjveHn/ZVOTXuWeK2v+YOI6TrKRwEd8iI8lVBjXnFHEXtn1EK+uhYf4U4JOs+kyYtSzs4xXNujcjU0GupQ/LYovbEoSQqagfGh40GW+lN8I6CFw7DY8NA8DntzzpTMRaUerq52C/N5isREaqbb+/yy0UOD3Cfax1fZpH3SYal1hZs/w0bcGEoheVa3Tz4J+NtlBF6htEXpmQuqKU3MkrUfqMLlE1sO46Jw8xs0uBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyxIp+QIO3N5kHusUbepTvHzISZiQjWq6k+r2x9HIcU=;
 b=R/uRvB5wSnSsy/2Rzsqp8ZnxKHIDE56lzePNZAU2LxvXedVZBh7syIoMaN8yUQXWoVo18bBXxIgwDGXq9z2vEZfk5g2ESFNv4On4L5sKCa/ZUU98v6KzjWkRIG4J1tAxrm+XfAlepYSJu/kB9jDBkDkjkcKgGQ7SuUWR7tDmzIUqqvr0O7vPSiJBe/U841cOy8xl2z5XKGCV7a1isAg9cKxhfTlQ5I9lhmeUGJ/aN8eSfO/vVlwJscngHIH2ScYQnZ/THsHhjvtunR6vEvXU6Hrz5PKyv4WV58SHQxYb/yu6fzIHYNb06X/ktU27+71vmIJNaOn2ptgYeOrebfIJXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyxIp+QIO3N5kHusUbepTvHzISZiQjWq6k+r2x9HIcU=;
 b=qzp4XMYW5uGc0oFutAFj9TOEqRR1Mo6wHDuMjtDHj9P25kRLczqyROy06BQpQda/4z/Mv2WMGeP4iH/1iA4b82E8Dfdxwn35mDQxYeL4IXF8jbik3wMuF/PCqnfmpBsMqykSueghEsNtaSNKvCREwPdDtvs067nOv7roHBZ/7pdJvMB7QR3xpjxNclrWQV1G1Qi03KYDzxKhVTlL74xGyYhUneD8AxCWubR90v+0MdqHAKizvjMOmCoCa0ANZmInUHj4WuuuqrDalFDCr73ZJX6jRSKeZDHmWzNhsY2OjcF1CyExVXSPyS+CviqLSYsYQ/6W/w1kXTKGS4Y1Az6Ldw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 13:39:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 13:39:26 +0000
Date:   Mon, 24 Apr 2023 10:39:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
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
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEaGjad50lqRNTWD@nvidia.com>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
 <ZEZ117OMCi0dFXqY@nvidia.com>
 <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8fff8b3-ead6-4f52-bf17-f2ef2e752b57@lucifer.local>
X-ClientProxiedBy: MN2PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:23a::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: 217044ac-5185-4cc1-30a6-08db44c9523d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e45VGVpI9ybwKK1Yt728iv5O12LcdTcvwQ18xwBnz06qw8WaHVQ0iM8SJwsVvl+0AHT7Eik1aSf3RjBF/tTFG0qhl7ScUNYVeiETDdHYpt60dtQdGswXlApyLUamDOUfUUhvMyLIk7QJ8wpFPtjT6GmRb/xRXbYug86uz6fc9tMNynfbmHEFN6um8kBLDh9nJcZhZXwdBOzr104fZNBU7Otxmnz88GqLoZ7uVodFwuQSbbb/Fzpqzy9sPMgb2roFtxLi8c2XohhpUQK+AeFtDQyCL4TufW/CnPZuh7bo0EIP2pK2ypMKe6Jzo0zJn1NgPFInrH0FDzXnOsaJSaIIziZj0JCXVw6AaHzNbK5YYSDymILJFU6tYc38hlRPhSJkuCvmlmwIplcrjFEkLt/iFsBwEawHbGMGrpRayb5VwmVnXkbLXkJTyOim8YHQDKlSI80zuQdOWBaxXQSHmv8KF8Xieok2P3YXrHJwPbtopc2DI3JkImnHT9cC6L065j+oTv6F+sv+OQGJ6urtSADuc32DkJ0r0QrXMUDKn8Fvd988CNu0A3wbYMr/pPV00zAD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199021)(2906002)(6486002)(2616005)(6512007)(6506007)(26005)(186003)(66946007)(66556008)(66476007)(8676002)(8936002)(316002)(41300700001)(6916009)(4326008)(478600001)(7406005)(5660300002)(7416002)(54906003)(38100700002)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TxtktKP6JCDYWQagt/DzfhitGxsKdpAhoJm2esQlVJx+69Nhzqum/qbJlY5o?=
 =?us-ascii?Q?hlE0HC6ACUaTpYaqbEB7iZeC9DsL6mhCn2FWHBzxv3lr83D0r79DY9WVeypv?=
 =?us-ascii?Q?nOUX0q5MCYfxRe1wuUJ3l8ox867jHktlZm2kId17Rsra0MrdniPuqUBKpmhq?=
 =?us-ascii?Q?8aYzqc3dHgcBhI5DXE5fvLRf15xBpdXE2EeMG6MycI/MtSgDx2+BJ/hjUyUx?=
 =?us-ascii?Q?HXyhonvcxH6UipntpMPDEcv/74vv8A2P7jlazZjb1yi5QAUETD/iKnN0/XwZ?=
 =?us-ascii?Q?35SKT7JnXo9Fp4cjsrKrwx/64Gz4lyIU98k/Vr9at+Cbeg8y5BTFSycdJJTW?=
 =?us-ascii?Q?azRaUfXeHUuhSLRnkb+nbjy4YGd+C4FQ1QOAHewKY7N5hPr1K4XSJJH9Q/1N?=
 =?us-ascii?Q?9J05O2gDntz0umYMrNxbkFv4mgZXUeuekOP11gzHqqs+/wEOrzFzIrtlljdV?=
 =?us-ascii?Q?6kgNfYk/LmbTkfgUy67FyUEUpkDFF0oIFYBOAa5kajzhM+lHiQEBAySqN1iv?=
 =?us-ascii?Q?ShRU90jK4XHqykha2gkQY1d/+5wSWDUBwTRNB3ImSJpDBaOjw3p855TeAjXW?=
 =?us-ascii?Q?Ui+TckQifjJlWw5uRe5giyoUBgK+vryUimZ0QrYyztf/2aT1ILpoA6IKb9HJ?=
 =?us-ascii?Q?dqDYv/peU1J8rJq3UaN7r1jHqdB6nj7Slb6Ghs4TwEDGDFFISDFl6E2sD7Rv?=
 =?us-ascii?Q?ZlLYJBbxwAZxQ8TOAbMpUhMT2qKvKzojZ4mFUs6l+7W6VaRCJqUFWYWJ89V4?=
 =?us-ascii?Q?Qwqro957IbMytDmv1cktFzPDyon7JlKOBpHt3AUSwkFsf+ZxHV8tAKyYS0k/?=
 =?us-ascii?Q?vYiCCYMeXPkwa5iGJ5iGndCA2YyqJ2HbULKx66h7beB8+pVRFWdGGS3IB0at?=
 =?us-ascii?Q?qAaX14CeIf2pIkdhAVbyHnXmGqmM9DLIZA7Aq2AzCMwzWo+3JIagPyRzndPV?=
 =?us-ascii?Q?m+FfiAW67vBsBNrRZgTBh25layBGLkE2szJoFbAyQLm6dSFDNtGTVOitMn/8?=
 =?us-ascii?Q?8MhveIK6dkoU3i/fVLSljdBf9cNl57pfqz7EGPDG78vYW5KTDY9c3NHc3GEw?=
 =?us-ascii?Q?n9o315ipfzs82SY2C61Va/FGiGODOtHKP/JDoQ1myB0iclioSsQb1+Bc+VI2?=
 =?us-ascii?Q?8IUnbn4a8l8QZZd49X76CIaZYdbdHIb5b48IswW/3SykHoe4UjEZ3HVHBszZ?=
 =?us-ascii?Q?REf/B5utubH9OxfKhAoZPkp/2s0pKN1Gkxov4NNswj075oZ1ed8HgbUXgux/?=
 =?us-ascii?Q?YjxmDT16K+9YtQZwPkKrIXFMKngQgm2HW7ZRRRPGlEjqnKyoU4Rw3yE+x4BU?=
 =?us-ascii?Q?vWrCiIy9bnNtifB95h+yWV0lMGBgxcfS2HNXFd2ZSMCr8/d1bEnF/t3FK0qN?=
 =?us-ascii?Q?eynIe6+wEfKgTWq0hWxrUIomNT1mpmDbOXgWTa8ClqDdo3Nh5ZWede94trBk?=
 =?us-ascii?Q?zwEQBS086+MtvHSc7LsYJg2dLOb3RLHZXU90uLfDJDm+efxUXZ+NQVj6HStK?=
 =?us-ascii?Q?bVHMlQrHAg9ClB9b/fWEzUu020a5+XoVt3TEDD9uhZzfTDxWAjcXfQFlaHX7?=
 =?us-ascii?Q?UkywdOagjoT1GR6WkILrFrL/+SmF9n8pS3UHPp6h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217044ac-5185-4cc1-30a6-08db44c9523d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 13:39:26.8143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mi0UpQtPuS7bSZPOnnluAMXvYlMxCZ+A6ZkvpyXqCKP+MyPL1s9nPvIF1STLRyfQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 01:38:49PM +0100, Lorenzo Stoakes wrote:

> I was being fairly conservative in that list, though we certainly need to
> set the flag for /proc/$pid/mem and ptrace to avoid breaking this
> functionality (I observed breakpoints breaking without it which obviously
> is a no go :). I'm not sure if there's a more general way we could check
> for this though?

More broadly we should make sure these usages of GUP safe somehow so
that it can reliably write to those types of pages without breaking
the current FS contract..

I forget exactly, but IIRC, don't you have to hold some kind of page
spinlock while writing to the page memory?

So, users that do this, or can be fixed to do this, can get file
backed pages. It suggests that a flag name is more like
FOLL_CALLER_USES_FILE_WRITE_LOCKING

> I wouldn't be totally opposed to dropping it for RDMA too, because I
> suspect accessing file-backed mappings for that is pretty iffy.
> 
> Do you have a sense of which in the list you feel could be pared back?

Anything using FOLL_LONGTERM should not set the flag, GUP should even
block the combination.

And we need to have in mind that the flag indicates the code is
buggy, so if you set it then we should understand how is that caller
expected to be fixed.

Jason
