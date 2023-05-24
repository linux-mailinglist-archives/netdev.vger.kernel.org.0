Return-Path: <netdev+bounces-4932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3421870F3C6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0A6D1C20BA6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65212C8F7;
	Wed, 24 May 2023 10:10:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E36C8ED
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:10:09 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2108.outbound.protection.outlook.com [40.107.93.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D18119
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:10:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhWSnBvK4fL69oyBFzaM9JEhEihPyZhZI7o5OqpAcFht9uHe1cStl6vzyZlKobhn6qrd7VBXSZS5O9b2h6aJXJnLo1SDRCc0WeksDnXkX2PmxMOb7De/Ah/OMpwWPw0Fw9xakfP9cRXDDPQsBOFYKOJuo7Dl69oHT3bZzDq8zGNCXHGfzto05pIjxAi48TSZzeUkV1YPC1X2FEjCVMdtxXzDK6pjUGRmgDzhd0chXbvuShXQH5QjT9rFn4D76zeg8TaXHIl9XXTB60OwDbbbWJaW/uaBk+rICQM5lbVj0OhCmaY9tt/FmaKl3WEU2pAGQdVUTQ3LuEn6CqURTkBqKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4XvkeeqF66kkp4wPAlroDjWXh0gwAjLvmCFVCECMFg=;
 b=bmsz6XEGoH4mZjwm1Optg53Z5I0LhCGrG/slVD5bHcarRo0yiT5/Ctt17a0M52mRSTx/m6d7TH+uZdBa69XSS2Y2SqdCtxMGykV2hYF+NlQyWhkEs0h/HzBlw3X+GydOzoCzCE+Ll7qtlBanXu1dFVcKGIxCtFxoXLmyv8NQazehfGLy6kUkThbkSX/whyGRx7IKFVBWwq1S3X39+L7+jpUPN0xFV3CjEVJDDBhCQ+cXQrINQDzzwf4VoSYlaAear7n/ypIRWpQoksPlNXo86xyvM+47EDubwpWdnBn8XsxEPH1RmicU+gLD2OcrW25ysXiSnA7P2VPBE2QpUl/GlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4XvkeeqF66kkp4wPAlroDjWXh0gwAjLvmCFVCECMFg=;
 b=hfHgMwkgq8uwvhJi+QOXKUzuPAkwlUx6HoDtBLsyt7Z1eTO4+X8pacRUu5mSmVgFuniaDBR41eFYil8YyDwKoYns0Ld0qL674afbVVYR9f8a0Ur1uYIWDyNjpcEq49MIky/59TNvaz5SNRCRH02NC/QUvEuuoTZYsULgOcUVBgQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4901.namprd13.prod.outlook.com (2603:10b6:303:f2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 10:10:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 10:10:03 +0000
Date: Wed, 24 May 2023 12:09:56 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Subject: Re: [PATCH net-next] sfc: handle VI shortage on ef100 by readjusting
 the channels
Message-ID: <ZG3idM6bQmF0Bu69@corigine.com>
References: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524093638.8676-1-pieter.jansen-van-vuuren@amd.com>
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: da2f2c35-2eff-4311-23db-08db5c3f0a57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Hp7HHAEJNqwxV/jqtAgqTQZWdU+5Al5NjBlT9B8Hrrfi6pAl3ucFA9TEfaxzOkeTd0yCP0LNz7w57VIBJYkfhVQKOk8K11rTLg6eXnAQuiE7lCzThMCF3ulxBZctH506piATvVSNDW83pcs4SzUuJCUAaHZ7v8mHYvV5bPuP4Op+uVcbT/dVBijgCO7TB69T+pWKqj3y60qoKtZVbUIVwNgvpKunAurqBW/+vby8w2aTseEqmOLiaw4YTv+UjVurBFHkjacs4ZX1nW9WOlB0ZFWDo9iU7dt26q5uQ4B8XHdy2P6vMbex6WJNFapvAOSQE9l4jvl9qOxmtONtL0dD6hR0kUBsk+2JyDD9bSe0hikSC1fZxqtbMqMfYLhSxAj6oEVgzZ93cnSiJvJVEGRMfG0VdbklSgeRuNkqhYoya4O6JtxHwtEl2+nwHL00ICleGZLJVYDxVSjC38mjLND5hvkTPXeo6oe6VJNlI9+/ZOVc5/05wBP6a0D1yYrr2NjGp9Oz/IX3My94gUhLsLropIHB/uTECx1tjhvMq7AvzNiYQ1SkBEouyNAO4788XXWYhCC/lDT/wnatoEQsQmwyHmXMLIfsnucZmvtQS40mZlI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(39840400004)(396003)(346002)(451199021)(5660300002)(8676002)(8936002)(2906002)(186003)(86362001)(2616005)(36756003)(83380400001)(44832011)(38100700002)(6512007)(6506007)(316002)(66556008)(66946007)(66476007)(6916009)(4326008)(6666004)(478600001)(6486002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mrz/kYpspV0ke3Ja+rz+u96v/drz+MULRvdbsWebNi1XFJyXGLIQJ2ePNXWH?=
 =?us-ascii?Q?5Gne6DBK68ExR0VUo+cE5nwo+KnBoiRM6K4yZBh4uvF9UX8VfJv8BfuhFLdH?=
 =?us-ascii?Q?faAOEUD7eXNGlAG44xKu8eJj5DVte7sjcq/Tp22yzIlU5E1fE1wjDxPLPVC3?=
 =?us-ascii?Q?LSh7Sbpr/2kTO9wCLa8t+inSVOrXaR5922AgR+OtQs9uK0r8hZTL8KB/5XkJ?=
 =?us-ascii?Q?peRXIHS/zB6nmNVBKpaGU1hxU/c2iMYufB4l9DYoZvWsZ/cu/AjSCfgM4PBp?=
 =?us-ascii?Q?w/r/QTLbdI8fpsy0OrVgF3zYPtbItDftEE9l0o5YDfxicRhx4WpbeO9Wynqq?=
 =?us-ascii?Q?BC9Beu0yOUN4Gx39KafCCS9fy5obwL1J57cAbNcer5/aDV+hy+v/vaJ4BUAS?=
 =?us-ascii?Q?BSI0j8AyZv+KFMmokUeh3tTVmRhiG3UGl1e1VbLh1XWW8YuWO+UOYCuwmpnm?=
 =?us-ascii?Q?ijdxqUbvDEdulKtX3BM7klT85wFz8sMQgpFFa7yNLwF9UW7FTKkPf8MqjDga?=
 =?us-ascii?Q?DxNLhWFAXkDZQZE24XjSLuP2BCN/DI43Uf27hk05xMT5jbA4umz3EqDipLpZ?=
 =?us-ascii?Q?DvA7eFu0m+u+xOcD3WMtM+Jk8kWUd9aLL2+4HAysWqmwLnnfayDswle60sYg?=
 =?us-ascii?Q?jb02L84Kza5vmIHoYmc8QHAdsZnQHBieMzhz/mZxb5SP4380qPgrAiDgZy5J?=
 =?us-ascii?Q?KJoCmf7nEYjWFIecDqqwH1LK6ELrom8ew+kCS9d4/f6h5ppUoF0+fage0Cvo?=
 =?us-ascii?Q?Bv9g6V64marimpkbz4lt+Xife7xpGwY9n0Pfa3DIi43RLMR9jaePEKTNabgS?=
 =?us-ascii?Q?2RGhe80t6qjxQHcV7AOflMHZNn2Ce2hglnHlHvqTuAFRqJ2JCdzjiIg31yHx?=
 =?us-ascii?Q?e75V60yQEfop13MOgDBRVWEM4Oa9axYcm8uWQzfxtNI85ItC8yx/VeeEH1wZ?=
 =?us-ascii?Q?3+ZHdR3SdjnpmzIpSF6G+/4BuDvUaXVgWaNUIC8iGT30Qoe/CgQ8FOPzMUSh?=
 =?us-ascii?Q?ufoucv+wXZX87SuM2kWD+Gw1bVABsqPRLZRyLjWQpyZH7V+tnamMFeIXpM04?=
 =?us-ascii?Q?8jictqGdibqm6iUiDck1ZlwGCLrPVx7+vcvEKJsNyhTwhkrXRGiFUCIreuze?=
 =?us-ascii?Q?rLm/s33U28DePQMB1wF9kVW3qiQgPSozSKQkmPGMRvJLRQS1lqSODbvVg37L?=
 =?us-ascii?Q?UlZw/KYx72yCoU/utBFRFKT3BS2dSF3CN9JIjIK0j58p13yMbJ107YqRtZck?=
 =?us-ascii?Q?lOVWG5NWSukFJBQ9g2nC2uHH8J5MZstCkvc+86jbyzBV7OXwv6fH6NXIO7XV?=
 =?us-ascii?Q?J6AYJ98ONbWJhx6vCftHt7nfAPxomVatSXK8bgjgs5/JoHqGtHhP1zwILwrY?=
 =?us-ascii?Q?Y+i9SYUHfnAVAYwYfgVb0qPnx3tZvsWvXDXNM5K/RQWdxEiSEP8XOR4Y+de9?=
 =?us-ascii?Q?h5XG3T1WZO1TmlFzpKAWlDZs75U3hrxd3J1rJ0A4cB9sKpiaG+sMQj+SBOPv?=
 =?us-ascii?Q?hoUkP6cTryMMslERrp3bBaB+YlIwVun9TKIXkBdUROTkWlH4uvgsWNaozGMV?=
 =?us-ascii?Q?htPkRgH13wjQl0LDR/LSiG5tDVvYhRtsOKCVpfRZxdDCDz0blX929pPpVeBH?=
 =?us-ascii?Q?s50N7THNDAZmdEyMZy2aF2StT/W1iWAoYFIcV4LoOboWd2dVdVDqSGfO10SR?=
 =?us-ascii?Q?Z92yeA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da2f2c35-2eff-4311-23db-08db5c3f0a57
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 10:10:03.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MeAqs3nzj/Kz6tIv4t3qoMqi0JUkvv8OHZLhNoi1rsePJo2lw/rQrFXU2FZ/oLNKpINUgCnHXSBByHhhe0o3FUmI7UVtnnhUjxXm7fXPPu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4901
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 10:36:38AM +0100, Pieter Jansen van Vuuren wrote:
> When fewer VIs are allocated than what is allowed we can readjust
> the channels by calling efx_mcdi_alloc_vis() again.
> 
> Signed-off-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Reviewed-by: Martin Habets <habetsm.xilinx@gmail.com>

Hi Pieter,

this patch looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

But during the review I noticed that Smatch flags some
problems in ef100_netdev.c that you may wish to address.
Please see below.

> ---
>  drivers/net/ethernet/sfc/ef100_netdev.c | 51 ++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> index d916877b5a9a..c201e001f3b8 100644
> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c

...

> @@ -133,9 +140,41 @@ static int ef100_net_open(struct net_device *net_dev)
>  		goto fail;
>  
>  	rc = ef100_alloc_vis(efx, &allocated_vis);
> -	if (rc)
> +	if (rc && rc != -EAGAIN)
>  		goto fail;
>  
> +	/* Try one more time but with the maximum number of channels
> +	 * equal to the allocated VIs, which would more likely succeed.
> +	 */
> +	if (rc == -EAGAIN) {
> +		rc = efx_mcdi_free_vis(efx);
> +		if (rc)
> +			goto fail;
> +
> +		efx_remove_interrupts(efx);
> +		efx->max_channels = allocated_vis;
> +
> +		rc = efx_probe_interrupts(efx);
> +		if (rc)
> +			goto fail;
> +
> +		rc = efx_set_channels(efx);
> +		if (rc)
> +			goto fail;
> +
> +		rc = ef100_alloc_vis(efx, &allocated_vis);
> +		if (rc && rc != -EAGAIN)
> +			goto fail;
> +
> +		/* It should be very unlikely that we failed here again, but in
> +		 * such a case we return ENOSPC.
> +		 */
> +		if (rc == -EAGAIN) {
> +			rc = -ENOSPC;
> +			goto fail;
> +		}
> +	}
> +
>  	rc = efx_probe_channels(efx);
>  	if (rc)
>  		return rc;

Not strictly related to this patch, but Smatch says that on error this should
probably free some resources. So perhaps:

		goto fail;

Also not strictly related this patch, but Smatch also noticed that
in ef100_probe_netdev net_dev does not seem to be freed on the error path.

