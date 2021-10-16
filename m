Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3C843027D
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 13:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbhJPL6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 07:58:20 -0400
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:63713
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240310AbhJPL6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Oct 2021 07:58:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJvhw74yJt9albnb7opX0NynW1ExN1w7c/ASsc37wwqGqKDy1MTPtfk5w73y7Dt9SpIkn9e3qSm+Uov8N3VxGcEyveDJWmg263DFNrJmLrq/C4C24NWcWRD+VqRy4wIKUOfoEkmkm+aW5QYqPzMhRIZcjNhhLIyLf1jtxccXWjvSo4hJBDHeX9OSCyQtnBz4Ck3A+X6Xn+c4Odjto/JHNpoABZp9FBG8JTlVcaYCFDqeZC3xsR+cwLIZScJcnX4kBm1aCXwFNYeEEc+I3HnCYRXIzQAM3n/CtfOEiOLrycPXNAR646HvGeR3HGd88e2LEgEWg7xVjmxVaE7/Zvmr0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRRU9DkAx1sHIJ3WLpRQZB7LbZN0ArSSkzpxjncPtn0=;
 b=UkPr1eCID8aCEjUmJfgO/kGx074CPIdePcw4TKQOVIEQlqstnMpVYWn/l5MhvmA+PyeBs3eYz1snXQqY5gj8yLGVrcBbC6nEkCj7KfveA/zth05QIiXv/T4hYiO4sYaq8Nw9zPS60FgeDF3n72WYpsYCvgJsiwrj5/r/GT8zjmE0xk0/G3iEvpm53xOsPVSrrfSWBzEl/bYxXtl7VZF2sAnggkNHs5KJ/7mSsbP+NjZ7TUDgICgckIfa4HGAqRgTEAELnA0mqqxWEl3p2fLBO2WP361B4f407EZFGbXY2FVxk2O5d7OvCMTGrNhhkDNPfaJ908SyCbcjJqmxge+bCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRRU9DkAx1sHIJ3WLpRQZB7LbZN0ArSSkzpxjncPtn0=;
 b=gX05H2BZpNOxoZ28d8pzfoXyLiq3YHb7BqtCtoxdDXILTZsGznE5Pk1upFwCzS1uzfff7LPHLqC9D71Mi6sR/4Btwx5xzZHuOFSf92Ho+QbegfF6bedWSZTrBpD4CvasgzS/2hzHlTUrKmFdPihvMiTpgHw3EtCXLpN1vw5up0QiseJZ4QWzYMsgrgQT6oNoZNxNzW3S5KRqpZoMKCbfTcv7tBmtIu3DVe90BKkEskfA3YTMPuXoRpasdl0R9oBEWiU7Ra0vCWsfw4ACNBVAvXRGaszftQjw0+7tWWU3+KXKR0144Dodbxgmm3lZdKNscth4N9kv7E+ieN3gTfKsVw==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Sat, 16 Oct
 2021 11:56:09 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4608.018; Sat, 16 Oct 2021
 11:56:09 +0000
Message-ID: <75a38832-b638-a95a-7ba7-f144cd05d978@nvidia.com>
Date:   Sat, 16 Oct 2021 14:56:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v3 net-next] net: make use of helper
 netif_is_bridge_master()
