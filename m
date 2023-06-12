Return-Path: <netdev+bounces-9991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CEB172B97D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5CE1C20AC5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354CADF55;
	Mon, 12 Jun 2023 07:59:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AEEFBE4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:59:49 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2133.outbound.protection.outlook.com [40.107.244.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE728E56
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:59:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKA/b7lNPEcuPpBX6Ckf1vS3ny1Rc1S/xhjsfUA6nAR44obOFobNwtJh9GXYSqyDVz4x71webK1i95sS6A6g6N33T7sB2GrpyOZXYY1Mz7Rk+T8v8ZOfIzvqDTwTj7Eo60yc86gl+P3xoVbOc9J4yqoGuoDVnVzq5koGmNj21bJ12ipWHxzEe13tYDSEZHi1MZqiUjWTQxfAhLBWZq0c0HdCvtSZfAbBLSvsm9lzKgkuY0OyhWKYVWyiSemKKSF8ZuVZt0pZs92z+iqlS6bLySYUkoL4OmQ2gMHH/lzTaThQbf/Cp0v1cF+kVtWJJEnD4vrUOKfVSQtVW8XqOjUpeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rS3HnCawVmgE/v6uVI0LpJe13on5JF8X1bx+EjmErR8=;
 b=kBxAor9PYVidKcZaxMMxMy9BGhnmZqb5y40T+8oMUNOBGiX9/U4IB7ecSRR46LqYT92umyI2kM+ml8xb3e0PoqWC3NaurgqshvCi3yFcsEIfBbKCQToWkqcGiSw3kfCESTPCnhOM9cOP0HLcI+gsyNzIRvAQasMgqloIgHMfgIlivfOi5Lsch+KDMLvln2BGOlbJGHRgIDWiW0NdDMiv7Wd8dqrFt+2QLjSRX18My/iPJ9c3jvZyc7RzFSszwrCJk8Qt1lvCuhPtRmyVXz5vMMLoYS4k7IHnhCVvdJncnNLD69LZuglD5HbFx6VL/1A/nQg2ZO8SZiBI9gdGXaPBtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS3HnCawVmgE/v6uVI0LpJe13on5JF8X1bx+EjmErR8=;
 b=BvG/tOYmhInL9c6W6zckkr1O9BF/aeLKZKNJBTi03l+VG76X/Za3hFKn5oDLsnir9kS9qAxHfxC2fygUcEScc9pHWM8ZGehLcfj27JfBZ3YRY3O/672wfUTl41nnZydETnAZA4vtVPa+ZCzAPm50B9tOYSFpwQRoZ6MP6hSVeJc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4490.namprd13.prod.outlook.com (2603:10b6:610:6a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 07:58:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 07:58:21 +0000
Date: Mon, 12 Jun 2023 09:58:14 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tristram.Ha@microchip.com
Cc: andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
	netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v1 net-next] net: phy: smsc: add WoL support to
 LAN8740/LAN8742 PHYs
Message-ID: <ZIbQFq8szLsaT5kB@corigine.com>
References: <1686274280-2994-1-git-send-email-Tristram.Ha@microchip.com>
 <ZIMYxaANiLvd0blQ@corigine.com>
 <BYAPR11MB3558494D2D38F58083233D80EC51A@BYAPR11MB3558.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR11MB3558494D2D38F58083233D80EC51A@BYAPR11MB3558.namprd11.prod.outlook.com>
X-ClientProxiedBy: AS4P191CA0026.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: 87f62a4b-773a-43c1-c364-08db6b1aca42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	p0Ak5Hp/oQ51SXBkstrHFnoWQorRRAVkQGD0JzyXXyVlgNS6DPpcY2kHcNecc50ToztTCEXh2z5J4S1wZrB7WN6qdb3jc3pn/Ks24rUzGKUx1xnBB7Tva+5F1AYwuL4QoNL5gzEK1XYoanKA7qzH+NWAoTPYBQA9W8gS7FXCMgELr+9g0YxuaZjfV2+WMWLiYmYhavzioZI3RiqM7FTknOPglJzd3Ah3lQ8D4a8EEspO+tUw6KZi9Irfqk07p8/+DDP9e25Qe7NnO+0y4n97Js1WMSkZhpF1aITiLc5NM+Lb00bki91po3hBmnWmUz5tcs8a/Ac3MIUvaLn3n3ip7qOprnJMdftpsPkIXR1k4iohZm32VGN4GYekvp9gSXPlQq7ubj1cldoxlQj44OgfIpF4ocaXzAUf9LpTrUAuxWqgHNOJU0x/eB5y3bnYvShMKWK6J1jw7QU0YuljnwPs9MK4gIrIrIJR7BVvdoh6w+/yJfva2vkDz/UkbA6PowlzgtGgr1wnJ5Z+FlXX6T899oqtYC84pQLsMKtWj8UIrYggFxMmTK0aImuR02HEsWEr9oOELMeBqCHNVfpEUe8o9LTJvndD48R2q8ZqtKq0IHg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(346002)(136003)(376002)(366004)(451199021)(6486002)(6666004)(36756003)(2616005)(38100700002)(86362001)(6506007)(6512007)(186003)(4744005)(2906002)(5660300002)(44832011)(8676002)(8936002)(316002)(41300700001)(6916009)(4326008)(66946007)(66556008)(66476007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3o/YuREJLUBSLcd8nTRtgU64WPMnzvxpYcRs6APYlE1K65nraRE1fBOnQ4wX?=
 =?us-ascii?Q?LJd5Px8EKvn/R/4lV4vVHbJRIRn0N4w4wGdYFWInG9RacooYI5ig4jmJeSSE?=
 =?us-ascii?Q?gpY4X8iP8zazCz749LOzh4fBzjpX/kstnA34BCsDDIXaghW8Szza2t4euo7f?=
 =?us-ascii?Q?pXiWnXky8aUnF1FnHayVywF2AZnG/mdWVl4w5Hwqp3r8TLt08C3NzlTZOOTD?=
 =?us-ascii?Q?8OdOG7Z5lcyqTaPeW60P+T+dMla0zS0jD930lh3P/LQbAB5Ba6+K5sobMxrL?=
 =?us-ascii?Q?lP6CZR/dCy+7UP0Z+7DNXpGw0HmNGYA467OiY67MOD6x/EtoJx67P81oXuBb?=
 =?us-ascii?Q?vS0vBdbkMQnwvma7W5f+neJqRTxLX6dcHhVG+ia0Yj6fG//EM37siL9bbYIq?=
 =?us-ascii?Q?GIfr3kakWlvU4EsV9XvzkPpgq8qeRzBUIpQi8Gc/vYBf3/nQYR+UvkrLPDHY?=
 =?us-ascii?Q?0ZVtMZwUMS01YgzQQqVTZbuWc1hyW3DDOiI11EoM6A5NNXSDTl+TnXZqp5AU?=
 =?us-ascii?Q?fY4I8Jdh8LO9jrjDrx3ftNLVL+UDUP0AS2zqNlL+YEwoQ42S2wzS7LQ97NEo?=
 =?us-ascii?Q?2rK5G19z0nmINZTv0EZ/5jXNF39aTgNM/rRH8e/TdpsahUO88yJeKzIAEwOC?=
 =?us-ascii?Q?dL5ZD2gQwyAB9ow8BXr8uCLdzIaq+dGEMSOoa0iMzh2gg8gaV4NlyOlMA4dg?=
 =?us-ascii?Q?9JPPoCdJlDTPv9pdMw3CmCMzHmskuM2vCXBHjjYQD3ZXzQMYobFGlQDAu7K8?=
 =?us-ascii?Q?8UAZ50ho9vke+qZvgUqywoAnW0EI4B5CT62RGs88htfFfGNKTwy5t9uHPKXs?=
 =?us-ascii?Q?lKaUO+cWRWrgQPldFJEBGyZcLqCz0ICe09PYPYzQmqyf9GyLfKy/FfwkR6h0?=
 =?us-ascii?Q?cJ7n8oLLDOlVqfmvJM02RNMTk3JzPbfTZ9VkD1SLBEYnBRxylnfrseTbnrhi?=
 =?us-ascii?Q?OTii8D2C4Nt/JfNxu9fPoAgHrshFlQVbBE1APFtPgLtwmaV/89atEsgbexCL?=
 =?us-ascii?Q?7o1fhVZVgn1uZ4PempVavsPubgcJkt9aFc2/g2nRewe5q0bWMtNSs8nrInm3?=
 =?us-ascii?Q?5Z3Qc6xfzDyIUAgP/Zq3j5SSbJiPhvfemXnQSxQsoSBCevu+RctqJ5ReEUGw?=
 =?us-ascii?Q?Jev/0XT7tqaeFcLInBQCHyv5smjROEAr12E6A4y91X5r7qRLVW68PrnV5asS?=
 =?us-ascii?Q?pvyTYkyUL7xObyO0GJVvxopD9xu4RWMxBdS7Y0n66WLXk5ZaNEfto4SBZFKa?=
 =?us-ascii?Q?W8UR1OqC4AVEc3ja4xsrdszKHxjYX7CY88cCwQ3d+A1D/xYvLK9pi6HUR1FJ?=
 =?us-ascii?Q?0TE+EsmneZQIRx3vUG0LRn9Hob2wNLRud2lZRgoxN6k/3nyZLmG/RoNqo6Eg?=
 =?us-ascii?Q?hNe0clFhMqN+bgpu2NPuOH+WRWecWUSfo9/djpQIXhAg19+wHKvkoZiZPVYG?=
 =?us-ascii?Q?EZD+lGbhDWLeFAuHCMrjmHW6sIO3mZcvIAhUylCAxdxbC/xwSf5K97W1HYt1?=
 =?us-ascii?Q?0VphEodTjcH4gydkHKUWg6tGK7cDBka+dKhZJJT2zdvC3ObEoiz/AzqKf0Go?=
 =?us-ascii?Q?f55arluT/41SxDic2eF2V8XcfwjsewMIuR8pE9QAZWBpUtS5rS2KcS/bAZcL?=
 =?us-ascii?Q?aZYktySb6RkTl3izo+MgUcoh0XpPTxamAkSJOfcaEjz6sFL+rZyZm/WOqs5X?=
 =?us-ascii?Q?YzfByw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87f62a4b-773a-43c1-c364-08db6b1aca42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 07:58:21.1286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bI6et0MxE+8QF6EUeBBmNoFnddKSEESNUwP3UMPvtcftNSGpN46wlO+vc9S4O9Z+CTgMcLQvw6Jw7RnswBPEVqnOxsO/JpXAjjNHK0CXIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4490
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 08:17:07PM +0000, Tristram.Ha@microchip.com wrote:
> > > +#define MII_LAN874X_PHY_PME1_SET             (2 << 13)
> > > +#define MII_LAN874X_PHY_PME2_SET             (2 << 11)
> > 
> > Hi Tristram,
> > 
> > you could consider using GENMASK for the above.
> >
> 
> The equivalent for (2 << 13) is BIT(14).
> It is defined this way to reflect actual hardware register definition.
> The value can be 0, 1, 2, 3 shifted to 13 and 11.

Thanks, understood.

