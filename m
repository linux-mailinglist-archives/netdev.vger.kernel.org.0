Return-Path: <netdev+bounces-1840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 541FC6FF456
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EDB41C20FCF
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A22A1DDD3;
	Thu, 11 May 2023 14:31:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767E01DDCF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:31:10 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2094.outbound.protection.outlook.com [40.107.244.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69071163D;
	Thu, 11 May 2023 07:31:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVeXcz9dIe1cOF8ZFNHU/vGp8a7OHsaU81Dpclv196XUnm54XtU8E32GAElsm6vXiJSGjDivxT+ak1jTCCMK50w6oYosQQSJY/rMQIDsCVs0qb0To6bEU9sKtW6ZYojoojKwo5yFZ9Id/1PrFsTyAOMVqKSpYAv/KcWA4JeklTx59jN7XGgWdQNnlA9iBUBh0yDqOw0bsuh9uQwNuW5LMjByxqQyD3gyyz3BUY1dr9w/yQAa7wyGYfSgLON/CCfJJO5179MTXBjkgzupYL5v4dPtyF+1pw3Rsn4YPcyJg0WG3aTQxAwER8UI+hXlCxlJP29wWlOeUwdVtece6tMC/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n0BdTFgIt/06rldDrtz2cg8QkzuSD3hwoqai3ictyJU=;
 b=YNJnIYXzoJbX14aajluXbYLlnVx7RXMNMnZ3sMktwce2EomxXH8HPpKHpewS6EYjHTQPDfnRR5mRDhvVnG03JrfZdeF0Kw4gUlx6/vno73CCgDiidK5kAz9IUtOzSamqq9DO6Y0yCYOVW1cd/AJSYdu6AXS1VpSqtOOB0rTV9JInZsnKDQjREy6MeS+RQA/x+CllYjdVMWJmp+R1y1tzUM2ybgVydR7iv4GQCpi5h/a7u/xaS51Oo1aDsxKxzmJlUc3tPioil3xuOLgeNhEPhc84ClDZAjC8l6itbZxNRi6nW9udOViAUy1h0mrg3YIHYwYrYjwFqla/UxtJ4eeL2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0BdTFgIt/06rldDrtz2cg8QkzuSD3hwoqai3ictyJU=;
 b=woKT8r6rDg4WV8kbAwwdOI+H3tV5TA06uxyH7cyiW5ThGXs6fXHy8RrF5E6TFOrd6XmE2hVE6r5JIc9tlBVTghRt2HoHRxBqy5IxTWqOn51uL9FRwy7vY0K4MDEMFw07pyf4IySpxnhH+XZwld2l6XhBmqBDhzMSIxCDxyAj7hI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5677.namprd13.prod.outlook.com (2603:10b6:806:21d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Thu, 11 May
 2023 14:30:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:30:58 +0000
Date: Thu, 11 May 2023 16:30:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>, Tom Rix <trix@redhat.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>, Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH 01/10] agp/amd64: Remove GPL distribution notice
Message-ID: <ZFz8FWoRyHzVseMK@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-2-bagasdotme@gmail.com>
X-ClientProxiedBy: AM0PR03CA0038.eurprd03.prod.outlook.com (2603:10a6:208::15)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5677:EE_
X-MS-Office365-Filtering-Correlation-Id: f22cbf6c-5b20-4bd7-6354-08db522c55e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gVHJX7y+9PeHI3RRfuxrl2vtF9JLxJ0tzILRe4TH8ztylfbTLH3mVXXCqZa2tr2Oj694dHLdiG90Xzd7u9yI36Nr5+9iKo4HzOWEpt+3Doj6ccaLsKjutDJpX1yAUsQ8YtGrqjhG4uS6D/TymIxkM5zE0jZHIK11KXvm/Uwm2x7LxV5MG14rqTdNHb8tG7uSw69hI1xtzZtnbGGgM/8NV1KzrOeMPlbn+8RBJOOAeloG/GQvnhl8WWEZJYCXSRgwhUG+RhNgQuKN/S3dOJOAb43gWe/CV+Rwa8hYBietkEmanptsskaUs3UvMU6GlG5u0sHrsW5ThS6stSfTen7xsgpmeEQ1PuqHjDX0/+OjJhNq9WcE2gGqr3/wckKvTu+iA3A1gRKYonYTPxTjSsWNAmjI36Bk2fzHaEr9fO3yibgSasNJ+ZutgvGsQb840C1MpH3ha6LgUjhsHes77PbdZAbAcZiPspiZ6/L7W7Pa+MZni46Fqlkl35DeVm2CQXZYdd0aYD5H/PQN72rlmZPRqhx0VP7GSkS2+lAXm8L2qnn9I8p/3NxWy8gr4JaoS5gKv7hwhbMkvrMU8hdiI4yeXIZyEtQSx/cJpOzuP3iHFwCX2XPVJzyzd/w4dq9dtXBf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(346002)(366004)(376002)(396003)(451199021)(2616005)(6666004)(36756003)(6486002)(83380400001)(86362001)(6512007)(6506007)(186003)(41300700001)(5660300002)(2906002)(44832011)(38100700002)(54906003)(4744005)(4326008)(66476007)(478600001)(66946007)(66556008)(15650500001)(316002)(6916009)(8936002)(7406005)(7416002)(8676002)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tr6wJPrU7DD8T9ygVVSW0yKZ5CJ7CZ6i3LD2FF8DGI1KfTDUcEpsS5M6N2qo?=
 =?us-ascii?Q?YY185vZGvPmYBZsYSQDc8OvatUQo2HHL51Y9cDSXrxp6lcv2OUGZV8kbSTGH?=
 =?us-ascii?Q?uEMI2cp6ryMzrjrSi3R50pom5oU43Lvacuw5BLj5tRlZpvB3mBf/tV2+QvAU?=
 =?us-ascii?Q?dhMGD+xPlIY19ZRQ2p3p56B1oVVHp6DzB62cCbwmyyM4w055sPEGo0nHfL6t?=
 =?us-ascii?Q?czRfpSadFagVyzgJfS2+jIRZtdNbw3nnbrxNJvPRyo4dcPeB3y/y522wrQ9G?=
 =?us-ascii?Q?eCcb8wWRuafou92+Zhxi8/AmyagngTAKQQEhbFKmTkeCMUxDJxKI4HHNo9Gv?=
 =?us-ascii?Q?q9OLuggUuUu9i+rKpgMpevKgdX9YHioR5w2UHnW59x4mBeEp5t6epNOKnNZk?=
 =?us-ascii?Q?2H/Bu32wP7Zg7t+f+sfAJlmsb0A2EeF7gA6kR+FOIqk1C108KXA5+S9+Q7xI?=
 =?us-ascii?Q?VI10QdKfGSNb47/9HqCoGHxQbpFTZ4qHW1+3AGTb+yD9nfj2ckMnyfhgVYec?=
 =?us-ascii?Q?UIwgEAHiHUgAugy8BgsLROvSxeIxE5QxRJI4X+BV7NqjBwGh9jZn4dUzOiYA?=
 =?us-ascii?Q?3OVlr6gWQoefiqtZnAxTcJcocM3EuiZRq3GqsrKr26K1VX0C6tA8rAehGQSu?=
 =?us-ascii?Q?sb7XkjHwKm88GoGHqofYEcoeLtDTmgL6589lSRw1b3BBfb/T0xvKxJ1sZI/V?=
 =?us-ascii?Q?wiDjNSIje85/dAPed9VEjR6aOimBQyLEDXfFUrIFluKbvXBKNEbwKjb1DVDq?=
 =?us-ascii?Q?FewBzgDH0NYxc4AtxPmxu/7xULCGpd7xEww0sarMCw3h9oJFDZaMcmpqIBMG?=
 =?us-ascii?Q?ADe1t40j3x48psTfwDLmAkd8iblzvtvY0936LRKancrA4MjxNyCmhxVBU16y?=
 =?us-ascii?Q?AFWaILs1HHRoK1WvHt0BIgeiG1rfpdN8UDiT+J6ZIkiqlmOybasT+Nxscezi?=
 =?us-ascii?Q?LJHva8cwtBQgx9D+3S+pmIDJIJBE0FTl5mN6eHVNhIppzFNyka4hwf6ycxze?=
 =?us-ascii?Q?s5ZLdp8mruxVN1H3WMRz5YI8RHR2v9mUF2E88+YRM6SEgbGwy/GWZk3kd5zV?=
 =?us-ascii?Q?YuuVeK67Thpabz1stfQ8K7ToaBvIf48QPg7rQa8c1UuwuDh3UpOxML0ZaTe9?=
 =?us-ascii?Q?WdWjjd8BC3VzxgTFHhK3ywJlf10/0OY9rhDLIuLzqBx9CtiM1eImlv/yG5uX?=
 =?us-ascii?Q?+d/KLlc++e+1aPA9ak8yOC8+rDORYDK20w+UMV77Ot7lO0MBCNRdjDFtyGPR?=
 =?us-ascii?Q?6lKQHO9OmqT4hu1nUNRR+ljniAgoEKcctS9TcNmF1VOr+KxOlRsLex7pq8h7?=
 =?us-ascii?Q?NbLa3RUfYOhvYfphixcCxlQmMDPAt8i174T3K+v8xtIfBPeJXWrgL2oPv2jM?=
 =?us-ascii?Q?iQNHzNp7k0jrEkC424UoZmp8iQOUW7E8O3kmQkUEXoM7/13R/RmAqL8WRQvD?=
 =?us-ascii?Q?mcvcxjsweAuwGxUROzTzB9UQLLdQ97+5bDS6gTMRN1mr/RQRcRrrghu2geUm?=
 =?us-ascii?Q?xZEioIwA+LrpIbl0moF6KY5eBzWT9FEw1eYBZk7XLHpVzyKTNPGxGcPLRnJx?=
 =?us-ascii?Q?/fTB1iA0CBOixpyYVUwxfHw9df71XmuKgHKLwv39B0P6BzCFEJybaif/ICup?=
 =?us-ascii?Q?NvO/4iJ/hM1nuVMzosjbFXl9bFLRjrrJZFHS2KM7ffeFPnKbN1u1YGOZrbbM?=
 =?us-ascii?Q?9ot3Ew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22cbf6c-5b20-4bd7-6354-08db522c55e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:30:57.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3nVT/s2WeYEwmp+WJDUzR5E5zlx/iwdRel+/B9CBN0BkE5DKomGPmJE1Npu+PFXXmgOMROITyXnBdqeokjK1FRRxuUST6AeZxf/2kO18ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5677
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:33:57PM +0700, Bagas Sanjaya wrote:
> There is already SPDX tag which does the job, so remove the redundant
> notice.
> 
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


