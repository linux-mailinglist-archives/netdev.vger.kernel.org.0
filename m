Return-Path: <netdev+bounces-1839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 528266FF451
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F23F28172A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3533F19E6C;
	Thu, 11 May 2023 14:30:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209991D2BB
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:30:17 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::70f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C685E1161B;
	Thu, 11 May 2023 07:29:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERA13qtuoTTY2XRakdnizehaVSnfLrpmME/7A9eJ879Yn5TUFujE/VY0eCUdtd8qBy9kCjjfJrhakCD1rjqyuKgZQeRMyiTcy9aBRZbAhPFJjovcEAzayCTxtnow82gTQd3qFxgOlLF6pmrXcR48p2jzRM1NoX4PYUXu50zBF9/Uysgr7DPBYHikE2hRRBviudnx60eiVglhahCvJ8q5zoWwNDOBf4/3ytQdNd/8obA5yjTUk0fnpSQAXcj/XmYPGyJuiSlMZ+4+hhgoMPa2zsVzft7ESx6OGlTAT8es3Nv+6Lf69VWVbQErkL94mvB4yKUx6FGVIUXtolBIUxCaKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mN6OgZdNLovoBJJOpGFO0HeWwXyAZCb0wR7g2LnELKU=;
 b=O56+4DOAILk+QN4P/lmh2xbuw7vHW+sW2lHOiSClu5QDp0OneaKkKWVFQcebgycOcp9AHFoZND22Vg8OAzvs22br/l7dbiii+Il6k4iCJ0lQEgk9EdHn61ZhfM4jRk8GXwyFki1LTjT+5m5z055wjs8VM85JkKORRMYasa47irMk3RlhsiVgI/KvdCo6iaDx9josS8tD6AXZ8VxPgJ7S0xSsP3E7WURmj/ADxAlDidp9/yZ9StECGroEK116rMH+VgW/VTt7MCZos8/b7g7kTZvF67MLjVe+jFPpILMA51u3lKWyuGib4hIel+8IBFUKXXUf+ZLLKjZiFIqUhLFPhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mN6OgZdNLovoBJJOpGFO0HeWwXyAZCb0wR7g2LnELKU=;
 b=AKqej9y4NLQ9T30zba5R/OnJXeulYEK+ebi38k/udNW9WZMqvgQ0FzCjpXuI0sqwm51hFJxQA6PcrO0dCr3PFlLIwdSHqMuaw7fSmE3xdGpwNVi2ZO6wPnlMo0E1Re2X36wxhVT2lolfXx/MYxhrXq/DsbrC10qXrMIQ118QT20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3637.namprd13.prod.outlook.com (2603:10b6:610:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 14:29:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:29:22 +0000
Date: Thu, 11 May 2023 16:29:10 +0200
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
Subject: Re: [PATCH 07/10] drivers: staging: wlan-ng: Remove GPL/MPL
 boilerplate
Message-ID: <ZFz7tk+kbw+S/ckR@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-8-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-8-bagasdotme@gmail.com>
X-ClientProxiedBy: AS4P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3637:EE_
X-MS-Office365-Filtering-Correlation-Id: e21ecc3d-8633-4cd7-9d77-08db522c1cb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fHacJv0FXXRU184JMaUEeImJtbFstja1uh+xaBt1cUYiwny/Ppm/l3ICMXzsV82Hb9VbA+zIqjdWn5wrBoYMoo5FqFHQcnyL89cBt7ZOsOJTuW3HzdvvDvVG79nZxQ3qe7IhxDDiRmC4Q8Ut0R06kBPRZ3oNJZm6uodGw5A5BMs+sFiVBcYPIvMHHqQgCgzek2+y9J895n1GPftO6QICIW8jpQhBeDtvBzpah/WwV4CRfAK6u8JCoY6N8aA2QB+cUSm0nv5h5AG4u9BFq/m63GSz08KSe6TRdE2VpglPJoQBDx0vbi3fJKc8Lt7Yk7aM9CySPi2Mf1IwaeN7hJ16k4HbojzPF8MWyDk+0m2vbGArsJsgvX2wDJ8efkZN2C0frf0qp4GoMpt9iiV+PIoEJhqlm6GUfsnvm4o4qXCaDh8NQxv8rKpxeE7VTWh2VQUYOJ5mvRfwfn0WRYSFwIwfnFOCERhr2AU0qP5B71Pz6eahKdwwNsd9ShT5/Ck9K1PwlS3UD3p8XaNGtOxzQd8t83fNBtmSVw696xv50vsbZLt3nEp3eiXkNrdjvG3kr34z8mYipgVJhHfVzlNJY0wfTuwIwfI5F1hfOYInCCyVx9e7FIJ0vl8A4I8JlHiO2egTVfS6PvG8D6j/KwKkQ6/H1yjnWQN/Qz/2Opr0FtFUxbY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(136003)(346002)(39840400004)(451199021)(38100700002)(5660300002)(478600001)(6486002)(6666004)(8676002)(8936002)(316002)(6506007)(186003)(6512007)(6916009)(66946007)(66476007)(66556008)(4326008)(41300700001)(2906002)(7406005)(7416002)(54906003)(44832011)(86362001)(558084003)(36756003)(2616005)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fh/H5qYzJTPbUW2qHhmX/zgejGVieksfwnD6Ss5tbqCtRUMUpPXS9oDgqscS?=
 =?us-ascii?Q?uGQamBOBS+mHRbAyEnL9X4c/AA4NsK0cLK5+zmTNnynriwK5gghmMUBjLUgo?=
 =?us-ascii?Q?ypc0ODp3DxRZTDwJQqbAySdveOLBablURKc0ANP4FJlImoqVSzU+vvvJhsWL?=
 =?us-ascii?Q?97hKcVikcT5JA0vij4Db5GvHbWGyaYO5QkdI4Z0HooGnAJi9Th2eVROud2UO?=
 =?us-ascii?Q?jmH6pYTpQU4tImjHES0t7xclRdbUlRYQtkG0IknYnX23uS/3QgribJ1XMp8F?=
 =?us-ascii?Q?zOi2aHpw0stDzy9j35LR7/J6rTgekDFTGblT3Z0KBGySKh2g001NkjnsP2f0?=
 =?us-ascii?Q?0wgq/479RrnA+EpgdbdV0g+dyRzPvcwKmVDsS2LvvwY3/V+3xBT0AbE/UGZh?=
 =?us-ascii?Q?dRIx474NpY/RhRvmS15n5vXUmknmVb69dHjXPjVSDuKc1PU3XLRw4ks3Py2l?=
 =?us-ascii?Q?46W4kS4GWigDnfj5Zfq/CPzY0Tsd1CUERxErIWLYi3b8AaNrdP0s6OZVamSL?=
 =?us-ascii?Q?2zVPsQq7WKnq6AxH0kAjjuYwLS7Npte9I4b+rHTWRXUUZzP/mn9TLTGZi1j8?=
 =?us-ascii?Q?VRVZCT+Ca2IBlIPuaSEjhGmGFoH6s0pP3cIC1bFFgVLkMfL3ZsDMH7h4mXpp?=
 =?us-ascii?Q?nWuIg+An929sgYf5ffCYrj0eMIy9AQpKNwhl4z1yL6o0oudapei7b+keVCHl?=
 =?us-ascii?Q?cs+b9h4dVOJ2HkI6mx/7PSzruZcjOamP8keQ24E8owFb4ge1YOYIukttzu0S?=
 =?us-ascii?Q?tMpTD4WweDJszQofzfBClsHzV1jNQLgAq3LITPftagTz1DsCe2qMHekZbybn?=
 =?us-ascii?Q?9gsnICJr7gw5H41g/JveBU83C9IfmYk9I9Au5/PAbUn+GI/VkGriCFeCiC5a?=
 =?us-ascii?Q?wyKoe3iIBcOkVtBJYg3URftKs4jxiuLjsFubSKGuuBxnK5kJ5O5T1zhBelf9?=
 =?us-ascii?Q?tlyR2B0WJ78KukRB/CtsNWn1TNtzy1BrAZb3l9xoO0BcR/lY7hHJXDNrsjH7?=
 =?us-ascii?Q?BtIdP0zinLhow7SVo3enSCbkjgRkmInGYbMFga6j0yboShpQKcgK87aR5gBA?=
 =?us-ascii?Q?89xGv6S2XTr/mjabxxWny71kCLB0CPkqSWP3iaZYXu8Esv5M1fnC4wy+tyKc?=
 =?us-ascii?Q?cQ3IHI1FBnyugtMd2ghSXB6nNESyNM4hZKOja0mDUzxAD6HuzW+b2tymM1u4?=
 =?us-ascii?Q?LAto2A7nsAvpsHLFsN0UnacbtC17XrLx8Pwpy6UJpMTUKyGh+4FvX36etWyF?=
 =?us-ascii?Q?mjqLekU3Kc3VmuxCElfWfQStFePVs3hgqJtkCW2ClVTNf4guoHALH8cVqEsn?=
 =?us-ascii?Q?jNVWoxSIwy5p4hG6WID9OgiHyNlACyL6sQNHNL8rkRge47mr4ZBtVAX7Vlm7?=
 =?us-ascii?Q?tqpaRMRRRqJH+NszBEPPPuvKIeOpUG0oEuWayNXVZX/c2hHlI3k17UsvVTKV?=
 =?us-ascii?Q?0DywGmwRE3Han/Tae0FG8WWhTkJ9z+Xy8cuSlEgf0D3SAZy3oGU6u6A8dA0C?=
 =?us-ascii?Q?DXp50oHQO7Uwj7l0nW0ZGVhGMBbbeQ53fQFe4Hgr91uyVzHZmgwNYx8/4X2H?=
 =?us-ascii?Q?GdJS64GGdRUazsaXgfUjkIBFKzX5wVqdIjfanHxky+HECjzbAqVga1QzMu3w?=
 =?us-ascii?Q?yFODwAvngojQX2x6Fl/JrYvmYC49TObnKjz0wrv/a3QhxIq76slIvvsXyKxj?=
 =?us-ascii?Q?JSBebA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e21ecc3d-8633-4cd7-9d77-08db522c1cb3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:29:21.9710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5T35zS7seQy66k5aevvlrV1VaH3JOa/XWPM+Ny+u2CpIchIr6gw2+H5ni84QbRaVHKvSOJWc4j9p1EPemsZHWjUszFRvxWK4OL7v+7HI0cY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3637
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:34:03PM +0700, Bagas Sanjaya wrote:
> Remove the license boilerplate as there is already SPDX license
> identifier which fulfills the same intention as the boilerplate.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


