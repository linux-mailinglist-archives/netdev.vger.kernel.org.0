Return-Path: <netdev+bounces-1948-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6499F6FFB57
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B4D41C2109E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD72947B;
	Thu, 11 May 2023 20:35:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2FB8F56
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:35:45 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C3976BD
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:35:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XktOtDD2QpYSL9xEui79yq2fgrXVnn7CaN+9X4JvzAh8Fw+7mYBE0WtdRPvqz3zK3Hq2qyvx6PZ0kznzAKDw0ZVuSMusi3FmhCFXrbUq80Zwb3JzDV+TvVFLw6obaEmre00wS53aWeZ0t1sVo9zts2wpZ6ATVwqClCB3FGvvE22SjbOzzTrvN3bnjlvOTJSwmvxQRnMyF7+kb3A0B+HUTtjJPV8Kv5WzLV7aPxzLm+V7euDPnkM5fT+K35DGzL8tq0H6t9VxlXcF9c89+gmewoBHmhIDaekunWp48U3+eD+p5t80OHCnXeax/LiAuNJ168TEU+TMeBF07l3/uiEvZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BmS70tCb5gEhloC3gnW/DbXf7q3CLYPpChyVOeDw9ao=;
 b=YBHZ3izHl/s+fX6WY5Z+wMfew2u98FlR2b4Atd6qYm7knoNq9BkKI1CU9yCRgI5BXciT5xpI9i1wkKoaRC3fJ/juVb6U4jpv8k4j78S6drxweJ3kAg7FICdzUr5hS1uFgpd18yRJTQ/c/xlo2RUT65CXggjxufgVRqcR4nLuuPQ+PycdyeoSPtSXVlU9VwlflcF62vPl9xJh7CDngGdCbHo02Gpq79kE8Q7lk7EPF2YSDV0YKo+akq6CODmo8P4Pc7iANLwNGSPuLaVvuXar5m+mmKPo7zJUJjcTipu9u/MDDwfyeRpZmKXWo5M9slIZBv8aVxNoBTs7undpfby8vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BmS70tCb5gEhloC3gnW/DbXf7q3CLYPpChyVOeDw9ao=;
 b=sJZeSGgslWSGGj6StP0f9U8bzTy4pOa213bQVdMe6sAt7QPd8Lb4s8SXO6NYSYVOruwu2lhYoUFMxYzavqrpEf6Ywu0djGvM8RXmyczdMvi0aPtAZCED6S4iGixpN7yDV4lmV9tJVhJn4+2Ird6m6Gw2w6/LNZdH1DXUPy48MWHJdRXyBbTX28lI7Kx0sfSsDpt4SjeGaP9JohCrWGmdYKKYnEJ+McPNijMxpKWw+m9fIXUAqsoBzCfeN9P3CmS2nIBsvTJ+rxvjQERLFirK2nQ3+zzUjWGNK3pgWBkp+T+a11m9jPTPN6+J3qigHhVp5Kfz28+ATnc8LD6M+otfyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by IA1PR12MB7664.namprd12.prod.outlook.com (2603:10b6:208:423::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.37; Thu, 11 May
 2023 20:35:40 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Thu, 11 May 2023
 20:35:40 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org,  Saeed Mahameed <saeed@kernel.org>,  Gal
 Pressman <gal@nvidia.com>,  Tariq Toukan <tariqt@nvidia.com>,  "David S.
 Miller" <davem@davemloft.net>,  Jakub Kicinski <kuba@kernel.org>,  Richard
 Cochran <richardcochran@gmail.com>,  Jacob Keller
 <jacob.e.keller@intel.com>,  Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-next 9/9] ptp: ocp: Add .getmaxphase ptp_clock_info
 callback
