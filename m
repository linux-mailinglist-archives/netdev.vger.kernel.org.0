Return-Path: <netdev+bounces-4695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3451570DF10
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D06280D23
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D3D1F182;
	Tue, 23 May 2023 14:19:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0B31E50F
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 14:19:50 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2117.outbound.protection.outlook.com [40.107.96.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FD9DD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BH7+AYXIBeHiunAwh+pb/5UnOJjRJg1Rz+3ddencrgvwpLAOaVuQNJlQWgQNiC8e5EV0NDNmuMZ7BvXjTa4bOxHSxCQDMAYpBK26DcPaHGb0FuzAleFxcMzySi7DMcqdoP3o9iCJ/QnXre3JOgescBnLKVmxfS55yjj2kwJOPlbdLe7nHwzImJTm3se8ASjF4LkGFOluKyv57zyU8nZ7iVZrAKy9lRyPPgilRP0SUJWIslmrg21mRYB8CjbLoBs28O7f75Bt6iOv7Gsb04da60XdLNHv7rpKOSBxChqW7A+YNujfIXvO7d3a50CshGtFwnDX9fpsjf0U0QqOeW5FqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyX0RilhPMAkJet6jY3+DbNOcg4LvB0npTB+dSkvZQQ=;
 b=gjQUaVj9a1LiLaGIra9Fcz1Bq1lhsOGH4NiIFgseJWORfdtVirQqEuApuI+fcsCsfq5zw+czYHfxRFYXpgFZoNzbFHLp6WVO10vlkDCDWTjbkxVWFOluIcHnzEm5vBXnggqWbj0fdRyyiATXY/qzTIVqc1szevJs+ti/0kiljagXSv4b9ncMHgMTtNrTP4raJJbP4mMAJKtifKE2GbZXakVsWV0Gkejv2WvSGcq9UHR8z8jpY0wgr8f5/3s9qwzmAqw5HgQVxdrLgh1tEhsZ2qVVGoNgH21VaAvMNGzj6STuay9z/rNeqf3VQC8dyeeCdeNGidaiY3gPf8231ILC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WyX0RilhPMAkJet6jY3+DbNOcg4LvB0npTB+dSkvZQQ=;
 b=U7lYvHA9mg/Kk/MLuBv/zxB4nqcm8mhvCPtqFtjbfjzjxCx74b1nEq0DBgRRU6jacSt/MwaJR00yQngBIIxTxBMmP+cPBFfNEJIVlevs9+lUUlDUMrHexLCv78kGGeapLCBsxQoatu71kRNeGnyeQ2glir5V9n6Fkt5EwywIJfA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6407.namprd13.prod.outlook.com (2603:10b6:408:196::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Tue, 23 May
 2023 14:19:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 14:19:47 +0000
Date: Tue, 23 May 2023 16:19:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net-next 2/3] devlink: remove no longer true locking
 comment from port_new/del()
Message-ID: <ZGzLfZrARmMPJi4n@corigine.com>
References: <20230523123801.2007784-1-jiri@resnulli.us>
 <20230523123801.2007784-3-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523123801.2007784-3-jiri@resnulli.us>
X-ClientProxiedBy: AM0PR04CA0102.eurprd04.prod.outlook.com
 (2603:10a6:208:be::43) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6407:EE_
X-MS-Office365-Filtering-Correlation-Id: ae018eee-3f94-4437-bfef-08db5b98c317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TxdBp3Fvuqua57yvOU5uSqXys2DRlKBcnTbqaC1eyN9xH3qYnJkhNpKJpF0u8AkWNBkiwgIlLERU7w4a1MI0noHk847ofqhC7W6vl91lvnyXMFJ8FABftfgJWQT2gnmTXaT9KI6+/HWu2Nbt6jhEdJYYonPABIbYFmwu1h3UvgTSZ2Vro7x07b3AAI+Pj0fvcM3L6FRHuFBuGO7XG/3+Vx2b44yh3gVWX/bEPGlfkVQi4sHQng+Nu4LemP1Yj3iujgnBxNrVkyWsbFUp4aIv8U3Nf3miztKMJJk2PCLSbAaNzJrIoEkgsqaEeD4z8bcZh3p0bkvCrbnEq19EASZ+Wlx2z1qpHriZZ7jiEU+a4XigMQ/OxVG6MtBvmErMg+ZsHzgNJIWs8fNbZDJh+ngswyaQykMVJFOO9jG+CBpluPcdx0AeAnrpthAPLmn0/q6WcxW5ygU8P5mVvdHuGCoKiAU1QjO+MrDoy1fZdpFuLgPfDQoW1JcisbUqWr/UtnwavxuCpy3/18xfNf5gLqmyDVgv8zi168/q5JD6NW84kmcIpGLZ6IZU99pEMWDxKMdr7LgNxuRdw0ZcnEAivFRJsKi7Ra7lYE6uTcoSSxO5NHA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(376002)(346002)(396003)(451199021)(316002)(4326008)(66556008)(66476007)(6916009)(66946007)(41300700001)(6486002)(6666004)(478600001)(38100700002)(86362001)(5660300002)(8936002)(8676002)(44832011)(186003)(6506007)(6512007)(36756003)(83380400001)(2906002)(558084003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1fwaQfh0no2wRgWI4HdB+Ksu4EXo5+GzOMK/USuKsIgnKhgdhTUWIyZejxe6?=
 =?us-ascii?Q?TohGZUsuAc+pw5L/zbZjE74upE4i10UPx6V79+AYNhTif1868U4wnKbxXrUU?=
 =?us-ascii?Q?DkWvxCCmWfw3+QSe8AMsU+KUUlIWqE/D5CSRxtLUn+P02uGDL09+IoeKXeCj?=
 =?us-ascii?Q?iGduNohEtEWbmUuDpI+upu4iNLlkdtAhbNosrghvohRyRVJWBQD3nJiL60pI?=
 =?us-ascii?Q?0uwo6n3DrzyIFUe4SO7hI0CYrFYdu/p5nk9aZtN3iSkZJSSrHr4bdCtUT3qr?=
 =?us-ascii?Q?qk47rCPYN6kLL5h3QcayxDurkuyMVg4qCBq/MTRmkYktKOPki1ikXX4xdRWg?=
 =?us-ascii?Q?WfmQcIIh8ri5hGdBfelC5XjnYoabcATgYCvv0zKwRqr0yagq2ET5iTQYymUc?=
 =?us-ascii?Q?gC3QjcYhIObAfr3/N/RLLgayRPquR9whpi3lW0/xGpjNcGVMrSMZ14AXxvBJ?=
 =?us-ascii?Q?RFthyzknonXV8C6vaSDK80nrZkoW9BpqPwboqyrrJmS07gcvDyg4PWSISnZV?=
 =?us-ascii?Q?1bxe86+pDwzIr5qtZ98tfv0i7lV+sxbdD2KiCYPzhHvTNxRtlqN6z5JyAXUv?=
 =?us-ascii?Q?r2RBRiYmGnFwldl6SjEWJOQM5UOFvrGHzRC73T04GVewD4PP0SfBTlNV2Ncc?=
 =?us-ascii?Q?/9O0lhzAj5t0hmgFsQxgySaQepqsjJS7N3/0AIHqa2Z1Hb38CavNnSpGI9EH?=
 =?us-ascii?Q?u/9CZEqGtpu+fkLL/Qj6880YTxCiEaFlvtUk5UmsGDDVtmHrzQFl2FsTo1/x?=
 =?us-ascii?Q?c+jXabZi00qLVHiLJDoBsDAielHvs+NelLW1xQHw6ahd39/6Fz+l32DmMFME?=
 =?us-ascii?Q?6i1DSePkn5sOGChaNjItD+/KtVVenC8+OyZIjRyrZLVEZqUClXHLBTu+Zv27?=
 =?us-ascii?Q?LZLf4aEewSbA0u75fpV3SPbN+3AXwA+H+HrV4TNtv157TEK2i5GapAgAbhMy?=
 =?us-ascii?Q?RmOogSCFavdBdhn1WicmqO9HCwP4Ka5CKKIjaYTy2+CY1vRnmWYZG2W1rK7V?=
 =?us-ascii?Q?TEjnlr0xRejJAJSm+f1dYhlpuhvFbRrd+T8j4k9Lqps0UW2xHQOHIZ5w8Vgf?=
 =?us-ascii?Q?U0RnxZ0p6sqMQKE9aAO4TGJDmF6dcBUkjkb/XjCVf/539GFNgg7iBzgQNA1Z?=
 =?us-ascii?Q?RNrjWOBdd7eDb0HZh8nYmuY9IYRIigut5NAPbyjP4XpSTS45as2hlrejO8Z6?=
 =?us-ascii?Q?MZxka6c4R0cXe0tdgHFav7CXgVREKg0HSvIEtnVuonkvBV2KUxLUqgs7tqtJ?=
 =?us-ascii?Q?Q38Hi+VlFukSqm7K3siygZrfYMWxzIDVqgTkr/9p1so7H9qUad7fRsJYKStS?=
 =?us-ascii?Q?6S5Mz3SiMuxJ7nNOihrArG708gG0IATwddjLWY9uKMOM/Y+po8jZYtBvkQzk?=
 =?us-ascii?Q?i7CPcvOvpgdNnXlFew7TEOH8qD9qA23f2uQJXGCGwMNOKf6X4vrUgCuZJQTV?=
 =?us-ascii?Q?nasfy/c/NchfpxcEHLjiF0MQ1Q2rVIUGCOUpmQtAxUGb8Hd0MSCKl+dJxA5P?=
 =?us-ascii?Q?GgPQ+juYALucl9gvObaWFcg5drYgnDpKXz3qEMNLNnDIbmpyA2PfIuneC791?=
 =?us-ascii?Q?ge3D2gk+1uKDDMHmNF9GyeZERr7rmhmLSwn6SvbVqeIqeg5s9slQ+Fgt10VK?=
 =?us-ascii?Q?uelNU3EWQqn//bIPJGAEuWO6eMsh851rsOfIKeCpTT6T3QB1DfKU+7Steo43?=
 =?us-ascii?Q?mvSWQg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae018eee-3f94-4437-bfef-08db5b98c317
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 14:19:47.1413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oNJkKgwnBs9o5TLv8drcKy1/dC+us5YwA2+UzFA/zFkgDBvZ0Q0KJSpXAGwxddKj9R7cR5ICn4Y528b76LkUg4BIua7WLTqFFDSZwzDT/gY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6407
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:38:00PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> All commands are called holding instance lock. Remove the outdated
> comment that says otherwise.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


