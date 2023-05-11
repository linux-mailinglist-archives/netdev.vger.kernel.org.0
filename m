Return-Path: <netdev+bounces-1724-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A579F6FEFC1
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:15:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5F041C20F0C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CC61C775;
	Thu, 11 May 2023 10:15:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817181C75F
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:15:11 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2125.outbound.protection.outlook.com [40.107.237.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B6710DD
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+i6z2nceHnvYDImpuq2C/3Wesb5sx576+0BR1KJfZpQ7fawXMnpqOZwSqqpDywVhaOIQbmoCzXfjzr+pyLSgzCTRbyrPKBLRSZnFqq2vCoEUkC8l3yYfj0bQ7rLJo0irOyjmmJkAYFktosTnbncuMQiGbcxUjEMwFIw8fPV7B8DPg5p+kBaT0OhyjwHYCYtESdXr4mMMctWkJ1eIV5P7tsUQaw1te3RQf0T8Mr7bDJQp8Y+LfDrHM7X8cktheYfzSmu21SQKAThkW5/wvC9Iwy7O+MLJSrrzn3JjXPlUS1TJl3ABtdFj7NKuKaVfKZ2BhoLzK5zL9TfL41DNGCS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPkR1WQcl7c6/mhxOI02B609YRTxsSiy4L6nxvcG7XQ=;
 b=mVjRBAi70dZYgme0sRscTBFFSd3pszCLlPVix9J9WV9arRA80NfchdGabm+eytxm8FimLAkLf1RNdgacZjKBFeEhKo/VjHJLFEC6W1jEXxwgkKc7qmlfQech8x/S/EP3cMKixhGNWoAScT9iz5JNeipzfcDKqJ2HEkBZnNfLr/V0rbqad8iiX9r/Y9xE7bC2u+q7uyncUjIxi5Hiz+yCwuW5FhCZhQUpRHUauVuam5CmkNc2JQJK0xw8zszQkKcvqH3tVwEPh/KuknBHS6s/ebJBpBszAmJKMTGsn5pkVKK++yodFn8jHPse5ocLTbpo3y/1bVLqfr5piqARVclUkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPkR1WQcl7c6/mhxOI02B609YRTxsSiy4L6nxvcG7XQ=;
 b=mRMS1CuAIDGjdgzjv/CEe1YZKTQ1V7shdqs8Ny0yZzhPR/rsxriWmGpl9nKXLBj99Fjl7eZk93XARV9picCarkl51BqkJDi01VQ29ZgLJaHGgcPM/D7OnpRCRXak2w/jE1vgC3iYGUE1lzLIXKKRXY2Cr1W3ivUjtJzw8VNbAzs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:15:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:15:07 +0000
Date: Thu, 11 May 2023 12:15:01 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 7/7] net: sfp: add support for rate selection
Message-ID: <ZFzAJZqBcfsOZBwa@corigine.com>
References: <ZFt+i+E8aUmUx4zd@shell.armlinux.org.uk>
 <E1pwhv9-001Xog-G2@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhv9-001Xog-G2@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM0PR02CA0120.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: dc9c3b3d-9e9d-4da0-b6ae-08db52089878
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DclpV+B7d44ECxmLgnYlExWZq7jfBfOvLAOIoQAQ7y+CAbPozGgUkeQHCcJPB0+Ql1w6VYKgMzFjOAnWiUDayaRZFN5eCefcHUjzCuhnkyfO8gkhScrrc7d67NNlOdzZK66XzjjFL8SCzakBpvqoZq3JKZ2QmsmzkiNES2yama6AmyqjDXP9OZz6yl+8MoKmux8sW2/U3qJAsvd6gJIv2mATbXYvDfPPuHe1zO+haFSTiKzF1FaxmNjxAZbur4DZpUwEBEU3ejfcfmt4FseDM0C8BEMe5QGIlumTL3fRRa8nYTt1ENCkvj/X7wNhFbHMKzWxdHLSx9q/9J1/eRUk6zthUFxco6FJR+ElXMSJT4oodJWxPHG+HszDFSEGTc/BweM9zkalRbQR3zml2/KkbaT9PV95yAGJHDdWir59Euao6l36OSTDvZ6vgwIjw3FjxFRLjY4aIbMimrh31r3/gtIbw+O8bRnL7UCLW73HjPTBEUO0r2BHIo+UQgcasqiNJbnv5eU5FjytVs0jdjENkQJSLK9MSuEfhEMYnAVmDbAGJ/kA6FMIM9ZUTpZw7CT4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(39840400004)(396003)(451199021)(4326008)(6486002)(2616005)(478600001)(66476007)(2906002)(86362001)(44832011)(5660300002)(66556008)(6666004)(4744005)(66946007)(41300700001)(38100700002)(36756003)(186003)(6506007)(6512007)(316002)(8676002)(54906003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GDzmYSBqOfgfmX4EJ1NERy4lm7U8yiTKe8IYgdbZ4+qzKa1KOWVcS3yNoN+q?=
 =?us-ascii?Q?FY98l/QLOHxsf/wu+aRC03Lc1mZq8954ylfwNPfyAgCNObpM0ppmilbE6hYU?=
 =?us-ascii?Q?cnLLtJFgXzQ5l8OT08Sgr08lOn0pueBG6tzwHDLJ+eYEO9J8epx8dm9kGuAt?=
 =?us-ascii?Q?A/70X5Xy+zDsPqSUWftthf023QiJnyUcn/Bn2OT/6QBnC4f4eENWR7Wi5NCe?=
 =?us-ascii?Q?jfD09vFl0L+Qqvb+FdeO0QSxXLibiMK/L9471j2TfgyPGonucrg1vD+H2Hvp?=
 =?us-ascii?Q?07sgHsY6lKV94ABVKk2AXknvLXihf/U3+yww/K6OGCRHKXi+4HwVj0fKWVYW?=
 =?us-ascii?Q?50G9FMHQaf0JlkYnWAjdmA/7weTUtjXeMt7KZhIbCAJ8nJgXWjt4ex9m02MX?=
 =?us-ascii?Q?ZPJCoxZ7Umr1WtamV8p5dtc582xT/4XwIYvMeUyFiAPxU+zRcW53EFsdlGBs?=
 =?us-ascii?Q?2Cq8H9uXXZ95HhwN22buKClHmhbRoqvkPfCp7M0zDbYtrhHr39Guq3mlWUBY?=
 =?us-ascii?Q?3/L8fN7rcCVs75571qcIKhJY1oUQ9zYXSzEPMEX1w8tfV8Q9qKcKhvTUwwwc?=
 =?us-ascii?Q?Gipsmxe93ieq56NwdFUeS8ck3kxuDby4iWVPakBAUIwwjRTq0rUUIPs5pzKV?=
 =?us-ascii?Q?GlkLFuN6v7BNo0i165vsFcTg1V1ENyuof4fR8zrR0LIdTuzxD9coB/6fQFC6?=
 =?us-ascii?Q?fafoBgiycE3N3edyaZ3/5fY8KixK5lgCwQqALAd5zvHjD4w1lLdkpEM9le1m?=
 =?us-ascii?Q?+kzRPnDqEOAnc1ha3aPOzQHZRgRWXvv1JjOSFMhWxBkA+HFmUyraxgyyxvtq?=
 =?us-ascii?Q?DR4JYQnRjg7EcDcdeft4WTeQyQYwGmLKZg9eHP9wFbbsCEMe5qD3ksokug8f?=
 =?us-ascii?Q?mZa0HUfD2nBZ05mb8NGc0doA8doFzXoZFf4y1QztHoEd4RuvoEbZKGTLS6SU?=
 =?us-ascii?Q?J5aE7rOfU6Eg8O2pOnyE89H0VmvQMCztZY54sOhACI0y1SoC4RatsDIidXWG?=
 =?us-ascii?Q?HKt6qs6ef9njlO05qtrp+sle6D4Ni/Aa83CZ2TrlXLzJdMQ1ohlzzq3gKvJd?=
 =?us-ascii?Q?mFLj/QzvAK0jRvR7yOgc1vKD7z9a51Z5Hvjyzu6RoEKF6SMXqkFJ2rtHRtCK?=
 =?us-ascii?Q?PjNXjpHPgdkWpA34u+iij+O1i+tmejDMTPIcwQqUdQEXSL1kUX32Grd5OOyY?=
 =?us-ascii?Q?O4GxMgNT2zbRk44A1UbQVggh9m/DJAEw4+OlqY77dMP1RjjpQ6JXlV6OHJGD?=
 =?us-ascii?Q?ve88dCoXnKEFWfaPzs3sHQL1UMK0itTM8B0ont5aKYIp5XJNaaH7UJBTdXt3?=
 =?us-ascii?Q?h2c6fc1OKtCFyzRzQsebyQJAaP0TlT34soUJc5OjZ8RbZjGuhJ/YhwTSMs9J?=
 =?us-ascii?Q?7Ga7BQue47h4wyNTKBqNEF5VKF+fIAOAU3VGM9zzxmTD6NjVLpcCqRfmgP2d?=
 =?us-ascii?Q?lgNEwXrPmAz2rIqea6E0QJKU38U8ySyzKOgNrAAO91r8R2cNGDNlHzxVmv+g?=
 =?us-ascii?Q?52nveFywk4t/t6fbQ+8jZm979PAWqSTDVwVIqeK6Dg5anFZk1PcYDTLYyAnf?=
 =?us-ascii?Q?HW5F7ZfehC4wquz/1XshUHAemdPuN/DSWQcl4LM3JeWMtCC/TRAuYRUi57Ma?=
 =?us-ascii?Q?3x4LyjgH6/nNSuachTTzY93VyfQwnUySilTo0IuEoRbSSNCBKQ6XBFkxxgpb?=
 =?us-ascii?Q?+NYSSg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc9c3b3d-9e9d-4da0-b6ae-08db52089878
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:15:07.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nP+Wab4lznx1QWZVrXfoiyhY5v9uFWTQJqvRND+loeG1e6OKuqKec0nFPSqtQzyoOYYQhAcm13Awfg0yw2aky6lsLY3mR8zOpYJGdw/c9hI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:23:47PM +0100, Russell King (Oracle) wrote:
> Add support for parsing the rate select thresholds and switching of the
> RS0 and RS1 signals to the transceiver. This is complicated by various
> revisions of SFF-8472 and interaction of SFF-8431, SFF-8079 and
> INF-8074.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


