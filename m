Return-Path: <netdev+bounces-711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2002B6F9304
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 18:07:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9845A28113A
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 16:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A724882B;
	Sat,  6 May 2023 16:07:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786F13D7A
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:07:23 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2103.outbound.protection.outlook.com [40.107.93.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DDD1BC0
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 09:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUgr+Ayvnw7TS/sRso0Xyls2ng3mYUr5SddNRN90DO3i8Ra2useLKq4AwltFXUfIzu6ZG5AyEH6g6dpI2aJrwLpCEy/YdWku6CwljE1RlCNDC8dfuuzIVxgwxgRv3efjwDBoSzP3xIiboA3rkuzqDhZ56KomOCvZwfz3qwBllncS6kt/K1i8cPIx9+sQQxN0ZnNT7mRZDMoyOnj9a53BgC8MbXO4ZFIiyQBq/KxeO7vxfx2nr/vdzIeg8AEGyCPs8laJ1wqHp1QWNf8xsFIGSR8SUDx155OyVuxUwjrY6011WmKctdMfjHuW9HgxRGaFC/MjkQeQv8366d1kRcuk8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A15VQkP8tVO3hYroY6BFK9zkslDymLSXSo0zaWmh/i8=;
 b=ZaX1Yd/p3dVF273hP8tBkBjA6tXayueXZZGixICgsHHfYiceUSXs+1mzybf8Za4rd95sXpBsm9EIs/W1GPlMJxjdAOxvOcuM6vOsW/cHLM5OCFrkYgaWfPPoFmQIKvIZFnI9Vj6gFSVrbeBZE53a8vPZallgd1A+p6KNHqBHHWxTNQb6KBOCG0KnsP/m0LZqcgrmRHAuyUfL3YE1YxUlRrM0GaQnpaAQaDrAbs3hnEGd9k5DViAf1kw01sYusmClvGWZzU38oIlNahUmO5xZsa/p36UXbX9dWLP6pIeCKsYuyApBxxHDxz6ci0NHk/MHNPBKy6RxqHTAxYAMEpgMQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A15VQkP8tVO3hYroY6BFK9zkslDymLSXSo0zaWmh/i8=;
 b=OdMF6e9xhuRWjBkDjhKykvnK9pAr+EiL5S5xbE8bEVLQ2Yh+ZoHH4Eqc0BvSeZmYwR4/B30avn+W48nuPPYBNJIWoqaTaLnlRms5OLvUIZlS923q7XTfKepJdNSxRh/W54uSHND0mvmSZgSatAaS0Cb/BqWdfFv5wUsFOIdautA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4545.namprd13.prod.outlook.com (2603:10b6:208:17d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sat, 6 May
 2023 16:07:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 16:07:14 +0000
Date: Sat, 6 May 2023 18:07:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 2/6] net/handshake: Fix handshake_dup() ref counting
Message-ID: <ZFZ7LNJ/rHoTjFdI@corigine.com>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333395123.7813.7077088598355438510.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: AM3PR07CA0135.eurprd07.prod.outlook.com
 (2603:10a6:207:8::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: 6874a941-54a8-4abd-cefa-08db4e4bf4da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6H75sQBb39M9ayb3TX+pvOf4/XmSJ2Zd7CiP00eSdcHAbbe+XtP6cHbdOz8ypNtNPb2G6ge3g/ADfG7N95xJ66thsaq3IT15egxUfuGynDbbzSvjkx1LAtSKtoa/+QvN8idH0bV2+1VjAXY0Oae+ccziH2qGdQApCZjhfipWxhriN//AZHyWejTbXFojG3ygeYDOeZ2/gt5gRgYksKZmVz2q7nusmZDUGfPHYM9q+t624kdp0E8vPdNJiisjw30+2rP/0CQGDMo16VM5uWsAhHnSTtZkf2Yl0YRMgZCYUhGWWTpyaWbFGbDhL4GsrsgXjVzTglTSjR+eA7YR4VcuGAbAsRB58+1uyqyGgnDgg9hS5MzkQ94lddRZoN60KDZ6gicFXly2sHqbBheG5fnlWm4HiTsyHSiaSXwLi7tNk3vIyU1y2wA2yljODxbXnB0NnhFEHJ16TOX6Pm59S5487pxgJupAb+WY6Jze6iRUsWVWAiBP79hzWZNytce2EsqQ3B4kYuXqFNL367zv0lK4Z/yyRlYSTF+uctPLz3FrKJA4bLdfI4EPcB/G2Vgm2vnL1qC2rudck0Agtgkd7LM5wyVqazCdyWM2rzdGLbnpK8o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39830400003)(346002)(396003)(136003)(451199021)(36756003)(478600001)(8936002)(66476007)(6916009)(66946007)(4326008)(66556008)(44832011)(8676002)(316002)(4744005)(38100700002)(2906002)(41300700001)(5660300002)(186003)(6666004)(86362001)(6512007)(2616005)(6506007)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IUa0OqQuuduDB/l7qQn5kudyLuqaqLdkYXVhcVFNf15HOOszv4q/rmNM5RnQ?=
 =?us-ascii?Q?fPPP+zb5n3uohjrabz/yhj3ElMx0dHYEbatKpWEax6eOjuzce1UiCH256zH9?=
 =?us-ascii?Q?C4KyGYP2+prTyFpZpWGxnIhh+B8Blh7+wnvacfTlIDF+jcRHfGvJnQei37wz?=
 =?us-ascii?Q?Jp+jn5e19W+KvgPQuiTnK8ULmIFw1qvBDtR1lWsRCHfToFq72tzwY/zRAk+a?=
 =?us-ascii?Q?0DRCmOlljZRckU/YeDDZFcQVkrqciFsd4jp9GC7FZH8QSQ0Vtrm0jSjb4KPR?=
 =?us-ascii?Q?UhKeRCTaytULhj5JcI8yg0oQ18pRggfE2k6IjclpJEGxK03XJ6uZITDoQ4+H?=
 =?us-ascii?Q?Q/zYNpAOpL7iMl0TNvsVQyzB53XEkxis2f6pk0x2Xlhg8HWR3zMGlYqEpDpN?=
 =?us-ascii?Q?5neN9CDQZyfFiD9gWljNLXUpHxze9CckGzgQRnlBSiYg25UqFpVrxUiz26S2?=
 =?us-ascii?Q?bkzwiBkbfr3PC0g5t0cMLwtoKeC5F4w+FblMiEbJvl3ixLKznpXE1V1DNPQR?=
 =?us-ascii?Q?Hhoq55TC2KLJsq7JOasHX7FmsvzpPEHB6icChAK+PbcKX3/ZMLIqunfpHsix?=
 =?us-ascii?Q?oUR61x7T5vIrW25GAmbCu1uuYnoM2vkyl5c8bQcU7RblI7R/7GIIyysWF4hn?=
 =?us-ascii?Q?kHQK+yvpklMLNcneYWwfpxvKWPd0XUpoSY05fmwn220o9i0l9+zMcjxqVPyk?=
 =?us-ascii?Q?OLq635nJu6YTZmrPLMxCwHVM8c1JdtUHVg6+AZu9XPinkH8vawKN0aZZfINq?=
 =?us-ascii?Q?WAMj49Nz+kusv7D/JbSbadNsnQYcIe1TYqHS2+LWoZXrXZ2fj17WfrIdi1MG?=
 =?us-ascii?Q?dl+zpKPqRbcCegtSB0axs5Gx2qZhJAxnp5Q/BRLdAmv02ndAQiPsrvx4cmj+?=
 =?us-ascii?Q?LaQdgdDslI+9yxfjM9kxz1YA+QiQQfA8WzH9od/YhkaH35J6iHJnFtUWr4oJ?=
 =?us-ascii?Q?p/FpbgQpwsRdn/NW5olmCeTn5z7Rdr4azxoSUtT/+yxp3kkFCviX98JDAdYI?=
 =?us-ascii?Q?qUGqEO+lvkn/2U6yfWp+r2YsoXxhlN5a95Xa4fQPeGkIxeY+bMZFa1JzHQso?=
 =?us-ascii?Q?UL7ONLa9Wz0BByJNnr4Av1l4SQnYSpeW5I8b4/Uluv4AynoOWhMyn7GvlSpe?=
 =?us-ascii?Q?VvfE3DXvLv1AuYW/pfjJ2v4uzAfVTiTRCNB645bn7dByunYG7GuE6gPcPQwB?=
 =?us-ascii?Q?Ii3YCnxq1DfMG2mZhCeeZs9OEDJ7sWKBKnS8OANO0Ier1a38zeaZR5sX1elX?=
 =?us-ascii?Q?KeUspGXUsTHMHU6C7/yCgKtLA3LFWpeRH7CkoWgpBZ5x/RWGf4R5CE1UGgqm?=
 =?us-ascii?Q?QuZMJKzxbLjr3qrkVCPGXMp4lLsdcRVZzH8c3iBwc0qJth1GgCUHan01lLAO?=
 =?us-ascii?Q?ofDd1tahmtDnXwqHO4oDjKl6ZfAUcUL87nm/jAiwNgCQpGXhli+usgKyctCO?=
 =?us-ascii?Q?w1Cke3CzS4JY7oLA2ghbCRI3g7l1TGgf7tUDCCS9rNq9G1aWX8aVRZt3Lp1I?=
 =?us-ascii?Q?PqdoNq+SmZ9kChPSmX3bUmLr+cpSDAxX1B6+Cm+Lhkwv0D+TUsCEvkhJUMTk?=
 =?us-ascii?Q?jQKniN7nbVHrPBen0YpGeb1fwt4IARdawTAz0iVnVLNC8gofCbZPirvNWkxR?=
 =?us-ascii?Q?RKVpMgMAP0lxn/3VW9ec1yUbdUxLG6Pqryymr0EVMPBsO0fSPeolgf+gDQpm?=
 =?us-ascii?Q?o2y6JA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6874a941-54a8-4abd-cefa-08db4e4bf4da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 16:07:14.2143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Spuy2CkbMEi4RxpXbvO1mYlQtQuKXjJ5FZHHqNMfO6CiuxjL1twmzyLKc+304efqhWPpLP+l4OpEHseFIuXPV2ly6E4IDxMP5iLUDUMZN3g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4545
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 08:46:01PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> If get_unused_fd_flags() fails, we ended up calling fput(sock->file)
> twice.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


