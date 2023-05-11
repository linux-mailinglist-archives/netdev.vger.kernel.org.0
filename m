Return-Path: <netdev+bounces-1845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59DB26FF483
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:35:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE78328191C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1B4647;
	Thu, 11 May 2023 14:35:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8919F642
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:35:11 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3714106E2;
	Thu, 11 May 2023 07:34:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H/wz27dH6EIfC2ODDwkIVsJgvitVH4pVff9w9Mjn74I1VahzsHGTg8QlwIpRYwIatNcjFtbJmIkhbK79Zhy7zMdevcxr1wUU3Hd3vBjEaFHYTi+3DYI3MSIBQd5cI6F+mQ5t1LVaPuZefFwyFCwenxCVoB7rldHcm2K2Nq9SqevP5ytjsRxiFGduJW3yydr63e1XGcJe73zjFtUlKo0u6KKvRgPL3+BoFER6q04kxDEuka5mAQTZcXg+/izVASKM2RpKOveKEVAOX+/P5INMSb6tZmKaJTlfrfwK3ay/aFklqChhDwqLWeqKfW6z4R3IpQwsWYP08zfMg6tFjwse9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0K5kcXO42I0YcTXaMQRjQhKoWzeTjgItkU3XSr/7Pfk=;
 b=Vk9xpbDm6nCtXZ3CMQ2df3sqDzw3zPLTUzGg7qVGM5gB9M4TkUs0iY5aXC4bGs3UeQQFcuwEpUMruFHKYTdZxE2kZ2hhetIZ4wbCKaN4M7Gd9FG1vXLnEodJV3Er2DNegeaUvIR6O2CbS+1bZ/ZO6tB3pKXACMYqgMy4rJl4UTtzR26q7hu9OxsaiG8QmA8ta5GYy2BiiWboYyoT+8ToZsjYGXSksGnFpRkaDHkKrBrhvKNvpfPMrEqDCxiix5NfwGvPenfk58PYdB1ATdOynY+ESk2JKmmWM9ifq28WaXJud9duesdKEgJSoyh38st14zWivNEp4+QVVzQt11g33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K5kcXO42I0YcTXaMQRjQhKoWzeTjgItkU3XSr/7Pfk=;
 b=dyKoXyqxZlxvBRT0H/jbciDxldblicmjd6KEEY0QKJAahujRNXMLaDQrNkES64zotM7Gei5OaiAsfJgkT0HKRfiJ3Bgmwc9LLkaDe7Gq2jphE6J2iX7DJZdrXYqfIJJ3q14aGk4JmWfqrTMeTYi8UG+UCMM/KSjyYMiAFh0oEDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6509.namprd13.prod.outlook.com (2603:10b6:510:2e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 14:34:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:34:45 +0000
Date: Thu, 11 May 2023 16:34:32 +0200
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
	Maxime Bizon <mbizon@freebox.fr>,
	"David A . Hinds" <dahinds@users.sourceforge.net>,
	"John G . Dorsey" <john+@cs.cmu.edu>
Subject: Re: [PATCH 06/10] pcmcia: Add SPDX identifier
Message-ID: <ZFz8+D3X0dvR4Kw2@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-7-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-7-bagasdotme@gmail.com>
X-ClientProxiedBy: AM3PR07CA0062.eurprd07.prod.outlook.com
 (2603:10a6:207:4::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f840f3-865a-4f9a-6e24-08db522cdd3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V3kqp4h36nwpYsTNbbMLUlAc+yiUMNE2r79rdqL1K3PMwaOC331DxL8LH6gXu9MBz90hBpO33lG/LNODoXjNRYJMXh4YlpjEe8Seqp6XXte9y0fD+tRosf+JbPwrrYEbu7FEluKtMxvwJcRP7ei/VCbwp7MDmMdIgPkmxWecfHnXoIu6RdYkck0f70PMD9z7JTYo2qipODWtf67ZoIlWQ8B7Kra4ArFSyliyexshK7/G56j9UawT9m/xXcxJAUn+0klspooPafzRhXK2PEm8WlpaxrGsg5+J9ELK6VYAvmDEi4F+pSmagr5nvKLvDbrvGC3z/sDujGCVMHPD43FfAHeRrVM7+7kiWd24Lrc2ZNpVG96blY1rAVpBuJimo3A1/XjCgmPhOJ2yoHrSzLjWmcEhQgridetbm1gBH61xcl0uFYYC7Ot4iRMqVDjVxPI9AIycHwH9e/rD0YNhdmZovffmXpPAIb6dxDXBAUxT7wQWv6iScKT31sG+dFmP1NgMCm6FTPDzLoH6V3Zga3AZG2JtQ0y4jZ8e7BCyECbFRfO4l2YlQWMYazqaByyf+NIXYZn80OVHIgXh6Hu88+yDAQAUcdQS6vS6HAKhEB66sUchzUzkvlaDvhyeExHrexL7jFLjlsOEYuEotrZ6yrgCwg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(136003)(396003)(346002)(366004)(376002)(451199021)(36756003)(558084003)(86362001)(478600001)(54906003)(7406005)(2906002)(44832011)(2616005)(7416002)(5660300002)(4326008)(6666004)(38100700002)(8676002)(66476007)(66946007)(6486002)(186003)(316002)(83380400001)(66556008)(41300700001)(6916009)(8936002)(6506007)(6512007)(67856001)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rRyF89AGh/Q6YFQLaggAHo7nhYUIg+UyFVAaYtByk4BaGK10VcjE/O0+y4Xd?=
 =?us-ascii?Q?MlK6nD0uyxQlzX6hUm4ZdnM5+RfNRcRJy2ZTdg56g7CpRHZeXSSZyPJ7i7Yg?=
 =?us-ascii?Q?/ZhV2CGAZOO72Poz0xUmViqeOj/1ZvuyXMJq4CTDwBG3JEDI27GlOJs/kyQC?=
 =?us-ascii?Q?H2j0+mKnJQpTL+jOknt07NWebChlSI3AZdJ19iQ8Y6hW7K0Q/SLQR8y5lsK8?=
 =?us-ascii?Q?ELTSf+kxMc39DeLxC+OVwGc0BHTQuWzRd9DUoMH43yebcra+W1AhT9n6W5Yd?=
 =?us-ascii?Q?Q0neR4qF19F5VkPe14wJ+kWwuAuK4z4DPLp2r5iD9fS6huadgv8lSOHaJ3f3?=
 =?us-ascii?Q?7XXSXtRJwWw5X6JVhEG+iuzH2tt9YIiVhAsWI90wbLNYZevur6PErFsyASld?=
 =?us-ascii?Q?PhMAQ78g8SyiFWpk0M/KbDn7Ps2POnXNq90dV9KzL04C5z6jZjxPHVEc5Gxe?=
 =?us-ascii?Q?cazi1ALrk/uziNuOoRAf5euPBMpU2NXnE91VYjDBUdz2LPHgBg+0CD8TaaLa?=
 =?us-ascii?Q?ALnYQmhG80Qd30Jtj9cglkd4zIEyzGiMJPtXKvh38540dHl93vdlOKxaUyb/?=
 =?us-ascii?Q?Pq/foOUiBecOFMEV6oS//2KXUNGy5c0MVgl+VIDfWE7lQkMipaihT7T8VkYH?=
 =?us-ascii?Q?ycNMZ+Ll0zIIhVFtmokarIHl0U79uGpprM+bRbKXqQufiaV+J92Enp8vOL58?=
 =?us-ascii?Q?QHmXukxXkylc7gv0vSfnK0hRNVgTXUxjluPOOyr55mTeSbLaLtVuu+uHl2lJ?=
 =?us-ascii?Q?w8twzbEmXezg8evan2xZqtNRTUIWyb3uurTscJ5Mv9u18HG5YUJqkNYKlBjm?=
 =?us-ascii?Q?QP+76u1WVQpAkFhFiG96QvEHL5Cvtt9ijG05oKZBk00SGUsM0rNsyz9UEKPc?=
 =?us-ascii?Q?enDxvIv+lV+dw2UxtjSEgWUhjr0d9qQPRfR5sX5LNOoog4IdyX7WYHnJBEDg?=
 =?us-ascii?Q?at+iFHdsQWonV1sP03PS5z02CsT4t6K2aC4JgHISuHjdSLk5fxTQCBpNvvEW?=
 =?us-ascii?Q?P+xQ5JPLUzv9EatiMmqkxdjGq41vDA+YNT632VqtdSGL9IQ70yqAZdrYLCgl?=
 =?us-ascii?Q?skxiT8Ed7G+4h1xRIXlodIVblbURMVYOr8rU62LACcva487ozSAog714XryM?=
 =?us-ascii?Q?PYBLtY09blfXx0umjbNVX9mvNzoNF6eN3ny4kjwdaOWTEiO9Jf8bESQDdwB5?=
 =?us-ascii?Q?AUp3HnWlOIRj9f4OFlqGbvUfRWDBEkrKxaGYFAaqMWYVmbh0IEBAJAccFRI9?=
 =?us-ascii?Q?tNmy1zxwxUorGtyF1qhET/NO+FOUNR2Odgx+8pRBP99IFRmYqiv5Fw8tl8AV?=
 =?us-ascii?Q?nVuwrYuuNnjwMINWcCH1O/XuaNfurT/mpH7T7sGeY940o7VvC3ESnf42KU1X?=
 =?us-ascii?Q?71f0IwvnVKbyZf5e30+Rk2wfPxhuGC575Jatag2ZgDjNW7MS73M1Kkc1WOdK?=
 =?us-ascii?Q?HTxY9prvjIzhmG6H0ZSf3TETejTJp4zIDBCDSyJmQOeorD9b81r+k7ymf9TX?=
 =?us-ascii?Q?v1hMTvoBWmUpRgPLNuLIP9HfK5sAVAIQQ9k7yAHyE3q5kFUFJdvZT29MEYmW?=
 =?us-ascii?Q?VAEoz62BdSrGJwp/rdQQagRolS2Fk1iBN7PxeHiCw97Cfmpyt8n3l3Hxcbg7?=
 =?us-ascii?Q?mXNVtdPlZKloRfTGubC4ve9bqSu0NY7nm/YGOFZINSG0tsTGaeu5qq9+Z8mG?=
 =?us-ascii?Q?PmKJYA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f840f3-865a-4f9a-6e24-08db522cdd3c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:34:45.3174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFjALYzeQfYdLma3As1RyCGXxNpJEtZPn8IQeYrNdb3cLhWr1d5/Hb9w5boojVApO7YK+af9r0swcWL0yWirwChy/JNPvjG8G0TUcyyU+84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6509
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:34:02PM +0700, Bagas Sanjaya wrote:
> Add SPDX identifier on remaining files untouched during previous
> rounds of SPDX conversion while replacing boilerplate notice if any.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


