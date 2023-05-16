Return-Path: <netdev+bounces-2879-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA08F70466A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 793971C20D56
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7FD1D2D0;
	Tue, 16 May 2023 07:31:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B07156E9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:31:52 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2101.outbound.protection.outlook.com [40.107.95.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9984212;
	Tue, 16 May 2023 00:31:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bi9lHTlIDjT5JrlRrKdukGas4pPls625i9dXUYRk8Q+PQ7Fsp66w27XzlMDswKo7q0/GYxcJFxCJ8qPIZhzY4yHkxaobSpPOrNzHb6wlt1JX2EAsLbQuMiJ76IuldhBFNOm8P6yMZ0zyo2DDRotJ046v6kIshgiTlg/JyAvUwmVUKvV3okQgEpGCx1XgVYZq8g5r+85pF7+bQjWsV++piSa0rjlWJoY8b/EZncGHX57zDkBt4VZ64eI0TV0oIcnhMma8FKc06toCYy+keahrU4cqsef0+iqBJkA3ctW+j5OcrR3n0s+TzWagy+uGY6YME/13G8v3Qx3h+7NIDcxamA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eFlqXhQiEkbgP1NIA8fFFfatf0UtjMDcqi9RLlasb10=;
 b=N5FvfGl6VTYb4HefR3T7oMHxIRL+arQJEMwhZK18aOUebLxolitQ+3OztqgqGiE1a2TIx1XaDffrmUz+OSeliTNjAZ16gGqk5HIUotVqc+2SZzTbt70KL+wNiPAFctKfUkzBG+zSd9WC+tcl3xasGZNcsC5LIsKtKIF3SWifsR6085PFweNKq9E5Aug174fW1SCZpXFBw2EN/p3FYohOxuwJ7yoYRL/KFPQ7icC5gwNIK3xTNBs4Lggw+Yfxuv8lDgjhnubzWbMvktC5fc13BtxVJac4EPUOwTR6psNbQNDyhKORE7tdEeIGlbL+5cqDFbZ/kPbIib/xT+jfuu2vhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eFlqXhQiEkbgP1NIA8fFFfatf0UtjMDcqi9RLlasb10=;
 b=gNf5avQAB4+0nsO0SVE3vh16c6pgLl53Kprhq9u4Igwdbi4sB4qMQj+2Sg+tUou4aO0RuktvCYu0INMzj1G3TxgqXwHgquledKyJc/uaGSneP4tSdSDhQ5qX9n3E7D00qFyRaKqlPOTD4TwshfB+oMR1Zsgq+DemneBwLKZdwAk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6477.namprd13.prod.outlook.com (2603:10b6:408:199::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.15; Tue, 16 May
 2023 07:31:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 07:31:43 +0000
Date: Tue, 16 May 2023 09:31:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Wei Fang <wei.fang@nxp.com>, Rob Herring <robh@kernel.org>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Ondrej Ille <ondrej.ille@gmail.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Haibo Chen <haibo.chen@nxp.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>, Mark Brown <broonie@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
	Michal Simek <michal.simek@amd.com>, linux-can@vger.kernel.org,
	netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de, linux-sunxi@lists.linux.dev,
	Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
Subject: Re: [PATCH net-next 00/19] can: Convert to platform remove callback
 returning void
Message-ID: <ZGMxOB6iVj39vM6U@corigine.com>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AS4P191CA0027.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: b2a29618-4d56-4c83-7683-08db55df98dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hr8jsJ3vUhfSc7EM0oCVyiwcJl/vmH3dyvN3VO59tE0fAkv1nVIG8++hhZzqWOAReyBptUhHxmL0fMw1/qZ55GluG/SZ3ZQnUYNPIIgIp7wtoYh9CVck51UrRxuUX9+1O6PZcbvpw/KJ95R7IdJ+otzdxBVBjBZYv/65/W6sYX4ruCLb6YphjlqQoiIrpzDjnt9PoUgq+l2zZAPKD2cXd/A+WTCY9CnrqCduNd/aERJNPPE1gYu4+tlFS1pfFlGeIjSREkdMZ8vPaYHAky6syO73RSiXrGexTGrQEIRFA2j4M1v3iSEBR4uOlzydk6o8noU3nkUIWVM0ErS+Hl0II5JbW7lp9wf/fqOp337Nx5pQFMUC1lsVixdA0sh24N5vyIP9mTPNhp4yF5VWmuHYnTgYTDMK9fJBcJQBuIa59S2ycevORa+y1Ik6bnX9m1UyidUtoJSAoipo7pUgZ7GPB9+E1kpGy3BZKkKqJurA6HVj/puAyzwhUfpcQCsv+jDbuGL+8fFx/HhxFoWjE8G6vfpg8/2QOkaSgTjFHEOifuE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(366004)(39840400004)(376002)(451199021)(54906003)(2616005)(186003)(478600001)(86362001)(6506007)(6512007)(38100700002)(6666004)(966005)(6486002)(36756003)(4326008)(316002)(6916009)(41300700001)(66476007)(5660300002)(66556008)(66946007)(2906002)(44832011)(7406005)(7416002)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3NveXp3eEw1a0czUitxYVNqL1djZCtpSksraGpIUzlMOUNyUUgrSG5TZ1V1?=
 =?utf-8?B?Umx4WXowZldWWm9YT1VDR1Y2ZkhKSXJSanAvNU5YY0kveGVBYVJOSXJ6WEw2?=
 =?utf-8?B?aldzaGs1VDUwNVVCclY5M1RrejNxNkhOcGVRUHNQL2RCazhHQmJyRnd0RWpQ?=
 =?utf-8?B?c3FwTjBxNG02ekNEQ09lSklqWGNxeTFBOFRvVHVGNFhqeWNJVTVHKzd5eDVq?=
 =?utf-8?B?T1JVMDB0V0VZV1BXYzI1SVRqR25TaGlVWnZkaUloaXpFVE52QzVBSVAva2tW?=
 =?utf-8?B?TFBuSXhnYXp1Vzl4NU5sVXVueTFVSUlEOGtIRyt0VEdJZkFFK1JFMmFrKzZF?=
 =?utf-8?B?RHBJZDRCU3ZpZzNvT0JnYTV5K2NMSzJUUk9Rakt5K3ZSc252b1d4UTVqTHdy?=
 =?utf-8?B?QUMzR1YzRk5FWjZUWVRKZmVYb2JWbTZ5eUNQcE92Vnd2STBJL1NiV0tTRUh1?=
 =?utf-8?B?b3h3cVdEZ2FiWXVOVUc3OGNRT1M0czZ2WXUyR2JJMEVZY3pDb1hDQTRPUmZk?=
 =?utf-8?B?d2tFNUEvZ2kwTDd6bjlHKzRIT0lqR2llaTZxNnlEVkNIRzFBbktKVUlVN2VE?=
 =?utf-8?B?Si9YanhvYmF5T3pNZkZpMFhFV0FKZzA0YmhMWXpVOG1LSnJVcHlwUEt0SlVV?=
 =?utf-8?B?Yk9Lb2EyUVhvUy8vMlhNVGJzLzltU1FmSWxUYjZQaURDTHdTQ0JsanpaT1JU?=
 =?utf-8?B?dElSaDNPQURrYVc0eEJGc3JqdGtwVDlJZ2Z1cStzWlE1bmJLYUdXOEJTRTk5?=
 =?utf-8?B?QzN0dmh2NkhYL0o1bnB5ZVcxMmZqR0RNTDJGekZvbHZpZzAyQWZDRGIrUXho?=
 =?utf-8?B?K0taYlErNGRWVFFwZUdYOTgrV3hmZUNlZUZDMVQzek5GVVV6MDJXT1djWEYr?=
 =?utf-8?B?TVFIZzA4RVJVM3dGTGlDVXMva0dqV2FhQ3FFSTBtVmtta05hQzUxUUNrNzVw?=
 =?utf-8?B?MGZoTVZRSUxUeEVuYlBQTS9ISTJPUnBmTmwveG1JZWRxZCtxbFFTazlzeXIw?=
 =?utf-8?B?QXM1SGc5c1M1dVluNjFPMDY1eGtiWXorRm5GZ1RlMTlQOHhvUUh2WE9Wall2?=
 =?utf-8?B?dGRtbDVocGxuYWoxRjA5TmFkeXNWbTNnVjB4eGdFeWx6dHE1ZVRJRlJvbFNF?=
 =?utf-8?B?ODFKdDRyQ1d1bWRsN09SWkNGV2xjNmVmOUVybXRIblNwclVhYlI2WTFsbkJM?=
 =?utf-8?B?b3dOSXlhOFBnVVp4VDFpMklNMzVza3UyemppeUM3MnBmcG5lb215bkhBOTky?=
 =?utf-8?B?L09PcmFJRURuRmpraWNwVlJKT002cTllaVA0OUFjbUJkMkZmK1JwZTE5ckEz?=
 =?utf-8?B?aGN2TXhVaG0xWXhYMS9WTDlDeXNBUTVMVFBUbG9CUU52Y3RtdWNGOGxnMEl5?=
 =?utf-8?B?ZmJlVXNqQXhBR0RpYWQ0dGdNdzJMVjNaQmRIYkFrdzR4MUs3OC9sWlZvOWpJ?=
 =?utf-8?B?eE0rZDlMZElZMnE2b1poVnJvYkNNNkhmdkgxWmpmNFFsbXp4RWhxdGNydkxi?=
 =?utf-8?B?eDcwTGptQmtjTzVuN0hyVjRsU1QxcDJUeXkrZUtvY0g1bXlobzBNYW1MU29q?=
 =?utf-8?B?RXd2QmlBcEd3ZnJwazNlLy8ySmVteG5DNExXOENtZGE1NWMzZkhaTFZTVUNn?=
 =?utf-8?B?b3pnQy91MC9adk5VYXg4U0JQSUZIN2poSjVxTGZRV2V3ejBPN0xiN1JBcXl2?=
 =?utf-8?B?UlgzYzluZnBocTBaQVdTdmhoMFBaWlNVYWMxRFFGVWZOTzZGU3NXUHF2T0pS?=
 =?utf-8?B?Tll3M1l3dC9nNXA2VytuOXVwWWF2aFVmNkhOcHJFL0hYNEpxZmEreHVkRXh1?=
 =?utf-8?B?T2Y3Y1duWWtaKzRMam16WUp1UWxlWFd5enZIVERpWndBWEp0blV6NG5WM1or?=
 =?utf-8?B?dUdhMGMxR285dVBaN3FMeGRBU0huTklmVjRSK3cydlNTODlJOFFtRnU1U04w?=
 =?utf-8?B?alhmcW9IbjF6bmlISFpMSWVHTEpJR2tnaXR5L3VlTkU5V0dvdW5ESFlCaE5V?=
 =?utf-8?B?S2gxTlZ2MDlkNDNub1F2c3ZkSmN5bjBsZkhWNFB2ZHNwSUZYWnNyTGVsa0Jw?=
 =?utf-8?B?bTQ0bDBGT0ZPUWF5ZUpzeTQ0MnZ2UTdxVHNmeWNFOGdJL3Q1K3VaUHJveGlk?=
 =?utf-8?B?V3pmRmZ6RDJIeVpoWk5aeFBRbHhuMWlaWExDQWJubVBMY1RiWVp6cytYU3d5?=
 =?utf-8?B?TjFRcFdkaE1uT0hudVI2NFAwZ1ZXdVJwM2J1RGhjTEJoN0lzUTQzaks3UTdi?=
 =?utf-8?B?a3pZdkNQaW8yVnFmb1dGRkNmS2RRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2a29618-4d56-4c83-7683-08db55df98dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 07:31:43.6547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+TVER6EjSTuJO+7zCGXyHvrjKa003vlqPLQ4SAPL0RTY+7fSaVAMUqQVAZ5hIJpk075hZbLSoDdsCsTtxDKXiKO9SNaBspTLT/RLjBGJe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6477
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:27:06PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> this series convers the drivers below drivers/net/can to the
> .remove_new() callback of struct platform_driver(). The motivation is to
> make the remove callback less prone for errors and wrong assumptions.
> See commit 5c5a7680e67b ("platform: Provide a remove callback that
> returns no value") for a more detailed rationale.
> 
> All drivers already returned zero unconditionally in their
> .remove() callback, so converting them to .remove_new() is trivial.

Hi Uwe,

I like these changes and they all look good to me.
However, I have a question, perhaps more directed at the netdev
maintainers than yourself.

In principle patch-sets for netdev should not include more than 15 patches.
It's unclear to me if, on the basis of that, this patchset should
be split up. Or if, f.e. given the simple nature of the patches,
an exception applies in this case. Or something else.

I have no fixed opinion on this.
But I feel that the question should be asked.

Link: https://kernel.org/doc/html/v6.1/process/maintainer-netdev.html

...

