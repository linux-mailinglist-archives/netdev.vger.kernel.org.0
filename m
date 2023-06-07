Return-Path: <netdev+bounces-8889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB74672630C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1575B2802A9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F35415485;
	Wed,  7 Jun 2023 14:39:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9D78C1D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:39:23 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A1819BA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:39:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWu+oaxDlqYGuLHQ/A9iNS5McE/k149/gV7FHJB4Hwk7ehO2J/rf/sbw6l4VF74kx2mtpAxc97W7jm0xGMdtmswKJSLB9m6DZWnr/7JBR5eXKkPx0b+vubyWIua4G1SIQJ5wznCnYjd8gao+H55I6UT1c+/CztzP2p5syTrZ41XcbEUkzZA5uUEl7ajHt5Id+IuRwtgHCQZDip9E1Sglln9ZFnglSWCotbcj0k72ma1OtwnRQpIGHyMKMso16hlm/tTkvI0+7P/9ZkpWhCFtZjvrACarEEVq+rSUv/EErt6esWyGb04i4m/Oo9gfqSbJLpBNJtDScYR6jvMdFfVrWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9jpU0SXHWB/ZY0g3mgSrDZ+DB6ngd4XN/SQnaXytdCM=;
 b=BsjCctwMQCtdTYPGNeie36Pf5IcdB7Y+Ua/O5YA9DB5oSAvnO5O5+TdI/g/+NFBVyyPFoSzEiZw2BfbCXzPJpYnDB8LHhVBBgS140sxzDhRdIWGWByqKZh5G0gjWQPm9/aTubpnmE0p4rN66UPWVaFVdnQb9GaSnkBKhP011tbiWGCZFtfUoFr8laYgNnT2XghXR9wAO58wgYmFISRSgg1+25kaR13mHUB4MGJ0t2gts/+gxYUa6St5yaxS4LybJPYtZ+EC9+9FMRxffgiEPeZdb7uMYo3VO3EbaECEBrk1hpxjb2sapZBa0GBBnjiLV0onHQAMl0Tqew7v9PfsGzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jpU0SXHWB/ZY0g3mgSrDZ+DB6ngd4XN/SQnaXytdCM=;
 b=Gi2k7z40Iy2d5Z95l3WyLBjuSaA81VSDXvUHbPVpQX9p1BSIml/wUG+Ax/hmPtmjQz/UMW7AyQJqMjhxZ4l0dnCWfhXuBaTFL4VzbSnQa9VlwO3SPxBgLMDpnzYdJ5hohB685kE1CQ+KJLuJzp2f0RB8jnYumxsNhAXbmBcYQF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by PH0PR13MB5330.namprd13.prod.outlook.com (2603:10b6:510:f9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 14:39:19 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 14:39:19 +0000
Date: Wed, 7 Jun 2023 16:39:11 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Wei Fang <wei.fang@nxp.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rob Herring <robh@kernel.org>, Shenwei Wang <shenwei.wang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
	kernel@pengutronix.de, Michal Kubiak <michal.kubiak@intel.com>
Subject: Re: [PATCH net-next v2 3/8] net: fec: Convert to platform remove
 callback returning void
Message-ID: <ZICWj93C3XgkPilG@corigine.com>
References: <20230606162829.166226-1-u.kleine-koenig@pengutronix.de>
 <20230606162829.166226-4-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606162829.166226-4-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM3PR05CA0112.eurprd05.prod.outlook.com
 (2603:10a6:207:2::14) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|PH0PR13MB5330:EE_
X-MS-Office365-Filtering-Correlation-Id: 43fb9696-55fc-42ac-5be8-08db6764f9f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2kL31xdgOXN1M93Sceho9/1GCMYp889/Jvpc28hatiJvXcSMyQwrHnJP7azAjMcCgVLpvISyaBn/3KZTjWAy5nybszlBFnwCmjE6T+IxwrKEikirAYl3E3qLCSTKmpndagruJQBx5Pap5XI0cXZ3IBq0/wfeq2mXmEEbQo9wbAtaTCS/pI5KHljiqiAsIye3zHedLQwe/v47I/9Fyd9MAcbFP8viWyIW92c4lCBa+7ZOkBM1cWmUgQX1acAD2qmJwrarWuRieXwqVFNzMM6XCvY5DmWnYUTdBV/gH/GSW1bXbkU4D6n8kNPgS9LqXdiMZXjD/cSx3h5yQEiGTZd50RowdAyrF9JcnchLr/oNoa8KZP5bcjMybADpKE958gTtRTSU80gHL+IFsmPS5DocMQFWz0LzCx5oPI5owGlglc9jg+7VmECb2YgLzlcjr87+3RFYBL2r8K5FviLtsiHg3KIxvAvE2+HLsxAP0vSYIa3t3Oe58cKkQ5jy9B/m8cV7PVkEv2yXxsA1Ktxs3cm5RFrf3lrOii2uCPoL6kRi+/unIw/9Iu48dZShqTtcpNOOXxCn/wwDEHBqrOefVc3D7l24xAEX/Qjp4UdBC6B+UK4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(39840400004)(346002)(396003)(451199021)(38100700002)(6512007)(6506007)(36756003)(86362001)(2616005)(186003)(54906003)(5660300002)(7416002)(44832011)(2906002)(4744005)(316002)(478600001)(41300700001)(8936002)(66946007)(6916009)(66476007)(66556008)(8676002)(4326008)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFppSTlTb3dxM09LdE9JcjFjczVQSTU4a2l3dVIwbFV0NGw1WW9KUGlyNmZS?=
 =?utf-8?B?Z0FETGE0cHo4SWNGN3VFcHlaSW1ZOTZXQ3hya3RTOTQrTWgzNmZRQWpuTDh0?=
 =?utf-8?B?dU9mVi9jNFJaMGZtemFDOWhRbEorRDdYVzZmU3hlNlZxQzRNZGlKUkliSndE?=
 =?utf-8?B?NTRhajNiYUR3dC9NN21wYnBySW9xUUE1VGludWlrUVFUZ0RWcEtwejJwU1Nl?=
 =?utf-8?B?Y0dYVVRnTmZ3cVJKd1pnWXI3K05MNWpJcWlKcFN4eHgzK25BVjY2VmNHYk5s?=
 =?utf-8?B?MjVBa2NRNXhycWZHbFV3VEptZmhuWVBlbFora0JsUHVsdy9OTmYwejRpajZT?=
 =?utf-8?B?cGkvenZmTjUrc3d6SWlQZDhablFqUW1WSHEwZGQ0YURVNVZLa25NQ2FqOTFK?=
 =?utf-8?B?a29vaGg2WG42dmxtc3ZHNWN3NDJMN3lUZWt0cWRTbTBCTzV5TzhqdW5RVlc0?=
 =?utf-8?B?RmpMdTQ3TlJ3SzJIdGxuMFY5RmM0cXJTTXhjZ3NyNHA1Q0o0MDd0WFNycnlw?=
 =?utf-8?B?MGJWRks4YW9CakhTM1g2NEoycnRwb29NWmFrVXR5NnJSMldKR2k4QjdQbXA2?=
 =?utf-8?B?RlFDWVQ5N0k4bENEWVpLV1pUbWhRVHJ2S2lYTThtVjBkQTVsVEs5SFdkdnh2?=
 =?utf-8?B?cW9aYm1sUWo0dnR5U2lSdHUrTW9GOWMwQTcycjBvT2Z3eWh4elVFUklIdEZ6?=
 =?utf-8?B?WmZWelYwT0JSaGh6YmIvbk9NcnFUUzZBS0N0TGYzTWVia3FxaU1TWUtXRDla?=
 =?utf-8?B?dmFZSEVVMHhsUUxaUHlnYjl4UytndlNRREwzNlArTGJOMnY0b1V6b09vT0VO?=
 =?utf-8?B?djRBTFdDOVdMNldQNGxRdXBtdjF4RkNOb0pLUG9sUStNdHZtT0hUQ1JVeGhp?=
 =?utf-8?B?WC9RbGhjVmIwdVExMnErSzJlUFRkUUZOVWgxQVZXVzhLSlRwQTA0OGtlNVZa?=
 =?utf-8?B?VTIrd1BYV0g4WTRUOHlWbFV5bHFiS3dCR3MyVThwRXBTMUJxWGFhTzdMUHRG?=
 =?utf-8?B?TWpxa0VEbllpRHpnUldQZUthVU5nSHV1YS94dzM2WnY1Rk5wb2dlWU9UTEpq?=
 =?utf-8?B?UXh1MGIrb0Y0VzlwV2tlM3p2T2FYbmlBVlk1SzB5N2U5eWc4WU8ydERVaTg2?=
 =?utf-8?B?N2pYcHpoN1pTU3AzMTRtRmVreTRHcWFvVWcrRlRXVFBuTFNsZExPK3pKeUhL?=
 =?utf-8?B?ck9ZSkZHcEJvK2djNDhRRk5wYU9iOUU1NTBtd3BOTVlwOEcvZ0o4aXg3aVFC?=
 =?utf-8?B?a21RL3RqeUpRU3FkMUtRM2JSSTBqeW5PYU5NcnRscm1XR2ZybW1ub1d5b3Bo?=
 =?utf-8?B?anVYUit1SmJBM294WjRqekJkL0ZIbHdEbXBMbmg1ell6K3Y5M0lnR2JSSHAr?=
 =?utf-8?B?K3dmTlRvTk14eklrYnlucThIWkl5bGdjK2FKd284TzA0WWtWaU5mK09mYmZw?=
 =?utf-8?B?YXluTEFrUTdqWEpJTEpXUzB0ZU9YSTN6OEhsZzhvd09iZzZ4U3R3azBKRGJJ?=
 =?utf-8?B?c3M2Zm5QSmhrMUd0UzVTZHV4TDI2MU82T1VoUDZSREtweFprZ29DVlNDWWg4?=
 =?utf-8?B?NDhTVEtmcWZMNGRKK0J1bWNjN09kZjFISm1LRU1VaEFJMzM2d3FjM1dram9W?=
 =?utf-8?B?aXlPejJ2RTNBbEpXWU95enN0bUVYd21xaW1UOGFvems5SnhwaTVYRkU3Vzc5?=
 =?utf-8?B?ekc4VS83L0hyUWNXRjJuMGVKdGdyaXp4Q0VGZE0yVUI2cWVvaDlBSnFCS0Yx?=
 =?utf-8?B?Z096NmJHRTVzWEZINkY0RzdXeFJDZWZRMkRxTTluRkVuSXlVZ25OY1FYck9Y?=
 =?utf-8?B?ekZyWlhwN29ZT2JUK0xnZ3JaN29GT1hPUGJJNmI3b1Y4ZmRyb1lsSHZ6Wk1B?=
 =?utf-8?B?QkdHRTNFdG1QdFNhelBkQWRoeTI0VFJJWkZDQXUvV1Q5Y2dIWXJMQlJ3emRF?=
 =?utf-8?B?dmkwMlVvVlR4Y3djRC9JZzM1NnNUb3ZwK004b05TeFNWNWFSenNwQTVMc0JN?=
 =?utf-8?B?cS9ONnovNXJPcUNBM0NUTldNTktTWVZTRGJTQk9CNTRETUJPQ1VBbU1FZ2xD?=
 =?utf-8?B?dWxFeGRISHE0bVNINUh1Z25NckZRRHFFci9nb2hBM1IrUG1mTnlGY20wU3pL?=
 =?utf-8?B?WFpsTEpyZFltSTZPVXh0QVRud0ZhNEJvczcxdDREYk5zOEt0NkpXdFZlZWF1?=
 =?utf-8?B?bWdwb09WS1cwZ3gvSXByMVIxQm5CbllVRk5uK05LUGNTYjVNRmQ2K3FDQkxw?=
 =?utf-8?B?c1paTlV0UUxVa2hGSkdOaW9ZNERRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43fb9696-55fc-42ac-5be8-08db6764f9f6
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 14:39:19.3081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvCqJr2oz4529aXxUIl8XeEYwjUi/maj+LCURfjLS1yupq/LLV7tVFPANVaVZDZ1ySYwlXGdfoeQVU1LYA/cEb+lMbKfqeF3Z/4FIU11nAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5330
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:28:24PM +0200, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


