Return-Path: <netdev+bounces-6267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2539471573D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBD231C20B5F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266AA125B4;
	Tue, 30 May 2023 07:42:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C0E9462
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:42:03 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2139.outbound.protection.outlook.com [40.107.93.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44BF194;
	Tue, 30 May 2023 00:41:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JT1ALr3iIEGjuUXBkRqUMecergNdq30b5Ohvn4Sid2yO8vI47yqKrcAFkJ/frnyxCwj0BPn/AIwx03iqUWeUoH61Vio0blyR4cx4kiunyeTX0tn4uakb74RGqdxcC2juPT/yHLdCWrHD5yIBNM8hLJtrmODz85FmDFSFbrCpad3pSHaeAAoyWYO2q1NPldJ5ZyMF2jdL5UGFzNq6/JCeVSizk451wUurNDGJ950kth5xd7O05KT09KFT+ldNi4Vod7UIaOymmLDXIrdBPsuSzBMq9bKaqYdXObUh+YiK3tKnQb47+88308BM7Ooj4UY+b31LS50lkIaVh+pug2+vrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVjoYcrx7Ob7TJ2+VZX9NMRWLhuwz0eh/1nqs5R5FSo=;
 b=mvdM/qe06C5EFejn0ZgkPfM19SpAnvM/7ssuuSUXcLeoin0Gpp8g0Ri8SNKrAiHXYhLrFq2ntxiBa2bzvar4W7Wdm2yIYNqUzauHfV93XiiT1PQ1gvuJ5udx+hbMLfXk3AkatI3/XzT1sTg+djanflPrD71VkVgpNfZTSI7YFmT9f7B6ScE5VwKmdH/pKqjMWZ1tts/RUXpLhdfDBSmnqqOjKysMqgMt3BRp6RQuKjafM4G3qWv5OUFUV1R6QW8mFxsi9NB5xxORYmepZ/F/aMQomMxBxhqoEj/lybGCJ9QvY6P6B50DuHwMZqbq4ZAQz/OLblfRhgT94FcoQQ4ROA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVjoYcrx7Ob7TJ2+VZX9NMRWLhuwz0eh/1nqs5R5FSo=;
 b=CHMLu2YJ91iv5jaHB2TH71F9QB2IG0b9iccxF2y4mz157OAv2fBzIH9qY5ZAZ/+7a1LYh7z5YHmPhvDMBhoLejqnDcr8scpbN3QnLK0lN65vm9LPUfllihIhB/76rjuYu2nmBhpMWBVBCaogwESyvQi9FtBqK+sRQFFqtug7auo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB6046.namprd13.prod.outlook.com (2603:10b6:303:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 07:39:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:39:14 +0000
Date: Tue, 30 May 2023 09:39:07 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-wireless@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Jilin Yuan <yuanjilin@cdjrlc.com>,
	Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: rsi: Do not set MMC_PM_KEEP_POWER in shutdown
Message-ID: <ZHWoG/13NBr3G4jp@corigine.com>
References: <20230527222859.273768-1-marex@denx.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527222859.273768-1-marex@denx.de>
X-ClientProxiedBy: AS4P251CA0027.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: c965e6c6-9dce-46be-5ed1-08db60e0f72e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	E9vxvw3hyhTW7DldXWFiUQ6DqOLEXDkrD+L0haqyxRNcKnT1WtaJo9kJRDLeKsZ7eDDsuZclNJBLa51VUm0zgpcGZvpmSYrFLsLhy7hHaKlRBTQ/bo+y4W+ATHTCqqEhGSqrd8Qn2/HI9D0IoQEEXWNfl8IvMiJkp4uMAsqDKjooDxoO74ynXk6WZp8YG+0X1StXOndhhHSgkxK2fwlDBFsYdxouOK1EU/GkMe6Gftxkkmb3pthXK9owwJIcfvTIoG0PmiLqROPFPZ5Yp6frdXSqfu5WbEr89bCR9GkC791mGHJ/aYPY7Sx4bBErRb+7qmbtFeptWdh05O/meiuTaYV56XjyqDqnAXlW++eSztoa/p7OciF4mllXqx0il4a0PzlmhVkypGdmeiUBOHa+29q0HidPNbiCwXrzd5E5u+WZruFFYphc5v2Dgw3hXxneDIWccSYprokuN/rGJZyzZERW8aQ1Bc4eKwk9TfR60dM5H+iuZojoLRZiSkRvjk0RZ4YB/iAEPgobzlmuTglcA/oooF2y+5klRi7PwoGjsb3qOZjMmA0CdRoHb4d0w7Ul
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(376002)(136003)(346002)(451199021)(6512007)(6506007)(4744005)(186003)(2616005)(2906002)(54906003)(478600001)(44832011)(83380400001)(8676002)(38100700002)(41300700001)(8936002)(6486002)(6666004)(66946007)(5660300002)(66476007)(66556008)(316002)(86362001)(36756003)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SD5oxesgE8czUFk+kqtH9X2JAresA9x9iso6bG/t5y5hVVnY1KOxalJ8adfl?=
 =?us-ascii?Q?gUes+oRzOhExTIjcP+hE37MUKvX/2u3RsIQkriygSxgZ3i6+ytAHKuf/+7x2?=
 =?us-ascii?Q?lgIsKszdDOhYtGafLqgoYOgvbM6c2R8LMYvZ4cVIerWr61kIXuO76BYJbUO8?=
 =?us-ascii?Q?hpWhxCKyuHVKGjzOWSoVtlostEnpEGx9LnomPlOMVbKa5OIvBKG/6z3daFYV?=
 =?us-ascii?Q?G0owcME+IJjxnDpCRyHKlYztgUIDPNJF50IA55TvnUYKJLKec1QU/Xkyp6P+?=
 =?us-ascii?Q?869JSEbyx8WYgL13UDYeeOF3GPjkT8MAj2EG9SNoTZub/QgAGcb7/ZSh787+?=
 =?us-ascii?Q?s6EmNNY/vKo2y3+nQzwi9ZwREpQmM++FK4vPt2aNAEP6ETaT7xvooK/1pPQM?=
 =?us-ascii?Q?ZKUkmIMW4q5DwSducJ9RbumzBV0IJE3qEcEG/AU77tqsrYK1n+rQ4cbHKlxz?=
 =?us-ascii?Q?c+K7MAuzpNN2amHZYjVhbp9yhOkSjTRdSOJi5DSwLGRzzUqUZtK3wGAd5psO?=
 =?us-ascii?Q?vdQbOQuBCDA5j1TE7Pu9Goyphoke2SNNM2GAkklLeDV1op2fKV/tWsF0mORB?=
 =?us-ascii?Q?P5fz91fyTBdgr59iVnalfdliL7r184uHjED9b2VBxkInbUH+/o3w4488lAN+?=
 =?us-ascii?Q?FGNsw1j932llnJAspj7BV+9hSg7BHa+Zx5ybE/AvdOs3Aseor6Ct2ZyFDA09?=
 =?us-ascii?Q?gFlFjF7CoyKyLkL7osQglc864qsgdSwPvzDFfJ1F3atHN0673BO166JyMqLi?=
 =?us-ascii?Q?QT8VpMKt5lt3HNdRIDHFV/QR66DtVu+JpK75j/NKt0yMtmGf5OjdNpcxui82?=
 =?us-ascii?Q?Wu4G6wZM0CbHFI/klxE/6AFFIf92PAiXxxa+AA37kki8myBUEJmOBLIF1xPQ?=
 =?us-ascii?Q?l2wIQL/UYX+dYU3JdEPLxJS4Hs7ndW68GvW35iwSI0WWHz+mRh30uTfYGoV+?=
 =?us-ascii?Q?RORQe9Tn3466qnI8E4NngA5Gr0DvAGjh5xKFf/LXZJk71jMmu59w4a4BTB+J?=
 =?us-ascii?Q?ajKvTFgUTl7FZGThtxip9VIzWjdxHd9wC3BdTw9sQIidD7oSUpJlnCMEEscL?=
 =?us-ascii?Q?HEKVh7unLNchYNilLIPF5fsKWTjjx+kJByBevCYm1ZkQHqcE8juwvW3DrAtE?=
 =?us-ascii?Q?CRrG+xkgVhjyenNLUEcgW0FBmcfDDAdRI1ChM8lNNfC3/w8Mum8doXWVBkqS?=
 =?us-ascii?Q?P8ZhqEjobbhLacm609d7vzF37oKyJ2P0ct4fduR7/VXU2U9N1Hp0S/RE+Kbk?=
 =?us-ascii?Q?fKbVVg6BdSviQhF7uNUPnFn35Yj58NSZmdPP8siMinooVds3Gf+j/qa1/S5s?=
 =?us-ascii?Q?HQ1TEAsK9cECsHTgxUIevHuKE5/JRkXp5udXwAd2l+QiL3KENnwOWdLp1cbD?=
 =?us-ascii?Q?kndhIeTHqQDh6b1xroJLwtlt2TYwjl4+dI+0ygHMP9LetnAxX19iNRrxzUq0?=
 =?us-ascii?Q?oBmJD3+xo0K76YVIIjsTG/pijt6SgQs1j64qYzDtNRQhbq8V3NouJQe/7agX?=
 =?us-ascii?Q?5A68dl07cZMbs1CiWC2brLZ+Tf0JoOE6C/sFyPMhscJ4HWxPJXV5Eyxi0PnU?=
 =?us-ascii?Q?5tD4FjwLPVJXGAEmvSawusxc7HyzC0xfEv9tvIM08pWr2Ox/FivNDJxbDKCl?=
 =?us-ascii?Q?7ahdxPwFCL7LWidtneoCRGOEAexrUUjuBF9hkbe2D3QLjDAWKcAHgMyUNK+B?=
 =?us-ascii?Q?d4quIA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c965e6c6-9dce-46be-5ed1-08db60e0f72e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:39:14.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ujci6FjgOCr6fgIYgU8Xgdu5t+6c1d246pvjNeISqls624Mvx/Mkc8ufooI7TvZRixQmWBlO4YW3bP5sjQVRd78y7R7DTqY+O7F12TCec7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6046
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 12:28:59AM +0200, Marek Vasut wrote:
> It makes no sense to set MMC_PM_KEEP_POWER in shutdown. The flag
> indicates to the MMC subsystem to keep the slot powered on during
> suspend, but in shutdown the slot should actually be powered off.
> Drop this call.
> 
> Fixes: 063848c3e155 ("rsi: sdio: Add WOWLAN support for S5 shutdown state")
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


