Return-Path: <netdev+bounces-698-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D4746F915D
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 13:06:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 831CB1C21A63
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 11:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7C08474;
	Sat,  6 May 2023 11:06:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6218A1FB0
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 11:06:36 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2090.outbound.protection.outlook.com [40.107.223.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC0A83DD;
	Sat,  6 May 2023 04:06:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT3sDuO3sv9bMU9g9Wde5FW0PWRF2VxYGng0jsyiVla6zO6tVAdX4/JEJQcn/frkp53+wy28c3CltRVMKrj3FLfj9S5zMItrR8B/13rm8sMkPKwkxZseJTQ2VfEA6ixdnXBDs/WvMeKhzQo77p2jDcrJv2exFFzPirWc7gUJ9Gi4sQJ4tdnpkhiIln3c/LHq9S0limg24/NRIfD1WMZJpiSg+lhtcPIYDJlS8wU3/V4YVCkhtTAV8NsUGkyZk0v5rzGCwtVpHXaitY1uPYfuWtoPUBJgekm0Z51gAAOMT0AzKKQZZE/nMD4IQGMAoqMzvA4Z0wDRmA2V78egEDtkxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+/h30J2Hl/5Ft5C36O8V/5BNqXjdrDO/Iwvsl8Gz+s=;
 b=OU+tz6SOb/kJyfSrccmzLpcNN3lXd1+SnqZhp7tPyyAjskFyhvJ1t/tAMpyFFSnpaXwjrAb+0+qwEa/QdvjY0S9Z9+medSnNAAKNGVl4x0rnWrz8FOaJIobhhlGKNXdicCDmrTqN6DzvzZwRwWY21ra3vFRjPhadnQUyk+mLYsjrHg+d2ixabrhb3wbijC3IynRpmRurcUDhFzQgZuGpOK/liW1prn5sHVrmmhxU/HiaU5KAGfQwOXC9FaYU0QPUFCd403hJZmqi2N/NcBzldmFf/u5FFa+xPXmajt1HFbfRb67BivXHCKbjolHT4Pp2Y8M9C4+R5xOeSTEJRDcCdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+/h30J2Hl/5Ft5C36O8V/5BNqXjdrDO/Iwvsl8Gz+s=;
 b=iITWyu9KkpK/vVQRr7Ier3a66DPFD9OBWMbGTlai2/w+phWO95konMxZEFwCs77MzikweAaA/uj54HyqFOBicDKeR3zTyHLNLQrA235GOT78l/8LPlNitcizMM5A/itgfGSZb1UcAb7wvoMAyImTmSiON2QzU0QAkFlUBm3AGzI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4417.namprd13.prod.outlook.com (2603:10b6:208:1c5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 11:06:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Sat, 6 May 2023
 11:06:28 +0000
Date: Sat, 6 May 2023 13:06:22 +0200
From: Simon Horman <simon.horman@corigine.com>
To: wuych <yunchuan@nfschina.com>
Cc: ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net:ethernet:freescale:dpaa2:Remove unnecessary (void*)
 conversions
Message-ID: <ZFY0rlWDt1421Tvo@corigine.com>
References: <20230506094428.772239-1-yunchuan@nfschina.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230506094428.772239-1-yunchuan@nfschina.com>
X-ClientProxiedBy: AS4PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b749a02-bad7-45e9-b1d4-08db4e21f0a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a39CCHEE8nzeRpvQ0wtkBp5QwHrpt3HPAVwvSUyBdCn66gpRSdCFhpdCfV/1/Kuw5IYaBKhfsHrVEOnSr4Y4h6SFVrchib6RtKO+LuNEesZ7QzJ4z66Q61A+i7NgcalewG3aROD8Zs8yfO6/FAog1NgjwParz5OQOVclaqvaGUIfPewS7lt5JEdEpeabyUboQGcKzxzhB4sePSdxoDCgVITPG8p7tK7Xb7qB1Qv5iHLoMvNV605pX96roke0Jjsr8YfCGjWEsiub/ER8stV24bbd6wzmyVOSeZUciSX8sOTvZc/EA3+n6XVBibREcoVs9JrmR7rXse/7IySPK7C/l64md0Yy0M0ybHal9vaiBSSStihOyTjbMzsw2zjQFCr2grM4DepKWcc3AL8lVjDQXGzH9lNHjIWDd/BxdqAlvAUs6thwSejiOfoCOcNGCxpg3JjxYDnihQjr55wUHhaiaJVC9N3jIRQm3MjeZt6HX5fIHRmNXahjcurRojgM45NLcleurLJpPHrMmI7ryI5XhdZ5SpDpyPm+vosG32QvIbohGgC0CwoTzUs9ST2pQTLa34l3KLb5CatGBxIAAMStbJa0fJyecqwe4AzMXD47gIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(136003)(396003)(39830400003)(451199021)(41300700001)(2906002)(186003)(83380400001)(478600001)(2616005)(44832011)(6666004)(316002)(6512007)(6506007)(66899021)(86362001)(8936002)(8676002)(5660300002)(4326008)(36756003)(38100700002)(966005)(6916009)(6486002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ar2oKDErWLKs83ndY65G021hqdt3pB7htHDNya+B4jJKlXlbk2ZD9bnavrUj?=
 =?us-ascii?Q?BCib1lXrT3MsNsOjJRyHsUJSfu+6m6iUTxq66tifGwmi+1tk6irRrVWigOLf?=
 =?us-ascii?Q?BDtQhqX2l1GDhYKAdOJ7eSeReGUjcPYLLdcfl6JkpMQMfFYuz7KJXZv3OR13?=
 =?us-ascii?Q?6HDjGWy7BwKvtbejEgjrcFymLoSChvwP9pn0Yv7jkQUpEveaknzJu/SUd/TC?=
 =?us-ascii?Q?GTx+ZDoax/XlEA9H2no4FeiOzFR9s1mECr4MBCYPGxq0olngJ8QpOygQwAcw?=
 =?us-ascii?Q?i3dny1oZhp+KpZQ3Uo0Zp5yw74doXi9/gYhbs3n9NB4FxbYixvURLrvxqi+9?=
 =?us-ascii?Q?kzFMcEVicMrNXJyravT0C9zZk52/qsArKPL9m1NoGmjKN6qxz2ftev3/IMXO?=
 =?us-ascii?Q?BtaXt+spwzM7F/iQuec23sEXtUgI8Amj57PrkKBcTktm17XhVO4A6pKxX6S+?=
 =?us-ascii?Q?uWM8+lkShFpcFPdIkkVYrbauvt4ivfPNnix5dKvhOtRrQcuZCDhE+uT7vh6Y?=
 =?us-ascii?Q?glg8OudWNjjYfaMSAcWqWR8n2ObN9tf9OISwvDxpNaBqRDFr846afPElo2Ig?=
 =?us-ascii?Q?lw3NaKwTH9/geuw8r+rMNd8bcpoIpixAxdE0SQCpulpDdnfUI30739Anqd1y?=
 =?us-ascii?Q?GzuTV9yDvQ36uGjShHG0o2+EIZ08TbPLjN4LLS0m9Bs7ymjikGPL+CtUnE2F?=
 =?us-ascii?Q?AQl3jW3uAiRca9QFxHyPA7T8mEhxdSO8QzwlYEMyLHtW635Z3OUMtdgciwfT?=
 =?us-ascii?Q?r+CHYO6uv5HocXhYeTER2jkwSJvR2Bm84t39M5xxSoxJKmykcukam4f9fVYV?=
 =?us-ascii?Q?zXoW0MRJU92EFefHLmQCq9AlwUgmvJ9CjbYPrWeAWrPr1CU0TC7/EPh5mtq5?=
 =?us-ascii?Q?Ak1imUfiSxA0H5oaCp0E7NGiEeCAXh3MZHijTHApHvfRVUiS4vEtodzpr3WN?=
 =?us-ascii?Q?E5OXK56NYj6pQAy6zu4qLOGzkAI4DHeDFoPZ1EUSGjBh0en7zGJIfUwB/Y1N?=
 =?us-ascii?Q?OwfNF2cCNSPfRfL1Lg/ArORmGAOmMxYjpJ9oBfPJOtVNtGF3+weIO1aRXaWT?=
 =?us-ascii?Q?tP7nTV61xuDunKnHp0Ch/t9RrTK2r54ldlrPzZIFeG4l8k1mFJ2aqxXExar8?=
 =?us-ascii?Q?2dKjNkVxwPwCmzx4Q+5POia5+NTGuRVX2ucAkl/m14W0XXcPcfNRE4yuB19F?=
 =?us-ascii?Q?9E2nGCaXq8b5KJVCH4+3jRxwM4/p8OfD48BPHlKmBVA4oeDlSUDo2Ce1xECo?=
 =?us-ascii?Q?tiFyK7kDgGjk9pRk9zX6/4cFwVDVNz21iDmahcUYHnmBEruSfVU4tFXkB5fC?=
 =?us-ascii?Q?JLLhwsnzJEm04SD5aN3mdaIT4ZsKQbOCnXw8RcRmp2P5PzfYW2G2rkkJTXY0?=
 =?us-ascii?Q?WIr9aQoMNtxvoH5mIhpyieH6jxZipvYjHHcGJRPTZSCQk/ozXg0oRghG1QVV?=
 =?us-ascii?Q?33MhZjn9J5mZIfIVb2BF7YC5BSPKUL3zTETAg5hng6Ue678Y669bRQkYRLdR?=
 =?us-ascii?Q?DSuqSSBImNO6NhDqr59/OZUeevWkb7AAmbHYYGvm14QG+S6M1CluIH7GTn5H?=
 =?us-ascii?Q?08446Y6aweG1b68EYuzfoF+IUiNJMkXud2mG3tVq7Jf4+3dqH2a7kzl5wlzC?=
 =?us-ascii?Q?lkYactJ/SBsfEUZkl0YmUpWkMGbDORP0elyfckugpCPREkbGj+0VGYLOKC+w?=
 =?us-ascii?Q?LSW2Ew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b749a02-bad7-45e9-b1d4-08db4e21f0a1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 11:06:28.2561
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqvA4zIPvoLE9duoMkREJ8ZQmRyf89w54Z7ekr+bWZP6GC+20fryFhxinawjA8bXNV6sAjKAFTPBjLAb+hAC3Dft+WcDaqqlmNAYCu5ylTk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4417
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, May 06, 2023 at 05:44:28PM +0800, wuych wrote:
> Pointer variables of void * type do not require type cast.
> 
> Signed-off-by: wuych <yunchuan@nfschina.com>

Hi,

this looks good, but a few things to improve:

* Did you miss the instance in  dpaa2_dbg_bp_show()
* For networking patches, please set the target tree in the subject.
  As this is not a fix it should be 'net-next' (if it was a fix it would be
  'net')
  [PATCH net-next v2] ...
* As per the form letter below, -net-next is currently closed,
  so please repost after May 8th.
* I think the subject prefix should be dpaa2-eth:
  [PATCH net-next v2] dpaa2: ...
* I think the patch subject could be a bit clearer
  [PATCH net-next v2] dpaa2: Remove unnecessary cast of void pointers

Lastly, some text borrowed from others:

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle

