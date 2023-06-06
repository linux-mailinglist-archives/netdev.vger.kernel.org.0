Return-Path: <netdev+bounces-8397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6FD723E98
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C8F81C20E6C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E592A6EA;
	Tue,  6 Jun 2023 09:58:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D5F294DC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:58:23 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2116.outbound.protection.outlook.com [40.107.93.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED1510C7;
	Tue,  6 Jun 2023 02:58:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYrPrmD1pi66WJpReu2OLEAwSyCYyiM0TbDbTQUE7XjOy4xrTv5OQAei/h6segd/X9SRyJn26ZDksq/BNLaSglS20MRhqc2oCe9Y4bkwRzQyGXHniHkhLW3lYpEpO5W/yM6vHoSr6HeeTxsCm+4aiTkLI3VHyavsMleiSTfIgoYqymYZZTyJM5Yk7ZHA3jQ6SN04LoeohfNwi5msatiuuusE1M6Gypxkip4LnSr9A5KkKGRMW+WOb0Xm0FM6dHSrbS3NfZ0nhSCVJVO6xT0R1QYc9l33b0oI3ZgrFKfWYWfHGnp5gcgXKUiJc+O4C0Js6/VX7KRKrJJIy4pYw88NGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGNf4uP7dPjTuST4Be+fU6WfZaSniPgHkeXeR57YTXI=;
 b=hQw4xTJ45OiIGe5DVP7STrDqRK51VSYVCXLNZRERdfuEV4JuFyQZ8OdTxx7RunpGg/xSO82+8/1g75B3JdTLpaLnNu/zhNDZnEk8K5Tqnmdfc8UW8t06bbgS0WM7QBYySNaQp8TxRrErzy1z3Q7UI6jfu3ULQrOudb/m/HJQs92ofqRcKZCsx0JWpKT/gex7gJs7ye1JOfIkEXAllXNW43e8n8nsvwUHU92+X7/JYxMkZNl0cJOz01pk8sXvLH7/nAhccUT+DnvGPj4GjwG/bUf3xpar0WuSzq9HRVCwFqgSXbYw0A73tGJilF4kI6+e2kvzr5ICcZo7swOHHjQg/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LGNf4uP7dPjTuST4Be+fU6WfZaSniPgHkeXeR57YTXI=;
 b=re3N2OFg/RQXDqc0/nptYRRan8lyPT+uDU3qZPyHPCCD3rfZE9Y5MOdAYSGUM79kQmpDEAuVr2okHe7ngdbvCKa9aovfRLM1N2AhCShMM/i58hP4iF8fEehHq9Cfs3HheCgRb5Jncu0/zSirGPcXMtFGQ6s4QsCsq79c0JWfCUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5405.namprd13.prod.outlook.com (2603:10b6:510:138::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:58:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:58:11 +0000
Date: Tue, 6 Jun 2023 11:58:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Brett Creeley <brett.creeley@amd.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
	kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
	shannon.nelson@amd.com
Subject: Re: [PATCH net] pds_core: Fix FW recovery detection
Message-ID: <ZH8DLQclVT6SHafJ@corigine.com>
References: <20230605195116.49653-1-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605195116.49653-1-brett.creeley@amd.com>
X-ClientProxiedBy: AM0PR02CA0006.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5405:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fe4d1ad-37fb-44d2-4222-08db6674897d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+nwfvA2646tnhnKCVnDt7emSQBoEWwFC/kSeAeZ8EyBXxp0mYGPPqMTOIaARevDdZim4mYK/WIPfGCgIuw+QwOIpqOGo0xKHbsh7FezVps5ZV5RUj2Edtn9L5nBRksI7TW5cvWD9kTQnslUi+aBtLah19VC2koRjyPMkfxpBc42Es+g5Muu8LQBvWdwxzKjLFP29ilqaKsO4zWVHyQc8OzTYr+LrHLa8JkWE7l0p4ZAEiU3GLL0Gd33U+jiN9XE25Je2FuHHME5AMTV5qC+WzvXLPEFMkEMuEn3jwm0J72oNgv1WeKf5Xj7lU0FTLBjtLrAYr2ybSsRGcuTBpQL9U/ebO1FP4YSN6Yl5Lj15E9LmzOf14r/J9q+OYG/x4tc2150nO50ZfInRSaxB7YZjWOlbh9S8589H6AXCVdbrwQJD2nJtUGFkj/2FFc94gvlen6N+wuLmdBFjNqHRCJgOwZe1qQoGmtNQi9y5OONiIAxjjjmqxEnFuzHD4OZm4xyZ9R6JPFtK6Awoub0krJshvQPoyRGTSxarUHV6pdpS+ecglRsVaS74KzDp05IMgt4YFUCI78qc57D2yNMnzGhcViuCd6Q/hUMGU/MvMyY1Og4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(346002)(376002)(39840400004)(451199021)(6486002)(6666004)(6506007)(83380400001)(6512007)(186003)(2616005)(36756003)(86362001)(38100700002)(44832011)(5660300002)(316002)(41300700001)(8936002)(8676002)(66556008)(4326008)(6916009)(66476007)(478600001)(66946007)(2906002)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MdG/4d2bhpn9pIrwstB5e4A/nGo+o9mJCBM5D0JmJd22d8v3/lt4FtQHpLkB?=
 =?us-ascii?Q?ILHSFlYUMFgVN8VQ/KdAzPmZQts/PhJALIzzh9rgkTIrC6mVtLKXkG/lX9pX?=
 =?us-ascii?Q?iL4gs5nh6GPiQ/MtJQVMZyGDqMEeXIRUQOL2k+sC/MHZ1TU0vOyGR4PkcasR?=
 =?us-ascii?Q?ygJlpL5A0D4TE01f6A3+yFOtl2XEEMfIMALh+7qRoB/XnEeKSt5OI8FnJ5Fo?=
 =?us-ascii?Q?mowlVBtEcaWHKDMY+nwmBP0l9De6Jl9NIzQV69mg1rzUriof+3sqyGV1SgkB?=
 =?us-ascii?Q?BdX3LgCCEYgJH9YJTcWOyOCdeKk4u/1zHDSr1OhUnnlPeelRBXpiXW+gNTmN?=
 =?us-ascii?Q?ajqok/sE4EuWhnA+60HaYwWt5O++jjONuBDv9XWH7MHteVEg74OmIt1IXr1X?=
 =?us-ascii?Q?MCouzvBD6r162v0IAMeJk74j/d3Kh/BCV2QvJ9P6tT83Y1AHNlWSEuW4dF9a?=
 =?us-ascii?Q?G1RfuVldzVxBuaCbmO+zIeD6C1sZEPKZphW/BqXM7uomlGK+ZuIXQUjP4zDe?=
 =?us-ascii?Q?egfsSCNG26Q5sPbJtrEmepYKEWlTqcwDHVyefAyWCoYUoFVFyvpQmL8q5iCG?=
 =?us-ascii?Q?OhYpZeSOl3pxThj1ha68nq+jD9qiExjIBnVrPmNj+wZHWgWP4HREUWFawQVl?=
 =?us-ascii?Q?R0BpHCtL8jHH/HxSEd44kX1GfKDNszINApBtGEgu4vpS1wlh/NRQ+atdHURj?=
 =?us-ascii?Q?uL3YiFaK6847vLImycQ33mvJDmq8CUc4aBTNc0ByR+ZxUrZdn7tLNdw/52vR?=
 =?us-ascii?Q?cgIHu7tua0DF8hnpnAqpR2oDDYueZWtk6HXTg9yUAz/ltBoNOdVnRhgwx4v/?=
 =?us-ascii?Q?VDC5qK9c7wzzLzeCvtOv4FQ/y5SBMw/ltvSpQXB7Jf1IqpH23u8XYVeCn2eC?=
 =?us-ascii?Q?mQFmqB8D3pe44O+qqg0xVkSwY9eIjWU3GUM42itGeJ4OBHb7yywZzMgQWSwz?=
 =?us-ascii?Q?5NT73z3OKe5WC0L4bDiOOTzv6AlE2aIa2Cxid7fNYVwf5jLl29wJ4tEMFDb0?=
 =?us-ascii?Q?biFCagL5MS9aSDAI319+wNxpaoVTINWGaX4CQ2hNBA7IJB2zVfY5skC9n9Rd?=
 =?us-ascii?Q?zA9x0CZmO7Q7bj5hbn9BG9Hi7rt7c1OdvBbaa1gaVTcR+iOb+EMvbSTND1DY?=
 =?us-ascii?Q?IPMiXGtGdhiL4q6XzVNMKNyYa5c9CAjtqrhg973snDelI7bfNb808tyWK0Lp?=
 =?us-ascii?Q?6XW6E4CPTRmCafLzl0MxE/iYXTuLgjkBESjAmZaMqjRnlF62r8CSzGkT9h9/?=
 =?us-ascii?Q?MWPNdBOCFaRCDknjcEACap49kmynQSpouOzeccVWdhnz/UjUJh/9f3z4hNlf?=
 =?us-ascii?Q?Q73a2H74ltG0B3C30/Z2A9uW4IDL5qGxfo4JjtFgtk+9ntusjgGoVKt7CLE9?=
 =?us-ascii?Q?hxdUb3Dq0ICh6tAqOu0bASIIp/eMNRd2TF8YlFuDRnZc8B/MXqKevf5mfZal?=
 =?us-ascii?Q?7Ccju/whe60FQzwE4q2xkbTpV3dnMG0qykEWNv/mp/Ahs+EBij5SpDnbZOTm?=
 =?us-ascii?Q?Y994ZdrwFluOumvfjSwU0R4PmXGg5Xo/+9491o0inyJdAe27w8OhRjuiFg09?=
 =?us-ascii?Q?n9wNFVS99O/L/DcQhAwcgyQCPlt1P0YlI2Z8c4ml2/i04WQdtwCNFZ+ypZVM?=
 =?us-ascii?Q?4bRW4YuxKOzs6skDC1Hjo8Vgjh8SU9c+T7tqcjct0i3AwNSdgXJo1RysuwQe?=
 =?us-ascii?Q?MPAEmA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe4d1ad-37fb-44d2-4222-08db6674897d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:58:11.3486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZT02PHCZF5YvLYAt7d4Qb23JszHR8Tou5+4SMZAKW2IAvMWpVefpC1k8rBjROXSI0wVaPKIi5GhGapesJUVxP8HGHqBI/4vFqAHoI9UthW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5405
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 12:51:16PM -0700, Brett Creeley wrote:
> Commit 523847df1b37 ("pds_core: add devcmd device interfaces") included
> initial support for FW recovery detection. Unfortunately, the ordering
> in pdsc_is_fw_good() was incorrect, which was causing FW recovery to be
> undetected by the driver. Fix this by making sure to update the cached
> fw_status by calling pdsc_is_fw_running() before setting the local FW
> gen.
> 
> Fixes: 523847df1b37 ("pds_core: add devcmd device interfaces")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


