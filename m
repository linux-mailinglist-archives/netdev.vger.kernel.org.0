Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CC43F514E
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhHWTdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:33:55 -0400
Received: from mail-mw2nam08on2064.outbound.protection.outlook.com ([40.107.101.64]:32628
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230377AbhHWTdx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 15:33:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RY8Ch5npulVfPsGy6XKbHja6zXZT0Jfb9WMnz+6wVVSG728KZ6UKUwDvhiFClrAbYoXs4XytSwIXu5qSG61aOFfnvavwGI9aSB9PdYprKR2kqTRnoCZVDhfanFXiiPPgB4TMSeGvyXlLonYJyrNjaVjp6NIZJY635ZNfP8ZF3U5343+Dhe1bmGbuT2nrSp6pDqS1tflg0LRO3OYluas3oVESLpyZBa508sf7Xyw6Djznutxh21ojI6ra7iJp+E3S/T4c/RDujNnfULeFIXvxMormjzuaVZ64ee4C8Dpx912oibLUziUGgBI/B0GGvmXcPTfVccmC19cL0+16ZtJDLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1+jjqTserHIsZaxdAbHAH8KrOKU09M3SVe/RoHgqRk=;
 b=F8NqrImT80Z71sHQdaxbUbLoR+8DgqCmB9VQTJBYyuqCn6FRPdsvjRZPzSZLHQoxoitdpQYs89PMW/55fOvaQ9Au5v8YZy7btqHZq9rDY0nnoDnBo6vXOnnRbysyArACipndYyluyeAkbMDAcvw1fEzIkx1NEyR4n2MOm9YOJjKlBkaVvodGMXcZiWQKodgNmmvwyhnF65tOE/xTYE41UoZePoDHIkHF8adkwZ1QAKeBfgWwIpTNpf92UrCmvv2hlmpdDE0cDf7/ugnBISXN2luCLU7A33GFbcTVgPqud0UNiPk0jqlCVhF0g4EaNdO5KMUXPlhVlUhW+ettlU85Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1+jjqTserHIsZaxdAbHAH8KrOKU09M3SVe/RoHgqRk=;
 b=ZZZL2RhOkNHDaUr8vhFod8s25MTaWRtkv0b8JXHd4jEJO7VacV29/OwEzjZ9rVT7eWB+YkcxqQVaricpJeCrHBl6nGmytyX2VXugWw8hwZrNIAZy6N56s8++fatDgzH6jsYFp+lFqH2v9AOce1CfWMoS3Z2xUvhM6TVpSqXsJLwCDV4KQt1KvffuCERXQ3gmOzdNNgpawTEidNDOKsQqCxcHNbcBi6nwJf7iRo/mFwEE+Gf5kb/np2nO+dhc13w/Pba8v0SY8GFgZX8WudnTaNpYTe7HGhd7+Htxo+RN+OFaJ8ph9KtkeO5f1mAitMTYcNpxh9PoVohztnjf1KAr1g==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Mon, 23 Aug
 2021 19:33:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 19:33:08 +0000
Date:   Mon, 23 Aug 2021 16:33:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Zhang <markzhang@nvidia.com>
Cc:     dledford@redhat.com, saeedm@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, aharonl@nvidia.com, netao@nvidia.com,
        leonro@nvidia.com
Subject: Re: [PATCH rdma-next 00/10] Optional counter statistics support
Message-ID: <20210823193307.GA1006065@nvidia.com>
References: <20210818112428.209111-1-markzhang@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818112428.209111-1-markzhang@nvidia.com>
X-ClientProxiedBy: MN2PR12CA0010.namprd12.prod.outlook.com
 (2603:10b6:208:a8::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR12CA0010.namprd12.prod.outlook.com (2603:10b6:208:a8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Mon, 23 Aug 2021 19:33:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIFgx-004DlA-6x; Mon, 23 Aug 2021 16:33:07 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cabe823-ced6-4188-56aa-08d9666cd619
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50622F77CB48BD9F1BF505BFC2C49@BL1PR12MB5062.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8IBISwo6+m7f3JU+Z5KF13+B5Kqj6joVbGI250M6v8Hr4HI69do/aPpTwABio87CPDpfyoF6Qxh7OE2V2kSQ2iMlq4aJ6n+Jmf5if0tyzLGEUjscgBoN8Y346x7XQ1p3FNCt/B4DZ0JbNKoryYPTvnyNVNj0A5LODNxnkYjDihE8qT/PInpWppIsBxIlwdArj9Apg6r8xgYY46WEECUM4K6Uz+0fSBNo8K7spqWocU8sWx/pdcx+dANYdrSGqxFZ6u9hzl480sMcXAI7WkTAa+Q7GgasyvR+tlKfCo1EAqUc3bV0t2cMLaqgH1cUqSFv5CLD/KSILZCT/jjDyeI8cDQwUVlkb7MSWr0nadJ0i/wbJinUfCFjQmamYnT8glXUou9sTypaNSY9ynPsMNXQsOuqbctq3f+YaArsfrN22wRSai5+zuM57F5R/bUOZAm9ls8iT23egLcHubH2m2cb0lz07ygay8TIxAgsu9Q0jc4CiRoDMfoYCGZ2MfKTkLK9r20t4uYVavnMpPRjxrkIYr3BRRDPzw7VAlx2QbHPiFpdRr4bx8OC/8jBICUHbKeb2I0E3M9IsIDGgagpKu5DBBkiceUe4nfepWBvoiVcOS6YSK6nPEyxI/KtVawG5KGKrA4f4gQSOdE9tpSH8uHQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(66556008)(66476007)(36756003)(83380400001)(66946007)(2906002)(1076003)(33656002)(9746002)(107886003)(426003)(478600001)(26005)(6636002)(8936002)(6862004)(2616005)(38100700002)(37006003)(316002)(8676002)(5660300002)(9786002)(86362001)(186003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gneB32sLSspN1tHVwjMzE0nRNcL4iKmxY4dA0XBUw6LPIsIDX7wwE4WDUDMM?=
 =?us-ascii?Q?0bDCcmsN71PbE4cQcqJEoG16fmH/lwQbpwR6wiQRB1/ECnoBMcI6HjxMcDIm?=
 =?us-ascii?Q?vDroTLENhANv97Ed/11vwWEZdT4r11Og7EEqu/zZRHyhXYlSBXtbbRMuW3jL?=
 =?us-ascii?Q?QY4rq7+bMF2X94uF0TI38MbL10TaYFq402W6ZvScODMesVuYI9TjENHD1Z3c?=
 =?us-ascii?Q?1MkJw67ERrt7dkow4YHw649fRvwV39hKco3gW9D2ERrEbMdwmmuXa4yOGzo/?=
 =?us-ascii?Q?DW173/pJYV+5xjHQ+oK1xzE8NdZ63Yrf8AKWQAiqcgwkxi0wsUOzCOCTOfRM?=
 =?us-ascii?Q?rufL8ahDI5C8Qk2ZIsMEuTT4aF6+KJ6ih3y0l3MvjfyBWDtLIQhFbtc73See?=
 =?us-ascii?Q?2dvdtWRsT8k1EGWS40Vkvg56CL2iN2GX2EljrVeGBL0JMArSbIj54lauCiln?=
 =?us-ascii?Q?sZHJzDN32npU9G0ljogD7Hb1bbeuwSWRKcwCqZzI8X0Y0eVMzS2xIot08Wxz?=
 =?us-ascii?Q?/1EYxwZavmlkZ5nPn6q1uWKMU8zmY+fp69+s643cJwswOpBTYfEom/5ro8rf?=
 =?us-ascii?Q?4r9iG4WivEsYYNerz2Jg5DJR7X+IOeGS9coQOVKCiATHYixRRbdQ05TRkhuH?=
 =?us-ascii?Q?aQeaGxkdUwarHTd+rSFnLK+3T0BOH9lN74O7LjGIE3nGWotm29BUhECf5XLM?=
 =?us-ascii?Q?HDrs+yO+5kO8FsdWy6F/WsTa6p9WAsbzAZBy1oB6qQO8zpRYq2EbL04gaYwZ?=
 =?us-ascii?Q?A2SMImYUru0xZXZwPm4Yrko9GJUvaLAeELbS0SvSx/vlraHJ5MOjugbopIOs?=
 =?us-ascii?Q?LRZd+uRmKULKUy1eKgWR2vvGcWx/9hX5tn1qV+xhkaVO4fogUrmd1T04geSU?=
 =?us-ascii?Q?9E6u1LhZwYKOrms7HtwmT11eeGVW1VM+sxC/udamlDxnNsfavsYsOcSD/EEV?=
 =?us-ascii?Q?Rq7or7yTWL3XhZ+NJOnd8fTZCGbOVLpx17pIpfjwVO7+1/IofJ6R3jFglO6X?=
 =?us-ascii?Q?8UzJ0+/VzCzfXY60JzYelWuwx7ZhwFvF+zp+F2YUjez4bnrO0XRYi/om6ErG?=
 =?us-ascii?Q?AbVR6eyh7uBBDkQBMpWAgeI0DmwA5bjk9vRwhj6mq7FE3P3EeU6bXTmfBjAB?=
 =?us-ascii?Q?6cCXSknNlzOtZbBNR8rZyGsexv/yb0noaG9LkiZrAV8tyScN5Cq0Y6aMzyrl?=
 =?us-ascii?Q?NCBQOm3In+elycyaQ8p1qYfFNQL2O9SyGR3R6o7P203ZRFn9DSZ8z3L16FAu?=
 =?us-ascii?Q?AV3QJL+j/J2I7BBE0dgfh9Ot5hxtCZ9h/u/99xwgO52n79fvLC1dn+4DJRia?=
 =?us-ascii?Q?TmBuO0b+6Y4OGLreDmB7ggQR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cabe823-ced6-4188-56aa-08d9666cd619
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2021 19:33:08.5545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXWwyUp8jHMzSqI8cafCuApbJn5VDoGm0GjqZt9OqPL9fRRekDVclku9X3Jv0cxP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5062
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 02:24:18PM +0300, Mark Zhang wrote:
> Hi,
> 
> This series from Aharon and Neta provides an extension to the rdma
> statistics tool that allows to add and remove optional counters
> dynamically, using new netlink commands.
> 
> The idea of having optional counters is to provide to the users the
> ability to get statistics of counters that hurts performance.
> 
> Once an optional counter was added, its statistics will be presented
> along with all the counters, using the show command.
> 
> Binding objects to the optional counters is currently not supported,
> neither in auto mode nor in manual mode.
> 
> To get the list of optional counters that are supported on this device,
> use "rdma statistic mode supported". To see which counters are currently
> enabled, use "rdma statistic mode".
> 
> $ rdma statistic mode supported
> link rocep8s0f0/1
>     Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
> link rocep8s0f1/1
>     Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
> 
> $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
> $ rdma statistic mode
> link rocep8s0f0/1
>     Optional-set: cc_rx_ce_pkts
> $ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_tx_cnp_pkts
> $ rdma statistic mode
> link rocep8s0f0/1
>     Optional-set: cc_rx_ce_pkts cc_tx_cnp_pkts

This doesn't look like the right output to iproute to me, the two
command should not be using the same tag and the output of iproute
should always be formed to be valid input to iproute


> $ rdma statistic show link rocep8s0f0/1
> link rocep8s0f0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0
> out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0
> local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0
> req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0
> resp_cqe_flush_error 0 req_cqe_flush_error 0 roce_adp_retrans 0 roce_adp_retrans_to 0
> roce_slow_restart 0 roce_slow_restart_cnps 0 roce_slow_restart_trans 0 rp_cnp_ignored 0
> rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0 rx_icrc_encapsulated 0
>     Optional-set: cc_rx_ce_pkts 0 cc_tx_cnp_pkts 0

Also looks bad, optional counters should not be marked specially at
this point.

> Aharon Landau (9):
>   net/mlx5: Add support in bth_opcode as a match criteria
>   net/mlx5: Add priorities for counters in RDMA namespaces
>   RDMA/counters: Support to allocate per-port optional counter
>     statistics
>   RDMA/mlx5: Add alloc_op_port_stats() support
>   RDMA/mlx5: Add steering support in optional flow counters
>   RDMA/nldev: Add support to add and remove optional counters
>   RDMA/mlx5: Add add_op_stat() and remove_op_stat() support
>   RDMA/mlx5: Add get_op_stats() support
>   RDMA/nldev: Add support to get current enabled optional counters
> 
> Neta Ostrovsky (1):
>   RDMA/nldev: Add support to get optional counters statistics

This series is in a poor order, all the core update should come first
and the commit messages should explain what is going on when building
out the new APIs.

The RDMA/mlx5 patches can go last

Jason
