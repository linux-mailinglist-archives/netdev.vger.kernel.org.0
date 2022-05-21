Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F75252FC50
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 14:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236619AbiEUMSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 08:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbiEUMSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 08:18:04 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2132.outbound.protection.outlook.com [40.107.95.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67096CA96;
        Sat, 21 May 2022 05:18:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Syj7AukykkWib8EtDIyUoXZRm9iW84x1gnQ1uOza53BFqSW6nM8ZLdAJU61DoIzP5wVJSENXRBbyhSEBEKUByOF9zi1ctst6zQz+6Pvj+UlpE1o8taLcbKCeXZKLL/BRxzUgkKHeeQryw9rhHhoN/SRbs7IBSKK74ygc2ddAKcJ/jtFfsFy6g+wkYTlCuxGH/IQ4eXpJ1WxRd+E3pNZqqBaQINQ8MO7K3P98kMLIoEtyramLy0BfeQqHgLjdAmFJkuuZU1nV2MO/qhqb4k7EUutaqj4vDJmrqK/7RKpLi1htpyIUwpsaPwECO8aKHyA3AD3hxN5PCfZFWaO7HQYtLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzVqaY8FPi8oigo2LCFJzCDyNOSZF4A3IvA431j3AUY=;
 b=msyPFy5L1cX/9Z11qoILw4HTscAADibReej5WUFNeb3RNwEWYSWihZZLaH9sfGKOq5Hyzrb8uhAkq1tg9fgR+F4OfKZfJyIIQonwIq+5UFLtm29fvMynSgQD6QIMb5TCikGp+f0aPDmALA3Rho6AaKUwmiw4ukbMCaBHAzVGFYVJ3gSbwjIxPFpww+FH3KYt9LQiNh9QMXsCcgZrzNZGI4T7dzdu25jktz3Bg3tJkUfDeouljqYbJPuVZMJhv5JHn1kRCHODtLEIV/8O4XCpA5bKZzaOkFWHFVvsm8eDNhFTgoPpvM423eyT0hVTJRZ6bXt5EqJCq98nNpimfCiWQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CzVqaY8FPi8oigo2LCFJzCDyNOSZF4A3IvA431j3AUY=;
 b=HX5iJs4mozgR86kCEIFr71TPgcJhUDH7EhwKHJMGLE+MG2kkM7CpXR+kkLuzNJoZulLFTlPU6JbD34S2bbI6XmMjM6Jhrz/qKTrda3mMjXOPWYFzZELRLlRuwLkFbZqGln0yFkWZbRMM2C5y9wysUFM29ammb6PV9sDQB8aVKzM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21)
 by BYAPR13MB2758.namprd13.prod.outlook.com (2603:10b6:a03:ff::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.7; Sat, 21 May
 2022 12:17:58 +0000
Received: from DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::4d5f:a0de:1d6c:1bc9]) by DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::4d5f:a0de:1d6c:1bc9%3]) with mapi id 15.20.5293.007; Sat, 21 May 2022
 12:17:58 +0000
Date:   Sat, 21 May 2022 14:17:51 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     Simon Horman <simon.horman@corigine.com>,
        kernel-janitors@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, oss-drivers@corigine.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: flower: fix typo in comment
