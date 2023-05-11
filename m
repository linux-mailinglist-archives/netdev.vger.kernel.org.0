Return-Path: <netdev+bounces-1842-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF386FF475
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8A6B281752
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F351C01;
	Thu, 11 May 2023 14:33:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C6520986
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:33:48 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::70a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FB511B74;
	Thu, 11 May 2023 07:33:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaeoGQ6+Z1LS3oMX1221lsEqwllRsI8+wWodjBoBhGmEg+kC4Zp79vpNvcmuySkjZFbBQwHhOeePn+3PC65hZrSXBiQ3mhMo8do+cQJDeUxhnSSkfiB0X4nICrWV4K8/nZVidKpdxJ+jZ3Umv27DEPqXpsAeMIVftjeTeOjvL9mmsuqcJM9Jc7gy0+VQtzmmsPK5EogCcrgwP6ocqINt/RJ2Sx0dS4zfQgjm79GqlTI7KHpIcceeGgIEAHi4xrMxDt1T4V2PgDnS/aBZvGeZPrjp76NdD1mwBtj2VneJUmnUIcxBpoJHP2Uqd+4dNa3X456g7meMLVB6/mfvjFi+hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRYEAJInrxaogd+gcE7Mj1JVEnbUAS+m8eV1FNqKoMA=;
 b=MS8zr7wf4DHwHy4zFbpNYuPFvoekp9Z39heelIGg1Xo+DnKxn6w+QMUL0rqTxEwJOqmciCLEKWTW+V9su1UtjvtZkVy8BdhxI/G0zmsTsj3HPWX4uEWC68iQGhSo2hoNvvt8C6x8r8ZxU8ZX9Ev76c5kVOp9wZREs3+eV4HlBDNON0HAlWwJ1kAsx5azl++Wl35NXEvzd/elPAcCvbZ77aHf1C+MOVIeUOR1BtoETZvCMIJs5ha2+fUAt0iKepyUGsiS6SFH//H5zTCGvBb3tmnkTfZvN2byrvzgJ22a28gmhRN9QypJ1OvDF6YpIUrfBNLXImoMgPKxJ6ly9xbTVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRYEAJInrxaogd+gcE7Mj1JVEnbUAS+m8eV1FNqKoMA=;
 b=afzORCURaDxd/XrmlQ74OvgGf34g+wNDoWAWoW7TUul73gr62tSggae2lvjRlXcVQfVNrkA6RWTKiRMEqvgEXEc23vSGMMPBDFjyGi//PUyFuZHe5/6fqaRWYpgfYXCojs57R46RE5lkD7JK415EUe+w5oOp1NmKYh/2K+nUZqY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6509.namprd13.prod.outlook.com (2603:10b6:510:2e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 14:32:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:32:51 +0000
Date: Thu, 11 May 2023 16:32:38 +0200
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
	Ray Lehtiniemi <rayl@mail.com>,
	Alessandro Zummo <a.zummo@towertech.it>,
	Andrey Panin <pazke@donpac.ru>, Oleg Drokin <green@crimea.edu>,
	Marc Zyngier <maz@kernel.org>,
	Jonas Jensen <jonas.jensen@gmail.com>,
	Sylver Bruneau <sylver.bruneau@googlemail.com>,
	Andrew Sharp <andy.sharp@lsi.com>,
	Denis Turischev <denis@compulab.co.il>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 08/10] drivers: watchdog: Replace GPL license notice with
 SPDX identifier
