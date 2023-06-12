Return-Path: <netdev+bounces-10123-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9396172C599
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:16:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C403C1C20A39
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 13:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04521992A;
	Mon, 12 Jun 2023 13:16:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A242F18AF3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 13:16:33 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2102.outbound.protection.outlook.com [40.107.92.102])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48CAB8;
	Mon, 12 Jun 2023 06:16:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUcX/Ln2lmoeMnW7CAlCxsVNTyyQ9pvqRZqXStt/I4BdsclE37DCgKIxnqZBV1eLCejpQD8lKiaSiJ8CqxK76Ele9knM2aGL7NmhFudgYzkBqqwF5hJK+o1LEEsLGO2LdPI1+rJekOob0hKvYfJ+TjfqD+ZnHiTOlbOKrwpO4dgZGZmxv43/DLUEYLzQoN4/KMPeFarhtoGcQ0hAnDnsczX5lguyEoEkIMerPeSdEGwgmQxrQm7qBftrJEKVeN+fEYy01JwVRxIhE15RnDGbg48TMQVka1q3UFaGNiFwzHVx5RNX2tG/cQETVPKYmg/ORUT2ZcTpTKFHrcdjsMJaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ooYyLpwWLycGPSdqC0zY252x62xf4jCZ/HRBQITXWF0=;
 b=UTaidXoBSCHfXxdav3lmGhNCRKziQD2CPOC/fN7kb3KJt3th6NS0hyvMB96inCTbtq+Rl44Ds+E9JzVtNbQQJol5Us9dd2Z/6LiC7ZDXURmGuomR0nNvrUZlh4BTii7dOlFx6mIlCqKRuS/vMliqRdttXBMxr8yKjUEmyWeYgBOONTpBU20yoiE7amo3yCRudXibqq4M9JRC5cAmsiQRp/5Ctnoxaod3rm7TQ8b0IqUpufAzynvicAlu39IarffsoTRUSgeshsxFZhwJ+FBPL0f9pqfGUmfZqDmhTGJC0qm1Yfus1g2vGrMsh4dBidg+a2AKTePmezTTJ1EGMKZ70A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ooYyLpwWLycGPSdqC0zY252x62xf4jCZ/HRBQITXWF0=;
 b=WA6+mMl0sHAjAq8NQL0DPokze17MP8xSlehCxzthC7L5n5T4l5vfKr7/+wmFg+ArrHbx92TON+RfW/UcmclyDIFDfQnpc1OaNBLBDLy+sO88toy5zAFIsOCoHcy7fRJvmCXlVq/owFwpq5KD0qkXoOVwl/9rHUBcxuVK8sxiRLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4945.namprd13.prod.outlook.com (2603:10b6:a03:36f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 13:16:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 13:16:26 +0000
Date: Mon, 12 Jun 2023 15:16:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc: richardcochran@gmail.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, vincent.cheng.xh@renesas.com,
	harini.katakam@amd.com, git@amd.com
Subject: Re: [PATCH] ptp: clockmatrix: Add Defer probe if firmware load fails
Message-ID: <ZIcao8a7Yqf6McGw@corigine.com>
References: <20230612100044.979281-1-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612100044.979281-1-sarath.babu.naidu.gaddam@amd.com>
X-ClientProxiedBy: AM4PR05CA0003.eurprd05.prod.outlook.com (2603:10a6:205::16)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: acf65b4a-3c9e-4c0a-c901-08db6b473a17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5xTgrtz+opQD+0H2YLumPxar1P9QIrpaS6oUAAy3KGO63Z8Ojof6hCvBaLPG+F3EB+MNsI5BJ+oj3w08ihkD0RxrKtFJWJt3Xqx2QbaDetz/Mup+9tMnqJ3wZUOqFdV2b/OUPawW7G+DDzT9a0WUWVouEHtvXnVgTGBUqrLO1A71q/xaNXapXfSvjkvFO3VWs/Y5gCfajOP1+GCGG0LhEGg4w1+LLqa0u7GqvPf1AYwB6JF+iVBSq4kKevHF5cNrIjY5fdKLLKPGMM90+gaSjxoqIt+OX8TemY+u7kxSLx0d03GDph5dMSi3h+hqpa72JSYYQBOd/CyBoLQ6+CPCqn+Jnv6b9GFf3w9zf3XZzmhS0tJox1CcLBw7CpCdt5OOfWQstqcMYM7j2YD9Oi11It900D8xZ/J/s6Jfb95GLRhI5EG6VfT7pci6gZoRiVgexi13Gvc43hoUy5+iEQFI0k+1RHBZG7E1rDskFq01j3JdhqThNg0OtmOC6eaewRR4DhrJDDZnJYqI7m6bvmeTnfQLcqHkLBSansHzht0ADJ+nQSlAqys6Li1mfABqJ8I4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(346002)(376002)(396003)(136003)(451199021)(2906002)(6486002)(316002)(41300700001)(83380400001)(86362001)(6512007)(186003)(6506007)(44832011)(2616005)(38100700002)(5660300002)(36756003)(8936002)(66476007)(66556008)(66946007)(478600001)(8676002)(6666004)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kUYFndJjDNObmpHKeERmla02ISzn2mPP3IQgVH/tQzDyQKIggVjAF6OmW5RA?=
 =?us-ascii?Q?hu1zbEmALn/8x92+s/sEFI38vCqFC4qz0bjKXU09hQrkjwIO4xlksbuYcxO8?=
 =?us-ascii?Q?NY0j0BoWyHtQMQ1o5QNy+FqpYHtgbWBlIk7yohNP+QPbuyOcw8C2Y1gkINb1?=
 =?us-ascii?Q?3odvTaHBp4gmtjgJpVau++tPvxGGzVd8Ujh0kaJDFd5kPPiAXuCohbiPm5zI?=
 =?us-ascii?Q?eKXKWO5bS1AqJyi3/gMto0f/SQZxcv8Cu0s/qo7dXKcWBmaQnQ5ObS9sE+hf?=
 =?us-ascii?Q?0m62jc/abMSwd2lgL0ZLw/pR0n6gtzELzXgMetbVvkSdQg9DZGsX3wsnxr1I?=
 =?us-ascii?Q?8OT3Hs/em0cLpKNomouGBniksIwxthN5P+es/9aneIZpJXsutxRb9fgcM2Dy?=
 =?us-ascii?Q?NOTFSkrDv3N89JAg5lmqneE/IwnznXCI0teTitmZNETOVI6RKhaUm6HRH+ph?=
 =?us-ascii?Q?qgnYJSsU9irD6t/wd/YQ8Zs57GhQaSEhQEsljeo6PCdOl1JYIw/nXCTILS7m?=
 =?us-ascii?Q?ynL8Yvq9mCdzl5ctS8fXpYv1tXvu7ovUvCPzj/fZGGMqduGjKGz0ovcZnuR9?=
 =?us-ascii?Q?QkOpLIDqxnFsbDKlO7MOksVvGgoEoij2nleXYn2Ecwyi2FBmxikfAvyZnngI?=
 =?us-ascii?Q?oFKT+rseSfCzkl1B5Z4f/nvc9ozxpiJrvoOP+xKi0Zdh9AGvIRnDDbDegBI1?=
 =?us-ascii?Q?yvq0OWl4Iw5WVAqWLMHPJO/6aodijFsZoIgPO6l36FTGErM+18HwfJBBwK/l?=
 =?us-ascii?Q?LupAPEZobZAHSy4by6XX8oMHagiHO9Z+oQOIEhKpXfB0/BV9Xqaq++ZDybEm?=
 =?us-ascii?Q?Rgn/C4bjt2IHYluQ2MKkjlMQD3hUaA7QjTD/HQ5qGGedRJ9t+ZnRO+G7m4aD?=
 =?us-ascii?Q?2f3IvYwL/p9jeZXoXLKC7YwqKLJFKq4plfCurfllsevR7XoskSulGpRdUrPc?=
 =?us-ascii?Q?ed9afdrjYZ4uY1q/Nw21z1DDnvUGLARaXcOYy76bFOxrjjZv1nyZsHsl4UN8?=
 =?us-ascii?Q?Nz7m/HTDpm+8Gp6vN85ynuZfa9ygh0i44of8EVUFZwd9areBUvYVAwS3jObj?=
 =?us-ascii?Q?kMgu4oFfniizJ1C8/IGxx/44+dMhTkmtUWBw/swl36PdxlZIqg8IUVCK6Oy4?=
 =?us-ascii?Q?YKrG9Z2P7LdjtgWj0jEX41yFA61CCGjNeDFnM9auWnRN/TuI/cJGewxu2EpZ?=
 =?us-ascii?Q?aLSVfkgf8rcBHWSVIg54ovc1NbW+d40Am7JimlBdLTJIQQST+0eSj5y5bsBs?=
 =?us-ascii?Q?+CohmqLz4X74ifTfIRsVP8QokkjWqxEFre+yrc3CO3s7/Tf/zc/buFCv1sZz?=
 =?us-ascii?Q?SBi7qORYMjtwfr6HZCzQcsdW2iIK/6j2rwwNum5M0hwFWzMtDCoCxWuGbyc2?=
 =?us-ascii?Q?pnMw/vClWKgwvozyH5n2f06iI2BqKrbD6nJ4YpGcX+3iOdWja36NslyG78fc?=
 =?us-ascii?Q?f7Z5/2YRFMBC4mPHy0dpaEw5breL4rzcn9K6YkOpYnhfi50FoPppZmEJlS8r?=
 =?us-ascii?Q?ZCOhuXA86G9NjKefk+kLpsWD0x+czxY2B22lABl0bi6TEGHl24+v6vxCEMRQ?=
 =?us-ascii?Q?QH7i25lyB4qIJcpMIWvlwo0CtM/XdlHJj6iRklzlikWb5TKxzs0Cagd7Mn1h?=
 =?us-ascii?Q?ISZY9AwncO0Adt4yDrRUC1aFTFVgOfWG0Ph50W6b0BAFOJmV+L9HzSQZuLfd?=
 =?us-ascii?Q?OxNCOA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf65b4a-3c9e-4c0a-c901-08db6b473a17
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 13:16:26.6698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5/Ejz1CEPsxS2O7qUjYBzFX0LWJsSUX1/d7NRTO7kv1Kal4ZEOPHpqT8wYGrroWT7FlcuufM6ST1OEJUduFvh/eDb4Opu3UVD2juun52Rg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4945
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 03:30:44PM +0530, Sarath Babu Naidu Gaddam wrote:
> Clock matrix driver can be probed before the rootfs containing
> firmware/initialization .bin is available. The current driver
> throws a warning and proceeds to execute probe even when firmware
> is not ready. Instead, defer probe and wait for the .bin file to
> be available.
> 
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
>  drivers/ptp/ptp_clockmatrix.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
> index c9d451bf89e2..96328dfb7e55 100644
> --- a/drivers/ptp/ptp_clockmatrix.c
> +++ b/drivers/ptp/ptp_clockmatrix.c
> @@ -2424,9 +2424,13 @@ static int idtcm_probe(struct platform_device *pdev)
>  
>  	err = idtcm_load_firmware(idtcm, &pdev->dev);
>  
> -	if (err)
> +	if (err) {
>  		dev_warn(idtcm->dev, "loading firmware failed with %d", err);
>  
> +		if (err == -ENOENT)
> +			return -EPROBE_DEFER;

Hi Sarath,

Smatch reports that idtcm->lock is leaked here.

> +	}
> +
>  	wait_for_chip_ready(idtcm);
>  
>  	if (idtcm->tod_mask) {
> -- 
> 2.25.1
> 
> 

