Return-Path: <netdev+bounces-6385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 515377160EF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:02:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81F522811C3
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5CA21DDD7;
	Tue, 30 May 2023 13:02:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9C1D2BD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:02:07 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA6D114
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 06:01:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DtFJSz5ijYaJELq8VYv1/QKLV3KJJWKNNg4Xu5JgUOTtkiRZTFof1vAUoBn95L+2Zf5ddqGw5v7LVfaptGqJoymHucFKFzCIvQJNeAyCx/PAdInHe6JrT6vhWKGZyVCqk85BNad6v+Q/EFNSDd7i9IpGODv2ECni5yLDVAkySVf1yb8e7GO+n6Gdp7i8Ts6HuQ0KFbdhVdetGltbLSfsSJDx0ZjtD4eYR45a9vvJbTcIrL7km1iLzJucrRMnEzj+77NcIa3ykVSJj6duRR9dY3IIliiWevt3+QcdM21Ei28kdEuxVx71Xg8WNMLu7R8/v/nqRVFuwjG3+1alcqdDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xOgUCwf7foViiCut7RwMl3w0duibhwkv+0cp1LZDfA=;
 b=iCYwiEXTDXJn5V2+CsS4dhJX5RzGdTBh85Z8CShXn2yBEsBRiiPvOSOD18gcUIyXVpZFwfU5e/5ApsK6MVIHZYSr9WumMLRGA8EXtVPvdVjJZdT4MiHYqNP4Icr+08lJs85a0bOgyeYllmEpD76HPujhr07uyqdEpu/nZcTHojW3xF4DoGJykRK6xgAOF0mejuUY5uGHsKqc44bP9nJIxxbnhS3p008as9KKs/hP1jsu1y6w7/+BkTMxl0Ao2QRTcOUoPjEby/R+XtLUCbyFI1OMWbl99+Ypv4qELqCu4aSMw+GRCYWYOzvmJW/a5Ngx6enfp6R527yL0jAnhwjv8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xOgUCwf7foViiCut7RwMl3w0duibhwkv+0cp1LZDfA=;
 b=ANXA0MHjCIK3lVDCCd9hCoolaTjLuYtRXee+4GJbQGANYKuNrvx+VGZSjvt+VOm2CignagGqjasbmQ1RW7CeCcxvc9zbe77XhiB0U677aVcMX3zV3SbGH42pkPiaUQXbwJOhE13+Cp1UNkT07sCs4ae+tvwIfxDpMnjmKKf00ZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5693.namprd13.prod.outlook.com (2603:10b6:806:1ec::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 13:01:18 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 13:01:18 +0000
Date: Tue, 30 May 2023 15:01:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 02/14] udplite: Retire UDP-Lite for IPv6.
Message-ID: <ZHXzlz94VL+Y72PR@corigine.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
 <20230530010348.21425-3-kuniyu@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530010348.21425-3-kuniyu@amazon.com>
