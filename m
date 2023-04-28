Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709456F1E37
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 20:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346520AbjD1SuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 14:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjD1SuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 14:50:24 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD911FDC;
        Fri, 28 Apr 2023 11:50:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4RkCRDBe6vMp1aA+G45G9xmws1s8roMQU54YrAVW+ZghUWiGTphO+V4BFuD1haJ5Np14NcSqUkTYkT3f2yHheCk9lmrCCjc2QUV9SlT21gBmDHI5+gfjGO+acGCUn/AEaq/oZxHs/Bf8mi+BwA9SHZqNmZb3rabgDnVGrMBxqGnzw+iDOYYo+f1LrScJyaflq0zuph5dXf85o/Ttzf8QxhcMWVwsn5XZJ78Z1wDLeSfXdbVVx84dADeM65+3mXurae1qnJt1cVWJM37UEKC9RAefODeXlMD7Xmid/md5CqL+T/+zh7BttRG0O0MCgeVs9r+Ggp7j14PxaO/J49qfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mw023qHm2iwfXfoR3rKyX5syQLrvsUO6EuLoL5uoz7k=;
 b=CeIUcgN2jelYmluAw1mYToG/Sep39xeLD/8Vb8zvn347kfBgjAMM3EPXG7wMuGusj48XDVzgb2ugfk8yPr1IaXYazAPFlqGc1hHEMjs+K/8j6V53U44lbpnfur5Ry3ecEuG7c7ZYa9XImJQxUbj4tKOHei7VCX3ChAX5NjNYMFAEr6jMzg6tDy8FjdWxpcKtQyqDC2OznRIgz8t7PEMsaAaX4BsUU7OUNLZUW6FOfEefErLo8Co+kpHwp6Hz/fFx7jNKwFqllFSXGCspFqYvth0T/900zMXC3GjW5BrAEGiU0bxjQdeCYjemjMV5fRorcIgPSdo24gCmtrZqh1oiGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mw023qHm2iwfXfoR3rKyX5syQLrvsUO6EuLoL5uoz7k=;
 b=Lb09JSGcoWMN9lpOaAUwdqCxu0hjGn0RvY2Z6W5jo7S2uoAw+IcSBXeoBnQbbPsE+XWvhX79D3l0zWcgSYsTk7tlEt9URbSxUqsKrksPDRXgO7sThxQhfGoWzorEOvgnt4GU74oL1MEidS8vRLaiGeSw9G1g91w0KRzvvZ1Awb16nisMBWlW9H9nFL9G+qj5nI8/2blJcl1ZXZXLjzCMFRp4xEVV0D1TJj9AtJlIM4rR490OyH1VnDDQLS8B1C40glOSDngbyoEk4ZIp2OLbiHcbfboFMykAB1st8oK9R8iM8KfDSHYVOsLFqXuhUyut57sI3ZkfL4oZzbalGkyPHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6637.namprd12.prod.outlook.com (2603:10b6:8:bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.24; Fri, 28 Apr
 2023 18:50:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 18:50:21 +0000
Date:   Fri, 28 Apr 2023 15:50:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Theodore Ts'o <tytso@mit.edu>
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
Message-ID: <ZEwVbPM2OPSeY21R@nvidia.com>
References: <6b73e692c2929dc4613af711bdf92e2ec1956a66.1682638385.git.lstoakes@gmail.com>
 <afcc124e-7a9b-879c-dfdf-200426b84e24@redhat.com>
 <ZEvZtIb2EDb/WudP@nvidia.com>
 <ZEwPscQu68kx32zF@mit.edu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEwPscQu68kx32zF@mit.edu>
X-ClientProxiedBy: MN2PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:208:fc::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6637:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e1013f1-8066-4797-5481-08db48196aec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wwheoElm4hibrB0I7XA0C2mMlzrOjsd8NXmXmMHDBRBxMvuAoga+4eCzE3r7KYZTilutGAqPYv5IHy79vb7Q3azBhEQoS703HJZDIXRLKKGsyzjn2PWpPm9ixNC1ghEZFd8+ZiejJVDxgD3LGKlmeWAa8dH/S9jPNvmK3Ai/YqO7eS0Nl5VenC+LaE1MZV5Z2LXtnwKfpx20+BD4UjljToB6AOO8HbNtkgIzcqTI1jfpjcPbDDWriWB3p91V3i541H2SMuYXgSoZJE6rR742H9PN2QISEaHQaD4p/lSk5UFkdmD5/aVCcj3ROHb2ISsq/mYJrOh7YWzvqt/J5UnbkLI0NJchcqvWXBvlxR2hR/OTJMHx7fE5Eaxx8fPGTEAIO2grSykSqcT82GKHG6doeR9s4/D64YFXSUxAKgT15AaWPM6gAJP+ImQ+CKWX7Z9jFnTVTu0+cyYd0VZ0qiQ/IdQlrP+o2Wc3+0Hv1Dv+Nh0lBMGvrgG/ePgKtaaCK5YRVgEh0/K2mhf7V6qONh0Iyb0Oat3gzuK0WhGZMnn+G4P5kc+gKMu0h+JJm3SGxu6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199021)(6506007)(186003)(26005)(6512007)(4326008)(6916009)(5660300002)(7406005)(7416002)(36756003)(83380400001)(41300700001)(2616005)(38100700002)(86362001)(316002)(6486002)(54906003)(478600001)(4744005)(2906002)(66946007)(66476007)(66556008)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lpvvpoMKjBAVQsAiaqFnhK5VqRAC4zmQA4XcTaDvk7USM2JDCCPxndiS5Ik7?=
 =?us-ascii?Q?te0gaYJ6AVTgJJgl+CJTJyb/RcXG4nHUkWRDN6Kjp7HCZQxkXSo8RcMN70gH?=
 =?us-ascii?Q?+wLdoZ7R77YeRCYgR7DzldQ3gDTd8gWPon8eKU+0mNLEooLD7u6rnkf7w5Wm?=
 =?us-ascii?Q?aeobJ8LX27ahq844jK/Di4ZDtn7lcEWe48gjoOnzBTvAZ0eQg/V05vpzPUT1?=
 =?us-ascii?Q?yUmR1jB0sCtHqNIEyS2XOwPN0Bcyu4eQsyhmOkJG1ehsED0kYHJVPM5zE4Hi?=
 =?us-ascii?Q?rIxAh5EKoqUuSKHtWeqy4/tbcf0PdVoDjClZHHnvuEsBF78CTWW6KWN5vd2b?=
 =?us-ascii?Q?k+Z+Vg2KqA3ldElEX+0Dvl/G60V8q6Nlo1BEh3qV9y/egVgyg6IXTwmVx5WN?=
 =?us-ascii?Q?0aXNcIGYPxGJLJooiDo4o24y5vIm3FzSkKMeD6XjFZ3HeVQwLGUEGsOnzNW9?=
 =?us-ascii?Q?mf1ZYDWv7FF5QTKZI+RyqE9My1DppnvGhplerfp92Fly9Jr9gW79YYVYLoPP?=
 =?us-ascii?Q?EIEOv2bVVhjZGazXbmvqUT3CT5gvrtWfGOZ28Fy5/UD4jX5i1s4NEdOuNHu0?=
 =?us-ascii?Q?bQoNKTa+WrVd9hMqvvbK8E+4ewm4bO1Nh0K3c7AoPJzw8DQEh4a09tscHB6E?=
 =?us-ascii?Q?cIimipHy9dLd6HhRfq9K2Ha4ldR+3OfSxZpcIgCP5Zddmwe8Q1ofcQYjn3R3?=
 =?us-ascii?Q?dkPivvDDohnvrPC9+LDA16Cr4KS+Sqnw71gXtAIv616z/00U2Bq2znoZxQge?=
 =?us-ascii?Q?/LEF1N4ShUZGXYXw5iCpZFRAKznKGbBaULN52sewprS/22qB2tTHGE7Mr3j9?=
 =?us-ascii?Q?Sfxu5yAI6K6u495mnm4G+N+PV2s7Txfhu2OIluCLFrde5Kjlwi8EwO0udpQE?=
 =?us-ascii?Q?yoq8AaCYCNn0/8Ds6cpunAohrDF83cbbHYVPqLNuOIlvYIgc/O4fVPZUMRDZ?=
 =?us-ascii?Q?+ltNxNqCtRU7gP9oSJycgXnvoTXdDJxQY3pg4/8G//xV7odcSVIcLJt/Scvy?=
 =?us-ascii?Q?ej7gdAdQS8GJQW5KsTC16Fz0LUWsKbrSg3HQmk90DAZDlxUqJTF1ydclKs8s?=
 =?us-ascii?Q?qpmS+m1dpdn/hCdQpMkMZ72clWgCxaAPeqeTZ2dGfHOKITXh2KT9Ttq+h922?=
 =?us-ascii?Q?1Q/8oUySOEYQJBErLdUGWIHd32GcBIg1Hkhzlcae9K7aosNYcm6+yjibf8qS?=
 =?us-ascii?Q?u/IlufAAHbjVi0uvIZKbZWOFZdHGpMZIW6xeBrTU6USKRArPfTleBEK2TbGn?=
 =?us-ascii?Q?PvgAO6iH+8nPA6WD3UGn/xcCae5u7V0m52Ozo1oHWimU3NuvYYe1huKHEVkn?=
 =?us-ascii?Q?CD9yvcmfzRtmCbfLqpayoFuney72Zf9fh981b+vQ3ek1sREMuBneXfWgUmFl?=
 =?us-ascii?Q?M7oIVIhO8eUIpv+MDZyMgzRfNo1MufrNbxjRV2/iFnZNucMZGHN1oD00aJBV?=
 =?us-ascii?Q?twuUIAH38bH6TbPEGiAjW8cjjWk050ssMSJbUPk8aQoBrF9zahekKPxBxL74?=
 =?us-ascii?Q?evb/lArsjPWDnQWVZmVQmf71VUWYX7jIhXAQvhWaYCYp1OgJmmf5f8SdYpBM?=
 =?us-ascii?Q?ExDBFVfGy8SmkUypSs7vMKqScWjVoNxWeg548P7E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1013f1-8066-4797-5481-08db48196aec
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 18:50:21.0104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sr86pnZuXaKvdhH5BdjB/Vh39hnF0oK/VH2mWXD5+40GyOwTz4E/OW4Wkh0GY31h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6637
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

On Fri, Apr 28, 2023 at 02:25:53PM -0400, Theodore Ts'o wrote:
> On Fri, Apr 28, 2023 at 11:35:32AM -0300, Jason Gunthorpe wrote:
> > 
> > It has been years now, I think we need to admit a fix is still years
> > away. Blocking the security problem may even motivate more people to
> > work on a fix.
> 
> Do we think we can still trigger a kernel crash, or maybe even some
> more exciting like an arbitrary buffer overrun, via the
> process_vm_writev(2) system call into a file-backed mmap'ed region?

Jens? You blocked it from io_uring, did you have a specific attack in
mind?

Jason
