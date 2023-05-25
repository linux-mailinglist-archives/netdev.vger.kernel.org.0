Return-Path: <netdev+bounces-5271-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F0797107E8
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:51:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B079D2814B5
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE90CD2F7;
	Thu, 25 May 2023 08:51:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB21E3D7C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:51:17 +0000 (UTC)
Received: from outbound.mail.protection.outlook.com (mail-bn1nam02on2135.outbound.protection.outlook.com [40.107.212.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF33E1B5;
	Thu, 25 May 2023 01:51:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObdAXuBOXfE7L6rYOJ3xoIX1rd+pqlWFS+xaNA8QkH8CTIg83d/emPsg4drtFgofK0+we4E+T1yHFb/LJ0pswSSDmOa7+ph75wMcvotu4k0NOpW/wx0T74VzS7Z4ifVJNSB8dDywhVGy9iomGMcO4Jx5KSZEOGad0i+7nteI6nQW7RFrhCP8dDSbQkhRP6yDlK9hsCZp9qKc5qW72rpptbqwdewmNVYdisFcgZ5DTsZI90MYl0zbwHrBVsYcnfRIsErDCnFWFGmlvFtQVrMzPxToNuOVWGYeVAr0IoZMqBHMf62edapIhGv5x05WWCRgbf4RKEBD8ZqFWElYfBv0CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fi0N0iDe1L6KRfY3FgrWm/Fw5aW7gbruAtz2NwFQDhQ=;
 b=kpXlwGFMEJxC4AnuNWLZQ3aoy6Hj9mX3S1TdI0T9c8iFgSIPTQi0wx7ppYPA1ClqEtq7eEHkranKQq5hpwDcDkgFgHzXAiAx3/fmfB9FiIC19YwXOLo5T8MGI5TgzCFedvni55DYU9F+A84uqzzzHiybVPI9slNJLcZO2D1CjQB+96XAktwGaPJrsES+GSLOZ8NH3u072QrFZhQNd6yH8A6pgCi2EWAmxMOt3yt874qGd/hpb7lgZABKddw4yTDrqP+mE1m1NUn/enhEcWxRWLJv/+9qEV6bQlblqIoh9pZ9fpg9MSL0BLhgG3w1JU5/AwHzYySH7DWr669pJND34Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fi0N0iDe1L6KRfY3FgrWm/Fw5aW7gbruAtz2NwFQDhQ=;
 b=rsE9X8eeI5zf9kl4dYiBCVpDhkIrD3Lq0xxDY7Xt9gjFqJbB/ibhEeZOAlxHrAUt1ZuOE+xPPbjvVUB58l+smV4tIRbiumaerzBTffCwRQfZkx+m217mO9XOMH6vxU3dxaGPurAsl2nmFS3zunaPOwixnlqOXl/rLgzJ2fW80vQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6539.namprd13.prod.outlook.com (2603:10b6:510:30c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Thu, 25 May
 2023 08:51:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 08:51:05 +0000
Date: Thu, 25 May 2023 10:50:49 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH net-next 2/4] chelsio: Convert chtls_sendpage() to use
 MSG_SPLICE_PAGES
Message-ID: <ZG8hT0baeTiLrIal@corigine.com>
References: <ZG8TXgs+36O9AS93@corigine.com>
 <20230524144923.3623536-1-dhowells@redhat.com>
 <20230524144923.3623536-3-dhowells@redhat.com>
 <3788699.1685004106@warthog.procyon.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3788699.1685004106@warthog.procyon.org.uk>
X-ClientProxiedBy: AM9P250CA0020.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: ff56c2ad-dd39-42c0-1548-08db5cfd2cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XHVoB9p36Uvz1imYThb3U4NQZt+ItYFyj/76vHRaEPnKOfkMNaayK0CiVfBIhFmQj4K1A62/vHoBa3mqrM1yacEeicSurPZsyBf88RtXEw/bkdpwog1bvVP1b8JgqIQJBfxeRhNdCH8VLLNyLkAyO8cwLR6lHy5K+g7s5XoBIbVDVE62S6BA69VmWcrCapCMTudHRn8kdxk/LHCbmTQ4xmZoDTjLuyHeKMYyikP4EcWSTWaEzbZmObKr++slQp9jk9YQLq+MWbbx43cd4i4JXGptVmAZOejgfpIQopwhL+UeXJ/hiF6CIQ3oI4qOfLj2oxuLk28cJ67+J7Z0ssLzzmANho8E/t+t1AcOu85yYiy4rNUluN22Vb06E9ZtFZfCK7qKDAziN/lP/XkP5JkoUCkizAgUr246nZi5kUL1xqAsTvypx3soXabVCnqFRPPzLMxFmrQ/3xGkAsriUnUkcvDjP5BlYCtDCmJu05AuVDA9HU+c/l3gsy+SNHd/vRtQJh3fQl+twDnAqTcrVtpuz5F65aKJdWcmFKLTUkvCjAcuc5c8vukGfBEiL4uNxjAX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199021)(6512007)(186003)(558084003)(6506007)(7416002)(38100700002)(44832011)(2616005)(36756003)(83380400001)(2906002)(6486002)(316002)(54906003)(6666004)(41300700001)(478600001)(66946007)(66556008)(66476007)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bT3xvmDTzMgr/ZxFAqMUIF8J5TX3TitA22rXki0AdsfY04e/mJShNmou+Uyw?=
 =?us-ascii?Q?1nUoMTuZtiwtaecldYENSTFEhvDIfJBwqEPAkodzpM0BZKaTcnaxh1KQt+jV?=
 =?us-ascii?Q?Mk9GUTfKWqSvSZcpAFjpp5L4K1BY9kkdRz3lXJrcZ8GzhHQTmWGVdkERivf3?=
 =?us-ascii?Q?tf2r5h8+jYRFLZmB2aO/rgTNjWN1sXv8ABYog90RZL1RKM+OH6HuBJpML8PG?=
 =?us-ascii?Q?7WnEQLD3KIpSKfHHxRCTTrYbHK6cZ8I3ENGPCqroJG7Yh9weyOcX8rUaTCSI?=
 =?us-ascii?Q?Q6ZZiUuNbbjzaHpteXvdGjHi5AuxnT60JywnXBqq9AKyAVVKBNG821X0Tkav?=
 =?us-ascii?Q?nEHDAngv488bnCxsmp1ozAbyRKcrGr+Sr9c55O0dbGcX1Agl18sncCswXuwS?=
 =?us-ascii?Q?Z3PT6ON9kL9rhkKlIlq8A08zsIvqvy7+xNj9uanIdisk3bl/TExBGdPUQ/Cz?=
 =?us-ascii?Q?iaC1Vn2UeivJrw+kaBv9MmycPNezDYhSo46RrIk+Jl7ftgAl7asGehHwfcSA?=
 =?us-ascii?Q?4tR3R8Mp0QEDpPRPAPZSD2pik3frZruhvBvr8BG8vN+U4PMcKBLOviUdDjlZ?=
 =?us-ascii?Q?JIX0B/jhn8zE1RLASksL+9jB0AeCQrgqisNClbex1x4pyiiUNVC5boLmsZSJ?=
 =?us-ascii?Q?GTK6/1ZHxZG4IBQcec3XR81DClO3PCRb39ALZ4eIMoVNRdVEHNTEGpITBBcr?=
 =?us-ascii?Q?SD6aEb8k6BUA7v9QqyT//e4PL4LKEfsoIav5fVA7jnhM4gTiZ4u7axRdRVgS?=
 =?us-ascii?Q?JuUw5cla3LpVCpp0NFPdZxzYEd21bKVi7D9s53kEudwV1vKOZK4f5E2VK523?=
 =?us-ascii?Q?2ejX+N+NOc6hO3ZN6iY6Quqt8tjY6dTrGLfj/dPAa0YINxmJdCqIljiysSUi?=
 =?us-ascii?Q?OIx5U0OStuKPbnL88N2DDI6ZTZXaYnxW8dUED3DeM+MCFiV5rOPEWn5RWHas?=
 =?us-ascii?Q?n1xeKACdN13Kmg6g2PxhKoPScCPQ5dYsDKddjmVKOdr0pyjkj9dkuEP4iaQx?=
 =?us-ascii?Q?3dm/P3h0zq+jXC/OyA2ebTcVSGa5AZZ/59HhJ5VtMxYCqHB1cauW6hMNZ+Ao?=
 =?us-ascii?Q?O77xAS2nFCIVd//Wck7NVL9cN7ZR69F7HzkiWXWr8j+3B8iUhnGcLXGndsVs?=
 =?us-ascii?Q?itL8e/HIVZtTy5lxKfSuSusshKByjxPtUooxNP4L6x97Fcnv548ScTQ+5fN6?=
 =?us-ascii?Q?kzgK4qFhF1JGDSbgA4OzqnBY0375XWW7QY4jrq209sGT3ck792nVG/ZWKz28?=
 =?us-ascii?Q?WYq9CnnCZ2EsYrM0NSHrz58UmaYQWE8BxqoZD9yGMAClj+nyZgNl0i+6Ltx0?=
 =?us-ascii?Q?gjpK+62kd5DO8F37PA8/13ZIM/BIPNHeGgz8tByTljzNqIxzhx98Cr+/yjly?=
 =?us-ascii?Q?B+B8XeiB8JjxwPbfc9xX/IpDb7P2yLzjREkNpdaNx5al1Jli8aHkyJ+0hRk7?=
 =?us-ascii?Q?gBzB6eCyMHmmd/wGX1iibUMiKWvEBm/8oVbsafc8nQZdYRvkpQW8h21/rvXY?=
 =?us-ascii?Q?8EgvDNi991oeZlgQfHz05CmHVb9EAVDBlvZkJdifdd0DK9uXJ0rYDofvT9gK?=
 =?us-ascii?Q?XcJXaEQZJLHh7uHmdBWzLpisg9chUSFOkct/PvNFlaew+0k6gBT3WW6DuDl0?=
 =?us-ascii?Q?dg/W4otHA34zAZZYMRudzfFOaODz4/oSBAH3BtSXKzWZJGznSMzI6iCZ6Gzy?=
 =?us-ascii?Q?nmAXxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff56c2ad-dd39-42c0-1548-08db5cfd2cfe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 08:51:05.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XI6ChlyUNYfXpUsRVtVkb6m+gLc3rvsK3MJAC5ND4qirGHf5veB+qfPN9DEhYmhMK05gN/Q3bVi2lO7Jpe4cyMbC9f2KNKnd24hLi62SVhw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6539
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 09:41:46AM +0100, David Howells wrote:
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > a minor nit, in case you need to repost this series for some other reason.
> 
> Note that the aim is to delete chtls_sendpage() entirely at some point soon.

Excellent.