X-ClientProxiedBy: AS4P195CA0027.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5693:EE_
X-MS-Office365-Filtering-Correlation-Id: c6cf592d-4014-4cde-e7eb-08db610df54f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/p2BAPlPXKBG39zcOOL4/X+SNPnA1wqwJ8W6HDsF7Po2sruxf+JchEKX3am+rDuGyc9v+GC39atN4iMFmTgFH1IFuWJzU6WE7VChdL8XrUH+MAzkvOpwGvEqV78n3CY82nuYh0wF7HNeZDXP2b2wQy6NaLnv6+JfEzaxYm+kayKxxfuk5mp1Pmr8AEGextZzjK7zBkqAUuHoywWPztZ1+1KFI4+SxSz0u/Zrcw2lPZNL1dZ/VEMkTgPT/+lF72yw/zKzjNKHnedUXw0lwS230UcBi4uIe3xgjNnD+tuAoNKthjYWOGAFtv01tklxzzRtnYIC/y8AgXbXt+PoFj3YRrwMfLRSFcfNXU+Z509gKYXmMmaeoJMmTO49IWysA7S71M8IxT+M51SN6dMLxfDUxZV1Y14WJ9OtiiSTQc9D8DDmFZAm1XTTQyC5Rvw+Nr4gXUNyp1Tsun4e14op68saqyNQlYZpIBQDlk7o8iSOFs8iz04rzs+oT7DsEDy2VZsa2+ARbzK6ZI06y4OUE0zKn1+nwfMNDTXSvzD+N16Jkj5OG5dox7Q5waugOdLHKCVO8wCPyIKGkd+Kh/5afMBMoPRgzpLHQMqtph1Y5VIgtz3OgCHOdBbrtkSvliqBXmyXcquJYlMohhI+S5zjXGGFbw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(396003)(39840400004)(346002)(451199021)(478600001)(8676002)(8936002)(54906003)(41300700001)(5660300002)(86362001)(6666004)(6486002)(316002)(4326008)(6916009)(66946007)(66476007)(66556008)(44832011)(6512007)(6506007)(186003)(83380400001)(2616005)(2906002)(36756003)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dOYjMkw/XbpdEuneQJQ0zBQaBbvhMHhHmc4Bt+gBH+xK1MQ2+YC7tnsEGu/j?=
 =?us-ascii?Q?SAqFzw3ry2Dj/hIVDBGvCV/7EiYfUpzfs4y/wzwbwTols/112KyTovxm4hSL?=
 =?us-ascii?Q?WEnMAX+Gwy0jS/BunwL5/XFZVYaZ7pbHFqT1F4YCgODjVnBfvmpKr0nqn/W5?=
 =?us-ascii?Q?QhRwwy6v7EU3BC2L/DYPVpH7PGuqeFOgrQU2jUdPgBzD5B0XBIwUFLffyzpq?=
 =?us-ascii?Q?7xTZMo0wgAzfaqGrFCUh+P5iOKhuo2Y4Km46X8dR5RKnL/emKKpq0gXuxyE2?=
 =?us-ascii?Q?/5ehSWnNoJnLrydkLj4gbZtBQftuciUwZnBFY10RTdak1j3llISnd9uQbC65?=
 =?us-ascii?Q?6PYSiETLr+YvIBskBmDOg6YLnoQwj7kZeM09Eg0j6Q7KFK/1OrULLP/b0Wkt?=
 =?us-ascii?Q?GRs6bqKEI+u0W+5DmdzmrN+TfFab/lSqPIbpGpFVRbq+0JqnlWJQ2KE1kIJ4?=
 =?us-ascii?Q?kGiLbMOuzdo6nArXO87BMSZ4KUtBlfVcXq5SfSPaUZnjFos+Wed/5zS8jzCa?=
 =?us-ascii?Q?m1NW73SKGsEl51iu4A0/qkxODi8UMWXiNht7isJZfV61F06xjy3J7mscUIMv?=
 =?us-ascii?Q?8r+sO18o05JiVnur5ECjKrwytWp/A06H+QSn93TU+o2XGPxmokeDgBKWLKYp?=
 =?us-ascii?Q?+cMYu2mgKnqQ5CuSD0BsO7nEeSPh/mg0yBGhVVfUGh1lMMkv5QlEkJlziCS3?=
 =?us-ascii?Q?VwOcf9Z8MM0QbErkRONhREWf0Trcu0tFPlQJPn3kTEQlM2z7m/P/XPbYGjth?=
 =?us-ascii?Q?/DIByY4X+KcCk8rKTz3rMJ2iZJ4LQ57evW4QgGMVcvrIUfNBHEBujYTMaj6p?=
 =?us-ascii?Q?ndvj8nl1cCQMYcuAXZMchyWaESpi/Ri9Ki6D3nCap6/HV/yWT3QEIlUxS5YT?=
 =?us-ascii?Q?9XtmbvAqwUTsTETPLPFBlEmMPnotGlJ+UdKMn+8IWqsO31sV0+5av8mMIRvi?=
 =?us-ascii?Q?iL2yL7w6vIe104JHafWtTyQQBQY695iwAnyywVHo6xwz4uU4+a3WBc9+5Jwh?=
 =?us-ascii?Q?KDE88p3SDnGAx1DoTTXLCauS0wE0ohofKOBXIt/1QFTzdSYe2fcBh3vp5SJY?=
 =?us-ascii?Q?EY5CWxG1I47JuXVFSh8zFGjoMwyl09Z75OQgpGgWzQwivsiHx44QhhFYqhxM?=
 =?us-ascii?Q?d2+oDco4nxBR5P/R7FUuctKXSEzGxKe0itEJs4WlzmM205RDGFPBWPyrD0tw?=
 =?us-ascii?Q?VMVglKml40f/T1OG8vOY1QF4YFgwBh4hrUbjoMwTbhND+Jnj3bKi+LpuoMD9?=
 =?us-ascii?Q?wRWdPIbDExKT1qODiyX/LnV5HxeJ7H2vVT0++cUjpU4ADb1RtmPh9XrLhTnX?=
 =?us-ascii?Q?zuytkPJv9K3EEVmU5mH3gujpBwGqdVAOLscTgyJSgRyy/HQdcUSgIG2wsnjS?=
 =?us-ascii?Q?BiR5W6v8NVrhMeDqOP6vgmC2O5THrxYaKBvqadMHtZjFNeYyougkqpkIRE03?=
 =?us-ascii?Q?u4KyP/MKm63hUTCXEPC+QpKU2xKAeTIsE0uGO5rNFMJfAu0XrASEwuZRGvIq?=
 =?us-ascii?Q?CfmT0BiiVIhBIi7M7ZgZqRW+w5pEJyDCoo6utIGfS2isopeWP/jWa3KJOxrf?=
 =?us-ascii?Q?Hhc4ACJdF2WzxbnyBiaJuRPkGfAT/yK0z98w3Z3RfANwrWMfhQvCbZct2kB3?=
 =?us-ascii?Q?gcpFLeIvQYTZVp+qKFuHm7wyh6DUoiJ3lYuJ8vkZAB5jRoO26WC0lUCUFrQt?=
 =?us-ascii?Q?qUABhw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6cf592d-4014-4cde-e7eb-08db610df54f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 13:01:18.2174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nOuIEcKBdqDE/X3pj1q0WaLmdQ68vEs9a3cKTb57980Zx5ABmRdXo44EtiB66Lk4CFFUm6WC7pCeH2FlxSy1T80afldjf/L+uXemJA26Oj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5693
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 06:03:36PM -0700, Kuniyuki Iwashima wrote:
> We no longer support IPPROTO_UDPLITE for AF_INET6.
> 
> This commit removes udplite.c and udp_impl.h under net/ipv6 and makes
> some functions static that UDP shared.
> 
> Note that udplite.h is included in udp.c temporarily not to introduce
> breakage, but we will remove it later with dead code.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

