Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EBF6ECBFC
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 14:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjDXM2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 08:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbjDXM2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 08:28:13 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDFDC5;
        Mon, 24 Apr 2023 05:28:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLwT8ouulF/tPAm6209wUXHekVdE9w+n8mV98cMBq1kXdvgwQTvmG2Dj1CDlMvFOLjEw7yyY7A+BQd/x15vHkIFGz6oWUdox3GrEwTGdUnoxT1zIas9W2Os3mpB7h2fsEB991tPBOh5OUcodf8L2LSUtEdK1OH1jRQXFS7aZS/TAZEkHu8xOOrrB6KfrrkkUchW9dycIq9sc87NnsqiIpSwfXDlkEEoR+87SNR33/uoltnVrmQor9+9A92jKFvHNko+VjO5xoVOUUgP9SM5PH1pyeCwJ3AhxUVGt1dAsugKkCnuT91ra1NL2RELqkDpRa+evgVxZt+ghmOzs4QW1uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Yywi1v4yxEyvAeodHfSd7JjtRF1MOcdgR30iZgKri8=;
 b=kbWIiFakVqSwZAM8z9j/GE0sms8OkCflcYL+wkTcC4/JEOKIAnMkdrcMyda3s0Su4XoWe7Oi8jaWN/3wD844G4pMjMMIrflrBSW1/AAmHvxKdUULA94UvXd2uX97wGhH9c8FOSBlvdGqD1PivTmC+WNEs9q8eYDDFzgzSFTTNe/C1bw7qWuCbw4ao8N0H6o4YC1DYDAK3LPofTerYCVB49CxUZZj5mf9LkE2UMZ0hL4U9HrUl/nu/taiCdHLMVwY7LVBQfhPG1CvbKtgujG1nc320fcyvlIxeA3A0RQ8egPIUXaZnSLx8PM6Bslrx0I4rd//cPZ9d9zsl32caqzyLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Yywi1v4yxEyvAeodHfSd7JjtRF1MOcdgR30iZgKri8=;
 b=rdDgs3HaB/Pn/fW5jYI+rH7bfX3pR99hSYjMe7qd/ccrCFUi1OgPL5uVCigaWSRcmdgqb8WcaYjIzfvaftb8Yk4H/l8JplBzhXozpgO9R7g8bdGH7LLgdBIda0TsL8Uc4x6nVtO7MTEgLws1NO3TrG7wwGHfPi2fObDQUkVCkKafDNjvcwR7C5fkr6vEDjSzLrq/Mp8Rq8OrEaIz8RCBU52FXfjI4jQW52F46/u0i8jqRe/YWjAz7JNKIoZkYWJ62k3eP8apxrWWgAaMiHy20qtyD26a2/+dovQnptZ1gi4z6Dz2awVXKbVcIrQKB4lZq7TjlL66hidBE452JOrMAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7323.namprd12.prod.outlook.com (2603:10b6:806:29a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 12:28:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 12:28:09 +0000
Date:   Mon, 24 Apr 2023 09:28:07 -0300
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
Message-ID: <ZEZ117OMCi0dFXqY@nvidia.com>
References: <c8ee7e02d3d4f50bb3e40855c53bda39eec85b7d.1682321768.git.lstoakes@gmail.com>
 <ZEZPXHN4OXIYhP+V@infradead.org>
 <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90a54439-5d30-4711-8a86-eba816782a66@lucifer.local>
X-ClientProxiedBy: MN2PR01CA0032.prod.exchangelabs.com (2603:10b6:208:10c::45)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7323:EE_
X-MS-Office365-Filtering-Correlation-Id: d3f43c0a-5527-469d-bb84-08db44bf5cd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wf7gcm6tA5NbF+SAUsUeLCOl8p9tspDKE7TeWv2z3iyliupkH4mMahFAmzKP0sWj/jUbZ1znRaqFKMiU2VZMCcDWMS+cdyVaFciLyY+FDLO+TYVdeg9+yooE9LwLUXKakUVe+bx2PbFWkwm90XWN47maHZQayqkiXMmQItuOYMdKCLSXjkZ4sSLQwUeHhlvyFoQhVe+cVCn6hFMXC/nikmxeghRmXwe9LbnQFvBB0j19/FymIusDnMQKAb4I3PNqrnMvNqkwZFDoUjyqi+lxi1TdbfaDL/HuP/eIKxZFKv+7tVDQWQEm6XOmSb7gQtKJGy06zVQdaDgCiloSyecYN79l4GOrB07M7/qSyf1jLDZx+hvOd5ayeSeCHcfpHIWPQjyqCG8C0zhcSPKeTIfoccwAMiXFWV300u1t7IeVnkr43LYzig8LytKbW9ygaaK3gzxnUQ/ETGhYrYmF6ynM5znkyVizkGS6eGKyCg5FTUL4jq9+j2/LSioVshVoEz9uDJed6C2zx7yWCLUynVBchcRqINvPhJf/D5/iH6lzSVlyuTFTHqxfIZuW+2c6v76n
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199021)(6486002)(66556008)(66476007)(66946007)(6916009)(2906002)(6506007)(8936002)(83380400001)(186003)(8676002)(2616005)(41300700001)(26005)(6512007)(5660300002)(316002)(7406005)(7416002)(86362001)(54906003)(36756003)(38100700002)(4326008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j174vHmSMr+YHea+C1ouuWHGwxBl3a3p+cxK1v2QKinaIDzLRQHJbfVNiahu?=
 =?us-ascii?Q?njtpR5R9zJLW1Ki9R0J65DljOVRWZ4OzFGRC10wqaTK2Yj0mFG7/SWS0kVer?=
 =?us-ascii?Q?QZNbdm9UOV/nR7ni3tPj5LHBjFUsw12n2oZm8OsyXyIN+tmBP5CykqbiWuS0?=
 =?us-ascii?Q?+jVYRRvwg0p31JxHcczmWaErFTNmeYZsf/3/W+YpopVnaXn14JEN3uBPKQPc?=
 =?us-ascii?Q?EOqa6WBAwWwEPdoiDYE5n3zk9MM2FwIY8nNZDjZXteVeGAwUFiAWx16XYh04?=
 =?us-ascii?Q?UvWRRyI8tOT9bcYcGpGUv6IMQSGbMIcxtosaF6Y6ejyv4yr8NR1SoJ8jeMGH?=
 =?us-ascii?Q?hZ/YfQH5SY/NNStJpgowmdbWT1aLh3egn5DcUQyRYfXxG0jiK1WUYHsScI5F?=
 =?us-ascii?Q?TSAjyg6AGLDh0jtj2w5oz4XuYw6XOS0a7sO/Ui05677mqYh4rBasNXC9MXET?=
 =?us-ascii?Q?mlx/dex+lF9HVYgT/NpMd9Y1F2Lw/eEVw3DWdw+tYTNF45YAENd5rXwAj8gg?=
 =?us-ascii?Q?9yOhgmQPe8VDidaHrfcXqqbv3aWzNm8AmT8dswdH6Heuc8TBYLTmh79933DG?=
 =?us-ascii?Q?dlIoM20A15wYSPT5T1Df+Of9OkR11ytzXCkyKHFVYBoeaK964DSF+CSW3ewi?=
 =?us-ascii?Q?tYE7mWqbye0nsax0p3B8//U7WN1Xig1Unr1mOAqIQ0j5n+viEppjVUKklIEf?=
 =?us-ascii?Q?IdkcuOvlWtO1aUoWa3qdNoHyv+sYsbDrGdvuRmb3m8Ds0cpvfJt49Q7MIhtn?=
 =?us-ascii?Q?o27Y+siSvNeSWYelOmgId18XLE0ItVT2QoTwLfrEUAV0PV2OiCP93TYYKlnE?=
 =?us-ascii?Q?x4pYA6Ygs7NVzoiQnxd8ZJCBqiftebsOhqznssEBc1UugzPU6YjlF/aTZ4nb?=
 =?us-ascii?Q?RetgkwQdHcV9+l7h1yaKkCNcNPD2jord8CLflmO/v/w3/Be31yGhb5RbAG8J?=
 =?us-ascii?Q?8gT+AuiUNXfpRYAFs6uDBdMgmoAsAzXgso/KSxAm2ICTomAPxJ96h8cTynso?=
 =?us-ascii?Q?D3tvGq4QOZnfEpaX81gPr5RfSlrdAILsj3Ola41uHU3DBz0Aro6FYDUvRW6C?=
 =?us-ascii?Q?eD0f1RS9DzNSx12TQVoxkaiXimiYrkiEw5rbRp+RlhkRDeP0lJNhpxTpCeza?=
 =?us-ascii?Q?AkFVni10KinokSuA2hWjR3dbEbCPrGpYzCA6W23U49G7EBTfLdveKF3spnId?=
 =?us-ascii?Q?oLzxtIUGaHnhB+zOhfVnIR+NPkdIPzWU5ysC6VuAGuXa+ayz0shiyMT5tvfQ?=
 =?us-ascii?Q?RI/xvNgALI4e+qOWXKJF6/g8gcYDSQ83mxLpLZcABKh1swngkwpwa+oYW18x?=
 =?us-ascii?Q?M46taJR68G0D6oBfGYvP0TN2jJlj7zRBkQrr+QJKghrMLI2KZw9Z6Zdpp5wx?=
 =?us-ascii?Q?Q8UWtYcAG4l+c9uImn2GF7bCCBnkjuYtEjEpSzpIAsB6NGR+eNXgXub3LWxM?=
 =?us-ascii?Q?MMM11MfT5bHfzmkq2uZI4PM91Hr01B5eLETqNBIt1SqcP52txLClMuSMBw+b?=
 =?us-ascii?Q?cTfYiCpWq/D9ubIrZytcfdMFYkW2zb3QSnlmJqu5a+3MThEla5T1bpaRt3eR?=
 =?us-ascii?Q?2vVbd9wrEmya/uJjQX8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3f43c0a-5527-469d-bb84-08db44bf5cd6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 12:28:09.2049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KKRODEFt0zDz2AFUpABDX0IKQuqU3lU5UpVwX9KwKM2jUfy+BXGxn9rxcj4tPMIK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7323
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 11:17:55AM +0100, Lorenzo Stoakes wrote:
> On Mon, Apr 24, 2023 at 02:43:56AM -0700, Christoph Hellwig wrote:
> > I'm pretty sure DIRECT I/O reads that write into file backed mappings
> > are out there in the wild.

I wonder if that is really the case? I know people tried this with
RDMA and it didn't get very far before testing uncovered data
corruption and kernel crashes.. Maybe O_DIRECT has a much smaller race
window so people can get away with it?

> I know Jason is keen on fixing this at a fundamental level and this flag is
> ultimately his suggestion, so it certainly doesn't stand in the way of this
> work moving forward.

Yeah, the point is to close it off, because while we wish it was
fixed properly, it isn't. We are still who knows how far away from it.

In the mean time this is a fairly simple way to oops the kernel,
especially with cases like io_uring and RDMA. So, I view it as a
security problem.

My general dislike was that io_uring protected itself from the
security problem and we left all the rest of the GUP users out to dry.

So, my suggestion was to mark the places where we want to allow this,
eg O_DIRECT, and block everwhere else. Lorenzo, I would significantly
par back the list you have.

I also suggest we force block it at some kernel lockdown level..

Alternatively, perhaps we abuse FOLL_LONGTERM and prevent it from
working with filebacked pages since, I think, the ease of triggering a
bug goes up the longer the pages are pinned.

Jason
