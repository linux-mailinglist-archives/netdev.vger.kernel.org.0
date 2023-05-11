Return-Path: <netdev+bounces-1843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C935B6FF477
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83CA42818D2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A59461B91F;
	Thu, 11 May 2023 14:34:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AF41B90C
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:34:18 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::70a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F931154F;
	Thu, 11 May 2023 07:33:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYd7aRwB82XXzJRf+y/t8PQLmW7PDuzrVzUp4sw7Y7PmhLw+OvclHQrxwjGZKdbaTrvOXamY+ugg3fSn61xUUvpAKhRJzT4x43glNewH6b+rro8kFtxG0Noau23Ke914RRCV5a5kIBR4xGpaofyZuCQwrWH+R8VVWudThnumivmteVCZqTKoAita8SXUFLgj/ZiA9XJMvCb0egMBTW455vdEIqUBi72KdzkAm5Ufh7Aw+8QWu1hb2oO85K5yCGs2XgQVGrM/7AsNyKOZsrNE2HpO0a1BGR6GlbAaCspq042qSLfbusZyVt6qPM7d5wFtwSoYkwDfIsIk/sBwX5MeRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7XtcuNfIGT0nihuhMKJAditimUVelCubR4kcbYdvsI=;
 b=bUosGRRjSdmDl+8yFu6/0ZcRedxPqYd7MNBCOMIWMc4njncUgG9aMmurMfBMZYRrPcaVIEQj9uhHuDyoTpjDIkl7+et7Sa0P/XvG9WAhnjaK5EzUUEGJ/Ue6ikQvaw5ogoFOerMvuKNrA/GArAGMXWO961EG9XhlKDBpMzwYbdPTjQpEAnLOFHy4crur5Ge3n2/JNi0IPsT3CUBV+L6ryCd3XuPZrgcw6xe5mvyaevPnFhKxjXplj1pz61sfoAjZo3SWWQV7vB5CSbNUqyULkVzK7qoDZkCku84UtQvTbUmyO1LWEM9VaBqL94yVnMikW7OvfE6xJ/kq4OYjmg+sWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7XtcuNfIGT0nihuhMKJAditimUVelCubR4kcbYdvsI=;
 b=afWJ4cdDcnMx+kYBVt0yzats5+azc+WrVU4nvJM31mEFE5kLu0k/lw13tVtVA0v1fM4iUJWvUHKm7xsZ1786cXCjhWd4q3lC7CJBg2dnq9Q6JvYARykO3qrr+90+/NVdqdk5dxnPyj7NPdqchWnL5GPfOmpmvb39RlMNiwXeGgQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6509.namprd13.prod.outlook.com (2603:10b6:510:2e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 14:33:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:33:20 +0000
Date: Thu, 11 May 2023 16:33:09 +0200
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
Subject: Re: [PATCH 10/10] include: synclink: Replace GPL license notice with
 SPDX identifier
Message-ID: <ZFz8pRj80hzHfzii@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-11-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-11-bagasdotme@gmail.com>
X-ClientProxiedBy: AM8P251CA0025.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 257dc40f-fa7b-436b-9064-08db522caaf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	spS0Dr7fOPR6oFenkR5WaGFLdKjj//8cZv9aNlUq+djYBo3cKhU29eFVOaDDsqh7BWx/Kf7QnWqjwmXdHh0wx68tpoA7d+bFo6O7I30CGTe7etYzrbryFXosvc2jq7/Roo6AhEwCsGZmFPQyGb49EKk/xlz8REUNX9q4k3BEcBlCQWXb/1SDZtxTVJAh/stv5vAtqXc6XpuEAIC0VQInCBFKZDIa+Vuk0QNHDY0JRG8TwTQ4wENlhWGa4t1X89V+4meL1zW/HmZrpWxRkoLif9bHzlPwA2MMeG+qgpvYEBXyGoIXsgtUHkLb5yv0kBBxq4RzbCsR14sU2zyQ5Ws+LRslr9VKWH1ajyNIckKRHmCIj96L1URKZgy+JlcxWvRtpLQ4xn4eNNFSFAI3a/Ke/2YKmhJhMIAgjEGO5O4VLXpGkcWQtkeAY1Mr1peKc7wtmQ5LaCQGJ9IhGyLEk+dEbbtj5w6a6ZJ4g0rUI1iY8PPO++3bBXrfzsajljq7deu22YmBquJ345xuoZbkSx8AzQsFb+zAZmmxYnRWfBgINH5OqqEHq7SZX2yMxxrKKgoKaaYamrQ8tzh1LaDZMeZ/F5TkEqvHNROqFHShH/qkt9dwmuEbBmY42DmZxU8/sZ9P
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(39840400004)(376002)(451199021)(36756003)(558084003)(86362001)(478600001)(54906003)(7406005)(2906002)(44832011)(15650500001)(2616005)(7416002)(5660300002)(4326008)(6666004)(38100700002)(8676002)(66476007)(66946007)(6486002)(186003)(316002)(83380400001)(66556008)(41300700001)(6916009)(8936002)(6506007)(6512007)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lnv7iXCz/vSOB7YsWoPqI6WvLOijbNFgiGmDDd8LzECvotZj6QQv4jrEtvXS?=
 =?us-ascii?Q?x+w21q03cjNHLZB0GnM27F9pauCHTK2gsbCcrGvj3yh6zUQ03zmJS9oaKPPl?=
 =?us-ascii?Q?yHaTsMupEMNK/o1Ssj50gQFswb1RDaPC4Hv3agOoBb85lNvj0FIy21YtHAOq?=
 =?us-ascii?Q?YttzD/CfCt9zQn4my+JyxBCon9RU5adaAWtI0LoMkXgA4RiMDzOEXm292qy1?=
 =?us-ascii?Q?wFSp9FrP8lA0sJC29wGN1VSJpd1QqUEqM8lFOJiGx8Qno+yitWBmJKQ1CU7a?=
 =?us-ascii?Q?LDcy6dnYGOOc7chr6NbeBI1I1PslYYxGjOl5q+UOb4/OgMnH/eILgpp/zW92?=
 =?us-ascii?Q?iRUVLJnxdvedzstWUeHBtUU3Q8j7/ifZS41FLP9ZKEbKeBq0dSKDYxmzzBVl?=
 =?us-ascii?Q?pXEp09Pe3xVF5SmP3+O3Kkw62RKMM2J+342ZkmsH6SDmOiBexumM5IFc8icM?=
 =?us-ascii?Q?iUIONEWWW7w1aFmqIHDcXfBuDgf62TrZmspz8Lvs9MzEwGL8jV/WlgvQsd4v?=
 =?us-ascii?Q?I39FBL2WIgnzfKJCTScgXtScUzLSrxFifdR7bz2Jhy3saLKvKAtjA9ZlakUv?=
 =?us-ascii?Q?98GUseCPx/CdAP31cAxOOMAnz987vDow2aGjEjABRXpamhkqCnFmQYysY8rS?=
 =?us-ascii?Q?RYoUYGARrsBo0Fr8+jHcmiP6qae4e+MeVbijhkrm3ywticOc0DpFSJ0hunv9?=
 =?us-ascii?Q?C+/qZnbh7ac7oIp8Hng0Jniz6NDpz7HSbUP7bBuVMBcZ9v0RFDfg/aejpW0G?=
 =?us-ascii?Q?g2g1esfdfHHwY/IJfaTqQwcE28vrAe5YrxAWog1BoZLSOsanystInz/CDQDL?=
 =?us-ascii?Q?DoQew09hoqYEFe3hOgt5Xrb2i/9j0/ADytWyouZfJKPr2qzU8SS/Zas1Y9Av?=
 =?us-ascii?Q?iyJnbEAhj/P8SxyFCO4xubF8yzHPaUVDkl8tI1qrAzS733FCRfQoJu6Kmj1I?=
 =?us-ascii?Q?UNlOuV6H7uYLIB9kwlkBGycai99UeYlfJWnwI78woXzY1gFvdWVA5bNVBcoN?=
 =?us-ascii?Q?JFQFK5kqRyFJi5cpcrAQZtXnCShVaH17khNf82JCIpm1wFdZW2cmHzFiDe2j?=
 =?us-ascii?Q?7LF7lVVXilnBVk/D2ir7pZDcH7rNOiBxQ0zgfMM3Z4bkeCif1UUq652MFDPp?=
 =?us-ascii?Q?eej/5KjGfgqnl7rfNlX8vuHRTDFadne8v7f0Mjo5J8PHcw4Ngtd0Bml3BXLn?=
 =?us-ascii?Q?VBkhkkNuYX4z4L5lkV8k3Eo5RAzi9WFPjQGTYHxAfYCFVmacYx5w3pfQKi7X?=
 =?us-ascii?Q?0QiQl36pHKimp91RT4T7FLOslt90bUowPjFHXaHG0xdxY4PkTZmEqECIFVkc?=
 =?us-ascii?Q?+saGnGeoImze0EP6RlldvYQ7lo9u9QQCiQaoeezVqzI4T4lHQ571ru3JDZWB?=
 =?us-ascii?Q?Dqfzyjn2zBworS00DB8mytVBa6kJKpSJGUX3oTm7NHqyq9tQrxEYgxpfIC/J?=
 =?us-ascii?Q?568nC8CmtQMJjbcNTynKm0oSMIichMLcv2WQutP9at2cOqVhHVl8Mflo8zip?=
 =?us-ascii?Q?GRkY6AertZojkQPRRbBITP9cjTQzUGt+MeSsHoYkuVhs6yM4jV81Gpzd816+?=
 =?us-ascii?Q?sGRPuKZMZdXPsiuhGwSULBpXpED3DhbyNgpasyhLwS+3IzdmzDehBXSYLQ3A?=
 =?us-ascii?Q?t3ENaNMqmwYVs41uTBCFL8TZoml5blOt2Zsa6DuOKPPZ0dQLO7x8qlXE2Xot?=
 =?us-ascii?Q?EOumxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 257dc40f-fa7b-436b-9064-08db522caaf6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:33:20.6509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKvWBbecbJ/d2s//JoClevW9RPzPTGT/yOPNDSw9FQSAl3/BMomGszSI0V0gfoUDbtHCa7T8vRn478+z+xBEdkSsAT/SIeODx4Fb9u6bgxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6509
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:34:06PM +0700, Bagas Sanjaya wrote:
> Replace unversioned GPL license notice with appropriate SPDX
> identifier, which is GPL 1.0+.
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


