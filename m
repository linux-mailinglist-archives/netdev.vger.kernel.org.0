Return-Path: <netdev+bounces-1422-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 621DB6FDBA0
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91B5D1C20C55
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54119747A;
	Wed, 10 May 2023 10:29:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375B06AB7
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:29:58 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA97F65BA;
	Wed, 10 May 2023 03:29:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdNhmYBNSS6G7Ta25/bvw46nBpCxDvqfm485kRjftqGtBecRbSCFpw/U0+djR6x1Syc7mvAf6nUKBuX2dh2JXXfplHn1Vou3GbFjxq0ruFi8uKptpaGWxQKdL5YP3qfcNo8FN6vwYQkwfdIfhrnBzmSMP+feynAbF5uwuUmDZDdVKt2uX0sD8mReyQeYLuYNC2lxrLr1/jpJjef8lEJ0hjtGlYdh0M22ICfAA4ajrEJLeqK/glSHzwdgkxZX4yWVWeO1F1HGCgzi//c5y5cXMw77oT6UXZ13g/J/8h3ABlTCvXOxJU9TgHPfxzs5ffpAtKXYoJcPO0VOo2mcoATwWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwMwsdHZju1qwEKq7LkQ3KxElP8U2odGSYsw+1O/3MA=;
 b=maETvv76PocqpmOtrVuYj/h7th9bHCYVxjuUJai5Cl583+PVkntYPwwscjLTe0koQmpN8h89zX5yEov/+Bn+C/pQjOxWtkwvrxpY6iMA9XAaMK2gENb7F3Zc9nQ7kbDYnK6Uas2BrLkVXEfkKAkE0Q8a1L+WCw1Q05WmTeoXEjmR4vPEEPu5LvUv0bTWU6atExGxogp6RUWmgCcl6AwV1ZBqNn/0XpoH2I2mcJE9M9hP9Sb0vkQ8qCZ1rJIurcPDhsfK65q58EIO9oED8wZL00PirZ3QN5lSW6XvMoHjLT8iCodFbyfHRwKC64H1pZQCODH9n4izTbgf56jt1ub8tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwMwsdHZju1qwEKq7LkQ3KxElP8U2odGSYsw+1O/3MA=;
 b=HMQoRcLGX6FXFqm79pD7K042f18cYQxl8myXL7q09LJxMcyzwcRrpNnlD2oaepKf0j3VBn4OcEm7ZjO2cncIlb3fIi3JCeBKklwCThdKG+sEHqQLihZwBKYtKnO7MfIyY/r/AzY3jNPGKNcQlB867O0vCwdFZY4exx+PX1II3Lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5550.namprd13.prod.outlook.com (2603:10b6:510:130::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 10:29:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 10:29:52 +0000
Date: Wed, 10 May 2023 12:29:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
	roid@nvidia.com, leon@kernel.org, maxtram95@gmail.com,
	kliteyn@nvidia.com, irusskikh@marvell.com, liorna@nvidia.com,
	ehakim@nvidia.com, dbogdanov@marvell.com, sd@queasysnail.net,
	sgoutham@marvell.com, gakula@marvell.com, naveenm@marvell.com,
	hkelam@marvell.com, lcherian@marvell.com
Subject: Re: [net-next PATCH] macsec: Use helper macsec_netdev_priv for
 offload drivers
Message-ID: <ZFtyF3SqLCQleCZy@corigine.com>
References: <1683707289-2854-1-git-send-email-sbhatta@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683707289-2854-1-git-send-email-sbhatta@marvell.com>
X-ClientProxiedBy: AM0PR04CA0029.eurprd04.prod.outlook.com
 (2603:10a6:208:122::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5550:EE_
X-MS-Office365-Filtering-Correlation-Id: 46106809-d2d1-4eea-9bcc-08db51417d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	c8dDSQ54W2/uvt5SMO8nMicuybIemx88utMLoTajYIctOntpLK7+FmKjzprFLKk36eCyxi4VunHi9Z19QHnowTAoiN6pAvDMcMAkvadFNybwtJFF1wPvJign0iHhnIoPeqUP2QMY4kP/a8ypELouwDZLUpyurVBrniSY+Z2tcWPTXRB+9bCmwHH2WVKZPEDBfdnvrFuBcCdneN2XGRxq22G7r4tU4NbHPsy2+digGYlLD593CMvovasg5f0Mf9FWJMtYBoUvXS0gr/JfPtwe9bKCC8rKNpKCqLr2q0DcV8+E1qHeh7Hhj0DZHHkrZhqcTvvduOo9RN+4prwF7itBhZl41TrThtKln7TjXgdvtT5xG1Pow4Wg38ySJKAlXpQkS2PC0mKvlGHbN/PslTGp+ZqNzxYJms0P0w0+fttacqgxKF2ZLoXlc79sRGKJ2fWsTcCFn/ZTAWvuCOeDm9iXgbHluBwHLUBGVR1hzy6cbiswQqpSqZoOWz5Q+v42USMfubGDdYrMZ46G5HbneKDW/mK4nVd/YqZE2tReKlhM5nXhpQP4x73DJ98EWMCQkLhi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(366004)(136003)(376002)(346002)(451199021)(8936002)(8676002)(7416002)(44832011)(38100700002)(66476007)(66556008)(66946007)(2906002)(4744005)(478600001)(4326008)(316002)(5660300002)(6916009)(6486002)(6666004)(41300700001)(86362001)(6512007)(186003)(6506007)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N84QaWg8nLlYcFrZ5yLYZNDZX6tZjzEkPkiCgdHbtVncd/z/hqK4IyxfjwsI?=
 =?us-ascii?Q?E+bs3EEseM9ODy35iQG13c3nWwxq/to1sS1wQzilX1QHkDG6GCVp2g/I7yUy?=
 =?us-ascii?Q?uTg+59unFF9XD3X8ut2PGxd6mBdlnkI8LAZPtK8z3Rb33cmYNLtSUtlLnych?=
 =?us-ascii?Q?DGCluXzfP9/E8z1bgZRCl7xj0lDXmHjoYttavrPYjjRMB+lyysC6ZXdkUuaj?=
 =?us-ascii?Q?mSeqwtLTyAmEiYT7JeQZwzlAnOd1r9w0Ux8hCQWc0jpZABRUqQjRzSOKZtRt?=
 =?us-ascii?Q?iX9IsRZycHpxabOSOi98pWhmC2OaG3LWGZisUqTcXPWwifGPLmjcwJeNCx/B?=
 =?us-ascii?Q?LNIm5IymTkS8Aedm5zg5yBZK5vDtPUC/2tglQ44VOn61AiEsjXAb8m/QYzvW?=
 =?us-ascii?Q?GxihhLTvtMUrRI9EKeraAKEmInMa/rJyJFy2qTfPFBty5uAVn8yiJUVZk3mf?=
 =?us-ascii?Q?TrFWcb6NP/LryKpoWvhVCP9BJk2NJMlpo/91eV/AA3qmdLU1eCP1qCfZiF4A?=
 =?us-ascii?Q?s/EBmf2cVx9brPbRqxNvPnys8KMEIoXVX4FlfKIVWwC108JRbsUs1PAtlhML?=
 =?us-ascii?Q?bBGUuJHA3dNPlduBx5xsy3SVgjzIh5jvUCBAhpIogpVQwo79N+NlIIbNMgoK?=
 =?us-ascii?Q?LpsWAT6aD81EB4SLrC+wSy8O6/LfxQdjGWsEdbyRlq62P2YXYtnvjJsm/7jJ?=
 =?us-ascii?Q?4GhU12yWoi/dr03dZeJBAU62zcMcwnkiagRpa7wkyQm0wGdmBAcBq8/BZ//s?=
 =?us-ascii?Q?6wDUAwULgNnw2zS+XDGko9LNus1nMJJcWd5KeSRA2qHWtcrVdqhzAGJq59og?=
 =?us-ascii?Q?DTIq6XFFRXTC6piB/y2ivjRCKkawrqMhoIhseGy6kByre1U9PdI1WJCqGYM1?=
 =?us-ascii?Q?fKj9g6tozFrYpeHIpfNkvhG4tiSZiL3c008aa650ut3/Vx4x/HV1pTg+Mnfm?=
 =?us-ascii?Q?pJLsHSmlu9Ep1Fvq+R+9e5RZd1TUzimX8lgLBsCfBrdxJUWDugmO2tzJxbgs?=
 =?us-ascii?Q?19ht2HY4n1nnOIO6XGeB97rqIb3HVcRXBSVRWQpIPZSfuX01QKjs/tKsLLNv?=
 =?us-ascii?Q?94GTlO3KKU3pJKAlY+KQ3soL0aDwF+lhAhiWPpc72/v6EjN2K2rOUDiwf/B9?=
 =?us-ascii?Q?4G5AI3jpKGVXsXcUp0exnca+NcyPyHzgqddB49D0YACTJzTDRh10XQXgPSEM?=
 =?us-ascii?Q?/rOk9J08K3mhgAC9MaHO0vdcXhDL8uBr8s6GiYesBPZLy//sTULlmmOHC6q5?=
 =?us-ascii?Q?r3DzQP0n/3pkqydcJHpegAP7OgeWS2EmCsndXiLz65NCOyS72M8oXodK0D1T?=
 =?us-ascii?Q?g+Tl2y4EqF+qMecVTgUJV/V6JTXZEhzqCmRhc6zbZDSwkyMyZltTD32AiXq9?=
 =?us-ascii?Q?v7Bsv8TrIUKY4fuYDl3R/2RkckDzmapdTYXfPVR0aGPR3UW/PBOwphvMhEnW?=
 =?us-ascii?Q?OoU/g5kTr+KnsXLJ9XOWMfno/ZxVsqvPXhMUdVP9UheKjTyv8DDWoliBbA+4?=
 =?us-ascii?Q?GyYHjzuWPs+AsM1oKMW+VD/aKpQYBYdBq09PINxTumXMUraZY6+WO2jFChbO?=
 =?us-ascii?Q?KujCS1pg0dIh0flejHL8nIaMu/QRV2kBvtZgxcf/YEuXcaMw0UwiOt5dtA9w?=
 =?us-ascii?Q?4+7Sal9c7nx+hRqhNCLW3L8JHuJneFyh8ZnF7Wof6gJKzWeliffWNhOWJVmp?=
 =?us-ascii?Q?DhpcHg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46106809-d2d1-4eea-9bcc-08db51417d18
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 10:29:51.8571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zBU0Fkaayqo/gB6NKQN4M9iGId/h0ZNRMG8Wzv9ykNpGsm89J7qCV/tVPrzIgWipTtS3+NiWCRmy9MsDDXyIotLWZog7xgqErTWSUF8ViZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5550
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:58:09PM +0530, Subbaraya Sundeep wrote:
> Now macsec on top of vlan can be offloaded to macsec offloading
> devices so that VLAN tag is sent in clear text on wire i.e,
> packet structure is DMAC|SMAC|VLAN|SECTAG. Offloading devices can
> simply enable NETIF_F_HW_MACSEC feature in netdev->vlan_features for
> this to work. But the logic in offloading drivers to retrieve the
> private structure from netdev needs to be changed to check whether
> the netdev received is real device or a vlan device and get private
> structure accordingly. This patch changes the offloading drivers to
> use helper macsec_netdev_priv instead of netdev_priv.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


