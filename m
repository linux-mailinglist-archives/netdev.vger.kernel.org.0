Return-Path: <netdev+bounces-3902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6698709807
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F34C281A33
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A320AD35;
	Fri, 19 May 2023 13:15:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9478F4D
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:15:29 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2115.outbound.protection.outlook.com [40.107.95.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962749D;
	Fri, 19 May 2023 06:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0h5J4hoT/FcAtPcwO/IVg9TQC/7/jrM+dXqBp438zBDBPrghcSVrgCUL/xceLbo7V3PKNzOopOLnffoMje+pjK55AsrOmSU69V12n21iAIqaEDZCTRF0FIQ0xcfHM14LFdX/OUXR/ZEjmWAUDMf3UciKNZBYwWl4fL9bjHzGTATgUhUnnwU8EIpLilvk/912HiD4BQTJ+zi8c8iUx+OtfxB071djLomwfy8EvLhae/qqPR0LF8CrphHAvvcLzfSLg5ypacUbvcq7BGJm1r6UbxGK6jFpYqb0CkmxnFXmevyB9zU8LYpAkcKqGwvVKnq3W49YUH/Vi2cj/noA2i8JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Oa4FMAfh6YdUVQdR0CZB9wHrOW7Ubpi1Uz+erDkg5I=;
 b=JJGlObhSUEHzaVS7GSIt+aTzB+mEZDiaYxJCDIhGPVzJNxSgPJw5idO2sKCHVsTX7BGeIf6qmIhcAwCu25Xdf4/k+TiAGOoJfda5JADGePNRlMbzz2zKu0qM6YIhqk+1D8HwuUZqiyZlUbIYD7SE6Pf1cVI8QFq791W+yxbhXnxVHJY5dI8gkUV9rJPkUusUfQwogm9dK8o/MJLEZsKi/nP7cUf7aqHh0yMD4Yj9ci1aHWP1lB3oAf3mBd0LADt4aTaROEkgPz89Jp+ktLCpvav5EX82l40TWz1MJKNMApn6Hnoy4n9irv2rgScI8N/KfBBCvc/87xuhHrCL9UugoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Oa4FMAfh6YdUVQdR0CZB9wHrOW7Ubpi1Uz+erDkg5I=;
 b=ji/C5q1590nWkKDI45VqMpKTS+a0uBm0saixf4YeL81m9eQ3zwpzziElC2VOcmlxM9lwtHWCYmTJu+TqbNp4hFLpj2AUSZcx9THcukcYZtcmCr9pGzGLv47H6UdMAGqMijFPRq3InSJ0Jr1OQidyukW4nNBBmKRTQxVFcdPpMa0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5530.namprd13.prod.outlook.com (2603:10b6:303:182::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 13:15:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:15:23 +0000
Date: Fri, 19 May 2023 15:15:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dmitry Safonov <dima@arista.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Bob Gilligan <gilligan@arista.com>,
	Dan Carpenter <error27@gmail.com>,
	David Laight <David.Laight@aculab.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Francesco Ruggeri <fruggeri05@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Ivan Delalande <colona@arista.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: cipher - Add crypto_clone_cipher
Message-ID: <ZGd2Y/EU30Yxw6kZ@corigine.com>
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au>
 <E1pzvTX-00AnME-24@formenos.hmeau.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pzvTX-00AnME-24@formenos.hmeau.com>
X-ClientProxiedBy: AM8P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5530:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a2cf79e-ceba-4432-acc9-08db586b1a90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	u6fx72uO3rDVtJkeS82sXtDvSP5tHWxHBEHw8yzg4DLu+ttOGBnjPbf3gj7ZK+f1fpas41gAu3uAj31xg5c8aOPLf6unsQ0o53zCewx/iZI7gQdjxa78ifHiU/0aL/gtN7Nh0nNBIBxpbhY7W9jIePYbrntKgWWyhNZ9Dghx8+CkuGX8xIVDPHGCGTmxk4N4EIDg2k06gMuMLQqOEJHzef7PeKEQVHFkWc9v6y8J6i1fbssJvg7B5Rwa5DghCjBUnVTyS2SPYilnMgwm4Ciic+sqeS/VA6xyQu1zYeBFW4g9PR2z34N0IaUCT1QZf4bVWdHKjcaQZ89BYTJSaBrzRbVF/7xMfEo5sYTSpORrASlI1lOH5pjh6Vs/o6PAUL/KDjmPTmRkIoPLBPQpXhBSU25hspNu9SxXBlkvmR7mJdHUVnxt6pHzPIuoKqe5ihoXVBBCp3HEQC1gtunZkSGCrlmtZwM8VUHqotlInMr9XPqInata/JTDvEy/H8yr5VnBKlacWrwa+le3QM6SS8ZSwuz4/a1kvAT3Wk7/PqlBfSjxDaGKhtZVKczFx/tvFfFA
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(396003)(39840400004)(136003)(451199021)(38100700002)(36756003)(44832011)(86362001)(5660300002)(7416002)(6512007)(6506007)(8936002)(8676002)(2616005)(2906002)(478600001)(186003)(66476007)(54906003)(66946007)(41300700001)(6486002)(6916009)(66556008)(6666004)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZSZ4eqW6aRRok1pQKQuI8O6AVDSHub0EYJaJ3tIYv+S6XLvMnim1CofTsRpw?=
 =?us-ascii?Q?s+MD0DHxc0j/TNqiq3V43YWrFeoPCOTuoffcWQMSRfPwYDfCzq36C9jQIkqr?=
 =?us-ascii?Q?HiiimjXPqTujY2TYbqGVDch+sX/htrsC4CbJ9YFarcH9Oz/37zUw4fTHUtC/?=
 =?us-ascii?Q?8s80NezdjyAjDb1PDFbjKvlpzY8soYUR7Za/GbdjRJdsIupCGQ/wml7/0XTq?=
 =?us-ascii?Q?e7jAreiTg4yZMgkrghS7KlkX6Up9kY8WUSXr3llr6JA+oWE8xlGKO+uhvarg?=
 =?us-ascii?Q?aDXQoyKUd7p6fWGi5B1KYhcLFEyQe36EMlba4A0vgEoJzx6lZRMAMoGwh8Gp?=
 =?us-ascii?Q?m9Tbm+g2tvLerAHqGtDKR0t1C2UO9vFpcXmXQWNzwEIBCV8C7LYXjlcYQspC?=
 =?us-ascii?Q?cNixbY9PzSrTHQUB4Hm3m4hIlHyXgypUdW2yUo4wtMB1jV/cIlWOM3sHT5Fj?=
 =?us-ascii?Q?Ci3AbTEdCisrSo7mxxsOh4rQjJVq2oZWgTdNTgob8kjoDe+8hDB5CcXmVN00?=
 =?us-ascii?Q?IO2vMMRmouyJXbXlarXHYZxiiJNfe3hmTzpUrAmCGMK1gSF6SGWr9dtzCAdC?=
 =?us-ascii?Q?fmBPar6lTcd5mQAyVF9SpZqRxlQK6DvWOn0T9zuGh656zrBRmlR3r0GvuHMg?=
 =?us-ascii?Q?iNGMAwOy8Is8FApbh47z6A2ovMBqfEFLmk1zYG6Fgwi+R+FvQpLWPjccMxFm?=
 =?us-ascii?Q?TBRP5OHHLpB8BXtWNQXer37nCUiWJc865M1VyHeBMGgaNS/Kj02DVt5axqFJ?=
 =?us-ascii?Q?rB1WDXFjrpa1kleTlFnHXnOFl5cnL2+hjrU7w12d40bsIaJA8l3qAPrY4A7j?=
 =?us-ascii?Q?Adg/cicT5U1ICi059hZrFNKxtaNthKmBqih9kzfUoqGs/hQdHnWYqw0ieWaH?=
 =?us-ascii?Q?EeOCH4Vl/YS9HTxgExdOYp3YDvbWQufRaqJId/F9xtB/2L6XM4rBsqykCXtQ?=
 =?us-ascii?Q?A2OQOe1rX0ZH+SvT4R04hr/G+7J3zKaf+5MZQ+6QpFbFlLonI08Tqqh+e3SJ?=
 =?us-ascii?Q?VK0ely0gaSNNC36O+dOgpLKnogr0DGUxLwqVaixKImxL8UKskvNGtKA0nMR2?=
 =?us-ascii?Q?Dax5OEdJiPyu84m10kq/WkHx3rEbZBBg7MyNTVhPgflswt9VP9lf97Lv+C/1?=
 =?us-ascii?Q?1n2+Hoif9kaEJvhtp/i/f4tpbcq+J7RzJllBUw1FRWe238BevYBOoRpbsSfI?=
 =?us-ascii?Q?8J/16muje4EFMA9K1LQ5aZ/AY8kACfFjHtygJAhOA6WqFNOxgEp1hDn6Pcn9?=
 =?us-ascii?Q?YksAIIBBLLAVOOqflDrPMfZ2HD1zSWSCXZ/Ag4RSNNPYqINPQ5oGoXjSODM5?=
 =?us-ascii?Q?VlNPEKgKI/nMA0jNeFq4jJ6T+MOBBn+0FbgqntRfztGWDc1xLIETbcQBLA5q?=
 =?us-ascii?Q?JtGyH/iLuZ6kQAzwqPB//qfi/rgXlI5NjTUhR7WbBQDs6HCmGHN3L7lLBnYl?=
 =?us-ascii?Q?+Xkdt1NJMYgDEvKxIk1e4yzvIB33E/dU0+KpXoKnt2bHrsyHaIJOl26Nz65H?=
 =?us-ascii?Q?3i+ulutziYyqNkc5MMuUQe0GUNsGzgp6Arl8zcSm1lQP8SJpLXEORGb5Ame2?=
 =?us-ascii?Q?MKhSpTG39n28FYSVLbVTmKV4YH+Wsp2gxrm1pPWADfCAPZITS8WsH2rDfXmC?=
 =?us-ascii?Q?e/Gkmd3lpgFVXG6kbTskRJqsldhvBFUXUf6OLOn8220S6P821Bpq7FObfuCf?=
 =?us-ascii?Q?syg4rg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a2cf79e-ceba-4432-acc9-08db586b1a90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:15:23.6157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hY0XOEA1IFRNxADxN2UXqDGBFXjyUgDmNTyeu7vsmA6ndu47swtTo84oXItYj/E92tbFlyjHuU2FmQdqYO8ELrnX27lhN/bYxkrl9T6VO5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5530
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 04:28:35PM +0800, Herbert Xu wrote:
> Allow simple ciphers to be cloned, if they don't have a cra_init
> function.  This basically rules out those ciphers that require a
> fallback.
> 
> In future simple ciphers will be eliminated, and replaced with a
> linear skcipher interface.  When that happens this restriction will
> disappear.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  crypto/cipher.c                  |   23 +++++++++++++++++++++++
>  include/crypto/internal/cipher.h |    2 ++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/crypto/cipher.c b/crypto/cipher.c
> index b47141ed4a9f..d39ef5f72ab8 100644
> --- a/crypto/cipher.c
> +++ b/crypto/cipher.c
> @@ -90,3 +90,26 @@ void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
>  	cipher_crypt_one(tfm, dst, src, false);
>  }
>  EXPORT_SYMBOL_NS_GPL(crypto_cipher_decrypt_one, CRYPTO_INTERNAL);
> +
> +struct crypto_cipher *crypto_clone_cipher(struct crypto_cipher *cipher)
> +{
> +	struct crypto_tfm *tfm = crypto_cipher_tfm(cipher);
> +	struct crypto_alg *alg = tfm->__crt_alg;
> +	struct crypto_cipher *ncipher;
> +	struct crypto_tfm *ntfm;
> +
> +	if (alg->cra_init)
> +		return ERR_PTR(-ENOSYS);

Hi Herbert,

I see ENOSYS used in similar ways elsewhere in crypto/,
but it strikes me that EOPNOTSUPP may well be more appropriate.

> +
> +	ntfm = __crypto_alloc_tfm(alg, CRYPTO_ALG_TYPE_CIPHER,
> +				  CRYPTO_ALG_TYPE_MASK);
> +	if (IS_ERR(ntfm))
> +		return ERR_CAST(ntfm);
> +
> +	ntfm->crt_flags = tfm->crt_flags;
> +
> +	ncipher = __crypto_cipher_cast(ntfm);
> +
> +	return ncipher;
> +}
> +EXPORT_SYMBOL_GPL(crypto_clone_cipher);

...

