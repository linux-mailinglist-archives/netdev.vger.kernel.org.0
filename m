Return-Path: <netdev+bounces-6264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 249957156DE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C2A11C20B68
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:35:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC3511C94;
	Tue, 30 May 2023 07:35:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BAC111AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:35:01 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2128.outbound.protection.outlook.com [40.107.102.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09312F9;
	Tue, 30 May 2023 00:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8RDs3vZQDHVYh24FSSXKQ+O7KaNkoF1rESjk2D69/5Zp+JrVZgjenlpc68e3wbsl/XNr1z2fkhlpDcu1biKBhDJJzxZW6UdYjo9/3kMXIbzPHKj2Ar7EixXZpZCgXzn58L+WetEBqBXbHAo92H17FYkqMwXBN0X+ycoA2F1soEQx5pJAV/xNbcoLNEgQYNFZC0KHCZQxmA+fYW2ANrTO666VmiVMWreRfU9rmw54Q0Uds5lBbsmHcsybNF6vxq+2iMFlk7XS5J2gigKEo7qq9bkXc6DIlqVPN0Y+FyHk0L77p2nuk0s/dJS4m5AAm4MSGCiPLxILI5awU2rB2t2+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbFq7JLrAprxFHUM5JAvHZ/OAwbgxUU6S1QOcXwRk/A=;
 b=gGADhpLDwEmKxgmKEXMmFG5u90s6aYoqpavXmj0rdqS+G3dMyQz6wikwGM6HiogefcpRk8mzqDN8lVOVRHU3ti79Dpg8PZwbREeB8WQ28Jp0wUXyg2XVQaojS1IYjqjQAJnbY1N7VOrJFm7CN000J6jPMN/Z2g/wn4kB22yIizFUA+4LZrMZmk9M4qO0ZAyNI31U/fUqcl4lVdNV/J/eWpElJ+TilcUkVePqA5LOGW/KYF082bxU0dp4FSguCqAcsygygR0h6AOenJJ5XPbEzmEkpkjPTX5mJF6kHXGQjSX6MMsUmGBCHM17l/KeiCZYs/svl/XS9U/XbZ8iC9m7nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbFq7JLrAprxFHUM5JAvHZ/OAwbgxUU6S1QOcXwRk/A=;
 b=mq0wW6JwK9sZ4MX/ZsGfd/OhJf5aY3CW/UuVbxrD6mS12w+EgE+8oMT8Nim9fgZDYYqt1MrBwKL32f9JLVcRTkXcpskUJTFvieMYXzuQp3XDgAzt7He2yW8NQn4i7f+69wHjxkj3aQffMSV3Pqq4gjMv4fEDN0tfTsZafH0IbZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5508.namprd13.prod.outlook.com (2603:10b6:303:183::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 07:34:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:34:56 +0000
Date: Tue, 30 May 2023 09:34:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Derek Chickles <dchickles@marvell.com>,
	Satanand Burla <sburla@marvell.com>,
	Felix Manlunas <fmanlunas@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] liquidio: Use vzalloc()
Message-ID: <ZHWnGuK0nGhS+G+7@corigine.com>
References: <93b010824d9d92376e8d49b9eb396a0fa0c0ac80.1685216322.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93b010824d9d92376e8d49b9eb396a0fa0c0ac80.1685216322.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AS4PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5508:EE_
X-MS-Office365-Filtering-Correlation-Id: 107538d8-402d-4e1a-b8b8-08db60e05dd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ScvWQ2NW5SV9xrBb1bHzx7apXQxF9NLtDIiacHGTgX4+1tx+ijtw1hiiOgZpA9EpMT+v4XdQoRAkvYgn7HRv98Sb8ckXBPKiGWrygwPvvBCFiL9sYwieQfyy4nylKLYjZXOQpzcLfy/5ejTrBuHo5I2oh03zSQDBlF2asxxXBJzEWh5+/4tCsQOOv7+24uHasbMVE/jfqBk4Amy1b0f/mJW1pBubDuDs90AW4VcyryRsJfV8EwYb9yseZncL+FLzjtEhEth398M31pq57pEFzgMBSupMXV9ZLksXTFJQNKCIFZcikXvutI4ZhV/kK8ZmhUOLtkybZjl7NxjU9HFlOks/ITh9RMOtWPsTM5GUcflZsOAcQGdXxS0zubHMt9/5HZpNdTHtulhZx5BkDzVSQTaTBCdIufcGrbQjmCusFLPKCbk0F9U8WWXn2YlkrohPO/jtj+Y91+quN6h3lIcwn8bXQmpGUfK0j5GwuGSgIKa2lJYep+eZN53bl2MKwLpD9hNJEWrdlDc+1UilHcGt63e5wDEcz3uVFxLX4lNn6HOsNuw9xCS3FF7eqICEyBvg2vnMMABPhQgBTFmUDdtGUeacx4qLN9eyTsCRf1ji1jo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39830400003)(396003)(136003)(451199021)(36756003)(86362001)(66946007)(66556008)(66476007)(6916009)(4326008)(54906003)(316002)(478600001)(558084003)(6512007)(6506007)(186003)(41300700001)(8936002)(8676002)(44832011)(7416002)(2906002)(6486002)(6666004)(5660300002)(38100700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3M+j8V59YBYcXUuYRfvhzj0r6tcffK4huzi+aXlVya59W4ED5IsQ9vSq3bA9?=
 =?us-ascii?Q?oE/6hBWgeMoVe93ZOnAXNsdXiId7urqVBlb0Qk80Dpn8NfgfoTaMCYt9Ih47?=
 =?us-ascii?Q?TVd334VyJRFkkddISfsNkGgMCr0Pug0rbEUdVEzeSrRzgSHraDQ5QW4fp9SD?=
 =?us-ascii?Q?bE5VQARdXoFQxNtsuP8h3mkCAZUOUQ3PWqdHHzRxADUmzzD2Rm+5qlW6oaVH?=
 =?us-ascii?Q?pAFFgBJLmCx8JQbpqdOpYM3uCiT4dVruRTYr5VnGZuc/ktNY4Mm9Qo87PegJ?=
 =?us-ascii?Q?Z85HSWc5aorZ5BPLsNczP/WM9cnResrLsuLTb0tL0KOyjB4jFo1Tjl9McEd5?=
 =?us-ascii?Q?FpsA1atIo0nvNvKXfL33U2jCFFn81qlQTsucO/1Ka3xUGQ6F5oUsEALtKoMw?=
 =?us-ascii?Q?BcjfVnGvHtyJy1pkk6a1COsSHtIIZT8Qu3srFgo3iTNGdZqy99mi55uLoCIN?=
 =?us-ascii?Q?kaxQYQErMT1RtpnHp65WWPU2R4+Kl1FpiC76Ex1309QB6adcT13exM/h9JNn?=
 =?us-ascii?Q?5G4I52nTFor8Z0ovcYxVhdplBoPGsWa3J272p8faFQE5wjTaYwMqhi4VO2AO?=
 =?us-ascii?Q?RjA+j5iU3ykworknfuJSrfGhCIwx0Q7qVS0ZSFkvjgjfZw3Y7Ep/uSiWukIX?=
 =?us-ascii?Q?PKXco28Fg+IacQR4DTu9Ge2bEVoEGk6Lx0EM8QN8HwTTpLgMmiKc7uhvnVN7?=
 =?us-ascii?Q?lU3W7lAOhszEyYmpC8tMHpsN+BgPc08W8TWEIP/dMHPtB756zzGQNUwR7/h1?=
 =?us-ascii?Q?HcbIdWxFs4xXafy8ULFaymPO6RrNrjaLdmk2mBgI2w0M/X0uRW8KhZ5r1P9T?=
 =?us-ascii?Q?zlwfJKHjgVQ8ySsta+JF8b5sBHtvuzkIhSOe9nyVybR+wsTqk57Ylt7KaFTM?=
 =?us-ascii?Q?NnzJjQlvmsQQvR0Ux0S2xJdDRRAE8n5fdST6oPZpzYQKzJPu3CPE5pyP/aCJ?=
 =?us-ascii?Q?S5WabeioAFcf069vArLXVg3w92AffbhYI63jRbv6LHNFEKUXen/gLWuridJH?=
 =?us-ascii?Q?/1u+rmhG9mFoflHml7zX7W4YAR/hdr23jBGdBETR4zFSzgulKusVr7LnJpzI?=
 =?us-ascii?Q?GJfbQNfi94WPhDvpQVxo86oFepf+85a+MEmZfzBMKriR23JLyZ1kgGSFkDlo?=
 =?us-ascii?Q?OcEG2N+/+68OkWuNhPs/RfONwuWiTicvxS0QIQUIIMv5p/ILPN6v17o00Dk2?=
 =?us-ascii?Q?9ZC5C9SoVUD7yJzutCD+gWloqHeA5n608aUUmd8sn/yBJt2QKKD/baWLttyM?=
 =?us-ascii?Q?LJ9swQrfVjkq2R83TOsgtdW7ND1M5SEMBQxcom/gS/9KUuL5E6F7fiBriX1N?=
 =?us-ascii?Q?doj2edIEJv832QY9Mf+rZ3dunUtuZ4PkcytaTU5V+VPGjPbjv5ytr8QWC9AW?=
 =?us-ascii?Q?TydHbDcqPQXxASG9MtSDpl0ic2eDz6bwcsGVbV3aGP2zeAzkJJlqYs5IQ4s/?=
 =?us-ascii?Q?A7O7JmKrkUkXxvwbn7gtmlUrd94wJDbPzSJ7mWUe3VcO5xsjeswzvMmO+mRw?=
 =?us-ascii?Q?9arB6QMXl+Yo1UcoXgo7Y0utFsQecw/wzPnW9YugQ36bmzN+yB62z1cHIzEe?=
 =?us-ascii?Q?ZDYA8HWxyPheufvwmFG3dwP3VKBhrCHQjMDCzPj2NW48knD5zWE061vlSIfD?=
 =?us-ascii?Q?Ll/Q+y6lX30xyL3F4OxtYiCJljF88d7AQ2XltdKGWYc1d2Nb+66oko1cj+f4?=
 =?us-ascii?Q?weccPQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107538d8-402d-4e1a-b8b8-08db60e05dd4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:34:56.7673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Au6Qgd9rolvo8dF3F6d98/BimgRaWKh/b2glAb/yLIhZD/tFBI7GLfgwylYcel7OIx1oxeqiMxggpdGY+thaZgPE1/DuqH8e6Y31HQreJe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5508
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 27, 2023 at 09:40:08PM +0200, Christophe JAILLET wrote:
> Use vzalloc() instead of hand writing it with vmalloc()+memset().
> This is less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