...

> diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
> deleted file mode 100644
> index 0590f566379d..000000000000
> --- a/net/ipv6/udp_impl.h
> +++ /dev/null
> @@ -1,31 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef _UDP6_IMPL_H
> -#define _UDP6_IMPL_H
> -#include <net/udp.h>
> -#include <net/udplite.h>
> -#include <net/protocol.h>
> -#include <net/addrconf.h>
> -#include <net/inet_common.h>
> -#include <net/transp_v6.h>
> -
> -int __udp6_lib_rcv(struct sk_buff *, struct udp_table *, int);
> -int __udp6_lib_err(struct sk_buff *, struct inet6_skb_parm *, u8, u8, int,
> -		   __be32, struct udp_table *);
> -
> -int udpv6_init_sock(struct sock *sk);
> -int udp_v6_get_port(struct sock *sk, unsigned short snum);
> -void udp_v6_rehash(struct sock *sk);
> -
> -int udpv6_getsockopt(struct sock *sk, int level, int optname,
> -		     char __user *optval, int __user *optlen);
> -int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
> -		     unsigned int optlen);
> -int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
> -int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int flags,
> -		  int *addr_len);

clang-16 with W=1 complains that:

 +net/ipv6/udp.c:341:5: warning: no previous prototype for 'udpv6_recvmsg' [-Wmissing-prototypes]
 +  341 | int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 +      |     ^~~~~~~~~~~~~
 +net/ipv6/udp.c:1335:5: warning: no previous prototype for 'udpv6_sendmsg' [-Wmissing-prototypes]
 + 1335 | int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 +      |     ^~~~~~~~~~~~~

Likewise it has similar complains about ipv4 in a subsequent patch.

> -void udpv6_destroy_sock(struct sock *sk);
> -
> -#ifdef CONFIG_PROC_FS
> -int udp6_seq_show(struct seq_file *seq, void *v);
> -#endif
> -#endif	/* _UDP6_IMPL_H */

...