Message-ID: <ZFz8hldNxPDrh7eq@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-9-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-9-bagasdotme@gmail.com>
X-ClientProxiedBy: AM0PR10CA0124.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::41) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 0494fd3f-f30e-404e-e748-08db522c993b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XSP9wRRIncijCr4++gdhBdqKApIOmUd31bSO/81OeaHILIbHRDRAkBsAI41OoWxP+PmRshkAY5jglDLOJ4k+Xa90fJW/sQWYsKfhsvst162+wVmCkfbqRpRiwNMggdBTBDOQbFv3Z6VrH6kg+877vHLDl7Bz07XKw4A/E9CJl7JFj5CoOQ++GfRMcdXlY+3OE7cVOf6oEiojOcMWRu9F1Bm+j8AYjjgzdTeSKUbBntMg+eLtUpWjLaGes9He20OEAwKcjH+0RtwbKSirZZoo8xfpYP/PbSYk8cttFdMJdoIRIblzztkwOifQhWgDGbezKMFyRojyE3sHZwTLOYmAQ4PMj+VnSQKKDoN4/JKehwY9hIJthCS1nIo8REXKxSU8bGm8liintJXja/i1jkOtqr5DOkZAAlO6M5ayZ3G+Rgcy9LS1cUoUTo1h+GES8uS4cm75lcBBh/7x04sBziqVQU4aF8POM30DlBanYUwJMJMFEudD4xVQau6Qotf9PP4jJ9KkSr2V+iGJqkN+0mELdiYfDGB9xLApuoxRwCB+wXQCTRjbrej3o0z+KsWBnjxGCxnosGCVkpSaMku3ZeimdTTyKN9sFgWzQg1Gk9+BOh4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(39840400004)(376002)(451199021)(36756003)(558084003)(86362001)(478600001)(54906003)(7406005)(2906002)(44832011)(15650500001)(2616005)(7366002)(7416002)(5660300002)(4326008)(6666004)(38100700002)(8676002)(66476007)(66946007)(6486002)(186003)(316002)(83380400001)(66556008)(41300700001)(6916009)(8936002)(6506007)(6512007)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QuGvQqoDpyWvbmLlV5iThrkPFOKRjguwnj5HcjEn1bcm+k7a7m8iMpxGYX5X?=
 =?us-ascii?Q?hvH84SO51PK55XHD0vRgR/JV4DHZytzTZ6zukZlm+E/QO4IGOaqdg0dz5GJK?=
 =?us-ascii?Q?RPGKAraU1gopq3gge2ZqeOCRp/1XkxizLPOtZEoOQQecY1IrwsTYHu4+lA5q?=
 =?us-ascii?Q?9DeGrOojjWavAenL8nyBJpPbpZjsweWqo+uEtNwbWRS/RWsyUzhHPaMZ/vTY?=
 =?us-ascii?Q?hAE22a9ikXyfPzjXmghlxT/1mPIWnasyKZakGOZpfdGsXaPDtj+9RlgBbS0A?=
 =?us-ascii?Q?akOsvuv5ckZzPYFdG4AdmIV3MMcJXhfMWtgap55FQgcaiIN1xJ6flHAof9uu?=
 =?us-ascii?Q?ox8kgu6Bn+9j5KeTMVc+AKzkuiCI9tV7OxYZIRFpaF7Qa129x5mJsoy3OImJ?=
 =?us-ascii?Q?hG2MKcvAXcJD/Xpv3sa5+b5ISxABdl03XgocuzkwnqxzDx4lQfG4Cg9vT2ej?=
 =?us-ascii?Q?6NuZKIqirkE82qbFw8eOxTRv+aw86YPjigoUZfoqL1ZX2ixLfDvkUTWs1k7B?=
 =?us-ascii?Q?SGoib6wRrWHAXlA76WT/t4gbTYoVvAGqVKGKQJffXOcoSZpyaI3kB3xubSQ0?=
 =?us-ascii?Q?2bH2Wqz+O8Q3wUp9fpRHeC87sv6TajqmsG/6OH3kQYS85RDpieVrvPLcdOh4?=
 =?us-ascii?Q?un/+AWtuM1KwcCg8fMGYz/3EWgwoCr+BYekOX0DLDUOTLydT61J8BP4KV8/x?=
 =?us-ascii?Q?DGPC8G27RQeW4dywfw8cc1csSUN8HC9QunKK+F7L/15oZZdAGkt74+FkkB4D?=
 =?us-ascii?Q?W/2BGjr16nkeYeC/IXC7ZKZtF/nzH+GUJ5+lG61epQVOFTXETO3q/xsnkIkE?=
 =?us-ascii?Q?XylrQfsaNeJ+Ng5RJ/Yo7fP1Bsp1lRpqYyd0wmM4BUuzLLYlib4Ts4Ban2Fz?=
 =?us-ascii?Q?A1MnWEEcPtFvHRNP2+yco2H8p7gw7a9hNfIE5bHPc45a9l7GqbJzYFuT4FaX?=
 =?us-ascii?Q?tngRuPsgBYikW/qbkb4s6hXlVdtaINAAM6hKuNJY4jmEA8xIN53kOIopBLxk?=
 =?us-ascii?Q?uMlu1sw37VYR0xnx9fBe+ePcuSPK9eccLr/mfv4BU+jEojcCTRAfuBy98l9Z?=
 =?us-ascii?Q?E3InBv3Koa15k6mIV6ncJ48B9Yw9D+OpYllnAPcWpoMiXV4VX7Ue9GRKI3h5?=
 =?us-ascii?Q?J36CRwvzo+CClyZaj0CKWDEXj+bGqMTbBYcuKT2EKybIvC0FpPnWmwiynZuZ?=
 =?us-ascii?Q?jhh8rUBFuzsGUSR+k5MAM6vvlY23JFsPqSKCREig2DCcjjPddDGuN7Oh1Fwg?=
 =?us-ascii?Q?Cgh3wWzdLFM6uz2+YaPT71SjIBxrI9DgbyPRBhoE1MsLomRxyNoooH7q3xN8?=
 =?us-ascii?Q?lZFZr8VUHRONVr2eRFgGdiidXsn2Z1t6a1RZkwbdi1baqUg9G/vJmG12KwoN?=
 =?us-ascii?Q?pThzDBOkXQvpgezkhU615VR6aK4rKroaTvzxOewfGWtFvZ20fL+4BiveXncp?=
 =?us-ascii?Q?XN/87vKyBxiRWFrMEM/nSG2wsAEvv0iguJi5qFasRSUieIC8YuI2/tJ8SGNx?=
 =?us-ascii?Q?WwOANGHeTmIhQZ8m6OL9iQxzZthwoqoJ3myYO+4ljfF+TZ2AZoXufbgCdToH?=
 =?us-ascii?Q?/moyi11zhlEwbucsFw9MxJFtoHFc6JGXFesrEZZeSGaR1ARgul4uaBeeW3rM?=
 =?us-ascii?Q?PpCBrWgS8wPISeJUlxGJ+gokCoMTmmrCEZlRPknh4/YAVALIAQE/GILDJ12J?=
 =?us-ascii?Q?X9P3ew=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0494fd3f-f30e-404e-e748-08db522c993b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:32:50.9080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7rLJEMNpJ6jQNxweZlttjgpUzuNQeO000HYGNq40L/RJiiYa5RC/wHDetaLY5MwFMSjFwCCztlgeMQ5WIw5jbhQe7MT0+7OU+t4rWDGvc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6509
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:34:04PM +0700, Bagas Sanjaya wrote:
> Many watchdog drivers's source files has already SPDX license
> identifier, while some remaining doesn't.
> 
> Convert notices on remaining files to SPDX identifier.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