Content-Language: en-US
To:     Kyungrok Chung <acadx0@gmail.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20211016112137.18858-1-acadx0@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211016112137.18858-1-acadx0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0074.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::7) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.240.28] (213.179.129.39) by ZR0P278CA0074.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Sat, 16 Oct 2021 11:56:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d116dc1-9dcd-4aac-f643-08d9909bf178
X-MS-TrafficTypeDiagnostic: DM6PR12MB5567:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB55676487F1E1BC51DC888501DFBA9@DM6PR12MB5567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0x5VXotzjNSGYupGMxJF79WF9ipA8wHdu7Xqi5//e5ymcrsOawJ2GQXdKBPOuVsFs1e2EhRlj76QMMS3ymHGM50sZ6PJKEvmpRWooPk1h00dCVq08frWsjp8CIpdy7WzAEPMS6lDIlUqo4/MEBHryzXdZGYgfTIO/+kV4mnnScsdh6xyFXWHcLF6hacagTWdnFZ5Y14rB8GPYfxdRzh8w0M7mJbtctGkq770Oj0xT1lgUsMPFVX/9lLWQxBOmNpO5MYMv1Jm50aBlGeTmLII+b5/D5Mo6TpVJf7I3TFyIgXZ5rWiI17NFzPqv1fDsUOOihrhZzUDttePo16wdJ3ZxyS9i34rOQW7Jv4EnsvZwySsVJc5xBk4yYE0Hffox1bZgpvi57lP7q1OGs9LqXCd6jgUjM5Pc5OUtUfTuumexfD/zsTEcllW6sfM5UahZvfP/6IsqWwmyxiegDNodJGGkeDTyk/PMCuMww47gCGO1yC3aY/VlkpwiPiXk3RUhCJ09ZwtdwnbDcfPUtX+rO0orzaXaya1ljSchlTQV8H1uKrKVJc5R6EryX6KqDVYLnG69j9ffwmnr/QMMLEbogdsH3rGTmQi4/ztNGCs4wsHtE2zaZ1ZCNn7ZiIXuz4+2i1A7bV+Q4T/NhzqdK40mnLi3r0ScWtmXFyJ4d5omrEj71qSszz3LgRFqou4NXpLV1GMbgZmRMn89CNpTtkPt541wAUIElBcs2Zc4CNNEQ5m4N9fqAjvCJxJaFP0+pLBUb44bI9zx+cc263bog1MKnz0Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(2906002)(2616005)(86362001)(4326008)(6486002)(36756003)(508600001)(66476007)(66946007)(26005)(53546011)(5660300002)(316002)(38100700002)(16576012)(8676002)(8936002)(110136005)(186003)(6666004)(66556008)(4744005)(921005)(83380400001)(31686004)(7416002)(31696002)(781001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzNkaHpybEJNb0FhNjhLbTdGNDlTcFVnQnFVdXVZQU9MSGR5VDlrTHhXYmZG?=
 =?utf-8?B?T2IyQWcxN1FrZlVoTC9lQWlvSXNGQ1VUYjlEUEhKWXZFUEYvU0duSGVCeURn?=
 =?utf-8?B?RTM3V25CazlMeGhPM3dENW5DWGZ0bExHSGxnRmZVaWlrS2ZUR01OVHVQRlo0?=
 =?utf-8?B?ZHZjd08zWmVuNUx5Q0dSVWU1NUg2ZFo0UkQ4d2ZNdEp0UUtZVFVoaFFPcm9R?=
 =?utf-8?B?aWlHZHFkbEJOQ0FjczBVUGIwb092Y2pXcnkwL1N6T25jT2ZCSnM4NTh4em9k?=
 =?utf-8?B?U041bHNuODlLbVJsTGsvL09HN3ZjNmhITFI2TW9SRTBjdXpDbTRvL0JHdHlP?=
 =?utf-8?B?clo5d3FzSFZTNTVoRU5hZjFlL2ZhYTF5OGFaa1ZOT3NyQmovamxhTWhuUUxJ?=
 =?utf-8?B?T3ZyUnE5YkE5Zy92SlJoWCtrOFVYNXdWeHpJbFM4VmN5dWlWam5KdU45TUls?=
 =?utf-8?B?elh5ZXNNQmtUMGsrem84Y1k2UVZjMzhzM3R1RU1iS2dLNE8xOURxZ0JvS2lV?=
 =?utf-8?B?R0orYXBkODdBeDJCbytVUXBJazI1Rnk1OGtHK0tpUExBZExNcmpWa1QwUUpE?=
 =?utf-8?B?M05NV1pXNmRyZXBIY0RLdlBHK2FEZVBCczZvS3FzdTRTbXdGZFE3K0xJakxU?=
 =?utf-8?B?NUNoN3lJak9UMlNBNTRLSHpjYUpITmtZL2VZd3paWUEzbGlVc3lLNWcyZUhu?=
 =?utf-8?B?MFpZV04xSG1xNXRNdDB5WkFtUnN6aU43cEtTRjIySGNaYUJuTWtNQlRrRjQx?=
 =?utf-8?B?SC9oV2cybjhFV1hkSjZJZUZoSGFtK3M4S3VpcTA4MFJzY3NMMjdEM2hxV1V5?=
 =?utf-8?B?bS9JU09aS0FXMUdYRVkvTWtHbStNNmI4a2ZmTUE2L3loNXBkb3NVMER1N3h2?=
 =?utf-8?B?dml2Nk02Z0hidmt5ODdWSXZRR3NXS2ZyZGtMTnJvc3dPZlFXNXg2QzhaY09O?=
 =?utf-8?B?bmNmMVFXNTk3Y0UyR2I0UzI1aXA0OFRVN1VIVGMyYWN2d1ovbzMzT2ROT0xo?=
 =?utf-8?B?K1UxQ3RwTTQ1QU9ReGRmZ05PZmF0TnZvbDhEbGpDTU5jbjZ0b2FaRVVUTFFT?=
 =?utf-8?B?WW5zZ20xRHBlb1pTejNtM0QwcUw2UTJMU08yUEpLNGNwQjlkbmhhdlNlM3J3?=
 =?utf-8?B?NHN3SUtvUzU4a3FDUUw4S2xMaXg4LzhaU1daMjZZVUg5Uld4TEVwWnZtd0M0?=
 =?utf-8?B?RFhxclRVRUlQK1RnTU5lekhuTHVKZFZvQ1FTWDM0VkNTQlhYWXFJZEg2YWF5?=
 =?utf-8?B?cTNUV1dMcUZiYnlMUDRycFY1SFhxR3ByaTV5bkNjdklsQVNvRHhVcTJFckJt?=
 =?utf-8?B?MFZ4Y04vR3o5M1YxbHRrckFVOEUvR1lobnJzWExQWXhBRXJOWC8vUVhSU21u?=
 =?utf-8?B?RnF5VGRPUkhIRlFXUDBSMWdpRWlNeWlzbmdGVjZZbTk2bndXQ0lDb01BY3Q3?=
 =?utf-8?B?L0JYMTk2Wk9ENVc3Szc1NjgvM1dBY1RHRGdtWkcxb3VnSXZ1bzRONnhYTk4z?=
 =?utf-8?B?ZG5oNmVWTHhZd20veXJ2Z0RFZ2NSVWttN3hCTW9SMExZcFpwSTJZcDlQTkhG?=
 =?utf-8?B?NzE4STNITHk3Q0lDUkMyQXpLZlF3YzJpaGNYSGxIVFVXZkJaWFZCZDNvdWpY?=
 =?utf-8?B?OWMyQW9wK0RZM1FXbkd2emNhNWNTa255RDhsd010eiszaW5IUnc1am9YNXN5?=
 =?utf-8?B?N2w3OGNvME5JRGxMQUtqcVdDOGptK2x0RGU3d0p1ZVJBeHQ0cTVudURkb1VD?=
 =?utf-8?Q?ZEShiBFRFvyT9h7PgM8QlFlsune/Km7wvV6zBhe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d116dc1-9dcd-4aac-f643-08d9909bf178
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2021 11:56:09.7263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRXg2h4KywanajeHWgQajlvfiE2vghZOCXm5obif6XEU/I/aJd5IprQbiGjxj/QLynasyFQgC3n4fyx5L2cjaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/10/2021 14:21, Kyungrok Chung wrote:
> Make use of netdev helper functions to improve code readability.
> Replace 'dev->priv_flags & IFF_EBRIDGE' with netif_is_bridge_master(dev).
> 
> Signed-off-by: Kyungrok Chung <acadx0@gmail.com>
> ---
> 
> v1->v2:
>   - Apply fixes to batman-adv, core too.
> 
> v2->v3:
>   - Fix wrong logic.
> 
>  net/batman-adv/multicast.c      | 2 +-
>  net/bridge/br.c                 | 4 ++--
>  net/bridge/br_fdb.c             | 6 +++---
>  net/bridge/br_if.c              | 2 +-
>  net/bridge/br_ioctl.c           | 2 +-
>  net/bridge/br_mdb.c             | 4 ++--
>  net/bridge/br_netfilter_hooks.c | 2 +-
>  net/bridge/br_netlink.c         | 4 ++--
>  net/core/rtnetlink.c            | 2 +-
>  9 files changed, 14 insertions(+), 14 deletions(-)
> 

LGTM,
Reviewed-by: Nikolay Aleksandrov <nikolay@nvidia.com>

