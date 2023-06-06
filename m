Return-Path: <netdev+bounces-8335-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 293D6723C10
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:42:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 473CB1C20E30
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7370111AD;
	Tue,  6 Jun 2023 08:42:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB63F3D8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:42:52 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2109.outbound.protection.outlook.com [40.107.94.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C5CE8;
	Tue,  6 Jun 2023 01:42:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHu7TfgKfXV9Tv6o3zAkkDy1zW3IunJkE+6hm4MhJ2OwmNnk6vWmLwksYohe+wb8vwrxmZ3r1cXp31QN+znreUQEAi9ns1/jeCywMVzJZ/BEYSDhjJOaEYpjDkmL9IcBMiAgLdUPFzFYtAH8Tvp/uJjBAia9H4aLvF4uzTxQHjE7FyosedOe223Fs98tkEljC3ybvuL1cAL418/dQJku3abhRV/DewCjZ9NvAfB+NGnelna/JDXDYjAyYXi6HWeE6np7z3G8Np4cvT7UIG4BlINE798mdJBXaeOY8wZ9NJSEugHrZTOX4/3LJ3h30a90lv6pqnS7zDgYvCJxoOsFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g0DMF6Vp0+F5O5Ghg3be7zyaMAa+3oQNIdfq79rXQNk=;
 b=bY9Za3m+ULXBXXDr1VYHlM3Zh1QR0+YK0mZIMPa06Gg7q6nGG7y5LMgstgMdGw9QyI+70LcpJd+qBniHr8/t4o0i1fK+NXpY4iIsiJwIMW9b20EeK1KSTbxsBdNaEaDfJQZvv+uolvQ5TMiLKU8CZRV3a24YQjyDcH9lCxq4ggj5/5JStPOTlscdbWQp5x7vD42ZTMxRTIR8ueslb97FvsijROQ9uk3Hp/UDNzTb00pSI6Zsi+t8W7jXO7aNp0l5gYzOoXPCS6ncbWY+8DnCNd4JZtWFjSmHhfFsot/hCKtJbb6OahIerYZ2SwzzCnRFSNJRiDwW9Ib0M15k5NgyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0DMF6Vp0+F5O5Ghg3be7zyaMAa+3oQNIdfq79rXQNk=;
 b=n/uCQGK4SYxbwJxQFLTIsYaj4ZXDdfdJ4zE/DAfKbRBZIIKVx8Dp0SObsbKjmEjef+eKSB92aTceDXkJDiDNP1olGkoqWZw6l0CtvlUP5+bertan2PBh65XAIMBXxQeN1IGdjK/4P3Spr2E0SnXK33zc7AVn0ePzlnD6m2ZBRYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5776.namprd13.prod.outlook.com (2603:10b6:806:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 6 Jun
 2023 08:42:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:42:49 +0000
Date: Tue, 6 Jun 2023 10:42:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] mac_pton: Clean up the header inclusions
Message-ID: <ZH7xgznYTfyLIslo@corigine.com>
References: <20230604132858.6650-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604132858.6650-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: AS4P192CA0035.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: fb9fd38d-57bd-4c1f-1246-08db666a0239
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iWcT0ZGU5sT2IXx/iqjOLYpkg2/n/u9ihYYJ9RtmyROYbLAkxjBBU1273hmtsNun+y4kxAr41U3XelNj8sZ3uRVH73xpYqdYM6AEd2ZuKqt/jhTy9CVsMAhl1XGcH37Jk9PoznmP/Q3GRz8R72Jouha4m4MggTLeButC/eyhrcjDMQxYPZS0pUEVcBfJH0ARFFLh4is7hQqEh95Nzhj3G2ZiO1TA2MSYBXmGBNr9slc5FeNbo1lPdjfe2OzQwRGCoCscBwdQsmNw7+NZxfHD9stH6RpF6dhHbjXin5EOUwB/VQac/WlMJ2VtZFl0uZQrgKj+5Ka3+DbcCC2lo1k3uoSyKuEK017gvfaOnvx9nOWl/N8HojBFoYJGJl3k1llqxsnEnLndozrqpyJ6F/QVIWBj6nm2aEb42ytpIbYhYEYcPNW+KZuHNNyIV1h879477aHdplOArvsCtQriyXDzYqgkzMTI1DSjOAqcnQRaIulXRR7NWKWO8yAxRkfE3a8mLjm02k8Z8tFVDWZGr/66wQ5Q+MgQ+/AW4IRjrdEPqDHPs7UXJbjJQ9GOiC/wfVrC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(366004)(396003)(376002)(346002)(451199021)(4326008)(86362001)(41300700001)(6486002)(6916009)(316002)(6666004)(66556008)(36756003)(66476007)(44832011)(66946007)(5660300002)(2906002)(186003)(478600001)(6506007)(4744005)(6512007)(83380400001)(54906003)(8676002)(38100700002)(8936002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p3/J3PfcETUiPbWmquJfl1KHkr47HSDUkFze9y94kUEIvh7UM9/xUgqv/HzY?=
 =?us-ascii?Q?yp/ls9ME8pzuhdrgqGGn9rPWjYD7Zwq/SbCE+0Qs/IEN18oelcxkgtQ81sIG?=
 =?us-ascii?Q?pIVbEwCguX/7o8LNYjHZHDmMY3mY2WqqTn16GDsut948adeLdyRnDKr/9H9k?=
 =?us-ascii?Q?PvyqAbalzxfCgddZ/CrFLDK07OF96nwK2PRiNMsBmskBgkiR89BREb++GA1h?=
 =?us-ascii?Q?aX8uzfs8UfBD8bunqqOVTFKv36J/nyhPsWAUi7fzvAlFBXw4TmkDnmyw/8yU?=
 =?us-ascii?Q?hp8C2RZBmbwLI91ZLVzc3ian6GRsITWcksmu110jZlK2DslnMaTIerixAr3t?=
 =?us-ascii?Q?Osgyk+r7+8yBi9Bqrg74aRmWvVP4TsGD794BKvUEKcDApogG46nnVs8WwHQs?=
 =?us-ascii?Q?UsU1EP5hGN6da34eM3O91yG5ANkyuOEfkr1FNqNTzV3rMbve4xaKbaVzh/QY?=
 =?us-ascii?Q?+fMHhnBzSyFKehtFF9eUf9Z+8B19XyM4twLWBgxeTsaltpaOB9973H/rvlXK?=
 =?us-ascii?Q?WwgFOuAQTb/RlIzbxB/JuL9EVVQMALxSt8ywE2MBMdCpaFdAifRSyERv3wOR?=
 =?us-ascii?Q?GBwT5PNUY5K0d97LMvE57Ds9dY7u5kGnCAF8T6FPtRvUe/kkWyy7fI8CVHnm?=
 =?us-ascii?Q?Moll3Ll3Z297LfQ64ATMNtAJkRg8E7FtHRJthS5lOQSyBsfLeOhoZ1udFHwx?=
 =?us-ascii?Q?9eprGhORd95zlqDhHbfnIy8MTPLYavtgORGjPuZrLocBzu5kViXeu1qXQSmm?=
 =?us-ascii?Q?e/U5XEX5VdyfLOTEJm7E4AQVVtUeSGBFJlQxAb862GdI7B8WdI88AqD2Uyh9?=
 =?us-ascii?Q?SuieeysQA9D7HpV/eMt0hoyGWNUvzy6bBrGPmtfWbMN2G86aF3wXKX7Srn+7?=
 =?us-ascii?Q?feYH30qI+S1FatxlKLf0y3wWjuzhUvgaXsdFPtvdPZb+9z+d13MNa85rQ5iL?=
 =?us-ascii?Q?0JYdYtg/5xeHusxwFkfQyiKu6vdAn0ICvzkMN6w4ZuBOsXn41WE7yMOPPscG?=
 =?us-ascii?Q?NFfVys1SQwu7IIU+F3RvTwcegXofRofoC3yjqWfHN2966f6MiWTcgjcs6S4O?=
 =?us-ascii?Q?OJuF68he8eQCu7XXfp7tizWIbu3rXzrHhNG5zwBpblMN2aurG5dkhAfqAbl0?=
 =?us-ascii?Q?9W9xQ9DtW/sHJrpSGxH3LF3fhtZzdDlgyzZwdyNzpZfVc5vtFmsAal8QEVvQ?=
 =?us-ascii?Q?xp2b2wNRJBqUqZnsRnQ7WR1snsbr+RHfxIgRrtm26NpVFA2D7bE7JB8yyC9d?=
 =?us-ascii?Q?F9wUQ1Ycrgt0UEjQmLGbvQfxXh3F/sHiOoOevRZejTCrvPfYsF81dmoFwtpC?=
 =?us-ascii?Q?R7NO+iznp5Y+jmZuDjYgzpHvHfAEb92ryGG9fnnQVDxvSGlCR+L2K/32dXMK?=
 =?us-ascii?Q?exVV1ILZ7HywMWArBppN0CWHaFl29p08aavg+kGCKwClOXMggrJpAVi53Yoi?=
 =?us-ascii?Q?F+CB7TmDLtJHRQLqrifTF/ErxfbgIpPxj80spcHN7CzJXkwJg+82HMJ1TifW?=
 =?us-ascii?Q?Yvi5DtbvF/FqQqTCf1Gnc39blfGMZepBkRg8QnKb7t/TffTYXdB7U7ES14D6?=
 =?us-ascii?Q?OTgUwvXtZ56ukYYhyPwZB/glke3Y2L/P1iq0wmDV8XBIxIhcNQ3xZGE7ogF0?=
 =?us-ascii?Q?Jb4RsR046ARLjOATps5hQzdlgItanc9jZIPteEj1MMNRfYWhzeNkm1Qfp2b2?=
 =?us-ascii?Q?U/zSHg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9fd38d-57bd-4c1f-1246-08db666a0239
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:42:49.4209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFPMpVUKX3D+dE7z2/J9ffRs0XjdCicmpjBPCn8MVg1d+/E/K8jfssN4sAVqufnwOjn2zaz+IAFZI4cdiGlt3Ys1CFyGyMTdSieRKE8PrNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5776
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 04:28:58PM +0300, Andy Shevchenko wrote:
> Since hex_to_bin() is provided by hex.h there is no need to require
> kernel.h. Replace the latter by the former and add missing export.h.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Hi Andy,

is there a tool that you used to verify this change?

