Return-Path: <netdev+bounces-1834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8912B6FF40A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF86D1C20F54
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 964021B91B;
	Thu, 11 May 2023 14:25:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803821B8F3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:25:14 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2101.outbound.protection.outlook.com [40.107.96.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC05611575;
	Thu, 11 May 2023 07:24:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNEZR1V9cicsPIicS3u3akllebJseEm0z6EEGUCSAaE9LCr23X4wrU5xmq1rv3YoqovC+pEfgh22IxL3yOB0ui3osv25aepnAw2ZYdPjhfBk0HR6Fk1gcIm/wTfzy1H0WAhtvuoHfVnXYnKbmLSh7dyMk3Kqsx0cf3S2sMc14kyKC6/aB4baT9v2NAGTUKng0t+qoJfFGDt94Bhth75JfKvQABP1hM2+Kn8yLQcAs6GpIGxpRI+Yx4nHychUSPuuAp7qzOLcJhdpLy8RbHQ74DPg4h1Fhdbn3HlxgWgX7kdajPYFVvsGLr+ZoADiicxV8SL548hYkcf4S5UcYWyGVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RYmxkQ/ji41+jhyUAH9q4OQql59eG1Qtdit4nAaHJ0=;
 b=AcEpL3EcPvnepJTN1YSHawQ05MV6ULxAbbXycoavMjIAw/AMOSh0ZfMtSuDS0PipAojo24bU9WW9lTCiZjvTzXG+dOdiWNKTVPlyiccNK4rBeYP0nKPx60WYcybo63/IXodgM9hz9Z3K4SkylMCiMGJRg+atK12buejwWJkzf5YPl0wYhGFqXNJPeXFa+LhD1lov/Y5tfi22nIDEGnbKCcVKtBGpEn5ciqgOQWAiqGbeLVXyL92Wifmh6Ef50qnjHhUYHdU6sofHWOC3zKGpsONOpP9HlhGtZRQRpFp2mJZIpjWP3p870mXrOARpYD+/sS87rzThipmPjPbRny4w7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RYmxkQ/ji41+jhyUAH9q4OQql59eG1Qtdit4nAaHJ0=;
 b=amgmYNBn6odxr/Ufgxx53TbqXMQcjOWtwwLIkIlJGvsvVqg+k/0524ZsE84OR5CI7lQB+xiKV7clVfTzMppBR653B+++eqnwnqBwH2gcsh9Y/ycZ81Zz268QjNQNjKQWnCsamtJ630TA8jR5x+MhBhz6k3MMX3kKn3jW8f6CptY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6522.namprd13.prod.outlook.com (2603:10b6:a03:561::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 14:24:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:24:48 +0000
Date: Thu, 11 May 2023 16:24:35 +0200
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
	"David A . Hinds" <dahinds@users.sourceforge.net>,
	Donald Becker <becker@scyld.com>, Peter De Schrijver <p2@mind.be>,
	Greg Ungerer <gerg@linux-m68k.org>
Subject: Re: [PATCH 04/10] net: ethernet: 8390: Replace GPL boilerplate with
 SPDX identifier
Message-ID: <ZFz6o4NerIKW/db9@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-5-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-5-bagasdotme@gmail.com>
X-ClientProxiedBy: AM4PR0202CA0012.eurprd02.prod.outlook.com
 (2603:10a6:200:89::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 079f9e82-b533-41d1-0fed-08db522b79a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HrO3qMY54g7s+R0TY4gShgDySFw43IfO6KpRR+xtG/HFFRTYZOW4LihUwTk+XVMvcHVeEFdReuuaKKCP/KyLEBPk1Knw22J0e8XMeRyt77azpb0D4MD4LWC7jRiXFXHIoOstAZV3xesKrD2gEWQHzFYNUEhocVhEk6YFV2WR5Sz6/k7/xbpN2WvepaAUvJ4VQI+B54Ux1EIM+iMvQE7tK6e/M79j2ThBLAW/bt2gBmY6p/F5Pq7x+XGTleGZTi0TN5z1Bh1xTaW7GwEgXdSFKhKxhp7yNrvVxxjJVqNDwHgDyTGayf+0KlWDndYlNH/+csh8sjK/ogsLGBGQW3f+VYx+DFnzBY31mlEgpkOMqFBYS/m2jaSBecCPJQ68k+hZYbxudBncvrNowNKKaXINGJ3PMQW812NEUC9tlxBj7UtiY3IjhUAsIQgt+QBXUMOGXac05CnW7QLPRErkq3ptO1fbiPY5fippTwIwWdjQqXCLuoWTDVpnLc7WzaM6IHBorIk4IYgq+Wok2pdRg2iHxe9eB+uQx7dRF7yir0SG8og0f0KTZYbZcJb8c8vbY7G/EmU45ldOZw51cbi2HUukZ4wkyDQZ53m2sU1a4Mr0WP2siQ104ucuoCTd9i7uBQuK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(39840400004)(376002)(346002)(451199021)(186003)(6506007)(2906002)(41300700001)(4326008)(6512007)(6916009)(66556008)(66476007)(316002)(558084003)(38100700002)(83380400001)(7406005)(7416002)(2616005)(8676002)(86362001)(44832011)(8936002)(36756003)(5660300002)(54906003)(478600001)(6666004)(6486002)(66946007)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1IW8BJyNoU4F6B3Cw5ECWGrwPpkI7fzqw+DqvlkAdzMXhNp82XKG24BzhXe4?=
 =?us-ascii?Q?HE699Uj5M2/NNyPRonVMg5B0NBivACNj7PY2hNlbNU8eUzgmBcKt81xvvMz4?=
 =?us-ascii?Q?WjA7BNVWZ+78c+g8jsy0bjPrrZf1NDOn8yv48JZfHzznVca3AopY4SxMpEvo?=
 =?us-ascii?Q?Y+HqngUJ3uhCdp5rX8IV4kVLqpQlLkK7P1tQ9fzkk5uMfrv2lbX5SP929+ud?=
 =?us-ascii?Q?ToCK7+85eWizKEsWddR3nkLd6N6TN/rfGHL+b2i21lrSBG5aXEtGOQwXV8uS?=
 =?us-ascii?Q?3SUAe7YZljodex9ntwNQskXCnA+P1+NUTXSGz7VgFtJDeYdXaMg8OdimTDvx?=
 =?us-ascii?Q?vtZ4xUSUe5p4/kZ1WKwuo8RbaMRJ59snhWUwHiybgt8NRrihnl+OfVzsJ4wB?=
 =?us-ascii?Q?zRGRtZMpaq9h4zGXCsYjKcxlGTiPFTstdKFkiT8ZHj1NCqLLCzwO0GZIrvIi?=
 =?us-ascii?Q?aSo1TJujNZj5P/M1APR6i6dwmHMBtq75tOXsBrRou5YY8MEK54EzAcePv28U?=
 =?us-ascii?Q?Y7rxCekp8UGMURQB7uWTGaa9En6EcuwANyVr9C2LvohgrBTcxheUZWxMvFda?=
 =?us-ascii?Q?IrQ2x409VAsMiYWDy8Erw7glaZFNEhbMIQnFin2cC5wZJgX11s8uWfdUwMgA?=
 =?us-ascii?Q?oKV9me7NjhSBbv2cLb+k1+Nn8+Y3isiuO3bFtm4ViipBgr9quMTwrfJCfv0c?=
 =?us-ascii?Q?fsj2T0lyLylElGI/9KjJN3Cgy/Z5o8YhyEUIlN/1ANeDlm3KfetluJu0ryei?=
 =?us-ascii?Q?5I7GXJkz3bNlsmXuru8lvEsF53t66DFFpZh+2NyANXohmwn387ut0u/13zMi?=
 =?us-ascii?Q?aEcJErVziXTSyw+hYRwnracOhqbBmrpZunwMnSBY7zMzdqwHbLISN9W9N6hr?=
 =?us-ascii?Q?U+58OrRs1xMCgdsk8dqkPbGHXITaRx9sGqLmwUMY0RItcPntlxEcYilZ3eP4?=
 =?us-ascii?Q?j+umMdTFpJKo/X6wALnIUdZx1OrNGZMyvU0UtIgEvVF8UTD5cEOu1Vl5CHIl?=
 =?us-ascii?Q?E4tz0SoLmiXEP3/yPzMJmbpYEW8JPR/m5pdOt6oeIaSZcGMBHNQ2CkROpNs0?=
 =?us-ascii?Q?0f7W2QiOzECYO/bQmsl0gLRvEuxnMX8yahd9nGlGMcriCIblWiio2BLpNiec?=
 =?us-ascii?Q?0bSoY9m8q+4NPND6RsxAKwE3GVvG3HuR52FjHuP8tHjITT1+BE1GQGAXXMUJ?=
 =?us-ascii?Q?yUnyFlENLpR6DNGTcYhIE2GGafTN0o5nOPPqt61vIA5e2eRLKrZhDJHEaSU0?=
 =?us-ascii?Q?EBlSy/Zv/9YcWyYc61/D7lcjfBAfOlGw1pwQcjS2B/NEFuAmTD0q8iorovn8?=
 =?us-ascii?Q?TZRhXZ97P/GxIqVG9riroJcqKd3WfxhS3o1Odk9xyLoNkdixw73HOWdP6cU0?=
 =?us-ascii?Q?9GFIA5FpZH2bJx5J08v+hOPq13NVH+MA5njcfN+3UKw9YpLADXTf9WjeTk4+?=
 =?us-ascii?Q?XWAe0nnSFVL9TGjZAOzbyz3dNK9yteJuOmP6KBKc5GlN8ShXGczioxSFSvAz?=
 =?us-ascii?Q?n6ja/7lKL8+77iCRc0IlnLAt1yE8rRthRCHSLfHjTfuoAnr1w4hiJYjg48E3?=
 =?us-ascii?Q?FWSwMsAl5uZoshw82UmDyaoUH7iplGdZOu3GbXyGana0+7QTT7+4EQBq60js?=
 =?us-ascii?Q?aEQgScSLGfbz1dR/4dNz5WgjwRPeJNOd+nj1WCZsEeAvjoC7H+PIOlqWZain?=
 =?us-ascii?Q?IXJlqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079f9e82-b533-41d1-0fed-08db522b79a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:24:48.4821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBYa4i0225d+FWEhZcGlcrSsF4Rw6q8PM3lEkU6283qEywrGDDidvQtc3+5Xnfb2Oua5HZuJYc46tFhAXujJMZqJDxVGnJCURPBtYL0Pa/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6522
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:34:00PM +0700, Bagas Sanjaya wrote:
> Replace GPL boilerplate notice on remaining files with appropriate SPDX
> tag. For files mentioning COPYING, use GPL 2.0; otherwise GPL 1.0+.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


