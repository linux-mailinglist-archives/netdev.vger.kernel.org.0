Return-Path: <netdev+bounces-1720-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBFD6FEFB8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C29DF1C20F3B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6901C76C;
	Thu, 11 May 2023 10:13:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0531C75B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:13:28 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2112.outbound.protection.outlook.com [40.107.237.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B4BA6
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:13:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zmg/DYbYI4u7R6x2IWZb/eRqBXWxmQVE6W7RKQjG5b9lilJjnIz+ofxMarilfshXeGZrsk840Ho4C5IiQDxeE140oSTuMLeA/qUd0yK380BA1qBt98lJdCVVTBmbvPu9hS//Hsr23XH6JAAF/jbfmZibqR0TXaVonyPdAIhNaGA3rdWRu0PbG7XCc07CghbUPhZoObnH0YyCAgCI1Yr7DtER9SSkgFhbnKyXSG1JqONI4zZHzZoBS2gH3mlooWqo6Q+rSjz5kkGK397u4w5ZW1w3D1oNjwINPuT9at3YyuDPPy7k3T3Rv3tijQelQfGKaKOvY67LWbcdHaQq+VU04A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC/r6ISwd4rjQGz4Z4ZRimZmtVyLxLBBUE/6XJ6/Xvg=;
 b=MJJp8Ix1+fI7WPDvkLuW+Ij6FdEm7oB5H1ilwklagfVOGA8GaqqLPjyYhfty8HFL+XkDAjNX1nPhK2VuCM4ZGQgyfPuRT1VMDEdXGnwRfVUQrRRGrP1wc/Rgckq+dKt+GkKIqSx4NgKAKWY0P8yqFd9/H0YM69CIzuW9ypiLx0dfHotLfThaVWVm0CbUQgaBhp5n5eJ/B1YnfZUcCm+UAC6cfzZs8t9ETXqa2y/+AwUWXpmYlC3ZhgaEcQWGUVEU6xah2fLnQPRw9Gtz2L0YU+ENjma7SZYTN5v6jk3gaxY2sOzLAj5bjgKeJpJ36ULzbxCMlSjqQGw6Bg503n9QLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC/r6ISwd4rjQGz4Z4ZRimZmtVyLxLBBUE/6XJ6/Xvg=;
 b=cAttR+ql276HiBhksSoInSz9sKUMfrlFIrM2I+PCUte8gTfwK+TAlG0WGM0ONStxjGxyNMhVcvOiTocyHe5QiAZIOLOqbL5FTOYube+16cfNKmyTkRq1dKOkJwGyiU7HMHrQlumyjF16AThUfn9CJsHrPZ8H4iEet8k9U7btBj0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:13:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:13:25 +0000
Date: Thu, 11 May 2023 12:13:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 3/7] net: sfp: swap order of rtnl and
 st_mutex locks
