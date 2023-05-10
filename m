Return-Path: <netdev+bounces-1409-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45CAF6FDB28
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06989281415
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FBA16139;
	Wed, 10 May 2023 09:56:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C13811
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:56:09 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FC2618E;
	Wed, 10 May 2023 02:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YP4hRG4ZkYg3K3m6yHKoWvc7PJy2XefI0lh2h+NngvtsMc07wOiyyDKcANlewvUr46Rhd8WNKD0Q33Q+WzqtkP0MR39PbHoBYi6z+X/WUdCuf3sSmchoI31s8ltTN44pLU8II0C0YJDP/W7E5AtjqdHnhQWMJGcvbamjRfSOzeUSN+PeZX3jxepgJ8a45dGgcBGRw2Ca0IuN+mn7DOJ2fu1+njKOuDykhedVYnoHCNfCFFyehX/Yi6cOSLXYgpr8px4SRcna9EM+/ZAJeSsumxBwyiC2o5cANqQznLpOHZ/cgbMTCnQ/ExSfg9EqdJhaIVMDyTMgvE4nHQaWna4LBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9xoWEmFv97GT4ySIv+GrIZm7PnDKjOcn8PF+GrLafc=;
 b=Btsw8FS09peKjKbCMomvfLWKukBdtAAryscUaGO2x9pAiAPiP0XACux+KUWgtV7K0VzbNvqPzywG6zAb6aOhsFNxAJJSHsvMPFUctuHcMMn2ESQegeRCgj190pwR8O8T0aKvGtR32AQj7sxV+B/VR96FMZP0EJxS9ncMWcUhaqHT8uBi3QZQfkXhqWGuCR+W+4YRp6vqq1pQQjDRQneYS8huZ6PTCmatcB1x6KHl2RPRKgMel+wuE34xn2EC+tcHLrWYugC+Xo8oQ8AluA3MkCOCr38iES/GSaNa0l6OnqJ6CFZZ1fB9okNcDsQTtRFJxc8cvfMSo0zSkEC2Of0LyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9xoWEmFv97GT4ySIv+GrIZm7PnDKjOcn8PF+GrLafc=;
 b=dDL6uS+bDgBSt+qgHuQulOCQVFZCGH/s9bHlGUDYB2fB0jb7STjGFr67u8Ihx8vasNlFyUnOjk4nDvXL/Tv5EjcEu8glNNJ5G85FPi6aPmlmsOI88N/0eQK9M07f588DBj9thlkac+Fbr/Vnybj7njCOi+aZhLCDyD8bI8CFZLQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5156.namprd13.prod.outlook.com (2603:10b6:610:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 09:56:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:56:05 +0000
Date: Wed, 10 May 2023 11:55:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wuych <yunchuan@nfschina.com>
Cc: dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: liquidio: lio_vf_main: Remove unnecessary
 (void*) conversions
Message-ID: <ZFtqL+Anb7uudrIN@corigine.com>
References: <20230510060649.210238-1-yunchuan@nfschina.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510060649.210238-1-yunchuan@nfschina.com>
X-ClientProxiedBy: AM4PR0202CA0011.eurprd02.prod.outlook.com
 (2603:10a6:200:89::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: d7eecd77-9e03-413c-743e-08db513cc563
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TDHk5FgzK/JGPygNUhlymgImVeoOOpLSNew7fJTEd7qiBN0b3Y2vHhLsxxk/eu4bEJB6diBCUgo0vaffqbDKY/02FVbOMBGvjLpPY13vYLMUYD4UlCEPsANAxu4C8QNUyRmwGPgrpgKAqkIqQpSyytpbXJEZ3M/cn6uOJnKJ4yvA7R29cEw4Yz/Z9GZ6gpKafNXWEhUmxyAk4NL8le2s8Zutn+sKx1OLVOYk9WwUq14SUqdfqgELoU4mDucnNDqmtTd3ZKKblKL+V2r95HLl3AvgyeweFuOusFOx6gqX85ogPVwtpEIhJzN5qstLgdegjQMSxz2pcdtKFce8gWcs5FSOhUywV/RoSJRKxVe56esE2Qm0pgApAY1ZJPdaXp/QOIo3lhhGGoBOcC1P4Eb+Gr4jGAhZlcq6ziOKE095xzWMVhwGd2lXYspe9Yzxl889wcRD0bmQBaf/KlCL9COhqWke8ipO1Lhn0RBSMBG0meH0wq8ckaVhDv3QxESPf7mjZ9fUSznMUrXechvEPFrrksCuXH3EE8QHPMkNdHLPCOL6nOUNCqIt0sHjL8KbdbGCRb3lp8Xm1FznZeWNS/SWXz7XH1FWj76TICFxtbeyDKo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39840400004)(376002)(136003)(366004)(451199021)(66946007)(66556008)(44832011)(478600001)(4326008)(6916009)(66476007)(7416002)(8676002)(8936002)(5660300002)(6506007)(6512007)(316002)(6666004)(41300700001)(6486002)(2906002)(2616005)(186003)(558084003)(86362001)(38100700002)(36756003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g6YtvkMVRhpudBZbQPNGaPKjH/d+17dYunE1ubvQ6IGCtpMXN4QAe8U2K5gO?=
 =?us-ascii?Q?n8cAcYa1dXE7qjbENcSwocv+waQhKVqg4Zsiov462SaNjSRz+Dn2n+onVnBe?=
 =?us-ascii?Q?uEFHDWJZbvbEc/O7MgGQ35l4A8YDTg9+acGRoNX4BnQqzZ5DEn29f9exIV/R?=
 =?us-ascii?Q?c/gKXU6+h7c9PWMncmY2h/pIBub0rgNtrskSpuQPRs53wjgrsG7zLedmY00A?=
 =?us-ascii?Q?TTYm67uJAeQzermxDLiREgXen+PsnyXuhbN+9Rm8tmXPFWSmZJB3B0plTA+f?=
 =?us-ascii?Q?OD4jji2xEaXiSCmN5yG4PHYvewAANPlOVZRiTiQIeLEkXtH6uY2vHAVskfrs?=
 =?us-ascii?Q?p8mlUMUX+c8OrN6q3xlOvAfJmsZ9iWhNr4zluYJpa2uEI07v4swL7q5Dm4N+?=
 =?us-ascii?Q?rFu3p3kRxRMAehlHo6lCtTrIboPsuA/skDeV35FSxuIeewyTbYw7L8v4pijn?=
 =?us-ascii?Q?mpdm+m5bPd0n9SjG5wGryD8Wnfy6TvbVegiLsPoVpc7yu3fbwfnDfW4DGgmV?=
 =?us-ascii?Q?ZVZGRMerkzG+PCm1QHWS3z/Y6taAYJ/WVr0Wbt4XMHdrUSaPkTrlox6nNFZJ?=
 =?us-ascii?Q?7j7mIpiFVoDBXOnS3RkKeIp0DBJoW5b8LqR0z593tkCNdVvuYt4Mh3lrM5ER?=
 =?us-ascii?Q?oVgRDqd5dFoXwTjhcTSHXFBhGTEgVCrZoFVzYBeYU0w2ZTxpycGqq0V3r6L1?=
 =?us-ascii?Q?Alkd0MYvszuAwb21GBnTUepERfUGs6Nwaill/UacEB6xWKwAaqICXAqQ858I?=
 =?us-ascii?Q?egZtYvM7KVQpdE/9Swz4Rh6Mrv7r3mm7QYA94CB89tT68cBXwmIuXTwSmyXn?=
 =?us-ascii?Q?3RW0+xkjkZsSGKh0dO3/z79RSGhKgL/oq+DmtMv9WUWvs2z/ULc44UBzXluv?=
 =?us-ascii?Q?Bx5cTz3gcgcobwoUkLraSZ/e9dh3T9X3m+dTnv76+6UEH1f1dvW5Hn1cMX6P?=
 =?us-ascii?Q?2u/RlYcJO5NT7n1BgQacmwnSF42XNASqO+/XF3a7QLNqL7WHo2Bqg2d3pP+X?=
 =?us-ascii?Q?mrj3AUnYMCmzV3Tpf0ElQKsXk90REHJVBkzXP4M1bV9/FF4hzzH9qy/QIgLh?=
 =?us-ascii?Q?l/jD3CcEgWbMMXTFatQWehiJzMCh6KHa98J2kFgrfPrgto1OHtPAszmeWlwl?=
 =?us-ascii?Q?MacZ9ojQ44tFT2WxEQwQdjnEL6ts7VGAMWmBFsMKxZjTbrXBDTjHkEXYrEyF?=
 =?us-ascii?Q?DcBbtMH8wbFj0Tm/M5yANH3ej7nzgMj2Yp7b6NX6ZrRi7NUvXy4+s2zi2X/2?=
 =?us-ascii?Q?m7UEBmH6rZlpNorxtpcMwA7R7gocqXiF5q0D4wRT0xhMJNjzyBrMjTqfKHMd?=
 =?us-ascii?Q?teuez4pczjZjiYD9RNtkwkgRsfSxanI1MkpLX5ZkEQufYfFELiWGfIITKU97?=
 =?us-ascii?Q?71UFeDkByXlQryEsyOr556joWKGvue4WhIaV/Cz0pgt+wnkymDifCnkHcx1t?=
 =?us-ascii?Q?GUr+AZmLweNrPjzqLLT3EWp27VNvX27YpGhDyaQv5Yw0tE34yAaYphGFVRmM?=
 =?us-ascii?Q?/TJwfluu6vFoB6CA1avU12JGLrHHKz4XSPuCZKRF7+MzyTG3z8RRqVPNhuSu?=
 =?us-ascii?Q?JfDa6m4ZDXmoL1b/jWlttQXCo0oN07CCATtpMTyH/IQ3X6e1YIEdcEGeH0hB?=
 =?us-ascii?Q?iRqc+oVcF+Mq10EW5QUgbtCKzV2h7FZNGsQVF7Qof5orLxsICuewnjDtfh3V?=
 =?us-ascii?Q?upthHg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7eecd77-9e03-413c-743e-08db513cc563
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:56:05.6263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RH0Is9s+LkDXxYPSs4rwU6UMZFm6buVbz7FwEnpSLm66Ot3aqpitEZVYkteM5XNvUcslzWyRWx667vjwf80vzRSJ/Jb2RC21UGo7L3LlL4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5156
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 02:06:49PM +0800, wuych wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