Message-ID: <YojYbxmE/fGmom9N@oden.dyn.berto.se>
References: <20220521111145.81697-73-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220521111145.81697-73-Julia.Lawall@inria.fr>
X-ClientProxiedBy: GV3P280CA0010.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:b::11) To DM6PR13MB4431.namprd13.prod.outlook.com
 (2603:10b6:5:1bb::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19fbd2da-8755-42c1-9a9b-08da3b23f110
X-MS-TrafficTypeDiagnostic: BYAPR13MB2758:EE_
X-Microsoft-Antispam-PRVS: <BYAPR13MB275815E230A573CEEF14F832E7D29@BYAPR13MB2758.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqA6/wP7so4uAS5S+pHBRHGtCrcB9sjXRge8Gqs4tviGMdIGJp42rwhQ3jBQ2BKw14yDoj7q2d69R8/WJWr3EY5Yd88z4c63nXSiW1BcxqKsj1tHOhIIHgAN1PudNUgptsQrYxXUEKmWWzJhxAd6EBNL0E+wQfIgEXAMMikOREEqbeD0pzWnEBAhwxjtAg4GRV+d0XsSwmc41Ay6aBeK/JO4RRfXM55F+RmwHYS5jDplBpG/smNQ8AiM5jItpPBFaQ3LsrkblP+rttJ845cLCZ20t45uY54L/D8iygRVaE/ibC84AHEjEqD3tnO8TzfZZI3Fad0zVdJ/90DKhTxUq/sPlX4SCJ3x+yg46p8Qhwz1zLJpLHjqChkX0dkLN5MR0uiQNl3ie5/YWwm6Cs9og9Ejy8THwDbssIoGmPzx9V9vH9J4j8yE4nc1UiPwA7Gj6p0lYaKyp14ucCP7NqupTNK7r/9cn1qrAwj3ph7LQ254IhhEzOoTJS71cVq/7+7Bum5Y4/woNrGn3XZgyJWRXwp4Ep7ja7/lNGy/lB/FPEuCwK5Qt7hSb6eHybTVbVDqCGk98NiyvJ/Kh3clUsUP5tfvJgbEcBw7MXTIB9Lelh82fnX6NcgbL14T2B6g+MS7+HqPZwKa5Cjle4N35OThANnEkBs+dgMW/1CQAq77M1650t67RcmtFICHJj91pKVb1u8jqMY6zN2twNLqwKOhQ82fQojsKuSFQrF1KhpppIDWsbTIbGWw2zxHA466Bv2N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4431.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(39830400003)(136003)(396003)(346002)(376002)(186003)(86362001)(66556008)(5660300002)(66946007)(41300700001)(53546011)(83380400001)(55236004)(66476007)(6506007)(2906002)(8936002)(4326008)(8676002)(52116002)(316002)(6916009)(54906003)(6512007)(9686003)(26005)(38350700002)(38100700002)(6666004)(508600001)(6486002)(66574015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ytlrFuGyyq3bI4SJ8G37AkJlk5yaSs9+3t2kbT5+YoPfn9UhIudGWpisOM?=
 =?iso-8859-1?Q?uiL0Hfrx7v+Fg9deHTBiMeVMfNQYWspynohhPyEYQwEMoyZlNMjOOG51dy?=
 =?iso-8859-1?Q?E8A9KvMGzX7IFmFks8HMK6dcAH63DQmmPhKbM442C9iNvt2X7z2Y8Mz3kW?=
 =?iso-8859-1?Q?f2HyHi30p5Sb+iT1CTUhh3QTuCyaplOEtBX+mpRyJ45ngZsIikiJPrIdxu?=
 =?iso-8859-1?Q?OjvCVibR7uxlrdbO+J/Zb0UWed9Kn8UOWbWSZKeJU7WS9lwkZ1BGfMO2F0?=
 =?iso-8859-1?Q?VH3IEkvqGzxad5BVmOf9IGxuBViVRYDsLLw55Oi5nhtgQy3MKdvx7trEny?=
 =?iso-8859-1?Q?XHmHWctjb+hxj8QNNyVntN0ORjfYOSvDxE83uVozeYgIQQxOZevbUmarTT?=
 =?iso-8859-1?Q?9OGU3ClczBYUhuBl1sH5jSbVZ3kBdCZRQGhOhAF1ZO6pwkZBBzEQC/4NQF?=
 =?iso-8859-1?Q?vv1d3BPEVRU6El8jCtejoD5uT2Gzlv/Zll5IDiqrMNcataaO01YcXCsYfa?=
 =?iso-8859-1?Q?ltl0tHfShCt943udQAAjqk7O3pUEobFgGMuYRbShA4olJUYtGEjhKBtsGZ?=
 =?iso-8859-1?Q?+c7zOFTFmmX+1ybeWIuBZbEKhoBjdxpv4bsgeAfkKAI871tdyTaq9O+WY3?=
 =?iso-8859-1?Q?3jdQY1doeKGkoaQKJZZiD8feSsXaGkDWzS00IlcRYTYsyWioYDjDgPZ9LY?=
 =?iso-8859-1?Q?UXUHoZL1HaTH6TT5txjQI132rBk8nRfUOzNPrbiF2DsWxOlMRwT9L3LaZG?=
 =?iso-8859-1?Q?osFqA2t5Q7h/2WInJ6BYmGIaX1ieRvpniBQAkV4DCDDUOjtlXFVuuBa4CI?=
 =?iso-8859-1?Q?VhmUy6WYoDRAvf5jQJ/jRn+XwAhhi5dFfVj0I1WqePu1k9N7xf05b9oxmW?=
 =?iso-8859-1?Q?BSscNTck2xczpQ2y9yz6mA8Jb0Trp39hUkOzOgpmu9Pgm4i3v1zVVnY8Ag?=
 =?iso-8859-1?Q?5e00TboSWNN1hfkv5LIkYKZjbYSoEbFaxl1Wfh+36lYJ2iLRGdvJIEuqFl?=
 =?iso-8859-1?Q?Av0peDFuUZnSX3lFr9oR6SbpBUSLIKdexp/n03upczTGFn7WU7TUpLKcZU?=
 =?iso-8859-1?Q?U7Oqk0Ttrq9rbdV+AWxK01cDrzcMPKCBxSQvp0qfdZkku7dsc4shDAFvga?=
 =?iso-8859-1?Q?v5buU/jTfEEA2SvYlcLxYQaeyG4Sq7I2wFYDv0EjohLHYvuIyEhvumnQQy?=
 =?iso-8859-1?Q?4qhAsZkM8j1LfrgcyoKUTu0OUN9sYQAZpbzGnavuPU7wH/jD4Vu/fDi6ux?=
 =?iso-8859-1?Q?cf/5ggg3Rt0HOMiTzm5zddxkHJXFejIYIwleYLunAzHA7n2T3IQ23CD9+v?=
 =?iso-8859-1?Q?d7dFNdkIOMImpLzz3KLih8KyQoGrUMlEASFPqYQD1FwGr6kis8N7XfUAMK?=
 =?iso-8859-1?Q?vO+icoLN3+MgmyzoUI3xlf1qysIRAhAfNgcFBbHy1dZkHFZLLBkdTXMnVc?=
 =?iso-8859-1?Q?o6ux4KsDuwOpQMLHi8SrdH6AMvWUpf41iT9tLyqxliH/8G7I9Zy3onayKl?=
 =?iso-8859-1?Q?EgtVXFaKLvgrSvrmxz/3nw5SG98PjOfIcnbvopPtwOlV1IlfDjKIefWJH/?=
 =?iso-8859-1?Q?O413ehFJqn0pTdRyN9p0Fq5w8CJuKzmHVbbnrDcfoD/TXh263XFpV+uAwP?=
 =?iso-8859-1?Q?Ey1If2+CkD3Yp9pVGEZgUUTbFA3NHGXYiibtH/MXRUERWfJ8yZdcDBiKIe?=
 =?iso-8859-1?Q?YBQLNQzqapY3jfKbLeTpeilVZ2gv1GNENVUhumjXrHYabJ4Hzlk8lhBTh3?=
 =?iso-8859-1?Q?xEy8r6HwDkjWNXqtOQAsfGV3fe2bq76fcUt4spJpdf4VxZkbC/8firGM8I?=
 =?iso-8859-1?Q?PYiv9aG/C91DjDKWeMNZclvIY+ZPJWc=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fbd2da-8755-42c1-9a9b-08da3b23f110
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4431.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 12:17:58.1731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWbmWE+I1WtlQw1Vo9qhOHdmiscTw/qsqsOTF1mKjrsywVCMwRsNiMyFFnCElyWfmlqNhJemkszbcrqrYsPnLrfxFaQW85K+X4fOxCro1Og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2758
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Julia,

Thanks for your work.

On 2022-05-21 13:11:23 +0200, Julia Lawall wrote:
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>

> 
> ---
>  drivers/net/ethernet/netronome/nfp/flower/lag_conf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> index 63907aeb3884..ede90e086b28 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> @@ -576,7 +576,7 @@ nfp_fl_lag_changeupper_event(struct nfp_fl_lag *lag,
>  	group->dirty = true;
>  	group->slave_cnt = slave_count;
>  
> -	/* Group may have been on queue for removal but is now offfloable. */
> +	/* Group may have been on queue for removal but is now offloable. */
>  	group->to_remove = false;
>  	mutex_unlock(&lag->lock);
>  
> 

-- 
Kind Regards,
Niklas Söderlund
