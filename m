Return-Path: <netdev+bounces-3685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5668670853F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B3462819A2
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F277221091;
	Thu, 18 May 2023 15:44:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E561A53A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:44:58 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2130.outbound.protection.outlook.com [40.107.237.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19CD119
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:44:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ib2GiGtbp88mmCanQx5ON06Kn4UD9+N5QlEAsnVnVYQ/ae6rB2xDdvaBkmvu7X+ZGO1Q3HzvniGWJMS2l9+9deIZWqEfQWvBTeS71DPpXjOyYYKGZE3xNvFpf5z0plEk73D4mMEc8AFc9WbJK3X1pVwvXoRUtlIk67Q3YQ4JMiKCKc46W4KKfoEUxPdo4HmYtpwxsuHR65162fqWoue/gP/MAsRmjWgnZ+FKXnh2BFiOfNBgFcScWy4orCJZ6kDGMRwrU0iibxaYH83ncIb3PNOcp0uDPUqNRTl84XCk/+oa/w1UOtWdodqrU1iMS884cgBMTB75/bCEnaQD6a2y9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0e+spOJ6LcvnU4OU3yLIBFRljgTN+7lM9bZzoUFNupA=;
 b=nQEhtDNqVF7w4r07xvwBj+bpMCuUoMzoe/9FKodzikeFaVdXkt9wKDa+1/bJtLrlLwvkSR8AXk0D0Jf7aMSmatvt3rpEx+7O8smDTEm6zYvCbSnF82YshiPs5lrUkhTtQqWEHxdIu1eD99/8DrYEtoqNz1LTxuikeBlIbN9brBushGTy5Q1STWUmDF003Q7sEEsZwMjnPtAcU0/clb8PKYZ1MemVbkvSX/ZZs1k/DessLhxsHLCDbZTMYHJd7SruT4FrGTCqyjes790yQb6cfrSgnep7qTgfnXfl4lEHpzJJe1fkTOPcnFk3xyj2xhyLecX355W/lhUqvKZ22IbN+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0e+spOJ6LcvnU4OU3yLIBFRljgTN+7lM9bZzoUFNupA=;
 b=iwOjzpsOF6Ox0rTusoDjVtnuPAqqDTqZUsg0e2s8vH4IfkTCpWVvHqEQ0oOnhJBa2buBtkvzl8iWR03khTVpquqNtWTT0zVD1QNiWP2bgRQmO095ye6jJgvpAIpUJ1cagpRjVrGao0aKgCMKSJNzpAUZmJGLR4weRTTIKZ8lwPk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6487.namprd13.prod.outlook.com (2603:10b6:610:19d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6; Thu, 18 May
 2023 15:44:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 15:44:56 +0000
Date: Thu, 18 May 2023 17:44:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com,
	tariqt@nvidia.com, Shai Amiram <samiram@nvidia.com>
Subject: Re: [PATCH net 2/7] tls: rx: strp: set the skb->len of detached /
 CoW'ed skbs
Message-ID: <ZGZH8f4u3IHOQ+dy@corigine.com>
References: <20230517015042.1243644-1-kuba@kernel.org>
 <20230517015042.1243644-3-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517015042.1243644-3-kuba@kernel.org>
X-ClientProxiedBy: AM8P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a44aa49-78a3-40a6-1c92-08db57b6d456
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M8cAK6MHjuz3p6jFIyuq3sEVm7CZHYXMOcw6KknGrvlH1zFH9yBqUXDXxs+tCe8RWXJ141SoLAvbJvSD4fKlh5BBb/ovuxIaj9P2wBaFWe6XASa3Dk2V+ttv2l2hUieqp6Mo6owU0MNjtIKaV8ydyvaHECflc+82iSFBSfyH8WIXh+xZFRJHxMr9gpoz+B/CZ1CCe8JXEYFKuEfK64Rfo86wAnXjuWSU85K7yTjMLCyYmt4HQx1Dn4RVRw4HUjmMAO0JENSrUY/wiEfbewPVY3DoZNxd21UThcmVOW3yPUvIJN0r/4LzVbyt/lveEf3przW22JIGdDFfeS9mOniUM5Fn8jjav88uKqX/AGCKyXoXUAKVZVjDdLZ49ImSpPM+0+HaObCh1WVpaRKG8v0NMRJxThvU6CrFJ5iHCE+qkxDrEUwgkGw8GWY7+YBkmIbdeUUFiH4YgO8Kxt1vvmOuyfff8cDj2rSvJuj7FObCWfZD+yPO4eWgPaSfeg3M0Q9crbv8HBdupbAGuhXpa6l4DCwkObzh91Y8hHeQkgyRCtqujhcxGMmNpwU+mdBGdhPKpfPRxPjKS7aAqVdj1AFCmknCKFmz1/YV6Og/Eyr7ja4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39840400004)(366004)(396003)(346002)(451199021)(6486002)(6666004)(6506007)(6512007)(186003)(5660300002)(44832011)(41300700001)(8676002)(8936002)(4326008)(86362001)(6916009)(66476007)(66556008)(38100700002)(66946007)(316002)(2616005)(2906002)(4744005)(36756003)(478600001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kghgxHU7zHRa1ihZGJqhHwFhyonOzRb9V4cYNpCAxq+vm03ncj51keSMEJnY?=
 =?us-ascii?Q?dF+NYNZBaUQC5uI6ejG8xbR+690UzToG3Q9Hn8760a9slN4p835wUPJin70Z?=
 =?us-ascii?Q?zA6Y4b+RiEi50OUqxhm+egjPwgqm7glRiX2ADxnsLbWpO9CJa1n1QxnIBUU7?=
 =?us-ascii?Q?ge1KuptLrWotGg7BSJtk7voZ9FTVH143gmO3oZZG+WMyWFsbsk/q8ACWNp48?=
 =?us-ascii?Q?HBG6UW39vI2ltyF3gl6ZYae//8yXQz5Y3HUQChLroaUdBZZDliKSR+y4LTLr?=
 =?us-ascii?Q?DJcObm8FIEisDbOwyDrh/cNnikZNZv8nhNqgj3E/nEWqnqZw6igmE9szcUCU?=
 =?us-ascii?Q?huM/VKgKAg44frjUP/rSePEbsyDRC2rhZoQ0yRjy14gbl351+54EcimWvPFz?=
 =?us-ascii?Q?qA7/5zrOs4qULl4Q4ALt+RBXrcSiVh2uLeOf2e+ea2gpp5T3RzxHH1wDEaUF?=
 =?us-ascii?Q?IIZDDiONctmE4fnUCZxjlOU7lABn07y/y4OhUyt2l1stQqWVVgtAIM4PyF80?=
 =?us-ascii?Q?eOzlVFoGHGrBtBopQ4FKaJZaFbqtDG/U+wHZmhX6jgjkpNvTAF8FuuCmc/CU?=
 =?us-ascii?Q?H2q6RB/9OVer9Zo+Lnk2iRLHrRXVGRPVqhjsTtc6Nh5WiU+0Yhi4bGjbwZ4/?=
 =?us-ascii?Q?m1dpqTuwDhLE/9Y0AKHzY5oonVl6NjtYsSr/iaB6Y2O82UvPAQbEzYpKHwFl?=
 =?us-ascii?Q?lmtpU3+BF2HK1wjPiSTcpzkBkRd+f5li5hNOGmH9PHtVJq5oV1IuDWJ1GyRF?=
 =?us-ascii?Q?CxBmevC6T/rMkc1TQIvI86++n8+p9G361NdEZDUwbTv9nHFVinIeRfgwIX20?=
 =?us-ascii?Q?bkLwAet8mceZR0gK9eBJktSf+Okw0XW3wKg3Qd1fS4APvvhf+d4aaLPV/Bqn?=
 =?us-ascii?Q?jbUav421pIS7H85ifiZBI/VRy8vC35b1rwWUr1bid4LgZ8sp24P+fp8vx0u+?=
 =?us-ascii?Q?dued1N0FUtMEQAC5hewvt01AUBJ54x8o6bSK4QEUdDl386ZtGYrFvkHF7Z6Y?=
 =?us-ascii?Q?s98K5K84VqerLzunbcWI4trWNJNW7mDTNJMVCclJrSoVjselJDXtEkh1Q9Cw?=
 =?us-ascii?Q?ijnfI/7j4oFC//Sz+7A2+jOoMFT5yKhVCVPFtrrjyXNrH7PIG5e93pcEE6uz?=
 =?us-ascii?Q?z99uuTySRxf4sfjux5xM6xLQ5peEt2MTo2z87c2WMXR2vBHlAkl/X/cYd6V7?=
 =?us-ascii?Q?gr0KVKkfevzyM/Fls3ceKjTKGxnX1IjdoGM31AU0b9NO8dxkqlWwQBDbv8i0?=
 =?us-ascii?Q?khCDxvoiaoVQFQ+PiXxw1HCulX65nOGio0wjSculbhuE2qDGdPd10/T5S1Eu?=
 =?us-ascii?Q?cDtQF3QLTVQ3HIjzDuwS2vtUlLvDnSPaGolX3JZhIOQk4wSmadQG9ZL3nPPE?=
 =?us-ascii?Q?e11IcQwvHB/LnMjKvzApUOhZ0pQndos/jUmxl/qqoRO3s5GxGr0OCa1NFZsy?=
 =?us-ascii?Q?HzILPlLloXfKD43XZC/hFC295bdF7POQIKWLjPKaZvUPBcX8eGCSSdEouGCX?=
 =?us-ascii?Q?krfwptMYcSNGR30qLJFlADVuH0pPYvxA7/wsKNVdUgmQ8/He+MIGxgrF9L2+?=
 =?us-ascii?Q?n4bC0zsqBboEz34ysjPtgj9xwYDS6YNyCeydl7ytrobn5lTLh2IHjqMtJ+mc?=
 =?us-ascii?Q?JW6hBODqAGvxOMsC0No//NtFw/Lzan/LRmTlrQWRjx3RMvmNsv7iX8HptiSB?=
 =?us-ascii?Q?WTDZzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a44aa49-78a3-40a6-1c92-08db57b6d456
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 15:44:56.2793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0tNZHklU87H7kJtmNaIt9S6e8hA7fJK/8QxKviAHsVAUC9XsPNGYzIMBJF7Bylfm+KKkfm60tigXHjoKNFBE/y3M9Tvbhm349lZDC3jbj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6487
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:50:37PM -0700, Jakub Kicinski wrote:
> alloc_skb_with_frags() fills in page frag sizes but does not
> set skb->len and skb->data_len. Set those correctly otherwise
> device offload will most likely generate an empty skb and
> hit the BUG() at the end of __skb_nsg().
> 
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Tested-by: Shai Amiram <samiram@nvidia.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


