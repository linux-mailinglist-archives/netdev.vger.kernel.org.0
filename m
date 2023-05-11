Return-Path: <netdev+bounces-1844-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 600D26FF47A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5AAB281953
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9342C1E515;
	Thu, 11 May 2023 14:34:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803F31E50B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:34:38 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::70a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EC211627;
	Thu, 11 May 2023 07:34:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zrx1ZtklGWMcb9q71BOdaQRDopUQ+PMY1nxWxLg6PKpQuJaj/MJHg5f99Qq4WMLFOEJZE5gAlBpEvRxs0rNha32ITO5KSH5Ta53QOKCvJDOZWzEXUBk9Mkxosba3aMxkMwk5PNPS21wkIR5OPs7m8XN+52SUDs7KrR9cWR3K8kj6Aw+yhTtC1nqr7zjeOZrmte47AXbgpR2GDvK5owq6wxjFFZGADI/cewDis4o5Yd4m8cHlzWnUzle8CcvGkEo7YCp4QFeDk4HrOU+jeigiALOxjREcbt8la5Ku9a7dcIh+tHfDh78AytpVSwQI9DXq679knuKi5vTVK82Ni72EOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OMV7gUkxl3iFj8pUjrqF/PcwWQtn+l9H4iffyknGbg=;
 b=oGjbKfLZMbNy8NQ7hColxJJiyi+WTLHPmwHFW5xMwkHS8TAxMHkz1V5oWZKHN9CvtivUbbVNOdOMbVIWhIvTrC105zej8MXc1G0PsoAdxWkMyeyOQ5WdI1z9U4qRT0Q05sAiyP/+TvcUJxtXOudxGPwhskJv/0l1eZeLvoprBtkfyNuJYSgVkrOYXm2+UtbLoUGPGnJPDNhxlhuqmxTWw0CUokIu7myAZcai2cZsVQYDreUCOCty+68v+WnKy6kVWc/+j8OlLMdnr9Ioxyk7sivIWpcuVwj4Zk46wgUe+YIkZKypoc13R0QlPxAvSsTCSxUOj8aD20H4T+hQsZDwyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OMV7gUkxl3iFj8pUjrqF/PcwWQtn+l9H4iffyknGbg=;
 b=Yr0sjHPZMWHoefPFsG0DqtscQMbsYHVi29KveB8sxKZEOg3X4Qk7GrTcaThhkUwbfJ57UegzJyz/XSThqw+Dn/GF7V6lGpw0D9425NqyEOrl/nP9+9w5gKptHyxSbK3PF0wy+YfWI49IaPgVuqAo3rhBU40r7h/OSWBDjsH37BM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6509.namprd13.prod.outlook.com (2603:10b6:510:2e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 14:33:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:33:57 +0000
Date: Thu, 11 May 2023 16:33:45 +0200
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
	Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>
Subject: Re: [PATCH 09/10] udf: Replace license notice with SPDX identifier
Message-ID: <ZFz8yWskFc80IzJh@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-10-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-10-bagasdotme@gmail.com>
X-ClientProxiedBy: AM0PR01CA0090.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 97bd3abc-d546-4ebd-39bf-08db522cc0d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RJDg7sGkdmgQqlhQn437ylmEBtcgfrxh1W+rMAKA63VfpVScyAxOtaA67fzrDFxJebZe/WaUf+hEESufyw2qM9gxjKOoFMiuNmaNZsvfjj6IfpEOCwjG3AOJniu1OYA+gjTgUHa/1pe9304EK9vjKgw7n/E10pRClS9gl78fuJkcdkXzpyL9iZooZoTnrKgQU64q12NsAAoXpN9rse3ApnJuuuGFUj+sZn6TKg5D71E72koJDEqllajXNoDdUAxFk+AOxE28e5JBM/KEMsey6U21x0Sc5eDLfIpUE/lOjJZoIDkmVfK5oEyFO4uEljc0Bli+ns4SS8NsxIqH+HOVZ7pSa10+FP7ta5T8ySFEFF+DUID0mE/izXQEklhKPLQrlVp4ZYgBKc20F5s3uIytfQquQ9xWofo7gDh8gpEr52dll7mBPKjtHbbQJzUuPiGrlcD7rOB/JZE0iSK/Bvj59bQOfG8SOPzH9LCeJPONsS4My/I9QjtBnoctH3kvTYThLGYuLoassIGgpoBpMg08iH0o/DC15DBgFcuHeyq9H55owS8CLLDo3J59oTNNT1hk7ENMhYnQyMX6sTncsT+hUXwncb6nhdI3ohNlnJdDhNq3iY9/UGMKVeXFHg/W1gpG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(39840400004)(376002)(451199021)(36756003)(86362001)(478600001)(54906003)(7406005)(2906002)(4744005)(44832011)(2616005)(7416002)(5660300002)(4326008)(6666004)(38100700002)(8676002)(66476007)(66946007)(6486002)(186003)(316002)(66556008)(41300700001)(6916009)(8936002)(6506007)(6512007)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ufIH0FVc4OP5+y1ftJVPtSMwiuwnyGb+L0Ki2b1ofnwL0RkmatnEaHBS3vfy?=
 =?us-ascii?Q?tLaypJzob2fNENp55PUozSt4fKOYIxw27pvPPTXHC3HIi5UhY/UMQnM/bWf+?=
 =?us-ascii?Q?GF3a1ewSqeMlfwriP6tydZX/9hvUrgBgDny7S4HIPogOrvP1w1IiCls31baD?=
 =?us-ascii?Q?O/ueNfozqTN5jPrRKEaVXkqr19u57O6afP6IxaPeVlpcG2SfoC8rjuYeigMb?=
 =?us-ascii?Q?x+ffYv1t8HiuzFOIjMoN7fPeBBW9yKCqVdoy6Dhf5hYV6JBHGdSocOxchOME?=
 =?us-ascii?Q?APWP7c9TtqXt0TgdPVxHQh3K/MVqOn40Yp/qhKf6wWAUM0UKwQ5PBl/icy25?=
 =?us-ascii?Q?G+KpqL/Q6aAP4vrZkhBkddXKDE1+0wSMikaz9yQB0EbfmUr5EBcNURxIy89A?=
 =?us-ascii?Q?fLPFWRjxy/BojVGuwQHqnFV14WoV0B916e1dEKKKnoN+QmxjZ2qYkwCnSpsE?=
 =?us-ascii?Q?fi0zEl18X7xGmw6UIC422c0YeAudN/LiU8m3C+fkkP0aEz+sjFabV5INcUpM?=
 =?us-ascii?Q?eV4pYL4WEpIZpOU/hc23Vq8YMRs7+icRk9UxjcjW9cNqTE/wskyDt/fIU1V4?=
 =?us-ascii?Q?Gce4eO/NqZYtFywroexPg2vu0FYhGr7XsXeKsLmSDSII8zf71GfgVymht08L?=
 =?us-ascii?Q?NdyRGUXIKLW6v3MW+lo63H+Z2dv8XCb40LwIRTmGRFjjAq9j4C+i2SGEvDUE?=
 =?us-ascii?Q?7shPzpmhbXQFNxLXcTbvPt/0SDdWihhWHEam5iCX4kYl9LnHpY/PTUXI3GSd?=
 =?us-ascii?Q?ew28tLVCeHM9MFGFdOpuqUwsjnlrwO7Nw46VxiVh+8LY9M7bMYqJxPdbhDur?=
 =?us-ascii?Q?wfDCQVGfW2Xq3YfYkfP37j0aqNforoUsZtSuKSwIWvjTzSVHzuTScNnjeGhZ?=
 =?us-ascii?Q?E0Q/1yT6kgAYnwGAEl+WL6oqdu9gwLNJjGBVxVrP9vZI1MMlR/gChVNjqvcA?=
 =?us-ascii?Q?F/Y7eAWo5uG9nd7weFYLs9JXVycBdSoQ9OR8QaiAapb6wX7UNj8aHJjT3rpk?=
 =?us-ascii?Q?HgJEVzzflU6FmFHefBCsRF28RJ1PH9H+AHqqg9TvcgbxrAWrhkjmdS5OSCAw?=
 =?us-ascii?Q?1mfuFvYlWxHQnOwUNrVYKV+6HqXhA/bFMJeWVUWj8UT6we1/Ac3nSs5ysI9j?=
 =?us-ascii?Q?MRz7rWlMgmQd4f15gwIpaegOo7KvsGWW2p5cvQ7IC4Oa5gSnTa7VEtbhUaHx?=
 =?us-ascii?Q?2CtLpdB1A72qf0+BNrbPiIFW3P6fe/BXmOHWO5jVZkgL70q2ecb7/hvKtJ7L?=
 =?us-ascii?Q?wJZNvvAxMTorMuYhHKYP9K7sQqFoYmXvu4d1VfS388KtCMCx8CRcMjapmkPP?=
 =?us-ascii?Q?wQakgFxAaiLCFC2o9wUtIKx38bxiy63zC/z6kHoafwz38myyU+GAFmRJ1tHh?=
 =?us-ascii?Q?K+7c8ptaWqQYfu/sRIu+iDYmW01qPCpLGLvDVzQKX8BtTFDBjHNhPHOJkhPU?=
 =?us-ascii?Q?7Mcm9YmQgj5WfKsw5ZfzHJQgqqr9QdyeAtxpq8gDqhjoKJwwJWzl+LDWL80S?=
 =?us-ascii?Q?b++8OgHWb6/uhjc8NldHVJyvFU8cJBD2/LW6yfARmhbZHIDqs4r2v58H7r4d?=
 =?us-ascii?Q?0GsXHHjDVYIkCCY1TT36UBAbmW9qhkRfeY9AOb6txYdMKLp1CygspH5r7Wi0?=
 =?us-ascii?Q?11tD4YGITGy1JV7jgSUeZruLlaF3p8d1EZq98v3JE2gAufkQf63T2UhVhCOv?=
 =?us-ascii?Q?QyRR/A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97bd3abc-d546-4ebd-39bf-08db522cc0d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:33:57.3399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iu6+5gkSIkozQJbnNw6KyDwc5ntF9t2T49D6cgYIGTsHlB1UvrNfM9seqaqvzJk3Apo74PF6g7sPIun06+/pIuTkncvyeMRS8hnrJP5NAwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6509
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:34:05PM +0700, Bagas Sanjaya wrote:
> Except Kconfig and Makefile, all source files for UDF filesystem doesn't
> bear SPDX license identifier. Add appropriate license identifier while
> replacing boilerplates.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


