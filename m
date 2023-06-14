Return-Path: <netdev+bounces-10763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D001A73027D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BC2E2814D5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5FEAD49;
	Wed, 14 Jun 2023 14:55:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094C38BFB
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:55:38 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8BE1FE4;
	Wed, 14 Jun 2023 07:55:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrmamxjZrpbVkW+3815f6cXepyfGpF6TaeB/B3OFWQlEmmG6PEqLxPi5mfVQ0FWYLxLwSKdxr7Ee0j0lzi+KV6V2c7DIJIfk30NWsB4rNUB8tguesTDRtp4YgPuOr7VsOx4g0gfrHighFSxniHutnNvsnpnw8MzjUz6aX+0v4Tcz2y42c4jD1x6owehJAKVRJs1TARWL4anG/qGY1qtVrbhPtra09l/fZM1GNyzY6G6xCm3Y77JAsa2dmxs0JXkI1GqTyKW/1PZxvmleBq6Aqv6T2zOIut9pMQkTPGYzESQkKZTcaZbfjlglRGx0VTLSCxnPhAjrEMRJZ9EUoi2nUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCNv1PYhHrDGAsnaeCsqFF6EjSBNWX/7edqgZ23TZfM=;
 b=E+hCUXmKL/oNjQjhnVgbKGds8k5R544KDXvRHdWk+OyVd5oCUgKN8xllneQaT7VK+UNst1IsIs1Asd6LPDqBJ0OAFHDOwlT1TSYoUjC4ijvvxa815Dq44BvSTY3zf0IGYimoItCKgWCnFpp9dQMQg+L+QD7YDFSP1sg3THSuB94XyEiCMpDTUzWSJQxFX/HkSQyuDH++6KE4hkgS+BCclObO1KzZNIsmKuIByssikio55CS1MKsB64nNJjxbgcxFL9si0wGYNpKkzfSEOhRQ3l2rdjhDV1okrGMZQgKWyFFyJeNm+6XO7Llg+Vdl3CTZ7I6VZCQtQfmnGHtErTxdsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCNv1PYhHrDGAsnaeCsqFF6EjSBNWX/7edqgZ23TZfM=;
 b=gxY518YGPFYzyMOqi8FhVfNYrjja7H0HZlobZp/FmH/RzTrXTi3geGs/ndYaysQos01SI0hYAvwZrq7UCl+jZPZbWmWRqyqNJpMCcEIhvu4BUlNq/p4NTz0FAYvwK532DjXvbUc+jEt0gvKnRMvCoeeo/1esxrp9AdKjN23iluc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB5260.namprd13.prod.outlook.com (2603:10b6:303:137::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 14:55:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 14:55:25 +0000
Date: Wed, 14 Jun 2023 16:55:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jose Abreu <Jose.Abreu@synopsys.com>, stable@vger.kernel.org
Subject: Re: [net PATCH] net: ethernet: stmicro: stmmac: fix possible memory
 leak in __stmmac_open
Message-ID: <ZInUzhOZ/3TGSQl9@corigine.com>
References: <20230614073241.6382-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614073241.6382-1-ansuelsmth@gmail.com>
X-ClientProxiedBy: AS4P189CA0007.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB5260:EE_
X-MS-Office365-Filtering-Correlation-Id: 4288241b-0956-4afc-577a-08db6ce762d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OrvCS5nVYwi1OKjAQ5dGkub6Yh1DuAYk6XwT33sDn/HooP0ebTNf8MA7w7Sto7kvctkb5bRUebxcxHFdXYL0mTZHy8K5FJguqX97t9bfCbuPvf2UwchaSvt8jJaFtNrTlEQBM4TfXYWg3um1v6ODVEcIAHbZZmxMiwf9gvMic0jKyx5mdnTg40GNakWAjOy4MMyNVoWGZEMnrT5sAPc1GyTGRaDr/miM5hTgbUP5rfIzAMvVtZyfFdh0A+n4e5I+yeLE0tKxVOumNCmWhmQ/xZzEuqiKCRbHdyWqhIa4mnwq1bNqyPvGfMIkNUF5QaOOkQxJN836aOtOBnXwrZvjvu2grGV0/sv2py93qfJs3LOUNqD/MaULvY8buv7y8K9MtVPaNGatAM82jS5PxpX5wQutD8SrklWheUoTQAXWlV5XfQMG/XDu81csebrbTsKJZHAjvjDbAZrCv609FmtxxfhJH6MUEEAiwrzZu73IpFFLJVywjFlFLBIsbPgifwFK1o5wfCiSd5sa8dGS5pHXBkiIvhjM/SJkbmMQlBdxO6VhmYPuzA1XWlv1WwiIMzxzXmiwH7Hi19uka2dtzfY7/0wHSB/3SS0q136R5klwdDM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39830400003)(136003)(396003)(346002)(451199021)(54906003)(478600001)(8936002)(41300700001)(8676002)(4326008)(66946007)(6916009)(66556008)(66476007)(316002)(38100700002)(2616005)(186003)(83380400001)(6486002)(6666004)(5660300002)(6512007)(6506007)(86362001)(7416002)(44832011)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G0xHW0KRTCiIxjSaLfWzOEs6iSBfpialVW3d7T0kGbwlE1ZAkuwXKBhCqKVD?=
 =?us-ascii?Q?KzGPoDwcYIkdcWCo4eaYTY9XcdVhhTcaECuOpWhihElXTETKBKxoeIIPAe9k?=
 =?us-ascii?Q?cGZ4vE3tQbwJqv16KTqqIwMrfvvapIGV+Q8z02067RdVWp93722Lz5Z0hBC6?=
 =?us-ascii?Q?kehBt2x9Due8P7dBmpAlvptw8PGJDH9dmn5noWqID9/pyyeaEuY8YXVlE5+a?=
 =?us-ascii?Q?6AXPeAEs1fveVcyJL/QCpfj4Uk03xBdESb+aZZpAjG0o8d8hozMGFz271ede?=
 =?us-ascii?Q?CxY+D3cKqzU0Fn6ZizAKepVaZd8vcWwNO8uSwAuNGLezpsxFveoa8WOHpNyf?=
 =?us-ascii?Q?PSkpw3sar10L7BYo/vR8ZNevcb8HxYmdsc/dbNkUoAC9VjEk7WiKW4EmlTy4?=
 =?us-ascii?Q?g++3gsUPJ/VBe2ltBdWkwdGERHJp/nAjym7t2MJF4FiT3vDHhv4YkuBivm0X?=
 =?us-ascii?Q?iK1rUoowy37+jLczYbuBfe6vRgZLcNx3QGUJ5XU5vg68sTxcrkV5ObFHNCpC?=
 =?us-ascii?Q?PPgjMeakbDS64/Y0yq1veslgQvsBIyTzyDfKh9pdnj2GFyhPkguoZ1MqtShz?=
 =?us-ascii?Q?pBvUVmvnG0H5KOM4q3fUk2u7qHxrrV84Ssh3fUjjq+nKAuYhlW+x4OmemSen?=
 =?us-ascii?Q?zRk1V1aoPIhXk/29Pfjav0SmFg74eyYY0tfY/IqYLBk/x66qK/cjYJJKkdM/?=
 =?us-ascii?Q?+sxYJJhuY93zEYHiZpKvf4c9n5MoRcqS7LJ2X7JmUXDJaGuktm6yHZKbppXZ?=
 =?us-ascii?Q?4tuw61GvZoQy2vKKWbYofVrse4c64kDlyxM9+Xv/2rpDxL2f7FI1SDRidWbM?=
 =?us-ascii?Q?5VmaO6d+38eQUoaWJWOd9l5cq0yJFZCPno5Z9mRYUJxYS4ebS0ljGAZit2xU?=
 =?us-ascii?Q?zAQgZWK7VrKxMyNwrK/3uvlfgcQ8Re6tJMe+QSbCYaLlsWlaAX58BRkXGXoo?=
 =?us-ascii?Q?caxZwlJqqxR5RPtfj8LJHm86zATvgeS1mLTPnmuiJLqwNz9me7gpoDQACxgG?=
 =?us-ascii?Q?HOFO4kMsGXqco4ydw2JRm19fuw1axRbT9GJY8BnopaItEfDq8bOGfag/yf/7?=
 =?us-ascii?Q?FE0N4rPV24vEl3xeSBRHvK+K4ReVrcFUMHyRvWBS2HeHmpJxv1Hd6YvOPB3S?=
 =?us-ascii?Q?IG8K263Uz2CgqxO2ydSxp29opMo4D+1BDv4XOaC1s/t+ZMIKR4ABEeM76yT/?=
 =?us-ascii?Q?eWCx/e1z7gTXWZjDR239bLOdZv92lcG0GVr6skVTFFMA/MmSYXhA1ZYWP7r3?=
 =?us-ascii?Q?EUn0BFYNAcI5yEw8X3Wk9F39XwFGO8Smy9gf60zAeyvllPoVqCF7sx/h4DM7?=
 =?us-ascii?Q?EjcSS0qcgp0Q6lt2CQneJ8xffne4Pf+rthNXGtyVT4GbjR4IO37bl1CtDZMZ?=
 =?us-ascii?Q?V/T42OxjdHhkQDAjIDZ5LZAAe8UdrQShJx5iUCWn46Q9rFHmguGhuQ8C8DpM?=
 =?us-ascii?Q?SdT0WpyPTv/QUtw8x3IxaNrKkUiiXyluLghtTXE4BSjF6oqAtLnBEpfWZUtU?=
 =?us-ascii?Q?EDFArKcaPGCOTXOwpCJ98KhGLmysb+H9MPafL2pyWKpFxPwgKPE0M7nhvPXZ?=
 =?us-ascii?Q?V7ViySxs2FxATzUSBszd14j92xKNFhI04s0oeLMTtl62MP4Sgj+yVs6aHXyy?=
 =?us-ascii?Q?fpUAEPUBMh9kW8YJrbCx02crFo06kxx8hszue222N2+RPIZ+B/L3bUXGTucb?=
 =?us-ascii?Q?TSu1EA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4288241b-0956-4afc-577a-08db6ce762d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 14:55:25.6906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwW4Bo2jFWOGddNrnCzEuhpJtK/Pnot19Im6DQ4ZvZfQ1rpd89IgoNe7KPjwssFKC/+XTU8U5SA3HKL52R61baaSGdIhbUvaKIyR8nxsHbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5260
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 09:32:41AM +0200, Christian Marangi wrote:
> Fix a possible memory leak in __stmmac_open when stmmac_init_phy fails.
> It's also needed to free everything allocated by stmmac_setup_dma_desc
> and not just the dma_conf struct.
> 
> Correctly call free_dma_desc_resources on the new dma_conf passed to
> __stmmac_open on error.
> 
> Reported-by: Jose Abreu <Jose.Abreu@synopsys.com>
> Fixes: ba39b344e924 ("net: ethernet: stmicro: stmmac: generate stmmac dma conf before open")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index fa07b0d50b46..0966ab86fde2 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -3877,10 +3877,10 @@ static int __stmmac_open(struct net_device *dev,
>  
>  	stmmac_hw_teardown(dev);
>  init_error:
> -	free_dma_desc_resources(priv, &priv->dma_conf);
>  	phylink_disconnect_phy(priv->phylink);
>  init_phy_error:
>  	pm_runtime_put(priv->device);
> +	free_dma_desc_resources(priv, dma_conf);

Hi Christian,

Are these resources allocated by the caller?
If so, perhaps it would be clearer if a symmetric approach
was taken and the caller handled freeing them on error.

>  	return ret;
>  }
>  
> -- 
> 2.40.1
> 
> 

