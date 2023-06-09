Return-Path: <netdev+bounces-9543-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D75729B52
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64B18281900
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9016E174D1;
	Fri,  9 Jun 2023 13:17:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825CD10785
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:17:15 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2091.outbound.protection.outlook.com [40.107.243.91])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5793C0C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 06:16:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=epGizfLOXUJnyuyNDDoi9MvclqK6NfnJsF5FHAa3SwGqGQWT2tGLLFkYlE04j7et5u22NgsKJGsTBaCHcT1yst7h+MzVYrh1C3ItAiuOutetdUzWgksUEyvsC9ZVIT1PtgOUa/ZzbDVZ+LZWD7MGIxHsWqDSd7BIw//OAO8vJ6HIQLy7QEnaaa0jlJfah1jltHdbMgjfzjX9YcQXk9yy2ubH6yVx8fNpDzFfKkRvnxsfDRYDIMKz0N666RmrCHySv7yB6UjvfYrzrCHl//7nCdXWdgi45C2xpB+lzI/nlnKPb/PU3nvhkU8VbTERYThDIWBU2s4eYzpeLyJJJJuMhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lce5fl+GOYPNUunDZrM8bE39GB7bN2r7MBYaKHITQDU=;
 b=UVjI+iPwIV6I/RRqrDz2mkDlg0omgfF53Z4CT7p3dqyX7HVzbvq5cvXl1MLETzdZBPXB/a2mkdOhr138u7XwPtee2xJ8D68yDOh58bqjxwqOWS2QbAHvhnjmaUuqSOLlzLH+Dd9NZyQzT8sgP4xeNZ7mYvj4Pj9nYST+P0fVqhczivTP2D2g5taScHdfjbXTcK7/iXbw3vfUh/Sij7N4VlYNszzba35mooos5WQV0X+QZPQYDLw7A4vw3RvBbIPLOajQP+yfxdSzXXrdIeR1TDL5sDJ+CgAZUVmPaXDyVAfs10YhPn9Ab0szUDjf2SPMez5Mgy9elnKsTvA/yZj4XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lce5fl+GOYPNUunDZrM8bE39GB7bN2r7MBYaKHITQDU=;
 b=FSOre1saS8hUF1QcgLjdi780MhMMYg2KRm4M+TQisErLFKMRgIO12/KjyifaXxqNMcvo223m4oVCYXZHXcH292N1yQAv++AFqflu+hSQjljofI51fbTXjS/2FEuHyWILLFKvPdQy23lwyh3juSDWdg5xgQeZPXlsk/EjhJ8CGQY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6225.namprd13.prod.outlook.com (2603:10b6:806:2dc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Fri, 9 Jun
 2023 13:16:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 13:16:43 +0000
Date: Fri, 9 Jun 2023 15:16:36 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Martin Habets <habetsm.xilinx@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org, ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com
Subject: Re: [PATCH net-next] sfc: Add devlink dev info support for EF10
Message-ID: <ZIMmNBXZtudAYfH7@corigine.com>
References: <168629745652.2744.6477682091656094391.stgit@palantir17.mph.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168629745652.2744.6477682091656094391.stgit@palantir17.mph.net>
X-ClientProxiedBy: AM3PR04CA0132.eurprd04.prod.outlook.com (2603:10a6:207::16)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6225:EE_
X-MS-Office365-Filtering-Correlation-Id: b425b3a1-f407-4ff4-e729-08db68ebc4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	x+Vpc+dJAB5XsbvOXx9XlSr928EBv1LzcGm1hPiPiRdsHSZ35Jwi2ZaQuWdxTxWekUfxpKSsVojfErB6c8EYO39AZNCCWl5hevvYU3byxEzccwQnZW53vnUly+36w6ugoJotXaKWkvrVQC0eijUtRGxjKUOuLS5tgxMqRSohz9eVJMhX8bJycAYezLFovBnW4bKC8pAYU0YbYScZMsIH0Szin7PMoVchhJlXF3tdgSMCd8589Sov2ovw+mnTcXLZXXThgS4AYPM8mkahsUTLkxLXD+OGwR33bkiBc3gpd5QLfYgcN0G0WlP5ouoNw4utQ4yeP9Mwu13UHLK+tIuLYCBysUhxl1U4/yAprGqlCpscHUx1OvyBFRaQJ9f/qdkIFMWZfqdekAcdP6rpo4XxiDMYouEOzQlnzsr/d6NcXHKcDzlj+N5iSA8biJR86EmYX3jjHQFNxRnIBbusXKQuw96puXd04WsiPg50cQbLy+A7sIIlWMtjWyFWhVgg1zD082AN1UFxJc4BXk0UsCwR2fmnHWDP9dxIJtKIk7KaLwA1i2ikaYdutMXESmkAQD5H
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(366004)(39840400004)(136003)(451199021)(6506007)(6666004)(6512007)(2616005)(86362001)(478600001)(36756003)(6486002)(186003)(5660300002)(2906002)(316002)(44832011)(558084003)(38100700002)(66556008)(66476007)(6916009)(66946007)(41300700001)(4326008)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xO8OMcQ4SRh7gQk1l7p5c4OPzf7T7YKFJgWRRIrvoAKzUSVlWdjrfoav5L63?=
 =?us-ascii?Q?KghIxlvJaWvCBkGgaQKOYjfAAL91FB20OhrE4XmuWmvOSarTutsbLX4Kpl/j?=
 =?us-ascii?Q?N/9iYgVyEF1jhE/wU/cJHq8KKwv1JIyqOj4KbS6qCq3vCMOcxU7n6jBgr+Z7?=
 =?us-ascii?Q?rvUFjQTl5dekY6/mA8O4DUqvd65603/r51BFoYVrNE9HaWXg87XcLcEPIPdY?=
 =?us-ascii?Q?OKHc6jBkgOh9d3cXt0MYusTcF5pKrCprO4scE2E3+71mINA/Qq+TQ7Mx9Qqw?=
 =?us-ascii?Q?GyO8i7lDH6cnxBuiVuQS4+SdE3CIS4evihB+4rCTUN/GGjMeoOibxiwb1zrh?=
 =?us-ascii?Q?Kn8wnJMk4L4dcNBt3jF2F+xzBtEtosj8IHCmrwQjGbCh1Qf3OG2HhUOTAEfp?=
 =?us-ascii?Q?L4Dqyhj98cE4sQiPrFW8FYTvjscoQ3d9lP8uJWL3dzG+WTdWGhZZdTaSl7//?=
 =?us-ascii?Q?uzmhqMOnaZxsTGj1651HnhA7rJfsKziw5FLdLhJ1IgxbnuPnGVEC5N24J2W2?=
 =?us-ascii?Q?Kqd8Bl8VHaF5BlqBRj49iw1FBbmaq1+oIE0sF53m9l2WJ7LtEDDLBzEivlln?=
 =?us-ascii?Q?6Yky4RBwo5gg95GaskjNQcrisc+f331ggpiArL1qVjseQv5dVXlQHicM+2gi?=
 =?us-ascii?Q?cZzkxd2X54NTu09oq2j4tBer68PKuGfmp/UWkIJoIdPuYG2ocodwNE8KP26i?=
 =?us-ascii?Q?yqATzTviD8OR7n4GTYVEYnhRPwAwC3yhIQOYq4NwUnVOgyGMg3YuwVQgUxnG?=
 =?us-ascii?Q?mR/y3IIttxF8ztoVkCvgULOkBlA/VB0rSYKCx1mu7UjOR4F1m+CilBdaVsyY?=
 =?us-ascii?Q?MBjaMfbB7OvNufIh2uy0mewBthdRNtG42BZHKoS9Mytm+4iRHiyAoMDcGk4C?=
 =?us-ascii?Q?Y6s2fTjQUO5QqTCfJ3g/jQnlUkbWkjEV+wmkzaVJuY1O9DlJtD5iwQE+U+sw?=
 =?us-ascii?Q?/hqyt1IKoHiiI4Wtx9lhgCBaOLJPi6QS1wM1CVAY9Nm3s3QcJ35kh5X3tbs2?=
 =?us-ascii?Q?4/gBpOYnpuI/6Z9HF5IRrkxUdQznhJpkErQ1oY0AQOhhhGxvAoWIM7gkvHn+?=
 =?us-ascii?Q?igWimqhHhJaEvkbHwKvOihInk4uBSh2f3HZfN1DQ8PHrVqjW7sxbktsM6AKZ?=
 =?us-ascii?Q?OtkdDrnKQX0XFAfF/UHrME2jEQSgVcGhjXiIKwFjyFXBHnR96Zh6y4KlJ3Oe?=
 =?us-ascii?Q?TL9gBgWTJS6InRoSvZOY7VIss2cvjBwctBW74/PXhK2YoVzEl/7xr1OhLWfT?=
 =?us-ascii?Q?WVVN1jX0VCLbZGdt0tdlx3/VR3tUCA9ibYpcn9OCNmUVZLDjcCU3L/kBMjOL?=
 =?us-ascii?Q?t/Y4FIKlSdRAdqW/+1IiNGVSi6quAwqFZop8kGLpKMM46opToLnRObya8Z/n?=
 =?us-ascii?Q?TQN/3PAC6TDC4K2ZrBWcsJslsivqqZQcPNs49h1UokzdmixaMQHBi7KWXhwf?=
 =?us-ascii?Q?ladZpdiQdbe2gmkbBVlxUVYtd/Ey96IDP2bFLOc666PNyKAEoQznPywO0Xyg?=
 =?us-ascii?Q?nVHh1cZ44C1XB+usO+IieFdAT0GZJ4iTU/ItIX0D/Ch7v0cX1dTG0FLCDrJP?=
 =?us-ascii?Q?F57KCUFB9A29rGQxXfMdw5vDaVraNLR57FXdC/5wmRlncBr7iJV5s/6ICEV5?=
 =?us-ascii?Q?V9dp7dtyFsK92YCvXumUWjnHlVy1kkbnv3MYBFYf0RI4tRz7zPe5o8/z2Wjz?=
 =?us-ascii?Q?G3ljAQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b425b3a1-f407-4ff4-e729-08db68ebc4c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 13:16:43.2578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QE0btab+nfuZIbw71Oormc7B8iCcfyYUKugb8hKPtNLNzFsCKK1JkozkrNaD271j0TnIuRhAAxDi3WDgiqLx7UbuXVA62tWAsR4oD65ZoYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6225
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 08:57:36AM +0100, Martin Habets wrote:
> Reuse the work done for EF100 to add devlink support for EF10.
> There is no devlink port support for EF10.
> 
> Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