In-Reply-To: <e479b601-a242-8ef2-ade4-3fe477a196fc@linux.dev> (Vadim
	Fedorenko's message of "Thu, 11 May 2023 12:12:20 +0100")
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
	<20230510205306.136766-10-rrameshbabu@nvidia.com>
	<e479b601-a242-8ef2-ade4-3fe477a196fc@linux.dev>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Date: Thu, 11 May 2023 13:35:21 -0700
Message-ID: <87jzxezjw6.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|IA1PR12MB7664:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ad4d5d-749f-48cf-e4d5-08db525f48da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eER0MQHJtrjRL2Pe7H9FgMu1xEngfZg0MQFYywom2aIhmnQ2Vg/mXxRddfTYUhU1E42O/EjNC5X92jddz5B3Go8Giq1CxXtEUqXjjx3sO/RJZDW0/ITCDFzc57vw374DJB4oxf1RAo+LR3RMHLTky0xSA7Y7LJqDuFrfBJpajS4q8uv3+WDt+WepWA6GJo4MQs6y8mVftyWKSHRRM0xMc7BCdKLjkCRCk8jyRKylnpSWgekLoTgrr5ivukL20ieTMTF7yWQxr5PhQqxkLVdRqYMWUt1puj8W/nc68GIH21X2YvHClPbMoOPS598dtnEkSYawLYpoW4K9aHtHNjtLXPcXAMrPD8N2L0puG7bGKHCZCvjYEhzJjIECEkwn+xeJ4yLoHpo0KIMIlH6kJPoK7g2WUBCREit0b9jvWZXZlrDmZafXiPV3zWfLX6LHUpf6AVggcC9WThpsS4gisTMc0QRCdWADhAkJCZJ7jvMgxEDGJsDBZr5qwglt2QalSWVh2H7sQmuFpt7UqVNhFgNRwsL+LYF8sblDhQKSXpkDB7cz9VTQ3GYuJzumcDbKMLlatn/Jwhqa1vEcVGGu558jF/ElTsOaf/wLfxUW4Vx0tWg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199021)(316002)(6512007)(6506007)(26005)(53546011)(41300700001)(6916009)(66556008)(66476007)(4326008)(54906003)(478600001)(66946007)(6486002)(6666004)(8936002)(8676002)(5660300002)(86362001)(2616005)(4744005)(2906002)(83380400001)(38100700002)(186003)(36756003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uazH8yuky19INjWifXxOtuskU0rm5tSznH2hTwOOUzq4xcR6eH9FJF4r773s?=
 =?us-ascii?Q?1WSjuDtctMtnbGqZz2K565AFuXwGEPYXzmWnEe3isGwa56Hc/UfP/LmzpL/3?=
 =?us-ascii?Q?GM6avGuFA3BEt7A0AlcQAaZoAQ5QtV9O8V0pDXe6XqsbH/6foaX6Utnhw3LP?=
 =?us-ascii?Q?vMDMHYzQevw7ukZZOJSBa2/hDdDIV4R5mi5Mz5b9FxcuCfEhYtFNr7e63w1+?=
 =?us-ascii?Q?0nQEYXHwe4wGwmTVSUBLv+gV9+ZXvst8T8c8OxwNteibyeOVhYqDz4kBI1/F?=
 =?us-ascii?Q?lElLPXaKXDBLsB+kjLY/0bcjFPz0QSpof9VcItDRiHxsG26O8CG15yWCB1AC?=
 =?us-ascii?Q?fQV7xbNhopEi9P+7pMkv26JPqJotXU90oA2menHRPYAA/QxIFrENazN9ySNp?=
 =?us-ascii?Q?fqoY7Wz4gmDLeWnoopW/SXDVtfW4Abkq4qPfbd40JasWyitd9AsUZSi/oynS?=
 =?us-ascii?Q?r0zSPrA9Er3EnbtiprtwKOttF6tiinKQWqYbRKcHROBPQjv57k2fT7OjjPgF?=
 =?us-ascii?Q?+925wK9Hf4sxnnF2buYpV8APiX4HreycT4Y3O9QMn2GM0PWTIxKT9CKqSCI6?=
 =?us-ascii?Q?dM56VCVaVo0UkxZlkEUS0Q4tjM0rH69R+11S96xyVv6sIt5LFkET0ByPvmTE?=
 =?us-ascii?Q?aRQNt2Po4EtAKjxU/jcVLYN02WkKnDJKXPD3+vkFIFG9jJe0HHgxZUMVHayj?=
 =?us-ascii?Q?7k+uVUUAJ24wmOyQIseavenjLNPWt917oBUODE/wUbOnUTXbAbMcE3MCSlVC?=
 =?us-ascii?Q?Zhqdq47naU3hnFj0kzjygYL0MiM3YRy2b/X/subxE6lm4YOsX6q3wzaRpSQo?=
 =?us-ascii?Q?7uMxubTJj82Y3WBCRlWvoLRvN7LtwsNWWj9TjBbDbkS6O5IzHJyEv2C/zMc8?=
 =?us-ascii?Q?jtrfO6asTTfgB41poCE8FNg8TBrykLlcBFVb/co3nuJCjf0eHmqfdgDiCxmp?=
 =?us-ascii?Q?5SaJv3bzVsIJuNUfksI4EWu8TwqCe4YIjM2cQ1iZdumE9lYLpd3ZtdzoNnkk?=
 =?us-ascii?Q?CitTR5NFZy/m+8+k0vYxguU9W7QAEOPqHD6A5GCb9YYgDaTxJ/O7ei93E7+m?=
 =?us-ascii?Q?ow4Ai2Ze335jRZkpGvVgSd8a51sjl/SMe02hdnjUAcmRgh4GM7kZ5AS8grEQ?=
 =?us-ascii?Q?YqH/Wd4osM8uP3qIpWeK4wRniODkbfdjK8LaERY+C+eFgBCEkTKhF+a04QFZ?=
 =?us-ascii?Q?lCBacYvUy/Yo31JKwQEkn/DdNLqaTZiei6J+djXg/gaPDYcm5l5plWMAIqA9?=
 =?us-ascii?Q?eGo12WU4A95BRZKHP5eNKh8/gVsiYp3ZIZUedulPTwBvafR2dOyOR3njksno?=
 =?us-ascii?Q?mb9fXS6XCK/7Iat6BnUwiyLLSPs1wCWJF8zQF7/NCTpVF9QG/nqizneNUTs5?=
 =?us-ascii?Q?xPSmP8ySBayNAJZKs6yMy9TJ+bjkCZ4G1ML6QEZJi+QBKCpkGXpnpUkkNKcd?=
 =?us-ascii?Q?o/CM9mHnNNfIKq18331bbp1TxetMiBRn72/CVfyFIh9vh9t1MNclvICqTiIf?=
 =?us-ascii?Q?V3zRS+6+IFMCddGGJESbg4+qybq4sL50ZSlrvs82LBqiJZS0+dfyXugw2oV0?=
 =?us-ascii?Q?9rPTGWNqmzq9y6thkUvuo/b6XSbGzRFQ1S+leGtdPk5FqwXSL9gHVSVrUfIn?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ad4d5d-749f-48cf-e4d5-08db525f48da
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 20:35:40.3075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UVEKP09eudybegrV1SnbnELMDluaKiKFUhyv9RyjY3ifZg7fySpks/os5Ztgbxjf/L/5gHXtt5/qaKsR6G+nuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7664
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 11 May, 2023 12:12:20 +0100 Vadim Fedorenko <vadim.fedorenko@linux.dev> wrote:
> On 10/05/2023 21:53, Rahul Rameshbabu wrote:
>> Add a function that advertises a maximum offset of zero supported by
>> ptp_clock_info .adjphase in the OCP null ptp implementation.
>>
>> Cc: Richard Cochran <richardcochran@gmail.com> > Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> Neither Jonathan, nor myself are in the actual Cc list.
>

Accidentally had --suppress-cc in the invocation when this patch series
was sent and figured it would not be worth a RESEND since a v2 would
likely be needed. Will check that the v2 properly has the needed CCs for
each patch in the series.

-- Rahul Rameshbabu

