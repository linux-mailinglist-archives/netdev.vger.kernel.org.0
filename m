Return-Path: <netdev+bounces-2915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F49B704816
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ED581C20D8F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0404D2C729;
	Tue, 16 May 2023 08:45:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4681C26
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:45:48 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2105.outbound.protection.outlook.com [40.107.102.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A279B19BD;
	Tue, 16 May 2023 01:45:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhOw/PQZZUSysV5iRzLxda8LQQ8MDGSE1jxL+bFY7wqvf1VMNMQyZeWyCL83w5V3XyVOk7V6j0ECAT8nFbz65099gwjJJrISflZ+FJxTrG3sh4cZ6IHSXas7l2EQc+s9UogIF8zRY4sUgBDy0O8SRgC8aU6vRQpCxOjdS6PqbmJyOIQ95X6iA6klapC4aVfKLMo9xNJ+qnLhB+x/mOnvyI+qd+ja9LnMuzEFixEAfQ3EMOJ5kAVwwOOi5SCqK0P4FqxJ9On4XYgYBpw3M6MdaYBj4YFY7+0o+wXPV1GHwcx5GK5fAiyz6VzMlMUffMYn5AVkqZWwO7/EJCp+8U0Avg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR14ocwXPtaPTJc4AkWm6SBSYR0Zcs42MayMTcyI+co=;
 b=SMHscPZN6G4J04DT9UBIhithpE0kp5UR2ZXMlWZ/0f//FmwtA+8Xebxw940yG7T8pY/yioGPQT/jE1WlixT1D08tq4uFXPAL66Q7eeR4FkskOQ5T8V51ATszhPquX4TpB0FOm8JdVZQBLLH++acyOVd8dHipYDSPTLUo/DSYHM1MLMhz6o6HEtKLfH3T0qGyFlEhNXFZr8pEKRj9eFJOdKtLV/RVgewW5AWyY7XtPJNCBItvfMK+JcxrlOSSFyPkelk6hIcx1jdehBJ+d9P3ms2+N+UnegAcF6tUOEbXBLCIdYX1d+8kkSuddPd/laQlohfTKJNuuQfOJLn3WWqHdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR14ocwXPtaPTJc4AkWm6SBSYR0Zcs42MayMTcyI+co=;
 b=Oogur31GjPJvJAqI44141QX9VP8PKArik9TuzSoIiAKyS9+RUbLvnXv9akL/C4npbGBfPZHBuqHhWyIPbB+2EG2ayskAM3BZRVs8pxezDF9wWa7XzTdh80gEp6e0B+NcF2azDWO9KxD4M1OmGdnixiACs884MXTH6EA6vCG36ho=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6071.namprd13.prod.outlook.com (2603:10b6:a03:4f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 08:45:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:45:44 +0000
Date: Tue, 16 May 2023 10:45:23 +0200
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
Message-ID: <ZGNCoz+Dos/niRlx@corigine.com>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
 <ZGMxOB6iVj39vM6U@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZGMxOB6iVj39vM6U@corigine.com>
X-ClientProxiedBy: AM4PR0902CA0006.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: c023cfee-781d-49ed-9d82-08db55e9efb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GJUsUkFT/POhH2E9vFUIWnYPmqBNjbf07ENpsVvATHOqTnN/KFvsP4fgOh75lj9SpxF2cwV4THEl+3CN6UUiAGJDjzacQZ4pZBnCw8zbRSeSZijC/zAkoq7h3DNtPViuA4NE3eSWjinW+RhM6gYl7hmIhlPm7mDai1qqGBoKG1rZ3goexwe+YZltmKqqpqT8YklZOeXyYCPqFaM/8caX9MYEfRJ1kOdf42puS5aiYl2nCcS4zm8kZOVADiqlcefaxPmcoC5WotWY/FndZDWmjXU+uYlIvALcw0OaGNjLwdrnVpd3gajwxDq1ekAVErT5nqNJoIULa/wIXnJhnPmigbpw0SN5Dgjc5VeNlzIuN5YUDDhVvJ18TRZnspjbxmMbjFeXgtzixTaEflPQagb4cwrl7bP7MptBN0/Usw4Upg4QO4EP9UYY2lPB038qfvezLcTufh04wvWyUvWLGSkZj/UO8PoksOq43/10VlR+fgPpjPb6gstXXhzhu+MxezfAczVOuwQnlCt7GC+5RoHN0FPP3QelQWHvBNNXTaLXrqPYWwZPPisz5LzAeCRXEZKvDqBnKk8/k23nqP2OGDaEicwXVygD/6sAhi6BQ4Vfyx4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(366004)(396003)(39840400004)(451199021)(6916009)(2616005)(66476007)(966005)(2906002)(6666004)(6486002)(66556008)(66946007)(478600001)(54906003)(316002)(8936002)(8676002)(44832011)(7406005)(6512007)(7416002)(41300700001)(186003)(5660300002)(4326008)(6506007)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0Rzay9VaFIxdm9aMi80UkRXK3E2Ykl3aUNGSVk0c3IwMk02eXNTOVJwRVJ3?=
 =?utf-8?B?ZVZYcjZKR3BvdUxTVDNrR0YzamJhVGV0TlpCaHRPWTU2UTZOV0kxcjhXcnVP?=
 =?utf-8?B?NkVQdWxqNTBrVm4xMUJndkhobUZjdWRyUzREQ2pCRkpId3pmMHR1S2FLRGR1?=
 =?utf-8?B?VjkwQnV5Nkx3QzNoRi9hMkY0NVdMS3gyMkFQSGZSS1g1VCtsK1NKNncweHJu?=
 =?utf-8?B?SldiQ2hrZXNHOVZrbEF4bklQdU1ndnhmblpaY1A1TGNvbEZxdjg4Zi9XZVli?=
 =?utf-8?B?bDVHTWVEQ2tib0FqdzhpcmZzaUF0ZHZzbXRJL2ROVW5RLzNIdmwvZ3ZsQzd5?=
 =?utf-8?B?aWY0NWloNDZzNlhUcDc4YWZLV0NVdStZVXp6dHJwY2JuL0VJMVdDRXVjS1Ay?=
 =?utf-8?B?S0ZaZzNTMEozY3RIOUtVKzJMNEkxZWlQampDVnpBbnFMcXI4Qmk2SkJQbTJL?=
 =?utf-8?B?eXNHanBYUjNaaFJ5Z0UxT21keW1XUHFUTUZXTlBZbGw4VU9SN3Zmb3RIQU5m?=
 =?utf-8?B?dVNPbjg0WHE2M0s2eTFLcW5ESHRpYlM0TSt5R2JISjhybENqVldIclVEUjNs?=
 =?utf-8?B?R0tyN3oveGUrTktPWU5kV2dlTjh3R2Y0UXp6MEIrQXM2aFlYVEh0cXF3K3RT?=
 =?utf-8?B?M1A0YUFGRjl6TlJhRXV0Q2JySXR5SG5vY0FNM2YvVHU4bkowanpMUG9IamZk?=
 =?utf-8?B?cGNYMHZ6Z0srVmUyN0N1Q0hBUndTeitwTmNmT2hBaXZTVitmNE5Vb0VtRXlN?=
 =?utf-8?B?WDB4L3dJMVRkOE1tSWtlenhadTZ4QWR2ZUJNOWdNK3ovTWZQOFZicWZRbWcw?=
 =?utf-8?B?cklkSjFDdW9UNmdtZzVNVTVPV2VzT2U4eDhqdk03N2dMTUpaS0dmbTZGU3hM?=
 =?utf-8?B?OU9Hcmtha1hUQTNHL3R0dUlQNi9waEltekhOZk1yRzVxck5WVUhIaE51VFFz?=
 =?utf-8?B?S2JSMjBFQm0rQnFKVjJ5NHRCQmE1aTZLdU0vYURsd1c1MVVVZ1JlNEowQ3VF?=
 =?utf-8?B?djhXcnFRTWs0VkJvWUtGN1NGVVpJN3lMY1Z5UXY1cUIvRkNsR3E1UFZnc0dl?=
 =?utf-8?B?VVdqVzFBSmRTY2N0anJsSlV6TzNVUEJtenJLZjhWakpFVndLanJ1Tk9DV2hR?=
 =?utf-8?B?T1lmdFNQUVk1bVRqdGU4cGcrbkVXYVY5VmY1RlRBSzF3MER2aTRwb29BVG9F?=
 =?utf-8?B?cW9aR3dpR2wyTHBGaGdMN3U3QUJpTUJtM0VwNDloT2E5ZTB4ZU4xMEZLQjZS?=
 =?utf-8?B?WENVUnFNY01sUjUyMWVwOHM5dWlIYzlKakhLN2pQVTZOZHVMNzhNOTBzeVRB?=
 =?utf-8?B?cVliVDZyOXlSVW9YSk5hdDg0VUVqdGJTbUEvbjNxVEdTR3hra0MzSHV2dTJt?=
 =?utf-8?B?RWZaVXMzRGppbitXU2liRlZGRmt3cldUdmFNZDRtcm5GaERucWoyOEcxRmEw?=
 =?utf-8?B?STZ6OHpYeWRwbUpOdnpqVGlBK3BxWU83M3dyZ3JvMzI4NEhpMmRYUjVHaGlJ?=
 =?utf-8?B?NmV0MjZvSXQ4MkVxa0l0RGNXTUN0S2dNT0ZjT0ErOHBEUkpYU0xpZ1I2ZXBn?=
 =?utf-8?B?ZDgrTW1FSDB2dU5jTUZ1T24vVHY5Y3dxOEcyTFRYMTBhcGIzd3dCYzZwNjV4?=
 =?utf-8?B?cmkrZUkwYUtMNXhYeldIK0hHVkZIZnFvTXhpeHd3VER2VkpoaVU0ckdsTmRB?=
 =?utf-8?B?STFrNjRSUVVvSHVZOGp6NlZ4WFFHYitvTGwwKzV3eUdoeU5tTDBaWSt5UERk?=
 =?utf-8?B?Z1dZTEMzRG01VmZLaGNpbG1rbW1BQVlPZkQ5WjhWVThEdHhJbXVJeEJNNEdj?=
 =?utf-8?B?Mys5YjRPWFFaNzZUejZaa2NGdG5Pb29vb0U4d3paUzFmY2d0M1cxMHlBYUU0?=
 =?utf-8?B?UHFPSU9uWlA2clN5ZEsxcUxWMTVzeHZ5YXNIanAwYTE3eWZPTjV5ekpqS3Jq?=
 =?utf-8?B?MzByK05JczlNNkJhOTlMbjFFcGtxN01GekZ1TW8wQjFCaDNFdEFZeVhDZEtK?=
 =?utf-8?B?b1dwRWw4WXUvb28vZklhU0M0cDcxODZvWnJtMURoTGNhbFRaQmp0NDhQQlRx?=
 =?utf-8?B?Q3JpbnVFOEhKeFo2WUd4eUQwSUxlU3FCUmJRV1JBMmpzMFpnZjZVUTRwOHFv?=
 =?utf-8?B?WXRiWU00Y2x2dzlZSGlueE0zSE9zU0RSUjlDZkdwREZSOWpXQXhtNll6Y2Y4?=
 =?utf-8?B?WlJDSkVoMG1KU0hlRlJpMkpzandjM05hbVBSckZGTzM3dmJpTmZ5U1FWL2da?=
 =?utf-8?B?R0xlWHp1aTZSbHF2QzBBeXY0aUxnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c023cfee-781d-49ed-9d82-08db55e9efb8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:45:44.2350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aV5NzwCdklq8D+kmtRMM67TvgU51LZNIwcW/M5+k5WpB5tyZE9PwMgzU0X9UBX+V1+9HUJvcCNK1kmwp1jt++5FbbAANjd4dpPpGILUvb08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6071
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:31:04AM +0200, Simon Horman wrote:
> On Fri, May 12, 2023 at 11:27:06PM +0200, Uwe Kleine-König wrote:
> > Hello,
> > 
> > this series convers the drivers below drivers/net/can to the
> > .remove_new() callback of struct platform_driver(). The motivation is to
> > make the remove callback less prone for errors and wrong assumptions.
> > See commit 5c5a7680e67b ("platform: Provide a remove callback that
> > returns no value") for a more detailed rationale.
> > 
> > All drivers already returned zero unconditionally in their
> > .remove() callback, so converting them to .remove_new() is trivial.
> 
> Hi Uwe,
> 
> I like these changes and they all look good to me.
> However, I have a question, perhaps more directed at the netdev
> maintainers than yourself.
> 
> In principle patch-sets for netdev should not include more than 15 patches.
> It's unclear to me if, on the basis of that, this patchset should
> be split up. Or if, f.e. given the simple nature of the patches,
> an exception applies in this case. Or something else.
> 
> I have no fixed opinion on this.
> But I feel that the question should be asked.
> 
> Link: https://kernel.org/doc/html/v6.1/process/maintainer-netdev.html
> 
> ...

I now realise this series is for can.
Which I assume means the guidance above doesn't apply.

Sorry for the noise.

