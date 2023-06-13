Return-Path: <netdev+bounces-10327-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9C472DEB0
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 96D87281168
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE2728C2E;
	Tue, 13 Jun 2023 10:03:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD662915
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:03:56 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2136.outbound.protection.outlook.com [40.107.223.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813E3A0
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDoaejRngIFGltjggbXjQQ0tVTpghtbKdpLIUDTGJ9wMGAqQ4FaruQIYh1orzfKr0aXZ5a1VXP59fW0q9vEvCLyW1M04pm3GQH3zB8H+LF4RbFh/Wdf/vsmbl8M57yHs97w52TShdycZg/0XHNNE4FE+B99Qd20IaIsO82TD9xcNY1JK8RiAPTmyT52ZGSir/p+PQ0nhiaNvznW7QyMBjUYVKXmEs/LUUr0iSRgRKR8CspVMNR7UUFM90SUKxZjj8bhW12aWNSVS64Zu75nWn/u+SzWJdJV59j7oPreN2qosIlJrONZLu8yre7W/2A20AOZkNCpAlGA7WZkjLdKmlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=inypQOCEhagztOhVuRBxTXMMWBuaO/XknyNnJ02VLcI=;
 b=F3qIC0MuHkZyPlts5LyWLP2R6UDEIY43i7QQDIPM93J+qVjQcxp6uasA9qu/dy18lfNemi2eWcZNdmNOWigsUa85lgIA87ttagEalluPDT3OFqi6GVldcxMlS40OQV0Ny6XMHlzz0xJf0yW67ACGjcJKb4djmMQCpxj7AzeloYWKm+63WsRt+t5qkuxEF562aJRsFBOhzeTgqhCtnBEsi4FxLNOkE9C5sUGOVM9q0nM2h9f8vkY+SKwAAI3pycnBvVu9X1VDNSTp2efPuERevlPSXbgty36pa7DUeD4ig05+FLvdP9i4a1aMqHhENl098HJvZnVn32JmQjfSAI/Gzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=inypQOCEhagztOhVuRBxTXMMWBuaO/XknyNnJ02VLcI=;
 b=YPU/WnyATaHx24Wl48yl/CEZVUfSDphlRuLr2gmYTBi48jYa6k/wcoA00DcdF6UBNNW/Ua45XWMQDTX5H5Jx+GTwO7YQCWB5O1StJK0TNpiFBdlWLWHweSG7SWu4GdfduYfsEHxpfe5iVgBC5jsryaw46hOZs+bhK/EPlc3Rllk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6341.namprd13.prod.outlook.com (2603:10b6:510:2f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.21; Tue, 13 Jun
 2023 10:03:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 10:03:47 +0000
Date: Tue, 13 Jun 2023 12:03:40 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next v2 1/4] net: hns3: refine the tcam key convert
 handle
Message-ID: <ZIg+/KqNgDPx5GKo@corigine.com>
References: <20230612122358.10586-1-lanhao@huawei.com>
 <20230612122358.10586-2-lanhao@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612122358.10586-2-lanhao@huawei.com>
X-ClientProxiedBy: AS4P195CA0008.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6341:EE_
X-MS-Office365-Filtering-Correlation-Id: aa41bd5d-3e7f-4ab6-8aa0-08db6bf57a74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sNe0x/91mJF9tjfKjIH1plLywX6Hfap/h+KlJ4H82HGvlwsMEvrLOcGRP7AX2KIMKEXFJ7tWo9bI4/TL0h5OUYksITwgFLRFfPXsa4dn5bapG9oT8K6tDRzw2YcDxwGpyjIF/EYEFCtrueCG87w/aE1AexDtMPS+STWPND38v/32HbGcmGHAyfTMNnexsErwXoCvbiRKfbyDynRBTfnkERCqTp5mv3QoH8kI9lpkdIxZvANtpcNZ8/2VPTubVo0zTp2f9wuafEdOg2gt/zsEU56Mkqmi7e3JjxRlLFs0W5RZjdTUbGeZaToU6NlfzARMm+6qdHHTfO5zrLIm5RvBCJuX4B996iGrF3Qd4YUeTrij3wrdis71gfVEtzz02f+Tf2cAM2cDI3v9etdAYY2fN7rDJAuiCspE1mp60G9DOdzsKrvmTiIuo6/vcv51mTbNZEeKNIfsgpGCTr6F9AZk0UtBzKfHmDJGINOFvEjaT1n6f52pbcXj6jxJeq67Wrv76aUdHIia3mC7Oik7ouffh+ZXvIyM10z4qIYozPqpZpOywx5+bsvOivqD3KoHnv3J+CxltoiQktRSOfLYvHkEPtQMdFvCdzAdIb+dzGkb+bQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(366004)(39840400004)(451199021)(316002)(6486002)(41300700001)(86362001)(2616005)(186003)(7416002)(2906002)(4744005)(44832011)(6512007)(6506007)(38100700002)(8676002)(36756003)(5660300002)(8936002)(66946007)(6916009)(66556008)(66476007)(6666004)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkNkQzI4aGJKZzFjbHNpakFaWXNSZFB4dXl3MVBTRTYyaWtEeTR4MTFaN29k?=
 =?utf-8?B?NzAxRHo2d3k3ZG96bzRibjhKSklTTk9LUXhQSllMekQxV2tTWks0TDVWUFln?=
 =?utf-8?B?eGNTb1pwVjRDYzR1OHY0Yng4OUJSTkg4YzA5RGFtNnNlUDVOTU9NSnhmS2NN?=
 =?utf-8?B?dkw0dW8yTThHTzRTNjZQVWZNT3dOSi9XV2tMNG1Xb29ZdDZtQmZBUVBNTzZ4?=
 =?utf-8?B?RG1CQTl4cG5KaVk2dzJJc04rN0paZ0F6Uy9KODljVVlBR0JJV3NOamxwSVpC?=
 =?utf-8?B?U0VEbjJLa2JoZk1qQ1hPbk10UmtlRnhHMTJiUExSelZZWDRHczBadzd0TEdB?=
 =?utf-8?B?YWNGRkloRWxYZDIvd2FWV1FLWGxqMzVtT050cnIxeDFOUjMwcDV1RVFOQy9X?=
 =?utf-8?B?WUdDYzNmdzlHK1VEclAyS2tlZGtGckU5bFlJREl2TlpUL1FZbnorWUllZWpM?=
 =?utf-8?B?ZTBrTGkwc2ZQWjdubHlHWXVMTW96b093bWMwcEJqVVpRWVpsRitJb2ZWdktp?=
 =?utf-8?B?cEdVMGM5UmVjYUtiSHVUMTcwZkkyTXlmOGRqM3RxMU1uRUFpZC9ROWZyNCtX?=
 =?utf-8?B?Q1Q3Z2lDR01abU04T3p1ZDh0cStjRXpsNDM3anZESVVYc29GajJ4cWF6Wktz?=
 =?utf-8?B?ZXhYWlB5MDNCVmFaQ2xuQjl5R3NQNnh6VkMwVW95QUhTWW9aT2l4ck5zaFdN?=
 =?utf-8?B?MU96MC9SM1VHVi96WlhUell4YnhIeE9Hb29vVFBRVm5wZHE4ZjV2S05IZmxL?=
 =?utf-8?B?WStHTUErRUxFN29zd2ZGSndKT2F3RzFUU29KdG1QZGZVb1U2dTJyMjRYQ2pY?=
 =?utf-8?B?aGduaGdHWXdKZWRMeXpvRU0yZExkWjRoSHluZjEwTzVnUGNrdHg0ditFeElw?=
 =?utf-8?B?WWgxaHdDYmNTVFJTNFlWREdRYWdLQzNLWFJrNytXQTI5YklpazJXSU1tWkZP?=
 =?utf-8?B?K1dYc25qb2ZZSW1DdTNDZUVUS00vRm5EZTlseUhVNjlzVWpvYUN5Tkk0VVNz?=
 =?utf-8?B?elVrYnFHMEpBNWluNHhIOGJHK0FGcjZwWFRydmdhamNLV0h5V0pSY2tYcEt4?=
 =?utf-8?B?V09LSjBJVlZpTkRNNVd4d1NYQW1XeTlXOXRLL25mbXQ5Q2dkWVh3WGIrTFhh?=
 =?utf-8?B?REdSc3cvd0tFTGJjZGhGWml0K2JmOTlud01vVjRaTTVVS0ozbUpNN3doUVlH?=
 =?utf-8?B?REhVT2tnUDFHdUlHVnVJKzZSSUhyemE4ekRJQ3hCRTFNRHQyZ0l4R0Vua2ls?=
 =?utf-8?B?NjZVTUVteTN5WDB2U3ZBbGdKa2traW5yRXRuTFhSNk1XY3F2dHV0eHRnOVpK?=
 =?utf-8?B?YktDYWVJRVBpNWNyRE04QzUrbkI0bTZaWUNkRDFEbE1UTUMyWm1TKzE1dDBB?=
 =?utf-8?B?OTNjakVLcmJyaXFnSkYzcGllc1pnU0NlcHAyd2VGNXRQSGNWZm1jTmlWSUNF?=
 =?utf-8?B?MTRQQUVSU1pQZDFidkVhL3JEZ3NkVmN1MU03SnNaNXQ1MFBhdGh6UmhxR0Fq?=
 =?utf-8?B?Skk1aEphV3VycSswaGlTa2dRTEJUMk0yZnd0K3RzSk8rc0draDBITVF0bzdq?=
 =?utf-8?B?NllhMjNrenlhaHd0S1ZLQUM1UjRmcTNxWmN2VGRDOFlBTmp5WGxKR3JXSVRJ?=
 =?utf-8?B?cGpLRHpuVDlBNWZSMzl1T1RJNkcxY0FxVGN4S2U0RDIveEVkeXRnS0hEOVR2?=
 =?utf-8?B?RmRnVU5xU2d6SXdvQ1pBS2Qxa3Nxb1pnY0RMR3ZtZ3pxVitnV3dreVN6TWZG?=
 =?utf-8?B?L3BzajAyWUd4WVo0VEpRVGk3OTJ6Rk1BZGVlY3BGUWtza3IrRTA3cktCczFI?=
 =?utf-8?B?ajNmWXZoTVhCTko0MlltTXdvYWhMREk1clZvMWN4NDFUbU4vdXJvSGVjV2g0?=
 =?utf-8?B?TWlqTC96TGVkOHZ5c0JrMklPbWdya1lTejc0aExESi9aSy9Ebm1na3l2U1lt?=
 =?utf-8?B?OUNENzNFUWt0cDg1a0dwK0hmcWJhWmQ1Mkhhb1JQTDJHZUpkV1hTYnF1OEFD?=
 =?utf-8?B?K2dCczlOQXRCUGZCeWxDYkp3b2Y2NHZESnhQcmMvVldRV1ZzbWdJY2x6ZU92?=
 =?utf-8?B?dTgwRUpTRWRGWnA5WVgraVRxQ3FpTmkyUlBXK0IyK0V4dlRCT0J3TzRMS2RW?=
 =?utf-8?B?ckx5OWdmM2dxQ3RKbDNBbHlwQlBwS0xZMTl4L1ZxcUNBbDBXeVBRMEFicWxh?=
 =?utf-8?B?NXZXaW9kaXlYY0VmNlRVdWdKckdZYVVieDRieEh6RUtjanV0UnlRSHQrMDlR?=
 =?utf-8?B?QzBPRGhXUnhTc3BLRnJPT0dFM1BRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa41bd5d-3e7f-4ab6-8aa0-08db6bf57a74
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 10:03:47.0410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ECg+suVxbLHXvXzsrho8GX5/QWj3hrrVy9cAKCCQzaGuXWhg9rmojcB8LgMuQcO21y83F/2lPddHKg/x+Sls7JdGadf6YifsHDpKdlezvGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6341
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 08:23:55PM +0800, Hao Lan wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> The result of expression '(k ^ ~v)  & k' is exactly
> the same with  'k & v', so simplify it.
> (k ^ ~v) & k == k & v
> The truth table (in non table form):
> k == 0, v == 0:
>   (k ^ ~v) & k == (0 ^ ~0) & 0 == (0 ^ 1) & 0 == 1 & 0 == 0
>   k & v == 0 & 0 == 0
> 
> k == 0, v == 1:
>   (k ^ ~v) & k == (0 ^ ~1) & 0 == (0 ^ 0) & 0 == 1 & 0 == 0
>   k & v == 0 & 1 == 0
> 
> k == 1, v == 0:
>   (k ^ ~v) & k == (1 ^ ~0) & 1 == (1 ^ 1) & 1 == 0 & 1 == 0
>   k & v == 1 & 0 == 0
> 
> k == 1, v == 1:
>   (k ^ ~v) & k == (1 ^ ~1) & 1 == (1 ^ 0) & 1 == 1 & 1 == 1
>   k & v == 1 & 1 == 1
> 
> ChangeLog:
> v1->v2:
> Fixed the comment description error and added
> the truth table in the comment.
> suggested by Simon Horman.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Signed-off-by: Hao Lan <lanhao@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


