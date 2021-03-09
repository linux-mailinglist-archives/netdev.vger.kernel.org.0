Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABBF333122
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 22:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhCIVlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 16:41:53 -0500
Received: from mail-eopbgr60129.outbound.protection.outlook.com ([40.107.6.129]:52101
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232082AbhCIVlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 16:41:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+MBZq/DKn8WhWOveIfUb9wNEz19BGT7PwtkBsse4muYaLnAl+Qv8YEhoBc4mdP+D3iK3lt+qZZsk0JE6WjBTtjSCqyZ//k+GKlaWOJhFJ5BYirGwBxFxd/eWcWpRM6jvoHL95PetzZHToWfzQ5k0Y+1X/hUkdSnv3WIpaZMyT08DobzpnSONGUCHJA/mfdO1V/M8kUhzLI2H7y1gzM9skxulP7PrDvqPG8xFfL2I2rJ3x/bla8G6m4vzWczA4CgIBSpCwnOnW9Oz+sOh1dqqcFCbo10NsZ/IjjVZElZdWw8urGFC3mXjnk6sQ11/B990RFEVHnGlWwTbjMhAS8vdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZ694YIYCd2UL+4mOvbiRmANFbLnhPir7rFuQHimCsA=;
 b=k3JfwbMRzjDETfYAFSlGpUaEsOK7oH6VeRKcPqb7fNJDELvQ34/ARPRJLi7NLD1Cbr3WQgEFQ2dK+RIT9GGvvijF2f4FqU/4iQcba2R484SlLfStxzPVlrAcgIv2p1CcBCZuKj6ksfFp+FnBC8I1dacIOXJz2R8l9oTRr3J41EdLDFxsx7hiBGA+eHb6s2mRpsguh/JlX8QGxvYco2NwU7HApwxSmjvShNFTjS9Gcj6ET8NNrZHzwYAfm0zdyZLXwsiEDmHxADKMBi9/6jGaqXlnssz23FRHznvBigviTcyevl5sHybZ5BsETF2HQDyhiiGS3EN7Lwb46zBjPD5JeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZ694YIYCd2UL+4mOvbiRmANFbLnhPir7rFuQHimCsA=;
 b=NsI8FJdY0YP8jYHQcU+jETsVJpec+4G2GQ9sAARJzNi6gbbgHnviJlnkHGRwhXFuxh9y4+3FUfIvveQU5yHV8uTq586I2IHR6FwXIkMDFQQ7colFlO1UcB6TUoBnNoYhZZu4cVSdoMnTlaJUKS+/cqfiYXhpuI7ZX9yUV6Uxixs=
Authentication-Results: yulong.com; dkim=none (message not signed)
 header.d=none;yulong.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4087.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1f2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:41:49 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:41:49 +0000
Subject: Re: [PATCH] ethernet: ucc_geth: Use kmemdup instead of kmalloc and
 memcpy
To:     angkery <angkery@163.com>, leoyang.li@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Junlin Yang <yangjunlin@yulong.com>
References: <20210305142711.3022-1-angkery@163.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <f30c31a7-68fa-bd89-1ddf-857808a33f15@prevas.dk>
Date:   Tue, 9 Mar 2021 22:41:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210305142711.3022-1-angkery@163.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.208.71.248]
X-ClientProxiedBy: AM3PR07CA0109.eurprd07.prod.outlook.com
 (2603:10a6:207:7::19) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (80.208.71.248) by AM3PR07CA0109.eurprd07.prod.outlook.com (2603:10a6:207:7::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.16 via Frontend Transport; Tue, 9 Mar 2021 21:41:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 333560f2-a701-468a-34d0-08d8e34424e6
X-MS-TrafficTypeDiagnostic: AM9PR10MB4087:
X-Microsoft-Antispam-PRVS: <AM9PR10MB4087BE308437A79115F5BAE893929@AM9PR10MB4087.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+PKg6l/T4DaVQG7pw5ihyXRWfZjz0lKa6mhypW9U3xE4GczQFcJ/pYWXRbyXTQQQL5ioO6snQyZ9d3WOnHOY5nRZpsPwGq+JCG0M3LvDaOoDaf38AFlbYJuHJyatNgeKRNvxFIiOHJ61hPHnoXEgdnliKI5LgFY9rAouxssnmazYRXTL/4juC+Y9FZ78LbTh+QKFc+Sur4ibte54tPLQCdJkjeE20Jw90wp5Vc0YxVbUuzHrAu9V5twt9Ps8tj5yVhgpb7mzir+HONMvVlRSICUA5a3iPNlP2pW22/1jk0rS34B17uEdnDttGcfWH8zm7TWMiJlv0bhjWIWys3gx9Jd6941sg0ie//tx2s6vm2JE5Hbp/AxDC/YKsLK/0EYFfQ7dMtnXn8hOzPaw/mb15ZnVggyNQQmEvjPZKVC9/hyZbMG7k+qYIz8Lg39xLUz7Qgyj0FIkDnZxPAQ28Z5J1AS+1A8Y6gc6FYEsMv+BDkbeALxYxDfrWAXWgLBnPMT+RoikHaA27sBPpvj/4CCBxJI5lhYs7bdugBzKt105sREWho7GEm0hnSJrp2U8Z8s5k7IIAk+lr6RBLQbwJRJtatIbdHH7lKaRLsUVuIUNJ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(136003)(376002)(396003)(366004)(346002)(52116002)(956004)(8676002)(2616005)(8976002)(5660300002)(2906002)(26005)(316002)(31696002)(478600001)(6486002)(8936002)(31686004)(16576012)(86362001)(83380400001)(16526019)(66476007)(44832011)(66946007)(186003)(4326008)(36756003)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?0mEzpFe0bxumCmL3D5U+xbrPaYDa6g/KY22dtNuLJP+KWtYkArGo6erY?=
 =?Windows-1252?Q?mEfzZIXwOyoVTZL6r6PBzohft9/datrMaRNc3sD7ngB2qa1nTrJodACh?=
 =?Windows-1252?Q?aQg6SJuZN5Yf5IPqsrIui4ja6wXmbE6haYpW75VhPVdkMvpQfiZIDCL8?=
 =?Windows-1252?Q?5m2u0iMHaMqKH7fdNvgSBq0L6QaDSbYsh7N80SThXes0WzcmSNFmeNxd?=
 =?Windows-1252?Q?CreVPijln7z22HWlBD9bGU2eka4JkUWXADPL9DQRSQqbfVkB4nLjq9Au?=
 =?Windows-1252?Q?a9/hOkFR3C2OqPAJwd7m8wBvMEoYejomUWpZjTugjIZMjRXsIU4KgW9r?=
 =?Windows-1252?Q?ZYLuO3j7xrl0uPv+vAlZMhZ78el65gvmCaIySx3WL/UsN/63aYrRVcmA?=
 =?Windows-1252?Q?7qvIdDE0H0XdDIeAODziu3DBftDFfPuqi9gHf7iyZ1W2bHxltXa4xk3R?=
 =?Windows-1252?Q?wcZ9dhaULMzQKhFJAG9Mjqz8L3/coDYaAbc1dqq8h6I9/RQjfJ5k0bJ0?=
 =?Windows-1252?Q?0tLghBABGVHkkJcafA1H0MKcBDf3ie1NUOAWPVQnCTuOX768lp91DKqD?=
 =?Windows-1252?Q?o1AI2POiNk1aUFTRqmbxAxtxGQeuCe6XolIi32i/ITd/VU8cBxOy3ZNc?=
 =?Windows-1252?Q?TucmJBoYB0uNC7HJc1yMHicExgMakw3MiptO4tI99WjgVa2rTiaYaTc3?=
 =?Windows-1252?Q?HiDBHf2h2WOOuC2++kOcdVplUXebca5+zMIDQw2fZ5ceka1R8CLXc5pP?=
 =?Windows-1252?Q?rkKWq+vmnPgDrVxGF8lGSixasRi0Xgeu42rCT3Th1LTttAU8dJHcKj3Y?=
 =?Windows-1252?Q?ZcoJTlhWy2K7tlytGqC42IzXYgsaUVnY+xCeMQnJxZeeHKcvaCd0zWQW?=
 =?Windows-1252?Q?jISKX9V7RxQ6abyMoIF2DQXFK+SEXK5yXIL70KsMijLYFsZeg1Sxgc5I?=
 =?Windows-1252?Q?wbVs3B0do0aq9WvoWySSfOKU3zDCykAqNdCB38JW809In3QwznifYQkR?=
 =?Windows-1252?Q?dIWUOx3BJ7/yWeHZg0JGjddhT/8bf9j65aqkJdiD3fc44fWS7XBwlLSK?=
 =?Windows-1252?Q?ZCWyAfjunbQaXKcHesGwBhlWttTjx2dx1LxaAPxlp1X+0esIoXsaKZBl?=
 =?Windows-1252?Q?0wUY1KSC2WhevRQwYlf+QaNH68Q0Lw2GJYVMw8+boZDssk0aFT1iheKu?=
 =?Windows-1252?Q?hxtGFv6nj2tH3pPJX3RAa2Vq4oDUz4HKGwXx1Qbn1zyUGZF4y/zjhs1D?=
 =?Windows-1252?Q?odk8FLfrWVwxB0Np0y85b7M/VXpnMAjxRod9esg1jFEfRP5mRCUiMBam?=
 =?Windows-1252?Q?LGpJMBPXo8SkUvSHUsvUyp74KPg80gveNFhLVTLHR2xxP0yV0+oPf+wN?=
 =?Windows-1252?Q?lwTsH7OYuDjYS/QT2i4FqUB9AFaOnEI/s1P27ISWAQwnFmDGNJtZ64ET?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 333560f2-a701-468a-34d0-08d8e34424e6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:41:49.1082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsjaG7olauGiwbr7DYI9x4KLUep9MQVBNSw25XpUwrEenDl/hxNp9hrARvhCtBJgKcZLPy6mEs2UkduUGNHeQFPiZ5gcwa00+NJzqnkrITQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2021 15.27, angkery wrote:
> From: Junlin Yang <yangjunlin@yulong.com>
> 
> Fixes coccicheck warnings:
> ./drivers/net/ethernet/freescale/ucc_geth.c:3594:11-18:
> WARNING opportunity for kmemdup
> 
> Signed-off-by: Junlin Yang <yangjunlin@yulong.com>
> ---
>  drivers/net/ethernet/freescale/ucc_geth.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
> index ef4e2fe..2c079ad 100644
> --- a/drivers/net/ethernet/freescale/ucc_geth.c
> +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> @@ -3591,10 +3591,9 @@ static int ucc_geth_probe(struct platform_device* ofdev)
>  	if ((ucc_num < 0) || (ucc_num > 7))
>  		return -ENODEV;
>  
> -	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
> +	ug_info = kmemdup(&ugeth_primary_info, sizeof(*ug_info), GFP_KERNEL);
>  	if (ug_info == NULL)
>  		return -ENOMEM;
> -	memcpy(ug_info, &ugeth_primary_info, sizeof(*ug_info));
>  
>  	ug_info->uf_info.ucc_num = ucc_num;
>  
> 

Ah, yes, of course, I should have used that.

Acked-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