Message-ID: <ZFy/v1MgWAubwisV@corigine.com>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
 <E1pwhuo-001XoI-Tl@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhuo-001XoI-Tl@rmk-PC.armlinux.org.uk>
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
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: ba43b3f6-ab48-4e2d-5cdd-08db52085bd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IDNESN4cqS6DG7IhvdwjjmWY1rGSEqfZ8MBCO7xGhoNV2mMbniDCpmkUcmBrTsfVDTl6xF84nN7NCmFZEZalc4NeLyZam46/paPFpzP9tDRY8MlaRxwnKNoK7ByBW+rKNj/XYO3CCKn0O1PgiZTvkcgJqaFpS7cXdjZt0K5ZprSXXHo25kPKr6W/sn0lrIuKRQSAi1upWeZ8ae7Kx8f4sC5ibxzk3przJv74Y7Q7uIh9dOeXOIak00VCpCXOWTtqtS9xmtOvVQueS8RAqk31ZBhNAuQ0icj+RJN2Cid5DBzs4hvz3Q8v9qxak0tJICSi1/ETOzwx2kbuYw+7xLlMVKsbbb0HJrkyBU+A4HM9acCt0xCgYDSQtJGOvpBLq9g9v0iizzAUxg/r8bkyuZekSDbls/f/t4jx8tH1VR5VEN6EyO3yOiTcJgLQ0CHrttlu70FXEN94YKkCbkkhwZlS9CBKv7ZKo3KifvBIsHvwffBYPyrH+VinvHeqAYTjx0wCrMgAfHPkZsKYJG7w9L/S9msprY9CDJmTNsPHCZ3ppQ1nY8wurX3sscExzvLBeipV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(346002)(366004)(451199021)(83380400001)(8676002)(8936002)(54906003)(316002)(6666004)(66946007)(4744005)(4326008)(2616005)(6486002)(44832011)(5660300002)(66556008)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q+tkNeg8BzesHAEm0Pm4f9FDEMx89laW/vijQOMYApNltKIuJmMe75dOy/H/?=
 =?us-ascii?Q?fhM85Hi6OTzbLLaxnYLMSBBO46I0FQ3B0+4ydBJtWt5w2dke9DNNmDTnWANW?=
 =?us-ascii?Q?4/KvMegyTloXGFk3WP3CssoYyRvvMdA2WQ90LqTY1p8+dr/U+AQQCXeI6ELV?=
 =?us-ascii?Q?Ws5RUISq/zfvysInWieTinhJ7EvDrUb3bGsN5qGUdUQ6U0hlyRVsw0phlvMi?=
 =?us-ascii?Q?xsxNu/xTPpOmSWkAy/fShK19steyuQU8VbsN6AB5yJiYa3LdhVNweXpd7wCD?=
 =?us-ascii?Q?WV/rhNQA2tnU4fyBRm2efhI5Ij+JOcAEzQGcW3+CpnOz2bQh+SXRg13U/8n+?=
 =?us-ascii?Q?ygdYnPLI8jU7dUd6VdBGYreT6errYmSn2gWlEV32EUOB5p/dtdbcfqpsgisa?=
 =?us-ascii?Q?5ZalyW6S7GDHz/HO/tUZWDd+94aBWoDrOiJaGWZ/aI+u3dWABah5HBgPewlb?=
 =?us-ascii?Q?UdU3aeHEfSpShpT5Uj72E+0h6/7T6DitOH6VtPhCsR+wSnkzMZ9dGJFZnH6x?=
 =?us-ascii?Q?ckN+tgARJt6qmbnRKn1VAMxZ2Bwm6w7apFN00RU99KZgLr8EQ29FyCe3Sq/f?=
 =?us-ascii?Q?jLtARPapWSMqn5PCegMQQZfdMEeolGlZ5osDqEz5A36gskmEiv0R71g+8H+4?=
 =?us-ascii?Q?tkaZ7hxM2u/HIYFZ9rpsAlcPsqUT2Q4J9TXhSZc2cdXC+4sYdIHSUzqXdOX8?=
 =?us-ascii?Q?G0BS8/OrehnSZV2KDK//zBtgL9qT6mmifx76ez8Eh6oxnxNk7LboaC8pZaaa?=
 =?us-ascii?Q?8g8J57UoROi3rPgaLOQ1fiF8rNl1k5eYGa4lCr22YIO+RgAoVv3LJLsYKhTa?=
 =?us-ascii?Q?D4t6RQoksqWatpBXY0isO93hVURCuoaNILaxAUL5HqOAUHq1xUP0nXF7aa2g?=
 =?us-ascii?Q?6AnGsC/u80+Qwwps5JkQv6wOMXr63al6JE4mFFkgdkOusP+aBztThDYJFfvv?=
 =?us-ascii?Q?bR2f03ui0WHqDsMPKdh8aBsPfJmIol8V2Ki5YXnmWci6g5iZjvL6zRJphqoK?=
 =?us-ascii?Q?0bUZgLhPstUgXE/kIXLaVkqpQiLlI/ODVEwDot7EuygvtSZ43xTntEqj+336?=
 =?us-ascii?Q?IjBqCLLbpA55IM+ov2uAUCdlnULOHSAbPHSnXSK2oobH7asUhhYsiM4aKAK1?=
 =?us-ascii?Q?EczGiAIv6Vs27To7jvnQVTXLBvLaciMDDHcONZsXsb00gepTibhJqE5Tw5VF?=
 =?us-ascii?Q?vyDF4quiKfzbZEAKQjdMYFCXkjE7fx4sQsrH7Gh0+t0N4exK2NVU2XQgD2Ak?=
 =?us-ascii?Q?6LsEhJac1teWXnLr3wyD/lDRC7RFRadfV0NEKs5aeanh+qqo+8Hb/j5XyMMF?=
 =?us-ascii?Q?9MkG/lV0DjEDC0Gdkune+DKJEnAMs13tV9fAgs8OtSg3AmEypFtjoYX6v8s+?=
 =?us-ascii?Q?r20uXlfNIu0FQAgywzijtulDmz73DLVJmSoRzBr8uw61YKbiaDpmjI1UNNG1?=
 =?us-ascii?Q?a21/UkHh4/gUv0m95s6beyCaciv4/04u2HX5hSHE5eCbnGPtUxT6KO+m0Pwp?=
 =?us-ascii?Q?/Gepnn80onumLFW9/OJUy0SxIE7XHz3e3HBxmIaxEG508L71EMN88sPZg6yM?=
 =?us-ascii?Q?qj4rcpFkdTUsFA/kHEiHCgbEjtEG8cm5GbQlrpJCt5JKFR2WtxrxVNUTPXvz?=
 =?us-ascii?Q?/RhWofvc4mnE/xYIIChPnoTg6kty95Wr/6G8FxYgQptgRfZW3dYtXKVC9fq0?=
 =?us-ascii?Q?JmizEQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba43b3f6-ab48-4e2d-5cdd-08db52085bd3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:13:25.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/yQq2LaxxIaHsljixG/9toGbS46JTF6FNrZTp2WQioE+do4zhaJ71B2MV2AdwC3ELygwSgWIffmoWgIMCX1VDn/i33Bm6tyCMkXoUH9giM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:23:26PM +0100, Russell King (Oracle) wrote:
> Swap the order of the rtnl and st_mutex locks - st_mutex is now nested
> beneath rtnl lock instead of rtnl being beneath st_mutex. This will
> allow us to hold st_mutex only while manipulating the module's hardware
> or software control state.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


