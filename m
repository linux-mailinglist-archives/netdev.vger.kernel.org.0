Return-Path: <netdev+bounces-9232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6517F7281D3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:52:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FA6A2816DC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959FE12B94;
	Thu,  8 Jun 2023 13:52:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824FD947B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:52:09 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2126.outbound.protection.outlook.com [40.107.94.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66F826B3;
	Thu,  8 Jun 2023 06:52:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eXNrY2A6OhnjC1kguX+GxOXRhyjuJN46TY28YqEYrd3eNGKZW8lARxRMevxJwAHbdbikvLLbbY+V06alj+IY3qdhDBEYdqyb8TgGtILZQWz+TGxEiuEBq8zLQpE5rc8ZfLoUneBvP6kBpVxwa3SLLp6PnGJp9yb3vJZZ03RCD+MRIMkMDQv05pjYLWrk6dZWIHlyx3Rw2H6NNqvDbW+D0I71T3mWx3OSV3l44If0BZRBSgxxuzzlu0Oh00WuR0D+FbRct3s+bZzNtDS075aarH6MM1FyY7n0LPpIos4olzzCQG2R1dCIA04OO+8Dw08ssWn6GpLit6vfAZMw7dRi4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6979IyXuu9eTWnRtX6c0GB3lP/Pc8sTv+Zo9ZrRsSfY=;
 b=VZ91SopvIlj79s82Y2ZIN0Y86aGJ5RIKt6FIx77O9C3cSPeNPP9s80VzaSzrFKqWyi5wKpIq1T9B/Fm7/QjhzG+KY0qG3cbp6ofcIgdok/WxyD0ZW2byU+P/OhvHhjKs7rfVYUtV8qZO8M2VQ9gwKl8Ny8r+GR++RU78RFMwEDRpx0rgcWZsqCCFvwCksLV+KwUK+QDf7Y9ZjohcVBbUkQ+Yzqwvt1mlPQJ6LWaf9zuHPFsNEowq0tEmlZDhYv4YO1i3SzonHp3QebBpRRmtVk9ddOf46Lbj6wjJijZB2vVohnlo3wUiWb3QTsJZIBpDjpEH+m1nSuOKNJly/xvTQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6979IyXuu9eTWnRtX6c0GB3lP/Pc8sTv+Zo9ZrRsSfY=;
 b=tI3y1Kl+DVZG2xRWlzdDr6sohBn8UhTLF1fpDPGR9QgHfK5wtOnp8wzhY5iko0k6kIjrhR69dMKRNfxsMZd0ifb/mHPRkGONC1EUdDvqWxyL5e78+AcVjyF+mXa0d+mb37X8DxTVBVX6ZzIb/25MjUd4Gl/Xq3E1nhcclWtqdDk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6178.namprd13.prod.outlook.com (2603:10b6:806:2e5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 13:52:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 13:52:03 +0000
Date: Thu, 8 Jun 2023 15:51:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, lanhao@huawei.com,
	netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Phong Hoang <phong.hoang.wz@renesas.com>
Subject: Re: [PATCH net v3] net: renesas: rswitch: Fix timestamp feature
 after all descriptors are used
Message-ID: <ZIHc+7/UTJE4c7md@corigine.com>
References: <20230608015727.1862917-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608015727.1862917-1-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: AS4P189CA0012.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6178:EE_
X-MS-Office365-Filtering-Correlation-Id: 010db653-a695-4ca0-5f3f-08db68278a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Kg1a42mKKSkrsCq9SVxyLo64jF/cTJfxGFehQOnQQDD9Wnl5EF5KD8bjiB7rFfaN/kVTS+x+GbmqtfwVsyBZ8kuRtx1ar06EOPa2ps6NSYCY2lTmQ/jJxPW41v1y1f6CgeWj6sCjCM4nWwnRouLkd1DqExnlLTpJYnFdm9j/K6mxQiqr0eDy5kkemyTnFo0gJPsIGRrqnHjjy53Ffm5pggGAUPEP3ZfW+/HXaok9nSiBVeD5HM1gg26UCgmh+OOW12A9MY7XqEJvYZzawEHxqEMRJA+2jw5Oh9O0keFW+EoVYbP3giubAwgEg+zTKpr/3EehT9cNwg7M42yryAiu7jH7EFxh3GYGXjTiWL/7GXp9OX0bAMq+cvJl6fyXErnUSwRk+5v3ZJXuLFf/sOdaUHJtSqr4LOorsX7wgkiDuYb5wegAg9RapDE+EYSg8twaZ0MEx80P0JePUcbs7YiuLkJjRSrIMmLtPrLDQMBCBMJUDq6Pod8CRZ7CZkBRa9uST+PQnESxC+RaekNZyDMmsIyEloDeKu9mCk4AWq1aFLE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(376002)(346002)(366004)(396003)(451199021)(83380400001)(2906002)(2616005)(86362001)(36756003)(38100700002)(966005)(6486002)(6666004)(316002)(41300700001)(5660300002)(8936002)(8676002)(4326008)(478600001)(6512007)(66946007)(66556008)(6506007)(66476007)(186003)(6916009)(7416002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wE+p/AJ3p0YcGETIHMWuYxR/tpV/LLBenXeDujIVUjVDGQnU+/U5EIUXOUxg?=
 =?us-ascii?Q?eE/0vGCkRpkKHZVgzAQ1a8hcuOgW/gt9reRgqC8Zv++r838oDjbmDek5xlJb?=
 =?us-ascii?Q?uzHLAMboCgQKQqakYTQ5iUrS4Q4ADh9IQINarRCLpzEsPqM1crvxf95LdMoW?=
 =?us-ascii?Q?2z1yBh8PKMeTtAwI1bF05all44L/TcEoD3FVm28B6Tm2Zsf10RJbDf5l9E0T?=
 =?us-ascii?Q?DIueXZJowM9ogoTZa/A220DyzM2eu89OESNM5uZ7xWxhuDzxKF9CAMzXbhx2?=
 =?us-ascii?Q?A/RQW8SPlxzD/6LCPXlM69B60Pu1V69rbITOR4lLkAbjPYYXcKhY/Bl0H9Ni?=
 =?us-ascii?Q?J0pd3GxMU6LvjCY//38DnVLEKbzm+1cLgcPj7TMmw7JQWeFVuv/s2huoERKx?=
 =?us-ascii?Q?Bj1Ar2GyUUuoB+BW2LF0m2c9UpbBEFt8JU1+DaIGgWiKdxZBQL3SFuRrEnvi?=
 =?us-ascii?Q?UpAQBvVrx1DbsczmvFzhjOxm09Cd1FjomiDbrDMsBiBx/I3EoPNmUZF3MeM5?=
 =?us-ascii?Q?unbflUFyEusJ/twB1FicoQwrpHeWMQ36X7Kg+GmX3DMFitvLx5gLXL7qbSPH?=
 =?us-ascii?Q?Z5s3jl5hfG79tz9zbJEZZMazBv7FWiA1QzsnxvlQwEfb92hm8+FgrA8ZLEiw?=
 =?us-ascii?Q?T9Vy9aS5455bTGYucu9KE1MECrRGPLQ2DAQKYik5VfGUef21aCRaLtzv76CF?=
 =?us-ascii?Q?D08COOUDJFHVQPhTfKVF81ypSJs2nTRUemq9xfeezPfAmyid2WmtG8zkKREO?=
 =?us-ascii?Q?HCkyzpTBsoDtohxcRB//Tmp3f+g09INKgshR/TQ/14rF/IMtHCAUXw+BUC+U?=
 =?us-ascii?Q?NIz2MDCg3pe19J9yGRnb6eL25H5KdI3Swg0v4KNAuZ+TV1IWq+DBC9msm17V?=
 =?us-ascii?Q?XY522mzmUL+hx1PM8CbE1WJGuN6Bnp6/UGaDTd9vxC42wRW1v/39/BMD5h/L?=
 =?us-ascii?Q?Eo6rMttTqwMqIPtM+qFYaiTG278+YY2RL/R8APCWHXatN2t6uyZWb+3lDVeU?=
 =?us-ascii?Q?FX15aPTeC2sSJ5G236xbFzRXa+MoxvGRAWa70W4ukcTGGF35l25qNaGMbAXy?=
 =?us-ascii?Q?ov8XDWFM7eCfW5wtZN0qRk4Rcqtzxetpu70+MTo3XNdzr4jUitnFlS++N4GK?=
 =?us-ascii?Q?PHK1DpD9r8ZeJArGHy5ZcQaVcnc5GbGACZdef8pAbtZsUTzasq+6OEhaObUR?=
 =?us-ascii?Q?OsD2+nsMtE1slZ4cV5IHpJ1FEMz8v9Y8DXnFfp42EEc6I7lmB2vD2eN1Bcx0?=
 =?us-ascii?Q?GaEwh2J3CWTiJFK8jp7KLLsAYfl/Q01mhzD+a+PzMylu8CY5A9oHr7exGGCY?=
 =?us-ascii?Q?ck7ugenb4iSMP33gSfJ/+BZOTBnUPqlsvYC4dYN3pgnT/n6ObVqiwa0slpFj?=
 =?us-ascii?Q?7ioT5NFn0TST45pVdWHsF0reyx09LZEbMW4579Uzj6N5+02EPbX9cDfhETr2?=
 =?us-ascii?Q?JnsnISXAP8iyoNRMaw7nuxQ0rxBvRuhV/RpXa++PWOAnAFX+Zbx4NK5MycuE?=
 =?us-ascii?Q?QoaaSIJAlq3oPqGAzf0kyGOY/MsMHjTVaQaQw2orSvK/qS3U+k7YugrzB6sx?=
 =?us-ascii?Q?q34oiKugWTcB/0iTQOFLiXCjOd2NV4EL81SOF4fADMC0CM/91OhFBHtageGC?=
 =?us-ascii?Q?e1e1C1PnHAO7JXlmKpeG0qee/V+TOoiivANXJ+ceRC6j4zRJYnX7Nzqmkhth?=
 =?us-ascii?Q?FGNlkg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 010db653-a695-4ca0-5f3f-08db68278a0d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 13:52:03.4464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsrqYiL7D2TgUJPEbDTJYI/9CSdLNVYxKefZvE++zJlvL7xo+jkjLJ4AYq50gw4c/R+mvdsehL459P5muNk2CCBIZ3HzEU1is2uN5V68Su8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6178
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 10:57:27AM +0900, Yoshihiro Shimoda wrote:
> The timestamp descriptors were intended to act cyclically. Descriptors
> from index 0 through gq->ring_size - 1 contain actual information, and
> the last index (gq->ring_size) should have LINKFIX to indicate
> the first index 0 descriptor. However, the LINKFIX value is missing,
> causing the timestamp feature to stop after all descriptors are used.
> To resolve this issue, set the LINKFIX to the timestamp descritors.
> 
> Reported-by: Phong Hoang <phong.hoang.wz@renesas.com>
> Fixes: 33f5d733b589 ("net: renesas: rswitch: Improve TX timestamp accuracy")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  Since I got this report locally, I didn't add Closes: tag.
> 
>  Changes from v2:
> https://lore.kernel.org/all/20230607070141.1795982-1-yoshihiro.shimoda.uh@renesas.com/
>  - Rebase the latest net.git / main branch.
>  - Fix typo in the commit description.
>  - Modify the implementation of setting the last LINKFIX setting from
>    rswitch_gwca_ts_queue_fill() to rswitch_gwca_ts_queue_alloc() because
>    the last LINKFIX setting is only needed at the initialization time.
> 
>  Changes from v1:
> https://lore.kernel.org/all/20230607064402.1795548-1-yoshihiro.shimoda.uh@renesas.com/
>  - Fix typo in the subject.
> 
>  drivers/net/ethernet/renesas/rswitch.c | 36 ++++++++++++++++----------
>  1 file changed, 22 insertions(+), 14 deletions(-)

Hi all,

Hao Lan has provided a Reviewed-by for v2 [1], which was perhaps intended
for v3 (this version). In any case, I think we good on this one.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

[1] https://lore.kernel.org/all/08006a4c-0627-9779-2260-a7e10dda454e@huawei.com/

